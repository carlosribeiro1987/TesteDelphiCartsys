unit CidadeRepository;

interface
type
    TCidadeRepository = class
    public
          function BuscarCidadeId(const ACidade, AUf: string): Integer;
          function BuscarEstadoId(const AUf: string): Integer;
          function InserirEstado(const ANome, AUf: string): Integer;
          function InserirCidade(const ANome: string; const AEstadoId: Integer): Integer;
    end;
implementation
uses
    System.SysUtils, FireDAC.Comp.Client, DatabaseDataModule;


{ TCidadeRepository }

function TCidadeRepository.BuscarCidadeId(const ACidade, AUf: string): Integer;
var
   Query: TFDQuery;
begin
     Result := 0;
     Query := TFDQuery.Create(nil);
     try
        Query.Connection := dmDatabase.conDatabase;

        Query.SQL.Text := 'SELECT C.ID ' +
                          'FROM CIDADE C ' +
                          'INNER JOIN ESTADO E ON E.ID = C.ESTADOID ' +
                          'WHERE C.NOME = :CIDADE ' +
                          'AND E.UF = :UF';

        Query.ParamByName('CIDADE').AsString := ACidade;
        Query.ParamByName('UF').AsString := AUf;

        Query.Open;

        if not Query.IsEmpty then
           Result := Query.FieldByName('ID').AsInteger;

     finally
            Query.Free;
     end;

end;

function TCidadeRepository.BuscarEstadoId(const AUf: string): Integer;
var
   Query: TFDQuery;
begin
     Result := 0;
     Query := TFDQuery.Create(nil);
     try
        Query.Connection := dmDatabase.conDatabase;
        Query.SQL.Text := 'SELECT ID FROM ESTADO WHERE UF = :UF';
        Query.ParamByName('UF').AsString := AUf;
        Query.Open;

        if not Query.IsEmpty then
           Result := Query.FieldByName('ID').AsInteger;
     finally
            Query.Free;
     end;

end;

function TCidadeRepository.InserirCidade(const ANome: string;
  const AEstadoId: Integer): Integer;
var
   Query: TFDQuery;
begin
     Query := TFDQuery.Create(nil);
     try
        Query.Connection := dmDatabase.conDatabase;
        Query.SQL.Text := 'INSERT INTO CIDADE (NOME, ESTADOID) ' +
                          'VALUES (:NOME, :ESTADOID) ' +
                          'RETURNING ID';

        Query.ParamByName('NOME').AsString := ANome;
        Query.ParamByName('ESTADOID').AsInteger := AEstadoId;

        Query.Open;

        Result := Query.FieldByName('ID').AsInteger;
     finally
            Query.Free;
     end;

end;

function TCidadeRepository.InserirEstado(const ANome, AUf: string): Integer;
var
   Query: TFDQuery;
begin
     Query := TFDQuery.Create(nil);
     try
        Query.Connection := dmDatabase.conDatabase;
        Query.SQL.Text := 'INSERT INTO ESTADO (NOME, UF) ' +
                          'VALUES (:NOME, :UF) ' +
                          'RETURNING ID';

        Query.ParamByName('NOME').AsString := ANome;
        Query.ParamByName('UF').AsString := AUf;

        Query.Open;

        Result := Query.FieldByName('ID').AsInteger;
     finally
            Query.Free;
     end;

end;

end.
