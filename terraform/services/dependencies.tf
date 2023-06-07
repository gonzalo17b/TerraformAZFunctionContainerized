data "azurerm_container_registry" "audit_acr" {
  name                = var.deployment_acr_name
  resource_group_name = var.deployment_acr_resource_group
}
