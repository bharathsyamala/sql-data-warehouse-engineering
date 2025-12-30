/*

This script creates the tables required to store data from the source systems: CRM and ERP.

In PostgreSQL, it's not possible to import data into tables from CSV files using standard method such as copy or \copy in IDEs such as pgAdmin, DBeaver, or VSCode with postgresql libraries. 

Therefore, the commands required to perform the loading are given at the end, after the table creation commands in the script.


*/

-- $ Tables for CRM source systems $

-- $$ Creating table crm_cust_info $$


drop table if EXISTS bronze.crm_cust_info;
create table bronze.crm_cust_info(
    cst_id bigint,
    cst_key VARCHAR(20),
    cst_firstname VARCHAR(25),
    cst_lastname VARCHAR(25),
    cst_marital_status VARCHAR(5),
    cst_gender VARCHAR(5),
    cst_create_date TEXT
);


-- $$ Creating table crm_prd_info $$

drop table if EXISTS bronze.crm_prd_info;
create table bronze.crm_prd_info(
    prd_id int,
    prd_key VARCHAR(50),
    prd_nm text,
    prd_cost int,
    prd_line VARCHAR(5),
    prd_start_dt TEXT,
    prd_end_dt TEXT
);



-- $$ Creating table crm_sales_details $$

drop table if EXISTS bronze.crm_sales_details;
create table bronze.crm_sales_details(
    sls_ord_num VARCHAR(15),
    sls_prd_key VARCHAR(15),
    sls_cust_id BIGINT,
    sls_order_dt text,
    sls_ship_dt text,
    sls_due_dt text,
    sls_sales int,
    sls_quantity int,
    sls_price int
);



-- $ Tables for ERP source systems $

-- $$ Creating table erp_CUST_AZ12 $$

drop table if EXISTS bronze.erp_CUST_AZ12;

create table bronze.erp_CUST_AZ12(
    CID VARCHAR(25),
    BDATE TEXT,
    GEN VARCHAR(10)
);



-- $$ Creating table erp_LOC_A101 $$

drop table if EXISTS erp_LOC_A101;

create table bronze.erp_LOC_A101(
    CID VARCHAR(25),
    CNTRY VARCHAR(20)
);


-- $$ Creating table erp_PX_CAT_G1V2 $$

drop table if EXISTS erp_PX_CAT_G1V2;

create table bronze.erp_PX_CAT_G1V2(
    ID VARCHAR(10),
    CAT VARCHAR(25),
    SUBCAT VARCHAR(30),
    Maintenance VARCHAR(10)
);





/* 

INSERTING RAW DATA INTO TABLES FROM SOURCE SYSTEMS 

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
