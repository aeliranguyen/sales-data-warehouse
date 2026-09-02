# Sales Data Warehouse | SQL & Python

A portfolio data warehouse project that transforms raw sales data into a structured analytical data warehouse using SQL and Python.

**Author:** Nguyen Anh Thu  
**Tools Used:** PostgreSQL, SQL, Python, Pandas, SQLAlchemy, Git/GitHub  
**Project Type:** Data Warehouse / ELT / Analytics Engineering

---

## Table of Contents

- [Background & Overview](#background--overview)
- [Dataset Description & Data Structure](#dataset-description--data-structure)
- [Main Process](#main-process)
- [Final Conclusion & Recommendations](#final-conclusion--recommendations)

---

## Background & Overview

### Objective

This project builds a sales data warehouse that transforms raw operational data into a clean and structured analytical model.

The objective is to create a reliable data foundation for sales performance, customer, product, employee, distributor, target, and return analysis.

### What is this project about? What Business Question will it solve?

This project simulates a real-world data warehouse workflow, from raw data ingestion to analytical-ready tables.

The project aims to:

- Load raw CSV and Excel files into PostgreSQL.
- Organize data into Raw, Staging, and Gold layers.
- Profile and identify data quality issues.
- Clean and standardize data before analytical use.
- Build dimensional and fact tables using a Star Schema.
- Apply SCD Type 2 to dimensions where historical changes need to be preserved.
- Create analytical-ready fact tables for sales, returns, distributor orders, and targets.

The warehouse is designed to support business questions such as:

- How is sales performance changing over time?
- Which products and categories generate the most revenue?
- Which customers contribute the most sales?
- How does actual sales performance compare with targets?
- Which employees and distributors perform best?
- What are the main return patterns?
- How well are distributor orders fulfilled and delivered on time?

### Who is this project for?

- Data Analysts
- Business Analysts
- Data Engineers
- Analytics Engineers
- Sales Operations teams
- Business decision-makers and stakeholders

---

## Dataset Description & Data Structure

### Data Source

The project uses simulated business data representing a sales and distribution organization.

The raw data consists of CSV and Excel files representing different operational business entities.

- **Source:** Simulated business dataset
- **Database:** PostgreSQL
- **Raw data format:** CSV and XLSX
- **Processing languages:** SQL and Python
- **Target architecture:** Layered Data Warehouse

### Data Layers

The project follows a layered data architecture:

```text
Raw Data
   ↓
Raw / Bronze Layer
   ↓
Staging / Silver Layer
   ↓
Gold / Data Warehouse Layer
```

### Raw / Bronze Layer

The Raw layer stores data close to the original source files.

Its main purpose is to:

- Ingest source data.
- Preserve raw records.
- Track source information.
- Store ingestion metadata.
- Support data lineage and traceability.

### Staging / Silver Layer

The Staging layer prepares the raw data for analytical modeling.

Main transformations include:

- Trimming text values.
- Standardizing data types.
- Converting date fields.
- Handling missing values.
- Removing duplicate records.
- Validating business keys.
- Preparing clean datasets for the Gold layer.

### Gold / Data Warehouse Layer

The Gold layer contains business-oriented analytical tables following a Star Schema.

The main dimensions are:

| Dimension | Purpose | SCD |
|---|---|---|
| dim_date | Calendar and time analysis | Static |
| dim_employees | Employee and organizational attributes | Type 2 |
| dim_customers | Customer attributes | Type 1 |
| dim_products | Product and pricing attributes | Type 1 |
| dim_distributors | Distributor and channel attributes | Type 2 |

The main fact tables are:

| Fact Table | Grain | Purpose |
|---|---|---|
| fact_sales | One sales line item | Sales transaction analysis |
| fact_returns | One return transaction | Return analysis |
| fact_targets | One employee/month/plan version | Target performance analysis |
| fact_distributor_orders | One distributor order | Distributor order and delivery analysis |

### Data Structure & Relationships

The Gold layer follows a Star Schema in which fact tables contain business measures and foreign keys to descriptive dimensions.

```text
                    dim_date
                       |
                       |
dim_customers --- fact_sales --- dim_products
                       |
                       |
                 dim_employees

                    dim_date
                       |
                       |
dim_distributors - fact_distributor_orders - dim_products

                    dim_date
                       |
                       |
                 fact_returns
                  /    |    \
                 /     |     \
       dim_customers dim_products dim_employees

                    dim_date
                       |
                       |
                 fact_targets
                       |
                dim_employees
```

### Table Schema & Data Snapshot

#### dim_date

| Column | Description |
|---|---|
| date_key | Surrogate date key |
| date_day | Calendar date |
| day | Day number |
| month | Month number |
| month_name | Month name |
| quarter | Quarter |
| year | Calendar year |
| week | Week information |
| fiscal_year | Fiscal year |

The `date_key` provides a consistent key for joining fact tables to the date dimension.

#### dim_employees

| Column | Description |
|---|---|
| employee_key | Surrogate key |
| employee_id | Business employee ID |
| employee_name | Employee name |
| region | Employee region |
| team | Employee team |
| effective_from | Start date of record validity |
| effective_to | End date of record validity |
| is_current | Indicates the current record |

SCD Type 2 is used to preserve historical employee attribute changes.

#### dim_customers

| Column | Description |
|---|---|
| customer_key | Surrogate key |
| customer_id | Business customer ID |
| customer_name | Customer name |
| customer_type | Customer classification |
| loyalty_tier | Customer loyalty level |
| join_date | Customer joining date |
| status | Customer status |

#### dim_products

| Column | Description |
|---|---|
| product_key | Surrogate key |
| product_id | Business product ID |
| product_name | Product name |
| category | Product category |
| sub_category | Product sub-category |
| unit | Product unit |
| unit_price | Selling price |
| cost_price | Product cost |
| status | Product status |
| launch_date | Product launch date |

#### dim_distributors

| Column | Description |
|---|---|
| distributor_key | Surrogate key |
| distributor_id | Business distributor ID |
| distributor_name | Distributor name |
| distributor_level | Distributor classification |
| channel | Distribution channel |
| effective_from | Start date of record validity |
| effective_to | End date of record validity |
| is_current | Indicates the current record |

SCD Type 2 is used where historical distributor changes need to be preserved.

#### fact_sales

**Grain: One row = one sales line item**

| Column | Description |
|---|---|
| sales_key | Surrogate transaction key |
| date_key | Date dimension key |
| employee_key | Employee dimension key |
| customer_key | Customer dimension key |
| product_key | Product dimension key |
| order_id | Business order ID |
| quantity | Quantity sold |
| unit_price | Selling price |
| sales_amount | Sales revenue |
| cost_amount | Cost amount |
| profit_amount | Profit |

#### fact_returns

**Grain: One row = one return transaction**

| Column | Description |
|---|---|
| return_id | Return transaction ID |
| original_order_id | Original sales order |
| date_key | Return date key |
| customer_key | Customer dimension key |
| employee_key | Employee dimension key |
| product_key | Product dimension key |
| return_quantity | Returned quantity |
| unit_price | Unit price |
| return_amount | Return value |
| return_reason | Reason for return |
| status | Return status |

#### fact_targets

**Grain: One row = one employee/month/plan version**

| Column | Description |
|---|---|
| target_key | Surrogate target key |
| date_key | Monthly date key |
| employee_key | Employee dimension key |
| plan_version | Target plan version |
| version_date | Version date |
| target_revenue | Revenue target |
| target_quantity | Quantity target |
| target_new_customers | New customer target |
| is_latest_flag | Latest plan indicator |

#### fact_distributor_orders

**Grain: One row = one distributor order**

| Column | Description |
|---|---|
| distributor_order_key | Surrogate order key |
| date_key | Order date key |
| distributor_key | Distributor dimension key |
| order_id | Business order ID |
| product_id | Product ID |
| product_category | Product category |
| qty_ordered | Ordered quantity |
| qty_delivered | Delivered quantity |
| fill_rate_pct | Order fulfillment rate |
| unit_price_list | List price |
| distributor_price | Distributor price |
| gross_amount | Gross order value |
| delivered_amount | Delivered order value |
| expected_delivery_date | Expected delivery date |
| actual_delivery_date | Actual delivery date |
| ontime_delivery | On-time delivery indicator |
| delivery_status | Delivery status |
| payment_terms | Payment terms |

---

## Main Process

### Data Ingestion

Python is used to read the source CSV and Excel files and load them into PostgreSQL.

The ingestion process keeps the original data available in the Raw layer before business transformations are applied.

The process includes:

- Reading CSV and Excel files.
- Loading data into PostgreSQL.
- Adding ingestion metadata.
- Tracking source and batch information.

### Data Profiling

The raw datasets are profiled before transformation to identify potential data quality issues.

The profiling checks:

- Total row counts.
- NULL values.
- Duplicate records.
- Data types.
- Missing business keys.
- Date fields.
- Potential data quality issues.

This step helps identify problems before creating analytical tables.

### Data Cleaning & Transformation

The Staging layer applies SQL transformations to prepare clean datasets.

The main transformations include:

- Trimming text values.
- Standardizing data types.
- Converting text dates into DATE fields.
- Handling missing values.
- Removing duplicates.
- Validating business keys.
- Preparing standardized staging tables.

### Dimensional Modeling

The cleaned staging data is transformed into a Star Schema.

The modeling process includes:

- Creating dimension tables.
- Creating surrogate keys.
- Creating fact tables.
- Defining the grain of each fact table.
- Establishing relationships between facts and dimensions.
- Applying SCD Type 1 or Type 2 depending on the business requirement.

### Surrogate Keys

Surrogate keys are used in the Gold layer to provide stable warehouse identifiers.

For example:

```text
Business Key
employee_id
      ↓
dim_employees
      ↓
employee_key
```

Fact tables use surrogate keys when connecting to dimensions.

### Slowly Changing Dimensions

SCD Type 2 is used when historical changes need to be preserved.

For example:

```text
Employee 101
Region A
01/01/2025 → 30/06/2025

Employee 101
Region B
01/07/2025 → Current
```

Instead of overwriting the previous value, both versions are retained.

The validity period is represented by:

- `effective_from`
- `effective_to`
- `is_current`

This allows historical transactions to be analyzed using the attributes that were valid at the time of the transaction.

### Fact Table Construction

Fact tables are created after the dimensions are available.

Fact records are connected to dimensions through surrogate keys such as:

```text
date_key
employee_key
customer_key
product_key
distributor_key
```

Business measures are stored in the fact tables, including:

```text
quantity
sales_amount
profit_amount
return_amount
target_revenue
qty_ordered
qty_delivered
```

### Analytical Use Cases

The resulting warehouse can support:

**Sales Performance**

- Revenue by month.
- Revenue by product.
- Revenue by customer.
- Revenue by employee.
- Quantity sold.
- Profit performance.

**Sales vs Target**

- Actual revenue.
- Target revenue.
- Achievement percentage.
- Target variance.

**Customer Analysis**

- Customer contribution.
- Customer segmentation.
- Loyalty tier analysis.
- Customer revenue.

**Product Analysis**

- Product sales.
- Category performance.
- Revenue contribution.
- Product profitability.

**Distributor Analysis**

- Distributor order volume.
- Fill rate.
- Delivered amount.
- On-time delivery.
- Distributor performance.

**Return Analysis**

- Return quantity.
- Return amount.
- Return reasons.
- Returns by product.
- Returns by customer.
- Returns by employee.

---

## Final Conclusion & Recommendations

This project demonstrates how raw operational data can be transformed into a structured data warehouse suitable for business analytics.

### Key Takeaways

- Use a layered Raw → Staging → Gold architecture to separate ingestion, transformation, and analytical modeling.
- Use a Star Schema to make business analysis easier and more consistent.
- Use surrogate keys to establish stable relationships between fact and dimension tables.
- Apply SCD Type 2 when historical dimension changes need to be preserved.
- Define the grain of each fact table before building the model.
- Perform data profiling and quality checks before creating analytical tables.
- Keep ingestion metadata primarily in the Raw layer for data lineage and traceability.
- Keep the Gold layer focused on business-oriented analytical data.

The resulting warehouse provides a foundation for future SQL analysis, reporting, and BI dashboards.
