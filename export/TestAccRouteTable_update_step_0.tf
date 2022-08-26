
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "test" {
  name     = "acctestRG-220826010412279971"
  location = "West Europe"
}

resource "azurerm_route_table" "test" {
  name                = "acctestrt220826010412279971"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
}
