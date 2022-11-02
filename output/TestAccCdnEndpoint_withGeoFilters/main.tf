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
  name      = "acctestRG-221102104217713454"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "profile" {
  type      = "Microsoft.Cdn/profiles@2020-09-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestcdnprof221102104217713454"
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
  name      = "acctestcdnend221102104217713454"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      geoFilters = [
        {
          action = "Allow"
          countryCodes = [
            "GB",
          ]
          relativePath = "/some-example-endpoint"
        },
        {
          action = "Block"
          countryCodes = [
            "US",
          ]
          relativePath = "/some-other-endpoint"
        },
      ]
      isHttpAllowed  = false
      isHttpsAllowed = true
      originPath     = "/origin-path"
      origins = [
        {
          name = "acceptanceTestCdnOrigin1"
          properties = {
            hostName  = "www.contoso.com"
            httpPort  = 80
            httpsPort = 443
          }
        },
      ]
      probePath                  = "/origin-path/probe"
      queryStringCachingBehavior = "IgnoreQueryString"
    }
  })
  tags = {}
}
