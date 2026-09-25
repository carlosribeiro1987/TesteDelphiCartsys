unit TotpService;

interface

type
TTotpService = class
  public
    class function GerarSecret: string; static;
    class function ValidarCodigo(const ASecret: string; const ACodigo: string): Boolean; static;
    class function GerarUri(const ASecret, ALogin: string): string; static;
  end;


implementation
  uses
    System.SysUtils, GoogleOTP;



{ TTotpService }

class function TTotpService.GerarSecret: string;
begin
  Result := GenerateOTPSecret;
end;

class function TTotpService.GerarUri(const ASecret, ALogin: string): string;
begin
     Result :=
    'otpauth://totp/Cartsys:' + ALogin +
    '?secret=' + ASecret +
    '&issuer=Cartsys' +
    '&algorithm=SHA1' +
    '&digits=6' +
    '&period=30';
end;

class function TTotpService.ValidarCodigo(const ASecret,
  ACodigo: string): Boolean;
var
  Codigo: Integer;
begin
  Result := False;
  if Length(ACodigo) <> 6 then
    Exit;
  if not TryStrToInt(ACodigo, Codigo) then
    Exit;

  Result := ValidateTOPT(ASecret, Codigo, 0);
end;

end.
