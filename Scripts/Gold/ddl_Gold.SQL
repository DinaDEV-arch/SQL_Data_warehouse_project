



--===================================================
-- Creat Dimention: gold.dim_customers
--===================================================

IF OBJECT_ID ('gold.dim_customers', 'v') IS NOT NULL
   DROP TABLE gold.dim_customers
   GO
Create view gold.dim_customers as 
select 
row_number () over (order by cst_id) as customer_key,
ci.cst_id as customer_id,
ci.cst_key as customer_number,
ci.cst_firstname as first_name,
ci.cst_lastname as last_name,
er.BDATE as birth_data,
case when  ci.cst_gndr != 'N/A' then  ci.cst_gndr
else coalesce (er.GEN, 'N/A')
end as gender,
ci.cst_marital_status as marital_status ,
le.CNTRY as country,
ci.cst_create_date as create_date
from Silver.crm_cust_info ci
left join Silver.erp_CUST_AZ12 er 
on ci.cst_key = er.CID
left join Silver.erp_LOC_A101 le
on ci.cst_key= le.CID


--===================================================
-- Creat Dimention: gold.dim_products
--===================================================
IF OBJECT_ID ('gold.dim_products', 'v') IS NOT NULL
   DROP TABLE gold.dim_products
   GO
Create view gold.dim_products as 
select 
row_number () over ( order by p.prd_start_dt,p.prd_key) as product_key,
p.prd_id as product_id,
p.prd_key as product_number,
p.prd_nm as product_name,
p.cat_id as category_id,
ep.CAT as category,
ep.SUBCAT as subcategory,
ep.MAINTENANCE as maintenance,
p.prd_line as product_line,
p.prd_cost as Product_cost,
p.prd_start_dt as start_date 
from Silver.crm_prd_info p
left join Silver.erp_PX_CAT_G1V2 ep
on p.cat_id = ep.ID
where prd_end_dt is null -- filter out all historical data 


--===================================================
-- Creat Fact: gold.fact_sales
--===================================================
IF OBJECT_ID ('gold.fact_sales', 'v') IS NOT NULL
   DROP TABLE gold.fact_sales
   GO
create view gold.fact_sales as 
select 
ss.sls_ord_num  as order_number,
p.product_key,
c.customer_key,
ss.sls_order_dt as order_date,
ss.sls_ship_dt as shipping_date ,
ss.sls_due_dt as due_date,
ss.sls_Sales as sales_amount,
ss.sls_quantity as quantity,
ss.sls_price as price
from Silver.crm_sales_details ss
left join gold.dim_products p
on ss.sls_prd_key = p.product_number
left join gold.dim_customers c
on ss.sls_cust_id = c.customer_id
