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