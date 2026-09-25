unit ClienteRelatorioView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.Client, ppProd, ppClass,
  ppReport, ppComm, ppRelatv, ppDB, ppDBPipe, Data.DB, FireDAC.Comp.DataSet,
  ppDesignLayer, ppParameter,
  ClienteController, ClienteModel, System.Generics.Collections, ppBands, ppCache,
  ppCtrls, ppPrnabl, ppVar;

type
  TfrmClienteRelatorio = class(TForm)
    gbxFiltros: TGroupBox;
    rbtTodos: TRadioButton;
    rbtFaixaIds: TRadioButton;
    rbtLocalidade: TRadioButton;
    pnlLocalidade: TPanel;
    lblCidade: TLabel;
    lblEstado: TLabel;
    edtCidade: TEdit;
    edtEstado: TEdit;
    pnlFaixaIds: TPanel;
    lblIdInicial: TLabel;
    lblIdFinal: TLabel;
    edtIdInicial: TEdit;
    edtIdFinal: TEdit;
    dscClientes: TDataSource;
    ppDBPipelineClientes: TppDBPipeline;
    ppRelatorioClientes: TppReport;
    mtbClientes: TFDMemTable;
    btnVisualizar: TButton;
    ppHeaderBand1: TppHeaderBand;
    ppDetailBand1: TppDetailBand;
    ppLabel1: TppLabel;
    ppLabel2: TppLabel;
    ppLabel4: TppLabel;
    ppLabel5: TppLabel;
    ppLabel6: TppLabel;
    ppLabel3: TppLabel;
    ppLabel7: TppLabel;
    ppLabel8: TppLabel;
    ppDBText1: TppDBText;
    ppDBText2: TppDBText;
    ppDBText3: TppDBText;
    ppDBText4: TppDBText;
    ppDBText5: TppDBText;
    ppDBText6: TppDBText;
    ppDBText7: TppDBText;
    ppFooterBand1: TppFooterBand;
    ppLabel9: TppLabel;
    ppSystemVariable1: TppSystemVariable;
    ppLabel10: TppLabel;
    ppSystemVariable2: TppSystemVariable;
    procedure FiltroClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnVisualizarClick(Sender: TObject);
  private
    { Private declarations }
    FController: TClienteController;
    procedure ConfigurarMemTable;
    procedure CarregarClientes;
  public
    { Public declarations }
  end;

var
  frmClienteRelatorio: TfrmClienteRelatorio;

implementation

{$R *.dfm}



procedure TfrmClienteRelatorio.btnVisualizarClick(Sender: TObject);
begin
     try
        CarregarClientes;

     if mtbClientes.IsEmpty then
     begin
          ShowMessage('Nenhum cliente encontrado para os filtros informados.');
          Exit;
     end;

     ppRelatorioClientes.Print;
  except
    on E: Exception do
      ShowMessage(E.Message);
  end;
end;

procedure TfrmClienteRelatorio.CarregarClientes;
var
   Clientes: TObjectList<TCliente>;
   Cliente: TCliente;
   IdInicial: Integer;
   IdFinal: Integer;
   Cidade: string;
   Estado: string;
begin
     IdInicial := 0;
     IdFinal := 0;
     Cidade := '';
     Estado := '';

     if rbtFaixaIds.Checked then
     begin
          if not TryStrToInt(Trim(edtIdInicial.Text), IdInicial) then
             raise Exception.Create('Informe um ID inicial válido.');

          if not TryStrToInt(Trim(edtIdFinal.Text), IdFinal) then
             raise Exception.Create('Informe um ID final válido.');
     end
     else if rbtLocalidade.Checked then
     begin
          Cidade := Trim(edtCidade.Text);
          Estado := Trim(edtEstado.Text);
     end;

     Clientes := FController.ListarParaRelatorio(IdInicial, IdFinal, Cidade, Estado);

     try
        mtbClientes.DisableControls;
        try
           mtbClientes.EmptyDataSet;

           for Cliente in Clientes do
           begin
                mtbClientes.Append;
                mtbClientes.FieldByName('ID').AsInteger := Cliente.Id;
                mtbClientes.FieldByName('NOME').AsString := Cliente.Nome;
                mtbClientes.FieldByName('CPF_CNPJ').AsString := Cliente.CpfCnpj;
                mtbClientes.FieldByName('CEP').AsString := Cliente.Endereco.Cep;
                mtbClientes.FieldByName('ENDERECO').AsString := Cliente.Endereco.Logradouro;
                mtbClientes.FieldByName('NUMERO').AsString := Cliente.Endereco.Numero;
                mtbClientes.FieldByName('BAIRRO').AsString := Cliente.Endereco.Bairro;
                mtbClientes.FieldByName('CIDADE').AsString := Cliente.Endereco.CidadeNome;
                mtbClientes.FieldByName('ESTADO').AsString := Cliente.Endereco.EstadoUf;

                if Cliente.DataNascimento = 0 then
                   mtbClientes.FieldByName('DATANASCIMENTO').Clear
                else
                    mtbClientes.FieldByName('DATANASCIMENTO').AsDateTime := Cliente.DataNascimento;

                mtbClientes.Post;
          end;
        finally
               mtbClientes.EnableControls;
        end;
     finally
            Clientes.Free;
     end;


end;

procedure TfrmClienteRelatorio.ConfigurarMemTable;
begin
     if not mtbClientes.Active then
        mtbClientes.CreateDataSet;
end;

procedure TfrmClienteRelatorio.FiltroClick(Sender: TObject);
begin
     pnlFaixaIds.Visible := rbtFaixaIds.Checked;
     pnlLocalidade.Visible := rbtLocalidade.Checked;
end;

procedure TfrmClienteRelatorio.FormCreate(Sender: TObject);
begin
     FController := TClienteController.Create;

     rbtTodos.Checked := True;
     pnlFaixaIds.Visible := False;
     pnlLocalidade.Visible := False;

     ConfigurarMemTable;
end;

procedure TfrmClienteRelatorio.FormDestroy(Sender: TObject);
begin
     FController.Free;
end;

end.
