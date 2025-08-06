# Virtual Machines
resource "azurerm_linux_virtual_machine" "backend" {
  name                  = "${var.project_name}-backend-vm"
  location              = var.location
  resource_group_name   = var.resource_group_name
  size                  = var.backend_vm_size
  admin_username        = var.admin_username
  network_interface_ids = [azurerm_network_interface.backend.id]
  secure_boot_enabled   = true
  vtpm_enabled          = true
  tags                  = var.tags

  additional_capabilities {
  }

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key_backend
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.backend_storage_account_type
  }

  source_image_reference {
    publisher = var.vm_image_publisher
    offer     = var.vm_image_offer
    sku       = var.vm_image_sku
    version   = var.vm_image_version
  }
}

resource "azurerm_linux_virtual_machine" "data" {
  name                  = "${var.project_name}-data-vm"
  location              = var.location
  resource_group_name   = var.resource_group_name
  size                  = var.data_vm_size
  admin_username        = var.admin_username
  network_interface_ids = [azurerm_network_interface.data.id]
  secure_boot_enabled   = true
  vtpm_enabled          = true
  tags                  = var.tags

  additional_capabilities {
  }

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key_data
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.data_storage_account_type
  }

  source_image_reference {
    publisher = var.vm_image_publisher
    offer     = var.vm_image_offer
    sku       = var.vm_image_sku
    version   = var.vm_image_version
  }
}

resource "azurerm_linux_virtual_machine" "elasticsearch" {
  name                  = "${var.project_name}-elasticsearch-vm"
  location              = var.location
  resource_group_name   = var.resource_group_name
  size                  = var.elasticsearch_vm_size
  admin_username        = var.admin_username
  network_interface_ids = [azurerm_network_interface.elasticsearch.id]
  secure_boot_enabled   = true
  vtpm_enabled          = true
  tags                  = var.tags

  additional_capabilities {
  }

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key_elasticsearch
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.elasticsearch_storage_account_type
  }

  source_image_reference {
    publisher = var.vm_image_publisher
    offer     = var.vm_image_offer
    sku       = var.vm_image_sku
    version   = var.vm_image_version
  }
}