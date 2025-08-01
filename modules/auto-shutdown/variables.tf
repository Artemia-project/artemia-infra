variable "enable_auto_shutdown" {
  description = "Enable automatic VM shutdown"
  type        = bool
  default     = false
}

variable "auto_shutdown_time" {
  description = "Time to automatically shutdown VMs (24-hour format)"
  type        = string
  default     = "18:00"
}

variable "auto_shutdown_timezone" {
  description = "Timezone for auto-shutdown schedule"
  type        = string
  default     = "Korea Standard Time"
}

variable "auto_start_enabled" {
  description = "Enable automatic VM startup"
  type        = bool
  default     = false
}

variable "auto_start_time" {
  description = "Time to automatically start VMs (24-hour format)"
  type        = string
  default     = "09:00"
}

variable "weekend_shutdown_enabled" {
  description = "Enable weekend shutdown (Friday evening to Monday morning)"
  type        = bool
  default     = false
}

variable "enable_advanced_scheduling" {
  description = "Enable advanced scheduling with Automation Account (for complex scenarios)"
  type        = bool
  default     = false
}

variable "notification_email" {
  description = "Email to notify before VM shutdown"
  type        = string
  default     = ""
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "location" {
  description = "Azure location"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "backend_vm_id" {
  description = "ID of the backend VM"
  type        = string
}

variable "llm_vm_id" {
  description = "ID of the LLM VM"
  type        = string
}

variable "elasticsearch_vm_id" {
  description = "ID of the Elasticsearch VM"
  type        = string
}

variable "tags" {
  description = "Tags to be applied to resources"
  type        = map(string)
  default     = {}
}