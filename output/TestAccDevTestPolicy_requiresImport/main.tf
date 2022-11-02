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
  name      = "acctestRG-221102104812246655"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "lab" {
  type      = "Microsoft.DevTestLab/labs@2018-09-15"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestdtl221102104812246655"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      labStorageType = "Premium"
    }
  })
  tags = {}
}

resource "azapi_resource" "policy" {
  type      = "Microsoft.DevTestLab/labs/policysets/policies@2018-09-15"
  parent_id = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-221102104812246655/providers/Microsoft.DevTestLab/labs/acctestdtl221102104812246655/policysets/default"
  name      = "LabVmCount"

  body = jsonencode({
    properties = {
      description   = ""
      evaluatorType = "MaxValuePolicy"
      factData      = ""
      factName      = "LabVmCount"
      threshold     = "999"
    }
  })
  tags = {}
}
