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
  name      = "acctestRG-221102104618549228"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "service" {
  type      = "Microsoft.ApiManagement/service@2021-08-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestAM-221102104618549228"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      certificates = [
      ]
      customProperties = {
        Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Ssl30 = "false"
        Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Tls10 = "false"
        Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Tls11 = "false"
        Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Tls10         = "false"
        Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Tls11         = "false"
      }
      disableGateway      = false
      publicNetworkAccess = "Enabled"
      publisherEmail      = "pub1@email.com"
      publisherName       = "pub1"
      virtualNetworkType  = "None"
    }
    sku = {
      capacity = 0
      name     = "Consumption"
    }
  })
  tags = {}
}

resource "azapi_resource" "schema" {
  type      = "Microsoft.ApiManagement/service/schemas@2021-08-01"
  parent_id = azapi_resource.service.id
  name      = "accetestSchema-221102104618549228"

  body = jsonencode({
    properties = {
      description              = ""
      schemaType               = "xml"
      value                    = "    <xsd:schema xmlns:xsd=" http : //www.w3.org/2001/XMLSchema"
      xmlns : tns              = "http://tempuri.org/PurchaseOrderSchema.xsd" targetNamespace = "http://tempuri.org/PurchaseOrderSchema.xsd" elementFormDefault = "qualified" >
      < xsd : element name     = "PurchaseOrder" type = "tns:PurchaseOrderType" / >
      < xsd : complexType name = "PurchaseOrderType" >
      < xsd : sequence >
      < xsd : element name = "ShipTo" type = "tns:USAddress" maxOccurs = "2" / >
      < xsd : element name = "BillTo" type = "tns:USAddress" / >
      < / xsd : sequence >
      < xsd : attribute name = "OrderDate" type = "xsd:date" / >
      < / xsd : complexType >
      < xsd : complexType name = "USAddress" >
      < xsd : sequence >
      < xsd : element name = "name" type = "xsd:string" / >
      < xsd : element name = "street" type = "xsd:string" / >
      < xsd : element name = "city" type = "xsd:string" / >
      < xsd : element name = "state" type = "xsd:string" / >
      < xsd : element name = "zip" type = "xsd:integer" / >
      < / xsd : sequence >
      < xsd : attribute name = "country" type = "xsd:NMTOKEN" fixed = "US" / >
      < / xsd : complexType >
      < / xsd : schema >
      "
    }
  })
  
}
