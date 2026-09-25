unit UsuarioRepository;

interface

uses
  UsuarioModel, System.Generics.Collections;

  type
    TUsuarioRepository = class
      public
            function BuscarPorId(const AId: Integer): TUsuario;
            function BuscarPorLogin(const ALogin: string): TUsuario;
            function ListarBloqueados: TObjectList<TUsuario>;
            procedure AtualizarTentativasInvalidas(const AUsuarioId,  ATentativasInvalidas: Integer);
            procedure AtualizarBloqueio(const AUsuarioId: Integer; const ABloqueado: Boolean);
            procedure AtualizarTotpSecret(const AUsuarioId: Integer; const ATotpSecret: string);
    end;

implementation
  uses
    System.SysUtils, FireDAC.Comp.Client, DatabaseDataModule;

{ TUsuarioRepository }




procedure TUsuarioRepository.AtualizarBloqueio(const AUsuarioId: Integer; const ABloqueado: Boolean);
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := dmDatabase.conDatabase;
    Query.SQL.Text := 'UPDATE USUARIO ' +
                      'SET BLOQUEADO = :BLOQUEADO ' +
                      'WHERE ID = :USUARIO_ID';

    Query.ParamByName('BLOQUEADO').AsBoolean :=  ABloqueado;

    Query.ParamByName('USUARIO_ID').AsInteger := AUsuarioId;

    Query.ExecSQL;
  finally
      Query.Free;
  end;

end;

procedure TUsuarioRepository.AtualizarTentativasInvalidas(const AUsuarioId,  ATentativasInvalidas: Integer);
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := dmDatabase.conDatabase;
    Query.SQL.Text := 'UPDATE USUARIO ' +
                      'SET TENTATIVAS_INVALIDAS = :TENTATIVAS_INVALIDAS ' +
                      'WHERE ID = :USUARIO_ID';
    Query.ParamByName('TENTATIVAS_INVALIDAS').AsInteger := ATentativasInvalidas;  
    Query.ParamByName('USUARIO_ID').AsInteger := AUsuarioId;

    Query.ExecSQL;
  finally
    Query.Free;
  end;
end;

procedure TUsuarioRepository.AtualizarTotpSecret(const AUsuarioId: Integer;
  const ATotpSecret: string);
var
  Query: TFDQuery;
begin
    Query := TFDQuery.Create(nil);
    try
      Query.Connection := dmDatabase.conDatabase;
      Query.SQL.Text := 'UPDATE USUARIO ' +
                        'SET TOTP_SECRET = :TOTP_SECRET '+
                        'WHERE ID = :USUARIO_ID';

      Query.ParamByName('TOTP_SECRET').AsString := ATotpSecret;
      Query.ParamByName('USUARIO_ID').AsInteger := AUsuarioId;

      Query.ExecSQL;

    finally
       Query.Free;
    end;
end;

function TUsuarioRepository.BuscarPorId(const AId: Integer): TUsuario;
var
   Query: TFDQuery;
   Usuario: TUsuario;
begin
     Result := nil;
     Query := TFDQuery.Create(nil);

     try
        Query.Connection := dmDatabase.conDatabase;
        Query.SQL.Text := 'SELECT ID, NOME, LOGIN, SENHA_HASH, TOTP_SECRET, ' +
                          'TENTATIVAS_INVALIDAS, BLOQUEADO, ADMINISTRADOR ' +
                          'FROM USUARIO ' +
                          'WHERE ID = :ID';

        Query.ParamByName('ID').AsInteger := AId;
        Query.Open;

        if not Query.IsEmpty then
        begin
             Usuario := TUsuario.Create;

             Usuario.Id := Query.FieldByName('ID').AsInteger;
             Usuario.Nome := Query.FieldByName('NOME').AsString;
             Usuario.Login := Query.FieldByName('LOGIN').AsString;
             Usuario.SenhaHash := Query.FieldByName('SENHA_HASH').AsString;
             Usuario.TOTPSecret := Query.FieldByName('TOTP_SECRET').AsString;
             Usuario.TentativasInvalidas := Query.FieldByName('TENTATIVAS_INVALIDAS').AsInteger;
             Usuario.Bloqueado := Query.FieldByName('BLOQUEADO').AsBoolean;
             Usuario.Administrador := Query.FieldByName('ADMINISTRADOR').AsBoolean;

             Result := Usuario;
        end;
     finally
            Query.Free;
     end;

end;

function TUsuarioRepository.BuscarPorLogin(const ALogin: string): TUsuario;
var
  Query: TFDQuery;
begin
  Result := nil;
  Query := TFDQuery.Create(nil);

  try
    Query.Connection := dmDatabase.conDatabase;

    Query.SQL.Text := 'SELECT ID, NOME, LOGIN, SENHA_HASH, TOTP_SECRET, ' +
                      'TENTATIVAS_INVALIDAS, BLOQUEADO, ADMINISTRADOR ' +
                      'FROM USUARIO ' +
                      'WHERE LOGIN = :LOGIN';

    Query.ParamByName('LOGIN').AsString := ALogin;

    Query.Open;

    if not Query.IsEmpty then
    begin
         var Usuario := TUsuario.Create;

         Usuario.Id := Query.FieldByName('ID').AsInteger;
         Usuario.Nome := Query.FieldByName('NOME').AsString;
         Usuario.Login := Query.FieldByName('LOGIN').AsString;
         Usuario.SenhaHash := Query.FieldByName('SENHA_HASH').AsString;
         Usuario.TOTPSecret := Query.FieldByName('TOTP_SECRET').AsString;
         Usuario.TentativasInvalidas := Query.FieldByName('TENTATIVAS_INVALIDAS').AsInteger;
         Usuario.Bloqueado := Query.FieldByName('BLOQUEADO').AsBoolean;
         Usuario.Administrador := Query.FieldByName('ADMINISTRADOR').AsBoolean;

         Result := Usuario;

    end;

  finally
    Query.Free;
  end;

end;





function TUsuarioRepository.ListarBloqueados: TObjectList<TUsuario>;
var
   Query: TFDQuery;
   Usuario: TUsuario;
begin
     Result := TObjectList<TUsuario>.Create(True);
     try
         Query := TFDQuery.Create(nil);

         try
            Query.Connection := dmDatabase.conDatabase;
            Query.SQL.Text := 'SELECT ID, NOME, LOGIN, SENHA_HASH, TOTP_SECRET, ' +
                              'TENTATIVAS_INVALIDAS, BLOQUEADO, ADMINISTRADOR ' +
                              'FROM USUARIO ' +
                              'WHERE BLOQUEADO = TRUE ' +
                              'ORDER BY NOME';

            Query.Open;

            while not Query.Eof do
            begin
                 Usuario := TUsuario.Create;

                 Usuario.Id := Query.FieldByName('ID').AsInteger;
                 Usuario.Nome := Query.FieldByName('NOME').AsString;
                 Usuario.Login := Query.FieldByName('LOGIN').AsString;
                 Usuario.SenhaHash := Query.FieldByName('SENHA_HASH').AsString;
                 Usuario.TOTPSecret := Query.FieldByName('TOTP_SECRET').AsString;
                 Usuario.TentativasInvalidas := Query.FieldByName('TENTATIVAS_INVALIDAS').AsInteger;
                 Usuario.Bloqueado := Query.FieldByName('BLOQUEADO').AsBoolean;
                 Usuario.Administrador := Query.FieldByName('ADMINISTRADOR').AsBoolean;

                 Result.Add(Usuario);
                 Query.Next;
            end;

         finally
               Query.Free;
         end;
     except
           Result.Free;
           raise;
     end;
end;

end.
