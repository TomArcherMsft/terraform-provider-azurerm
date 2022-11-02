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
  name      = "testaccRG-221102104937765723"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "frontDoorWebApplicationFirewallPolicy" {
  type      = "Microsoft.Network/frontDoorWebApplicationFirewallPolicies@2020-04-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "testAccFrontDoorWAF221102104937765723"
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
          {
            action       = "Block"
            enabledState = "Enabled"
            matchConditions = [
              {
                matchValue = [
                  "192.168.1.0/24",
                ]
                matchVariable   = "RemoteAddr"
                negateCondition = false
                operator        = "IPMatch"
              },
              {
                matchValue = [
                  "windows",
                ]
                matchVariable   = "RequestHeader"
                negateCondition = false
                operator        = "Contains"
                selector        = "UserAgent"
                transforms = [
                  "Lowercase",
                  "Trim",
                ]
              },
            ]
            name                       = "Rule2"
            priority                   = 2
            rateLimitDurationInMinutes = 1
            rateLimitThreshold         = 10
            ruleType                   = "MatchRule"
          },
          {
            action       = "Block"
            enabledState = "Enabled"
            matchConditions = [
              {
                matchValue = [
                  "192.168.1.0/24",
                ]
                matchVariable   = "SocketAddr"
                negateCondition = false
                operator        = "IPMatch"
              },
              {
                matchValue = [
                  "windows",
                ]
                matchVariable   = "RequestHeader"
                negateCondition = false
                operator        = "Contains"
                selector        = "UserAgent"
                transforms = [
                  "Lowercase",
                  "Trim",
                ]
              },
            ]
            name                       = "Rule3"
            priority                   = 3
            rateLimitDurationInMinutes = 1
            rateLimitThreshold         = 10
            ruleType                   = "MatchRule"
          },
        ]
      }
      managedRules = {
        managedRuleSets = [
          {
            exclusions = [
              {
                matchVariable         = "QueryStringArgNames"
                selector              = "not_suspicious"
                selectorMatchOperator = "Equals"
              },
            ]
            ruleGroupOverrides = [
              {
                ruleGroupName = "PHP"
                rules = [
                  {
                    action       = "Block"
                    enabledState = "Disabled"
                    ruleId       = "933100"
                  },
                ]
              },
              {
                exclusions = [
                  {
                    matchVariable         = "QueryStringArgNames"
                    selector              = "really_not_suspicious"
                    selectorMatchOperator = "Equals"
                  },
                ]
                ruleGroupName = "SQLI"
                rules = [
                  {
                    action       = "Block"
                    enabledState = "Disabled"
                    exclusions = [
                      {
                        matchVariable         = "QueryStringArgNames"
                        selector              = "innocent"
                        selectorMatchOperator = "Equals"
                      },
                    ]
                    ruleId = "942200"
                  },
                ]
              },
            ]
            ruleSetType    = "DefaultRuleSet"
            ruleSetVersion = "1.0"
          },
          {
            ruleSetType    = "Microsoft_BotManagerRuleSet"
            ruleSetVersion = "1.0"
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
  tags = {}
}
