object dxfmPageSetupDialog: TdxfmPageSetupDialog
  Left = 280
  Top = 218
  AutoSize = True
  BorderStyle = bsDialog
  Caption = 'Page Setup'
  ClientHeight = 600
  ClientWidth = 600
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object lcMain: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 600
    Height = 600
    TabOrder = 0
    AutoSize = True
    LayoutLookAndFeel = dxLayoutCxLookAndFeel1
    object pbxPageOrder: TPaintBox
      Left = 10000
      Top = 10000
      Width = 64
      Height = 64
      Color = 16448250
      ParentColor = False
      Visible = False
      OnDblClick = pbxPageOrderDblClick
      OnPaint = pbxPageOrderPaint
    end
    object btnHelp: TcxButton
      Left = 501
      Top = 575
      Width = 85
      Height = 23
      Caption = '&Help'
      TabOrder = 49
      OnClick = btnHelpClick
    end
    object btnOK: TcxButton
      Left = 319
      Top = 575
      Width = 85
      Height = 23
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 47
    end
    object btnPrint: TcxButton
      Left = 112
      Top = 575
      Width = 96
      Height = 23
      Caption = 'Print...'
      TabOrder = 46
      OnClick = btnPrintClick
    end
    object btnPrintPreview: TcxButton
      Left = 10
      Top = 575
      Width = 96
      Height = 23
      Caption = 'Print Preview...'
      TabOrder = 45
      OnClick = btnPrintPreviewClick
    end
    object edStyleName: TcxTextEdit
      Left = 76
      Top = 10
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 0
      OnExit = edStyleNameExit
      Width = 408
    end
    object btnOptions: TcxButton
      Left = 490
      Top = 10
      Width = 96
      Height = 23
      Caption = '&Options ...'
      TabOrder = 1
      OnClick = btnOptionsClick
    end
    object btnCancel: TcxButton
      Left = 410
      Top = 575
      Width = 85
      Height = 23
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 48
    end
    object rbtnAdjustTo: TcxRadioButton
      Left = 22
      Top = 79
      Caption = '&Adjust To:'
      Color = 16448250
      ParentColor = False
      TabOrder = 40
      OnClick = ScalingClick
      AutoSize = True
      GroupIndex = 3
      ParentBackground = False
      Transparent = True
    end
    object rbtnFitTo: TcxRadioButton
      Tag = 1
      Left = 22
      Top = 150
      Caption = '&Fit To Page Width'
      Color = 16448250
      ParentColor = False
      TabOrder = 42
      OnClick = ScalingClick
      AutoSize = True
      GroupIndex = 3
      ParentBackground = False
      Transparent = True
    end
    object seAdjustTo: TcxSpinEdit
      Left = 42
      Top = 107
      Properties.MaxValue = 500.000000000000000000
      Properties.MinValue = 10.000000000000000000
      Properties.OnChange = ScaleChanged
      Style.HotTrack = False
      TabOrder = 41
      Value = 10
      OnExit = AdjustToExit
      Width = 64
    end
    object lbxPaperType: TcxListBox
      Left = 10000
      Top = 10000
      Width = 214
      Height = 327
      Anchors = [akLeft, akTop, akBottom]
      ItemHeight = 20
      ListStyle = lbOwnerDrawFixed
      Style.TransparentBorder = False
      TabOrder = 2
      Visible = False
      OnClick = lbxPaperTypeClick
      OnDrawItem = lbxPaperTypeDrawItem
    end
    object sePaperWidth: TcxSpinEdit
      Left = 10000
      Top = 10000
      Anchors = [akLeft, akBottom]
      Properties.ImmediatePost = True
      Properties.Increment = 0.100000000000000000
      Properties.LargeIncrement = 1.000000000000000000
      Properties.ValueType = vtFloat
      Properties.OnChange = PaperWidthHeightChange
      Properties.OnEditValueChanged = PaperWidthHeightUpdateInfos
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 3
      Visible = False
      OnExit = PaperWidthHeightUpdateInfos
      Width = 142
    end
    object sePaperHeight: TcxSpinEdit
      Left = 10000
      Top = 10000
      Anchors = [akLeft, akBottom]
      Properties.ImmediatePost = True
      Properties.Increment = 0.100000000000000000
      Properties.LargeIncrement = 1.000000000000000000
      Properties.ValueType = vtFloat
      Properties.OnChange = PaperWidthHeightChange
      Properties.OnEditValueChanged = PaperWidthHeightUpdateInfos
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 4
      Visible = False
      OnExit = PaperWidthHeightUpdateInfos
      Width = 142
    end
    object cbxPaperSource: TcxComboBox
      Left = 10000
      Top = 10000
      Anchors = [akLeft, akBottom]
      AutoSize = False
      Properties.DropDownListStyle = lsFixedList
      Properties.OnChange = cbxPaperSourceChange
      Properties.OnDrawItem = cbxPaperSourcePropertiesDrawItem
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 5
      Visible = False
      Height = 22
      Width = 142
    end
    object chbxShading: TcxCheckBox
      Left = 10000
      Top = 10000
      Caption = 'Print using &gray shading'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 11
      Transparent = True
      Visible = False
      OnClick = chbxShadingClick
    end
    object rbtnDownThenOver: TcxRadioButton
      Tag = 1
      Left = 10000
      Top = 10000
      Caption = '&Down, then over'
      Checked = True
      Color = 16448250
      ParentColor = False
      TabOrder = 9
      TabStop = True
      Visible = False
      OnClick = PageOrderClick
      AutoSize = True
      GroupIndex = 2
      ParentBackground = False
      Transparent = True
    end
    object rbtnOverThenDown: TcxRadioButton
      Left = 10000
      Top = 10000
      Caption = 'O&ver, then down'
      Color = 16448250
      ParentColor = False
      TabOrder = 10
      Visible = False
      OnClick = PageOrderClick
      AutoSize = True
      GroupIndex = 2
      ParentBackground = False
      Transparent = True
    end
    object rBtnPortrait: TcxRadioButton
      Left = 10000
      Top = 10000
      Caption = 'P&ortrait'
      Checked = True
      Color = 16448250
      ParentColor = False
      TabOrder = 6
      TabStop = True
      Visible = False
      OnClick = OrientationClick
      OnDblClick = OrientationDblClick
      AutoSize = True
      GroupIndex = 1
      ParentBackground = False
      Transparent = True
    end
    object rBtnLandscape: TcxRadioButton
      Tag = 1
      Left = 10000
      Top = 10000
      Caption = '&Landscape'
      Color = 16448250
      ParentColor = False
      TabOrder = 7
      Visible = False
      OnClick = OrientationClick
      OnDblClick = OrientationDblClick
      AutoSize = True
      GroupIndex = 1
      ParentBackground = False
      Transparent = True
    end
    object rBtnAutoOrientation: TcxRadioButton
      Tag = 2
      Left = 10000
      Top = 10000
      Caption = '&Auto'
      Color = 16448250
      ParentColor = False
      TabOrder = 8
      Visible = False
      OnClick = OrientationClick
      OnDblClick = OrientationDblClick
      AutoSize = True
      GroupIndex = 1
      ParentBackground = False
      Transparent = True
    end
    object seMarginTop: TcxSpinEdit
      Tag = 1
      Left = 10000
      Top = 10000
      Properties.ImmediatePost = True
      Properties.Increment = 0.100000000000000000
      Properties.LargeIncrement = 1.000000000000000000
      Properties.ValueType = vtFloat
      Properties.OnChange = MarginChange
      Properties.OnEditValueChanged = MarginValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 12
      Visible = False
      OnExit = MarginExit
      Width = 136
    end
    object seMarginBottom: TcxSpinEdit
      Tag = 3
      Left = 10000
      Top = 10000
      Properties.ImmediatePost = True
      Properties.Increment = 0.100000000000000000
      Properties.LargeIncrement = 1.000000000000000000
      Properties.ValueType = vtFloat
      Properties.OnChange = MarginChange
      Properties.OnEditValueChanged = MarginValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 13
      Visible = False
      OnExit = MarginExit
      Width = 136
    end
    object seMarginLeft: TcxSpinEdit
      Left = 10000
      Top = 10000
      Properties.ImmediatePost = True
      Properties.Increment = 0.100000000000000000
      Properties.LargeIncrement = 1.000000000000000000
      Properties.ValueType = vtFloat
      Properties.OnChange = MarginChange
      Properties.OnEditValueChanged = MarginValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 14
      Visible = False
      OnExit = MarginExit
      Width = 136
    end
    object seMarginRight: TcxSpinEdit
      Tag = 2
      Left = 10000
      Top = 10000
      Properties.ImmediatePost = True
      Properties.Increment = 0.100000000000000000
      Properties.LargeIncrement = 1.000000000000000000
      Properties.ValueType = vtFloat
      Properties.OnChange = MarginChange
      Properties.OnEditValueChanged = MarginValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 15
      Visible = False
      OnExit = MarginExit
      Width = 136
    end
    object seMarginHeader: TcxSpinEdit
      Tag = 5
      Left = 10000
      Top = 10000
      Properties.ImmediatePost = True
      Properties.Increment = 0.100000000000000000
      Properties.LargeIncrement = 1.000000000000000000
      Properties.ValueType = vtFloat
      Properties.OnChange = MarginChange
      Properties.OnEditValueChanged = MarginValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 16
      Visible = False
      OnExit = MarginExit
      Width = 136
    end
    object seMarginFooter: TcxSpinEdit
      Tag = 6
      Left = 10000
      Top = 10000
      Properties.ImmediatePost = True
      Properties.Increment = 0.100000000000000000
      Properties.LargeIncrement = 1.000000000000000000
      Properties.ValueType = vtFloat
      Properties.OnChange = MarginChange
      Properties.OnEditValueChanged = MarginValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 17
      Visible = False
      OnExit = MarginExit
      Width = 136
    end
    object btnRestoreOriginalMargins: TcxButton
      Left = 10000
      Top = 10000
      Width = 99
      Height = 23
      Caption = 'Restore &Original'
      TabOrder = 19
      Visible = False
      OnClick = btnRestoreOriginalMarginsClick
    end
    object btnFix: TcxButton
      Left = 10000
      Top = 10000
      Width = 75
      Height = 23
      Caption = 'Fi&x'
      TabOrder = 18
      Visible = False
      OnClick = btnFixClick
    end
    object lblCenterOnPage: TcxLabel
      Left = 10000
      Top = 10000
      Caption = 'Center on page '
      Style.HotTrack = False
      Transparent = True
      Visible = False
    end
    object chbxCenterHorz: TcxCheckBox
      Left = 10000
      Top = 10000
      Caption = 'Hori&zontaly'
      ParentColor = False
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 21
      Transparent = True
      Visible = False
      OnClick = CenterOnPageClick
    end
    object chbxCenterVert: TcxCheckBox
      Tag = 1
      Left = 10000
      Top = 10000
      Caption = '&Verticaly'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 22
      Transparent = True
      Visible = False
      OnClick = CenterOnPageClick
    end
    object btnHeaderFont: TcxButton
      Left = 10000
      Top = 10000
      Width = 75
      Height = 23
      Caption = '&Font...'
      TabOrder = 25
      Visible = False
      OnClick = btnHFFontClick
    end
    object edHeaderFontInfo: TcxTextEdit
      Left = 10000
      Top = 10000
      TabStop = False
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Properties.ReadOnly = True
      Style.HotTrack = False
      Style.Shadow = False
      Style.TransparentBorder = False
      TabOrder = 26
      Visible = False
      Height = 23
      Width = 265
    end
    object btnHeaderBackground: TcxButton
      Left = 10000
      Top = 10000
      Width = 170
      Height = 23
      Anchors = [akTop, akRight]
      Caption = '&Background'
      OptionsImage.Layout = blGlyphRight
      TabOrder = 24
      Visible = False
      OnClick = BackgroundClick
    end
    object memHeaderLeft: TcxMemo
      Left = 10000
      Top = 10000
      Properties.OnChange = memHeaderCenterPropertiesChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 27
      Visible = False
      OnEnter = MemoEnter
      OnExit = MemoExit
      Height = 82
      Width = 170
    end
    object memHeaderCenter: TcxMemo
      Tag = 1
      Left = 10000
      Top = 10000
      Properties.Alignment = taCenter
      Properties.OnChange = memHeaderCenterPropertiesChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 28
      Visible = False
      OnEnter = MemoEnter
      OnExit = MemoExit
      Height = 82
      Width = 170
    end
    object memHeaderRight: TcxMemo
      Tag = 2
      Left = 10000
      Top = 10000
      Properties.Alignment = taRightJustify
      Properties.OnChange = memHeaderCenterPropertiesChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 29
      Visible = False
      OnEnter = MemoEnter
      OnExit = MemoExit
      Height = 82
      Width = 170
    end
    object chbxReverseOnEvenPages: TcxCheckBox
      Left = 10000
      Top = 10000
      Caption = '&Reverse on even pages'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 23
      Transparent = True
      Visible = False
      OnClick = chbxReverseOnEvenPagesClick
    end
    object btnFooterFont: TcxButton
      Tag = 1
      Left = 10000
      Top = 10000
      Width = 75
      Height = 23
      Caption = 'Fo&nt...'
      TabOrder = 31
      Visible = False
      OnClick = btnHFFontClick
    end
    object edFooterFontInfo: TcxTextEdit
      Left = 10000
      Top = 10000
      TabStop = False
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Properties.ReadOnly = True
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 32
      Visible = False
      Height = 23
      Width = 265
    end
    object btnFooterBackGround: TcxButton
      Tag = 1
      Left = 10000
      Top = 10000
      Width = 170
      Height = 23
      Anchors = [akTop, akRight]
      Caption = 'Back&ground'
      OptionsImage.Layout = blGlyphRight
      TabOrder = 30
      Visible = False
      OnClick = BackgroundClick
    end
    object memFooterLeft: TcxMemo
      Tag = 3
      Left = 10000
      Top = 10000
      Properties.OnChange = memHeaderCenterPropertiesChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 33
      Visible = False
      OnEnter = MemoEnter
      OnExit = MemoExit
      Height = 82
      Width = 170
    end
    object memFooterCenter: TcxMemo
      Tag = 4
      Left = 10000
      Top = 10000
      Properties.Alignment = taCenter
      Properties.OnChange = memHeaderCenterPropertiesChange
      Style.HotTrack = False
      TabOrder = 34
      Visible = False
      OnEnter = MemoEnter
      OnExit = MemoExit
      Height = 82
      Width = 170
    end
    object memFooterRight: TcxMemo
      Tag = 5
      Left = 10000
      Top = 10000
      Properties.Alignment = taRightJustify
      Properties.OnChange = memHeaderCenterPropertiesChange
      Style.HotTrack = False
      TabOrder = 35
      Visible = False
      OnEnter = MemoEnter
      OnExit = MemoExit
      Height = 82
      Width = 170
    end
    object btnVertAlignBottom: TcxButton
      Tag = 2
      Left = 10000
      Top = 10000
      Width = 25
      Height = 25
      OptionsImage.Glyph.SourceDPI = 192
      OptionsImage.Glyph.Data = {
        3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
        462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D2241
        6C69676E546F702220786D6C6E733D22687474703A2F2F7777772E77332E6F72
        672F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F
        7777772E77332E6F72672F313939392F786C696E6B2220783D22307078222079
        3D22307078222076696577426F783D22302030203332203332223E0D0A093C73
        74796C6520747970653D22746578742F637373223E2E426C61636B7B66696C6C
        3A233732373237323B7374726F6B653A233732373237327D3C2F7374796C653E
        0D0A093C6C696E6520436C6173733D22426C61636B222078313D223322207931
        3D2232382E35222078323D223239222079323D2232382E3522207374796C653D
        227374726F6B652D77696474683A203270783B222F3E0D0A093C706F6C79676F
        6E20636C6173733D22426C61636B2220706F696E74733D2231362E3032342032
        362E3137372031312E3031372032302E3836352031352E3032322032302E3836
        352031352E3032322031352E3535322031372E3032352031352E353532203137
        2E3032352032302E3836352032312E30332032302E383635222F3E0D0A3C2F73
        76673E0D0A}
      SpeedButtonOptions.GroupIndex = 1
      SpeedButtonOptions.CanBeFocused = False
      TabOrder = 36
      Visible = False
      OnClick = VertTextAlignClick
    end
    object btnVertAlignCenter: TcxButton
      Tag = 1
      Left = 10000
      Top = 10000
      Width = 25
      Height = 25
      OptionsImage.Glyph.SourceDPI = 192
      OptionsImage.Glyph.Data = {
        3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
        462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D2241
        6C69676E546F702220786D6C6E733D22687474703A2F2F7777772E77332E6F72
        672F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F
        7777772E77332E6F72672F313939392F786C696E6B2220783D22307078222079
        3D22307078222076696577426F783D22302030203332203332223E0D0A093C73
        74796C6520747970653D22746578742F637373223E2E426C61636B7B66696C6C
        3A233732373237323B7374726F6B653A233732373237327D3C2F7374796C653E
        0D0A093C6C696E6520436C6173733D22426C61636B222078313D223322207931
        3D223136222078323D223239222079323D22313622207374796C653D22737472
        6F6B652D77696474683A203270783B222F3E0D0A093C706F6C79676F6E20636C
        6173733D22426C61636B2220706F696E74733D2231352E3937352031372E3237
        312031302E3936382032322E3538362031342E3937332032322E353836203134
        2E3937332032372E3930322031362E3937362032372E3930322031362E393736
        2032322E3538362032302E3938312032322E353836222F3E0D0A093C706F6C79
        676F6E20636C6173733D22426C61636B2220706F696E74733D2231362E303233
        2031342E3935382031312E30313620392E3634362031352E30323120392E3634
        362031352E30323120342E3333332031372E30323420342E3333332031372E30
        323420392E3634362032312E30323920392E363436222F3E0D0A3C2F7376673E
        0D0A}
      SpeedButtonOptions.GroupIndex = 1
      SpeedButtonOptions.CanBeFocused = False
      TabOrder = 37
      Visible = False
      OnClick = VertTextAlignClick
    end
    object btnVertAlignTop: TcxButton
      Left = 10000
      Top = 10000
      Width = 25
      Height = 25
      OptionsImage.Glyph.SourceDPI = 192
      OptionsImage.Glyph.Data = {
        3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
        462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D2241
        6C69676E546F702220786D6C6E733D22687474703A2F2F7777772E77332E6F72
        672F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F
        7777772E77332E6F72672F313939392F786C696E6B2220783D22307078222079
        3D22307078222076696577426F783D22302030203332203332223E0D0A093C73
        74796C6520747970653D22746578742F637373223E2E426C61636B7B66696C6C
        3A233732373237323B7374726F6B653A233732373237327D3C2F7374796C653E
        0D0A093C706F6C79676F6E20636C6173733D22426C61636B2220706F696E7473
        3D2231362E30333820362E3030352031312E3033312031322E3030392031352E
        3033362031322E3030392031352E3033362031382E3031342031372E30333920
        31382E3031342031372E3033392031322E3030392032312E3034342031322E30
        3039222F3E0D0A093C6C696E6520436C6173733D22426C61636B222078313D22
        33222079313D22342E35222078323D223239222079323D22342E352220737479
        6C653D227374726F6B652D77696474683A203270783B222F3E0D0A3C2F737667
        3E0D0A}
      SpeedButtonOptions.GroupIndex = 1
      SpeedButtonOptions.CanBeFocused = False
      SpeedButtonOptions.Down = True
      TabOrder = 38
      Visible = False
      OnClick = VertTextAlignClick
    end
    object tbPredefined: TPanel
      Left = 10000
      Top = 10000
      Width = 392
      Height = 25
      Anchors = [akLeft, akTop, akRight]
      BevelOuter = bvNone
      ParentShowHint = False
      ShowHint = True
      TabOrder = 39
      Visible = False
    end
    object sePagesWide: TcxSpinEdit
      Left = 42
      Top = 178
      Properties.OnChange = sePagesWidePropertiesChange
      Style.HotTrack = False
      TabOrder = 43
      OnExit = sePagesWideExit
      Width = 64
    end
    object sePagesTall: TcxSpinEdit
      Left = 123
      Top = 178
      AutoSize = False
      Properties.OnChange = sePagesWidePropertiesChange
      Style.HotTrack = False
      TabOrder = 44
      OnExit = sePagesWideExit
      Height = 25
      Width = 64
    end
    object lcMainGroup_Root: TdxLayoutGroup
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Visible = False
      Hidden = True
      ItemIndex = 1
      ShowBorder = False
      Index = -1
    end
    object libtnHelp: TdxLayoutItem
      Parent = pnlButtons
      AlignHorz = ahRight
      CaptionOptions.Visible = False
      Control = btnHelp
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 85
      ControlOptions.ShowBorder = False
      Index = 4
    end
    object libtnOK: TdxLayoutItem
      Parent = pnlButtons
      AlignHorz = ahRight
      CaptionOptions.Visible = False
      Control = btnOK
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 85
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object libtnPrint: TdxLayoutItem
      Parent = pnlButtons
      CaptionOptions.Visible = False
      Control = btnPrint
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 96
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object libtnPrintPreview: TdxLayoutItem
      Parent = pnlButtons
      CaptionOptions.Visible = False
      Control = btnPrintPreview
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 96
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lblStyleName: TdxLayoutItem
      Parent = pnlStyleName
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'lblStyleName'
      Control = edStyleName
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object libtnOptions: TdxLayoutItem
      Parent = pnlStyleName
      AlignHorz = ahRight
      AlignVert = avTop
      CaptionOptions.Visible = False
      Control = btnOptions
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 96
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object libtnCancel: TdxLayoutItem
      Parent = pnlButtons
      AlignHorz = ahRight
      CaptionOptions.Visible = False
      Control = btnCancel
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 85
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object dxLayoutItem2: TdxLayoutItem
      Parent = tshScaling
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Visible = False
      Control = rbtnAdjustTo
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 113
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem3: TdxLayoutItem
      Parent = tshScaling
      AlignHorz = ahClient
      CaptionOptions.Visible = False
      Control = rbtnFitTo
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 113
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object lblPercentOfNormalSize: TdxLayoutItem
      Parent = tshScaling
      AlignHorz = ahLeft
      Offsets.Left = 20
      CaptionOptions.Text = '% normal size'
      CaptionOptions.Layout = clRight
      Control = seAdjustTo
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 64
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem4: TdxLayoutItem
      Parent = gbxPaper
      AlignVert = avClient
      Control = lbxPaperType
      ControlOptions.OriginalHeight = 183
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lblPaperWidth: TdxLayoutItem
      Parent = gbxPaper
      AlignVert = avBottom
      CaptionOptions.Text = '&Width:'
      Control = sePaperWidth
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lblPaperHeight: TdxLayoutItem
      Parent = gbxPaper
      AlignVert = avBottom
      CaptionOptions.Text = 'H&eight:'
      Control = sePaperHeight
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object lblPaperSource: TdxLayoutItem
      Parent = gbxPaper
      AlignVert = avBottom
      CaptionOptions.Text = 'Paper so&urce:'
      Control = cbxPaperSource
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object dxLayoutItem5: TdxLayoutItem
      Parent = gbxShading
      CaptionOptions.Visible = False
      Control = chbxShading
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 139
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem6: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup2
      CaptionOptions.Visible = False
      Control = rbtnDownThenOver
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 113
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem8: TdxLayoutItem
      Parent = gbxPrintOrder
      AlignHorz = ahLeft
      AlignVert = avTop
      Control = pbxPageOrder
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 64
      ControlOptions.OriginalWidth = 64
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem7: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup2
      CaptionOptions.Visible = False
      Control = rbtnOverThenDown
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 113
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem9: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup4
      CaptionOptions.Visible = False
      Control = rBtnPortrait
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 80
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object bvlOrientationHolder: TdxLayoutItem
      Parent = gbxOrientation
      AlignHorz = ahLeft
      AlignVert = avTop
      SizeOptions.AssignedValues = [sovSizableHorz, sovSizableVert]
      SizeOptions.SizableHorz = False
      SizeOptions.SizableVert = False
      SizeOptions.Height = 160
      SizeOptions.Width = 160
      Index = 0
    end
    object dxLayoutItem10: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup4
      CaptionOptions.Visible = False
      Control = rBtnLandscape
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 80
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem11: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup4
      CaptionOptions.Visible = False
      Control = rBtnAutoOrientation
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 80
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object bvlPreviewHolder: TdxLayoutItem
      Parent = tshMargins
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Layout = clTop
      Index = 0
    end
    object lblMarginTop: TdxLayoutItem
      Parent = pnlMargins
      CaptionOptions.Text = '&Top:'
      Control = seMarginTop
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lblMarginBottom: TdxLayoutItem
      Parent = pnlMargins
      CaptionOptions.Text = 'Bottom:'
      Control = seMarginBottom
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lblMarginLeft: TdxLayoutItem
      Parent = pnlMargins
      CaptionOptions.Text = 'Left:'
      Control = seMarginLeft
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object lblMarginRight: TdxLayoutItem
      Parent = pnlMargins
      CaptionOptions.Text = 'Right:'
      Control = seMarginRight
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object lblMarginHeader: TdxLayoutItem
      Parent = pnlHFMargins
      CaptionOptions.Text = 'Header:'
      Control = seMarginHeader
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lblMarginFooter: TdxLayoutItem
      Parent = pnlHFMargins
      CaptionOptions.Text = 'Footer:'
      Control = seMarginFooter
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem12: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup3
      AlignHorz = ahClient
      CaptionOptions.Visible = False
      Control = btnRestoreOriginalMargins
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem13: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup3
      AlignVert = avClient
      CaptionOptions.Visible = False
      Control = btnFix
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lilblCenterOnPage: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup8
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = lblCenterOnPage
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 78
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lichbxCenterHorz: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup6
      AlignHorz = ahClient
      CaptionOptions.Visible = False
      Control = chbxCenterHorz
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lichbxCenterVert: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup6
      AlignHorz = ahClient
      CaptionOptions.Visible = False
      Control = chbxCenterVert
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object bvlMarginsWarningHolder: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup5
      AlignVert = avTop
      SizeOptions.Height = 36
      Index = 3
    end
    object libtnHeaderFont: TdxLayoutItem
      Parent = pnlHeaderFont
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Visible = False
      Control = btnHeaderFont
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object liedHeaderFontInfo: TdxLayoutItem
      Parent = pnlHeaderFont
      AlignHorz = ahClient
      AlignVert = avClient
      Control = edHeaderFontInfo
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object libtnHeaderBackground: TdxLayoutItem
      Parent = pnlHeaderFont
      AlignHorz = ahRight
      AlignVert = avClient
      CaptionOptions.Visible = False
      Control = btnHeaderBackground
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 170
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem21: TdxLayoutItem
      Parent = pnlHeaderMemos
      AlignHorz = ahClient
      AlignVert = avClient
      Control = memHeaderLeft
      ControlOptions.OriginalHeight = 82
      ControlOptions.OriginalWidth = 170
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object limemHeaderCenter: TdxLayoutItem
      Parent = pnlHeaderMemos
      AlignVert = avClient
      Control = memHeaderCenter
      ControlOptions.OriginalHeight = 82
      ControlOptions.OriginalWidth = 170
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object limemHeaderRight: TdxLayoutItem
      Parent = pnlHeaderMemos
      AlignVert = avClient
      Control = memHeaderRight
      ControlOptions.OriginalHeight = 82
      ControlOptions.OriginalWidth = 170
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object pnlReverse: TdxLayoutItem
      Parent = tshHeaderFooter
      CaptionOptions.Visible = False
      Control = chbxReverseOnEvenPages
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 134
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object pnlStyleName: TdxLayoutGroup
      Parent = lcMainGroup_Root
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      ItemIndex = 1
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 0
    end
    object pnlButtons: TdxLayoutGroup
      Parent = lcMainGroup_Root
      AlignHorz = ahClient
      CaptionOptions.Visible = False
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 2
    end
    object pgctrlMain: TdxLayoutGroup
      Parent = lcMainGroup_Root
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      ItemIndex = 3
      LayoutDirection = ldTabbed
      ShowBorder = False
      TabbedOptions.ShowFrame = True
      Index = 1
    end
    object tshScaling: TdxLayoutGroup
      Parent = pgctrlMain
      CaptionOptions.Text = '&Scaling'
      ItemIndex = 2
      Index = 3
    end
    object tshPage: TdxLayoutGroup
      Parent = pgctrlMain
      CaptionOptions.Text = '&Page'
      ItemIndex = 1
      LayoutDirection = ldHorizontal
      Index = 0
    end
    object gbxPaper: TdxLayoutGroup
      Parent = tshPage
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'Paper'
      Index = 0
    end
    object gbxShading: TdxLayoutGroup
      Parent = dxLayoutAutoCreatedGroup1
      AlignHorz = ahClient
      AlignVert = avBottom
      CaptionOptions.Text = 'Shading'
      Index = 2
    end
    object gbxPrintOrder: TdxLayoutGroup
      Parent = dxLayoutAutoCreatedGroup1
      AlignVert = avBottom
      CaptionOptions.Text = 'Print Order'
      ItemIndex = 1
      LayoutDirection = ldHorizontal
      Index = 1
    end
    object dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup
      Parent = tshPage
      AlignHorz = ahClient
      Index = 1
    end
    object dxLayoutAutoCreatedGroup2: TdxLayoutAutoCreatedGroup
      Parent = gbxPrintOrder
      AlignHorz = ahClient
      AlignVert = avCenter
      Index = 1
    end
    object gbxOrientation: TdxLayoutGroup
      Parent = dxLayoutAutoCreatedGroup1
      AlignVert = avClient
      CaptionOptions.Text = 'Orientation'
      ItemIndex = 1
      LayoutDirection = ldHorizontal
      Index = 0
    end
    object dxLayoutAutoCreatedGroup4: TdxLayoutAutoCreatedGroup
      Parent = gbxOrientation
      AlignHorz = ahClient
      AlignVert = avClient
      Index = 1
    end
    object tshMargins: TdxLayoutGroup
      Parent = pgctrlMain
      CaptionOptions.Text = '&Margins'
      ItemIndex = 1
      LayoutDirection = ldHorizontal
      Index = 1
    end
    object gbxMargins: TdxLayoutGroup
      Parent = dxLayoutAutoCreatedGroup5
      AlignHorz = ahLeft
      AlignVert = avTop
      SizeOptions.Width = 210
      ItemIndex = 1
      Index = 0
    end
    object pnlMargins: TdxLayoutGroup
      Parent = gbxMargins
      CaptionOptions.Visible = False
      ItemIndex = 3
      ShowBorder = False
      Index = 0
    end
    object pnlHFMargins: TdxLayoutGroup
      Parent = gbxMargins
      CaptionOptions.Visible = False
      ItemIndex = 1
      ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup3: TdxLayoutAutoCreatedGroup
      Parent = gbxMargins
      LayoutDirection = ldHorizontal
      Index = 2
    end
    object dxLayoutAutoCreatedGroup5: TdxLayoutAutoCreatedGroup
      Parent = tshMargins
      Index = 1
    end
    object dxLayoutAutoCreatedGroup6: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutAutoCreatedGroup5
      LayoutDirection = ldHorizontal
      Index = 2
    end
    object tshHeaderFooter: TdxLayoutGroup
      Parent = pgctrlMain
      CaptionOptions.Text = 'Header \ Footer'
      ItemIndex = 2
      Index = 2
    end
    object pnlHeader: TdxLayoutGroup
      Parent = tshHeaderFooter
      CaptionOptions.Text = 'Header'
      Index = 1
    end
    object pnlHeaderFont: TdxLayoutGroup
      Parent = pnlHeader
      AlignHorz = ahClient
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      ItemIndex = 1
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 0
    end
    object pnlHeaderMemos: TdxLayoutGroup
      Parent = pnlHeader
      CaptionOptions.Text = 'Hidden Group'
      Hidden = True
      ItemIndex = 2
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 1
    end
    object pnlFooter: TdxLayoutGroup
      Parent = tshHeaderFooter
      CaptionOptions.Text = 'Footer'
      Index = 2
    end
    object libtnFooterFont: TdxLayoutItem
      Parent = pnlFooterFont
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Visible = False
      Control = btnFooterFont
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object liedFooterFontInfo: TdxLayoutItem
      Parent = pnlFooterFont
      AlignHorz = ahClient
      AlignVert = avClient
      Control = edFooterFontInfo
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object libtnFooterBackground: TdxLayoutItem
      Parent = pnlFooterFont
      AlignHorz = ahRight
      CaptionOptions.Visible = False
      Control = btnFooterBackGround
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 170
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object pnlFooterMemos: TdxLayoutGroup
      Parent = pnlFooter
      CaptionOptions.Text = 'New Group'
      ItemIndex = 2
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 1
    end
    object pnlFooterFont: TdxLayoutGroup
      Parent = pnlFooter
      AlignHorz = ahClient
      CaptionOptions.Text = 'New Group'
      ItemIndex = 1
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 0
    end
    object limemFooterLeft: TdxLayoutItem
      Parent = pnlFooterMemos
      AlignHorz = ahClient
      AlignVert = avClient
      Control = memFooterLeft
      ControlOptions.OriginalHeight = 82
      ControlOptions.OriginalWidth = 170
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object limemFooterCenter: TdxLayoutItem
      Parent = pnlFooterMemos
      AlignHorz = ahClient
      AlignVert = avClient
      Control = memFooterCenter
      ControlOptions.OriginalHeight = 82
      ControlOptions.OriginalWidth = 170
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object limemFooterRight: TdxLayoutItem
      Parent = pnlFooterMemos
      AlignVert = avClient
      Control = memFooterRight
      ControlOptions.OriginalHeight = 82
      ControlOptions.OriginalWidth = 170
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object pnlBottom: TdxLayoutGroup
      Parent = tshHeaderFooter
      CaptionOptions.Text = 'New Group'
      ItemIndex = 1
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 3
    end
    object gbxVertAlignment: TdxLayoutGroup
      Parent = pnlBottom
      AlignHorz = ahLeft
      AlignVert = avClient
      CaptionOptions.Text = ' Vertical Alignment '
      LayoutDirection = ldHorizontal
      Index = 0
    end
    object dxLayoutItem32: TdxLayoutItem
      Parent = gbxVertAlignment
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Visible = False
      Control = btnVertAlignBottom
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 25
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem31: TdxLayoutItem
      Parent = gbxVertAlignment
      AlignHorz = ahLeft
      AlignVert = avClient
      CaptionOptions.Visible = False
      Control = btnVertAlignCenter
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 25
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem30: TdxLayoutItem
      Parent = gbxVertAlignment
      AlignVert = avClient
      CaptionOptions.Visible = False
      Control = btnVertAlignTop
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 25
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object gbxFunctions: TdxLayoutGroup
      Parent = pnlBottom
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = ' Predefined Functions  '
      Index = 1
    end
    object litbPredefined: TdxLayoutItem
      Parent = gbxFunctions
      AlignVert = avClient
      CaptionOptions.Visible = False
      Control = tbPredefined
      ControlOptions.AutoControlAreaAlignment = False
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 185
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object liPagesWide: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup7
      AlignHorz = ahLeft
      Offsets.Left = 20
      CaptionOptions.Text = '1'
      CaptionOptions.Layout = clRight
      Control = sePagesWide
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 64
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object liPagesTall: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup7
      AlignVert = avClient
      CaptionOptions.Text = '1'
      CaptionOptions.Layout = clRight
      Control = sePagesTall
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 64
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup7: TdxLayoutAutoCreatedGroup
      Parent = tshScaling
      LayoutDirection = ldHorizontal
      Index = 4
    end
    object dxLayoutSeparatorItem1: TdxLayoutSeparatorItem
      Parent = dxLayoutAutoCreatedGroup8
      AlignHorz = ahClient
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object dxLayoutAutoCreatedGroup8: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutAutoCreatedGroup5
      LayoutDirection = ldHorizontal
      Index = 1
    end
    object dxLayoutSeparatorItem2: TdxLayoutSeparatorItem
      Parent = tshScaling
      CaptionOptions.Text = 'Separator'
      Index = 2
    end
  end
  object ilPaperTypes: TcxImageList
    SourceDPI = 96
    FormatVersion = 1
    Left = 122
    Top = 65534
    Bitmap = {
      494C010102000800080010001000FFFFFFFF2110FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000803030330030303300303033003030330030303300303
      0330000000170000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000303032C505050D72121218B2121218B2121218B2121218B3737
      37B31A1A1A7C0000000000000000000000000000000000000000000000000000
      0000717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000303032C303030A70F0F0F5E3D3D3DBB3D3D3DBB2929299B0D0D
      0D581A1A1A7C0000000000000000000000000000000000000000000000000000
      0000717171FF0000000000000000000000000000000000000000000000007171
      71FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000002020
      2087717171FF717171FF303030A7010101220707074407070744050505380D0D
      0D58717171FF717171FF515151D8000000000000000000000000000000000000
      0000717171FF00000000717171FF717171FF717171FF717171FF000000007171
      71FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000003333
      33AB717171FF717171FF303030A70606063C1818187818181878111111630D0D
      0D58717171FF717171FF6D6D6DFB0000000000000000454545C8717171FF7171
      71FF717171FF0000000000000000000000000000000000000000000000007171
      71FF717171FF717171FF484848CC000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000052B3F7F0637508F0637508F445D
      69DA717171FF717171FF626262ED484848CB484848CB484848CB484848CB5555
      55DD717171FF717171FF6D6D6DFB0000000000000000717171FF717171FF7171
      71FF717171FF00000000717171FF717171FF717171FF717171FF000000007171
      71FF717171FF717171FF717171FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000014B1FFFF14B1FFFF14B1FFFF5287
      A0FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF6D6D6DFB0000000000000000717171FF717171FF7171
      71FF717171FF0000000000000000000000000000000000000000000000007171
      71FF717171FF717171FF717171FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000014B1FFFF14B1FFFF14B1FFFF5287
      A0FF717171FF3C96C2FF3A97C6FF3A97C6FF3A97C6FF3A97C6FF3A97C6FF3A97
      C6FF12121268505050D66D6D6DFB0000000000000000717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000014B1FFFF14B1FFFF14B1FFFF3D95
      C0FF647A86FF22A7EAFF498DAEFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF309E
      D5FF1414146D272727963A3A3AB60000000000000000717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000014B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF24A6E7FF5188A2FF14B1FFFF14B1FFFF14B1FFFF14B1FFFF349B
      CFFF1A1A1A7C00000000000000000000000000000000717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000014B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF24A6E7FF5188A2FF14B1FFFF14B1FFFF14B1FFFF14B1FFFF349B
      CFFF1A1A1A7C00000000000000000000000000000000717171FF717171FF0000
      000D000000000000000000000000000000000000000000000000000000000000
      00000000000B717171FF717171FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000014B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF21A8ECFF5C8092FF588397FF588397FF588397FF588397FF5A81
      94FF1111116300000000000000000000000000000000424242C3717171FF0000
      0000717171FF0000000000000000000000000000000000000000000000007171
      71FF00000000717171FF454545C8000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000014B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1
      FFFF000000000000000000000000000000000000000000000000000000000000
      0000717171FF0000000000000000000000000000000000000000000000007171
      71FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000014B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF0321317003213170032131700321317003213170032131700319
      2461000000000000000000000000000000000000000000000000000000000000
      0000717171FF0000000000000000000000000000000000000000000000007171
      71FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000014B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF0000000000000000000000000000000000000000000000007171
      71FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000218235F03213170032131700321
      3170031924610000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000}
    DesignInfo = -130950
    ImageInfo = <
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D2251
          7569636B5F5072696E742220786D6C6E733D22687474703A2F2F7777772E7733
          2E6F72672F323030302F7376672220786D6C6E733A786C696E6B3D2268747470
          3A2F2F7777772E77332E6F72672F313939392F786C696E6B2220783D22307078
          2220793D22307078222076696577426F783D22302030203332203332223E0D0A
          093C7374796C6520747970653D22746578742F6373732220786D6C3A73706163
          653D227072657365727665223E2E426C61636B7B66696C6C3A23373237323732
          3B7D262331333B262331303B2623393B2E59656C6C6F777B66696C6C3A234646
          423131353B7D3C2F7374796C653E0D0A093C672069643D22466F6C646572436C
          6F736522207472616E73666F726D3D226D617472697828312C20302C20302C20
          312C202D342C202D342E383837303229223E0D0A09093C673E0D0A0909093C70
          61746820636C6173733D2259656C6C6F772220643D224D32372C313048313456
          3763302D302E352D302E352D312D312D31483543342E352C362C342C362E352C
          342C3776313863302C302E352C302E352C312C312C3168323263302E352C302C
          312D302E352C312D3156313120202623393B2623393B2623393B4332382C3130
          2E352C32372E352C31302C32372C31307A222F3E0D0A09093C2F673E0D0A0909
          3C673E0D0A0909093C7061746820636C6173733D2259656C6C6F772220643D22
          4D32372C3130483134563763302D302E352D302E352D312D312D31483543342E
          352C362C342C362E352C342C3776313863302C302E352C302E352C312C312C31
          68323263302E352C302C312D302E352C312D3156313120202623393B2623393B
          2623393B4332382C31302E352C32372E352C31302C32372C31307A222F3E0D0A
          09093C2F673E0D0A093C2F673E0D0A093C7061746820636C6173733D22426C61
          636B2220643D224D2031332E333120392E3836204C2032332E32393420392E38
          36204C2032332E3239342031352E373231204C2032342E3935372031352E3732
          31204C2032342E39353720382E333935204C2031312E36343720382E33393520
          4C2031312E3634372031352E373231204C2031332E33312031352E373231204C
          2031332E333120392E3836205A204D2032382E3238352031342E323536204C20
          32362E3632312031342E323536204C2032362E3632312031362E343533204320
          32362E3632312031362E3839332032362E3238392031372E3138362032352E37
          38392031372E313836204C2031302E3831352031372E31383620432031302E33
          31362031372E31383620392E3938332031362E38393320392E3938332031362E
          343533204C20392E3938332031342E323536204C20382E3331392031342E3235
          36204320372E3430342031342E32353620362E3635352031342E39313520362E
          3635352031352E373231204C20362E3635352032342E353131204320362E3635
          352032352E33313720372E3430342032352E39373620382E3331392032352E39
          3736204C2031312E3634372032352E393736204C2031312E3634372033302E33
          3731204C2032342E3935372033302E333731204C2032342E3935372032352E39
          3736204C2032382E3238352032352E39373620432032392E322032352E393736
          2032392E3934392032352E3331372032392E3934392032342E353131204C2032
          392E3934392031352E37323120432032392E3934392031342E3931352032392E
          322031342E3235362032382E3238352031342E323536205A204D2032332E3239
          342032342E353131204C2032332E3239342032352E393736204C2032332E3239
          342032382E393036204C2031332E33312032382E393036204C2031332E333120
          32352E393736204C2031332E33312032342E353131204C2031332E3331203231
          2E353831204C2032332E3239342032312E353831204C2032332E323934203234
          2E353131205A204D2032312E36332032352E393736204C2031342E3937342032
          352E393736204C2031342E3937342032372E343431204C2032312E3633203237
          2E343431204C2032312E36332032352E393736205A204D2032312E3633203233
          2E303436204C2031342E3937342032332E303436204C2031342E393734203234
          2E353131204C2032312E36332032342E353131204C2032312E36332032332E30
          3436205A22207374796C653D22222F3E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D2251
          7569636B5F5072696E742220786D6C6E733D22687474703A2F2F7777772E7733
          2E6F72672F323030302F7376672220786D6C6E733A786C696E6B3D2268747470
          3A2F2F7777772E77332E6F72672F313939392F786C696E6B2220783D22307078
          2220793D22307078222076696577426F783D2230203020333220333222207374
          796C653D22656E61626C652D6261636B67726F756E643A6E6577203020302033
          322033323B2220786D6C3A73706163653D227072657365727665223E26233133
          3B262331303B3C7374796C6520747970653D22746578742F637373223E2E426C
          61636B7B66696C6C3A233732373237323B7D3C2F7374796C653E0D0A3C706174
          6820636C6173733D22426C61636B2220643D224D31302C326831327638683256
          304838763130683256327A204D32382C38682D32763363302C302E362D302E34
          2C312D312C314837632D302E362C302D312D302E342D312D3156384834632D31
          2E312C302D322C302E392D322C3276313220202623393B63302C312E312C302E
          392C322C322C3268347636683136762D36683463312E312C302C322D302E392C
          322D325631304333302C382E392C32392E312C382C32382C387A204D32322C32
          3276327634483130762D34762D32762D346831325632327A204D32302C323468
          2D38763268385632347A204D32302C3230682D38763220202623393B68385632
          307A222F3E0D0A3C2F7376673E0D0A}
      end>
  end
  object ilBins: TcxImageList
    SourceDPI = 96
    FormatVersion = 1
    Left = 151
    Top = 65534
    Bitmap = {
      494C010102000800080010001000FFFFFFFF2110FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000803030330030303300303033003030330030303300303
      0330000000170000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000303032C505050D72121218B2121218B2121218B2121218B3737
      37B31A1A1A7C0000000000000000000000000000000000000000000000000000
      0000717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000303032C303030A70F0F0F5E3D3D3DBB3D3D3DBB2929299B0D0D
      0D581A1A1A7C0000000000000000000000000000000000000000000000000000
      0000717171FF0000000000000000000000000000000000000000000000007171
      71FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000002020
      2087717171FF717171FF303030A7010101220707074407070744050505380D0D
      0D58717171FF717171FF515151D80000000000000000454545C8717171FF7171
      71FF717171FF0000000000000000000000000000000000000000000000007171
      71FF717171FF717171FF484848CC000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000003333
      33AB717171FF717171FF303030A70606063C1818187818181878111111630D0D
      0D58717171FF717171FF6D6D6DFB0000000000000000717171FF717171FF7171
      71FF717171FF0000000000000000000000000000000000000000000000007171
      71FF717171FF717171FF717171FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000052B3F7F0637508F0637508F445D
      69DA717171FF717171FF626262ED484848CB484848CB484848CB484848CB5555
      55DD717171FF717171FF6D6D6DFB0000000000000000717171FF717171FF7171
      71FF717171FF0000000000000000000000000000000000000000000000007171
      71FF717171FF717171FF717171FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000014B1FFFF14B1FFFF14B1FFFF5287
      A0FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF6D6D6DFB0000000000000000717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000014B1FFFF14B1FFFF14B1FFFF5287
      A0FF717171FF3C96C2FF3A97C6FF3A97C6FF3A97C6FF3A97C6FF3A97C6FF3A97
      C6FF12121268505050D66D6D6DFB0000000000000000717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000014B1FFFF14B1FFFF14B1FFFF3D95
      C0FF647A86FF22A7EAFF498DAEFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF309E
      D5FF1414146D272727963A3A3AB60000000000000000717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000014B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF24A6E7FF5188A2FF14B1FFFF14B1FFFF14B1FFFF14B1FFFF349B
      CFFF1A1A1A7C00000000000000000000000000000000717171FF717171FF0000
      000D000000000000000000000000000000000000000000000000000000000000
      00000000000B717171FF717171FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000014B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF24A6E7FF5188A2FF14B1FFFF14B1FFFF14B1FFFF14B1FFFF349B
      CFFF1A1A1A7C00000000000000000000000000000000424242C3717171FF0000
      0000717171FF0000000000000000000000000000000000000000000000007171
      71FF00000000717171FF454545C8000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000014B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF21A8ECFF5C8092FF588397FF588397FF588397FF588397FF5A81
      94FF111111630000000000000000000000000000000000000000000000000000
      0000717171FF0000000000000000000000000000000000000000000000007171
      71FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000014B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1
      FFFF000000000000000000000000000000000000000000000000000000000000
      0000717171FF0000000000000000000000000000000000000000000000007171
      71FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000014B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF0321317003213170032131700321317003213170032131700319
      2461000000000000000000000000000000000000000000000000000000000000
      0000717171FF0000000000000000000000000000000000000000000000007171
      71FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000014B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000218235F03213170032131700321
      3170031924610000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000}
    DesignInfo = -130921
    ImageInfo = <
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D2251
          7569636B5F5072696E742220786D6C6E733D22687474703A2F2F7777772E7733
          2E6F72672F323030302F7376672220786D6C6E733A786C696E6B3D2268747470
          3A2F2F7777772E77332E6F72672F313939392F786C696E6B2220783D22307078
          2220793D22307078222076696577426F783D22302030203332203332223E0D0A
          093C7374796C6520747970653D22746578742F6373732220786D6C3A73706163
          653D227072657365727665223E2E426C61636B7B66696C6C3A23373237323732
          3B7D262331333B262331303B2623393B2E59656C6C6F777B66696C6C3A234646
          423131353B7D3C2F7374796C653E0D0A093C672069643D22466F6C646572436C
          6F736522207472616E73666F726D3D226D617472697828312C20302C20302C20
          312C202D342C202D342E383837303229223E0D0A09093C673E0D0A0909093C70
          61746820636C6173733D2259656C6C6F772220643D224D32372C313048313456
          3763302D302E352D302E352D312D312D31483543342E352C362C342C362E352C
          342C3776313863302C302E352C302E352C312C312C3168323263302E352C302C
          312D302E352C312D3156313120202623393B2623393B2623393B4332382C3130
          2E352C32372E352C31302C32372C31307A222F3E0D0A09093C2F673E0D0A0909
          3C673E0D0A0909093C7061746820636C6173733D2259656C6C6F772220643D22
          4D32372C3130483134563763302D302E352D302E352D312D312D31483543342E
          352C362C342C362E352C342C3776313863302C302E352C302E352C312C312C31
          68323263302E352C302C312D302E352C312D3156313120202623393B2623393B
          2623393B4332382C31302E352C32372E352C31302C32372C31307A222F3E0D0A
          09093C2F673E0D0A093C2F673E0D0A093C7061746820636C6173733D22426C61
          636B2220643D224D2031332E333120392E3836204C2032332E32393420392E38
          36204C2032332E3239342031352E373231204C2032342E3935372031352E3732
          31204C2032342E39353720382E333935204C2031312E36343720382E33393520
          4C2031312E3634372031352E373231204C2031332E33312031352E373231204C
          2031332E333120392E3836205A204D2032382E3238352031342E323536204C20
          32362E3632312031342E323536204C2032362E3632312031362E343533204320
          32362E3632312031362E3839332032362E3238392031372E3138362032352E37
          38392031372E313836204C2031302E3831352031372E31383620432031302E33
          31362031372E31383620392E3938332031362E38393320392E3938332031362E
          343533204C20392E3938332031342E323536204C20382E3331392031342E3235
          36204320372E3430342031342E32353620362E3635352031342E39313520362E
          3635352031352E373231204C20362E3635352032342E353131204320362E3635
          352032352E33313720372E3430342032352E39373620382E3331392032352E39
          3736204C2031312E3634372032352E393736204C2031312E3634372033302E33
          3731204C2032342E3935372033302E333731204C2032342E3935372032352E39
          3736204C2032382E3238352032352E39373620432032392E322032352E393736
          2032392E3934392032352E3331372032392E3934392032342E353131204C2032
          392E3934392031352E37323120432032392E3934392031342E3931352032392E
          322031342E3235362032382E3238352031342E323536205A204D2032332E3239
          342032342E353131204C2032332E3239342032352E393736204C2032332E3239
          342032382E393036204C2031332E33312032382E393036204C2031332E333120
          32352E393736204C2031332E33312032342E353131204C2031332E3331203231
          2E353831204C2032332E3239342032312E353831204C2032332E323934203234
          2E353131205A204D2032312E36332032352E393736204C2031342E3937342032
          352E393736204C2031342E3937342032372E343431204C2032312E3633203237
          2E343431204C2032312E36332032352E393736205A204D2032312E3633203233
          2E303436204C2031342E3937342032332E303436204C2031342E393734203234
          2E353131204C2032312E36332032342E353131204C2032312E36332032332E30
          3436205A22207374796C653D22222F3E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F6373732220786D6C3A737061
          63653D227072657365727665223E2E5265647B66696C6C3A234431314331433B
          7D262331333B262331303B2623393B2E426C61636B7B66696C6C3A2337323732
          37323B7D262331333B262331303B2623393B2E426C75657B66696C6C3A233131
          373744373B7D262331333B262331303B2623393B2E477265656E7B66696C6C3A
          233033394332333B7D262331333B262331303B2623393B2E59656C6C6F777B66
          696C6C3A234646423131353B7D262331333B262331303B2623393B2E57686974
          657B66696C6C3A234646464646463B7D262331333B262331303B2623393B2E73
          74307B6F7061636974793A302E353B7D262331333B262331303B2623393B2E73
          74317B6F7061636974793A302E37353B7D262331333B262331303B2623393B2E
          7374327B6F7061636974793A302E32353B7D3C2F7374796C653E0D0A3C672069
          643D225072696E745F315F223E0D0A09093C7061746820636C6173733D22426C
          61636B2220643D224D31302C346831327638683256324838763130683256347A
          204D32382C3130682D32763363302C302E362D302E342C312D312C314837632D
          302E362C302D312D302E342D312D31762D334834632D312E312C302D322C302E
          392D322C3276313220202623393B2623393B63302C312E312C302E392C322C32
          2C3268347634683136762D34683463312E312C302C322D302E392C322D325631
          324333302C31302E392C32392E312C31302C32382C31307A204D32322C323476
          327632483130762D32762D32762D346831325632347A222F3E0D0A093C2F673E
          0D0A3C2F7376673E0D0A}
        FileName = 'SVG Images\Scheduling\Print.svg'
        Keywords = 'Scheduling;Print'
      end>
  end
  object ilPapers: TcxImageList
    SourceDPI = 96
    FormatVersion = 1
    Left = 180
    Top = 65534
    Bitmap = {
      494C010102000800080010001000FFFFFFFF2110FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000666666F2717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF676767F400000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000717171FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000717171FF0000000000000000D77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000717171FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000717171FF0000000000000000D77610FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFD77610FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000717171FF000000000000
      0000D77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FF0000
      000000000000717171FF0000000000000000D77610FFE5A662FFFDF6F0FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFDF7F1FFE5A765FFD77610FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000717171FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000717171FF0000000000000000D77610FFF1D0ADFFDE903CFFF5DE
      C6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFF6E0C8FFDE903CFFF1CFAAFFD77610FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000717171FF000000000000
      0000D77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FF0000
      000000000000717171FF0000000000000000D77610FFFFFFFFFFFAEFE3FFE199
      4CFFEAB985FFFEFDFBFFFDF7F1FFE5A765FFE5A662FFFDF6F0FFFEFDFCFFEBBB
      88FFE1984AFFFAEEE1FFFFFFFFFFD77610FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000717171FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000717171FF0000000000000000D77610FFFFFFFFFFFFFFFFFFFFFD
      FCFFECBD8BFFE09646FFDF903CFFF1CFABFFF1D0ADFFDE903BFFE09748FFEBBB
      88FFFEFDFCFFFFFFFFFFFFFFFFFFD77610FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000717171FF000000000000
      0000D77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FF0000
      000000000000717171FF0000000000000000D77610FFFFFFFFFFFFFFFFFFFEFD
      FCFFEBBB88FFE1984AFFFAEEE1FFFFFFFFFFFFFFFFFFFAEFE2FFE1994CFFEAB9
      85FFFEFDFBFFFFFFFFFFFFFFFFFFD77610FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000717171FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000717171FF0000000000000000D77610FFFFFFFFFFFAEDE0FFE198
      4AFFEBBC89FFFEFDFCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDFCFFECBD
      8BFFE09748FFFAECDEFFFFFFFFFFD77610FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000717171FF000000000000
      0000D77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FF0000
      000000000000717171FF0000000000000000D77610FFF1CEAAFFDF913DFFF6E0
      C9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFF6E1CBFFDF913DFFF0CDA7FFD77610FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000717171FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000717171FF0000000000000000D77610FFE5A866FFFDF7F2FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFDF8F3FFE6A968FFD77610FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000717171FF000000000000
      0000D77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FF0000
      000000000000717171FF0000000000000000D77610FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFD77610FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000717171FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000717171FF0000000000000000D77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000717171FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000717171FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000646464F0717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF666666F200000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000}
    DesignInfo = -130892
    ImageInfo = <
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F6373732220786D6C3A737061
          63653D227072657365727665223E2E59656C6C6F777B66696C6C3A2346464231
          31353B7D262331333B262331303B2623393B2E5265647B66696C6C3A23443131
          4331433B7D262331333B262331303B2623393B2E426C75657B66696C6C3A2331
          31373744373B7D262331333B262331303B2623393B2E477265656E7B66696C6C
          3A233033394332333B7D262331333B262331303B2623393B2E426C61636B7B66
          696C6C3A233732373237323B7D262331333B262331303B2623393B2E57686974
          657B66696C6C3A234646464646463B7D262331333B262331303B2623393B2E73
          74307B6F7061636974793A302E37353B7D3C2F7374796C653E0D0A3C67206964
          3D2253696E676C655061676556696577223E0D0A09093C7061746820636C6173
          733D22426C61636B2220643D224D32372C30483343322E342C302C322C302E34
          2C322C3176323863302C302E362C302E342C312C312C3168323463302E362C30
          2C312D302E342C312D3156314332382C302E342C32372E362C302C32372C307A
          204D32362C3238483456326832325632387A222F3E0D0A09093C706174682063
          6C6173733D22426C75652220643D224D32322C384838563668313456387A204D
          32322C3130483876326831345631307A204D32322C3134483876326831345631
          347A204D32322C3138483876326831345631387A204D32322C32324838763268
          31345632327A222F3E0D0A093C2F673E0D0A3C2F7376673E0D0A}
        FileName = 'SVG Images\PDF Viewer\SinglePageView.svg'
        Keywords = 'PDF Viewer;SinglePageView'
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F6373732220786D6C3A737061
          63653D227072657365727665223E2E57686974657B66696C6C3A234646464646
          463B7D262331333B262331303B2623393B2E426C75657B66696C6C3A23313137
          3744373B7D3C2F7374796C653E0D0A3C672069643D224D61696C223E0D0A0909
          3C7265637420793D22342220636C6173733D22426C7565222077696474683D22
          333222206865696768743D223234222F3E0D0A09093C7265637420783D223222
          20793D22362220636C6173733D225768697465222077696474683D2232382220
          6865696768743D223230222F3E0D0A09093C706F6C79676F6E20636C6173733D
          22426C75652220706F696E74733D2233302C382031362C313820322C3820322C
          31302031302E342C313620322C323220322C32342031312E382C31372031362C
          32302032302E322C31372033302C32342033302C32322032312E362C31362033
          302C3130202623393B222F3E0D0A093C2F673E0D0A3C2F7376673E0D0A}
        FileName = 'DevAV\Contacts\Mail.svg'
        Keywords = 'Contacts;Mail'
      end>
  end
  object ilPrintOrders: TcxImageList
    SourceDPI = 96
    BkColor = clWhite
    Height = 64
    Width = 64
    FormatVersion = 1
    Left = 210
    Top = 65534
    Bitmap = {
      494C010102000800080040004000FFFFFF002110FFFFFFFFFFFFFFFF424D3600
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
    DesignInfo = -130862
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
      end>
  end
  object dxLayoutLookAndFeelList1: TdxLayoutLookAndFeelList
    Left = 8
    object dxLayoutCxLookAndFeel1: TdxLayoutCxLookAndFeel
      PixelsPerInch = 96
    end
  end
end
