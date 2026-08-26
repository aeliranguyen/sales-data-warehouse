DROP TABLE IF EXISTS staging.stg_sales_transactions;

CREATE TABLE staging.stg_sales_transactions AS

WITH source AS (

    SELECT

        NULLIF(TRIM(order_id), '') AS order_id,

        CAST(
            NULLIF(TRIM(order_date), '')
            AS DATE
        ) AS order_date,

        order_month,
        order_quarter,
        order_year,

        NULLIF(TRIM(customer_id), '') AS customer_id,
        NULLIF(TRIM(region), '') AS region,
        NULLIF(TRIM(province), '') AS province,
        NULLIF(TRIM(channel), '') AS channel,
        NULLIF(TRIM(employee_id), '') AS employee_id,
        NULLIF(TRIM(product_id), '') AS product_id,
        NULLIF(TRIM(product_category), '') AS product_category,

        quantity,
        unit_price,
        discount_pct,
        discount_amount,
        gross_amount,
        net_amount,

        NULLIF(TRIM(delivery_status), '') AS delivery_status,
        NULLIF(TRIM(payment_method), '') AS payment_method,
        NULLIF(TRIM(payment_status), '') AS payment_status,

        _source_file,
        _source_platform,
        _ingested_at,
        _batch_id,

        ROW_NUMBER() OVER (
            PARTITION BY order_id, product_id
            ORDER BY _ingested_at DESC
        ) AS rn

    FROM raw.sales_transactions

    WHERE order_id IS NOT NULL
      AND LOWER(TRIM(order_id))
          NOT IN ('', 'null', 'none', 'nan')

)

SELECT

    order_id,
    order_date,
    order_month,
    order_quarter,
    order_year,
    customer_id,
    region,
    province,
    channel,
    employee_id,
    product_id,
    product_category,
    quantity,
    unit_price,
    discount_pct,
    discount_amount,
    gross_amount,
    net_amount,
    delivery_status,
    payment_method,
    payment_status,

    _source_file,
    _source_platform,
    _ingested_at,
    _batch_id

FROM source

WHERE rn = 1;