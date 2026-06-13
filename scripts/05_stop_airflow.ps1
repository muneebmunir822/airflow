$ErrorActionPreference = "Stop"
docker compose down
Write-Host "Airflow containers stopped. Volumes are preserved." -ForegroundColor Green
