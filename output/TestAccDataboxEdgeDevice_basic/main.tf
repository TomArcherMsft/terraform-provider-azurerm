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
  name      = "acctestRG-databoxedge-221102104513265091"
  location  = "eastus"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "dataBoxEdgeDevice" {
  type      = "Microsoft.DataBoxEdge/dataBoxEdgeDevices@2020-12-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctest-dd-4i1cc"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    sku = {
      name = "EdgeP_Base"
      tier = "Standard"
    }
  })
  tags = {}
}
