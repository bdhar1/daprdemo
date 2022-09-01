
resource "azurerm_postgresql_flexible_server" "pgsql" {
  name                   = var.pgsql_name
  resource_group_name    = azurerm_resource_group.rg.name
  location               = azurerm_resource_group.rg.location
  version                = "14"
  administrator_login    = "pgadmin"
  administrator_password = "Kolkata@1"
  storage_mb             = 32768
  sku_name               = "B_Standard_B1ms"
  
  lifecycle {
    ignore_changes = [ zone ]
  }
}

resource "azurerm_postgresql_flexible_server_database" "pgsql_db" {
  name      = "daprdemo"
  server_id = azurerm_postgresql_flexible_server.pgsql.id
  collation = "en_US.utf8"
  charset   = "utf8"
}

resource "azurerm_cosmosdb_account" "cmdb_account" {
  name                = var.cmdb_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  offer_type          = "Standard"
  kind                = "MongoDB"

  capabilities {
    name = "EnableAggregationPipeline"
  }

  capabilities {
    name = "mongoEnableDocLevelTTL"
  }

  capabilities {
    name = "MongoDBv3.4"
  }

  capabilities {
    name = "EnableMongo"
  }

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000
  }

  geo_location {
    location          = azurerm_resource_group.rg.location
    failover_priority = 0
  }
}

resource "azurerm_cosmosdb_mongo_database" "cmdb" {
  name                = "daprdemo"
  resource_group_name = azurerm_cosmosdb_account.cmdb_account.resource_group_name
  account_name        = azurerm_cosmosdb_account.cmdb_account.name
  throughput          = 400
}