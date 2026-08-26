DROP TABLE IF EXISTS dwh.fact_targets;

CREATE TABLE dwh.fact_targets AS

SELECT

    ROW_NUMBER() OVER (
        ORDER BY
            e.employee_key,
            d.date_key,
            t.plan_version
    ) AS target_key,

    d.date_key,

    e.employee_key,

    t.plan_version,
    t.version_date,

    t.target_revenue,
    t.target_quantity,
    t.target_new_customers,

    t.is_latest_flag

FROM staging.stg_sales_targets_versioned t

LEFT JOIN dwh.dim_date d
       ON t.year = d.year
      AND t.month = d.month

LEFT JOIN dwh.dim_employees e
       ON t.employee_id = e.employee_id
      AND d.date_day
          BETWEEN e.effective_from
              AND e.effective_to;