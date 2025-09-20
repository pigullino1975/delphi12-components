inherited fmQImport3CSVEditor: TfmQImport3CSVEditor
  Caption = 'fmQImport3CSVEditor'
  PixelsPerInch = 96
  TextHeight = 13
  object laCSVEncoding: TLabel [5]
    Left = 182
    Top = 68
    Width = 108
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Encoding'
  end
  inherited paGrid: TPanel
    Top = 92
    Height = 252
  end
  object cmbCSVEncoding: TComboBox [13]
    Left = 296
    Top = 65
    Width = 236
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 7
    OnChange = cmbCSVEncodingChange
  end
  inherited odFileName: TOpenDialog
    DefaultExt = 'txt'
  end
end
