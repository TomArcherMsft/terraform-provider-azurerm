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
  name      = "acctestRG-tsi-221102105040030953"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "environment" {
  type      = "Microsoft.TimeSeriesInsights/environments@2020-05-15"
  parent_id = azapi_resource.resourceGroup.id
  name      = "accTEst_tsie221102105040030953"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    kind = "Gen1"
    properties = {
      dataRetentionTime            = "P30D"
      storageLimitExceededBehavior = "PurgeOldData"
    }
    sku = {
      capacity = 1
      name     = "S1"
    }
  })
  tags = {}
}

resource "azapi_resource" "accessPolicy" {
  type      = "Microsoft.TimeSeriesInsights/environments/accessPolicies@2020-05-15"
  parent_id = azapi_resource.environment.id
  name      = "accTEst_tsiap221102105040030953"

  body = jsonencode({
    properties = {
      description       = ""
      principalObjectId = "aGUID"
      roles = [
        "Reader",
      ]
    }
  })

}
