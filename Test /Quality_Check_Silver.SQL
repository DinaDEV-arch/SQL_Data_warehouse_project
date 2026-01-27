/*
====================================================
 Topic: SQL Transformation & Data Cleaning
 Project: ADAM STORE – Data Warehouse

 Purpose:
   This section focuses on transforming raw and 
   semi-processed data into **clean, consistent, 
   and high-quality datasets**. Transformation and 
   cleaning are essential steps before loading 
   data into Silver or Gold layers.

 Key Activities:
   - Removing duplicates and null values
   - Standardizing data formats (dates, text, numbers)
   - Applying business rules and calculations
   - Aggregating data for reporting
   - Validating data through **quality checks**

 Quality Checks:
   - Checking for missing or inconsistent values
   - Verifying data types and constraints
   - Comparing source vs target counts
   - Ensuring data integrity across tables

 Usage:
   SQL queries and scripts are used to perform 
   transformations and enforce quality checks 
   before the data is consumed for analytics.

====================================================
*/

--Check for null or duplicate in praimary key 
--Expectation: No Result
select cst_id,
count (*)
from Silver.crm_cust_info
group by cst_id 
having count (*) > 1 or cst_id  is null;
--------


select prd_id,
count (*)
from Silver.crm_prd_info
group by prd_id
having count (*) > 1 or prd_id is null;
--------

-- check unwanted spaces
--Expectation: No Result
SELECT cst_firstname
FROM Silver.crm_cust_info
where cst_firstname != trim(cst_firstname);

SELECT cst_lastname
FROM Silver.crm_cust_info
where cst_lastname != trim(cst_lastname);

SELECT prd_nm
FROM Silver.crm_prd_info
where prd_nm != trim(prd_nm);

SELECT sls_ord_num
FROM Silver.crm_sales_details
where sls_ord_num != trim(sls_ord_num);

select *
from Bronze.erp_PX_CAT_G1V2
where CAT != Trim (CAT ) or SUBCAT != Trim (SUBCAT ) or MAINTENANCE != Trim (MAINTENANCE )

--- check for Null or Negative Numbers 
--Expectation: No Result
SELECT prd_cost
FROM Silver.crm_prd_info
where prd_cost <0 or  prd_cost is null;



-- Date Standardization and Consistency
Select Distinct Cst_Gndr
from Silver.crm_cust_info

Select Distinct cst_marital_status
from Silver.crm_cust_info

Select Distinct prd_line
from Silver.crm_prd_info

select Distinct
sls_sales,
sls_quantity,
sls_price,
sls_ord_num
from Silver.crm_sales_details
where  sls_sales != sls_quantity * sls_price 
      or sls_sales is null or sls_quantity is null or sls_price is null
      or sls_sales <=0 or sls_quantity <=0 or sls_price <=0
order by 
sls_quantity,
sls_sales,
sls_price,
sls_ord_num;

select distinct gen
from Silver.erp_CUST_AZ12


select distinct CNTRY
from Silver.erp_LOC_A101
order by CNTRY 

select distinct SUBCAT
from Bronze.erp_PX_CAT_G1V2
order by SUBCAT

--check for invalid date orders
select *
from Silver.crm_prd_info.crm_prd_info
where prd_end_dt < prd_start_dt
order by prd_end_dt,prd_start_dt  asc

-- identfiy out_of_rang_date
select distinct BDATE 
from Silver.erp_CUST_AZ12
where BDATE  < '1924-01-01' or  BDATE > getdate()


