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
  name      = "acctestRG-221102104734791727"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "lab" {
  type      = "Microsoft.DevTestLab/labs@2018-09-15"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctdtl-221102104734791727"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      labStorageType = "Premium"
    }
  })
  tags = {}
}

resource "azapi_resource" "schedule" {
  type      = "Microsoft.DevTestLab/labs/schedules@2018-09-15"
  parent_id = azapi_resource.lab.id
  name      = "LabVmAutoStart"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      notificationSettings = {
        status        = "Disabled"
        timeInMinutes = 0
        webhookUrl    = ""
      }
      status     = "Disabled"
      taskType   = "LabVmsStartupTask"
      timeZoneId = "India Standard Time"
      weeklyRecurrence = {
        time = "1100"
        weekdays = [
          "Monday",
          "Tuesday",
        ]
      }
    }
  })
  tags = {
    environment = "Production"
  }
}
