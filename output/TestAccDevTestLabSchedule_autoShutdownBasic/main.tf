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
  name      = "acctestRG-221102104730158944"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "lab" {
  type      = "Microsoft.DevTestLab/labs@2018-09-15"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctdtl-221102104730158944"
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
  name      = "LabVmsShutdown"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      dailyRecurrence = {
        time = "0100"
      }
      notificationSettings = {
        status        = "Disabled"
        timeInMinutes = 0
        webhookUrl    = ""
      }
      status     = "Disabled"
      taskType   = "LabVmsShutdownTask"
      timeZoneId = "India Standard Time"
    }
  })
  tags = {
    environment = "Production"
  }
}
