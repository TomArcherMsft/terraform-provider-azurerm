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
  name      = "acctestRG-cognitive-221102104250634436"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "virtualNetwork" {
  type      = "Microsoft.Network/virtualNetworks@2021-08-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestvirtnet221102104250634436"
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
  name      = "acctestsubnetb221102104250634436"

  body = jsonencode({
    properties = {
      addressPrefix = "10.0.4.0/24"
      delegations = [
      ]
      privateEndpointNetworkPolicies    = "Enabled"
      privateLinkServiceNetworkPolicies = "Enabled"
      serviceEndpointPolicies = [
      ]
      serviceEndpoints = [
        {
          service = "Microsoft.CognitiveServices"
        },
      ]
    }
  })

}

resource "azapi_resource" "subnet2" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2021-08-01"
  parent_id = azapi_resource.virtualNetwork.id
  name      = "acctestsubneta221102104250634436"

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
        {
          service = "Microsoft.CognitiveServices"
        },
      ]
    }
  })

}

resource "azapi_resource" "account" {
  type      = "Microsoft.CognitiveServices/accounts@2021-04-30"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestcogacc-221102104250634436"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    kind = "Face"
    properties = {
      allowedFqdnList = [
      ]
      apiProperties       = {}
      customSubDomainName = "acctestcogacc-221102104250634436"
      disableLocalAuth    = false
      networkAcls = {
        defaultAction = "Deny"
        ipRules = [
        ]
        virtualNetworkRules = [
          {
            id                               = azapi_resource.subnet2.id
            ignoreMissingVnetServiceEndpoint = false
          },
          {
            id                               = azapi_resource.subnet.id
            ignoreMissingVnetServiceEndpoint = false
          },
        ]
      }
      publicNetworkAccess           = "Enabled"
      restrictOutboundNetworkAccess = false
    }
    sku = {
      name = "S0"
      tier = "Standard"
    }
  })
  tags = {}
}
