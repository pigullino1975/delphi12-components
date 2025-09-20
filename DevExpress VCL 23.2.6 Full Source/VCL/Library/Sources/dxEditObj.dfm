object FEditObject: TFEditObject
  Left = 368
  Top = 185
  AutoSize = True
  BorderStyle = bsDialog
  Caption = 'Edit Object'
  ClientHeight = 414
  ClientWidth = 380
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  TextHeight = 13
  object lcMain: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 380
    Height = 414
    TabOrder = 0
    AutoSize = True
    LayoutLookAndFeel = dxLayoutCxLookAndFeel1
    object memoText: TcxMemo
      Left = 100
      Top = 94
      Properties.OnChange = seHeightChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 2
      Height = 69
      Width = 258
    end
    object cbFont: TcxFontNameComboBox
      Left = 100
      Top = 169
      Properties.FontPreview.Visible = False
      Properties.OnChange = seHeightChange
      Properties.OnEditValueChanged = cbFontPropertiesEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 3
      Width = 258
    end
    object cbTextPosition: TcxComboBox
      Left = 100
      Top = 194
      Properties.DropDownListStyle = lsFixedList
      Properties.OnChange = seHeightChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 4
      Width = 258
    end
    object cbShapeStyle: TcxComboBox
      Left = 100
      Top = 219
      Properties.DropDownListStyle = lsFixedList
      Properties.OnChange = seHeightChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 5
      Width = 258
    end
    object cbImagePosition: TcxComboBox
      Left = 10000
      Top = 10000
      Anchors = [akLeft, akRight, akBottom]
      Properties.DropDownListStyle = lsFixedList
      Properties.OnChange = seHeightChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 12
      Visible = False
      Width = 185
    end
    object btnClear: TcxButton
      Left = 10000
      Top = 10000
      Width = 75
      Height = 25
      Caption = 'Clear Image'
      TabOrder = 13
      Visible = False
      OnClick = btnClearClick
    end
    object cbRaisedOut: TcxCheckBox
      Left = 10000
      Top = 10000
      Caption = 'Raised outer edge'
      Style.HotTrack = False
      TabOrder = 14
      Transparent = True
      Visible = False
      OnClick = seHeightChange
    end
    object cbRaisedIn: TcxCheckBox
      Left = 10000
      Top = 10000
      Caption = 'Raised inner edge'
      Style.HotTrack = False
      TabOrder = 16
      Transparent = True
      Visible = False
      OnClick = seHeightChange
    end
    object cbSunkenOut: TcxCheckBox
      Left = 10000
      Top = 10000
      Caption = 'Sunken outer edge'
      Style.HotTrack = False
      TabOrder = 15
      Transparent = True
      Visible = False
      OnClick = seHeightChange
    end
    object cbSunkenIn: TcxCheckBox
      Left = 10000
      Top = 10000
      Caption = 'Sunken inner edge'
      Style.HotTrack = False
      TabOrder = 17
      Transparent = True
      Visible = False
      OnClick = seHeightChange
    end
    object cbFlat: TcxCheckBox
      Left = 10000
      Top = 10000
      Caption = 'Flat'
      Style.HotTrack = False
      TabOrder = 18
      Transparent = True
      Visible = False
      OnClick = seHeightChange
    end
    object cbMono: TcxCheckBox
      Left = 10000
      Top = 10000
      Caption = 'Mono'
      Style.HotTrack = False
      TabOrder = 19
      Transparent = True
      Visible = False
      OnClick = seHeightChange
    end
    object cbLeft: TcxCheckBox
      Left = 10000
      Top = 10000
      Caption = 'Left'
      State = cbsChecked
      Style.HotTrack = False
      TabOrder = 20
      Transparent = True
      Visible = False
      OnClick = seHeightChange
    end
    object cbTop: TcxCheckBox
      Left = 10000
      Top = 10000
      Caption = 'Top'
      State = cbsChecked
      Style.HotTrack = False
      TabOrder = 21
      Transparent = True
      Visible = False
      OnClick = seHeightChange
    end
    object cbRight: TcxCheckBox
      Left = 10000
      Top = 10000
      Caption = 'Right'
      State = cbsChecked
      Style.HotTrack = False
      TabOrder = 22
      Transparent = True
      Visible = False
      OnClick = seHeightChange
    end
    object cbBottom: TcxCheckBox
      Left = 10000
      Top = 10000
      Caption = 'Bottom'
      State = cbsChecked
      Style.HotTrack = False
      TabOrder = 23
      Transparent = True
      Visible = False
      OnClick = seHeightChange
    end
    object cbSoft: TcxCheckBox
      Left = 10000
      Top = 10000
      Caption = 'Soft'
      Style.HotTrack = False
      TabOrder = 24
      Transparent = True
      Visible = False
      OnClick = seHeightChange
    end
    object cbAdjust: TcxCheckBox
      Left = 10000
      Top = 10000
      Caption = 'Adjust'
      Style.HotTrack = False
      TabOrder = 25
      Transparent = True
      Visible = False
      OnClick = seHeightChange
    end
    object cbMiddle: TcxCheckBox
      Left = 10000
      Top = 10000
      Caption = 'Middle'
      Style.HotTrack = False
      TabOrder = 26
      Transparent = True
      Visible = False
      OnClick = seHeightChange
    end
    object cbDiag: TcxCheckBox
      Left = 10000
      Top = 10000
      Caption = 'Diagonal'
      Style.HotTrack = False
      TabOrder = 27
      Transparent = True
      Visible = False
      OnClick = seHeightChange
    end
    object btnOK: TcxButton
      Left = 213
      Top = 344
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = '&OK'
      Default = True
      ModalResult = 1
      TabOrder = 28
    end
    object btnCancel: TcxButton
      Left = 294
      Top = 344
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 29
    end
    object pBkColor: TPanel
      Left = 232
      Top = 294
      Width = 25
      Height = 25
      TabOrder = 9
      OnClick = pColorClick
    end
    object pColor: TPanel
      Left = 100
      Top = 294
      Width = 25
      Height = 25
      TabOrder = 8
      OnClick = pColorClick
    end
    object cbTransparent: TcxCheckBox
      Left = 275
      Top = 294
      AutoSize = False
      Caption = 'Transparent'
      Style.HotTrack = False
      TabOrder = 10
      Transparent = True
      OnClick = seHeightChange
      Height = 25
      Width = 83
    end
    object seAngle: TcxSpinEdit
      Left = 100
      Top = 269
      Properties.MaxValue = 359.000000000000000000
      Properties.MinValue = -359.000000000000000000
      Properties.OnChange = seHeightChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 7
      Width = 258
    end
    object seLineWidth: TcxSpinEdit
      Left = 100
      Top = 244
      Properties.MinValue = 1.000000000000000000
      Properties.OnChange = seHeightChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 6
      Value = 1
      Width = 258
    end
    object seHeight: TcxSpinEdit
      Left = 100
      Top = 44
      Properties.MinValue = 1.000000000000000000
      Properties.OnChange = seHeightChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 0
      Value = 1
      Width = 258
    end
    object seWidth: TcxSpinEdit
      Left = 100
      Top = 69
      Properties.MinValue = 1.000000000000000000
      Properties.OnChange = seHeightChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 1
      Value = 1
      Width = 258
    end
    object gcImages: TdxGalleryControl
      Left = 10000
      Top = 10000
      Width = 337
      Height = 252
      Visible = False
      OptionsBehavior.ItemCheckMode = icmSingleCheck
      OptionsView.Item.Image.ShowFrame = False
      OptionsView.Item.Text.Position = posBottom
      TabOrder = 11
      OnItemClick = gcImagesItemClick
      object gcgImages: TdxGalleryControlGroup
        ShowCaption = False
      end
    end
    object lcMainGroup_Root: TdxLayoutGroup
      AlignHorz = ahLeft
      AlignVert = avTop
      Hidden = True
      ShowBorder = False
      Index = -1
    end
    object dxLayoutGroup2: TdxLayoutGroup
      Parent = lcMainGroup_Root
      AlignHorz = ahLeft
      AlignVert = avTop
      LayoutDirection = ldTabbed
      ShowBorder = False
      TabbedOptions.ShowFrame = True
      Index = 0
    end
    object tsGeneral: TdxLayoutGroup
      Parent = dxLayoutGroup2
      CaptionOptions.Text = 'General'
      LayoutDirection = ldHorizontal
      Index = 0
    end
    object dxLayoutGroup4: TdxLayoutGroup
      Parent = dxLayoutGroup1
      AlignVert = avTop
      CaptionOptions.Text = 'Hidden Group'
      Hidden = True
      ItemIndex = 7
      ShowBorder = False
      Index = 0
    end
    object Label1: TdxLayoutItem
      Parent = dxLayoutGroup4
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.AlignVert = tavTop
      CaptionOptions.Text = 'Text'
      Control = memoText
      ControlOptions.OriginalHeight = 69
      ControlOptions.OriginalWidth = 203
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object Label4: TdxLayoutItem
      Parent = dxLayoutGroup4
      CaptionOptions.Text = 'Text Font'
      Control = cbFont
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 144
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object Label2: TdxLayoutItem
      Parent = dxLayoutGroup4
      CaptionOptions.Text = 'Text Layout'
      Control = cbTextPosition
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 144
      ControlOptions.ShowBorder = False
      Index = 4
    end
    object Label3: TdxLayoutItem
      Parent = dxLayoutGroup4
      CaptionOptions.Text = 'Shape Type'
      Control = cbShapeStyle
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 144
      ControlOptions.ShowBorder = False
      Index = 5
    end
    object tsImage: TdxLayoutGroup
      Parent = dxLayoutGroup2
      CaptionOptions.Text = 'Image'
      Index = 1
    end
    object dxLayoutGroup5: TdxLayoutGroup
      Parent = tsImage
      AlignHorz = ahClient
      AlignVert = avBottom
      CaptionOptions.Text = 'Hidden Group'
      Hidden = True
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 1
    end
    object Label5: TdxLayoutItem
      Parent = dxLayoutGroup5
      AlignHorz = ahClient
      AlignVert = avCenter
      CaptionOptions.Text = 'Image Layout'
      Control = cbImagePosition
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 173
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem11: TdxLayoutItem
      Parent = dxLayoutGroup5
      AlignHorz = ahRight
      AlignVert = avCenter
      CaptionOptions.Text = 'btnClear'
      CaptionOptions.Visible = False
      Control = btnClear
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object tsFrame: TdxLayoutGroup
      Parent = dxLayoutGroup2
      CaptionOptions.Text = 'Frame'
      LayoutDirection = ldHorizontal
      Index = 2
    end
    object dxLayoutGroup7: TdxLayoutGroup
      Parent = tsFrame
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'Hidden Group'
      Hidden = True
      ItemIndex = 1
      ShowBorder = False
      Index = 0
    end
    object GroupBox1: TdxLayoutGroup
      Parent = dxLayoutGroup7
      CaptionOptions.Text = ' Edge Style '
      LayoutDirection = ldHorizontal
      Index = 0
    end
    object dxLayoutItem12: TdxLayoutItem
      Parent = dxLayoutGroup9
      AlignHorz = ahLeft
      CaptionOptions.Text = 'Raised outer edge'
      CaptionOptions.Visible = False
      Control = cbRaisedOut
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 112
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem13: TdxLayoutItem
      Parent = dxLayoutGroup10
      AlignHorz = ahLeft
      CaptionOptions.Text = 'Raised inner edge'
      CaptionOptions.Visible = False
      Control = cbRaisedIn
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 110
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem14: TdxLayoutItem
      Parent = dxLayoutGroup9
      AlignHorz = ahLeft
      CaptionOptions.Text = 'Sunken outer edge'
      CaptionOptions.Visible = False
      Control = cbSunkenOut
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 115
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem15: TdxLayoutItem
      Parent = dxLayoutGroup10
      AlignHorz = ahLeft
      CaptionOptions.Text = 'Sunken inner edge'
      CaptionOptions.Visible = False
      Control = cbSunkenIn
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 113
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object GroupBox2: TdxLayoutGroup
      Parent = dxLayoutGroup7
      AlignHorz = ahClient
      CaptionOptions.Text = ' Border Style '
      ItemIndex = 2
      LayoutDirection = ldHorizontal
      Index = 1
    end
    object dxLayoutGroup12: TdxLayoutGroup
      Parent = GroupBox2
      AlignVert = avTop
      CaptionOptions.Text = 'Hidden Group'
      Hidden = True
      ShowBorder = False
      Index = 0
    end
    object dxLayoutItem16: TdxLayoutItem
      Parent = dxLayoutGroup12
      AlignHorz = ahLeft
      CaptionOptions.Text = 'cbFlat'
      CaptionOptions.Visible = False
      Control = cbFlat
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 42
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem17: TdxLayoutItem
      Parent = dxLayoutGroup12
      AlignHorz = ahLeft
      CaptionOptions.Text = 'cbMono'
      CaptionOptions.Visible = False
      Control = cbMono
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 50
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutGroup13: TdxLayoutGroup
      Parent = GroupBox2
      AlignVert = avTop
      CaptionOptions.Text = 'Hidden Group'
      Hidden = True
      ShowBorder = False
      Index = 1
    end
    object dxLayoutItem18: TdxLayoutItem
      Parent = dxLayoutGroup13
      AlignHorz = ahLeft
      CaptionOptions.Text = 'cbLeft'
      CaptionOptions.Visible = False
      Control = cbLeft
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 43
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem19: TdxLayoutItem
      Parent = dxLayoutGroup13
      AlignHorz = ahLeft
      CaptionOptions.Text = 'cbTop'
      CaptionOptions.Visible = False
      Control = cbTop
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 42
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem20: TdxLayoutItem
      Parent = dxLayoutGroup13
      AlignHorz = ahLeft
      CaptionOptions.Text = 'cbRight'
      CaptionOptions.Visible = False
      Control = cbRight
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 49
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutItem21: TdxLayoutItem
      Parent = dxLayoutGroup13
      AlignHorz = ahLeft
      CaptionOptions.Text = 'cbBottom'
      CaptionOptions.Visible = False
      Control = cbBottom
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 58
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object dxLayoutGroup14: TdxLayoutGroup
      Parent = GroupBox2
      AlignVert = avTop
      CaptionOptions.Text = 'Hidden Group'
      Hidden = True
      ShowBorder = False
      Index = 2
    end
    object dxLayoutItem22: TdxLayoutItem
      Parent = dxLayoutGroup14
      AlignHorz = ahLeft
      CaptionOptions.Text = 'cbSoft'
      CaptionOptions.Visible = False
      Control = cbSoft
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 44
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem23: TdxLayoutItem
      Parent = dxLayoutGroup14
      AlignHorz = ahLeft
      CaptionOptions.Text = 'cbAdjust'
      CaptionOptions.Visible = False
      Control = cbAdjust
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 55
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem24: TdxLayoutItem
      Parent = dxLayoutGroup14
      AlignHorz = ahLeft
      CaptionOptions.Text = 'cbMiddle'
      CaptionOptions.Visible = False
      Control = cbMiddle
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 54
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutItem25: TdxLayoutItem
      Parent = dxLayoutGroup14
      AlignHorz = ahLeft
      CaptionOptions.Text = 'cbDiag'
      CaptionOptions.Visible = False
      Control = cbDiag
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 65
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object dxLayoutGroup3: TdxLayoutGroup
      Parent = lcMainGroup_Root
      AlignHorz = ahRight
      AlignVert = avTop
      CaptionOptions.Text = 'Hidden Group'
      Hidden = True
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 1
    end
    object dxLayoutItem26: TdxLayoutItem
      Parent = dxLayoutGroup3
      AlignHorz = ahRight
      AlignVert = avBottom
      CaptionOptions.Text = 'btnOK'
      CaptionOptions.Visible = False
      Control = btnOK
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem27: TdxLayoutItem
      Parent = dxLayoutGroup3
      AlignHorz = ahRight
      AlignVert = avBottom
      CaptionOptions.Text = 'btnCancel'
      CaptionOptions.Visible = False
      Control = btnCancel
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object Label9: TdxLayoutItem
      Parent = dxLayoutGroup6
      AlignVert = avClient
      CaptionOptions.Text = 'Background Color'
      Control = pBkColor
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 25
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutGroup1: TdxLayoutGroup
      Parent = tsGeneral
      CaptionOptions.Text = 'Hidden Group'
      Hidden = True
      ItemIndex = 1
      ShowBorder = False
      Index = 0
    end
    object Label8: TdxLayoutItem
      Parent = dxLayoutGroup6
      AlignHorz = ahLeft
      CaptionOptions.Text = 'Shape Color'
      Control = pColor
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 25
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem7: TdxLayoutItem
      Parent = dxLayoutGroup6
      AlignVert = avClient
      Control = cbTransparent
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 83
      ControlOptions.ShowBorder = False
      Index = 4
    end
    object liAngle: TdxLayoutItem
      Parent = dxLayoutGroup4
      CaptionOptions.Text = 'Rotation Angle '
      Control = seAngle
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 144
      ControlOptions.ShowBorder = False
      Index = 7
    end
    object liLineWidth: TdxLayoutItem
      Parent = dxLayoutGroup4
      CaptionOptions.Text = 'Line Width'
      Control = seLineWidth
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 144
      ControlOptions.ShowBorder = False
      Index = 6
    end
    object liHeight: TdxLayoutItem
      Parent = dxLayoutGroup4
      CaptionOptions.Text = 'Height'
      Control = seHeight
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 144
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object liWidth: TdxLayoutItem
      Parent = dxLayoutGroup4
      CaptionOptions.Text = 'Width'
      Control = seWidth
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 144
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutGroup9: TdxLayoutGroup
      Parent = GroupBox1
      CaptionOptions.Text = 'New Group'
      ShowBorder = False
      Index = 0
    end
    object dxLayoutGroup10: TdxLayoutGroup
      Parent = GroupBox1
      CaptionOptions.Text = 'New Group'
      ItemIndex = 1
      ShowBorder = False
      Index = 1
    end
    object dxLayoutItem30: TdxLayoutItem
      Parent = tsImage
      CaptionOptions.Text = 'dxGalleryControl1'
      CaptionOptions.Visible = False
      Control = gcImages
      ControlOptions.OriginalHeight = 252
      ControlOptions.OriginalWidth = 150
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutGroup6: TdxLayoutGroup
      Parent = dxLayoutGroup1
      CaptionOptions.Text = 'Hidden Group'
      Hidden = True
      ItemIndex = 3
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 1
    end
    object dxLayoutSeparatorItem1: TdxLayoutSeparatorItem
      Parent = dxLayoutGroup6
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object dxLayoutSeparatorItem2: TdxLayoutSeparatorItem
      Parent = dxLayoutGroup6
      CaptionOptions.Text = 'Separator'
      Index = 3
    end
  end
  object FontDialog: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Left = 302
    Top = 6
  end
  object dxLayoutLookAndFeelList1: TdxLayoutLookAndFeelList
    object dxLayoutCxLookAndFeel1: TdxLayoutCxLookAndFeel
      PixelsPerInch = 96
    end
  end
  object ilImages: TcxImageList
    SourceDPI = 96
    FormatVersion = 1
    Left = 304
    Top = 224
    Bitmap = {
      494C010101000800040010001000FFFFFFFF2100FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000006354D8C13A3EBF50D71A3CC031C28660000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000050D78ADD214B1FFFF14B1FFFF0423327200000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000010B114214B1FFFF14B1FFFF073C589600000012000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000008E4E0BCFD47410FD0101
      0018000000000000000004273979073E5A9809090949696969F50A0A0A4D0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000002E190376D77610FF2011
      02630000000000000000000000000000000F676767F43B3B3BB902020B3E0404
      1F63000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000301001FD57510FE6638
      08B0000000000000000000000000000000000909094802020B3E1818B7EF1B1B
      CFFE040421670000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007D4509C3D776
      10FFD77610FFD77610FFD77610FFC56C0FF40D07014003031B5D1B1BCDFD1B1B
      D1FF1B1BCFFE0404216700000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000002414026AD776
      10FF713E08B9361E0480361E0480B0610DE7BD680EEF0000000504041D601B1B
      CDFD1B1BD1FF1B1BCFFE04042167000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000001000015CF72
      10FB693908B20000000001000013CF7210FB6B3B08B400000000000000000404
      1D601B1BCDFD1B1BD1FF12128FD3000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000006E3C
      08B6CB7010F80000000F1F110262D77610FF1B0E025B00000000000000000000
      000004041D6012128CD100000118000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000001C0F
      025DD77610FF1B0F025C6C3B08B5C66D0FF50000000C00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000DC76E0FF6764109BDCD7010F95C3207A70000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00005F3407A9D77610FFD77610FF140A014E0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000150B0150D77610FFBA660EED000000060000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
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
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000}
    DesignInfo = 14680368
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
          63653D227072657365727665223E2E5265647B66696C6C3A234431314331433B
          7D262331333B262331303B2623393B2E426C61636B7B66696C6C3A2337323732
          37323B7D262331333B262331303B2623393B2E426C75657B66696C6C3A233131
          373744373B7D262331333B262331303B2623393B2E59656C6C6F777B66696C6C
          3A234646423131353B7D3C2F7374796C653E0D0A3C7061746820636C6173733D
          22426C75652220643D224D372E36362C313868372E37346C302E32332D302E32
          336C302C306C322E35352D322E35354C31332E35352C3248392E374C322C3234
          68332E38354C372E36362C31387A204D31312E36332C362E31326C322E392C38
          2E383848382E373120202623393B43382E37312C31352C31312E34392C362E36
          372C31312E36332C362E31327A222F3E0D0A3C7061746820636C6173733D2259
          656C6C6F772220643D224D31342E36312C32322E333163332E30382C332E3038
          2C302C302C332E30382C332E30384331362E31352C33302C31312E36322C3330
          2C382C33304331312E34362C32362E35342C31312E37372C32322E33312C3134
          2E36312C32322E33317A222F3E0D0A3C7061746820636C6173733D2252656422
          20643D224D32392E37372C31322E39326C2D322E36392D322E3639632D302E33
          312D302E33312D302E37372D302E33312D312E30382C306C2D372E35342C372E
          35346C332E37372C332E37374C32392E37372C313420202623393B4333302E30
          372C31332E37372C33302E30372C31332E32332C32392E37372C31322E39327A
          222F3E0D0A3C7061746820636C6173733D22426C61636B2220643D224D31372E
          33382C31382E38356C2D312E34362C312E3436632D302E33312C302E33312D30
          2E33312C302E37372C302C312E30386C322E36392C322E363963302E33312C30
          2E33312C302E37372C302E33312C312E30382C306C312E34362D312E34362020
          2623393B4C31372E33382C31382E38357A222F3E0D0A3C2F7376673E0D0A}
        FileName = 'SVG Images\RichEdit\ChangeFontStyle.svg'
        Keywords = 'RichEdit;ChangeFontStyle'
      end>
  end
end
