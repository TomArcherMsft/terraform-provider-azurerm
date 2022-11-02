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
  name      = "acctestRG-221102104210674839"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "service" {
  type      = "Microsoft.ApiManagement/service@2021-08-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestAM-221102104210674839"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      certificates = [
      ]
      customProperties = {
        Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Ssl30 = "false"
        Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Tls10 = "false"
        Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Tls11 = "false"
        Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Tls10         = "false"
        Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Tls11         = "false"
      }
      disableGateway      = false
      publicNetworkAccess = "Enabled"
      publisherEmail      = "pub1@email.com"
      publisherName       = "pub1"
      virtualNetworkType  = "None"
    }
    sku = {
      capacity = 0
      name     = "Consumption"
    }
  })
  tags = {}
}

resource "azapi_resource" "api" {
  type      = "Microsoft.ApiManagement/service/apis@2021-08-01"
  parent_id = azapi_resource.service.id
  name      = "acctestapi-221102104210674839;rev=1"

  body = jsonencode({
    properties = {
      apiType    = "http"
      apiVersion = ""
      format     = "swagger-json"
      path       = "api1"
      type       = "http"
      value      = "{
  " swagger ": " 2.0 ",
  " info ": {
    " description ": " This is a simple API ",
    " version ": " 1.0.2 ",
    " title ": " tftest2 ",
    " contact ": {
      " email ": " you @ your-company.com "
    },
    " license ": {
      " name ": " Apache 2.0 ",
      " url ": " http : //www.apache.org/licenses/LICENSE-2.0.html"
    }
    },
    "tags" : [
      {
        "name" : "admins",
        "description" : "Secured Admin-only calls"
      },
      {
        "name" : "developers",
        "description" : "Operations available to regular developers"
      }
    ],
    "paths" : {
      "/inventory" : {
        "get" : {
          "tags" : [
            "developers"
          ],
          "summary" : "searches inventory",
          "operationId" : "searchInventory",
          "description" : "By passing in the appropriate options, you can search for\navailable inventory in the system\n",
          "produces" : [
            "application/json"
          ],
          "parameters" : [
            {
              "in" : "query",
              "name" : "searchString",
              "description" : "pass an optional search string for looking up inventory",
              "required" : false,
              "type" : "string"
            },
            {
              "in" : "query",
              "name" : "skip",
              "description" : "number of records to skip for pagination",
              "type" : "integer",
              "format" : "int32",
              "minimum" : 0
            },
            {
              "in" : "query",
              "name" : "limit",
              "description" : "maximum number of records to return",
              "type" : "integer",
              "format" : "int32",
              "minimum" : 0,
              "maximum" : 50
            }
          ],
          "responses" : {
            "200" : {
              "description" : "search results matching criteria",
              "schema" : {
                "type" : "array",
                "items" : {
                  "$ref" : "#/definitions/InventoryItem"
                }
              }
            },
            "400" : {
              "description" : "bad input parameter"
            }
          }
        },
        "post" : {
          "tags" : [
            "admins"
          ],
          "summary" : "adds an inventory item",
          "operationId" : "addInventory",
          "description" : "Adds an item to the system",
          "consumes" : [
            "application/json"
          ],
          "produces" : [
            "application/json"
          ],
          "parameters" : [
            {
              "in" : "body",
              "name" : "inventoryItem",
              "description" : "Inventory item to add",
              "schema" : {
                "$ref" : "#/definitions/InventoryItem"
              }
            }
          ],
          "responses" : {
            "201" : {
              "description" : "item created"
            },
            "400" : {
              "description" : "invalid input, object invalid"
            },
            "409" : {
              "description" : "an existing item already exists"
            }
          }
        }
      }
    },
    "definitions" : {
      "InventoryItem" : {
        "type" : "object",
        "required" : [
          "id",
          "name",
          "manufacturer",
          "releaseDate"
        ],
        "properties" : {
          "id" : {
            "type" : "string",
            "format" : "uuid",
            "example" : "d290f1ee-6c54-4b01-90e6-d701748f0851"
          },
          "name" : {
            "type" : "string",
            "example" : "Widget Adapter"
          },
          "releaseDate" : {
            "type" : "string",
            "format" : "int32",
            "example" : "2016-08-29T09:12:33.001Z"
          },
          "manufacturer" : {
            "$ref" : "#/definitions/Manufacturer"
          }
        }
      },
      "Manufacturer" : {
        "required" : [
          "name"
        ],
        "properties" : {
          "name" : {
            "type" : "string",
            "example" : "ACME Corporation"
          },
          "homePage" : {
            "type" : "string",
            "format" : "url",
            "example" : "https://www.acme-corp.com"
          },
          "phone" : {
            "type" : "string",
            "example" : "408-867-5309"
          }
        }
      }
    },
    "schemes" : [
      "https"
    ]
  }
  "
    }
  })
  
}

resource " azapi_resource " " api2 " {
  type = " Microsoft.ApiManagement / service / apis @ 2021 - 08 - 01 "
  parent_id = azapi_resource.service.id
  name = " acctestapi-221102104210674839 ; rev = 1 "
  
  body = jsonencode({
    properties = {
      apiRevisionDescription = " "
      apiType = " http "
      apiVersion = " "
      apiVersionDescription = " "
      authenticationSettings = {}
      description = " "
      displayName = " api1 "
      path = " api1 "
      protocols = [
        " https ",
      ]
      serviceUrl = " "
      subscriptionRequired = true
      type = " http "
    }
  })
  
}
