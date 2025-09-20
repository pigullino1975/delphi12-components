inherited fmQImport3ODTEditor: TfmQImport3ODTEditor
  Caption = 'fmQImport3ODTEditor'
  PixelsPerInch = 96
  TextHeight = 13
  inherited laSkip_01: TLabel
    Left = 400
  end
  inherited laSkip_02: TLabel
    Left = 476
  end
  inherited paFileName: TPanel
    TabOrder = 0
  end
  inherited paButtons: TPanel
    TabOrder = 6
  end
  inherited edSkip: TEdit
    Left = 443
    TabOrder = 4
  end
  inherited pcGrid: TPageControl
    TabOrder = 5
  end
  object cbHeaderRow: TCheckBox [10]
    Left = 241
    Top = 38
    Width = 145
    Height = 21
    Caption = 'Use First Row As Header'
    TabOrder = 3
    OnClick = cbHeaderRowClick
  end
  inherited odFileName: TOpenDialog
    DefaultExt = 'odt'
    Filter = 'Open Document Spreadsheet (*.odt)|*.odt'
  end
end
