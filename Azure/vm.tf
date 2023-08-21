resource "azurerm_linux_virtual_machine" "cloud-migration-vms" {
    count = 3
    name = "web-server-${count.index}"
    resource_group_name = azurerm_resource_group.cloud-migration-resource-group.name
    location = azurerm_resource_group.cloud-migration-resource-group.location
    size = "Standard_B1Is"
    admin_username = "azureuser"
    network_interface_ids = [ 
        azurerm_network_interface.cloud-migration-network-interface.id 
    ]

    admin_ssh_key {
        username = "azureuser"
        public_key = file("~/.ssh/id_rsa.pub")
    }

    os_disk {
        caching = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer = "UbuntuServer"
        sku = "20.04-LTS"
        version = "latest"
    }
}