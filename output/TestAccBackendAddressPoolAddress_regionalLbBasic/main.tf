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
  name      = "acctestRG-221102105241585183"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "publicIPAddress" {
  type      = "Microsoft.Network/publicIPAddresses@2021-08-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestpip-221102105241585183"
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

resource "azapi_resource" "loadBalancer" {
  type      = "Microsoft.Network/loadBalancers@2021-08-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestlb-221102105241585183"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      frontendIPConfigurations = [
        {
          name = "feip"
          properties = {
            publicIPAddress = {
              id = azapi_resource.publicIPAddress.id
            }
          }
        },
      ]
    }
    sku = {
      name = "Standard"
      tier = "Regional"
    }
  })
  tags = {}
}

resource "azapi_resource" "backendAddressPool" {
  type      = "Microsoft.Network/loadBalancers/backendAddressPools@2021-08-01"
  parent_id = azapi_resource.loadBalancer.id
  name      = "internal"

  body = jsonencode({
    properties = {}
  })

}

resource "azapi_resource" "backendAddressPool2" {
  type      = "Microsoft.Network/loadBalancers/backendAddressPools@2021-08-01"
  parent_id = azapi_resource.loadBalancer.id
  name      = "internal"

  body = jsonencode({
    id = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-221102105241585183/providers/Microsoft.Network/loadBalancers/acctestlb-221102105241585183/backendAddressPools/internal"
    properties = {
      loadBalancerBackendAddresses = [
        {
          name = "address"
          properties = {
            ipAddress = "191.168.0.1"
            virtualNetwork = {
              id = azapi_resource.virtualNetwork.id
            }
          }
        },
      ]
    }
  })

}
