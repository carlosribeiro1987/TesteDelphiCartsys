unit DatabaseDataModule;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, FireDAC.Phys.IBBase, Data.DB,
  FireDAC.Comp.Client, System.IOUtils;

type
  TdmDatabase = class(TDataModule)
    conDatabase: TFDConnection;
    FBDriverLink: TFDPhysFBDriverLink;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Conectar;
    procedure Desconectar;
  end;

var
  dmDatabase: TdmDatabase;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}







{ TdmDatabase }

procedure TdmDatabase.Conectar;
var
   DiretorioAplicacao: string;
   CaminhoBanco: string;
   CaminhoFbClient: string;
begin
     if conDatabase.Connected then
     Exit;

     DiretorioAplicacao := ExtractFilePath(ParamStr(0));
     CaminhoBanco := TPath.Combine(DiretorioAplicacao, 'database\CARTSYS.FDB');
     CaminhoFbClient := TPath.Combine(DiretorioAplicacao, 'fbclient.dll');

     if not FileExists(CaminhoBanco) then
        raise Exception.CreateFmt('Banco de dados não encontrado: %s', [CaminhoBanco]);

     if not FileExists(CaminhoFbClient) then
        raise Exception.CreateFmt('Cliente do Firebird não encontrado: %s', [CaminhoFbClient]);

     conDatabase.Params.Values['Database'] := CaminhoBanco;
     FBDriverLink.VendorLib := CaminhoFbClient;

     conDatabase.Open;
end;



procedure TdmDatabase.Desconectar;
begin
     if conDatabase.Connected then
     begin
       conDatabase.Close;
     end;
end;

end.
