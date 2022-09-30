
resource "azurerm_postgresql_flexible_server" "pgsql" {
  name                   = var.pgsql_name
  resource_group_name    = data.azurerm_resource_group.rg.name
  location               = data.azurerm_resource_group.rg.location
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
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  capabilities {
    name = "EnableAggregationPipeline"
  }

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000
  }

  geo_location {
    location          = data.azurerm_resource_group.rg.location
    failover_priority = 0
  }
}

resource "azurerm_cosmosdb_sql_database" "cmdb" {
  name                = "daprdemo"
  resource_group_name = azurerm_cosmosdb_account.cmdb_account.resource_group_name
  account_name        = azurerm_cosmosdb_account.cmdb_account.name
  throughput          = 400
}

resource "azurerm_cosmosdb_sql_container" "example" {
  name                  = "daprdemo"
  resource_group_name   = azurerm_cosmosdb_account.cmdb_account.resource_group_name
  account_name          = azurerm_cosmosdb_account.cmdb_account.name
  database_name         = azurerm_cosmosdb_sql_database.cmdb.name
  partition_key_path    = "/id"
  throughput            = 400
}
