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
  name      = "acctestRG-221102105125733862"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "virtualNetwork" {
  type      = "Microsoft.Network/virtualNetworks@2021-08-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctvn-221102105125733862"
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
  name      = "acctsub-221102105125733862"

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
  name      = "acctni-221102105125733862"
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
  name      = "acctvm-221102105125733862"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      hardwareProfile = {
        vmSize = "Standard_D1_v2"
      }
      networkProfile = {
        networkInterfaces = [
          {
            id = azapi_resource.networkInterface.id
            properties = {
              primary = false
            }
          },
        ]
      }
      osProfile = {
        adminPassword = "Password1234!"
        adminUsername = "testadmin"
        computerName  = "hn221102105125733862"
        linuxConfiguration = {
          disablePasswordAuthentication = false
        }
      }
      storageProfile = {
        dataDisks = [
          {
            caching                 = "ReadWrite"
            createOption            = "Empty"
            diskSizeGB              = 1
            lun                     = 0
            name                    = "mydatadisk1"
            writeAcceleratorEnabled = false
          },
        ]
        imageReference = {
          offer     = "UbuntuServer"
          publisher = "Canonical"
          sku       = "16.04-LTS"
          version   = "latest"
        }
        osDisk = {
          caching                 = "ReadWrite"
          createOption            = "FromImage"
          name                    = "myosdisk1"
          writeAcceleratorEnabled = false
        }
      }
    }
  })
  tags = {
    cost-center = "Ops"
    environment = "Production"
  }
}
