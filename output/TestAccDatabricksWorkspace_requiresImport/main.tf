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
  name      = "acctestRG-databricks-221102104550619291"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "workspace" {
  type      = "Microsoft.Databricks/workspaces@2022-04-01-preview"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestDBW-221102104550619291"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      managedResourceGroupId = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/databricks-rg-acctestRG-databricks-221102104550619291"
      parameters = {
        prepareEncryption = {
          value = false
        }
        requireInfrastructureEncryption = {
          value = false
        }
      }
      publicNetworkAccess = "Enabled"
    }
    sku = {
      name = "standard"
    }
  })
  tags = {}
}
