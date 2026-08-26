DROP TABLE IF EXISTS dwh.fact_returns;

CREATE TABLE dwh.fact_returns AS

SELECT

    r.return_id,

    r.original_order_id,

    d.date_key,

    c.customer_key,

    e.employee_key,

    p.product_key,

    r.return_quantity,

    r.unit_price,

    r.return_amount,

    r.return_reason,

    r.status

FROM staging.stg_return_transactions r

LEFT JOIN dwh.dim_date d
       ON r.return_date = d.date_day

LEFT JOIN dwh.dim_customers c
       ON r.customer_id = c.customer_id

LEFT JOIN dwh.dim_products p
       ON r.product_id = p.product_id

LEFT JOIN dwh.dim_employees e
       ON r.employee_id = e.employee_id
      AND r.return_date
          BETWEEN e.effective_from
              AND e.effective_to;