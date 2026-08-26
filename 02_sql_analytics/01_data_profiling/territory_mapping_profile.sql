-- 1. Total Rows
SELECT
    COUNT(*) AS total_rows
FROM raw.territory_mapping;


-- 2. Column Data Types
SELECT
    column_name,
    data_type
FROM information_schema.columns
WHERE table_schema = 'raw'
  AND table_name = 'territory_mapping'
ORDER BY ordinal_position;


-- 3. NULL Summary
SELECT
    COUNT(*) AS total_rows,

    COUNT(*) FILTER (WHERE territory_id IS NULL) AS territory_id_null,
    ROUND(COUNT(*) FILTER (WHERE territory_id IS NULL) * 100.0 / COUNT(*),2) AS territory_id_null_pct,

    COUNT(*) FILTER (WHERE employee_id IS NULL) AS employee_id_null,
    COUNT(*) FILTER (WHERE customer_id IS NULL) AS customer_id_null,
    COUNT(*) FILTER (WHERE region IS NULL) AS region_null,
    COUNT(*) FILTER (WHERE team IS NULL) AS team_null,
    COUNT(*) FILTER (WHERE effective_date IS NULL) AS effective_date_null,
    COUNT(*) FILTER (WHERE expiry_date IS NULL) AS expiry_date_null,
    COUNT(*) FILTER (WHERE version IS NULL) AS version_null

FROM raw.territory_mapping;


-- 4. Duplicate Territory ID
SELECT
    territory_id,
    COUNT(*) AS duplicate_count
FROM raw.territory_mapping
GROUP BY territory_id
HAVING COUNT(*) > 1;


-- 5. Invalid Date Format
SELECT *
FROM raw.territory_mapping
WHERE effective_date !~ '^\d{4}-\d{2}-\d{2}$'
   OR expiry_date !~ '^\d{4}-\d{2}-\d{2}$';


-- 6. Invalid Effective Period
SELECT *
FROM raw.territory_mapping
WHERE effective_date::date > expiry_date::date;


-- 7. Distinct Region
SELECT DISTINCT region
FROM raw.territory_mapping
ORDER BY region;


-- 8. Distinct Team
SELECT DISTINCT team
FROM raw.territory_mapping
ORDER BY team;


-- 9. Distinct Version
SELECT DISTINCT version
FROM raw.territory_mapping
ORDER BY version;


-- 10. Metadata Check
SELECT
    COUNT(*) FILTER (WHERE _source_file IS NULL) AS source_file_null,
    COUNT(*) FILTER (WHERE _source_platform IS NULL) AS source_platform_null,
    COUNT(*) FILTER (WHERE _ingested_at IS NULL) AS ingested_at_null,
    COUNT(*) FILTER (WHERE _batch_id IS NULL) AS batch_id_null
FROM raw.territory_mapping;