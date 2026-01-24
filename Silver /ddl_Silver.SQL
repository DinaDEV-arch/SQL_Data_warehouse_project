

IF OBJECT_ID ('Silver.crm_cust_info', 'U') IS NOT NULL
   DROP TABLE Silver.crm_cust_info;

CREATE Table Silver.crm_cust_info 
(
cst_id INT,
cst_key VARCHAR (50),
cst_firstname VARCHAR (50),
cst_lastname VARCHAR (50),
cst_marital_status VARCHAR (50),
cst_gndr VARCHAR  (50),
cst_create_date DATE,
dwh_create_date DATETIME2 DEFAULT GETDATE ()
);

IF OBJECT_ID ('Silver.crm_prd_info', 'U') IS NOT NULL
   DROP TABLE Silver.crm_prd_info;
CREATE Table Silver.crm_prd_info
(
prd_id INT,
cat_id VARCHAR(50),
prd_key VARCHAR(50),
prd_nm VARCHAR(50),
prd_cost INT,
prd_line VARCHAR(50),
prd_start_dt DATE,
prd_end_dt DATE,
dwh_create_date DATETIME2 DEFAULT GETDATE ()
);


IF OBJECT_ID ('Silver.crm_sales_details', 'U') IS NOT NULL
   DROP TABLE Silver.crm_sales_details;
CREATE Table Silver.crm_sales_details 
(
sls_ord_num VARCHAR (50),
sls_prd_key VARCHAR (50),
sls_cust_id INT,
sls_order_dt DATE,
sls_ship_dt DATE,
sls_due_dt DATE,
sls_Sales INT,
sls_quantity INT,
sls_price INT,
dwh_create_date DATETIME2 DEFAULT GETDATE ()
);

IF OBJECT_ID ('Silver.erp_CUST_AZ12', 'U') IS NOT NULL
   DROP TABLE Silver.erp_CUST_AZ12;
CREATE Table Silver.erp_CUST_AZ12
(
CID VARCHAR (50),
BDATE DATE,
GEN  VARCHAR (10),
dwh_create_date DATETIME2 DEFAULT GETDATE ()
);

IF OBJECT_ID ('Silver.erp_LOC_A101', 'U') IS NOT NULL
   DROP TABLE Silver.erp_LOC_A101;
CREATE Table Silver.erp_LOC_A101
(
CID VARCHAR (50),
CNTRY VARCHAR (50),
dwh_create_date DATETIME2 DEFAULT GETDATE ()
);

IF OBJECT_ID ('Silver.erp_PX_CAT_G1V2', 'U') IS NOT NULL
   DROP TABLE Silver.erp_PX_CAT_G1V2;
CREATE Table Silver.erp_PX_CAT_G1V2
(
ID VARCHAR (10),
CAT VARCHAR (50),
SUBCAT VARCHAR (50),
MAINTENANCE VARCHAR (50),
dwh_create_date DATETIME2 DEFAULT GETDATE ()
);

CREATE OR ALTER PROCEDURE Silver.load_Silver AS 
BEGIN
     DECLARE @START_TIME DATETIME, @END_TIME DATETIME, @Batch_Start_time DATETIME, @Batch_end_time DATETIME;
     BEGIN TRY
	 SET @Batch_Start_time = GETDATE ();
PRINT '============================================';
PRINT 'Loading Silver layer';
PRINT '============================================';

PRINT '----------------------------------------------';
PRINT 'Loading CRM System';
PRINT '-----------------------------------------------';

SET @START_TIME = GETDATE ();
PRINT '>> Truncating Table: Silver.crm_cust_info';
TRUNCATE TABLE Silver.crm_cust_info;

PRINT '>> Incerting Data into: Silver.crm_cust_info';
BULK INSERT Silver.crm_cust_info
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
PRINT '>> Truncating Table: Silver.crm_prd_info';
TRUNCATE TABLE Silver.crm_prd_info;

PRINT '>> Incerting Data into: Silver.crm_prd_info';
BULK INSERT Silver.crm_prd_info
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
PRINT '>> Truncating Table: Silver.crm_sales_details';
TRUNCATE TABLE Silver.crm_sales_details;

PRINT '>> Incerting Data into: Silver.crm_sales_details';
BULK INSERT Silver.crm_sales_details
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
PRINT '>> Truncating Table: Silver.erp_CUST_AZ12';
TRUNCATE TABLE Silver.erp_CUST_AZ12; ---- 1 lasr row

PRINT '>> Incerting Data into: Silver.erp_CUST_AZ12';
BULK INSERT Silver.erp_CUST_AZ12
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
PRINT '>> Truncating Table: Silver.erp_LOC_A101';
TRUNCATE TABLE Silver.erp_LOC_A101; 

PRINT '>> Incerting Data into: Silver.erp_LOC_A101';
BULK INSERT Silver.erp_LOC_A101
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
PRINT '>> Truncating Table: Silver.erp_PX_CAT_G1V2';
TRUNCATE TABLE Silver.erp_PX_CAT_G1V2;

PRINT '>> Incerting Data into: Silver.erp_PX_CAT_G1V2';
BULK INSERT Silver.erp_PX_CAT_G1V2
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
PRINT'Loading Silver layer is complete';
PRINT '>> Total Load Duration:' + CAST(DATEDIFF(Second, @Batch_end_time, @Batch_end_time) AS VARCHAR) + 'Seconds';
PRINT'==================================================================';


	 END TRY
	 BEGIN CATCH
	 PRINT '-----------------------------------------------'
	 PRINT 'ERROR OCCURED DURING LOADING Silver LAYER'
	 PRINT 'ERROR MESSAGE' + ERROR_MESSAGE ();
	 PRINT 'ERROR MESSAGE' + CAST (ERROR_NUMBER ()AS VARCHAR);
	 PRINT '------------------------------------------------'
	 END CATCH 
END
