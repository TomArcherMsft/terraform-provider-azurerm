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
  name      = "acctestRG-databoxedge-221102104538900566"
  location  = "eastus"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "dataBoxEdgeDevice" {
  type      = "Microsoft.DataBoxEdge/dataBoxEdgeDevices@2020-12-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctest-dd-hou62"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    sku = {
      name = "EdgeP_Base"
      tier = "Standard"
    }
  })
  tags = {}
}

resource "azapi_resource" "order" {
  type      = "Microsoft.DataBoxEdge/dataBoxEdgeDevices/orders@2020-12-01"
  parent_id = azapi_resource.dataBoxEdgeDevice.id
  name      = "default"

  body = jsonencode({
    properties = {
      contactInformation = {
        companyName   = "Microsoft"
        contactPerson = "TerraForm Test"
        emailList = [
          "creator4983@FlynnsArcade.com",
        ]
        phone = "425-882-8080"
      }
      shippingAddress = {
        addressLine1 = "One Microsoft Way"
        addressLine2 = ""
        addressLine3 = ""
        city         = "Redmond"
        country      = "United States"
        postalCode   = "98052"
        state        = "WA"
      }
    }
  })

}
