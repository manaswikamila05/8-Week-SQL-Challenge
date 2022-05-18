# :pizza: Case Study #2: Pizza runner - Runner and Customer Experience

## Case Study Questions

1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
4. What was the average distance travelled for each customer?
5. What was the difference between the longest and shortest delivery times for all orders?
6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
7. What is the successful delivery percentage for each runner?

***

###  1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
- Returned week number is between 0 and 52 or 0 and 53.
- Default mode of the week =0 -> First day of the week is Sunday
- Extract week -> WEEK(registration_date) or EXTRACT(week from registration_date)

```sql
SELECT week(registration_date) as 'Week of registration',
       count(runner_id) as 'Number of runners'
FROM pizza_runner.runners
GROUP BY 1;
``` 
	
#### Result set:
![image](https://user-images.githubusercontent.com/77529445/164647808-eb3031b8-e120-4e8d-bc7f-64fa512d4aac.png)

***

###  2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

```sql
SELECT runner_id,
       TIMESTAMPDIFF(MINUTE, order_time, pickup_time) AS runner_pickup_time,
       round(avg(TIMESTAMPDIFF(MINUTE, order_time, pickup_time)), 2) avg_runner_pickup_time
FROM runner_orders_temp
INNER JOIN customer_orders_temp USING (order_id)
WHERE cancellation IS NULL
GROUP BY runner_id;
``` 
	
#### Result set:
![image](https://user-images.githubusercontent.com/77529445/164702992-fbc50aa6-7e66-45c7-8e77-7e906a77e004.png)

***

###  3. Is there any relationship between the number of pizzas and how long the order takes to prepare?

```sql
WITH order_count_cte AS
  (SELECT order_id,
          COUNT(order_id) AS pizzas_order_count,
          TIMESTAMPDIFF(MINUTE, order_time, pickup_time) AS prep_time
   FROM runner_orders_temp
   INNER JOIN customer_orders_temp USING (order_id)
   WHERE cancellation IS NULL
   GROUP BY order_id)
SELECT pizzas_order_count,
       round(avg(prep_time), 2)
FROM order_count_cte
GROUP BY pizzas_order_count;
``` 
	
#### Result set:
![image](https://user-images.githubusercontent.com/77529445/164703063-bb11984c-6ff6-4464-953a-7d7b6c686946.png)

***

###  4. What was the average distance travelled for each customer?

```sql
SELECT customer_id,
       round(avg(distance), 2) AS 'average_distance_travelled'
FROM runner_orders_temp
INNER JOIN customer_orders_temp USING (order_id)
WHERE cancellation IS NULL
GROUP BY customer_id;
``` 
	
#### Result set:
![image](https://user-images.githubusercontent.com/77529445/164703130-5fcf4130-4da3-438d-bed5-ea1ac2eeeaaf.png)

***

###  5. What was the difference between the longest and shortest delivery times for all orders?

```sql
SELECT MIN(duration) minimum_duration,
       MAX(duration) AS maximum_duration,
       MAX(duration) - MIN(duration) AS maximum_difference
FROM runner_orders_temp;
``` 
	
#### Result set:
![image](https://user-images.githubusercontent.com/77529445/164703196-70c37c17-b217-45f2-ba3a-caace379475f.png)

***

###  6. What was the average speed for each runner for each delivery and do you notice any trend for these values?

```sql
SELECT runner_id,
       distance AS distance_km,
       round(duration/60, 2) AS duration_hr,
       round(distance*60/duration, 2) AS average_speed
FROM runner_orders_temp
WHERE cancellation IS NULL
ORDER BY runner_id;
``` 
	
#### Result set:
![image](https://user-images.githubusercontent.com/77529445/164703262-5d728ac2-3080-4015-a387-6f6afc63c82c.png)

***

###  7. What is the successful delivery percentage for each runner?

```sql
SELECT runner_id,
       COUNT(pickup_time) AS delivered_orders,
       COUNT(*) AS total_orders,
       ROUND(100 * COUNT(pickup_time) / COUNT(*)) AS delivery_success_percentage
FROM runner_orders_temp
GROUP BY runner_id
ORDER BY runner_id;
``` 
	
#### Result set:
![image](https://user-images.githubusercontent.com/77529445/164703324-de88203a-e673-498c-b775-8cae9523673d.png)

***

Click [here](https://github.com/manaswikamila05/8-Week-SQL-Challenge/blob/main/Case%20Study%20%23%202%20-%20Pizza%20Runner/C.%20Ingredient%20Optimisation.md) to view the  solution of C. Ingredient Optimisation!

