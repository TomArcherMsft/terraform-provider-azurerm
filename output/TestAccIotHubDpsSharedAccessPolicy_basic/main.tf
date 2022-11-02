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
  name      = "acctestRG-221102105206911666"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "provisioningService" {
  type      = "Microsoft.Devices/provisioningServices@2022-02-05"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestIoTDPS-221102105206911666"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      allocationPolicy    = "Hashed"
      enableDataResidency = false
      iotHubs = [
      ]
      publicNetworkAccess = "Enabled"
    }
    sku = {
      capacity = 1
      name     = "S1"
    }
  })
  tags = {}
}
