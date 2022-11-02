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
  name      = "acctestRG-cognitive-221102104226440827"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "account" {
  type      = "Microsoft.CognitiveServices/accounts@2021-04-30"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestcogacc-221102104226440827"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    kind = "Face"
    properties = {
      allowedFqdnList = [
        "foo.com",
        "bar.com",
      ]
      apiProperties                 = {}
      customSubDomainName           = ""
      disableLocalAuth              = true
      publicNetworkAccess           = "Disabled"
      restrictOutboundNetworkAccess = true
    }
    sku = {
      name = "S0"
      tier = "Standard"
    }
  })
  tags = {
    Acceptance = "Test"
  }
}
