unit UsuarioController;

interface
uses
    System.Generics.Collections, UsuarioModel, UsuarioService;

type
    TUsuarioController = class
    private
           FUsuarioService: TUsuarioService;
    public
          constructor Create;
          destructor Destroy; override;
          function ListarBloqueados(const AAdministrador: TUsuario): TObjectList<TUsuario>;
          procedure DesbloquearUsuario(const AAdministrador: TUsuario; const AUsuarioId: Integer);
    end;


implementation

{ TUsuarioController }

constructor TUsuarioController.Create;
begin
     inherited Create;
     FUsuarioService := TUsuarioService.Create;
end;

procedure TUsuarioController.DesbloquearUsuario(const AAdministrador: TUsuario;
  const AUsuarioId: Integer);
begin
      FUsuarioService.DesbloquearUsuario(AAdministrador, AUsuarioId);
end;

destructor TUsuarioController.Destroy;
begin
     FUsuarioService.Free;
     inherited;;
end;

function TUsuarioController.ListarBloqueados(
  const AAdministrador: TUsuario): TObjectList<TUsuario>;
begin
     Result := FUsuarioService.ListarBloqueados(AAdministrador);
end;

end.
