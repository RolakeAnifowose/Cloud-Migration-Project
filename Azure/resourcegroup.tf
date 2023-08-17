provider "azurerm" {
    version = "3.0.0"
}

resource "azurerm_resource_group" "cloud-migration-resource-group" {
    name = "cloud-migration-resource-group"
    location = var.location
}