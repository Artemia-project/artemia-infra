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

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "default_subnet_address_prefixes" {
  description = "Address prefixes for the default subnet"
  type        = list(string)
  default     = ["10.0.0.0/24"]
}

variable "firewall_subnet_address_prefixes" {
  description = "Address prefixes for the firewall subnet"
  type        = list(string)
  default     = ["10.0.1.0/26"]
}

variable "load_balancer_name" {
  description = "Name of the load balancer"
  type        = string
}

variable "tags" {
  description = "Tags to be applied to resources"
  type        = map(string)
  default     = {}
}

# Security Configuration Variables
variable "allowed_ip_ranges" {
  description = "List of IP ranges allowed to access VMs (CIDR notation)"
  type        = list(string)
  default     = ["0.0.0.0/0"]  # Default allows all - CHANGE FOR PRODUCTION
  validation {
    condition = alltrue([
      for cidr in var.allowed_ip_ranges : can(cidrhost(cidr, 0))
    ])
    error_message = "All IP ranges must be valid CIDR notation (e.g., '192.168.1.0/24')."
  }
}

variable "enable_rdp_access" {
  description = "Enable RDP access (port 3389) - typically false for Linux VMs"
  type        = bool
  default     = false
}

variable "ssh_allowed_ip_ranges" {
  description = "Specific IP ranges allowed for SSH access (more restrictive than general access)"
  type        = list(string)
  default     = ["0.0.0.0/0"]  # Default allows all - CHANGE FOR PRODUCTION
  validation {
    condition = alltrue([
      for cidr in var.ssh_allowed_ip_ranges : can(cidrhost(cidr, 0))
    ])
    error_message = "All SSH IP ranges must be valid CIDR notation."
  }
}

variable "environment" {
  description = "Environment name (used for security rule priority calculation)"
  type        = string
  default     = "prod"
  validation {
    condition = contains(["dev", "stg", "prod"], var.environment)
    error_message = "Environment must be one of: dev, stg, prod."
  }
}

variable "airflow_ui_allowed_ip_ranges" {
  description = "List of IP ranges allowed to access Airflow UI on port 8080 (CIDR notation)"
  type        = list(string)
  default     = ["0.0.0.0/0"]  # Default allows all - CHANGE FOR PRODUCTION
  validation {
    condition = alltrue([
      for cidr in var.airflow_ui_allowed_ip_ranges : can(cidrhost(cidr, 0))
    ])
    error_message = "All Airflow UI IP ranges must be valid CIDR notation (e.g., '203.0.113.10/32')."
  }
}