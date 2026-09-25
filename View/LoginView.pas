unit LoginView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,  Vcl.StdCtrls, LoginController, UsuarioModel, AuthenticatorView;

type
  TfrmLogin = class(TForm)
    lblLogin: TLabel;
    lblSenha: TLabel;
    edtLogin: TEdit;
    edtSenha: TEdit;
    btnEntrar: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnEntrarClick(Sender: TObject);
  private
    { Private declarations }
    FController: TLoginController;
    FUsuarioAutenticado: TUsuario;
  public
    { Public declarations }
    function ObterUsuarioAutenticado: TUsuario;
  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.dfm}

procedure TfrmLogin.btnEntrarClick(Sender: TObject);
var
  Usuario: TUsuario;
  UsuarioBloqueado: Boolean;
  Autenticador: TfrmAuthenticator;
  Secret: string;
  Uri: string;
  CodigoValido: Boolean;
begin
  Usuario := FController.Autenticar(Trim(edtLogin.Text), edtSenha.Text, UsuarioBloqueado);
  if Usuario = nil then
  begin
    if UsuarioBloqueado then
      ShowMessage('Usuario bloqueado.' + sLineBreak + 'Solicite desbloqueio a um administrador.')
    else
      ShowMessage('Login ou senha inválidos.');

    Exit;
  end;

  try
    Autenticador := TfrmAuthenticator.Create(nil);
    try
      if FController.AuthenticatorConfigurado(Usuario) then
      begin
        Autenticador.SolicitarCodigo;
        if Autenticador.ShowModal <> mrOk then
          Exit;

        CodigoValido := FController.ValidarAuthenticator(Usuario, Autenticador.Codigo);
      end
      else
      begin
         FController.IniciarConfiguracaoAuthenticator(Usuario, Secret, Uri);
         Autenticador.Configurar(Secret, Uri);

         if Autenticador.ShowModal <> mrOk then
          Exit;

          CodigoValido := FController.ConfirmarConfiguracaoAuthenticator(Usuario, Secret, Autenticador.Codigo);
      end;

      if not CodigoValido then
      begin
        if Usuario.Bloqueado then
          ShowMessage('Usuário bloqueado.' + sLineBreak + 'Solicite o desbloqueio a um administrador.')
        else
          ShowMessage('Código inválido.');

        Exit;
      end;

      FController.ConcluirAutenticacao(Usuario);

      FUsuarioAutenticado := Usuario;
      Usuario := nil;

      ModalResult := mrOk;
    finally
       Autenticador.Free;
    end;
  finally
     Usuario.Free;
  end;
end;

procedure TfrmLogin.FormCreate(Sender: TObject);
begin
     FController := TLoginController.Create;
     FUsuarioAutenticado := nil;
end;

procedure TfrmLogin.FormDestroy(Sender: TObject);
begin
     FUsuarioAutenticado.Free;
     FController.Free;
end;

function TfrmLogin.ObterUsuarioAutenticado: TUsuario;
begin
     Result := FUsuarioAutenticado;
     FUsuarioAutenticado := nil;
end;

end.
