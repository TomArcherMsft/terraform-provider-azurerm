
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "test" {
  name     = "acctestRG-220905045823261598"
  location = "West Europe"
}

resource "azurerm_dns_zone" "test" {
  name                = "acctestzone220905045823261598.com"
  resource_group_name = azurerm_resource_group.test.name

  tags = {
    environment = "Production"
    cost_center = "MSFT"
  }
}
