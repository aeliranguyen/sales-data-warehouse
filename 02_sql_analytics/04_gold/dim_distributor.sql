DROP TABLE IF EXISTS dwh.dim_distributors;

CREATE TABLE dwh.dim_distributors AS

WITH distributor_history AS (

    SELECT

        distributor_id,
        distributor_name,
        tier,
        channel,
        province,
        region,
        contact_person,
        phone,
        email,
        tax_code,
        join_date,
        credit_limit,
        status,
        assigned_supervisor_id,

        join_date AS effective_from,

        COALESCE(
            LEAD(join_date) OVER (
                PARTITION BY distributor_id
                ORDER BY join_date
            ) - INTERVAL '1 day',
            DATE '9999-12-31'
        ) AS effective_to,

        CASE
            WHEN LEAD(join_date) OVER (
                PARTITION BY distributor_id
                ORDER BY join_date
            ) IS NULL
            THEN TRUE
            ELSE FALSE
        END AS is_current

    FROM staging.stg_distributor_master

)

SELECT

    ROW_NUMBER() OVER (
        ORDER BY distributor_id, effective_from
    ) AS distributor_key,

    *

FROM distributor_history;