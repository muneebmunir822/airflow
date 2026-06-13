$ErrorActionPreference = "Stop"
Write-Host "Triggering full BrightMart dbt orchestration DAG..." -ForegroundColor Cyan
docker compose exec airflow-scheduler airflow dags trigger brightmart_full_dbt_orchestration
Write-Host "Open http://localhost:8080 and inspect the DAG run." -ForegroundColor Green
