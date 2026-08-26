DROP TABLE IF EXISTS dwh.dim_customers;

CREATE TABLE dwh.dim_customers AS

SELECT
    ROW_NUMBER() OVER (
        ORDER BY customer_id
    ) AS customer_key,
    customer_id,
    customer_name,
    customer_type,
    channel,
    province,
    region,
    address,
    phone,
    tax_code,
    join_date,
    credit_limit,
    status

FROM staging.stg_customer_master;