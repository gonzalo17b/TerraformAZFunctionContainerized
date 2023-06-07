resource "azurerm_servicebus_namespace" "bus" {
  name                = lower("${random_string.string.result}gbcbus")
  resource_group_name = azurerm_resource_group.audit_resource_group.name
  location            = azurerm_resource_group.audit_resource_group.location
  sku                 = "Standard"
  capacity            = 0
  zone_redundant      = false
  local_auth_enabled  = true
}

resource "azurerm_servicebus_queue" "audit_queue" {
  name                                 = "audit-qeue"
  namespace_id                         = azurerm_servicebus_namespace.bus.id
  enable_partitioning                  = false
  default_message_ttl                  = "P2D"
  dead_lettering_on_message_expiration = "true"
  lock_duration                        = "PT2M"
  requires_session                     = true
}

resource "azurerm_servicebus_namespace" "externalbus" {
  name                = lower("${random_string.string.result}gbcexternalbus")
  resource_group_name = azurerm_resource_group.audit_resource_group.name
  location            = azurerm_resource_group.audit_resource_group.location
  sku                 = "Standard"
  capacity            = 0
  zone_redundant      = false
  local_auth_enabled  = true
}

resource "azurerm_servicebus_queue" "externalqeue" {
  name                                 = "audit-external-qeue"
  namespace_id                         = azurerm_servicebus_namespace.externalbus.id
  enable_partitioning                  = false
  default_message_ttl                  = "P2D"
  dead_lettering_on_message_expiration = "true"
  lock_duration                        = "PT2M"
  requires_session                     = true
}
