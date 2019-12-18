unit ServerMethodsUnit1;

interface

uses System.SysUtils, System.Classes, Datasnap.DSServer, Datasnap.DSAuth;

type
{$METHODINFO ON}
  TServerMethods1 = class(TComponent)
  private
    { Private declarations }
  public
    { Public declarations }
    function EchoString(Value: string): string;
    function ReverseString(Value: string): string;
    function GetUserName: string;
  end;
{$METHODINFO OFF}

implementation

uses System.StrUtils, Datasnap.DSSession;

// 在 REST Client 用的 url API
// http://localhost:8080/Datasnap/rest/TserverMethods1/ReverseString/12345

function TServerMethods1.EchoString(Value: string): string;
begin
  Result := Value;
end;

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

end.
