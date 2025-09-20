inherited dxRichEditPageSetupDialogForm: TdxRichEditPageSetupDialogForm
  Caption = 'Page Setup'
  ClientHeight = 265
  ClientWidth = 281
  KeyPreview = True
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 13
  inherited dxLayoutControl1: TdxLayoutControl
    Width = 281
    Height = 265
    object rbPortrait: TcxRadioButton [0]
      Left = 30
      Top = 114
      Caption = '&Portrait'
      Color = 16448250
      ParentColor = False
      TabOrder = 4
      AutoSize = True
      ParentBackground = False
      Transparent = True
    end
    object rbLandscape: TcxRadioButton [1]
      Left = 30
      Top = 142
      Caption = 'Land&scape'
      Color = 16448250
      ParentColor = False
      TabOrder = 5
      AutoSize = True
      ParentBackground = False
      Transparent = True
    end
    object cmbMarginsApplyTo: TcxComboBox [2]
      Left = 71
      Top = 170
      Properties.DropDownListStyle = lsFixedList
      Style.HotTrack = False
      TabOrder = 6
      Width = 150
    end
    object cmbPaperApplyTo: TcxComboBox [3]
      Left = 10000
      Top = 9964
      Properties.DropDownListStyle = lsFixedList
      Style.HotTrack = False
      TabOrder = 10
      Visible = False
      Width = 150
    end
    object cmbPaperSize: TcxComboBox [4]
      Left = 10000
      Top = 9964
      Properties.DropDownListStyle = lsFixedList
      Style.HotTrack = False
      TabOrder = 7
      Visible = False
      Width = 133
    end
    object edtPaperWidth: TdxMeasurementUnitEdit [5]
      Left = 10000
      Top = 9964
      TabOrder = 8
      Width = 73
    end
    object edtPaperHeight: TdxMeasurementUnitEdit [6]
      Left = 10000
      Top = 9964
      TabOrder = 9
      Width = 73
    end
    object cmbSectionStart: TcxComboBox [7]
      Left = 10000
      Top = 9964
      Properties.DropDownListStyle = lsFixedList
      Style.HotTrack = False
      TabOrder = 11
      Visible = False
      Width = 133
    end
    object cbDifferentOddAndEvenPage: TcxCheckBox [8]
      Left = 10000
      Top = 9964
      Caption = 'Different &odd and even'
      Style.HotTrack = False
      TabOrder = 12
      Transparent = True
      Visible = False
    end
    object cbDifferentFirstPage: TcxCheckBox [9]
      Left = 10000
      Top = 9964
      Caption = 'Different first &page'
      Style.HotTrack = False
      TabOrder = 13
      Transparent = True
      Visible = False
    end
    object cmbLayoutApplyTo: TcxComboBox [10]
      Left = 10000
      Top = 9964
      Properties.DropDownListStyle = lsFixedList
      Style.HotTrack = False
      TabOrder = 14
      Visible = False
      Width = 150
    end
    object btnOk: TcxButton [11]
      Left = 109
      Top = 213
      Width = 75
      Height = 25
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 15
      OnClick = btnOkClick
    end
    object btnCancel: TcxButton [12]
      Left = 190
      Top = 213
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 16
    end
    object edtMarginLeft: TdxMeasurementUnitEdit [13]
      Left = 58
      Top = 63
      TabOrder = 1
      Width = 73
    end
    object edtMarginRight: TdxMeasurementUnitEdit [14]
      Left = 180
      Top = 63
      TabOrder = 3
      Width = 73
    end
    object edtMarginBottom: TdxMeasurementUnitEdit [15]
      Left = 180
      Top = 32
      TabOrder = 2
      Width = 73
    end
    object edtMarginTop: TdxMeasurementUnitEdit [16]
      Left = 58
      Top = 32
      TabOrder = 0
      Width = 73
    end
    object lcgTabControl: TdxLayoutGroup
      Parent = dxLayoutControl1Group_Root
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'New Group'
      LayoutDirection = ldTabbed
      ShowBorder = False
      Index = 0
    end
    object lcgPageMargins: TdxLayoutGroup
      Parent = lcgTabControl
      CaptionOptions.Text = 'Margins'
      ItemIndex = 4
      Index = 0
    end
    object dxLayoutControl1Group1: TdxLayoutGroup
      Parent = lcgPageMargins
      CaptionOptions.Text = 'New Group'
      Offsets.Left = 8
      ItemIndex = 1
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 1
    end
    object dxLayoutControl1Group5: TdxLayoutGroup
      Parent = lcgPageMargins
      CaptionOptions.Text = 'New Group'
      Offsets.Left = 8
      ItemIndex = 1
      ShowBorder = False
      Index = 3
    end
    object dxLayoutControl1Item5: TdxLayoutItem
      Parent = dxLayoutControl1Group5
      CaptionOptions.Text = 'cxRadioButton1'
      CaptionOptions.Visible = False
      Control = rbPortrait
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 113
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutControl1Item6: TdxLayoutItem
      Parent = dxLayoutControl1Group5
      CaptionOptions.Text = 'cxRadioButton2'
      CaptionOptions.Visible = False
      Control = rbLandscape
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 113
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lciMarginsApplyTo: TdxLayoutItem
      Parent = lcgPageMargins
      AlignHorz = ahLeft
      AlignVert = avBottom
      CaptionOptions.Text = 'Appl&y to:'
      Control = cmbMarginsApplyTo
      ControlOptions.AlignHorz = ahRight
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 150
      ControlOptions.ShowBorder = False
      Index = 4
    end
    object lcgPagePaper: TdxLayoutGroup
      Parent = lcgTabControl
      CaptionOptions.Text = 'Paper'
      ItemIndex = 1
      Index = 1
    end
    object dxLayoutControl1Group6: TdxLayoutGroup
      Parent = lcgPagePaper
      AlignHorz = ahLeft
      CaptionOptions.Text = 'New Group'
      Offsets.Left = 8
      ShowBorder = False
      Index = 1
    end
    object lciPaperApplyTo: TdxLayoutItem
      Parent = lcgPagePaper
      AlignHorz = ahLeft
      AlignVert = avBottom
      CaptionOptions.Text = 'Appl&y to:'
      Control = cmbPaperApplyTo
      ControlOptions.AlignHorz = ahRight
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 150
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutControl1Item8: TdxLayoutItem
      Parent = dxLayoutControl1Group6
      SizeOptions.Width = 133
      CaptionOptions.Visible = False
      Control = cmbPaperSize
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 133
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lciPaperWidth: TdxLayoutItem
      Parent = dxLayoutControl1Group6
      AlignHorz = ahLeft
      SizeOptions.Width = 133
      CaptionOptions.Text = '&Width:'
      Control = edtPaperWidth
      ControlOptions.AlignHorz = ahRight
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 73
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lciPaperHeight: TdxLayoutItem
      Parent = dxLayoutControl1Group6
      AlignHorz = ahLeft
      SizeOptions.Width = 133
      CaptionOptions.Text = '&Height:'
      Control = edtPaperHeight
      ControlOptions.AlignHorz = ahRight
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 73
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object lcgPageLayout: TdxLayoutGroup
      Parent = lcgTabControl
      CaptionOptions.Text = 'Layout'
      ItemIndex = 4
      Index = 2
    end
    object lciSectionStart: TdxLayoutItem
      Parent = lcgPageLayout
      AlignHorz = ahLeft
      Offsets.Left = 8
      CaptionOptions.Text = 'Section sta&rt:'
      Control = cmbSectionStart
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 133
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutControl1Group7: TdxLayoutGroup
      Parent = lcgPageLayout
      CaptionOptions.Text = 'New Group'
      Offsets.Left = 8
      ShowBorder = False
      Index = 3
    end
    object dxLayoutControl1Item13: TdxLayoutItem
      Parent = dxLayoutControl1Group7
      CaptionOptions.Text = 'cxCheckBox1'
      CaptionOptions.Visible = False
      Control = cbDifferentOddAndEvenPage
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutControl1Item14: TdxLayoutItem
      Parent = dxLayoutControl1Group7
      CaptionOptions.Text = 'cxCheckBox2'
      CaptionOptions.Visible = False
      Control = cbDifferentFirstPage
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lciLayoutApplyTo: TdxLayoutItem
      Parent = lcgPageLayout
      AlignHorz = ahLeft
      AlignVert = avBottom
      CaptionOptions.Text = 'Appl&y to:'
      Control = cmbLayoutApplyTo
      ControlOptions.AlignHorz = ahRight
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 150
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
    object lblMargins: TdxLayoutSeparatorItem
      Parent = lcgPageMargins
      CaptionOptions.Text = 'Margins'
      CaptionOptions.Visible = True
      Index = 0
    end
    object lblOrientation: TdxLayoutSeparatorItem
      Parent = lcgPageMargins
      CaptionOptions.Text = 'Orientation'
      CaptionOptions.Visible = True
      Index = 2
    end
    object lblPaperSize: TdxLayoutSeparatorItem
      Parent = lcgPagePaper
      CaptionOptions.Text = 'Pape&r size'
      CaptionOptions.Visible = True
      Index = 0
    end
    object lblSection: TdxLayoutSeparatorItem
      Parent = lcgPageLayout
      CaptionOptions.Text = 'Section'
      CaptionOptions.Visible = True
      Index = 0
    end
    object lblHeadersAndFooters: TdxLayoutSeparatorItem
      Parent = lcgPageLayout
      CaptionOptions.Text = 'Headers and footers'
      CaptionOptions.Visible = True
      Index = 2
    end
    object dxLayoutGroup1: TdxLayoutGroup
      Parent = dxLayoutControl1Group1
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      ItemIndex = 1
      ShowBorder = False
      Index = 0
    end
    object dxLayoutGroup2: TdxLayoutGroup
      Parent = dxLayoutControl1Group1
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      ShowBorder = False
      Index = 1
    end
    object lciMarginLeft: TdxLayoutItem
      Parent = dxLayoutGroup1
      CaptionOptions.Text = '&Left:'
      Control = edtMarginLeft
      ControlOptions.AlignHorz = ahRight
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 73
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lciMarginRight: TdxLayoutItem
      Parent = dxLayoutGroup2
      CaptionOptions.Text = '&Right:'
      Control = edtMarginRight
      ControlOptions.AlignHorz = ahRight
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 73
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lciMarginBottom: TdxLayoutItem
      Parent = dxLayoutGroup2
      CaptionOptions.Text = '&Bottom:'
      Control = edtMarginBottom
      ControlOptions.AlignHorz = ahRight
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 73
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lciMarginTop: TdxLayoutItem
      Parent = dxLayoutGroup1
      CaptionOptions.Text = '&Top:'
      Control = edtMarginTop
      ControlOptions.AlignHorz = ahRight
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 73
      ControlOptions.ShowBorder = False
      Index = 0
    end
  end
  inherited dxLayoutLookAndFeelList1: TdxLayoutLookAndFeelList
    inherited dxLayoutCxLookAndFeel1: TdxLayoutCxLookAndFeel
      PixelsPerInch = 96
    end
  end
end
