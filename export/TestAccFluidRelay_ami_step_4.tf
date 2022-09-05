





provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "test" {
  name     = "acctestRG-fluidrelay-220905045909663843"
  location = "West Europe"
}


resource "azurerm_user_assigned_identity" "test" {
  name                = "acctestRG-userAssignedIdentity-220905045909663843"
  resource_group_name = azurerm_resource_group.test.name
  location            = azurerm_resource_group.test.location
}


resource "azurerm_fluid_relay_server" "test" {
  name                = "acctestRG-fuildRelayServer-220905045909663843"
  resource_group_name = azurerm_resource_group.test.name
  location            = "West Europe"
  identity {
    type = "SystemAssigned"
  }
  tags = {
    foo = "bar"
  }
}
