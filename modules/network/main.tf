# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  address_space       = var.vnet_address_space
  location            = var.location
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# Default Subnet
resource "azurerm_subnet" "default" {
  address_prefixes     = var.default_subnet_address_prefixes
  name                 = "default"
  resource_group_name  = var.resource_group_name
  service_endpoints    = ["Microsoft.Sql"]
  virtual_network_name = azurerm_virtual_network.vnet.name
}

# Azure Firewall Subnet
resource "azurerm_subnet" "firewall" {
  address_prefixes     = var.firewall_subnet_address_prefixes
  name                 = "AzureFirewallSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
}

# Load Balancer - using subnet for internal LB
resource "azurerm_lb" "main" {
  location            = var.location
  name                = var.load_balancer_name
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  tags                = var.tags

  frontend_ip_configuration {
    name                          = "lb-frontend-ip"
    subnet_id                     = azurerm_subnet.default.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Load Balancer Backend Pool
resource "azurerm_lb_backend_address_pool" "main" {
  loadbalancer_id = azurerm_lb.main.id
  name            = "${var.project_name}-backend-pool"
}

# Network Security Groups
resource "azurerm_network_security_group" "backend" {
  location            = var.location
  name                = "${var.project_name}-backend-vm-nsg"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_network_security_group" "data" {
  location            = var.location
  name                = "${var.project_name}-data-vm-nsg"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_network_security_group" "elasticsearch" {
  location            = var.location
  name                = "${var.project_name}-elasticsearch-vm-nsg"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# NSG Rules for Backend VM
# HTTP Access - Configurable source IP ranges
resource "azurerm_network_security_rule" "backend_http" {
  count                       = length(var.allowed_ip_ranges)
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "80"
  direction                   = "Inbound"
  name                        = "HTTP-${count.index + 1}"
  network_security_group_name = azurerm_network_security_group.backend.name
  priority                    = 300 + count.index
  protocol                    = "Tcp"
  resource_group_name         = var.resource_group_name
  source_address_prefix       = var.allowed_ip_ranges[count.index]
  source_port_range           = "*"
}

# HTTPS Access - Configurable source IP ranges
resource "azurerm_network_security_rule" "backend_https" {
  count                       = length(var.allowed_ip_ranges)
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "443"
  direction                   = "Inbound"
  name                        = "HTTPS-${count.index + 1}"
  network_security_group_name = azurerm_network_security_group.backend.name
  priority                    = 320 + count.index
  protocol                    = "Tcp"
  resource_group_name         = var.resource_group_name
  source_address_prefix       = var.allowed_ip_ranges[count.index]
  source_port_range           = "*"
}

# SSH Access - More restrictive IP ranges
resource "azurerm_network_security_rule" "backend_ssh" {
  count                       = length(var.ssh_allowed_ip_ranges)
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "22"
  direction                   = "Inbound"
  name                        = "SSH-${count.index + 1}"
  network_security_group_name = azurerm_network_security_group.backend.name
  priority                    = 340 + count.index
  protocol                    = "Tcp"
  resource_group_name         = var.resource_group_name
  source_address_prefix       = var.ssh_allowed_ip_ranges[count.index]
  source_port_range           = "*"
}

# RDP Access - Only if explicitly enabled (typically disabled for Linux VMs)
resource "azurerm_network_security_rule" "backend_rdp" {
  count                       = var.enable_rdp_access ? length(var.ssh_allowed_ip_ranges) : 0
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "3389"
  direction                   = "Inbound"
  name                        = "RDP-${count.index + 1}"
  network_security_group_name = azurerm_network_security_group.backend.name
  priority                    = 360 + count.index
  protocol                    = "Tcp"
  resource_group_name         = var.resource_group_name
  source_address_prefix       = var.ssh_allowed_ip_ranges[count.index]
  source_port_range           = "*"
}

# NSG Rules for Data VM
# HTTP Access - Configurable source IP ranges
resource "azurerm_network_security_rule" "data_http" {
  count                       = length(var.allowed_ip_ranges)
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "80"
  direction                   = "Inbound"
  name                        = "HTTP-${count.index + 1}"
  network_security_group_name = azurerm_network_security_group.data.name
  priority                    = 300 + count.index
  protocol                    = "Tcp"
  resource_group_name         = var.resource_group_name
  source_address_prefix       = var.allowed_ip_ranges[count.index]
  source_port_range           = "*"
}

# HTTPS Access - Configurable source IP ranges
resource "azurerm_network_security_rule" "data_https" {
  count                       = length(var.allowed_ip_ranges)
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "443"
  direction                   = "Inbound"
  name                        = "HTTPS-${count.index + 1}"
  network_security_group_name = azurerm_network_security_group.data.name
  priority                    = 320 + count.index
  protocol                    = "Tcp"
  resource_group_name         = var.resource_group_name
  source_address_prefix       = var.allowed_ip_ranges[count.index]
  source_port_range           = "*"
}

# SSH Access - More restrictive IP ranges
resource "azurerm_network_security_rule" "data_ssh" {
  count                       = length(var.ssh_allowed_ip_ranges)
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "22"
  direction                   = "Inbound"
  name                        = "SSH-${count.index + 1}"
  network_security_group_name = azurerm_network_security_group.data.name
  priority                    = 340 + count.index
  protocol                    = "Tcp"
  resource_group_name         = var.resource_group_name
  source_address_prefix       = var.ssh_allowed_ip_ranges[count.index]
  source_port_range           = "*"
}

# RDP Access - Only if explicitly enabled
resource "azurerm_network_security_rule" "data_rdp" {
  count                       = var.enable_rdp_access ? length(var.ssh_allowed_ip_ranges) : 0
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "3389"
  direction                   = "Inbound"
  name                        = "RDP-${count.index + 1}"
  network_security_group_name = azurerm_network_security_group.data.name
  priority                    = 360 + count.index
  protocol                    = "Tcp"
  resource_group_name         = var.resource_group_name
  source_address_prefix       = var.ssh_allowed_ip_ranges[count.index]
  source_port_range           = "*"
}

# NSG Rules for Elasticsearch VM
# HTTP Access - Configurable source IP ranges (for Elasticsearch API)
resource "azurerm_network_security_rule" "elasticsearch_http" {
  count                       = length(var.allowed_ip_ranges)
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "80"
  direction                   = "Inbound"
  name                        = "HTTP-${count.index + 1}"
  network_security_group_name = azurerm_network_security_group.elasticsearch.name
  priority                    = 310 + count.index
  protocol                    = "Tcp"
  resource_group_name         = var.resource_group_name
  source_address_prefix       = var.allowed_ip_ranges[count.index]
  source_port_range           = "*"
}

# HTTPS Access - Configurable source IP ranges (for Elasticsearch API)
resource "azurerm_network_security_rule" "elasticsearch_https" {
  count                       = length(var.allowed_ip_ranges)
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "443"
  direction                   = "Inbound"
  name                        = "HTTPS-${count.index + 1}"
  network_security_group_name = azurerm_network_security_group.elasticsearch.name
  priority                    = 330 + count.index
  protocol                    = "Tcp"
  resource_group_name         = var.resource_group_name
  source_address_prefix       = var.allowed_ip_ranges[count.index]
  source_port_range           = "*"
}

# SSH Access - More restrictive IP ranges
resource "azurerm_network_security_rule" "elasticsearch_ssh" {
  count                       = length(var.ssh_allowed_ip_ranges)
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "22"
  direction                   = "Inbound"
  name                        = "SSH-${count.index + 1}"
  network_security_group_name = azurerm_network_security_group.elasticsearch.name
  priority                    = 350 + count.index
  protocol                    = "Tcp"
  resource_group_name         = var.resource_group_name
  source_address_prefix       = var.ssh_allowed_ip_ranges[count.index]
  source_port_range           = "*"
}

# RDP Access - Only if explicitly enabled
resource "azurerm_network_security_rule" "elasticsearch_rdp" {
  count                       = var.enable_rdp_access ? length(var.ssh_allowed_ip_ranges) : 0
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "3389"
  direction                   = "Inbound"
  name                        = "RDP-${count.index + 1}"
  network_security_group_name = azurerm_network_security_group.elasticsearch.name
  priority                    = 360 + count.index
  protocol                    = "Tcp"
  resource_group_name         = var.resource_group_name
  source_address_prefix       = var.ssh_allowed_ip_ranges[count.index]
  source_port_range           = "*"
}

# Additional Elasticsearch-specific ports (9200, 9300) for internal communication
resource "azurerm_network_security_rule" "elasticsearch_api" {
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_ranges     = ["9200", "9300"]
  direction                   = "Inbound"
  name                        = "Elasticsearch-Internal"
  network_security_group_name = azurerm_network_security_group.elasticsearch.name
  priority                    = 400
  protocol                    = "Tcp"
  resource_group_name         = var.resource_group_name
  source_address_prefix       = var.default_subnet_address_prefixes[0] # Only from internal subnet
  source_port_range           = "*"
}