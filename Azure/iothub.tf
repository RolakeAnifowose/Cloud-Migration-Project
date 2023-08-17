resource "azurerm_eventhub_namespace" "eventhub-namespace" {
    name = "eventhub-namespace"
    resource_group_name = azurerm_resource_group.cloud-migration-resource-group.name
    location = azurerm_resource_group.cloud-migration-resource-group.location
    sku = "Basic"
}

resource "azurerm_eventhub" "migration-eventhub" {
    name = "migration-eventhub"
    resource_group_name = azurerm_resource_group.cloud-migration-resource-group.name
    namespace_name = azurerm_eventhub_namespace.eventhub-namespace.name
    partition_count = 2
    message_retention = 1
}

resource "azurerm_eventhub_authorization_rule" "authorization_rule" {
    name = "authorization_rule"
    resource_group_name = azurerm_resource_group.cloud-migration-resource-group.name
    namespace_name = azurerm_eventhub_namespace.eventhub-namespace.name
    eventhub_name = azurerm_eventhub.migration-eventhub.name
    send = true
}

resource "azurerm_iothub" "migration-ito-hub" {
    name = "migration-ito-hub"
    resource_group_name = azurerm_resource_group.cloud-migration-resource-group.name
    location = azurerm_resource_group.cloud-migration-resource-group.location

    sku {
        name = "S1"
        capacity = "1"
    }
}