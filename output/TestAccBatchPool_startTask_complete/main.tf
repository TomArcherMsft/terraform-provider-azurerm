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
  name      = "testaccRG-batch-221102104240428162"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "networkSecurityGroup" {
  type      = "Microsoft.Network/networkSecurityGroups@2021-08-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "testnsg-batch-1a207"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      securityRules = [
      ]
    }
  })
  tags = {}
}

resource "azapi_resource" "virtualNetwork" {
  type      = "Microsoft.Network/virtualNetworks@2021-08-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "testvn-batch-1a207"
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
  name      = "testaccpool1a207"

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
      startTask = {
        commandLine = "echo 'Hello World from $env'"
        containerSettings = {
          containerRunOptions = "cat /proc/cpuinfo"
          imageName           = "centos7"
          registry = {
            password       = "myPassword"
            registryServer = "myContainerRegistry.azurecr.io"
            username       = "myUserName"
          }
          workingDirectory = "ContainerImageDefault"
        }
        environmentSettings = [
          {
            name  = "bu"
            value = "Research&Dev"
          },
          {
            name  = "env"
            value = "TEST"
          },
        ]
        maxTaskRetryCount = 5
        resourceFiles = [
          {
            filePath            = "README.md"
            storageContainerUrl = "https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/main/README.md"
          },
        ]
        userIdentity = {
          autoUser = {
            elevationLevel = "NonAdmin"
            scope          = "Task"
          }
        }
        waitForSuccess = true
      }
      taskSlotsPerNode = 1
      vmSize           = "Standard_A1"
    }
  })

}

resource "azapi_resource" "subnet2" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2021-08-01"
  parent_id = azapi_resource.virtualNetwork.id
  name      = "testsn-1a207"

  body = jsonencode({
    id = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/testaccRG-batch-221102104240428162/providers/Microsoft.Network/virtualNetworks/testvn-batch-1a207/subnets/testsn-1a207"
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
  name      = "testsn-1a207"

  body = jsonencode({
    id = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/testaccRG-batch-221102104240428162/providers/Microsoft.Network/virtualNetworks/testvn-batch-1a207/subnets/testsn-1a207"
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
