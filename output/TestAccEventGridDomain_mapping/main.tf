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
  name      = "acctestRG-221102104837828592"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "domain" {
  type      = "Microsoft.EventGrid/domains@2021-12-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctesteg-221102104837828592"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      autoCreateTopicWithFirstSubscription = true
      autoDeleteTopicWithLastSubscription  = true
      disableLocalAuth                     = false
      inputSchema                          = "CustomEventSchema"
      inputSchemaMapping = {
        inputSchemaMappingType = "Json"
        properties = {
          dataVersion = {
            defaultValue = "1.0"
          }
          eventType = {
            sourceField = "test"
          }
          subject = {
            defaultValue = "DefaultSubject"
          }
          topic = {
            sourceField = "test"
          }
        }
      }
      publicNetworkAccess = "Enabled"
    }
  })
  tags = {}
}
