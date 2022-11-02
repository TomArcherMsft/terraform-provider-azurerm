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
  name      = "testaccRG-batch-221102104313494786"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "publicIPAddress" {
  type      = "Microsoft.Network/publicIPAddresses@2021-08-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestpip221102104313494786"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      dnsSettings = {
        domainNameLabel = "acctestpip221102104313494786"
      }
      idleTimeoutInMinutes     = 4
      publicIPAddressVersion   = "IPv4"
      publicIPAllocationMethod = "Dynamic"
    }
    sku = {
      name = "Basic"
      tier = "Regional"
    }
  })
  tags = {}
}
azapi_resource.resourceGroup.id
name     = "acctestsav1fdo"
location = azapi_resource.resourceGroup.location
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
  environment = "Dev"
}
}

resource "azapi_resource" "image" {
  type      = "Microsoft.Compute/galleries/images@2022-01-03"
  parent_id = azapi_resource.gallery.id
  name      = "acctestimg221102104313494786"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      architecture = "x64"
      description  = ""
      disallowed = {
        diskTypes = [
        ]
      }
      features         = null
      hyperVGeneration = "V1"
      identifier = {
        offer     = "AccTesOffer221102104313494786"
        publisher = "AccTesPublisher221102104313494786"
        sku       = "AccTesSku221102104313494786"
      }
      osState             = "Generalized"
      osType              = "Linux"
      privacyStatementUri = ""
      recommended = {
        memory = {}
        vCPUs  = {}
      }
      releaseNoteUri = ""
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
  name      = "testaccpoolv1fdo"

  body = jsonencode({
    properties = {
      certificates = null
      deploymentConfiguration = {
        virtualMachineConfiguration = {
          imageReference = {
            id = azapi_resource.image.id
          }
          nodeAgentSkuId = "batch.node.ubuntu 18.04"
          osDisk = {
            ephemeralOSDiskSettings = {}
          }
        }
      }
      displayName            = "Test Acc Pool"
      interNodeCommunication = "Enabled"
      metadata = [
      ]
      scaleSettings = {
        fixedScale = {
          resizeTimeout          = "PT15M"
          targetDedicatedNodes   = 2
          targetLowPriorityNodes = 0
        }
      }
      taskSlotsPerNode = 2
      vmSize           = "Standard_A1"
    }
  })

}

resource "azapi_resource" "networkInterface" {
  type      = "Microsoft.Network/networkInterfaces@2021-08-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestnic-221102104313494786"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      enableAcceleratedNetworking = false
      enableIPForwarding          = false
      ipConfigurations = [
        {
          name = "testconfigurationsource"
          properties = {
            primary                   = false
            privateIPAddressVersion   = "IPv4"
            privateIPAllocationMethod = "Dynamic"
            publicIPAddress = {
              id = azapi_resource.publicIPAddress.id
            }
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
