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
  name      = "acctestRG-LFA-221102104025861073"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "serverfarm" {
  type      = "Microsoft.Web/serverfarms@2021-02-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestASP-221102104025861073"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      hyperV         = false
      perSiteScaling = false
      reserved       = true
      zoneRedundant  = false
    }
    sku = {
      name = "S1"
    }
  })
  tags = {}
}
      = true
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
