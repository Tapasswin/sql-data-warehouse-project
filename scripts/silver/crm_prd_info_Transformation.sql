/* TABLE - crm_prod_info */
SELECT * FROM bronze.crm_prd_info;

-- Check NULL or Duplicates in primary key.
-- Expecting: No Records
SELECT prd_id, COUNT(*)
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;
/* We can see no duplicates are NUll for prd_id */

-- Check for unwanted spaces
-- Expectation: No Results
SELECT prd_nm
FROM bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);
/* We don't see any spaces in name*/

-- Cost shouldn't be negative are NULL
-- Expectation: No Results
SELECT prd_cost
FROM bronze.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;
/* We can see the NUll need to replace it with 0*/

-- Data Standardization & Consistency
SELECT DISTINCT prd_line
FROM bronze.crm_prd_info;
/* We need to replace it with its full text and n/a for NULL*/

-- Check for Invalid Date Orders
SELECT *
FROM bronze.crm_prd_info
WHERE prd_start_dt > prd_end_dt;
/* We got 200 rows are having invalid date need to adjust the End Date */


-- separate cat_key and prd_key (cat_key in erp px cat it was '_')
SELECT 
prd_id,
REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_key,
SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,
prd_nm,
ISNULL(prd_cost, 0),
CASE UPPER(TRIM(prd_line))
	WHEN 'M' THEN 'Mountain'
	WHEN 'R' THEN 'Road'
	WHEN 'S' THEN 'Other Sales'
	WHEN 'T' THEN 'Touring'
	ELSE 'n/a'
END AS prd_line,
CAST(prd_start_dt AS DATE) AS prd_start_dt,
CAST(LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS Date) AS prd_end_dt
FROM bronze.crm_prd_info;

/* INSERTING This Transforming table into the Silver layer*/
INSERT INTO silver.crm_prd_info(
	prd_id,
	cat_key,
	prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
)
SELECT 
prd_id,
REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,
prd_nm,
ISNULL(prd_cost, 0),
CASE UPPER(TRIM(prd_line))
	WHEN 'M' THEN 'Mountain'
	WHEN 'R' THEN 'Road'
	WHEN 'S' THEN 'Other Sales'
	WHEN 'T' THEN 'Touring'
	ELSE 'n/a'
END AS prd_line,
CAST(prd_start_dt AS DATE) AS prd_start_dt,
CAST(LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS Date) AS prd_end_dt
FROM bronze.crm_prd_info;

/*
Transforamtion:
1. Derived Column
2. Removed Null in Prd Cost
3. Data Normalization and Standardization
4. Casting Date column
5. Data Enrichment
*/
SELECT * FROM silver.crm_prd_info;

/* ------------VALIDATING TABLE - crm_prod_info----------- */

-- Check NULL or Duplicates in primary key.
-- Expecting: No Records
SELECT prd_id, COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- Check for unwanted spaces
-- Expectation: No Results
SELECT prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- Cost shouldn't be negative are NULL
-- Expectation: No Results
SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- Data Standardization & Consistency
SELECT DISTINCT prd_line
FROM silver.crm_prd_info;

-- Check for Invalid Date Orders
SELECT *
FROM silver.crm_prd_info
WHERE prd_start_dt > prd_end_dt;
