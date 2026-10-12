data "google_client_config" "this" {}

locals {
  project  = data.google_client_config.this.project
  owner_id = coalesce(var.owner_id, var.name)
}
