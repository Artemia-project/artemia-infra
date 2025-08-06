# Load Balancer - using subnet for internal LB
resource "azurerm_lb" "main" {
  name                = var.load_balancer_name
  location            = var.location
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
  name            = "${var.project_name}-backend-pool"
  loadbalancer_id = azurerm_lb.main.id
}