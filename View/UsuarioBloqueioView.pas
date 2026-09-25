unit UsuarioBloqueioView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids,
  UsuarioModel, UsuarioController, System.Generics.Collections;

type
  TfrmUsuarioBloqueio = class(TForm)
    gbxUsuariosBloqueados: TGroupBox;
    grdUsuarios: TDBGrid;
    btnDesbloquear: TButton;
    btnFechar: TButton;
    mtbUsuarios: TFDMemTable;
    dscUsuarios: TDataSource;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure btnDesbloquearClick(Sender: TObject);
  private
    { Private declarations }
    FController: TUsuarioController;
    FUsuarioAutenticado: TUsuario;
    procedure CarregarUsuarios;
  public
    { Public declarations }
    procedure ConfigurarUsuario(const AUsuario: TUsuario);
  end;

var
  frmUsuarioBloqueio: TfrmUsuarioBloqueio;

implementation

{$R *.dfm}

{ TfrmUsuarioBloqueio }

procedure TfrmUsuarioBloqueio.btnDesbloquearClick(Sender: TObject);
var
   UsuarioId: Integer;
begin
     if mtbUsuarios.IsEmpty then
     begin
          ShowMessage('Não há usuário selecionado para desbloquear.');
          Exit;
     end;

     UsuarioId := mtbUsuarios.FieldByName('ID').AsInteger;

     if MessageDlg('Deseja desbloquear o usuário selecionado?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
        Exit;

     try
        FController.DesbloquearUsuario(FUsuarioAutenticado, UsuarioId);

        ShowMessage('Usuário desbloqueado com sucesso.');

        CarregarUsuarios;
     except
           on E: Exception do
              ShowMessage(E.Message);

     end;
end;


procedure TfrmUsuarioBloqueio.btnFecharClick(Sender: TObject);
begin
     Close;
end;

procedure TfrmUsuarioBloqueio.CarregarUsuarios;
var
   Usuarios: TObjectList<TUsuario>;
   Usuario: TUsuario;
begin
     if FController = nil then
        raise Exception.Create('FController está NIL.');

     if FUsuarioAutenticado = nil then
        raise Exception.Create('FUsuarioAutenticado está NIL.');

     mtbUsuarios.DisableControls;
     try
        if not mtbUsuarios.Active then
          mtbUsuarios.CreateDataSet
        else
          mtbUsuarios.EmptyDataSet;

        Usuarios := FController.ListarBloqueados(FUsuarioAutenticado);
        try
           for Usuario in Usuarios do
           begin

                mtbUsuarios.Append;
                mtbUsuarios.FieldByName('ID').AsInteger := Usuario.Id;
                mtbUsuarios.FieldByName('NOME').AsString := Usuario.Nome;
                mtbUsuarios.FieldByName('LOGIN').AsString := Usuario.Login;
                mtbUsuarios.FieldByName('TENTATIVAS_INVALIDAS').AsInteger := Usuario.TentativasInvalidas;
                mtbUsuarios.Post;
           end;
        finally
               Usuarios.Free;
        end;
     finally
            mtbUsuarios.EnableControls;
     end;
end;

procedure TfrmUsuarioBloqueio.ConfigurarUsuario(const AUsuario: TUsuario);
begin
     FUsuarioAutenticado := AUsuario;
     CarregarUsuarios;
end;

procedure TfrmUsuarioBloqueio.FormCreate(Sender: TObject);
begin
     FController := TUsuarioController.Create;
     FUsuarioAutenticado := nil;
end;

procedure TfrmUsuarioBloqueio.FormDestroy(Sender: TObject);
begin
     FController.Free;
end;

end.
