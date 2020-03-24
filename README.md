# VLC_DataSnap_REST

## CheckBox - Basic Auth ##
可以關掉認證，以便 NetHTTPClient 測試

## 測試 URI ##
http://localhost:8080/Datasnap/rest/TserverMethods1/ReverseString/12345

## TWebModule1.DSRESTWebDispatcher1FormatResult ##
根據不同的方法名可以返回不同的格式
可以不用是預設的json 格式  \{ "Result":\["..."\] \}

## TServerMethods1.EchoStringParam ##
可自行解析參數，例：EchoStringParam?p1=11&p2=22


# FMX_REST_Client #

## RESTRequest ##
搭配 HTTPBasicAuthenticator 可以通過 Basic 認證(帳號/密碼)

## NetHTTPClient ##
雖然在 NetHTTPClient1AuthEvent 提供帳密，但認證失敗