# BrightMart Airflow Orchestration Package

This package adds Apache Airflow orchestration to the BrightMart SQLite -> Snowflake -> dbt Kimball warehouse lab.

## Recommended classroom path on Windows

1. Install Docker Desktop with WSL2 backend enabled.
2. Open this folder in VS Code.
3. Open PowerShell in this folder.
4. Run `scripts\00_prepare_folders.ps1`.
5. Open `.env` and enter Snowflake credentials.
6. Run `scripts\01_build_and_start_airflow.ps1`.
7. Open `http://localhost:8080`.
8. Login with `airflow` / `airflow` unless changed in `.env`.
9. Trigger `brightmart_simple_dbt_build` first.
10. Trigger `brightmart_full_dbt_orchestration` after the simple run succeeds.

## Included assets

- `docker-compose.yml`: local Airflow lab environment.
- `Dockerfile`: custom Airflow image with dbt and Snowflake connector installed.
- `.env.example`: Airflow and Snowflake environment variables.
- `profiles/profiles.yml`: dbt profile using environment variables.
- `dags/brightmart_simple_dbt_build.py`: beginner DAG.
- `dags/brightmart_full_dbt_orchestration.py`: full dbt orchestration DAG.
- `scripts/*.ps1`: Windows helper scripts.
- `scripts/load_csv_to_snowflake.py`: optional raw CSV load script.
- `dbt/brightmart_retail`: BrightMart dbt project skeleton.
- `sql`: Snowflake raw setup and quality probe SQL files.

## Important note

This package is for classroom learning and local development. It is not a production Airflow deployment.
