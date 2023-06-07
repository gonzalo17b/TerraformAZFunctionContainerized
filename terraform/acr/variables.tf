variable "random_string_length" {
  description = "Length of the random string"
  type        = number
  default     = 4
}

variable "resource_group_location" {
  description = "Location for the resource group"
  type        = string
  default     = "West Europe"
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

variable "acr_sku" {
  description = "SKU for the Azure Container Registry"
  type        = string
  default     = "Basic"
}

variable "admin_enabled" {
  description = "Flag to enable admin access to the Azure Container Registry"
  type        = bool
  default     = true
}
