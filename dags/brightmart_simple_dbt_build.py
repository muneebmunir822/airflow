
"""
BrightMart simple dbt build DAG.

Use this first when students are new to orchestration. It runs the common dbt command path:
debug -> deps -> build -> docs generate.
"""

import os
from datetime import timedelta

import pendulum
from airflow.decorators import dag
from airflow.operators.bash import BashOperator
from airflow.operators.empty import EmptyOperator

DBT_PROJECT_DIR = os.environ.get("DBT_PROJECT_DIR", "/opt/airflow/dbt/brightmart_retail")
DBT_PROFILES_DIR = os.environ.get("DBT_PROFILES_DIR", "/opt/airflow/profiles")
DBT_TARGET = os.environ.get("DBT_TARGET", "dev")


def dbt(task_id: str, command: str):
    return BashOperator(
        task_id=task_id,
        bash_command=f'cd "{DBT_PROJECT_DIR}" && dbt {command} --profiles-dir "{DBT_PROFILES_DIR}" --target "{DBT_TARGET}"',
        append_env=True,
        retries=1,
        retry_delay=timedelta(minutes=2),
    )


@dag(
    dag_id="brightmart_simple_dbt_build",
    start_date=pendulum.datetime(2026, 5, 1, tz="Asia/Karachi"),
    schedule=None,
    catchup=False,
    tags=["brightmart", "dbt", "beginner"],
)
def brightmart_simple_dbt_build():
    start = EmptyOperator(task_id="start")
    debug = dbt("dbt_debug", "debug")
    deps = dbt("dbt_deps", "deps")
    build = dbt("dbt_build", "build")
    docs = dbt("dbt_docs_generate", "docs generate")
    end = EmptyOperator(task_id="end")

    start >> debug >> deps >> build >> docs >> end


brightmart_simple_dbt_build()
