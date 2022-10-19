package acceptance

import (
	"fmt"
	"io/ioutil"
	"os"
	"path"
	"strings"
	"testing"
)

func (td TestData) ExportConfig(t *testing.T, steps []TestStep) {
	workingDirectory, err := os.Getwd()
	if err != nil {
		t.Fatal(err)
	}
	workingDirectory = workingDirectory[:strings.Index(workingDirectory, "internal")]
	workingDirectory = path.Join(workingDirectory, "export", td.ResourceType, strings.ReplaceAll(t.Name(), "/", "_"))
	if _, err := os.Stat(workingDirectory); os.IsNotExist(err) {
		err = os.MkdirAll(workingDirectory, 0744)
		if err != nil {
			t.Fatal(err)
		}
	}

	for i, step := range steps {
		if len(step.Config) > 0 {
			filename := path.Join(workingDirectory, fmt.Sprintf("step_%v.tf", i))
			d1 := []byte(step.Config)
			err = ioutil.WriteFile(filename, d1, 0744)
			if err != nil {
				t.Fatalf("fail to write file: %v", err)
			} else {
				fmt.Printf("config exported to file : %v", filename)
			}
		}
	}
}
