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
  name      = "acctestRG-healthcareapi-221102105129964671"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "workspace" {
  type      = "Microsoft.HealthcareApis/workspaces@2021-11-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acc221102105129964671"
  location  = azapi_resource.resourceGroup.location
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "fhirservice" {
  type      = "Microsoft.HealthcareApis/workspaces/fhirservices@2021-11-01"
  parent_id = azapi_resource.workspace.id
  name      = "fhir221102105129964671"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    kind = "fhir-R4"
    properties = {
      acrConfiguration = {}
      authenticationConfiguration = {
        audience          = "https://acctestfhir.fhir.azurehealthcareapis.com"
        authority         = "https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47"
        smartProxyEnabled = false
      }
      corsConfiguration = {
        allowCredentials = false
        headers = [
        ]
        methods = [
        ]
        origins = [
        ]
      }
    }
  })
  tags = {}
}
