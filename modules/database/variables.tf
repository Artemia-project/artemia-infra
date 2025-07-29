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

variable "tags" {
  description = "Tags to be applied to resources"
  type        = map(string)
  default     = {}
}