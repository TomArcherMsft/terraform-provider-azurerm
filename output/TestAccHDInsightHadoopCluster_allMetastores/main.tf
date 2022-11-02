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
  name      = "acctestRG-221102105007180704"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "server" {
  type      = "Microsoft.Sql/servers@2015-05-01-preview"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestsql-221102105007180704"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      administratorLogin         = "sql_admin"
      administratorLoginPassword = "TerrAform123!"
      version                    = "12.0"
    }
  })
  tags = {}
}

resource "azapi_resource" "connectionPolicy" {
  type      = "Microsoft.Sql/servers/connectionPolicies@2014-04-01"
  parent_id = azapi_resource.server.id
  name      = "default"

  body = jsonencode({
    properties = {
      connectionType = "Default"
    }
  })

}

resource "azapi_resource" "securityAlertPolicy" {
  type      = "Microsoft.Sql/servers/securityAlertPolicies@2017-03-01-preview"
  parent_id = azapi_resource.server.id
  name      = azapi_resource.connectionPolicy.name

  body = jsonencode({
    properties = {
      state = "Disabled"
    }
  })

}

resource "azapi_resource" "storageAccount" {
  type      = "Microsoft.Storage/storageAccounts@2021-09-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestsav6u29"
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

resource "azapi_resource" "database" {
  type      = "Microsoft.Sql/servers/databases@2014-04-01"
  parent_id = azapi_resource.server.id
  name      = "oozie"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      collation                     = "SQL_Latin1_General_CP1_CI_AS"
      createMode                    = azapi_resource.securityAlertPolicy.name
      readScale                     = "Disabled"
      requestedServiceObjectiveName = "GP_Gen5_2"
      zoneRedundant                 = false
    }
  })
  tags = {}
}
}
