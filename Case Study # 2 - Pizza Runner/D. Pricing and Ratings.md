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
             length(replace(extras, ", ", "")) AS topping_count
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

``` 
	
#### Result set:

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

``` 
	
#### Result set:

***

###  5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?

```sql

``` 
	
#### Result set:

***



