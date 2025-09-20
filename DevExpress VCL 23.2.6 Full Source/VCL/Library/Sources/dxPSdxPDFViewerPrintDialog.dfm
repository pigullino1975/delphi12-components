inherited dxPDFPrintDialog: TdxPDFPrintDialog
  Caption = 'dxPDFPrintDialog'
  ClientHeight = 650
  ClientWidth = 1000
  Position = poOwnerFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  inherited lcMain: TdxLayoutControl
    Width = 1000
    Height = 650
    inherited pbxCollate: TPaintBox
      Left = 396
      Top = 151
    end
    inherited btnPreview: TcxButton
      Top = 846
      TabOrder = 33
    end
    inherited btnPageSetup: TcxButton
      Top = 846
      TabOrder = 32
    end
    inherited btnOK: TcxButton
      Left = 810
      Top = 846
      TabOrder = 34
    end
    inherited btnCancel: TcxButton
      Left = 901
      Top = 846
      TabOrder = 35
    end
    inherited btnHelp: TcxButton
      Left = 992
      Top = 846
      TabOrder = 36
    end
    inherited lbxPrintStyles: TcxListBox
      Top = 757
      Height = 65
      TabOrder = 28
    end
    inherited btnDefineStyles: TcxButton
      Top = 786
      TabOrder = 30
    end
    inherited btnPageSetup2: TcxButton
      Top = 757
      TabOrder = 29
    end
    inherited seCopies: TcxSpinEdit
      Left = 439
      Top = 84
      TabOrder = 6
      Width = 127
    end
    inherited cbxNumberOfPages: TcxComboBox
      Left = 439
      Top = 53
      TabOrder = 5
      Width = 127
    end
    inherited chbxCollate: TcxCheckBox
      Left = 345
      Top = 115
      TabOrder = 7
    end
    inherited rbtnAllPages: TcxRadioButton
      Top = 53
      TabOrder = 0
    end
    inherited rbtnCurrentPage: TcxRadioButton
      Top = 81
      TabOrder = 1
    end
    inherited rbtnPageRanges: TcxRadioButton
      Top = 109
      TabOrder = 3
    end
    inherited edPageRanges: TcxTextEdit
      Top = 109
      TabOrder = 4
      Width = 210
    end
    inherited rbtnSelection: TcxRadioButton
      Top = 81
      TabOrder = 2
    end
    inherited cbxPrinters: TcxComboBox
      Top = 272
      TabOrder = 8
      Width = 150
    end
    inherited btnPrinterProperties: TcxButton
      Left = 235
      Top = 273
      TabOrder = 9
    end
    inherited btnNetwork: TcxButton
      Left = 235
      Top = 303
      TabOrder = 11
    end
    inherited lStatus: TcxLabel
      Top = 304
    end
    inherited lType: TcxLabel
      Top = 332
    end
    inherited lWhere: TcxLabel
      Top = 359
    end
    inherited lComment: TcxLabel
      Top = 386
    end
    inherited chbxPrintToFile: TcxCheckBox
      Top = 449
      TabOrder = 16
    end
    inherited cbxFileName: TcxComboBox
      Top = 452
      TabOrder = 17
      Width = 121
    end
    inherited btnBrowse: TcxButton
      Left = 235
      Top = 452
      TabOrder = 18
    end
    object rbtnAdjustTo: TcxRadioButton [27]
      Left = 25
      Top = 546
      Caption = '&Adjust To:'
      Color = 16448250
      ParentColor = False
      TabOrder = 19
      OnClick = rbtnAdjustToClick
      AutoSize = True
      GroupIndex = 1
      ParentBackground = False
      Transparent = True
    end
    object seScaleFactor: TcxSpinEdit [28]
      Left = 45
      Top = 574
      Enabled = False
      Properties.MaxValue = 500.000000000000000000
      Properties.MinValue = 10.000000000000000000
      Properties.OnEditValueChanged = seScaleFactorPropertiesEditValueChanged
      Style.HotTrack = False
      TabOrder = 20
      Value = 100
      OnExit = seScaleFactorExit
      Width = 60
    end
    object rbtnFitToWidth: TcxRadioButton [29]
      Left = 25
      Top = 605
      Caption = '&Fit To Page Width'
      Color = 16448250
      ParentColor = False
      TabOrder = 21
      OnClick = rbtnFitToWidthClick
      AutoSize = True
      GroupIndex = 1
      ParentBackground = False
      Transparent = True
    end
    object lblCenterOnPage: TcxLabel [30]
      Left = 25
      Top = 633
      Caption = 'Center on page '
      Style.HotTrack = False
      Transparent = True
    end
    object cbCenterHorz: TcxCheckBox [31]
      Left = 25
      Top = 660
      Caption = 'Hori&zontaly'
      ParentColor = False
      Style.HotTrack = False
      TabOrder = 23
      Transparent = True
      OnClick = cbCenterHorzClick
    end
    object cbCenterVert: TcxCheckBox [32]
      Tag = 1
      Left = 183
      Top = 660
      AutoSize = False
      Caption = '&Verticaly'
      Style.HotTrack = False
      TabOrder = 24
      Transparent = True
      OnClick = cbCenterVertClick
      Height = 30
      Width = 127
    end
    object rbtnAutoOrientation: TcxRadioButton [33]
      Left = 346
      Top = 272
      Caption = 'Auto portrait/landscape'
      Color = 16448250
      ParentColor = False
      TabOrder = 25
      OnClick = rbtnAutoOrientationClick
      AutoSize = True
      GroupIndex = 2
      ParentBackground = False
      Transparent = True
    end
    object rbtnPortrait: TcxRadioButton [34]
      Left = 346
      Top = 328
      Caption = 'Portrait'
      Color = 16448250
      ParentColor = False
      TabOrder = 27
      OnClick = rbtnPortraitClick
      AutoSize = True
      GroupIndex = 2
      ParentBackground = False
      Transparent = True
    end
    object rbtnLandscape: TcxRadioButton [35]
      Left = 346
      Top = 300
      Caption = 'Landscape'
      Color = 16448250
      ParentColor = False
      TabOrder = 26
      OnClick = rbtnLandscapeClick
      AutoSize = True
      GroupIndex = 2
      ParentBackground = False
      Transparent = True
    end
    object Preview: TdxPSPreviewWindow [36]
      Left = 602
      Top = 53
      Width = 460
      Height = 769
      BorderStyle = cxcbsNone
      OnInitContent = PreviewInitContent
    end
    object cbPrintAsImage: TcxCheckBox [37]
      Left = 25
      Top = 413
      Caption = 'Print as Image'
      Style.HotTrack = False
      TabOrder = 15
      Transparent = True
      OnClick = cbPrintAsImageClick
    end
    inherited lcMainGroup_Root: TdxLayoutGroup
      CaptionOptions.Visible = False
    end
    inherited gbxPrintStyles: TdxLayoutGroup
      Parent = dxLayoutAutoCreatedGroup7
      Top = 475
    end
    inherited dxLayoutAutoCreatedGroup2: TdxLayoutAutoCreatedGroup
      Index = 1
    end
    inherited dxLayoutItem3: TdxLayoutItem
      ControlOptions.OriginalHeight = 65
    end
    inherited gbxCopies: TdxLayoutGroup
      SizeOptions.Width = 200
      Top = 10
    end
    inherited gbxPageRange: TdxLayoutGroup
      Top = 10
    end
    inherited dxLayoutAutoCreatedGroup4: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutAutoCreatedGroup7
      Index = 0
    end
    inherited gbxPrinter: TdxLayoutGroup
      Parent = dxLayoutAutoCreatedGroup9
      AlignHorz = ahLeft
    end
    inherited dxLayoutAutoCreatedGroup10: TdxLayoutAutoCreatedGroup
      Index = 6
    end
    object dxLayoutAutoCreatedGroup7: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutAutoCreatedGroup11
      Index = 0
    end
    object dxLayoutAutoCreatedGroup11: TdxLayoutAutoCreatedGroup
      Parent = lcMainGroup_Root
      LayoutDirection = ldHorizontal
      Index = 0
    end
    object dxLayoutGroup1: TdxLayoutGroup
      Parent = dxLayoutAutoCreatedGroup7
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 1
    end
    object gbxPlacementAndScaling: TdxLayoutGroup
      Parent = dxLayoutAutoCreatedGroup9
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'Placement and Scaling'
      SizeOptions.Width = 250
      ItemIndex = 3
      Index = 1
    end
    object Orientation: TdxLayoutGroup
      Parent = dxLayoutGroup1
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'Orientation'
      SizeOptions.Width = 250
      ItemIndex = 2
      Index = 1
    end
    object dxLayoutItem2: TdxLayoutItem
      Parent = gbxPlacementAndScaling
      CaptionOptions.Visible = False
      Control = rbtnAdjustTo
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 100
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lblPercentOfNormalSize: TdxLayoutItem
      Parent = gbxPlacementAndScaling
      AlignHorz = ahLeft
      Offsets.Left = 20
      CaptionOptions.Text = '% normal size'
      CaptionOptions.Layout = clRight
      Control = seScaleFactor
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 60
      ControlOptions.ShowBorder = False
      Enabled = False
      Index = 1
    end
    object dxLayoutItem4: TdxLayoutItem
      Parent = gbxPlacementAndScaling
      CaptionOptions.Visible = False
      Control = rbtnFitToWidth
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 113
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutItem6: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup8
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = lblCenterOnPage
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 78
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem7: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup12
      AlignHorz = ahClient
      CaptionOptions.Visible = False
      Control = cbCenterHorz
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 78
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem9: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup12
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Visible = False
      Control = cbCenterVert
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 65
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup12: TdxLayoutAutoCreatedGroup
      Parent = gbxPlacementAndScaling
      LayoutDirection = ldHorizontal
      Index = 4
    end
    object dxLayoutItem10: TdxLayoutItem
      Parent = Orientation
      CaptionOptions.Visible = False
      Control = rbtnAutoOrientation
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 113
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem11: TdxLayoutItem
      Parent = Orientation
      CaptionOptions.Visible = False
      Control = rbtnPortrait
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 113
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutItem12: TdxLayoutItem
      Parent = Orientation
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Visible = False
      Control = rbtnLandscape
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 113
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object gbxPreview: TdxLayoutGroup
      Parent = dxLayoutAutoCreatedGroup13
      AlignHorz = ahLeft
      AlignVert = avClient
      CaptionOptions.Text = 'Preview'
      Index = 0
    end
    object dxLayoutAutoCreatedGroup13: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutAutoCreatedGroup11
      AlignHorz = ahClient
      Index = 1
    end
    object dxLayoutItem1: TdxLayoutItem
      Parent = gbxPreview
      AlignHorz = ahClient
      AlignVert = avClient
      Control = Preview
      ControlOptions.OriginalHeight = 100
      ControlOptions.OriginalWidth = 460
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem13: TdxLayoutItem
      Parent = gbxPrinter
      AlignHorz = ahClient
      AlignVert = avTop
      LayoutLookAndFeel = dxLayoutCxLookAndFeel1
      CaptionOptions.Text = 'New Item'
      CaptionOptions.Visible = False
      Control = cbPrintAsImage
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 91
      ControlOptions.ShowBorder = False
      Index = 5
    end
    object dxLayoutSeparatorItem1: TdxLayoutSeparatorItem
      Parent = dxLayoutAutoCreatedGroup8
      AlignHorz = ahClient
      AlignVert = avCenter
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object dxLayoutAutoCreatedGroup8: TdxLayoutAutoCreatedGroup
      Parent = gbxPlacementAndScaling
      LayoutDirection = ldHorizontal
      Index = 3
    end
    object dxLayoutAutoCreatedGroup9: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutGroup1
      AlignHorz = ahClient
      Index = 0
    end
  end
  inherited pmPrintStyles: TPopupMenu
    Left = 455
    Top = 352
  end
  inherited ilPrinters: TcxImageList
    FormatVersion = 1
    DesignInfo = -195988
  end
  inherited dxLayoutLookAndFeelList1: TdxLayoutLookAndFeelList
    Left = 480
    inherited dxLayoutCxLookAndFeel1: TdxLayoutCxLookAndFeel
      PixelsPerInch = 96
    end
  end
end
