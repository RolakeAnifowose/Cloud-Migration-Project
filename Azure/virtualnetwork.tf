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
    virtual_network_name = "azurerm_virtual_network.cloud-migration-virtual-network.name"
}

resource "azurerm_subnet" "private-subnet" {
    name = "public-subnet"
    resource_group_name = azurerm_resource_group.cloud-migration-resource-group.name
    address_prefixes = ["10.0.2.0/24"]
    virtual_network_name = "azurerm_virtual_network.cloud-migration-virtual-network.name"
}

#Public IP
resource "azurerm_public_ip" "cloud-migration-public-ip" {
    name = cloud-migration-public-ip
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
    name = cloud-migration-network-interface
    location = azurerm_resource_group.cloud-migration-resource-group.location
    resource_group_name = azurerm_resource_group.cloud-migration-resource-group.name
    ip_configuration {
        name = "interface"
        subnet_id = azurerm_subnet.public-subnet.id
        private_ip_address_allocation = "Dynamic"
    }
}