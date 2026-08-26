DROP TABLE IF EXISTS dwh.dim_employees;

CREATE TABLE dwh.dim_employees AS

SELECT

    ROW_NUMBER() OVER (
        ORDER BY employee_id, effective_date
    ) AS employee_key,

    employee_id,
    full_name,
    gender,
    date_of_birth,
    join_date,
    position,

    region,
    team,

    email,
    phone,

    status,
    version,

    effective_date AS effective_from,

    COALESCE(

        LEAD(effective_date)
        OVER(
            PARTITION BY employee_id
            ORDER BY effective_date
        ) - INTERVAL '1 day',

        DATE '9999-12-31'

    ) AS effective_to,

    CASE

        WHEN LEAD(effective_date)
             OVER(
                 PARTITION BY employee_id
                 ORDER BY effective_date
             ) IS NULL

        THEN TRUE

        ELSE FALSE

    END AS is_current

FROM staging.stg_employee_master

ORDER BY employee_id,effective_date;