#Virtual Network
resource "azurerm_virtual_network" "cloud-migration-virtual-network" {
    name = "cloud-migration-virtual-network"
    address_space = ["10.0.0.0/16"]
    location = azurerm_resource_group.cloud-migration-resource-group.location
    resource_group_name = azurerm_resource_group.cloud-migration-resource-group.name
    tags = {
        environment = "Production"
    }
}

#Subnet
resource "azurerm_subnet" "public-subnet" {
    name = "public-subnet"
    resource_group_name = azurerm_resource_group.cloud-migration-resource-group.name
    address_prefixes = ["10.0.1.0/24"]
    virtual_network_name = azurerm_virtual_network.cloud-migration-virtual-network.name
}

resource "azurerm_subnet" "private-subnet" {
    name = "private-subnet"
    resource_group_name = azurerm_resource_group.cloud-migration-resource-group.name
    address_prefixes = ["10.0.2.0/24"]
    virtual_network_name = azurerm_virtual_network.cloud-migration-virtual-network.name
}

#Public IP
resource "azurerm_public_ip" "cloud-migration-public-ip" {
    name = "cloud-migration-public-ip"
    location = azurerm_resource_group.cloud-migration-resource-group.location
    resource_group_name = azurerm_resource_group.cloud-migration-resource-group.name
    allocation_method = "Dynamic"
}

#Virtual Network Gateway
# resource "azurerm_virtual_network_gateway" "cloud-migration-network-gateway" {
#     name = cloud-migration-network-gateway
# }

#Network Interface to enable communication between VMs and the internet, Azure, and on-premises resources
resource "azurerm_network_interface" "cloud-migration-network-interface" {
    count = 3
    name = "cloud-migration-network-interface-${count.index}"
    location = azurerm_resource_group.cloud-migration-resource-group.location
    resource_group_name = azurerm_resource_group.cloud-migration-resource-group.name
    ip_configuration {
        name = "interface"
        subnet_id = azurerm_subnet.public-subnet.id
        private_ip_address_allocation = "Dynamic"
    }
}

resource "azurerm_network_interface" "cloud-migration-private-network-interface" {
    count = 2
    name = "cloud-migration-private-network-interface-${count.index}"
    location = azurerm_resource_group.cloud-migration-resource-group.location
    resource_group_name = azurerm_resource_group.cloud-migration-resource-group.name
    ip_configuration {
        name = "interface"
        subnet_id = azurerm_subnet.private-subnet.id
        private_ip_address_allocation = "Dynamic"
    }
}

#Network Security Group
resource "azurerm_network_security_group" "public-nsg" {
    name = "public-nsg"
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

resource "azurerm_subnet_network_security_group_association" "nsg-association-to-public-subnet" {
  subnet_id = azurerm_subnet.public-subnet.id
  network_security_group_id = azurerm_network_security_group.public-nsg.id
}

resource "azurerm_network_security_group" "private-nsg" {
    name = "private-nsg"
    resource_group_name = azurerm_resource_group.cloud-migration-resource-group.name
    location = azurerm_resource_group.cloud-migration-resource-group.location

    security_rule {
        name = "AllowInternalTraffic"
        priority = 100
        direction = "Inbound"
        access = "Allow"
        protocol = "*"
        source_port_range = "*"
        destination_port_range = "*"
        source_address_prefix = "VirtualNetwork"
        destination_address_prefix = "VirtualNetwork"
    }

    security_rule {
        name = "DenyAllInboundFromOutisdeSubnet"
        priority = 4096
        direction = "Inbound"
        access = "Deny"
        protocol = "*"
        source_port_range = "*"
        destination_port_range = "*"
        source_address_prefix = "*"
        destination_address_prefix = "10.0.2.0/24"
    }
}

resource "azurerm_subnet_network_security_group_association" "nsg-association-to-private-subnet" {
  subnet_id = azurerm_subnet.private-subnet.id
  network_security_group_id = azurerm_network_security_group.private-nsg.id
}