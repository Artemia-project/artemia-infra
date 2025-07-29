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

output "llm_vm_id" {
  description = "ID of the LLM VM"
  value       = module.compute.llm_vm_id
}

output "elasticsearch_vm_id" {
  description = "ID of the Elasticsearch VM"
  value       = module.compute.elasticsearch_vm_id
}

output "backend_public_ip" {
  description = "Public IP address of the backend VM"
  value       = module.compute.backend_public_ip
}

output "llm_public_ip" {
  description = "Public IP address of the LLM VM"
  value       = module.compute.llm_public_ip
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