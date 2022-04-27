## :avocado: Case Study #3: Foodie-Fi - Customer Journey

Based off the 8 sample customers provided in the sample from the subscriptions table, write a brief description about each customer’s onboarding journey.

Try to keep it as short as possible - you may also want to run some sort of join to make your explanations a bit easier!

***

###  Distinct customer_id in the dataset

```sql
SELECT count(distinct(customer_id)) AS 'distinct customers'
FROM subscriptions;
``` 
	
#### Result set:
![image](https://user-images.githubusercontent.com/77529445/164886129-bcb3c7ba-b9c1-49c2-bf6d-7e95db015d8b.png)

***

Selecting the following random customer_id's from the subscriptions table to view their onboarding journey.
Checking the following customer_id's : 1,21,73,87,99,193,290,400

###  Customer 1

```sql
SELECT customer_id,
       plan_id,
       plan_name,
       start_date
FROM subscriptions
JOIN plans USING (plan_id)
WHERE customer_id =1;
``` 
	
#### Result set:
![image](https://user-images.githubusercontent.com/77529445/164886282-b3a105dd-9748-4b33-bc9b-d493667fce1b.png)

- Customer started the free trial on 1 August 2020  
- They subscribed to the basic monthly during the seven day the trial period to continue the subscription
***

###  Customer 21

```sql
SELECT customer_id,
       plan_id,
       plan_name,
       start_date
FROM subscriptions
JOIN plans USING (plan_id)
WHERE customer_id =21;
``` 
	
#### Result set:
![image](https://user-images.githubusercontent.com/77529445/164886333-14c74af7-eb02-430f-8bb3-3e564b5d3aef.png)

- Customer started the free trial on 4 Feb 202 and subscribed to the basic monthly during the seven day the trial period to continue the subscription
- They then upgraded to the pro monthly plan after 4 months
- Customer cancelled their subscription and churned on 27 September 2020 
***

###  Customer 73

```sql
SELECT customer_id,
       plan_id,
       plan_name,
       start_date
FROM subscriptions
JOIN plans USING (plan_id)
WHERE customer_id =73;
``` 
	
#### Result set:
![image](https://user-images.githubusercontent.com/77529445/164886363-a829a6ab-022a-48de-a83d-1adffc3e9040.png)

- Customer started the free trial on 24 March 2020 and subscribed to the basic monthly after the seven day the trial period to continue the subscription
- They then upgraded to the pro monthly plan after 2 months
- They then  upgraded to the pro annual plan in October 2020
***

###  Customer 87

```sql
SELECT customer_id,
       plan_id,
       plan_name,
       start_date
FROM subscriptions
JOIN plans USING (plan_id)
WHERE customer_id =87;
``` 
	
#### Result set:
![image](https://user-images.githubusercontent.com/77529445/164886440-b5f56717-6508-4830-a22e-f8b6a0001ac2.png)

- Customer started the free trial on 8 August 2020 
- They may have chosen to continue with the pro monthly after the seven day the trial period
- They then upgraded to the pro annual plan in September 2020
***

###  Customer 99

```sql
SELECT customer_id,
       plan_id,
       plan_name,
       start_date
FROM subscriptions
JOIN plans USING (plan_id)
WHERE customer_id =99;
``` 
	
#### Result set:
![image](https://user-images.githubusercontent.com/77529445/164886472-791c220c-24fa-4de1-98c3-b45c549f8d83.png)

- Customer started the free trial on 5 December 2020
- They chose not to continue with paid subscription and decided to cancel on the last day of the trial period.
***

###  Customer 290

```sql
SELECT customer_id,
       plan_id,
       plan_name,
       start_date
FROM subscriptions
JOIN plans USING (plan_id)
WHERE customer_id =290;
``` 
	
#### Result set:
![image](https://user-images.githubusercontent.com/77529445/164886510-905e131b-3d65-4751-b33a-ecc65ef8bb19.png)

- Customer started the free trial on 10 January 2020
- They subscribed to the basic monthly plan during the seven day the trial period to continue the subscription
***

Click [here](https://github.com/manaswikamila05/8-Week-SQL-Challenge/blob/main/Case%20Study%20%23%203%20-%20Foodie-Fi/B.%20Data%20Analysis%20Questions.md) to view the solution solution of B. Data Analysis Questions!


