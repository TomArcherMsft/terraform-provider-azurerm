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
  name      = "acctestRG-frontdoor-221102104949309471"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "frontDoor" {
  type      = "Microsoft.Network/frontDoors@2020-05-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctest-FD-221102104949309471"
  location  = "Global"
  body = jsonencode({
    properties = {
      backendPools = [
        {
          id   = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-frontdoor-221102104949309471/providers/Microsoft.Network/frontDoors/acctest-FD-221102104949309471/backendPools/acctest-FD-221102104949309471-pool-bing"
          name = "acctest-FD-221102104949309471-pool-bing"
          properties = {
            backends = [
              {
                address           = "bing.com"
                backendHostHeader = "bing.com"
                enabledState      = "Enabled"
                httpPort          = 80
                httpsPort         = 443
                priority          = 1
                weight            = 75
              },
            ]
            healthProbeSettings = {
              id = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-frontdoor-221102104949309471/providers/Microsoft.Network/frontDoors/acctest-FD-221102104949309471/healthProbeSettings/acctest-FD-221102104949309471-bing-HP"
            }
            loadBalancingSettings = {
              id = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-frontdoor-221102104949309471/providers/Microsoft.Network/frontDoors/acctest-FD-221102104949309471/loadBalancingSettings/acctest-FD-221102104949309471-bing-LB"
            }
          }
        },
        {
          id   = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-frontdoor-221102104949309471/providers/Microsoft.Network/frontDoors/acctest-FD-221102104949309471/backendPools/acctest-FD-221102104949309471-pool-google"
          name = "acctest-FD-221102104949309471-pool-google"
          properties = {
            backends = [
              {
                address           = "google.com"
                backendHostHeader = "google.com"
                enabledState      = "Enabled"
                httpPort          = 80
                httpsPort         = 443
                priority          = 1
                weight            = 75
              },
            ]
            healthProbeSettings = {
              id = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-frontdoor-221102104949309471/providers/Microsoft.Network/frontDoors/acctest-FD-221102104949309471/healthProbeSettings/acctest-FD-221102104949309471-google-HP"
            }
            loadBalancingSettings = {
              id = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-frontdoor-221102104949309471/providers/Microsoft.Network/frontDoors/acctest-FD-221102104949309471/loadBalancingSettings/acctest-FD-221102104949309471-google-LB"
            }
          }
        },
      ]
      backendPoolsSettings = {
        enforceCertificateNameCheck = "Disabled"
        sendRecvTimeoutSeconds      = 60
      }
      enabledState = "Enabled"
      friendlyName = ""
      frontendEndpoints = [
        {
          id   = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-frontdoor-221102104949309471/providers/Microsoft.Network/frontDoors/acctest-FD-221102104949309471/frontendEndpoints/acctest-FD-221102104949309471-default-FE"
          name = "acctest-FD-221102104949309471-default-FE"
          properties = {
            hostName                    = "acctest-FD-221102104949309471.azurefd.net"
            sessionAffinityEnabledState = "Disabled"
            sessionAffinityTtlSeconds   = 0
          }
        },
      ]
      healthProbeSettings = [
        {
          id   = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-frontdoor-221102104949309471/providers/Microsoft.Network/frontDoors/acctest-FD-221102104949309471/healthProbeSettings/acctest-FD-221102104949309471-bing-HP"
          name = "acctest-FD-221102104949309471-bing-HP"
          properties = {
            enabledState      = "Enabled"
            healthProbeMethod = "HEAD"
            intervalInSeconds = 120
            path              = "/"
            protocol          = "Https"
          }
        },
        {
          id   = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-frontdoor-221102104949309471/providers/Microsoft.Network/frontDoors/acctest-FD-221102104949309471/healthProbeSettings/acctest-FD-221102104949309471-google-HP"
          name = "acctest-FD-221102104949309471-google-HP"
          properties = {
            enabledState      = "Enabled"
            healthProbeMethod = "GET"
            intervalInSeconds = 120
            path              = "/"
            protocol          = "Https"
          }
        },
      ]
      loadBalancingSettings = [
        {
          id   = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-frontdoor-221102104949309471/providers/Microsoft.Network/frontDoors/acctest-FD-221102104949309471/loadBalancingSettings/acctest-FD-221102104949309471-bing-LB"
          name = "acctest-FD-221102104949309471-bing-LB"
          properties = {
            additionalLatencyMilliseconds = 0
            sampleSize                    = 4
            successfulSamplesRequired     = 2
          }
        },
        {
          id   = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-frontdoor-221102104949309471/providers/Microsoft.Network/frontDoors/acctest-FD-221102104949309471/loadBalancingSettings/acctest-FD-221102104949309471-google-LB"
          name = "acctest-FD-221102104949309471-google-LB"
          properties = {
            additionalLatencyMilliseconds = 0
            sampleSize                    = 4
            successfulSamplesRequired     = 2
          }
        },
      ]
      routingRules = [
        {
          id   = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-frontdoor-221102104949309471/providers/Microsoft.Network/frontDoors/acctest-FD-221102104949309471/routingRules/acctest-FD-221102104949309471-bing-RR"
          name = "acctest-FD-221102104949309471-bing-RR"
          properties = {
            acceptedProtocols = [
              "Https",
            ]
            enabledState = "Enabled"
            frontendEndpoints = [
              {
                id = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-frontdoor-221102104949309471/providers/Microsoft.Network/frontDoors/acctest-FD-221102104949309471/frontendEndpoints/acctest-FD-221102104949309471-default-FE"
              },
            ]
            patternsToMatch = [
              "/poolBing/*",
            ]
            routeConfiguration = {
              @ odata.type = "#Microsoft.Azure.FrontDoor.Models.FrontdoorForwardingConfiguration"
              backendPool = {
                id = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-frontdoor-221102104949309471/providers/Microsoft.Network/frontDoors/acctest-FD-221102104949309471/backendPools/acctest-FD-221102104949309471-pool-bing"
              }
              cacheConfiguration = {
                dynamicCompression           = "Disabled"
                queryParameterStripDirective = "StripAll"
                queryParameters              = ""
              }
              forwardingProtocol = "MatchRequest"
            }
          }
        },
        {
          id   = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-frontdoor-221102104949309471/providers/Microsoft.Network/frontDoors/acctest-FD-221102104949309471/routingRules/acctest-FD-221102104949309471-google-RR"
          name = "acctest-FD-221102104949309471-google-RR"
          properties = {
            acceptedProtocols = [
              "Https",
            ]
            enabledState = "Enabled"
            frontendEndpoints = [
              {
                id = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-frontdoor-221102104949309471/providers/Microsoft.Network/frontDoors/acctest-FD-221102104949309471/frontendEndpoints/acctest-FD-221102104949309471-default-FE"
              },
            ]
            patternsToMatch = [
              "/poolGoogle/*",
            ]
            routeConfiguration = {
              @ odata.type = "#Microsoft.Azure.FrontDoor.Models.FrontdoorForwardingConfiguration"
              backendPool = {
                id = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-frontdoor-221102104949309471/providers/Microsoft.Network/frontDoors/acctest-FD-221102104949309471/backendPools/acctest-FD-221102104949309471-pool-google"
              }
              cacheConfiguration = {
                dynamicCompression           = "Disabled"
                queryParameterStripDirective = "StripAll"
                queryParameters              = ""
              }
              forwardingProtocol = "MatchRequest"
            }
          }
        },
      ]
    }
  })
  tags = {}
}
