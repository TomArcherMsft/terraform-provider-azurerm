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
  name      = "acctestrg-cdn-afdx-221102104434168920"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "profile" {
  type      = "Microsoft.Cdn/profiles@2021-06-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctest-cdnfdprofile-221102104434168920"
  location  = "global"
  body = jsonencode({
    properties = {
      originResponseTimeoutSeconds = 120
    }
    sku = {
      name = "Standard_AzureFrontDoor"
    }
  })
  tags = {}
}

resource "azapi_resource" "originGroup" {
  type      = "Microsoft.Cdn/profiles/originGroups@2021-06-01"
  parent_id = azapi_resource.profile.id
  name      = "acctest-cdnfd-group-221102104434168920"

  body = jsonencode({
    properties = {
      loadBalancingSettings = {
        additionalLatencyInMilliseconds = 0
        sampleSize                      = 16
        successfulSamplesRequired       = 3
      }
      sessionAffinityState                                  = "Enabled"
      trafficRestorationTimeToHealedOrNewEndpointsInMinutes = 10
    }
  })

}

resource "azapi_resource" "origin" {
  type      = "Microsoft.Cdn/profiles/originGroups/origins@2021-06-01"
  parent_id = azapi_resource.originGroup.id
  name      = "acctest-cdnfdorigin-221102104434168920"

  body = jsonencode({
    properties = {
      enabledState                = "Enabled"
      enforceCertificateNameCheck = false
      hostName                    = "contoso.com"
      httpPort                    = 80
      httpsPort                   = 443
      originHostHeader            = "www.contoso.com"
      priority                    = 1
      weight                      = 1
    }
  })

}
