# :avocado: Case Study #3: Foodie-Fi
<p align="center">
<img src="https://8weeksqlchallenge.com/images/case-study-designs/3.png" alt="Image" width="450" height="450">

View the case study [here](https://8weeksqlchallenge.com/case-study-3/)
  
## Table Of Contents
  - [Introduction](#introduction)
  - [Dataset](#datasets)
  - [Entity Relationship Diagram](#entity-relationship-diagram)
  - [Case Study Solutions](#case-study-solutions)


## Introduction
Subscription based businesses are super popular and Danny realised that there was a large gap in the market - he wanted to create a new streaming service that only had food related content - something like Netflix but with only cooking shows!

Danny finds a few smart friends to launch his new startup Foodie-Fi in 2020 and started selling monthly and annual subscriptions, giving their customers unlimited on-demand access to exclusive food videos from around the world!

Danny created Foodie-Fi with a data driven mindset and wanted to ensure all future investment decisions and new features were decided using data. This case study focuses on using subscription style digital data to answer important business questions.

## Datasets

**plans table** : Customers can choose which plans to join Foodie-Fi when they first sign up.

There are 5 customer plans.
- Basic plan - customers have limited access and can only stream their videos and is only available monthly at $9.90
- Pro plan - customers have no watch time limits and are able to download videos for offline viewing. Pro plans start at $19.90 a month or $199 for an annual subscription.
- Trial plan - Customers can sign up to an initial 7 day free trial will automatically continue with the pro monthly subscription plan unless they cancel, downgrade to basic or upgrade to an annual pro plan at any point during the trial.
- Churn plan - When customers cancel their Foodie-Fi service - they will have a churn plan record with a null price but their plan will continue until the end of the billing period.

**subscriptions table** 
- Customer subscriptions show the *exact date where their specific plan_id starts*.
- If customers *downgrade* from a pro plan or *cancel their subscription* - the higher plan will remain in place until the period is over - the start_date in the subscriptions table will reflect the date that the actual plan changes.
- When customers *upgrade* their account from a basic plan to a pro or annual pro plan - the higher plan will take effect straightaway.
- When customers *churn* - they will keep their access until the end of their current billing period but the start_date will be technically the day they decided to cancel their service.

## Entity Relationship Diagram
![alt text](https://github.com/manaswikamila05/8-Week-SQL-Challenge/blob/main/Case%20Study%20%23%203%20-%20Foodie-Fi/ERD.jpg)

## Case Study Solutions
- [A. Customer Journey](https://github.com/manaswikamila05/8-Week-SQL-Challenge/blob/main/Case%20Study%20%23%203%20-%20Foodie-Fi/A.%20Customer%20Journey.md)
- [B. Data Analysis Questions](https://github.com/manaswikamila05/8-Week-SQL-Challenge/blob/main/Case%20Study%20%23%203%20-%20Foodie-Fi/B.%20Data%20Analysis%20Questions.md)

