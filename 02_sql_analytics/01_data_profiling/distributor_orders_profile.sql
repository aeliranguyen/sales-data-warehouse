-- 1. Total Rows
SELECT
    COUNT(*) AS total_rows
FROM raw.distributor_orders;


-- 2. Column Data Types
SELECT
    column_name,
    data_type
FROM information_schema.columns
WHERE table_schema = 'raw'
  AND table_name = 'distributor_orders'
ORDER BY ordinal_position;


-- 3. NULL Summary
SELECT
    COUNT(*) AS total_rows,

    -- Keys
    COUNT(*) FILTER (WHERE order_id IS NULL) AS order_id_null,
    COUNT(*) FILTER (WHERE order_date IS NULL) AS order_date_null,
    COUNT(*) FILTER (WHERE distributor_id IS NULL) AS distributor_id_null,
    COUNT(*) FILTER (WHERE product_id IS NULL) AS product_id_null,

    -- Measures
    COUNT(*) FILTER (WHERE qty_ordered IS NULL) AS qty_ordered_null,
    COUNT(*) FILTER (WHERE qty_delivered IS NULL) AS qty_delivered_null,
    COUNT(*) FILTER (WHERE unit_price_list IS NULL) AS unit_price_list_null,
    COUNT(*) FILTER (WHERE distributor_price IS NULL) AS distributor_price_null,
    COUNT(*) FILTER (WHERE gross_amount IS NULL) AS gross_amount_null,
    COUNT(*) FILTER (WHERE delivered_amount IS NULL) AS delivered_amount_null,
    COUNT(*) FILTER (WHERE fill_rate_pct IS NULL) AS fill_rate_pct_null,

    -- Important dates
    COUNT(*) FILTER (WHERE expected_delivery_date IS NULL) AS expected_delivery_date_null,
    COUNT(*) FILTER (WHERE actual_delivery_date IS NULL) AS actual_delivery_date_null,

    -- Status
    COUNT(*) FILTER (WHERE delivery_status IS NULL) AS delivery_status_null

FROM raw.distributor_orders;

-- 4. Duplicate Order ID
SELECT
    order_id,
    COUNT(*) AS duplicate_count
FROM raw.distributor_orders
GROUP BY order_id
HAVING COUNT(*) > 1;

SELECT
    order_id,
    product_id,
    COUNT(*) AS duplicate_count
FROM raw.distributor_orders
GROUP BY order_id, product_id
HAVING COUNT(*) > 1;


-- 5. Invalid Order Month
SELECT *
FROM raw.distributor_orders
WHERE order_month NOT BETWEEN 1 AND 12;


-- 6. Invalid Order Quarter
SELECT *
FROM raw.distributor_orders
WHERE order_quarter NOT BETWEEN 1 AND 4;


-- 7. Negative Quantity
SELECT *
FROM raw.distributor_orders
WHERE qty_ordered < 0
   OR qty_delivered < 0;


-- 8. Delivered Quantity > Ordered Quantity
SELECT *
FROM raw.distributor_orders
WHERE qty_delivered > qty_ordered;


-- 9. Negative Price / Amount
SELECT *
FROM raw.distributor_orders
WHERE unit_price_list < 0
   OR distributor_price < 0
   OR gross_amount < 0
   OR delivered_amount < 0;


-- 10. Invalid Fill Rate
SELECT *
FROM raw.distributor_orders
WHERE fill_rate_pct < 0
   OR fill_rate_pct > 100;


-- 11. Invalid Delivery Date
SELECT *
FROM raw.distributor_orders
WHERE expected_delivery_date !~ '^\d{4}-\d{2}-\d{2}$'
   OR actual_delivery_date !~ '^\d{4}-\d{2}-\d{2}$';


-- 12. Distinct Delivery Status
SELECT DISTINCT delivery_status
FROM raw.distributor_orders
ORDER BY delivery_status;


-- 13. Distinct Payment Terms
SELECT DISTINCT payment_terms
FROM raw.distributor_orders
ORDER BY payment_terms;


-- 14. Metadata Check
SELECT
    COUNT(*) FILTER (WHERE _source_file IS NULL) AS source_file_null,
    COUNT(*) FILTER (WHERE _source_platform IS NULL) AS source_platform_null,
    COUNT(*) FILTER (WHERE _ingested_at IS NULL) AS ingested_at_null,
    COUNT(*) FILTER (WHERE _batch_id IS NULL) AS batch_id_null
FROM raw.distributor_orders;

