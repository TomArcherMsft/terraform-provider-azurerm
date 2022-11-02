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
  name      = "acctestRG-cognitive-221102104213169843"
  location  = "eastus2"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "account" {
  type      = "Microsoft.CognitiveServices/accounts@2021-04-30"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestcogacc-221102104213169843"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    kind = "SpeechServices"
    properties = {
      allowedFqdnList = [
      ]
      apiProperties                 = {}
      customSubDomainName           = ""
      disableLocalAuth              = false
      publicNetworkAccess           = "Enabled"
      restrictOutboundNetworkAccess = false
    }
    sku = {
      name = "S0"
      tier = "Standard"
    }
  })
  tags = {}
}
