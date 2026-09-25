object frmCliente: TfrmCliente
  Left = 0
  Top = 0
  Caption = 'Clientes'
  ClientHeight = 482
  ClientWidth = 800
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    800
    482)
  TextHeight = 15
  object btnFechar: TButton
    Left = 715
    Top = 450
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Fechar'
    TabOrder = 0
    OnClick = btnFecharClick
    ExplicitLeft = 713
    ExplicitTop = 442
  end
  object gbxPesquisar: TGroupBox
    Left = 8
    Top = 8
    Width = 782
    Height = 436
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'Clientes'
    TabOrder = 1
    ExplicitWidth = 780
    ExplicitHeight = 428
    DesignSize = (
      782
      436)
    object lblPesquisa: TLabel
      Left = 179
      Top = 15
      Width = 53
      Height = 15
      Caption = 'Pesquisar:'
    end
    object lblCampoPesquisa: TLabel
      Left = 11
      Top = 21
      Width = 42
      Height = 15
      Caption = 'Campo:'
    end
    object cmbCampoPesquisa: TComboBox
      Left = 11
      Top = 36
      Width = 162
      Height = 23
      ItemIndex = 1
      TabOrder = 0
      Text = 'Nome'
      Items.Strings = (
        'ID'
        'Nome'
        'CPF/CNPJ'
        'CEP'
        'Cidade'
        'Estado'
        'Data de Nascimento')
    end
    object btnPesquisar: TButton
      Left = 696
      Top = 34
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Pesquisar'
      TabOrder = 1
      OnClick = btnPesquisarClick
      ExplicitLeft = 694
    end
    object edtPesquisa: TEdit
      Left = 179
      Top = 36
      Width = 511
      Height = 23
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 2
      ExplicitWidth = 509
    end
    object grdClientes: TDBGrid
      Left = 11
      Top = 65
      Width = 760
      Height = 324
      Anchors = [akLeft, akTop, akRight, akBottom]
      DataSource = dscClientes
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      TabOrder = 3
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -12
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          FieldName = 'ID'
          Width = 50
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NOME'
          Title.Caption = 'Nome'
          Width = 170
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CPF_CNPJ'
          Title.Caption = 'CPF / CNPJ'
          Width = 100
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CEP'
          Width = 80
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CIDADE'
          Title.Caption = 'Cidade'
          Width = 150
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ESTADO'
          Title.Caption = 'Estado'
          Width = 55
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DATANASCIMENTO'
          Title.Caption = 'Data de Nascimento'
          Width = 125
          Visible = True
        end>
    end
    object btnExcluir: TButton
      Left = 534
      Top = 399
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Excluir'
      TabOrder = 4
      OnClick = btnExcluirClick
      ExplicitLeft = 532
      ExplicitTop = 391
    end
    object btnEditar: TButton
      Left = 615
      Top = 399
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Editar'
      TabOrder = 5
      OnClick = btnEditarClick
      ExplicitLeft = 613
      ExplicitTop = 391
    end
    object btnNovo: TButton
      Left = 696
      Top = 399
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Novo'
      TabOrder = 6
      OnClick = btnNovoClick
      ExplicitLeft = 694
      ExplicitTop = 391
    end
  end
  object mtbClientes: TFDMemTable
    FieldDefs = <
      item
        Name = 'ID'
        DataType = ftInteger
      end
      item
        Name = 'NOME'
        DataType = ftString
        Size = 80
      end
      item
        Name = 'CPF_CNPJ'
        DataType = ftString
        Size = 14
      end
      item
        Name = 'CEP'
        DataType = ftString
        Size = 8
      end
      item
        Name = 'CIDADE'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'ESTADO'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'DATANASCIMENTO'
        DataType = ftDate
      end>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 224
    Top = 280
  end
  object dscClientes: TDataSource
    DataSet = mtbClientes
    Left = 368
    Top = 264
  end
end
