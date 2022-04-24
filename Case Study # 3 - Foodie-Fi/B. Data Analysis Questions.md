# :avocado: Case Study #3: Foodie-Fi - Data Analysis Questions

## Case Study Questions
1. How many customers has Foodie-Fi ever had?
2. What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value
3. What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name
4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
5. How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?
6. What is the number and percentage of customer plans after their initial free trial?
7. What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?
8. How many customers have upgraded to an annual plan in 2020?
9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?
10. Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)
11. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?

***

###  1. How many customers has Foodie-Fi ever had?

```sql
SELECT count(DISTINCT customer_id) AS 'distinct customers'
FROM subscriptions;
``` 
	
#### Result set:
![image](https://user-images.githubusercontent.com/77529445/164981170-9edf1b3e-b27b-43b5-90c1-c6ff74463e73.png)

***

###  2. What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value

```sql
SELECT month(start_date),
       count(DISTINCT customer_id) as 'monthly distribution'
FROM subscriptions
JOIN plans USING (plan_id)
WHERE plan_id=0
GROUP BY month(start_date);
``` 
	
#### Result set:
![image](https://user-images.githubusercontent.com/77529445/164981204-63098eac-ed95-4c63-8f26-3f91a8495abc.png)

***

###  3. What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name

```sql
SELECT plan_id,
       plan_name,
       count(*) AS 'count of events'
FROM subscriptions
JOIN plans USING (plan_id)
WHERE year(start_date) > 2020
GROUP BY plan_id;
``` 
	
#### Result set:
![image](https://user-images.githubusercontent.com/77529445/164981223-da4b6e28-636c-4bde-92bc-aab821d8a17f.png)

***

###  4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?

```sql
SELECT plan_name, count(DISTINCT customer_id) as 'churned customers',
       round(100 *count(DISTINCT customer_id) / (
       SELECT count(DISTINCT customer_id) AS 'distinct customers'
FROM subscriptions
       ),2) as 'churn percentage'
FROM subscriptions
JOIN plans USING (plan_id)
where plan_id=4;
``` 
	
#### Result set:
![image](https://user-images.githubusercontent.com/77529445/164981238-e545644e-bf0e-4a07-80e7-74b502f1e5ef.png)

```sql
WITH counts_cte AS
  (SELECT plan_name,
          count(DISTINCT customer_id) AS distinct_customer_count,
          SUM(CASE
                  WHEN plan_id=4 THEN 1
                  ELSE 0
              END) AS churned_customer_count
   FROM subscriptions
   JOIN plans USING (plan_id))
SELECT *,
       round(100*(churned_customer_count/distinct_customer_count), 2) AS churn_percentage
FROM counts_cte;
``` 
	
#### Result set:
![image](https://user-images.githubusercontent.com/77529445/164981288-a4f71aaf-148d-406b-b5a4-c1658dddef25.png)

***

###  5. How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?

```sql
WITH next_plan_cte AS
  (SELECT *,
          lead(plan_id, 1) over(PARTITION BY customer_id
                                ORDER BY start_date) AS next_plan
   FROM subscriptions),
     churners AS
  (SELECT *
   FROM next_plan_cte
   WHERE next_plan=4
     AND plan_id=0)
SELECT count(customer_id) AS 'churn after trial count',
       round(100 *count(customer_id)/
               (SELECT count(DISTINCT customer_id) AS 'distinct customers'
                FROM subscriptions), 2) AS 'churn percentage'
FROM churners;
``` 
	
#### Result set:
![image](https://user-images.githubusercontent.com/77529445/164981310-3c79a54d-8333-486b-9826-d4e27126009c.png)

***

###  6. What is the number and percentage of customer plans after their initial free trial?

```sql
SELECT plan_name,
       count(customer_id) customer_count,
       round(100 *count(DISTINCT customer_id) /
               (SELECT count(DISTINCT customer_id) AS 'distinct customers'
                FROM subscriptions), 2) AS 'customer percentage'
FROM subscriptions
JOIN plans USING (plan_id)
WHERE plan_name != 'trial'
GROUP BY plan_name
ORDER BY plan_id;
``` 
	
#### Result set:
![image](https://user-images.githubusercontent.com/77529445/164981328-0e9c6cf3-9d6e-4757-9e96-b296fff504a6.png)

***

###  7. What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?

```sql

``` 
	
#### Result set:

***

###  8. How many customers have upgraded to an annual plan in 2020?

```sql
SELECT plan_id,
       COUNT(DISTINCT customer_id) AS annual_plan_customer_count
FROM foodie_fi.subscriptions
WHERE plan_id = 3
  AND year(start_date) = 2020;
``` 
	
#### Result set:
![image](https://user-images.githubusercontent.com/77529445/164986297-31c4e3f7-3d85-47da-8dc3-92c8182fce26.png)

***

###  9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?

```sql

``` 
	
#### Result set:

***

###  10. Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)

```sql

``` 
	
#### Result set:

***

###  11. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?

```sql

``` 
	
#### Result set:

***
