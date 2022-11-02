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
  name      = "acctestRG-221102104400396730-all"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "service" {
  type      = "Microsoft.ApiManagement/service@2021-08-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestAM-221102104400396730-all"
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

resource "azapi_resource" "backend" {
  type      = "Microsoft.ApiManagement/service/backends@2021-08-01"
  parent_id = azapi_resource.service.id
  name      = "acctestapi-221102104400396730"

  body = jsonencode({
    properties = {
      credentials = {
        authorization = {
          parameter = "parameter"
          scheme    = "scheme"
        }
        header = {
          header1 = [
            "header1value1",
            "header1value2",
          ]
          header2 = [
            "header2value1",
            "header2value2",
          ]
        }
        query = {
          query1 = [
            "query1value1",
            "query1value2",
          ]
          query2 = [
            "query2value1",
            "query2value2",
          ]
        }
      }
      description = "description"
      protocol    = "http"
      proxy = {
        password = "password"
        url      = "http://192.168.1.1:8080"
        username = "username"
      }
      resourceId = "https://resourceid"
      title      = "title"
      tls = {
        validateCertificateChain = false
        validateCertificateName  = true
      }
      url = "https://acctest"
    }
  })

}
