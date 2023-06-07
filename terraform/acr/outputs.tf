output "acr_host_name" {
  value       = azurerm_container_registry.audit_acr.name
  description = "ACR name"
}
