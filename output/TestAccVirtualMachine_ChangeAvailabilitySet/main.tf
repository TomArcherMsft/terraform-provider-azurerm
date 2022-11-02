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
  name      = "acctestRG-221102105207702190"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "availabilitySet" {
  type      = "Microsoft.Compute/availabilitySets@2021-11-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "availabilityset221102105207702190"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      platformFaultDomainCount  = 3
      platformUpdateDomainCount = 5
    }
    sku = {
      name = "Aligned"
    }
  })
  tags = {}
}

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
  name      = "acctsub-221102105207702190"

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
  name      = "acctni-221102105207702190"
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
