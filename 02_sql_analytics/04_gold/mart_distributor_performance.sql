DROP TABLE IF EXISTS dwh.mart_distributor_performance;

CREATE TABLE dwh.mart_distributor_performance AS

WITH distributor_monthly AS (

    SELECT

        f.distributor_key,

        d.distributor_id,
        d.distributor_name,
        d.tier,
        d.channel,
        d.region,
        d.province,

        dt.fiscal_year,
        dt.year,
        dt.month,
        dt.month_name,

        COUNT(DISTINCT f.order_id) AS total_orders,

        COUNT(DISTINCT f.product_id) AS total_products,

        SUM(f.qty_ordered) AS total_qty_ordered,

        SUM(f.qty_delivered) AS total_qty_delivered,

        SUM(f.gross_amount) AS total_gross_amount,

        SUM(f.delivered_amount) AS total_delivered_amount,

        AVG(f.fill_rate_pct) AS avg_fill_rate,

        COUNT(*) FILTER (
        WHERE LOWER(f.ontime_delivery) = 'yes'
        ) AS ontime_delivery_count,

        COUNT(*) FILTER (
        WHERE LOWER(f.ontime_delivery) = 'no'
        ) AS late_delivery_count,

        COUNT(*) AS total_delivery_records

    FROM dwh.fact_distributor_orders f

    LEFT JOIN dwh.dim_distributors d
           ON f.distributor_key = d.distributor_key

    LEFT JOIN dwh.dim_date dt
           ON f.date_key = dt.date_key

    GROUP BY

        f.distributor_key,

        d.distributor_id,
        d.distributor_name,
        d.tier,
        d.channel,
        d.region,
        d.province,

        dt.fiscal_year,
        dt.year,
        dt.month,
        dt.month_name

)

SELECT

    distributor_key,

    distributor_id,
    distributor_name,

    tier,
    channel,
    region,
    province,

    fiscal_year,
    year,
    month,
    month_name,

    total_orders,
    total_products,

    total_qty_ordered,
    total_qty_delivered,

    ROUND(avg_fill_rate::NUMERIC,2) AS fill_rate_pct,

    total_gross_amount,

    total_delivered_amount,

    ROUND(

        (
            total_delivered_amount
            *100.0
            /
            NULLIF(total_gross_amount,0)
        )::NUMERIC,

        2

    ) AS delivered_amount_rate_pct,

    ontime_delivery_count,

    late_delivery_count,

    total_delivery_records,

    ROUND(

        (
            ontime_delivery_count
            *100.0
            /
            NULLIF(total_delivery_records,0)
        )::NUMERIC,

        2

    ) AS ontime_delivery_rate_pct

FROM distributor_monthly

ORDER BY

    year,
    month,
    distributor_name;
    