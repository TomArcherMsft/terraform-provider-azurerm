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
  name      = "acctestRG-221102104217649131"
  location  = "westeurope"
  body      = jsonencode({})
  tags      = {}
}

resource "azapi_resource" "service" {
  type      = "Microsoft.ApiManagement/service@2021-08-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestAM-221102104217649131"
  location  = azapi_resource.resourceGroup.location
  body = jsonencode({
    properties = {
      certificates = [
      ]
      customProperties = {
        Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Ssl30 = "false"
        Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Tls10 = "false"
        Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Tls11 = "false"
        Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Tls10         = "false"
        Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Tls11         = "false"
      }
      disableGateway      = false
      publicNetworkAccess = "Enabled"
      publisherEmail      = "pub1@email.com"
      publisherName       = "pub1"
      virtualNetworkType  = "None"
    }
    sku = {
      capacity = 0
      name     = "Consumption"
    }
  })
  tags = {}
}

resource "azapi_resource" "api" {
  type      = "Microsoft.ApiManagement/service/apis@2021-08-01"
  parent_id = azapi_resource.service.id
  name      = "acctestapi-221102104217649131;rev=1"

  body = jsonencode({
    properties = {
      apiType        = "http"
      apiVersion     = ""
      format         = "wsdl"
      path           = "api1"
      type           = "http"
      value          = "<!-- source: https://svn.apache.org/repos/asf/airavata/sandbox/xbaya-web/test/Calculator.wsdl -->
<wsdl:definitions xmlns:wsdl=" http : //schemas.xmlsoap.org/wsdl/" xmlns:ns="http://c.b.a"
      xmlns : wsaw   = "http://www.w3.org/2006/05/addressing/wsdl"
      xmlns : http   = "http://schemas.xmlsoap.org/wsdl/http/" xmlns : xs = "http://www.w3.org/2001/XMLSchema"
      xmlns : soap   = "http://schemas.xmlsoap.org/wsdl/soap/" xmlns : mime = "http://schemas.xmlsoap.org/wsdl/mime/"
      xmlns : soap12 = "http://schemas.xmlsoap.org/wsdl/soap12/" targetNamespace = "http://c.b.a" >
      < wsdl : documentation > Calculator < / wsdl : documentation >
      < wsdl : types >
      < xs : schema attributeFormDefault = "qualified" elementFormDefault = "qualified" targetNamespace = "http://c.b.a" >
      < xs : element name                = "add" >
      < xs : complexType >
      < xs : sequence >
      < xs : element minOccurs = "0" name = "n1" type = "xs:int" / >
      < xs : element minOccurs = "0" name = "n2" type = "xs:int" / >
      < / xs : sequence >
      < / xs : complexType >
      < / xs : element >
      < xs : element name = "addResponse" >
      < xs : complexType >
      < xs : sequence >
      < xs : element minOccurs = "0" name = "return" type = "xs:int" / >
      < / xs : sequence >
      < / xs : complexType >
      < / xs : element >
      < / xs : schema >
      < / wsdl : types >
      < wsdl : message name = "addRequest" >
      < wsdl : part name    = "parameters" element = "ns:add" / >
      < / wsdl : message >
      < wsdl : message name = "addResponse" >
      < wsdl : part name    = "parameters" element = "ns:addResponse" / >
      < / wsdl : message >
      < wsdl : portType name  = "CalculatorPortType" >
      < wsdl : operation name = "add" >
      < wsdl : input message  = "ns:addRequest" wsaw : Action = "urn:add" / >
      < wsdl : output message = "ns:addResponse" wsaw : Action = "urn:addResponse" / >
      < / wsdl : operation >
      < / wsdl : portType >
      < wsdl : binding name         = "CalculatorSoap11Binding" type = "ns:CalculatorPortType" >
      < soap : binding transport    = "http://schemas.xmlsoap.org/soap/http" style = "document" / >
      < wsdl : operation name       = "add" >
      < soap : operation soapAction = "urn:add" style = "document" / >
      < wsdl : input >
      < soap : body use = "literal" / >
      < / wsdl : input >
      < wsdl : output >
      < soap : body use = "literal" / >
      < / wsdl : output >
      < / wsdl : operation >
      < / wsdl : binding >
      < wsdl : binding name           = "CalculatorSoap12Binding" type = "ns:CalculatorPortType" >
      < soap12 : binding transport    = "http://schemas.xmlsoap.org/soap/http" style = "document" / >
      < wsdl : operation name         = "add" >
      < soap12 : operation soapAction = "urn:add" style = "document" / >
      < wsdl : input >
      < soap12 : body use = "literal" / >
      < / wsdl : input >
      < wsdl : output >
      < soap12 : body use = "literal" / >
      < / wsdl : output >
      < / wsdl : operation >
      < / wsdl : binding >
      < wsdl : binding name       = "CalculatorHttpBinding" type = "ns:CalculatorPortType" >
      < http : binding verb       = "POST" / >
      < wsdl : operation name     = "add" >
      < http : operation location = "add" / >
      < wsdl : input >
      < mime : content type = "text/xml" part = "parameters" / >
      < / wsdl : input >
      < wsdl : output >
      < mime : content type = "text/xml" part = "parameters" / >
      < / wsdl : output >
      < / wsdl : operation >
      < / wsdl : binding >
      < wsdl : service name     = "Calculator" >
      < wsdl : port name        = "CalculatorHttpsSoap11Endpoint" binding = "ns:CalculatorSoap11Binding" >
      < soap : address location = "https://acceptancetests.terraform.io/services/Calculator.CalculatorHttpsSoap11Endpoint/" / >
      < / wsdl : port >
      < wsdl : port name        = "CalculatorHttpSoap11Endpoint" binding = "ns:CalculatorSoap11Binding" >
      < soap : address location = "http://acceptancetests.terraform.io/services/Calculator.CalculatorHttpSoap11Endpoint/" / >
      < / wsdl : port >
      < wsdl : port name          = "CalculatorHttpSoap12Endpoint" binding = "ns:CalculatorSoap12Binding" >
      < soap12 : address location = "http://acceptancetests.terraform.io/services/Calculator.CalculatorHttpSoap12Endpoint/" / >
      < / wsdl : port >
      < wsdl : port name          = "CalculatorHttpsSoap12Endpoint" binding = "ns:CalculatorSoap12Binding" >
      < soap12 : address location = "https://acceptancetests.terraform.io/services/Calculator.CalculatorHttpsSoap12Endpoint/" / >
      < / wsdl : port >
      < wsdl : port name        = "CalculatorHttpsEndpoint" binding = "ns:CalculatorHttpBinding" >
      < http : address location = "https://acceptancetests.terraform.io/services/Calculator.CalculatorHttpsEndpoint/" / >
      < / wsdl : port >
      < wsdl : port name        = "CalculatorHttpEndpoint" binding = "ns:CalculatorHttpBinding" >
      < http : address location = "http://acceptancetests.terraform.io/services/Calculator.CalculatorHttpEndpoint/" / >
      < / wsdl : port >
      < / wsdl : service >
      < / wsdl : definitions >
      "
      wsdlSelector = {
        wsdlEndpointName = " CalculatorHttpsSoap11Endpoint "
        wsdlServiceName = " Calculator "
      }
    }
  })
  
}

resource " azapi_resource " " api2 " {
  type = " Microsoft.ApiManagement / service / apis @ 2021 - 08 - 01 "
  parent_id = azapi_resource.service.id
  name = " acctestapi-221102104217649131 ; rev = 1 "
  
  body = jsonencode({
    properties = {
      apiRevisionDescription = " "
      apiType = " http "
      apiVersion = " "
      apiVersionDescription = " "
      authenticationSettings = {}
      description = " "
      displayName = " api1 "
      path = " api1 "
      protocols = [
        " https ",
      ]
      serviceUrl = " "
      subscriptionRequired = true
      type = " http "
    }
  })
  
}
