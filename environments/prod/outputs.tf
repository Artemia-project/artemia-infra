# Network Outputs
output "vnet_id" {
  description = "ID of the virtual network"
  value       = module.network.vnet_id
}

output "default_subnet_id" {
  description = "ID of the default subnet"
  value       = module.network.default_subnet_id
}

output "load_balancer_id" {
  description = "ID of the load balancer"
  value       = module.network.load_balancer_id
}

# Compute Outputs
output "backend_vm_id" {
  description = "ID of the backend VM"
  value       = module.compute.backend_vm_id
}

output "data_vm_id" {
  description = "ID of the Data VM"
  value       = module.compute.data_vm_id
}

output "elasticsearch_vm_id" {
  description = "ID of the Elasticsearch VM"
  value       = module.compute.elasticsearch_vm_id
}

output "backend_public_ip" {
  description = "Public IP address of the backend VM"
  value       = module.compute.backend_public_ip
}

output "data_public_ip" {
  description = "Public IP address of the Data VM"
  value       = module.compute.data_public_ip
}

output "elasticsearch_public_ip" {
  description = "Public IP address of the Elasticsearch VM"
  value       = module.compute.elasticsearch_public_ip
}

# Database Outputs
output "sql_server_id" {
  description = "ID of the SQL Server"
  value       = module.database.server_id
}

output "sql_database_id" {
  description = "ID of the SQL Database"
  value       = module.database.database_id
}

output "sql_server_fqdn" {
  description = "Fully qualified domain name of the SQL Server"
  value       = module.database.server_fqdn
}

# Storage Outputs
output "main_storage_account_name" {
  description = "Name of the main data storage account"
  value       = module.storage.main_storage_account_name
}

output "state_storage_account_name" {
  description = "Name of the Terraform state storage account"
  value       = module.storage.state_storage_account_name
}

# Messaging Outputs
output "eventhub_namespace_name" {
  description = "Name of the EventHub namespace"
  value       = module.messaging.namespace_name
}

output "eventhub_name" {
  description = "Name of the EventHub"
  value       = module.messaging.eventhub_name
}

# AI/ML Outputs
output "openai_endpoint" {
  description = "Endpoint of the OpenAI cognitive account"
  value       = module.ai_ml.cognitive_account_endpoint
}

output "openai_account_name" {
  description = "Name of the OpenAI cognitive account"
  value       = module.ai_ml.cognitive_account_name
}

# Monitoring Outputs
output "primary_action_group_id" {
  description = "ID of the primary action group"
  value       = module.monitoring.primary_action_group_id
}

output "recommended_action_group_id" {
  description = "ID of the recommended action group"
  value       = module.monitoring.recommended_action_group_id
}

# Function App Outputs
output "function_app_id" {
  description = "ID of the Function App"
  value       = module.functions.function_app_id
}

output "function_app_name" {
  description = "Name of the Function App"
  value       = module.functions.function_app_name
}

output "function_app_default_hostname" {
  description = "Default hostname of the Function App"
  value       = module.functions.function_app_default_hostname
}

output "function_app_outbound_ip_addresses" {
  description = "Outbound IP addresses of the Function App"
  value       = module.functions.function_app_outbound_ip_addresses
}

output "function_app_service_plan_id" {
  description = "ID of the Function App Service Plan"
  value       = module.functions.app_service_plan_id
}

output "function_storage_account_id" {
  description = "ID of the Function App storage account"
  value       = module.functions.storage_account_id
}