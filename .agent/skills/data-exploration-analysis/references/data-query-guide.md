# Data Query & Retrieval Guide

## 1. Inspect Before Loading
- Always check table schemas, column types, and total row counts (`COUNT(*)` or parquet metadata) before pulling data into memory.
- Identify timezones, primary keys, and potential many-to-many join traps upfront.

## 2. Safe Retrieval & Sampling
- Avoid arbitrary small limits (`LIMIT 50`) for EDA — they hide tail behavior and time drift.
- For large `.parquet` files or database tables, push column selection, filtering, and pre-aggregation to **SQL, DuckDB, or Polars** before materializing into `pandas`, or use explicit random/stratified sampling.

## 3. Separate Retrieval from Analysis
- **SQL / DuckDB / Polars layer:** column selection, coarse date bounds, joins, and pre-aggregation of massive logs/files.
- **Python / DataFrame layer:** statistical analysis, transformations, feature engineering, and validation.

## 4. Live-Data Validation
- Immediately verify loaded data: `df.shape`, `df.dtypes`, missingness %, duplicate keys, and `min`/`max` of numeric and datetime columns.
