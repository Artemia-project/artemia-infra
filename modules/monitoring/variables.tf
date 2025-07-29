variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "primary_action_group_name" {
  description = "Name of the primary action group"
  type        = string
}

variable "recommended_action_group_name" {
  description = "Name of the recommended action group"
  type        = string
}

variable "primary_short_name" {
  description = "Short name for the primary action group"
  type        = string
  default     = "Artemia AG"
}

variable "recommended_short_name" {
  description = "Short name for the recommended action group"
  type        = string
  default     = "recalert1"
}

variable "primary_email" {
  description = "Primary email for notifications"
  type        = string
}

variable "secondary_email" {
  description = "Secondary email for notifications"
  type        = string
}

variable "vm_ids" {
  description = "Map of VM names to IDs for monitoring"
  type        = map(string)
}

variable "cpu_threshold" {
  description = "CPU percentage threshold for alerts"
  type        = number
  default     = 80
}

variable "memory_threshold" {
  description = "Available memory threshold in bytes"
  type        = number
  default     = 1000000000
}

variable "disk_iops_threshold" {
  description = "Disk IOPS consumed percentage threshold"
  type        = number
  default     = 95
}

variable "network_in_threshold" {
  description = "Network in total threshold in bytes"
  type        = number
  default     = 500000000000
}

variable "network_out_threshold" {
  description = "Network out total threshold in bytes"
  type        = number
  default     = 200000000000
}

variable "tags" {
  description = "Tags to be applied to resources"
  type        = map(string)
  default     = {}
}