output "gcs_bucket_name" {
  description = "The name of the created GCS bucket"
  value       = google_storage_bucket.medicaid_raw_bucket.name
}

output "bigquery_dataset_id" {
  description = "The ID of the created BigQuery dataset"
  value       = google_bigquery_dataset.sdud_raw_dataset.dataset_id
}