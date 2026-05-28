data "google_client_config" "this" {}

locals {
  project = data.google_client_config.this.project
}
