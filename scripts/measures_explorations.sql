/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends or spot anomalies.

SQL Functions Used:
    - COUNT(), SUM(), AVG()
===============================================================================
*/

-- find the total sales
SELECT
	SUM(sales_amount) total_sales
FROM GOLD.fact_sales ;

-- find how many items are sold 
SELECT
	sum(quantity) total_quantity
FROM GOLD.fact_sales;

-- find the average selling price 
SELECT
	AVG(price) average_price
FROM GOLD.fact_sales;

-- find the total number of orders 
SELECT
	COUNT(distinct order_number) total_orders
FROM GOLD.fact_sales;

-- find the total number of products 
SELECT
	COUNT(product_name) total_num_products
FROM GOLD.dim_products;

SELECT
	COUNT(DISTINCT product_key) total_num_products
FROM GOLD.dim_products;

-- find the total number of customers 
SELECT
	COUNT(customer_number) total_num_customers
FROM GOLD.dim_customers;

-- find the total number of customers who had placed an order
SELECT
	COUNT(DISTINCT customer_key) total_num_customers
FROM GOLD.fact_sales;
-- ========================================================================================================================= --
-- generate a report that show all key metrics of the business
SELECT
	'Total Sales' AS measure_name,
	SUM(sales_amount) measure_value		--  total_sales
FROM GOLD.fact_sales 

UNION ALL

SELECT
	'Total Quantity' AS measure_name,
	SUM(quantity) measure_value			-- total_quantity
FROM GOLD.fact_sales

UNION ALL

SELECT
	'Average Price' AS measure_name,
	AVG(price) measure_value			-- average_price
FROM GOLD.fact_sales

UNION ALL

SELECT
	'Total Orders' AS measure_name,
	COUNT(DISTINCT order_number) measure_value			-- Total actual order without duplicates
FROM GOLD.fact_sales

UNION ALL

SELECT
	'Total Number of Products' AS measure_name,
	COUNT(DISTINCT product_key) measure_value		-- total number of products 
FROM GOLD.dim_products

UNION ALL

SELECT
	'Total Number of Customers' AS measure_name,
	COUNT(DISTINCT customer_key) measure_value		-- total number of customers 
FROM GOLD.dim_customers;


