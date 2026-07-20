terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "6.8.0"
    }
  }
}

provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}

resource "google_storage_bucket" "medicaid_raw_bucket" {
  name          = var.bucket
  location      = "US"
  force_destroy = true
  uniform_bucket_level_access = true
}

resource "google_bigquery_dataset" "sdud_raw_dataset" {
  dataset_id                  = var.dataset
  description                 = "Raw SDUD data"
  location                    = "US"
  delete_contents_on_destroy  = true
}