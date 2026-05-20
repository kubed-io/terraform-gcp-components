data "google_client_config" "this" {}

locals {
  creds_str = base64decode(google_service_account_key.this.private_key)
  creds     = jsondecode(local.creds_str)
}

resource "google_service_account" "this" {
  account_id                   = var.name
  display_name                 = var.display_name
  description                  = var.description
  create_ignore_already_exists = true
}

resource "google_service_account_key" "this" {
  service_account_id = google_service_account.this.name
}

resource "google_project_iam_member" "this" {
  for_each = toset(var.roles)
  project  = data.google_client_config.this.project
  role     = each.value
  member   = "serviceAccount:${google_service_account.this.email}"
}

resource "google_storage_hmac_key" "this" {
  count                 = var.hmac_key ? 1 : 0
  service_account_email = google_service_account.this.email
}
