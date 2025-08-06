# Public IPs
resource "azurerm_public_ip" "backend" {
  name                = "${var.project_name}-backend-vm-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  tags                = var.tags
}

resource "azurerm_public_ip" "data" {
  name                = "${var.project_name}-data-vm-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  tags                = var.tags
}

resource "azurerm_public_ip" "elasticsearch" {
  name                = "${var.project_name}-elasticsearch-vm-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  tags                = var.tags
}