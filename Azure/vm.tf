# resource "azurerm_virtual_machine" "cloud-migration-vms" {
#     name = "vm1"
#     vm_size = "Standard_B1Is"
#     location = var.location
#     resource_group_name = azurerm_resource_group.cloud-migration-resource-group.name

#     storage_os_disk {
#         name = "vm1disk"
#         caching = "ReadWrite"
#         create_option = "FromImage"
#         managed_disk_type = "Standard_LRS"
#     }
# }