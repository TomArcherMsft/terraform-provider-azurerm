
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "test" {
  name     = "acctestRG-df-220923011743856089"
  location = "West Europe"
}

resource "azurerm_data_factory" "test" {
  name                = "acctestDF220923011743856089"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name

  tags = {
    environment = "production"
    updated     = "true"
  }
}
