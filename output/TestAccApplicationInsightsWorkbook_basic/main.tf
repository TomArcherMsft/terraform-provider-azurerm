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
  name      = "acctest-rg-221102104142040708"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "workbook" {
  type      = "Microsoft.Insights/workbooks@2022-04-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "be1ad266-d329-4454-b693-8287e4d3b35d"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    kind = "shared"
    properties = {
      category       = "workbook"
      displayName    = "acctest-amw-221102104142040708"
      serializedData = "{" fallbackResourceIds ":[" Azure Monitor "]," isLocked ":false," items ":[{" content ":{" json ":" Test2022 "}," name ":" text - 0 "," type ":1}]," version ":" Notebook / 1.0 "}"
      sourceId       = "azure monitor"
    }
  })
  tags = null
}
