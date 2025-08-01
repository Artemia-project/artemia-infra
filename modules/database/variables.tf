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

variable "server_name" {
  description = "Name of the SQL Server"
  type        = string
}

variable "database_name" {
  description = "Name of the SQL Database"
  type        = string
}

variable "administrator_login" {
  description = "Administrator login for SQL Server"
  type        = string
  default     = "artemia_admin"
}

variable "administrator_login_password" {
  description = "Administrator login password for SQL Server"
  type        = string
  sensitive   = true
}

variable "server_version" {
  description = "Version of SQL Server"
  type        = string
  default     = "12.0"
}

variable "storage_account_type" {
  description = "Storage account type for the database"
  type        = string
  default     = "Local"
}

variable "azuread_authentication_only" {
  description = "Whether to use Azure AD authentication only"
  type        = bool
  default     = false
}

variable "azuread_admin_login_username" {
  description = "Azure AD admin login username"
  type        = string
}

variable "azuread_admin_object_id" {
  description = "Azure AD admin object ID"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet for virtual network rule"
  type        = string
}

variable "sku_name" {
  description = "SKU name for the SQL Database"
  type        = string
  default     = "GP_S_Gen5_1"
}

variable "tags" {
  description = "Tags to be applied to resources"
  type        = map(string)
  default     = {}
}

# Database Security Configuration
variable "enable_public_access" {
  description = "Enable public IP access to SQL Server (should be false for production)"
  type        = bool
  default     = false
}

variable "allowed_ip_ranges" {
  description = "List of IP ranges allowed to access SQL Server (CIDR notation)"
  type = list(object({
    name             = string
    start_ip_address = string
    end_ip_address   = string
  }))
  default = []
  validation {
    condition = alltrue([
      for ip_range in var.allowed_ip_ranges :
      can(regex("^([0-9]{1,3}\\.){{3}}[0-9]{1,3}$", ip_range.start_ip_address)) &&
      can(regex("^([0-9]{1,3}\\.){{3}}[0-9]{1,3}$", ip_range.end_ip_address))
    ])
    error_message = "IP addresses must be in valid IPv4 format (e.g., '192.168.1.1')."
  }
}

variable "enable_auditing" {
  description = "Enable SQL Server auditing and logging"
  type        = bool
  default     = false
}

variable "audit_storage_account_id" {
  description = "Storage account ID for audit logs (required if enable_auditing is true)"
  type        = string
  default     = null
}

variable "minimum_tls_version" {
  description = "Minimum TLS version for SQL Server connections"
  type        = string
  default     = "1.2"
  validation {
    condition     = contains(["1.0", "1.1", "1.2"], var.minimum_tls_version)
    error_message = "Minimum TLS version must be 1.0, 1.1, or 1.2."
  }
}