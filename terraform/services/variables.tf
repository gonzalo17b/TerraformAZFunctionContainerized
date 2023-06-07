variable "image_name" {
  type        = string
  description = "Az function image name"
  default     = "audit"
}

variable "image_tag" {
  type        = string
  description = "Az function image tag"
  default     = "v1"
}

variable "deployment_acr_name" {
  description = "ACR name"
  type        = string
  default     = "pocgbcacr070623"
}

variable "deployment_acr_resource_group" {
  description = "ACR resource group"
  type        = string
  default     = "pocgbcrg070623"
}
