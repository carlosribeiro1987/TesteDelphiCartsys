unit PasswordService;

interface
type
  TPasswordService = class
    public
      class function GerarHash(const ASenha: string): string; static;
      class function ValidarSenha(const ASenha, AHash: string): Boolean; static;
  end;


implementation

uses
  Bcrypt;

{ TPasswordService }

class function TPasswordService.GerarHash(const ASenha: string): string;
begin
     Result := TBCrypt.HashPassword(ASenha);
end;

class function TPasswordService.ValidarSenha(const ASenha,
  AHash: string): Boolean;
  var
    HashDesatualizado: Boolean;
begin
     Result := TBCrypt.CheckPassword(ASenha, AHash, HashDesatualizado);
end;

end.
