unit DatabaseSeed;

interface

type
  TDatabaseSeed = class
  private
    class procedure SeedAdministrador; static;
    class procedure SeedUsuarios; static;
    class procedure SeedClientes; static;
  public
    class procedure Executar; static;
  end;

implementation

uses
    System.SysUtils, FireDAC.Comp.Client, FireDAC.DApt, DatabaseDataModule, PasswordService;

class procedure TDatabaseSeed.Executar;
begin
     SeedAdministrador;
     SeedUsuarios;
     SeedClientes;
end;

class procedure TDatabaseSeed.SeedAdministrador;
var
   Query: TFDQuery;
   SenhaHash: string;
begin
     Query := TFDQuery.Create(nil);
     try
        Query.Connection := dmDatabase.conDatabase;

        Query.SQL.Text := 'SELECT COUNT(*) AS TOTAL FROM USUARIO ' +
                          'WHERE ADMINISTRADOR = TRUE';
        Query.Open;

        if Query.FieldByName('TOTAL').AsInteger > 0 then
           Exit;

        Query.Close;

        SenhaHash := TPasswordService.GerarHash('Admin@123');

        Query.SQL.Text := 'INSERT INTO USUARIO ' +
                          '(NOME, LOGIN, SENHA_HASH, TOTP_SECRET, TENTATIVAS_INVALIDAS, BLOQUEADO, ADMINISTRADOR) ' +
                          'VALUES (:NOME, :LOGIN, :SENHA_HASH, NULL, 0, FALSE, TRUE)';

        Query.ParamByName('NOME').AsString := 'Administrador01';
        Query.ParamByName('LOGIN').AsString := 'admin01';
        Query.ParamByName('SENHA_HASH').AsString := SenhaHash;

        Query.ExecSQL;
     finally
            Query.Free;
     end;
end;

class procedure TDatabaseSeed.SeedClientes;
var
   Query: TFDQuery;
   EstadoId: Integer;
   CidadeId: Integer;
   I: Integer;
begin
     Query := TFDQuery.Create(nil);
     try
        Query.Connection := dmDatabase.conDatabase;

        Query.SQL.Text := 'SELECT COUNT(*) AS TOTAL FROM CLIENTE';
        Query.Open;

        if Query.FieldByName('TOTAL').AsInteger > 0 then
           Exit;

        Query.Close;

        Query.SQL.Text := 'SELECT ID FROM ESTADO WHERE UF = :UF';
        Query.ParamByName('UF').AsString := 'SC';
        Query.Open;

        if Query.IsEmpty then
        begin
             Query.Close;
             Query.SQL.Text := 'INSERT INTO ESTADO (NOME, UF) ' +
                            'VALUES (:NOME, :UF) RETURNING ID';
             Query.ParamByName('NOME').AsString := 'Santa Catarina';
             Query.ParamByName('UF').AsString := 'SC';
             Query.Open;
        end;

        EstadoId := Query.FieldByName('ID').AsInteger;
        Query.Close;

        Query.SQL.Text := 'SELECT ID FROM CIDADE ' +
                          'WHERE NOME = :NOME AND ESTADOID = :ESTADOID';
        Query.ParamByName('NOME').AsString := 'Blumenau';
        Query.ParamByName('ESTADOID').AsInteger := EstadoId;
        Query.Open;

        if Query.IsEmpty then
        begin
             Query.Close;
             Query.SQL.Text := 'INSERT INTO CIDADE (NOME, ESTADOID) ' +
                               'VALUES (:NOME, :ESTADOID) RETURNING ID';
                            Query.ParamByName('NOME').AsString := 'Blumenau';
             Query.ParamByName('ESTADOID').AsInteger := EstadoId;
             Query.Open;
        end;

        CidadeId := Query.FieldByName('ID').AsInteger;
        Query.Close;

        for I := 1 to 15 do
        begin
             Query.SQL.Text := 'INSERT INTO CLIENTE ' +
                               '(NOME, CEP, CPF_CNPJ, ENDERECO, NUMERO, COMPLEMENTO, BAIRRO, CIDADE, DATANASCIMENTO) ' +
                               'VALUES (:NOME, :CEP, :CPF_CNPJ, :ENDERECO, :NUMERO, NULL, :BAIRRO, :CIDADE, NULL)';

             Query.ParamByName('NOME').AsString := Format('Cliente Teste %.2d', [I]);
             Query.ParamByName('CEP').AsString := '89010000';
             Query.ParamByName('CPF_CNPJ').AsString := Format('00000000%.3d', [I]);
             Query.ParamByName('ENDERECO').AsString := 'Rua de Teste';
             Query.ParamByName('NUMERO').AsString := IntToStr(I);
             Query.ParamByName('BAIRRO').AsString := 'Centro';
             Query.ParamByName('CIDADE').AsInteger := CidadeId;

             Query.ExecSQL;
        end;
     finally
            Query.Free;
     end;
end;

class procedure TDatabaseSeed.SeedUsuarios;
var
   Query: TFDQuery;
   SenhaHash: string;
begin
     Query := TFDQuery.Create(nil);
     try
        Query.Connection := dmDatabase.conDatabase;

        Query.SQL.Text := 'SELECT COUNT(*) AS TOTAL FROM USUARIO WHERE LOGIN = :LOGIN';
         Query.ParamByName('LOGIN').AsString := 'usuario01';
         Query.Open;
         if Query.FieldByName('TOTAL').AsInteger = 0 then
         begin
              Query.Close;

              SenhaHash := TPasswordService.GerarHash('Usuario@123');

              Query.SQL.Text := 'INSERT INTO USUARIO ' +
                                '(NOME, LOGIN, SENHA_HASH, TOTP_SECRET, TENTATIVAS_INVALIDAS, BLOQUEADO, ADMINISTRADOR) ' +
                                'VALUES (:NOME, :LOGIN, :SENHA_HASH, NULL, 0, FALSE, FALSE)';

              Query.ParamByName('NOME').AsString := 'Usuário Teste 01';
              Query.ParamByName('LOGIN').AsString := 'usuario01';
              Query.ParamByName('SENHA_HASH').AsString := SenhaHash;

              Query.ExecSQL;
         end
         else
             Query.Close;

         Query.SQL.Text := 'SELECT COUNT(*) AS TOTAL FROM USUARIO WHERE LOGIN = :LOGIN';
         Query.ParamByName('LOGIN').AsString := 'usuario02';
         Query.Open;

         if Query.FieldByName('TOTAL').AsInteger = 0 then
         begin
              Query.Close;

              SenhaHash := TPasswordService.GerarHash('Usuario@123');

              Query.SQL.Text := 'INSERT INTO USUARIO ' +
                                '(NOME, LOGIN, SENHA_HASH, TOTP_SECRET, TENTATIVAS_INVALIDAS, BLOQUEADO, ADMINISTRADOR) ' +
                                'VALUES (:NOME, :LOGIN, :SENHA_HASH, NULL, 0, FALSE, FALSE)';

              Query.ParamByName('NOME').AsString := 'Usuário Teste 02';
              Query.ParamByName('LOGIN').AsString := 'usuario02';
              Query.ParamByName('SENHA_HASH').AsString := SenhaHash;

              Query.ExecSQL;
        end
        else
            Query.Close;

     finally
            Query.Free;
     end;

end;

end.
