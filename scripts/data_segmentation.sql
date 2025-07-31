/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - To group data into meaningful categories for targeted insights.
    - For customer segmentation, product categorization, or regional analysis.

SQL Functions Used:
    - CASE: Defines custom segmentation logic.
    - GROUP BY: Groups data into segments.
===============================================================================
*/
/*Segment products into cost ranges and 
count how many products fall into each segment*/

WITH CTE_product_cost_ranges AS 
(
SELECT	
	product_key,
	product_name,
	cost,
	case	WHEN cost >= 0 AND cost < 500 THEN 'Range 1'
            WHEN cost >= 500 AND cost < 1000 THEN 'Range 2'
            WHEN cost >= 1000 AND cost < 1500 THEN 'Range 3'
            ELSE 'Range 4'
	END cost_range
FROM gold.dim_products
)
SELECT
	cost_range,
	count(product_key) as products_number_per_range
FROM CTE_product_cost_ranges
GROUP BY cost_range;

-- ----------------------------------------------------------------------------------------------------------------   

/*Segment sales into segements and count how many customer fall into each segment*/
WITH customer_total_sales AS (
    SELECT 
        c.customer_key,
        SUM(f.sales_amount) AS total_sales
    FROM gold.fact_sales AS f
    INNER JOIN gold.dim_customers AS c
        ON c.customer_key = f.customer_key
    GROUP BY c.customer_key
),
customer_segmentations AS (
    SELECT 
        customer_key,
        total_sales,
        CASE 
            WHEN total_sales BETWEEN 0 AND 1000 THEN 'Segment 1'
            WHEN total_sales BETWEEN 1001 AND 2000 THEN 'Segment 2'
            WHEN total_sales BETWEEN 2001 AND 3000 THEN 'Segment 3'
            ELSE 'Segment 4'
        END AS sales_segmentation
    FROM customer_total_sales
)
SELECT 
    sales_segmentation,
    COUNT(customer_key) AS total_customers
FROM customer_segmentations
GROUP BY sales_segmentation
ORDER BY sales_segmentation;

-- ----------------------------------------------------------------------------------------------------------------

/*Group customers into three segments based on their spending behavior:
	- VIP: Customers with at least 12 months of history and spending more than €5,000.
	- Regular: Customers with at least 12 months of history but spending €5,000 or less.
	- New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group
*/
WITH cte_customer_details AS(
	SELECT 
		customer_key,
		SUM(sales_amount)	AS total_sales,
		MAX(order_date)		AS max_order_date,
		MIN(order_date)		AS min_order_date,
		DATEDIFF(month,MIN(order_date),MAX(order_date)) AS customer_life_span_history
	FROM gold.fact_sales
	GROUP BY customer_key
),
cte_lifespan_segmentionsn AS(
SELECT
	customer_key,
	total_sales,
	CASE	
		WHEN customer_life_span_history >= 12 AND total_sales > 5000 THEN 'VIP Customer'
		WHEN customer_life_span_history >= 12 AND total_sales <= 5000 THEN 'Regular Customer' 
		ELSE 'New Customer'
	END customer_level
FROM cte_customer_details
)
SELECT 
	customer_level,
	COUNT(customer_key)	[total customers]
FROM cte_lifespan_segmentionsn
GROUP BY customer_level
ORDER BY [total customers] DESC

    
-- ----------------------------------------------------------------------------------------------------------------
/*
    segment customers on how many diff - products bought already
    Variety Seekers: bought more than 15 different product
    Standard Buyers: between 6 - 15
    Low Variety: lower than  6
*/
WITH customer_variety AS (
    SELECT 
        customer_key,
        COUNT(DISTINCT product_key) AS product_variety
    FROM gold.fact_sales
    GROUP BY customer_key
),
segmented_customers AS (
    SELECT 
        customer_key,
        CASE 
            WHEN product_variety > 15 THEN 'Variety Seeker'
            WHEN product_variety BETWEEN 6 AND 15 THEN 'Standard Buyer'
            ELSE 'Low Variety'
        END AS variety_segment
    FROM customer_variety
)
SELECT 
    variety_segment,
    COUNT(*) AS customer_count
FROM segmented_customers
GROUP BY variety_segment;
