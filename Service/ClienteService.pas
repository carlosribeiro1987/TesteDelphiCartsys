unit ClienteService;

interface
uses
  System.Generics.Collections,  ClienteModel, ClienteRepository, CidadeRepository;

type
  TClienteService = class
  private
    FRepository: TClienteRepository;
    FCidadeRepository: TCidadeRepository;
    procedure ValidarExclusao(const AId: Integer);
    procedure ResolverCidade(const ACliente: TCliente);
  public
    constructor Create;
    destructor Destroy; override;

    function BuscarPorId(const AId: Integer): TCliente;
    function Listar: TObjectList<TCliente>;
    function Inserir(const ACliente: TCliente): Integer;
    procedure Atualizar(const ACliente: TCliente);
    procedure Excluir(const AId: Integer);
    function Pesquisar(const ACampo, AValor: string): TObjectList<TCliente>;
    function ListarParaRelatorio(const AIdInicial, AIdFinal: Integer; const ACidade, AEstado: string): TObjectList<TCliente>;
  end;

implementation
uses
    System.SysUtils, DatabaseDataModule;

{ TClienteService }

constructor TClienteService.Create;
begin
     inherited Create;
     FRepository := TClienteRepository.Create;
     FCidadeRepository := TCidadeRepository.Create;
end;

destructor TClienteService.Destroy;
begin
     FCidadeRepository.Free;
     FRepository.Free;
     inherited;
end;

procedure TClienteService.Atualizar(const ACliente: TCliente);
begin
      dmDatabase.conDatabase.StartTransaction;
      try
         ResolverCidade(ACliente);
         FRepository.Atualizar(ACliente);
         dmDatabase.conDatabase.Commit;
      except
            dmDatabase.conDatabase.Rollback;
            raise;
      end;
end;

function TClienteService.BuscarPorId(const AId: Integer): TCliente;
begin
     Result := FRepository.BuscarPorId(AId);
end;





procedure TClienteService.Excluir(const AId: Integer);
begin
     ValidarExclusao(AId);
     dmDatabase.conDatabase.StartTransaction;

     try
        FRepository.Excluir(AId);
        dmDatabase.conDatabase.Commit;
     except
           dmDatabase.conDatabase.Rollback;
           raise;
     end;
end;

function TClienteService.Inserir(const ACliente: TCliente): Integer;
begin
     dmDatabase.conDatabase.StartTransaction;
     try
        ResolverCidade(ACliente);
         Result := FRepository.Inserir(ACliente);
         dmDatabase.conDatabase.Commit;
     except
           dmDatabase.conDatabase.Rollback;
           raise;
     end;
end;

function TClienteService.Listar: TObjectList<TCliente>;
begin
     Result := FRepository.Listar;
end;

function TClienteService.ListarParaRelatorio(const AIdInicial,
  AIdFinal: Integer; const ACidade, AEstado: string): TObjectList<TCliente>;
begin
      if (AIdInicial > 0) and (AIdFinal > 0) and (AIdInicial > AIdFinal) then
         raise Exception.Create('O ID inicial não pode ser maior que o ID final.');

      Result := FRepository.ListarParaRelatorio(AIdInicial, AIdFinal, Trim(ACidade), Trim(AEstado));
end;

function TClienteService.Pesquisar(const ACampo,
  AValor: string): TObjectList<TCliente>;
begin
     Result := FRepository.Pesquisar(ACampo, AValor);
end;

procedure TClienteService.ResolverCidade(const ACliente: TCliente);
var
   CidadeId: Integer;
   EstadoId: Integer;
begin
     CidadeId := FCidadeRepository.BuscarCidadeId(ACliente.Endereco.CidadeNome, ACliente.Endereco.EstadoUf);
     if CidadeId = 0 then
     begin
          EstadoId := FCidadeRepository.BuscarEstadoId(ACliente.Endereco.EstadoUf);
          if EstadoId = 0 then
          begin
               EstadoId := FCidadeRepository.InserirEstado(ACliente.Endereco.EstadoNome, ACliente.Endereco.EstadoUf);
          end;
          CidadeId := FCidadeRepository.InserirCidade(ACliente.Endereco.CidadeNome, EstadoId);
     end;
      ACliente.Endereco.CidadeId := CidadeId;
end;

procedure TClienteService.ValidarExclusao(const AId: Integer);
begin
     if AId in [1, 5, 8, 10, 15] then
        raise Exception.Create('Este cliente não pode ser excluído.');
end;

end.
