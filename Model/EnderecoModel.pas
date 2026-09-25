unit EnderecoModel;

interface
type
  TEndereco = class
  private
    FCep: string;
    FLogradouro: string;
    FNumero: string;
    FComplemento: string;
    FBairro: string;
    FCidadeId: Integer;
    FCidadeNome: string;
    FEstadoUf: string;
    FEstadoNome: string;
  public
    property Cep: string read FCep write FCep;
    property Logradouro: string read FLogradouro write FLogradouro;
    property Numero: string read FNumero write FNumero;
    property Complemento: string read FComplemento write FComplemento;
    property Bairro: string read FBairro write FBairro;
    property CidadeId: Integer read FCidadeId write FCidadeId;
    property CidadeNome: string read FCidadeNome write FCidadeNome;
    property EstadoUf: string read FEstadoUf write FEstadoUf;
    property EstadoNome: string read FEstadoNome write FEstadoNome;
  end;

implementation

end.
