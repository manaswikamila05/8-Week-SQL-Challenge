# :technologist: :moneybag: :cloud: :chart: Case Study #4: Data Bank 
<p align="center">
<img src="https://8weeksqlchallenge.com/images/case-study-designs/4.png" alt="Image" width="450" height="450">

View the case study [here](https://8weeksqlchallenge.com/case-study-4/)
  
## Table Of Contents
  - [Introduction](#introduction)
  - [Problem Statement](#problem-statement)
  - [Datasets used](#datasets-used)
  - [Entity Relationship Diagram](#entity-relationship-diagram)
  - [Case Study Solutions](#case-study-solutions)
  
## Introduction
There is a new innovation in the financial industry called Neo-Banks: new aged digital only banks without physical branches.

Danny thought that there should be some sort of intersection between these new age banks, cryptocurrency and the data world…so he decides to launch a new initiative - Data Bank!

Data Bank runs just like any other digital bank - but it isn’t only for banking activities, they also have the world’s most secure distributed data storage platform!

Customers are allocated cloud data storage limits which are directly linked to how much money they have in their accounts. There are a few interesting caveats that go with this business model, and this is where the Data Bank team need your help!

## Problem Statement
The management team at Data Bank want to increase their total customer base - but also need some help tracking just how much data storage their customers will need.

This case study is all about calculating metrics, growth and helping the business analyse their data in a smart way to better forecast and plan for their future developments!


## Datasets used
Just like popular cryptocurrency platforms - Data Bank is also run off a network of nodes where both money and data is stored across the globe. In a traditional banking sense - you can think of these nodes as bank branches or stores that exist around the world. The  regions table contains the region_id and their respective region_name values.
  
![image](https://user-images.githubusercontent.com/77529445/165747951-d00563e9-86cb-404b-913e-1df4c26f6029.png)

Customers are randomly distributed across the nodes according to their region - this also specifies exactly which node contains both their cash and data.
This random distribution changes frequently to reduce the risk of hackers getting into Data Bank’s system and stealing customer’s money and data!
  
Below is a sample of the top 10 rows of the data_bank.customer_nodes
![image](https://user-images.githubusercontent.com/77529445/165748069-0ccca2f4-fc9c-4183-8cda-6e10a9ee782b.png)

Customer transaction table stores all customer deposits, withdrawals and purchases made using their Data Bank debit card
  
![image](https://user-images.githubusercontent.com/77529445/165748268-c7e71778-173b-435d-93a4-178c6a2d1ebc.png)

 
## Entity Relationship Diagram
![image](https://user-images.githubusercontent.com/77529445/165748352-09dfcafd-07a6-4bf0-b171-7ba0ec75aa22.png)
  
## Case Study Solutions
- [A. Customer Nodes Exploration](https://github.com/manaswikamila05/8-Week-SQL-Challenge/blob/main/Case%20Study%20%23%204%20-%20Data%20Bank/A.%20Customer%20Nodes%20Exploration.md)
- [B. Customer Transactions](https://github.com/manaswikamila05/8-Week-SQL-Challenge/blob/main/Case%20Study%20%23%204%20-%20Data%20Bank/B.%20Customer%20Transactions.md)
- [C. Data Allocation Challenge](https://github.com/manaswikamila05/8-Week-SQL-Challenge/blob/main/Case%20Study%20%23%204%20-%20Data%20Bank/C.%20Data%20Allocation%20Challenge.md)

