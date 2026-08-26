# Sales Data Warehouse & Analytics

**PostgreSQL • Python • SQL • Power BI**

An end-to-end sales data warehouse and analytics project that transforms raw operational data into structured analytical datasets using a **Bronze → Silver → Gold** architecture.

The project covers data ingestion, data profiling, data cleaning, dimensional modeling, SCD Type 1 / Type 2, SQL transformation, data marts, and Power BI reporting.

## Table of Contents

1. [ Background & Overview](#-background--overview)
2. [ Data Architecture](#-data-architecture)
3. [ Dataset Description](#-dataset-description)
4. [ Data Pipeline](#-data-pipeline)
5. [ Silver Layer — Data Cleaning](#-silver-layer--data-cleaning)
6. [ Gold Layer — Data Warehouse](#-gold-layer--data-warehouse)
7. [ Fact & Dimension Tables](#-fact--dimension-tables)
8. [ Analytics & Power BI](#-analytics--power-bi)
9. [ Tools & Technologies](#-tools--technologies)
10. [ Repository Structure](#-repository-structure)
11. [ Security](#-security)
12. [ Key Takeaways](#-key-takeaways)

---

# Background & Overview

## Objective

The objective of this project is to build a structured **Sales Data Warehouse** that transforms raw operational data into reliable analytical datasets for business reporting and decision-making.

The project follows an end-to-end workflow:

```text
Raw Data → Bronze → Silver → Gold → Data Mart → Power BI
```

## Business Questions

The warehouse is designed to support questions such as:

- How are sales performing over time?
- Which employees generate the most revenue?
- How does actual sales performance compare with targets?
- Which products and categories contribute the most revenue?
- How are customers distributed across loyalty tiers?
- How are distributors performing?
- What is the impact of returned products?
- How can historical employee and distributor changes be reflected in reporting?

---

# Data Architecture

The project follows a layered data warehouse architecture:

```text
Source Files
    │
    ▼
Bronze / Raw
Raw data + ingestion metadata
    │
    ▼
Silver / Staging
Cleaning + standardization + validation
    │
    ▼
Gold / Data Warehouse
Dimensions + Facts + Star Schema
    │
    ▼
Power BI

# Dataset Description

The project uses source datasets representing:

- Sales transactions
- Sales targets
- Customer master
- Product master
- Employee master
- Distributor information
- Distributor orders
- Return transactions
- Promotion information
- Territory mapping

Source data is first loaded into the **Bronze / Raw** layer before being transformed into Silver and Gold.

---

# Data Pipeline

## 1⃣ Bronze Layer

The Bronze layer stores source data with minimal transformation.

### Main responsibilities

- Load source files into PostgreSQL
- Preserve source information
- Add ingestion metadata
- Track pipeline batches
- Maintain raw data for traceability

Typical metadata:

```text
_source_file
_source_platform
_ingested_at
_batch_id
```

---

# Silver Layer — Data Cleaning

The Silver layer transforms raw source data into cleaner and more consistent datasets.

### Data Type Standardization

- Convert text dates into `DATE`
- Convert numeric fields into appropriate numeric types
- Standardize text fields

### Data Cleaning

- Trim unnecessary spaces
- Handle NULL values
- Standardize categorical values
- Remove duplicate records
- Normalize business keys

### Data Validation

- Duplicate business keys
- Missing values
- Invalid dates
- Invalid numeric values
- Referential integrity

---

# Gold Layer — Data Warehouse

The Gold layer implements a **Star Schema** consisting of dimension tables, fact tables, and analytical marts.

```text
                         dim_date


dim_customers  fact_sales  dim_products


                     dim_employees


                    dim_distributors
```

---

# Fact & Dimension Tables

| Table | Type | Purpose | SCD |
|---|---|---|---|
| `dim_date` | Dimension | Calendar: day, week, month, quarter, year, FY | Static |
| `dim_employees` | Dimension | Employee information and historical changes | Type 2 |
| `dim_customers` | Dimension | Customer information and loyalty tier | Type 1 |
| `dim_products` | Dimension | Product, category and cost information | Type 1 |
| `dim_distributors` | Dimension | Distributor information, level and channel | Type 2 |
| `fact_sales` | Fact | Sales transactions | 1 line item |
| `fact_targets` | Fact | Employee/month/version targets | Temporal |
| `fact_returns` | Fact | Returned products | — |
| `fact_distributor_orders` | Fact | Distributor orders and delivery performance | — |
| `mart_sales_vs_target` | Mart | Actual vs target by month | — |
| `mart_distributor_performance` | Mart | Distributor performance | — |

---

# `dim_date`

The `dim_date` table is the central calendar dimension.

Key attributes include:

```text
date_key
date_day
day
week
month
month_name
quarter
year
fiscal_year
```

The calendar supports daily, weekly, monthly, quarterly, and fiscal-year analysis.

---

# `dim_employees`

`dim_employees` uses **SCD Type 2** to preserve employee history.

When an employee changes attributes such as region or team, the previous record is not overwritten.

```text
Old record
effective_to = change date - 1

New record
effective_from = change date
```

When joining employee information to a fact table, the transaction date is used to identify the correct historical version:

```sql
ON emp.employee_id = fact.employee_id
AND fact.date BETWEEN emp.effective_from
                  AND emp.effective_to
```

---

# `dim_customers`

`dim_customers` stores customer information used for sales analysis.

Typical attributes:

```text
customer_key
customer_id
customer_name
customer_type
loyalty_tier
join_date
```

The dimension follows **SCD Type 1**, meaning updates overwrite previous attribute values.

---

# `dim_products`

`dim_products` stores product information.

Typical attributes:

```text
product_key
product_id
product_name
category
sub_category
unit
unit_price
cost_price
status
launch_date
```

---

# `dim_distributors`

`dim_distributors` stores distributor information and historical changes.

Typical attributes:

```text
distributor_key
distributor_id
distributor_name
distributor_level
channel
effective_from
effective_to
is_current
```

The dimension uses **SCD Type 2**.

---

# `fact_sales`

`fact_sales` stores sales transactions at:

> **1 line item = 1 fact row**

Typical fields:

```text
sales_key
date_key
employee_key
customer_key
product_key
distributor_key
quantity
unit_price
sales_amount
```

---

# `fact_targets`

`fact_targets` stores sales targets by:

```text
Employee
Month
Plan Version
```

Typical fields:

```text
target_key
date_key
employee_key
plan_version
version_date
target_revenue
target_quantity
target_new_customers
is_latest_flag
```

The current implementation links target records to the calendar dimension using target year and month:

```sql
LEFT JOIN dwh.dim_date d
       ON t.year = d.year
      AND t.month = d.month
```

The business grain is:

> **1 employee × 1 month × 1 plan version**

A future refinement is to use the **start of month** when linking monthly targets to the daily calendar dimension, so each monthly target maps to a single calendar date.

---

# `fact_returns`

`fact_returns` stores returned product transactions.

Typical fields:

```text
return_id
original_order_id
date_key
customer_key
employee_key
product_key
return_quantity
unit_price
return_amount
return_reason
status
```

---

# `fact_distributor_orders`

`fact_distributor_orders` tracks distributor orders and delivery performance.

Key measures include:

```text
distributor_order_key
date_key
distributor_key
order_id
product_id
qty_ordered
qty_delivered
fill_rate_pct
gross_amount
delivered_amount
ontime_delivery
delivery_status
payment_terms
```

---

# `mart_sales_vs_target`

`mart_sales_vs_target` compares actual sales performance against sales targets.

Typical metrics:

```text
Actual Sales
Target Sales
Achievement Rate
```

```text
Achievement Rate =
Actual Sales / Target Sales
```

This mart supports Power BI reporting and helps identify employees exceeding or falling below targets.

---

# `mart_distributor_performance`

The distributor performance mart provides aggregated distributor KPIs, including:

- Total orders
- Quantity ordered
- Quantity delivered
- Fill rate
- Gross order value
- Delivered value
- On-time delivery rate

---

# Analytics & Power BI

The Gold and Mart layers provide analytical datasets for Power BI.

### Sales Performance

- Total Revenue
- Sales Quantity
- Monthly Sales
- Sales by Employee
- Sales by Product
- Sales by Category
- Sales by Customer

### Target Performance

- Actual Sales
- Target Sales
- Achievement Rate
- Monthly Target Performance
- Employee Performance

### Customer Analytics

- Customer distribution
- Loyalty tier
- Customer sales contribution

### Product Analytics

- Revenue by product
- Revenue by category
- Product quantity
- Product profitability

### Distributor Analytics

- Order quantity
- Delivery quantity
- Fill rate
- On-time delivery
- Distributor revenue

---

# Tools & Technologies

| Tool | Purpose |
|---|---|
| **Python** | Data ingestion and pipeline automation |
| **PostgreSQL** | Data warehouse database |
| **SQL** | Data transformation and analytics |
| **Power BI** | Dashboard and business reporting |
| **Git / GitHub** | Version control and portfolio management |

---

# Repository Structure

```text
sales-data-warehouse/

 README.md
 .gitignore

 00_setup/
    .env.example
    init_db.sql
    requirements.txt

 01_ingestion/
    loaders/
    connectors/
    utils/

 02_sql_analytics/
    01_data_profiling/
    02_silver/
    03_tests/
    04_gold/

 03_power_bi/
    sales_dashboard.pbix

 docs/
     data_dictionary.md
     data_issues.md
     assumptions_log.md
```

---

# Security

Sensitive credentials are not included in this repository.

The following file must remain local:

```text
.env
```

Commit only:

```text
.env.example
```

Example:

```env
DB_HOST=localhost
DB_PORT=5432
DB_NAME=your_database
DB_USER=your_username
DB_PASSWORD=your_password
```

The actual `.env` file is excluded using `.gitignore`.

---

# Data Quality & Validation

### Bronze

- Row count
- NULL percentage
- Duplicate records
- Source file tracking

### Silver

- Data type validation
- Business key uniqueness
- Duplicate removal
- Date validation
- NULL handling

### Gold

- Primary/surrogate key uniqueness
- Dimension-to-fact relationships
- SCD Type 2 validity
- Referential integrity
- Fact table grain validation

---

# Key Takeaways

This project demonstrates an end-to-end approach to building a sales analytics data warehouse:

```text
Raw Data
   ↓
Data Ingestion
   ↓
Data Profiling
   ↓
Data Cleaning
   ↓
Silver Layer
   ↓
Dimensional Modeling
   ↓
Gold Layer
   ↓
Data Mart
   ↓
Power BI
```

The project demonstrates practical skills in:

- Data ingestion
- Data profiling
- Data cleaning
- SQL transformation
- PostgreSQL
- Star Schema design
- Fact and dimension modeling
- SCD Type 1
- SCD Type 2
- Temporal data handling
- Data marts
- Business analytics
- Power BI reporting
- Git/GitHub version control

The overall goal is to transform raw operational data into a structured analytical data warehouse that supports reliable reporting, business analysis, and decision-making.

---

## ‍ Author

**Nguyễn Anh Thư**

Data Analyst Portfolio Project

**Skills:** SQL • Python • PostgreSQL • Power BI • Data Warehousing
