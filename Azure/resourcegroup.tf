#Resource Group
resource "azurerm_resource_group" "cloud-migration-resource-group" {
    name = "cloud-migration-resource-group"
    location = "UK South"
}

#Network Security Group
resource "azurerm_network_security_group" "cloud-migration-nsg" {
    name = "cloud-migration-nsg"
    resource_group_name = azurerm_resource_group.cloud-migration-resource-group.name
    location = azurerm_resource_group.cloud-migration-resource-group.location

    security_rule {
        name = "inbound-http-access"
        priority = 100
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "80"
        source_address_prefix = "*"
        destination_address_prefix = "*"
    }

    security_rule {
        name = "inbound-https-access"
        priority = 110
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "443"
        source_address_prefix = "*"
        destination_address_prefix = "*"
    }

    security_rule {
        name = "outbound-access"
        priority = 100
        direction = "Outbound"
        access = "Allow"
        protocol = "*"
        source_port_range = "*"
        destination_port_range = "*"
        source_address_prefix = "*"
        destination_address_prefix = "*"
    }
}