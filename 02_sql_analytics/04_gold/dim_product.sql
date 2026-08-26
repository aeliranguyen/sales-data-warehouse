DROP TABLE IF EXISTS dwh.dim_products;

CREATE TABLE dwh.dim_products AS

SELECT
    ROW_NUMBER() OVER (
        ORDER BY product_id
    ) AS product_key,
    product_id,
    product_name,
    category,
    sub_category,
    unit,
    unit_price,
    cost_price,
    weight_gram,
    status,
    launch_date

FROM staging.stg_product_master;