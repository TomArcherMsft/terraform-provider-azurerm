package localserver

import (
	"fmt"
	"net/http"
	"strings"

	"github.com/Azure/go-autorest/autorest"
)

var cache = make(map[string][]byte)

func localServer() autorest.SendDecorator {
	return func(s autorest.Sender) autorest.Sender {
		return autorest.SenderFunc(func(r *http.Request) (*http.Response, error) {
			//fmt.Printf("start request %s %s\n", r.Method, r.URL)

			//fmt.Printf("-----------mocked---------------\n")
			// hardcode
			if strings.Contains(r.URL.Path, "agentRegistrationInformation") && r.Method == "GET" {
				value := []byte(`{"id":"/subscriptions/85b3dbca-5974-4067-9669-67a141095a76/resourceGroups/acctestRG-auto-221012141332893225/providers/Microsoft.Automation/automationAccounts/acctest-221012141332893225/agentRegistrationInformation/https://5b6d766a-540c-4d92-9715-3ce0994f8206.agentsvc.we.azure-automation.net/accounts/5b6d766a-540c-4d92-9715-3ce0994f8206","keys":{"primary":"xjz09X1FkVq/IMGz9GLtMLcS86qxY5d86QJ7USKhaxyuiipO5WbN2QcZyCOV4swWcFUEdTtVDP0P2Sy8b/KSgA==","secondary":"Xg9OZEiCDtJNBRrvx6DpNkhuK17WqTkZHPfcyBDUAuc+UEGs1D/tz16AFpj1/rvA/XCVAk3rJyFTZOaItv5NUQ=="},"endpoint":"https://5b6d766a-540c-4d92-9715-3ce0994f8206.agentsvc.we.azure-automation.net/accounts/5b6d766a-540c-4d92-9715-3ce0994f8206","dscMetaConfiguration":"\r\n\tinstance of MSFT_WebDownloadManager as $MSFT_WebDownloadManager1ref\r\n\t{\r\n\tResourceID = \"[ConfigurationRepositoryWeb]AzureAutomationDSC\";\r\n\t SourceInfo = \"C:\\\\OaaS-RegistrationMetaConfig2.ps1::20::9::ConfigurationRepositoryWeb\";\r\n\t RegistrationKey = \"xjz09X1FkVq/IMGz9GLtMLcS86qxY5d86QJ7USKhaxyuiipO5WbN2QcZyCOV4swWcFUEdTtVDP0P2Sy8b/KSgA==\"; \r\n\t ServerURL = \"https://5b6d766a-540c-4d92-9715-3ce0994f8206.agentsvc.we.azure-automation.net/accounts/5b6d766a-540c-4d92-9715-3ce0994f8206\";\r\n\t};\r\n\r\n\tinstance of MSFT_WebResourceManager as $MSFT_WebResourceManager1ref\r\n\t{\r\n\t SourceInfo = \"C:\\\\OaaS-RegistrationMetaConfig2.ps1::27::9::ResourceRepositoryWeb\";\r\n\t ServerURL = \"https://5b6d766a-540c-4d92-9715-3ce0994f8206.agentsvc.we.azure-automation.net/accounts/5b6d766a-540c-4d92-9715-3ce0994f8206\";\r\n\t ResourceID = \"[ResourceRepositoryWeb]AzureAutomationDSC\";\r\n\t RegistrationKey = \"xjz09X1FkVq/IMGz9GLtMLcS86qxY5d86QJ7USKhaxyuiipO5WbN2QcZyCOV4swWcFUEdTtVDP0P2Sy8b/KSgA==\"; \r\n\t};\r\n\r\n\tinstance of MSFT_WebReportManager as $MSFT_WebReportManager1ref\r\n\t{\r\n\t SourceInfo = \"C:\\\\OaaS-RegistrationMetaConfig2.ps1::34::9::ReportServerWeb\";\r\n\t ServerURL = \"https://5b6d766a-540c-4d92-9715-3ce0994f8206.agentsvc.we.azure-automation.net/accounts/5b6d766a-540c-4d92-9715-3ce0994f8206\";\r\n\t ResourceID = \"[ReportServerWeb]AzureAutomationDSC\";\r\n\t RegistrationKey = \"xjz09X1FkVq/IMGz9GLtMLcS86qxY5d86QJ7USKhaxyuiipO5WbN2QcZyCOV4swWcFUEdTtVDP0P2Sy8b/KSgA==\"; \r\n\t};\r\n\r\n\tinstance of MSFT_DSCMetaConfiguration as $MSFT_DSCMetaConfiguration1ref\r\n\t{\r\n\t RefreshMode = \"Pull\";\r\n\t AllowModuleOverwrite = False;\r\n\t ActionAfterReboot = \"ContinueConfiguration\";\r\n\t RefreshFrequencyMins = 30;\r\n\t RebootNodeIfNeeded = False;\r\n\t ConfigurationModeFrequencyMins = 15;\r\n\t ConfigurationMode = \"ApplyAndMonitor\";\r\n\r\n\t  ResourceModuleManagers = {\r\n\t  $MSFT_WebResourceManager1ref  \r\n\t};\r\n\t  ReportManagers = {\r\n\t  $MSFT_WebReportManager1ref  \r\n\t };\r\n\t  ConfigurationDownloadManagers = {\r\n\t  $MSFT_WebDownloadManager1ref  \r\n\t };\r\n\t};\r\n\r\n\tinstance of OMI_ConfigurationDocument\r\n\t{\r\n\t Version=\"2.0.0\";\r\n\t MinimumCompatibleVersion = \"2.0.0\";\r\n\t CompatibleVersionAdditionalProperties= { \"MSFT_DSCMetaConfiguration:StatusRetentionTimeInDays\" };\r\n\t Author=\"azureautomation\";\r\n\t GenerationDate=\"04/17/2015 11:41:09\";\r\n\t GenerationHost=\"azureautomation-01\";\r\n\t Name=\"RegistrationMetaConfig\";\r\n\t};\r\n\t"}`)
				return GetResponse(r, value), nil
			} else {
				// cached
				switch r.Method {
				case http.MethodGet:
					if value, ok := cache[r.URL.Path]; ok {
						return GetResponse(r, value), nil
					} else {
						return GetNotFoundResponse(r), nil
					}
				case http.MethodPut:
					cache[r.URL.Path] = ReadBody(r)
					return PutResponse(r), nil
				case http.MethodDelete:
					delete(cache, r.URL.Path)
					return DeleteResponse(r), nil
				default:
					return nil, fmt.Errorf("not implemented exception: %s %s", r.Method, r.URL)
				}
			}

			fmt.Printf("-----------real---------------\n")
			resp, err := s.Do(r)
			if err != nil {
				fmt.Printf("%s %s received error '%v'\n", r.Method, r.URL, err)
			} else {
				fmt.Printf("%s %s received %s\n", r.Method, r.URL, resp.Status)
			}
			fmt.Printf("------------------------------\n\n")
			return resp, err
		})
	}
}

func WithLocalServer() []autorest.SendDecorator {
	return []autorest.SendDecorator{localServer()}
}
