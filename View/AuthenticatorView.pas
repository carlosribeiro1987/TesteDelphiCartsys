unit AuthenticatorView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfrmAuthenticator = class(TForm)
    lblTitulo: TLabel;
    imgQRCode: TImage;
    lblCodigo: TLabel;
    edtCodigo: TEdit;
    btnConfirmar: TButton;
    btnCancelar: TButton;
    lblChave: TLabel;
    edtChave: TEdit;
  private
    { Private declarations }
    procedure GerarQRCode(const AConteudo: string);

  public
    { Public declarations }
    procedure Configurar(const ASecret, AUri: string);
    procedure SolicitarCodigo;
    function Codigo: string;
  end;

var
  frmAuthenticator: TfrmAuthenticator;

implementation
uses
  DelphiZXIngQRCode;

{$R *.dfm}

{ TfrmAuthenticator }




function TfrmAuthenticator.Codigo: string;
begin
     Result := Trim(edtCodigo.Text);
end;

procedure TfrmAuthenticator.Configurar(const ASecret, AUri: string);
begin
  lblTitulo.Caption := 'Configure o aplicativo autenticador.';

  lblChave.Visible := True;
  edtChave.Visible := True;
  imgQRCode.Visible := True;

  edtChave.Text := ASecret;
  edtCodigo.Clear;

  GerarQRCode(AUri);
end;



procedure TfrmAuthenticator.GerarQRCode(const AConteudo: string);
var
  QRCode: TDelphiZXingQRCode;
  Bitmap: TBitmap;
  X: Integer;
  Y: Integer;
  Escala: Integer;
begin
  QRCode := TDelphiZXingQRCode.Create;
  Bitmap := TBitmap.Create;

  try
    QRCode.Data := AConteudo;
    QRCode.Encoding := TQRCodeEncoding.qrAuto;
    QRCode.QuietZone := 4;

    Escala := 5;

    Bitmap.SetSize(QRCode.Columns * Escala, QRCode.Rows * Escala);
    Bitmap.Canvas.Brush.Color := clWhite;
    Bitmap.Canvas.FillRect(Bitmap.Canvas.ClipRect);
    Bitmap.Canvas.Brush.Color := clBlack;

    for Y := 0 to QRCode.Rows - 1 do
      for X := 0 to QRCode.Columns - 1 do
        if QRCode.IsBlack[Y, X] then
          Bitmap.Canvas.FillRect(Rect(X * Escala, Y * Escala, (X + 1) * Escala, (Y + 1) * Escala));

    imgQRCode.Picture.Assign(Bitmap);
  finally
       Bitmap.Free;
       QRCode.Free;
  end;

end;

procedure TfrmAuthenticator.SolicitarCodigo;
begin
     ClientWidth := 337;
     ClientHeight := 145;

     lblTitulo.Caption := 'Verificação em duas etapas';

     lblChave.Visible := False;
     edtChave.Visible := False;
     imgQRCode.Visible := False;

     lblTitulo.Top := 16;

     lblCodigo.Top := 55;
     edtCodigo.Top := 75;

     btnCancelar.Top := 110;
     btnConfirmar.Top := 110;

     edtChave.Clear;
     imgQRCode.Picture.Assign(nil);
     edtCodigo.Clear;

end;

end.
