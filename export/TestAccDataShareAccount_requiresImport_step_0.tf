

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "test" {
  name     = "acctestRG-datashare-220923011753389554"
  location = "West Europe"
}


resource "azurerm_data_share_account" "test" {
  name                = "acctest-DSA-220923011753389554"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  identity {
    type = "SystemAssigned"
  }
}
