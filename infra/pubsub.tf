/*
resource "azurerm_eventgrid_topic" "evgt" {
  name                = var.evgt_name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
}*/

resource "azurerm_servicebus_namespace" "sbns" {
  name                = var.sbns_name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  sku                 = "Standard"
}

resource "azurerm_servicebus_queue" "sbq" {
  name         = "daprdemo"
  namespace_id = azurerm_servicebus_namespace.sbns.id
}


resource "azurerm_servicebus_topic" "topic" {
  name         = "daprdemo1"
  namespace_id = azurerm_servicebus_namespace.sbns.id
  enable_partitioning = true
}