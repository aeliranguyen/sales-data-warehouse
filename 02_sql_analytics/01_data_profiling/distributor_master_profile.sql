-- 1. Total Rows
SELECT
    COUNT(*) AS total_rows
FROM raw.distributor_master;


-- 2. Column Data Types
SELECT
    column_name,
    data_type
FROM information_schema.columns
WHERE table_schema = 'raw'
  AND table_name = 'distributor_master'
ORDER BY ordinal_position;


-- 3. Null Summary
SELECT
    COUNT(*) AS total_rows,

    COUNT(*) FILTER (WHERE distributor_id IS NULL) AS distributor_id_null,
    ROUND(COUNT(*) FILTER (WHERE distributor_id IS NULL) * 100.0 / COUNT(*),2) AS distributor_id_null_pct,

    COUNT(*) FILTER (WHERE distributor_name IS NULL) AS distributor_name_null,
    COUNT(*) FILTER (WHERE tier IS NULL) AS tier_null,
    COUNT(*) FILTER (WHERE channel IS NULL) AS channel_null,
    COUNT(*) FILTER (WHERE province IS NULL) AS province_null,
    COUNT(*) FILTER (WHERE region IS NULL) AS region_null,
    COUNT(*) FILTER (WHERE contact_person IS NULL) AS contact_person_null,
    COUNT(*) FILTER (WHERE phone IS NULL) AS phone_null,
    COUNT(*) FILTER (WHERE email IS NULL) AS email_null,
    COUNT(*) FILTER (WHERE tax_code IS NULL) AS tax_code_null,
    COUNT(*) FILTER (WHERE join_date IS NULL) AS join_date_null,
    COUNT(*) FILTER (WHERE credit_limit IS NULL) AS credit_limit_null,
    COUNT(*) FILTER (WHERE status IS NULL) AS status_null,
    COUNT(*) FILTER (WHERE assigned_supervisor_id IS NULL) AS supervisor_null

FROM raw.distributor_master;


-- 4. Duplicate Distributor ID
SELECT
    distributor_id,
    COUNT(*) AS duplicate_count
FROM raw.distributor_master
GROUP BY distributor_id
HAVING COUNT(*) > 1;


-- 5. Distinct Tier
SELECT DISTINCT tier
FROM raw.distributor_master
ORDER BY tier;


-- 6. Distinct Channel
SELECT DISTINCT channel
FROM raw.distributor_master
ORDER BY channel;


-- 7. Distinct Region
SELECT DISTINCT region
FROM raw.distributor_master
ORDER BY region;


-- 8. Distinct Status
SELECT DISTINCT status
FROM raw.distributor_master
ORDER BY status;


-- 9. Negative Credit Limit
SELECT *
FROM raw.distributor_master
WHERE credit_limit < 0;


-- 10. Invalid Join Date
SELECT *
FROM raw.distributor_master
WHERE join_date !~ '^\d{4}-\d{2}-\d{2}$';


-- 11. Invalid Email
SELECT *
FROM raw.distributor_master
WHERE email IS NOT NULL
  AND email NOT LIKE '%@%';


-- 12. Metadata Check
SELECT
    COUNT(*) FILTER (WHERE _source_file IS NULL) AS source_file_null,
    COUNT(*) FILTER (WHERE _source_platform IS NULL) AS source_platform_null,
    COUNT(*) FILTER (WHERE _ingested_at IS NULL) AS ingested_at_null,
    COUNT(*) FILTER (WHERE _batch_id IS NULL) AS batch_id_null
FROM raw.distributor_master;