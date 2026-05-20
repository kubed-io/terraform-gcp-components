data "google_client_config" "this" {}

data "google_project" "this" {
  project_id = data.google_client_config.this.project
}

locals {
  principal_set_base = "principalSet://iam.googleapis.com/projects/${data.google_project.this.number}/locations/global/workloadIdentityPools/${var.pool_id}"
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

resource "google_service_account_iam_member" "members" {
  for_each           = { for m in var.members : m.serviceAccountName => m }
  service_account_id = "projects/${data.google_client_config.this.project}/serviceAccounts/${each.key}@${data.google_client_config.this.project}.iam.gserviceaccount.com"
  role               = "roles/iam.workloadIdentityUser"
  member             = "${local.principal_set_base}/${each.value.condition}"
}
