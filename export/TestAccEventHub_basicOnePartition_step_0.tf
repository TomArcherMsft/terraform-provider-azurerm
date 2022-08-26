
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "test" {
  name     = "acctestRG-eventhub-220826005959210963"
  location = "West Europe"
}

resource "azurerm_eventhub_namespace" "test" {
  name                = "acctesteventhubnamespace-220826005959210963"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  sku                 = "Basic"
}

resource "azurerm_eventhub" "test" {
  name                = "acctesteventhub-220826005959210963"
  namespace_name      = azurerm_eventhub_namespace.test.name
  resource_group_name = azurerm_resource_group.test.name
  partition_count     = 1
  message_retention   = 1
}
