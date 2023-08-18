#Resource Group
resource "azurerm_resource_group" "cloud-migration-resource-group" {
    name = "cloud-migration-resource-group"
    location = "UK South"
}