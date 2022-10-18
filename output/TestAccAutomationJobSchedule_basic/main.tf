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
  name      = "acctestRG-auto-221018164222221406"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "automationAccount" {
  type      = "Microsoft.Automation/automationAccounts@2021-06-22"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestAA-221018164222221406"
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
  name      = "Output-HelloWorld"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      description = "This is a test runbook for terraform acceptance test"
      logProgress = true
      logVerbose  = true
      publishContentLink = {
        uri     = "https://raw.githubusercontent.com/Azure/azure-quickstart-templates/c4935ffb69246a6058eb24f54640f53f69d3ac9f/101-automation-runbook-getvms/Runbooks/Get-AzureVMTutorial.ps1"
        version = ""
      }
      runbookType = "PowerShell"
    }
  })
  tags = {}
}

resource "azapi_resource" "schedule" {
  type      = "Microsoft.Automation/automationAccounts/schedules@2020-01-13-preview"
  parent_id = azapi_resource.automationAccount.id
  name      = "acctestAS-221018164222221406"

  body = jsonencode({
    properties = {
      description = ""
      frequency   = "OneTime"
      startTime   = "2022-10-18T16:49:37.765066+08:00"
      timeZone    = "Etc/UTC"
    }
  })

}

resource "azapi_resource" "draft" {
  type      = "Microsoft.Automation/automationAccounts/runbooks/draft@2018-06-30"
  parent_id = azapi_resource.runbook.id
  name      = "content"

  body = jsonencode(null)

}

resource "azapi_resource" "jobSchedule" {
  type      = "Microsoft.Automation/automationAccounts/jobSchedules@2020-01-13-preview"
  parent_id = azapi_resource.automationAccount.id
  name      = "a5fa0d30-5951-449c-9081-1072982663e8"

  body = jsonencode({
    properties = {
      runbook = {
        name = azapi_resource.runbook.name
      }
      schedule = {
        name = azapi_resource.schedule.name
      }
    }
  })

}
