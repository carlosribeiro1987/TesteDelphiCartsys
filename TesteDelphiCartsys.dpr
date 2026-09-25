program TesteDelphiCartsys;

uses
  Vcl.Forms,
  Vcl.Controls,
  LoginView in 'View\LoginView.pas' {frmLogin},
  DatabaseDataModule in 'Data\DatabaseDataModule.pas' {dmDatabase: TDataModule},
  UsuarioModel in 'Model\UsuarioModel.pas',
  UsuarioRepository in 'Data\Repository\UsuarioRepository.pas',
  Bcrypt in 'Lib\Bcrypt.pas',
  PasswordService in 'Service\PasswordService.pas',
  UsuarioService in 'Service\UsuarioService.pas',
  TotpService in 'Service\TotpService.pas',
  GoogleOTP in 'Lib\GoogleOTP.pas',
  Base32U in 'Lib\Base32U.pas',
  LoginController in 'Controller\LoginController.pas',
  DelphiZXIngQRCode in 'Lib\DelphiZXIngQRCode.pas',
  AuthenticatorView in 'View\AuthenticatorView.pas' {frmAuthenticator},
  DatabaseSeed in 'Data\Seed\DatabaseSeed.pas',
  MainView in 'View\MainView.pas' {frmMain},
  ClienteModel in 'Model\ClienteModel.pas',
  ClienteRepository in 'Data\Repository\ClienteRepository.pas',
  ClienteService in 'Service\ClienteService.pas',
  ClienteController in 'Controller\ClienteController.pas',
  ClienteView in 'View\ClienteView.pas' {frmCliente},
  ClienteCadastroView in 'View\ClienteCadastroView.pas' {frmClientreCadastro},
  EnderecoModel in 'Model\EnderecoModel.pas',
  ViaCepService in 'Service\ViaCepService.pas',
  CidadeRepository in 'Data\Repository\CidadeRepository.pas',
  UsuarioController in 'Controller\UsuarioController.pas',
  UsuarioBloqueioView in 'View\UsuarioBloqueioView.pas' {frmUsuarioBloqueio},
  AuthorizationService in 'Service\AuthorizationService.pas',
  ClienteRelatorioView in 'View\ClienteRelatorioView.pas' {frmClienteRelatorio};

{$R *.res}

var
   Login: TfrmLogin;
   UsuarioAutenticado: TUsuario;

   FormRelatorio: TfrmClienteRelatorio;

begin
     Application.Initialize;

     Application.CreateForm(TdmDatabase, dmDatabase);

  dmDatabase.Conectar;



     TDatabaseSeed.Executar;




     UsuarioAutenticado := nil;
     Login := TfrmLogin.Create(nil);

     try
        if Login.ShowModal = mrOk then
           UsuarioAutenticado := Login.ObterUsuarioAutenticado;

     finally
            Login.Free;
     end;

     if UsuarioAutenticado <> nil then
     begin
          frmMain := TfrmMain.Create(nil);
          try
             frmMain.ConfigurarUsuario(UsuarioAutenticado);
             frmMain.ShowModal;
          finally
                 frmMain.Free;
                 frmMain := nil;
                 UsuarioAutenticado.Free;
          end;
     end;

end.
