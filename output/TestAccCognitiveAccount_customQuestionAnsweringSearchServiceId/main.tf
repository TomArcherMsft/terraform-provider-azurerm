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
  name      = "acctestRG-cognitive-221102104238190305"
  location  = "westus"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "searchService" {
  type      = "Microsoft.Search/searchServices@2020-03-13"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestsearchacc-221102104238190305"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      networkRuleSet = {
        ipRules = [
        ]
      }
      publicNetworkAccess = "enabled"
    }
    sku = {
      name = "standard"
    }
  })
  tags = {}
}

resource "azapi_resource" "account" {
  type      = "Microsoft.CognitiveServices/accounts@2021-04-30"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestcogacc-221102104238190305"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    kind = "TextAnalytics"
    properties = {
      allowedFqdnList = [
      ]
      apiProperties = {
        qnaAzureSearchEndpointId = azapi_resource.searchService.id
      }
      customSubDomainName           = ""
      disableLocalAuth              = false
      publicNetworkAccess           = "Enabled"
      restrictOutboundNetworkAccess = false
    }
    sku = {
      name = "F0"
      tier = "Free"
    }
  })
  tags = {}
}
