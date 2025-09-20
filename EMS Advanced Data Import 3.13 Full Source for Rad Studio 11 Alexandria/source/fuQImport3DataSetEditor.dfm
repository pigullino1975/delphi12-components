inherited fmQImport3DataSetEditor: TfmQImport3DataSetEditor
  Caption = 'fmQImport3DataSetEditor'
  PixelsPerInch = 96
  TextHeight = 13
  inherited Bevel1: TBevel
    Visible = False
  end
  inherited paFileName: TPanel
    Visible = False
  end
  inherited paFields: TPanel
    inherited lvFields: TListView
      Columns = <
        item
          Caption = 'Destination'
          Width = 226
        end>
    end
    inherited lvMap: TListView
      Columns = <
        item
          Caption = 'Destination'
          Width = 167
        end
        item
          Alignment = taCenter
          Width = 20
        end
        item
          Caption = 'Source'
          Width = 167
        end>
    end
    inherited lvSource: TListView
      Columns = <
        item
          Caption = 'Source'
          Width = 226
        end>
    end
  end
end
