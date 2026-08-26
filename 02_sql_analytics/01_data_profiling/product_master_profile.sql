-- 1. Total Rows
SELECT
    COUNT(*) AS total_rows
FROM raw.product_master;


-- 2. Column Data Types
SELECT
    column_name,
    data_type
FROM information_schema.columns
WHERE table_schema = 'raw'
  AND table_name = 'product_master'
ORDER BY ordinal_position;


-- 3. NULL Summary
SELECT
    COUNT(*) AS total_rows,

    COUNT(*) FILTER (WHERE product_id IS NULL) AS product_id_null,
    ROUND(COUNT(*) FILTER (WHERE product_id IS NULL) * 100.0 / COUNT(*),2) AS product_id_null_pct,

    COUNT(*) FILTER (WHERE product_name IS NULL) AS product_name_null,
    COUNT(*) FILTER (WHERE category IS NULL) AS category_null,
    COUNT(*) FILTER (WHERE sub_category IS NULL) AS sub_category_null,
    COUNT(*) FILTER (WHERE unit IS NULL) AS unit_null,
    COUNT(*) FILTER (WHERE unit_price IS NULL) AS unit_price_null,
    COUNT(*) FILTER (WHERE cost_price IS NULL) AS cost_price_null,
    COUNT(*) FILTER (WHERE weight_gram IS NULL) AS weight_gram_null,
    COUNT(*) FILTER (WHERE status IS NULL) AS status_null,
    COUNT(*) FILTER (WHERE launch_date IS NULL) AS launch_date_null

FROM raw.product_master;


-- 4. Duplicate Product ID
SELECT
    product_id,
    COUNT(*) AS duplicate_count
FROM raw.product_master
GROUP BY product_id
HAVING COUNT(*) > 1;


-- 5. Negative Price
SELECT *
FROM raw.product_master
WHERE unit_price < 0
   OR cost_price < 0;


-- 6. Negative Weight
SELECT *
FROM raw.product_master
WHERE weight_gram < 0;


-- 7. Invalid Launch Date
SELECT *
FROM raw.product_master
WHERE launch_date !~ '^\d{4}-\d{2}-\d{2}$';


-- 8. Distinct Category
SELECT DISTINCT category
FROM raw.product_master
ORDER BY category;


-- 9. Distinct Sub Category
SELECT DISTINCT sub_category
FROM raw.product_master
ORDER BY sub_category;


-- 10. Distinct Unit
SELECT DISTINCT unit
FROM raw.product_master
ORDER BY unit;


-- 11. Distinct Status
SELECT DISTINCT status
FROM raw.product_master
ORDER BY status;


-- 12. Metadata Check
SELECT
    COUNT(*) FILTER (WHERE _source_file IS NULL) AS source_file_null,
    COUNT(*) FILTER (WHERE _source_platform IS NULL) AS source_platform_null,
    COUNT(*) FILTER (WHERE _ingested_at IS NULL) AS ingested_at_null,
    COUNT(*) FILTER (WHERE _batch_id IS NULL) AS batch_id_null
FROM raw.product_master;

