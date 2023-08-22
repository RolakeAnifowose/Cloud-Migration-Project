resource "azurerm_windows_virtual_machine" "example" {
    count = 3
    name = "web-server-${count.index}"
    resource_group_name = azurerm_resource_group.cloud-migration-resource-group.name
    location = azurerm_resource_group.cloud-migration-resource-group.location
    size = "Standard_B1s"
    admin_username = "adminuser"
    admin_password = "@NyxTPP123!"
    network_interface_ids = [
        azurerm_network_interface.cloud-migration-network-interface[count.index].id,
    ]
    availability_set_id = azurerm_availability_set.vm-availability-set.id

    os_disk {
        caching = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    source_image_reference {
        publisher = "MicrosoftWindowsServer"
        offer = "WindowsServer"
        sku = "2016-Datacenter"
        version = "latest"
    }
}