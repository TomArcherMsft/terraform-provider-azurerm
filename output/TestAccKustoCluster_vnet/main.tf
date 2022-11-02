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
  name      = "acctestRG-221102105210167309"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "networkSecurityGroup" {
  type      = "Microsoft.Network/networkSecurityGroups@2021-08-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestkcptrwm-nsg"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      securityRules = [
      ]
    }
  })
  tags = {}
}

resource "azapi_resource" "publicIPAddress2" {
  type      = "Microsoft.Network/publicIPAddresses@2021-08-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestkcptrwm-management-pip"
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

resource "azapi_resource" "securityRule" {
  type      = "Microsoft.Network/networkSecurityGroups/securityRules@2021-08-01"
  parent_id = azapi_resource.networkSecurityGroup.id
  name      = "AllowAzureDataExplorerManagement"

  body = jsonencode({
    properties = {
      access                   = "Allow"
      destinationAddressPrefix = "VirtualNetwork"
      destinationPortRange     = "443"
      direction                = "Inbound"
      priority                 = 1000
      protocol                 = "Tcp"
      sourceAddressPrefix      = "AzureDataExplorerManagement"
      sourcePortRange          = "*"
    }
  })

}

resource "azapi_resource" "subnet" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2021-08-01"
  parent_id = azapi_resource.virtualNetwork.id
  name      = "acctestkcptrwm-subnet"

  body = jsonencode({
    properties = {
      addressPrefix = "10.0.1.0/24"
      delegations = [
        {
          name = "delegation"
          properties = {
            serviceName = "Microsoft.Kusto/clusters"
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
  name      = "acctestkcptrwm-subnet"

  body = jsonencode({
    id = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-221102105210167309/providers/Microsoft.Network/virtualNetworks/acctestkcptrwm-vnet/subnets/acctestkcptrwm-subnet"
    properties = {
      addressPrefix = "10.0.1.0/24"
      delegations = [
        {
          name = "delegation"
          properties = {
            serviceName = "Microsoft.Kusto/clusters"
          }
        },
      ]
      privateEndpointNetworkPolicies    = "Enabled"
      privateLinkServiceNetworkPolicies = "Enabled"
      routeTable = {
        id = azapi_resource.routeTable.id
      }
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
  name      = "acctestkcptrwm-subnet"

  body = jsonencode({
    id = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-221102105210167309/providers/Microsoft.Network/virtualNetworks/acctestkcptrwm-vnet/subnets/acctestkcptrwm-subnet"
    properties = {
      addressPrefix = "10.0.1.0/24"
      delegations = [
        {
          name = "delegation"
          properties = {
            serviceName = "Microsoft.Kusto/clusters"
          }
        },
      ]
      networkSecurityGroup = {
        id = azapi_resource.networkSecurityGroup.id
      }
      privateEndpointNetworkPolicies    = "Enabled"
      privateLinkServiceNetworkPolicies = "Enabled"
      routeTable = {
        id = azapi_resource.routeTable.id
      }
      serviceEndpointPolicies = [
      ]
      serviceEndpoints = [
      ]
    }
  })

}

resource "azapi_resource" "cluster" {
  type      = "Microsoft.Kusto/clusters@2022-02-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestkcptrwm"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      enableAutoStop                = true
      enableDiskEncryption          = false
      enableDoubleEncryption        = false
      enablePurge                   = false
      enableStreamingIngest         = false
      engineType                    = "V2"
      publicIPType                  = "IPv4"
      publicNetworkAccess           = "Enabled"
      restrictOutboundNetworkAccess = "Disabled"
      trustedExternalTenants = [
      ]
      virtualNetworkConfiguration = {
        dataManagementPublicIpId = azapi_resource.publicIPAddress2.id
        enginePublicIpId         = azapi_resource.publicIPAddress.id
        subnetId                 = azapi_resource.subnet3.id
      }
    }
    sku = {
      capacity = 1
      name     = "Dev(No SLA)_Standard_D11_v2"
      tier     = "Basic"
    }
  })
  tags = {}
}

resource "azapi_resource" "subnet4" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2021-08-01"
  parent_id = azapi_resource.virtualNetwork.id
  name      = "acctestkcptrwm-subnet"

  body = jsonencode({
    id = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-221102105210167309/providers/Microsoft.Network/virtualNetworks/acctestkcptrwm-vnet/subnets/acctestkcptrwm-subnet"
    properties = {
      addressPrefix = "10.0.1.0/24"
      delegations = [
        {
          name = "delegation"
          properties = {
            serviceName = "Microsoft.Kusto/clusters"
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
  name      = "acctestkcptrwm-subnet"

  body = jsonencode({
    id = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-221102105210167309/providers/Microsoft.Network/virtualNetworks/acctestkcptrwm-vnet/subnets/acctestkcptrwm-subnet"
    properties = {
      addressPrefix = "10.0.1.0/24"
      delegations = [
        {
          name = "delegation"
          properties = {
            serviceName = "Microsoft.Kusto/clusters"
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
