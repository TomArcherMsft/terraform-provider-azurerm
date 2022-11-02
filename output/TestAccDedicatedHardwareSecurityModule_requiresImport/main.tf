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
  name      = "acctestRG-hsm-221102105016913550"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "publicIPAddress" {
  type      = "Microsoft.Network/publicIPAddresses@2021-08-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctest-pip-221102105016913550"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
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

resource "azapi_resource" "subnet" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2021-08-01"
  parent_id = azapi_resource.virtualNetwork.id
  name      = "gatewaysubnet"

  body = jsonencode({
    properties = {
      addressPrefix = "10.2.255.0/26"
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

resource "azapi_resource" "subnet2" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2021-08-01"
  parent_id = azapi_resource.virtualNetwork.id
  name      = "acctest-hsmsubnet-221102105016913550"

  body = jsonencode({
    properties = {
      addressPrefix = "10.2.1.0/24"
      delegations = [
        {
          name = "first"
          properties = {
            serviceName = "Microsoft.HardwareSecurityModules/dedicatedHSMs"
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

resource "azapi_resource" "virtualNetworkGateway" {
  type      = "Microsoft.Network/virtualNetworkGateways@2021-08-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctest-vnetgateway-221102105016913550"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      activeActive           = false
      enableBgp              = false
      enablePrivateIpAddress = false
      gatewayType            = "ExpressRoute"
      ipConfigurations = [
        {
          name = "vnetGatewayConfig"
          properties = {
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
      sku = {
        name = "Standard"
        tier = "Standard"
      }
      vpnType = "PolicyBased"
    }
  })
  tags = {}
}

resource "azapi_resource" "dedicatedHSM" {
  type      = "Microsoft.HardwareSecurityModules/dedicatedHSMs@2021-11-30"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctest-hsm-r86km"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      networkProfile = {
        networkInterfaces = [
          {
            privateIpAddress = "10.2.1.8"
          },
        ]
        subnet = {
          id = azapi_resource.subnet2.id
        }
      }
      stampId = "stamp2"
    }
    sku = {
      name = "SafeNet Luna Network HSM A790"
    }
  })
  tags = {}
}
