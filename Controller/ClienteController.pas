unit ClienteController;

interface
uses
  System.Generics.Collections,
  ClienteModel,
  ClienteService;

type
  TClienteController = class
  private
    FService: TClienteService;
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

{ TClienteController }

procedure TClienteController.Atualizar(const ACliente: TCliente);
begin
     FService.Atualizar(ACliente);
end;

function TClienteController.BuscarPorId(const AId: Integer): TCliente;
begin
     Result := FService.BuscarPorId(AId);
end;

constructor TClienteController.Create;
begin
  inherited Create;
  FService := TClienteService.Create;
end;

destructor TClienteController.Destroy;
begin
  FService.Free;
  inherited;
end;

procedure TClienteController.Excluir(const AId: Integer);
begin
     FService.Excluir(AId);
end;

function TClienteController.Inserir(const ACliente: TCliente): Integer;
begin
     Result := FService.Inserir(ACliente);
end;

function TClienteController.Listar: TObjectList<TCliente>;
begin
     Result := FService.Listar;
end;

function TClienteController.ListarParaRelatorio(const AIdInicial,
  AIdFinal: Integer; const ACidade, AEstado: string): TObjectList<TCliente>;
begin
       Result := FService.ListarParaRelatorio(AIdInicial, AIdFinal, ACidade, AEstado);
end;

function TClienteController.Pesquisar(const ACampo,
  AValor: string): TObjectList<TCliente>;
begin
     Result := FService.Pesquisar(ACampo, AValor);
end;

end.
