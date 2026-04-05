/* TABLE : erp_loc_a101 */
SELECT * FROM bronze.erp_loc_a101;

-- Check the CID is good as in silver.crm_cust_info
SELECT CID
FROM bronze.erp_loc_a101
WHERE CID NOT IN (SELECT cst_key FROM silver.crm_cust_info);

--Check the countries
SELECT DISTINCT CNTRY
FROM bronze.erp_loc_a101;

/* TRANSFORAMTION */
INSERT INTO silver.erp_loc_a101(
	CID,
	CNTRY
)
SELECT
REPLACE(CID, '-', '') AS CID,
CASE WHEN TRIM(CNTRY) = 'DE' THEN 'GERMANY'
	WHEN TRIM(CNTRY) IN ('US', 'USA') THEN 'United States'
	WHEN TRIM(CNTRY) = '' OR CNTRY IS NULL THEN 'n/a'
	ELSE TRIM(CNTRY)
END AS cntry
FROM bronze.erp_loc_a101;

SELECT * FROM  silver.erp_loc_a101;

/* VALIDATION */
-- Check the CID is good as in silver.crm_cust_info
SELECT CID
FROM silver.erp_loc_a101
WHERE CID NOT IN (SELECT cst_key FROM silver.crm_cust_info);

--Check the countries
SELECT DISTINCT CNTRY
FROM silver.erp_loc_a101;
