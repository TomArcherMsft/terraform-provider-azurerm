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
  name      = "acctestRG-221102104623140211"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "service" {
  type      = "Microsoft.ApiManagement/service@2021-08-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestAM-221102104623140211"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      certificates = [
      ]
      customProperties = {
        Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Ssl30                      = "false"
        Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Tls10                      = "false"
        Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Tls11                      = "false"
        Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA = "false"
        Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA = "false"
        Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA   = "false"
        Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA   = "false"
        Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_3DES_EDE_CBC_SHA        = "false"
        Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_128_CBC_SHA         = "false"
        Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_128_CBC_SHA256      = "false"
        Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_128_GCM_SHA256      = "false"
        Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_256_CBC_SHA         = "false"
        Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_256_CBC_SHA256      = "false"
        Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Ssl30                              = "false"
        Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Tls10                              = "false"
        Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Tls11                              = "false"
      }
      disableGateway      = false
      publicNetworkAccess = "Enabled"
      publisherEmail      = "pub1@email.com"
      publisherName       = "pub1"
      virtualNetworkType  = "None"
    }
    sku = {
      capacity = 1
      name     = "Developer"
    }
  })
  tags = {}
}

resource "azapi_resource" "portalsetting" {
  type      = "Microsoft.ApiManagement/service/portalsettings@2021-08-01"
  parent_id = azapi_resource.service.id
  name      = "signin"

  body = jsonencode({
    properties = {
      enabled = false
    }
  })

}
