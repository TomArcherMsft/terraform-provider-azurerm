package provider_test

import (
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"path"
	"sort"
	"strings"
	"testing"

	"github.com/hashicorp/hcl2/hcl/hclsyntax"
	"github.com/hashicorp/hcl2/hclparse"
	"github.com/hashicorp/terraform-plugin-sdk/v2/helper/schema"
	"github.com/hashicorp/terraform-provider-azurerm/internal/provider"
	"github.com/hashicorp/terraform-provider-azurerm/internal/sdk"
)

type CoverageResult struct {
	ResourceProviderName  string
	PropertyCount         int
	UncoveredPropertyList []string
}

type CoverageResults []CoverageResult

func (s CoverageResults) Len() int {
	return len(s)
}

func (s CoverageResults) Less(i, j int) bool {
	return s[i].ResourceProviderName < s[j].ResourceProviderName
}

func (s CoverageResults) Swap(i, j int) {
	s[i], s[j] = s[j], s[i]
}

func dfs(block *hclsyntax.Block, prefix string) []string {
	results := make([]string, 0)
	if block == nil {
		return results
	}

	current := "." + block.Type
	if len(block.Labels) > 0 {
		current += "." + block.Labels[0] //strings.Join(block.Labels, ".")
	}
	if strings.EqualFold(block.Type, "dynamic") {
		current = "." + block.Labels[0]
		block = block.Body.Blocks[0]
	}
	if block.Body != nil {
		if len(block.Body.Blocks) > 0 {
			for _, v := range block.Body.Blocks {
				results = append(results, dfs(v, prefix+current)...)
			}
		}
		if len(block.Body.Attributes) > 0 {
			for _, v := range block.Body.Attributes {
				results = append(results, prefix+current+"."+v.Name)
			}
		}
	} else {
		fmt.Printf("impossible to reach here %v", prefix+current)
	}
	return results
}

func getTestedProperties(filename string) []string {
	parser := hclparse.NewParser()
	f, parseDiags := parser.ParseHCLFile(filename)
	if parseDiags.HasErrors() {
		log.Printf(parseDiags.Error())
		return []string{}
	}
	results := make([]string, 0)
	if f != nil {
		body := f.Body.(*hclsyntax.Body)
		for _, v := range body.Blocks {
			if v == nil {
				continue
			}
			results = append(results, dfs(v, "")...)
		}
	}
	for i, prop := range results {
		results[i] = strings.TrimPrefix(prop, ".resource.")
	}
	return results
}

func dfs2(resource *schema.Resource, prefix string) []string {
	results := make([]string, 0)
	if resource == nil {
		return results
	}
	for key, value := range resource.Schema {
		if !value.Optional && !value.Required && value.Computed {
			continue // skip computed property
		}
		if len(value.Deprecated) > 0 {
			continue // skip deprecated property
		}
		if value.Elem == nil {
			results = append(results, prefix+"."+key)
		} else {
			//dfs(value.Elem, )
			if subResource, ok := value.Elem.(*schema.Resource); ok {
				// This is used to test property like replications=[], skip it
				//if value.ConfigMode == pluginsdk.SchemaConfigModeAttr {
				//	results = append(results, prefix+"."+key)
				//}
				results = append(results, dfs2(subResource, prefix+"."+key)...)
			} else {
				results = append(results, prefix+"."+key)
			}
		}
	}
	return results
}

func getCoverageReport(results CoverageResults) string {
	content := "# Test Coverage Report For Azure Terraform Provider \n"
	content += fmt.Sprintf("_branch: %s_\n", os.Getenv("TEST_BRANCH"))
	content += "### Summary\n"
	content += "| Resource Provider | Properties total | Uncovered | Covered | Coverage |\n"
	content += "| --- | --- | --- | --- | --- |\n"
	uncovered := 0
	total := 0
	for _, res := range results {
		uncovered += len(res.UncoveredPropertyList)
		total += res.PropertyCount
	}
	content += fmt.Sprintf("| %s | %d | %d | %d | %.2f%% |\n", "Overall", total, uncovered, total-uncovered, float32(total-uncovered)/float32(total)*100)
	sort.Sort(results)
	for _, res := range results {
		uncovered := len(res.UncoveredPropertyList)
		covered := res.PropertyCount - uncovered
		content += fmt.Sprintf("| %s | %d | %d | %d | %.2f%% |\n", res.ResourceProviderName, res.PropertyCount, uncovered, covered, float32(covered)/float32(res.PropertyCount)*100)
	}

	content += "### Details\n"
	content += "```\n"
	for _, res := range results {
		content += fmt.Sprintf("%s\n", res.ResourceProviderName)
		for _, prop := range res.UncoveredPropertyList {
			content += fmt.Sprintf("    %s\n", prop)
		}
		content += "\n"
	}
	content += "```\n"

	content += "### Debug\n"
	content += fmt.Sprintf("- [Build](https://dev.azure.com/mseng/VSOSS/_build/results?buildId=%s) - The pipeline build\n", os.Getenv("BUILD_ID"))
	content += fmt.Sprintf("- [Commit](https://github.com/ms-henglu/terraform-provider-azurerm/tree/%s) - The build workspace\n", os.Getenv("TAG"))

	return content
}

func Test_coverage(t *testing.T) {
	workingDirectory, err := os.Getwd()
	if err != nil {
		t.Fatal(err)
	}
	workingDirectory = workingDirectory[:strings.Index(workingDirectory, "internal")]
	workingDirectory = path.Join(workingDirectory, "export")
	// load test config
	files, err := ioutil.ReadDir(workingDirectory)
	if err != nil {
		log.Fatal(err)
	}
	tfFiles := make([]string, 0)
	for _, resourceFolder := range files {
		testcaseFolders, err := ioutil.ReadDir(path.Join(workingDirectory, resourceFolder.Name()))
		if err != nil {
			log.Fatal(err)
		}
		for _, testcaseFolder := range testcaseFolders {
			files, err := ioutil.ReadDir(path.Join(workingDirectory, resourceFolder.Name(), testcaseFolder.Name()))
			if err != nil {
				log.Fatal(err)
			}
			for _, file := range files {
				tfFiles = append(tfFiles, path.Join(workingDirectory, resourceFolder.Name(), testcaseFolder.Name(), file.Name()))
			}
		}
	}
	log.Printf("total files: %v", len(tfFiles))

	testedProps := make(map[string]string, 0)
	for i, filename := range tfFiles {
		for _, prop := range getTestedProperties(filename) {
			testedProps[prop] = filename
		}
		if i%500 == 0 {
			log.Printf("%v%%", float32(i+1)*100/float32(len(files)))
		}
	}

	// create provider
	azureProvider := make(map[string]map[string]*schema.Resource, 0)
	for _, service := range provider.SupportedTypedServices() {
		for _, r := range service.Resources() {
			key := r.ResourceType()
			wrapper := sdk.NewResourceWrapper(r)
			resource, _ := wrapper.Resource()
			if azureProvider[service.Name()] == nil {
				azureProvider[service.Name()] = make(map[string]*schema.Resource, 0)
			}
			azureProvider[service.Name()][key] = resource
		}
	}
	for _, service := range provider.SupportedUntypedServices() {
		for k, v := range service.SupportedResources() {
			if azureProvider[service.Name()] == nil {
				azureProvider[service.Name()] = make(map[string]*schema.Resource, 0)
			}
			azureProvider[service.Name()][k] = v
		}
	}

	// cross check
	unknownProp := make(map[string]string, 0)
	results := make([]CoverageResult, 0)
	for rp, value := range azureProvider {
		log.Printf("checking test coverage for %v", rp)
		props := make(map[string]int, 0)
		for key, value := range value {
			if len(value.DeprecationMessage) != 0 {
				continue
			}
			results := dfs2(value, key)
			for _, prop := range results {
				props[prop] = 0
			}
		}

		uncoveredProp := make(map[string]int, 0)
		for prop, filename := range testedProps {
			if _, ok := props[prop]; ok {
				props[prop]++
			} else {
				unknownProp[prop] = filename
			}
		}

		for key, value := range props {
			if value == 0 {
				uncoveredProp[key] = 0
			}
		}

		temp := make([]string, 0)
		for key := range uncoveredProp {
			temp = append(temp, key)
		}
		sort.Strings(temp)

		results = append(results, CoverageResult{
			ResourceProviderName:  rp,
			PropertyCount:         len(props),
			UncoveredPropertyList: temp,
		})
	}

	// get unknown props, should be empty
	filteredProp := make(map[string]string, 0)
	ignoredPropPattern := []string{".data", ".depends_on", ".lifecycle", ".locals", ".variable", "azurerm.", "azurerm-alt.", ".output", "azuread_", ".provider"}
	for key, value := range unknownProp {
		ignored := false
		for _, pattern := range ignoredPropPattern {
			if strings.Contains(key, pattern) {
				ignored = true
				break
			}
		}
		if !ignored {
			filteredProp[key] = value
		}
	}

	log.Printf("unknown props: %v", len(unknownProp))
	log.Printf("filtered unknown props: %v", len(filteredProp))

	log.Println("------------------------------------")
	log.Println("------------------------------------")
	reportContent := getCoverageReport(results)

	d1 := []byte(reportContent)
	filename := workingDirectory + "report.md"
	err = ioutil.WriteFile(filename, d1, 0644)
	if err != nil {
		t.Fatalf("fail to write file: %v", err)
	}
	log.Println(reportContent)
}
