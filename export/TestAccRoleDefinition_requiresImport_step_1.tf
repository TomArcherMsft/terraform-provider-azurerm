

provider "azurerm" {
  features {}
}

data "azurerm_subscription" "primary" {
}

resource "azurerm_role_definition" "test" {
  role_definition_id = "a60bae26-6572-48dd-b6ba-81d268a94c0a"
  name               = "acctestrd-220909033849428146"
  scope              = data.azurerm_subscription.primary.id

  permissions {
    actions     = ["*"]
    not_actions = []
  }

  assignable_scopes = [
    data.azurerm_subscription.primary.id,
  ]
}


resource "azurerm_role_definition" "import" {
  role_definition_id = azurerm_role_definition.test.role_definition_id
  name               = azurerm_role_definition.test.name
  scope              = azurerm_role_definition.test.scope

  permissions {
    actions     = ["*"]
    not_actions = []
  }

  assignable_scopes = [
    data.azurerm_subscription.primary.id,
  ]
}
