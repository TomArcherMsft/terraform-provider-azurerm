
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "test" {
  name     = "acctestRG-acr-220826005716442076"
  location = "West Europe"
}

resource "azurerm_container_registry" "test" {
  name                       = "testacccr220826005716442076"
  resource_group_name        = azurerm_resource_group.test.name
  location                   = azurerm_resource_group.test.location
  sku                        = "Premium"
  network_rule_bypass_option = "None"
}
