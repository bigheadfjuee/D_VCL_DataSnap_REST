unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, IPPeerClient,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, Data.DB, Datasnap.DBClient, REST.Response.Adapter, REST.Client,
  Data.Bind.Components, Data.Bind.ObjectScope, REST.Authenticator.Simple,
  REST.Authenticator.Basic, FMX.Edit, FMX.StdCtrls, FMX.Controls.Presentation,
  FMX.ScrollBox, FMX.Memo, System.Net.URLClient, System.Net.HttpClient,
  System.Net.HttpClientComponent, FMX.ComboEdit;

type
  TForm1 = class(TForm)
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    ListView1: TListView;
    HTTPBasicAuthenticator1: THTTPBasicAuthenticator;
    Memo1: TMemo;
    Panel1: TPanel;
    btnExcute: TButton;
    NetHTTPClient1: TNetHTTPClient;
    btnHTTP: TButton;
    cbeMethod: TComboEdit;
    procedure btnExcuteClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnHTTPClick(Sender: TObject);
    procedure NetHTTPClient1AuthEvent(const Sender: TObject;
      AnAuthTarget: TAuthTargetType; const ARealm, AURL: string;
      var AUserName, APassword: string; var AbortAuth: Boolean;
      var Persistence: TAuthPersistenceType);
    procedure NetHTTPClient1RequestCompleted(const Sender: TObject;
      const AResponse: IHTTPResponse);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses System.JSON;

// uri Test
// http://localhost:8080/Datasnap/rest/TserverMethods1/ReverseString/12345
procedure TForm1.btnHTTPClick(Sender: TObject);
var
  uri: string;
  ss: TSTringStream;
begin
  uri := 'http://localhost:8080/Datasnap/rest/TserverMethods1/' +
    cbeMethod.Text;

  NetHTTPClient1.Accept := 'application/json';
  NetHTTPClient1.AcceptCharSet := 'UTF-8';
  try
    ss := TSTringStream.Create('', TEncoding.UTF8);
    NetHTTPClient1.Get(uri, ss).ContentAsString(TEncoding.UTF8);
  except
    on e: Exception do
    begin
      Memo1.Lines.Add(e.ToString);
    end;

  end;

  Memo1.Lines.Add(ss.DataString);
  ss.DisposeOf();
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  HTTPBasicAuthenticator1.Username := 'admin';
  HTTPBasicAuthenticator1.Password := '1234';

  cbeMethod.Items.Add('ReverseString/abcde');
  cbeMethod.Items.Add('GetUserName');
  cbeMethod.Items.Add('EchoString/1234');
  cbeMethod.Items.Add('EchoStringJSON/1234');
  cbeMethod.Items.Add('EchoStringParam?p1=aa&p2=33');
  cbeMethod.ItemIndex := 0;
end;

procedure TForm1.NetHTTPClient1AuthEvent(const Sender: TObject;
  AnAuthTarget: TAuthTargetType; const ARealm, AURL: string;
  var AUserName, APassword: string; var AbortAuth: Boolean;
  var Persistence: TAuthPersistenceType);
begin

  // Tony : Basic Auth 失敗
  if AnAuthTarget = TAuthTargetType.Server then
  begin
    AUserName := 'admin';
    APassword := '1234';
  end;

end;

procedure TForm1.NetHTTPClient1RequestCompleted(const Sender: TObject;
  const AResponse: IHTTPResponse);
begin
  // Memo1.Lines.Add((AResponse.ContentAsString(TEncoding.UTF8)));
end;

procedure TForm1.btnExcuteClick(Sender: TObject);
var
  jv: TJSONValue;
  mName: string;
  str: string;
begin

  RESTClient1.BaseURL := 'http://localhost:8080/Datasnap/rest/TserverMethods1/'
    + cbeMethod.Text;

  try
    RESTRequest1.Execute;
    Memo1.Lines.Add(RESTResponse1.Content);

  except
    on e: Exception do
      Memo1.Lines.Add(e.ToString);
  end;

end;

end.
