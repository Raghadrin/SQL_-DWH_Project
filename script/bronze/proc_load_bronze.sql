create or alter procedure bronze.load_bronze as
begin
	declare @start_time datetime ,@end_time datetime,@batch_start_time datetime,@batch_end_time datetime;
	begin try
		set @batch_start_time = GETDATE();
		print'>> loading bronze layer';
		print '=================================================================================';
		print'loading CRM files';
		print '=================================================================================';

		print'>> truncate table bronze.crm_cust_info ';
		set @start_time = GETDATE()
		truncate table bronze.crm_cust_info;
		bulk insert bronze.crm_cust_info
		from 'C:\Users\user\Downloads\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		with(
			firstrow =2,
			fieldterminator = ',',
			tablock
		);
		set @end_time = GETDATE();
		print 'loading time : '+ cast(datediff(second,@start_time,@end_time) as nvarchar) + ' seconds'

		print '--------------------------------------';
		print'>> truncate table bronze.crm_prd_info ';
		set @start_time = GETDATE()
		truncate table bronze.crm_prd_info;
		bulk insert bronze.crm_prd_info
		from 'C:\Users\user\Downloads\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		with(
			firstrow =2,
			fieldterminator = ',',
			tablock
		);
		set @end_time = GETDATE();
		print 'loading time : '+ cast(datediff(second,@start_time,@end_time) as nvarchar) + ' seconds'

		print '--------------------------------------';
		print'>> truncate table crm_sales_details ';
		set @start_time = GETDATE()
		truncate table bronze.crm_sales_details;
		bulk insert bronze.crm_sales_details
		from 'C:\Users\user\Downloads\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		with(
			firstrow =2,
			fieldterminator = ',',
			tablock
		);
		set @end_time = GETDATE();
		print 'loading time : '+ cast(datediff(second,@start_time,@end_time) as nvarchar) + ' seconds'
		print '--------------------------------------';
		print '=================================================================================';
		print'loading ERP files';
		print '=================================================================================';


		print'>> truncate table bronze.erp_cust_az12 ';
		set @start_time = GETDATE()
		truncate table bronze.erp_cust_az12;
		bulk insert bronze.erp_cust_az12
		from 'C:\Users\user\Downloads\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		with(
			firstrow =2,
			fieldterminator = ',',
			tablock
		);
		set @end_time = GETDATE();
		print 'loading time : '+ cast(datediff(second,@start_time,@end_time) as nvarchar) + ' seconds'
		print '--------------------------------------';
		print'>> truncate table  bronze.erp_px_cat_g1v22 ';
		set @start_time = GETDATE()
		truncate table bronze.erp_px_cat_g1v2;
		bulk insert bronze.erp_px_cat_g1v2
		from 'C:\Users\user\Downloads\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		with(
			firstrow =2,
			fieldterminator = ',',
			tablock
		);
		set @end_time = GETDATE();
		print 'loading time : '+ cast(datediff(second,@start_time,@end_time) as nvarchar) + ' seconds'
		print '--------------------------------------';
		print'>> truncate table  bronze.erp_loc_a101 ';
		set @start_time = GETDATE()
		truncate table bronze.erp_loc_a101;
		bulk insert bronze.erp_loc_a101
		from 'C:\Users\user\Downloads\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		with(
			firstrow =2,
			fieldterminator = ',',
			tablock
		);
		set @end_time = GETDATE();
		print 'loading time : '+ cast(datediff(second,@start_time,@end_time) as nvarchar) + ' seconds'
		print '--------------------------------------';
		set @batch_end_time = GETDATE();
		print 'batch time : '+ cast(datediff(second,@batch_start_time,@batch_end_time) as nvarchar) + ' seconds'
		print '--------------------------------------';
		print '----------------------------------------------------------------------------------';
		print'finished loading files';
		print '----------------------------------------------------------------------------------;'
	end try
	begin catch
		print '----------------------------------------------------------------------------------';
		print'ERORR LOADING BRONZE LAYER';
		print'ERORR MASSAGE : '+ error_number();
		print'ERORR MASSAGE : '+ cast(error_message() as varchar);
		print '----------------------------------------------------------------------------------;'
	end catch
end
