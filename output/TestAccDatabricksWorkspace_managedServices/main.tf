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
  name      = "acctestRG-databricks-221102104627401980"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "vault" {
  type      = "Microsoft.KeyVault/vaults@2021-10-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctest-kv-zrkc7"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      accessPolicies = [
      ]
      enableRbacAuthorization      = false
      enableSoftDelete             = true
      enabledForDeployment         = false
      enabledForDiskEncryption     = false
      enabledForTemplateDeployment = false
      publicNetworkAccess          = "Enabled"
      sku = {
        family = "A"
        name   = "premium"
      }
      softDeleteRetentionInDays = 7
      tenantId                  = "72f988bf-86f1-41af-91ab-2d7cd011db47"
    }
  })
  tags = {}
}
