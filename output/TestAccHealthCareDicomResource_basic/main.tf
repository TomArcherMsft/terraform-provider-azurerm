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
  name      = "acctestRG-dicom-221102104926427793"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "workspace" {
  type      = "Microsoft.HealthcareApis/workspaces@2021-11-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "wk2211021093"
  location  = azapi_resource.resourceGroup.location
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "dicomservice" {
  type      = "Microsoft.HealthcareApis/workspaces/dicomservices@2021-11-01"
  parent_id = azapi_resource.workspace.id
  name      = "dicom2211021093"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      publicNetworkAccess = "Enabled"
    }
  })
  tags = {}
}
