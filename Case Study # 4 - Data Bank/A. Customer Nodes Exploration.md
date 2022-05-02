## :technologist::woman_technologist: Case Study #4: Data Bank - Customer Nodes Exploration

## Case Study Questions

1. How many unique nodes are there on the Data Bank system?
2. What is the number of nodes per region?
3. How many customers are allocated to each region?
4. How many days on average are customers reallocated to a different node?
5. What is the median, 80th and 95th percentile for this same reallocation days metric for each region?

***

###  1. How many unique nodes are there on the Data Bank system?

```sql
SELECT count(DISTINCT node_id) AS unique_nodes
FROM customer_nodes;
``` 
	
#### Result set:
![image](https://user-images.githubusercontent.com/77529445/165895245-c6b15626-c023-4d1a-9aaa-43cf8d3f1878.png)

***

###  2. What is the number of nodes per region?

```sql
SELECT region_id,
       region_name,
       count(node_id) AS node_count
FROM customer_nodes
INNER JOIN regions USING(region_id)
GROUP BY region_id;
``` 
	
#### Result set:
![image](https://user-images.githubusercontent.com/77529445/165895305-a8e9c09d-b2ea-4377-9f5f-a9d14c7d14e8.png)

***

###  3. How many customers are allocated to each region?

```sql
SELECT region_id,
       region_name,
       count(DISTINCT customer_id) AS customer_count
FROM customer_nodes
INNER JOIN regions USING(region_id)
GROUP BY region_id;
``` 
	
#### Result set:
![image](https://user-images.githubusercontent.com/77529445/165895370-9639af80-4f0b-45c7-8063-6faa3beafc55.png)

***

###  4. How many days on average are customers reallocated to a different node?

```sql
SELECT round(avg(datediff(end_date, start_date)), 2) AS avg_days
FROM customer_nodes
WHERE end_date!='9999-12-31';
``` 
	
#### Result set:
![image](https://user-images.githubusercontent.com/77529445/165895454-321fad36-bd71-442f-a7a3-ab99e8749151.png)

***

###  5. What is the median, 80th and 95th percentile for this same reallocation days metric for each region?
- reallocation days metric: days taken to reallocate to a different node
- Percentile found by partitioning the dataset by regions and arranging it in ascending order of reallocation_days
- 95th percentile -> 95% of the values are less than or equal to the current value.


**95th percentile**
```sql
with reallocation_days_cte as(
select *, (datediff(end_date,start_date)) as reallocation_days
from customer_nodes
where end_date!='9999-12-31'),
percentile_cte as 
(
select *,  
percent_rank() over(partition by region_id  order by reallocation_days )*100 as p
from reallocation_days_table
)
select region_id, reallocation_days
from percentile_cte
where p between 95.0 and 95.99
group by region_id;
``` 
	
#### Result set:
![image](https://user-images.githubusercontent.com/77529445/166219080-acfa853a-111a-4fde-bcd7-dfb1d35f685e.png)

***
