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
  name      = "acctestRG-logic-221102105258086864"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "virtualNetwork" {
  type      = "Microsoft.Network/virtualNetworks@2021-08-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctest-vnet-221102105258086864"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      addressSpace = {
        addressPrefixes = [
          "10.0.0.0/22",
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
  name      = "isesubnet2"

  body = jsonencode({
    properties = {
      addressPrefix = "10.0.1.32/27"
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
  name      = "isesubnet3"

  body = jsonencode({
    properties = {
      addressPrefix = "10.0.1.64/27"
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

resource "azapi_resource" "subnet3" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2021-08-01"
  parent_id = azapi_resource.virtualNetwork.id
  name      = "isesubnet4"

  body = jsonencode({
    properties = {
      addressPrefix = "10.0.1.96/27"
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

resource "azapi_resource" "subnet4" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2021-08-01"
  parent_id = azapi_resource.virtualNetwork.id
  name      = "isesubnet1"

  body = jsonencode({
    properties = {
      addressPrefix = "10.0.1.0/27"
      delegations = [
        {
          name = "integrationServiceEnvironments"
          properties = {
            serviceName = "Microsoft.Logic/integrationServiceEnvironments"
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

resource "azapi_resource" "integrationServiceEnvironment" {
  type      = "Microsoft.Logic/integrationServiceEnvironments@2019-05-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestRG-logic-221102105258086864"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      networkConfiguration = {
        accessEndpoint = {
          type = "Internal"
        }
        subnets = [
          {
            id = azapi_resource.subnet4.id
          },
          {
            id = azapi_resource.subnet3.id
          },
          {
            id = azapi_resource.subnet2.id
          },
          {
            id = azapi_resource.subnet.id
          },
        ]
      }
    }
    sku = {
      capacity = 0
      name     = "Premium"
    }
  })
  tags = {}
}
