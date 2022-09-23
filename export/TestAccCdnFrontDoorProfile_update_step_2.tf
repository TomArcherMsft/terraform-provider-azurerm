
provider "azurerm" {
  features {}
}


resource "azurerm_resource_group" "test" {
  name     = "acctestRG-cdn-afdx-220923011602011647"
  location = "West Europe"
}


resource "azurerm_cdn_frontdoor_profile" "test" {
  name                = "acctest-c-220923011602011647"
  resource_group_name = azurerm_resource_group.test.name

  response_timeout_seconds = 120
  sku_name                 = "Premium_AzureFrontDoor"

  tags = {
    ENV = "Production"
  }
}
