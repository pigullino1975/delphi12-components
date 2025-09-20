inherited SpreadSheetRLForm: TSpreadSheetRLForm
  Left = 182
  Top = 159
  Caption = 'Report Links Demo - ExpressSpreadSheet'
  ClientHeight = 531
  ClientWidth = 874
  PixelsPerInch = 96
  TextHeight = 13
  inherited lbDescrip: TLabel
    Width = 874
    Caption = 
      'This example demonstrates the ExpressSpreadSheet printing capabi' +
      'lities.'
  end
  inherited sbMain: TStatusBar
    Top = 512
    Width = 874
    Visible = False
  end
  inherited ToolBar1: TToolBar
    Width = 874
    object tbsOpen: TToolButton
      Left = 123
      Top = 0
      Action = actOpen
    end
    object ToolButton2: TToolButton
      Left = 146
      Top = 0
      Action = actSave
    end
    object ToolButton3: TToolButton
      Left = 169
      Top = 0
      Action = actCut
    end
    object ToolButton4: TToolButton
      Left = 192
      Top = 0
      Action = actCopy
    end
    object ToolButton5: TToolButton
      Left = 215
      Top = 0
      Action = actPaste
    end
  end
  object dxSpreadSheet1: TdxSpreadSheet [3]
    AlignWithMargins = True
    Left = 3
    Top = 70
    Width = 868
    Height = 439
    Align = alClient
    Data = {
      8002000044585353763242461000000042465320000000000000000001000101
      010100000000000001004246532000000000424653200100000001000000200B
      00000007000000430061006C0069006200720069000000000000002000000020
      0000000020000000000020000000000020000000000020000007000000470045
      004E004500520041004C00000000000002000000000000000001424653200100
      0000424653201700000054006400780053007000720065006100640053006800
      6500650074005400610062006C00650056006900650077000600000053006800
      650065007400310001FFFFFFFFFFFFFFFF640000000200000002000000020000
      0055000000140000000200000002000000000200000002000000000000010000
      0000000101000042465320550000000000000042465320000000004246532014
      0000000000000042465320000000000000000000000000010000000000000000
      0000000000000000000000424653200000000002020000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000064000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000200020200020000000000000000000000000000000000020000000000
      0000000000000000000000000000000000000000000000000000000000000202
      0000000000000000424653200000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000}
  end
  object dxSpreadSheetFormulaBar1: TdxSpreadSheetFormulaBar [4]
    AlignWithMargins = True
    Left = 3
    Top = 44
    Width = 868
    Height = 20
    Align = alTop
    SpreadSheet = dxSpreadSheet1
    TabOrder = 3
  end
  inherited mmMain: TMainMenu
    inherited miFile: TMenuItem
      object LoadData1: TMenuItem [0]
        Action = actOpen
      end
      object miSaveSpreadSheet: TMenuItem [1]
        Tag = 2
        Action = actSave
      end
      object MenuItem6: TMenuItem [2]
        Caption = '-'
      end
      object PrintArea1: TMenuItem [3]
        Caption = 'Print &Area'
        object SetPrintArea1: TMenuItem
          Action = actSetPrintArea
        end
        object ClearPrintArea1: TMenuItem
          Action = actClearPrintArea
        end
      end
    end
    object mnuEdit: TMenuItem [1]
      Caption = '&Edit'
      object miCut: TMenuItem
        Tag = 3
        Action = actCut
      end
      object miCopy: TMenuItem
        Tag = 2
        Action = actCopy
      end
      object miPaste: TMenuItem
        Tag = 4
        Action = actPaste
      end
      object N7: TMenuItem
        Caption = '-'
      end
      object miCells: TMenuItem
        Caption = 'C&ells'
        object miFormat: TMenuItem
          Tag = 5
          Action = actFormatCells
        end
        object miDeletecells: TMenuItem
          Tag = 12
          Action = actDeleteCells
        end
        object Insertcells1: TMenuItem
          Tag = 13
          Action = actInsertCells
        end
      end
    end
  end
  inherited sty: TActionList
    Left = 80
    object actDeleteCells: TAction
      Category = 'Cells'
      Caption = 'Delete...'
      OnExecute = actDeleteCellsExecute
      OnUpdate = AlwaysEnabled
    end
    object actSave: TAction
      Category = 'File'
      Caption = '&Save'
      ImageIndex = 14
      ShortCut = 16467
      OnExecute = actSaveExecute
    end
    object actInsertCells: TAction
      Tag = 1
      Category = 'Cells'
      Caption = 'Insert...'
      OnExecute = actInsertCellsExecute
      OnUpdate = AlwaysEnabled
    end
    object actCut: TAction
      Category = 'Edit'
      Caption = 'Cu&t'
      Hint = 'Cut'
      ImageIndex = 15
      ShortCut = 16472
      OnExecute = actCutExecute
      OnUpdate = AlwaysEnabled
    end
    object actCopy: TAction
      Category = 'Edit'
      Caption = '&Copy'
      Hint = 'Copy'
      ImageIndex = 16
      ShortCut = 16451
      OnExecute = actCopyExecute
      OnUpdate = AlwaysEnabled
    end
    object actPaste: TAction
      Category = 'Edit'
      Caption = '&Paste'
      Hint = 'Paste'
      ImageIndex = 17
      ShortCut = 16470
      OnExecute = actPasteExecute
      OnUpdate = AlwaysEnabled
    end
    object actFormatCells: TAction
      Category = 'Cells'
      Caption = 'Format Cells...'
      OnExecute = actFormatCellsExecute
      OnUpdate = AlwaysEnabled
    end
    object actOpen: TAction
      Category = 'File'
      Caption = '&Open'
      ImageIndex = 19
      OnExecute = actOpenExecute
      OnUpdate = AlwaysEnabled
    end
    object actSetPrintArea: TAction
      Caption = '&Set Print Area'
      OnExecute = actSetPrintAreaExecute
      OnUpdate = AlwaysEnabled
    end
    object actClearPrintArea: TAction
      Caption = '&Clear Print Area'
      OnExecute = actClearPrintAreaExecute
      OnUpdate = AlwaysEnabled
    end
  end
  inherited dxComponentPrinter: TdxComponentPrinter
    CurrentLink = dxComponentPrinterLink1
    PixelsPerInch = 96
    object dxComponentPrinterLink1: TdxSpreadSheetReportLnk
      Component = dxSpreadSheet1
      PrinterPage.DMPaper = 1
      PrinterPage.Footer = 5080
      PrinterPage.GrayShading = True
      PrinterPage.Header = 5080
      PrinterPage.PageSize.X = 215900
      PrinterPage.PageSize.Y = 279400
      PrinterPage._dxMeasurementUnits_ = 0
      PrinterPage._dxLastMU_ = 2
      PixelsPerInch = 96
      BuiltInReportLink = True
    end
  end
  inherited dxPSEngineController1: TdxPSEngineController
    Active = True
    Left = 608
    Top = 120
  end
  inherited ilMain: TcxImageList
    FormatVersion = 1
    DesignInfo = 6815872
  end
  object SaveDialog: TdxSaveFileDialog
    DefaultExt = 'xls'
    Filter = 'Spreadsheet files (*.xls)|*.xls'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 440
    Top = 89
  end
  object OpenDialog: TdxOpenFileDialog
    Left = 296
    Top = 264
  end
end
