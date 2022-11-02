
resource "azapi_resource" "serverfarm" {
  type      = "Microsoft.Web/serverfarms@2021-02-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestASP-WAS-221102104019786961"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      hyperV         = false
      perSiteScaling = false
      reserved       = false
      zoneRedundant  = false
    }
    sku = {
      name = "EP1"
    }
  })
  tags = {}
}
