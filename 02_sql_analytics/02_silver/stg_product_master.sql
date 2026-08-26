DROP TABLE IF EXISTS staging.stg_product_master;

CREATE TABLE staging.stg_product_master AS

WITH source AS (

    SELECT

        NULLIF(TRIM(product_id), '') AS product_id,
        NULLIF(TRIM(product_name), '') AS product_name,
        NULLIF(TRIM(category), '') AS category,
        NULLIF(TRIM(sub_category), '') AS sub_category,
        NULLIF(TRIM(unit), '') AS unit,

        unit_price,
        cost_price,
        weight_gram,

        NULLIF(TRIM(status), '') AS status,

        CAST(
            NULLIF(TRIM(launch_date), '')
            AS DATE
        ) AS launch_date,

        _source_file,
        _source_platform,
        _ingested_at,
        _batch_id,

        ROW_NUMBER() OVER (
            PARTITION BY product_id
            ORDER BY _ingested_at DESC
        ) AS rn

    FROM raw.product_master

    WHERE product_id IS NOT NULL
      AND LOWER(TRIM(product_id))
          NOT IN ('', 'null', 'none', 'nan')

)

SELECT

    product_id,
    product_name,
    category,
    sub_category,
    unit,
    unit_price,
    cost_price,
    weight_gram,
    status,
    launch_date,

    _source_file,
    _source_platform,
    _ingested_at,
    _batch_id

FROM source

WHERE rn = 1;