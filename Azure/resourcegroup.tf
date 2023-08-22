#Resource Group
resource "azurerm_resource_group" "cloud-migration-resource-group" {
    name = "cloud-migration-resource-group"
    location = "East US"
}

resource "azurerm_availability_set" "vm-availability-set" {
  name = "vm-availability-set"
  location = azurerm_resource_group.cloud-migration-resource-group.location
  resource_group_name = azurerm_resource_group.cloud-migration-resource-group.name

  tags = {
    environment = "Production"
  }
}