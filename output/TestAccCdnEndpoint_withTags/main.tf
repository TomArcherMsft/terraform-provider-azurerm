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
  name      = "acctestRG-221102104200696396"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "profile" {
  type      = "Microsoft.Cdn/profiles@2020-09-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestcdnprof221102104200696396"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    sku = {
      name = "Standard_Verizon"
    }
  })
  tags = {}
}

resource "azapi_resource" "endpoint" {
  type      = "Microsoft.Cdn/profiles/endpoints@2020-09-01"
  parent_id = azapi_resource.profile.id
  name      = "acctestcdnend221102104200696396"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      isHttpAllowed  = true
      isHttpsAllowed = true
      origins = [
        {
          name = "acceptanceTestCdnOrigin2"
          properties = {
            hostName  = "www.contoso.com"
            httpPort  = 80
            httpsPort = 443
          }
        },
      ]
      queryStringCachingBehavior = "IgnoreQueryString"
    }
  })
  tags = {
    cost_center = "MSFT"
    environment = "Production"
  }
}
