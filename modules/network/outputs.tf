output "vnet_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  description = "Name of the virtual network"
  value       = azurerm_virtual_network.vnet.name
}

output "default_subnet_id" {
  description = "ID of the default subnet"
  value       = azurerm_subnet.default.id
}

output "firewall_subnet_id" {
  description = "ID of the firewall subnet"
  value       = azurerm_subnet.firewall.id
}

output "load_balancer_id" {
  description = "ID of the load balancer"
  value       = azurerm_lb.main.id
}

output "backend_pool_id" {
  description = "ID of the load balancer backend pool"
  value       = azurerm_lb_backend_address_pool.main.id
}

output "backend_nsg_id" {
  description = "ID of the backend NSG"
  value       = azurerm_network_security_group.backend.id
}

output "llm_nsg_id" {
  description = "ID of the LLM NSG"
  value       = azurerm_network_security_group.llm.id
}

output "elasticsearch_nsg_id" {
  description = "ID of the Elasticsearch NSG"
  value       = azurerm_network_security_group.elasticsearch.id
}