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
  name      = "acctestRG-kusto-221102105124056756"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "cluster" {
  type      = "Microsoft.Kusto/clusters@2022-02-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestkcfdcnh"
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
    }
    sku = {
      capacity = 1
      name     = "Dev(No SLA)_Standard_D11_v2"
      tier     = "Basic"
    }
  })
  tags = {}
}

resource "azapi_resource" "principalAssignment" {
  type      = "Microsoft.Kusto/clusters/principalAssignments@2022-02-01"
  parent_id = azapi_resource.cluster.id
  name      = "acctestkdpa221102105124056756"

  body = jsonencode({
    properties = {
      principalId   = "0ddf9866-48e9-4e1d-a880-17a2ea0c9ec6"
      principalType = "App"
      role          = "AllDatabasesViewer"
      tenantId      = "72f988bf-86f1-41af-91ab-2d7cd011db47"
    }
  })

}
