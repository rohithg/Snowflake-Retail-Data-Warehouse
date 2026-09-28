# Snowflake Retail Data Warehouse

ELT pipeline on **Snowflake + dbt + Airflow** — star-schema dimensional models processing 200M+ records from ERP, CRM, and logistics sources.

## Architecture

```
ERP / CRM / Logistics ──Snowpipe──► RAW ──dbt──► STAGING ──► MARTS (star schema)
                                         ▲
                                    Airflow DAGs
```

### Layers

| Layer | Purpose |
|-------|---------|
| `raw` | Landed source extracts (append-only) |
| `staging` | Cleaned, typed, renamed (`stg_*`) |
| `intermediate` | Business joins / conformed keys |
| `marts` | Star schema dims + facts for BI |

### Sources modeled

- **ERP** — orders, order lines, products, inventory
- **CRM** — customers, accounts, opportunities
- **Logistics** — shipments, carriers, delivery events

## Quick start

```bash
# 1. Create Snowflake objects
snowsql -f sql/ddl/01_databases_and_schemas.sql
snowsql -f sql/ddl/02_raw_tables.sql

# 2. Install dbt deps and run
cd dbt_project
dbt deps
dbt seed
dbt run
dbt test

# 3. Point Airflow at airflow/dags/retail_elt_dag.py
```

## Star schema

**Dimensions:** `dim_customer`, `dim_product`, `dim_date`, `dim_carrier`, `dim_location`  
**Facts:** `fct_orders`, `fct_order_items`, `fct_shipments`, `fct_inventory_snapshot`

## Design notes

- Surrogate keys via `dbt_utils.generate_surrogate_key`
- SCD Type 2 on `dim_customer` and `dim_product`
- Incremental facts partitioned by `order_date` / `shipment_date`
- Data tests on uniqueness, not-null, and referential integrity

## Project layout

```
airflow/dags/          Orchestration
dbt_project/           Transformations + tests
sql/ddl/               Snowflake DDL
sql/snowpipe/          Ingestion pipes
docs/                  Data dictionary
scripts/               Utility helpers
```
