variable "name" {
  type        = string
  description = "Name of the bucket."
}

variable "location" {
  type        = string
  description = "GCS location for the bucket (e.g. US, EU, us-central1)."
  default     = "US"
}

variable "storage_class" {
  type        = string
  description = "Storage class of the bucket."
  default     = "STANDARD"
}

variable "versioning" {
  type        = bool
  description = "Enable versioning for the bucket."
  default     = false
}

variable "uniform_bucket_level_access" {
  type        = bool
  description = "Enable uniform bucket-level access."
  default     = true
}

variable "public_access_prevention" {
  type        = string
  description = "Public access prevention setting (inherited, enforced)."
  default     = "enforced"
}

variable "force_destroy" {
  type        = bool
  description = "Allow bucket to be destroyed even if it contains objects."
  default     = false
}

variable "lifecycle_rules" {
  type = list(object({
    action = object({
      type          = string
      storage_class = optional(string)
    })
    condition = object({
      age                   = optional(number)
      created_before        = optional(string)
      with_state            = optional(string)
      matches_storage_class = optional(list(string))
      num_newer_versions    = optional(number)
    })
  }))
  description = "Lifecycle rules for the bucket."
  default     = []
}

variable "iam" {
  type = list(object({
    role    = string
    members = list(string)
  }))
  description = "IAM bindings for the bucket."
  default     = []
}

variable "cors" {
  type = list(object({
    origins          = optional(list(string))
    methods          = optional(list(string))
    response_headers = optional(list(string))
    max_age_seconds  = optional(number)
  }))
  description = "CORS configuration for the bucket."
  default     = []
}

variable "labels" {
  type        = map(string)
  description = "Labels to apply to the bucket."
  default     = {}
}
