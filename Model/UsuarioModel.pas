unit UsuarioModel;

interface

type
  TUsuario = class
    private
      FId: Integer;
      FNome: string;
      FLogin: string;
      FSenhaHash: string;
      FTOTPSecret: string;
      FTentativasInvalidas: Integer;
      FBloqueado: Boolean;
      FAdministrador: Boolean;

    public
      property Id: Integer read FId write FId;
      property Nome: string read FNome write FNome;
      property Login: string read FLogin write FLogin;
      property SenhaHash: string read FSenhaHash write FSenhaHash;
      property TOTPSecret: string read FTOTPSecret write FTOTPSecret;
      property TentativasInvalidas: Integer read FTentativasInvalidas write FTentativasInvalidas;
      property Bloqueado: Boolean read FBloqueado write FBloqueado;
      property Administrador: Boolean read FAdministrador write FAdministrador;


  end;

implementation

end.
