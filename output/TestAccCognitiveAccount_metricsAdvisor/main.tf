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
  name      = "acctestRG-cognitive-221102104257475421"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "account" {
  type      = "Microsoft.CognitiveServices/accounts@2021-04-30"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestcogacc-221102104257475421"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    kind = "MetricsAdvisor"
    properties = {
      allowedFqdnList = [
      ]
      apiProperties = {
        aadClientId = "310d7b2e-d1d1-4b87-9807-5b885b290c00"
        aadTenantId = "72f988bf-86f1-41af-91ab-2d7cd011db47"
        superUser   = "mock_user1"
        websiteName = "mock_name2"
      }
      customSubDomainName           = "acctestcogacc-221102104257475421"
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
