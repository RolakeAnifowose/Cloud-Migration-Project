resource "azurerm_eventhub_namespace" "migration-eventhub-namespace" {
    name = "migration-eventhub-namespace"
    resource_group_name = azurerm_resource_group.cloud-migration-resource-group.name
    location = azurerm_resource_group.cloud-migration-resource-group.location
    sku = "Basic"
}

resource "azurerm_eventhub" "migration-eventhub" {
    name = "migration-eventhub"
    resource_group_name = azurerm_resource_group.cloud-migration-resource-group.name
    namespace_name = azurerm_eventhub_namespace.migration-eventhub-namespace.name
    partition_count = 2
    message_retention = 1
}

resource "azurerm_eventhub_authorization_rule" "authorization_rule" {
    name = "authorization_rule"
    resource_group_name = azurerm_resource_group.cloud-migration-resource-group.name
    namespace_name = azurerm_eventhub_namespace.migration-eventhub-namespace.name
    eventhub_name = azurerm_eventhub.migration-eventhub.name
    send = true
}

resource "azurerm_iothub" "migration-iot-hub" {
    name = "migration-iot-hub"
    resource_group_name = azurerm_resource_group.cloud-migration-resource-group.name
    location = azurerm_resource_group.cloud-migration-resource-group.location

    sku {
        name = "S1"
        capacity = "1"
    }
}