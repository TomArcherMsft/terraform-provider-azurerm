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
  name      = "acctestRG-diskspool-221102104758365565"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "virtualNetwork" {
  type      = "Microsoft.Network/virtualNetworks@2021-08-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctest-vnet-221102104758365565"
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
  name      = "acctest-subnet-221102104758365565"

  body = jsonencode({
    properties = {
      addressPrefix = "10.0.0.0/24"
      delegations = [
        {
          name = "diskspool"
          properties = {
            serviceName = "Microsoft.StoragePool/diskPools"
          }
        },
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

resource "azapi_resource" "diskPool" {
  type      = "Microsoft.StoragePool/diskPools@2021-08-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctest-diskspool-2hetn"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      availabilityZones = [
        "1",
      ]
      subnetId = azapi_resource.subnet.id
    }
    sku = {
      name = "Basic_B1"
      tier = "Basic"
    }
  })
  tags = {}
}
