from datetime import datetime, timedelta
import os
from airflow import DAG
from airflow.providers.google.cloud.transfers.gcs_to_bigquery import GCSToBigQueryOperator

PROJECT_ID = os.environ.get("GCP_PROJECT_ID")
DATASET_NAME = "sdud_raw"
TABLE_NAME = "yearly_drug_utilization"

with DAG(
    dag_id="gcs_to_bigquery_sdud",
    # These args will get passed on to each operator
    # You can override them on a per-task basis during operator initialization
    default_args={
        "depends_on_past": False,
        "retries": 1,
        "retry_delay": timedelta(minutes=5),
    },
    description="A simple DAG to load SDUD data from GCS to BigQuery",
    # schedule=timedelta(days=1), # For the purposes of this project, schedule will not be set.
    start_date=datetime(2026, 1, 1),
    catchup=False,
) as dag:

    load_csv = GCSToBigQueryOperator(
        task_id="gcs_to_bigquery",
        bucket="medicaid-raw",
        source_objects=["sdud-raw/sdud_raw_2025.csv"],
        destination_project_dataset_table=f"{DATASET_NAME}.{TABLE_NAME}",
        schema_fields=[
            {"name": "utilization_type", "type": "STRING", "mode": "NULLABLE"},
            {"name": "state", "type": "STRING", "mode": "NULLABLE"},
            {"name": "ndc", "type": "STRING", "mode": "NULLABLE"},
            {"name": "labeler_code", "type": "STRING", "mode": "NULLABLE"},
            {"name": "product_code", "type": "STRING", "mode": "NULLABLE"},
            {"name": "package_size", "type": "STRING", "mode": "NULLABLE"},
            {"name": "year", "type": "INTEGER", "mode": "NULLABLE"},
            {"name": "quarter", "type": "INTEGER", "mode": "NULLABLE"},
            {"name": "suppression_used", "type": "BOOLEAN", "mode": "NULLABLE"},
            {"name": "product_name", "type": "STRING", "mode": "NULLABLE"},
            {"name": "units_reimbursed", "type": "FLOAT", "mode": "NULLABLE"},
            {"name": "number_of_prescriptions", "type": "INTEGER", "mode": "NULLABLE"},
            {"name": "total_amount_reimbursed", "type": "FLOAT", "mode": "NULLABLE"},
            {"name": "medicaid_amount_reimbursed", "type": "FLOAT", "mode": "NULLABLE"},
            {"name": "non_medicaid_amount_reimbursed", "type": "FLOAT", "mode": "NULLABLE"},
        ],
        write_disposition="WRITE_TRUNCATE",
    )