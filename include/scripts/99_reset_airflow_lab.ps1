$ErrorActionPreference = "Stop"
Write-Host "WARNING: This deletes Airflow metadata volumes and local logs." -ForegroundColor Red
$confirm = Read-Host "Type RESET to continue"
if ($confirm -eq "RESET") {
    docker compose down --volumes --remove-orphans
    Remove-Item -Recurse -Force logs -ErrorAction SilentlyContinue
    New-Item -ItemType Directory -Path logs | Out-Null
    Write-Host "Reset complete." -ForegroundColor Green
} else {
    Write-Host "Reset cancelled." -ForegroundColor Yellow
}
