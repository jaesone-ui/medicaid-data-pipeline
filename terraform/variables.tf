variable "project" { 
    type = string
    description = "GCP Project ID"
}

variable "region" {
  default = "us-central1"
  type = string
  description = "GCP Region"
}

variable "zone" {
  default = "us-central1-c"
}

variable "bucket" {
  type = string
  description = "GCS bucket name"
}

variable "dataset" {
  type = string
  description = "BQ dataset name"
}