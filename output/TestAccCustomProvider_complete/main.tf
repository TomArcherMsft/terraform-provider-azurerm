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
  name      = "acctestRG-cp-221102104424651158"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "resourceProvider" {
  type      = "Microsoft.CustomProviders/resourceProviders@2018-09-01-preview"
  parent_id = azapi_resource.resourceGroup.id
  name      = "accTEst_saa221102104424651158"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      resourceTypes = [
        {
          endpoint    = "https://example.com/"
          name        = "dEf1"
          routingType = "Proxy"
        },
      ]
    }
  })
  tags = {}
}
