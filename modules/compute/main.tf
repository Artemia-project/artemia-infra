# SSH Public Keys
resource "azurerm_ssh_public_key" "backend" {
  location            = var.location
  name                = "${var.project_name}-backend-vm-keypair"
  public_key          = var.ssh_public_key_backend
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_ssh_public_key" "llm" {
  location            = var.location
  name                = "${var.project_name}-llm-vm-keypair"
  public_key          = var.ssh_public_key_llm
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_ssh_public_key" "elasticsearch" {
  location            = var.location
  name                = "${var.project_name}-elasticsearch-vm-keypair"
  public_key          = var.ssh_public_key_elasticsearch
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# Public IPs
resource "azurerm_public_ip" "backend" {
  allocation_method   = "Static"
  location            = var.location
  name                = "${var.project_name}-backend-vm-ip"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_public_ip" "llm" {
  allocation_method   = "Static"
  location            = var.location
  name                = "${var.project_name}-llm-vm-ip"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_public_ip" "elasticsearch" {
  allocation_method   = "Static"
  location            = var.location
  name                = "${var.project_name}-elasticsearch-vm-ip"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# Network Interfaces
resource "azurerm_network_interface" "backend" {
  accelerated_networking_enabled = true
  location                       = var.location
  name                           = "${var.project_name}-backend-vm-nic"
  resource_group_name            = var.resource_group_name
  tags                          = var.tags

  ip_configuration {
    name                          = "ipconfig1"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.backend.id
    subnet_id                     = var.subnet_id
  }
}

resource "azurerm_network_interface" "llm" {
  accelerated_networking_enabled = true
  location                       = var.location
  name                           = "${var.project_name}-llm-vm-nic"
  resource_group_name            = var.resource_group_name
  tags                          = var.tags

  ip_configuration {
    name                          = "ipconfig1"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.llm.id
    subnet_id                     = var.subnet_id
  }
}

resource "azurerm_network_interface" "elasticsearch" {
  accelerated_networking_enabled = true
  location                       = var.location
  name                           = "${var.project_name}-elasticsearch-vm-nic"
  resource_group_name            = var.resource_group_name
  tags                          = var.tags

  ip_configuration {
    name                          = "ipconfig1"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.elasticsearch.id
    subnet_id                     = var.subnet_id
  }
}

# Network Interface to Load Balancer Backend Pool Associations
resource "azurerm_network_interface_backend_address_pool_association" "backend" {
  backend_address_pool_id = var.backend_pool_id
  ip_configuration_name   = "ipconfig1"
  network_interface_id    = azurerm_network_interface.backend.id
}

resource "azurerm_network_interface_backend_address_pool_association" "llm" {
  backend_address_pool_id = var.backend_pool_id
  ip_configuration_name   = "ipconfig1"
  network_interface_id    = azurerm_network_interface.llm.id
}

# Network Interface to NSG Associations
resource "azurerm_network_interface_security_group_association" "backend" {
  network_interface_id      = azurerm_network_interface.backend.id
  network_security_group_id = var.backend_nsg_id
}

resource "azurerm_network_interface_security_group_association" "llm" {
  network_interface_id      = azurerm_network_interface.llm.id
  network_security_group_id = var.llm_nsg_id
}

resource "azurerm_network_interface_security_group_association" "elasticsearch" {
  network_interface_id      = azurerm_network_interface.elasticsearch.id
  network_security_group_id = var.elasticsearch_nsg_id
}

# Virtual Machines
resource "azurerm_linux_virtual_machine" "backend" {
  admin_username        = var.admin_username
  location              = var.location
  name                  = "${var.project_name}-backend-vm"
  network_interface_ids = [azurerm_network_interface.backend.id]
  resource_group_name   = var.resource_group_name
  secure_boot_enabled   = true
  size                  = var.backend_vm_size
  tags                  = var.tags
  vtpm_enabled          = true

  additional_capabilities {
  }

  admin_ssh_key {
    public_key = var.ssh_public_key_backend
    username   = var.admin_username
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.backend_storage_account_type
  }

  source_image_reference {
    offer     = var.vm_image_offer
    publisher = var.vm_image_publisher
    sku       = var.vm_image_sku
    version   = var.vm_image_version
  }
}

resource "azurerm_linux_virtual_machine" "llm" {
  admin_username        = var.admin_username
  location              = var.location
  name                  = "${var.project_name}-llm-vm"
  network_interface_ids = [azurerm_network_interface.llm.id]
  resource_group_name   = var.resource_group_name
  secure_boot_enabled   = true
  size                  = var.llm_vm_size
  tags                  = var.tags
  vtpm_enabled          = true

  additional_capabilities {
  }

  admin_ssh_key {
    public_key = var.ssh_public_key_llm
    username   = var.admin_username
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.llm_storage_account_type
  }

  source_image_reference {
    offer     = var.vm_image_offer
    publisher = var.vm_image_publisher
    sku       = var.vm_image_sku
    version   = var.vm_image_version
  }
}

resource "azurerm_linux_virtual_machine" "elasticsearch" {
  admin_username        = var.admin_username
  location              = var.location
  name                  = "${var.project_name}-elasticsearch-vm"
  network_interface_ids = [azurerm_network_interface.elasticsearch.id]
  resource_group_name   = var.resource_group_name
  secure_boot_enabled   = true
  size                  = var.elasticsearch_vm_size
  tags                  = var.tags
  vtpm_enabled          = true

  additional_capabilities {
  }

  admin_ssh_key {
    public_key = var.ssh_public_key_elasticsearch
    username   = var.admin_username
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.elasticsearch_storage_account_type
  }

  source_image_reference {
    offer     = var.vm_image_offer
    publisher = var.vm_image_publisher
    sku       = var.vm_image_sku
    version   = var.vm_image_version
  }
}