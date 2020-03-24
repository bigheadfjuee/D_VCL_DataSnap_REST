unit ServerMethodsUnit1;

interface

uses System.SysUtils, System.Classes, Datasnap.DSServer, Datasnap.DSAuth,
  System.JSON;

type
{$METHODINFO ON}
  TServerMethods1 = class(TComponent)
  private
    { Private declarations }
  public
    { Public declarations }

    function ReverseString(Value: string): string;
    function GetUserName: string;

    function EchoString(Value: string): string;
    function EchoStringJSON(Value: string): TJSONObject;
    function EchoStringParam(Value: string): string;

  end;
{$METHODINFO OFF}

implementation

uses System.StrUtils, Datasnap.DSSession, Data.DBXPlatform;

// 在 REST Client 用的 uri API
// http://localhost:8080/Datasnap/rest/TserverMethods1/ReverseString/12345

function TServerMethods1.ReverseString(Value: string): string;
begin
  Result := System.StrUtils.ReverseString(Value);
end;

function TServerMethods1.GetUserName: string;
var
  Session: TDSSession;
begin
  Session := TDSSessionManager.GetThreadSession;
  Result := Session.GetData('username') + ':' + Session.Username;
end;

function TServerMethods1.EchoString(Value: string): string;
begin
  Result := Value;
end;

function TServerMethods1.EchoStringJSON(Value: string): TJSONObject;
var
  JSONObj: TJSONObject;
begin
  JSONObj := TJSONObject.Create;
  JSONObj.AddPair(TJSONPair.Create('name', Value));
  Result := JSONObj;
end;

function TServerMethods1.EchoStringParam(Value: string): string;
var
  metaData: TDSInvocationMetadata;
  i: integer;
begin
  metaData := GetInvocationMetadata;
  // 自行解析 EchoStringParam?p1=11&p2=33 的參數列
  for i := 0 to Pred(metaData.QueryParams.Count) do
  begin
    // Tony 用 Delphi RESTRequest1.Execute 會多一筆只有 '=' 的資料！？
    if not metaData.QueryParams[i].Equals('=') then
      Result := Result + '<param>' + metaData.QueryParams[i] + '</param>';
  end;
  metaData.ResponseContent := '<xml>' + #13#10 + Result + #13#10 + '</xml>';
end;

end.
