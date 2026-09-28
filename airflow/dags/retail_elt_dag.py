"""Daily retail ELT: ingest freshness checks → dbt build → mart tests."""

from __future__ import annotations

from datetime import datetime, timedelta

from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.providers.common.sql.operators.sql import SQLCheckOperator

DEFAULT_ARGS = {
    "owner": "data-engineering",
    "depends_on_past": False,
    "retries": 2,
    "retry_delay": timedelta(minutes=10),
    "email_on_failure": True,
}

with DAG(
    dag_id="retail_snowflake_elt",
    description="Snowflake + dbt ELT for retail star schema",
    default_args=DEFAULT_ARGS,
    start_date=datetime(2026, 1, 1),
    schedule="0 6 * * *",
    catchup=False,
    max_active_runs=1,
    tags=["retail", "snowflake", "dbt"],
) as dag:
    check_raw_freshness = SQLCheckOperator(
        task_id="check_raw_freshness",
        conn_id="snowflake_default",
        sql="""
            select
              case
                when count(*) filter (
                  where _loaded_at >= dateadd(hour, -26, current_timestamp())
                ) > 0 then 1
                else 0
              end as ok
            from RETAIL_DW.raw_erp.orders
        """,
    )

    dbt_deps = BashOperator(
        task_id="dbt_deps",
        bash_command="cd /opt/airflow/dbt/retail_dw && dbt deps",
    )

    dbt_build = BashOperator(
        task_id="dbt_build",
        bash_command=(
            "cd /opt/airflow/dbt/retail_dw && "
            "dbt build --select staging intermediate marts --exclude package:dbt_utils"
        ),
    )

    dbt_test_marts = BashOperator(
        task_id="dbt_test_marts",
        bash_command="cd /opt/airflow/dbt/retail_dw && dbt test --select marts",
    )

    check_raw_freshness >> dbt_deps >> dbt_build >> dbt_test_marts
