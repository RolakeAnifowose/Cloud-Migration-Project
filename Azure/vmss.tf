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

resource "azurerm_monitor_autoscale_setting" "vmss-autoscaling" {
  name = "vmss-autoscaling"
  resource_group_name = azurerm_resource_group.cloud-migration-resource-group.name
  location = azurerm_resource_group.cloud-migration-resource-group.location
  target_resource_id = azurerm_windows_virtual_machine_scale_set.vmss.id

  profile {
    name = "defaultProfile"

    capacity {
      default = 3
      minimum = 3
      maximum = 5
    }

    rule {
      metric_trigger {
        metric_name = "Percentage CPU"
        metric_resource_id = azurerm_windows_virtual_machine_scale_set.vmss.id
        time_grain = "PT1M"
        statistic = "Average"
        time_window = "PT5M"
        time_aggregation = "Average"
        operator = "GreaterThan"
        threshold = 70
        metric_namespace   = "microsoft.compute/virtualmachinescalesets"
        # dimensions {
        #   name     = "AppName"
        #   operator = "Equals"
        #   values   = ["App1"]
        # }
      }

      scale_action {
        direction = "Increase"
        type = "ChangeCount"
        value = "1" #Scale up by one instance
        cooldown = "PT5M" #Cool down period - 5 minutes
      }
    }

    rule {
      metric_trigger {
        metric_name = "Percentage CPU"
        metric_resource_id = azurerm_windows_virtual_machine_scale_set.vmss.id
        time_grain = "PT1M"
        statistic = "Average"
        time_window = "PT5M"
        time_aggregation = "Average"
        operator = "LessThan"
        threshold = 25
      }

      scale_action {
        direction = "Decrease"
        type = "ChangeCount"
        value = "1"
        cooldown = "PT5M"
      }
    }
  }
}