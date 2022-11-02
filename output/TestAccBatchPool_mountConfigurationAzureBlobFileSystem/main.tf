
resource "azapi_resource" "batchAccount" {
  type      = "Microsoft.Batch/batchAccounts@2022-01-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "testaccbatchewa7j"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      encryption = {
        keySource = "Microsoft.Batch"
      }
      poolAllocationMode  = "BatchService"
      publicNetworkAccess = "Enabled"
    }
  })
  tags = {}
}

resource "azapi_resource" "storageAccount" {
  type      = "Microsoft.Storage/storageAccounts@2021-09-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "accbatchsaewa7j"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    kind = "StorageV2"
    properties = {
      accessTier                   = "Hot"
      allowBlobPublicAccess        = true
      allowCrossTenantReplication  = true
      allowSharedKeyAccess         = true
      defaultToOAuthAuthentication = false
      encryption = {
        keySource = "Microsoft.Storage"
        services = {
          queue = {
            keyType = "Service"
          }
          table = {
            keyType = "Service"
          }
        }
      }
      isHnsEnabled      = false
      isNfsV3Enabled    = false
      minimumTlsVersion = "TLS1_2"
      networkAcls = {
        defaultAction = "Allow"
      }
      publicNetworkAccess      = "Enabled"
      supportsHttpsTrafficOnly = true
    }
    sku = {
      name = "Standard_LRS"
    }
  })
  tags = {}
}

resource "azapi_resource" "subnet" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2021-08-01"
  parent_id = azapi_resource.virtualNetwork.id
  name      = "testsn-ewa7j"

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

resource "azapi_resource" "subnet2" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2021-08-01"
  parent_id = azapi_resource.virtualNetwork.id
  name      = "testsn-ewa7j"

  body = jsonencode({
    id = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/testaccRG-batch-221102104452057580/providers/Microsoft.Network/virtualNetworks/testvn-batch-ewa7j/subnets/testsn-ewa7j"
    properties = {
      addressPrefix = "10.0.2.0/24"
      delegations = [
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

resource "azapi_resource" "subnet3" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2021-08-01"
  parent_id = azapi_resource.virtualNetwork.id
  name      = "testsn-ewa7j"

  body = jsonencode({
    id = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/testaccRG-batch-221102104452057580/providers/Microsoft.Network/virtualNetworks/testvn-batch-ewa7j/subnets/testsn-ewa7j"
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
