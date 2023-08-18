resource "azurerm_storage_account" "cloud-migration-storage-account" {
    name = "migrationstorageaccount"
    location = azurerm_resource_group.cloud-migration-resource-group.location
    resource_group_name = azurerm_resource_group.cloud-migration-resource-group.name
    account_tier = "Standard"
    account_replication_type = "LRS" #Locally redundant storage
}

resource "azurerm_storage_container" "cloud-migration-storage-container" {
    name = "cloud-migration-storage-container"
    storage_account_name = azurerm_storage_account.cloud-migration-storage-account.name
    container_access_type = "private"
}

resource "azurerm_storage_blob" "cloud-migration-blob-storage" {
    name = "cloud-migration-blob-storage"
    storage_account_name = azurerm_storage_account.cloud-migration-storage-account.name
    storage_container_name = azurerm_storage_container.cloud-migration-storage-container.name
    type = "Block"
}