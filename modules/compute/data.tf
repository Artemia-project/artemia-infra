# Data sources for VM image reference
data "azurerm_platform_image" "vm_image" {
  location  = var.location
  publisher = var.vm_image_publisher
  offer     = var.vm_image_offer
  sku       = var.vm_image_sku
}