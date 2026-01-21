/*
====================================================
 Project: ADAM STORE – Data Warehouse
 Layer  : Bronze Layer
 Purpose:
   This script is responsible for creating tables 
   in the Bronze layer, which stores raw data coming 
   directly from source systems such as CRM and ERP.
   
   The Bronze layer keeps data in its original format 
   without transformations, to be used later in the 
   Silver and Gold layers.

 What this script does:
   - Creates all Bronze tables
   - Prepares the structure to receive raw CSV files
   - Supports data loading using BULK INSERT

 Author: Dina
 Date  : 2026-01-21
====================================================
*/

IF OBJECT_ID ('Bronze.crm_cust_info', 'U') IS NOT NULL
   DROP TABLE Bronze.crm_cust_info;

CREATE Table Bronze.crm_cust_info 
(
cst_id INT,
cst_key VARCHAR (50),
cst_firstname VARCHAR (50),
cst_lastname VARCHAR (50),
cst_marital_status VARCHAR (50),
cst_gndr VARCHAR  (50),
cst_create_date DATE
);

IF OBJECT_ID ('Bronze.crm_prd_info', 'U') IS NOT NULL
   DROP TABLE Bronze.crm_prd_info;
CREATE Table Bronze.crm_prd_info
(
prd_id INT,
prd_key VARCHAR(50),
prd_nm VARCHAR(50),
prd_cost INT,
prd_line VARCHAR(10),
prd_start_dt DATE,
prd_end_dt DATE
);


IF OBJECT_ID ('Bronze.crm_sales_details', 'U') IS NOT NULL
   DROP TABLE Bronze.crm_sales_details;
CREATE Table Bronze.crm_sales_details 
(
sls_ord_num VARCHAR (50),
sls_prd_key VARCHAR (50),
sls_cust_id INT,
sls_order_dt INT,
sls_ship_dt INT,
sls_due_dt INT,
sls_sales INT,
sls_quantity INT,
sls_price INT
);

IF OBJECT_ID ('Bronze.erp_CUST_AZ12', 'U') IS NOT NULL
   DROP TABLE Bronze.erp_CUST_AZ12;

CREATE Table Bronze.erp_CUST_AZ12
(
CID VARCHAR (50),
BDATE DATE,
GEN  VARCHAR (10)
);

IF OBJECT_ID ('Bronze.erp_LOC_A101', 'U') IS NOT NULL
   DROP TABLE Bronze.erp_LOC_A101;


CREATE Table Bronze.erp_LOC_A101
(
CID VARCHAR (50),
CNTRY VARCHAR (50)
);

IF OBJECT_ID ('Bronze.erp_PX_CAT_G1V2', 'U') IS NOT NULL
   DROP TABLE Bronze.erp_PX_CAT_G1V2;

CREATE Table Bronze.erp_PX_CAT_G1V2
(
ID VARCHAR (10),
CAT VARCHAR (50),
SUBCAT VARCHAR (50),
MAINTENANCE VARCHAR (50)
);
