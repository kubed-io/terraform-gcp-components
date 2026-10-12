variable "name" {
  type        = string
  description = "Resource name for the managed zone (unique within the project)."
}

variable "dns_name" {
  type        = string
  description = "DNS name of the zone, ending with a dot (e.g. example.com.)."
}

variable "description" {
  type        = string
  description = "Free-text description of the zone."
  default     = "Managed by Terraform"
}

variable "visibility" {
  type        = string
  description = "Zone visibility: public or private."
  default     = "public"
}

variable "force_destroy" {
  type        = bool
  description = "Delete all records in the zone when destroying."
  default     = false
}

variable "dnssec_config" {
  type = object({
    state         = optional(string, "off")
    non_existence = optional(string)
    kind          = optional(string)
    default_key_specs = optional(list(object({
      algorithm  = optional(string)
      key_length = optional(number)
      key_type   = optional(string)
      kind       = optional(string)
    })), [])
  })
  description = "DNSSEC configuration. state: off, on, or transfer. non_existence: nsec or nsec3. default_key_specs requires both keySigning and zoneSigning entries."
  default     = null
}

variable "private_visibility_config" {
  type = object({
    networks = list(object({
      network_url = string
    }))
  })
  description = "VPC networks that can see this zone. Required when visibility is private."
  default     = null
}

variable "cloud_logging_config" {
  type = object({
    enabled = bool
  })
  description = "Cloud logging configuration for the zone."
  default     = null
}

variable "iam" {
  type = list(object({
    role    = string
    members = list(string)
    condition = optional(object({
      title       = string
      expression  = string
      description = optional(string)
    }))
  }))
  description = "IAM bindings for the zone. Each entry is authoritative for its role."
  default     = []
}

variable "records" {
  type = list(object({
    name    = string
    type    = string
    ttl     = optional(number, 300)
    rrdatas = optional(list(string))
    routing_policy = optional(object({
      health_check = optional(string)
      wrr = optional(list(object({
        weight  = number
        rrdatas = list(string)
      })), [])
      geo = optional(list(object({
        location = string
        rrdatas  = list(string)
      })), [])
      primary_backup = optional(object({
        trickle_ratio = optional(number)
        primary = object({
          external_endpoints = list(string)
        })
        backup_geo = list(object({
          location = string
          rrdatas  = list(string)
        }))
      }))
    }))
  }))
  description = "Record sets in the zone. name is relative (www) or @ for the apex. Each sets rrdatas or routing_policy, not both."
  default     = []

  validation {
    condition = alltrue([
      for r in var.records :
      (r.rrdatas == null) != (r.routing_policy == null)
    ])
    error_message = "Each record sets exactly one of rrdatas or routing_policy."
  }

  validation {
    condition = length(var.records) == length(distinct([
      for r in var.records :
      "${r.name} ${r.type}"
    ]))
    error_message = "Each name + type pair may appear once; put every value for it in one rrdatas list."
  }
}

variable "owner_id" {
  type        = string
  description = "Owner written into each record's external-dns TXT registry marker. Defaults to the zone name. Must differ from any external-dns --txt-owner-id sharing the zone."
  default     = null
}

variable "labels" {
  type        = map(string)
  description = "GCP labels to apply to the zone."
  default     = {}
}
