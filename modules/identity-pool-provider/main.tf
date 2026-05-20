data "google_client_config" "this" {}

data "google_project" "this" {
  project_id = data.google_client_config.this.project
}

resource "google_iam_workload_identity_pool_provider" "this" {
  workload_identity_pool_id          = var.pool_id
  workload_identity_pool_provider_id = var.name
  display_name                       = var.display_name
  description                        = var.description
  disabled                           = var.disabled
  attribute_mapping                  = var.attribute_mapping
  attribute_condition                = var.attribute_condition

  oidc {
    issuer_uri        = var.issuer_uri
    allowed_audiences = var.allowed_audiences
  }
}
