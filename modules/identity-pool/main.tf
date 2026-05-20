data "google_client_config" "this" {}

data "google_project" "this" {
  project_id = data.google_client_config.this.project
}

resource "google_iam_workload_identity_pool" "this" {
  workload_identity_pool_id = var.name
  display_name              = var.display_name
  description               = var.description
}
