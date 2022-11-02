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
  name      = "acctestRG-vdesktophp-221102104727582013"
  location  = "eastus2"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "hostPool" {
  type      = "Microsoft.DesktopVirtualization/hostPools@2022-02-10-preview"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestHPyl377"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      agentUpdate = {
        maintenanceWindowTimeZone = "UTC"
        maintenanceWindows = [
          {
            dayOfWeek = "Saturday"
            hour      = 2
          },
        ]
        type                    = "Scheduled"
        useSessionHostLocalTime = false
      }
      customRdpProperty             = ""
      description                   = ""
      friendlyName                  = ""
      hostPoolType                  = "Pooled"
      loadBalancerType              = "BreadthFirst"
      maxSessionLimit               = 999999
      personalDesktopAssignmentType = ""
      preferredAppGroupType         = "Desktop"
      startVMOnConnect              = false
      validationEnvironment         = true
    }
  })
  tags = {}
}
