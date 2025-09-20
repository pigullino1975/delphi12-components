inherited fmQImport3XMLEditor: TfmQImport3XMLEditor
  Caption = 'fmQImport3XMLEditor'
  PixelsPerInch = 96
  TextHeight = 13
  inherited paFields: TPanel
    inherited lvMap: TListView
      Columns = <
        item
          Caption = 'DataSet'
          Width = 167
        end
        item
          Alignment = taCenter
          Width = 20
        end
        item
          Caption = 'XML'
          Width = 167
        end>
    end
    inherited lvSource: TListView
      Columns = <
        item
          Caption = 'XML'
          Width = 226
        end>
    end
  end
  inherited odFileName: TOpenDialog
    DefaultExt = 'xml'
    Filter = 'XML files (*.xml)|*.xml'
  end
end
