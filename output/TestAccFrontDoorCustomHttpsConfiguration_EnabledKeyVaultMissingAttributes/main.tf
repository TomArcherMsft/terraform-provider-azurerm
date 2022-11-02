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
  name      = "acctestRG-frontdoor-221102104922109958"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "frontDoor" {
  type      = "Microsoft.Network/frontDoors@2020-05-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctest-FD-221102104922109958"
  location  = "Global"
  body = jsonencode({
    properties = {
      backendPools = [
        {
          id   = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-frontdoor-221102104922109958/providers/Microsoft.Network/frontDoors/acctest-FD-221102104922109958/backendPools/backend-bing-custom"
          name = "backend-bing-custom"
          properties = {
            backends = [
              {
                address           = "www.bing.com"
                backendHostHeader = "www.bing.com"
                enabledState      = "Enabled"
                httpPort          = 80
                httpsPort         = 443
                priority          = 1
                weight            = 50
              },
            ]
            healthProbeSettings = {
              id = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-frontdoor-221102104922109958/providers/Microsoft.Network/frontDoors/acctest-FD-221102104922109958/healthProbeSettings/health-probe-custom"
            }
            loadBalancingSettings = {
              id = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-frontdoor-221102104922109958/providers/Microsoft.Network/frontDoors/acctest-FD-221102104922109958/loadBalancingSettings/load-balancing-setting-custom"
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
          id   = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-frontdoor-221102104922109958/providers/Microsoft.Network/frontDoors/acctest-FD-221102104922109958/frontendEndpoints/frontend-endpoint-custom"
          name = "frontend-endpoint-custom"
          properties = {
            hostName                    = "acctest-FD-221102104922109958.azurefd.net"
            sessionAffinityEnabledState = "Disabled"
            sessionAffinityTtlSeconds   = 0
          }
        },
      ]
      healthProbeSettings = [
        {
          id   = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-frontdoor-221102104922109958/providers/Microsoft.Network/frontDoors/acctest-FD-221102104922109958/healthProbeSettings/health-probe-custom"
          name = "health-probe-custom"
          properties = {
            enabledState      = "Enabled"
            healthProbeMethod = "GET"
            intervalInSeconds = 120
            path              = "/"
            protocol          = "Http"
          }
        },
      ]
      loadBalancingSettings = [
        {
          id   = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-frontdoor-221102104922109958/providers/Microsoft.Network/frontDoors/acctest-FD-221102104922109958/loadBalancingSettings/load-balancing-setting-custom"
          name = "load-balancing-setting-custom"
          properties = {
            additionalLatencyMilliseconds = 0
            sampleSize                    = 4
            successfulSamplesRequired     = 2
          }
        },
      ]
      routingRules = [
        {
          id   = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-frontdoor-221102104922109958/providers/Microsoft.Network/frontDoors/acctest-FD-221102104922109958/routingRules/routing-rule"
          name = "routing-rule"
          properties = {
            acceptedProtocols = [
              "Http",
              "Https",
            ]
            enabledState = "Enabled"
            frontendEndpoints = [
              {
                id = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-frontdoor-221102104922109958/providers/Microsoft.Network/frontDoors/acctest-FD-221102104922109958/frontendEndpoints/frontend-endpoint-custom"
              },
            ]
            patternsToMatch = [
              "/*",
            ]
            routeConfiguration = {
              @ odata.type = "#Microsoft.Azure.FrontDoor.Models.FrontdoorForwardingConfiguration"
              backendPool = {
                id = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-frontdoor-221102104922109958/providers/Microsoft.Network/frontDoors/acctest-FD-221102104922109958/backendPools/backend-bing-custom"
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
