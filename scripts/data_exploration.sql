/*
===============================================================================
Database Exploration
===============================================================================
Purpose:
    - To explore the structure of the database, including the list of tables and their schemas.
    - To inspect the columns and metadata for specific tables.

Table Used:
    - INFORMATION_SCHEMA.TABLES
    - INFORMATION_SCHEMA.COLUMNS
===============================================================================
*/
-- explore the database :
--	explore all objects in the database
SELECT 
	TABLE_CATALOG,	
	TABLE_NAME,
	TABLE_SCHEMA,
	TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES order by TABLE_SCHEMA

--	explore all columns that exists in our database for a specific table 
SELECT 
	TABLE_CATALOG,
	TABLE_SCHEMA,
	TABLE_NAME,
	COLUMN_NAME,
	IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS  WHERE TABLE_NAME = 'dim_produccts'
