data "google_client_config" "this" {}

resource "google_storage_bucket" "this" {
  name                        = var.name
  location                    = var.location
  storage_class               = var.storage_class
  force_destroy               = var.force_destroy
  uniform_bucket_level_access = var.uniform_bucket_level_access
  public_access_prevention    = var.public_access_prevention
  labels                      = var.labels

  versioning {
    enabled = var.versioning
  }

  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rules
    content {
      action {
        type          = lifecycle_rule.value.action.type
        storage_class = lifecycle_rule.value.action.storage_class
      }
      condition {
        age                   = lifecycle_rule.value.condition.age
        created_before        = lifecycle_rule.value.condition.created_before
        with_state            = lifecycle_rule.value.condition.with_state
        matches_storage_class = lifecycle_rule.value.condition.matches_storage_class
        num_newer_versions    = lifecycle_rule.value.condition.num_newer_versions
      }
    }
  }

  dynamic "cors" {
    for_each = var.cors
    content {
      origin          = cors.value.origins
      method          = cors.value.methods
      response_header = cors.value.response_headers
      max_age_seconds = cors.value.max_age_seconds
    }
  }
}

locals {
  iam_bindings = flatten([
    for binding in var.iam : [
      for member in binding.members : {
        role   = binding.role
        member = member
      }
    ]
  ])
}

resource "google_storage_bucket_iam_member" "this" {
  for_each = { for binding in local.iam_bindings : "${binding.role}-${binding.member}" => binding }
  bucket   = google_storage_bucket.this.name
  role     = each.value.role
  member   = each.value.member
}
