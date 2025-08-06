# SSH Public Keys
resource "azurerm_ssh_public_key" "backend" {
  name                = "${var.project_name}-backend-vm-keypair"
  location            = var.location
  resource_group_name = var.resource_group_name
  public_key          = var.ssh_public_key_backend
  tags                = var.tags
}

resource "azurerm_ssh_public_key" "data" {
  name                = "${var.project_name}-data-vm-keypair"
  location            = var.location
  resource_group_name = var.resource_group_name
  public_key          = var.ssh_public_key_data
  tags                = var.tags
}

resource "azurerm_ssh_public_key" "elasticsearch" {
  name                = "${var.project_name}-elasticsearch-vm-keypair"
  location            = var.location
  resource_group_name = var.resource_group_name
  public_key          = var.ssh_public_key_elasticsearch
  tags                = var.tags
}