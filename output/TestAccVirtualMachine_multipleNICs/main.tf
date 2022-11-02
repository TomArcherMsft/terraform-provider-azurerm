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
  name      = "acctestRG-221102105142128767"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "virtualNetwork" {
  type      = "Microsoft.Network/virtualNetworks@2021-08-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctvn-221102105142128767"
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
  name      = "acctsub-221102105142128767"

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
  name      = "acctni1-221102105142128767"
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

resource "azapi_resource" "networkInterface2" {
  type      = "Microsoft.Network/networkInterfaces@2021-08-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctni2-221102105142128767"
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
  name      = "acctvmyj383"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      hardwareProfile = {
        vmSize = "Standard_F1"
      }
      networkProfile = {
        networkInterfaces = [
          {
            id = azapi_resource.networkInterface.id
            properties = {
              primary = true
            }
          },
          {
            id = azapi_resource.networkInterface2.id
            properties = {
              primary = false
            }
          },
        ]
      }
      osProfile = {
        adminPassword = "Password1234!"
        adminUsername = "testadmin"
        computerName  = "acctvmyj383"
        windowsConfiguration = {
          enableAutomaticUpdates = false
          provisionVMAgent       = false
        }
      }
      storageProfile = {
        imageReference = {
          offer     = "WindowsServer"
          publisher = "MicrosoftWindowsServer"
          sku       = "2012-Datacenter"
          version   = "latest"
        }
        osDisk = {
          caching      = "ReadWrite"
          createOption = "FromImage"
          managedDisk = {
            storageAccountType = "Standard_LRS"
          }
          name                    = "myosdisk1"
          writeAcceleratorEnabled = false
        }
      }
    }
  })
  tags = {}
}
