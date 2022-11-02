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
  name      = "acctestRG-databricks-221102104558571048"
  location  = "eastus2"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "networkSecurityGroup" {
  type      = "Microsoft.Network/networkSecurityGroups@2021-08-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctest-nsg-221102104558571048"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      securityRules = [
      ]
    }
  })
  tags = {}
}

resource "azapi_resource" "virtualNetwork" {
  type      = "Microsoft.Network/virtualNetworks@2021-08-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctest-vnet-221102104558571048"
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
  name      = "acctest-sn-public-221102104558571048"

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

resource "azapi_resource" "subnet2" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2021-08-01"
  parent_id = azapi_resource.virtualNetwork.id
  name      = "acctest-snpl-221102104558571048"

  body = jsonencode({
    properties = {
      addressPrefix = "10.0.3.0/24"
      delegations = [
      ]
      privateEndpointNetworkPolicies    = "Disabled"
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
  name      = "acctest-sn-private-221102104558571048"

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

resource "azapi_resource" "subnet4" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2021-08-01"
  parent_id = azapi_resource.virtualNetwork.id
  name      = "acctest-sn-public-221102104558571048"

  body = jsonencode({
    id = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-databricks-221102104558571048/providers/Microsoft.Network/virtualNetworks/acctest-vnet-221102104558571048/subnets/acctest-sn-public-221102104558571048"
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

resource "azapi_resource" "subnet5" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2021-08-01"
  parent_id = azapi_resource.virtualNetwork.id
  name      = "acctest-sn-private-221102104558571048"

  body = jsonencode({
    id = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-databricks-221102104558571048/providers/Microsoft.Network/virtualNetworks/acctest-vnet-221102104558571048/subnets/acctest-sn-private-221102104558571048"
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

resource "azapi_resource" "workspace" {
  type      = "Microsoft.Databricks/workspaces@2022-04-01-preview"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestDBW-221102104558571048"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      managedResourceGroupId = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-DBW-221102104558571048-managed"
      parameters = {
        customPrivateSubnetName = {
          value = azapi_resource.subnet5.name
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
      publicNetworkAccess = "Disabled"
      requiredNsgRules    = "NoAzureDatabricksRules"
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

resource "azapi_resource" "privateEndpoint" {
  type      = "Microsoft.Network/privateEndpoints@2021-08-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctest-endpoint-221102104558571048"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      customNetworkInterfaceName = ""
      ipConfigurations = [
      ]
      manualPrivateLinkServiceConnections = [
      ]
      privateLinkServiceConnections = [
        {
          name = "acctest-psc-221102104558571048"
          properties = {
            groupIds = [
              "databricks_ui_api",
            ]
            privateLinkServiceId = azapi_resource.workspace.id
          }
        },
      ]
      subnet = {
        id = azapi_resource.subnet2.id
      }
    }
  })
  tags = {}
}

resource "azapi_resource" "privateDnsZone" {
  type      = "Microsoft.Network/privateDnsZones@2018-09-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "privatelink.azuredatabricks.net"
  location  = "global"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "subnet6" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2021-08-01"
  parent_id = azapi_resource.virtualNetwork.id
  name      = "acctest-sn-private-221102104558571048"

  body = jsonencode({
    id = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-databricks-221102104558571048/providers/Microsoft.Network/virtualNetworks/acctest-vnet-221102104558571048/subnets/acctest-sn-private-221102104558571048"
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

resource "azapi_resource" "subnet7" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2021-08-01"
  parent_id = azapi_resource.virtualNetwork.id
  name      = "acctest-sn-public-221102104558571048"

  body = jsonencode({
    id = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-databricks-221102104558571048/providers/Microsoft.Network/virtualNetworks/acctest-vnet-221102104558571048/subnets/acctest-sn-public-221102104558571048"
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
