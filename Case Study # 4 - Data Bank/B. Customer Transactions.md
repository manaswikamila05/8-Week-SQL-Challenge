## :technologist::woman_technologist: Case Study #4: Data Bank - Customer Transactions - WIP

## Case Study Questions

1. What is the unique count and total amount for each transaction type?
2. What is the average total historical deposit counts and amounts for all customers?
3. For each month - how many Data Bank customers make more than 1 deposit and either 1 purchase or 1 withdrawal in a single month?
4. What is the closing balance for each customer at the end of the month?
5. What is the percentage of customers who increase their closing balance by more than 5%?

***

###  1. What is the unique count and total amount for each transaction type?

```sql
SELECT txn_type,
       count(*) AS unique_count,
       sum(txn_amount) AS total_amont
FROM customer_transactions
GROUP BY txn_type;
``` 
	
#### Result set:
![image](https://user-images.githubusercontent.com/77529445/165959743-9026aba5-b653-4a50-9785-e92ed7d6f9df.png)

***

###  2. What is the average total historical deposit counts and amounts for all customers?

```sql
SELECT round(count(customer_id)/
               (SELECT count(DISTINCT customer_id)
                FROM customer_transactions)) AS average_deposit_count,
       concat('$', round(avg(txn_amount), 2)) AS average_deposit_amount
FROM customer_transactions
WHERE txn_type = "deposit";
``` 
	
#### Result set:
![image](https://user-images.githubusercontent.com/77529445/165959862-4b59c7ba-c08b-4d4f-a277-d6931df78946.png)

***

###  3. For each month - how many Data Bank customers make more than 1 deposit and either 1 purchase or 1 withdrawal in a single month?

```sql
WITH transaction_count_per_month_cte AS
  (SELECT customer_id,
          month(txn_date) AS txn_month,
          SUM(IF(txn_type="deposit", 1, 0)) AS deposit_count,
          SUM(IF(txn_type="withdrawal", 1, 0)) AS withdrawal_count,
          SUM(IF(txn_type="purchase", 1, 0)) AS purchase_count
   FROM customer_transactions
   GROUP BY customer_id,
            month(txn_date))
SELECT txn_month,
       count(DISTINCT customer_id) as customer_count
FROM transaction_count_per_month_cte
WHERE deposit_count>1
  AND (purchase_count = 1
       OR withdrawal_count = 1)
GROUP BY txn_month;
``` 
	
#### Result set:
![image](https://user-images.githubusercontent.com/77529445/165960192-10c71d44-6586-4697-b309-e7e3660e80e3.png)

***

###  4. What is the closing balance for each customer at the end of the month?

```sql
WITH txn_monthly_balance_cte AS
  (SELECT customer_id,
          txn_amount,
          month(txn_date) AS txn_month,
          SUM(CASE
                  WHEN txn_type="deposit" THEN txn_amount
                  ELSE -txn_amount
              END) AS net_transaction_amt
   FROM customer_transactions
   GROUP BY customer_id,
            month(txn_date)
   ORDER BY customer_id)
SELECT customer_id,
       txn_month,
       net_transaction_amt,
       sum(net_transaction_amt) over(PARTITION BY customer_id
                                     ORDER BY txn_month ROWS BETWEEN UNBOUNDED preceding AND CURRENT ROW) AS closing_balance
FROM txn_monthly_balance_cte;
``` 
	
#### Result set:
![image](https://user-images.githubusercontent.com/77529445/165960387-6fcd2844-ad0d-44be-b37c-18c15c84d1ae.png)

***

###  5. What is the percentage of customers who increase their closing balance by more than 5%?

```sql

``` 
	
#### Result set:

***

