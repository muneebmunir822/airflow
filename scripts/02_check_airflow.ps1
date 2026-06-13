$ErrorActionPreference = "Stop"
Write-Host "Container status:" -ForegroundColor Cyan
docker compose ps
Write-Host "\nRecent scheduler logs:" -ForegroundColor Cyan
docker compose logs --tail=80 airflow-scheduler
