DROP TABLE IF EXISTS dwh.mart_sales_vs_target;

CREATE TABLE dwh.mart_sales_vs_target AS

WITH actual_sales AS (

    SELECT

        fs.employee_key,

        d.year,
        d.month,
        d.month_name,
        d.fiscal_year,

        SUM(fs.quantity) AS actual_quantity,
        SUM(fs.net_amount) AS actual_revenue

    FROM dwh.fact_sales fs

    JOIN dwh.dim_date d
      ON fs.date_key = d.date_key

    GROUP BY

        fs.employee_key,
        d.year,
        d.month,
        d.month_name,
        d.fiscal_year
),

targets AS (

    SELECT

        ft.employee_key,

        d.year,
        d.month,
        d.month_name,
        d.fiscal_year,

        SUM(ft.target_quantity) AS target_quantity,
        SUM(ft.target_revenue) AS target_revenue,
        SUM(ft.target_new_customers) AS target_new_customers

    FROM dwh.fact_targets ft

    JOIN dwh.dim_date d
      ON ft.date_key = d.date_key

    GROUP BY

        ft.employee_key,
        d.year,
        d.month,
        d.month_name,
        d.fiscal_year
)

SELECT

    COALESCE(a.employee_key, t.employee_key) AS employee_key,

    e.employee_id,
    e.full_name,
    e.region,
    e.team,

    COALESCE(a.fiscal_year, t.fiscal_year) AS fiscal_year,
    COALESCE(a.year, t.year) AS year,
    COALESCE(a.month, t.month) AS month,
    COALESCE(a.month_name, t.month_name) AS month_name,

    COALESCE(a.actual_quantity,0) AS actual_quantity,
    COALESCE(t.target_quantity,0) AS target_quantity,

    COALESCE(a.actual_quantity,0)
        - COALESCE(t.target_quantity,0)
        AS quantity_gap,

    CASE
        WHEN COALESCE(t.target_quantity,0)=0 THEN NULL
        ELSE ROUND(
            (
                COALESCE(a.actual_quantity,0)
                *100.0
                / t.target_quantity
            )::NUMERIC,
            2
        )
    END AS quantity_achievement_pct,

    COALESCE(a.actual_revenue,0) AS actual_revenue,
    COALESCE(t.target_revenue,0) AS target_revenue,

    COALESCE(a.actual_revenue,0)
        - COALESCE(t.target_revenue,0)
        AS revenue_gap,

    CASE
        WHEN COALESCE(t.target_revenue,0)=0 THEN NULL
        ELSE ROUND(
            (
                COALESCE(a.actual_revenue,0)
                *100.0
                / t.target_revenue
            )::NUMERIC,
            2
        )
    END AS revenue_achievement_pct,

    COALESCE(t.target_new_customers,0) AS target_new_customers

FROM actual_sales a

FULL OUTER JOIN targets t

ON a.employee_key = t.employee_key
AND a.year = t.year
AND a.month = t.month

LEFT JOIN dwh.dim_employees e

ON COALESCE(a.employee_key,t.employee_key)
   = e.employee_key

ORDER BY

    year,
    month,
    employee_id;