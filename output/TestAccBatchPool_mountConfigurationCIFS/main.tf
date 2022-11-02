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
  name      = "testaccRG-batch-221102104457588693"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "virtualNetwork" {
  type      = "Microsoft.Network/virtualNetworks@2021-08-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "testvn-batch-vtn1p"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      addressSpace = {
        addressPrefixes = [
          "10.0.0.0/16",
        ]
      }
      dhcpOptions = {
        dnsServers = [
          "10.0.0.4",
          "10.0.0.5",
        ]
      }
      subnets = [
      ]
    }
  })
  tags = {}
}

resource "azapi_resource" "pool" {
  type      = "Microsoft.Batch/batchAccounts/pools@2022-01-01"
  parent_id = azapi_resource.batchAccount.id
  name      = "testaccpoolvtn1p"

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
      mountConfiguration = [
        {
          cifsMountConfiguration = {
            mountOptions      = "sampleops"
            password          = "myPassword"
            relativeMountPath = "/mnt/"
            source            = "https://testaccount.file.core.windows.net/"
            username          = "myUserName"
          }
        },
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

resource "azapi_resource" "subnet" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2021-08-01"
  parent_id = azapi_resource.virtualNetwork.id
  name      = "testsn-vtn1p"

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

resource "azapi_resource" "subnet2" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2021-08-01"
  parent_id = azapi_resource.virtualNetwork.id
  name      = "testsn-vtn1p"

  body = jsonencode({
    id = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/testaccRG-batch-221102104457588693/providers/Microsoft.Network/virtualNetworks/testvn-batch-vtn1p/subnets/testsn-vtn1p"
    properties = {
      addressPrefix = "10.0.2.0/24"
      delegations = [
      ]
      networkSecurityGroup = {
        id = azapi_resource.networkSecurityGroup.id
      }
      privateEndpointNetworkPolicies    = "Enabled"
      privateLinkServiceNetworkPolicies = "Enabled"
      serviceEndpointPolicies = [
      ]
      serviceEndpoints = [
      ]
    }
  })

}

resource "azapi_resource" "subnet3" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2021-08-01"
  parent_id = azapi_resource.virtualNetwork.id
  name      = "testsn-vtn1p"

  body = jsonencode({
    id = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/testaccRG-batch-221102104457588693/providers/Microsoft.Network/virtualNetworks/testvn-batch-vtn1p/subnets/testsn-vtn1p"
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
