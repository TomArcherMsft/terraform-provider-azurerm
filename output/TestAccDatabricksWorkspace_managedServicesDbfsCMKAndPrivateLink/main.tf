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
  name      = "acctestRG-databricks-221102104632355557"
  location  = "eastus2"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "networkSecurityGroup" {
  type      = "Microsoft.Network/networkSecurityGroups@2021-08-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctest-nsg-221102104632355557"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      securityRules = [
      ]
    }
  })
  tags = {}
}

resource "azapi_resource" "subnet" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2021-08-01"
  parent_id = azapi_resource.virtualNetwork.id
  name      = "acctest-sn-private-221102104632355557"

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
  name      = "acctest-sn-public-221102104632355557"

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
  name      = "acctest-snpl-221102104632355557"

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

resource "azapi_resource" "subnet4" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2021-08-01"
  parent_id = azapi_resource.virtualNetwork.id
  name      = "acctest-sn-private-221102104632355557"

  body = jsonencode({
    id = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-databricks-221102104632355557/providers/Microsoft.Network/virtualNetworks/acctest-vnet-221102104632355557/subnets/acctest-sn-private-221102104632355557"
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

resource "azapi_resource" "subnet5" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2021-08-01"
  parent_id = azapi_resource.virtualNetwork.id
  name      = "acctest-sn-public-221102104632355557"

  body = jsonencode({
    id = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-databricks-221102104632355557/providers/Microsoft.Network/virtualNetworks/acctest-vnet-221102104632355557/subnets/acctest-sn-public-221102104632355557"
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

resource "azapi_resource" "subnet6" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2021-08-01"
  parent_id = azapi_resource.virtualNetwork.id
  name      = "acctest-sn-private-221102104632355557"

  body = jsonencode({
    id = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-databricks-221102104632355557/providers/Microsoft.Network/virtualNetworks/acctest-vnet-221102104632355557/subnets/acctest-sn-private-221102104632355557"
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
  name      = "acctest-sn-public-221102104632355557"

  body = jsonencode({
    id = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-databricks-221102104632355557/providers/Microsoft.Network/virtualNetworks/acctest-vnet-221102104632355557/subnets/acctest-sn-public-221102104632355557"
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
