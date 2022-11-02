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
  name      = "acctestRG-frontdoor-221102104959427242"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "frontDoor" {
  type      = "Microsoft.Network/frontDoors@2020-05-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctest-FD-221102104959427242"
  location  = "Global"
  body = jsonencode({
    properties = {
      backendPools = [
        {
          id   = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-frontdoor-221102104959427242/providers/Microsoft.Network/frontDoors/acctest-FD-221102104959427242/backendPools/acctest-FD-221102104959427242-pool-bing"
          name = "acctest-FD-221102104959427242-pool-bing"
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
              id = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-frontdoor-221102104959427242/providers/Microsoft.Network/frontDoors/acctest-FD-221102104959427242/healthProbeSettings/acctest-FD-221102104959427242-bing-HP"
            }
            loadBalancingSettings = {
              id = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-frontdoor-221102104959427242/providers/Microsoft.Network/frontDoors/acctest-FD-221102104959427242/loadBalancingSettings/acctest-FD-221102104959427242-bing-LB"
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
          id   = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-frontdoor-221102104959427242/providers/Microsoft.Network/frontDoors/acctest-FD-221102104959427242/frontendEndpoints/acctest-FD-221102104959427242-default-FE"
          name = "acctest-FD-221102104959427242-default-FE"
          properties = {
            hostName                    = "acctest-FD-221102104959427242.azurefd.net"
            sessionAffinityEnabledState = "Disabled"
            sessionAffinityTtlSeconds   = 0
          }
        },
      ]
      healthProbeSettings = [
        {
          id   = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-frontdoor-221102104959427242/providers/Microsoft.Network/frontDoors/acctest-FD-221102104959427242/healthProbeSettings/acctest-FD-221102104959427242-bing-HP"
          name = "acctest-FD-221102104959427242-bing-HP"
          properties = {
            enabledState      = "Enabled"
            healthProbeMethod = "HEAD"
            intervalInSeconds = 120
            path              = "/"
            protocol          = "Https"
          }
        },
      ]
      loadBalancingSettings = [
        {
          id   = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-frontdoor-221102104959427242/providers/Microsoft.Network/frontDoors/acctest-FD-221102104959427242/loadBalancingSettings/acctest-FD-221102104959427242-bing-LB"
          name = "acctest-FD-221102104959427242-bing-LB"
          properties = {
            additionalLatencyMilliseconds = 0
            sampleSize                    = 4
            successfulSamplesRequired     = 2
          }
        },
      ]
      routingRules = [
        {
          id   = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-frontdoor-221102104959427242/providers/Microsoft.Network/frontDoors/acctest-FD-221102104959427242/routingRules/acctest-FD-221102104959427242-bing-RR"
          name = "acctest-FD-221102104959427242-bing-RR"
          properties = {
            acceptedProtocols = [
              "Https",
            ]
            enabledState = "Enabled"
            frontendEndpoints = [
              {
                id = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-frontdoor-221102104959427242/providers/Microsoft.Network/frontDoors/acctest-FD-221102104959427242/frontendEndpoints/acctest-FD-221102104959427242-default-FE"
              },
            ]
            patternsToMatch = [
              "/poolBing/*",
            ]
            routeConfiguration = {
              @ odata.type = "#Microsoft.Azure.FrontDoor.Models.FrontdoorForwardingConfiguration"
              backendPool = {
                id = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-frontdoor-221102104959427242/providers/Microsoft.Network/frontDoors/acctest-FD-221102104959427242/backendPools/acctest-FD-221102104959427242-pool-bing"
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
