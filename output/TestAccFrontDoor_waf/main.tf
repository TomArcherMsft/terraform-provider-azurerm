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
  name      = "acctestRG-frontdoor-221102104957025971"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "frontDoorWebApplicationFirewallPolicy" {
  type      = "Microsoft.Network/frontDoorWebApplicationFirewallPolicies@2020-04-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestwafp221102104957025971"
  location  = "global"
  body = jsonencode({
    properties = {
      policySettings = {
        enabledState = "Enabled"
        mode         = "Prevention"
      }
    }
  })
  tags = {}
}

resource "azapi_resource" "frontDoor" {
  type      = "Microsoft.Network/frontDoors@2020-05-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctest-FD-221102104957025971"
  location  = "Global"
  body = jsonencode({
    properties = {
      backendPools = [
        {
          id   = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-frontdoor-221102104957025971/providers/Microsoft.Network/frontDoors/acctest-FD-221102104957025971/backendPools/backend-bing"
          name = "backend-bing"
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
              id = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-frontdoor-221102104957025971/providers/Microsoft.Network/frontDoors/acctest-FD-221102104957025971/healthProbeSettings/health-probe"
            }
            loadBalancingSettings = {
              id = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-frontdoor-221102104957025971/providers/Microsoft.Network/frontDoors/acctest-FD-221102104957025971/loadBalancingSettings/load-balancing-setting"
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
          id   = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-frontdoor-221102104957025971/providers/Microsoft.Network/frontDoors/acctest-FD-221102104957025971/frontendEndpoints/frontend-endpoint"
          name = "frontend-endpoint"
          properties = {
            hostName                    = "acctest-FD-221102104957025971.azurefd.net"
            sessionAffinityEnabledState = "Disabled"
            sessionAffinityTtlSeconds   = 0
            webApplicationFirewallPolicyLink = {
              id = azapi_resource.frontDoorWebApplicationFirewallPolicy.id
            }
          }
        },
      ]
      healthProbeSettings = [
        {
          id   = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-frontdoor-221102104957025971/providers/Microsoft.Network/frontDoors/acctest-FD-221102104957025971/healthProbeSettings/health-probe"
          name = "health-probe"
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
          id   = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-frontdoor-221102104957025971/providers/Microsoft.Network/frontDoors/acctest-FD-221102104957025971/loadBalancingSettings/load-balancing-setting"
          name = "load-balancing-setting"
          properties = {
            additionalLatencyMilliseconds = 0
            sampleSize                    = 4
            successfulSamplesRequired     = 2
          }
        },
      ]
      routingRules = [
        {
          id   = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-frontdoor-221102104957025971/providers/Microsoft.Network/frontDoors/acctest-FD-221102104957025971/routingRules/routing-rule"
          name = "routing-rule"
          properties = {
            acceptedProtocols = [
              "Http",
              "Https",
            ]
            enabledState = "Enabled"
            frontendEndpoints = [
              {
                id = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-frontdoor-221102104957025971/providers/Microsoft.Network/frontDoors/acctest-FD-221102104957025971/frontendEndpoints/frontend-endpoint"
              },
            ]
            patternsToMatch = [
              "/*",
            ]
            routeConfiguration = {
              @ odata.type = "#Microsoft.Azure.FrontDoor.Models.FrontdoorForwardingConfiguration"
              backendPool = {
                id = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-frontdoor-221102104957025971/providers/Microsoft.Network/frontDoors/acctest-FD-221102104957025971/backendPools/backend-bing"
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
