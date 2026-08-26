-- 1. Total Rows
SELECT
    COUNT(*) AS total_rows
FROM raw.sales_transactions;


-- 2. Column Data Types
SELECT
    column_name,
    data_type
FROM information_schema.columns
WHERE table_schema = 'raw'
  AND table_name = 'sales_transactions'
ORDER BY ordinal_position;


-- 3. NULL Summary
SELECT
    COUNT(*) AS total_rows,

    COUNT(*) FILTER (WHERE order_id IS NULL) AS order_id_null,
    ROUND(COUNT(*) FILTER (WHERE order_id IS NULL) * 100.0 / COUNT(*),2) AS order_id_null_pct,

    COUNT(*) FILTER (WHERE order_date IS NULL) AS order_date_null,
    COUNT(*) FILTER (WHERE customer_id IS NULL) AS customer_id_null,
    COUNT(*) FILTER (WHERE region IS NULL) AS region_null,
    COUNT(*) FILTER (WHERE province IS NULL) AS province_null,
    COUNT(*) FILTER (WHERE channel IS NULL) AS channel_null,
    COUNT(*) FILTER (WHERE employee_id IS NULL) AS employee_id_null,
    COUNT(*) FILTER (WHERE product_id IS NULL) AS product_id_null,
    COUNT(*) FILTER (WHERE product_category IS NULL) AS product_category_null,
    COUNT(*) FILTER (WHERE quantity IS NULL) AS quantity_null,
    COUNT(*) FILTER (WHERE unit_price IS NULL) AS unit_price_null,
    COUNT(*) FILTER (WHERE discount_pct IS NULL) AS discount_pct_null,
    COUNT(*) FILTER (WHERE discount_amount IS NULL) AS discount_amount_null,
    COUNT(*) FILTER (WHERE gross_amount IS NULL) AS gross_amount_null,
    COUNT(*) FILTER (WHERE net_amount IS NULL) AS net_amount_null,
    COUNT(*) FILTER (WHERE delivery_status IS NULL) AS delivery_status_null,
    COUNT(*) FILTER (WHERE payment_method IS NULL) AS payment_method_null,
    COUNT(*) FILTER (WHERE payment_status IS NULL) AS payment_status_null

FROM raw.sales_transactions;


-- 4. Duplicate Order Line
SELECT
    order_id,
    product_id,
    COUNT(*) AS duplicate_count
FROM raw.sales_transactions
GROUP BY order_id, product_id
HAVING COUNT(*) > 1;


-- 5. Negative Quantity
SELECT *
FROM raw.sales_transactions
WHERE quantity < 0;


-- 6. Negative Prices and Amounts
SELECT *
FROM raw.sales_transactions
WHERE unit_price < 0
   OR discount_amount < 0
   OR gross_amount < 0
   OR net_amount < 0;


-- 7. Invalid Discount Percentage
SELECT *
FROM raw.sales_transactions
WHERE discount_pct < 0
   OR discount_pct > 100;


-- 8. Invalid Order Date
SELECT *
FROM raw.sales_transactions
WHERE order_date !~ '^\d{4}-\d{2}-\d{2}$';


-- 9. Distinct Region
SELECT DISTINCT region
FROM raw.sales_transactions
ORDER BY region;


-- 10. Distinct Channel
SELECT DISTINCT channel
FROM raw.sales_transactions
ORDER BY channel;


-- 11. Distinct Product Category
SELECT DISTINCT product_category
FROM raw.sales_transactions
ORDER BY product_category;


-- 12. Distinct Delivery Status
SELECT DISTINCT delivery_status
FROM raw.sales_transactions
ORDER BY delivery_status;


-- 13. Distinct Payment Method
SELECT DISTINCT payment_method
FROM raw.sales_transactions
ORDER BY payment_method;


-- 14. Distinct Payment Status
SELECT DISTINCT payment_status
FROM raw.sales_transactions
ORDER BY payment_status;


-- 15. Metadata Check
SELECT
    COUNT(*) FILTER (WHERE _source_file IS NULL) AS source_file_null,
    COUNT(*) FILTER (WHERE _source_platform IS NULL) AS source_platform_null,
    COUNT(*) FILTER (WHERE _ingested_at IS NULL) AS ingested_at_null,
    COUNT(*) FILTER (WHERE _batch_id IS NULL) AS batch_id_null
FROM raw.sales_transactions;