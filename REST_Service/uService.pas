unit uService;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.SvcMgr, Vcl.Dialogs, IdBaseComponent,
  IdComponent, IdCustomTCPServer, IdTimeServer;

type
  TMyREST_Service = class(TService)
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
    procedure ServiceCreate(Sender: TObject);
  private
    { Private declarations }
  public
    function GetServiceController: TServiceController; override;
    { Public declarations }
  end;

var
  MyREST_Service: TMyREST_Service;

implementation

{$R *.dfm}

uses uREST_Server; // 將 REST 功能封裝成 Unit

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  MyREST_Service.Controller(CtrlCode);
end;

function TMyREST_Service.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TMyREST_Service.ServiceCreate(Sender: TObject);
begin
  MyREST_Server := TMyREST_Server.Create(self);
end;

procedure TMyREST_Service.ServiceStart(Sender: TService; var Started: Boolean);
begin

  MyREST_Server.StartServer;
end;

procedure TMyREST_Service.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
  MyREST_Server.StopServer;

end;

end.
