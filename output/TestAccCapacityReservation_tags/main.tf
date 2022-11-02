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
  name      = "acctest-compute-221102104332645343"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "capacityReservationGroup" {
  type      = "Microsoft.Compute/capacityReservationGroups@2022-08-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctest-ccrg-221102104332645343"
  location  = azapi_resource.resourceGroup.location
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "capacityReservation" {
  type      = "Microsoft.Compute/capacityReservationGroups/capacityReservations@2022-08-01"
  parent_id = azapi_resource.capacityReservationGroup.id
  name      = "acctest-ccr-221102104332645343"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    sku = {
      capacity = 2
      name     = "Standard_F2"
    }
  })
  tags = {
    ENV = "Test"
  }
}
