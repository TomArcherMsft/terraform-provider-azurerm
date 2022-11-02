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
  name      = "acctestRG-221102104233888823"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "availabilitySet" {
  type      = "Microsoft.Compute/availabilitySets@2021-11-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestavset-221102104233888823"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      platformFaultDomainCount  = 3
      platformUpdateDomainCount = 5
    }
    sku = {
      name = "Aligned"
    }
  })
  tags = {}
}
