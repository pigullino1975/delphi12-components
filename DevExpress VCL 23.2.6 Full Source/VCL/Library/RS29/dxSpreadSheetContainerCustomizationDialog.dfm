object dxSpreadSheetContainerCustomizationDialogForm: TdxSpreadSheetContainerCustomizationDialogForm
  Left = 0
  Top = 0
  AutoSize = True
  BorderStyle = bsDialog
  Caption = 'Customize Object'
  ClientHeight = 500
  ClientWidth = 440
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lcMain: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 440
    Height = 500
    TabOrder = 0
    AutoSize = True
    LayoutLookAndFeel = dxLayoutCxLookAndFeel1
    object btnOK: TcxButton
      Left = 264
      Top = 465
      Width = 80
      Height = 25
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 54
    end
    object btnCancel: TcxButton
      Left = 350
      Top = 465
      Width = 80
      Height = 25
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 55
    end
    object rbNoFill: TcxRadioButton
      Left = 10000
      Top = 10000
      Caption = '&No fill'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 20
      Visible = False
      OnClick = rbTextureFillClick
      AutoSize = True
      ParentBackground = False
      Transparent = True
    end
    object rbSolidFill: TcxRadioButton
      Left = 10000
      Top = 10000
      Caption = '&Solid fill'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 21
      Visible = False
      OnClick = rbTextureFillClick
      AutoSize = True
      ParentBackground = False
      Transparent = True
    end
    object rbGradientFill: TcxRadioButton
      Left = 10000
      Top = 10000
      Caption = '&Gradient fill'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 22
      Visible = False
      OnClick = rbTextureFillClick
      AutoSize = True
      ParentBackground = False
      Transparent = True
    end
    object rbTextureFill: TcxRadioButton
      Left = 10000
      Top = 10000
      Caption = '&Texture fill'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 23
      Visible = False
      OnClick = rbTextureFillClick
      AutoSize = True
      ParentBackground = False
      Transparent = True
    end
    object btnSolidFillColor: TcxButton
      Left = 10000
      Top = 10000
      Width = 75
      Height = 26
      Caption = '&Color'
      OptionsImage.Spacing = 8
      TabOrder = 24
      Visible = False
      OnClick = btnColorClick
    end
    object imTextureFill: TcxImage
      Left = 10000
      Top = 10000
      Properties.PopupMenuLayout.MenuItems = []
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 29
      Visible = False
      Height = 144
      Width = 446
    end
    object btnTextureFillSave: TcxButton
      Left = 10000
      Top = 10000
      Width = 75
      Height = 26
      Action = acTextureFillSave
      TabOrder = 31
      Visible = False
    end
    object btnTextureFillLoad: TcxButton
      Left = 10000
      Top = 10000
      Width = 75
      Height = 26
      Action = acTextureFillLoad
      TabOrder = 30
      Visible = False
    end
    object ccbGradientFillDirection: TcxComboBox
      Left = 10000
      Top = 10000
      Properties.DropDownListStyle = lsFixedList
      Style.TransparentBorder = False
      TabOrder = 25
      Visible = False
      Width = 192
    end
    object btnGradientFillColor: TcxButton
      Left = 10000
      Top = 10000
      Width = 75
      Height = 26
      Caption = '&Color'
      Enabled = False
      OptionsImage.Spacing = 8
      TabOrder = 26
      Visible = False
      OnClick = btnGradientFillColorClick
    end
    object btnGradientFillAddStop: TcxButton
      Left = 10000
      Top = 10000
      Width = 75
      Height = 26
      Caption = '&Add'
      OptionsImage.Layout = blGlyphTop
      TabOrder = 27
      Visible = False
      OnClick = btnGradientFillAddStopClick
    end
    object btnGradientFillRemoveStop: TcxButton
      Left = 10000
      Top = 10000
      Width = 75
      Height = 26
      Caption = 'Remo&ve'
      Enabled = False
      OptionsImage.Layout = blGlyphTop
      TabOrder = 28
      Visible = False
      OnClick = btnGradientFillRemoveStopClick
    end
    object rbNoLine: TcxRadioButton
      Left = 10000
      Top = 10000
      Caption = '&No line'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 32
      Visible = False
      OnClick = rbGradientLineClick
      AutoSize = True
      GroupIndex = 1
      ParentBackground = False
      Transparent = True
    end
    object rbSolidLine: TcxRadioButton
      Left = 10000
      Top = 10000
      Caption = '&Solid line'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 33
      Visible = False
      OnClick = rbGradientLineClick
      AutoSize = True
      GroupIndex = 1
      ParentBackground = False
      Transparent = True
    end
    object rbGradientLine: TcxRadioButton
      Left = 10000
      Top = 10000
      Caption = '&Gradient line'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 34
      Visible = False
      OnClick = rbGradientLineClick
      AutoSize = True
      GroupIndex = 1
      ParentBackground = False
      Transparent = True
    end
    object btnSolidLineColor: TcxButton
      Left = 10000
      Top = 10000
      Width = 75
      Height = 26
      Caption = '&Color'
      OptionsImage.Spacing = 8
      TabOrder = 37
      Visible = False
      OnClick = btnColorClick
    end
    object ccbLineStyle: TcxComboBox
      Left = 10000
      Top = 10000
      Properties.DropDownListStyle = lsFixedList
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 35
      Visible = False
      Width = 140
    end
    object ceLineWidth: TcxSpinEdit
      Left = 10000
      Top = 10000
      Properties.AssignedValues.MinValue = True
      Properties.ValueType = vtFloat
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 36
      Visible = False
      Width = 140
    end
    object btnGradientLineColor: TcxButton
      Left = 10000
      Top = 10000
      Width = 75
      Height = 26
      Caption = '&Color'
      Enabled = False
      OptionsImage.Spacing = 8
      TabOrder = 39
      Visible = False
      OnClick = btnGradientLineColorClick
    end
    object btnGradientLineAddStop: TcxButton
      Left = 10000
      Top = 10000
      Width = 75
      Height = 26
      Caption = '&Add'
      OptionsImage.Spacing = 8
      TabOrder = 40
      Visible = False
      OnClick = btnGradientLineAddStopClick
    end
    object btnGradientLineRemoveStop: TcxButton
      Left = 10000
      Top = 10000
      Width = 75
      Height = 26
      Caption = 'Remo&ve'
      Enabled = False
      OptionsImage.Spacing = 8
      TabOrder = 41
      Visible = False
      OnClick = btnGradientLineRemoveStopClick
    end
    object ccbGradientLineDirection: TcxComboBox
      Left = 10000
      Top = 10000
      Properties.DropDownListStyle = lsFixedList
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 38
      Visible = False
      Width = 140
    end
    object lbSizeAndRotate: TcxLabel
      Left = 24
      Top = 44
      AutoSize = False
      Caption = 'Size and rotate'
      Style.HotTrack = False
      Style.TransparentBorder = False
      Properties.Alignment.Vert = taVCenter
      Properties.LineOptions.Visible = True
      Transparent = True
      Height = 13
      Width = 73
      AnchorY = 51
    end
    object seHeight: TcxSpinEdit
      Left = 90
      Top = 63
      Properties.AssignedValues.MinValue = True
      Properties.ImmediatePost = True
      Properties.OnChange = seHeightPropertiesChange
      Style.HotTrack = False
      TabOrder = 1
      Width = 75
    end
    object seRotation: TcxSpinEdit
      Left = 90
      Top = 90
      Properties.DisplayFormat = '0.##### '#176
      Properties.ImmediatePost = True
      Properties.ValueType = vtFloat
      Style.HotTrack = False
      TabOrder = 2
      Width = 75
    end
    object seWidth: TcxSpinEdit
      Left = 214
      Top = 63
      Properties.AssignedValues.MinValue = True
      Properties.ImmediatePost = True
      Properties.OnChange = seWidthPropertiesChange
      Style.HotTrack = False
      TabOrder = 3
      Width = 75
    end
    object lbPosition: TcxLabel
      Left = 10000
      Top = 10000
      AutoSize = False
      Caption = 'Positioning'
      Style.HotTrack = False
      Style.TransparentBorder = False
      Properties.Alignment.Vert = taVCenter
      Properties.LineOptions.Visible = True
      Transparent = True
      Visible = False
      Height = 13
      Width = 51
      AnchorY = 10007
    end
    object rbTwoCells: TcxRadioButton
      Left = 10000
      Top = 10000
      Caption = 'Move and &size with cells'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 17
      Visible = False
      AutoSize = True
      GroupIndex = 2
      ParentBackground = False
      Transparent = True
    end
    object rbOneCell: TcxRadioButton
      Left = 10000
      Top = 10000
      Caption = '&Move but don'#39't size with cells'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 18
      Visible = False
      AutoSize = True
      GroupIndex = 2
      ParentBackground = False
      Transparent = True
    end
    object rbAbsolute: TcxRadioButton
      Left = 10000
      Top = 10000
      Caption = '&Don'#39't move or size with cells'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 19
      Visible = False
      AutoSize = True
      GroupIndex = 2
      ParentBackground = False
      Transparent = True
    end
    object lbScale: TcxLabel
      Left = 24
      Top = 117
      AutoSize = False
      Caption = 'Scale'
      Style.HotTrack = False
      Style.TransparentBorder = False
      Properties.Alignment.Vert = taVCenter
      Properties.LineOptions.Visible = True
      Transparent = True
      Height = 13
      Width = 25
      AnchorY = 124
    end
    object seScaleHeight: TcxSpinEdit
      Left = 90
      Top = 136
      Properties.AssignedValues.MinValue = True
      Properties.DisplayFormat = '0 %'
      Properties.ImmediatePost = True
      Properties.OnChange = seScaleHeightPropertiesChange
      Style.HotTrack = False
      TabOrder = 5
      Width = 75
    end
    object seScaleWidth: TcxSpinEdit
      Left = 214
      Top = 136
      Properties.AssignedValues.MinValue = True
      Properties.DisplayFormat = '0 %'
      Properties.ImmediatePost = True
      Properties.OnChange = seScaleWidthPropertiesChange
      Style.HotTrack = False
      TabOrder = 6
      Width = 75
    end
    object cbLockAspectRatio: TcxCheckBox
      Left = 40
      Top = 163
      Caption = 'Lock &aspect ratio'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 7
      Transparent = True
      OnClick = cbLockAspectRatioClick
    end
    object cbRelativeToPictureSize: TcxCheckBox
      Left = 40
      Top = 186
      Caption = '&Relative to original picture size'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 8
      Transparent = True
      OnClick = cbRelativeToPictureSizeClick
    end
    object lbOriginalSize: TcxLabel
      Left = 24
      Top = 282
      AutoSize = False
      Caption = 'Original size'
      Style.HotTrack = False
      Style.TransparentBorder = False
      Properties.Alignment.Vert = taVCenter
      Properties.LineOptions.Visible = True
      Transparent = True
      Height = 13
      Width = 57
      AnchorY = 289
    end
    object lbCrop: TcxLabel
      Left = 24
      Top = 209
      AutoSize = False
      Caption = 'Crop from'
      Style.HotTrack = False
      Style.TransparentBorder = False
      Properties.Alignment.Vert = taVCenter
      Properties.LineOptions.Visible = True
      Transparent = True
      Height = 13
      Width = 48
      AnchorY = 216
    end
    object seCropLeft: TcxSpinEdit
      Left = 90
      Top = 228
      Properties.ImmediatePost = True
      Properties.OnChange = seCropHorzPropertiesChange
      Style.HotTrack = False
      TabOrder = 10
      Width = 75
    end
    object seCropRight: TcxSpinEdit
      Left = 90
      Top = 255
      Properties.ImmediatePost = True
      Properties.OnChange = seCropHorzPropertiesChange
      Style.HotTrack = False
      TabOrder = 11
      Width = 75
    end
    object seCropTop: TcxSpinEdit
      Left = 214
      Top = 228
      Properties.ImmediatePost = True
      Properties.OnChange = seCropVertPropertiesChange
      Style.HotTrack = False
      TabOrder = 12
      Width = 75
    end
    object seCropBottom: TcxSpinEdit
      Left = 214
      Top = 255
      Properties.ImmediatePost = True
      Properties.OnChange = seCropVertPropertiesChange
      Style.HotTrack = False
      TabOrder = 13
      Width = 75
    end
    object btnReset: TcxButton
      Left = 40
      Top = 321
      Width = 75
      Height = 25
      Caption = 'Re&set'
      TabOrder = 15
      OnClick = btnResetClick
    end
    object lbTextAlignment: TcxLabel
      Left = 10000
      Top = 10002
      AutoSize = False
      Caption = 'Alignment'
      Style.HotTrack = False
      Style.TransparentBorder = False
      Properties.Alignment.Vert = taVCenter
      Properties.LineOptions.Visible = True
      Transparent = True
      Visible = False
      Height = 13
      Width = 47
      AnchorY = 10009
    end
    object cbTextBoxHorzAlign: TcxComboBox
      Left = 10000
      Top = 10000
      Properties.DropDownListStyle = lsFixedList
      Style.HotTrack = False
      TabOrder = 45
      Visible = False
      Width = 85
    end
    object cbTextBoxVertAlign: TcxComboBox
      Left = 10000
      Top = 10000
      Properties.DropDownListStyle = lsFixedList
      Style.HotTrack = False
      TabOrder = 46
      Visible = False
      Width = 85
    end
    object lbTextPadding: TcxLabel
      Left = 10000
      Top = 10002
      AutoSize = False
      Caption = 'Padding'
      Style.HotTrack = False
      Style.TransparentBorder = False
      Properties.Alignment.Vert = taVCenter
      Properties.LineOptions.Visible = True
      Transparent = True
      Visible = False
      Height = 13
      Width = 38
      AnchorY = 10009
    end
    object seTextPaddingLeft: TcxSpinEdit
      Left = 10000
      Top = 10000
      Properties.AssignedValues.MinValue = True
      Properties.ImmediatePost = True
      Style.HotTrack = False
      TabOrder = 48
      Visible = False
      Width = 85
    end
    object seTextPaddingRight: TcxSpinEdit
      Left = 10000
      Top = 10000
      Properties.AssignedValues.MinValue = True
      Properties.ImmediatePost = True
      Style.HotTrack = False
      TabOrder = 49
      Visible = False
      Width = 85
    end
    object seTextPaddingTop: TcxSpinEdit
      Left = 10000
      Top = 10000
      Properties.AssignedValues.MinValue = True
      Properties.ImmediatePost = True
      Style.HotTrack = False
      TabOrder = 50
      Visible = False
      Width = 85
    end
    object seTextPaddingBottom: TcxSpinEdit
      Left = 10000
      Top = 10000
      Properties.AssignedValues.MinValue = True
      Properties.ImmediatePost = True
      Style.HotTrack = False
      TabOrder = 51
      Visible = False
      Width = 85
    end
    object cbTextBoxAutoSize: TcxCheckBox
      Left = 10000
      Top = 10000
      Caption = 'cbTextBoxAutoSize'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 52
      Transparent = True
      Visible = False
    end
    object cbTextBoxWordWrap: TcxCheckBox
      Left = 10000
      Top = 10000
      Caption = 'cbTextBoxWordWrap'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 53
      Transparent = True
      Visible = False
    end
    object meText: TcxMemo
      Left = 10000
      Top = 10000
      Lines.Strings = (
        'meText')
      Properties.ScrollBars = ssVertical
      Style.HotTrack = False
      TabOrder = 42
      Visible = False
      Height = 356
      Width = 527
    end
    object btnTextFont: TcxButton
      Left = 10000
      Top = 10000
      Width = 80
      Height = 25
      Caption = 'btnFont'
      TabOrder = 43
      Visible = False
      OnClick = btnTextFontClick
    end
    object lcMainGroup_Root: TdxLayoutGroup
      AlignHorz = ahParentManaged
      AlignVert = avParentManaged
      CaptionOptions.Visible = False
      Hidden = True
      ShowBorder = False
      Index = -1
    end
    object lcMainItem2: TdxLayoutItem
      Parent = lcMainGroup2
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = btnOK
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 80
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lcMainItem1: TdxLayoutItem
      Parent = lcMainGroup2
      CaptionOptions.Text = 'btnCancel'
      CaptionOptions.Visible = False
      Control = btnCancel
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 80
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lcgTabs: TdxLayoutGroup
      Parent = lcMainGroup_Root
      AlignVert = avClient
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      LayoutDirection = ldTabbed
      ShowBorder = False
      TabbedOptions.ShowFrame = True
      Index = 0
    end
    object lcMainGroup2: TdxLayoutAutoCreatedGroup
      Parent = lcMainGroup_Root
      AlignHorz = ahRight
      LayoutDirection = ldHorizontal
      Index = 1
    end
    object lcgFill: TdxLayoutGroup
      Parent = lcgTabs
      CaptionOptions.Text = 'Fill'
      ItemIndex = 5
      Index = 2
    end
    object lcgLine: TdxLayoutGroup
      Parent = lcgTabs
      CaptionOptions.Text = 'Line'
      ItemIndex = 4
      Index = 3
    end
    object lcMainItem3: TdxLayoutItem
      Parent = lcgFill
      CaptionOptions.Visible = False
      Control = rbNoFill
      ControlOptions.AlignHorz = ahLeft
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 51
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lcMainItem4: TdxLayoutItem
      Parent = lcgFill
      CaptionOptions.Visible = False
      Control = rbSolidFill
      ControlOptions.AlignHorz = ahLeft
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 60
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lcMainItem5: TdxLayoutItem
      Parent = lcgFill
      CaptionOptions.Visible = False
      Control = rbGradientFill
      ControlOptions.AlignHorz = ahLeft
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 79
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object lcMainItem6: TdxLayoutItem
      Parent = lcgFill
      CaptionOptions.Visible = False
      Control = rbTextureFill
      ControlOptions.AlignHorz = ahLeft
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 76
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object lcgSolidFill: TdxLayoutItem
      Parent = lcMainGroup3
      AlignHorz = ahLeft
      Control = btnSolidFillColor
      ControlOptions.OriginalHeight = 26
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lcMainGroup3: TdxLayoutGroup
      Parent = lcgFill
      AlignVert = avClient
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      ShowBorder = False
      Index = 5
    end
    object lcMainItem7: TdxLayoutItem
      Parent = lcgTextureFill
      AlignHorz = ahClient
      AlignVert = avClient
      Control = imTextureFill
      ControlOptions.OriginalHeight = 200
      ControlOptions.OriginalWidth = 200
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lcMainItem8: TdxLayoutItem
      Parent = lcMainGroup5
      CaptionOptions.Visible = False
      Control = btnTextureFillSave
      ControlOptions.OriginalHeight = 26
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lcgTextureFill: TdxLayoutAutoCreatedGroup
      Parent = lcMainGroup3
      AlignVert = avClient
      LayoutDirection = ldHorizontal
      Index = 2
    end
    object lcMainGroup5: TdxLayoutAutoCreatedGroup
      Parent = lcgTextureFill
      Index = 1
    end
    object lcMainItem10: TdxLayoutItem
      Parent = lcMainGroup5
      CaptionOptions.Visible = False
      Control = btnTextureFillLoad
      ControlOptions.OriginalHeight = 26
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lcgGradientFill: TdxLayoutGroup
      Parent = lcMainGroup3
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      ItemIndex = 2
      ShowBorder = False
      Index = 1
    end
    object lciGradientFillDirection: TdxLayoutItem
      Parent = lcgGradientFill
      AlignHorz = ahLeft
      CaptionOptions.Text = '&Direction:'
      CaptionOptions.Layout = clTop
      Control = ccbGradientFillDirection
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 192
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lciGradientFillStops: TdxLayoutItem
      Parent = lcgGradientFill
      CaptionOptions.Text = '&Stops:'
      CaptionOptions.Layout = clTop
      ControlOptions.AutoColor = True
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lcMainGroup6: TdxLayoutAutoCreatedGroup
      Parent = lcgGradientFill
      AlignHorz = ahClient
      LayoutDirection = ldHorizontal
      Index = 2
    end
    object lcMainItem13: TdxLayoutItem
      Parent = lcMainGroup6
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = btnGradientFillColor
      ControlOptions.OriginalHeight = 26
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Enabled = False
      Index = 0
    end
    object lcMainItem12: TdxLayoutItem
      Parent = lcMainGroup7
      AlignHorz = ahClient
      AllowRemove = False
      CaptionOptions.Visible = False
      Control = btnGradientFillAddStop
      ControlOptions.OriginalHeight = 26
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lcMainItem14: TdxLayoutItem
      Parent = lcMainGroup7
      AlignHorz = ahClient
      CaptionOptions.Visible = False
      Control = btnGradientFillRemoveStop
      ControlOptions.OriginalHeight = 26
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Enabled = False
      Index = 1
    end
    object lcMainGroup7: TdxLayoutGroup
      Parent = lcMainGroup6
      AlignHorz = ahRight
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 1
    end
    object lcMainSeparatorItem1: TdxLayoutSeparatorItem
      Parent = lcgFill
      SizeOptions.AssignedValues = [sovSizableHorz, sovSizableVert]
      SizeOptions.SizableHorz = False
      SizeOptions.SizableVert = False
      Index = 4
    end
    object lciPenNoLine: TdxLayoutItem
      Parent = lciLinePenStyle
      CaptionOptions.Visible = False
      Control = rbNoLine
      ControlOptions.AlignHorz = ahLeft
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 57
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lciPenSolidLine: TdxLayoutItem
      Parent = lciLinePenStyle
      CaptionOptions.Visible = False
      Control = rbSolidLine
      ControlOptions.AlignHorz = ahLeft
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 66
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lciPenGradientLine: TdxLayoutItem
      Parent = lciLinePenStyle
      CaptionOptions.Visible = False
      Control = rbGradientLine
      ControlOptions.AlignHorz = ahLeft
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 85
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object lcMainSeparatorItem2: TdxLayoutSeparatorItem
      Parent = lciLinePenStyle
      SizeOptions.AssignedValues = [sovSizableHorz, sovSizableVert]
      SizeOptions.SizableHorz = False
      SizeOptions.SizableVert = False
      CaptionOptions.Text = 'Separator'
      Index = 3
    end
    object lcgSolidLine: TdxLayoutItem
      Parent = lcgLine
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = btnSolidLineColor
      ControlOptions.OriginalHeight = 26
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object lciLineStyle: TdxLayoutItem
      Parent = lcgLine
      AlignHorz = ahLeft
      CaptionOptions.Text = '&Style:'
      CaptionOptions.Layout = clTop
      Control = ccbLineStyle
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 140
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lciLineWidth: TdxLayoutItem
      Parent = lcgLine
      AlignHorz = ahLeft
      CaptionOptions.Text = '&Width:'
      CaptionOptions.Layout = clTop
      Control = ceLineWidth
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 140
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object lcgGradientLine: TdxLayoutGroup
      Parent = lcgLine
      AlignHorz = ahClient
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      ItemIndex = 2
      ShowBorder = False
      Index = 4
    end
    object lciGradientLineStops: TdxLayoutItem
      Parent = lcgGradientLine
      CaptionOptions.Text = '&Stops:'
      CaptionOptions.Layout = clTop
      ControlOptions.AutoColor = True
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lcMainGroup4: TdxLayoutAutoCreatedGroup
      Parent = lcgGradientLine
      LayoutDirection = ldHorizontal
      Index = 2
    end
    object lcMainItem16: TdxLayoutItem
      Parent = lcMainGroup4
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = btnGradientLineColor
      ControlOptions.OriginalHeight = 26
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Enabled = False
      Index = 0
    end
    object lcMainGroup8: TdxLayoutGroup
      Parent = lcMainGroup4
      AlignHorz = ahRight
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 1
    end
    object lcMainItem18: TdxLayoutItem
      Parent = lcMainGroup8
      CaptionOptions.Visible = False
      Control = btnGradientLineAddStop
      ControlOptions.OriginalHeight = 26
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lcMainItem19: TdxLayoutItem
      Parent = lcMainGroup8
      CaptionOptions.Visible = False
      Control = btnGradientLineRemoveStop
      ControlOptions.OriginalHeight = 26
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Enabled = False
      Index = 1
    end
    object lciGradientLineDirection: TdxLayoutItem
      Parent = lcgGradientLine
      AlignHorz = ahLeft
      CaptionOptions.Text = '&Direction:'
      CaptionOptions.Layout = clTop
      Control = ccbGradientLineDirection
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 140
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lcgSize: TdxLayoutGroup
      Parent = lcgTabs
      CaptionOptions.Text = 'Size'
      ItemIndex = 6
      Index = 0
    end
    object lcMainItem23: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup2
      AlignHorz = ahLeft
      CaptionOptions.Text = 'lbSizeAndRotate'
      CaptionOptions.Visible = False
      Control = lbSizeAndRotate
      ControlOptions.OriginalHeight = 13
      ControlOptions.OriginalWidth = 73
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lcMainGroup11: TdxLayoutGroup
      Parent = lcgSize
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      Offsets.Left = 16
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 1
    end
    object lcMainGroup10: TdxLayoutAutoCreatedGroup
      Parent = lcMainGroup11
      AlignHorz = ahLeft
      Index = 0
    end
    object lciHeight: TdxLayoutItem
      Parent = lcMainGroup10
      AlignHorz = ahLeft
      CaptionOptions.Text = 'H&eight:'
      Control = seHeight
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lciRotation: TdxLayoutItem
      Parent = lcMainGroup10
      AlignHorz = ahLeft
      CaptionOptions.Text = 'Ro&tation:'
      Control = seRotation
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lciWidth: TdxLayoutItem
      Parent = lcMainGroup11
      AlignHorz = ahLeft
      CaptionOptions.Text = 'Wi&dth'
      Control = seWidth
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lcgProperties: TdxLayoutGroup
      Parent = lcgTabs
      CaptionOptions.Text = 'Properties'
      Index = 1
    end
    object lcMainItem17: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup1
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Text = 'lbPosition'
      CaptionOptions.Visible = False
      Control = lbPosition
      ControlOptions.OriginalHeight = 13
      ControlOptions.OriginalWidth = 51
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lcMainGroup9: TdxLayoutGroup
      Parent = lcgProperties
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      Offsets.Left = 16
      ShowBorder = False
      Index = 1
    end
    object lcMainItem20: TdxLayoutItem
      Parent = lcMainGroup9
      CaptionOptions.Text = 'rbTwoCells'
      CaptionOptions.Visible = False
      Control = rbTwoCells
      ControlOptions.AlignHorz = ahLeft
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 139
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lcMainItem21: TdxLayoutItem
      Parent = lcMainGroup9
      CaptionOptions.Text = 'rbOneCell'
      CaptionOptions.Visible = False
      Control = rbOneCell
      ControlOptions.AlignHorz = ahLeft
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 164
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lcMainItem22: TdxLayoutItem
      Parent = lcMainGroup9
      CaptionOptions.Text = 'rbAbsolute'
      CaptionOptions.Visible = False
      Control = rbAbsolute
      ControlOptions.AlignHorz = ahLeft
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 159
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object lcMainItem24: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup3
      AlignHorz = ahLeft
      CaptionOptions.Text = 'cxLabel1'
      CaptionOptions.Visible = False
      Control = lbScale
      ControlOptions.OriginalHeight = 13
      ControlOptions.OriginalWidth = 25
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lcMainGroup13: TdxLayoutGroup
      Parent = lcgSize
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      Offsets.Left = 16
      ShowBorder = False
      Index = 3
    end
    object lcMainGroup12: TdxLayoutAutoCreatedGroup
      Parent = lcMainGroup13
      LayoutDirection = ldHorizontal
      Index = 0
    end
    object lciScaleHeight: TdxLayoutItem
      Parent = lcMainGroup12
      AlignHorz = ahLeft
      CaptionOptions.Text = '&Height:'
      Control = seScaleHeight
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lciScaleWidth: TdxLayoutItem
      Parent = lcMainGroup12
      CaptionOptions.Text = '&Width:'
      Control = seScaleWidth
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lcMainItem27: TdxLayoutItem
      Parent = lcMainGroup13
      CaptionOptions.Text = 'cxCheckBox1'
      CaptionOptions.Visible = False
      Control = cbLockAspectRatio
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lciRelativeToPictureSize: TdxLayoutItem
      Parent = lcMainGroup13
      CaptionOptions.Text = 'cxCheckBox1'
      CaptionOptions.Visible = False
      Control = cbRelativeToPictureSize
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object lciOriginalSize: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup5
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = lbOriginalSize
      ControlOptions.OriginalHeight = 13
      ControlOptions.OriginalWidth = 57
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lciCrop: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup4
      AlignHorz = ahLeft
      CaptionOptions.Text = 'lbCrop'
      CaptionOptions.Visible = False
      Control = lbCrop
      ControlOptions.OriginalHeight = 13
      ControlOptions.OriginalWidth = 48
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lcgCrop: TdxLayoutGroup
      Parent = lcgSize
      CaptionOptions.Text = 'New Group'
      Offsets.Left = 16
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 5
    end
    object lcMainGroup14: TdxLayoutAutoCreatedGroup
      Parent = lcgCrop
      AlignHorz = ahLeft
      Index = 0
    end
    object lciCropLeft: TdxLayoutItem
      Parent = lcMainGroup14
      AlignHorz = ahLeft
      CaptionOptions.Text = '&Left:'
      Control = seCropLeft
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lciCropRight: TdxLayoutItem
      Parent = lcMainGroup14
      CaptionOptions.Text = 'Ri&ght:'
      Control = seCropRight
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lcMainGroup15: TdxLayoutAutoCreatedGroup
      Parent = lcgCrop
      Index = 1
    end
    object lciCropTop: TdxLayoutItem
      Parent = lcMainGroup15
      CaptionOptions.Text = 'To&p:'
      Control = seCropTop
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lciCropBottom: TdxLayoutItem
      Parent = lcMainGroup15
      CaptionOptions.Text = 'Botto&m:'
      Control = seCropBottom
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lcgOriginalSize: TdxLayoutGroup
      Parent = lcgSize
      Offsets.Left = 16
      ShowBorder = False
      Index = 7
    end
    object lclOriginalSize: TdxLayoutLabeledItem
      Parent = lcgOriginalSize
      CaptionOptions.Text = 'Height: / Width'
      Index = 0
    end
    object lcMainItem25: TdxLayoutItem
      Parent = lcgOriginalSize
      AlignHorz = ahLeft
      CaptionOptions.Text = 'cxButton1'
      CaptionOptions.Visible = False
      Control = btnReset
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lcgTextBox: TdxLayoutGroup
      Parent = lcgTabs
      CaptionOptions.Text = 'Text Box'
      ItemIndex = 2
      Index = 5
    end
    object lcMainItem26: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup6
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Visible = False
      Control = lbTextAlignment
      ControlOptions.OriginalHeight = 13
      ControlOptions.OriginalWidth = 47
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lciTextBoxHorzAlign: TdxLayoutItem
      Parent = lcMainGroup19
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Text = 'lciTextBoxHorzAlign'
      Control = cbTextBoxHorzAlign
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 85
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lciTextBoxVertAlign: TdxLayoutItem
      Parent = lcMainGroup19
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Text = 'lciTextBoxVertAlign'
      Control = cbTextBoxVertAlign
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 85
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lcMainGroup19: TdxLayoutGroup
      Parent = lcgTextBox
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      Offsets.Left = 16
      ShowBorder = False
      Index = 1
    end
    object lcMainItem31: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup7
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Visible = False
      Control = lbTextPadding
      ControlOptions.OriginalHeight = 13
      ControlOptions.OriginalWidth = 38
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lcMainGroup18: TdxLayoutGroup
      Parent = lcgTextBox
      AlignVert = avTop
      CaptionOptions.Text = 'New Group'
      Offsets.Left = 16
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 3
    end
    object lcMainGroup16: TdxLayoutGroup
      Parent = lcMainGroup18
      AlignHorz = ahLeft
      CaptionOptions.Text = 'New Group'
      ShowBorder = False
      Index = 0
    end
    object lciTextPaddingLeft: TdxLayoutItem
      Parent = lcMainGroup16
      CaptionOptions.Text = '&Left:'
      Control = seTextPaddingLeft
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 85
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lciTextPaddingRight: TdxLayoutItem
      Parent = lcMainGroup16
      CaptionOptions.Text = 'Ri&ght:'
      Control = seTextPaddingRight
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lcMainGroup17: TdxLayoutGroup
      Parent = lcMainGroup18
      AlignHorz = ahLeft
      CaptionOptions.Text = 'New Group'
      ShowBorder = False
      Index = 1
    end
    object lciTextPaddingTop: TdxLayoutItem
      Parent = lcMainGroup17
      CaptionOptions.Text = 'To&p:'
      Control = seTextPaddingTop
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 85
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lciTextPaddingBottom: TdxLayoutItem
      Parent = lcMainGroup17
      CaptionOptions.Text = 'Botto&m:'
      Control = seTextPaddingBottom
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lcMainItem28: TdxLayoutItem
      Parent = lcgTextBox
      AlignVert = avTop
      CaptionOptions.Text = 'cxCheckBox1'
      CaptionOptions.Visible = False
      Control = cbTextBoxAutoSize
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 5
    end
    object lciTextBoxWordWrap: TdxLayoutItem
      Parent = lcgTextBox
      AlignVert = avTop
      CaptionOptions.Visible = False
      Control = cbTextBoxWordWrap
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 6
    end
    object lcgText: TdxLayoutGroup
      Parent = lcgTabs
      CaptionOptions.Text = 'Text'
      Index = 4
    end
    object lcMainItem33: TdxLayoutItem
      Parent = lcgText
      AlignHorz = ahClient
      AlignVert = avClient
      Control = meText
      ControlOptions.OriginalHeight = 89
      ControlOptions.OriginalWidth = 185
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lcMainItem34: TdxLayoutItem
      Parent = lcgText
      AlignHorz = ahRight
      CaptionOptions.Text = 'cxButton1'
      CaptionOptions.Visible = False
      Control = btnTextFont
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 80
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lcMainSeparatorItem3: TdxLayoutSeparatorItem
      Parent = lcgTextBox
      CaptionOptions.Text = 'Separator'
      Index = 4
    end
    object lciLinePenStyle: TdxLayoutGroup
      Parent = lcgLine
      CaptionOptions.Text = 'New Group'
      ShowBorder = False
      Index = 0
    end
    object dxLayoutSeparatorItem1: TdxLayoutSeparatorItem
      Parent = dxLayoutAutoCreatedGroup1
      AlignHorz = ahClient
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup
      Parent = lcgProperties
      AlignVert = avTop
      LayoutDirection = ldHorizontal
      Index = 0
    end
    object dxLayoutSeparatorItem2: TdxLayoutSeparatorItem
      Parent = dxLayoutAutoCreatedGroup2
      AlignHorz = ahClient
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object dxLayoutAutoCreatedGroup2: TdxLayoutAutoCreatedGroup
      Parent = lcgSize
      LayoutDirection = ldHorizontal
      Index = 0
    end
    object dxLayoutSeparatorItem3: TdxLayoutSeparatorItem
      Parent = dxLayoutAutoCreatedGroup3
      AlignHorz = ahClient
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object dxLayoutAutoCreatedGroup3: TdxLayoutAutoCreatedGroup
      Parent = lcgSize
      LayoutDirection = ldHorizontal
      Index = 2
    end
    object dxLayoutSeparatorItem4: TdxLayoutSeparatorItem
      Parent = dxLayoutAutoCreatedGroup4
      AlignHorz = ahClient
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object dxLayoutAutoCreatedGroup4: TdxLayoutAutoCreatedGroup
      Parent = lcgSize
      LayoutDirection = ldHorizontal
      Index = 4
    end
    object dxLayoutSeparatorItem5: TdxLayoutSeparatorItem
      Parent = dxLayoutAutoCreatedGroup5
      AlignHorz = ahClient
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object dxLayoutAutoCreatedGroup5: TdxLayoutAutoCreatedGroup
      Parent = lcgSize
      LayoutDirection = ldHorizontal
      Index = 6
    end
    object dxLayoutSeparatorItem6: TdxLayoutSeparatorItem
      Parent = dxLayoutAutoCreatedGroup6
      AlignHorz = ahClient
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object dxLayoutAutoCreatedGroup6: TdxLayoutAutoCreatedGroup
      Parent = lcgTextBox
      AlignVert = avTop
      LayoutDirection = ldHorizontal
      Index = 0
    end
    object dxLayoutSeparatorItem7: TdxLayoutSeparatorItem
      Parent = dxLayoutAutoCreatedGroup7
      AlignHorz = ahClient
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object dxLayoutAutoCreatedGroup7: TdxLayoutAutoCreatedGroup
      Parent = lcgTextBox
      AlignVert = avTop
      LayoutDirection = ldHorizontal
      Index = 2
    end
  end
  object dxLayoutLookAndFeelList1: TdxLayoutLookAndFeelList
    Left = 376
    object dxLayoutCxLookAndFeel1: TdxLayoutCxLookAndFeel
      PixelsPerInch = 96
    end
  end
  object TextureOpenDialog: TdxOpenFileDialog
    Left = 336
  end
  object TextureSaveDialog: TdxSaveFileDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 336
    Top = 32
  end
  object alActions: TActionList
    Left = 304
    object acTextureFillLoad: TAction
      Caption = '&Load'
      OnExecute = acTextureFillLoadExecute
    end
    object acTextureFillSave: TAction
      Caption = '&Save'
      OnExecute = acTextureFillSaveExecute
      OnUpdate = acTextureFillSaveUpdate
    end
  end
  object fdTextBoxFont: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Left = 304
    Top = 32
  end
end
