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
  name      = "acctestRG-221102104233833476"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "profile" {
  type      = "Microsoft.Cdn/profiles@2020-09-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestcdnprof221102104233833476"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    sku = {
      name = "Standard_Microsoft"
    }
  })
  tags = {}
}

resource "azapi_resource" "endpoint" {
  type      = "Microsoft.Cdn/profiles/endpoints@2020-09-01"
  parent_id = azapi_resource.profile.id
  name      = "acctestcdnend221102104233833476"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      deliveryPolicy = {
        description = ""
        rules = [
          {
            actions = [
              {
                name = "CacheExpiration"
                parameters = {
                  @ odata.type  = "Microsoft.Azure.Cdn.Models.DeliveryRuleCacheExpirationActionParameters"
                  cacheBehavior = "Override"
                  cacheDuration = "5.04:44:23"
                  cacheType     = "All"
                }
              },
              {
                name = "CacheKeyQueryString"
                parameters = {
                  @ odata.type        = "Microsoft.Azure.Cdn.Models.DeliveryRuleCacheKeyQueryStringBehaviorActionParameters"
                  queryParameters     = "test"
                  queryStringBehavior = "IncludeAll"
                }
              },
              {
                name = "ModifyRequestHeader"
                parameters = {
                  @ odata.type = "Microsoft.Azure.Cdn.Models.DeliveryRuleHeaderActionParameters"
                  headerAction = "Append"
                  headerName   = "www.contoso1.com"
                  value        = "test value"
                }
              },
              {
                name = "UrlRedirect"
                parameters = {
                  @ odata.type        = "Microsoft.Azure.Cdn.Models.DeliveryRuleUrlRedirectActionParameters"
                  customFragment      = "5fgdfg"
                  customHostname      = "www.contoso.com"
                  customPath          = "/article.aspx"
                  customQueryString   = "id={var_uri_path_1}&title={var_uri_path_2}"
                  destinationProtocol = "Https"
                  redirectType        = "Found"
                }
              },
            ]
            name  = "Global"
            order = 0
          },
        ]
      }
      isHttpAllowed    = true
      isHttpsAllowed   = true
      originHostHeader = "www.contoso.com"
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
      queryStringCachingBehavior = "IgnoreQueryString"
    }
  })
  tags = {}
}
