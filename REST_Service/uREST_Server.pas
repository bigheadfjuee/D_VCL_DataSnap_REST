unit uREST_Server;

interface

uses
  System.Classes, System.SysUtils, System.Variants,
  IdHTTPWebBrokerBridge, Web.HTTPApp;

type
  TMyREST_Server = class(TComponent)
  private
    FServer: TIdHTTPWebBrokerBridge;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;
    procedure StartServer();
    procedure StopServer();
  end;

var
  MyREST_Server: TMyREST_Server;

implementation

uses
  Winapi.Windows, Winapi.ShellApi, WebModuleUnit1,
  Web.WebReq, Datasnap.DSSession;

procedure TerminateThreads;
begin
  if TDSSessionManager.Instance <> nil then
    TDSSessionManager.Instance.TerminateAllSessions;
end;

constructor TMyREST_Server.Create(AOwner: TComponent);
begin
  inherited;

  // Tony 重點！ 在 program REST_Server 中發現的
  // (project view source)
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass; // WebModuleUnit1.pas

  FServer := TIdHTTPWebBrokerBridge.Create(Self);

  // Tony 註：如果在執行檔路徑沒有相關的 css, images, js, proxy, tmeplates
  // 程式仍會回應 REST 指令，但無法用 Browser 直接開網頁
  // 會有路徑錯誤的 exception
end;

destructor TMyREST_Server.Destroy();
begin
  FServer.Free;
  inherited;
end;

procedure TMyREST_Server.StartServer;
begin
  if not FServer.Active then
  begin
    FServer.Bindings.Clear;
    FServer.DefaultPort := 8080;
    FServer.Active := True;
  end;
end;

procedure TMyREST_Server.StopServer;
begin
  TerminateThreads;
  FServer.Active := False;
  FServer.Bindings.Clear;
end;

end.
