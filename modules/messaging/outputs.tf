output "namespace_id" {
  description = "ID of the EventHub namespace"
  value       = azurerm_eventhub_namespace.main.id
}

output "namespace_name" {
  description = "Name of the EventHub namespace"
  value       = azurerm_eventhub_namespace.main.name
}

output "eventhub_id" {
  description = "ID of the EventHub"
  value       = azurerm_eventhub.main.id
}

output "eventhub_name" {
  description = "Name of the EventHub"
  value       = azurerm_eventhub.main.name
}

output "auth_rule_primary_connection_string" {
  description = "Primary connection string of the authorization rule"
  value       = azurerm_eventhub_namespace_authorization_rule.main.primary_connection_string
  sensitive   = true
}

output "auth_rule_secondary_connection_string" {
  description = "Secondary connection string of the authorization rule"
  value       = azurerm_eventhub_namespace_authorization_rule.main.secondary_connection_string
  sensitive   = true
}