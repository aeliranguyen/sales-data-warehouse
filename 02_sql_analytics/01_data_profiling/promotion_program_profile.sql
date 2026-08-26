-- 1. Total Rows
SELECT
    COUNT(*) AS total_rows
FROM raw.promotion_program;


-- 2. Column Data Types
SELECT
    column_name,
    data_type
FROM information_schema.columns
WHERE table_schema = 'raw'
  AND table_name = 'promotion_program'
ORDER BY ordinal_position;


-- 3. NULL Summary
SELECT
    COUNT(*) AS total_rows,

    COUNT(*) FILTER (WHERE promotion_id IS NULL) AS promotion_id_null,
    ROUND(COUNT(*) FILTER (WHERE promotion_id IS NULL) * 100.0 / COUNT(*),2) AS promotion_id_null_pct,

    COUNT(*) FILTER (WHERE promotion_name IS NULL) AS promotion_name_null,
    COUNT(*) FILTER (WHERE promotion_type IS NULL) AS promotion_type_null,
    COUNT(*) FILTER (WHERE target_channel IS NULL) AS target_channel_null,
    COUNT(*) FILTER (WHERE target_region IS NULL) AS target_region_null,
    COUNT(*) FILTER (WHERE start_date IS NULL) AS start_date_null,
    COUNT(*) FILTER (WHERE end_date IS NULL) AS end_date_null,
    COUNT(*) FILTER (WHERE applicable_products IS NULL) AS applicable_products_null,
    COUNT(*) FILTER (WHERE discount_pct IS NULL) AS discount_pct_null,
    COUNT(*) FILTER (WHERE min_order_quantity IS NULL) AS min_order_quantity_null,
    COUNT(*) FILTER (WHERE budget_vnd IS NULL) AS budget_vnd_null,
    COUNT(*) FILTER (WHERE actual_cost_vnd IS NULL) AS actual_cost_vnd_null,
    COUNT(*) FILTER (WHERE status IS NULL) AS status_null,
    COUNT(*) FILTER (WHERE created_by IS NULL) AS created_by_null

FROM raw.promotion_program;


-- 4. Duplicate Promotion ID
SELECT
    promotion_id,
    COUNT(*) AS duplicate_count
FROM raw.promotion_program
GROUP BY promotion_id
HAVING COUNT(*) > 1;


-- 5. Negative Discount
SELECT *
FROM raw.promotion_program
WHERE discount_pct < 0
   OR discount_pct > 100;


-- 6. Negative Quantity
SELECT *
FROM raw.promotion_program
WHERE min_order_quantity < 0;


-- 7. Negative Budget
SELECT *
FROM raw.promotion_program
WHERE budget_vnd < 0
   OR actual_cost_vnd < 0;


-- 8. Invalid Date Format
SELECT *
FROM raw.promotion_program
WHERE start_date !~ '^\d{4}-\d{2}-\d{2}$'
   OR end_date !~ '^\d{4}-\d{2}-\d{2}$';


-- 9. Invalid Promotion Period
SELECT *
FROM raw.promotion_program
WHERE start_date::date > end_date::date;


-- 10. Distinct Promotion Type
SELECT DISTINCT promotion_type
FROM raw.promotion_program
ORDER BY promotion_type;


-- 11. Distinct Target Channel
SELECT DISTINCT target_channel
FROM raw.promotion_program
ORDER BY target_channel;


-- 12. Distinct Target Region
SELECT DISTINCT target_region
FROM raw.promotion_program
ORDER BY target_region;


-- 13. Distinct Status
SELECT DISTINCT status
FROM raw.promotion_program
ORDER BY status;


-- 14. Metadata Check
SELECT
    COUNT(*) FILTER (WHERE _source_file IS NULL) AS source_file_null,
    COUNT(*) FILTER (WHERE _source_platform IS NULL) AS source_platform_null,
    COUNT(*) FILTER (WHERE _ingested_at IS NULL) AS ingested_at_null,
    COUNT(*) FILTER (WHERE _batch_id IS NULL) AS batch_id_null
FROM raw.promotion_program;
