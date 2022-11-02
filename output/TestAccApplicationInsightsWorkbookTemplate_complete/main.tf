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
  name      = "acctest-rg-221102104215669126"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "workbookTemplate" {
  type      = "Microsoft.Insights/workbookTemplates@2020-11-20"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctest-aiwt-221102104215669126"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      author = "test author"
      galleries = [
        {
          category     = "Failures"
          name         = "test"
          order        = 100
          resourceType = "microsoft.insights/components"
          type         = "tsg"
        },
      ]
      localized = {
        ar = [
          {
            galleries = [
              {
                category     = "Failures"
                name         = "test"
                order        = 100
                resourceType = "microsoft.insights/components"
                type         = "tsg"
              },
            ]
            templateData = {
              $ schema = "https://github.com/Microsoft/Application-Insights-Workbooks/blob/master/schema/workbook.json"
              items = [
                {
                  content = {
                    json = "## New workbook
---

Welcome to your new workbook."
                  }
                  name = "text - 2"
                  type = 1
                },
              ]
              styleSettings = {}
              version       = "Notebook/1.0"
            }
          },
        ]
      }
      priority = 1
      templateData = {
        $ schema = "https://github.com/Microsoft/Application-Insights-Workbooks/blob/master/schema/workbook.json"
        items = [
          {
            content = {
              json = "## New workbook
---

Welcome to your new workbook."
            }
            name = "text - 2"
            type = 1
          },
        ]
        styleSettings = {}
        version       = "Notebook/1.0"
      }
    }
  })
  tags = {
    key = "value"
  }
}
