terraform {
  required_providers {
    google = {
      version = "4.15.0"
      source  = "hashicorp/google"
    }
  }
}

provider "google" {
  project     = var.project
  region      = var.region
  zone        = var.zone
  credentials = var.key
}