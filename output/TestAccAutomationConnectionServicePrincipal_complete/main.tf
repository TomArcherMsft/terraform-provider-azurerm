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
  name      = "acctestRG-auto-221018160958665387"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "automationAccount" {
  type      = "Microsoft.Automation/automationAccounts@2021-06-22"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestAA-221018160958665387"
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

resource "azapi_resource" "connection" {
  type      = "Microsoft.Automation/automationAccounts/connections@2020-01-13-preview"
  parent_id = azapi_resource.automationAccount.id
  name      = "acctestACSP-221018160958665387"

  body = jsonencode({
    properties = {
      connectionType = {
        name = "AzureServicePrincipal"
      }
      description = "acceptance test for automation connection"
      fieldDefinitionValues = {
        ApplicationId         = "00000000-0000-0000-0000-000000000000"
        CertificateThumbprint = "AEB97B81A68E8988850972916A8B8B6CD8F39813
"
        SubscriptionId        = "85b3dbca-5974-4067-9669-67a141095a76"
        TenantId              = "72f988bf-86f1-41af-91ab-2d7cd011db47"
      }
    }
  })

}
