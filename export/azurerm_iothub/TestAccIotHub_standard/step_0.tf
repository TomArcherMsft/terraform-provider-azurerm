
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "test" {
  name     = "acctestRG-221028165054858815"
  location = "West Europe"
}

resource "azurerm_iothub" "test" {
  name                = "acctestIoTHub-221028165054858815"
  resource_group_name = azurerm_resource_group.test.name
  location            = azurerm_resource_group.test.location

  sku {
    name     = "S1"
    capacity = "1"
  }

  tags = {
    purpose = "testing"
  }
}
