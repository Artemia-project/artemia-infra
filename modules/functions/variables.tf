variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Location for the resources"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "function_app_name" {
  description = "Name of the Function App"
  type        = string
}

variable "app_service_plan_name" {
  description = "Name of the App Service Plan"
  type        = string
}

variable "storage_account_name" {
  description = "Name of the storage account for Function App"
  type        = string
}

variable "runtime_name" {
  description = "Runtime name for the Function App"
  type        = string
  default     = "python"
}

variable "runtime_version" {
  description = "Runtime version for the Function App"
  type        = string
  default     = "3.12"
}

variable "instance_memory_mb" {
  description = "Instance memory in MB"
  type        = number
  default     = 2048
}

variable "maximum_instance_count" {
  description = "Maximum instance count"
  type        = number
  default     = 100
}

variable "https_only" {
  description = "Enable HTTPS only"
  type        = bool
  default     = true
}

variable "public_network_access" {
  description = "Public network access setting"
  type        = string
  default     = "Enabled"
}

variable "key_vault_reference_identity" {
  description = "Key Vault reference identity"
  type        = string
  default     = "SystemAssigned"
}