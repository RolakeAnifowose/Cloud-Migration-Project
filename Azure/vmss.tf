resource "azurerm_windows_virtual_machine_scale_set" "vmss" {
  name = "vmss"
  resource_group_name = azurerm_resource_group.cloud-migration-resource-group.name
  location = azurerm_resource_group.cloud-migration-resource-group.location
  sku = "Standard_B1s"
  instances = 3
  admin_password = "@NyxTPP123!"
  admin_username = "adminuser"

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer = "WindowsServer"
    sku = "2016-Datacenter"
    version = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching = "ReadWrite"
  }

  network_interface {
    name = "cloud-migration-network-interface"
    primary = true

    ip_configuration {
      name = "interface"
      primary = true
      subnet_id = azurerm_subnet.public-subnet.id
    }
  }
}