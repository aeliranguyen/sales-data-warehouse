DROP TABLE IF EXISTS staging.stg_employee_master;

CREATE TABLE staging.stg_employee_master AS

WITH source AS (

    SELECT

        NULLIF(TRIM(employee_id), '') AS employee_id,
        NULLIF(TRIM(full_name), '') AS full_name,
        NULLIF(TRIM(gender), '') AS gender,

        CAST(
            NULLIF(TRIM(date_of_birth), '')
            AS DATE
        ) AS date_of_birth,

        CAST(
            NULLIF(TRIM(join_date), '')
            AS DATE
        ) AS join_date,

        NULLIF(TRIM(position), '') AS position,
        NULLIF(TRIM(region), '') AS region,
        NULLIF(TRIM(team), '') AS team,
        NULLIF(TRIM(email), '') AS email,

        CAST(phone AS TEXT) AS phone,

        NULLIF(TRIM(status), '') AS status,
        NULLIF(TRIM(version), '') AS version,

        CAST(
            NULLIF(TRIM(effective_date), '')
            AS DATE
        ) AS effective_date,

        CAST(
            NULLIF(TRIM(resign_date), '')
            AS DATE
        ) AS resign_date,

        NULLIF(TRIM(transfer_note), '') AS transfer_note,

        _source_file,
        _source_platform,
        _ingested_at,
        _batch_id

    FROM raw.employee_master

    WHERE employee_id IS NOT NULL
      AND LOWER(TRIM(employee_id))
          NOT IN ('', 'null', 'none', 'nan')

)

SELECT

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
    effective_date,
    resign_date,
    transfer_note,

    _source_file,
    _source_platform,
    _ingested_at,
    _batch_id

FROM source;
