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
  name      = "acctestRG-221102105235212998"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "proximityPlacementGroup" {
  type      = "Microsoft.Compute/proximityPlacementGroups@2021-11-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "accPPG-221102105235212998"
  location  = azapi_resource.resourceGroup.location
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "storageAccount" {
  type      = "Microsoft.Storage/storageAccounts@2021-09-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "accsa221102105235212998"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    kind = "StorageV2"
    properties = {
      accessTier                   = "Hot"
      allowBlobPublicAccess        = true
      allowCrossTenantReplication  = true
      allowSharedKeyAccess         = true
      defaultToOAuthAuthentication = false
      encryption = {
        keySource = "Microsoft.Storage"
        services = {
          queue = {
            keyType = "Service"
          }
          table = {
            keyType = "Service"
          }
        }
      }
      isHnsEnabled      = false
      isNfsV3Enabled    = false
      minimumTlsVersion = "TLS1_2"
      networkAcls = {
        defaultAction = "Allow"
      }
      publicNetworkAccess      = "Enabled"
      supportsHttpsTrafficOnly = true
    }
    sku = {
      name = "Standard_LRS"
    }
  })
  tags = {
    environment = "staging"
  }
}

resource "azapi_resource" "subnet" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2021-08-01"
  parent_id = azapi_resource.virtualNetwork.id
  name      = "acctsub-221102105235212998"

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
  name      = "acctvmss-221102105235212998"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      orchestrationMode = "Uniform"
      overprovision     = true
      proximityPlacementGroup = {
        id = azapi_resource.proximityPlacementGroup.id
      }
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
              name = "TestNetworkProfile-221102105235212998"
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
          computerNamePrefix = "testvm-221102105235212998"
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
