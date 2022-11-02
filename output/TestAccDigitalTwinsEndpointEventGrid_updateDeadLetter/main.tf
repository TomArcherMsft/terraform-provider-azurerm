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
  name      = "acctestRG-dtwin-221102104723145956"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "digitalTwinsInstance" {
  type      = "Microsoft.DigitalTwins/digitalTwinsInstances@2020-12-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctest-DT-221102104723145956"
  location  = azapi_resource.resourceGroup.location
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "topic" {
  type      = "Microsoft.EventGrid/topics@2021-12-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctesteg-221102104723145956"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      disableLocalAuth    = false
      inputSchema         = "EventGridSchema"
      inputSchemaMapping  = null
      publicNetworkAccess = "Enabled"
    }
  })
  tags = {}
}
