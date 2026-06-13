$ErrorActionPreference = "Stop"
$folders = @("dags", "logs", "plugins", "config", "dbt", "profiles", "scripts", "sql", "data\exported_csv")
foreach ($folder in $folders) {
    if (!(Test-Path $folder)) { New-Item -ItemType Directory -Path $folder | Out-Null }
}
if (!(Test-Path ".env")) {
    Copy-Item ".env.example" ".env"
    Write-Host "Created .env from .env.example. Open .env and fill Snowflake values before starting Airflow." -ForegroundColor Yellow
}
Write-Host "Folder preparation complete." -ForegroundColor Green
