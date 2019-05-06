terraform {
  backend "gcs" {
    bucket  = "tf-state-prod"
    prefix  = "terraform/state"
  }
}

provider "google" {
  project     = "venky-staging"
  region      = "us-central1"
}

resource "google_composer_environment" "test" {
  name = "my-first-env"
  region = "us-central1"
  config {
    node_count = 4

    node_config {
      zone = "us-central1-a"
      machine_type = "n1-standard-1"

      network = "${google_compute_network.test.self_link}"
      subnetwork =  "${google_compute_subnetwork.test.self_link}"

      service_account = "${google_service_account.test.name}"
    }
  }

  depends_on = ["google_project_iam_member.composer-worker"]
}

resource "google_compute_network" "test" {
  name          = "composer-test-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "test" {
  name          = "composer-test-subnetwork"
  ip_cidr_range = "10.2.0.0/16"
  region        = "us-central1"
  network       = "${google_compute_network.test.self_link}"
}

resource "google_service_account" "test" {
  account_id   = "composer-env-account"
  display_name = "Test Service Account for Composer Environment"
}

resource "google_project_iam_member" "composer-worker" {
  role    = "roles/composer.admin"
  member  = "serviceAccount:${google_service_account.test.email}"
}
