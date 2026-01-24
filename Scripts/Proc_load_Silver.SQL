/*
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
🥈 Silver Layer

The Silver Layer contains cleaned and standardized data transformed from the Bronze Layer.
It applies data quality rules, basic transformations, and business logic to prepare data for analytics and reporting.

Source: Bronze Layer
Load Strategy: Full Load (TRUNCATE + INSERT) 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
*/
 CREATE OR ALTER PROCEDURE Silver.load_Silver AS 
 BEGIN
 DECLARE @START_TIME DATETIME, @END_TIME DATETIME, @Batch_Start_time DATETIME, @Batch_end_time DATETIME;
 BEGIN TRY
 SET @Batch_Start_time = GETDATE ();
 SET @START_TIME = GETDATE ();
PRINT '============================================';
PRINT 'Loading Silver layer';
PRINT '============================================';

PRINT '----------------------------------------------';
PRINT 'Loading CRM System';
PRINT '-----------------------------------------------';

/*
Silver Layer – crm_cust_info

Source: Bronze.erp_CUST_AZ12

Transformations:
- Trim cst_firstname, cst_lastname
- Trim cst_marital_status and cst_gndr
- Marital status: S → Single, M → Married, else N/A
- Gender: M → Male, F → Female, else N/A
- Remove duplicates on cst_id

Load: Full Load (TRUNCATE + INSERT)
*/

PRINT '>> Truncationg Table: Silver.crm_cust_info';
Truncate table Silver.crm_cust_info
PRINT '>> Inserting data into: Silver.crm_cust_info';
INSERT INTO Silver.crm_cust_info
(
cst_id,
cst_key,
cst_firstname,
cst_lastname,
cst_marital_status,
cst_gndr,
cst_create_date)
select 
cst_id,
cst_key,
Trim (cst_firstname) As cst_firstname,
Trim (cst_lastname) AS cst_lastname,
Case When upper(trim (cst_marital_status)) = 'S' then 'Single'
     When upper(trim (cst_marital_status)) = 'M' then 'Married'
Else 'N/A' End as cst_marital_status, 
Case When upper(trim (cst_gndr)) = 'M' then 'Male'
     When upper(trim (cst_gndr)) = 'F' then 'Female'
Else 'N/A' End as cst_gndr,
cst_create_date
from 
(
SELECT *,
row_number() over (partition by cst_id order by cst_create_date desc) as flag_Last
FROM Bronze.crm_cust_info ) t
where flag_Last = 1;
SET @END_TIME = GETDATE ();
PRINT'>> Load Duration:' + CAST(DATEDIFF(Second,@Start_time,@End_Time) AS VARCHAR) +'Seconds';
PRINT '------------------------------------------------------------------------------------------';

/*
Silver Layer – Silver.crm_prd_info

Source: Bronze.bronze.crm_prd_table

Transformations:
- Replace '-' with '_' in prd_key
- Create prd_key_sub: first 5 characters of prd_key
- Create prd_key_len: length of prd_key
- Replace null prd_cost with 0
- Uppercase and trim prd_line
- Map prd_line values: 
    'M' → 'Mountain', 
    'R' → 'Road', 
    'S', 'T' → 'Other Sales', 
    else 'N/A'
- Map prd_type: 'Touring' else 'N/A'
- Ensure prd_end_dt is after prd_start_dt; if not, set to NULL

Load: Full Load (TRUNCATE + INSERT)
*/

SET @START_TIME = GETDATE ();
PRINT '>> Truncationg Table: Silver.crm_prd_info';
Truncate table Silver.crm_prd_info
PRINT '>> Inserting data into: Silver.crm_prd_info';
INSERT INTO Silver.crm_prd_info
(
prd_id,
cat_id,
prd_key,
prd_nm ,
prd_cost,
prd_line,
prd_start_dt,
prd_end_dt)
Select 
prd_id,
replace(substring (prd_key,1,5), '-','_') as cat_id,
substring(prd_key,7, len (prd_key)) as prd_key,
prd_nm ,
isnull (prd_cost,0) as prd_cost,
case when upper(trim (prd_line)) = 'M' then 'Mountain'
     when upper(trim (prd_line)) = 'R' then 'Road'
	 when upper(trim (prd_line)) = 'S' then 'Other Sales'
	 when upper(trim (prd_line)) = 'T' then 'Touring'
	 else 'N/A' end as prd_line,
prd_start_dt,
DATEADD(DAY,-1, lead (prd_start_dt) over (partition by prd_key order by prd_start_dt))
as prd_end_dt_test
from Bronze.crm_prd_info;
SET @END_TIME = GETDATE ();
PRINT'>> Load Duration:' + CAST(DATEDIFF(Second,@Start_time,@End_Time) AS VARCHAR) +'Seconds';
PRINT '------------------------------------------------------------------------------------------';

/*
Silver Layer –Silver.crm_sales_details

Source: Bronze.bronze.crm_sales_details

Transformations:
- Convert sls_order_dt:
    - If value = 0 or length != 8 → set NULL
    - Cast as DATE
- Convert sls_ship_dt:
    - If value = 0 or length != 8 → set NULL
    - Cast as DATE
- Convert sls_due_dt:
    - If value = 0 or length != 8 → set NULL
    - Cast as DATE
- Recalculate sls_sales as: sls_quantity * sls_price
- Recalculate sls_price as: sls_sales / NULLIF(sls_quantity, 0)
  (avoid division by zero)

Load: Full Load (TRUNCATE + INSERT)
*/

PRINT '----------------------------------------------';
PRINT 'Loading ERP System';
PRINT '-----------------------------------------------';	
SET @START_TIME = GETDATE ();
PRINT '>> Truncationg Table: Silver.crm_sales_details';
Truncate table Silver.crm_sales_details
PRINT '>> Inserting data into: Silver.crm_sales_details';
INSERT INTO Silver.crm_sales_details
(
sls_ord_num,
sls_prd_key, 
sls_cust_id, 
sls_order_dt, 
sls_ship_dt,
sls_due_dt, 
sls_sales, 
sls_quantity, 
sls_price)
select 
sls_ord_num, 
sls_prd_key,
sls_cust_id,
case when sls_order_dt = 0 or len (sls_order_dt)!= 8 then Null
else cast (cast(sls_order_dt as varchar) as date)
end as  sls_order_dt,
case when sls_ship_dt = 0 or len (sls_ship_dt)!= 8 then Null
else cast (cast(sls_ship_dt as varchar) as date)
end as  sls_ship_dt, 
case when sls_due_dt = 0 or len (sls_due_dt)!= 8 then Null
else cast (cast(sls_due_dt as varchar) as date)  
end as sls_due_dt,
case when sls_sales is null or sls_sales <=0 or sls_sales!= sls_quantity * ABS(sls_price)
then sls_quantity * ABS(sls_price) 
else sls_sales  end as sls_sales, 
sls_quantity,
case when sls_price is null or sls_price <=0 
     then sls_sales / nullif (sls_quantity,0)
	 else sls_price  end as sls_price
from Bronze.crm_sales_details
SET @END_TIME = GETDATE ();
PRINT'>> Load Duration:' + CAST(DATEDIFF(Second,@Start_time,@End_Time) AS VARCHAR) +'Seconds';
PRINT '------------------------------------------------------------------------------------------';

/*
Silver Layer –Silver.erp_CUST_AZ12

Source: Bronze.bronze.erp_CUST_AZ12

Transformations:
- Filter CID values starting with 'NAS%' (substring match)
- Set BDATE to NULL if date is in the future
- Uppercase and trim gen
- Map gen values:
    'M' → 'Male'
    'F' → 'Female'
    else → 'N/A'

Load: Full Load (TRUNCATE + INSERT)
*/

SET @START_TIME = GETDATE ();
PRINT '>> Truncationg Table: Silver.erp_CUST_AZ12';
Truncate table Silver.erp_CUST_AZ12
PRINT '>> Inserting data into: Silver.erp_CUST_AZ12';
INSERT INTO Silver.erp_CUST_AZ12
(
CID,
BDATE, 
GEN)
select 
case when CID like 'NAS%' Then substring (CID,4,len(CID))
else CID end as CID,
case when BDATE < getdate () then Null 
else BDATE end as BDATE,
case when upper(trim(gen)) in ('F','Female') then 'Female' 
     when upper(trim(gen)) in ('M','Male') then 'Male'
	 else 'N/A' end gen 
from Bronze.erp_CUST_AZ12
SET @END_TIME = GETDATE ();
PRINT'>> Load Duration:' + CAST(DATEDIFF(Second,@Start_time,@End_Time) AS VARCHAR) +'Seconds';
PRINT '------------------------------------------------------------------------------------------';
/*
Silver Layer – Silver.erp_LOC_A101

Source: Bronze.bronze.erp_LOC_A101

Transformations:
- Replace '-' in CID with ' ' (space)
- Trim and map CNTRY values:
    'US', 'USA' → 'United States'
    'DE' → 'Germany'
    ' ' or NULL → 'N/A'

Load: Full Load (TRUNCATE + INSERT)
*/


SET @START_TIME = GETDATE ();
PRINT '>> Truncationg Table: Silver.erp_LOC_A101';
Truncate table Silver.erp_LOC_A101
PRINT '>> Inserting data into: Silver.erp_LOC_A101';
INSERT INTO Silver.erp_LOC_A101
(
CID,
CNTRY)
select 
Replace (CID ,'-', ' ') CID,
case when trim (CNTRY) in ('US','USA') then 'United States'
     when trim (CNTRY) = ('DE') then 'Germany'
	 when trim (CNTRY) = ' ' or (CNTRY) is null then 'N/A'
	 else trim (CNTRY) end as CNTRY
from Bronze.erp_LOC_A101
SET @END_TIME = GETDATE ();
PRINT'>> Load Duration:' + CAST(DATEDIFF(Second,@Start_time,@End_Time) AS VARCHAR) +'Seconds';
PRINT '------------------------------------------------------------------------------------------';

/*
Silver Layer – silver_customer_raw

Source: Bronze.bronze_customer_table

Transformations:
- None

Load: Full Load (TRUNCATE + INSERT)
*/

SET @START_TIME = GETDATE ();
PRINT '>> Truncationg Table: Silver.erp_PX_CAT_G1V2';
Truncate table Silver.erp_PX_CAT_G1V2
PRINT '>> Inserting data into: Silver.erp_PX_CAT_G1V2';
INSERT INTO Silver.erp_PX_CAT_G1V2
(
ID,
CAT,
SUBCAT,
MAINTENANCE)
select 
ID,
CAT,
SUBCAT,
MAINTENANCE
from Bronze.erp_PX_CAT_G1V2
     SET @END_TIME = GETDATE ();
	 PRINT'>> Load Duration:' + CAST(DATEDIFF(Second,@Start_time,@End_Time) AS VARCHAR) +'Seconds';
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
