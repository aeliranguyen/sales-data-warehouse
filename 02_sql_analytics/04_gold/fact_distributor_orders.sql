DROP TABLE IF EXISTS dwh.fact_distributor_orders;

CREATE TABLE dwh.fact_distributor_orders AS

SELECT

    ROW_NUMBER() OVER (
        ORDER BY o.order_id
    ) AS distributor_order_key,

    dt.date_key,

    d.distributor_key,

    o.order_id,

    o.product_id,
    o.product_category,

    o.qty_ordered,
    o.qty_delivered,

    o.fill_rate_pct,

    o.unit_price_list,
    o.distributor_price,

    o.gross_amount,
    o.delivered_amount,

    o.expected_delivery_date,
    o.actual_delivery_date,

    o.ontime_delivery,

    o.delivery_status,

    o.payment_terms

FROM staging.stg_distributor_orders o

LEFT JOIN dwh.dim_distributors d
       ON o.distributor_id = d.distributor_id

LEFT JOIN dwh.dim_date dt
       ON o.order_date = dt.date_day;