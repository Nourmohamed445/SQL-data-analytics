/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - To compare performance or metrics across dimensions or time periods.
    - To evaluate differences between categories.
    - Useful for A/B testing or regional comparisons.

SQL Functions Used:
    - SUM(), AVG(): Aggregates values for comparison.
    - Window Functions: SUM() OVER() for total calculations.
===============================================================================
*/

USE DataWarehouseAnalytics;
-- which category contribute the most to overall sales?

-- with CTE
WITH part_to_whole AS (
	SELECT 
		  p.category,
		  SUM(f.sales_amount) category_sales
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_products p
	    ON f.product_key = p.product_key
	GROUP BY category
)
SELECT
	  category,
	  category_sales,
	  SUM(category_sales) OVER() Overall_sales,
	  round((CAST(category_sales AS float) / SUM(category_sales) OVER())  * 100,2 )AS percentage_sales
FROM part_to_whole w

-- with cte and subquery
WITH categorys_sales AS (
	SELECT 
		  p.category,
		  SUM(f.sales_amount) category_sales
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_products p
	    ON f.product_key = p.product_key
	GROUP BY category
)
SELECT
	    category,
	    category_sales,
	    (SELECT SUM(sales_amount) FROM gold.fact_sales) total_sales,
	CONCAT( round( CAST(category_sales AS float) / (SELECT SUM(sales_amount) FROM gold.fact_sales)  * 100,2 ), '%' ) AS percentage_sales
FROM categorys_sales w
ORDER BY category_sales DESC


-- which product had been ordered more than the others?
SELECT 
    	product_name,
    	product_count_order,
    	[TOTAL ORDERS],
    	CONCAT(ROUND(CAST(product_count_order AS float) / [TOTAL ORDERS] * 100 , 2) , '%') order_precentage_per_product
FROM(
    SELECT 
        	product_name,
        	COUNT(DISTINCT order_number)	product_count_order,
        	(SELECT COUNT(DISTINCT order_number) FROM gold.fact_sales) AS [TOTAL ORDERS]
    FROM gold.fact_sales AS F
    LEFT JOIN gold.dim_products AS P
    		ON	F.product_key = P.product_key
    GROUP BY product_name
)t
ORDER BY [TOTAL ORDERS]


-- compare sales per category for the year over the total sales per this year
SELECT 
    	year,
    	category,
    	sales_per_year,
    	[TOTAL SALES],
    	CONCAT(ROUND(CAST(sales_per_year AS float) / [TOTAL SALES] * 100 ,2), '%') precentage_sales_per_year
FROM 
(
SELECT
    	YEAR(order_date) year,
    	category,
    	SUM(sales_amount) sales_per_year,
    	SUM(SUM(sales_amount)) over() [TOTAL SALES]
FROM gold.fact_sales	F
INNER JOIN gold.dim_products	P
  	ON F.product_key = P.product_key
WHERE YEAR(order_date) IS NOT NULL AND YEAR(order_date) = 2014  
GROUP BY 
    	YEAR(order_date),
      category
)t
ORDER BY precentage_sales_per_year DESC
