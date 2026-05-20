variable "name" {
  type        = string
  description = "Pool ID. Becomes workload_identity_pool_id."
}

variable "display_name" {
  type        = string
  description = "Human-friendly name shown in the GCP console."
  default     = ""
}

variable "description" {
  type        = string
  description = "Free-form description of the pool."
  default     = ""
}
