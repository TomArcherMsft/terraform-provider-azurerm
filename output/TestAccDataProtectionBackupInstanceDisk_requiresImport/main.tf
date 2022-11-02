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
  name      = "acctest-dataprotection-221102104602498529"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "backupVault" {
  type      = "Microsoft.DataProtection/backupVaults@2022-04-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctest-dataprotection-vault-221102104602498529"
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
  name      = "acctest-dbp-221102104602498529"

  body = jsonencode({
    properties = {
      datasourceTypes = [
        "Microsoft.Compute/disks",
      ]
      objectType = "BackupPolicy"
      policyRules = [
        {
          backupParameters = {
            backupType = "Incremental"
            objectType = "AzureBackupParams"
          }
          dataStore = {
            dataStoreType = "OperationalStore"
            objectType    = "DataStoreInfoBase"
          }
          name       = "BackupIntervals"
          objectType = "AzureBackupRule"
          trigger = {
            objectType = "ScheduleBasedTriggerContext"
            schedule = {
              repeatingTimeIntervals = [
                "R/2021-05-20T04:54:23+00:00/PT4H",
              ]
            }
            taggingCriteria = [
              {
                isDefault = true
                tagInfo = {
                  id      = "Default_"
                  tagName = "Default"
                }
                taggingPriority = 99
              },
            ]
          }
        },
        {
          isDefault = true
          lifecycles = [
            {
              deleteAfter = {
                duration   = "P7D"
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
})

}
