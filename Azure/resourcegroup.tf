provider "azurerm" {
    version = "1.35.0"
}

resource "azurerm_resource_group" "cloud-migration-resource-group" {
    name = "cloud-migration-resource-group"
    location = var.location
}