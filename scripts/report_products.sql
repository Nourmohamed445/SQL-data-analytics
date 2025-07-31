/*
===============================================================================
Product Report
===============================================================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average monthly revenue
===============================================================================
*/
 /*
===============================================================================
Product Report
===============================================================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average monthly revenue
===============================================================================
*/
-- =============================================================================
-- Create Report: gold.report_products
-- =============================================================================
IF OBJECT_ID('gold.report_products', 'V') IS NOT NULL
    DROP VIEW gold.report_products;
GO

CREATE VIEW gold.report_products AS
/*---------------------------------------------------------------------------
1) Base Query: Retrieves core columns from fact_sales and dim_products
---------------------------------------------------------------------------*/
WITH    cte_basic_query AS(
    SELECT 
        F.order_number,
        F.customer_key,
        F.order_date,
        F.sales_amount,
        f.quantity,
        P.product_key,
        P.product_number,
        P.category,
        P.subcategory,
        P.cost
    FROM gold.fact_sales AS F
    LEFT JOIN gold.dim_products P
        ON p.product_key = F.product_key
),
/*---------------------------------------------------------------------------
2) Product Aggregations: Summarizes key metrics at the product level
---------------------------------------------------------------------------*/
cte_products_aggregations AS(
SELECT  
        product_key,
        product_number,
        category,
        subcategory,
        cost,
        MAX(order_date) Last_sales_date,

        -- total orders 
        COUNT(DISTINCT order_number)   total_orders,
        -- total sales
        SUM(sales_amount)  total_sales,
        -- total quantity sold
        SUM(quantity)  total_quantity_sold,
        -- total customers (unique)
        COUNT(DISTINCT customer_key) total_customers,
        -- lifespan (in months)
        DATEDIFF(MONTH,MIN(order_date),MAX(order_date)) nr_of_active_months,
        --  average sales price
        ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity, 0)),1) AS avg_selling_price
FROM cte_basic_query
GROUP BY 
        product_key,
        product_number,
        category,
        subcategory,
        cost
)
/*---------------------------------------------------------------------------
  3) Final Query: Combines all product results into one output
---------------------------------------------------------------------------*/
SELECT 
        product_key,
        product_number,
        category,
        subcategory,
        cost,
        Last_sales_date,
        total_orders,
        total_sales,
        total_quantity_sold,
        avg_selling_price,
        total_customers,
        nr_of_active_months,
        -- Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
        CASE    WHEN total_sales > 50000 THEN 'High-Performers'
                WHEN total_sales < 10000 THEN 'Low-Performers'
                ELSE 'Mid-Range'
        END product_segments,
        -- recency (months since last sale)
        DATEDIFF(month,Last_sales_date,GETDATE())    AS recency,
        -- average order revenue (AOR)  = total_sales / total_orders
	    CASE 
		        WHEN total_orders = 0 THEN 0
		        ELSE total_sales / total_orders
	    END AS avg_order_revenue,
        -- average monthly revenue
       	CASE
		        WHEN nr_of_active_months = 0 THEN total_sales
		        ELSE total_sales / nr_of_active_months
	    END AS avg_monthly_revenue
FROM cte_products_aggregations
