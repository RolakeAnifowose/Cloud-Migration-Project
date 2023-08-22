resource "azurerm_monitor_action_group" "migration-monitor" {
  name = "migration-monitor"
  short_name = "monitor"
  resource_group_name = azurerm_resource_group.cloud-migration-resource-group.name
  email_receiver {
    name = "email"
    email_address = "26027603@students.lincoln.ac.uk"
  }
}

resource "azurerm_monitor_metric_alert" "vm_scale_set_alert" {
  name = "vm-scale-set-alert"
  resource_group_name = azurerm_resource_group.cloud-migration-resource-group.name
  scopes = [azurerm_virtual_machine_scale_set.example.id]
  
  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachineScaleSets"
    metric_name = "Percentage CPU"
    operator = "GreaterThan"
    threshold = 75
    aggregation = "Average"
  }

  action {
    action_group_id = azurerm_monitor_action_group.example.id
  }
}

resource "azurerm_monitor_metric_alert" "cosmosdb_alert" {
  name = "cosmosdb-alert"
  resource_group_name = azurerm_resource_group.cloud-migration-resource-group.name
  scopes = [azurerm_cosmosdb_account.example.id]
  
  criteria {
    metric_namespace = "Microsoft.DocumentDB/databaseAccounts"
    metric_name = "TotalRequests"
    operator = "GreaterThan"
    threshold = 10000
    aggregation = "Total"
  }

  action {
    action_group_id = azurerm_monitor_action_group.example.id
  }
}

resource "azurerm_monitor_metric_alert" "mysql_server_alert" {
  name = "mysql-server-alert"
  resource_group_name = azurerm_resource_group.cloud-migration-resource-group.name
  scopes = [azurerm_mysql_server.example.id]
  
  criteria {
    metric_namespace = "Microsoft.DBforMySQL/servers"
    metric_name = "ActiveConnections"
    operator = "GreaterThan"
    threshold = 20
    aggregation = "Average"
  }

  action {
    action_group_id = azurerm_monitor_action_group.example.id
  }
}
