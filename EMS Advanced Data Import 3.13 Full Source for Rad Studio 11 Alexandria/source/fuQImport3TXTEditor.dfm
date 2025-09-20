inherited fmQImport3TXTEditor: TfmQImport3TXTEditor
  Caption = 'fmQImport3TXTEditor'
  PixelsPerInch = 96
  TextHeight = 13
  inherited laSkip_01: TLabel
    Left = 234
  end
  inherited laSkip_02: TLabel
    Left = 309
    Width = 52
  end
  inherited paButtons: TPanel
    TabOrder = 5
  end
  inherited ToolBar: TToolBar
    Left = 209
  end
  inherited paFields: TPanel
    Width = 203
    inherited lvFields: TListView
      Width = 195
      Columns = <
        item
          Caption = 'Fields'
          Width = 120
        end
        item
          Caption = 'Pos'
          Width = 35
        end
        item
          Caption = 'Size'
          Width = 35
        end>
    end
  end
  inherited edSkip: TEdit
    Left = 276
  end
  object paView: TPanel [9]
    Left = 209
    Top = 65
    Width = 348
    Height = 279
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    TabOrder = 4
  end
  inherited odFileName: TOpenDialog
    DefaultExt = 'txt'
  end
end
