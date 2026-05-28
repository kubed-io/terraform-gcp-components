output "name" {
  value = google_dns_managed_zone.this.name
}

output "dns_name" {
  value = google_dns_managed_zone.this.dns_name
}

output "managed_zone_id" {
  value = google_dns_managed_zone.this.managed_zone_id
}

output "name_servers" {
  value = google_dns_managed_zone.this.name_servers
}

output "project" {
  value = data.google_client_config.this.project
}
