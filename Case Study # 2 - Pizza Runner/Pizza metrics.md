# :pizza: Case Study #2: Pizza runner - Pizza Metrics

## Case Study Questions

1. How many pizzas were ordered?
2. How many unique customer orders were made?
3. How many successful orders were delivered by each runner?
4. How many of each type of pizza was delivered?
5. How many Vegetarian and Meatlovers were ordered by each customer?
6. What was the maximum number of pizzas delivered in a single order?
7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
8. How many pizzas were delivered that had both exclusions and extras?
9. What was the total volume of pizzas ordered for each hour of the day?
10. What was the volume of orders for each day of the week?

***

###  1. How many pizzas were ordered?

```sql
SELECT count(pizza_id) AS "Total Number Of Pizzas Ordered"
FROM pizza_runner.customer_orders;
``` 
	
#### Result set:
![image](https://user-images.githubusercontent.com/77529445/164606099-9ea969f1-928e-4bbd-90cd-5211aaed7e89.png)

***

###  2. How many unique customer orders were made?

```sql
SELECT 
  COUNT(DISTINCT order_id) AS 'Number Of Unique Orders'
FROM customer_orders_temp;
``` 
	
#### Result set:
![image](https://user-images.githubusercontent.com/77529445/164606186-2b5465ef-69df-4fbb-9a2d-cd50afd49c7a.png)

***

###  3. How many successful orders were delivered by each runner?

```sql
SELECT runner_id,
       count(order_id) AS 'Number Of Successful Orders'
FROM pizza_runner.runner_orders_temp
WHERE cancellation IS NULL
GROUP BY runner_id;
``` 
	
#### Result set:
![image](https://user-images.githubusercontent.com/77529445/164606290-b70ee6e3-ed23-417a-9e86-e8555d9e55c3.png)

***

###  4. How many of each type of pizza was delivered?

```sql

SELECT pizza_id,
       pizza_name,
       count(pizza_id) AS 'Number Of Pizzas Delivered'
FROM pizza_runner.runner_orders_temp
INNER JOIN customer_orders_temp USING (order_id)
INNER JOIN pizza_names USING (pizza_id)
WHERE cancellation IS NULL
GROUP BY pizza_id;
``` 
	
#### Result set:
![image](https://user-images.githubusercontent.com/77529445/164606389-9128a4e0-90e9-467b-a593-c18c62ca007e.png)

***

###  5. How many Vegetarian and Meatlovers were ordered by each customer?

```sql
SELECT customer_id,
       pizza_name,
       count(pizza_id) AS 'Number Of Pizzas Ordered'
FROM customer_orders_temp
INNER JOIN pizza_names USING (pizza_id)
GROUP BY customer_id,
         pizza_id
ORDER BY customer_id ;
``` 
	
#### Result set:
![image](https://user-images.githubusercontent.com/77529445/164606480-326c416f-a909-49e8-8bda-8055ee247fd1.png)

- The counts of the Meat lover and Vegetarian pizzas ordered by the customers is not discernible.

```sql
SELECT customer_id,
       SUM(CASE
               WHEN pizza_id = 1 THEN 1
               ELSE 0
           END) AS 'Meat lover Pizza Count',
       SUM(CASE
               WHEN pizza_id = 2 THEN 1
               ELSE 0
           END) AS 'Vegetarian Pizza Count'
FROM customer_orders_temp
GROUP BY customer_id
ORDER BY customer_id;
``` 
	
#### Result set:
![image](https://user-images.githubusercontent.com/77529445/164606848-8980ebb9-a8e5-4b2b-a612-b86b19f4df08.png)

***

###  

```sql

``` 
	
#### Result set:

***

###  

```sql

``` 
	
#### Result set:

***

###  

```sql

``` 
	
#### Result set:

***

###  

```sql

``` 
	
#### Result set:

***

###  

```sql

``` 
	
#### Result set:

***

###  

```sql

``` 
	
#### Result set:

***
