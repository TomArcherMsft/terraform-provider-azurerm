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
  name      = "acctestRG-storage-221102105220568675"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "virtualNetwork" {
  type      = "Microsoft.Network/virtualNetworks@2021-08-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctest-VN-221102105220568675"
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
  name      = "acctestsub-221102105220568675"

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

resource "azapi_resource" "cach" {
  type      = "Microsoft.StorageCache/caches@2021-09-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctest-HPCC-221102105220568675"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      cacheSizeGB = 3072
      networkSettings = {
        mtu       = 1500
        ntpServer = "time.windows.com"
      }
      securitySettings = {
        accessPolicies = null
      }
      subnet = azapi_resource.subnet.id
    }
    sku = {
      name = "Standard_2G"
    }
  })
  tags = {
    environment = "Production"
  }
}
