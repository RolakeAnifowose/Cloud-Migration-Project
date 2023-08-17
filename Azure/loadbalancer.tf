resource "azurerm_lb" "migration-load-balancer" {
    name = "migration-load-balancer"
    resource_group_name = azurerm_resource_group.cloud-migration-resource-group.name
    location = azurerm_resource_group.cloud-migration-resource-group.location

    frontend_ip_configuration {
      name = "PublicIPAddress"
      public_ip_address_id = azurerm_public_ip.cloud-migration-public-ip.id
    }
}