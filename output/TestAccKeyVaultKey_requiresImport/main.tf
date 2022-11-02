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
  name      = "acctestRG-221102105210363788"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "vault" {
  type      = "Microsoft.KeyVault/vaults@2021-10-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestkv-pfzdw"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      accessPolicies = [
        {
          objectId = "7b354af3-2209-4d07-985e-8b02f29c82f9"
          permissions = {
            certificates = [
            ]
            keys = [
              "Create",
              "Delete",
              "Get",
              "Purge",
              "Recover",
              "Update",
            ]
            secrets = [
              "Delete",
              "Get",
              "Set",
            ]
            storage = [
            ]
          }
          tenantId = "72f988bf-86f1-41af-91ab-2d7cd011db47"
        },
      ]
      enableRbacAuthorization      = false
      enableSoftDelete             = true
      enabledForDeployment         = false
      enabledForDiskEncryption     = false
      enabledForTemplateDeployment = false
      publicNetworkAccess          = "Enabled"
      sku = {
        family = "A"
        name   = "standard"
      }
      softDeleteRetentionInDays = 7
      tenantId                  = "72f988bf-86f1-41af-91ab-2d7cd011db47"
    }
  })
  tags = {
    environment = "Production"
  }
}
