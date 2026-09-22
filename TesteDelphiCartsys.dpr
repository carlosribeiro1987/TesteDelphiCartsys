program TesteDelphiCartsys;

uses
  Vcl.Forms,
  LoginView in 'View\LoginView.pas' {frmLogin};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.Run;
end.
