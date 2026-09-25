unit ClienteView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.Generics.Collections, ClienteController, ClienteModel;

type
  TfrmCliente = class(TForm)
    btnFechar: TButton;
    gbxPesquisar: TGroupBox;
    lblPesquisa: TLabel;
    cmbCampoPesquisa: TComboBox;
    btnPesquisar: TButton;
    lblCampoPesquisa: TLabel;
    edtPesquisa: TEdit;
    grdClientes: TDBGrid;
    btnExcluir: TButton;
    btnEditar: TButton;
    btnNovo: TButton;
    mtbClientes: TFDMemTable;
    dscClientes: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);

  private
    { Private declarations }
    FController: TClienteController;
    procedure CarregarClientes;
    procedure PreencherGrid(const AClientes: TObjectList<TCliente>);
  public
    { Public declarations }
  end;

var
  frmCliente: TfrmCliente;

implementation
uses
    ClienteCadastroView;

{$R *.dfm}

procedure TfrmCliente.btnEditarClick(Sender: TObject);
var
   FormCadastro: TfrmClientreCadastro;
   ClienteId: Integer;
begin
     if mtbClientes.IsEmpty then
     begin
          MessageDlg('Selecione um cliente para editar.', mtWarning, [mbOK], 0);
          Exit;
     end;

     ClienteId := mtbClientes.FieldByName('ID').AsInteger;

     FormCadastro := TfrmClientreCadastro.Create(nil);
     try
        FormCadastro.CarregarCliente(ClienteId);

        if FormCadastro.ShowModal = mrOk then
           CarregarClientes;
     finally
            FormCadastro.Free;
     end;

end;

procedure TfrmCliente.btnExcluirClick(Sender: TObject);
var
   ClienteId: Integer;
begin
     if mtbClientes.IsEmpty then
     begin
          MessageDlg('Selecione um cliente para excluir.', mtWarning, [mbOK], 0);
          Exit;
     end;

     ClienteId := mtbClientes.FieldByName('ID').AsInteger;

     if MessageDlg('Deseja realmente excluir o cliente selecionado?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
        Exit;

     try
        FController.Excluir(ClienteId);
        CarregarClientes;
     except
           on E: Exception do
              MessageDlg(E.Message, mtError, [mbOK], 0);
     end;
end;

procedure TfrmCliente.btnFecharClick(Sender: TObject);
begin
     Close;
end;

procedure TfrmCliente.btnNovoClick(Sender: TObject);
var
   FormCadastro: TfrmClientreCadastro;
begin
     FormCadastro := TfrmClientreCadastro.Create(nil);
     try
        if FormCadastro.ShowModal = mrOk then
           CarregarClientes;
     finally
            FormCadastro.Free;
     end;
end;

procedure TfrmCliente.btnPesquisarClick(Sender: TObject);
var
   Clientes: TObjectList<TCliente>;
begin
     if Trim(edtPesquisa.Text) = '' then
     begin
         CarregarClientes;
         Exit;
     end;

     Clientes := FController.Pesquisar(cmbCampoPesquisa.Text, Trim(edtPesquisa.Text));

     try
         PreencherGrid(Clientes);
     finally
            Clientes.Free;
     end;


end;

procedure TfrmCliente.CarregarClientes;
var
   Clientes: TObjectList<TCliente>;
begin
     Clientes := FController.Listar;
     try
         PreencherGrid(Clientes);

     finally
            Clientes.Free;
     end;

end;

procedure TfrmCliente.FormCreate(Sender: TObject);
begin
     FController := TClienteController.Create;

     mtbClientes.CreateDataSet;
     CarregarClientes;
end;

procedure TfrmCliente.FormDestroy(Sender: TObject);
begin
     FController.Free;
end;

procedure TfrmCliente.PreencherGrid(const AClientes: TObjectList<TCliente>);
var
   Cliente: TCliente;
begin
     mtbClientes.DisableControls;
     try
        mtbClientes.EmptyDataSet;

        for Cliente in AClientes do
        begin
             mtbClientes.Append;

             mtbClientes.FieldByName('ID').AsInteger := Cliente.Id;
             mtbClientes.FieldByName('NOME').AsString := Cliente.Nome;
             mtbClientes.FieldByName('CPF_CNPJ').AsString := Cliente.CpfCnpj;
             mtbClientes.FieldByName('CEP').AsString := Cliente.Endereco.Cep;
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
end;

end.
