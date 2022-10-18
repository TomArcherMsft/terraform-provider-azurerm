package azapi

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"path"

	"github.com/Azure/go-autorest/autorest"
	"github.com/hashicorp/terraform-provider-azurerm/internal/temp/azapi/generator"
)

var OutputDirectory = "/Users/luheng/go/src/github.com/hashicorp/terraform-provider-azurerm/output"

var filename string

func SetFileName(testName string) {
	filename = testName
	generator.Reset()
	err := os.RemoveAll(path.Join(OutputDirectory, filename))
	if err != nil {
		fmt.Errorf("remove folder: %s", filename)
	}
}

func azapiGenerator() autorest.SendDecorator {
	return func(s autorest.Sender) autorest.Sender {
		return autorest.SenderFunc(func(r *http.Request) (*http.Response, error) {
			if r.Method == "PUT" {
				config := generator.AzapiConfigFromRequest(r)
				fileDirectory := path.Join(OutputDirectory, filename)
				if _, err := os.Stat(fileDirectory); os.IsNotExist(err) {
					err = os.Mkdir(fileDirectory, 0777)
					if err != nil {
						log.Fatalf("creating directory %s: %+v", fileDirectory, err)
					}
				}
				filepath := path.Join(fileDirectory, "main.tf")
				err := generator.AppendConfig(filepath, config)
				if err != nil {
					fmt.Errorf("appending config to filepath %s: %+v", filepath, err)
				}
			}

			return s.Do(r)
		})
	}
}

func WithAzapiGenerator() []autorest.SendDecorator {
	return []autorest.SendDecorator{azapiGenerator()}
}
