module "identity_pool" {
  source = "../../modules/identity-pool"

  name         = "example-pool"
  display_name = "Example Workload Identity Pool"
  description  = "Pool for external workloads to authenticate as GCP service accounts"
}

output "pool_name" {
  value = module.identity_pool.pool_name
}

output "project_number" {
  value = module.identity_pool.project_number
}
