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
  name      = "testaccRG-221102104933552464"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "frontDoorWebApplicationFirewallPolicy" {
  type      = "Microsoft.Network/frontDoorWebApplicationFirewallPolicies@2020-04-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "testAccFrontDoorWAF221102104933552464"
  location  = "global"
  body = jsonencode({
    properties = {
      customRules = {
        rules = [
          {
            action       = "Block"
            enabledState = "Enabled"
            matchConditions = [
              {
                matchValue = [
                  "192.168.1.0/24",
                  "10.0.0.0/24",
                ]
                matchVariable   = "RemoteAddr"
                negateCondition = false
                operator        = "IPMatch"
              },
            ]
            name                       = "Rule1"
            priority                   = 1
            rateLimitDurationInMinutes = 1
            rateLimitThreshold         = 10
            ruleType                   = "MatchRule"
          },
        ]
      }
      managedRules = {
        managedRuleSets = [
          {
            ruleGroupOverrides = [
              {
                ruleGroupName = "PHP"
                rules = [
                  {
                    action       = "Block"
                    enabledState = "Disabled"
                    ruleId       = "933111"
                  },
                ]
              },
            ]
            ruleSetType    = "DefaultRuleSet"
            ruleSetVersion = "preview-0.1"
          },
          {
            ruleSetType    = "BotProtection"
            ruleSetVersion = "preview-0.1"
          },
        ]
      }
      policySettings = {
        customBlockResponseBody       = "PGh0bWw+CjxoZWFkZXI+PHRpdGxlPkhlbGxvPC90aXRsZT48L2hlYWRlcj4KPGJvZHk+CkhlbGxvIHdvcmxkCjwvYm9keT4KPC9odG1sPg=="
        customBlockResponseStatusCode = 403
        enabledState                  = "Enabled"
        mode                          = "Prevention"
        redirectUrl                   = "https://www.contoso.com"
      }
    }
  })
  tags = {
    ENV = "Test"
  }
}
