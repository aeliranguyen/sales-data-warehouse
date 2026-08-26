# customer_master

## Summary
- Total rows: 2,000
- Primary key: `customer_id`

## Issues
- `tax_code`: 1,035 NULL values (51.75%).
- `join_date` is stored as TEXT.
- `phone` is stored as BIGINT. Leading zeros may be lost.

## Silver Plan
- Cast `join_date` to DATE.
- Apply `TRIM()` to text columns.
- Convert `phone` to TEXT to preserve the original phone number format.


# distributor_master

## Summary
- Total rows: 138
- Primary key: `distributor_id`

## Issues
- `join_date` is stored as TEXT.
- `phone` and `tax_code` are stored as BIGINT. Leading zeros may be lost.

## Silver Plan
- Cast `join_date` to DATE.
- Apply `TRIM()` to text columns.
- Convert `phone` and `tax_code` to TEXT to preserve the original values.


# distributor_orders

## Summary
- Total rows: 35,945
- Primary key: (`order_id`, `product_id`)

## Issues
- `order_date`, `expected_delivery_date`, and `actual_delivery_date` are stored as TEXT.
- `order_id` is not unique because one order can contain multiple products.
- No duplicate records were found for the composite key (`order_id`, `product_id`).

## Silver Plan
- Cast date columns to DATE.
- Apply `TRIM()` to text columns.
- Keep one record per (`order_id`, `product_id`).


# employee_master

## Summary
- Total rows: 1140
- Primary key: `employee_id`

## Issues
- `phone` is stored as BIGINT.
- `date_of_birth`, `join_date`, and `effective_date` are stored as TEXT.
- `resign_date` contains 96,94% NULL values.
- `transfer_note` contains 97,81% NULL values.
-Found multiple duplicate `employee_id` values.
- Each duplicated employee appears **10 times**, mainly because the Bronze layer stores multiple versions from the source Excel sheets.
- Deduplication will be handled in the Silver layer using the latest business logic.

## Silver Plan
- Cast `date_of_birth`, `join_date`, and `effective_date` to DATE.
- Apply `TRIM()` and convert empty strings to `NULL` for all text columns.
- Convert `phone` to TEXT.
- Keep `resign_date` as DATE with NULL values until valid source data is available.
- Keep `transfer_note` as TEXT with NULL values until valid source data is available.


# product_master

## Summary
- Total rows: 100
- Primary key: `product_id`

## Issues
- `launch_date` is stored as TEXT.

## Silver Plan
- Cast `launch_date` to DATE.
- Apply `TRIM()` to text columns.


# promotion_program

## Summary
- Total rows: 40
- Primary key: `promotion_id`

## Issues
- `start_date` and `end_date` are stored as TEXT.

## Silver Plan
- Cast `start_date` and `end_date` to DATE.
- Apply `TRIM()` to text columns.

# return_transactions

## Summary
- Total rows: 3665
- Primary key: `return_id`

## Issues
- `return_date` is stored as TEXT.

## Silver Plan
- Cast `return_date` to DATE.
- Apply `TRIM()` to text columns.

# sales_target_plan

## Summary
- Total rows: 1950
- Primary key: (`plan_version`, `employee_id`, `year`, `month`)

## Issues
- `version_date`, `effective_from`, and `effective_to` are stored as TEXT.

## Silver Plan
- Cast `version_date`, `effective_from`, and `effective_to` to DATE.
- Apply `TRIM()` to text columns.
# sales_transactions

## Summary
- Total rows: 119101
- Primary key: (`order_id`, `product_id`)

## Issues
- `order_date` is stored as TEXT.

## Silver Plan
- Cast `order_date` to DATE.
- Apply `TRIM()` to text columns.
# territory_mapping

## Summary
- Total rows: 1843
- Primary key: `territory_id`

## Issues
- `effective_date` and `expiry_date` are stored as TEXT.

## Silver Plan
- Cast `effective_date` and `expiry_date` to DATE.
- Apply `TRIM()` to text columns.