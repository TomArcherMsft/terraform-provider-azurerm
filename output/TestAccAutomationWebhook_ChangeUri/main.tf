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
  name      = "acctestRG-auto-221018170707719692"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "automationAccount" {
  type      = "Microsoft.Automation/automationAccounts@2021-06-22"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctest-221018170707719692"
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

resource "azapi_resource" "runbook" {
  type      = "Microsoft.Automation/automationAccounts/runbooks@2018-06-30"
  parent_id = azapi_resource.automationAccount.id
  name      = "Get-AzureVMTutorial"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      description = "This is a test runbook for terraform acceptance test"
      draft       = {}
      logProgress = true
      logVerbose  = true
      runbookType = "PowerShell"
    }
  })
  tags = {}
}

resource "azapi_resource" "draft" {
  type      = "Microsoft.Automation/automationAccounts/runbooks/draft@2018-06-30"
  parent_id = azapi_resource.runbook.id
  name      = "content"

  body = jsonencode(null)

}

resource "azapi_resource" "webhook" {
  type      = "Microsoft.Automation/automationAccounts/webhooks@2015-10-31"
  parent_id = azapi_resource.automationAccount.id
  name      = "TestRunbook_webhook"

  body = jsonencode({
    properties = {
      expiryTime = "2022-10-18T10:07:07Z"
      isEnabled  = true
      parameters = {}
      runOn      = ""
      runbook = {
        name = azapi_resource.runbook.name
      }
    }
  })

}
