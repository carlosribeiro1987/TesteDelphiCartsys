unit AuthorizationService;

interface
uses
    SysUtils, UsuarioModel;

type
  TAuthorizationService = class

  public
        class procedure ExigirUsuarioAutenticado(const AUsuario: TUsuario); static;
        class procedure ExigirAdministrador(const AUsuario: TUsuario); static;
  end;

implementation

{ TAuthorizationService }

class procedure TAuthorizationService.ExigirAdministrador(
  const AUsuario: TUsuario);
begin
     ExigirUsuarioAutenticado(AUsuario);

     if not AUsuario.Administrador then
        raise Exception.Create('Acesso permitido apenas para administradores.');
end;

class procedure TAuthorizationService.ExigirUsuarioAutenticado(
  const AUsuario: TUsuario);
begin
     if AUsuario = nil then
        raise Exception.Create('Usuário não autenticado.');
end;

end.
