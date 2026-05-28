module "identity_pool_provider" {
  source = "../../modules/identity-pool-provider"

  name    = "github"
  pool_id = "example-pool"

  display_name = "GitHub Actions"
  description  = "GitHub Actions OIDC provider for the example org"

  attribute_condition = "assertion.repository_owner_id == '123456789'"

  attribute_mapping = {
    "google.subject"                = "assertion.sub"
    "attribute.actor"               = "assertion.actor"
    "attribute.repository"          = "assertion.repository"
    "attribute.repository_owner"    = "assertion.repository_owner"
    "attribute.repository_owner_id" = "assertion.repository_owner_id"
  }

  members = [
    {
      serviceAccountName = "example-app"
      condition          = "attribute.repository_owner_id/123456789"
    },
  ]
}

output "audience" {
  value = module.identity_pool_provider.audience
}
