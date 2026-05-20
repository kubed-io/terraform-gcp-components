output "project_id" {
  value = data.google_client_config.this.project
}

output "email" {
  value = google_service_account.this.email
}

output "credentials" {
  value     = local.creds_str
  sensitive = true
}

output "private_key" {
  value     = local.creds.private_key
  sensitive = true
}

output "token_uri" {
  value     = local.creds.token_uri
  sensitive = true
}

output "client_id" {
  value     = local.creds.client_id
  sensitive = true
}

output "hmac_access_id" {
  value     = var.hmac_key ? google_storage_hmac_key.this[0].access_id : ""
  sensitive = true
}

output "hmac_secret" {
  value     = var.hmac_key ? google_storage_hmac_key.this[0].secret : ""
  sensitive = true
}
