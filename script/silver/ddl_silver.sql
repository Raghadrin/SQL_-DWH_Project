IF OBJECT_ID('silver.crm_cust_info', 'U') IS NOT NULL 
    DROP TABLE silver.crm_cust_info;
CREATE TABLE silver.crm_cust_info (
    cust_id int,
    cust_key nvarchar(50),
    cust_firstname nvarchar(50),
    cust_lastname nvarchar(50),
    cust_material_status nvarchar(50),
    cust_gndr nvarchar(50),
    cust_create_date date,
    dwh_creation_dt datetime2 default getdate()
);

IF OBJECT_ID('silver.crm_prd_info', 'U') IS NOT NULL 
    DROP TABLE silver.crm_prd_info;
CREATE TABLE silver.crm_prd_info (
    prd_id          int,
    cat_id         nvarchar(50),
    prd_key         nvarchar(50),
    prd_nm          nvarchar(50),
    prd_cost        int,
    prd_line        nvarchar(50),
    prd_start_dt    date,
    prd_end_dt      date,
    dwh_creation_dt datetime2 default getdate()
);

IF OBJECT_ID('silver.crm_sales_details', 'U') IS NOT NULL 
    DROP TABLE silver.crm_sales_details;
CREATE TABLE silver.crm_sales_details (
    sls_ord_num nvarchar(50),
    sls_prd_key nvarchar(50),
    sls_cust_id int,
    sls_order_date date,
    sls_ship_date date,
    sls_due_date date,
    sls_sales int,
    sls_quantity int,
    sls_price int,
    dwh_creation_dt datetime2 default getdate()
);

IF OBJECT_ID('silver.erp_cust_az12', 'U') IS NOT NULL 
    DROP TABLE silver.erp_cust_az12;
CREATE TABLE silver.erp_cust_az12 (
    cid nvarchar(50),
    bdate date,
    gen nvarchar(50),
    dwh_creation_dt datetime2 default getdate()
);

IF OBJECT_ID('silver.erp_loc_a101', 'U') IS NOT NULL 
    DROP TABLE silver.erp_loc_a101;
CREATE TABLE silver.erp_loc_a101 (
    cid nvarchar(50),
    cntry nvarchar(50),
    dwh_creation_dt datetime2 default getdate()
);

IF OBJECT_ID('silver.erp_px_cat_g1v2', 'U') IS NOT NULL 
    DROP TABLE silver.erp_px_cat_g1v2;
CREATE TABLE silver.erp_px_cat_g1v2 (
    id nvarchar(50),
    cat nvarchar(50),
    subcat nvarchar(50),
    maintenance nvarchar(50),
    dwh_creation_dt datetime2 default getdate()
);
