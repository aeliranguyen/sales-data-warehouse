DROP TABLE IF EXISTS dwh.fact_sales;

CREATE TABLE dwh.fact_sales AS

SELECT

    ROW_NUMBER() OVER (
        ORDER BY s.order_id
    ) AS sales_key,

    d.date_key,

    c.customer_key,

    e.employee_key,

    p.product_key,

    s.order_id,

    s.quantity,

    s.unit_price,

    s.discount_pct,

    s.discount_amount,

    s.gross_amount,

    s.net_amount,

    s.delivery_status,

    s.payment_method,

    s.payment_status

FROM staging.stg_sales_transactions s

LEFT JOIN dwh.dim_date d
       ON s.order_date = d.date_day

LEFT JOIN dwh.dim_customers c
       ON s.customer_id = c.customer_id

LEFT JOIN dwh.dim_products p
       ON s.product_id = p.product_id

LEFT JOIN dwh.dim_employees e
       ON s.employee_id = e.employee_id
      AND s.order_date
          BETWEEN e.effective_from
              AND e.effective_to;