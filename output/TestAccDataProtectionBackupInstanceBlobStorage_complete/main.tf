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
  name      = "acctest-dataprotection-221102104553834573"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "backupVault" {
  type      = "Microsoft.DataProtection/backupVaults@2022-04-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctest-dataprotection-vault-221102104553834573"
  location  = azapi_resource.resourceGroup.location
  identity {
    type         = "SystemAssigned"
    identity_ids = []
  }
  body = jsonencode({
    properties = {
      storageSettings = [
        {
          datastoreType = "VaultStore"
          type          = "LocallyRedundant"
        },
      ]
    }
  })
  tags = {}
}

resource "azapi_resource" "backupPolicy2" {
  type      = "Microsoft.DataProtection/backupVaults/backupPolicies@2022-04-01"
  parent_id = azapi_resource.backupVault.id
  name      = "acctest-dbp-221102104553834573"

  body = jsonencode({
    properties = {
      datasourceTypes = [
        "Microsoft.Storage/storageAccounts/blobServices",
      ]
      objectType = "BackupPolicy"
      policyRules = [
        {
          isDefault = true
          lifecycles = [
            {
              deleteAfter = {
                duration   = "P30D"
                objectType = "AbsoluteDeleteOption"
              }
              sourceDataStore = {
                dataStoreType = "OperationalStore"
                objectType    = "DataStoreInfoBase"
              }
              targetDataStoreCopySettings = [
              ]
            },
          ]
          name       = "Default"
          objectType = "AzureRetentionRule"
        },
      ]
    }
  })

}
