IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO
create view gold.fact_sales as
select
	sd.sls_ord_num as order_number,
	dp.product_key,
	dc.customer_key,
	sd.sls_order_date as order_date,
	sd.sls_ship_date as shipping_date,
	sd.sls_due_date as due_date,
	sd.sls_sales as sales_amount,
	sd.sls_quantity as quantity,
	sd.sls_price as price
from silver.crm_sales_details as sd
left join gold.dim_customers as dc
on sd.sls_cust_id = dc.customer_id
left join gold.dim_products as dp
on dp.product_number = sd.sls_prd_key

--------------------------------------------------------------
  IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO
create view gold.dim_products as
select 
	ROW_NUMBER() over(order by pn.prd_start_dt,pn.prd_key) as product_key,
	pn.prd_id as product_id ,
	pn.prd_key as product_number ,
	pn.prd_nm as product_name,
	pn.cat_id as category_id,
	px.cat as category,
	px.subcat as subcategory,
	px.maintenance,
	pn.prd_cost as cost,
	pn.prd_line as product_line,
	pn.prd_start_dt as start_date
from silver.crm_prd_info as pn
left join silver.erp_px_cat_g1v2 as px
on pn.cat_id = px.id
where pn.prd_end_dt is null --filter historical data
