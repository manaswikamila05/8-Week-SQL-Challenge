# :pizza: Case Study #2: Pizza runner - Bonus Question

If Danny wants to expand his range of pizzas - how would this impact the existing data design? Write an INSERT statement to demonstrate what would happen if a new Supreme pizza with all the toppings was added to the Pizza Runner menu?

Supreme pizza has all toppings on it.

![image](https://user-images.githubusercontent.com/77529445/168252509-fa26acf9-5442-439a-869f-d28f4e90b0ac.png)

We'd have to insert data into pizza_names and pizza_recipes tables

***

```sql
INSERT INTO pizza_names VALUES(3, 'Supreme');
SELECT * FROM pizza_names;
``` 
![image](https://user-images.githubusercontent.com/77529445/168253501-37fa4dd6-db97-441c-b65e-e873f8080f4d.png)

```sql
INSERT INTO pizza_recipes
VALUES(3, (SELECT GROUP_CONCAT(topping_id SEPARATOR ', ') FROM pizza_toppings));
``` 

```sql
SELECT * FROM pizza_recipes;
``` 
![image](https://user-images.githubusercontent.com/77529445/168253456-9963d83b-4bc9-4f1b-8cf4-927b5d24cc5a.png)

*** 

```sql
SELECT *
FROM pizza_names
INNER JOIN pizza_recipes USING(pizza_id);
``` 
![image](https://user-images.githubusercontent.com/77529445/168253404-92f729d5-0db7-44e7-9cda-684ad2a879c2.png)

***

Click [here](https://github.com/manaswikamila05/8-Week-SQL-Challenge) to move back to the 8-Week-SQL-Challenge repository!
