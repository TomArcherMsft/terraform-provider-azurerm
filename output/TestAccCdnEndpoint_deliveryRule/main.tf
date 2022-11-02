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
  name      = "acctestRG-221102104239484513"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "profile" {
  type      = "Microsoft.Cdn/profiles@2020-09-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestcdnprof221102104239484513"
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
  name      = "acctestcdnend221102104239484513"
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
                name = "UrlRedirect"
                parameters = {
                  @ odata.type        = "Microsoft.Azure.Cdn.Models.DeliveryRuleUrlRedirectActionParameters"
                  destinationProtocol = "Https"
                  redirectType        = "Found"
                }
              },
            ]
            conditions = [
              {
                name = "Cookies"
                parameters = {
                  @ odata.type = "Microsoft.Azure.Cdn.Models.DeliveryRuleCookiesConditionParameters"
                  matchValues = [
                    "windows",
                  ]
                  negateCondition = false
                  operator        = "Contains"
                  selector        = "abc"
                  transforms = [
                    "Lowercase",
                  ]
                }
              },
              {
                name = "RequestScheme"
                parameters = {
                  @ odata.type = "Microsoft.Azure.Cdn.Models.DeliveryRuleRequestSchemeConditionParameters"
                  matchValues = [
                    "HTTP",
                  ]
                  negateCondition = false
                  operator        = "Equal"
                }
              },
            ]
            name  = "http2https"
            order = 1
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
