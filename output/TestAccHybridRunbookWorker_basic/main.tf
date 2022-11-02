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
  name      = "acctestRG-auto-221102104359484539"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "virtualNetwork" {
  type      = "Microsoft.Network/virtualNetworks@2021-08-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestnw-221102104359484539"
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

resource "azapi_resource" "credential" {
  type      = "Microsoft.Automation/automationAccounts/credentials@2020-01-13-preview"
  parent_id = azapi_resource.automationAccount.id
  name      = "acctest-221102104359484539"

  body = jsonencode({
    properties = {
      description = ""
      password    = "test_pwd"
      userName    = "test_user"
    }
  })

}

resource "azapi_resource" "hybridRunbookWorkerGroup" {
  type      = "Microsoft.Automation/automationAccounts/hybridRunbookWorkerGroups@2021-06-22"
  parent_id = azapi_resource.automationAccount.id
  name      = "acctest-221102104359484539"

  body = jsonencode({
    credential = {
      name = "acctest-221102104359484539"
    }
  })

}

resource "azapi_resource" "networkInterface" {
  type      = "Microsoft.Network/networkInterfaces@2021-08-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctni-221102104359484539"
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
  name      = "acctestVM-221102104359484539"
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
        vmSize = "Standard_D2s_v3"
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
        adminPassword            = "P@$$w0rd1234!"
        adminUsername            = "adminuser"
        allowExtensionOperations = true
        computerName             = "acctestVM-221102104359484539"
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
          sku       = "16.04-LTS"
          version   = "latest"
        }
        osDisk = {
          caching      = "ReadWrite"
          createOption = "FromImage"
          managedDisk = {
            storageAccountType = "Standard_LRS"
          }
          osType                  = "Linux"
          writeAcceleratorEnabled = false
        }
      }
    }
  })
  tags = {
    azsecpack                                                                = "nonprod"
    platformsettings.host_environment.service.platform_optedin_for_rootcerts = "true"
  }
}

resource "azapi_resource" "hybridRunbookWorker" {
  type      = "Microsoft.Automation/automationAccounts/hybridRunbookWorkerGroups/hybridRunbookWorkers@2021-06-22"
  parent_id = azapi_resource.hybridRunbookWorkerGroup.id
  name      = "0209b1bb-d206-487f-893d-d3f87ca99087"

  body = jsonencode({
    properties = {
      vmResourceId = azapi_resource.virtualMachine.id
    }
  })

}
