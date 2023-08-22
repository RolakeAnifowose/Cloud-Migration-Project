resource "azurerm_lb" "migration-load-balancer" {
    name = "migration-load-balancer"
    resource_group_name = azurerm_resource_group.cloud-migration-resource-group.name
    location = azurerm_resource_group.cloud-migration-resource-group.location

    frontend_ip_configuration {
      name = "PublicIPAddress"
      public_ip_address_id = azurerm_public_ip.cloud-migration-public-ip.id
    }
}

resource "azurerm_lb_backend_address_pool" "load-balancer-backend-pool" {
    loadbalancer_id = azurerm_lb.migration-load-balancer.id
    name = "BackEndAddressPool"
}

resource "azurerm_lb_rule" "load-balancer-rule" {
  loadbalancer_id = azurerm_lb.migration-load-balancer.id
  name = "LBRule"
  protocol = "Tcp"
  frontend_port = 80
  backend_port = 80
  frontend_ip_configuration_name = "PublicIPAddress"
}

resource "azurerm_lb_probe" "health-check-probe" {
  loadbalancer_id = azurerm_lb.migration-load-balancer.id
  name = "health-check-probe"
  protocol = "Http"
  port = 80
  request_path = "/"
}

resource "azurerm_network_interface_backend_address_pool_association" "vm_backend_pool_association" {
  count = 3
  network_interface_id = azurerm_network_interface.cloud-migration-network-interface[count.index].id
  ip_configuration_name = "interface"
  backend_address_pool_id = azurerm_lb_backend_address_pool.load-balancer-backend-pool.id
}