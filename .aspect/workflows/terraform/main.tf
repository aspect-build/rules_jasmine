terraform {
  required_version = "~> 1.4.0"

  backend "gcs" {
    bucket = "aw-deployment-terraform-state-rules-jasmine"
    prefix = "terraform/state"
  }
}

provider "google" {
  project = "aw-deployment-rules-jasmine"
  region  = "us-west2"
}
