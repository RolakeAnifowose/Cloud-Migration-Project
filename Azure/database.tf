resource "azurerm_cosmosdb_account" "cloud-migration-cosmos-account" {
    name = "cloud-migration-cosmos-account"
    location = azurerm_resource_group.cloud-migration-resource-group.location
    resource_group_name = azurerm_resource_group.cloud-migration-resource-group.name
    offer_type = "Standard"
    kind = "MongoDB"
    enable_automatic_failover = true

    capabilities {
        name = "MongoDBv3.4"
    }

    capabilities {
        name = "EnableMongo"
    }

    capabilities {
        name = "EnableAggregationPipeline"
    }

    geo_location {
        location = "UK South"
        failover_priority = 1
    }

    geo_location {
        location = "East US"
        failover_priority = 0
    }

    consistency_policy {
        consistency_level = "BoundedStaleness"
        max_interval_in_seconds = 300
        max_staleness_prefix = 100000
    }
}

resource "azurerm_cosmosdb_mongo_database" "mongodb-database" {
    name = "mongodb-database"
    #resource_group_name = azurerm_cosmosdb_account.cloud-migration-cosmos-account.resource_group_name
    resource_group_name = azurerm_resource_group.cloud-migration-resource-group.name
    account_name = azurerm_cosmosdb_account.cloud-migration-cosmos-account.name
    throughput = 400
}

resource "azurerm_mysql_server" "cloud-migration-mysql-server" {
  name = "cloud-migration-mysql-server"
  location = azurerm_resource_group.cloud-migration-resource-group.location
  resource_group_name = azurerm_resource_group.cloud-migration-resource-group.name

  administrator_login = "cloudmigration"
  administrator_login_password = "@NxyTPP123!!"

  sku_name = "GP_Gen5_2"
  storage_mb = 5120
  version = "5.7"

  auto_grow_enabled = true
  backup_retention_days = 7
  geo_redundant_backup_enabled = true
  infrastructure_encryption_enabled = true
  public_network_access_enabled = false
  ssl_enforcement_enabled = true
  ssl_minimal_tls_version_enforced = "TLS1_2"
}

resource "azurerm_mysql_database" "cloud-migration-mysql-database" {
  name = "cloud-migration-mysql-database"
  resource_group_name = azurerm_resource_group.cloud-migration-resource-group.name
  server_name = azurerm_mysql_server.cloud-migration-mysql-server.name
  charset = "utf8"
  collation = "utf8_unicode_ci"
}