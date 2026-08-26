DROP TABLE IF EXISTS dwh.dim_date;

CREATE TABLE dwh.dim_date AS

SELECT

    date_day,

    TO_CHAR(date_day, 'YYYYMMDD')::INT AS date_key,

    EXTRACT(YEAR FROM date_day)::INT AS year,

    EXTRACT(QUARTER FROM date_day)::INT AS quarter,

    EXTRACT(MONTH FROM date_day)::INT AS month,

    TO_CHAR(date_day, 'Month') AS month_name,

    EXTRACT(WEEK FROM date_day)::INT AS week,

    EXTRACT(DAY FROM date_day)::INT AS day,

    TO_CHAR(date_day, 'Day') AS day_name,

    EXTRACT(DOW FROM date_day)::INT AS day_of_week,

    CASE
        WHEN EXTRACT(DOW FROM date_day) IN (0,6)
        THEN TRUE
        ELSE FALSE
    END AS is_weekend,

    CASE
        WHEN EXTRACT(MONTH FROM date_day) >= 10
        THEN EXTRACT(YEAR FROM date_day)::INT + 1
        ELSE EXTRACT(YEAR FROM date_day)::INT
    END AS fiscal_year

FROM generate_series(

    DATE '2022-01-01',
    DATE '2026-12-31',
    INTERVAL '1 day'

) AS date_day;