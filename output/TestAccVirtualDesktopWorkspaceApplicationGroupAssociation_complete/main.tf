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
  name      = "acctestRG-vdesktop-221102104756416388"
  location  = "eastus2"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "hostPool2" {
  type      = "Microsoft.DesktopVirtualization/hostPools@2022-02-10-preview"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestHP2nd22110288"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      customRdpProperty             = ""
      description                   = ""
      friendlyName                  = ""
      hostPoolType                  = "Personal"
      loadBalancerType              = "Persistent"
      maxSessionLimit               = 999999
      personalDesktopAssignmentType = "Automatic"
      preferredAppGroupType         = "Desktop"
      startVMOnConnect              = false
      validationEnvironment         = false
    }
  })
  tags = {}
}

resource "azapi_resource" "applicationGroup2" {
  type      = "Microsoft.DesktopVirtualization/applicationGroups@2022-02-10-preview"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestAG2nd22110288"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      applicationGroupType = "Desktop"
      description          = "Acceptance Test: An application group"
      friendlyName         = "TestAppGroup"
      hostPoolArmPath      = azapi_resource.hostPool2.id
    }
  })
  tags = {}
}
