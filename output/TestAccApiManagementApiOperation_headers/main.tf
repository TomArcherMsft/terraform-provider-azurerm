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
  name      = "acctestRG-221102104049823229"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "service" {
  type      = "Microsoft.ApiManagement/service@2021-08-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestAM-221102104049823229"
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

resource "azapi_resource" "api" {
  type      = "Microsoft.ApiManagement/service/apis@2021-08-01"
  parent_id = azapi_resource.service.id
  name      = "acctestapi-221102104049823229;rev=3"

  body = jsonencode({
    properties = {
      apiRevisionDescription = ""
      apiType                = "http"
      apiVersion             = ""
      apiVersionDescription  = ""
      authenticationSettings = {}
      description            = "What is my purpose? You parse butter."
      displayName            = "Butter Parser"
      path                   = "butter-parser"
      protocols = [
        "http",
        "https",
      ]
      serviceUrl = "https://example.com/foo/bar"
      subscriptionKeyParameterNames = {
        header = "X-Butter-Robot-API-Key"
        query  = "location"
      }
      subscriptionRequired = true
      type                 = "http"
    }
  })

}
