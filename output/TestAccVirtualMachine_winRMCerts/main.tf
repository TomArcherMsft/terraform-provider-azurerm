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
  name      = "acctestsb6v1-resources"
  location  = "westeurope"
  body      = jsonencode({})
  tags = {
    source = "TestAccVirtualMachine_winRMCerts"
  }
}

resource "azapi_resource" "virtualNetwork" {
  type      = "Microsoft.Network/virtualNetworks@2021-08-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestsb6v1-network"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      addressSpace = {
        addressPrefixes = [
          "10.0.0.0/16",
        ]
      }
      dhcpOptions = {
        dnsServers = [
        ]
      }
      subnets = [
      ]
    }
  })
  tags = {}
}

resource "azapi_resource" "vault" {
  type      = "Microsoft.KeyVault/vaults@2021-10-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestsb6v1-keyvault"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      accessPolicies = [
        {
          objectId = "7b354af3-2209-4d07-985e-8b02f29c82f9"
          permissions = {
            certificates = [
              "Create",
              "Delete",
              "DeleteIssuers",
              "Get",
              "GetIssuers",
              "Import",
              "List",
              "ListIssuers",
              "ManageContacts",
              "ManageIssuers",
              "Purge",
              "SetIssuers",
              "Update",
            ]
            keys = [
              "Backup",
              "Create",
              "Decrypt",
              "Delete",
              "Encrypt",
              "Get",
              "Import",
              "List",
              "Purge",
              "Recover",
              "Restore",
              "Sign",
              "UnwrapKey",
              "Update",
              "Verify",
              "WrapKey",
            ]
            secrets = [
              "Backup",
              "Delete",
              "Get",
              "List",
              "Purge",
              "Recover",
              "Restore",
              "Set",
            ]
            storage = [
            ]
          }
          tenantId = "72f988bf-86f1-41af-91ab-2d7cd011db47"
        },
      ]
      enableRbacAuthorization      = false
      enableSoftDelete             = true
      enabledForDeployment         = true
      enabledForDiskEncryption     = false
      enabledForTemplateDeployment = true
      publicNetworkAccess          = "Enabled"
      sku = {
        family = "A"
        name   = "standard"
      }
      tenantId = "72f988bf-86f1-41af-91ab-2d7cd011db47"
    }
  })
  tags = {}
}

resource "azapi_resource" "subnet" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2021-08-01"
  parent_id = azapi_resource.virtualNetwork.id
  name      = "internal"

  body = jsonencode({
    properties = {
      addressPrefix = "10.0.2.0/24"
      delegations = [
      ]
      privateEndpointNetworkPolicies    = "Enabled"
      privateLinkServiceNetworkPolicies = "Enabled"
      serviceEndpointPolicies = [
      ]
      serviceEndpoints = [
      ]
    }
  })

}

resource "azapi_resource" "networkInterface" {
  type      = "Microsoft.Network/networkInterfaces@2021-08-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestsb6v1-nic"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      enableAcceleratedNetworking = false
      enableIPForwarding          = false
      ipConfigurations = [
        {
          name = "testconfiguration1"
          properties = {
            primary                   = false
            privateIPAddressVersion   = "IPv4"
            privateIPAllocationMethod = "Dynamic"
            subnet = {
              id = azapi_resource.subnet.id
            }
          }
        },
      ]
    }
  })
  tags = {}
}
