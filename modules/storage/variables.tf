variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure location"
  type        = string
}

variable "main_storage_account_name" {
  description = "Name of the main data storage account"
  type        = string
}

variable "state_storage_account_name" {
  description = "Name of the Terraform state storage account"
  type        = string
}

variable "account_tier" {
  description = "Tier of the storage account"
  type        = string
  default     = "Standard"
}

variable "account_replication_type" {
  description = "Replication type of the storage account"
  type        = string
  default     = "LRS"
}

variable "allow_nested_items_to_be_public" {
  description = "Whether nested items can be public"
  type        = bool
  default     = false
}

variable "min_tls_version" {
  description = "Minimum TLS version for the state storage account"
  type        = string
  default     = "TLS1_2"
}

variable "tags" {
  description = "Tags to be applied to resources"
  type        = map(string)
  default     = {}
}