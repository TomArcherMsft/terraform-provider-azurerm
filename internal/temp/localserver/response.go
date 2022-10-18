package localserver

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"io/ioutil"
	"net/http"
	"strings"
)

func GetNotFoundResponse(r *http.Request) *http.Response {
	responseBody := []byte(`{"error":{"code":"ResourceNotFound","message":"Resource XXX could not be found."}}`)

	return &http.Response{
		Status:     "404 Not Found",
		StatusCode: 404,
		Proto:      "HTTP/2.0",
		ProtoMajor: 2,
		ProtoMinor: 0,
		Header: map[string][]string{
			"Pragma": {"no-cache"},
		},
		Body:             io.NopCloser(bytes.NewBuffer(responseBody)),
		ContentLength:    int64(len(responseBody)),
		TransferEncoding: nil,
		Close:            false,
		Uncompressed:     false,
		Trailer:          nil,
		Request:          r,
		TLS:              nil,
	}
}

func GetResponse(r *http.Request, responseBody []byte) *http.Response {
	return &http.Response{
		Status:     "200 OK",
		StatusCode: 200,
		Proto:      "HTTP/2.0",
		ProtoMajor: 2,
		ProtoMinor: 0,
		Header: map[string][]string{
			"Pragma": {"no-cache"},
		},
		Body:             io.NopCloser(bytes.NewBuffer(responseBody)),
		ContentLength:    int64(len(responseBody)),
		TransferEncoding: nil,
		Close:            false,
		Uncompressed:     false,
		Trailer:          nil,
		Request:          r,
		TLS:              nil,
	}
}

func PutResponse(r *http.Request) *http.Response {
	responseBody, err := ioutil.ReadAll(r.Body)
	if err != nil {
		fmt.Errorf("PUT %s: %+v", r.URL.Path, err)
	}
	r.Body = io.NopCloser(bytes.NewBuffer(responseBody))
	return &http.Response{
		Status:     "201 Created",
		StatusCode: 201,
		Proto:      "HTTP/2.0",
		ProtoMajor: 2,
		ProtoMinor: 0,
		Header: map[string][]string{
			"Pragma": {"no-cache"},
		},
		Body:             io.NopCloser(bytes.NewBuffer(responseBody)),
		ContentLength:    int64(len(responseBody)),
		TransferEncoding: nil,
		Close:            false,
		Uncompressed:     false,
		Trailer:          nil,
		Request:          r,
		TLS:              nil,
	}
}

func DeleteResponse(r *http.Request) *http.Response {
	responseBody := make([]byte, 0)
	r.Body = io.NopCloser(bytes.NewBuffer(responseBody))
	return &http.Response{
		Status:     "200 OK",
		StatusCode: 200,
		Proto:      "HTTP/2.0",
		ProtoMajor: 2,
		ProtoMinor: 0,
		Header: map[string][]string{
			"Pragma": {"no-cache"},
		},
		Body:             io.NopCloser(bytes.NewBuffer(responseBody)),
		ContentLength:    int64(len(responseBody)),
		TransferEncoding: nil,
		Close:            false,
		Uncompressed:     false,
		Trailer:          nil,
		Request:          r,
		TLS:              nil,
	}
}

func ReadBody(r *http.Request) []byte {
	responseBody, err := ioutil.ReadAll(r.Body)
	if err != nil {
		fmt.Errorf("PUT %s: %+v", r.URL.Path, err)
		return nil
	}
	var body map[string]interface{}
	err = json.Unmarshal(responseBody, &body)
	if err != nil {
		fmt.Errorf("PUT %s: %+v", r.URL.Path, err)
		return nil
	}
	body["id"] = r.URL.Path
	body["name"] = NameFromUrl(r.URL.Path)
	props := make(map[string]interface{})
	if v, ok := body["properties"]; ok {
		props = v.(map[string]interface{})
	}
	props["provisioningState"] = "Succeeded"
	body["properties"] = props
	responseBody, err = json.Marshal(body)
	if err != nil {
		fmt.Errorf("PUT %s: %+v", r.URL.Path, err)
		return nil
	}
	r.Body = io.NopCloser(bytes.NewBuffer(responseBody))
	return responseBody
}

func NameFromUrl(url string) string {
	parts := strings.Split(url, "/")
	if len(parts) == 0 {
		return ""
	}
	return parts[len(parts)-1]
}
