object frmLogin: TfrmLogin
  Left = 0
  Top = 0
  Caption = 'frmLogin'
  ClientHeight = 161
  ClientWidth = 249
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object lblLogin: TLabel
    Left = 8
    Top = 11
    Width = 33
    Height = 15
    Caption = 'Login:'
  end
  object lblSenha: TLabel
    Left = 8
    Top = 77
    Width = 35
    Height = 15
    Caption = 'Senha:'
  end
  object edtLogin: TEdit
    Left = 8
    Top = 32
    Width = 233
    Height = 23
    TabOrder = 0
  end
  object edtSenha: TEdit
    Left = 8
    Top = 98
    Width = 233
    Height = 23
    PasswordChar = '*'
    TabOrder = 1
  end
  object btnEntrar: TButton
    Left = 160
    Top = 127
    Width = 75
    Height = 25
    Caption = 'Entrar'
    Default = True
    TabOrder = 2
    OnClick = btnEntrarClick
  end
end
