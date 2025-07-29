output "main_storage_account_id" {
  description = "ID of the main data storage account"
  value       = azurerm_storage_account.main_data.id
}

output "main_storage_account_name" {
  description = "Name of the main data storage account"
  value       = azurerm_storage_account.main_data.name
}

output "state_storage_account_id" {
  description = "ID of the Terraform state storage account"
  value       = azurerm_storage_account.state.id
}

output "state_storage_account_name" {
  description = "Name of the Terraform state storage account"
  value       = azurerm_storage_account.state.name
}

output "artemia_container_id" {
  description = "ID of the artemia container"
  value       = azurerm_storage_container.artemia.id
}

output "tfstate_container_id" {
  description = "ID of the terraform-state container"
  value       = azurerm_storage_container.tfstate.id
}

output "main_storage_account_primary_access_key" {
  description = "Primary access key of the main storage account"
  value       = azurerm_storage_account.main_data.primary_access_key
  sensitive   = true
}

output "state_storage_account_primary_access_key" {
  description = "Primary access key of the state storage account"
  value       = azurerm_storage_account.state.primary_access_key
  sensitive   = true
}