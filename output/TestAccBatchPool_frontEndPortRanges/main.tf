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
  name      = "testaccRG-221102104446424636-batchpool"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "batchAccount" {
  type      = "Microsoft.Batch/batchAccounts@2022-01-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "testaccbatchaj1lb"
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
essVersion               = "IPv4"
publicIPAllocationMethod = "Static"
}
sku = {
  name = "Standard"
  tier = "Regional"
}
})
tags = {}
}

resource "azapi_resource" "subnet" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2021-08-01"
  parent_id = azapi_resource.virtualNetwork.id
  name      = "internal"

  body = jsonencode({
    properties = {
      addressPrefix = "10.0.2.0/24"
      delegations = [
      ]
      privateEndpointNetworkPolicies    = "Enabled"
      privateLinkServiceNetworkPolicies = "Enabled"
      serviceEndpointPolicies = [
      ]
      serviceEndpoints = [
      ]
    }
  })

}

resource "azapi_resource" "pool" {
  type      = "Microsoft.Batch/batchAccounts/pools@2022-01-01"
  parent_id = azapi_resource.batchAccount.id
  name      = "testaccpoolaj1lb"

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
      networkConfiguration = {
        dynamicVNetAssignmentScope = "none"
        endpointConfiguration = {
          inboundNatPools = [
            {
              backendPort            = 22
              frontendPortRangeEnd   = 4100
              frontendPortRangeStart = 4000
              name                   = "SSH"
              networkSecurityGroupRules = [
                {
                  access              = "Deny"
                  priority            = 1001
                  sourceAddressPrefix = "*"
                },
              ]
              protocol = "TCP"
            },
          ]
        }
        publicIPAddressConfiguration = {
          ipAddressIds = [
            azapi_resource.publicIPAddress.id,
          ]
          provision = "UserManaged"
        }
        subnetId = azapi_resource.subnet.id
      }
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
