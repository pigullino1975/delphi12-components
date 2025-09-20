inherited dxRichEditTablePropertiesDialogForm: TdxRichEditTablePropertiesDialogForm
  Caption = 'Table Properties'
  ClientHeight = 265
  ClientWidth = 393
  Position = poOwnerFormCenter
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 13
  inherited dxLayoutControl1: TdxLayoutControl
    Width = 393
    Height = 265
    object cbTablePreferredWidth: TcxCheckBox [0]
      Left = 22
      Top = 68
      Caption = 'Preferred &width:'
      Style.HotTrack = False
      TabOrder = 0
      Transparent = True
    end
    object seTablePreferredWidth: TdxMeasurementUnitEdit [1]
      Left = 132
      Top = 70
      TabOrder = 1
      Width = 63
    end
    object cmbTableWidthType: TcxComboBox [2]
      Left = 262
      Top = 70
      Properties.DropDownListStyle = lsFixedList
      Style.HotTrack = False
      TabOrder = 2
      Width = 107
    end
    object rgTableAlignmentLeft: TcxRadioButton [3]
      Left = 22
      Top = 134
      Caption = '&Left'
      TabOrder = 3
      AutoSize = True
      GroupIndex = 1
      Transparent = True
    end
    object rgTableAlignmenCenter: TcxRadioButton [4]
      Left = 79
      Top = 134
      Caption = '&Center'
      TabOrder = 4
      AutoSize = True
      GroupIndex = 1
      Transparent = True
    end
    object rgTableAlignmenRight: TcxRadioButton [5]
      Left = 150
      Top = 134
      Caption = 'Rig&ht'
      TabOrder = 5
      AutoSize = True
      GroupIndex = 1
      Transparent = True
    end
    object seIndentFromLeft: TdxMeasurementUnitEdit [6]
      Left = 213
      Top = 142
      TabOrder = 6
      Width = 81
    end
    object btnBorder: TcxButton [7]
      Left = 123
      Top = 216
      Width = 140
      Height = 25
      Caption = 'Borders and Shading...'
      TabOrder = 7
      OnClick = btnBorderClick
    end
    object btnTableOptions: TcxButton [8]
      Left = 269
      Top = 216
      Width = 100
      Height = 25
      Caption = '&Options...'
      TabOrder = 8
      OnClick = btnTableOptionsClick
    end
    object cbSpecifyHeight: TcxCheckBox [9]
      Left = 10000
      Top = 10000
      Caption = '&Specify height:'
      Style.HotTrack = False
      TabOrder = 9
      Transparent = True
      Visible = False
    end
    object seHeight: TdxMeasurementUnitEdit [10]
      Left = 10000
      Top = 10000
      TabOrder = 10
      Width = 63
    end
    object cmbRowHeightType: TcxComboBox [11]
      Left = 10000
      Top = 10000
      Properties.DropDownListStyle = lsFixedList
      Style.HotTrack = False
      TabOrder = 11
      Visible = False
      Width = 85
    end
    object cbCantSplit: TcxCheckBox [12]
      Left = 10000
      Top = 10000
      Caption = 'Allow row to brea&k across pages'
      Style.HotTrack = False
      TabOrder = 12
      Transparent = True
      Visible = False
    end
    object cbHeader: TcxCheckBox [13]
      Left = 10000
      Top = 10000
      Caption = 'Repeat as &header row at the top of each page'
      Style.HotTrack = False
      TabOrder = 13
      Transparent = True
      Visible = False
    end
    object btnPreviousRow: TcxButton [14]
      Left = 10000
      Top = 10000
      Width = 130
      Height = 25
      Caption = '&Previous Row'
      TabOrder = 14
      Visible = False
    end
    object btnNextRow: TcxButton [15]
      Left = 10000
      Top = 10000
      Width = 130
      Height = 25
      Caption = '&Next Row'
      TabOrder = 15
      Visible = False
    end
    object cbColumnPreferredWidth: TcxCheckBox [16]
      Left = 10000
      Top = 10000
      Caption = 'Preferred &width:'
      Style.HotTrack = False
      TabOrder = 16
      Transparent = True
      Visible = False
    end
    object seColumnPreferredWidth: TdxMeasurementUnitEdit [17]
      Left = 10000
      Top = 10000
      TabOrder = 17
      Width = 63
    end
    object cmbColumnWidthType: TcxComboBox [18]
      Left = 10000
      Top = 10000
      Properties.DropDownListStyle = lsFixedList
      Style.HotTrack = False
      TabOrder = 18
      Visible = False
      Width = 85
    end
    object btnPreviousColumn: TcxButton [19]
      Left = 10000
      Top = 10000
      Width = 130
      Height = 25
      Caption = '&Previous Column'
      TabOrder = 19
      Visible = False
    end
    object btnNextColumn: TcxButton [20]
      Left = 10000
      Top = 10000
      Width = 130
      Height = 25
      Caption = '&Next Column'
      TabOrder = 20
      Visible = False
    end
    object cbCellPreferredWidth: TcxCheckBox [21]
      Left = 10000
      Top = 10000
      Caption = 'Preferred &width:'
      Style.HotTrack = False
      TabOrder = 21
      Transparent = True
      Visible = False
    end
    object seCellPreferredWidth: TdxMeasurementUnitEdit [22]
      Left = 10000
      Top = 10000
      TabOrder = 22
      Width = 63
    end
    object cmbCellWidthType: TcxComboBox [23]
      Left = 10000
      Top = 10000
      Properties.DropDownListStyle = lsFixedList
      Style.HotTrack = False
      TabOrder = 23
      Visible = False
      Width = 85
    end
    object rbCellVerticalAlignmentTop: TcxRadioButton [24]
      Left = 10000
      Top = 10000
      Caption = 'To&p'
      TabOrder = 24
      Visible = False
      AutoSize = True
      GroupIndex = 2
      Transparent = True
    end
    object rbCellVerticalAlignmentCenter: TcxRadioButton [25]
      Left = 10000
      Top = 10000
      Caption = '&Center'
      TabOrder = 25
      Visible = False
      AutoSize = True
      GroupIndex = 2
      Transparent = True
    end
    object rbCellVerticalAlignmentBottom: TcxRadioButton [26]
      Left = 10000
      Top = 10000
      Caption = '&Bottom'
      TabOrder = 26
      Visible = False
      AutoSize = True
      GroupIndex = 2
      Transparent = True
    end
    object btnCellOptions: TcxButton [27]
      Left = 10000
      Top = 10000
      Width = 100
      Height = 25
      Caption = '&Options...'
      TabOrder = 27
      Visible = False
      OnClick = btnCellOptionsClick
    end
    object btnOk: TcxButton [28]
      Left = 225
      Top = 259
      Width = 75
      Height = 25
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 28
    end
    object btnCancel: TcxButton [29]
      Left = 306
      Top = 259
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 29
    end
    inherited dxLayoutControl1Group_Root: TdxLayoutGroup
      CaptionOptions.Visible = False
    end
    object lcgTabControl: TdxLayoutGroup
      Parent = dxLayoutControl1Group_Root
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      LayoutDirection = ldTabbed
      ShowBorder = False
      Index = 0
    end
    object lcgTable: TdxLayoutGroup
      Parent = lcgTabControl
      CaptionOptions.Text = '&Table'
      Index = 0
    end
    object dxLayoutControl1Group1: TdxLayoutGroup
      Parent = lcgTable
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 1
    end
    object dxLayoutControl1Item4: TdxLayoutItem
      Parent = dxLayoutControl1Group1
      AlignVert = avCenter
      CaptionOptions.Text = 'cxCheckBox1'
      CaptionOptions.Visible = False
      Control = cbTablePreferredWidth
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 104
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutControl1Item5: TdxLayoutItem
      Parent = dxLayoutControl1Group1
      AlignVert = avCenter
      CaptionOptions.Visible = False
      Control = seTablePreferredWidth
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 63
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lciTableWidthType: TdxLayoutItem
      Parent = dxLayoutControl1Group1
      AlignVert = avCenter
      CaptionOptions.Text = '&Measure in:'
      Control = cmbTableWidthType
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 107
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutControl1Group3: TdxLayoutGroup
      Parent = lcgTable
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 3
    end
    object lcgTableAlignment: TdxLayoutGroup
      Parent = dxLayoutControl1Group3
      AlignVert = avCenter
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 0
    end
    object dxLayoutControl1Item8: TdxLayoutItem
      Parent = lcgTableAlignment
      CaptionOptions.Text = 'cxRadioButton1'
      CaptionOptions.Visible = False
      Control = rgTableAlignmentLeft
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 51
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutControl1Item9: TdxLayoutItem
      Parent = lcgTableAlignment
      CaptionOptions.Text = 'cxRadioButton2'
      CaptionOptions.Visible = False
      Control = rgTableAlignmenCenter
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 65
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutControl1Item10: TdxLayoutItem
      Parent = lcgTableAlignment
      CaptionOptions.Text = 'cxRadioButton3'
      CaptionOptions.Visible = False
      Control = rgTableAlignmenRight
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 57
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object lciIndentFromLeft: TdxLayoutItem
      Parent = dxLayoutControl1Group3
      CaptionOptions.Text = '&Indent from left:'
      CaptionOptions.Layout = clTop
      Control = seIndentFromLeft
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 81
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutControl1Group4: TdxLayoutAutoCreatedGroup
      Parent = lcgTable
      AlignVert = avBottom
      LayoutDirection = ldHorizontal
      Index = 4
    end
    object lciBorder: TdxLayoutItem
      Parent = dxLayoutControl1Group4
      AlignHorz = ahRight
      CaptionOptions.Text = 'cxButton1'
      CaptionOptions.Visible = False
      Control = btnBorder
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 140
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lciTableOptions: TdxLayoutItem
      Parent = dxLayoutControl1Group4
      AlignHorz = ahRight
      CaptionOptions.Text = 'cxButton2'
      CaptionOptions.Visible = False
      Control = btnTableOptions
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 100
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lcgRow: TdxLayoutGroup
      Parent = lcgTabControl
      CaptionOptions.Text = '&Row'
      Index = 1
    end
    object lcilRowNumber: TdxLayoutItem
      Parent = lcgRow
      Offsets.Left = 10
      CaptionOptions.Text = 'Row'
      Index = 1
    end
    object dxLayoutControl1Group5: TdxLayoutGroup
      Parent = lcgRow
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      Offsets.Left = 10
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 2
    end
    object dxLayoutControl1Item15: TdxLayoutItem
      Parent = dxLayoutControl1Group5
      AlignVert = avCenter
      Padding.AssignedValues = [lpavLeft]
      CaptionOptions.Visible = False
      CaptionOptions.Layout = clTop
      Control = cbSpecifyHeight
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 97
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutControl1Item16: TdxLayoutItem
      Parent = dxLayoutControl1Group5
      AlignVert = avCenter
      CaptionOptions.Visible = False
      CaptionOptions.Layout = clTop
      Control = seHeight
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 63
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lciRowHeightType: TdxLayoutItem
      Parent = dxLayoutControl1Group5
      AlignVert = avCenter
      CaptionOptions.Text = 'Row height &is:'
      Control = cmbRowHeightType
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 85
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutControl1Group6: TdxLayoutGroup
      Parent = lcgRow
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      ShowBorder = False
      Index = 4
    end
    object lciCantSplit: TdxLayoutItem
      Parent = dxLayoutControl1Group6
      Offsets.Left = 10
      Visible = False
      CaptionOptions.Text = 'cxCheckBox1'
      CaptionOptions.Visible = False
      Control = cbCantSplit
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lciHeader: TdxLayoutItem
      Parent = dxLayoutControl1Group6
      Offsets.Left = 10
      Visible = False
      CaptionOptions.Text = 'cxCheckBox2'
      CaptionOptions.Visible = False
      Control = cbHeader
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutControl1Group7: TdxLayoutAutoCreatedGroup
      Parent = lcgRow
      AlignHorz = ahCenter
      LayoutDirection = ldHorizontal
      Index = 5
    end
    object lciPreviousRow: TdxLayoutItem
      Parent = dxLayoutControl1Group7
      Visible = False
      CaptionOptions.Text = 'cxButton1'
      CaptionOptions.Visible = False
      Control = btnPreviousRow
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 130
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lciNextRow: TdxLayoutItem
      Parent = dxLayoutControl1Group7
      Visible = False
      CaptionOptions.Text = 'cxButton2'
      CaptionOptions.Visible = False
      Control = btnNextRow
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 130
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lcgColumn: TdxLayoutGroup
      Parent = lcgTabControl
      CaptionOptions.Text = 'Col&umn'
      Index = 2
    end
    object lciColumnNumber: TdxLayoutItem
      Parent = lcgColumn
      Offsets.Left = 10
      CaptionOptions.Text = 'Column'
      Index = 1
    end
    object dxLayoutControl1Group8: TdxLayoutGroup
      Parent = lcgColumn
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      Offsets.Left = 10
      LayoutDirection = ldHorizontal
      Padding.AssignedValues = [lpavLeft]
      ShowBorder = False
      Index = 2
    end
    object dxLayoutControl1Item22: TdxLayoutItem
      Parent = dxLayoutControl1Group8
      AlignVert = avCenter
      CaptionOptions.Text = 'cxCheckBox1'
      CaptionOptions.Visible = False
      Control = cbColumnPreferredWidth
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 104
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutControl1Item23: TdxLayoutItem
      Parent = dxLayoutControl1Group8
      AlignVert = avCenter
      CaptionOptions.Text = 'dxMeasurementUnitEdit2'
      CaptionOptions.Visible = False
      Control = seColumnPreferredWidth
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 63
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lciColumnWidthType: TdxLayoutItem
      Parent = dxLayoutControl1Group8
      AlignHorz = ahRight
      AlignVert = avCenter
      CaptionOptions.Text = '&Measure in:'
      Control = cmbColumnWidthType
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 85
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutControl1Group9: TdxLayoutAutoCreatedGroup
      Parent = lcgColumn
      AlignHorz = ahCenter
      LayoutDirection = ldHorizontal
      Index = 3
    end
    object lciPreviousColumn: TdxLayoutItem
      Parent = dxLayoutControl1Group9
      Visible = False
      CaptionOptions.Text = 'cxButton1'
      CaptionOptions.Visible = False
      Control = btnPreviousColumn
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 130
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lciNextColumn: TdxLayoutItem
      Parent = dxLayoutControl1Group9
      Visible = False
      CaptionOptions.Text = 'cxButton2'
      CaptionOptions.Visible = False
      Control = btnNextColumn
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 130
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lcgCell: TdxLayoutGroup
      Parent = lcgTabControl
      CaptionOptions.Text = 'C&ell'
      Index = 3
    end
    object dxLayoutControl1Group10: TdxLayoutGroup
      Parent = lcgCell
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 1
    end
    object dxLayoutControl1Item28: TdxLayoutItem
      Parent = dxLayoutControl1Group10
      AlignVert = avCenter
      CaptionOptions.Text = 'cxCheckBox1'
      CaptionOptions.Visible = False
      Control = cbCellPreferredWidth
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 104
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutControl1Item29: TdxLayoutItem
      Parent = dxLayoutControl1Group10
      AlignVert = avCenter
      CaptionOptions.Text = 'dxMeasurementUnitEdit2'
      CaptionOptions.Visible = False
      Control = seCellPreferredWidth
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 63
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lciCellWidthType: TdxLayoutItem
      Parent = dxLayoutControl1Group10
      AlignVert = avCenter
      CaptionOptions.Text = '&Measure in:'
      Control = cmbCellWidthType
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 85
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object lcgCellVerticalAlignment: TdxLayoutGroup
      Parent = lcgCell
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 3
    end
    object dxLayoutControl1Item30: TdxLayoutItem
      Parent = lcgCellVerticalAlignment
      AlignHorz = ahLeft
      CaptionOptions.Text = 'cxRadioButton1'
      CaptionOptions.Visible = False
      Control = rbCellVerticalAlignmentTop
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 50
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutControl1Item31: TdxLayoutItem
      Parent = lcgCellVerticalAlignment
      AlignHorz = ahLeft
      CaptionOptions.Text = 'cxRadioButton2'
      CaptionOptions.Visible = False
      Control = rbCellVerticalAlignmentCenter
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 65
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutControl1Item32: TdxLayoutItem
      Parent = lcgCellVerticalAlignment
      AlignHorz = ahLeft
      CaptionOptions.Text = 'cxRadioButton3'
      CaptionOptions.Visible = False
      Control = rbCellVerticalAlignmentBottom
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 66
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object lciCellOptions: TdxLayoutItem
      Parent = lcgCell
      AlignHorz = ahRight
      AlignVert = avBottom
      CaptionOptions.Text = 'cxButton1'
      CaptionOptions.Visible = False
      Control = btnCellOptions
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 100
      ControlOptions.ShowBorder = False
      Index = 4
    end
    object dxLayoutControl1Group2: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutControl1Group_Root
      AlignHorz = ahRight
      LayoutDirection = ldHorizontal
      Index = 1
    end
    object dxLayoutControl1Item1: TdxLayoutItem
      Parent = dxLayoutControl1Group2
      AlignHorz = ahRight
      CaptionOptions.Text = 'cxButton1'
      CaptionOptions.Visible = False
      Control = btnOk
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutControl1Item2: TdxLayoutItem
      Parent = dxLayoutControl1Group2
      AlignHorz = ahRight
      CaptionOptions.Text = 'cxButton2'
      CaptionOptions.Visible = False
      Control = btnCancel
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lblTableSize: TdxLayoutSeparatorItem
      Parent = lcgTable
      CaptionOptions.Text = 'Size'
      CaptionOptions.Visible = True
      Index = 0
    end
    object lblTableAlignment: TdxLayoutSeparatorItem
      Parent = lcgTable
      CaptionOptions.Text = 'Alignment'
      CaptionOptions.Visible = True
      Index = 2
    end
    object lblRowSize: TdxLayoutSeparatorItem
      Parent = lcgRow
      CaptionOptions.Text = 'Size'
      CaptionOptions.Visible = True
      Index = 0
    end
    object lblRowOptions: TdxLayoutSeparatorItem
      Parent = lcgRow
      Offsets.Left = 10
      Visible = False
      CaptionOptions.Text = '&Options'
      CaptionOptions.Visible = True
      Index = 3
    end
    object lblColumnSize: TdxLayoutSeparatorItem
      Parent = lcgColumn
      CaptionOptions.Text = 'Size'
      CaptionOptions.Visible = True
      Index = 0
    end
    object lblCellSize: TdxLayoutSeparatorItem
      Parent = lcgCell
      CaptionOptions.Text = 'Size'
      CaptionOptions.Visible = True
      Index = 0
    end
    object lblCellVerticalAlighment: TdxLayoutSeparatorItem
      Parent = lcgCell
      CaptionOptions.Text = 'Vertical alignment'
      CaptionOptions.Visible = True
      Index = 2
    end
  end
end
