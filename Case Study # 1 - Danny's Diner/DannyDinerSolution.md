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
                            ORDER BY s.order_date) AS rank
   FROM dannys_diner.sales AS s
   JOIN dannys_diner.menu AS m ON s.product_id = m.product_id)
SELECT customer_id,
       product_name
FROM order_info_cte
WHERE rank = 1
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
                            ORDER BY s.order_date DESC) AS first_item
   FROM dannys_diner.menu AS m
   INNER JOIN dannys_diner.sales AS s ON m.product_id = s.product_id
   INNER JOIN dannys_diner.members AS mem ON mem.customer_id = s.customer_id
   WHERE order_date < join_date )
SELECT customer_id,
       product_name,
       order_date,
       join_date
FROM diner_info
WHERE first_item=1;
``` 
	
#### Result set:
| customer_id | product_name | order_date               | join_date                |
| ----------- | ------------ | ------------------------ | ------------------------ |
| A           | sushi        | 2021-01-01T00:00:00.000Z | 2021-01-07T00:00:00.000Z |
| A           | curry        | 2021-01-01T00:00:00.000Z | 2021-01-07T00:00:00.000Z |
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

```sql
SELECT s.customer_id,
       SUM(price*20) AS customer_points
FROM dannys_diner.menu AS m
INNER JOIN dannys_diner.sales AS s ON m.product_id = s.product_id
INNER JOIN dannys_diner.members AS mem ON mem.customer_id = s.customer_id
WHERE order_date >= join_date
  AND order_date BETWEEN join_date AND join_date+7
GROUP BY s.customer_id
ORDER BY s.customer_id;
``` 
	
#### Result set:
| customer_id | customer_points |
| ----------- | --------------- |
| A           | 1020            |
| B           | 440             |

***




