-- 1. Total Rows
SELECT
    COUNT(*) AS total_rows
FROM raw.sales_target_plan;


-- 2. Column Data Types
SELECT
    column_name,
    data_type
FROM information_schema.columns
WHERE table_schema = 'raw'
  AND table_name = 'sales_target_plan'
ORDER BY ordinal_position;


-- 3. NULL Summary
SELECT
    COUNT(*) AS total_rows,

    COUNT(*) FILTER (WHERE plan_version IS NULL) AS plan_version_null,
    ROUND(COUNT(*) FILTER (WHERE plan_version IS NULL) * 100.0 / COUNT(*),2) AS plan_version_null_pct,

    COUNT(*) FILTER (WHERE version_date IS NULL) AS version_date_null,
    COUNT(*) FILTER (WHERE effective_from IS NULL) AS effective_from_null,
    COUNT(*) FILTER (WHERE effective_to IS NULL) AS effective_to_null,
    COUNT(*) FILTER (WHERE employee_id IS NULL) AS employee_id_null,
    COUNT(*) FILTER (WHERE employee_name IS NULL) AS employee_name_null,
    COUNT(*) FILTER (WHERE region IS NULL) AS region_null,
    COUNT(*) FILTER (WHERE team IS NULL) AS team_null,
    COUNT(*) FILTER (WHERE year IS NULL) AS year_null,
    COUNT(*) FILTER (WHERE month IS NULL) AS month_null,
    COUNT(*) FILTER (WHERE target_revenue IS NULL) AS target_revenue_null,
    COUNT(*) FILTER (WHERE target_quantity IS NULL) AS target_quantity_null,
    COUNT(*) FILTER (WHERE target_new_customers IS NULL) AS target_new_customers_null,
    COUNT(*) FILTER (WHERE version_label IS NULL) AS version_label_null

FROM raw.sales_target_plan;


-- 4. Duplicate Plan
SELECT
    plan_version,
    employee_id,
    year,
    month,
    COUNT(*) AS duplicate_count
FROM raw.sales_target_plan
GROUP BY
    plan_version,
    employee_id,
    year,
    month
HAVING COUNT(*) > 1;


-- 5. Negative Target Values
SELECT *
FROM raw.sales_target_plan
WHERE target_revenue < 0
   OR target_quantity < 0
   OR target_new_customers < 0;


-- 6. Invalid Date Format
SELECT *
FROM raw.sales_target_plan
WHERE version_date !~ '^\d{4}-\d{2}-\d{2}$'
   OR effective_from !~ '^\d{4}-\d{2}-\d{2}$'
   OR effective_to !~ '^\d{4}-\d{2}-\d{2}$';


-- 7. Invalid Effective Period
SELECT *
FROM raw.sales_target_plan
WHERE effective_from::date > effective_to::date;


-- 8. Distinct Region
SELECT DISTINCT region
FROM raw.sales_target_plan
ORDER BY region;


-- 9. Distinct Team
SELECT DISTINCT team
FROM raw.sales_target_plan
ORDER BY team;


-- 10. Distinct Version Label
SELECT DISTINCT version_label
FROM raw.sales_target_plan
ORDER BY version_label;


-- 11. Metadata Check
SELECT
    COUNT(*) FILTER (WHERE _source_file IS NULL) AS source_file_null,
    COUNT(*) FILTER (WHERE _source_platform IS NULL) AS source_platform_null,
    COUNT(*) FILTER (WHERE _ingested_at IS NULL) AS ingested_at_null,
    COUNT(*) FILTER (WHERE _batch_id IS NULL) AS batch_id_null
FROM raw.sales_target_plan;