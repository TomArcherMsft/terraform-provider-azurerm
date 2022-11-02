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
  name      = "acctestRG-221102104346844311"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "service" {
  type      = "Microsoft.ApiManagement/service@2021-08-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestAM-221102104346844311"
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

resource "azapi_resource" "authorizationServer" {
  type      = "Microsoft.ApiManagement/service/authorizationServers@2021-08-01"
  parent_id = azapi_resource.service.id
  name      = "acctestauthsrv-221102104346844311"

  body = jsonencode({
    properties = {
      authorizationEndpoint = "https://azacceptance.hashicorptest.com/client/authorize"
      authorizationMethods = [
        "GET",
        "POST",
      ]
      bearerTokenSendingMethods = [
        "authorizationHeader",
      ]
      clientAuthenticationMethod = [
        "Basic",
      ]
      clientId                   = "42424242-4242-4242-4242-424242424242"
      clientRegistrationEndpoint = "https://azacceptance.hashicorptest.com/client/register"
      clientSecret               = "n1n3-m0re-s3a5on5-m0r1y"
      defaultScope               = "read write"
      description                = "This is a test description"
      displayName                = "Test Group"
      grantTypes = [
        "authorizationCode",
      ]
      resourceOwnerPassword = "C-193P"
      resourceOwnerUsername = "rick"
      supportState          = true
      tokenBodyParameters = [
        {
          name  = "test"
          value = "token-body-parameter"
        },
      ]
      tokenEndpoint = "https://azacceptance.hashicorptest.com/client/token"
    }
  })

}
