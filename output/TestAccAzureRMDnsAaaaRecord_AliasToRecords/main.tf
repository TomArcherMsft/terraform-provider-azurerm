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
  name      = "acctestRG-221102104834926192"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "publicIPAddress" {
  type      = "Microsoft.Network/publicIPAddresses@2021-08-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "mypublicip221102104834926192"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      idleTimeoutInMinutes     = 4
      publicIPAddressVersion   = "IPv6"
      publicIPAllocationMethod = "Dynamic"
    }
    sku = {
      name = "Basic"
      tier = "Regional"
    }
  })
  tags = {}
}
