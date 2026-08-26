-- Customer Master

-- Primary Key NOT NULL
SELECT *
FROM staging.stg_customer_master
WHERE customer_id IS NULL;

-- Primary Key UNIQUE
SELECT
    customer_id,
    COUNT(*) AS duplicate_count
FROM staging.stg_customer_master
GROUP BY customer_id
HAVING COUNT(*) > 1;


-- Distributor Master

-- Primary Key NOT NULL
SELECT *
FROM staging.stg_distributor_master
WHERE distributor_id IS NULL;

-- Primary Key UNIQUE
SELECT
    distributor_id,
    COUNT(*) AS duplicate_count
FROM staging.stg_distributor_master
GROUP BY distributor_id
HAVING COUNT(*) > 1;


-- Distributor Orders

-- Composite Primary Key NOT NULL
SELECT *
FROM staging.stg_distributor_orders
WHERE order_id IS NULL
   OR product_id IS NULL;

-- Composite Primary Key UNIQUE
SELECT
    order_id,
    product_id,
    COUNT(*) AS duplicate_count
FROM staging.stg_distributor_orders
GROUP BY order_id, product_id
HAVING COUNT(*) > 1;


-- Employee Master

-- Primary Key NOT NULL
SELECT *
FROM staging.stg_employee_master
WHERE employee_id IS NULL;

-- Primary Key UNIQUE
SELECT
    employee_id,
    COUNT(*) AS duplicate_count
FROM staging.stg_employee_master
GROUP BY employee_id
HAVING COUNT(*) > 1;


-- Product Master

-- Primary Key NOT NULL
SELECT *
FROM staging.stg_product_master
WHERE product_id IS NULL;

-- Primary Key UNIQUE
SELECT
    product_id,
    COUNT(*) AS duplicate_count
FROM staging.stg_product_master
GROUP BY product_id
HAVING COUNT(*) > 1;


-- Promotion Program

-- Primary Key NOT NULL
SELECT *
FROM staging.stg_promotion_program
WHERE promotion_id IS NULL;

-- Primary Key UNIQUE
SELECT
    promotion_id,
    COUNT(*) AS duplicate_count
FROM staging.stg_promotion_program
GROUP BY promotion_id
HAVING COUNT(*) > 1;


-- Return Transactions

-- Primary Key NOT NULL
SELECT *
FROM staging.stg_return_transactions
WHERE return_id IS NULL;

-- Primary Key UNIQUE
SELECT
    return_id,
    COUNT(*) AS duplicate_count
FROM staging.stg_return_transactions
GROUP BY return_id
HAVING COUNT(*) > 1;


-- Sales Target Plan

-- Composite Primary Key NOT NULL
SELECT *
FROM staging.stg_sales_targets_versioned
WHERE employee_id IS NULL
   OR year IS NULL
   OR month IS NULL
   OR plan_version IS NULL;

-- Composite Primary Key UNIQUE
SELECT
    employee_id,
    year,
    month,
    plan_version,
    COUNT(*) AS duplicate_count
FROM staging.stg_sales_targets_versioned
GROUP BY
    employee_id,
    year,
    month,
    plan_version
HAVING COUNT(*) > 1;


-- Sales Transactions

-- Composite Primary Key NOT NULL
SELECT *
FROM staging.stg_sales_transactions
WHERE order_id IS NULL
   OR product_id IS NULL;

-- Composite Primary Key UNIQUE
SELECT
    order_id,
    product_id,
    COUNT(*) AS duplicate_count
FROM staging.stg_sales_transactions
GROUP BY
    order_id,
    product_id
HAVING COUNT(*) > 1;


-- Territory Mapping

-- Primary Key NOT NULL
SELECT *
FROM staging.stg_territory_mapping
WHERE territory_id IS NULL;

-- Primary Key UNIQUE
SELECT
    territory_id,
    COUNT(*) AS duplicate_count
FROM staging.stg_territory_mapping
GROUP BY territory_id
HAVING COUNT(*) > 1;