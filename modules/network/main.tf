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

resource "azurerm_network_security_group" "llm" {
  location            = var.location
  name                = "${var.project_name}-llm-vm-nsg"
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
resource "azurerm_network_security_rule" "backend_http" {
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "80"
  direction                   = "Inbound"
  name                        = "HTTP"
  network_security_group_name = azurerm_network_security_group.backend.name
  priority                    = 300
  protocol                    = "Tcp"
  resource_group_name         = var.resource_group_name
  source_address_prefix       = "*"
  source_port_range           = "*"
}

resource "azurerm_network_security_rule" "backend_https" {
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "443"
  direction                   = "Inbound"
  name                        = "HTTPS"
  network_security_group_name = azurerm_network_security_group.backend.name
  priority                    = 320
  protocol                    = "Tcp"
  resource_group_name         = var.resource_group_name
  source_address_prefix       = "*"
  source_port_range           = "*"
}

resource "azurerm_network_security_rule" "backend_ssh" {
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "22"
  direction                   = "Inbound"
  name                        = "SSH"
  network_security_group_name = azurerm_network_security_group.backend.name
  priority                    = 340
  protocol                    = "Tcp"
  resource_group_name         = var.resource_group_name
  source_address_prefix       = "*"
  source_port_range           = "*"
}

resource "azurerm_network_security_rule" "backend_rdp" {
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "3389"
  direction                   = "Inbound"
  name                        = "RDP"
  network_security_group_name = azurerm_network_security_group.backend.name
  priority                    = 360
  protocol                    = "Tcp"
  resource_group_name         = var.resource_group_name
  source_address_prefix       = "*"
  source_port_range           = "*"
}

# NSG Rules for LLM VM
resource "azurerm_network_security_rule" "llm_http" {
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "80"
  direction                   = "Inbound"
  name                        = "HTTP"
  network_security_group_name = azurerm_network_security_group.llm.name
  priority                    = 340
  protocol                    = "Tcp"
  resource_group_name         = var.resource_group_name
  source_address_prefix       = "*"
  source_port_range           = "*"
}

resource "azurerm_network_security_rule" "llm_https" {
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "443"
  direction                   = "Inbound"
  name                        = "HTTPS"
  network_security_group_name = azurerm_network_security_group.llm.name
  priority                    = 320
  protocol                    = "Tcp"
  resource_group_name         = var.resource_group_name
  source_address_prefix       = "*"
  source_port_range           = "*"
}

resource "azurerm_network_security_rule" "llm_ssh" {
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "22"
  direction                   = "Inbound"
  name                        = "SSH"
  network_security_group_name = azurerm_network_security_group.llm.name
  priority                    = 300
  protocol                    = "Tcp"
  resource_group_name         = var.resource_group_name
  source_address_prefix       = "*"
  source_port_range           = "*"
}

resource "azurerm_network_security_rule" "llm_rdp" {
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "3389"
  direction                   = "Inbound"
  name                        = "RDP"
  network_security_group_name = azurerm_network_security_group.llm.name
  priority                    = 360
  protocol                    = "Tcp"
  resource_group_name         = var.resource_group_name
  source_address_prefix       = "*"
  source_port_range           = "*"
}

# NSG Rules for Elasticsearch VM
resource "azurerm_network_security_rule" "elasticsearch_http" {
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "80"
  direction                   = "Inbound"
  name                        = "HTTP"
  network_security_group_name = azurerm_network_security_group.elasticsearch.name
  priority                    = 320
  protocol                    = "Tcp"
  resource_group_name         = var.resource_group_name
  source_address_prefix       = "*"
  source_port_range           = "*"
}

resource "azurerm_network_security_rule" "elasticsearch_https" {
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "443"
  direction                   = "Inbound"
  name                        = "HTTPS"
  network_security_group_name = azurerm_network_security_group.elasticsearch.name
  priority                    = 340
  protocol                    = "Tcp"
  resource_group_name         = var.resource_group_name
  source_address_prefix       = "*"
  source_port_range           = "*"
}

resource "azurerm_network_security_rule" "elasticsearch_ssh" {
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "22"
  direction                   = "Inbound"
  name                        = "SSH"
  network_security_group_name = azurerm_network_security_group.elasticsearch.name
  priority                    = 300
  protocol                    = "Tcp"
  resource_group_name         = var.resource_group_name
  source_address_prefix       = "*"
  source_port_range           = "*"
}

resource "azurerm_network_security_rule" "elasticsearch_rdp" {
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "3389"
  direction                   = "Inbound"
  name                        = "RDP"
  network_security_group_name = azurerm_network_security_group.elasticsearch.name
  priority                    = 360
  protocol                    = "Tcp"
  resource_group_name         = var.resource_group_name
  source_address_prefix       = "*"
  source_port_range           = "*"
}