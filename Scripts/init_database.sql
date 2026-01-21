-- =====================================================
--  Project: ADAM_STORE Database Setup
--  Description:
--    This script creates a new database called ADAM_STORE
--    It first checks if a database with the same name exists
--    If it exists, it deletes it before creating a new one
--    Then it creates three schemas: bronze, silver, and gold
-- =====================================================

-- Use the master database
USE master;

--  DROP DATABASE IF EXISTS
--  This will delete the database ADAM_STORE if it already exist

IF EXISTS (SELECT name FROM sys.databases WHERE name = N'ADAM_STORE')
BEGIN
    DROP DATABASE ADAM_STORE;
    PRINT 'Database ADAM_STORE dropped successfully.';
END
GO

-- Create a new database called ADAM_STORE
CREATE DATABASE ADAM_STORE;

-- Switch to ADAM_STORE database
USE ADAM_STORE;

-- Create schemas
-- Bronze schema
CREATE SCHEMA bronze;
GO

-- Silver schema
CREATE SCHEMA Silver;
GO

-- Gold schema
CREATE SCHEMA Gold;
GO
