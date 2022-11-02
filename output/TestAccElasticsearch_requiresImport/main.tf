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
  name      = "acctestrg-elastic-221102104825781837"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "monitor" {
  type      = "Microsoft.Elastic/monitors@2020-07-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctest-estc221102104825781837"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      monitoringStatus = "Enabled"
      userInfo = {
        emailAddress = "terraform-acctest@hashicorp.com"
      }
    }
    sku = {
      name = "ess-monthly-consumption_Monthly"
    }
  })
  tags = {}
}
