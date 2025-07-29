variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure location"
  type        = string
}

variable "namespace_name" {
  description = "Name of the EventHub namespace"
  type        = string
}

variable "namespace_sku" {
  description = "SKU of the EventHub namespace"
  type        = string
  default     = "Standard"
}

variable "local_authentication_enabled" {
  description = "Whether local authentication is enabled"
  type        = bool
  default     = false
}

variable "eventhub_name" {
  description = "Name of the EventHub"
  type        = string
}

variable "message_retention" {
  description = "Message retention in days"
  type        = number
  default     = 1
}

variable "partition_count" {
  description = "Number of partitions"
  type        = number
  default     = 1
}

variable "auth_rule_name" {
  description = "Name of the authorization rule"
  type        = string
  default     = "RootManageSharedAccessKey"
}

variable "auth_rule_listen" {
  description = "Whether the authorization rule has listen permissions"
  type        = bool
  default     = true
}

variable "auth_rule_manage" {
  description = "Whether the authorization rule has manage permissions"
  type        = bool
  default     = true
}

variable "auth_rule_send" {
  description = "Whether the authorization rule has send permissions"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to be applied to resources"
  type        = map(string)
  default     = {}
}