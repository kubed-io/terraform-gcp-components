output "provider_id" {
  value       = google_iam_workload_identity_pool_provider.this.workload_identity_pool_provider_id
  description = "The provider ID."
}

output "provider_name" {
  value       = google_iam_workload_identity_pool_provider.this.name
  description = "Full resource name: projects/<num>/locations/global/workloadIdentityPools/<pool>/providers/<id>."
}

output "audience" {
  value       = "//iam.googleapis.com/${google_iam_workload_identity_pool_provider.this.name}"
  description = "Audience string to use in OIDC token requests."
}

output "project_id" {
  value       = data.google_client_config.this.project
  description = "GCP project ID."
}

output "project_number" {
  value       = data.google_project.this.number
  description = "GCP project number — needed when building principalSet members."
}
