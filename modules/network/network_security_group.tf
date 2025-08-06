# Network Security Groups
resource "azurerm_network_security_group" "backend" {
  name                = "${var.project_name}-backend-vm-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_network_security_group" "data" {
  name                = "${var.project_name}-data-vm-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_network_security_group" "elasticsearch" {
  name                = "${var.project_name}-elasticsearch-vm-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}