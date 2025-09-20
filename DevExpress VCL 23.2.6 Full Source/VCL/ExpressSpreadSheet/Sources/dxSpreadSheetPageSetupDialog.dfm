inherited dxSpreadSheetPageSetupDialogForm: TdxSpreadSheetPageSetupDialogForm
  Caption = 'dxSpreadSheetPageSetupDialogForm'
  ClientHeight = 521
  ClientWidth = 529
  PopupMode = pmAuto
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  inherited lcMain: TdxLayoutControl
    Width = 529
    Height = 521
    inherited beAreaSelector: TcxButtonEdit
      Width = 378
    end
    object btnCancel: TcxButton [1]
      Left = 313
      Top = 454
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'btnCancel'
      ModalResult = 2
      TabOrder = 44
      OnClick = btnCancelClick
    end
    object btnOK: TcxButton [2]
      Left = 232
      Top = 454
      Width = 75
      Height = 25
      Caption = 'btnOK'
      Default = True
      TabOrder = 43
      OnClick = btnOKClick
    end
    object tePrintArea: TcxButtonEdit [3]
      Left = 10000
      Top = 10000
      RepositoryItem = ertiArea
      Properties.Buttons = <>
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 29
      Text = 'tePrintArea'
      Visible = False
      OnEnter = tePrintAreaEnter
      OnExit = tePrintAreaExit
      Width = 289
    end
    object lbPrint: TcxLabel [4]
      Left = 10000
      Top = 10000
      Caption = 'lbPrint'
      Style.HotTrack = False
      Style.TransparentBorder = False
      Transparent = True
      Visible = False
    end
    object cbPrintGridLines: TcxCheckBox [5]
      Left = 10000
      Top = 10000
      Caption = 'cbPrintGridLines'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 34
      Transparent = True
      Visible = False
    end
    object cbPrintHeaders: TcxCheckBox [6]
      Left = 10000
      Top = 10000
      Caption = 'cbGridLines'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 37
      Transparent = True
      Visible = False
    end
    object cbPrintCommentsMode: TcxComboBox [7]
      Left = 10000
      Top = 10000
      Properties.DropDownListStyle = lsFixedList
      Style.HotTrack = False
      TabOrder = 38
      Visible = False
      Width = 140
    end
    object cbPrintCellErrorsMode: TcxComboBox [8]
      Left = 10000
      Top = 10000
      Properties.DropDownListStyle = lsFixedList
      Style.HotTrack = False
      TabOrder = 39
      Visible = False
      Width = 140
    end
    object cbBlackAndWhite: TcxCheckBox [9]
      Left = 10000
      Top = 10000
      Caption = 'cbGridLines'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 35
      Transparent = True
      Visible = False
    end
    object cbDraftQuality: TcxCheckBox [10]
      Left = 10000
      Top = 10000
      Caption = 'cbGridLines'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 36
      Transparent = True
      Visible = False
    end
    object lbPrintTitles: TcxLabel [11]
      Left = 10000
      Top = 10000
      Caption = 'lbPrintTitles'
      Style.HotTrack = False
      Style.TransparentBorder = False
      Transparent = True
      Visible = False
    end
    object teRowsToRepeat: TcxButtonEdit [12]
      Left = 10000
      Top = 10000
      RepositoryItem = ertiArea
      Properties.Buttons = <>
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 31
      Text = 'teRowsToRepeat'
      Visible = False
      OnEnter = tePrintAreaEnter
      OnExit = tePrintAreaExit
      Width = 324
    end
    object teColumnsToRepeat: TcxButtonEdit [13]
      Left = 10000
      Top = 10000
      RepositoryItem = ertiArea
      Properties.Buttons = <>
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 32
      Text = 'teColumnsToRepeat'
      Visible = False
      OnEnter = tePrintAreaEnter
      OnExit = tePrintAreaExit
      Width = 324
    end
    object lbPageOrder: TcxLabel [14]
      Left = 10000
      Top = 10000
      Caption = 'lbPageOrder'
      Style.HotTrack = False
      Style.TransparentBorder = False
      Transparent = True
      Visible = False
    end
    object rbtnDownThenOver: TcxRadioButton [15]
      Tag = 1
      Left = 10000
      Top = 10000
      Caption = '&Down, then over'
      Checked = True
      Color = clBtnFace
      ParentColor = False
      TabOrder = 41
      TabStop = True
      Visible = False
      OnClick = rbtnOverThenDownClick
      AutoSize = True
      GroupIndex = 1
      ParentBackground = False
      Transparent = True
    end
    object rbtnOverThenDown: TcxRadioButton [16]
      Left = 10000
      Top = 10000
      Caption = 'O&ver, then down'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 42
      Visible = False
      OnClick = rbtnOverThenDownClick
      AutoSize = True
      GroupIndex = 1
      ParentBackground = False
      Transparent = True
    end
    object pbxPageOrder: TPaintBox [17]
      Left = 10000
      Top = 10000
      Width = 74
      Height = 49
      Color = clBtnFace
      ParentColor = False
      Visible = False
      OnPaint = pbxPageOrderPaint
    end
    object lbOrientation: TcxLabel [18]
      Left = 24
      Top = 74
      Caption = 'lbOrientation'
      Style.HotTrack = False
      Style.TransparentBorder = False
      Transparent = True
    end
    object pbxPageOrientation: TPaintBox [19]
      Left = 34
      Top = 97
      Width = 32
      Height = 32
      Color = clBtnFace
      ParentColor = False
      OnPaint = pbxPageOrientationPaint
    end
    object rbPageOrientationPortrait: TcxRadioButton [20]
      Tag = 1
      Left = 76
      Top = 93
      Caption = 'Portrait'
      Checked = True
      Color = clBtnFace
      ParentColor = False
      TabOrder = 4
      TabStop = True
      OnClick = rbPageOrientationPortraitClick
      AutoSize = True
      GroupIndex = 2
      ParentBackground = False
      Transparent = True
    end
    object rbPageOrientationLandscape: TcxRadioButton [21]
      Left = 76
      Top = 116
      Caption = 'Landscape'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 5
      OnClick = rbPageOrientationPortraitClick
      AutoSize = True
      GroupIndex = 2
      ParentBackground = False
      Transparent = True
    end
    object meFirstPageNumber: TcxMaskEdit [22]
      Left = 111
      Top = 251
      Properties.MaskKind = emkRegExpr
      Properties.EditMask = '\d*'
      Style.HotTrack = False
      TabOrder = 13
      Width = 45
    end
    object seMarginLeft: TcxSpinEdit [23]
      Left = 9999
      Top = 10000
      RepositoryItem = ersiMargins
      Style.HotTrack = False
      TabOrder = 14
      Visible = False
      Width = 75
    end
    object seMarginTop: TcxSpinEdit [24]
      Left = 9999
      Top = 10000
      RepositoryItem = ersiMargins
      Style.HotTrack = False
      TabOrder = 15
      Visible = False
      Width = 75
    end
    object seMarginRight: TcxSpinEdit [25]
      Left = 9999
      Top = 10000
      RepositoryItem = ersiMargins
      Style.HotTrack = False
      TabOrder = 20
      Visible = False
      Width = 75
    end
    object seMarginHeader: TcxSpinEdit [26]
      Left = 9999
      Top = 10000
      RepositoryItem = ersiMargins
      Style.HotTrack = False
      TabOrder = 19
      Visible = False
      Width = 75
    end
    object seMarginBottom: TcxSpinEdit [27]
      Left = 9999
      Top = 10000
      RepositoryItem = ersiMargins
      Style.HotTrack = False
      TabOrder = 17
      Visible = False
      Width = 75
    end
    object seMarginFooter: TcxSpinEdit [28]
      Left = 9999
      Top = 10000
      RepositoryItem = ersiMargins
      Style.HotTrack = False
      TabOrder = 18
      Visible = False
      Width = 75
    end
    object gbPagePreviewHolder: TcxGroupBox [29]
      Left = 9999
      Top = 10000
      PanelStyle.Active = True
      ParentBackground = False
      ParentColor = False
      Style.Color = clBtnFace
      Style.TransparentBorder = False
      TabOrder = 16
      Visible = False
      Height = 160
      Width = 160
    end
    object lbCenterOnPage: TcxLabel [30]
      Left = 9999
      Top = 10000
      Caption = 'lbCenterOnPage'
      Style.HotTrack = False
      Style.TransparentBorder = False
      Transparent = True
      Visible = False
    end
    object cbCenterHorizontally: TcxCheckBox [31]
      Left = 9999
      Top = 10000
      Caption = 'cbCenterHorizontally'
      Properties.OnChange = PageSettingsChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 22
      Transparent = True
      Visible = False
    end
    object cbCenterVertically: TcxCheckBox [32]
      Left = 9999
      Top = 10000
      Caption = 'cbCenterVertically'
      Properties.OnChange = PageSettingsChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 23
      Transparent = True
      Visible = False
    end
    object cbPaperSize: TcxComboBox [33]
      Left = 111
      Top = 224
      Properties.DropDownListStyle = lsFixedList
      Properties.OnChange = PageSettingsChanged
      Style.HotTrack = False
      TabOrder = 12
      Width = 263
    end
    object lbScaling: TcxLabel [34]
      Left = 24
      Top = 139
      Caption = 'lbScaling'
      Style.HotTrack = False
      Style.TransparentBorder = False
      Transparent = True
    end
    object seAdjustTo: TcxSpinEdit [35]
      Left = 114
      Top = 158
      Properties.Increment = 5.000000000000000000
      Properties.OnChange = seAdjustToPropertiesChange
      Style.HotTrack = False
      TabOrder = 9
      Value = 10
      Width = 62
    end
    object sePagesWide: TcxSpinEdit [36]
      Left = 114
      Top = 185
      Properties.OnChange = sePagesWidePropertiesChange
      Style.HotTrack = False
      TabOrder = 10
      Width = 62
    end
    object sePagesTall: TcxSpinEdit [37]
      Left = 251
      Top = 185
      Style.HotTrack = False
      TabOrder = 11
      Height = 21
      Width = 62
    end
    object rbAdjustTo: TcxRadioButton [38]
      Left = 34
      Top = 158
      Caption = 'rbAdjustTo'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 7
      OnClick = rbAdjustToClick
      AutoSize = True
      ParentBackground = False
      Transparent = True
    end
    object rbFitTo: TcxRadioButton [39]
      Left = 34
      Top = 189
      Caption = 'rbFitTo'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 8
      OnClick = rbFitToClick
      AutoSize = True
      ParentBackground = False
      Transparent = True
    end
    object cbHeaderTemplates: TcxComboBox [40]
      Left = 9999
      Top = 10000
      Properties.DropDownListStyle = lsFixedList
      Properties.OnChange = cbHeaderTemplatesPropertiesChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 24
      Visible = False
      Width = 349
    end
    object cbFooterTemplates: TcxComboBox [41]
      Left = 9999
      Top = 10000
      Properties.DropDownListStyle = lsFixedList
      Properties.OnChange = cbFooterTemplatesPropertiesChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 26
      Visible = False
      Width = 349
    end
    object btnCustomHeaderFooter: TcxButton [42]
      Left = 9999
      Top = 10000
      Width = 160
      Height = 25
      Caption = 'btnCustomHeaderFooter'
      TabOrder = 25
      Visible = False
      OnClick = btnCustomHeaderFooterClick
    end
    object cbAlignWithPageMargins: TcxCheckBox [43]
      Left = 9999
      Top = 10000
      Caption = 'cbAlignWithPageMargins'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 28
      Transparent = True
      Visible = False
    end
    object cbScaleWithDocument: TcxCheckBox [44]
      Left = 9999
      Top = 10000
      Caption = 'cxCheckBox1'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 27
      Transparent = True
      Visible = False
    end
    object pbHeaderPreview: TPaintBox [45]
      Left = 10000
      Top = 10000
      Width = 349
      Height = 50
      Color = clBtnFace
      ParentColor = False
      Visible = False
      OnPaint = pbHeaderPreviewPaint
    end
    object pbFooterPreview: TPaintBox [46]
      Left = 10000
      Top = 10000
      Width = 349
      Height = 50
      Color = clBtnFace
      ParentColor = False
      Visible = False
      OnPaint = pbFooterPreviewPaint
    end
    object btnPrint: TcxButton [47]
      Left = 176
      Top = 409
      Width = 96
      Height = 25
      Caption = 'btnPrint'
      TabOrder = 1
      OnClick = btnPrintClick
    end
    object btnPrintPreview: TcxButton [48]
      Left = 278
      Top = 409
      Width = 96
      Height = 25
      Caption = 'btnPrintPreview'
      TabOrder = 2
      OnClick = btnPrintPreviewClick
    end
    inherited lcMainGroup_Root: TdxLayoutGroup
      ItemIndex = 1
    end
    object dxLayoutItem1: TdxLayoutItem
      Parent = lgButtons
      CaptionOptions.Text = 'cxButton1'
      CaptionOptions.Visible = False
      Control = btnCancel
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem2: TdxLayoutItem
      Parent = lgButtons
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Visible = False
      Control = btnOK
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lgTabs: TdxLayoutGroup
      Parent = lcMainGroup_Root
      CaptionOptions.Text = 'New Group'
      LayoutDirection = ldTabbed
      ShowBorder = False
      TabbedOptions.ShowFrame = True
      OnTabChanged = lgTabsTabChanged
      Index = 1
    end
    object lgButtons: TdxLayoutAutoCreatedGroup
      Parent = lcMainGroup_Root
      AlignHorz = ahRight
      LayoutDirection = ldHorizontal
      Index = 2
    end
    object lgSheet: TdxLayoutGroup
      Parent = lgTabs
      CaptionOptions.Text = 'New Group'
      ItemIndex = 6
      Index = 3
    end
    object liPrintArea: TdxLayoutItem
      Parent = lgSheet
      CaptionOptions.Text = 'tePrintArea'
      Control = tePrintArea
      ControlOptions.OriginalHeight = 24
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem3: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup17
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = lbPrint
      ControlOptions.OriginalHeight = 13
      ControlOptions.OriginalWidth = 30
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem4: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup4
      AlignHorz = ahLeft
      Offsets.Left = 10
      CaptionOptions.Visible = False
      Control = cbPrintGridLines
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 94
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem5: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup4
      AlignHorz = ahLeft
      Offsets.Left = 10
      CaptionOptions.Visible = False
      Control = cbPrintHeaders
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 72
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object liPrintCommentsMode: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup3
      AlignHorz = ahRight
      Control = cbPrintCommentsMode
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 140
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutAutoCreatedGroup2: TdxLayoutAutoCreatedGroup
      Parent = lgSheet
      LayoutDirection = ldHorizontal
      Index = 5
    end
    object liPrintCellErrorsMode: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup3
      AlignHorz = ahRight
      Control = cbPrintCellErrorsMode
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 140
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup3: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutAutoCreatedGroup2
      AlignHorz = ahRight
      Index = 1
    end
    object dxLayoutAutoCreatedGroup4: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutAutoCreatedGroup2
      AlignHorz = ahClient
      Index = 0
    end
    object liBlackAndWhite: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup4
      AlignHorz = ahLeft
      Offsets.Left = 10
      CaptionOptions.Visible = False
      Control = cbBlackAndWhite
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 72
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem6: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup4
      AlignHorz = ahLeft
      Padding.Left = 10
      Padding.AssignedValues = [lpavLeft]
      CaptionOptions.Visible = False
      Control = cbDraftQuality
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 72
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutItem7: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup16
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = lbPrintTitles
      ControlOptions.OriginalHeight = 13
      ControlOptions.OriginalWidth = 55
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object liRowsToRepeat: TdxLayoutItem
      Parent = lgSheet
      Offsets.Left = 14
      CaptionOptions.Text = '1'
      Control = teRowsToRepeat
      ControlOptions.OriginalHeight = 24
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object liColumnsToRepeat: TdxLayoutItem
      Parent = lgSheet
      Offsets.Left = 14
      CaptionOptions.Text = '1'
      Control = teColumnsToRepeat
      ControlOptions.OriginalHeight = 24
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object dxLayoutItem8: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup18
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = lbPageOrder
      ControlOptions.OriginalHeight = 13
      ControlOptions.OriginalWidth = 60
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem9: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup6
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Visible = False
      Control = rbtnDownThenOver
      ControlOptions.AlignHorz = ahLeft
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 106
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem10: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup6
      AlignHorz = ahClient
      CaptionOptions.Visible = False
      Control = rbtnOverThenDown
      ControlOptions.AlignHorz = ahLeft
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 107
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem11: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup5
      AlignHorz = ahLeft
      AlignVert = avTop
      Offsets.Left = 10
      Control = pbxPageOrder
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 49
      ControlOptions.OriginalWidth = 74
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutAutoCreatedGroup5: TdxLayoutAutoCreatedGroup
      Parent = lgSheet
      AlignHorz = ahClient
      AlignVert = avTop
      LayoutDirection = ldHorizontal
      Index = 7
    end
    object dxLayoutAutoCreatedGroup6: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutAutoCreatedGroup5
      AlignHorz = ahClient
      AlignVert = avCenter
      Index = 1
    end
    object lgPage: TdxLayoutGroup
      Parent = lgTabs
      CaptionOptions.Text = 'New Group'
      ItemIndex = 4
      Index = 0
    end
    object dxLayoutItem12: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup13
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = lbOrientation
      ControlOptions.OriginalHeight = 13
      ControlOptions.OriginalWidth = 62
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem13: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup7
      AlignHorz = ahLeft
      Padding.Bottom = 4
      Padding.Left = 10
      Padding.Right = 4
      Padding.Top = 4
      Padding.AssignedValues = [lpavBottom, lpavLeft, lpavRight, lpavTop]
      Control = pbxPageOrientation
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 32
      ControlOptions.OriginalWidth = 32
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem14: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup8
      CaptionOptions.Visible = False
      Control = rbPageOrientationPortrait
      ControlOptions.AlignHorz = ahLeft
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 54
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem15: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup8
      AlignHorz = ahClient
      CaptionOptions.Visible = False
      Control = rbPageOrientationLandscape
      ControlOptions.AlignHorz = ahLeft
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 69
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup7: TdxLayoutAutoCreatedGroup
      Parent = lgPage
      LayoutDirection = ldHorizontal
      Index = 2
    end
    object dxLayoutAutoCreatedGroup8: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutAutoCreatedGroup7
      AlignHorz = ahClient
      Index = 1
    end
    object liFirstPageNumber: TdxLayoutItem
      Parent = lgPage
      AlignHorz = ahLeft
      CaptionOptions.Text = 'FirstPageNumber'
      Control = meFirstPageNumber
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 45
      ControlOptions.ShowBorder = False
      Index = 7
    end
    object lgMargins: TdxLayoutGroup
      Parent = lgTabs
      CaptionOptions.Text = 'New Group'
      SizeOptions.Height = 360
      ItemIndex = 1
      Index = 1
    end
    object liMarginLeft: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup9
      AlignHorz = ahLeft
      AlignVert = avCenter
      SizeOptions.Width = 75
      CaptionOptions.Text = 'liMarginLeft'
      CaptionOptions.Layout = clTop
      Control = seMarginLeft
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object liMarginTop: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup10
      AlignHorz = ahCenter
      SizeOptions.Width = 75
      CaptionOptions.Text = 'MarginTop'
      CaptionOptions.Layout = clTop
      Control = seMarginTop
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object liMarginRight: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup11
      AlignVert = avCenter
      SizeOptions.Width = 75
      CaptionOptions.Text = 'MarginRight'
      CaptionOptions.Layout = clTop
      Control = seMarginRight
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 60
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object liMarginHeader: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup11
      SizeOptions.Width = 75
      CaptionOptions.Text = 'MarginHeader'
      CaptionOptions.Layout = clTop
      Control = seMarginHeader
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 60
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object liMarginBottom: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup10
      AlignHorz = ahCenter
      SizeOptions.Width = 75
      CaptionOptions.Text = 'liMarginBottom'
      CaptionOptions.Layout = clTop
      Control = seMarginBottom
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object liMarginFooter: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup11
      AlignVert = avBottom
      SizeOptions.Width = 75
      CaptionOptions.Text = 'liMarginFooter'
      CaptionOptions.Layout = clTop
      Control = seMarginFooter
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 60
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem22: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup10
      AlignVert = avTop
      CaptionOptions.Visible = False
      CaptionOptions.Layout = clTop
      Control = gbPagePreviewHolder
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 160
      ControlOptions.OriginalWidth = 160
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup9: TdxLayoutAutoCreatedGroup
      Parent = lgMargins
      AlignHorz = ahCenter
      AlignVert = avTop
      LayoutDirection = ldHorizontal
      Index = 0
    end
    object dxLayoutAutoCreatedGroup10: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutAutoCreatedGroup9
      Index = 1
    end
    object dxLayoutAutoCreatedGroup11: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutAutoCreatedGroup9
      Index = 2
    end
    object dxLayoutItem16: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup15
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = lbCenterOnPage
      ControlOptions.OriginalHeight = 13
      ControlOptions.OriginalWidth = 79
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem17: TdxLayoutItem
      Parent = lgMargins
      Offsets.Left = 10
      CaptionOptions.Visible = False
      Control = cbCenterHorizontally
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 93
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutItem18: TdxLayoutItem
      Parent = lgMargins
      Offsets.Left = 10
      CaptionOptions.Visible = False
      Control = cbCenterVertically
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 93
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object liPaperSize: TdxLayoutItem
      Parent = lgPage
      AlignHorz = ahClient
      CaptionOptions.Text = 'liPaperSize'
      Control = cbPaperSize
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 6
    end
    object dxLayoutItem19: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup14
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = lbScaling
      ControlOptions.OriginalHeight = 13
      ControlOptions.OriginalWidth = 41
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutSeparatorItem1: TdxLayoutSeparatorItem
      Parent = lgPage
      CaptionOptions.Text = 'Separator'
      Index = 5
    end
    object liAdjustTo: TdxLayoutItem
      Parent = dxLayoutGroup2
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Text = 'liAdjustTo'
      CaptionOptions.Layout = clRight
      Control = seAdjustTo
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 62
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object liPagesWide: TdxLayoutItem
      Parent = dxLayoutGroup2
      AlignHorz = ahLeft
      AlignVert = avBottom
      CaptionOptions.Text = 'sePagesWide'
      CaptionOptions.Layout = clRight
      Control = sePagesWide
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 62
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object liPagesTall: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup1
      AlignVert = avBottom
      CaptionOptions.Text = 'sePagesTall'
      CaptionOptions.Layout = clRight
      Control = sePagesTall
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 62
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutItem24: TdxLayoutItem
      Parent = dxLayoutGroup1
      AlignHorz = ahLeft
      Offsets.Left = 10
      SizeOptions.Width = 74
      CaptionOptions.Visible = False
      Control = rbAdjustTo
      ControlOptions.AlignHorz = ahLeft
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 71
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem25: TdxLayoutItem
      Parent = dxLayoutGroup1
      AlignHorz = ahLeft
      AlignVert = avBottom
      Offsets.Left = 10
      SizeOptions.Width = 74
      CaptionOptions.Visible = False
      Control = rbFitTo
      ControlOptions.AlignHorz = ahLeft
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 52
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lgHeaderFooter: TdxLayoutGroup
      Parent = lgTabs
      CaptionOptions.Text = 'New Group'
      ItemIndex = 5
      Index = 2
    end
    object liHeader: TdxLayoutItem
      Parent = lgHeaderFooter
      CaptionOptions.Text = 'Caption:'
      CaptionOptions.Layout = clTop
      Control = cbHeaderTemplates
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object liFooter: TdxLayoutItem
      Parent = lgHeaderFooter
      CaptionOptions.Text = 'Caption:'
      CaptionOptions.Layout = clTop
      Control = cbFooterTemplates
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 4
    end
    object dxLayoutItem29: TdxLayoutItem
      Parent = lgHeaderFooter
      AlignHorz = ahCenter
      CaptionOptions.Text = 'cxButton1'
      CaptionOptions.Visible = False
      CaptionOptions.Layout = clTop
      Control = btnCustomHeaderFooter
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 160
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutItem30: TdxLayoutItem
      Parent = lgHeaderFooter
      CaptionOptions.Text = 'cxCheckBox1'
      CaptionOptions.Visible = False
      CaptionOptions.Layout = clTop
      Control = cbAlignWithPageMargins
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 84
      ControlOptions.ShowBorder = False
      Index = 6
    end
    object dxLayoutItem31: TdxLayoutItem
      Parent = lgHeaderFooter
      CaptionOptions.Visible = False
      CaptionOptions.Layout = clTop
      Control = cbScaleWithDocument
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 84
      ControlOptions.ShowBorder = False
      Index = 5
    end
    object dxLayoutItem20: TdxLayoutItem
      Parent = lgHeaderFooter
      Control = pbHeaderPreview
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 50
      ControlOptions.OriginalWidth = 105
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem21: TdxLayoutItem
      Parent = lgHeaderFooter
      CaptionOptions.Layout = clTop
      Control = pbFooterPreview
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 50
      ControlOptions.OriginalWidth = 105
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object dxLayoutItem23: TdxLayoutItem
      Parent = lgPrintButtons
      AlignHorz = ahRight
      AlignVert = avClient
      CaptionOptions.Text = 'cxButton1'
      CaptionOptions.Visible = False
      Control = btnPrint
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 96
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem26: TdxLayoutItem
      Parent = lgPrintButtons
      AlignHorz = ahRight
      AlignVert = avBottom
      CaptionOptions.Visible = False
      Control = btnPrintPreview
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 96
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lgPrintButtons: TdxLayoutGroup
      Parent = lgPage
      AlignHorz = ahRight
      AlignVert = avBottom
      CaptionOptions.Text = 'New Group'
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 0
    end
    object dxLayoutGroup1: TdxLayoutGroup
      Parent = dxLayoutAutoCreatedGroup1
      AlignHorz = ahLeft
      CaptionOptions.Text = 'Hidden Group'
      Hidden = True
      ItemIndex = 1
      ShowBorder = False
      Index = 0
    end
    object dxLayoutGroup2: TdxLayoutGroup
      Parent = dxLayoutAutoCreatedGroup1
      CaptionOptions.Text = 'Hidden Group'
      Hidden = True
      ItemIndex = 1
      ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup
      Parent = lgPage
      LayoutDirection = ldHorizontal
      Index = 4
    end
    object dxLayoutSeparatorItem2: TdxLayoutSeparatorItem
      Parent = dxLayoutAutoCreatedGroup13
      AlignHorz = ahClient
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object dxLayoutAutoCreatedGroup13: TdxLayoutAutoCreatedGroup
      Parent = lgPage
      LayoutDirection = ldHorizontal
      Index = 1
    end
    object dxLayoutSeparatorItem3: TdxLayoutSeparatorItem
      Parent = dxLayoutAutoCreatedGroup14
      AlignHorz = ahClient
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object dxLayoutAutoCreatedGroup14: TdxLayoutAutoCreatedGroup
      Parent = lgPage
      LayoutDirection = ldHorizontal
      Index = 3
    end
    object dxLayoutSeparatorItem4: TdxLayoutSeparatorItem
      Parent = dxLayoutAutoCreatedGroup15
      AlignHorz = ahClient
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object dxLayoutSeparatorItem5: TdxLayoutSeparatorItem
      Parent = dxLayoutAutoCreatedGroup16
      AlignHorz = ahClient
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object dxLayoutAutoCreatedGroup15: TdxLayoutAutoCreatedGroup
      Parent = lgMargins
      LayoutDirection = ldHorizontal
      Index = 1
    end
    object dxLayoutAutoCreatedGroup16: TdxLayoutAutoCreatedGroup
      Parent = lgSheet
      LayoutDirection = ldHorizontal
      Index = 1
    end
    object dxLayoutSeparatorItem6: TdxLayoutSeparatorItem
      Parent = dxLayoutAutoCreatedGroup17
      AlignHorz = ahClient
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object dxLayoutSeparatorItem7: TdxLayoutSeparatorItem
      Parent = dxLayoutAutoCreatedGroup18
      AlignHorz = ahClient
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object dxLayoutAutoCreatedGroup17: TdxLayoutAutoCreatedGroup
      Parent = lgSheet
      LayoutDirection = ldHorizontal
      Index = 4
    end
    object dxLayoutAutoCreatedGroup18: TdxLayoutAutoCreatedGroup
      Parent = lgSheet
      LayoutDirection = ldHorizontal
      Index = 6
    end
  end
  inherited LayoutLookAndFeelList: TdxLayoutLookAndFeelList
    inherited LayoutCxLookAndFeel: TdxLayoutCxLookAndFeel
      PixelsPerInch = 96
    end
  end
  inherited EditRepository: TcxEditRepository
    Left = 304
    PixelsPerInch = 96
    object ersiMargins: TcxEditRepositorySpinItem
      Properties.AssignedValues.MinValue = True
      Properties.EditFormat = '0.00'
      Properties.ValueType = vtFloat
      Properties.OnChange = PageSettingsChanged
    end
  end
  object ilPrintOrders: TcxImageList
    SourceDPI = 96
    BkColor = clWhite
    Height = 64
    Width = 64
    FormatVersion = 1
    Left = 274
    Top = 8
    Bitmap = {
      494C010102001800100040004000FFFFFF002110FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000000100004000000001002000000000000000
      0100000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000D07
      01402715036E2816036F2816036F2816036F2816036F2816036F2816036F2816
      036F2816036F2816036F2816036F2816036F2816036F2816036F2816036F2816
      036F2816036F2816036F2816036F2816036F2816036F2816036F2816036F2816
      036F2816036F130A014D0000000300000000000000000301001F231302672816
      036F2816036F2816036F2816036F2816036F2816036F2816036F2816036F2816
      036F2816036F2816036F2816036F2816036F2816036F2816036F2816036F2816
      036F2816036F2816036F2816036F2816036F2816036F2816036F2816036F1F11
      0262010000160000000000000000000000000000000000000000000000000D07
      01402715036E2816036F2816036F2816036F2816036F2816036F2816036F2816
      036F2816036F2816036F2816036F2816036F2816036F2816036F2816036F2816
      036F2816036F2816036F2816036F2816036F2816036F2816036F2816036F2816
      036F2816036F130A014D0000000300000000000000000301001F231302672816
      036F2816036F2816036F2816036F2816036F2816036F2816036F2816036F2816
      036F2816036F2816036F2816036F2816036F2816036F2816036F2816036F2816
      036F2816036F2816036F2816036F2816036F2816036F2816036F2816036F1F11
      0262010000160000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000003010020351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F07040031000000000000000029160370351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F1E100260000000000000000000000000000000000000000003010020351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F07040031000000000000000029160370351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F66513AA96C57
      40AD351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F1E1002600000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000009050037351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F100901470000000000000008351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2E190377000000000000000000000000000000000000000009050037351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F100901470000000000000008351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F705B45AFFFFF
      FFFFA19382CF3B230A85351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2E1903770000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F100901470000000000000008351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F3D250C87351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2E19037700000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F100901470000000000000008351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F705B45AFB6DE
      ACFFAAD99EFFD7D0C8EC50381F97351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2E1903770000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F100901470000000000000008351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F897764C0D9D4CCED432C138D351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2E19037700000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F100901470000000000000008351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F705B45AFADDA
      A1FF229C02FF6FBF5AFFECF1E8FC796650B6361E0480351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2E1903770000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F100901470000000000000008351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F826F5ABBD8EED3FF95CF85FFD9D3CBED40280F8A351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2E19037700000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F100901470000000000000008351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F705B45AFADDA
      A1FF229C02FF229C02FF40AA25FFD1EACAFFB2A598D83F270D89351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2E1903770000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F5B442CA0351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F100901470000000000000008351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F826F5ABBE0F1DCFF39A61DFF229C02FF8ACA78FFD1CAC1E940280F8A351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2E19037700000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F100901470000000000000008351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F705B45AFADDA
      A1FF229C02FF229C02FF229C02FF269E07FF9AD18BFFE0DCD6F15A422A9F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2E1903770000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037FBEB4A8DFAA9D8FD43C240A86351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F100901470000000000000008351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F7663
      4CB4E0F1DCFF3AA71EFF229C02FF229C02FF229C02FF96D087FFD1CAC1E94028
      0F8A351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2E19037700000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F100901470000000000000008351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F705B45AFADDA
      A1FF229C02FF229C02FF229C02FF229C02FF229C02FF5FB748FFEAF3E6FE8977
      63C0361E0581351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2E1903770000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037FBEB4A8DFCDE9C6FFD5CEC7EB4D351C95351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F100901470000000000000008351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F76634CB4E6F3
      E2FF3AA71EFF229C02FF229C02FF229C02FF229C02FF229C02FF98D189FFC7BE
      B4E43D250B87351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2E19037700000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F361E0480877562BFB0A396D7B0A396D7B0A396D7B0A3
      96D7B0A396D7B0A396D7B0A396D7B0A396D7B0A396D7B0A396D7B0A396D7B0A3
      96D7B0A396D7B0A396D7B0A396D7B0A396D7B0A396D7B0A396D7B0A396D7B0A3
      96D7B0A396D7B0A396D7969089C6787878AF7C7B7BB2B0A396D7B0A396D7B0A3
      96D7B0A396D7B0A396D7B0A396D7B0A396D7B0A396D7B0A396D7CBC3BAE6ADDA
      A1FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF37A51AFFC3E4
      BAFFC2B7ADE1432C138D351D037F351D037F351D037F351D037F351D037F351D
      037F2E1903770000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037FBEB4A8DF59B541FF73C05FFFEAEDE5FA6C5740AD351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F100901470000000000000008351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F715C46B0E6F3E3FF41AA
      26FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF9DD3
      8FFFC7BEB4E43D250B87351D037F351D037F351D037F351D037F351D037F351D
      037F2E19037700000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F3D250B87C7BEB4E4D8EED3FF68BB52FF67BB
      51FF67BB51FF67BB51FF67BB51FF67BB51FF67BB51FF67BB51FF67BB51FF67BB
      51FF67BB51FF67BB51FF67BB51FF67BB51FF67BB51FF67BB51FF67BB51FF67BB
      51FF67BB51FF67BB51FF67BB51FF67BB51FF67BB51FF67BB51FF67BB51FF67BB
      51FF67BB51FF67BB51FF67BB51FF67BB51FF67BB51FF67BB51FF67BB51FF4DAF
      33FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF249D
      04FF8ACA78FFE7E6E0F6644E36A7351D037F351D037F351D037F351D037F351D
      037F2E1903770000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037FBEB4A8DF59B541FF229C02FF49AD2EFFDEF0DAFF998A79CA38200783351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F100901470000000000000008351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F6C5740ADE4F1E0FE41AA26FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF239C
      03FFA5D698FFC5BCB2E33A220984351D037F351D037F351D037F351D037F351D
      037F2E19037700000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F3D250B87C7BEB4E4A5D698FF239C
      03FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF52B239FFE2F2DEFF988777C939210883351D037F351D037F351D
      037F2E1903770000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037FBEB4A8DF59B541FF229C02FF229C02FF2DA10FFFB7DFACFFC8BFB5E4452E
      158F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F100901470000000000000008351D037F351D037F351D
      037F351D037F351D037F351D037F6C5740ADEAF4E7FE47AD2CFF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF239C03FFA5D698FFBDB2A6DE3A220984351D037F351D037F351D037F351D
      037F2E19037700000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F3C240B86BDB2A6DEA7D8
      9BFF259D05FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF2FA211FFB5DEAAFFCFC7BFE84B331A93351D037F351D
      037F2E1903770000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037FBEB4A8DF59B541FF229C02FF229C02FF229C02FF239C03FF84C871FFE7E6
      E0F6604931A4351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F100901470000000000000008351D037F351D037F351D
      037F351D037F351D037F634D35A6E8F1E4FD49AD2EFF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF239C03FFB1DCA6FFBDB2A6DE3A220984351D037F351D037F351D
      037F2E19037700000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F3A220984BDB2
      A6DEB1DCA6FF259D05FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF5CB644FFF3F8F1FE84715DBD351D037F351D
      037F2E1903770000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037FBEB4A8DF59B541FF229C02FF229C02FF229C02FF229C02FF229C02FF55B3
      3CFFE6F2E2FE897865C0361E0581351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F100901470000000000000008351D037F351D037F351D
      037F351D037F634D35A6ECF2E8FC49AD2EFF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF259D05FFB1DCA6FFB3A79BD938200782351D037F351D
      037F2E19037700000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F3A22
      0984B9AEA2DCB1DCA6FF259D05FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF259E06FF96D087FFE1DED8F25C452DA1351D037F351D037F351D
      037F2E1903770000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037FBEB4A8DF59B541FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF35A518FFC6E5BDFFBAAFA3DD40280F8A351D037F351D037F351D037F351D
      037F351D037F351D037F100901470000000000000008351D037F351D037F351D
      037F5E4731A3ECF2E8FC51B138FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF259D05FFB7DFACFFB2A598D838200782351D
      037F2E19037700000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F38200782B2A598D8B9E0AFFF279E08FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF3DA821FFCDE9C6FFB5A99DDA40280F8A351D037F351D037F351D037F351D
      037F2E1903770000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037FBEB4A8DF59B541FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF259D05FF95D086FFE0DCD6F1553E269C351D037F351D037F351D
      037F351D037F351D037F100901470000000000000008351D037F351D037F5B44
      2DA0F3F2EFFA89CA77FF59B541FF59B541FF59B541FF59B541FF59B541FF52B2
      39FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF3AA71EFF59B5
      41FF59B541FF59B541FF59B541FF59B541FF5EB747FFE0F1DCFFAFA295D7361E
      05812E19037700000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F38200782B2A598D8BCE1B2FF279E08FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF49AD2EFFDBEFD6FFE4F3E0FFE4F3
      E0FFE4F3E0FFE4F3E0FFE4F3E0FFE4F3E0FFE4F3E0FFE4F3E0FFE4F3E0FFE4F3
      E0FFE4F3E0FFE4F3E0FFE4F3E0FFE4F3E0FFE4F3E0FFE4F3E0FFE4F3E0FF9CD2
      8DFF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF6ABD
      55FFEAF1E6FC7E6A55B9361E0480351D037F351D037F351D037F351D037F351D
      037F2E1903770000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037FBEB4A8DF59B541FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF63B94CFFE9F1E5FC7A6752B7351D037F351D
      037F351D037F351D037F100901470000000000000008351D037F432C138DB5A9
      9DDABEB4A8DFBEB4A8DFBEB4A8DFBEB4A8DFBEB4A8DFBEB4A8DFC6BCB3E3E4F3
      E0FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF83C770FFE1DD
      D7F1BEB4A8DFBEB4A8DFBEB4A8DFBEB4A8DFBEB4A8DFBEB4A8DFBEB4A8DF745F
      49B22E19037700000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F38200782A7998AD2BEE2B4FF2BA00CFF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF5BB643FFEFF6ECFE725E
      47B1462E158F462E158F1E160D5E0404042005050527462E158F462E158F462E
      158F462E158F462E158F462E158F462E158F462E158F462E158F7F6B56B9ADDA
      A1FF229C02FF229C02FF229C02FF229C02FF229C02FF2AA00BFFA6D799FFD9D4
      CCED523B2299351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2E1903770000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037FBEB4A8DF59B541FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF3EA923FFD2EBCCFFAA9D8FD43C24
      0A86351D037F351D037F100901470000000000000008351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F462E158FE4F3
      E0FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF83C770FF9484
      73C7351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2E19037700000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F361E0581A79889D2C6E6BEFF2BA00CFF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF51B138FFECF2
      E8FC634D35A6351D037F100901470000000000000008351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F705B45AFADDA
      A1FF229C02FF229C02FF229C02FF229C02FF47AD2CFFD9EED4FFA69889D23C24
      0A86351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2E1903770000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037FBEB4A8DF59B541FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF289F09FFA7D79AFFD5CE
      C7EB4D351C95351D037F100901470000000000000008351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F462E158FE4F3
      E0FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF83C770FF9484
      73C7351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2E19037700000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F361E0581A29383CFC6E6BEFF2BA0
      0CFF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF51B1
      38FFECF2E8FC634D35A6100901470000000000000008351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F705B45AFADDA
      A1FF229C02FF229C02FF229C02FF7AC367FFEAECE5F9705C46B0351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2E1903770000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037FBEB4A8DF59B541FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF73C0
      5FFFEAEDE5FA6C5740AD100901470000000000000008351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F462E158FE4F3
      E0FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF83C770FF9484
      73C7351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2E19037700000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F361E04809A8B7ACBCEE9
      C7FF2FA211FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF4BAF31FFE7EFE2FC352F29780000000000000008351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F705B45AFADDA
      A1FF229C02FF30A212FFB6DEABFFCDC5BDE74B331A93351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2E1903770000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037FBEB4A8DF59B541FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF49AD2EFFDEF0DAFF6B6763A70000000700000008351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F462E158FE4F3
      E0FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF83C770FF9484
      73C7351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2E19037700000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F361E04809A8B
      7ACBD0EAC9FF2FA211FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF49AD2EFFE7F1E4FC2020205B00000008351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F705B45AFADDA
      A1FF53B23AFFE3F2DFFF978776C938200783351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2E1903770000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037FBEB4A8DF59B541FF229C02FF229C02FF229C02FF229C02FF229C02FF2EA1
      10FF85C872FF239C03FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF2DA10FFFB7DFACFF9E9E9EC905050427351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F462E158FE4F3
      E0FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF83C770FF9484
      73C7351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2E19037700000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F361E
      04808F7F6CC4D1EACAFF34A417FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF49AD2EFFE2EFDFFC26252364351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F705B45AFE6F4
      E3FFE8E6E0F6644E36A7351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2E1903770000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000503002A351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037FBEB4A8DF59B541FF229C02FF229C02FF229C02FF229C02FF229C02FF30A2
      12FFFFFFFFFFB8DFADFF2EA110FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF239C03FF84C871FFDBDDD9EF604931A4351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F462E158FE4F3
      E0FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF83C770FF9484
      73C7351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2414026A00000000000000000000000000000000000000000503002A351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F8E7C6AC3D8EED3FF34A417FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF41AA26FFE6F3E3FF76634CB4351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F705B45AFC0B6
      ABE0432C138D351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2414026A0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000031E10
      0260351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037FBEB4A8DF59B541FF229C02FF229C02FF229C02FF229C02FF229C02FF30A2
      12FFF2EFEDF9998978CADFF1DBFF49AD2EFF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF55B33CFFE6F2E2FE897865C0361E
      0581351D037F351D037F351D037F351D037F351D037F351D037F462E158FE4F3
      E0FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF83C770FF9484
      73C7351D037F351D037F351D037F351D037F351D037F351D037F351D037F311B
      037B050200280000000000000000000000000000000000000000000000031E10
      0260351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F8A7865C1D8EED3FF34A417FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF41AA26FFE6F3E3FF76634CB4351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F422B128C361E
      0581351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F311B
      037B050200280000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000D0000001000000010000000100000001000000010000000100000
      0010949392C359B541FF229C02FF229C02FF229C02FF229C02FF229C02FF30A2
      12FFE1E1E1F0000000102020205CDFE3DEF374C160FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF35A518FFC6E5BDFF9895
      91C60404032500000010000000100000001000000010000000100707052EE4F3
      E0FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF83C770FF5756
      5496000000100000001000000010000000100000001000000010000000100000
      0006000000000000000000000000000000000000000000000000000000000000
      00000000000D0000001000000010000000100000001000000010000000100000
      0010000000100000001000000010000000100000001000000010000000100000
      001000000010000000100000001039383879DFF1DBFF3AA71EFF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF3CA820FFE0F0DBFF413D
      3A82000000100000001000000010000000100000001000000010000000100000
      0010000000100000001000000010000000100000001000000010000000100000
      0010000000100000001000000010000000100000001000000010000000100000
      0006000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008F8F8FBF59B541FF229C02FF229C02FF229C02FF229C02FF229C02FF30A2
      12FFE0E0E0EF00000000000000000707072BB3B3B3D6A7D89BFF299F0AFF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF259D05FF95D0
      86FFC9CAC9E30C0C0C390000000000000000000000000000000004040420E4F3
      E0FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF83C770FF5050
      508F000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000038383878E0F1DCFF3AA71EFF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF3AA71EFFE0F1
      DCFF383838780000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008F8F8FBF59B541FF229C02FF229C02FF229C02FF229C02FF229C02FF30A2
      12FFE0E0E0EF0000000000000000000000000000000C6E6E6EA8D3EBCDFF3EA9
      23FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF63B94CFFE4ECE1F93030306F00000000000000000000000004040420E4F3
      E0FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF83C770FF5050
      508F000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000002D2D2D6CDEEFDAFE41AA
      26FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF3AA7
      1EFFDBEFD6FF3A3A3A7A00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000002170C
      0154351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037FBEB4A8DF59B541FF229C02FF229C02FF229C02FF229C02FF229C02FF30A2
      12FFEEEBE8F7351D037F351D037F351D037F351D037F351D037F7A6651B6EAF1
      E6FC63B94DFF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF3EA923FFD2EBCCFFAA9D8FD43C240A86351D037F462E158FE4F3
      E0FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF83C770FF9484
      73C7351D037F351D037F351D037F351D037F351D037F351D037F351D037F2D18
      037503020022000000000000000000000000000000000000000000000002170C
      0154351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F76634CB4E6F3
      E3FF41AA26FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF34A417FFD8EED3FF8E7C6AC3351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F2D18
      0375030200220000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000004020027351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037FBEB4A8DF59B541FF229C02FF229C02FF229C02FF229C02FF229C02FF30A2
      12FFEEEBE8F7351D037F351D037F351D037F351D037F351D037F351D037F543D
      259BE0DBD5F196D087FF259D05FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF289F09FFA7D79AFFD5CEC7EB4D351C95462E158FE4F3
      E0FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF83C770FF9484
      73C7351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F22120266000000000000000000000000000000000000000004020027351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F745F
      49B2E4F1E0FE41AA26FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF34A417FFD8EED3FF8E7C6AC3351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F221202660000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037FBEB4A8DF59B541FF229C02FF229C02FF229C02FF229C02FF229C02FF30A2
      12FFEEEBE8F7351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F3F270E89B9AEA2DCC6E6BEFF36A519FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF73C05FFFEAEDE5FA83715CBCE4F3
      E0FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF83C770FF9484
      73C7351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2E19037700000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F6C5740ADEAF4E7FE49AD2EFF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF31A313FFD0EAC9FF968675C8361E0480351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2E1903770000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037FBEB4A8DF59B541FF229C02FF229C02FF229C02FF229C02FF229C02FF30A2
      12FFEEEBE8F7351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F361E058174685BB0E5F1E1FD56B33DFF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF49AD2EFFDEF0DAFFE4F3
      E0FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF83C770FF9484
      73C7351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2E19037700000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F6C5740ADEAF4E7FE49AD2EFF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF2FA211FFD0EAC9FF9A8B7ACB361E0480351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2E1903770000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037FBEB4A8DF59B541FF229C02FF229C02FF229C02FF229C02FF229C02FF30A2
      12FFEEEBE8F7351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F1009014714141448D6D8D5EC85C872FF239C03FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF2DA10FFF9CD2
      8DFF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF83C770FF9484
      73C7351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2E19037700000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F4A3C2E8FE1EBDEF950B136FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF2FA211FFCBE7C3FF9B8C7BCB361E
      0581351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2E1903770000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037FBEB4A8DF59B541FF229C02FF229C02FF229C02FF229C02FF229C02FF30A2
      12FFEEEBE8F7351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F100901470000000004040423C8BFB5E4B8DFADFF2EA1
      10FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF83C770FF9484
      73C7351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2E19037700000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F100901471717174EE6EDE4F951B138FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF2BA00CFFC6E6BEFFA798
      89D2361E0581351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2E1903770000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037FBEB4A8DF59B541FF229C02FF229C02FF229C02FF229C02FF229C02FF30A2
      12FFEEEBE8F7351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F10090147000000000000000838200782998978CADFF1
      DBFF4AAE2FFF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF83C770FF9484
      73C7351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2E19037700000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F10090147000000001717174EE7EDE2FA52B239FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF2BA00CFFC6E6
      BEFFA79889D2361E0581351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2E1903770000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037FBEB4A8DF59B541FF229C02FF229C02FF229C02FF229C02FF229C02FF30A2
      12FFEEEBE8F7351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F100901470000000000000008351D037F351D037F6B56
      3FACEAECE5F975C161FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF83C770FF9484
      73C7351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2E19037700000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F1009014700000000000000085B442DA0ECEFE7FA5BB6
      43FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF289F
      09FFBCE1B2FFAEA193D638200782351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2E1903770000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037FBEB4A8DF59B541FF229C02FF229C02FF229C02FF229C02FF229C02FF30A2
      12FFEEEBE8F7351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F100901470000000000000008351D037F351D037F351D
      037F4D351C95D4CEC7EBA8D89CFF299F0AFF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF83C770FF9484
      73C7351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2E19037700000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F4C341C947B6852B77B6852B77B6852B77B68
      52B77B6852B77B6852B77B6852B77B6852B77B6852B77B6852B77B6852B77B68
      52B77B6852B77B6852B77B6852B77B6852B77B6852B77B6852B77B6852B77B68
      52B77B6852B77B6852B7564D439831313170343332747B6852B7AFA295D7F6FB
      F5FF5BB643FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF279E08FFBCE1B2FFB2A598D838200782351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2E1903770000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037FBEB4A8DF59B541FF229C02FF229C02FF229C02FF229C02FF229C02FF30A2
      12FFEEEBE8F7351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F100901470000000000000008351D037F351D037F351D
      037F351D037F3B230A85AA9C8ED4D4ECCEFF3FA924FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF83C770FF9484
      73C7351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2E19037700000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F705B45AFDBEFD6FF9FD491FF9FD491FF9FD4
      91FF9FD491FF9FD491FF9FD491FF9FD491FF9FD491FF9FD491FF9FD491FF9FD4
      91FF9FD491FF9FD491FF9FD491FF9FD491FF9FD491FF9FD491FF9FD491FF9FD4
      91FF9FD491FF9FD491FF9FD491FF9FD491FF9FD491FF9FD491FF9FD491FF9FD4
      91FF96D087FF2CA10EFF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF279E08FFB6DEABFFB2A598D83A220984351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2E1903770000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037FBEB4A8DF59B541FF229C02FF229C02FF229C02FF229C02FF229C02FF30A2
      12FFEEEBE8F7351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F100901470000000000000008351D037F351D037F351D
      037F351D037F351D037F351D037F7A6651B6EAF1E6FC65BA4FFF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF83C770FF9484
      73C7351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2E19037700000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F705B45AFADDAA1FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF259D05FFB1DCA6FFBDB2A6DE3A220984351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2E1903770000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037FBEB4A8DF59B541FF229C02FF229C02FF229C02FF229C02FF229C02FF30A2
      12FFEEEBE8F7351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F100901470000000000000008351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F543D259BE0DBD5F197D088FF259D
      05FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF83C770FF9484
      73C7351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2E19037700000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F705B45AFADDAA1FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF259D05FFB1DCA6FFBDB2A6DE3A220984351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2E1903770000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037FBEB4A8DF59B541FF229C02FF229C02FF229C02FF229C02FF229C02FF30A2
      12FFEEEBE8F7351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F100901470000000000000008351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F3F270E89B9AEA2DCC7E6
      BFFF37A51AFF229C02FF229C02FF229C02FF229C02FF229C02FF83C770FF9484
      73C7351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2E19037700000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F705B45AFADDAA1FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF249D04FFA5D698FFC3BAAFE23D25
      0B87351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2E1903770000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037FBEB4A8DF59B541FF229C02FF229C02FF229C02FF229C02FF229C02FF30A2
      12FFEEEBE8F7351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F100901470000000000000008351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F361E05818977
      64C0E7F3E3FE56B43EFF229C02FF229C02FF229C02FF229C02FF83C770FF9484
      73C7351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2E19037700000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F705B45AFADDAA1FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF239C03FFA5D698FFC7BE
      B4E43D250B87351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2E1903770000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037FBEB4A8DF59B541FF229C02FF229C02FF229C02FF229C02FF229C02FF30A2
      12FFEEEBE8F7351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F100901470000000000000008351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F5F4831A3E8E6E0F686C973FF239C03FF229C02FF229C02FF83C770FF9484
      73C7351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2E19037700000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F705B45AFADDAA1FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF239C03FF9FD4
      91FFC7BEB4E43F270E89351D037F351D037F351D037F351D037F351D037F351D
      037F2E1903770000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037FBEB4A8DF59B541FF229C02FF229C02FF229C02FF229C02FF229C02FF30A2
      12FFEEEBE8F7351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F100901470000000000000008351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F442D148EC8BFB5E4B9DFAEFF2FA211FF229C02FF83C770FF9484
      73C7351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2E19037700000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F705B45AFE0F1DCFFADDAA1FFADDAA1FFADDA
      A1FFADDAA1FFADDAA1FFADDAA1FFADDAA1FFADDAA1FFADDAA1FFADDAA1FFADDA
      A1FFADDAA1FFADDAA1FFADDAA1FFADDAA1FFADDAA1FFADDAA1FFADDAA1FFADDA
      A1FFADDAA1FFADDAA1FFADDAA1FFADDAA1FFADDAA1FFADDAA1FFADDAA1FFADDA
      A1FFADDAA1FFADDAA1FFADDAA1FFADDAA1FFADDAA1FFADDAA1FFADDAA1FFADDA
      A1FFADDAA1FFADDAA1FFADDAA1FFADDAA1FFADDAA1FFADDAA1FFADDAA1FFADDA
      A1FFF2F9F0FFD1CAC1E940280F8A351D037F351D037F351D037F351D037F351D
      037F2E1903770000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037FBEB4A8DF59B541FF229C02FF229C02FF229C02FF229C02FF229C02FF30A2
      12FFEEEBE8F7351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F100901470000000000000008351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F38200782998978CADFF1DBFF4AAE2FFF83C770FF9484
      73C7351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2E19037700000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F49311891705B45AF705B45AF705B45AF705B
      45AF705B45AF705B45AF705B45AF705B45AF705B45AF705B45AF705B45AF705B
      45AF705B45AF705B45AF705B45AF705B45AF705B45AF705B45AF705B45AF705B
      45AF705B45AF705B45AF493F368C2424246027262565705B45AF705B45AF705B
      45AF705B45AF705B45AF705B45AF705B45AF705B45AF705B45AF705B45AF705B
      45AF705B45AF705B45AF705B45AF705B45AF705B45AF705B45AF705B45AF705B
      45AF705B45AF705B45AF553E269C351D037F351D037F351D037F351D037F351D
      037F2E1903770000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037FBEB4A8DF59B541FF229C02FF229C02FF229C02FF229C02FF229C02FF30A2
      12FFEEEBE8F7351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F100901470000000000000008351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F6B563FACEAECE5F9C6E5BEFF9484
      73C7351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2E19037700000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F100901470000000000000008351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2E1903770000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037FBEB4A8DFE0F1DCFFD6ECD0FFD6ECD0FFD6ECD0FFD6ECD0FFD6ECD0FFD8EE
      D3FFEEEBE8F7351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F100901470000000000000008351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F4D351C95D4CEC7EB9484
      73C7351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2E19037700000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F100901470000000000000008351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2E1903770000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F4931189150381F9750381F9750381F9750381F9750381F9750381F975038
      1F974E371E96351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F100901470000000000000008351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F3B230A855E47
      31A3351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2E19037700000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F100901470000000000000008351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2E1903770000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F100901470000000000000008351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2E19037700000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F100901470000000000000008351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2E1903770000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F100901470000000000000008351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2E19037700000000000000000000000000000000000000000A050038351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F100901470000000000000008351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F2E1903770000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000004020024351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F0905003500000000000000002B170373351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F20110263000000000000000000000000000000000000000004020024351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F0905003500000000000000002B170373351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F201102630000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000001130A
      014C311B037A351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F321B037C1A0E0259000000050000000000000000050200282A170372351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F2715
      026D0201001D000000000000000000000000000000000000000000000001130A
      014C311B037A351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F321B037C1A0E0259000000050000000000000000050200282A170372351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F351D
      037F351D037F351D037F351D037F351D037F351D037F351D037F351D037F2715
      026D0201001D0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000000010000400000000100010000000000000800000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000}
    DesignInfo = 524562
    ImageInfo = <
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C73766720783D223070782220793D223070782220766965
          77426F783D22302030203332203332222076657273696F6E3D22312E31222078
          6D6C6E733D22687474703A2F2F7777772E77332E6F72672F323030302F737667
          2220786D6C6E733A786C696E6B3D22687474703A2F2F7777772E77332E6F7267
          2F313939392F786C696E6B2220656E61626C652D6261636B67726F756E643D22
          6E657720302030203332203332223E0D0A093C7374796C6520747970653D2274
          6578742F6373732220786D6C3A73706163653D227072657365727665223E2E47
          7265656E7B66696C6C3A233033394332333B7374726F6B652D77696474683A30
          2E353B7374726F6B653A57686974657D262331333B262331303B2623393B2E42
          6C75657B66696C6C3A233131373744373B7D3C2F7374796C653E0D0A093C7061
          7468207374796C653D226F7061636974793A302E352220636C6173733D22426C
          75652220643D224D2032392E343533203134204C2031372E3435332031342043
          2031362E3835332031342031362E3435332031332E35322031362E3435332031
          322E38204C2031362E34353320332E3220432031362E34353320322E34382031
          362E38353320322031372E3435332032204C2032392E34353320322043203330
          2E30353320322033302E34353320322E34382033302E34353320332E32204C20
          33302E3435332031322E3820432033302E3435332031332E35322033302E3035
          332031342032392E343533203134205A222F3E0D0A093C70617468207374796C
          653D226F7061636974793A302E352220636C6173733D22426C75652220643D22
          4D2031342E323637203134204C20322E323637203134204320312E3636372031
          3420312E3236372031332E353220312E3236372031322E38204C20312E323637
          20332E32204320312E32363720322E343820312E363637203220322E32363720
          32204C2031342E323637203220432031342E38363720322031352E3236372032
          2E34382031352E32363720332E32204C2031352E3236372031322E3820432031
          352E3236372031332E35322031342E3836372031342031342E32363720313420
          5A222F3E0D0A093C70617468207374796C653D226F7061636974793A302E3522
          20636C6173733D22426C75652220643D224D2032392E3435332032372E343232
          204C2031372E3435332032372E34323220432031362E3835332032372E343232
          2031362E3435332032362E3934322031362E3435332032362E323232204C2031
          362E3435332031362E36323220432031362E3435332031352E3930322031362E
          3835332031352E3432322031372E3435332031352E343232204C2032392E3435
          332031352E34323220432033302E3035332031352E3432322033302E34353320
          31352E3930322033302E3435332031362E363232204C2033302E343533203236
          2E32323220432033302E3435332032362E3934322033302E3035332032372E34
          32322032392E3435332032372E343232205A222F3E0D0A093C70617468207374
          796C653D226F7061636974793A302E352220636C6173733D22426C7565222064
          3D224D2031342E3236372032372E343232204C20322E3236372032372E343232
          204320312E3636372032372E34323220312E3236372032362E39343220312E32
          36372032362E323232204C20312E3236372031362E363232204320312E323637
          2031352E39303220312E3636372031352E34323220322E3236372031352E3432
          32204C2031342E3236372031352E34323220432031342E3836372031352E3432
          322031352E3236372031352E3930322031352E3236372031362E363232204C20
          31352E3236372032362E32323220432031352E3236372032362E393432203134
          2E3836372032372E3432322031342E3236372032372E343232205A222F3E0D0A
          093C706F6C79676F6E20636C6173733D22477265656E2220706F696E74733D22
          32332E3539392032352E32352031372E3835372031392E3336322032312E3638
          342031392E3336322032312E3638342031322E30303120362E3337322032332E
          37373820362E3337322031392E33363220362E33373220342E36342031302E32
          303120342E36342031302E3230312031362E3431372032352E35313320342E36
          342032352E3531332031392E3336322032392E3334312031392E333632222F3E
          0D0A3C2F7376673E0D0A}
        FileName = 'SVG Images\Print\TopDown.svg'
        Keywords = 'Print;TopDown'
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C73766720783D223070782220793D223070782220766965
          77426F783D22302030203332203332222076657273696F6E3D22312E31222078
          6D6C6E733D22687474703A2F2F7777772E77332E6F72672F323030302F737667
          2220786D6C6E733A786C696E6B3D22687474703A2F2F7777772E77332E6F7267
          2F313939392F786C696E6B2220656E61626C652D6261636B67726F756E643D22
          6E657720302030203332203332223E0D0A093C7374796C6520747970653D2274
          6578742F6373732220786D6C3A73706163653D227072657365727665223E2E47
          7265656E7B66696C6C3A233033394332333B207374726F6B652D77696474683A
          302E353B207374726F6B653A2057686974657D262331333B262331303B262339
          3B2E426C75657B66696C6C3A233131373744373B7D3C2F7374796C653E0D0A09
          3C70617468207374796C653D226F7061636974793A302E352220636C6173733D
          22426C75652220643D224D2032392E343533203134204C2031372E3435332031
          3420432031362E3835332031342031362E3435332031332E35322031362E3435
          332031322E38204C2031362E34353320332E3220432031362E34353320322E34
          382031362E38353320322031372E3435332032204C2032392E34353320322043
          2033302E30353320322033302E34353320322E34382033302E34353320332E32
          204C2033302E3435332031322E3820432033302E3435332031332E3532203330
          2E3035332031342032392E343533203134205A222F3E0D0A093C706174682073
          74796C653D226F7061636974793A302E352220636C6173733D22426C75652220
          643D224D2031342E323637203134204C20322E323637203134204320312E3636
          3720313420312E3236372031332E353220312E3236372031322E38204C20312E
          32363720332E32204320312E32363720322E343820312E363637203220322E32
          36372032204C2031342E323637203220432031342E38363720322031352E3236
          3720322E34382031352E32363720332E32204C2031352E3236372031322E3820
          432031352E3236372031332E35322031342E3836372031342031342E32363720
          3134205A222F3E0D0A093C70617468207374796C653D226F7061636974793A30
          2E352220636C6173733D22426C75652220643D224D2032392E3435332032372E
          343232204C2031372E3435332032372E34323220432031362E3835332032372E
          3432322031362E3435332032362E3934322031362E3435332032362E32323220
          4C2031362E3435332031362E36323220432031362E3435332031352E39303220
          31362E3835332031352E3432322031372E3435332031352E343232204C203239
          2E3435332031352E34323220432033302E3035332031352E3432322033302E34
          35332031352E3930322033302E3435332031362E363232204C2033302E343533
          2032362E32323220432033302E3435332032362E3934322033302E3035332032
          372E3432322032392E3435332032372E343232205A222F3E0D0A093C70617468
          207374796C653D226F7061636974793A302E352220636C6173733D22426C7565
          2220643D224D2031342E3236372032372E343232204C20322E3236372032372E
          343232204320312E3636372032372E34323220312E3236372032362E39343220
          312E3236372032362E323232204C20312E3236372031362E363232204320312E
          3236372031352E39303220312E3636372031352E34323220322E323637203135
          2E343232204C2031342E3236372031352E34323220432031342E383637203135
          2E3432322031352E3236372031352E3930322031352E3236372031362E363232
          204C2031352E3236372032362E32323220432031352E3236372032362E393432
          2031342E3836372032372E3432322031342E3236372032372E343232205A222F
          3E0D0A093C706F6C79676F6E20706F696E74733D2232382E3532372032312E33
          38312032312E3533342031362E3236342032312E3533342031392E3637362031
          322E3739322031392E3637362032362E37373920362E3033322032312E353334
          20362E30333220342E303520362E30333220342E303520392E3434332031382E
          30333720392E34343320342E30352032332E3038362032312E3533342032332E
          3038362032312E3533342032362E3439372220636C6173733D22477265656E22
          2F3E0D0A3C2F7376673E0D0A}
        FileName = 'SVG Images\Print\LeftToRight.svg'
        Keywords = 'Print;LeftToRight'
      end>
  end
  object ilLarge: TcxImageList
    SourceDPI = 96
    Height = 32
    Width = 32
    FormatVersion = 1
    Left = 244
    Top = 8
    Bitmap = {
      494C010102000800100020002000FFFFFFFF2110FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000800000002000000001002000000000000040
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000484848CC717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF4E4E4ED4000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000717171FF717171FF000000000000
      0000000000000000000000000000000000000000000000000000484848CC7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF4E4E
      4ED4000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000717171FF717171FF000000000000
      0000000000000000000000000000000000000000000000000000717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000717171FF717171FF000000000000
      0000000000000000000000000000000000000000000000000000717171FF7171
      71FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000717171FF7171
      71FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000717171FF717171FF000000000000
      0000000000000000000000000000000000000000000000000000717171FF7171
      71FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000717171FF7171
      71FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000717171FF717171FF000000000000
      0000000000000000000000000000000000000000000000000000717171FF7171
      71FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000717171FF7171
      71FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000717171FF717171FF000000000000
      0000000000000000000000000000000000000000000000000000717171FF7171
      71FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000717171FF7171
      71FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF00000000000000000000000000000000D77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FF00000000000000000000000000000000717171FF717171FF000000000000
      0000000000000000000000000000000000000000000000000000717171FF7171
      71FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000717171FF7171
      71FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF00000000000000000000000000000000D77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FF00000000000000000000000000000000717171FF717171FF000000000000
      0000000000000000000000000000000000000000000000000000717171FF7171
      71FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000717171FF7171
      71FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000717171FF717171FF000000000000
      0000000000000000000000000000000000000000000000000000717171FF7171
      71FF00000000000000000000000000000000D77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FF00000000000000000000000000000000717171FF7171
      71FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000717171FF717171FF000000000000
      0000000000000000000000000000000000000000000000000000717171FF7171
      71FF00000000000000000000000000000000D77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FF00000000000000000000000000000000717171FF7171
      71FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF00000000000000000000000000000000D77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FF00000000000000000000000000000000717171FF717171FF000000000000
      0000000000000000000000000000000000000000000000000000717171FF7171
      71FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000717171FF7171
      71FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF00000000000000000000000000000000D77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FF00000000000000000000000000000000717171FF717171FF000000000000
      0000000000000000000000000000000000000000000000000000717171FF7171
      71FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000717171FF7171
      71FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000717171FF717171FF000000000000
      0000000000000000000000000000000000000000000000000000717171FF7171
      71FF00000000000000000000000000000000D77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FF00000000000000000000000000000000717171FF7171
      71FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000717171FF717171FF000000000000
      0000000000000000000000000000000000000000000000000000717171FF7171
      71FF00000000000000000000000000000000D77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FF00000000000000000000000000000000717171FF7171
      71FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF00000000000000000000000000000000D77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FF00000000000000000000000000000000717171FF717171FF000000000000
      0000000000000000000000000000000000000000000000000000717171FF7171
      71FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000717171FF7171
      71FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF00000000000000000000000000000000D77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FF00000000000000000000000000000000717171FF717171FF000000000000
      0000000000000000000000000000000000000000000000000000717171FF7171
      71FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000717171FF7171
      71FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000717171FF717171FF000000000000
      0000000000000000000000000000000000000000000000000000717171FF7171
      71FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000717171FF7171
      71FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000717171FF717171FF000000000000
      0000000000000000000000000000000000000000000000000000717171FF7171
      71FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000717171FF7171
      71FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000717171FF717171FF000000000000
      0000000000000000000000000000000000000000000000000000717171FF7171
      71FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000717171FF7171
      71FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000717171FF717171FF000000000000
      0000000000000000000000000000000000000000000000000000717171FF7171
      71FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000717171FF7171
      71FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000717171FF717171FF000000000000
      0000000000000000000000000000000000000000000000000000717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000717171FF717171FF000000000000
      0000000000000000000000000000000000000000000000000000434343C47171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF4848
      48CC000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000434343C4717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF484848CC000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000080000000200000000100010000000000000200000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000}
    DesignInfo = 524532
    ImageInfo = <
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D2250
          6F7274726169745F315F2220786D6C6E733D22687474703A2F2F7777772E7733
          2E6F72672F323030302F7376672220786D6C6E733A786C696E6B3D2268747470
          3A2F2F7777772E77332E6F72672F313939392F786C696E6B2220783D22307078
          2220793D22307078222076696577426F783D2230203020333220333222207374
          796C653D22656E61626C652D6261636B67726F756E643A6E6577203020302033
          322033323B2220786D6C3A73706163653D227072657365727665223E26233133
          3B262331303B3C7374796C6520747970653D22746578742F6373732220786D6C
          3A73706163653D227072657365727665223E2E426C61636B7B66696C6C3A2337
          32373237323B7D262331333B262331303B2623393B2E426C75657B66696C6C3A
          233131373744373B7D3C2F7374796C653E0D0A3C706174682069643D22506F72
          74726169742220636C6173733D22426C75652220643D224D31302C3138683130
          76324831305631387A204D31302C3136683130762D324831305631367A204D31
          302C3132683130762D324831305631327A222F3E0D0A3C7061746820636C6173
          733D22426C61636B2220643D224D32352C32483543342E342C322C342C322E34
          2C342C3376323463302C302E362C302E342C312C312C3168323063302E362C30
          2C312D302E342C312D3156334332362C322E342C32352E362C322C32352C327A
          204D32342C3236483656346831385632367A222F3E0D0A3C2F7376673E0D0A}
        FileName = 'SVG Images\Pages\PageOrientationPortrait.svg'
        Keywords = 'Pages;PageOrientationPortrait'
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          616E6473636170652220786D6C6E733D22687474703A2F2F7777772E77332E6F
          72672F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F
          2F7777772E77332E6F72672F313939392F786C696E6B2220783D223070782220
          793D22307078222076696577426F783D2230203020333220333222207374796C
          653D22656E61626C652D6261636B67726F756E643A6E65772030203020333220
          33323B2220786D6C3A73706163653D227072657365727665223E262331333B26
          2331303B3C7374796C6520747970653D22746578742F6373732220786D6C3A73
          706163653D227072657365727665223E2E426C61636B7B66696C6C3A23373237
          3237323B7D262331333B262331303B2623393B2E426C75657B66696C6C3A2331
          31373744373B7D3C2F7374796C653E0D0A3C7061746820636C6173733D22426C
          75652220643D224D32322C31384838762D326831345631387A204D32322C3132
          483876326831345631327A222F3E0D0A3C7061746820636C6173733D22426C61
          636B2220643D224D32372C34483343322E342C342C322C342E342C322C357632
          3063302C302E362C302E342C312C312C3168323463302E362C302C312D302E34
          2C312D3156354332382C342E342C32372E362C342C32372C347A204D32362C32
          34483456366832325632347A222F3E0D0A3C2F7376673E0D0A}
        FileName = 'SVG Images\Pages\PageOrientationLandscape.svg'
        Keywords = 'Pages;PageOrientationLandscape'
      end>
  end
end
