/* TABLE : erp_px_cat_g1v2*/
SELECT * FROM bronze.erp_px_cat_g1v2;

-- check any white spaces are not
SELECT * FROM bronze.erp_px_cat_g1v2 
WHERE cat!= TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != TRIM(maintenance)

-- check Consistency and Standardization
SELECT DISTINCT
MAINTENANCE
FROM bronze.erp_px_cat_g1v2;

/* ALL good no need of transformation */

INSERT INTO silver.erp_px_cat_g1v2(
	ID,
	CAT,
	SUBCAT,
	MAINTENANCE
)
SELECT * FROM bronze.erp_px_cat_g1v2;

