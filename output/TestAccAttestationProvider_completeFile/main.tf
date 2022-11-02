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
  name      = "acctestRG-attestation-221102104030942229"
  location  = "uksouth"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "attestationProvider" {
  type      = "Microsoft.Attestation/attestationProviders@2020-10-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestapknc2ppow4i"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      policySigningCertificates = {
        keys = [
          {
            kty = "RSA"
            x5c = [
              "MIIBzDCCAS2gAwIBAgIBATAKBggqhkjOPQQDBDAQMQ4wDAYDVQQKEwVFTkNPTTAeFw0wOTExMTAyMzAwMDBaFw0xMDA1MDkyMzAwMDBaMBAxDjAMBgNVBAoTBUVOQ09NMIGbMBAGByqGSM49AgEGBSuBBAAjA4GGAAQBAqCuRox5N3MTU8wTuIeIBXF7iMnhntqmGVKQ0hfQFDQGv+Lyduo7JPqFp/Y2jlXSdNrAdz5WxbrY+kDxIpkBQtIAkIDDZVmTueq3ZDAfcGdENnzNJVCaPlHXJLvEEINcoJkUO++cVyywdreVJc67vhNx1TdXV3pp7f+RbOmNKbnVRByjNTAzMA4GA1UdDwEB/wQEAwIHgDATBgNVHSUEDDAKBggrBgEFBQcDATAMBgNVHRMBAf8EAjAAMAoGCCqGSM49BAMEA4GMADCBiAJCAbbb7svI5tuhCyA3jQTSgA8zpvk0YWNXkZ07xzdV8jdMMumCaW9ycEIqJ5KSquuPhUw9oekzB51daybV1VQXVVdVAkIA+kMMSJzwtzHqNAUTmiZPcg7H8v1ASl4tR6lpKTpUPY2XlXOCt2Yf4dsFsijuvzbJBdx75d4Ef5TRHPcg+PHNZgg=",
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
