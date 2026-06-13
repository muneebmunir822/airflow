# Instructor Runbook

## Recommended sequence
1. Explain orchestration vs transformation.
2. Show the package folder structure.
3. Start Docker Desktop.
4. Create `.env` from `.env.example`.
5. Start Airflow using the PowerShell scripts.
6. Open the UI and explain DAG, task, run, schedule, retry, and log.
7. Trigger the simple DAG.
8. Trigger the full DAG.
9. Open task logs for dbt commands.
10. Discuss diagnostic anomaly tests and production hard-fail vs soft-fail design.

## Common issues
- Docker is not running: start Docker Desktop.
- Port 8080 is already in use: stop the conflicting service or change the compose port.
- dbt debug fails: check `.env`, `profiles/profiles.yml`, role/warehouse/database permissions.
- DAG not visible: check scheduler logs and Python import errors.
- Custom packages missing: rebuild image using `docker compose build --no-cache`.
