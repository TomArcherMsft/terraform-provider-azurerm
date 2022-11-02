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
  name      = "acctestRG-databricks-221102104601772944"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "virtualNetwork" {
  type      = "Microsoft.Network/virtualNetworks@2021-08-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctest-vnet-221102104601772944"
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
  name      = "acctest-sn-private-221102104601772944"

  body = jsonencode({
    properties = {
      addressPrefix = "10.0.2.0/24"
      delegations = [
        {
          name = "acctest"
          properties = {
            serviceName = "Microsoft.Databricks/workspaces"
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

resource "azapi_resource" "subnet2" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2021-08-01"
  parent_id = azapi_resource.virtualNetwork.id
  name      = "acctest-sn-public-221102104601772944"

  body = jsonencode({
    properties = {
      addressPrefix = "10.0.1.0/24"
      delegations = [
        {
          name = "acctest"
          properties = {
            serviceName = "Microsoft.Databricks/workspaces"
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

resource "azapi_resource" "subnet3" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2021-08-01"
  parent_id = azapi_resource.virtualNetwork.id
  name      = "acctest-sn-private-221102104601772944"

  body = jsonencode({
    id = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-databricks-221102104601772944/providers/Microsoft.Network/virtualNetworks/acctest-vnet-221102104601772944/subnets/acctest-sn-private-221102104601772944"
    properties = {
      addressPrefix = "10.0.2.0/24"
      delegations = [
        {
          name = "acctest"
          properties = {
            serviceName = "Microsoft.Databricks/workspaces"
          }
        },
      ]
      networkSecurityGroup = {
        id = azapi_resource.networkSecurityGroup.id
      }
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
  name      = "acctest-sn-public-221102104601772944"

  body = jsonencode({
    id = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-databricks-221102104601772944/providers/Microsoft.Network/virtualNetworks/acctest-vnet-221102104601772944/subnets/acctest-sn-public-221102104601772944"
    properties = {
      addressPrefix = "10.0.1.0/24"
      delegations = [
        {
          name = "acctest"
          properties = {
            serviceName = "Microsoft.Databricks/workspaces"
          }
        },
      ]
      networkSecurityGroup = {
        id = azapi_resource.networkSecurityGroup.id
      }
      privateEndpointNetworkPolicies    = "Enabled"
      privateLinkServiceNetworkPolicies = "Enabled"
      serviceEndpointPolicies = [
      ]
      serviceEndpoints = [
      ]
    }
  })

}

resource "azapi_resource" "workspace" {
  type      = "Microsoft.Databricks/workspaces@2022-04-01-preview"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestDBW-221102104601772944"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      managedResourceGroupId = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-DBW-221102104601772944-managed"
      parameters = {
        customPrivateSubnetName = {
          value = azapi_resource.subnet3.name
        }
        customPublicSubnetName = {
          value = azapi_resource.subnet4.name
        }
        customVirtualNetworkId = {
          value = azapi_resource.virtualNetwork.id
        }
        enableNoPublicIp = {
          value = true
        }
        prepareEncryption = {
          value = false
        }
        requireInfrastructureEncryption = {
          value = false
        }
      }
      publicNetworkAccess = "Enabled"
    }
    sku = {
      name = "premium"
    }
  })
  tags = {
    Environment = "Production"
    Pricing     = "Premium"
  }
}

resource "azapi_resource" "subnet5" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2021-08-01"
  parent_id = azapi_resource.virtualNetwork.id
  name      = "acctest-sn-private-221102104601772944"

  body = jsonencode({
    id = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-databricks-221102104601772944/providers/Microsoft.Network/virtualNetworks/acctest-vnet-221102104601772944/subnets/acctest-sn-private-221102104601772944"
    properties = {
      addressPrefix = "10.0.2.0/24"
      delegations = [
        {
          name = "acctest"
          properties = {
            serviceName = "Microsoft.Databricks/workspaces"
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

resource "azapi_resource" "subnet6" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2021-08-01"
  parent_id = azapi_resource.virtualNetwork.id
  name      = "acctest-sn-public-221102104601772944"

  body = jsonencode({
    id = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-databricks-221102104601772944/providers/Microsoft.Network/virtualNetworks/acctest-vnet-221102104601772944/subnets/acctest-sn-public-221102104601772944"
    properties = {
      addressPrefix = "10.0.1.0/24"
      delegations = [
        {
          name = "acctest"
          properties = {
            serviceName = "Microsoft.Databricks/workspaces"
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
