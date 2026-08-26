-- 1. Total Rows
SELECT
    COUNT(*) AS total_rows
FROM raw.employee_master;


-- 2. Column Data Types
SELECT
    column_name,
    data_type
FROM information_schema.columns
WHERE table_schema = 'raw'
  AND table_name = 'employee_master'
ORDER BY ordinal_position;


-- 3. NULL Summary
SELECT
    COUNT(*) AS total_rows,

    COUNT(*) FILTER (WHERE employee_id IS NULL) AS employee_id_null,
    ROUND(COUNT(*) FILTER (WHERE employee_id IS NULL)*100.0/COUNT(*),2) AS employee_id_null_pct,

    COUNT(*) FILTER (WHERE full_name IS NULL) AS full_name_null,
    COUNT(*) FILTER (WHERE gender IS NULL) AS gender_null,
    COUNT(*) FILTER (WHERE date_of_birth IS NULL) AS date_of_birth_null,
    COUNT(*) FILTER (WHERE join_date IS NULL) AS join_date_null,
    COUNT(*) FILTER (WHERE position IS NULL) AS position_null,
    COUNT(*) FILTER (WHERE region IS NULL) AS region_null,
    COUNT(*) FILTER (WHERE team IS NULL) AS team_null,
    COUNT(*) FILTER (WHERE email IS NULL) AS email_null,
    COUNT(*) FILTER (WHERE phone IS NULL) AS phone_null,
    COUNT(*) FILTER (WHERE status IS NULL) AS status_null,
    COUNT(*) FILTER (WHERE version IS NULL) AS version_null,
    COUNT(*) FILTER (WHERE effective_date IS NULL) AS effective_date_null,
    COUNT(*) FILTER (WHERE resign_date IS NULL) AS resign_date_null,
    COUNT(*) FILTER (WHERE transfer_note IS NULL) AS transfer_note_null

FROM raw.employee_master;


-- 4. Duplicate Employee ID
SELECT
    employee_id,
    COUNT(*) AS duplicate_count
FROM raw.employee_master
GROUP BY employee_id
HAVING COUNT(*) > 1;


-- 5. Distinct Gender
SELECT DISTINCT gender
FROM raw.employee_master
ORDER BY gender;


-- 6. Distinct Position
SELECT DISTINCT position
FROM raw.employee_master
ORDER BY position;


-- 7. Distinct Region
SELECT DISTINCT region
FROM raw.employee_master
ORDER BY region;


-- 8. Distinct Team
SELECT DISTINCT team
FROM raw.employee_master
ORDER BY team;


-- 9. Distinct Status
SELECT DISTINCT status
FROM raw.employee_master
ORDER BY status;

-- 10. Distinct Resign Date 
SELECT DISTINCT resign_date
FROM raw.employee_master;

-- 11. Distinct Transfer Note
SELECT DISTINCT transfer_note
FROM raw.employee_master;


-- 12. Invalid Email
SELECT *
FROM raw.employee_master
WHERE email IS NOT NULL
  AND email NOT LIKE '%@%';


-- 13. Invalid Join Date
SELECT *
FROM raw.employee_master
WHERE join_date !~ '^\d{4}-\d{2}-\d{2}$';


-- 14. Invalid Date of Birth
SELECT *
FROM raw.employee_master
WHERE date_of_birth !~ '^\d{4}-\d{2}-\d{2}$';


-- 15. Invalid Effective Date
SELECT *
FROM raw.employee_master
WHERE effective_date !~ '^\d{4}-\d{2}-\d{2}$';


-- 16. Metadata Check
SELECT
    COUNT(*) FILTER (WHERE _source_file IS NULL) AS source_file_null,
    COUNT(*) FILTER (WHERE _source_platform IS NULL) AS source_platform_null,
    COUNT(*) FILTER (WHERE _ingested_at IS NULL) AS ingested_at_null,
    COUNT(*) FILTER (WHERE _batch_id IS NULL) AS batch_id_null
FROM raw.employee_master;