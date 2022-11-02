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
  name      = "acctestRG-221102105232355269"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "virtualNetwork" {
  type      = "Microsoft.Network/virtualNetworks@2021-08-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctvn-221102105232355269"
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
  name      = "acctsub-221102105232355269"

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

resource "azapi_resource" "virtualMachineScaleSet" {
  type      = "Microsoft.Compute/virtualMachineScaleSets@2022-08-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctvmss-221102105232355269"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      orchestrationMode    = "Uniform"
      overprovision        = true
      singlePlacementGroup = false
      upgradePolicy = {
        automaticOSUpgradePolicy = {
          enableAutomaticOSUpgrade = false
        }
        mode = "Manual"
      }
      virtualMachineProfile = {
        extensionProfile = {
          extensions = [
          ]
        }
        networkProfile = {
          networkInterfaceConfigurations = [
            {
              name = "TestNetworkProfile-221102105232355269"
              properties = {
                dnsSettings                 = {}
                enableAcceleratedNetworking = false
                enableIPForwarding          = false
                ipConfigurations = [
                  {
                    name = "TestIPConfiguration"
                    properties = {
                      applicationGatewayBackendAddressPools = [
                      ]
                      applicationSecurityGroups = [
                      ]
                      loadBalancerBackendAddressPools = [
                      ]
                      loadBalancerInboundNatPools = [
                      ]
                      primary = true
                      subnet = {
                        id = azapi_resource.subnet.id
                      }
                    }
                  },
                ]
                primary = true
              }
            },
          ]
        }
        osProfile = {
          adminPassword      = "Passwword1234"
          adminUsername      = "myadmin"
          computerNamePrefix = "testvm-221102105232355269"
        }
        storageProfile = {
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
              storageAccountType = "StandardSSD_LRS"
            }
          }
        }
      }
    }
    sku = {
      capacity = 2
      name     = "Standard_D1_v2"
      tier     = "Standard"
    }
  })
  tags = {}
}
