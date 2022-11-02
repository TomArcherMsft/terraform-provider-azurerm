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
  name      = "acctestRG-vdesktop-221102104813703741"
  location  = "eastus2"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "workspace" {
  type      = "Microsoft.DesktopVirtualization/workspaces@2022-02-10-preview"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctWS221102104813703741"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      description  = ""
      friendlyName = ""
    }
  })
  tags = {}
}
