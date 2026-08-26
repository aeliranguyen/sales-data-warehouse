DROP TABLE IF EXISTS staging.stg_sales_targets_versioned;

CREATE TABLE staging.stg_sales_targets_versioned AS

WITH source AS (

    SELECT

        NULLIF(TRIM(plan_version), '') AS plan_version,

        CAST(NULLIF(TRIM(version_date), '') AS DATE) AS version_date,
        CAST(NULLIF(TRIM(effective_from), '') AS DATE) AS effective_from,
        CAST(NULLIF(TRIM(effective_to), '') AS DATE) AS effective_to,

        NULLIF(TRIM(employee_id), '') AS employee_id,
        NULLIF(TRIM(employee_name), '') AS employee_name,
        NULLIF(TRIM(region), '') AS region,
        NULLIF(TRIM(team), '') AS team,

        year,
        month,

        target_revenue,
        target_quantity,
        target_new_customers,

        NULLIF(TRIM(version_label), '') AS version_label,

        _source_file,
        _source_platform,
        _ingested_at,
        _batch_id

    FROM raw.sales_target_plan

    WHERE employee_id IS NOT NULL
      AND LOWER(TRIM(employee_id))
          NOT IN ('', 'null', 'none', 'nan')

),

versioned AS (

    SELECT
        *,

        ROW_NUMBER() OVER(
            PARTITION BY employee_id, year, month
            ORDER BY version_date DESC
        ) AS rn

    FROM source

)

SELECT

    plan_version,
    version_date,
    effective_from,
    effective_to,

    employee_id,
    employee_name,
    region,
    team,

    year,
    month,

    target_revenue,
    target_quantity,
    target_new_customers,

    version_label,

    CASE
        WHEN rn = 1 THEN TRUE
        ELSE FALSE
    END AS is_latest_flag,

    _source_file,
    _source_platform,
    _ingested_at,
    _batch_id

FROM versioned;