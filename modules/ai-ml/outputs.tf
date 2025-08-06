output "cognitive_account_id" {
  description = "ID of the cognitive account"
  value       = azurerm_cognitive_account.openai.id
}

output "cognitive_account_name" {
  description = "Name of the cognitive account"
  value       = azurerm_cognitive_account.openai.name
}

output "cognitive_account_endpoint" {
  description = "Endpoint of the cognitive account"
  value       = azurerm_cognitive_account.openai.endpoint
}

output "cognitive_account_primary_access_key" {
  description = "Primary access key of the cognitive account"
  value       = azurerm_cognitive_account.openai.primary_access_key
  sensitive   = true
}

output "cognitive_account_secondary_access_key" {
  description = "Secondary access key of the cognitive account"
  value       = azurerm_cognitive_account.openai.secondary_access_key
  sensitive   = true
}

# Azure AI Search Service outputs
output "search_service_id" {
  description = "ID of the Azure AI Search service"
  value       = azurerm_search_service.search.id
}

output "search_service_name" {
  description = "Name of the Azure AI Search service"
  value       = azurerm_search_service.search.name
}

output "search_service_url" {
  description = "URL of the Azure AI Search service"
  value       = "https://${azurerm_search_service.search.name}.search.windows.net"
}

output "search_service_primary_key" {
  description = "Primary admin key of the Azure AI Search service"
  value       = azurerm_search_service.search.primary_key
  sensitive   = true
}

output "search_service_secondary_key" {
  description = "Secondary admin key of the Azure AI Search service"
  value       = azurerm_search_service.search.secondary_key
  sensitive   = true
}

output "search_service_query_keys" {
  description = "Query keys of the Azure AI Search service"
  value       = azurerm_search_service.search.query_keys
  sensitive   = true
}