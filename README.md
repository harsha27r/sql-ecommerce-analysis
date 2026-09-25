# SQL E-Commerce Analysis

Advanced SQL analytics on the Olist Brazilian E-Commerce dataset (96,000+ customers, 100,000+ orders).

## What This Covers

10 analytical queries demonstrating real-world SQL patterns used in data analyst roles:

- **Revenue trends** — monthly revenue and new customer acquisition over time
- **Customer segmentation** — one-time, occasional, regular, and loyal buyer tiers
- **Window functions** — RANK() to identify top customers within each state
- **Running totals** — cumulative revenue using SUM() OVER()
- **Repeat purchase analysis** — repeat rate by state to identify retention patterns
- **Delivery performance** — late delivery rate by state
- **Geographic analysis** — revenue and customer distribution across Brazilian states

## Tech Stack

- **SQL** — window functions, CTEs, CASE statements, aggregations
- **DuckDB** — analytical query engine
- **Python / pandas** — query execution and result display
- **dbt** — upstream data transformation (see dbt-ecommerce-pipeline repo)

## Key Findings

- São Paulo (SP) leads in revenue at $6M+ across 40,000+ customers
- 97% of customers are one-time buyers — significant retention opportunity
- Top customer lifetime value exceeds $13,600
- Repeat purchase rates range from 3-4% across top states

## How to Run

```bash
pip install duckdb pandas
python test_queries.py
```

> Requires the DuckDB database from the dbt-ecommerce-pipeline project.