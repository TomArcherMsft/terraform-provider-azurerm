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
  name      = "acctestRG-221102104752964390"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "lab" {
  type      = "Microsoft.DevTestLab/labs@2018-09-15"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestdtl221102104752964390"
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
  name      = "acctestdtvn221102104752964390"

  body = jsonencode({
    properties = {
      description = ""
      subnetOverrides = [
        {
          labSubnetName                = "acctestdtvn221102104752964390Subnet"
          resourceId                   = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-221102104752964390/providers/Microsoft.Network/virtualNetworks/acctestdtvn221102104752964390/subnets/acctestdtvn221102104752964390Subnet"
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
  name      = "acctestdtvn221102104752964390"

  body = jsonencode({
    properties = {
      description = ""
      subnetOverrides = [
        {
          labSubnetName                = "acctestdtvn221102104752964390Subnet"
          resourceId                   = "/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-221102104752964390/providers/Microsoft.Network/virtualNetworks/acctestdtvn221102104752964390/subnets/acctestdtvn221102104752964390Subnet"
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
  name      = "acctestvm-vm221102104752964390"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      allowClaim              = true
      disallowPublicIpAddress = false
      galleryImageReference = {
        offer     = "UbuntuServer"
        osType    = "Linux"
        publisher = "Canonical"
        sku       = "18.04-LTS"
        version   = "latest"
      }
      isAuthenticationWithSshKey = true
      labSubnetName              = "acctestdtvn221102104752964390Subnet"
      labVirtualNetworkId        = azapi_resource.virtualnetwork2.id
      networkInterface           = {}
      notes                      = ""
      osType                     = "Linux"
      password                   = ""
      size                       = "Standard_F2"
      sshKey                     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDCsTcryUl51Q2VSEHqDRNmceUFo55ZtcIwxl2QITbN1RREti5ml/VTytC0yeBOvnZA4x4CFpdw/lCDPk0yrH9Ei5vVkXmOrExdTlT3qI7YaAzj1tUVlBd4S6LX1F7y6VLActvdHuDDuXZXzCDd/97420jrDfWZqJMlUK/EmCE5ParCeHIRIvmBxcEnGfFIsw8xQZl0HphxWOtJil8qsUWSdMyCiJYYQpMoMliO99X40AUc4/AlsyPyT5ddbKk08YrZ+rKDVHF7o29rh4vi5MmHkVgVQHKiKybWlHq+b71gIAUQk9wrJxD+dqt4igrmDSpIjfjwnd+l5UIn5fJSO5DYV4YT/4hwK7OKmuo7OFHD0WyY5YnkYEMtFgzemnRBdE8ulcT60DQpVgRMXFWHvhyCWy0L6sgj1QWDZlLpvsIvNfHsyhKFMG1frLnMt/nP0+YCcfg+v1JYeCKjeoJxB8DWcRBsjzItY0CGmzP8UYZiYKl/2u+2TgFS5r7NWH11bxoUzjKdaa1NLw+ieA8GlBFfCbfWe6YVB9ggUte4VtYFMZGxOjS2bAiYtfgTKFJv+XqORAwExG6+G2eDxIDyo80/OA9IG7Xv/jwQr7D6KDjDuULFcN/iTxuttoKrHeYz1hf5ZQlBdllwJHYx6fK2g8kha6r2JIQKocvsAXiiONqSfw== hello@world.com"
      storageType                = "Standard"
      userName                   = "acct5stU5er"
    }
  })
  tags = {}
}
