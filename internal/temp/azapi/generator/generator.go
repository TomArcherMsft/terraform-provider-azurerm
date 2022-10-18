package generator

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"io/ioutil"
	"net/http"
	"os"
	"regexp"
	"strings"

	"github.com/Azure/azure-sdk-for-go/sdk/azcore/arm"
	pluralize "github.com/gertd/go-pluralize"
	"github.com/hashicorp/hcl2/hclwrite"
	"github.com/hashicorp/terraform-provider-azurerm/internal/temp/azapi/hcl"
)

var labelSet = make(map[string]bool)
var valueReferenceMap = make(map[string]string)

var pluralizeClient = pluralize.NewClient()

var providerConfig = `terraform {
  required_providers {
    azapi = {
      source = "Azure/azapi"
    }
  }
}

provider "azapi" {
  skip_provider_registration = false
}
`

func Reset() {
	labelSet = make(map[string]bool)
	valueReferenceMap = make(map[string]string)
}

func AzapiConfigFromRequest(r *http.Request) string {
	url := r.URL.Path
	parentId := parentIdFromUrl(url)
	parentIdProp := fmt.Sprintf(`parent_id = "%s"`, parentId)
	name := nameFromUrl(url)
	resourceType := resourceTypeFromUrl(url)
	label := newLabel(resourceType, labelSet)
	labelSet[label] = true
	valueReferenceMap[url] = fmt.Sprintf(`azapi_resource.%s.id`, label)
	valueReferenceMap[name] = fmt.Sprintf(`azapi_resource.%s.name`, label)
	var body interface{}
	json.Unmarshal(bodyFromRequest(r), &body)
	propsBeforeBody := ""
	propsAfterBody := ""
	if bodyMap, ok := body.(map[string]interface{}); ok {
		if locationValue, ok := bodyMap["location"]; ok && locationValue != nil {
			propsBeforeBody = fmt.Sprintf(`location = "%v"`, locationValue)
			if strings.EqualFold(resourceType, "Microsoft.Resources/resourceGroups") {
				valueReferenceMap[locationValue.(string)] = fmt.Sprintf(`azapi_resource.%s.location`, label)
			}
			delete(bodyMap, "location")
		}
		if tagsValue, ok := bodyMap["tags"]; ok {
			propsAfterBody = fmt.Sprintf(`tags = %s`, hcl.MarshalIndent(tagsValue, "  ", "  "))
			delete(bodyMap, "tags")
		}
		if identityValue, ok := bodyMap["identity"]; ok {
			if identityMap, ok := identityValue.(map[string]interface{}); ok {
				identityType := identityMap["type"].(string)
				identitiesIds := make([]string, 0)
				if userAssignedIdentitiesValue, ok := identityMap["userAssignedIdentities"]; ok {
					if userAssignedIdentitiesMap, ok := userAssignedIdentitiesValue.(map[string]interface{}); ok && len(userAssignedIdentitiesMap) != 0 {
						for k, _ := range userAssignedIdentitiesMap {
							identitiesIds = append(identitiesIds, fmt.Sprintf(`"%s"`, k))
						}
					}
				}
				switch {
				case strings.Contains(identityType, ","):
					identityType = string(SystemAssignedUserAssigned)
				case strings.EqualFold(identityType, string(UserAssigned)):
					identityType = string(UserAssigned)
				case strings.EqualFold(identityType, string(SystemAssigned)):
					identityType = string(SystemAssigned)
				default:
					identityType = string(None)
				}

				if identityType != string(None) {
					if propsBeforeBody != "" {
						propsBeforeBody += "\n"
					}
					propsBeforeBody += fmt.Sprintf(
						`  identity {
    type = "%s"
    identity_ids = [%s]
  }`, identityType, strings.Join(identitiesIds, ", "))
				}
				delete(bodyMap, "identity")
			}
		}
		delete(bodyMap, "name")
		body = bodyMap
	}

	bodyHcl := hcl.MarshalIndent(body, "  ", "  ")
	apiVersion := r.URL.Query().Get("api-version")

	content := fmt.Sprintf(
		`resource "azapi_resource" "%s" {
  type = "%s@%s"
  %s
  name = "%s"
  %s
  body = jsonencode(%s)
  %s
}
`, label, resourceType, apiVersion, parentIdProp, name, propsBeforeBody, bodyHcl, propsAfterBody)
	for v, k := range valueReferenceMap {
		// skip same label
		if strings.Contains(k, fmt.Sprintf(`.%s.`, label)) {
			continue
		}
		re := regexp.MustCompile(fmt.Sprintf(`(?i)"%s"`, v))
		content = re.ReplaceAllString(content, k)
	}
	return content
}

func AppendConfig(filename string, content string) error {
	if _, err := os.Stat(filename); os.IsNotExist(err) {
		err = ioutil.WriteFile(filename, []byte(providerConfig), 0777)
		if err != nil {
			return err
		}
	}
	data, err := ioutil.ReadFile(filename)
	if err != nil {
		return err
	}
	content = fmt.Sprintf("%s\n%s", string(data), content)
	err = ioutil.WriteFile(filename, hclwrite.Format([]byte(content)), 0777)
	if err != nil {
		return err
	}
	return nil
}

func newLabel(resourceType string, idMap map[string]bool) string {
	parts := strings.Split(resourceType, "/")
	label := "test"
	if len(parts) != 0 {
		label = parts[len(parts)-1]
		label = pluralizeClient.Singular(label)
	}
	_, ok := idMap[label]
	if !ok {
		return label
	}
	for i := 2; i <= 100; i++ {
		newLabel := fmt.Sprintf("%s%d", label, i)
		_, ok = idMap[newLabel]
		if !ok {
			return newLabel
		}
	}
	return label
}

func resourceTypeFromUrl(id string) string {
	if id == "/" {
		return arm.TenantResourceType.String()
	}
	resourceType, err := arm.ParseResourceType(id)
	if err != nil {
		return ""
	}
	return resourceType.String()
}

func nameFromUrl(id string) string {
	resourceId, err := arm.ParseResourceID(id)
	if err != nil {
		return ""
	}
	return resourceId.Name
}

func parentIdFromUrl(id string) string {
	resourceId, err := arm.ParseResourceID(id)
	if err != nil {
		return ""
	}
	if resourceId.Parent.ResourceType.String() == arm.TenantResourceType.String() {
		return "/"
	}
	return resourceId.Parent.String()
}

func bodyFromRequest(r *http.Request) []byte {
	responseBody, err := ioutil.ReadAll(r.Body)
	if err != nil {
		fmt.Errorf("PUT %s: %+v", r.URL.Path, err)
		return nil
	}
	r.Body = io.NopCloser(bytes.NewBuffer(responseBody))
	return responseBody
}

func addressWithId(id string, idMap map[string]string) string {
	for k, v := range idMap {
		if strings.EqualFold(id, v) {
			return k
		}
	}
	return ""
}

type IdentityType string

const (
	None                       IdentityType = "None"
	SystemAssigned             IdentityType = "SystemAssigned"
	UserAssigned               IdentityType = "UserAssigned"
	SystemAssignedUserAssigned IdentityType = "SystemAssigned, UserAssigned"
)
