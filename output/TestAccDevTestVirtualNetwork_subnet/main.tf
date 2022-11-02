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
  name      = "acctestRG-221102104831240366"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "lab" {
  type      = "Microsoft.DevTestLab/labs@2018-09-15"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestdtl221102104831240366"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      labStorageType = "Premium"
    }
  })
  tags = {}
}

resource "azapi_resource" "virtualnetwork" {
  type      = "Microsoft.DevTestLab/labs/virtualnetworks@2018-09-15"
  parent_id = azapi_resource.lab.id
  name      = "acctestdtvn221102104831240366"

  body = jsonencode({
    properties = {
      description = ""
      subnetOverrides = [
        {
          labSubnetName                = "acctestdtvn221102104831240366Subnet"
          resourceId                   = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-221102104831240366/providers/Microsoft.Network/virtualNetworks/acctestdtvn221102104831240366/subnets/acctestdtvn221102104831240366Subnet"
          useInVmCreationPermission    = "Allow"
          usePublicIpAddressPermission = "Deny"
        },
      ]
    }
  })
  tags = {}
}

resource "azapi_resource" "virtualnetwork2" {
  type      = "Microsoft.DevTestLab/labs/virtualnetworks@2018-09-15"
  parent_id = azapi_resource.lab.id
  name      = "acctestdtvn221102104831240366"

  body = jsonencode({
    properties = {
      description = ""
      subnetOverrides = [
        {
          labSubnetName                = "acctestdtvn221102104831240366Subnet"
          resourceId                   = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-221102104831240366/providers/Microsoft.Network/virtualNetworks/acctestdtvn221102104831240366/subnets/acctestdtvn221102104831240366Subnet"
          useInVmCreationPermission    = "Allow"
          usePublicIpAddressPermission = "Deny"
        },
      ]
    }
  })
  tags = {}
}
