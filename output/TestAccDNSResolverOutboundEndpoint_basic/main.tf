
resource "azapi_resource" "subnet" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2021-08-01"
  parent_id = azapi_resource.virtualNetwork.id
  name      = "outbounddns"

  body = jsonencode({
    properties = {
      addressPrefix = "10.0.0.64/28"
      delegations = [
        {
          name = "Microsoft.Network.dnsResolvers"
          properties = {
            serviceName = "Microsoft.Network/dnsResolvers"
          }
        },
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

resource "azapi_resource" "outboundEndpoint" {
  type      = "Microsoft.Network/dnsResolvers/outboundEndpoints@2022-07-01"
  parent_id = azapi_resource.dnsResolver.id
  name      = "acctest-droe-221102103446048566"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      subnet = {
        id = azapi_resource.subnet.id
      }
    }
  })
  tags = null
}
