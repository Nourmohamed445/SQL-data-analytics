-- cumulative analysis
-- :- its a good technique to check ig our project sales is growing or declining 
-- we use aggregate window functions 
-- we still work through date 

-- we are using it to mentor the goals how its growing , how its working to understand everything

-- ========================================
-- calculate the total sales per month and the running total sales over time

SELECT 
	due_date,
	total_sales,
	SUM(t.total_sales) OVER(PARTITION BY YEAR(due_date)ORDER BY t.due_date) running_total_sales
FROM (
SELECT 
	DATETRUNC(MONTH,due_date) due_date,
	SUM(sales_amount) AS total_sales
FROM gold.fact_sales
GROUP BY DATETRUNC(MONTH,due_date)
)t
ORDER BY due_date
