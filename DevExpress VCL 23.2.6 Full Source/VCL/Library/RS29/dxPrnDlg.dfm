object dxfmPrintDialog: TdxfmPrintDialog
  Left = 281
  Top = 188
  AutoSize = True
  BorderStyle = bsDialog
  Caption = 'Print'
  ClientHeight = 489
  ClientWidth = 526
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 13
  object lcMain: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 526
    Height = 489
    TabOrder = 0
    AutoSize = True
    LayoutLookAndFeel = dxLayoutCxLookAndFeel1
    object pbxCollate: TPaintBox
      Left = 332
      Top = 278
      Width = 118
      Height = 54
      Color = clBtnFace
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      OnDblClick = pbxCollateDblClick
      OnPaint = pbxCollatePaint
    end
    object btnPreview: TcxButton
      Left = 112
      Top = 456
      Width = 96
      Height = 23
      Anchors = [akLeft, akBottom]
      Caption = 'Print Pre&view'
      TabOrder = 22
      OnClick = btnPreviewClick
    end
    object btnPageSetup: TcxButton
      Left = 10
      Top = 456
      Width = 96
      Height = 23
      Anchors = [akLeft, akBottom]
      Caption = 'Page Set&up...'
      OptionsImage.Layout = blGlyphRight
      TabOrder = 21
      OnClick = btnPageSetupClick
    end
    object btnOK: TcxButton
      Left = 249
      Top = 456
      Width = 85
      Height = 23
      Anchors = [akLeft, akBottom]
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 23
    end
    object btnCancel: TcxButton
      Left = 340
      Top = 456
      Width = 85
      Height = 23
      Anchors = [akLeft, akBottom]
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 24
    end
    object btnHelp: TcxButton
      Left = 431
      Top = 456
      Width = 85
      Height = 23
      Anchors = [akLeft, akBottom]
      Caption = '&Help'
      TabOrder = 25
      OnClick = btnHelpClick
    end
    object lbxPrintStyles: TcxListBox
      Left = 22
      Top = 368
      Width = 368
      Height = 70
      Anchors = [akLeft, akTop, akRight, akBottom]
      ItemHeight = 13
      PopupMenu = pmPrintStyles
      Style.TransparentBorder = False
      TabOrder = 18
      OnClick = lbxPrintStylesClick
      OnDblClick = PageSetup2Click
      OnDrawItem = lbxPrintStylesDrawItem
    end
    object btnDefineStyles: TcxButton
      Left = 396
      Top = 397
      Width = 96
      Height = 23
      Caption = 'Define S&tyles...'
      TabOrder = 20
      OnClick = DefineStylesClick
    end
    object btnPageSetup2: TcxButton
      Left = 396
      Top = 368
      Width = 96
      Height = 23
      Caption = 'Page Set&up...'
      Default = True
      TabOrder = 19
      OnClick = PageSetup2Click
    end
    object seCopies: TcxSpinEdit
      Left = 372
      Top = 230
      Properties.SpinButtons.Position = sbpHorzRight
      Properties.OnChange = seCopiesChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 16
      OnExit = seCopiesExit
      Width = 132
    end
    object cbxNumberOfPages: TcxComboBox
      Left = 372
      Top = 205
      Properties.DropDownListStyle = lsFixedList
      Properties.OnChange = cbxNumberOfPagesChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 15
      Width = 132
    end
    object chbxCollate: TcxCheckBox
      Left = 278
      Top = 255
      Caption = 'Co&llate copies'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 17
      Transparent = True
      OnClick = chbxCollateClick
    end
    object rbtnAllPages: TcxRadioButton
      Left = 22
      Top = 205
      Caption = '&All'
      Checked = True
      Color = clBtnFace
      ParentColor = False
      TabOrder = 10
      TabStop = True
      OnClick = rbtnPagesClick
      AutoSize = True
      ParentBackground = False
      Transparent = True
    end
    object rbtnCurrentPage: TcxRadioButton
      Tag = 1
      Left = 22
      Top = 228
      Caption = 'Curr&ent page'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 11
      OnClick = rbtnPagesClick
      AutoSize = True
      ParentBackground = False
      Transparent = True
    end
    object rbtnPageRanges: TcxRadioButton
      Tag = 2
      Left = 22
      Top = 251
      Caption = 'Pa&ges: '
      Color = clBtnFace
      ParentColor = False
      TabOrder = 13
      OnClick = rbtnPagesClick
      AutoSize = True
      ParentBackground = False
      Transparent = True
    end
    object edPageRanges: TcxTextEdit
      Left = 91
      Top = 251
      Properties.OnChange = edPageRangesChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 14
      OnExit = edPageRangesExit
      OnKeyPress = edPageRangesKeyPress
      Width = 157
    end
    object rbtnSelection: TcxRadioButton
      Tag = 3
      Left = 119
      Top = 228
      Caption = '&Selection'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 12
      OnClick = rbtnPagesClick
      AutoSize = True
      ParentBackground = False
      Transparent = True
    end
    object cbxPrinters: TcxImageComboBox
      Left = 76
      Top = 30
      Properties.Images = ilPrinters
      Properties.Items = <>
      Properties.OnChange = cbxPrintersChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 0
      Width = 347
    end
    object btnPrinterProperties: TcxButton
      Left = 429
      Top = 28
      Width = 75
      Height = 23
      Caption = 'P&roperties...'
      TabOrder = 1
      OnClick = btnPrinterPropertiesClick
    end
    object btnNetwork: TcxButton
      Left = 429
      Top = 57
      Width = 75
      Height = 23
      Caption = 'Net&work...'
      TabOrder = 3
      OnClick = btnNetworkClick
    end
    object lStatus: TcxLabel
      Left = 76
      Top = 61
      Caption = 'Status'
      Style.HotTrack = False
      Style.TransparentBorder = False
      Transparent = True
    end
    object lType: TcxLabel
      Left = 76
      Top = 86
      Caption = 'Type'
      Style.HotTrack = False
      Style.TransparentBorder = False
      Transparent = True
    end
    object lWhere: TcxLabel
      Left = 76
      Top = 106
      Caption = 'Where'
      Style.HotTrack = False
      Style.TransparentBorder = False
      Transparent = True
    end
    object lComment: TcxLabel
      Left = 76
      Top = 126
      Caption = 'Comment'
      Style.HotTrack = False
      Style.TransparentBorder = False
      Transparent = True
    end
    object chbxPrintToFile: TcxCheckBox
      Left = 22
      Top = 149
      Caption = 'Print to &file'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 7
      Transparent = True
      OnClick = chbxPrintToFileClick
    end
    object cbxFileName: TcxComboBox
      Left = 100
      Top = 146
      AutoSize = False
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 8
      Text = 'cbxFileName'
      OnExit = cbxFileNameExit
      Height = 23
      Width = 323
    end
    object btnBrowse: TcxButton
      Left = 429
      Top = 146
      Width = 75
      Height = 23
      Caption = '&Browse...'
      TabOrder = 9
      OnClick = btnBrowseClick
    end
    object lcMainGroup_Root: TdxLayoutGroup
      AlignHorz = ahLeft
      AlignVert = avTop
      Hidden = True
      ItemIndex = 1
      ShowBorder = False
      Index = -1
    end
    object libtnPreview: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup1
      AlignHorz = ahClient
      CaptionOptions.Text = 'btnPreview'
      CaptionOptions.Visible = False
      Control = btnPreview
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 96
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object libtnPageSetup: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup1
      AlignVert = avClient
      CaptionOptions.Text = 'btnPageSetup'
      CaptionOptions.Visible = False
      Control = btnPageSetup
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 96
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutAutoCreatedGroup2
      AlignHorz = ahLeft
      AlignVert = avTop
      LayoutDirection = ldHorizontal
      Index = 0
    end
    object libtnOK: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup2
      AlignHorz = ahRight
      AlignVert = avTop
      CaptionOptions.Text = 'btnOK'
      CaptionOptions.Visible = False
      Control = btnOK
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 85
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object libtnCancel: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup2
      AlignHorz = ahRight
      AlignVert = avTop
      CaptionOptions.Text = 'btnCancel'
      CaptionOptions.Visible = False
      Control = btnCancel
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 85
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object libtnHelp: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup2
      AlignHorz = ahRight
      AlignVert = avTop
      CaptionOptions.Text = 'btnHelp'
      CaptionOptions.Visible = False
      Control = btnHelp
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 85
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object gbxPrintStyles: TdxLayoutGroup
      Parent = lcMainGroup_Root
      CaptionOptions.Text = 'Print Styles'
      ItemIndex = 1
      LayoutDirection = ldHorizontal
      Index = 2
    end
    object dxLayoutAutoCreatedGroup2: TdxLayoutAutoCreatedGroup
      Parent = lcMainGroup_Root
      LayoutDirection = ldHorizontal
      Index = 3
    end
    object dxLayoutItem3: TdxLayoutItem
      Parent = gbxPrintStyles
      AlignHorz = ahLeft
      AlignVert = avTop
      Control = lbxPrintStyles
      ControlOptions.OriginalHeight = 70
      ControlOptions.OriginalWidth = 368
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object libtnDefineStyles: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup3
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Text = 'btnDefineStyles'
      CaptionOptions.Visible = False
      Control = btnDefineStyles
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 96
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object libtnPageSetup2: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup3
      CaptionOptions.Text = 'btnPageSetup2'
      CaptionOptions.Visible = False
      Control = btnPageSetup2
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 96
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutAutoCreatedGroup3: TdxLayoutAutoCreatedGroup
      Parent = gbxPrintStyles
      AlignHorz = ahLeft
      Index = 1
    end
    object gbxCopies: TdxLayoutGroup
      Parent = dxLayoutAutoCreatedGroup4
      AlignHorz = ahClient
      CaptionOptions.Text = 'C&opies'
      SizeOptions.Width = 250
      ItemIndex = 2
      Index = 1
    end
    object dxLayoutItem8: TdxLayoutItem
      Parent = gbxCopies
      AlignHorz = ahCenter
      Control = pbxCollate
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 54
      ControlOptions.OriginalWidth = 118
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object lblNumberOfCopies: TdxLayoutItem
      Parent = gbxCopies
      CaptionOptions.Text = 'seCopies'
      Control = seCopies
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 100
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lblNumberOfPages: TdxLayoutItem
      Parent = gbxCopies
      CaptionOptions.Text = 'Number of pa&ges :'
      Control = cbxNumberOfPages
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 100
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem5: TdxLayoutItem
      Parent = gbxCopies
      AlignHorz = ahClient
      CaptionOptions.Visible = False
      Control = chbxCollate
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 90
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object gbxPageRange: TdxLayoutGroup
      Parent = dxLayoutAutoCreatedGroup4
      AlignHorz = ahClient
      CaptionOptions.Text = ' Page ra&nge '
      SizeOptions.Width = 250
      ItemIndex = 4
      Index = 0
    end
    object dxLayoutAutoCreatedGroup4: TdxLayoutAutoCreatedGroup
      Parent = lcMainGroup_Root
      LayoutDirection = ldHorizontal
      Index = 1
    end
    object lirbtnAllPages: TdxLayoutItem
      Parent = gbxPageRange
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Visible = False
      Control = rbtnAllPages
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 38
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lirbtnCurrentPage: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup6
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = rbtnCurrentPage
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 91
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lirbtnPageRanges: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup5
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = rbtnPageRanges
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 63
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object liedPageRanges: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup5
      AlignHorz = ahClient
      Control = edPageRanges
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup5: TdxLayoutAutoCreatedGroup
      Parent = gbxPageRange
      LayoutDirection = ldHorizontal
      Index = 2
    end
    object lirbtnSelection: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup6
      AlignVert = avClient
      CaptionOptions.Visible = False
      Control = rbtnSelection
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 70
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup6: TdxLayoutAutoCreatedGroup
      Parent = gbxPageRange
      LayoutDirection = ldHorizontal
      Index = 1
    end
    object gbxPrinter: TdxLayoutGroup
      Parent = lcMainGroup_Root
      CaptionOptions.Text = ' &Printer '
      ItemIndex = 1
      Index = 0
    end
    object lblName: TdxLayoutItem
      Parent = dxLayoutGroup2
      AlignHorz = ahClient
      AlignVert = avCenter
      CaptionOptions.Text = 'Name:'
      Control = cbxPrinters
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object libtnPrinterProperties: TdxLayoutItem
      Parent = dxLayoutGroup2
      AlignHorz = ahRight
      AlignVert = avCenter
      CaptionOptions.Visible = False
      Control = btnPrinterProperties
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object libtnNetwork: TdxLayoutItem
      Parent = dxLayoutGroup3
      AlignHorz = ahRight
      AlignVert = avCenter
      CaptionOptions.Visible = False
      Control = btnNetwork
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lblStatus: TdxLayoutItem
      Parent = dxLayoutGroup3
      AlignHorz = ahClient
      AlignVert = avCenter
      CaptionOptions.Text = 'Status:'
      Control = lStatus
      ControlOptions.AlignVert = avCenter
      ControlOptions.OriginalHeight = 13
      ControlOptions.OriginalWidth = 31
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lblType: TdxLayoutItem
      Parent = gbxPrinter
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'Type:'
      Control = lType
      ControlOptions.OriginalHeight = 13
      ControlOptions.OriginalWidth = 24
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object lblWhere: TdxLayoutItem
      Parent = gbxPrinter
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'Where:'
      Control = lWhere
      ControlOptions.OriginalHeight = 13
      ControlOptions.OriginalWidth = 32
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object lblComment: TdxLayoutItem
      Parent = gbxPrinter
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'Comment:'
      Control = lComment
      ControlOptions.OriginalHeight = 13
      ControlOptions.OriginalWidth = 45
      ControlOptions.ShowBorder = False
      Index = 4
    end
    object lichbxPrintToFile: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup10
      AlignHorz = ahLeft
      AlignVert = avCenter
      CaptionOptions.Visible = False
      Control = chbxPrintToFile
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 72
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object licbxFileName: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup10
      AlignHorz = ahClient
      AlignVert = avClient
      Control = cbxFileName
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup10: TdxLayoutAutoCreatedGroup
      Parent = gbxPrinter
      AlignHorz = ahClient
      AlignVert = avTop
      LayoutDirection = ldHorizontal
      Index = 5
    end
    object libtnBrowse: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup10
      AlignHorz = ahRight
      AlignVert = avClient
      CaptionOptions.Visible = False
      Control = btnBrowse
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object lblDescription: TdxLayoutLabeledItem
      Parent = gbxPageRange
      AlignVert = avTop
      CaptionOptions.Text = 'Enter page number and/or page ranges'
      CaptionOptions.WordWrap = True
      Index = 3
    end
    object bvlPRWarningHolder: TdxLayoutItem
      Parent = gbxPageRange
      AlignHorz = ahClient
      AlignVert = avClient
      Visible = False
      Index = 4
    end
    object dxLayoutGroup2: TdxLayoutGroup
      Parent = gbxPrinter
      AlignVert = avTop
      CaptionOptions.Text = 'Hidden Group'
      Hidden = True
      ItemIndex = 1
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 0
    end
    object dxLayoutGroup3: TdxLayoutGroup
      Parent = gbxPrinter
      AlignVert = avTop
      CaptionOptions.Text = 'Hidden Group'
      Hidden = True
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 1
    end
    object liPageNumbersWarningSign: TdxLayoutImageItem
      Parent = lgPageNumbersWarning
      AlignVert = avClient
      Padding.Left = 3
      Padding.AssignedValues = [lpavLeft]
      CaptionOptions.Text = 'WarningSign'
      CaptionOptions.Visible = False
      Image.SourceDPI = 192
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
        63653D227072657365727665223E2E426C61636B7B66696C6C3A233732373237
        323B7D262331333B262331303B2623393B2E5265647B66696C6C3A2344313143
        31433B7D262331333B262331303B2623393B2E59656C6C6F777B66696C6C3A23
        4646423131353B7D262331333B262331303B2623393B2E477265656E7B66696C
        6C3A233033394332333B7D3C2F7374796C653E0D0A3C672069643D225761726E
        696E67223E0D0A09093C7061746820636C6173733D2259656C6C6F772220643D
        224D31342E392C342E3763302E362D312C312E352D312C322E312C306C31322E
        372C32312E3563302E362C312C302E312C312E382D312C312E3848332E33632D
        312E322C302D312E362D302E382D312D312E384C31342E392C342E377A222F3E
        0D0A09093C636972636C6520636C6173733D22426C61636B222063783D223136
        222063793D2232322220723D2232222F3E0D0A09093C7265637420783D223134
        2220793D2231302220636C6173733D22426C61636B222077696474683D223422
        206865696768743D2238222F3E0D0A093C2F673E0D0A3C2F7376673E0D0A}
      Index = 0
    end
    object liPageNumbersWarningText: TdxLayoutLabeledItem
      Parent = lgPageNumbersWarning
      AlignHorz = ahClient
      CaptionOptions.Text = 'Page numbers out of range (x - x)'
      Index = 1
    end
    object lgPageNumbersWarning: TdxLayoutGroup
      Parent = gbxPageRange
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'PageNumbersWarning Group'
      LayoutLookAndFeel = dxLayoutCxLookAndFeel_InfoBk
      Visible = False
      Hidden = True
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 5
    end
  end
  object pmPrintStyles: TPopupMenu
    OnPopup = pmPrintStylesPopup
    Left = 219
    Top = 5
    object miPageSetup: TMenuItem
      Caption = 'Page Set&up...'
      Default = True
      ShortCut = 16397
      OnClick = PageSetup2Click
    end
    object miLine1: TMenuItem
      Caption = '-'
    end
    object miDefineStyles: TMenuItem
      Caption = 'Define Styles...'
      OnClick = DefineStylesClick
    end
  end
  object ilPrinters: TcxImageList
    SourceDPI = 96
    FormatVersion = 1
    Left = 128
    Top = 29
    Bitmap = {
      494C010105000800080010001000FFFFFFFF2110FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000002000000001002000000000000020
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000636363EF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF656565F1000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000717171FF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000717171FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000717171FF00000000229C02FF229C
      02FF229C02FF00000000D77610FFD77610FFD77610FF00000000A85F40FFA85F
      40FFA85F40FF00000000717171FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000717171FF00000000229C02FF229C
      02FF229C02FF00000000D77610FFD77610FFD77610FF00000000A85F40FFA85F
      40FFA85F40FF00000000717171FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000717171FF00000000229C02FF229C
      02FF229C02FF00000000D77610FFD77610FFD77610FF00000000A85F40FFA85F
      40FFA85F40FF00000000717171FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000717171FF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000717171FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000717171FF000000001BA781FF1BA7
      81FF1BA781FF000000007C8909FF7C8909FF7C8909FF00000000784870FF7848
      70FF784870FF00000000717171FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000717171FF000000001BA781FF1BA7
      81FF1BA781FF000000007C8909FF7C8909FF7C8909FF00000000784870FF7848
      70FF784870FF00000000717171FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000717171FF000000001BA781FF1BA7
      81FF1BA781FF000000007C8909FF7C8909FF7C8909FF00000000784870FF7848
      70FF784870FF00000000717171FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000717171FF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000717171FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000717171FF0000000014B1FFFF14B1
      FFFF14B1FFFF000000001866E8FF1866E8FF1866E8FF000000001B1BD1FF1B1B
      D1FF1B1BD1FF00000000717171FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000717171FF0000000014B1FFFF14B1
      FFFF14B1FFFF000000001866E8FF1866E8FF1866E8FF000000001B1BD1FF1B1B
      D1FF1B1BD1FF00000000717171FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000717171FF0000000014B1FFFF14B1
      FFFF14B1FFFF000000001866E8FF1866E8FF1866E8FF000000001B1BD1FF1B1B
      D1FF1B1BD1FF00000000717171FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000717171FF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000717171FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000626262ED717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF636363EF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000002C1803752414026A000000000000000000000000000000000000
      0000717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF000000000000000000000000000000000000000000000000000000007171
      71FF0000000000000000000000000000000000000000717171FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000666666F27171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF676767F30606
      063E371E0482D77610FF2B180373000000000000000000000000000000000000
      0000717171FF0000000000000000000000000000000000000000000000007171
      71FF00000000000000000000000000000000454545C8717171FF717171FF7171
      71FF0000000000000000000000000000000000000000717171FF717171FF7171
      71FF484848CC000000000000000000000000454545C8717171FF717171FF4848
      48CC00000000454545C8717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF484848CC0000000000000000717171FF0000
      000000000000000000000000000000000000000000000000000000000000371E
      0482D77610FF341D037E000000000000000000000000454545C8717171FF7171
      71FF717171FF0000000000000000000000000000000000000000000000007171
      71FF717171FF717171FF484848CC00000000717171FF717171FF717171FF7171
      71FF0000000000000000000000000000000000000000717171FF717171FF7171
      71FF717171FF000000000000000000000000717171FF717171FF717171FF7171
      71FF00000000717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF0000000000000000717171FF0000
      000000000000000000000000000747270593C16A0FF2C16A0FF2774209BED776
      10FF341D037E0606063E000000000000000000000000717171FF717171FF7171
      71FF717171FF0000000000000000000000000000000000000000000000007171
      71FF717171FF717171FF717171FF00000000717171FF717171FF717171FF7171
      71FF0000000000000000000000000000000000000000717171FF717171FF7171
      71FF717171FF000000000000000000000000717171FF717171FF717171FF7171
      71FF00000000717171FF717171FF717171FF00000000717171FF000000007171
      71FF00000000717171FF717171FF717171FF0000000000000000717171FF0000
      0000000000000000000045260591D77610FFD17310FCD07210FBD77610FF7540
      09BC00000000676767F3000000000000000000000000717171FF717171FF7171
      71FF717171FF0000000000000000000000000000000000000000000000007171
      71FF717171FF717171FF717171FF00000000717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF000000000000000000000000717171FF717171FF717171FF7171
      71FF00000000717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF0000000000000000717171FF0000
      00000000000000000000BC670EEFA35A0DDE0302002204020023D07210FBC16A
      0FF200000000717171FF000000000000000000000000717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF00000000717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF000000000000000000000000717171FF717171FF717171FF7171
      71FF00000000717171FF717171FF717171FF00000000717171FF000000007171
      71FF00000000717171FF717171FF717171FF0000000000000000717171FF0000
      000000000000000000008B4C0BCD0301001F0000000004020023D17310FCC16A
      0FF200000000717171FF000000000000000000000000717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF00000000717171FF717171FF0000000D0000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000717171FF717171FF717171FF7171
      71FF00000000717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF0000000000000000717171FF0000
      000000000000000000000000000A0000000003010021A65B0DE0D77610FF4727
      059300000000717171FF000000000000000000000000717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF00000000424242C3717171FF000000007171
      71FF000000000000000000000000000000001E8A02EF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF1F8C02F1717171FF717171FF717171FF7171
      71FF00000000717171FF717171FF717171FF00000000717171FF000000007171
      71FF00000000717171FF717171FF717171FF0000000000000000717171FF0000
      00000000000000000000000000000000000B8E4E0BCFBB670EEE452605910000
      000700000000717171FF000000000000000000000000717171FF717171FF0000
      000D000000000000000000000000000000000000000000000000000000000000
      00000000000B717171FF717171FF000000000000000000000000000000007171
      71FF00000000000000000000000000000000229C02FF229C02FF1A7602DE1A76
      02DE229C02FF229C02FF229C02FF229C02FF717171FF717171FF717171FF7171
      71FF00000000717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF0000000000000000717171FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000717171FF000000000000000000000000424242C3717171FF0000
      0000717171FF0000000000000000000000000000000000000000000000007171
      71FF00000000717171FF454545C8000000000000000000000000000000007171
      71FF00000000000000000000000000000000229C02FF1A7602DE0002001F0002
      001F1A7602DE229C02FF229C02FF229C02FF717171FF717171FF717171FF7171
      71FF00000000717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF0000000000000000717171FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000717171FF00000000000000000000000000000000000000000000
      0000717171FF0000000000000000000000000000000000000000000000007171
      71FF000000000000000000000000000000000000000000000000000000007171
      71FF00000000000000000000000000000000229C02FF0002001F092801820928
      01820002001F1A7602DE229C02FF229C02FF717171FF717171FF717171FF7171
      71FF00000000717171FF717171FF0000000D0000000000000000000000000000
      0000000000000000000B717171FF717171FF0000000000000000717171FF0000
      0000000000000000000000000000000000000000000000000000666666F27171
      71FF717171FF555555DE00000000000000000000000000000000000000000000
      0000717171FF0000000000000000000000000000000000000000000000007171
      71FF000000000000000000000000000000000000000000000000000000007171
      71FF717171FF717171FF717171FF00000000229C02FF09280182229C02FF229C
      02FF092801820002001F1A7602DE229C02FF424242C3717171FF717171FF4545
      45C800000000424242C3717171FF00000000717171FF00000000000000000000
      0000717171FF00000000717171FF454545C80000000000000000717171FF0000
      0000000000000000000000000000000000000000000000000000717171FF7171
      71FF555555DE0101011F00000000000000000000000000000000000000000000
      0000717171FF0000000000000000000000000000000000000000000000007171
      71FF000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000229C02FF229C02FF229C02FF229C
      02FF229C02FF092801820002001F229C02FF0000000000000000000000000000
      000000000000000000000000000000000000717171FF00000000000000000000
      0000717171FF0000000000000000000000000000000000000000717171FF0000
      0000000000000000000000000000000000000000000000000000717171FF5555
      55DE0101011F0000000000000000000000000000000000000000000000000000
      0000717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF09280182229C02FF0000000000000000000000000000
      000000000000000000000000000000000000717171FF717171FF717171FF7171
      71FF717171FF0000000000000000000000000000000000000000646464F07171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF555555DE0101
      011F000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000001E8702ED229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF1E8902EF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000200000000100010000000000000100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000}
    DesignInfo = 1900672
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
          63653D227072657365727665223E2E426C75657B66696C6C3A23313137374437
          3B7D262331333B262331303B2623393B2E59656C6C6F777B66696C6C3A234646
          423131353B7D262331333B262331303B2623393B2E426C61636B7B66696C6C3A
          233732373237323B7D262331333B262331303B2623393B2E477265656E7B6669
          6C6C3A233033394332333B7D262331333B262331303B2623393B2E5265647B66
          696C6C3A234431314331433B7D262331333B262331303B2623393B2E7374307B
          6F7061636974793A302E37353B7D262331333B262331303B2623393B2E737431
          7B6F7061636974793A302E353B7D3C2F7374796C653E0D0A3C672069643D2250
          72696E74223E0D0A09093C706F6C79676F6E20636C6173733D22426C61636B22
          20706F696E74733D2231302C342032322C342032322C31322032342C31322032
          342C3220382C3220382C31322031302C3132202623393B222F3E0D0A09093C70
          61746820636C6173733D22426C61636B2220643D224D32382C3130682D327633
          63302C302E362D302E342C312D312C314837632D302E362C302D312D302E342D
          312D31762D334834632D312E312C302D322C302E392D322C3276313263302C31
          2E312C302E392C322C322C3268347634683136762D34683420202623393B2623
          393B63312E312C302C322D302E392C322D325631324333302C31302E392C3239
          2E312C31302C32382C31307A204D32322C323476327632483130762D32762D32
          762D346831325632347A222F3E0D0A093C2F673E0D0A3C2F7376673E0D0A}
        FileName = 'SVG Images\Icon Builder\Actions_Print.svg'
        Keywords = 'Icon Builder;Actions;Print'
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
          63653D227072657365727665223E2E426C61636B7B66696C6C3A233732373237
          323B7D262331333B262331303B2623393B2E59656C6C6F777B66696C6C3A2346
          46423131353B7D262331333B262331303B2623393B2E426C75657B66696C6C3A
          233131373744373B7D262331333B262331303B2623393B2E5265647B66696C6C
          3A234431314331433B7D262331333B262331303B2623393B2E57686974657B66
          696C6C3A234646464646463B7D262331333B262331303B2623393B2E47726565
          6E7B66696C6C3A233033394332333B7D262331333B262331303B2623393B2E73
          74307B66696C6C3A233732373237323B7D262331333B262331303B2623393B2E
          7374317B6F7061636974793A302E353B7D262331333B262331303B2623393B2E
          7374327B6F7061636974793A302E37353B7D3C2F7374796C653E0D0A3C672069
          643D2244656661756C745072696E746572223E0D0A09093C7061746820636C61
          73733D22426C61636B2220643D224D382C313648365636683876324838563136
          7A204D32362C3138763863302C312E312D302E392C322D322C32682D34763448
          36762D344832632D312E312C302D322D302E392D322D3256313663302D312E31
          2C302E392D322C322D326832763320202623393B2623393B63302C302E362C30
          2E342C312C312C314832367A204D31382C3232483876386831305632327A222F
          3E0D0A09093C7061746820636C6173733D22477265656E2220643D224D33312C
          30483137632D302E352C302D312C302E352D312C3176313463302C302E352C30
          2E352C312C312C3168313463302E352C302C312D302E352C312D315631433332
          2C302E352C33312E352C302C33312C307A204D33302C356C2D382C386C2D342D
          34563620202623393B2623393B6C342C346C382D3856357A222F3E0D0A093C2F
          673E0D0A3C2F7376673E0D0A}
        FileName = 'SVG Images\Outlook Inspired\DefaultPrinter.svg'
        Keywords = 'Outlook Inspired;DefaultPrinter'
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
          63653D227072657365727665223E2E426C61636B7B66696C6C3A233732373237
          323B7D262331333B262331303B2623393B2E59656C6C6F777B66696C6C3A2346
          46423131353B7D262331333B262331303B2623393B2E426C75657B66696C6C3A
          233131373744373B7D262331333B262331303B2623393B2E5265647B66696C6C
          3A234431314331433B7D262331333B262331303B2623393B2E57686974657B66
          696C6C3A234646464646463B7D262331333B262331303B2623393B2E47726565
          6E7B66696C6C3A233033394332333B7D262331333B262331303B2623393B2E73
          74307B66696C6C3A233732373237323B7D262331333B262331303B2623393B2E
          7374317B6F7061636974793A302E353B7D262331333B262331303B2623393B2E
          7374327B6F7061636974793A302E37353B7D3C2F7374796C653E0D0A3C672069
          643D22466178223E0D0A09093C7061746820636C6173733D22426C61636B2220
          643D224D31382C38682D3256326831307636682D325634682D3656387A204D38
          2C3236563863302D312E312D302E392D322D322D32483243302E392C362C302C
          362E392C302C3876313863302C312E312C302E392C322C322C32683420202623
          393B2623393B43372E312C32382C382C32372E312C382C32367A204D33322C38
          76313863302C312E312D302E392C322D322C32483132632D312E312C302D322D
          302E392D322D32563863302D312E312C302E392D322C322D326832763363302C
          302E362C302E342C312C312C3168313263302E362C302C312D302E342C312D31
          5636683220202623393B2623393B4333312E312C362C33322C362E392C33322C
          387A204D31382C3232682D32763268325632327A204D31382C3138682D327632
          68325631387A204D31382C3134682D32763268325631347A204D32322C323268
          2D32763268325632327A204D32322C3138682D32763268325631387A204D3232
          2C3134682D327632683220202623393B2623393B5631347A204D32362C323268
          2D32763268325632327A204D32362C3138682D32763268325631387A204D3236
          2C3134682D32763268325631347A222F3E0D0A093C2F673E0D0A3C2F7376673E
          0D0A}
        FileName = 'SVG Images\Outlook Inspired\Fax.svg'
        Keywords = 'Outlook Inspired;Fax'
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
          63653D227072657365727665223E2E426C61636B7B66696C6C3A233732373237
          323B7D262331333B262331303B2623393B2E426C75657B66696C6C3A23313137
          3744373B7D3C2F7374796C653E0D0A3C7061746820636C6173733D22426C6163
          6B2220643D224D31382C32384C31382C32384C31382C3238222F3E0D0A3C7061
          746820636C6173733D22426C61636B2220643D224D32312E342C32384831386C
          302C306C302C3048365634683134763563302C302E362C302E342C312C312C31
          68357631332E346C322C3256396C2D372D37483543342E342C322C342C322E34
          2C342C3376323663302C302E362C302E342C312C312C316831382E3420202623
          393B4C32312E342C32387A222F3E0D0A3C7061746820636C6173733D22426C75
          652220643D224D32392C32396C2D352E392D352E3963302E362D302E392C302E
          392D322C302E392D332E3163302D332E332D322E372D362D362D36632D302E39
          2C302D312E372C302E322D322E352C302E356C342C3463302E382C302E382C30
          2E382C322E322C302C3320202623393B732D322E322C302E382D332C306C2D34
          2D344331322E322C31382E332C31322C31392E312C31322C323063302C332E33
          2C322E372C362C362C3663312E312C302C322E322D302E332C332E312D302E39
          4C32372C333163302E362C302E362C312E342C302E362C322C3020202623393B
          4332392E362C33302E342C32392E362C32392E362C32392C32397A222F3E0D0A
          3C2F7376673E0D0A}
        FileName = 'SVG Images\XAF\Action_Printing_PageSetup.svg'
        Keywords = 'XAF;Action;Printing;PageSetup'
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
          63653D227072657365727665223E2E59656C6C6F777B66696C6C3A2346464231
          31353B7D262331333B262331303B2623393B2E5265647B66696C6C3A23443131
          4331433B7D262331333B262331303B2623393B2E426C61636B7B66696C6C3A23
          3732373237323B7D262331333B262331303B2623393B2E426C75657B66696C6C
          3A233131373744373B7D262331333B262331303B2623393B2E57686974657B66
          696C6C3A234646464646463B7D262331333B262331303B2623393B2E47726565
          6E7B66696C6C3A233033394332333B7D262331333B262331303B2623393B2E73
          74307B6F7061636974793A302E37353B7D262331333B262331303B2623393B2E
          7374317B6F7061636974793A302E353B7D262331333B262331303B2623393B2E
          7374327B6F7061636974793A302E32353B7D262331333B262331303B2623393B
          2E7374337B66696C6C3A234646423131353B7D3C2F7374796C653E0D0A3C6720
          69643D2245646974436F6C6F7273223E0D0A09093C7061746820636C6173733D
          22426C61636B2220643D224D32392C30483143302E352C302C302C302E352C30
          2C3176323863302C302E352C302E352C312C312C3168323863302E352C302C31
          2D302E352C312D3156314333302C302E352C32392E352C302C32392C307A204D
          32382C3238483256326832365632387A222F3E0D0A09093C7061746820636C61
          73733D2259656C6C6F772220643D224D31302C31304834563468365631307A20
          4D31382C34682D367636683656347A204D31302C31324834763668365631327A
          222F3E0D0A09093C7061746820636C6173733D22477265656E2220643D224D31
          302C32364834762D3668365632367A204D31382C3132682D3676366836563132
          7A222F3E0D0A09093C7061746820636C6173733D225265642220643D224D3236
          2C3130682D36563468365631307A204D32362C3132682D36763668365631327A
          222F3E0D0A09093C7061746820636C6173733D22426C75652220643D224D3236
          2C3236682D36762D3668365632367A204D31382C3230682D3676366836563230
          7A222F3E0D0A09093C6720636C6173733D22737431223E0D0A0909093C726563
          7420783D22342220793D2231322220636C6173733D22477265656E2220776964
          74683D223622206865696768743D2236222F3E0D0A0909093C7061746820636C
          6173733D225265642220643D224D31382C3130682D36563468365631307A204D
          32362C3230682D36763668365632307A222F3E0D0A0909093C7061746820636C
          6173733D22426C75652220643D224D32362C3138682D36762D3668365631387A
          204D31382C3132682D36763668365631327A222F3E0D0A09093C2F673E0D0A09
          093C6720636C6173733D22737431223E0D0A0909093C7265637420783D223230
          2220793D2232302220636C6173733D22426C7565222077696474683D22362220
          6865696768743D2236222F3E0D0A09093C2F673E0D0A093C2F673E0D0A3C2F73
          76673E0D0A}
        FileName = 'SVG Images\Dashboards\EditColors.svg'
        Keywords = 'Dashboards;EditColors'
      end>
  end
  object dxLayoutLookAndFeelList1: TdxLayoutLookAndFeelList
    Left = 384
    Top = 65520
    object dxLayoutCxLookAndFeel1: TdxLayoutCxLookAndFeel
      PixelsPerInch = 96
    end
    object dxLayoutCxLookAndFeel_InfoBk: TdxLayoutStandardLookAndFeel
      GroupOptions.Color = clInfoBk
      ItemOptions.CaptionOptions.Font.Charset = DEFAULT_CHARSET
      ItemOptions.CaptionOptions.Font.Color = clWindowText
      ItemOptions.CaptionOptions.Font.Height = -12
      ItemOptions.CaptionOptions.Font.Name = 'Tahoma'
      ItemOptions.CaptionOptions.Font.Style = []
      ItemOptions.CaptionOptions.UseDefaultFont = False
      PixelsPerInch = 96
    end
  end
end
