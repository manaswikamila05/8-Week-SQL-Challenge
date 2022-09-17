## :shopping_cart: Case Study #5: Data Mart - Data Exploration

## Case Study Questions
1. What day of the week is used for each week_date value?
2. What range of week numbers are missing from the dataset?
3. How many total transactions were there for each year in the dataset?
4. What is the total sales for each region for each month?
5. What is the total count of transactions for each platform
6. What is the percentage of sales for Retail vs Shopify for each month?
7. What is the percentage of sales by demographic for each year in the dataset?
8. Which age_band and demographic values contribute the most to Retail sales?
9. Can we use the avg_transaction column to find the average transaction size for each year for Retail vs Shopify? If not - how would you calculate it instead?

***

###  1. What day of the week is used for each week_date value?

```sql
SELECT DISTINCT dayname(week_date) AS day_of_week
FROM clean_weekly_sales;
``` 
	
#### Result set:
![image](https://user-images.githubusercontent.com/77529445/190210286-867b6b69-e9b8-41a9-845f-ac659ae21766.png)

***

###  2. What range of week numbers are missing from the dataset? 
- To get the current value of default_week_format variable : SHOW VARIABLES LIKE 'default_week_format';

```sql
-- Range 0 to 52

SELECT DISTINCT week(week_date) AS week_number
FROM clean_weekly_sales
ORDER BY week(week_date) ASC;

-- Missing week numbers: Week 1 to 11 and week 36 to 52
``` 
	
#### Result set:
![image](https://user-images.githubusercontent.com/77529445/190210714-2f2acc7d-2ec8-4343-af85-df737dc5944b.png)

***

###  3. How many total transactions were there for each year in the dataset?

```sql
SELECT year(week_date) AS YEAR,
       sum(transactions) AS total_transactions
FROM clean_weekly_sales
GROUP BY year(week_date)
ORDER BY 1;
``` 
	
#### Result set:
![image](https://user-images.githubusercontent.com/77529445/190211018-64eff211-6485-46f1-9718-b0d71ed001b5.png)

***

###  4. What is the total sales for each region for each month?

```sql
SELECT region,
       month_number,
       monthname(week_date) as month_name,
       sum(sales) AS total_sales
FROM clean_weekly_sales
GROUP BY region,
         month_number
ORDER BY 1,
         2;
``` 
	
#### Result set:
![image](https://user-images.githubusercontent.com/77529445/190211522-6141322a-be42-4211-8fec-72ec02c9e6d7.png)

***

###  5. What is the total count of transactions for each platform 

```sql
SELECT platform,
       sum(transactions) AS transactions_count
FROM clean_weekly_sales
GROUP BY 1;
``` 
	
#### Result set:
![image](https://user-images.githubusercontent.com/77529445/190211704-dc469d8b-06e9-4a57-aaff-7c969352c2a4.png)

***

###  6. What is the percentage of sales for Retail vs Shopify for each month?

Using GROUP BY and WINDOW FUNCTION
```sql
WITH sales_contribution_cte AS
  (SELECT calendar_year,
          month_number,
          platform,
          sum(sales) AS sales_contribution
   FROM clean_weekly_sales
   GROUP BY 1,
            2,
            3
   ORDER BY 1,
            2),
     total_sales_cte AS
  (SELECT *,
          sum(sales_contribution) over(PARTITION BY calendar_year, month_number) AS total_sales
   FROM sales_contribution_cte)
SELECT calendar_year,
       month_number,
       ROUND(sales_contribution/total_sales*100, 2) AS retail_percent,
       100-ROUND(sales_contribution/total_sales*100, 2) AS shopify_percent
FROM total_sales_cte
WHERE platform = "Retail"
ORDER BY 1,
         2;
``` 

Using GROUP BY AND CASE statements
```sql
WITH sales_cte AS
  (SELECT calendar_year,
          month_number,
          SUM(CASE
                  WHEN platform="Retail" THEN sales
              END) AS retail_sales,
          SUM(CASE
                  WHEN platform="Shopify" THEN sales
              END) AS shopify_sales,
          sum(sales) AS total_sales
   FROM clean_weekly_sales
   GROUP BY 1,
            2
   ORDER BY 1,
            2)
SELECT calendar_year,
       month_number,
       ROUND(retail_sales/total_sales*100, 2) AS retail_percent,
       ROUND(shopify_sales/total_sales*100, 2) AS shopify_percent
FROM sales_cte;
``` 
	
#### Result set:
![image](https://user-images.githubusercontent.com/77529445/190578851-5544de41-08cc-401f-adf6-12304e2c78a4.png)


***

###  7. What is the percentage of sales by demographic for each year in the dataset?

```sql
WITH sales_contribution_cte AS
  (SELECT calendar_year,
          demographic,
          sum(sales) AS sales_contribution
   FROM clean_weekly_sales
   GROUP BY 1,
            2
   ORDER BY 1),
     total_sales_cte AS
  (SELECT *,
          sum(sales_contribution) over(PARTITION BY calendar_year) AS total_sales
   FROM sales_contribution_cte)
SELECT calendar_year,
       demographic,
       ROUND(100*sales_contribution/total_sales, 2) AS percent_sales_contribution
FROM total_sales_cte
GROUP BY 1,
         2;
``` 

#### Result set:
![image](https://user-images.githubusercontent.com/77529445/190579915-c6613674-730b-4611-9fdf-680a6dabc431.png)

```sql
WITH sales_cte AS
  (SELECT calendar_year,
          SUM(CASE
                  WHEN demographic="Couples" THEN sales
              END) AS couple_sales,
          SUM(CASE
                  WHEN demographic="Families" THEN sales
              END) AS family_sales,
          SUM(CASE
                  WHEN demographic="unknown" THEN sales
              END) AS unknown_sales,
          sum(sales) AS total_sales
   FROM clean_weekly_sales
   GROUP BY 1
   ORDER BY 1)
SELECT calendar_year,
       ROUND(couple_sales/total_sales*100, 2) AS couple_percent,
       ROUND(family_sales/total_sales*100, 2) AS family_percent,
       ROUND(unknown_sales/total_sales*100, 2) AS unknown_percent
FROM sales_cte;
``` 
#### Result set:
![image](https://user-images.githubusercontent.com/77529445/190579310-e5844171-9d75-46a9-b61f-eb14e32c69ca.png)


***

###  8. Which age_band and demographic values contribute the most to Retail sales?

```sql
SELECT age_band,
       demographic,
       ROUND(100*sum(sales)/
               (SELECT SUM(sales)
                FROM clean_weekly_sales
                WHERE platform="Retail"), 2) AS retail_sales_percentage
FROM clean_weekly_sales
WHERE platform="Retail"
GROUP BY 1,
         2
ORDER BY 3 DESC;
``` 
	
#### Result set:


***

###  9. Can we use the avg_transaction column to find the average transaction size for each year for Retail vs Shopify? If not - how would you calculate it instead?

Let's try this mathematically.
Consider average of (4,4,4,4,4,4) = (4*6)/6 = 4 and average(5) = 5
Average of averages = (4+5)/2 = 4.5
Average of all numbers = (24+5)/ = 4.1428

Hence, we can not use avg_transaction column to find the average transaction size for each year and sales platform, because the result will be incorrect if we calculate average of an average to calculate the average.

```sql
SELECT calendar_year,
       platform,
       ROUND(SUM(sales)/SUM(transactions), 2) AS correct_avg,
       ROUND(AVG(avg_transaction), 2) AS incorrect_avg
FROM clean_weekly_sales
GROUP BY 1,
         2
ORDER BY 1,
         2;
``` 
	
#### Result set:
![image](https://user-images.githubusercontent.com/77529445/190840979-c7e92b09-898d-43d5-a9f6-8f12394fabbe.png)


***
