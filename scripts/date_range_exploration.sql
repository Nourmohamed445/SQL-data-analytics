/*
===============================================================================
Date Range Exploration 
===============================================================================
Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data.

SQL Functions Used:
    - MIN(), MAX(), DATEDIFF()
===============================================================================
*/

 -- lets explore the bounderies of the orderdate
 -- find the first and last date order 
-- find how many years of sales do we have 
SELECT 
	MIN(order_date) first_order_date,
	MAX(order_date) last_order_date,
	DATEDIFF(YEAR,MIN(order_date),MAX(order_date)) yeas_of_sales
FROM gold.fact_sales

-- find the youngest and oldest customer
SELECT 
	MIN(AGE) youngest_customer,
	MAX(AGE) oldest_customer
FROM (
SELECT 
	DATEDIFF(year,birthdate,CAST( GETDATE() AS DATE)) AGE
FROM gold.dim_customers
)t
