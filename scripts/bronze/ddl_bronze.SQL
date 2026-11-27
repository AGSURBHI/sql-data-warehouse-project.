/*
======================================================================
DDL Script: Create Bronze Tables
======================================================================
Script purpose:
This Script creates tables in the 'bronze' schema, dropping existing tables
if they already exist.
Run this script to re-define the DDL structure of 'bronze' tables
======================================================================
*/

--TABLE CREATION

IF OBJECT_ID ('bronze.crm_cust_info','U') is not null
    Drop table bronze.crm_cust_info;

Create Table bronze.crm_cust_info(
cst_id int,
cst_key nvarchar(50),
cst_firstname nvarchar(50),
cst_lastname nvarchar(50),
cst_marital_status nvarchar(50),
cst_gndr nvarchar(50),
cst_create_date date
);

IF OBJECT_ID ('bronze.crm_prd_info','U') is not null
    Drop table bronze.crm_prd_info

Create Table bronze.crm_prd_info(
prd_id int,
prd_key nvarchar(50),
prd_nm nvarchar(50),
prd_cost int,
prd_line nvarchar(50),
prd_start_dt datetime,
prd_end_dt datetime
);

IF OBJECT_ID ('bronze.crm_sales_details','U') is not null
    Drop table bronze.crm_sales_details;

Create Table bronze.crm_sales_details(
sls_ord_num nvarchar(50),
sls_prd_key nvarchar(50),
sls_cust_id int,
sls_order_dt int,
sls_ship_dt int,
sls_due_dt int,
sls_sales int,
sls_quantity int,
sls_price int
)

-- erp tables

IF OBJECT_ID ('bronze.erp_cust_az12','U') is not null
    Drop table bronze.erp_cust_az12;

Create Table bronze.erp_cust_az12(
cid nvarchar(50),
bdate date,
gen nvarchar(50)
)

IF OBJECT_ID ('bronze.erp_loc_a101','U') is not null
    Drop table bronze.erp_loc_a101;

Create Table bronze.erp_loc_a101(
CID nvarchar(50),
CNTRY nvarchar(50)
)

IF OBJECT_ID ('bronze.erp_px_cat_g1v2','U') is not null
    Drop table bronze.erp_px_cat_g1v2;

Create Table  bronze.erp_px_cat_g1v2(
id nvarchar(50),
cat nvarchar(50),
subcat nvarchar(50),
maintenance nvarchar(50)
);

--DEVELOP SQL LOAD SCRIPTS and store them in stored procedure.

EXEC bronze.load_bronze

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT '=================================================';
		PRINT 'Loading Bronze Layer';
		PRINT '=================================================';

		PRINT '-------------------------------------------------';
		PRINT 'Loading CRM Tables';
		PRINT '-------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info

		PRINT '>> Inserting Data Into: bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info
		FROM 'F:\SQL Portfolio_dwh_project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		); 
		SET @end_time = GETDATE();
		PRINT '>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time ) AS NVARCHAR) + 'seconds';
		PRINT '-------------------------------'

		SET @start_time = GETDATE()
		PRINT '>> Truncating Table: bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info

		PRINT '>> Inserting Data Into: bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM 'F:\SQL Portfolio_dwh_project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		PRINT '>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time ) AS NVARCHAR) + 'seconds';
		PRINT '-------------------------------'

		SET @start_time = GETDATE()
		PRINT '>> Truncating Table: bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details

		PRINT '>> Inserting Data Into: bronze.crm_sales_details';
		BULK INSERT bronze.crm_sales_details
		FROM 'F:\SQL Portfolio_dwh_project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		PRINT '>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time ) AS NVARCHAR) + 'seconds';
		PRINT '-------------------------------'

		PRINT '-------------------------------------------------';
		PRINT 'Loading ERP Tables';
		PRINT '-------------------------------------------------';

		SET @start_time = GETDATE()
		PRINT '>> Truncating Table: bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12

		PRINT '>> Inserting Data Into: bronze.erp_cust_az12';
		BULK INSERT bronze.erp_cust_az12
		FROM 'F:\SQL Portfolio_dwh_project\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		PRINT '>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time ) AS NVARCHAR) + 'seconds';
		PRINT '-------------------------------'

		SET @start_time = GETDATE()
		PRINT '>> Truncating Table: bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101

		PRINT '>> Inserting Data Into: bronze.erp_loc_a101';
		BULK INSERT bronze.erp_loc_a101
		FROM 'F:\SQL Portfolio_dwh_project\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
		WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
		);
		PRINT '>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time ) AS NVARCHAR) + 'seconds';
		PRINT '-------------------------------'

		SET @start_time = GETDATE()
		PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2

		PRINT '>> Inserting Data Into: bronze.erp_px_cat_g1v2';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'F:\SQL Portfolio_dwh_project\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
		WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
		);
		PRINT '>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time ) AS NVARCHAR) + 'seconds';
		PRINT '-------------------------------'

		SET @batch_end_time = GETDATE();
		PRINT '========================================='
		PRINT 'Loading Bronze Layer is Completed';
		PRINT ' - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + 'seconds';
		PRINT '========================================='
	END TRY
	BEGIN CATCH
		PRINT '==========================================================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error NUMBER' + CAST(ERROR_NUMBER() AS NVARCHAR)
		PRINT 'Error STATE' + CAST(ERROR_STATE() AS NVARCHAR)
		PRINT '==========================================================================='
	END CATCH
END
