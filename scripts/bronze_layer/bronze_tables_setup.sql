/*

This script creates the tables required to store data from the source systems: CRM and ERP.

The structure of the tables is derived from analyzing the data within the CSV files.

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


