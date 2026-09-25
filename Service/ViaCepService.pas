unit ViaCepService;

interface
uses
    EnderecoModel;

type
    TViaCepService = class
    private
           class function LimparCep(const ACep: string): string; static;
    public
          class function Buscar(const ACep: string): TEndereco; static;
    end;

implementation
uses
    System.SysUtils, System.Net.HttpClient, System.JSON;



{ TViaCepService }

class function TViaCepService.Buscar(const ACep: string): TEndereco;
var
   HttpClient: THTTPClient;
   Response: IHTTPResponse;
   Json: TJSONObject;
   Cep: string;
   CepNumerico: Int64;
begin
     Result := nil;
     Cep := LimparCep(ACep);

     if Length(Cep) <> 8 then
        raise Exception.Create('CEP inválido.');
     if not TryStrToInt64(Cep, CepNumerico) then
        raise Exception.Create('CEP inválido.');


     HttpClient := THTTPClient.Create;
     try
         Response := HttpClient.Get('https://viacep.com.br/ws/' + Cep + '/json/');
         if Response.StatusCode <> 200 then
            raise Exception.Create('Não foi possível consultar o CEP.');

         Json := TJSONObject.ParseJSONValue(Response.ContentAsString(TEncoding.UTF8)) as TJSONObject;
         try
             if Json = nil then
                raise Exception.Create('Resposta inválida do ViaCEP.');
             if Json.GetValue<Boolean>('erro', False) then
                raise Exception.Create('CEP não encontrado.');

             Result := TEndereco.Create;
             Result.Cep := Cep;
             Result.Logradouro := Json.GetValue<string>('logradouro','');
             Result.Complemento := Json.GetValue<string>('complemento','');
             Result.Bairro := Json.GetValue<string>('bairro','');
             Result.CidadeNome := Json.GetValue<string>('localidade','');
             Result.EstadoUf := Json.GetValue<string>('uf','');
             Result.EstadoNome := Json.GetValue<string>('estado', '');
         finally

                Json.Free;
         end;

     finally
            HttpClient.Free;

     end;


end;

class function TViaCepService.LimparCep(const ACep: string): string;
begin
     Result := ACep.Replace('-', '').Replace(' ', '');
end;

end.
