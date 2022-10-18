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
  name      = "acctestRG-auto-221018163550288699"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "automationAccount" {
  type      = "Microsoft.Automation/automationAccounts@2021-06-22"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctest-221018163550288699"
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

resource "azapi_resource" "configuration" {
  type      = "Microsoft.Automation/automationAccounts/configurations@2019-06-01"
  parent_id = azapi_resource.automationAccount.id
  name      = "acctest"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      description = ""
      logVerbose  = false
      source = {
        type  = "embeddedContent"
        value = "configuration acctest {}"
      }
    }
  })
  tags = {}
}
