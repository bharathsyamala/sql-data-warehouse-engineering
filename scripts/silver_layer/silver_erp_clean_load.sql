-- $ Data cleaning and loading for ERP source systems $
-- Bronze → Silver standardisation layer
-----------------------------------------------------

-- $$ Load ERP customer master (ID cleanup, date sanity checks) $$

TRUNCATE TABLE silver.erp_cust_az12;  -- full refresh of silver table

INSERT INTO silver.erp_cust_az12 (
    cid,
    bdate,
    gen
)
SELECT
    CASE 
        WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4) 
        ELSE cid
    END AS cid,  -- remove system-specific prefix from customer id

    CASE 
        WHEN DATE(bdate) > CURRENT_DATE THEN NULL
        ELSE TO_DATE(bdate, 'YYYY-MM-DD')
    END AS bdate,  -- reject future birth dates and enforce DATE datatype

    CASE 
        WHEN UPPER(TRIM(gen)) = 'F' THEN 'Female'
        WHEN UPPER(TRIM(gen)) = 'M' THEN 'Male'
        WHEN gen IS NULL OR TRIM(gen) = '' THEN 'N/A'
        ELSE TRIM(gen)
    END AS gen  -- normalize gender values and handle missing data

FROM bronze.erp_cust_az12;


-- $$ Load ERP location master (country normalization) $$

TRUNCATE TABLE silver.erp_loc_a101;  -- full refresh

INSERT INTO silver.erp_loc_a101 (
    cid,
    cntry
)
SELECT
    REPLACE(cid, '-', '') AS cid,  -- standardize customer id format
    CASE 
        WHEN UPPER(TRIM(cntry)) IN ('US', 'USA') THEN 'United States'
        WHEN UPPER(TRIM(cntry)) = 'DE' THEN 'Germany'
        WHEN cntry IS NULL OR TRIM(cntry) = '' THEN 'N/A'
        ELSE TRIM(cntry)
    END AS cntry  -- normalize country codes to full names

FROM bronze.erp_loc_a101;


-- $$ Load ERP product category reference data $$

TRUNCATE TABLE silver.erp_px_cat_g1v2;  -- full refresh

INSERT INTO silver.erp_px_cat_g1v2 (
    id,
    cat,
    subcat,
    maintenance
)
SELECT
    id,
    TRIM(cat)        AS cat,         -- remove padding from category
    TRIM(subcat)     AS subcat,      -- remove padding from sub-category
    TRIM(maintenance) AS maintenance -- standardize maintenance flag/description

FROM bronze.erp_px_cat_g1v2;
