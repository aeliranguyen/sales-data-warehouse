-- 1. Total Rows
SELECT
    COUNT(*) AS total_rows
FROM raw.return_transactions;


-- 2. Column Data Types
SELECT
    column_name,
    data_type
FROM information_schema.columns
WHERE table_schema = 'raw'
  AND table_name = 'return_transactions'
ORDER BY ordinal_position;


-- 3. NULL Summary
SELECT
    COUNT(*) AS total_rows,

    COUNT(*) FILTER (WHERE return_id IS NULL) AS return_id_null,
    ROUND(COUNT(*) FILTER (WHERE return_id IS NULL) * 100.0 / COUNT(*),2) AS return_id_null_pct,

    COUNT(*) FILTER (WHERE original_order_id IS NULL) AS original_order_id_null,
    COUNT(*) FILTER (WHERE return_date IS NULL) AS return_date_null,
    COUNT(*) FILTER (WHERE customer_id IS NULL) AS customer_id_null,
    COUNT(*) FILTER (WHERE employee_id IS NULL) AS employee_id_null,
    COUNT(*) FILTER (WHERE product_id IS NULL) AS product_id_null,
    COUNT(*) FILTER (WHERE region IS NULL) AS region_null,
    COUNT(*) FILTER (WHERE province IS NULL) AS province_null,
    COUNT(*) FILTER (WHERE return_quantity IS NULL) AS return_quantity_null,
    COUNT(*) FILTER (WHERE unit_price IS NULL) AS unit_price_null,
    COUNT(*) FILTER (WHERE return_amount IS NULL) AS return_amount_null,
    COUNT(*) FILTER (WHERE return_reason IS NULL) AS return_reason_null,
    COUNT(*) FILTER (WHERE status IS NULL) AS status_null

FROM raw.return_transactions;


-- 4. Duplicate Return ID
SELECT
    return_id,
    COUNT(*) AS duplicate_count
FROM raw.return_transactions
GROUP BY return_id
HAVING COUNT(*) > 1;


-- 5. Negative Quantity
SELECT *
FROM raw.return_transactions
WHERE return_quantity < 0;


-- 6. Negative Amount
SELECT *
FROM raw.return_transactions
WHERE unit_price < 0
   OR return_amount < 0;


-- 7. Invalid Return Date
SELECT *
FROM raw.return_transactions
WHERE return_date !~ '^\d{4}-\d{2}-\d{2}$';


-- 8. Distinct Return Reason
SELECT DISTINCT return_reason
FROM raw.return_transactions
ORDER BY return_reason;


-- 9. Distinct Status
SELECT DISTINCT status
FROM raw.return_transactions
ORDER BY status;


-- 10. Distinct Region
SELECT DISTINCT region
FROM raw.return_transactions
ORDER BY region;


-- 11. Metadata Check
SELECT
    COUNT(*) FILTER (WHERE _source_file IS NULL) AS source_file_null,
    COUNT(*) FILTER (WHERE _source_platform IS NULL) AS source_platform_null,
    COUNT(*) FILTER (WHERE _ingested_at IS NULL) AS ingested_at_null,
    COUNT(*) FILTER (WHERE _batch_id IS NULL) AS batch_id_null
FROM raw.return_transactions;