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
  name      = "acctestRG-compute-221102105029116844"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "hostGroup" {
  type      = "Microsoft.Compute/hostGroups@2021-11-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctest-DHG-221102105029116844"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      platformFaultDomainCount = 2
    }
  })
  tags = {}
}

resource "azapi_resource" "host" {
  type      = "Microsoft.Compute/hostGroups/hosts@2021-11-01"
  parent_id = azapi_resource.hostGroup.id
  name      = "acctest-DH-221102105029116844"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      autoReplaceOnFailure = true
      licenseType          = "None"
      platformFaultDomain  = 1
    }
    sku = {
      name = "DSv3-Type1"
    }
  })
  tags = {}
}
