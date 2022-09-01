
resource "azurerm_eventgrid_topic" "evgt" {
  name                = var.evgt_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

resource "azurerm_servicebus_namespace" "sbns" {
  name                = var.sbns_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
}

resource "azurerm_servicebus_queue" "sbq" {
  name         = "daprdemo"
  namespace_id = azurerm_servicebus_namespace.sbns.id
}
