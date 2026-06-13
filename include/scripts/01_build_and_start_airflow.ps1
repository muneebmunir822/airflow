$ErrorActionPreference = "Stop"
Write-Host "Building the custom Airflow image with dbt installed..." -ForegroundColor Cyan
docker compose build
Write-Host "Initializing Airflow metadata database and admin user..." -ForegroundColor Cyan
docker compose up airflow-init
Write-Host "Starting Airflow services..." -ForegroundColor Cyan
docker compose up -d
Write-Host "Airflow should be available at http://localhost:8080 after services become healthy." -ForegroundColor Green
