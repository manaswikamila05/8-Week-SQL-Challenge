# Data Cleaning

## customer_orders table
- The exclusions and extras columns in customer_orders table will need to be cleaned up before using them in the queries  
- In the exclusions and extras columns, there are blank spaces and null values.

```sql
DROP TABLE IF EXISTS customer_orders_temp;

CREATE TEMPORARY TABLE customer_orders_temp AS
SELECT order_id,
       customer_id,
       pizza_id,
       CASE
           WHEN exclusions = '' THEN NULL
           WHEN exclusions = 'null' THEN NULL
           ELSE exclusions
       END AS exclusions,
       CASE
           WHEN extras = '' THEN NULL
           WHEN extras = 'null' THEN NULL
           ELSE extras
       END AS extras,
       order_time
FROM customer_orders;

SELECT * FROM customer_orders_temp;
``` 
	
#### Result set:
![image](https://user-images.githubusercontent.com/77529445/164605662-f76ec84b-a934-4088-8cdc-70ee92c8ed66.png)


***

## runner_orders table
- The pickup_time, distance, duration and cancellation columns in runner_orders table will need to be cleaned up before using them in the queries  
- In the pickup_time column, there are null values.
- In the distance column, there are null values. It contains unit - km. The 'km' must also be stripped 
- In the duration column, there are null values. The 'minutes', 'mins' 'minute' must be stripped
- In the cancellation column, there are blank spaces and null values.

```sql
DROP TABLE IF EXISTS runner_orders_temp;

CREATE TEMPORARY TABLE runner_orders_temp AS

SELECT order_id,
       runner_id,
       CASE
           WHEN pickup_time LIKE 'null' THEN NULL
           ELSE pickup_time
       END AS pickup_time,
       CASE
           WHEN distance LIKE 'null' THEN NULL
           ELSE CAST(regexp_replace(distance, '[a-z]+', '') AS FLOAT)
       END AS distance,
       CASE
           WHEN duration LIKE 'null' THEN NULL
           ELSE CAST(regexp_replace(duration, '[a-z]+', '') AS FLOAT)
       END AS duration,
       CASE
           WHEN cancellation LIKE '' THEN NULL
           WHEN cancellation LIKE 'null' THEN NULL
           ELSE cancellation
       END AS cancellation
FROM runner_orders;

SELECT * FROM runner_orders_temp;
``` 
	
#### Result set:
![image](https://user-images.githubusercontent.com/77529445/164605747-0243ab4e-9652-4c88-ad92-960314a94e4d.png)


***
# Expanding the comma seperated string into rows

## pizza_recipes table

#### pizza_recipes table
- The toppings column in the pizza_recipes table is a comma separated string.

![image](https://user-images.githubusercontent.com/77529445/167378441-104c0fea-c7ed-4968-8a9a-e8aa0c8ae3f3.png)

### Method 1: Using a Procedure
- A temporary table is created by calling a procedure which stores the pizza id and the topping in a separate row by splitting the comma separated string into multiple rows.
- String functions are used to split the string

```sql
DROP TABLE IF EXISTS pizza_topping_temp;

CREATE
TEMPORARY TABLE pizza_topping_temp(pizza_id int, topping int);

DROP PROCEDURE IF EXISTS GetToppings;

DELIMITER $$
CREATE PROCEDURE GetToppings()
BEGIN
	DECLARE i INT DEFAULT 0;
    DECLARE j INT DEFAULT 0;
	DECLARE n INT DEFAULT 0;
    DECLARE x INT DEFAULT 0;
    DECLARE id  INT;
	DECLARE topping_in TEXT;
    DECLARE topping_out TEXT;

 	SET i = 0;
    SELECT COUNT(*) FROM pizza_recipes INTO n;

	WHILE i < n DO  -- Iterate per row
		SELECT pizza_id, toppings INTO id, topping_in FROM pizza_recipes LIMIT i,1 ; -- Select each row and store values in id, topping_in variables
		SET x = (CHAR_LENGTH(topping_in) - CHAR_LENGTH( REPLACE ( topping_in, ' ', '') ))+1; -- Find the number of toppings in the row

        SET j = 1;
		WHILE j <= x DO -- Iterate over each element in topping
			SET topping_out = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(topping_in, ',', j), ',', -1));
            -- SUBSTRING_INDEX(topping_in, ',', j -> Returns a substring from a string before j occurences of comma
            -- (SUBSTRING_INDEX(SUBSTRING_INDEX(topping_in, ',', j), ',', -1)) -> Returns the last topping from the substring found above, element at -1 index
			INSERT INTO pizza_topping_temp VALUES(id, topping_out);  -- Insert pizza_id and the topping into table pizza_info
			SET j = j + 1; -- Increment the counter to find the next pizza topping in the row
        END WHILE;
        SET i = i + 1;-- Increment the counter to fetch the next row
	END WHILE;
END$$
DELIMITER ;

CALL GetToppings();


SELECT *
FROM pizza_topping_temp;
``` 
	
#### Result set:
![image](https://user-images.githubusercontent.com/77529445/167378920-e084b0e7-69d7-4202-9d7d-cd18b93f4400.png)

### Method 2: Using a JSON functions
- JSON functions are used to split the comma separated string into multiple rows.

```sql
SELECT t.pizza_id, (j.topping)
FROM pizza_recipes t
JOIN json_table(trim(replace(json_array(t.toppings), ',', '","')), '$[*]' columns (topping varchar(50) PATH '$')) j ;
```

#### Result set:
![image](https://user-images.githubusercontent.com/77529445/167557792-a3bf6995-7dca-46d6-96ee-5d514b9bcdaf.png)

***

- [A. Pizza Metrics](https://github.com/manaswikamila05/8-Week-SQL-Challenge/blob/main/Case%20Study%20%23%202%20-%20Pizza%20Runner/A.%20Pizza%20metrics.md)
- [B. Runner and Customer Experience](https://github.com/manaswikamila05/8-Week-SQL-Challenge/blob/main/Case%20Study%20%23%202%20-%20Pizza%20Runner/B.%20Runner%20and%20Customer%20Experience.md)
- [C. Ingredient Optimisation](https://github.com/manaswikamila05/8-Week-SQL-Challenge/blob/main/Case%20Study%20%23%202%20-%20Pizza%20Runner/C.%20Ingredient%20Optimisation.md)
