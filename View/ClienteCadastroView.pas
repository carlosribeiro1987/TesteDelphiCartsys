unit ClienteCadastroView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.WinXPickers,
  Vcl.StdCtrls;

type
  TfrmClientreCadastro = class(TForm)
    gbxEndereco: TGroupBox;
    lblLogradouro: TLabel;
    edtLogradouro: TEdit;
    edtNumero: TEdit;
    lblNumero: TLabel;
    lblComplemento: TLabel;
    edtComplemento: TEdit;
    edtBairro: TEdit;
    lblBairro: TLabel;
    edtCidade: TEdit;
    lblCidade: TLabel;
    lblCep: TLabel;
    edtCep: TEdit;
    btnBuscarCep: TButton;
    lblEstado: TLabel;
    edtEstado: TEdit;
    gbxDadosPessoais: TGroupBox;
    edtNome: TEdit;
    lblNome: TLabel;
    lblCpfCnpj: TLabel;
    edtCpfCnpj: TEdit;
    lblDataNascimento: TLabel;
    dtpDataNascimento: TDateTimePicker;
    btnCancelar: TButton;
    btnSalvar: TButton;
    procedure btnBuscarCepClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edtCepKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtCepKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    FClienteId: Integer;
    FEstadoNome: string;
    FEstadoUf: string;
    procedure HabilitarEndereco(const AHabilitar: Boolean);
  public
    { Public declarations }
    procedure CarregarCliente(const AClienteId: Integer);
  end;

var
  frmClientreCadastro: TfrmClientreCadastro;

implementation
uses
    ViaCepService, EnderecoModel, ClienteModel, ClienteController;

{$R *.dfm}

procedure TfrmClientreCadastro.btnBuscarCepClick(Sender: TObject);
var
   Endereco: TEndereco;
begin
     Endereco := nil;
     try
        try
           Endereco := TViaCepService.Buscar(edtCep.Text);
           edtCep.Text := Endereco.Cep;
           edtLogradouro.Text := Endereco.Logradouro;
           edtComplemento.Text := Endereco.Complemento;
           edtBairro.Text := Endereco.Bairro;
           edtCidade.Text := Endereco.CidadeNome;
           edtEstado.Text := Endereco.EstadoNome;
           FEstadoNome := Endereco.EstadoNome;
           FEstadoUf := Endereco.EstadoUf;

           HabilitarEndereco(True);
           edtNumero.SetFocus;
        finally
              Endereco.Free;
        end;
     except
           on E: Exception do
              MessageDlg(E.Message, mtError, [mbOK], 0);
     end;

end;

procedure TfrmClientreCadastro.btnSalvarClick(Sender: TObject);
var
   Cliente: TCliente;
   Controller: TClienteController;
begin
     Cliente := TCliente.Create;
     Controller := TClienteController.Create;

     try
        Cliente.Id := FClienteId;
        Cliente.Nome := Trim(edtNome.Text);
        Cliente.CpfCnpj := Trim(edtCpfCnpj.Text);

        if dtpDataNascimento.Checked then
           Cliente.DataNascimento := dtpDataNascimento.Date
        else
            Cliente.DataNascimento := 0;

        Cliente.Endereco.Cep := Trim(edtCep.Text);
        Cliente.Endereco.Logradouro := Trim(edtLogradouro.Text);
        Cliente.Endereco.Numero := Trim(edtNumero.Text);
        Cliente.Endereco.Complemento := Trim(edtComplemento.Text);
        Cliente.Endereco.Bairro := Trim(edtBairro.Text);
        Cliente.Endereco.CidadeNome := Trim(edtCidade.Text);
        Cliente.Endereco.EstadoNome := FEstadoNome;
        Cliente.Endereco.EstadoUf := FEstadoUf;
        try
           if FClienteId = 0 then
              Controller.Inserir(Cliente)
           else
               Controller.Atualizar(Cliente);

           ModalResult := mrOk;
        except
              on E: Exception do
                 MessageDlg(E.Message, mtError, [mbOK], 0);
        end;
    finally
            Controller.Free;
            Cliente.Free;
    end;

end;

procedure TfrmClientreCadastro.CarregarCliente(const AClienteId: Integer);
var
   Cliente: TCliente;
   Controller: TClienteController;
begin
     Controller := TClienteController.Create;
     Cliente := nil;
     try
        Cliente := Controller.BuscarPorId(AClienteId);

        if Cliente = nil then
           raise Exception.Create('Cliente não encontrado.');

        FClienteId := Cliente.Id;

        edtNome.Text := Cliente.Nome;
        edtCpfCnpj.Text := Cliente.CpfCnpj;

        if Cliente.DataNascimento = 0 then
           dtpDataNascimento.Checked := False
        else
        begin
             dtpDataNascimento.Date := Cliente.DataNascimento;
             dtpDataNascimento.Checked := True;
        end;

        edtCep.Text := Cliente.Endereco.Cep;
        edtLogradouro.Text := Cliente.Endereco.Logradouro;
        edtNumero.Text := Cliente.Endereco.Numero;
        edtComplemento.Text := Cliente.Endereco.Complemento;
        edtBairro.Text := Cliente.Endereco.Bairro;
        edtCidade.Text := Cliente.Endereco.CidadeNome;
        edtEstado.Text := Cliente.Endereco.EstadoNome;

        FEstadoNome := Cliente.Endereco.EstadoNome;
        FEstadoUf := Cliente.Endereco.EstadoUf;

        HabilitarEndereco(True);

        Caption := 'Editar Cliente';
     finally
            Cliente.Free;
            Controller.Free;
     end;
end;

procedure TfrmClientreCadastro.edtCepKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     if Key = VK_RETURN then
     begin
          Key := 0;
          btnBuscarCepClick(btnBuscarCep);
     end;
end;

procedure TfrmClientreCadastro.edtCepKeyPress(Sender: TObject; var Key: Char);
begin
     if Key = #13 then
        Key := #0;
end;

procedure TfrmClientreCadastro.FormCreate(Sender: TObject);
begin
     FClienteId := 0;
     FEstadoNome := '';
     FEstadoUf := '';
     HabilitarEndereco(False);
end;

procedure TfrmClientreCadastro.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     if Key <> VK_RETURN then
        Exit;

     if ActiveControl = edtCep then
        Exit;

     Key := 0;
     Perform(WM_NEXTDLGCTL, 0, 0);
end;


procedure TfrmClientreCadastro.FormKeyPress(Sender: TObject; var Key: Char);
begin
     if Key = #13 then
        Key := #0
end;

procedure TfrmClientreCadastro.HabilitarEndereco(const AHabilitar: Boolean);
begin
     edtLogradouro.Enabled := AHabilitar;
     edtNumero.Enabled := AHabilitar;
     edtComplemento.Enabled := AHabilitar;
     edtBairro.Enabled := AHabilitar;
     edtCidade.Enabled := AHabilitar;
     edtEstado.Enabled := AHabilitar;
     btnSalvar.Enabled := AHabilitar;
end;

end.
