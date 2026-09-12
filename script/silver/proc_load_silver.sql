create or alter procedure silver.load_silver as
begin
	print '>> truncate table : silver.crm_cust_info'
	truncate table silver.crm_cust_info
	print '>> insert data into silver layer  : silver.crm_cust_info'
		insert into silver.crm_cust_info(
		cust_id,
		cust_key,
		cust_firstname,
		cust_lastname,
		cust_material_status,
		cust_gndr,
		cust_create_date
		)
		select 
		cust_id,
		cust_key,
		trim(cust_firstname) as cust_firstname,
		trim(cust_lastname)as cust_lastname,
		case 
			when upper(trim(cust_material_status)) ='M' then 'Married'
			when upper(trim(cust_material_status)) ='S' then 'Single'
			else 'n/a'
		end cust_material_status,
		case 
			when upper(trim(cust_gndr)) ='F' then 'Female'
			when upper(trim(cust_gndr)) ='M' then 'male'
			else 'n/a'
		end cust_gndr,
		cust_create_date
		from(
		select
		*, 
		ROW_NUMBER() over(partition by cust_id order by cust_create_date desc) as flag
		from bronze.crm_cust_info
		where cust_id is not null
		) t 
		where flag = 1 


	print '>> truncate table : crm_prd_info'
	truncate table silver.crm_prd_info
	print '>> insert data into silver layer  : crm_prd_info'
		insert into silver.crm_prd_info(
		prd_id,
		cat_id,
		prd_key,
		prd_nm,
		prd_cost,
		prd_line,
		prd_start_dt,
		prd_end_dt
		)
		select
		prd_id,
		replace(SUBSTRING(prd_key,1,5),'-','_' )as cat_id,
		SUBSTRING(prd_key,7,LEN(prd_key))as prd_key,
		trim(prd_nm) as prd_nm,
		isnull(prd_cost,0) prd_cost,
		case
			when upper(trim(prd_line)) = 'R' THEN 'Road'
			when upper(trim(prd_line)) = 'S' THEN 'Other sales'
			when upper(trim(prd_line)) = 'M' THEN 'Mountain'
			when upper(trim(prd_line)) = 'T' THEN 'Touring'
			ELSE 'n/a'
		end as prd_line,
		prd_start_dt,
		cast((lead(cast(prd_start_dt as datetime)) over(partition by prd_key order by cast(prd_start_dt as datetime))-1) as date) as prd_end_dt
		from bronze.crm_prd_info
	

	print '>> truncate table : crm_sales_details'
	truncate table silver.crm_sales_details
	print '>> insert data into silver layer  : crm_sales_details'
		insert into silver.crm_sales_details(
			sls_ord_num ,
			sls_prd_key ,
			sls_cust_id ,
			sls_order_date ,
			sls_ship_date ,
			sls_due_date ,
			sls_sales ,
			sls_quantity ,
			sls_price 
		)
		select 
			sls_ord_num ,
			sls_prd_key ,
			sls_cust_id ,
			case 
				when sls_order_date=0 or LEN(sls_order_date) != 8 then null
				else cast(cast(sls_order_date as nvarchar)as date)
			end as sls_order_date,
			case 
			 when sls_ship_date=0 or LEN(sls_ship_date) != 8 then null
				else cast(cast(sls_ship_date as nvarchar)as date)
			end as sls_ship_date,
			case 
				when sls_due_date=0 or LEN(sls_due_date) != 8 then null
				else cast(cast(sls_due_date as nvarchar)as date)
			end as sls_due_date,
			case 
				when sls_sales is null or sls_ship_date <= 0 or sls_sales != sls_quantity * abs(sls_price)
				then sls_quantity * abs(sls_price)
				else sls_sales
			end as sls_sales,
			sls_quantity,
				case 
				when sls_price  is null or sls_price  <= 0 
				then sls_sales / nullif(sls_quantity,0) 
				else sls_price
			end as sls_price 
		from bronze.crm_sales_details



	print '>> truncate table : silver.erp_cust_az12'
	truncate table silver.erp_cust_az12
	print '>> insert data into silver layer  : silver.erp_cust_az12'
		insert into silver.erp_cust_az12 (
			cid ,
			bdate ,
			gen 
		)
		select 
		case
		   WHEN cid like 'NAS%' THEN substring(trim(cid),4,len(cid))
		end as cid,
		case 
		when bdate >= GETDATE() then null
			else bdate
		end bdate,
		case
		   when UPPER(TRIM(gen))='M' then 'Male'
		   when UPPER(TRIM(gen))='F' then 'Female'
		   when TRIM(gen) ='' or gen is null then 'n/a'
		   else  gen
		end as gen
		from bronze.erp_cust_az12 


	print '>> truncate table : silver.erp_loc_a101'
	truncate table silver.erp_loc_a101
	print '>> insert data into silver layer  : silver.erp_loc_a101'
		insert into silver.erp_loc_a101(
			cid ,
			cntry 
		)
		select 
		replace(trim(cid),'-','') as cid,
		case
			when upper(trim(cntry)) in ('US','USA','UNITED STATES') THEN 'United states'
			when upper(trim(cntry)) in ('DE','GERMANY') THEN 'Germany'
			when trim(cntry)='' or cntry is null then 'n/a'
			else trim(cntry)
		end as cntry
		from bronze.erp_loc_a101


	print '>> truncate table : silver.erp_px_cat_g1v2'
	truncate table silver.erp_px_cat_g1v2
	print '>> insert data into silver layer  : silver.erp_px_cat_g1v2'
		insert into silver.erp_px_cat_g1v2(
			id  ,
			cat ,
			subcat  ,
			maintenance
		)
		select 
		id,
		cat,
		subcat,
		maintenance
		from bronze.erp_px_cat_g1v2
end
