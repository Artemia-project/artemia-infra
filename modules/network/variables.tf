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