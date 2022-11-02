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
  name      = "acctestRG-auto-221102104354001758"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "automationAccount" {
  type      = "Microsoft.Automation/automationAccounts@2021-06-22"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestAA-221102104354001758"
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

resource "azapi_resource" "credential" {
  type      = "Microsoft.Automation/automationAccounts/credentials@2020-01-13-preview"
  parent_id = azapi_resource.automationAccount.id
  name      = "acctest-221102104354001758"

  body = jsonencode({
    properties = {
      description = ""
      password    = "test_pwd"
      userName    = "test_user"
    }
  })

}

resource "azapi_resource" "hybridRunbookWorkerGroup" {
  type      = "Microsoft.Automation/automationAccounts/hybridRunbookWorkerGroups@2021-06-22"
  parent_id = azapi_resource.automationAccount.id
  name      = "acctest-221102104354001758"

  body = jsonencode({
    credential = {
      name = "acctest-221102104354001758"
    }
  })

}
