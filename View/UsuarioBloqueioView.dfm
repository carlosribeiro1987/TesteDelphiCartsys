object frmUsuarioBloqueio: TfrmUsuarioBloqueio
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Desbloqueio de Usu'#225'rios'
  ClientHeight = 416
  ClientWidth = 599
  Color = clBtnFace
  Constraints.MaxHeight = 455
  Constraints.MaxWidth = 615
  Constraints.MinHeight = 455
  Constraints.MinWidth = 614
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    599
    416)
  TextHeight = 15
  object gbxUsuariosBloqueados: TGroupBox
    Left = 8
    Top = 8
    Width = 585
    Height = 369
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'Usu'#225'rios Bloqueados'
    TabOrder = 0
    ExplicitWidth = 583
    ExplicitHeight = 361
    DesignSize = (
      585
      369)
    object grdUsuarios: TDBGrid
      Left = 10
      Top = 24
      Width = 567
      Height = 305
      Anchors = [akLeft, akTop, akRight, akBottom]
      DataSource = dscUsuarios
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      TabOrder = 0
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
          Width = 250
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'LOGIN'
          Title.Caption = 'Login'
          Width = 135
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'TENTATIVAS_INVALIDAS'
          Title.Caption = 'Tentativas Inv'#225'lidas'
          Width = 110
          Visible = True
        end>
    end
    object btnDesbloquear: TButton
      Left = 480
      Top = 335
      Width = 97
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Desbloquear'
      TabOrder = 1
      OnClick = btnDesbloquearClick
      ExplicitLeft = 478
      ExplicitTop = 327
    end
  end
  object btnFechar: TButton
    Left = 486
    Top = 383
    Width = 107
    Height = 33
    Anchors = [akRight, akBottom]
    Caption = 'Fechar'
    TabOrder = 1
    ExplicitLeft = 484
    ExplicitTop = 375
  end
  object mtbUsuarios: TFDMemTable
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
        Name = 'LOGIN'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'TENTATIVAS_INVALIDAS'
        DataType = ftInteger
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
    Left = 384
    Top = 144
  end
  object dscUsuarios: TDataSource
    DataSet = mtbUsuarios
    Left = 384
    Top = 208
  end
end
