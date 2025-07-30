/*
===============================================================================
Performance Analysis (Year-over-Year, Month-over-Month)
===============================================================================
Purpose:
    - To measure the performance of products, customers, or regions over time.
    - For benchmarking and identifying high-performing entities.
    - To track yearly trends and growth.

SQL Functions Used:
    - LAG(): Accesses data from previous rows.
    - AVG() OVER(): Computes average values within partitions.
    - CASE: Defines conditional logic for trend analysis.
===============================================================================
*/

/* 
	we use it to compare the target value with the value 
	help messure success and compare performance 

	current[measure] - target[measure ]
*/

/* Analyze the yearly performance of products by comparing their sales 
to both the average sales performance of the product and the previous year's sales */

WITH yearly_product_sales AS (
	SELECT 
		YEAR(GFS.order_date) year,
		GDP.product_name,			
		SUM(GFS.sales_amount) current_sales
	FROM gold.fact_sales	GFS
	LEFT JOIN gold.dim_products		GDP
		ON GFS.product_key = GDP.product_key
	WHERE GFS.order_date IS NOT NULL
	GROUP BY 
		YEAR(GFS.order_date),
		GDP.product_name
)
SELECT 
	year,
	product_name,
	current_sales,
	AVG(current_sales)	OVER(PARTITION BY product_name) avg_sales,

	-- compare with average sales performance
	(current_sales - AVG(current_sales)	OVER(PARTITION BY product_name)) AS diff_sales,
	CASE	WHEN  (current_sales - AVG(current_sales)	OVER(PARTITION BY product_name)) < 0 
			THEN 'Below Avg'
			WHEN  (current_sales - AVG(current_sales)	OVER(PARTITION BY product_name)) > 0 
			THEN 'above Avg'
			ELSE 'AVG'
	END AS average_change,

	-- compare with the pervious year sales 
	LAG(current_sales) OVER(PARTITION BY product_name ORDER BY year) AS pervious_year_sales,
	(current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY year)) AS diff_sales_by_years,
	CASE	WHEN  current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY year) < 0 
			THEN 'Decrease'
			WHEN  current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY year) > 0 
			THEN 'Increase'
			ELSE 'NoChange'
	END AS average_change

FROM yearly_product_sales
