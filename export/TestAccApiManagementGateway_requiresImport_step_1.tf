

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "test" {
  name     = "acctestRG-220923011456733539"
  location = "West Europe"
}

resource "azurerm_api_management" "test" {
  name                = "acctestAM-220923011456733539"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  publisher_name      = "pub1"
  publisher_email     = "pub1@email.com"

  sku_name = "Developer_1"
}

resource "azurerm_api_management_gateway" "test" {
  name              = "acctestAMGateway-220923011456733539"
  api_management_id = azurerm_api_management.test.id

  location_data {
    name = "test"
  }
}


resource "azurerm_api_management_gateway" "import" {
  name              = azurerm_api_management_gateway.test.name
  api_management_id = azurerm_api_management_gateway.test.api_management_id

  location_data {
    name = "test"
  }
}
