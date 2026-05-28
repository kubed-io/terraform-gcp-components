module "service_account" {
  source = "../../modules/service-account"

  name         = "example-app"
  display_name = "Example App"
  description  = "Service account for example-app"

  roles = [
    "roles/storage.objectAdmin",
    "roles/secretmanager.secretAccessor",
  ]
}

output "email" {
  value = module.service_account.email
}

output "credentials" {
  value     = module.service_account.credentials
  sensitive = true
}
