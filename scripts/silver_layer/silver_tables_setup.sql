/*

This script creates tables for the silver layer, which are very similar to bronze layer in structure.

An additional column, dwh_create_date TIMESTAMP, is added to each table to track of data loads.


*/


-- $ Tables for CRM source systems $

-- $$ Creating table crm_cust_info $$
drop table if EXISTS silver.crm_cust_info;
create table silver.crm_cust_info(
    cst_id bigint,
    cst_key VARCHAR(20),
    cst_firstname VARCHAR(25),
    cst_lastname VARCHAR(25),
    cst_marital_status VARCHAR(15),
    cst_gender VARCHAR(15),
    cst_create_date DATE,
    dwh_create_date TIMESTAMP DEFAULT current_timestamp
);


-- $$ Creating table crm_prd_info $$

drop table if EXISTS silver.crm_prd_info;
create table silver.crm_prd_info(
    prd_id int,
    prd_key VARCHAR(50),
    prd_cat_id VARCHAR(15),
    sls_prd_key VARCHAR(25),
    prd_nm text,
    prd_cost int,
    prd_line VARCHAR(25),
    prd_start_dt date,
    prd_end_dt date,
    dwh_create_date TIMESTAMP DEFAULT current_timestamp
);



-- $$ Creating table crm_sales_details $$

drop table if EXISTS silver.crm_sales_details;
create table silver.crm_sales_details(
    sls_ord_num VARCHAR(15),
    sls_prd_key VARCHAR(15),
    sls_cust_id BIGINT,
    sls_order_dt date,
    sls_ship_dt DATE,
    sls_due_dt date,
    sls_sales int,
    sls_quantity int,
    sls_price int,
    dwh_create_date TIMESTAMP DEFAULT current_timestamp
);



-- $ Tables for ERP source systems $

-- $$ Creating table erp_CUST_AZ12 $$

drop table if EXISTS silver.erp_CUST_AZ12;

create table silver.erp_CUST_AZ12(
    CID VARCHAR(25),
    BDATE DATE,
    GEN VARCHAR(10),
    dwh_create_date TIMESTAMP DEFAULT current_timestamp
);



-- $$ Creating table erp_LOC_A101 $$

drop table if EXISTS silver.erp_LOC_A101;

create table silver.erp_LOC_A101(
    CID VARCHAR(25),
    CNTRY VARCHAR(20),
    dwh_create_date TIMESTAMP DEFAULT current_timestamp
);


-- $$ Creating table erp_PX_CAT_G1V2 $$

drop table if EXISTS silver.erp_PX_CAT_G1V2;

create table silver.erp_PX_CAT_G1V2(
    ID VARCHAR(10),
    CAT VARCHAR(25),
    SUBCAT VARCHAR(30),
    Maintenance VARCHAR(10),
    dwh_create_date TIMESTAMP DEFAULT current_timestamp
);

