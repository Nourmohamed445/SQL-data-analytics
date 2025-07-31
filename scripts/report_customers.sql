/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - lifespan (in months)
    4. Calculates valuable KPIs:
	    - recency (months since last order)
		- average order value
		- average monthly spend
===============================================================================
*/
-- =============================================================================
-- Create Report: gold.report_customers
-- =============================================================================
IF OBJECT_ID('gold.report_customers', 'V') IS NOT NULL
    DROP VIEW gold.report_customers;
GO

CREATE VIEW gold.report_customers AS
/*---------------------------------------------------------------------------
1) Base Query: Retrieves core columns from tables
---------------------------------------------------------------------------*/
WITH cte_basic_query AS(
SELECT 
	f.order_number,
	f.product_key,
	f.order_date,
	f.quantity,
	f.sales_amount,
	c.customer_key,
	c.customer_number,
	CONCAT(c.first_name, ' ' ,c.last_name ) AS Customer_Name,
	DATEDIFF(year,c.birthdate,GETDATE())	AS Age
FROM gold.fact_sales F
LEFT JOIN gold.dim_customers C
	ON F.customer_key = C.customer_key
WHERE order_date IS NOT NULL),

/*---------------------------------------------------------------------------
2) Customer Aggregations: Summarizes key metrics at the customer level
---------------------------------------------------------------------------*/
cte_aggregation_query AS
(
SELECT 
	customer_key,
	customer_number,
	Customer_Name,
	Age,
	COUNT(DISTINCT order_date) [Total Orders],
	COUNT(DISTINCT product_key) [Total Products],
	SUM(quantity)	[Total Quantity],
	SUM(sales_amount)	[Total Sales],
	MAX(order_date)		[Last Order Date],
	DATEDIFF(MONTH,MIN(order_date),MAX(order_date))	[Life Span]
FROM cte_basic_query 
GROUP BY 	
	customer_key,
	customer_number,
	Customer_Name,
	Age
)
SELECT 
	customer_key,
	customer_number,
	Customer_Name,
	Age,
	-- Segment customers by age group
	CASE 
		WHEN Age < 20	THEN 'Under 20'
		WHEN Age BETWEEN 20	AND 29 THEN ' 20 - 29 '
		WHEN Age BETWEEN 30	AND 39 THEN ' 30 - 39 '
		WHEN Age BETWEEN 40	AND 49 THEN ' 40 - 49 '
		ELSE '50 and Above'
	END age_group,

	-- Segment customers by age group
	CASE 
		WHEN [Life Span] >= 12 AND [Total Sales] > 5000 THEN 'VIP'
		WHEN [Life Span] >= 12 AND [Total Sales] <= 5000 THEN 'Regular' 
		ELSE 'New '
	END customer_group_level,

	[Total Orders],
	[Total Products],
	[Total Quantity],
	[Total Sales],
	[Last Order Date],
	[Life Span],

	-- calculate the recency : how many months had the customer not active till now 
	DATEDIFF(MONTH,[Last Order Date],GETDATE())	AS recency,

	-- calculate average order value : total_sales / total_orders
	CASE 
			WHEN [Total Orders] = 0 THEN 0
			ELSE [Total Sales] / [Total Orders]
	END [average order value],

	-- calculate average monthly spend : total_sales / total number of months that customer was active in 
	CASE 
			WHEN [Life Span] = 0 THEN [Total Sales]
			ELSE [Total Sales] / [Life Span]
	END [average monthly spend]
FROM cte_aggregation_query

