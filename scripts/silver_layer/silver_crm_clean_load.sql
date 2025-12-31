-- $ Data cleaning and loading for CRM source systems $
-- Bronze → Silver transformation layer
-----------------------------------------------------

-- $$ Load customer master (deduplicated & standardized) $$

TRUNCATE TABLE silver.crm_cust_info;  -- full refresh of silver layer

INSERT INTO silver.crm_cust_info (
    cst_id,
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_marital_status,
    cst_gender,
    cst_create_date
)
WITH x AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY cst_id
            ORDER BY cst_create_date DESC
        ) AS rn
    FROM bronze.crm_cust_info
)  -- deduplicate customers by keeping latest record per cst_id
SELECT
    cst_id,
    cst_key,
    TRIM(cst_firstname) AS cst_firstname,  -- remove leading/trailing spaces
    TRIM(cst_lastname)  AS cst_lastname,   -- remove leading/trailing spaces
    CASE 
        WHEN TRIM(UPPER(cst_marital_status)) = 'M' THEN 'Married'
        WHEN TRIM(UPPER(cst_marital_status)) = 'S' THEN 'Single'
        ELSE 'N/A'
    END AS cst_marital_status,  -- normalize marital status codes
    CASE 
        WHEN TRIM(UPPER(cst_gender)) = 'M' THEN 'Male'
        WHEN TRIM(UPPER(cst_gender)) = 'F' THEN 'Female'
        ELSE 'N/A'
    END AS cst_gender,          -- normalize gender codes
    TO_DATE(cst_create_date, 'YYYY-MM-DD') AS cst_create_date  -- enforce DATE datatype
FROM x
WHERE rn = 1;  -- keep only latest record per customer


-- $$ Load product master (category parsing & SCD-style end dating) $$

TRUNCATE TABLE silver.crm_prd_info;  -- full refresh

INSERT INTO silver.crm_prd_info (
    prd_id,
    prd_key,
    prd_cat_id,
    sls_prd_key,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt
)
SELECT
    prd_id,
    prd_key,
    REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS prd_cat_id,  -- derive product category id
    SUBSTRING(prd_key, 7)                        AS sls_prd_key, -- extract sales product key
    prd_nm,
    COALESCE(prd_cost, 0)                        AS prd_cost,    -- default missing cost to 0
    CASE UPPER(TRIM(prd_line))
        WHEN 'M' THEN 'Mountain'
        WHEN 'R' THEN 'Road'
        WHEN 'S' THEN 'Other Sales'
        WHEN 'T' THEN 'Touring'
        ELSE 'N/A'
    END AS prd_line,                             -- normalize product line codes
    TO_DATE(prd_start_dt, 'YYYY-MM-DD')          AS prd_start_dt,
    DATE(
        TO_DATE(
            LEAD(prd_start_dt) OVER (
                PARTITION BY prd_key
                ORDER BY prd_start_dt
            ),
            'YYYY-MM-DD'
        ) - INTERVAL '1 day'
    ) AS prd_end_dt  -- derive end date from next version (SCD Type 2 logic)
FROM bronze.crm_prd_info;


-- $$ Load sales fact (date parsing & revenue correction) $$

TRUNCATE TABLE silver.crm_sales_details;  -- full refresh

INSERT INTO silver.crm_sales_details (
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_quantity,
    sls_sales,
    sls_price
)
SELECT
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,

    -- convert YYYYMMDD strings into DATE, reject invalid values
    CASE 
        WHEN sls_order_dt = '0' OR LENGTH(sls_order_dt) != 8 THEN NULL
        ELSE DATE(CONCAT(
            SUBSTRING(sls_order_dt, 1, 4), '-',
            SUBSTRING(sls_order_dt, 5, 2), '-',
            SUBSTRING(sls_order_dt, 7, 2)
        ))
    END AS sls_order_dt,

    CASE 
        WHEN sls_ship_dt = '0' OR LENGTH(sls_ship_dt) != 8 THEN NULL
        ELSE DATE(CONCAT(
            SUBSTRING(sls_ship_dt, 1, 4), '-',
            SUBSTRING(sls_ship_dt, 5, 2), '-',
            SUBSTRING(sls_ship_dt, 7, 2)
        ))
    END AS sls_ship_dt,

    CASE 
        WHEN sls_due_dt = '0' OR LENGTH(sls_due_dt) != 8 THEN NULL
        ELSE DATE(CONCAT(
            SUBSTRING(sls_due_dt, 1, 4), '-',
            SUBSTRING(sls_due_dt, 5, 2), '-',
            SUBSTRING(sls_due_dt, 7, 2)
        ))
    END AS sls_due_dt,

    sls_quantity,

    -- correct invalid or inconsistent sales amounts
    CASE 
        WHEN sls_sales IS NULL
          OR sls_sales <= 0
          OR sls_sales != sls_quantity * ABS(sls_price)
        THEN sls_quantity * ABS(sls_price)
        ELSE sls_sales
    END AS sls_sales,

    -- derive unit price when missing or invalid
    CASE 
        WHEN sls_price IS NULL OR sls_price <= 0
        THEN sls_sales / NULLIF(sls_quantity, 0)
        ELSE sls_price
    END AS sls_price

FROM bronze.crm_sales_details;
