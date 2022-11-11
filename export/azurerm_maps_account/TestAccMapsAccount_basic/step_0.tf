
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "test" {
  name     = "acctestRG-221111013852589971"
  location = "West Europe"
}

resource "azurerm_maps_account" "test" {
  name                = "accMapsAccount-221111013852589971"
  resource_group_name = azurerm_resource_group.test.name
  sku_name            = "S0"
}
