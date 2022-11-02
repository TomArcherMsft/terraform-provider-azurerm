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
  name      = "acctestRG-221102104843168291"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "domain" {
  type      = "Microsoft.EventGrid/domains@2021-12-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctesteg-221102104843168291"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      autoCreateTopicWithFirstSubscription = true
      autoDeleteTopicWithLastSubscription  = true
      disableLocalAuth                     = false
      inboundIpRules = [
        {
          action = "Allow"
          ipMask = "10.0.0.0/16"
        },
        {
          action = "Allow"
          ipMask = "10.1.0.0/16"
        },
      ]
      inputSchema         = "EventGridSchema"
      inputSchemaMapping  = null
      publicNetworkAccess = "Enabled"
    }
  })
  tags = {}
}
