-- *********************** insert data into dim_customers table ***********************--
IF OBJECT_ID('gold.dim_customers','U') IS NOT NULL
	BEGIN
		TRUNCATE TABLE gold.dim_customers;
	END
GO

BULK INSERT gold.dim_customers
FROM 
	'E:\Noor\SQL projects\sql-data-analytics-project\datasets\csv-files\gold.dim_customers.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
); 
GO	

-- *********************** insert data into dim_customers table ***********************--
IF OBJECT_ID('gold.dim_products','U') IS NOT NULL
	BEGIN
		TRUNCATE TABLE gold.dim_products;
	END
GO

BULK INSERT gold.dim_products
FROM 
	'E:\Noor\SQL projects\sql-data-analytics-project\datasets\csv-files\gold.dim_products.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);
GO

-- *********************** insert data into dim_customers table ***********************--
IF OBJECT_ID('gold.fact_sales','U') IS NOT NULL
	BEGIN
		TRUNCATE TABLE gold.fact_sales;
	END
GO

BULK INSERT gold.fact_sales
FROM 
	'E:\Noor\SQL projects\sql-data-analytics-project\datasets\csv-files\gold.fact_sales.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);
