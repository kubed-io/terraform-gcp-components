resource "google_dns_managed_zone" "this" {
  name          = var.name
  dns_name      = var.dns_name
  description   = var.description
  visibility    = var.visibility
  force_destroy = var.force_destroy
  labels        = var.labels

  dynamic "dnssec_config" {
    for_each = var.dnssec_config != null ? [var.dnssec_config] : []
    content {
      state         = dnssec_config.value.state
      non_existence = dnssec_config.value.non_existence
      kind          = dnssec_config.value.kind

      dynamic "default_key_specs" {
        for_each = dnssec_config.value.default_key_specs
        content {
          algorithm  = default_key_specs.value.algorithm
          key_length = default_key_specs.value.key_length
          key_type   = default_key_specs.value.key_type
          kind       = default_key_specs.value.kind
        }
      }
    }
  }

  dynamic "private_visibility_config" {
    for_each = var.private_visibility_config != null ? [var.private_visibility_config] : []
    content {
      dynamic "networks" {
        for_each = private_visibility_config.value.networks
        content {
          network_url = networks.value.network_url
        }
      }
    }
  }

  dynamic "cloud_logging_config" {
    for_each = var.cloud_logging_config != null ? [var.cloud_logging_config] : []
    content {
      enable_logging = cloud_logging_config.value.enabled
    }
  }
}
