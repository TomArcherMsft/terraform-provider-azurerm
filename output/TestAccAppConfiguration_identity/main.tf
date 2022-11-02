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
  name      = "acctestRG-appconfig-221102104104687054"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "configurationStore" {
  type      = "Microsoft.AppConfiguration/configurationStores@2022-05-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "testaccappconf221102104104687054"
  location  = azapi_resource.resourceGroup.location
  identity {
    type         = "SystemAssigned"
    identity_ids = []
  }
  body = jsonencode({
    properties = {
      disableLocalAuth      = false
      enablePurgeProtection = false
    }
    sku = {
      name = "standard"
    }
  })
  tags = {
    ENVironment = "DEVelopment"
  }
}
