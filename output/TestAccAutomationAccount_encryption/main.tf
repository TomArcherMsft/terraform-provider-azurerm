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
  name      = "acctestRG-auto-221018161352769560"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "userAssignedIdentity" {
  type      = "Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestUAI-221018161352769560"
  location  = azapi_resource.resourceGroup.location
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "vault" {
  type      = "Microsoft.KeyVault/vaults@2021-10-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "vault221018161352769560"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      accessPolicies = [
        {
          objectId = "7b354af3-2209-4d07-985e-8b02f29c82f9"
          permissions = {
            certificates = [
              "ManageContacts",
            ]
            keys = [
              "Create",
              "Get",
              "List",
              "Delete",
              "Purge",
            ]
            secrets = [
              "Set",
            ]
            storage = [
            ]
          }
          tenantId = "72f988bf-86f1-41af-91ab-2d7cd011db47"
        },
        {
          objectId = "1ee6c61a-9e8c-4f84-a3a8-25bec456df7f"
          permissions = {
            certificates = [
            ]
            keys = [
              "Get",
              "Recover",
              "WrapKey",
              "UnwrapKey",
            ]
            secrets = [
            ]
            storage = [
            ]
          }
          tenantId = "72f988bf-86f1-41af-91ab-2d7cd011db47"
        },
      ]
      enablePurgeProtection        = true
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
  tags = {}
}

resource "azapi_resource" "automationAccount" {
  type      = "Microsoft.Automation/automationAccounts@2021-06-22"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctest-221018161352769560"
  location  = azapi_resource.resourceGroup.location
  identity {
    type         = "UserAssigned"
    identity_ids = [azapi_resource.userAssignedIdentity.id]
  }
  body = jsonencode({
    properties = {
      disableLocalAuth = true
      encryption = {
        identity = {
          userAssignedIdentity = azapi_resource.userAssignedIdentity.id
        }
        keySource = "Microsoft.Keyvault"
        keyVaultProperties = {
          keyName     = "acckvkey-221018161352769560"
          keyVersion  = "0002df59cca943dd908c503e15f48bb9"
          keyvaultUri = "https://vault221018161352769560.vault.azure.net/"
        }
      }
      publicNetworkAccess = true
      sku = {
        name = "Basic"
      }
    }
  })
  tags = {}
}
