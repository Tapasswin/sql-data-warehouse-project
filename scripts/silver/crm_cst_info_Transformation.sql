/* TABLE : crm_cst_info */
-- Check NULL or Duplicates in primary key.
-- Expecting: No Records

SELECT cst_id, COUNT(*)
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

/*
TRANSFORAMTION:
This query will only get the unique cst_id from the bronze.crm_cst_info table.
*/
SELECT * 
FROM(
	SELECT *, ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS Flag_last
	FROM bronze.crm_cust_info
	WHERE cst_id is NOT NULL
	) t
WHERE Flag_last = 1;


-- Check for unwanted spaces
-- Expectation: No Results
SELECT cst_firstname 
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

SELECT cst_lastname
FROM bronze.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);

/*
We are Triming the firstname and lastname while removing NULL and duplicates only.
*/
SELECT 
cst_id,
cst_key,
TRIM(cst_firstname) AS cst_firstname,
TRIM(cst_lastname) AS cst_lastname,
cst_marital_status,
cst_gndr,
cst_create_date
FROM(
	SELECT *, ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last
	FROM bronze.crm_cust_info
	WHERE cst_id is NOT NULL
)t
WHERE flag_last = 1;


-- Data Standardization & Consistency
SELECT DISTINCT(cst_gndr)
FROM bronze.crm_cust_info;

SELECT DISTINCT(cst_marital_status)
FROM bronze.crm_cust_info;

/*
We can see the Female and Male are in shortcust and we also have null value we need to maintain consistency 
as case sensitive and insted of NULL replcae it with n/a
*/
SELECT 
cst_id,
cst_key,
TRIM(cst_firstname) AS cst_firstname,
TRIM(cst_lastname) AS cst_lastname,
CASE
	WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
	WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
	ELSE 'n/a'
END cst_marital_status,
CASE
	WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
	WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
	ELSE 'n/a'
END cst_gndr,
cst_create_date
FROM(
	SELECT *, ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last
	FROM bronze.crm_cust_info
	WHERE cst_id is NOT NULL
)t
WHERE flag_last = 1;

/*------- VALIDATION TABLE : crm_cust_info --------*/
-- Check NULL or Duplicates in primary key.
-- Expecting: No Records

SELECT cst_id, COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Check for unwanted spaces
-- Expectation: No Results
SELECT cst_firstname 
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

SELECT cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);

-- Data Standardization & Consistency
SELECT DISTINCT(cst_gndr)
FROM silver.crm_cust_info;

SELECT DISTINCT(cst_marital_status)
FROM silver.crm_cust_info;
