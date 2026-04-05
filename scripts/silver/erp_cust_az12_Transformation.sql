/* TABLE - erp_cust_az12 */
SELECT * FROM bronze.erp_cust_az12;

-- Check  the CID with the silver.crm_cust_info
SELECT CID
FROM bronze.erp_cust_az12
WHERE CID NOT IN (SELECT cst_key FROM silver.crm_cust_info)
/* We can see that the NAS waas additionaly added to it need to remove it.*/

-- Check the Birthday dates
SELECT BDATE
FROM bronze.erp_cust_az12
WHERE BDATE < '1925-01-01' OR BDATE > '2025-01-01';
/* We can see there are 100yr before entries and future entries need to make future to NULL*/

-- Data consistency and Standardization
SELECT DISTINCT(GEN)
FROM bronze.erp_cust_az12;

/* TRANSFORMATION */
INSERT INTO silver.erp_cust_az12(
	CID,
	BDATE,
	GEN
)
SELECT
CASE WHEN CID LIKE 'NAS%' THEN SUBSTRING(CID, 4, LEN(CID))
	ELSE CID
END AS CID,
CASE WHEN BDATE > '2025-01-01' THEN NULL
	ELSE BDATE
END AS BDATE,
CASE WHEN UPPER(TRIM(GEN)) IN ('F', 'FEMALE') THEN 'Female'
	WHEN UPPER(TRIM(GEN)) IN ('M', 'MALE') THEN 'Male'
	ELSE 'n/a'
END AS GEN
FROM bronze.erp_cust_az12;

/* VALIDATION */
-- Check  the CID with the silver.crm_cust_info
SELECT CID
FROM silver.erp_cust_az12
WHERE CID NOT IN (SELECT cst_key FROM silver.crm_cust_info);

-- Check the Birthday dates
SELECT BDATE
FROM silver.erp_cust_az12
WHERE BDATE < '1925-01-01' OR BDATE > '2025-01-01';

-- Data consistency and Standardization
SELECT DISTINCT(GEN)
FROM silver.erp_cust_az12;
