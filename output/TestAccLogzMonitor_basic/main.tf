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
  name      = "acctest-logz-221102105304376786"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "monitor" {
  type      = "Microsoft.Logz/monitors@2020-10-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctest-lm-221102105304376786"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      logzOrganizationProperties = {}
      monitoringStatus           = "Enabled"
      planData = {
        billingCycle  = "MONTHLY"
        effectiveDate = "2022-11-02T17:53:04+08:00"
        planDetails   = "100gb14days"
        usageType     = "COMMITTED"
      }
      userInfo = {
        emailAddress = "9d186100-1e0f-4b4a-bb10-753d2d52b750@example.com"
        firstName    = "first"
        lastName     = "last"
        phoneNumber  = "123456"
      }
    }
  })
  tags = {}
}
