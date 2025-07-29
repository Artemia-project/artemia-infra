output "backend_vm_id" {
  description = "ID of the backend VM"
  value       = azurerm_linux_virtual_machine.backend.id
}

output "llm_vm_id" {
  description = "ID of the LLM VM"
  value       = azurerm_linux_virtual_machine.llm.id
}

output "elasticsearch_vm_id" {
  description = "ID of the Elasticsearch VM"
  value       = azurerm_linux_virtual_machine.elasticsearch.id
}

output "backend_public_ip" {
  description = "Public IP address of the backend VM"
  value       = azurerm_public_ip.backend.ip_address
}

output "llm_public_ip" {
  description = "Public IP address of the LLM VM"
  value       = azurerm_public_ip.llm.ip_address
}

output "elasticsearch_public_ip" {
  description = "Public IP address of the Elasticsearch VM"
  value       = azurerm_public_ip.elasticsearch.ip_address
}