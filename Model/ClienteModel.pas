unit ClienteModel;

interface
uses
  System.SysUtils, EnderecoModel;

type
    TCliente = class
    private
           FId: Integer;
           FNome: string;
           FCpfCnpj: string;
           FDataNascimento: TDateTime;
           FEndereco: TEndereco;
   
   public
         constructor Create;
         destructor Destroy; override;
  
         property Id: Integer read FId write FId;
         property Nome: string read FNome write FNome;
         property CpfCnpj: string read FCpfCnpj write FCpfCnpj;   
         property DataNascimento: TDateTime read FDataNascimento write FDataNascimento;
         property Endereco: TEndereco read FEndereco;

   end;

implementation

{ TCliente }

constructor TCliente.Create;
begin
     inherited Create;
     FEndereco := TEndereco.Create;
end;

destructor TCliente.Destroy;
begin
     FEndereco.Free;
     inherited; inherited;
end;

end.
