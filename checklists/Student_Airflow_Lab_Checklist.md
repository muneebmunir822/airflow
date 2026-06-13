# Student Airflow Lab Checklist

## Setup evidence
- [ ] Docker Desktop installed and running.
- [ ] VS Code opened at Airflow package folder.
- [ ] `.env` created from `.env.example`.
- [ ] Snowflake variables filled in `.env`.
- [ ] `docker compose build` succeeded.
- [ ] `docker compose up airflow-init` succeeded.
- [ ] Airflow UI opens at `http://localhost:8080`.
- [ ] Login works.

## dbt evidence
- [ ] `dbt debug` succeeds inside Airflow container.
- [ ] `brightmart_simple_dbt_build` DAG succeeds.
- [ ] `brightmart_full_dbt_orchestration` DAG is visible.
- [ ] Students can explain task dependencies.
- [ ] Students can read task logs.
- [ ] Students can explain why diagnostic tests may fail before cleaning is complete.

## Final submission
- [ ] Screenshot of Docker containers.
- [ ] Screenshot of Airflow DAG grid.
- [ ] Screenshot of one successful dbt task log.
- [ ] Screenshot of one failed/soft-failed anomaly check or explanation.
- [ ] Short write-up: how Airflow differs from dbt.
