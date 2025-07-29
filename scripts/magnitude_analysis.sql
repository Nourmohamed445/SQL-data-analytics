/*
===============================================================================
Magnitude Analysis
===============================================================================
Purpose:
    - To quantify data and group results by specific dimensions.
    - For understanding data distribution across categories.

SQL Functions Used:
    - Aggregate Functions: SUM(), COUNT(), AVG()
    - GROUP BY, ORDER BY
===============================================================================
*/

-- =============================================
 -- find total CUSTOMERS by COUNTRY 
SELECT
	country,
	COUNT(DISTINCT	customer_key) totalCustomers 
FROM gold.dim_customers
GROUP BY country
ORDER BY COUNT(DISTINCT	customer_key) DESC;

 -- find total CUSTOMERS by GENDER 
SELECT 
	gender,
	COUNT(DISTINCT	customer_key) totalCustomers 
FROM gold.dim_customers
GROUP BY gender
ORDER BY COUNT(DISTINCT	customer_key) DESC;

 -- find total PRODUCTS by CATEGORY
SELECT 
	category,
	COUNT(DISTINCT	product_name) total_products 
FROM gold.dim_products
GROUP BY category
ORDER BY COUNT(DISTINCT	product_name) DESC;


-- ===============================================
-- whats the average cost for each SUBcategory 
SELECT 
	subcategory,
	AVG(cost) average_cost_per_country
FROM gold.dim_products
GROUP BY subcategory
ORDER BY AVG(cost) DESC;

-- Whats the total revenue generated for each category
-- total revenue  = price * quantity(sold)
SELECT 
	GDP.category,
	SUM(GFS.price *	GFS.quantity) AS total_revenue
FROM gold.fact_sales	GFS
LEFT JOIN gold.dim_products	GDP
	ON GDP.product_key = GFS.product_key
GROUP BY category

SELECT 
	GDP.category,
	SUM(GFS.sales_amount) AS total_revenue
FROM gold.fact_sales	GFS
LEFT JOIN gold.dim_products	GDP
	ON GDP.product_key = GFS.product_key
GROUP BY category
ORDER BY SUM(sales_amount) DESC;

-- find the total revenue generated for each customer
SELECT 
	GDC.first_name,
	GDC.last_name,
	SUM(GFS.sales_amount) AS total_revenue
FROM gold.fact_sales	GFS
LEFT JOIN gold.dim_customers GDC
	ON GDC.customer_key = GFS.customer_key
GROUP BY GDC.first_name,GDC.last_name
ORDER BY SUM(GFS.sales_amount) DESC;

-- whats the total revenue  for each product line
SELECT 
	p.product_line,
	SUM(sales_amount) Total_revenue 
FROM gold.fact_sales	s
LEFT JOIN gold.dim_products	p
	on s.product_key = p.product_key
GROUP BY p.product_line
ORDER BY SUM(sales_amount) DESC;

-- whats the total customers  for each status
SELECT 
	marital_status,
	count(customer_key) total_customer
FROM gold.dim_customers
GROUP BY marital_status
ORDER BY count(customer_key) DESC;
