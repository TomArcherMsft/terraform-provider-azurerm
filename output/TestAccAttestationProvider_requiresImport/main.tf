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
  name      = "acctestRG-attestation-221102104020117270"
  location  = "uksouth"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "attestationProvider" {
  type      = "Microsoft.Attestation/attestationProviders@2020-10-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestapcqpff6e8ox"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {}
  })
  tags = {}
}
