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
  name      = "acctestRG-cdn-afdx-221102104306398186"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "profile" {
  type      = "Microsoft.Cdn/profiles@2021-06-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctest-profile-221102104306398186"
  location  = "global"
  body = jsonencode({
    properties = {
      originResponseTimeoutSeconds = 120
    }
    sku = {
      name = "Standard_AzureFrontDoor"
    }
  })
  tags = {}
}

resource "azapi_resource" "afdEndpoint" {
  type      = "Microsoft.Cdn/profiles/afdEndpoints@2021-06-01"
  parent_id = azapi_resource.profile.id
  name      = "acctest-endpoint-221102104306398186"
  location  = "global"
  body = jsonencode({
    properties = {
      enabledState = "Enabled"
    }
  })
  tags = {}
}
