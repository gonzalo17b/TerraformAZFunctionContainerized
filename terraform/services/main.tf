
resource "random_string" "string" {
  length  = 4
  special = false
}

resource "azurerm_resource_group" "audit_resource_group" {
  name     = "${random_string.string.result}audit_resource_grp"
  location = "West Europe"
}

resource "azurerm_storage_account" "audit_storage_account" {
  name                     = lower("auditstorage${random_string.string.result}")
  resource_group_name      = azurerm_resource_group.audit_resource_group.name
  location                 = azurerm_resource_group.audit_resource_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  depends_on = [azurerm_resource_group.audit_resource_group]
}

resource "azurerm_service_plan" "audit_service_plan" {
  name                   = "audit-service-plan"
  resource_group_name    = azurerm_resource_group.audit_resource_group.name
  location               = azurerm_resource_group.audit_resource_group.location
  os_type                = "Linux"
  sku_name               = "B1"
  zone_balancing_enabled = false
  worker_count           = 1
}


resource "azurerm_linux_function_app" "audit_azfunc" {
  name                       = "audit-azfunc"
  resource_group_name        = azurerm_resource_group.audit_resource_group.name
  location                   = azurerm_resource_group.audit_resource_group.location
  storage_account_name       = azurerm_storage_account.audit_storage_account.name
  storage_account_access_key = azurerm_storage_account.audit_storage_account.primary_access_key
  service_plan_id            = azurerm_service_plan.audit_service_plan.id
  https_only                 = true
  virtual_network_subnet_id  = azurerm_subnet.audit.id

  site_config {
    always_on           = true
    http2_enabled       = true
    minimum_tls_version = "1.2"

    application_stack {
      docker {
        registry_url      = data.azurerm_container_registry.audit_acr.login_server
        registry_username = data.azurerm_container_registry.audit_acr.admin_username
        registry_password = data.azurerm_container_registry.audit_acr.admin_password
        image_name        = var.image_name
        image_tag         = var.image_tag
      }
    }
  }

  functions_extension_version = "~4"

  app_settings = {
    "DOCKER_REGISTRY_SERVER_URL"                        = data.azurerm_container_registry.audit_acr.login_server
    "DOCKER_REGISTRY_SERVER_USERNAME"                   = data.azurerm_container_registry.audit_acr.admin_username
    "DOCKER_REGISTRY_SERVER_PASSWORD"                   = data.azurerm_container_registry.audit_acr.admin_password
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE"               = "false"
    "ServiceBusConfiguration__ConnectionString"         = azurerm_servicebus_namespace.bus.default_primary_connection_string
    "ServiceBusConfiguration__QueueName"                = azurerm_servicebus_queue.audit_queue.name
    "ServiceBusConfiguration__ExternalConnectionString" = azurerm_servicebus_namespace.externalbus.default_primary_connection_string
    "ServiceBusConfiguration__ExternalQueueName"        = azurerm_servicebus_queue.externalqeue.name
  }

  identity {
    type = "SystemAssigned"
  }
}

