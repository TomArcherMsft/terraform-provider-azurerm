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
  name      = "acctestRG-221102105102667367"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "cluster2" {
  type      = "Microsoft.Kusto/clusters@2022-02-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestkc2kfgmt"
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

resource "azapi_resource" "database" {
  type      = "Microsoft.Kusto/clusters/databases@2022-02-01"
  parent_id = azapi_resource.cluster.id
  name      = "acctestkd-221102105102667367"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    kind       = "ReadWrite"
    properties = {}
  })

}

}

resource "azapi_resource" "attachedDatabaseConfiguration" {
  type      = "Microsoft.Kusto/clusters/attachedDatabaseConfigurations@2022-02-01"
  parent_id = azapi_resource.cluster.id
  name      = "acctestka-221102105102667367"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      clusterResourceId                 = azapi_resource.cluster2.id
      databaseName                      = azapi_resource.database2.name
      defaultPrincipalsModificationKind = "None"
      tableLevelSharingProperties = {
        externalTablesToExclude = [
          "ExternalTable2",
        ]
        externalTablesToInclude = [
          "ExternalTable1",
        ]
        materializedViewsToExclude = [
          "MaterializedViewTable2",
        ]
        materializedViewsToInclude = [
          "MaterializedViewTable1",
        ]
        tablesToExclude = [
          "Table2",
        ]
        tablesToInclude = [
          "Table1",
        ]
      }
    }
  })

}
