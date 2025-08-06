# Required variables (no defaults)
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure location"
  type        = string
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet for VMs"
  type        = string
}

variable "backend_pool_id" {
  description = "ID of the load balancer backend pool"
  type        = string
}

variable "backend_nsg_id" {
  description = "ID of the backend NSG"
  type        = string
}

variable "data_nsg_id" {
  description = "ID of the data NSG"
  type        = string
}

variable "elasticsearch_nsg_id" {
  description = "ID of the elasticsearch NSG"
  type        = string
}

variable "ssh_public_key_backend" {
  description = "SSH public key for backend VM"
  type        = string
}

variable "ssh_public_key_data" {
  description = "SSH public key for data VM"
  type        = string
}

variable "ssh_public_key_elasticsearch" {
  description = "SSH public key for elasticsearch VM"
  type        = string
}

# Variables with defaults
variable "admin_username" {
  description = "Admin username for VMs"
  type        = string
  default     = "azureuser"
}

variable "backend_vm_size" {
  description = "Size of the backend VM"
  type        = string
  default     = "Standard_D2s_v5"
}

variable "data_vm_size" {
  description = "Size of the Data VM"
  type        = string
  default     = "Standard_E4ds_v4"
}

variable "elasticsearch_vm_size" {
  description = "Size of the Elasticsearch VM"
  type        = string
  default     = "Standard_D2s_v5"
}

variable "backend_storage_account_type" {
  description = "Storage account type for backend VM"
  type        = string
  default     = "StandardSSD_LRS"
}

variable "data_storage_account_type" {
  description = "Storage account type for Data VM"
  type        = string
  default     = "Premium_LRS"
}

variable "elasticsearch_storage_account_type" {
  description = "Storage account type for Elasticsearch VM"
  type        = string
  default     = "Premium_LRS"
}

variable "vm_image_offer" {
  description = "VM image offer"
  type        = string
  default     = "ubuntu-24_04-lts"
}

variable "vm_image_publisher" {
  description = "VM image publisher"
  type        = string
  default     = "canonical"
}

variable "vm_image_sku" {
  description = "VM image SKU"
  type        = string
  default     = "server"
}

variable "vm_image_version" {
  description = "VM image version"
  type        = string
  default     = "latest"
}

variable "tags" {
  description = "Tags to be applied to resources"
  type        = map(string)
  default     = {}
}