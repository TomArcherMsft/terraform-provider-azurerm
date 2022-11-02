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
  name      = "acctestRG-appconfig-221102104130736573"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "configurationStore" {
  type      = "Microsoft.AppConfiguration/configurationStores@2022-05-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "testaccappconf221102104130736573"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      disableLocalAuth          = false
      enablePurgeProtection     = false
      softDeleteRetentionInDays = 1
    }
    sku = {
      name = "standard"
    }
  })
  tags = {}
}
