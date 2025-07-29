/*
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:
    This script creates a new database named 'DataWarehouseAnalytics' after checking if it already exists. 
    If the database exists, it is dropped and recreated. Additionally, this script creates a schema called gold
	
WARNING:
    Running this script will drop the entire 'DataWarehouseAnalytics' database if it exists. 
    All data in the database will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.
*/

USE master;
GO

-- Drop and recreate the 'DataWarehouseAnalytics' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouseAnalytics')
BEGIN
    ALTER DATABASE DataWarehouseAnalytics SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouseAnalytics;
END;

-- Create the 'DataWarehouseAnalytics' database
CREATE DATABASE DataWarehouseAnalytics;
GO

-- use our database we just created 
USE DataWarehouseAnalytics;
GO

-- Create Schemas
-- if there is no schema called "gold" in the database server schemas 
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'gold')
BEGIN
	-- then do create schema with gold name
    EXEC('CREATE SCHEMA gold');
END;



--************************************* table : gold.dim_customers ******************************** --
-- check if there is a table called dim customers exists
IF OBJECT_ID('gold.dim_customers','U') IS NOT NULL
	DROP TABLE gold.dim_customers;
GO
-- if not then create the table 
CREATE TABLE gold.dim_customers(
	customer_key			int,
	customer_id				int,
	customer_number			nvarchar(50),
	first_name				nvarchar(50),
	last_name				nvarchar(50),
	country					nvarchar(50),
	marital_status			nvarchar(50),
	gender					nvarchar(50),
	birthdate				date,
	create_date				date
);
GO



--************************************* table : gold.dim_products ******************************** --
-- check if there is a table called dim products exists
IF OBJECT_ID('gold.dim_products','U') IS NOT NULL
	DROP TABLE gold.dim_products;
GO

-- if not then create the table
CREATE TABLE gold.dim_products(
	product_key			int ,
	product_id			int ,
	product_number		nvarchar(50) ,
	product_name		nvarchar(50) ,
	category_id			nvarchar(50) ,
	category			nvarchar(50) ,
	subcategory			nvarchar(50) ,
	maintenance			nvarchar(50) ,
	cost				int,
	product_line		nvarchar(50),
	start_date			date 
);
GO



--************************************* table : gold.fact_sales ******************************** --
-- check if there is a table called fact_sales exists
IF OBJECT_ID('gold.fact_sales','U') IS NOT NULL
	DROP TABLE gold.fact_sales;
GO

-- if not then create the table
CREATE TABLE gold.fact_sales(
	order_number			nvarchar(50),
	product_key				int,
	customer_key			int,
	order_date				date,
	shipping_date			date,
	due_date				date,
	sales_amount			int,
	quantity				tinyint,
	price					int 
);
GO

