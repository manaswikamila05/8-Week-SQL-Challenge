## :technologist::woman_technologist: Case Study #4: Data Bank - Data Allocation Challenge

To test out a few different hypotheses - the Data Bank team wants to run an experiment where different groups of customers would be allocated data using 3 different options:

- **Option 1**: data is allocated based off the amount of money at the end of the previous month
- **Option 2**: data is allocated on the average amount of money kept in the account in the previous 30 days
- **Option 3**: data is updated real-time


For this multi-part challenge question - you have been requested to generate the following data elements to help the Data Bank team estimate how much data will need to be provisioned for each option:
- running customer balance column that includes the impact each transaction
- customer balance at the end of each month
- minimum, average and maximum values of the running balance for each customer

Using all of the data available - how much data would have been required for each option on a monthly basis?

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
SELECT *,
       last_value(running_customer_balance) over(PARTITION BY customer_id, txn_month
                                                 ORDER BY txn_month) AS month_end_balance,
       min(running_customer_balance) over(PARTITION BY customer_id) AS min_running_customer_balance,
       max(running_customer_balance) over(PARTITION BY customer_id) AS max_running_customer_balance,
       round(avg(running_customer_balance) over(PARTITION BY customer_id), 2) AS avg_running_customer_balance
FROM running_customer_balance_cte;
``` 

## **Option 1**: data is allocated based off the amount of money at the end of the previous month

Assumption: Some customers do not maintain a positive account balance at the end of the month. The data allocation for such customers is considered to be 0 since there is no mention of penalizing customers for maintaining a negative balance at the end of each month


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
   FROM running_customer_balance_cte)
SELECT txn_month,
       sum(IF(month_end_balance > 0, month_end_balance, 0)) AS data_required_per_month
FROM month_end_balance_cte
GROUP BY txn_month;
``` 
