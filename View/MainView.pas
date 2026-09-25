unit MainView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, UsuarioModel;

type
  TfrmMain = class(TForm)
    menMainMenu: TMainMenu;
    mnuSistema: TMenuItem;
    mnuSair: TMenuItem;
    menCadastros: TMenuItem;
    mnuCliente: TMenuItem;
    mnuRelatorios: TMenuItem;
    mnuRelatorio: TMenuItem;
    mnuDesbloquearUsuarios: TMenuItem;
    procedure mnuSairClick(Sender: TObject);
    procedure mnuClienteClick(Sender: TObject);
    procedure mnuDesbloquearUsuariosClick(Sender: TObject);
    procedure mnuRelatorioClick(Sender: TObject);
  private
    { Private declarations }
    FUsuarioAutenticado: TUsuario;
  public
    { Public declarations }
    procedure ConfigurarUsuario(const AUsuario: TUsuario);
  end;

var
  frmMain: TfrmMain;

implementation
uses
    ClienteView, UsuarioBloqueioView, ClienteRelatorioView;

{$R *.dfm}

procedure TfrmMain.ConfigurarUsuario(const AUsuario: TUsuario);
begin
     FUsuarioAutenticado := AUsuario;

     mnuDesbloquearUsuarios.Enabled := (FUsuarioAutenticado <> nil) and FUsuarioAutenticado.Administrador;
end;

procedure TfrmMain.mnuClienteClick(Sender: TObject);
var
   FormCliente: TfrmCliente;
begin
     FormCliente := TfrmCliente.Create(Self);
     try
         FormCliente.ShowModal;
     finally
            FormCliente.Free;
     end;

end;

procedure TfrmMain.mnuDesbloquearUsuariosClick(Sender: TObject);
var
   FormUsuarioBloqueio: TfrmUsuarioBloqueio;
begin
     FormUsuarioBloqueio := TfrmUsuarioBloqueio.Create(Self);
     try
        FormUsuarioBloqueio.ConfigurarUsuario(FUsuarioAutenticado);
        FormUsuarioBloqueio.ShowModal;
     finally
            FormUsuarioBloqueio.Free;
     end;
end;

procedure TfrmMain.mnuRelatorioClick(Sender: TObject);
var
   FormClienteRelatorio: TfrmClienteRelatorio;
begin
     FormClienteRelatorio := TfrmClienteRelatorio.Create(Self);
     try
        FormClienteRelatorio.ShowModal;
     finally
            FormClienteRelatorio.Free;
     end;
end;

procedure TfrmMain.mnuSairClick(Sender: TObject);
begin
     Close;
end;

end.
