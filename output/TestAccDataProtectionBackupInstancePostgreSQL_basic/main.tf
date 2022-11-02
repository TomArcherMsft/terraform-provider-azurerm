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
  name      = "acctest-dataprotection-221102104611385070"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "server" {
  type      = "Microsoft.DBforPostgreSQL/servers@2017-12-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctest-postgresql-server-221102104611385070"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      administratorLogin         = "psqladmin"
      administratorLoginPassword = "H@Sh1CoR3!"
      createMode                 = "Default"
      infrastructureEncryption   = "Disabled"
      minimalTlsVersion          = "TLS1_2"
      publicNetworkAccess        = "Enabled"
      sslEnforcement             = "Enabled"
      storageProfile = {
        backupRetentionDays = 7
        storageAutogrow     = "Enabled"
        storageMB           = 5120
      }
      version = "9.5"
    }
    sku = {
      capacity = 2
      family   = "Gen5"
      name     = "B_Gen5_2"
      tier     = "Basic"
    }
  })
  tags = {}
}

resource "azapi_resource" "backupPolicy" {
  type      = "Microsoft.DataProtection/backupVaults/backupPolicies@2022-04-01"
  parent_id = azapi_resource.backupVault.id
  name      = "acctest-dp-second-221102104611385070"

  body = jsonencode({
    properties = {
      datasourceTypes = [
        "Microsoft.DBforPostgreSQL/servers/databases",
      ]
      objectType = "BackupPolicy"
      policyRules = [
        {
          backupParameters = {
            backupType = "Full"
            objectType = "AzureBackupParams"
          }
          dataStore = {
            dataStoreType = "VaultStore"
            objectType    = "DataStoreInfoBase"
          }
          name       = "BackupIntervals"
          objectType = "AzureBackupRule"
          trigger = {
            objectType = "ScheduleBasedTriggerContext"
            schedule = {
              repeatingTimeIntervals = [
                "R/2021-05-23T02:30:00+00:00/P1W",
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
                duration   = "P3M"
                objectType = "AbsoluteDeleteOption"
              }
              sourceDataStore = {
                dataStoreType = "VaultStore"
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
