output "function_app_id" {
  description = "The ID of the Function App"
  value       = azurerm_linux_function_app.function_app.id
}

output "function_app_name" {
  description = "The name of the Function App"
  value       = azurerm_linux_function_app.function_app.name
}

output "function_app_default_hostname" {
  description = "The default hostname of the Function App"
  value       = azurerm_linux_function_app.function_app.default_hostname
}

output "function_app_outbound_ip_addresses" {
  description = "The outbound IP addresses of the Function App"
  value       = azurerm_linux_function_app.function_app.outbound_ip_addresses
}

output "function_app_possible_outbound_ip_addresses" {
  description = "The possible outbound IP addresses of the Function App"
  value       = azurerm_linux_function_app.function_app.possible_outbound_ip_addresses
}

output "app_service_plan_id" {
  description = "The ID of the App Service Plan"
  value       = azurerm_service_plan.function_plan.id
}

output "app_service_plan_name" {
  description = "The name of the App Service Plan"
  value       = azurerm_service_plan.function_plan.name
}

output "storage_account_id" {
  description = "The ID of the Function App storage account"
  value       = azurerm_storage_account.function_storage.id
}

output "storage_account_name" {
  description = "The name of the Function App storage account"
  value       = azurerm_storage_account.function_storage.name
}

output "storage_account_primary_connection_string" {
  description = "The primary connection string of the Function App storage account"
  value       = azurerm_storage_account.function_storage.primary_connection_string
  sensitive   = true
}

