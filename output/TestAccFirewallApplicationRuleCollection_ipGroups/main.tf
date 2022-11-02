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
  name      = "acctestRG-fw-221102104921966475"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "publicIPAddress" {
  type      = "Microsoft.Network/publicIPAddresses@2021-08-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestpip221102104921966475"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      idleTimeoutInMinutes     = 4
      publicIPAddressVersion   = "IPv4"
      publicIPAllocationMethod = "Static"
    }
    sku = {
      name = "Standard"
      tier = "Regional"
    }
  })
  tags = {}
}
parent_id = azapi_resource.resourceGroup.id
name      = "acctestvirtnet221102104921966475"
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
  name      = "AzureFirewallSubnet"

  body = jsonencode({
    properties = {
      addressPrefix = "10.0.1.0/24"
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

resource "azapi_resource" "azureFirewall" {
  type      = "Microsoft.Network/azureFirewalls@2021-08-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestfirewall221102104921966475"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      additionalProperties = {}
      ipConfigurations = [
        {
          name = "configuration"
          properties = {
            publicIPAddress = {
              id = azapi_resource.publicIPAddress.id
            }
            subnet = {
              id = azapi_resource.subnet.id
            }
          }
        },
      ]
      sku = {
        name = "AZFW_VNet"
        tier = "Standard"
      }
      threatIntelMode = "Deny"
    }
  })
  tags = {}
}
