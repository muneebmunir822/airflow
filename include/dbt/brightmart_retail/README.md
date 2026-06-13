# BrightMart Retail dbt Project Skeleton

This project is designed for the BrightMart retail warehouse lab. It assumes that the normalized SQLite OLTP database has been exported to CSV and loaded into Snowflake table-for-table in `BRIGHTMART_DB.RAW`.

Recommended learning order:

1. Export SQLite tables to CSV using `scripts/export_sqlite_to_csv.py`.
2. Create Snowflake raw tables using `snowflake_sql/01_create_raw_tables.sql`.
3. Load CSVs through Snowsight or SnowSQL using `snowflake_sql/02_copy_into_raw_tables.sql` as a template.
4. Configure `profiles.yml`.
5. Run `dbt debug`, `dbt deps`, `dbt seed`, `dbt run --select staging`, `dbt run`, `dbt test`, `dbt snapshot`, and `dbt docs generate`.

This skeleton intentionally contains diagnostic tests that may warn because the source database has realistic anomalies. That is part of the lab.
