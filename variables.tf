# Variables for sensitive data
# Create a terraform.tfvars file to set these values (don't commit it to git)

variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
  sensitive   = true
}

variable "primary_email" {
  description = "Primary email address for notifications"
  type        = string
  sensitive   = true
}

variable "secondary_email" {
  description = "Secondary email address for notifications"  
  type        = string
  sensitive   = true
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "artemia-rg"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "Korea Central"
}

variable "storage_account_name" {
  description = "Name of the storage account for Terraform state"
  type        = string
  default     = "artemiastatestore"
}

# SSH Key configuration
variable "ssh_public_key_backend" {
  description = "SSH public key for backend VM"
  type        = string
  sensitive   = true
}

variable "ssh_public_key_llm" {
  description = "SSH public key for LLM VM"
  type        = string
  sensitive   = true
}

variable "ssh_public_key_elasticsearch" {
  description = "SSH public key for Elasticsearch VM"
  type        = string
  sensitive   = true
}

# Database configuration
variable "administrator_login" {
  description = "Administrator login username for SQL Server"
  type        = string
  default     = "artemia_admin"
}

variable "administrator_login_password" {
  description = "Administrator login password for SQL Server"
  type        = string
  sensitive   = true
}