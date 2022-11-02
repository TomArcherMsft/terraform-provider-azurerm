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
  name      = "acctestRG-attestation-221102104025473348"
  location  = "uksouth"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "attestationProvider" {
  type      = "Microsoft.Attestation/attestationProviders@2020-10-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestapcjlpdxqtdq"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      policySigningCertificates = {
        keys = [
          {
            kty = "RSA"
            x5c = [
              "MIIBzDCCAS2gAwIBAgIBATAKBggqhkjOPQQDBDAQMQ4wDAYDVQQKEwVFTkNPTTAeFw0yMjExMDIwMjQwMjVaFw0yMzA1MDEwMjQwMjVaMBAxDjAMBgNVBAoTBUVOQ09NMIGbMBAGByqGSM49AgEGBSuBBAAjA4GGAAQAaMMC8zPPWy+4lYggNx6TiCOl1Spa3iEH7l5FydB0vda3PADOvX7zQTslXPwl3OsPazO7v7+lOxctySZXeb1DrNIANtmb9uqxCOtntejVZ45Nr9eCHlG+60m66IQDKIrxj6l9u09XnqdciBawpJR0+g94N0VSffV19Ngud8FsGE9L26mjNTAzMA4GA1UdDwEB/wQEAwIHgDATBgNVHSUEDDAKBggrBgEFBQcDATAMBgNVHRMBAf8EAjAAMAoGCCqGSM49BAMEA4GMADCBiAJCALMFnZ+g+ty5ACLU/D8xvlrgrBylh0pIaL6sGQkNnC7iuQ//FFW8kLct7LVUK6VEY4OqSWzTQQ/m3HlLSE5NNwEjAkIAiVqQatVzXJ6cDISqsjMVtit/H7Xbd9KKJa/6ZR4gELsQWZKHJRIYckReHtRSRhjWHLZ/TlItuSFUCaxuWwug9pw=",
            ]
          },
        ]
      }
    }
  })
  tags = {
    ENV = "Test"
  }
}
