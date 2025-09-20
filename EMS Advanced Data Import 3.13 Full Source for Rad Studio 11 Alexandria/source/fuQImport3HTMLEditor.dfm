inherited fmQImport3HTMLEditor: TfmQImport3HTMLEditor
  Caption = 'fmQImport3HTMLEditor'
  PixelsPerInch = 96
  TextHeight = 13
  inherited laColumn: TLabel
    Left = 328
  end
  inherited laSkip_01: TLabel
    Left = 443
  end
  inherited laSkip_02: TLabel
    Left = 519
    Width = 35
  end
  object laTable: TLabel [5]
    Left = 239
    Top = 38
    Width = 27
    Height = 21
    AutoSize = False
    Caption = 'Table'
    FocusControl = cbTable
    Layout = tlCenter
  end
  inherited paGrid: TPanel
    TabOrder = 6
  end
  inherited paButtons: TPanel
    TabOrder = 7
  end
  inherited cbColumn: TComboBox
    Left = 387
    TabOrder = 4
  end
  inherited edSkip: TEdit
    Left = 486
    TabOrder = 5
  end
  object cbTable: TComboBox [13]
    Left = 271
    Top = 38
    Width = 50
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 3
    OnChange = cbTableChange
  end
  inherited odFileName: TOpenDialog
    DefaultExt = 'txt'
    Filter = 'HTML Files (*.htm, *.html)|*.htm; *.html;'
  end
end
