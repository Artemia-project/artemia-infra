# App Service Plan for Function App (FlexConsumption)
resource "azurerm_service_plan" "function_plan" {
  name                = var.app_service_plan_name
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  sku_name            = "FC1"
  
  tags = var.tags
}

# Storage Account for Function App deployment
resource "azurerm_storage_account" "function_storage" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "Storage"
  
  allow_nested_items_to_be_public = false
  default_to_oauth_authentication = true
  
  tags = var.tags
}

# Storage Container for Function App package
resource "azurerm_storage_container" "function_deployment" {
  name                  = "app-package-artemia-data-pipeline-function-851245e"
  storage_account_id    = azurerm_storage_account.function_storage.id
  container_access_type = "private"
}

# Linux Function App (FlexConsumption)
resource "azurerm_linux_function_app" "function_app" {
  name                = var.function_app_name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.function_plan.id
  
  storage_account_name       = azurerm_storage_account.function_storage.name
  storage_account_access_key = azurerm_storage_account.function_storage.primary_access_key
  
  https_only                    = var.https_only
  public_network_access_enabled = var.public_network_access == "Enabled"
  functions_extension_version   = "~4"
  
# FlexConsumption Function Apps use site_config for runtime configuration
  # Deployment configuration is handled through deployment slots or ARM templates
  
  site_config {
    ftps_state = "FtpsOnly"
    
    application_stack {
      python_version = var.runtime_version
    }
    
    cors {
      allowed_origins     = ["https://portal.azure.com"]
      support_credentials = false
    }
    
    # FlexConsumption specific settings
    always_on = false
  }
  
  app_settings = {
    "DEPLOYMENT_STORAGE_CONNECTION_STRING" = azurerm_storage_account.function_storage.primary_connection_string
  }
  
  tags = var.tags
}