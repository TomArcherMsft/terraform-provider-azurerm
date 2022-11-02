
resource "azapi_resource" "service" {
  type      = "Microsoft.ApiManagement/service@2021-08-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestAM-221102104025781994"
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
  name      = "acctestAMA-221102104025781994;rev=1"

  body = jsonencode({
    properties = {
      apiType    = "http"
      apiVersion = ""
      format     = "swagger-link-json"
      path       = "test"
      type       = "http"
      value      = "http://conferenceapi.azurewebsites.net/?format=json"
    }
  })

}

resource "azapi_resource" "api2" {
  type      = "Microsoft.ApiManagement/service/apis@2021-08-01"
  parent_id = azapi_resource.service.id
  name      = "acctestAMA-221102104025781994;rev=1"

  body = jsonencode({
    properties = {
      apiRevisionDescription = ""
      apiType                = "http"
      apiVersion             = ""
      apiVersionDescription  = ""
      authenticationSettings = {}
      description            = ""
      displayName            = "Test API"
      path                   = "test"
      protocols = [
        "https",
      ]
      serviceUrl           = ""
      subscriptionRequired = true
      type                 = "http"
    }
  })

}
