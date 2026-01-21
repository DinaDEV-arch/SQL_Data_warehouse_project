/*
====================================================
 Procedure Name: load_Bronze
 Project       : ADAM STORE – Data Warehouse
 Layer         : Bronze Layer

 Purpose:
   This stored procedure is responsible for loading 
   raw data from CSV files into the Bronze layer tables.
   It uses BULK INSERT to transfer data directly from 
   source files (CRM / ERP) into staging tables without 
   transformation.

 What this procedure does:
   - Loads CSV files into Bronze tables
   - Tracks start and end time of each load
   - Prints status messages for each step
   - Handles errors using TRY...CATCH

 Usage Example:
   EXEC load_Bronze;

 Author: Dina
 Date  : 2026-01-21
====================================================
*/

CREATE OR ALTER PROCEDURE Bronze.load_Bronze AS 
BEGIN
     DECLARE @START_TIME DATETIME, @END_TIME DATETIME, @Batch_Start_time DATETIME, @Batch_end_time DATETIME;
     BEGIN TRY
	 SET @Batch_Start_time = GETDATE ();
PRINT '============================================';
PRINT 'Loading Bronze layer';
PRINT '============================================';

PRINT '----------------------------------------------';
PRINT 'Loading CRM System';
PRINT '-----------------------------------------------';

SET @START_TIME = GETDATE ();
PRINT '>> Truncating Table: Bronze.crm_cust_info';
TRUNCATE TABLE Bronze.crm_cust_info;

PRINT '>> Incerting Data into: Bronze.crm_cust_info';
BULK INSERT Bronze.crm_cust_info
FROM 'C:\Data\SQL\Adam Store\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
WITH (
       FIRSTROW = 2,
	   FIELDTERMINATOR = ',',
	   TABLOCK
	   );
SET @END_TIME = GETDATE ();
PRINT'>> Load Duration:' + CAST(DATEDIFF(Second,@Start_time,@End_Time) AS VARCHAR) +'Seconds';
PRINT '------------------------------------------------------------------------------------------';

SET @START_TIME = GETDATE ();
PRINT '>> Truncating Table: Bronze.crm_prd_info';
TRUNCATE TABLE Bronze.crm_prd_info;

PRINT '>> Incerting Data into: Bronze.crm_prd_info';
BULK INSERT Bronze.crm_prd_info
FROM 'C:\Data\SQL\Adam Store\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
WITH (
       FIRSTROW = 2,
	   FIELDTERMINATOR = ',',
	   TABLOCK
	   );
SET @END_TIME = GETDATE ();
PRINT'>> Load Duration:' + CAST(DATEDIFF(Second,@Start_time,@End_Time) AS VARCHAR) +'Seconds';
PRINT '------------------------------------------------------------------------------------------';


SET @START_TIME = GETDATE ();
PRINT '>> Truncating Table: Bronze.crm_sales_details';
TRUNCATE TABLE Bronze.crm_sales_details;

PRINT '>> Incerting Data into: Bronze.crm_sales_details';
BULK INSERT Bronze.crm_sales_details
FROM 'C:\Data\SQL\Adam Store\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
WITH (
       FIRSTROW = 2,
	   FIELDTERMINATOR = ',',
	   TABLOCK
	   );
SET @END_TIME = GETDATE ();
PRINT'>> Load Duration:' + CAST(DATEDIFF(Second,@Start_time,@End_Time) AS VARCHAR) +'Seconds';
PRINT '------------------------------------------------------------------------------------------';

PRINT '----------------------------------------------';
PRINT 'Loading ERP System';
PRINT '-----------------------------------------------';	  

SET @START_TIME = GETDATE ();
PRINT '>> Truncating Table: Bronze.erp_CUST_AZ12';
TRUNCATE TABLE Bronze.erp_CUST_AZ12; ---- 1 lasr row

PRINT '>> Incerting Data into: Bronze.erp_CUST_AZ12';
BULK INSERT Bronze.erp_CUST_AZ12
FROM 'C:\Data\SQL\Adam Store\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
WITH (
       FIRSTROW = 2,
	   FIELDTERMINATOR = ',',
	   TABLOCK
	   );
SET @END_TIME = GETDATE ();
PRINT'>> Load Duration:' + CAST(DATEDIFF(Second,@Start_time,@End_Time) AS VARCHAR) +'Seconds';
PRINT '------------------------------------------------------------------------------------------';

SET @START_TIME = GETDATE ();
PRINT '>> Truncating Table: Bronze.erp_LOC_A101';
TRUNCATE TABLE Bronze.erp_LOC_A101; 

PRINT '>> Incerting Data into: Bronze.erp_LOC_A101';
BULK INSERT Bronze.erp_LOC_A101
FROM 'C:\Data\SQL\Adam Store\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
WITH (
       FIRSTROW = 2,
	   FIELDTERMINATOR = ',',
	   TABLOCK
	   );
SET @END_TIME = GETDATE ();
PRINT'>> Load Duration:' + CAST(DATEDIFF(Second,@Start_time,@End_Time) AS VARCHAR) +'Seconds';
PRINT '------------------------------------------------------------------------------------------';

SET @START_TIME = GETDATE ();
PRINT '>> Truncating Table: Bronze.erp_PX_CAT_G1V2';
TRUNCATE TABLE Bronze.erp_PX_CAT_G1V2;

PRINT '>> Incerting Data into: Bronze.erp_PX_CAT_G1V2';
BULK INSERT Bronze.erp_PX_CAT_G1V2
FROM 'C:\Data\SQL\Adam Store\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
WITH (
       FIRSTROW = 2,
	   FIELDTERMINATOR = ',',
	   TABLOCK
	   );
SET @END_TIME = GETDATE ();
PRINT'>> Load Duration:' + CAST(DATEDIFF(Second, @Start_time, @End_Time) AS VARCHAR) + 'Seconds';
PRINT '------------------------------------------------------------------------------------------';

SET @Batch_end_time = GETDATE ();
PRINT'==================================================================';
PRINT'Loading Bronze layer is complete';
PRINT '>> Total Load Duration:' + CAST(DATEDIFF(Second, @Batch_end_time, @Batch_end_time) AS VARCHAR) + 'Seconds';
PRINT'==================================================================';


	 END TRY
	 BEGIN CATCH
	 PRINT '-----------------------------------------------'
	 PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
	 PRINT 'ERROR MESSAGE' + ERROR_MESSAGE ();
	 PRINT 'ERROR MESSAGE' + CAST (ERROR_NUMBER ()AS VARCHAR);
	 PRINT '------------------------------------------------'
	 END CATCH 
END

