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
  name      = "testaccRG-batchjob-221102104207830722"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "batchAccount" {
  type      = "Microsoft.Batch/batchAccounts@2022-01-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "testaccbatch1lbbl"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      encryption = {
        keySource = "Microsoft.Batch"
      }
      poolAllocationMode  = "BatchService"
      publicNetworkAccess = "Enabled"
    }
  })
  tags = {}
}

resource "azapi_resource" "pool" {
  type      = "Microsoft.Batch/batchAccounts/pools@2022-01-01"
  parent_id = azapi_resource.batchAccount.id
  name      = "testaccpool-221102104207830722"

  body = jsonencode({
    properties = {
      certificates = null
      deploymentConfiguration = {
        virtualMachineConfiguration = {
          imageReference = {
            offer     = "UbuntuServer"
            publisher = "Canonical"
            sku       = "18.04-lts"
            version   = "latest"
          }
          nodeAgentSkuId = "batch.node.ubuntu 18.04"
          osDisk = {
            ephemeralOSDiskSettings = {}
          }
        }
      }
      displayName            = ""
      interNodeCommunication = "Enabled"
      metadata = [
      ]
      scaleSettings = {
        fixedScale = {
          resizeTimeout          = "PT15M"
          targetDedicatedNodes   = 1
          targetLowPriorityNodes = 0
        }
      }
      taskSlotsPerNode = 1
      vmSize           = "Standard_A1"
    }
  })

}
