# :ramen: :curry: :sushi: Case Study #1: Danny's Diner

## Case Study Questions

1. What is the total amount each customer spent at the restaurant?
2. How many days has each customer visited the restaurant?
3. What was the first item from the menu purchased by each customer?
4. What is the most purchased item on the menu and how many times was it purchased by all customers?
5. Which item was the most popular for each customer?
6. Which item was purchased first by the customer after they became a member?
7. Which item was purchased just before the customer became a member?
10. What is the total items and amount spent for each member before they became a member?
11. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
12. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
***

###  1. What is the total amount each customer spent at the restaurant?

```sql
SELECT customer_id,
       CONCAT('$', sum(price)) AS total_sales
FROM dannys_diner.menu
INNER JOIN dannys_diner.sales ON menu.product_id = sales.product_id
GROUP BY customer_id
ORDER BY customer_id;
``` 
	
#### Result set:
| customer_id | total_sales |
| ----------- | ----------- |
| A           | $76         |
| B           | $74         |
| C           | $36         |

***

###  2. How many days has each customer visited the restaurant?

```sql
SELECT customer_id,
       count(DISTINCT order_date) AS visit_count
FROM dannys_diner.sales
GROUP BY customer_id
ORDER BY customer_id;
``` 
	
#### Result set:
| customer_id | visit_count |
| ----------- | ----------- |
| A           | 4           |
| B           | 6           |
| C           | 2           |

***

###  3. What was the first item from the menu purchased by each customer?

```sql
WITH order_info_cte AS
  (SELECT customer_id,
          order_date,
          product_name,
          DENSE_RANK() OVER(PARTITION BY s.customer_id
                            ORDER BY s.order_date) AS rank_num
   FROM dannys_diner.sales AS s
   JOIN dannys_diner.menu AS m ON s.product_id = m.product_id)
SELECT customer_id,
       product_name
FROM order_info_cte
WHERE rank_num = 1
GROUP BY customer_id,
         product_name;
``` 
	
#### Result set:
| customer_id | product_name |
| ----------- | ------------ |
| A           | curry        |
| A           | sushi        |
| B           | curry        |
| C           | ramen        |

```sql
WITH order_info_cte AS
  (SELECT customer_id,
          order_date,
          product_name,
          DENSE_RANK() OVER(PARTITION BY s.customer_id
                            ORDER BY s.order_date) AS rank_num
   FROM dannys_diner.sales AS s
   JOIN dannys_diner.menu AS m ON s.product_id = m.product_id)
  SELECT customer_id,
          GROUP_CONCAT(DISTINCT product_name
                    ORDER BY product_name) AS product_name
   FROM order_info_cte
   WHERE rank_num = 1
   GROUP BY customer_id
;
``` 
	
#### Result set:
![image](https://user-images.githubusercontent.com/77529445/165887304-a1e2e494-a611-43b0-af50-3674d2133f09.png)

***

###  4. What is the most purchased item on the menu and how many times was it purchased by all customers?

```sql
SELECT product_name AS most_purchased_item,
       count(sales.product_id) AS order_count
FROM dannys_diner.menu
INNER JOIN dannys_diner.sales ON menu.product_id = sales.product_id
GROUP BY product_name
ORDER BY order_count DESC
LIMIT 1;
``` 
	
#### Result set:
| most_purchased_item | order_count |
| ------------------- | ----------- |
| ramen               | 8           |

```sql
SELECT most_purchased_item,
       max(order_count) AS order_count
FROM
  (SELECT product_name AS most_purchased_item,
          count(sales.product_id) AS order_count
   FROM dannys_diner.menu
   INNER JOIN dannys_diner.sales ON menu.product_id = sales.product_id
   GROUP BY product_name
   ORDER BY order_count DESC) max_purchased_item;
``` 
	
#### Result set:
![image](https://user-images.githubusercontent.com/77529445/165887623-4abffa33-c5d1-4e20-b8a8-8cd0d8c16e7a.png)

***

###  5. Which item was the most popular for each customer?

```sql
WITH order_info AS
  (SELECT product_name,
          customer_id,
          count(product_name) AS order_count,
          rank() over(PARTITION BY customer_id
                      ORDER BY count(product_name) DESC) AS rank_num
   FROM dannys_diner.menu
   INNER JOIN dannys_diner.sales ON menu.product_id = sales.product_id
   GROUP BY customer_id,
            product_name)
SELECT customer_id,
       product_name,
       order_count
FROM order_info
WHERE rank_num =1;
``` 
	
#### Result set:
| customer_id | product_name | order_count |
| ----------- | ------------ | ----------- |
| A           | ramen        | 3           |
| B           | ramen        | 2           |
| B           | curry        | 2           |
| B           | sushi        | 2           |
| C           | ramen        | 3           |

```sql
WITH order_info AS
  (SELECT product_name,
          customer_id,
          count(product_name) AS order_count,
          rank() over(PARTITION BY customer_id
                      ORDER BY count(product_name) DESC) AS rank_num
   FROM dannys_diner.menu
   INNER JOIN dannys_diner.sales ON menu.product_id = sales.product_id
   GROUP BY customer_id,
            product_name)
SELECT customer_id,
       GROUP_CONCAT(DISTINCT product_name
                    ORDER BY product_name) AS product_name,
       order_count
FROM order_info
WHERE rank_num =1
GROUP BY customer_id;
``` 
	
#### Result set:
![image](https://user-images.githubusercontent.com/77529445/165887834-471f46c0-2520-4b83-88d9-d91310ceb87c.png)

***

###  6. Which item was purchased first by the customer after they became a member?

```sql
WITH diner_info AS
  (SELECT product_name,
          s.customer_id,
          order_date,
          join_date,
          m.product_id,
          DENSE_RANK() OVER(PARTITION BY s.customer_id
                            ORDER BY s.order_date) AS first_item
   FROM dannys_diner.menu AS m
   INNER JOIN dannys_diner.sales AS s ON m.product_id = s.product_id
   INNER JOIN dannys_diner.members AS mem ON mem.customer_id = s.customer_id
   WHERE order_date >= join_date )
SELECT customer_id,
       product_name,
       order_date
FROM diner_info
WHERE first_item=1;
``` 
	
#### Result set:
| customer_id | product_name | order_date               |
| ----------- | ------------ | ------------------------ |
| A           | curry        | 2021-01-07T00:00:00.000Z |
| B           | sushi        | 2021-01-11T00:00:00.000Z |

***

###  7. Which item was purchased just before the customer became a member?

```sql
WITH diner_info AS
  (SELECT product_name,
          s.customer_id,
          order_date,
          join_date,
          m.product_id,
          DENSE_RANK() OVER(PARTITION BY s.customer_id
                            ORDER BY s.order_date DESC) AS item_rank
   FROM dannys_diner.menu AS m
   INNER JOIN dannys_diner.sales AS s ON m.product_id = s.product_id
   INNER JOIN dannys_diner.members AS mem ON mem.customer_id = s.customer_id
   WHERE order_date < join_date )
SELECT customer_id,
       GROUP_CONCAT(DISTINCT product_name
                    ORDER BY product_name) AS product_name,
       order_date,
       join_date
FROM diner_info
WHERE item_rank=1
GROUP BY customer_id;
``` 
	
#### Result set:
| customer_id | product_name | order_date               | join_date                |
| ----------- | ------------ | ------------------------ | ------------------------ |
| A           | curry,sushi  | 2021-01-01T00:00:00.000Z | 2021-01-07T00:00:00.000Z |
| B           | sushi        | 2021-01-04T00:00:00.000Z | 2021-01-09T00:00:00.000Z |

***

###  8. What is the total items and amount spent for each member before they became a member?

```sql
SELECT s.customer_id,
       count(product_name) AS total_items,
       CONCAT('$', SUM(price)) AS amount_spent
FROM dannys_diner.menu AS m
INNER JOIN dannys_diner.sales AS s ON m.product_id = s.product_id
INNER JOIN dannys_diner.members AS mem ON mem.customer_id = s.customer_id
WHERE order_date < join_date
GROUP BY s.customer_id
ORDER BY customer_id;
``` 
	
#### Result set:
| customer_id | total_items | amount_spent |
| ----------- | ----------- | ------------ |
| A           | 2           | $25          |
| B           | 3           | $40          |

***

###  9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

#### Had the customer joined the loyalty program before making the purchases, total points that each customer would have accrued
```sql
SELECT customer_id,
       SUM(CASE
               WHEN product_name = 'sushi' THEN price*20
               ELSE price*10
           END) AS customer_points
FROM dannys_diner.menu AS m
INNER JOIN dannys_diner.sales AS s ON m.product_id = s.product_id
GROUP BY customer_id
ORDER BY customer_id;
``` 
	
#### Result set:
| customer_id | customer_points |
| ----------- | --------------- |
| A           | 860             |
| B           | 940             |
| C           | 360             |

#### Total points that each customer has accrued after taking a membership
```sql
SELECT s.customer_id,
       SUM(CASE
               WHEN product_name = 'sushi' THEN price*20
               ELSE price*10
           END) AS customer_points
FROM dannys_diner.menu AS m
INNER JOIN dannys_diner.sales AS s ON m.product_id = s.product_id
INNER JOIN dannys_diner.members AS mem ON mem.customer_id = s.customer_id
WHERE order_date >= join_date
GROUP BY s.customer_id
ORDER BY s.customer_id;
``` 
	
#### Result set:
| customer_id | customer_points |
| ----------- | --------------- |
| A           | 510             |
| B           | 440             |

***

###  10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January

#### Steps
1. Find the program_last_date which is 7 days after a customer joins the program (including their join date)
2. Determine the customer points for each transaction and for members with a membership
- During the first week of the membership -> points = price*20 irrespective of the purchase item
- Product = Sushi -> and order_date is not within a week of membership -> points = price*20
- Product = Not Sushi -> and order_date is not within a week of membership -> points = price*10
3. Conditions in WHERE clause
- order_date <= '2021-01-31' -> Order must be placed before 31st January 2021
- order_date >= join_date -> Points awarded to only customers with a membership

```sql
WITH program_last_day_cte AS
  (SELECT join_date,
          DATE_ADD(join_date, INTERVAL 6 DAY) AS program_last_date,
          customer_id
   FROM dannys_diner.members)
SELECT s.customer_id,
       SUM(CASE
               WHEN order_date BETWEEN join_date AND program_last_date THEN price*10*2
               WHEN order_date NOT BETWEEN join_date AND program_last_date
                    AND product_name = 'sushi' THEN price*10*2
               WHEN order_date NOT BETWEEN join_date AND program_last_date
                    AND product_name != 'sushi' THEN price*10
           END) AS customer_points
FROM dannys_diner.menu AS m
INNER JOIN dannys_diner.sales AS s ON m.product_id = s.product_id
INNER JOIN program_last_day_cte AS mem ON mem.customer_id = s.customer_id
AND order_date <='2021-01-31'
AND order_date >=join_date
GROUP BY s.customer_id
ORDER BY s.customer_id;
``` 
```sql
SELECT s.customer_id,
       SUM(IF(order_date BETWEEN join_date AND DATE_ADD(join_date, INTERVAL 6 DAY), price*10*2, IF(product_name = 'sushi', price*10*2, price*10))) AS customer_points
FROM dannys_diner.menu AS m
INNER JOIN dannys_diner.sales AS s ON m.product_id = s.product_id
INNER JOIN dannys_diner.members AS mem USING (customer_id)
WHERE order_date <='2021-01-31'
  AND order_date >=join_date
GROUP BY s.customer_id
ORDER BY s.customer_id;
``` 

#### Result set:
| customer_id | customer_points |
| ----------- | --------------- |
| A           | 1020            |
| B           | 320             |

***

###  Bonus Questions

#### Join All The Things
Create basic data tables that Danny and his team can use to quickly derive insights without needing to join the underlying tables using SQL. Fill Member column as 'N' if the purchase was made before becoming a member and 'Y' if the after is amde after joining the membership.

```sql
SELECT customer_id,
       order_date,
       product_name,
       price,
       IF(order_date >= join_date, 'Y', 'N') AS member
FROM members
RIGHT JOIN sales USING (customer_id)
INNER JOIN menu USING (product_id)
ORDER BY customer_id,
         order_date;
``` 
	
#### Result set:
![image](https://user-images.githubusercontent.com/77529445/167406964-25276db9-fe1c-4608-8b77-b0970b156888.png)

***

#### Rank All The Things
Danny also requires further information about the ranking of customer products, but he purposely does not need the ranking for non-member purchases so he expects null ranking values for the records when customers are not yet part of the loyalty program.

```sql
SELECT customer_id,
       order_date,
       product_name,
       price,
       IF(order_date >= join_date, 'Y', 'N') AS member
FROM members
RIGHT JOIN sales USING (customer_id)
INNER JOIN menu USING (product_id)
ORDER BY customer_id,
         order_date;
``` 
```sql
WITH data_table AS
  (SELECT customer_id,
          order_date,
          product_name,
          price,
          IF(order_date >= join_date, 'Y', 'N') AS member
   FROM members
   RIGHT JOIN sales USING (customer_id)
   INNER JOIN menu USING (product_id)
   ORDER BY customer_id,
            order_date)
SELECT *,
       IF(member='N', NULL, DENSE_RANK() OVER (PARTITION BY customer_id, member
                                               ORDER BY order_date)) AS ranking
FROM data_table;
```

#### Result set:
![image](https://user-images.githubusercontent.com/77529445/167407504-41d02dd0-0bd1-4a3c-8f41-00ae07daefad.png)


***


Click [here](https://github.com/manaswikamila05/8-Week-SQL-Challenge) to move back to the 8-Week-SQL-Challenge repository!


