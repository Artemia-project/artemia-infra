# NSG Rules for Backend VM
# HTTP Access - Configurable source IP ranges
resource "azurerm_network_security_rule" "backend_http" {
  count                       = length(var.allowed_ip_ranges)
  name                        = "HTTP-${count.index + 1}"
  priority                    = 300 + count.index
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = var.allowed_ip_ranges[count.index]
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.backend.name
}

# HTTPS Access - Configurable source IP ranges
resource "azurerm_network_security_rule" "backend_https" {
  count                       = length(var.allowed_ip_ranges)
  name                        = "HTTPS-${count.index + 1}"
  priority                    = 320 + count.index
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = var.allowed_ip_ranges[count.index]
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.backend.name
}

# SSH Access - More restrictive IP ranges
resource "azurerm_network_security_rule" "backend_ssh" {
  count                       = length(var.ssh_allowed_ip_ranges)
  name                        = "SSH-${count.index + 1}"
  priority                    = 340 + count.index
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = var.ssh_allowed_ip_ranges[count.index]
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.backend.name
}

# RDP Access - Only if explicitly enabled (typically disabled for Linux VMs)
resource "azurerm_network_security_rule" "backend_rdp" {
  count                       = var.enable_rdp_access ? length(var.ssh_allowed_ip_ranges) : 0
  name                        = "RDP-${count.index + 1}"
  priority                    = 360 + count.index
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = var.ssh_allowed_ip_ranges[count.index]
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.backend.name
}

# NSG Rules for Data VM
# HTTP Access - Configurable source IP ranges
resource "azurerm_network_security_rule" "data_http" {
  count                       = length(var.allowed_ip_ranges)
  name                        = "HTTP-${count.index + 1}"
  priority                    = 300 + count.index
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = var.allowed_ip_ranges[count.index]
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.data.name
}

# HTTPS Access - Configurable source IP ranges
resource "azurerm_network_security_rule" "data_https" {
  count                       = length(var.allowed_ip_ranges)
  name                        = "HTTPS-${count.index + 1}"
  priority                    = 320 + count.index
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = var.allowed_ip_ranges[count.index]
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.data.name
}

# SSH Access - More restrictive IP ranges
resource "azurerm_network_security_rule" "data_ssh" {
  count                       = length(var.ssh_allowed_ip_ranges)
  name                        = "SSH-${count.index + 1}"
  priority                    = 340 + count.index
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = var.ssh_allowed_ip_ranges[count.index]
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.data.name
}

# RDP Access - Only if explicitly enabled
resource "azurerm_network_security_rule" "data_rdp" {
  count                       = var.enable_rdp_access ? length(var.ssh_allowed_ip_ranges) : 0
  name                        = "RDP-${count.index + 1}"
  priority                    = 360 + count.index
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = var.ssh_allowed_ip_ranges[count.index]
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.data.name
}

# Airflow UI Access (port 8080) - Configurable source IP ranges
resource "azurerm_network_security_rule" "data_airflow_ui" {
  count                       = length(var.airflow_ui_allowed_ip_ranges)
  name                        = "Airflow-UI-${count.index + 1}"
  priority                    = 380 + count.index
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8080"
  source_address_prefix       = var.airflow_ui_allowed_ip_ranges[count.index]
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.data.name
}

# NSG Rules for Elasticsearch VM
# HTTP Access - Configurable source IP ranges (for Elasticsearch API)
resource "azurerm_network_security_rule" "elasticsearch_http" {
  count                       = length(var.allowed_ip_ranges)
  name                        = "HTTP-${count.index + 1}"
  priority                    = 310 + count.index
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = var.allowed_ip_ranges[count.index]
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.elasticsearch.name
}

# HTTPS Access - Configurable source IP ranges (for Elasticsearch API)
resource "azurerm_network_security_rule" "elasticsearch_https" {
  count                       = length(var.allowed_ip_ranges)
  name                        = "HTTPS-${count.index + 1}"
  priority                    = 330 + count.index
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = var.allowed_ip_ranges[count.index]
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.elasticsearch.name
}

# SSH Access - More restrictive IP ranges
resource "azurerm_network_security_rule" "elasticsearch_ssh" {
  count                       = length(var.ssh_allowed_ip_ranges)
  name                        = "SSH-${count.index + 1}"
  priority                    = 350 + count.index
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = var.ssh_allowed_ip_ranges[count.index]
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.elasticsearch.name
}

# RDP Access - Only if explicitly enabled
resource "azurerm_network_security_rule" "elasticsearch_rdp" {
  count                       = var.enable_rdp_access ? length(var.ssh_allowed_ip_ranges) : 0
  name                        = "RDP-${count.index + 1}"
  priority                    = 360 + count.index
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = var.ssh_allowed_ip_ranges[count.index]
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.elasticsearch.name
}

# Additional Elasticsearch-specific ports (9200, 9300) for internal communication
resource "azurerm_network_security_rule" "elasticsearch_api" {
  name                        = "Elasticsearch-Internal"
  priority                    = 400
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["9200", "9300"]
  source_address_prefix       = var.default_subnet_address_prefixes[0] # Only from internal subnet
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.elasticsearch.name
}