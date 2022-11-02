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
  name      = "acctest-rg-221102103453980907"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "virtualNetwork" {
  type      = "Microsoft.Network/virtualNetworks@2021-08-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctest-rg-221102103453980907"
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

resource "azapi_resource" "dnsResolver" {
  type      = "Microsoft.Network/dnsResolvers@2022-07-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctest-dr-221102103453980907"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      virtualNetwork = {
        id = azapi_resource.virtualNetwork.id
      }
    }
  })
  tags = null
}
