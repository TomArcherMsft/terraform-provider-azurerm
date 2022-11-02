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
  name      = "acctestRG-221102104256576020"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "profile" {
  type      = "Microsoft.Cdn/profiles@2020-09-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestcdnprof221102104256576020"
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
  name      = "acctestcdnend221102104256576020"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      deliveryPolicy = {
        description = ""
        rules = [
          {
            actions = [
              {
                name = "ModifyResponseHeader"
                parameters = {
                  @ odata.type = "Microsoft.Azure.Cdn.Models.DeliveryRuleHeaderActionParameters"
                  headerAction = "Delete"
                  headerName   = "Content-Language"
                }
              },
            ]
            conditions = [
              {
                name = "Cookies"
                parameters = {
                  @ odata.type = "Microsoft.Azure.Cdn.Models.DeliveryRuleCookiesConditionParameters"
                  matchValues = [
                  ]
                  negateCondition = false
                  operator        = "Any"
                  selector        = "abc"
                }
              },
            ]
            name  = "cookieCondition"
            order = 1
          },
          {
            actions = [
              {
                name = "ModifyResponseHeader"
                parameters = {
                  @ odata.type = "Microsoft.Azure.Cdn.Models.DeliveryRuleHeaderActionParameters"
                  headerAction = "Delete"
                  headerName   = "Content-Language"
                }
              },
            ]
            conditions = [
              {
                name = "PostArgs"
                parameters = {
                  @ odata.type = "Microsoft.Azure.Cdn.Models.DeliveryRulePostArgsConditionParameters"
                  matchValues = [
                  ]
                  negateCondition = false
                  operator        = "Any"
                  selector        = "abc"
                }
              },
            ]
            name  = "postArg"
            order = 2
          },
          {
            actions = [
              {
                name = "ModifyResponseHeader"
                parameters = {
                  @ odata.type = "Microsoft.Azure.Cdn.Models.DeliveryRuleHeaderActionParameters"
                  headerAction = "Delete"
                  headerName   = "Content-Language"
                }
              },
            ]
            conditions = [
              {
                name = "QueryString"
                parameters = {
                  @ odata.type = "Microsoft.Azure.Cdn.Models.DeliveryRuleQueryStringConditionParameters"
                  matchValues = [
                  ]
                  negateCondition = false
                  operator        = "Any"
                }
              },
            ]
            name  = "queryString"
            order = 3
          },
          {
            actions = [
              {
                name = "ModifyResponseHeader"
                parameters = {
                  @ odata.type = "Microsoft.Azure.Cdn.Models.DeliveryRuleHeaderActionParameters"
                  headerAction = "Delete"
                  headerName   = "Content-Language"
                }
              },
            ]
            conditions = [
              {
                name = "RemoteAddress"
                parameters = {
                  @ odata.type = "Microsoft.Azure.Cdn.Models.DeliveryRuleRemoteAddressConditionParameters"
                  matchValues = [
                  ]
                  negateCondition = false
                  operator        = "Any"
                }
              },
            ]
            name  = "remoteAddress"
            order = 4
          },
          {
            actions = [
              {
                name = "ModifyResponseHeader"
                parameters = {
                  @ odata.type = "Microsoft.Azure.Cdn.Models.DeliveryRuleHeaderActionParameters"
                  headerAction = "Delete"
                  headerName   = "Content-Language"
                }
              },
            ]
            conditions = [
              {
                name = "RequestBody"
                parameters = {
                  @ odata.type = "Microsoft.Azure.Cdn.Models.DeliveryRuleRequestBodyConditionParameters"
                  matchValues = [
                  ]
                  negateCondition = false
                  operator        = "Any"
                }
              },
            ]
            name  = "requestBody"
            order = 5
          },
          {
            actions = [
              {
                name = "ModifyResponseHeader"
                parameters = {
                  @ odata.type = "Microsoft.Azure.Cdn.Models.DeliveryRuleHeaderActionParameters"
                  headerAction = "Delete"
                  headerName   = "Content-Language"
                }
              },
            ]
            conditions = [
              {
                name = "RequestHeader"
                parameters = {
                  @ odata.type = "Microsoft.Azure.Cdn.Models.DeliveryRuleRequestHeaderConditionParameters"
                  matchValues = [
                  ]
                  negateCondition = false
                  operator        = "Any"
                  selector        = "abc"
                }
              },
            ]
            name  = "requestHeader"
            order = 6
          },
          {
            actions = [
              {
                name = "ModifyResponseHeader"
                parameters = {
                  @ odata.type = "Microsoft.Azure.Cdn.Models.DeliveryRuleHeaderActionParameters"
                  headerAction = "Delete"
                  headerName   = "Content-Language"
                }
              },
            ]
            conditions = [
              {
                name = "RequestUri"
                parameters = {
                  @ odata.type = "Microsoft.Azure.Cdn.Models.DeliveryRuleRequestUriConditionParameters"
                  matchValues = [
                  ]
                  negateCondition = false
                  operator        = "Any"
                }
              },
            ]
            name  = "requestUri"
            order = 7
          },
          {
            actions = [
              {
                name = "ModifyResponseHeader"
                parameters = {
                  @ odata.type = "Microsoft.Azure.Cdn.Models.DeliveryRuleHeaderActionParameters"
                  headerAction = "Delete"
                  headerName   = "Content-Language"
                }
              },
            ]
            conditions = [
              {
                name = "UrlFileExtension"
                parameters = {
                  @ odata.type = "Microsoft.Azure.Cdn.Models.DeliveryRuleUrlFileExtensionMatchConditionParameters"
                  matchValues = [
                  ]
                  negateCondition = false
                  operator        = "Any"
                }
              },
            ]
            name  = "uriFileExtension"
            order = 8
          },
          {
            actions = [
              {
                name = "ModifyResponseHeader"
                parameters = {
                  @ odata.type = "Microsoft.Azure.Cdn.Models.DeliveryRuleHeaderActionParameters"
                  headerAction = "Delete"
                  headerName   = "Content-Language"
                }
              },
            ]
            conditions = [
              {
                name = "UrlFileName"
                parameters = {
                  @ odata.type = "Microsoft.Azure.Cdn.Models.DeliveryRuleUrlFilenameConditionParameters"
                  matchValues = [
                  ]
                  negateCondition = false
                  operator        = "Any"
                }
              },
            ]
            name  = "uriFileName"
            order = 9
          },
          {
            actions = [
              {
                name = "ModifyResponseHeader"
                parameters = {
                  @ odata.type = "Microsoft.Azure.Cdn.Models.DeliveryRuleHeaderActionParameters"
                  headerAction = "Delete"
                  headerName   = "Content-Language"
                }
              },
            ]
            conditions = [
              {
                name = "UrlPath"
                parameters = {
                  @ odata.type = "Microsoft.Azure.Cdn.Models.DeliveryRuleUrlPathMatchConditionParameters"
                  matchValues = [
                  ]
                  negateCondition = false
                  operator        = "Any"
                }
              },
            ]
            name  = "uriPath"
            order = 10
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
