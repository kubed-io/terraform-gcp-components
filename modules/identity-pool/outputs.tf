output "pool_id" {
  value       = google_iam_workload_identity_pool.this.workload_identity_pool_id
  description = "The pool ID (matches metadata.name)."
}

output "pool_name" {
  value       = google_iam_workload_identity_pool.this.name
  description = "Full resource name: projects/<num>/locations/global/workloadIdentityPools/<id>."
}

output "project_id" {
  value       = data.google_client_config.this.project
  description = "GCP project ID."
}

output "project_number" {
  value       = data.google_project.this.number
  description = "GCP project number — needed when building principal/principalSet members."
}
