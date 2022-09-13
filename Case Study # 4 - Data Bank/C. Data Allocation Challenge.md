## :technologist::woman_technologist: Case Study #4: Data Bank - Data Allocation Challenge

To test out a few different hypotheses - the Data Bank team wants to run an experiment where different groups of customers would be allocated data using 3 different options:

- **Option 1**: data is allocated based off the amount of money at the end of the previous month
- **Option 2**: data is allocated on the average amount of money kept in the account in the previous 30 days
- **Option 3**: data is updated real-time


For this multi-part challenge question - you have been requested to generate the following data elements to help the Data Bank team estimate how much data will need to be provisioned for each option:
- running customer balance column that includes the impact each transaction
```sql
 WITH transaction_amt_cte AS
  (SELECT *,
          month(txn_date) AS txn_month,
          SUM(CASE
                  WHEN txn_type="deposit" THEN txn_amount
                  ELSE -txn_amount
              END) AS net_transaction_amt
   FROM customer_transactions
   GROUP BY customer_id,
            txn_date
   ORDER BY customer_id,
            txn_date),
      running_customer_balance_cte AS
  (SELECT customer_id,
          txn_date,
          txn_month,
          txn_type,
          txn_amount,
          sum(net_transaction_amt) over(PARTITION BY customer_id
                                        ORDER BY txn_month ROWS BETWEEN UNBOUNDED preceding AND CURRENT ROW) AS running_customer_balance
   FROM transaction_amt_cte)
SELECT *
FROM running_customer_balance_cte;
``` 
- customer balance at the end of each month
```sql
 WITH transaction_amt_cte AS
  (SELECT *,
          month(txn_date) AS txn_month,
          SUM(CASE
                  WHEN txn_type="deposit" THEN txn_amount
                  ELSE -txn_amount
              END) AS net_transaction_amt
   FROM customer_transactions
   GROUP BY customer_id,
            txn_date
   ORDER BY customer_id,
            txn_date),
      running_customer_balance_cte AS
  (SELECT customer_id,
          txn_date,
          txn_month,
          txn_type,
          txn_amount,
          sum(net_transaction_amt) over(PARTITION BY customer_id
                                        ORDER BY txn_month ROWS BETWEEN UNBOUNDED preceding AND CURRENT ROW) AS running_customer_balance
   FROM transaction_amt_cte),
      month_end_balance_cte AS
  (SELECT *,
          last_value(running_customer_balance) over(PARTITION BY customer_id, txn_month
                                                    ORDER BY txn_month) AS month_end_balance
   FROM running_customer_balance_cte
   GROUP BY customer_id,
            txn_month)
SELECT customer_id,
       txn_month,
       month_end_balance
FROM month_end_balance_cte;
``` 
- minimum, average and maximum values of the running balance for each customer
```sql
WITH transaction_amt_cte AS
  (SELECT *,
          month(txn_date) AS txn_month,
          SUM(CASE
                  WHEN txn_type="deposit" THEN txn_amount
                  ELSE -txn_amount
              END) AS net_transaction_amt
   FROM customer_transactions
   GROUP BY customer_id,
            txn_date
   ORDER BY customer_id,
            txn_date),
     running_customer_balance_cte AS
  (SELECT customer_id,
          txn_date,
          txn_month,
          txn_type,
          txn_amount,
          sum(net_transaction_amt) over(PARTITION BY customer_id
                                        ORDER BY txn_month ROWS BETWEEN UNBOUNDED preceding AND CURRENT ROW) AS running_customer_balance
   FROM transaction_amt_cte
   GROUP BY customer_id,
            txn_month)
SELECT customer_id,
       min(running_customer_balance),
       max(running_customer_balance),
       round(avg(running_customer_balance), 2) AS 'avg(running_customer_balance)'
FROM running_customer_balance_cte
GROUP BY customer_id
ORDER BY customer_id ;
``` 


Using all of the data available - how much data would have been required for each option on a monthly basis?

###  **Option 1**: Data is allocated based off the amount of money at the end of the previous month
How much data would have been required on a monthly basis?

```sql
WITH transaction_amt_cte AS
  (SELECT *,
          month(txn_date) AS txn_month,
          SUM(CASE
                  WHEN txn_type="deposit" THEN txn_amount
                  ELSE -txn_amount
              END) AS net_transaction_amt
   FROM customer_transactions
   GROUP BY customer_id,
            txn_date
   ORDER BY customer_id,
            txn_date),
     running_customer_balance_cte AS
  (SELECT customer_id,
          txn_date,
          txn_month,
          txn_type,
          txn_amount,
          sum(net_transaction_amt) over(PARTITION BY customer_id
                                        ORDER BY txn_month ROWS BETWEEN UNBOUNDED preceding AND CURRENT ROW) AS running_customer_balance
   FROM transaction_amt_cte),
     month_end_balance_cte AS
  (SELECT *,
          last_value(running_customer_balance) over(PARTITION BY customer_id, txn_month
                                                    ORDER BY txn_month) AS month_end_balance
   FROM running_customer_balance_cte),
     customer_month_end_balance_cte AS
  (SELECT customer_id,
          txn_month,
          month_end_balance
   FROM month_end_balance_cte
   GROUP BY customer_id,
            txn_month)
SELECT txn_month,
       sum(month_end_balance) AS data_required_per_month
FROM customer_month_end_balance_cte
GROUP BY txn_month
ORDER BY txn_month
``` 

#### Result set:
![image](https://user-images.githubusercontent.com/77529445/166265817-f2bd74cf-0759-43d2-8b32-aabaa40453aa.png)

**Observed**: Data required per month is negative. This is caused due to negative account balance maintained by customers at the end of the month.

**Assumption**: Some customers do not maintain a positive account balance at the end of the month. I'm assuming that no data is allocated when the 
amount of money at the end of the previous month is negative. we can use **SUM(IF(month_end_balance > 0, month_end_balance, 0))** in the select clause to compute the total data requirement per month.

#### Result set:
![image](https://user-images.githubusercontent.com/77529445/166266334-1a6ea8e8-7495-4832-90b0-3801017ab991.png)

***

###  **Option 2**: Data is allocated on the average amount of money kept in the account in the previous 30 days
How much data would have been required on a monthly basis?

```sql
WITH transaction_amt_cte AS
  (SELECT *,
          month(txn_date) AS txn_month,
          SUM(CASE
                  WHEN txn_type="deposit" THEN txn_amount
                  ELSE -txn_amount
              END) AS net_transaction_amt
   FROM customer_transactions
   GROUP BY customer_id,
            txn_date
   ORDER BY customer_id,
            txn_date),
     running_customer_balance_cte AS
  (SELECT customer_id,
          txn_date,
          txn_month,
          txn_type,
          txn_amount,
          sum(net_transaction_amt) over(PARTITION BY customer_id
                                        ORDER BY txn_month ROWS BETWEEN UNBOUNDED preceding AND CURRENT ROW) AS running_customer_balance
   FROM transaction_amt_cte
   GROUP BY customer_id,
            txn_month),
     avg_running_customer_balance AS
  (SELECT customer_id,
          txn_month,
          avg(running_customer_balance) over(PARTITION BY customer_id) AS 'avg_running_customer_balance'
   FROM running_customer_balance_cte
   GROUP BY customer_id,
            txn_month
   ORDER BY customer_id)
SELECT txn_month,
       round(sum(avg_running_customer_balance)) AS data_required_per_month
FROM avg_running_customer_balance
GROUP BY txn_month;
``` 

#### Result set:
![image](https://user-images.githubusercontent.com/77529445/166285983-4bd22c19-f272-4338-a845-56ef1137b81a.png)



###  **Option 3**: Data is updated real-time
How much data would have been required on a monthly basis?

```sql
WITH transaction_amt_cte AS
  (SELECT *,
          month(txn_date) AS txn_month,
          SUM(CASE
                  WHEN txn_type="deposit" THEN txn_amount
                  ELSE -txn_amount
              END) AS net_transaction_amt
   FROM customer_transactions
   GROUP BY customer_id,
            txn_date
   ORDER BY customer_id,
            txn_date),
     running_customer_balance_cte AS
  (SELECT customer_id,
          txn_date,
          txn_month,
          txn_type,
          txn_amount,
          net_transaction_amt,
          sum(net_transaction_amt) over(PARTITION BY customer_id
                                        ORDER BY txn_month ROWS BETWEEN UNBOUNDED preceding AND CURRENT ROW) AS running_customer_balance
   FROM transaction_amt_cte)
SELECT txn_month,
       SUM(running_customer_balance) AS data_required_per_month
FROM running_customer_balance_cte
GROUP BY txn_month;
``` 

#### Result set:
![image](https://user-images.githubusercontent.com/77529445/167304936-5586815b-fd25-4245-8658-c5ab8b3c54f2.png)

***


Click [here](https://github.com/manaswikamila05/8-Week-SQL-Challenge) to move back to the 8-Week-SQL-Challenge repository!
