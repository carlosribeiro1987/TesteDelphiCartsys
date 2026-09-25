object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Cartsys - Controle de Clientes'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = menMainMenu
  Position = poScreenCenter
  TextHeight = 15
  object menMainMenu: TMainMenu
    Left = 24
    Top = 352
    object mnuSistema: TMenuItem
      Caption = 'Sistema'
      object mnuDesbloquearUsuarios: TMenuItem
        Caption = 'Desbloquear Usu'#225'rios'
        OnClick = mnuDesbloquearUsuariosClick
      end
      object mnuSair: TMenuItem
        Caption = 'Sair'
        OnClick = mnuSairClick
      end
    end
    object menCadastros: TMenuItem
      Caption = 'Cadastros'
      object mnuCliente: TMenuItem
        Caption = 'Cliente'
        OnClick = mnuClienteClick
      end
    end
    object mnuRelatorios: TMenuItem
      Caption = 'Relat'#243'rios'
      object mnuRelatorio: TMenuItem
        Caption = 'Relat'#243'rio'
        OnClick = mnuRelatorioClick
      end
    end
  end
end
