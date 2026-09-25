unit ClienteRepository;

interface
uses
  System.Generics.Collections,
  ClienteModel;

type
  TClienteRepository = class
  public
    function BuscarPorId(const AId: Integer): TCliente;
    function Listar: TObjectList<TCliente>;
    function Pesquisar(const ACampo, AValor: string): TObjectList<TCliente>;
    function Inserir(const ACliente: TCliente): Integer;
    procedure Atualizar(const ACliente: TCliente);
    procedure Excluir(const AId: Integer);

    function ListarParaRelatorio(const AIdInicial, AIdFinal: Integer; const ACidade, AEstado: string): TObjectList<TCliente>;
  end;

implementation
uses
    SysUtils,
    FireDAC.Comp.Client,
    DatabaseDataModule;

{ TClienteRepository }

function TClienteRepository.BuscarPorId(const AId: Integer): TCliente;
var
   Query: TFDQuery;
   Cliente: TCliente;
begin
     Result := nil;
     Query := TFDQuery.Create(nil);

     try
        Query.Connection := dmDatabase.conDatabase;
        Query.SQL.Text := 'SELECT C.ID, C.NOME, C.CEP, C.CPF_CNPJ, C.ENDERECO, C.NUMERO, ' +
                          'C.COMPLEMENTO, C.BAIRRO, C.CIDADE, C.DATANASCIMENTO, ' +
                          'CI.NOME AS CIDADE_NOME, E.UF AS ESTADO_UF, E.NOME AS ESTADO_NOME ' +
                          'FROM CLIENTE C ' +
                          'INNER JOIN CIDADE CI ON CI.ID = C.CIDADE ' +
                          'INNER JOIN ESTADO E ON E.ID = CI.ESTADOID ' +
                          'WHERE C.ID = :ID';

        Query.ParamByName('ID').AsInteger := AId;
        Query.Open;

        if Query.IsEmpty then
          Exit;

        Cliente := TCliente.Create;

        Cliente.Id := Query.FieldByName('ID').AsInteger;
        Cliente.Nome := Query.FieldByName('NOME').AsString;
        Cliente.CpfCnpj := Query.FieldByName('CPF_CNPJ').AsString;

        Cliente.Endereco.Cep := Query.FieldByName('CEP').AsString;
        Cliente.Endereco.Logradouro := Query.FieldByName('ENDERECO').AsString;
        Cliente.Endereco.Numero := Query.FieldByName('NUMERO').AsString;
        Cliente.Endereco.Complemento := Query.FieldByName('COMPLEMENTO').AsString;
        Cliente.Endereco.Bairro := Query.FieldByName('BAIRRO').AsString;
        Cliente.Endereco.CidadeId := Query.FieldByName('CIDADE').AsInteger;
        Cliente.Endereco.CidadeNome := Query.FieldByName('CIDADE_NOME').AsString;
        Cliente.Endereco.EstadoUf := Query.FieldByName('ESTADO_UF').AsString;
        Cliente.Endereco.EstadoNome := Query.FieldByName('ESTADO_NOME').AsString;

        if Query.FieldByName('DATANASCIMENTO').IsNull then
           Cliente.DataNascimento := 0
        else
            Cliente.DataNascimento := Query.FieldByName('DATANASCIMENTO').AsDateTime;

        Result := Cliente;
     finally
            Query.Free;
     end;
end;

function TClienteRepository.Listar: TObjectList<TCliente>;
var
   Query: TFDQuery;
   Cliente: TCliente;
begin
     Result := TObjectList<TCliente>.Create(True);
     Query := TFDQuery.Create(nil);

     try
        try
           Query.Connection := dmDatabase.conDatabase;
           Query.SQL.Text := 'SELECT C.ID, C.NOME, C.CEP, C.CPF_CNPJ, C.ENDERECO, C.NUMERO, ' +
                             'C.COMPLEMENTO, C.BAIRRO, C.CIDADE, C.DATANASCIMENTO, ' +
                             'CI.NOME AS CIDADE_NOME, E.UF AS ESTADO_UF ' +
                             'FROM CLIENTE C ' +
                             'INNER JOIN CIDADE CI ON CI.ID = C.CIDADE ' +
                             'INNER JOIN ESTADO E ON E.ID = CI.ESTADOID ' +
                             'ORDER BY C.NOME';

           Query.Open;

           while not Query.Eof do
           begin
                Cliente := TCliente.Create;

                Cliente.Id := Query.FieldByName('ID').AsInteger;
                Cliente.Nome := Query.FieldByName('NOME').AsString;
                Cliente.CpfCnpj := Query.FieldByName('CPF_CNPJ').AsString;

                Cliente.Endereco.Cep := Query.FieldByName('CEP').AsString;
                Cliente.Endereco.Logradouro := Query.FieldByName('ENDERECO').AsString;
                Cliente.Endereco.Numero := Query.FieldByName('NUMERO').AsString;
                Cliente.Endereco.Complemento := Query.FieldByName('COMPLEMENTO').AsString;
                Cliente.Endereco.Bairro := Query.FieldByName('BAIRRO').AsString;
                Cliente.Endereco.CidadeId := Query.FieldByName('CIDADE').AsInteger;
                Cliente.Endereco.CidadeNome := Query.FieldByName('CIDADE_NOME').AsString;
                Cliente.Endereco.EstadoUf := Query.FieldByName('ESTADO_UF').AsString;

                if Query.FieldByName('DATANASCIMENTO').IsNull then
                   Cliente.DataNascimento := 0
                else
                    Cliente.DataNascimento := Query.FieldByName('DATANASCIMENTO').AsDateTime;

                Result.Add(Cliente);
                Query.Next;
           end;
        except
              Result.Free;
              raise;
        end;
     finally
            Query.Free;
     end;
end;

function TClienteRepository.ListarParaRelatorio(const AIdInicial,
  AIdFinal: Integer; const ACidade, AEstado: string): TObjectList<TCliente>;
var
   Query: TFDQuery;
   Cliente: TCliente;
begin
     Result := TObjectList<TCliente>.Create(True);
     Query := TFDQuery.Create(nil);

     try
        try
           Query.Connection := dmDatabase.conDatabase;

           Query.SQL.Text :=  'SELECT C.ID, C.NOME, C.CEP, C.CPF_CNPJ, C.ENDERECO, C.NUMERO, ' +
                              'C.COMPLEMENTO, C.BAIRRO, C.CIDADE, C.DATANASCIMENTO, ' +
                              'CI.NOME AS CIDADE_NOME, E.UF AS ESTADO_UF ' +
                              'FROM CLIENTE C ' +
                              'INNER JOIN CIDADE CI ON CI.ID = C.CIDADE ' +
                              'INNER JOIN ESTADO E ON E.ID = CI.ESTADOID ' +
                              'WHERE 1 = 1 ';

           if (AIdInicial > 0) and (AIdFinal > 0) then
              Query.SQL.Add('AND C.ID BETWEEN :ID_INICIAL AND :ID_FINAL ');

           if Trim(ACidade) <> '' then
              Query.SQL.Add('AND CI.NOME CONTAINING :CIDADE ');

           if Trim(AEstado) <> '' then
              Query.SQL.Add('AND (E.UF CONTAINING :ESTADO OR E.NOME CONTAINING :ESTADO) ');

           Query.SQL.Add('ORDER BY C.NOME');

           if (AIdInicial > 0) and (AIdFinal > 0) then
           begin
                Query.ParamByName('ID_INICIAL').AsInteger := AIdInicial;
                Query.ParamByName('ID_FINAL').AsInteger := AIdFinal;
           end;

           if Trim(ACidade) <> '' then
              Query.ParamByName('CIDADE').AsString := ACidade;

           if Trim(AEstado) <> '' then
              Query.ParamByName('ESTADO').AsString := AEstado;

           Query.Open;

           while not Query.Eof do
           begin
                Cliente := TCliente.Create;

                Cliente.Id := Query.FieldByName('ID').AsInteger;
                Cliente.Nome := Query.FieldByName('NOME').AsString;
                Cliente.CpfCnpj := Query.FieldByName('CPF_CNPJ').AsString;

                Cliente.Endereco.Cep := Query.FieldByName('CEP').AsString;
                Cliente.Endereco.Logradouro := Query.FieldByName('ENDERECO').AsString;
                Cliente.Endereco.Numero := Query.FieldByName('NUMERO').AsString;
                Cliente.Endereco.Complemento := Query.FieldByName('COMPLEMENTO').AsString;
                Cliente.Endereco.Bairro := Query.FieldByName('BAIRRO').AsString;
                Cliente.Endereco.CidadeId := Query.FieldByName('CIDADE').AsInteger;
                Cliente.Endereco.CidadeNome := Query.FieldByName('CIDADE_NOME').AsString;
                Cliente.Endereco.EstadoUf := Query.FieldByName('ESTADO_UF').AsString;

                if Query.FieldByName('DATANASCIMENTO').IsNull then
                   Cliente.DataNascimento := 0
                else
                    Cliente.DataNascimento := Query.FieldByName('DATANASCIMENTO').AsDateTime;

                Result.Add(Cliente);
                Query.Next;
           end;
        except
              Result.Free;
              raise;
        end;
     finally
            Query.Free;
     end;

end;

function TClienteRepository.Pesquisar(const ACampo,
  AValor: string): TObjectList<TCliente>;
var
   Query: TFDQuery;
   Cliente: TCliente;
   Condicao: string;
begin
     Result := TObjectList<TCliente>.Create(True);
     Query := TFDQuery.Create(nil);

     try
        try
           query.Connection := dmDatabase.conDatabase;

           if SameText(ACampo, 'ID') then
              Condicao := 'C.ID = :VALOR'
           else if SameText(ACampo, 'NOME') then
                Condicao := 'C.NOME CONTAINING :VALOR'
           else if SameText(ACampo, 'CPF/CNPJ') then
                Condicao := 'C.CPF_CNPJ CONTAINING :VALOR'
           else if SameText(ACampo, 'CEP') then
                Condicao := 'C.CEP CONTAINING :VALOR'
           else if SameText(ACampo, 'CIDADE') then
                Condicao := 'CI.NOME CONTAINING :VALOR'
           else if SameText(ACampo, 'ESTADO') then
                Condicao := '(E.UF CONTAINING :VALOR OR E.NOME CONTAINING :VALOR)'
           else if SameText(ACampo, 'DATA DE NASCIMENTO') then
                Condicao := 'C.DATANASCIMENTO = :VALOR'
           else
               raise Exception.Create('Campo de pesquisa inválido.');

           Query.SQL.Text := 'SELECT C.ID, C.NOME, C.CEP, C.CPF_CNPJ, ' +
                             'C.ENDERECO, C.NUMERO, C.COMPLEMENTO, ' +
                             'C.BAIRRO, C.CIDADE, C.DATANASCIMENTO, ' +
                             'CI.NOME AS CIDADE_NOME, E.UF AS ESTADO_UF ' +
                             'FROM CLIENTE C ' +

                             'INNER JOIN CIDADE CI ON CI.ID = C.CIDADE ' +
                             'INNER JOIN ESTADO E ON E.ID = CI.ESTADOID ' +

                             'WHERE ' + Condicao + ' ' +
                             'ORDER BY C.NOME';

           if SameText(ACampo, 'ID') then
              Query.ParamByName('VALOR').AsInteger := StrToInt(AValor)
           else if SameText(ACampo, 'DATA DE NASCIMENTO') then
                Query.ParamByName('VALOR').AsDate := StrToDate(AValor)
           else
               Query.ParamByName('VALOR').AsString := AValor;

           Query.Open;

           while not Query.Eof do
           begin
                Cliente := TCliente.Create;

                Cliente.Id := Query.FieldByName('ID').AsInteger;
                Cliente.Nome := Query.FieldByName('NOME').AsString;
                Cliente.CpfCnpj := Query.FieldByName('CPF_CNPJ').AsString;

                Cliente.Endereco.Cep := Query.FieldByName('CEP').AsString;
                Cliente.Endereco.Logradouro := Query.FieldByName('ENDERECO').AsString;
                Cliente.Endereco.Numero := Query.FieldByName('NUMERO').AsString;
                Cliente.Endereco.Complemento := Query.FieldByName('COMPLEMENTO').AsString;
                Cliente.Endereco.Bairro := Query.FieldByName('BAIRRO').AsString;
                Cliente.Endereco.CidadeId := Query.FieldByName('CIDADE').AsInteger;
                Cliente.Endereco.CidadeNome := Query.FieldByName('CIDADE_NOME').AsString;
                Cliente.Endereco.EstadoUf := Query.FieldByName('ESTADO_UF').AsString;

                if Query.FieldByName('DATANASCIMENTO').IsNull then
                   Cliente.DataNascimento := 0
                else
                    Cliente.DataNascimento := Query.FieldByName('DATANASCIMENTO').AsDateTime;

                Result.Add(Cliente);
                Query.Next;
           end;
        except
              Result.Free;
              raise;
        end;
     finally
            Query.Free;
     end;
end;

procedure TClienteRepository.Atualizar(const ACliente: TCliente);
var
   Query: TFDQuery;
begin
     Query := TFDQuery.Create(nil);

     try
        Query.Connection := dmDatabase.conDatabase;
        Query.SQL.Text := 'UPDATE CLIENTE SET ' +
                          'NOME = :NOME, ' +
                          'CEP = :CEP, ' +
                          'CPF_CNPJ = :CPF_CNPJ, ' +
                          'ENDERECO = :ENDERECO, ' +
                          'NUMERO = :NUMERO, ' +
                          'COMPLEMENTO = :COMPLEMENTO, ' +
                          'BAIRRO = :BAIRRO, ' +
                          'CIDADE = :CIDADE, ' +
                          'DATANASCIMENTO = :DATANASCIMENTO ' +
                          'WHERE ID = :ID';

        Query.ParamByName('NOME').AsString := ACliente.Nome;
        Query.ParamByName('CEP').AsString := ACliente.Endereco.Cep;
        Query.ParamByName('CPF_CNPJ').AsString := ACliente.CpfCnpj;
        Query.ParamByName('ENDERECO').AsString := ACliente.Endereco.Logradouro;
        Query.ParamByName('NUMERO').AsString := ACliente.Endereco.Numero;
        Query.ParamByName('COMPLEMENTO').AsString := ACliente.Endereco.Complemento;
        Query.ParamByName('BAIRRO').AsString := ACliente.Endereco.Bairro;
        Query.ParamByName('CIDADE').AsInteger := ACliente.Endereco.CidadeId;
        Query.ParamByName('ID').AsInteger := ACliente.Id;

        if ACliente.DataNascimento = 0 then
           Query.ParamByName('DATANASCIMENTO').Clear
        else
            Query.ParamByName('DATANASCIMENTO').AsDate := ACliente.DataNascimento;

        Query.ExecSQL;
     finally
            Query.Free;
     end;
end;



procedure TClienteRepository.Excluir(const AId: Integer);
var
   Query: TFDQuery;
begin
     Query := TFDQuery.Create(nil);

     try
        Query.Connection := dmDatabase.conDatabase;
        Query.SQL.Text := 'DELETE FROM CLIENTE ' +
                          'WHERE ID = :ID';

        Query.ParamByName('ID').AsInteger := AId;

        Query.ExecSQL;
     finally
            Query.Free;
     end;
end;

function TClienteRepository.Inserir(const ACliente: TCliente): Integer;
var
   Query: TFDQuery;
begin
     Query := TFDQuery.Create(nil);

     try
        Query.Connection := dmDatabase.conDatabase;
        Query.SQL.Text := 'INSERT INTO CLIENTE ' +
                          '(NOME, CEP, CPF_CNPJ, ENDERECO, NUMERO, COMPLEMENTO, BAIRRO, CIDADE, DATANASCIMENTO) ' +
                          'VALUES ' +
                          '(:NOME, :CEP, :CPF_CNPJ, :ENDERECO, :NUMERO, :COMPLEMENTO, :BAIRRO, :CIDADE, :DATANASCIMENTO) ' +
                          'RETURNING ID';

        Query.ParamByName('NOME').AsString := ACliente.Nome;
        Query.ParamByName('CEP').AsString := ACliente.Endereco.Cep;
        Query.ParamByName('CPF_CNPJ').AsString := ACliente.CpfCnpj;
        Query.ParamByName('ENDERECO').AsString := ACliente.Endereco.Logradouro;
        Query.ParamByName('NUMERO').AsString := ACliente.Endereco.Numero;
        Query.ParamByName('COMPLEMENTO').AsString := ACliente.Endereco.Complemento;
        Query.ParamByName('BAIRRO').AsString := ACliente.Endereco.Bairro;
        Query.ParamByName('CIDADE').AsInteger := ACliente.Endereco.CidadeId;

        if ACliente.DataNascimento = 0 then
           Query.ParamByName('DATANASCIMENTO').Clear
        else
            Query.ParamByName('DATANASCIMENTO').AsDate := ACliente.DataNascimento;

        Query.Open;

        Result := Query.FieldByName('ID').AsInteger;
     finally
            Query.Free;
     end;
end;



end.
