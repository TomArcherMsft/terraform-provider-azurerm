terraform {
  required_providers {
    azapi = {
      source = "Azure/azapi"
    }
  }
}

provider "azapi" {
  skip_provider_registration = false
}

resource "azapi_resource" "resourceGroup" {
  type      = "Microsoft.Resources/resourceGroups@2020-06-01"
  parent_id = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76"
  name      = "acctestRG-datashare-221102104613789308"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "account" {
  type      = "Microsoft.DataShare/accounts@2019-11-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctest-DSA-221102104613789308"
  location  = azapi_resource.resourceGroup.location
  identity {
    type         = "SystemAssigned"
    identity_ids = []
  }
  body = jsonencode({})
  tags = {}
}
