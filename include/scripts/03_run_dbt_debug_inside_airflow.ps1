$ErrorActionPreference = "Stop"
Write-Host "Running dbt debug inside the Airflow scheduler container..." -ForegroundColor Cyan
docker compose exec airflow-scheduler bash -lc 'cd /opt/airflow/dbt/brightmart_retail && dbt debug --profiles-dir /opt/airflow/profiles --target dev'
