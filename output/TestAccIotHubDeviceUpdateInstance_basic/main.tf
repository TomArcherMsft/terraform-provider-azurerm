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
  name      = "acctest-rg-221102105118946503"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "account" {
  type      = "Microsoft.DeviceUpdate/accounts@2022-10-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acc-dua-apzdn"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      publicNetworkAccess = "Enabled"
      sku                 = "Standard"
    }
  })
  tags = null
}
