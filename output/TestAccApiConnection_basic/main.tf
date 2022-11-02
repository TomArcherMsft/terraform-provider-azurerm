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
  name      = "acctestRG-conn-221102104315100119"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "workflow" {
  type      = "Microsoft.Logic/workflows@2019-05-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestlaw-conn-221102104315100119"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      definition = {
        $ schema       = "https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#"
        actions        = {}
        contentVersion = "1.0.0.0"
        parameters     = null
        triggers       = {}
      }
      parameters = {}
      state      = "Enabled"
    }
  })
  tags = {}
}
