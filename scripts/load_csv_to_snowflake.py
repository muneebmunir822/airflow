
"""Optional CSV-to-Snowflake raw loader for the BrightMart Airflow lab.

Default behavior: skip unless LOAD_RAW_FROM_CSV=true.

Expected folder:
    /opt/airflow/data/exported_csv

Expected files:
    one CSV per raw table, with file names matching the Snowflake raw table names.
    Example: customers.csv, products.csv, sales_orders.csv.

This script is intentionally generic for classroom usage. For production,
use a managed ingestion pattern, external stages, Snowpipe, or orchestration-specific operators.
"""

from __future__ import annotations

import os
from pathlib import Path

import snowflake.connector


CSV_DIR = Path(os.environ.get("CSV_DIR", "/opt/airflow/data/exported_csv"))
SQL_DIR = Path(os.environ.get("SQL_DIR", "/opt/airflow/sql"))
LOAD_RAW_FROM_CSV = os.environ.get("LOAD_RAW_FROM_CSV", "false").lower() == "true"
LOAD_MODE = os.environ.get("LOAD_MODE", "append").lower()
RAW_DATABASE = os.environ.get("RAW_DATABASE", os.environ.get("DBT_SNOWFLAKE_DATABASE", "BRIGHTMART_DB"))
RAW_SCHEMA = os.environ.get("RAW_SCHEMA", "RAW")
RAW_STAGE = os.environ.get("RAW_STAGE", "BRIGHTMART_RAW_CSV_STAGE")


def connect():
    required = [
        "DBT_SNOWFLAKE_ACCOUNT",
        "DBT_SNOWFLAKE_USER",
        "DBT_ENV_SECRET_SNOWFLAKE_PASSWORD",
        "DBT_SNOWFLAKE_WAREHOUSE",
        "DBT_SNOWFLAKE_ROLE",
    ]
    missing = [key for key in required if not os.environ.get(key)]
    if missing:
        raise RuntimeError(f"Missing required Snowflake environment variables: {missing}")

    return snowflake.connector.connect(
        account=os.environ["DBT_SNOWFLAKE_ACCOUNT"],
        user=os.environ["DBT_SNOWFLAKE_USER"],
        password=os.environ["DBT_ENV_SECRET_SNOWFLAKE_PASSWORD"],
        warehouse=os.environ["DBT_SNOWFLAKE_WAREHOUSE"],
        role=os.environ["DBT_SNOWFLAKE_ROLE"],
        database=RAW_DATABASE,
        schema=RAW_SCHEMA,
    )


def run_sql_file(cursor, path: Path):
    if not path.exists():
        print(f"SQL file not found, skipping: {path}")
        return
    sql = path.read_text(encoding="utf-8")
    statements = [stmt.strip() for stmt in sql.split(";") if stmt.strip()]
    for stmt in statements:
        cursor.execute(stmt)


def main():
    if not LOAD_RAW_FROM_CSV:
        print("LOAD_RAW_FROM_CSV=false, skipping optional raw CSV load.")
        return

    if not CSV_DIR.exists():
        print(f"CSV directory does not exist: {CSV_DIR}. Skipping raw load.")
        return

    csv_files = sorted(CSV_DIR.glob("*.csv"))
    if not csv_files:
        print(f"No CSV files found in {CSV_DIR}. Skipping raw load.")
        return

    print(f"Loading {len(csv_files)} CSV files into {RAW_DATABASE}.{RAW_SCHEMA} using stage {RAW_STAGE}.")
    conn = connect()
    try:
        cur = conn.cursor()
        cur.execute(f"CREATE DATABASE IF NOT EXISTS {RAW_DATABASE}")
        cur.execute(f"CREATE SCHEMA IF NOT EXISTS {RAW_DATABASE}.{RAW_SCHEMA}")
        run_sql_file(cur, SQL_DIR / "01_create_raw_tables.sql")
        cur.execute(f"CREATE OR REPLACE STAGE {RAW_DATABASE}.{RAW_SCHEMA}.{RAW_STAGE}")

        for csv_path in csv_files:
            table_name = csv_path.stem.upper()
            print(f"Staging {csv_path.name} for table {table_name}")
            cur.execute(f"PUT file://{csv_path.as_posix()} @{RAW_DATABASE}.{RAW_SCHEMA}.{RAW_STAGE} AUTO_COMPRESS=TRUE OVERWRITE=TRUE")
            if LOAD_MODE == "replace":
                cur.execute(f"TRUNCATE TABLE IF EXISTS {RAW_DATABASE}.{RAW_SCHEMA}.{table_name}")
            copy_sql = f"""
                COPY INTO {RAW_DATABASE}.{RAW_SCHEMA}.{table_name}
                FROM @{RAW_DATABASE}.{RAW_SCHEMA}.{RAW_STAGE}/{csv_path.name}.gz
                FILE_FORMAT = (
                    TYPE = CSV
                    SKIP_HEADER = 1
                    FIELD_OPTIONALLY_ENCLOSED_BY = '\"'
                    NULL_IF = ('', 'NULL', 'null')
                    ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE
                )
                ON_ERROR = CONTINUE
            """
            cur.execute(copy_sql)
            print(f"Loaded {table_name}. COPY result: {cur.fetchall()}")
    finally:
        conn.close()


if __name__ == "__main__":
    main()
