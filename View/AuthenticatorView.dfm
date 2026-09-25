object frmAuthenticator: TfrmAuthenticator
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Autentica'#231#227'o em duas etapas'
  ClientHeight = 511
  ClientWidth = 334
  Color = clBtnFace
  Constraints.MaxWidth = 350
  Constraints.MinWidth = 350
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  TextHeight = 15
  object lblTitulo: TLabel
    Left = 8
    Top = 8
    Width = 190
    Height = 15
    Caption = 'Configure o aplicativo autenticador.'
  end
  object imgQRCode: TImage
    Left = 8
    Top = 29
    Width = 320
    Height = 320
    Center = True
    Constraints.MaxHeight = 320
    Constraints.MaxWidth = 320
    Constraints.MinHeight = 320
    Constraints.MinWidth = 320
    Proportional = True
    Stretch = True
  end
  object lblCodigo: TLabel
    Left = 8
    Top = 426
    Width = 42
    Height = 15
    Caption = 'C'#243'digo:'
  end
  object lblChave: TLabel
    Left = 8
    Top = 376
    Width = 79
    Height = 15
    Caption = 'Chave Manual:'
  end
  object edtCodigo: TEdit
    Left = 8
    Top = 447
    Width = 320
    Height = 23
    Constraints.MaxWidth = 320
    Constraints.MinWidth = 320
    MaxLength = 6
    TabOrder = 0
  end
  object btnConfirmar: TButton
    Left = 253
    Top = 479
    Width = 75
    Height = 25
    Caption = 'Confirmar'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancelar: TButton
    Left = 172
    Top = 479
    Width = 75
    Height = 25
    Caption = 'Cancelar'
    ModalResult = 2
    TabOrder = 2
  end
  object edtChave: TEdit
    Left = 8
    Top = 397
    Width = 320
    Height = 23
    AutoSelect = False
    AutoSize = False
    Constraints.MaxWidth = 320
    Constraints.MinWidth = 320
    ReadOnly = True
    TabOrder = 3
  end
end
