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

# Azure AI Search Service variables
variable "search_service_name" {
  description = "Name of the Azure AI Search service"
  type        = string
}

variable "search_service_sku" {
  description = "SKU/pricing tier for the Azure AI Search service"
  type        = string
  default     = "free"
}

variable "search_replica_count" {
  description = "Number of replicas for the search service"
  type        = number
  default     = 1
}

variable "search_partition_count" {
  description = "Number of partitions for the search service"
  type        = number
  default     = 1
}

variable "search_public_network_access" {
  description = "Enable public network access for the search service"
  type        = bool
  default     = true
}

variable "search_local_auth_enabled" {
  description = "Enable local authentication for the search service"
  type        = bool
  default     = false
}