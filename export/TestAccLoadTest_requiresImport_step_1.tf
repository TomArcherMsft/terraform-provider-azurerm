

provider "azurerm" {
  features {}
}



resource "azurerm_resource_group" "test" {
  name     = "acctestRG-220909034528965096"
  location = "West Europe"
}



resource "azurerm_load_test" "test" {
  name                = "acctestALT-220909034528965096"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
}


resource "azurerm_load_test" "import" {
  name                = azurerm_load_test.test.name
  location            = azurerm_load_test.test.location
  resource_group_name = azurerm_load_test.test.resource_group_name
}
