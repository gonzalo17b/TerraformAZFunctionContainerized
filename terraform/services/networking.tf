resource "azurerm_virtual_network" "main" {
  name                = "mainvnet"
  resource_group_name = azurerm_resource_group.audit_resource_group.name
  location            = azurerm_resource_group.audit_resource_group.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "audit" {
  name                 = "networkingaudit"
  resource_group_name  = azurerm_resource_group.audit_resource_group.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.8.0/24"]
  delegation {
    name = "appservice"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
  service_endpoints = [
    "Microsoft.KeyVault",
    "Microsoft.AzureActiveDirectory",
    "Microsoft.ServiceBus",
    "Microsoft.Sql"
  ]
}

resource "azurerm_role_assignment" "audit_servicebus" {
  count                = 1
  scope                = azurerm_servicebus_queue.audit_queue.id
  role_definition_name = "Azure Service Bus Data Owner"
  principal_id         = azurerm_linux_function_app.audit_azfunc.identity[0].principal_id
}
