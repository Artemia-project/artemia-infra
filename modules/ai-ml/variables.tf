variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure location"
  type        = string
}

variable "cognitive_account_name" {
  description = "Name of the cognitive account"
  type        = string
}

variable "custom_subdomain_name" {
  description = "Custom subdomain name for the cognitive account"
  type        = string
}

variable "kind" {
  description = "Kind of the cognitive account"
  type        = string
  default     = "OpenAI"
}

variable "sku_name" {
  description = "SKU name for the cognitive account"
  type        = string
  default     = "S0"
}

variable "network_acls_default_action" {
  description = "Default action for network ACLs"
  type        = string
  default     = "Allow"
}

variable "tags" {
  description = "Tags to be applied to resources"
  type        = map(string)
  default     = {}
}