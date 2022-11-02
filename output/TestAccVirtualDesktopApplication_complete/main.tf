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
  name      = "acctestRG-vdesktop-221102104702020918"
  location  = "eastus2"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "hostPool" {
  type      = "Microsoft.DesktopVirtualization/hostPools@2022-02-10-preview"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestHP"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      customRdpProperty             = ""
      description                   = "Acceptance Test: A host pool"
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

resource "azapi_resource" "applicationGroup" {
  type      = "Microsoft.DesktopVirtualization/applicationGroups@2022-02-10-preview"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestAG22110218"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      applicationGroupType = "RemoteApp"
      description          = "Acceptance Test: An application group"
      friendlyName         = "TestAppGroup"
      hostPoolArmPath      = azapi_resource.hostPool.id
    }
  })
  tags = {
    Purpose = "Acceptance-Testing"
  }
}

resource "azapi_resource" "application" {
  type      = "Microsoft.DesktopVirtualization/applicationGroups/applications@2022-02-10-preview"
  parent_id = azapi_resource.applicationGroup.id
  name      = "acctestAG22110218"

  body = jsonencode({
    properties = {
      commandLineArguments = "--incognito"
      commandLineSetting   = "DoNotAllow"
      description          = "Chromium based web browser"
      filePath             = "C:\Program Files\Google\Chrome\Application\chrome.exe"
      friendlyName         = "Google Chrome"
      iconIndex            = 1
      iconPath             = "C:\Program Files\Google\Chrome\Application\chrome.exe"
      showInPortal         = false
    }
  })

}
