

-- $ Integrating data from customer tables from both CRM and ERP data sources to create business ready views $


-- $$ Creating view specific to customer info $$
drop view gold.dim_customers;

CREATE VIEW gold.dim_customers as (
    SELECT
    ROW_NUMBER() OVER(ORDER BY (cc.cst_id)) as customer_key,
    cc.cst_id as customer_id,
    cc.cst_key as customer_number,
    cc.cst_firstname as first_name,
    cc.cst_lastname as last_name,
    el.cntry as country,
    CASE 
        WHEN cc.cst_gender='N/A' THEN  COALESCE(ec.gen, 'N/A')
        WHEN ec.gen='N/A' THEN  COALESCE(cc.cst_gender, 'N/A')
        WHEN cc.cst_gender!=ec.gen THEN  COALESCE(cc.cst_gender, 'N/A')
        ELSE  COALESCE(cc.cst_gender, 'N/A')
    END as gender,
    ec.bdate as birth_date,
    cc.cst_marital_status as marital_status,
    cc.cst_create_date as creation_date
from silver.crm_cust_info cc
    LEFT JOIN silver.erp_cust_az12 ec on ec.cid=cc.cst_key
    LEFT JOIN silver.erp_loc_a101 el ON el.cid=cc.cst_key
);


-- $$ Creating view specific to product info $$

drop view gold.dim_products;

CREATE VIEW gold.dim_products as (
    SELECT 
        cp.prd_id as product_id,
        cp.sls_prd_key as product_number,
        cp.prd_nm as product_name,
        cp.prd_cost as product_cost,
        cp.prd_cat_id as category_id,
        ep.cat as category,
        ep.subcat as sub_category,
        ep.maintenance as maintenance_status,
        cp.prd_line as product_line,
        cp.prd_start_dt as start_date
    from silver.crm_prd_info cp
        LEFT JOIN silver.erp_px_cat_g1v2 ep on cp.prd_cat_id=ep.id
    where cp.prd_end_dt is NULL
);


-- $$ Creating view specific to sales info $$

drop view gold.fact_sales;

create View gold.fact_sales as (
    SELECT
        s.sls_ord_num as order_number,
        p.product_id as product_id,
        c.customer_key,
        s.sls_price as price,
        s.sls_quantity as quantity,
        s.sls_sales as sales,
        s.sls_order_dt as order_date,
        s.sls_ship_dt as ship_date,
        s.sls_due_dt as due_date
    from silver.crm_sales_details s
        left join gold.dim_customers c on c.customer_id=s.sls_cust_id
        LEFT join gold.dim_products p on p.product_number=sls_prd_key
);

