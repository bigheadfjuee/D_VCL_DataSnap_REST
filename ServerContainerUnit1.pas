unit ServerContainerUnit1;

interface

uses System.SysUtils, System.Classes,
  Datasnap.DSServer, Datasnap.DSCommonServer,
  Datasnap.DSClientMetadata, Datasnap.DSHTTPServiceProxyDispatcher,
  Datasnap.DSProxyJavaAndroid, Datasnap.DSProxyJavaBlackBerry,
  Datasnap.DSProxyObjectiveCiOS, Datasnap.DSProxyCsharpSilverlight,
  Datasnap.DSProxyFreePascal_iOS,
  Datasnap.DSAuth, IPPeerServer, System.JSON, Data.DBXCommon, Datasnap.DSHTTP;

type
  TServerContainer1 = class(TDataModule)
    DSServer1: TDSServer;
    DSAuthenticationManager1: TDSAuthenticationManager;
    DSServerClass1: TDSServerClass;
    procedure DSServerClass1GetClass(DSServerClass: TDSServerClass;
      var PersistentClass: TPersistentClass);
    procedure DSAuthenticationManager1UserAuthorize(Sender: TObject;
      EventObject: TDSAuthorizeEventObject; var valid: Boolean);
    procedure DSAuthenticationManager1UserAuthenticate(Sender: TObject;
      const Protocol, Context, User, Password: string; var valid: Boolean;
      UserRoles: TStrings);

  private
    { Private declarations }
  public

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  isBasicAuth: Boolean;

function DSServer: TDSServer;
function DSAuthenticationManager: TDSAuthenticationManager;

implementation

{$R *.dfm}

uses Winapi.Windows, ServerMethodsUnit1, Datasnap.DSSession;

var
  FModule: TComponent;
  FDSServer: TDSServer;
  FDSAuthenticationManager: TDSAuthenticationManager;

function DSServer: TDSServer;
begin
  Result := FDSServer;
end;

function DSAuthenticationManager: TDSAuthenticationManager;
begin
  Result := FDSAuthenticationManager;
end;

constructor TServerContainer1.Create(AOwner: TComponent);
begin
  inherited;
  FDSServer := DSServer1;
  FDSAuthenticationManager := DSAuthenticationManager1;
end;

destructor TServerContainer1.Destroy;
begin
  inherited;
  FDSServer := nil;
  FDSAuthenticationManager := nil;
end;

procedure TServerContainer1.DSServerClass1GetClass(DSServerClass
  : TDSServerClass; var PersistentClass: TPersistentClass);
begin
  PersistentClass := ServerMethodsUnit1.TServerMethods1;
end;

procedure TServerContainer1.DSAuthenticationManager1UserAuthenticate
  (Sender: TObject; const Protocol, Context, User, Password: string;
  var valid: Boolean; UserRoles: TStrings);
var
  session: TDSSession;
begin
  { TODO : Validate the client user and password.
    If role-based authorization is needed, add role names to the UserRoles parameter }

  session := TDSSessionManager.GetThreadSession;
  session.PutData('username', User);

  // Authentication Method : BASIC => 帳號 密碼

  if User.Equals('admin') and Password.Equals('1234') then
    valid := True
  else
    valid := false;

  if not isBasicAuth then
    valid := True;

end;

procedure TServerContainer1.DSAuthenticationManager1UserAuthorize
  (Sender: TObject; EventObject: TDSAuthorizeEventObject; var valid: Boolean);
begin
  { TODO : Authorize a user to execute a method.
    Use values from EventObject such as UserName, UserRoles, AuthorizedRoles and DeniedRoles.
    Use DSAuthenticationManager1.Roles to define Authorized and Denied roles
    for particular server methods. }

  if not EventObject.UserName.Equals('admin') then
    valid := false
  else
    valid := True;

  if not isBasicAuth then
    valid := True;
end;

initialization

FModule := TServerContainer1.Create(nil);

finalization

FModule.Free;

end.
