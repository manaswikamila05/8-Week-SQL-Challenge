----------------------------------
-- CASE STUDY #1: DANNY'S DINER --
----------------------------------

-- Author: Manaswi Kamila
-- Date: 18/04/2022 
-- Tool used: MySQL Server

--------------------------
-- CASE STUDY QUESTIONS --
--------------------------

-- 1. What is the total amount each customer spent at the restaurant?
SELECT customer_id,
       CONCAT('$', sum(price)) AS total_sales
FROM dannys_diner.menu
INNER JOIN dannys_diner.sales ON menu.product_id = sales.product_id
GROUP BY customer_id
ORDER BY customer_id;

-- 2. How many days has each customer visited the restaurant?
SELECT customer_id,
       count(DISTINCT order_date) AS visit_count
FROM dannys_diner.sales
GROUP BY customer_id
ORDER BY customer_id;

-- 3. What was the first item from the menu purchased by each customer?
-- order_date column is a date column does not include the purchase time details. 
-- Asssumption: Since the timestamp is missing, all items bought on the first day is considered as the first item(provided multiple items were purchased on the first day)
-- dense_rank() is used to rank all orders purchased on the same day 

-- Using CTE
WITH order_info_cte AS
  (SELECT customer_id,
          order_date,
          product_name,
          DENSE_RANK() OVER(PARTITION BY s.customer_id
                            ORDER BY s.order_date) AS item_rank
   FROM dannys_diner.sales AS s
   JOIN dannys_diner.menu AS m ON s.product_id = m.product_id)
SELECT customer_id,
       product_name
FROM order_info_cte
WHERE item_rank = 1
GROUP BY customer_id,
         product_name;

-- Using derived table
SELECT customer_id,
       product_name
FROM
  (SELECT customer_id,
          order_date,
          product_name,
          DENSE_RANK() OVER(PARTITION BY s.customer_id
                            ORDER BY s.order_date) AS item_rank
   FROM dannys_diner.sales AS s
   JOIN dannys_diner.menu AS m ON s.product_id = m.product_id) AS first_item
WHERE item_rank=1
GROUP BY customer_id,
         product_name;

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
-- Using LIMIT clause
SELECT product_name AS most_purchased_item,
       count(sales.product_id) AS order_count
FROM dannys_diner.menu
INNER JOIN dannys_diner.sales ON menu.product_id = sales.product_id
GROUP BY product_name
ORDER BY order_count DESC
LIMIT 1;

-- Using derived table
SELECT most_purchased_item,
       order_count
FROM
  (SELECT product_name AS most_purchased_item,
          count(sales.product_id) AS order_count,
          rank() over(
                      ORDER BY count(sales.product_id) DESC) AS order_rank
   FROM dannys_diner.menu
   INNER JOIN dannys_diner.sales ON menu.product_id = sales.product_id
   GROUP BY product_name) item_counts
WHERE order_rank=1;

-- 5. Which item was the most popular for each customer?
-- Asssumption: Products with the highest purchase counts are all considered to be popular for each customer

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

-- 6. Which item was purchased first by the customer after they became a member?
-- Asssumption: Since timestamp of purchase is not available, purchase made when order_date is the same or after the join date is used to find the first item

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

-- 7. Which item was purchased just before the customer became a member?
-- Asssumption: Since timestamp of purchase is not available, purchase made when order_date is before the join date is used to find the last item purchased just before the customer became a member

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
       product_name,
       order_date,
       join_date
FROM diner_info
WHERE item_rank=1;

-- 8. What is the total items and amount spent for each member before they became a member?
SELECT s.customer_id,
       count(product_name) AS total_items,
       CONCAT('$', SUM(price)) AS amount_spent
FROM dannys_diner.menu AS m
INNER JOIN dannys_diner.sales AS s ON m.product_id = s.product_id
INNER JOIN dannys_diner.members AS mem ON mem.customer_id = s.customer_id
WHERE order_date < join_date
GROUP BY s.customer_id
ORDER BY customer_id;

-- 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
-- Had the customer joined the loyalty program before making the purchases, total points that each customer would have accrued
SELECT customer_id,
       SUM(CASE
               WHEN product_name = 'sushi' THEN price*20
               ELSE price*10
           END) AS customer_points
FROM dannys_diner.menu AS m
INNER JOIN dannys_diner.sales AS s ON m.product_id = s.product_id
GROUP BY customer_id
ORDER BY customer_id;

-- Total points that each customer has accrued after taking a membership
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

-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - 
-- how many points do customer A and B have at the end of January
-- Asssumption: Points is rewarded only after the customer joins in the membership program

-- Steps
-- 1. Find the program_last_date which is 7 days after a customer joins the program (including their join date)
-- 2. Determine the customer points for each transaction and for members with a membership
-- 		a. During the first week of the membership -> points = price*20 irrespective of the purchase item
-- 		b. Product = Sushi -> and order_date is not within a week of membership -> points = price*20
-- 		c. Product = Not Sushi -> and order_date is not within a week of membership -> points = price*10
-- 3. Conditions in WHERE clause
-- 		a. order_date <= '2021-01-31' -> Order must be placed before 31st January 2021
-- 		b. order_date >= join_date -> Points awarded to only customers with a membership

WITH program_last_day_cte AS
  (SELECT join_date,
          DATE_ADD(join_date, INTERVAL 7 DAY) AS program_last_date,
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

