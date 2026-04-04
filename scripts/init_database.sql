/*
Script purpose:
    This Script will creates a new database named 'DataWarehouse' after checking if it already exists. 
    If exist it will drop it and recreate it again.
    And it creates the 3 new schemas within the database: 'bronze', 'silver' and 'gold'.
Warning:
    Running the below script will dropdown the data base exists with the name DataWarehouse. 
    Proceed with caution and ensure you have proper backups before running this scrips.

USE master;
GO

-- Dop and recreate the database 'DataWarehouse'
IF EXIST (SELECT 1 FROM SYS.databases WHERE name = 'DataWarehouse')
BEGIN
  ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
  DROP DATABASE DataWarehouse;
END;
GO

-- Create the 'DataWarehouse' database
CREATE DATABASE DataWarehouse;

USE DataWarehouse;
GO

-- Create Schema
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO
