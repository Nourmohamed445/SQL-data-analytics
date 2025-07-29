/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/

-- which 5 products generate the highest revenue? 
SELECT	TOP 5
	GDP.subcategory,
	SUM(GFS.sales_amount) total_sales
FROM gold.fact_sales AS GFS
LEFT JOIN gold.dim_products AS GDP
	ON GFS.product_key = GDP.product_key
GROUP BY GDP.subcategory
ORDER BY SUM(GFS.sales_amount)	DESC;

-- find the top 10 customers who have generated the highest revenue
SELECT 
	t.customer_key,
	t.first_name,
	t.last_name,
	t.total_sales
FROM(
SELECT
	GDC.customer_key,
	GDC.first_name,
	GDC.last_name,
	SUM(GFS.sales_amount) total_sales,
	ROW_NUMBER() OVER(ORDER BY SUM(GFS.sales_amount) DESC) RANKING 
FROM gold.fact_sales AS GFS
LEFT JOIN gold.dim_customers AS GDC
	ON GFS.product_key = GDC.customer_key
GROUP BY 
	GDC.customer_key,
	GDC.first_name,
	GDC.last_name
)t
WHERE RANKING <=10

-- find the lowest 3 customers who order placed 
SELECT TOP 3
	C.customer_key,
	C.first_name,
	C.last_name,
	COUNT(DISTINCT order_number) total_sales
FROM gold.fact_sales	F
LEFT JOIN gold.dim_customers C
	ON F.customer_key = C.customer_key
GROUP BY 
	C.customer_key,
	C.first_name,
	C.last_name
ORDER BY COUNT(DISTINCT order_number)

-- what are the 5 worst-performing products in terms of sales?
SELECT	TOP 5
	GDP.product_name,
	SUM(GFS.sales_amount) total_sales
FROM gold.fact_sales AS GFS
LEFT JOIN gold.dim_products AS GDP
	ON GFS.product_key = GDP.product_key
GROUP BY GDP.product_name
ORDER BY SUM(GFS.sales_amount)	ASC
