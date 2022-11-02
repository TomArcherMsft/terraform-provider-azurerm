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
  name      = "acctestRG-221102104840812930"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "lab" {
  type      = "Microsoft.DevTestLab/labs@2018-09-15"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestdtl221102104840812930"
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
  name      = "acctestdtvn221102104840812930"

  body = jsonencode({
    properties = {
      description = ""
      subnetOverrides = [
        {
          labSubnetName                = "acctestdtvn221102104840812930Subnet"
          resourceId                   = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-221102104840812930/providers/Microsoft.Network/virtualNetworks/acctestdtvn221102104840812930/subnets/acctestdtvn221102104840812930Subnet"
          useInVmCreationPermission    = "Allow"
          usePublicIpAddressPermission = "Allow"
        },
      ]
    }
  })
  tags = {}
}

resource "azapi_resource" "virtualnetwork2" {
  type      = "Microsoft.DevTestLab/labs/virtualnetworks@2018-09-15"
  parent_id = azapi_resource.lab.id
  name      = "acctestdtvn221102104840812930"

  body = jsonencode({
    properties = {
      description = ""
      subnetOverrides = [
        {
          labSubnetName                = "acctestdtvn221102104840812930Subnet"
          resourceId                   = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-221102104840812930/providers/Microsoft.Network/virtualNetworks/acctestdtvn221102104840812930/subnets/acctestdtvn221102104840812930Subnet"
          useInVmCreationPermission    = "Allow"
          usePublicIpAddressPermission = "Allow"
        },
      ]
    }
  })
  tags = {}
}

resource "azapi_resource" "virtualmachine" {
  type      = "Microsoft.DevTestLab/labs/virtualmachines@2018-09-15"
  parent_id = azapi_resource.lab.id
  name      = "acctestvm812930"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      allowClaim              = true
      disallowPublicIpAddress = false
      galleryImageReference = {
        offer     = "WindowsServer"
        osType    = "Windows"
        publisher = "MicrosoftWindowsServer"
        sku       = "2012-Datacenter"
        version   = "latest"
      }
      isAuthenticationWithSshKey = false
      labSubnetName              = "acctestdtvn221102104840812930Subnet"
      labVirtualNetworkId        = azapi_resource.virtualnetwork2.id
      networkInterface           = {}
      notes                      = ""
      osType                     = "Windows"
      password                   = "Pa$w0rd1234!"
      size                       = "Standard_F2"
      storageType                = "Standard"
      userName                   = "acct5stU5er"
    }
  })
  tags = {}
}
