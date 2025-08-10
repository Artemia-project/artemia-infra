variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure location"
  type        = string
}

variable "registry_name" {
  description = "Name of the container registry"
  type        = string
}

variable "sku" {
  description = "SKU/pricing tier for the container registry"
  type        = string
  default     = "Basic"
  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.sku)
    error_message = "SKU must be Basic, Standard, or Premium."
  }
}

variable "admin_enabled" {
  description = "Enable admin user for the container registry"
  type        = bool
  default     = false
}

variable "anonymous_pull_enabled" {
  description = "Enable anonymous pull for the container registry"
  type        = bool
  default     = false
}

variable "data_endpoint_enabled" {
  description = "Enable data endpoint for the container registry"
  type        = bool
  default     = false
}

variable "public_network_access_enabled" {
  description = "Enable public network access for the container registry"
  type        = bool
  default     = true
}

variable "network_rule_bypass_option" {
  description = "Network rule bypass option"
  type        = string
  default     = "AzureServices"
  validation {
    condition     = contains(["AzureServices", "None"], var.network_rule_bypass_option)
    error_message = "Network rule bypass option must be AzureServices or None."
  }
}

variable "retention_policy_enabled" {
  description = "Enable retention policy"
  type        = bool
  default     = false
}

variable "retention_policy_days" {
  description = "Number of days for retention policy"
  type        = number
  default     = 7
}

variable "trust_policy_enabled" {
  description = "Enable trust policy"
  type        = bool
  default     = false
}

variable "export_policy_enabled" {
  description = "Enable export policy"
  type        = bool
  default     = true
}

variable "quarantine_policy_enabled" {
  description = "Enable quarantine policy"
  type        = bool
  default     = false
}

variable "azure_ad_auth_enabled" {
  description = "Enable Azure AD authentication as ARM policy"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to be applied to resources"
  type        = map(string)
  default     = {}
}