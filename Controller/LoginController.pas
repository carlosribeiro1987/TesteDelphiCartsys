unit LoginController;

interface
  uses
    UsuarioModel, UsuarioService;

  type
    TLoginController = class
    private
      FUsuarioService: TUsuarioService;
    public
      constructor Create;
      destructor Destroy; override;

      function Autenticar(const ALogin, ASenha: string; out AUsuarioBloqueado: Boolean): TUsuario;

      function AuthenticatorConfigurado(const AUsuario: TUsuario): Boolean;
      function ConfirmarConfiguracaoAuthenticator(const AUsuario: TUsuario; const ASecret, ACodigo: string): Boolean;
      function ValidarAuthenticator(const AUsuario: TUsuario; const ACodigo: string): Boolean;
      procedure IniciarConfiguracaoAuthenticator(const AUsuario: TUsuario; out ASecret, AUri: string);
      procedure ConcluirAutenticacao(const AUsuario: TUsuario);
    end;


implementation

{ TLoginController }

function TLoginController.AuthenticatorConfigurado(
  const AUsuario: TUsuario): Boolean;
begin
  Result := FUsuarioService.AuthenticatorConfigurado(AUsuario);
end;

procedure TLoginController.ConcluirAutenticacao(const AUsuario: TUsuario);
begin
   FUsuarioService.ConcluirAutenticacao(AUsuario);
end;

function TLoginController.ConfirmarConfiguracaoAuthenticator(
  const AUsuario: TUsuario; const ASecret, ACodigo: string): Boolean;
begin
   Result := FUsuarioService.ConfirmarConfiguracaoAuthenticator(AUsuario, ASecret, ACodigo);
end;

constructor TLoginController.Create;
begin
    inherited Create;
    FUsuarioService := TUsuarioService.Create;
end;

function TLoginController.Autenticar(const ALogin, ASenha: string; out AUsuarioBloqueado: Boolean): TUsuario;
begin
  Result := FUsuarioService.Autenticar(ALogin, ASenha, AUsuarioBloqueado);
end;



destructor TLoginController.Destroy;
begin
  FUsuarioService.Free;
  inherited;
end;

procedure TLoginController.IniciarConfiguracaoAuthenticator(
  const AUsuario: TUsuario; out ASecret, AUri: string);
begin
   FUsuarioService.IniciarConfiguracaoAuthenticator(AUsuario, ASecret, AUri);
end;

function TLoginController.ValidarAuthenticator(const AUsuario: TUsuario;
  const ACodigo: string): Boolean;
begin
   Result := FUsuarioService.ValidarAuthenticator(AUsuario, ACodigo);
end;

end.
