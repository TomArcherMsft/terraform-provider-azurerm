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
  name      = "testaccRG-221102104924834684"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "frontDoorWebApplicationFirewallPolicy" {
  type      = "Microsoft.Network/frontDoorWebApplicationFirewallPolicies@2020-04-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "testAccFrontDoorWAF221102104924834684"
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
