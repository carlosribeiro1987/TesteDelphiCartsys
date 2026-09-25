object dmDatabase: TdmDatabase
  Height = 750
  Width = 1000
  PixelsPerInch = 120
  object conDatabase: TFDConnection
    Params.Strings = (
      'DriverID=FB'
      'User_Name=SYSDBA'
      'CharacterSet=UTF8')
    LoginPrompt = False
    Left = 352
    Top = 368
  end
  object FBDriverLink: TFDPhysFBDriverLink
    Left = 480
    Top = 360
  end
end
