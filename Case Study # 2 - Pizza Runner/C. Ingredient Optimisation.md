# :pizza: Case Study #2: Pizza runner - Ingredient Optimisation WIP

## Case Study Questions

1. What are the standard ingredients for each pizza?
2. What was the most commonly added extra?
3. What was the most common exclusion?
4. Generate an order item for each record in the customers_orders table in the format of one of the following:
- Meat Lovers
- Meat Lovers - Exclude Beef
- Meat Lovers - Extra Bacon
- Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
5. Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
- For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"
6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?

***

## Temporary tables created to solve the below queries

```sql
DROP TABLE row_split_customer_orders_temp;

CREATE
TEMPORARY TABLE row_split_customer_orders_temp AS
SELECT t.row_num,
       t.order_id,
       t.customer_id,
       t.pizza_id,
       trim(j1.exclusions) AS exclusions,
       trim(j2.extras) AS extras,
       t.order_time
FROM
  (SELECT *,
          row_number() over() AS row_num
   FROM customer_orders_temp) t
INNER JOIN json_table(trim(replace(json_array(t.exclusions), ',', '","')),
                      '$[*]' columns (exclusions varchar(50) PATH '$')) j1
INNER JOIN json_table(trim(replace(json_array(t.extras), ',', '","')),
                      '$[*]' columns (extras varchar(50) PATH '$')) j2 ;


SELECT *
FROM row_split_customer_orders_temp;
``` 
![image](https://user-images.githubusercontent.com/77529445/168322232-dfbf27e4-519c-413d-ad8d-1b110903f7ee.png)


```sql
DROP TABLE row_split_pizza_recipes_temp;

CREATE
TEMPORARY TABLE row_split_pizza_recipes_temp AS
SELECT t.pizza_id,
       trim(j.topping) AS topping_id
FROM pizza_recipes t
JOIN json_table(trim(replace(json_array(t.toppings), ',', '","')),
                '$[*]' columns (topping varchar(50) PATH '$')) j ;


SELECT *
FROM row_split_pizza_recipes_temp;
``` 
![image](https://user-images.githubusercontent.com/77529445/168322313-099d7901-7d46-4390-81f2-1d18605a5084.png)


```sql
DROP TABLE IF EXISTS standard_ingredients;

CREATE
TEMPORARY TABLE standard_ingredients AS
SELECT pizza_id,
       pizza_name,
       group_concat(DISTINCT topping_name) 'standard_ingredients'
FROM row_split_pizza_recipes_temp
INNER JOIN pizza_names USING (pizza_id)
INNER JOIN pizza_toppings USING (topping_id)
GROUP BY pizza_name
ORDER BY pizza_id;

SELECT *
FROM standard_ingredients;
``` 
![image](https://user-images.githubusercontent.com/77529445/168322650-34dee02f-573d-495e-a75f-eeec2c295d21.png)


```sql

``` 


###  1. What are the standard ingredients for each pizza?

```sql
SELECT *
FROM standard_ingredients;
``` 
	
#### Result set:
![image](https://user-images.githubusercontent.com/77529445/167685439-27c169a5-dd82-4b60-bc4a-82f73f694b3a.png)

***

###  2. What was the most commonly added extra?

```sql
WITH extra_count_cte AS
  (SELECT trim(extras) AS extra_topping,
          count(*) AS purchase_counts
   FROM row_split_customer_orders_temp
   WHERE extras IS NOT NULL
   GROUP BY extras)
SELECT topping_name,
       purchase_counts
FROM extra_count_cte
INNER JOIN pizza_toppings ON extra_count_cte.extra_topping = pizza_toppings.topping_id
LIMIT 1;
``` 
	
#### Result set:
![image](https://user-images.githubusercontent.com/77529445/167685675-148a98ac-ea68-4978-8536-91ff5425f505.png)

***

###  3. What was the most common exclusion?

```sql
WITH extra_count_cte AS
  (SELECT trim(exclusions) AS extra_topping,
          count(*) AS purchase_counts
   FROM row_split_customer_orders_temp
   WHERE exclusions IS NOT NULL
   GROUP BY exclusions)
SELECT topping_name,
       purchase_counts
FROM extra_count_cte
INNER JOIN pizza_toppings ON extra_count_cte.extra_topping = pizza_toppings.topping_id
LIMIT 1;
``` 
	
#### Result set:
![image](https://user-images.githubusercontent.com/77529445/167685795-8a0ae1c6-0447-4e1f-aa84-70c68407549b.png)

***

###  4. Generate an order item for each record in the customers_orders table in the format of one of the following:
- Meat Lovers
- Meat Lovers - Exclude Beef
- Meat Lovers - Extra Bacon
- Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers

```sql
WITH order_summary_cte AS
  (SELECT pizza_name,
          row_num,
          order_id,
          customer_id,
          excluded_topping,
          t2.topping_name AS extras_topping
   FROM
     (SELECT *,
             topping_name AS excluded_topping
      FROM row_split_customer_orders_temp
      LEFT JOIN standard_ingredients USING (pizza_id)
      LEFT JOIN pizza_toppings ON topping_id = exclusions) t1
   LEFT JOIN pizza_toppings t2 ON t2.topping_id = extras)
SELECT order_id,
       customer_id,
       CASE
           WHEN excluded_topping IS NULL
                AND extras_topping IS NULL THEN pizza_name
           WHEN extras_topping IS NULL
                AND excluded_topping IS NOT NULL THEN concat(pizza_name, ' - Exclude ', GROUP_CONCAT(DISTINCT excluded_topping))
           WHEN excluded_topping IS NULL
                AND extras_topping IS NOT NULL THEN concat(pizza_name, ' - Include ', GROUP_CONCAT(DISTINCT extras_topping))
           ELSE concat(pizza_name, ' - Include ', GROUP_CONCAT(DISTINCT extras_topping), ' - Exclude ', GROUP_CONCAT(DISTINCT excluded_topping))
       END AS order_item
FROM order_summary_cte
GROUP BY row_num;
``` 
	
#### Result set:
![image](https://user-images.githubusercontent.com/77529445/167685922-38e6d766-7159-401d-9ba9-361113965dc5.png)

***

###  5. Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
- For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"

```sql

``` 
	
#### Result set:

***

###  6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?

```sql

``` 
	
#### Result set:

***

Click [here](https://github.com/manaswikamila05/8-Week-SQL-Challenge/blob/main/Case%20Study%20%23%202%20-%20Pizza%20Runner/D.%20Pricing%20and%20Ratings.md) to view the  solution of D. Pricing and Ratings!
