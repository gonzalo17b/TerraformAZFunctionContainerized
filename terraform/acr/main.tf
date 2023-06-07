resource "random_string" "string" {
  length  = var.random_string_length
  special = false
}

resource "azurerm_resource_group" "acr_resource_group" {
  name     = var.deployment_acr_resource_group
  location = var.resource_group_location
}

resource "azurerm_container_registry" "audit_acr" {
  name                = var.deployment_acr_name
  resource_group_name = azurerm_resource_group.acr_resource_group.name
  location            = azurerm_resource_group.acr_resource_group.location
  sku                 = var.acr_sku
  admin_enabled       = var.admin_enabled
}
