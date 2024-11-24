terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0" # Adjust version as needed
    }
  }
  required_version = ">= 1.0.0" # Optional: Enforce a specific Terraform version
}

provider "google" {
  project = var.project_id
  region  = var.region
}
