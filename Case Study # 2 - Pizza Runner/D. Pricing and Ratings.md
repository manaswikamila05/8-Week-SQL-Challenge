# :pizza: Case Study #2: Pizza runner - Pricing and Ratings

## Case Study Questions

1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?
2. What if there was an additional $1 charge for any pizza extras? Add cheese is $1 extra
3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
4. Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
- customer_id
- order_id
- runner_id
- rating
- order_time
- pickup_time
- Time between order and pickup
- Delivery duration
- Average speed
- Total number of pizzas
5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?

***

###  1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?

```sql
SELECT CONCAT('$', SUM(CASE
                           WHEN pizza_id = 1 THEN 12
                           ELSE 10
                       END)) AS total_revenue
FROM customer_orders_temp
INNER JOIN pizza_names USING (pizza_id)
INNER JOIN runner_orders_temp USING (order_id)
WHERE cancellation IS NULL;
``` 
	
#### Result set:
![image](https://user-images.githubusercontent.com/77529445/168244471-aebb9ea3-8566-4c03-b624-e9ec164390cd.png)

***

###  2. What if there was an additional $1 charge for any pizza extras? Add cheese is $1 extra

```sql
SELECT CONCAT('$', topping_revenue+ pizza_revenue) AS total_revenue
FROM
  (SELECT SUM(CASE
                  WHEN pizza_id = 1 THEN 12
                  ELSE 10
              END) AS pizza_revenue,
          sum(topping_count) AS topping_revenue
   FROM
     (SELECT *,
             length(extras) - length(replace(extras, ",", ""))+1 AS topping_count
      FROM customer_orders_temp
      INNER JOIN pizza_names USING (pizza_id)
      INNER JOIN runner_orders_temp USING (order_id)
      WHERE cancellation IS NULL
      ORDER BY order_id)t1) t2;
``` 
	
#### Result set:
![image](https://user-images.githubusercontent.com/77529445/168244665-403dc3f1-2e65-4be5-8ed0-e799a08b9afd.png)

***

###  3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.

```sql
DROP TABLE IF EXISTS runner_rating;

CREATE TABLE runner_rating (order_id INTEGER, rating INTEGER, review VARCHAR(100)) ;

-- Order 6 and 9 were cancelled
INSERT INTO runner_rating
VALUES ('1', '1', 'Really bad service'),
       ('2', '1', NULL),
       ('3', '4', 'Took too long..."),
       ('4', '1','Runner was lost, delivered it AFTER an hour. Pizza arrived cold' ),
       ('5', '2', ''Good service'),
       ('7', '5', 'It was great, good service and fast'),
       ('8', '2', 'He tossed it on the doorstep, poor service'),
       ('10', '5', 'Delicious!, he delivered it sooner than expected too!');


SELECT *
FROM runner_rating;
``` 
	
#### Result set:
![image](https://user-images.githubusercontent.com/77529445/168270655-61394a42-5004-459d-b056-0fde6366a960.png)

***

###  4. Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
- customer_id
- order_id
- runner_id
- rating
- order_time
- pickup_time
- Time between order and pickup
- Delivery duration
- Average speed
- Total number of pizzas

```sql

SELECT customer_id,
       order_id,
       runner_id,
       rating,
       order_time,
       pickup_time,
       TIMESTAMPDIFF(MINUTE, order_time, pickup_time) pick_up_time,
       duration AS delivery_duration,
       round(distance*60/duration, 2) AS average_speed,
       count(pizza_id) AS total_pizza_count
FROM customer_orders_temp
INNER JOIN runner_orders_temp USING (order_id)
INNER JOIN runner_rating USING (order_id)
GROUP BY order_id ;
``` 
	
#### Result set:
![image](https://user-images.githubusercontent.com/77529445/168271015-d7feb5dd-be06-4677-8e1c-6426ef6bc34c.png)

***

###  5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?

```sql
SELECT concat('$', round(sum(pizza_cost-delivery_cost), 2)) AS pizza_runner_revenue
FROM
  (SELECT order_id,
          distance,
          sum(pizza_cost) AS pizza_cost,
          round(0.30*distance, 2) AS delivery_cost
   FROM
     (SELECT *,
             (CASE
                  WHEN pizza_id = 1 THEN 12
                  ELSE 10
              END) AS pizza_cost
      FROM customer_orders_temp
      INNER JOIN pizza_names USING (pizza_id)
      INNER JOIN runner_orders_temp USING (order_id)
      WHERE cancellation IS NULL
      ORDER BY order_id) t1
   GROUP BY order_id
   ORDER BY order_id) t2;
``` 
	
#### Result set:
![image](https://user-images.githubusercontent.com/77529445/168251618-a7c97f22-9c0e-43d1-a4ec-1ea69e610c3d.png)

***

Click [here](https://github.com/manaswikamila05/8-Week-SQL-Challenge/blob/main/Case%20Study%20%23%202%20-%20Pizza%20Runner/E.%20Bonus%20Questions.md) to view the solution of E. Bonus Questions!

Click [here](https://github.com/manaswikamila05/8-Week-SQL-Challenge) to move back to the 8-Week-SQL-Challenge repository!

