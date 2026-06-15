
"""
BrightMart full dbt orchestration DAG.

Purpose:
- Run dbt from Airflow after the BrightMart SQLite data has been loaded into Snowflake RAW.
- Optionally load exported CSV files into Snowflake RAW when LOAD_RAW_FROM_CSV=true.
- Demonstrate real orchestration concepts: dependency order, retries, logs, observability, and diagnostic anomaly testing.
"""

import os
from datetime import timedelta

import pendulum
from airflow.decorators import dag
from airflow.operators.bash import BashOperator
from airflow.operators.empty import EmptyOperator
from airflow.utils.task_group import TaskGroup
from airflow.utils.trigger_rule import TriggerRule

DBT_PROJECT_DIR = os.environ.get("DBT_PROJECT_DIR", "/usr/local/airflow/include/dbt/brightmart_retail")
DBT_PROFILES_DIR = os.environ.get("DBT_PROFILES_DIR", "/usr/local/airflow/include/profiles")
DBT_TARGET = os.environ.get("DBT_TARGET", "dev")


def dbt_task(task_id: str, dbt_command: str, retries: int = 1, trigger_rule: str = TriggerRule.ALL_SUCCESS):
    """Create a BashOperator that runs one dbt command from the mounted dbt project."""
    return BashOperator(
        task_id=task_id,
        bash_command=f"""
        set -e
        echo "Working directory: {DBT_PROJECT_DIR}"
        cd "{DBT_PROJECT_DIR}"
        echo "Running dbt command: dbt {dbt_command} --profiles-dir {DBT_PROFILES_DIR} --target {DBT_TARGET}"
        dbt {dbt_command} --profiles-dir "{DBT_PROFILES_DIR}" --target "{DBT_TARGET}"
        """,
        append_env=True,
        env={
            "DBT_PROJECT_DIR": DBT_PROJECT_DIR,
            "DBT_PROFILES_DIR": DBT_PROFILES_DIR,
            "DBT_TARGET": DBT_TARGET,
        },
        retries=retries,
        retry_delay=timedelta(minutes=2),
        execution_timeout=timedelta(minutes=90),
        trigger_rule=trigger_rule,
    )


@dag(
    dag_id="brightmart_full_dbt_orchestration",
    description="BrightMart SQLite-to-Snowflake Kimball warehouse orchestration using Airflow and dbt Core.",
    start_date=pendulum.datetime(2026, 5, 1, tz="Asia/Karachi"),
    schedule="@daily",
    catchup=False,
    max_active_runs=1,
    default_args={"owner": "brightmart-data-engineering"},
    tags=["brightmart", "dbt", "snowflake", "kimball", "warehouse"],
)
def brightmart_full_dbt_orchestration():
    start = EmptyOperator(task_id="start")

    validate_container_mounts = BashOperator(
        task_id="validate_container_mounts",
        bash_command=f"""
        set -e
        echo "Checking Airflow container mounts..."
        test -d "{DBT_PROJECT_DIR}"
        test -f "{DBT_PROJECT_DIR}/dbt_project.yml"
        test -f "{DBT_PROFILES_DIR}/profiles.yml"
        echo "dbt project and profiles.yml are available."
        dbt --version
        """,
        append_env=True,
    )

    optional_load_raw_csv = BashOperator(
        task_id="optional_load_raw_csv_to_snowflake",
        bash_command="python /usr/local/airflow/include/scripts/load_csv_to_snowflake.py",
        append_env=True,
        retries=0,
    )

    dbt_deps = dbt_task("dbt_deps", "deps")
    dbt_debug = dbt_task("dbt_debug", "debug")
    dbt_parse = dbt_task("dbt_parse", "parse")

    with TaskGroup("seeds") as seeds:
        dbt_seed = dbt_task("dbt_seed", "seed")

    with TaskGroup("staging_layer") as staging_layer:
        run_staging = dbt_task("run_staging_models", "run --select path:models/staging")
        test_staging = dbt_task("test_staging_models", "test --select path:models/staging", retries=0)
        run_staging >> test_staging

    with TaskGroup("snapshot_layer") as snapshot_layer:
        run_snapshots = dbt_task("run_snapshots", "snapshot")

    with TaskGroup("intermediate_layer") as intermediate_layer:
        run_intermediate = dbt_task("run_intermediate_models", "run --select path:models/intermediate")

    with TaskGroup("mart_layer") as mart_layer:
        run_dimensions = dbt_task("run_dimension_models", "run --select path:models/marts/dimensions")
        run_facts = dbt_task("run_fact_models", "run --select path:models/marts/facts")
        run_dq_models = dbt_task("run_dq_models", "run --select path:models/marts/dq")
        test_marts = dbt_task("test_mart_models", "test --select path:models/marts", retries=0)
        run_dimensions >> run_facts >> run_dq_models >> test_marts

    with TaskGroup("diagnostic_anomaly_tests") as diagnostic_anomaly_tests:
        # These tests may fail intentionally when source anomalies are still present.
        # We keep the DAG moving so students can inspect the log and learn from failed checks.
        run_diagnostic_tests = BashOperator(
            task_id="run_diagnostic_tests_soft_fail",
            bash_command=f"""
            cd "{DBT_PROJECT_DIR}"
            echo "Running diagnostic anomaly tests. These may fail by design before cleaning rules are complete."
            dbt test --select path:tests/diagnostic --profiles-dir "{DBT_PROFILES_DIR}" --target "{DBT_TARGET}" || true
            echo "Diagnostic test step completed. Review dbt logs and run_results.json for failures."
            """,
            append_env=True,
            retries=0,
        )

    with TaskGroup("analysis_and_documentation") as analysis_and_documentation:
        compile_analysis = dbt_task("compile_analysis_sql", "compile --select path:analyses", trigger_rule=TriggerRule.ALL_DONE)
        generate_docs = dbt_task("generate_dbt_docs", "docs generate", trigger_rule=TriggerRule.ALL_DONE)
        dump_artifacts = BashOperator(
            task_id="dump_dbt_artifacts_to_log",
            bash_command=f"""
            TARGET="{DBT_PROJECT_DIR}/target"
            echo "===== ARTIFACT FILE LISTING ====="
            ls -lh "$TARGET"
            echo ""
            echo "===== run_results.json ====="
            python3 -c "import json,sys; d=json.load(open(sys.argv[1])); print(json.dumps(d,indent=2))" "$TARGET/run_results.json"
            echo ""
            echo "===== manifest.json (metadata only) ====="
            python3 -c "import json,sys; d=json.load(open(sys.argv[1])); print(json.dumps(d.get('metadata',{{}}),indent=2))" "$TARGET/manifest.json"
            echo ""
            echo "===== catalog.json (metadata only) ====="
            python3 -c "import json,sys; d=json.load(open(sys.argv[1])); print(json.dumps(d.get('metadata',{{}}),indent=2))" "$TARGET/catalog.json"
            echo ""
            echo "===== ALL ARTIFACTS CONFIRMED ====="
            """,
            append_env=True,
            retries=0,
            trigger_rule=TriggerRule.ALL_DONE,
        )
        compile_analysis >> generate_docs >> dump_artifacts

    end = EmptyOperator(task_id="end", trigger_rule=TriggerRule.ALL_DONE)

    start >> validate_container_mounts >> optional_load_raw_csv >> dbt_deps >> dbt_debug >> dbt_parse
    dbt_parse >> seeds >> staging_layer >> snapshot_layer >> intermediate_layer >> mart_layer
    mart_layer >> diagnostic_anomaly_tests >> analysis_and_documentation >> end


brightmart_full_dbt_orchestration()
