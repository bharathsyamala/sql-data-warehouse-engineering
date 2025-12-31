/* 

INSERTING RAW DATA INTO TABLES FROM SOURCE SYSTEMS - PostgreSQL does not allow using functions like COPY or \COPY within an IDE such as pgAdmin4, VSCode, or DBeaver, therefore, the \COPY statements in this file must be manually run in a PostgreSQL terminal.

1. TRUNCATE table <table_name>
2. Copying bulk data into the tables:

    The .csv data files are located in either source_crm or source_erp in the datasets folder. Therefore, the path to access the files are of the structure - 

    <main data warehouse project folder>/datasets/<source_crm|erp>/<file_name>.csv

    Therefore, replace the two dots in the path in below commands, which are of above form from "../datasets/", with the path in your PC leading to datasets. For example (in Windows) - "C:/Users/John/Documents/data warehouse project/datasets/...".


*/


-- $ Tables for CRM source systems $

-- $$ Inserting data into bronze.crm_cust_info table
TRUNCATE TABLE bronze.crm_cust_info;
\COPY bronze.crm_cust_info from '../datasets/source_crm/cust_info.csv' with (format CSV, header, delimiter ',');


-- $$ Inserting data into bronze.crm_prd_info table
TRUNCATE TABLE bronze.crm_prd_info;
\COPY bronze.crm_prd_info from '../datasets/source_crm/prd_info.csv' with (format CSV, header, delimiter ',');


-- $$ Inserting data into bronze.crm_sales_details table
TRUNCATE TABLE bronze.crm_sales_details;
\COPY bronze.crm_sales_details from '../datasets/source_crm/sales_details.csv' with (format CSV, header, delimiter ',');




-- $ Tables for ERP source systems $

-- $$ Creating table erp_CUST_AZ12 $$
TRUNCATE TABLE bronze.erp_cust_az12;
\COPY bronze.erp_CUST_AZ12 from '../datasets/source_erp/CUST_AZ12.csv' with (format CSV, header, delimiter ',');


-- $$ Creating table erp_LOC_A101 $$
TRUNCATE TABLE bronze.erp_loc_a101;
\COPY bronze.erp_LOC_A101 from '../datasets/source_erp/LOC_A101.csv' with (format CSV, header, delimiter ',');


-- $$ Creating table erp_PX_CAT_G1V2 $$
TRUNCATE TABLE bronze.erp_px_cat_g1v2;
\COPY bronze.erp_PX_CAT_G1V2 from '../datasets/source_erp/PX_CAT_G1V2.csv' with (format CSV, header, delimiter ',');
