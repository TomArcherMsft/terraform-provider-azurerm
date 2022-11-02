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
  name      = "acctestRG-221102105132141111"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "cluster" {
  type      = "Microsoft.Kusto/clusters@2022-02-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestkc8uq4q"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      allowedFqdnList = [
        "255.255.255.0/24",
      ]
      allowedIpRangeList = [
        "0.0.0.0/0",
      ]
      enableAutoStop                = true
      enableDiskEncryption          = false
      enableDoubleEncryption        = false
      enablePurge                   = false
      enableStreamingIngest         = false
      engineType                    = "V2"
      publicIPType                  = "DualStack"
      publicNetworkAccess           = "Disabled"
      restrictOutboundNetworkAccess = "Enabled"
      trustedExternalTenants = [
      ]
    }
    sku = {
      capacity = 2
      name     = "Standard_D13_v2"
      tier     = "Standard"
    }
  })
  tags = {}
}
