unit UsuarioService;

interface
  uses
      System.Generics.Collections,
      UsuarioModel,
      UsuarioRepository;

  type
    TUsuarioService = class
      private
        FRepository: TUsuarioRepository;

        procedure RegistrarTentativaInvalida(const AUsuario: TUsuario);
      public
        constructor Create;
        destructor Destroy; override;

        function Autenticar(const ALogin, ASenha: string; out AUsuarioBloqueado: Boolean): TUsuario;
        function AuthenticatorConfigurado(const AUsuario: TUsuario): Boolean;
        function ConfirmarConfiguracaoAuthenticator(const AUsuario: TUsuario; const ASecret, ACodigo: string): Boolean;
        function ValidarAuthenticator(const AUsuario: TUsuario; const ACodigo: string): Boolean;
        function ListarBloqueados(const AAdministrador: TUsuario): TObjectList<TUsuario>;

        procedure IniciarConfiguracaoAuthenticator(const AUsuario: TUsuario; out ASecret, AUri: string);
        procedure ConcluirAutenticacao(const AUsuario: TUsuario);

        procedure DesbloquearUsuario(const AAdministrador: TUsuario; const AUsuarioId: Integer);
    end;

implementation
uses
  PasswordService, DatabaseDataModule, System.SysUtils,
  TotpService, AuthorizationService;


{ TUsuarioService }

function TUsuarioService.Autenticar(const ALogin, ASenha: string; out AUsuarioBloqueado: Boolean): TUsuario;
var
  Usuario: TUsuario;
begin
    Result := nil;
    AUsuarioBloqueado := False;

    Usuario := FRepository.BuscarPorLogin(ALogin);
    if Usuario = nil then
      Exit;

    if Usuario.Bloqueado then
    begin
      AUsuarioBloqueado := True;
      Usuario.Free;
      Exit;
    end;

    if not TPasswordService.ValidarSenha(ASenha, Usuario.SenhaHash) then
    begin
      RegistrarTentativaInvalida(Usuario);
      AUsuarioBloqueado := Usuario.Bloqueado;
      Usuario.Free;
      Exit;
    end;

    Result := Usuario;
end;

function TUsuarioService.AuthenticatorConfigurado(
  const AUsuario: TUsuario): Boolean;
begin
  Result := Trim(AUsuario.TOTPSecret) <> '';
end;

procedure TUsuarioService.ConcluirAutenticacao(const AUsuario: TUsuario);
begin
   if AUsuario.TentativasInvalidas = 0 then
    Exit;

   FRepository.AtualizarTentativasInvalidas(AUsuario.Id, 0);
   AUsuario.TentativasInvalidas := 0;
end;

function TUsuarioService.ConfirmarConfiguracaoAuthenticator(
  const AUsuario: TUsuario; const ASecret, ACodigo: string): Boolean;
var
  CodigoValido: Boolean;
begin
  Result := False;
  CodigoValido := TTotpService.ValidarCodigo(ASecret, ACodigo);

  if not CodigoValido then
  begin
    RegistrarTentativaInvalida(AUsuario);
    Exit;
  end;

  FRepository.AtualizarTotpSecret(AUsuario.Id, ASecret);
  AUsuario.TOTPSecret := ASecret;
  Result := CodigoValido;
end;

constructor TUsuarioService.Create;
begin
  inherited Create;
  FRepository := TUsuarioRepository.Create;
end;

procedure TUsuarioService.DesbloquearUsuario(const AAdministrador: TUsuario; const AUsuarioId: Integer);
var
   Administrador: TUsuario;
begin
     TAuthorizationService.ExigirUsuarioAutenticado(AAdministrador);

     Administrador := FRepository.BuscarPorId(AAdministrador.Id);
     try
        if Administrador = nil then
           raise Exception.Create('Usuário administrador não encontrado.');

        TAuthorizationService.ExigirAdministrador(Administrador);

        if Administrador.Id = AUsuarioId then
           raise Exception.Create('O administrador não pode desbloquear a própria conta.');

        dmDatabase.conDatabase.StartTransaction;
        try
           FRepository.AtualizarBloqueio(AUsuarioId, False);
           FRepository.AtualizarTentativasInvalidas(AUsuarioId, 0);

           dmDatabase.conDatabase.Commit;
        except
              dmDatabase.conDatabase.Rollback;
              raise;
        end;
     finally
            Administrador.Free;
     end;
end;

destructor TUsuarioService.Destroy;
begin
  FRepository.Free;
  inherited;
end;

procedure TUsuarioService.IniciarConfiguracaoAuthenticator(
  const AUsuario: TUsuario; out ASecret, AUri: string);
begin
     ASecret := TotpService.TTotpService.GerarSecret;
     AUri := TotpService.TTotpService.GerarUri(ASecret, AUsuario.Login);
end;

function TUsuarioService.ListarBloqueados(
  const AAdministrador: TUsuario): TObjectList<TUsuario>;
var
   Administrador: TUsuario;
begin
     TAuthorizationService.ExigirUsuarioAutenticado(AAdministrador);

     Administrador := FRepository.BuscarPorId(AAdministrador.Id);
     try
        if Administrador = nil then
           raise Exception.Create('Usuário administrador não encontrado.');

        TAuthorizationService.ExigirAdministrador(Administrador);

        Result := FRepository.ListarBloqueados;
     finally
            Administrador.Free;
     end;
end;

procedure TUsuarioService.RegistrarTentativaInvalida(const AUsuario: TUsuario);
begin
  dmDatabase.conDatabase.StartTransaction;

  try
    AUsuario.TentativasInvalidas := AUsuario.TentativasInvalidas + 1;
    FRepository.AtualizarTentativasInvalidas(AUsuario.Id, AUsuario.TentativasInvalidas);

    if AUsuario.TentativasInvalidas >= 3 then
    begin
      AUsuario.Bloqueado := True;

      FRepository.AtualizarBloqueio(AUsuario.Id, AUsuario.Bloqueado);
    end;
    dmDatabase.conDatabase.Commit;
  except
    dmDatabase.conDatabase.Rollback;
    raise;
  end;





end;

function TUsuarioService.ValidarAuthenticator(const AUsuario: TUsuario;
  const ACodigo: string): Boolean;
begin
  Result := TTotpService.ValidarCodigo(AUsuario.TOTPSecret, ACodigo);

  if not Result then
    RegistrarTentativaInvalida(AUsuario);
end;

end.
