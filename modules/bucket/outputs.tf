output "name" {
  value = google_storage_bucket.this.name
}

output "url" {
  value = google_storage_bucket.this.url
}

output "self_link" {
  value = google_storage_bucket.this.self_link
}

output "project" {
  value = data.google_client_config.this.project
}
