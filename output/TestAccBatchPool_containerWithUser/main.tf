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
  name      = "testaccbatch221102104253358183"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "batchAccount" {
  type      = "Microsoft.Batch/batchAccounts@2022-01-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "testaccbatchghpno"
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
  name      = "testaccpoolghpno"

  body = jsonencode({
    properties = {
      certificates = null
      deploymentConfiguration = {
        virtualMachineConfiguration = {
          containerConfiguration = {
            containerImageNames = [
              "centos7",
            ]
            containerRegistries = [
              {
                password       = "myPassword"
                registryServer = "myContainerRegistry.azurecr.io"
                username       = "myUserName"
              },
            ]
            type = "DockerCompatible"
          }
          imageReference = {
            offer     = "ubuntu-server-container"
            publisher = "microsoft-azure-batch"
            sku       = "20-04-lts"
            version   = "latest"
          }
          nodeAgentSkuId = "batch.node.ubuntu 20.04"
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
