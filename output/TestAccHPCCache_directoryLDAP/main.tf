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
  name      = "acctestRG-storage-221102105304918805"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "virtualNetwork" {
  type      = "Microsoft.Network/virtualNetworks@2021-08-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctest-VN-221102105304918805"
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
  name      = "acctestsub-221102105304918805"

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
  name      = "acctestnic-221102105304918805"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      enableAcceleratedNetworking = false
      enableIPForwarding          = false
      ipConfigurations = [
        {
          name = "internal"
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
  name      = "acctest-vm-221102105304918805"
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
        vmSize = "Standard_F2"
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
        computerName             = "acctest-vm-221102105304918805"
        customData               = "IyEvYmluL2Jhc2gKCnN1ZG8gLWkKCmhvc3RuYW1lY3RsIHNldC1ob3N0bmFtZSBsZGFwLmV4YW1wbGUuY29tCgojIEluc3RhbGwgKHdpdGhvdXQgc3BlY2lmeWluZyB0aGUgcm9vdCBwdyBhcyB3ZSBhcmUgaW4gbm9uaW50ZXJhY3RpdmUgbW9kZSkKREVCSUFOX0ZST05URU5EPW5vbmludGVyYWN0aXZlIGFwdCBpbnN0YWxsIC15IHNsYXBkIGxkYXAtdXRpbHMKCiMgVXBkYXRlIHRoZSByb290IHB3IHRvICIxMjMiCmNhdCA8PCBFT0YgPiAvdG1wL3Jwdy5sZGlmCmRuOiBvbGNEYXRhYmFzZT17MX1tZGIsY249Y29uZmlnCmNoYW5nZXR5cGU6IG1vZGlmeQpyZXBsYWNlOiBvbGNSb290UFcKb2xjUm9vdFBXOiAkKHNsYXBwYXNzd2QgLXMgMTIzKQpFT0YKCmxkYXBtb2RpZnkgLVEgLVkgRVhURVJOQUwgLUggbGRhcGk6Ly8vIC1mIC90bXAvcnB3LmxkaWYKCiMgU2V0dXAgc2VsZiBzaWduZWQgY2VydGlmaWNhdGUKY3AgL2V0Yy9zc2wvY2VydHMvY2EtY2VydGlmaWNhdGVzLmNydCAvZXRjL2xkYXAvc2FzbDIKY2QgL2V0Yy9sZGFwL3Nhc2wyCm9wZW5zc2wgcmVxIC1uZXcgLW5ld2tleSByc2E6NDA5NiAtZGF5cyAzNjUgLW5vZGVzIC14NTA5IC1zdWJqICIvQz1DTi9TVD1TSC9MPVNIL089TkEvQ049IiAta2V5b3V0IHNlcnZlci5rZXkgLW91dCBzZXJ2ZXIuY3J0CmNob3duIG9wZW5sZGFwLiAvZXRjL2xkYXAvc2FzbDIvKgoKY2F0IDw8IEVPRiA+IC90bXAvY2VydC5sZGlmCmRuOiBjbj1jb25maWcKY2hhbmdldHlwZTogbW9kaWZ5CmFkZDogb2xjVExTQ0FDZXJ0aWZpY2F0ZUZpbGUKb2xjVExTQ0FDZXJ0aWZpY2F0ZUZpbGU6IC9ldGMvbGRhcC9zYXNsMi9jYS1jZXJ0aWZpY2F0ZXMuY3J0Ci0KcmVwbGFjZTogb2xjVExTQ2VydGlmaWNhdGVGaWxlCm9sY1RMU0NlcnRpZmljYXRlRmlsZTogL2V0Yy9sZGFwL3Nhc2wyL3NlcnZlci5jcnQKLQpyZXBsYWNlOiBvbGNUTFNDZXJ0aWZpY2F0ZUtleUZpbGUKb2xjVExTQ2VydGlmaWNhdGVLZXlGaWxlOiAvZXRjL2xkYXAvc2FzbDIvc2VydmVyLmtleQpFT0YKCmxkYXBtb2RpZnkgLVEgLVkgRVhURVJOQUwgLUggbGRhcGk6Ly8vIC1mIC90bXAvY2VydC5sZGlmCgojIEhvc3QgdGhlIGNlcnRpZmljYXRlIGZpbGUKW1sgISAtZCBjZXJ0IF1dICYmIG1rZGlyIC9jZXJ0CmNkIC9jZXJ0CmNwIC9ldGMvbGRhcC9zYXNsMi9zZXJ2ZXIuY3J0IC4Kbm9odXAgcHl0aG9uMyAtbSBodHRwLnNlcnZlciA4MDAwICYKCg=="
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
          osType                  = "Linux"
          writeAcceleratorEnabled = false
        }
      }
    }
  })
  tags = {}
}
