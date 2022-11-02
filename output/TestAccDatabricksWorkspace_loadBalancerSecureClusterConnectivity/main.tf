
resource "azapi_resource" "subnet2" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2021-08-01"
  parent_id = azapi_resource.virtualNetwork.id
  name      = "acctest-sn-private-221102104605936496"

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

resource "azapi_resource" "subnet3" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2021-08-01"
  parent_id = azapi_resource.virtualNetwork.id
  name      = "acctest-sn-public-221102104605936496"

  body = jsonencode({
    id = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-databricks-221102104605936496/providers/Microsoft.Network/virtualNetworks/acctest-vnet-221102104605936496/subnets/acctest-sn-public-221102104605936496"
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

resource "azapi_resource" "backendAddressPool" {
  type      = "Microsoft.Network/loadBalancers/backendAddressPools@2021-08-01"
  parent_id = azapi_resource.loadBalancer.id
  name      = "be-221102104605936496"

  body = jsonencode({
    properties = {}
  })

}

resource "azapi_resource" "subnet4" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2021-08-01"
  parent_id = azapi_resource.virtualNetwork.id
  name      = "acctest-sn-private-221102104605936496"

  body = jsonencode({
    id = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-databricks-221102104605936496/providers/Microsoft.Network/virtualNetworks/acctest-vnet-221102104605936496/subnets/acctest-sn-private-221102104605936496"
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

resource "azapi_resource" "loadBalancer2" {
  type      = "Microsoft.Network/loadBalancers@2021-08-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctest-loadbalancer-221102104605936496"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    id = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-databricks-221102104605936496/providers/Microsoft.Network/loadBalancers/acctest-loadbalancer-221102104605936496"
    properties = {
      frontendIPConfigurations = [
        {
          name = "acctest-PIP-221102104605936496"
          properties = {
            publicIPAddress = {
              id = azapi_resource.publicIPAddress.id
            }
          }
        },
      ]
      outboundRules = [
        {
          name = "OutboundRule-221102104605936496"
          properties = {
            allocatedOutboundPorts = 1024
            backendAddressPool = {
              id = azapi_resource.backendAddressPool.id
            }
            enableTcpReset = true
            frontendIPConfigurations = [
              {},
            ]
            idleTimeoutInMinutes = 4
            protocol             = "All"
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

resource "azapi_resource" "workspace" {
  type      = "Microsoft.Databricks/workspaces@2022-04-01-preview"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestDBW-221102104605936496"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      managedResourceGroupId = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-DBW-221102104605936496-managed"
      parameters = {
        customPrivateSubnetName = {
          value = azapi_resource.subnet4.name
        }
        customPublicSubnetName = {
          value = azapi_resource.subnet3.name
        }
        customVirtualNetworkId = {
          value = azapi_resource.virtualNetwork.id
        }
        enableNoPublicIp = {
          value = true
        }
        loadBalancerBackendPoolName = {
          value = azapi_resource.backendAddressPool.name
        }
        loadBalancerId = {
          value = azapi_resource.loadBalancer2.id
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

resource "azapi_resource" "loadBalancer3" {
  type      = "Microsoft.Network/loadBalancers@2021-08-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctest-loadbalancer-221102104605936496"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    id = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-databricks-221102104605936496/providers/Microsoft.Network/loadBalancers/acctest-loadbalancer-221102104605936496"
    properties = {
      frontendIPConfigurations = [
        {
          name = "acctest-PIP-221102104605936496"
          properties = {
            publicIPAddress = {
              id = azapi_resource.publicIPAddress.id
            }
          }
        },
      ]
      outboundRules = [
      ]
    }
    sku = {
      name = "Standard"
      tier = "Regional"
    }
  })
  tags = {}
}

resource "azapi_resource" "subnet5" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2021-08-01"
  parent_id = azapi_resource.virtualNetwork.id
  name      = "acctest-sn-public-221102104605936496"

  body = jsonencode({
    id = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-databricks-221102104605936496/providers/Microsoft.Network/virtualNetworks/acctest-vnet-221102104605936496/subnets/acctest-sn-public-221102104605936496"
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

resource "azapi_resource" "subnet6" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2021-08-01"
  parent_id = azapi_resource.virtualNetwork.id
  name      = "acctest-sn-private-221102104605936496"

  body = jsonencode({
    id = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-databricks-221102104605936496/providers/Microsoft.Network/virtualNetworks/acctest-vnet-221102104605936496/subnets/acctest-sn-private-221102104605936496"
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
