object frmClientreCadastro: TfrmClientreCadastro
  Left = 0
  Top = 0
  Caption = 'Cadastro de Cliente'
  ClientHeight = 420
  ClientWidth = 379
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  TextHeight = 15
  object gbxEndereco: TGroupBox
    Left = 8
    Top = 168
    Width = 361
    Height = 209
    Caption = 'Endere'#231'o'
    TabOrder = 0
    object lblLogradouro: TLabel
      Left = 16
      Top = 72
      Width = 62
      Height = 15
      Caption = 'Logradouro'
    end
    object lblNumero: TLabel
      Left = 264
      Top = 72
      Width = 44
      Height = 15
      Caption = 'N'#250'mero'
    end
    object lblComplemento: TLabel
      Left = 16
      Top = 117
      Width = 77
      Height = 15
      Caption = 'Complemento'
    end
    object lblBairro: TLabel
      Left = 183
      Top = 117
      Width = 31
      Height = 15
      Caption = 'Bairro'
    end
    object lblCidade: TLabel
      Left = 16
      Top = 162
      Width = 37
      Height = 15
      Caption = 'Cidade'
    end
    object lblCep: TLabel
      Left = 16
      Top = 24
      Width = 21
      Height = 15
      Caption = 'CEP'
    end
    object lblEstado: TLabel
      Left = 238
      Top = 162
      Width = 35
      Height = 15
      Caption = 'Estado'
    end
    object edtLogradouro: TEdit
      Left = 16
      Top = 88
      Width = 242
      Height = 23
      TabOrder = 1
    end
    object edtNumero: TEdit
      Left = 264
      Top = 88
      Width = 89
      Height = 23
      TabOrder = 2
    end
    object edtComplemento: TEdit
      Left = 16
      Top = 133
      Width = 161
      Height = 23
      TabOrder = 4
    end
    object edtBairro: TEdit
      Left = 183
      Top = 133
      Width = 170
      Height = 23
      TabOrder = 5
    end
    object edtCidade: TEdit
      Left = 16
      Top = 179
      Width = 216
      Height = 23
      TabOrder = 6
    end
    object edtCep: TEdit
      Left = 16
      Top = 43
      Width = 202
      Height = 23
      TabOrder = 0
      OnKeyDown = edtCepKeyDown
      OnKeyPress = edtCepKeyPress
    end
    object btnBuscarCep: TButton
      Left = 224
      Top = 41
      Width = 129
      Height = 25
      Caption = 'Buscar CEP'
      TabOrder = 3
      TabStop = False
      OnClick = btnBuscarCepClick
    end
    object edtEstado: TEdit
      Left = 238
      Top = 179
      Width = 115
      Height = 23
      TabOrder = 7
    end
  end
  object gbxDadosPessoais: TGroupBox
    Left = 8
    Top = 23
    Width = 361
    Height = 139
    Caption = 'Dados Pessoais'
    TabOrder = 1
    object lblNome: TLabel
      Left = 16
      Top = 27
      Width = 33
      Height = 15
      Caption = 'Nome'
    end
    object lblCpfCnpj: TLabel
      Left = 16
      Top = 72
      Width = 59
      Height = 15
      Caption = 'CPF / CNPJ'
    end
    object lblDataNascimento: TLabel
      Left = 183
      Top = 72
      Width = 105
      Height = 15
      Caption = 'Data de nascimento'
    end
    object edtNome: TEdit
      Left = 16
      Top = 43
      Width = 337
      Height = 23
      TabOrder = 0
    end
    object edtCpfCnpj: TEdit
      Left = 16
      Top = 88
      Width = 161
      Height = 23
      TabOrder = 1
    end
    object dtpDataNascimento: TDateTimePicker
      Left = 183
      Top = 88
      Width = 170
      Height = 23
      Date = 46289.000000000000000000
      Time = 46289.000000000000000000
      ShowCheckbox = True
      MinDate = 2.000000000000000000
      TabOrder = 2
    end
  end
  object btnCancelar: TButton
    Left = 212
    Top = 385
    Width = 75
    Height = 25
    Caption = 'Cancelar'
    ModalResult = 2
    TabOrder = 2
    TabStop = False
  end
  object btnSalvar: TButton
    Left = 294
    Top = 385
    Width = 75
    Height = 25
    Caption = 'Salvar'
    TabOrder = 3
    TabStop = False
    OnClick = btnSalvarClick
  end
end
