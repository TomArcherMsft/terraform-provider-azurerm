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
  name      = "acctestRG-auto-221018161202227641"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "automationAccount" {
  type      = "Microsoft.Automation/automationAccounts@2021-06-22"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestAutoAcct-221018161202227641"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      publicNetworkAccess = true
      sku = {
        name = "Basic"
      }
    }
  })
  tags = {}
}

resource "azapi_resource" "variable" {
  type      = "Microsoft.Automation/automationAccounts/variables@2020-01-13-preview"
  parent_id = azapi_resource.automationAccount.id
  name      = "acctestAutoVar-221018161202227641"

  body = jsonencode({
    properties = {
      description = ""
      isEncrypted = false
      value       = "" \ / Date(1556142054074) \ / ""
    }
  })

}
