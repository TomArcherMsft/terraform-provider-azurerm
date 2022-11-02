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
  name      = "acctestRG-dtl-221102104706909036"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "virtualNetwork" {
  type      = "Microsoft.Network/virtualNetworks@2021-08-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestVN-221102104706909036"
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
        ]
      }
      subnets = [
      ]
    }
  })
  tags = {}
}

resource "azapi_resource" "subnet" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2021-08-01"
  parent_id = azapi_resource.virtualNetwork.id
  name      = "acctestSN-221102104706909036"

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

resource "azapi_resource" "networkInterface" {
  type      = "Microsoft.Network/networkInterfaces@2021-08-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestNIC-221102104706909036"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      enableAcceleratedNetworking = false
      enableIPForwarding          = false
      ipConfigurations = [
        {
          name = "testconfiguration1"
          properties = {
            primary                   = false
            privateIPAddressVersion   = "IPv4"
            privateIPAllocationMethod = "Dynamic"
            subnet = {
              id = azapi_resource.subnet.id
            }
          }
        },
      ]
    }
  })
  tags = {}
}

resource "azapi_resource" "virtualMachine" {
  type      = "Microsoft.Compute/virtualMachines@2022-08-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestVM-221102104706909036"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      additionalCapabilities = {}
      applicationProfile = {
        galleryApplications = [
        ]
      }
      diagnosticsProfile = {
        bootDiagnostics = {
          enabled    = false
          storageUri = ""
        }
      }
      extensionsTimeBudget = "PT1H30M"
      hardwareProfile = {
        vmSize = "Standard_B2s"
      }
      networkProfile = {
        networkInterfaces = [
          {
            id = azapi_resource.networkInterface.id
            properties = {
              primary = true
            }
          },
        ]
      }
      osProfile = {
        adminPassword            = "Password1234!"
        adminUsername            = "testadmin"
        allowExtensionOperations = true
        computerName             = "acctestVM-221102104706909036"
        linuxConfiguration = {
          disablePasswordAuthentication = false
          patchSettings = {
            assessmentMode = "ImageDefault"
            patchMode      = "ImageDefault"
          }
          provisionVMAgent = true
          ssh = {
            publicKeys = [
            ]
          }
        }
        secrets = [
        ]
      }
      priority = "Regular"
      storageProfile = {
        dataDisks = [
        ]
        imageReference = {
          offer     = "UbuntuServer"
          publisher = "Canonical"
          sku       = "18.04-LTS"
          version   = "latest"
        }
        osDisk = {
          caching      = "ReadWrite"
          createOption = "FromImage"
          managedDisk = {
            storageAccountType = "Standard_LRS"
          }
          name                    = "myosdisk-221102104706909036"
          osType                  = "Linux"
          writeAcceleratorEnabled = false
        }
      }
    }
  })
  tags = {}
}

resource "azapi_resource" "schedule" {
  type      = "Microsoft.DevTestLab/schedules@2018-09-15"
  parent_id = azapi_resource.resourceGroup.id
  name      = "shutdown-computevm-acctestVM-221102104706909036"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      dailyRecurrence = {
        time = "1100"
      }
      notificationSettings = {
        emailRecipient = "alerts@devtest.com"
        status         = "Enabled"
        timeInMinutes  = 15
        webhookUrl     = "https://www.bing.com/2/4"
      }
      status           = "Disabled"
      targetResourceId = azapi_resource.virtualMachine.id
      taskType         = "ComputeVmShutdownTask"
      timeZoneId       = "Central Standard Time"
    }
  })
  tags = {
    Environment = "Production"
  }
}
