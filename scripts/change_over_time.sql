/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - To track trends, growth, and changes in key metrics over time.
    - For time-series analysis and identifying seasonality.
    - To measure growth or decline over specific periods.

SQL Functions Used:
    - Date Functions: DATEPART(), DATETRUNC(), FORMAT()
    - Aggregate Functions: SUM(), COUNT(), AVG()
===============================================================================
*/
-- sales performance over time 

--  total sales per years and month
SELECT 
	YEAR(order_date) year,
	MONTH(order_date) MONTH ,
	SUM(sales_amount) total_sales,
	COUNT(DISTINCT customer_key) total_nr_customers,
	SUM(quantity)	total_quantity
FROM gold.fact_sales
GROUP BY MONTH(order_date) , YEAR(order_date)
HAVING YEAR(order_date) IS NOT NULL
ORDER BY MONTH ;


-- another way
-- total sales per years
SELECT 
	YEAR(order_date) year,
	SUM(sales_amount) total_sales,
	COUNT(DISTINCT customer_key) total_nr_customers,
	SUM(quantity)	total_quantity
FROM gold.fact_sales
WHERE YEAR(order_date) IS NOT NULL
GROUP BY YEAR(order_date) 
ORDER BY YEAR(order_date) 

-- another_way
-- total sales per every month 
SELECT 
	DATETRUNC(MONTH,order_date) year,
	SUM(sales_amount) total_sales,
	COUNT(DISTINCT customer_key) total_nr_customers,
	SUM(quantity)	total_quantity
FROM gold.fact_sales
WHERE YEAR(order_date) IS NOT NULL
GROUP BY DATETRUNC(MONTH,order_date) 
ORDER BY DATETRUNC(MONTH,order_date) 


-- total quantity had been shipped per years 
SELECT 
	YEAR(shipping_date) Ship_date_year,
	SUM(quantity)	total_quantity
FROM gold.fact_sales
GROUP BY YEAR(shipping_date)
HAVING YEAR(shipping_date) IS NOT NULL
ORDER BY YEAR(shipping_date)


-- how many orders had been placed per year?
SELECT 
	YEAR(order_date) order_date,
	COUNT(DISTINCT order_number)	total_orders 
FROM gold.fact_sales
GROUP BY YEAR(order_date)
HAVING YEAR(order_date) IS NOT NULL
ORDER BY YEAR(order_date)

-- whats the top two year performs high sales revenue ?
SELECT	TOP 2
	YEAR(due_date) due_date_year,
	SUM(sales_amount)	total_revenues
FROM gold.fact_sales
GROUP BY 	YEAR(due_date)
HAVING 		YEAR(due_date) IS NOT NULL
ORDER BY 	total_revenues	DESC


















