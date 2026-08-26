-- 1. Total Rows
SELECT
    COUNT(*) AS total_rows
FROM raw.customer_master;


-- 2. Column Data Types
SELECT
    column_name,
    data_type
FROM information_schema.columns
WHERE table_schema = 'raw'
  AND table_name = 'customer_master'
ORDER BY ordinal_position;


-- 3. Null Summary
SELECT
    COUNT(*) AS total_rows,

    COUNT(*) FILTER (WHERE customer_id IS NULL) AS customer_id_null,
    ROUND(COUNT(*) FILTER (WHERE customer_id IS NULL) * 100.0 / COUNT(*),2) AS customer_id_null_pct,

    COUNT(*) FILTER (WHERE customer_name IS NULL) AS customer_name_null,
    ROUND(COUNT(*) FILTER (WHERE customer_name IS NULL) * 100.0 / COUNT(*),2) AS customer_name_null_pct,

    COUNT(*) FILTER (WHERE customer_type IS NULL) AS customer_type_null,
    COUNT(*) FILTER (WHERE channel IS NULL) AS channel_null,
    COUNT(*) FILTER (WHERE province IS NULL) AS province_null,
    COUNT(*) FILTER (WHERE region IS NULL) AS region_null,
    COUNT(*) FILTER (WHERE address IS NULL) AS address_null,
    COUNT(*) FILTER (WHERE phone IS NULL) AS phone_null,
    COUNT(*) FILTER (WHERE tax_code IS NULL) AS tax_code_null,
    COUNT(*) FILTER (WHERE join_date IS NULL) AS join_date_null,
    COUNT(*) FILTER (WHERE credit_limit IS NULL) AS credit_limit_null,
    COUNT(*) FILTER (WHERE status IS NULL) AS status_null

FROM raw.customer_master;


-- 4. Blank Strings
SELECT *

FROM raw.customer_master

WHERE

TRIM(customer_id)=''

OR TRIM(customer_name)=''

OR TRIM(customer_type)=''

OR TRIM(channel)=''

OR TRIM(region)=''

OR TRIM(status)='';


-- 5. Text Values ('null','nan','none')
SELECT *

FROM raw.customer_master

WHERE

LOWER(customer_id) IN ('null','nan','none')

OR LOWER(customer_name) IN ('null','nan','none')

OR LOWER(region) IN ('null','nan','none');


-- 6. Duplicate Customer ID
SELECT

customer_id,

COUNT(*) AS duplicate_count

FROM raw.customer_master

GROUP BY customer_id

HAVING COUNT(*)>1;


-- 7. Distinct Customer Type
SELECT DISTINCT customer_type
FROM raw.customer_master
ORDER BY customer_type;


-- 8. Distinct Channel
SELECT DISTINCT channel
FROM raw.customer_master
ORDER BY channel;


-- 9. Distinct Region
SELECT DISTINCT region
FROM raw.customer_master
ORDER BY region;


-- 10. Distinct Status
SELECT DISTINCT status
FROM raw.customer_master
ORDER BY status;


-- 11. Negative Credit Limit
SELECT *

FROM raw.customer_master

WHERE credit_limit < 0;


-- 12. Invalid Join Date Format
SELECT *

FROM raw.customer_master

WHERE join_date !~ '^\d{4}-\d{2}-\d{2}$';


-- 13. Metadata Check
SELECT

COUNT(*) FILTER (WHERE _source_file IS NULL) AS source_file_null,

COUNT(*) FILTER (WHERE _source_platform IS NULL) AS source_platform_null,

COUNT(*) FILTER (WHERE _ingested_at IS NULL) AS ingested_at_null,

COUNT(*) FILTER (WHERE _batch_id IS NULL) AS batch_id_null

FROM raw.customer_master;