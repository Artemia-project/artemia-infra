# Network Interface to Load Balancer Backend Pool Associations
resource "azurerm_network_interface_backend_address_pool_association" "backend" {
  network_interface_id    = azurerm_network_interface.backend.id
  ip_configuration_name   = "ipconfig1"
  backend_address_pool_id = var.backend_pool_id
}

resource "azurerm_network_interface_backend_address_pool_association" "data" {
  network_interface_id    = azurerm_network_interface.data.id
  ip_configuration_name   = "ipconfig1"
  backend_address_pool_id = var.backend_pool_id
}

# Network Interface to NSG Associations
resource "azurerm_network_interface_security_group_association" "backend" {
  network_interface_id      = azurerm_network_interface.backend.id
  network_security_group_id = var.backend_nsg_id
}

resource "azurerm_network_interface_security_group_association" "data" {
  network_interface_id      = azurerm_network_interface.data.id
  network_security_group_id = var.data_nsg_id
}

resource "azurerm_network_interface_security_group_association" "elasticsearch" {
  network_interface_id      = azurerm_network_interface.elasticsearch.id
  network_security_group_id = var.elasticsearch_nsg_id
}