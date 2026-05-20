variable "name" {
  type        = string
  description = "Provider ID under the pool. Becomes workload_identity_pool_provider_id (4-32 chars, lowercase + hyphens)."
}

variable "pool_id" {
  type        = string
  description = "Existing workload identity pool ID this provider belongs to."
}

variable "display_name" {
  type        = string
  description = "Human-friendly name shown in the GCP console."
  default     = ""
}

variable "description" {
  type        = string
  description = "Free-form description of the provider."
  default     = ""
}

variable "disabled" {
  type        = bool
  description = "Whether the provider is disabled."
  default     = false
}

variable "issuer_uri" {
  type        = string
  description = "OIDC issuer URI. Defaults to GitHub Actions' issuer."
  default     = "https://token.actions.githubusercontent.com"
}

variable "allowed_audiences" {
  type        = list(string)
  description = "Allowed OIDC token audiences. Empty list uses the default audience (the full pool provider resource name)."
  default     = []
}

variable "attribute_mapping" {
  type        = map(string)
  description = "Mapping from external token claims to Google attributes. Must include google.subject."
  default = {
    "google.subject"       = "assertion.sub"
    "attribute.actor"      = "assertion.actor"
    "attribute.repository" = "assertion.repository"
  }
}

variable "members" {
  type = list(object({
    serviceAccountName = string
    condition          = string
  }))
  description = "Service accounts to grant workloadIdentityUser through this provider. serviceAccountName is the GCP SA account ID, condition is the principalSet suffix (e.g. attribute.repository_owner_id/102392839)."
  default = []
}

variable "attribute_condition" {
  type        = string
  description = "CEL expression that further restricts which tokens are accepted (e.g. assertion.repository_owner == 'kubed-io')."
  default     = null
}
