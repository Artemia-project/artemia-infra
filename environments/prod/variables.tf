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
  validation {
    condition     = can(regex("^ssh-(rsa|ed25519|ecdsa)", var.ssh_public_key_backend))
    error_message = "SSH public key must be in valid OpenSSH format (ssh-rsa, ssh-ed25519, or ssh-ecdsa)."
  }
}

variable "ssh_public_key_data" {
  description = "SSH public key for Data VM"
  type        = string
  sensitive   = true
  validation {
    condition     = can(regex("^ssh-(rsa|ed25519|ecdsa)", var.ssh_public_key_data))
    error_message = "SSH public key must be in valid OpenSSH format (ssh-rsa, ssh-ed25519, or ssh-ecdsa)."
  }
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

variable "sku_name" {
  description = "SKU name for the SQL Database"
  type        = string
  default     = "GP_S_Gen5_1"
}

# Network configuration
variable "project_name" {
  description = "Name of the project for resource naming"
  type        = string
  default     = "artemia"
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
  default     = "artemia-vnet"
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
  default     = "artemia-load-balancer"
}

# Compute configuration
variable "admin_username" {
  description = "Administrator username for VMs"
  type        = string
  default     = "azureuser"
}

variable "backend_vm_size" {
  description = "Size of the backend VM"
  type        = string
  default     = "Standard_D2s_v5"
}

variable "data_vm_size" {
  description = "Size of the Data VM"
  type        = string
  default     = "Standard_E4ds_v4"
}

variable "elasticsearch_vm_size" {
  description = "Size of the Elasticsearch VM"
  type        = string
  default     = "Standard_D2s_v5"
}

variable "backend_storage_account_type" {
  description = "Storage account type for backend VM"
  type        = string
  default     = "StandardSSD_LRS"
}

variable "data_storage_account_type" {
  description = "Storage account type for Data VM"
  type        = string
  default     = "Premium_LRS"
}

variable "elasticsearch_storage_account_type" {
  description = "Storage account type for Elasticsearch VM"
  type        = string
  default     = "Premium_LRS"
}

# Database configuration
variable "server_name" {
  description = "Name of the SQL Server"
  type        = string
  default     = "artemia-server"
}

variable "database_name" {
  description = "Name of the SQL Database"
  type        = string
  default     = "artemia-database"
}

variable "server_version" {
  description = "Version of the SQL Server"
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
  default     = "artemia-group"
}

variable "azuread_admin_object_id" {
  description = "Azure AD admin object ID"
  type        = string
  default     = "d671c231-b875-4048-92f7-39ea71f488c6"
}

# Storage configuration
variable "main_storage_account_name" {
  description = "Name of the main data storage account"
  type        = string
  default     = "artemiadata"
}

variable "state_storage_account_name" {
  description = "Name of the Terraform state storage account"
  type        = string
  default     = "artemiastatestore"
}

variable "account_tier" {
  description = "Storage account tier"
  type        = string
  default     = "Standard"
}

variable "account_replication_type" {
  description = "Storage account replication type"
  type        = string
  default     = "LRS"
}

variable "allow_nested_items_to_be_public" {
  description = "Allow nested items to be public in storage account"
  type        = bool
  default     = false
}

variable "min_tls_version" {
  description = "Minimum TLS version for storage account"
  type        = string
  default     = "TLS1_2"
}

# Messaging configuration
variable "namespace_name" {
  description = "Name of the EventHub namespace"
  type        = string
  default     = "artemia-event-hubs-kafka"
}

variable "namespace_sku" {
  description = "SKU for the EventHub namespace"
  type        = string
  default     = "Standard"
}

variable "local_authentication_enabled" {
  description = "Whether local authentication is enabled for EventHub"
  type        = bool
  default     = false
}

variable "eventhub_name" {
  description = "Name of the EventHub"
  type        = string
  default     = "artemia-events"
}

variable "message_retention" {
  description = "Message retention in days for EventHub"
  type        = number
  default     = 1
}

variable "partition_count" {
  description = "Number of partitions for EventHub"
  type        = number
  default     = 1
}

variable "auth_rule_name" {
  description = "Name of the EventHub authorization rule"
  type        = string
  default     = "RootManageSharedAccessKey"
}

variable "auth_rule_listen" {
  description = "Whether the auth rule has listen permissions"
  type        = bool
  default     = true
}

variable "auth_rule_manage" {
  description = "Whether the auth rule has manage permissions"
  type        = bool
  default     = true
}

variable "auth_rule_send" {
  description = "Whether the auth rule has send permissions"
  type        = bool
  default     = true
}

# AI/ML configuration
variable "cognitive_account_name" {
  description = "Name of the cognitive services account"
  type        = string
  default     = "artemia-openai"
}

variable "custom_subdomain_name" {
  description = "Custom subdomain name for cognitive services"
  type        = string
  default     = "artemia-openai"
}

variable "cognitive_kind" {
  description = "Kind of cognitive services account"
  type        = string
  default     = "OpenAI"
}

variable "cognitive_sku_name" {
  description = "SKU name for cognitive services"
  type        = string
  default     = "S0"
}

variable "network_acls_default_action" {
  description = "Default action for network ACLs"
  type        = string
  default     = "Allow"
}

# Monitoring configuration
variable "primary_action_group_name" {
  description = "Name of the primary action group"
  type        = string
  default     = "artemia-ag"
}

variable "recommended_action_group_name" {
  description = "Name of the recommended action group"
  type        = string
  default     = "RecommendedAlertRules-AG-1"
}

variable "primary_short_name" {
  description = "Short name for primary action group"
  type        = string
  default     = "Artemia AG"
}

variable "recommended_short_name" {
  description = "Short name for recommended action group"
  type        = string
  default     = "recalert1"
}

variable "cpu_threshold" {
  description = "CPU threshold for monitoring alerts"
  type        = number
  default     = 80
}

variable "memory_threshold" {
  description = "Memory threshold for monitoring alerts (in bytes)"
  type        = number
  default     = 1000000000
}

variable "disk_iops_threshold" {
  description = "Disk IOPS threshold for monitoring alerts"
  type        = number
  default     = 95
}

variable "network_in_threshold" {
  description = "Network in threshold for monitoring alerts (in bytes)"
  type        = number
  default     = 500000000000
}

variable "network_out_threshold" {
  description = "Network out threshold for monitoring alerts (in bytes)"
  type        = number
  default     = 200000000000
}

# Auto-shutdown configuration
variable "enable_auto_shutdown" {
  description = "Enable automatic VM shutdown for cost optimization"
  type        = bool
  default     = false
}

variable "auto_shutdown_time" {
  description = "Time to automatically shutdown VMs (24-hour format, e.g., '18:00')"
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
  description = "Time to automatically start VMs (24-hour format, e.g., '09:00')"
  type        = string
  default     = "09:00"
}

variable "weekend_shutdown_enabled" {
  description = "Enable weekend shutdown (Friday evening to Monday morning)"
  type        = bool
  default     = false
}

variable "notification_email_shutdown" {
  description = "Email to notify before VM shutdown"
  type        = string
  default     = ""
}

# Cost optimization settings
variable "enable_cost_optimization" {
  description = "Enable cost optimization features"
  type        = bool
  default     = false
}

variable "burstable_vm_sizes" {
  description = "Use burstable VM sizes for cost optimization (overrides vm_size variables)"
  type        = bool
  default     = false
}

# Security Configuration for Production Environment
variable "allowed_ip_ranges" {
  description = "List of IP ranges allowed to access VMs and services (CIDR notation)"
  type        = list(string)
  default     = ["0.0.0.0/0"]  # CHANGE THIS FOR PRODUCTION - Use specific office/VPN IP ranges
  validation {
    condition = alltrue([
      for cidr in var.allowed_ip_ranges : can(cidrhost(cidr, 0))
    ])
    error_message = "All IP ranges must be valid CIDR notation (e.g., '192.168.1.0/24')."
  }
}

variable "ssh_allowed_ip_ranges" {
  description = "More restrictive IP ranges allowed for SSH access (CIDR notation)"
  type        = list(string)
  default     = ["0.0.0.0/0"]  # CHANGE THIS FOR PRODUCTION - Use specific admin IP ranges
  validation {
    condition = alltrue([
      for cidr in var.ssh_allowed_ip_ranges : can(cidrhost(cidr, 0))
    ])
    error_message = "All SSH IP ranges must be valid CIDR notation."
  }
}

variable "enable_rdp_access" {
  description = "Enable RDP access (port 3389) - should be false for Linux VMs"
  type        = bool
  default     = false
}

variable "enable_database_public_access" {
  description = "Enable public access to SQL Server - should be false for production"
  type        = bool
  default     = false
}

variable "database_allowed_ips" {
  description = "Specific IP ranges allowed to access SQL Server"
  type = list(object({
    name             = string
    start_ip_address = string
    end_ip_address   = string
  }))
  default = [
    # Add your office/VPN IP ranges here for production
    # {
    #   name             = "Office-Network"
    #   start_ip_address = "203.0.113.1"
    #   end_ip_address   = "203.0.113.100"
    # }
  ]
}

# Function App Configuration
variable "function_app_name" {
  description = "Name of the Function App"
  type        = string
  default     = "artemia-data-extract-function"
}

variable "app_service_plan_name" {
  description = "Name of the App Service Plan for Function App"
  type        = string
  default     = "ASP-artemiarg-bc89"
}

variable "function_storage_account_name" {
  description = "Name of the storage account for Function App"
  type        = string
  default     = "artemiafunctiondata"
}

variable "function_runtime_name" {
  description = "Runtime name for the Function App"
  type        = string
  default     = "python"
}

variable "function_runtime_version" {
  description = "Runtime version for the Function App"
  type        = string
  default     = "3.12"
}

variable "function_instance_memory_mb" {
  description = "Instance memory in MB for Function App"
  type        = number
  default     = 2048
}

variable "function_maximum_instance_count" {
  description = "Maximum instance count for Function App"
  type        = number
  default     = 100
}

variable "function_https_only" {
  description = "Enable HTTPS only for Function App"
  type        = bool
  default     = true
}

variable "function_public_network_access" {
  description = "Public network access setting for Function App"
  type        = string
  default     = "Enabled"
}

variable "function_key_vault_reference_identity" {
  description = "Key Vault reference identity for Function App"
  type        = string
  default     = "SystemAssigned"
}

variable "use_azure_cli" {
  description = "Use Azure CLI for authentication"
  type        = bool
  default     = true
}