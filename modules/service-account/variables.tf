variable "name" {
  type        = string
  description = "Account ID for the service account."
}

variable "display_name" {
  type        = string
  description = "Display name shown in the GCP console."
}

variable "description" {
  type        = string
  description = "Free-form description of the service account."
}

variable "roles" {
  type        = list(string)
  description = "IAM roles to grant to the service account at the project level."
  default     = []
}

variable "bindings" {
  type = map(object({
    role   = string
    member = string
  }))
  description = "SA-level IAM bindings granting other principals access to this service account (e.g. workload identity impersonation)."
  default = {}
}

variable "hmac_key" {
  type        = bool
  description = "Whether to create an HMAC key for this service account (for GCS interop access)."
  default     = false
}
