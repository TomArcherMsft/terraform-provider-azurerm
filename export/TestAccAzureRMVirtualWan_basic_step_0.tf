
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "test" {
  name     = "acctestRG-220909034740845488"
  location = "West Europe"
}

resource "azurerm_virtual_wan" "test" {
  name                = "acctestvwan220909034740845488"
  resource_group_name = azurerm_resource_group.test.name
  location            = azurerm_resource_group.test.location
}
