object FEditConnection: TFEditConnection
  Left = 389
  Top = 204
  AutoSize = True
  BorderStyle = bsDialog
  Caption = 'Edit Connection'
  ClientHeight = 321
  ClientWidth = 401
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lcMain: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 401
    Height = 321
    TabOrder = 0
    AutoSize = True
    LayoutLookAndFeel = dxLayoutCxLookAndFeel1
    object MemoText: TcxMemo
      Left = 10
      Top = 28
      Lines.Strings = (
        'MemoText')
      Properties.OnChange = MemoTextChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 0
      Height = 57
      Width = 385
    end
    object cbSArrowStyle: TcxComboBox
      Left = 84
      Top = 109
      Properties.DropDownListStyle = lsFixedList
      Properties.OnChange = MemoTextChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 2
      Width = 121
    end
    object cbDArrowStyle: TcxComboBox
      Left = 297
      Top = 109
      Properties.DropDownListStyle = lsFixedList
      Properties.OnChange = MemoTextChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 9
      Width = 121
    end
    object sbFont: TcxButton
      Left = 401
      Top = 28
      Width = 29
      Height = 28
      Hint = 'Text Font'
      OptionsImage.Glyph.SourceDPI = 192
      OptionsImage.Glyph.Data = {
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
      ParentShowHint = False
      ShowHint = True
      SpeedButtonOptions.CanBeFocused = False
      SpeedButtonOptions.Flat = True
      SpeedButtonOptions.Transparent = True
      TabOrder = 1
      OnClick = sbFontClick
    end
    object pSourceColor: TPanel
      Left = 84
      Top = 184
      Width = 25
      Height = 25
      ParentBackground = False
      TabOrder = 5
      OnClick = pColorClick
    end
    object pColor: TPanel
      Left = 65
      Top = 277
      Width = 25
      Height = 25
      ParentBackground = False
      TabOrder = 8
      OnClick = pColorClick
    end
    object btnOK: TcxButton
      Left = 274
      Top = 320
      Width = 75
      Height = 25
      Caption = '&OK'
      Default = True
      ModalResult = 1
      TabOrder = 13
    end
    object btnCancel: TcxButton
      Left = 355
      Top = 320
      Width = 75
      Height = 25
      Cancel = True
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 14
    end
    object seStrokeThickness: TcxSpinEdit
      Left = 65
      Top = 227
      Properties.MinValue = 1.000000000000000000
      Properties.OnChange = MemoTextChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 6
      Value = 1
      Width = 152
    end
    object seDArrowSize: TcxSpinEdit
      Left = 297
      Top = 134
      Properties.MinValue = 1.000000000000000000
      Properties.OnChange = MemoTextChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 10
      Value = 1
      Width = 121
    end
    object seSArrowSize: TcxSpinEdit
      Left = 84
      Top = 134
      Properties.MinValue = 1.000000000000000000
      Properties.OnChange = MemoTextChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 3
      Value = 1
      Width = 121
    end
    object seSLinkedPoint: TcxSpinEdit
      Left = 84
      Top = 159
      Properties.OnChange = MemoTextChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 4
      Width = 121
    end
    object seDLinkedPoint: TcxSpinEdit
      Left = 297
      Top = 159
      Properties.MaxValue = 16.000000000000000000
      Properties.MinValue = 1.000000000000000000
      Properties.OnChange = MemoTextChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 11
      Value = 1
      Width = 121
    end
    object pDestColor: TPanel
      Left = 297
      Top = 184
      Width = 25
      Height = 25
      ParentBackground = False
      TabOrder = 12
      OnClick = pColorClick
    end
    object cbLineStyle: TcxComboBox
      Left = 65
      Top = 252
      Properties.DropDownListStyle = lsEditFixedList
      Properties.Items.Strings = (
        'Solid'
        'Dashed'
        'Dotted'
        'Dash-Dotted'
        'Dash-Double-Dotted')
      Properties.OnChange = MemoTextChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 7
      Width = 152
    end
    object lcMainGroup_Root: TdxLayoutGroup
      AlignHorz = ahLeft
      AlignVert = avTop
      Hidden = True
      ShowBorder = False
      Index = -1
    end
    object dxLayoutGroup1: TdxLayoutGroup
      Parent = lcMainGroup_Root
      AlignVert = avTop
      ItemIndex = 1
      ShowBorder = False
      Index = 0
    end
    object dxLayoutGroup2: TdxLayoutGroup
      Parent = dxLayoutGroup1
      AlignVert = avTop
      CaptionOptions.Text = 'Hidden Group'
      Hidden = True
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 0
    end
    object liText: TdxLayoutItem
      Parent = dxLayoutGroup2
      AlignHorz = ahClient
      CaptionOptions.Text = 'Text'
      CaptionOptions.Layout = clTop
      Control = MemoText
      ControlOptions.OriginalHeight = 57
      ControlOptions.OriginalWidth = 345
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutGroup3: TdxLayoutGroup
      Parent = dxLayoutGroup1
      AlignVert = avTop
      CaptionOptions.Text = 'Hidden Group'
      Hidden = True
      ItemIndex = 1
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 1
    end
    object lgSource: TdxLayoutGroup
      Parent = dxLayoutAutoCreatedGroup1
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = ' Source '
      ItemIndex = 3
      Index = 0
    end
    object liArrowStyle: TdxLayoutItem
      Parent = lgSource
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'Arrow Style'
      Control = cbSArrowStyle
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 84
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lgTarget: TdxLayoutGroup
      Parent = dxLayoutGroup3
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = ' Destination '
      ItemIndex = 1
      Index = 1
    end
    object liArrowStyle2: TdxLayoutItem
      Parent = lgTarget
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'Arrow Style'
      Control = cbDArrowStyle
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 84
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem2: TdxLayoutItem
      Parent = dxLayoutGroup2
      AlignVert = avTop
      CaptionOptions.Text = ' '
      CaptionOptions.Layout = clTop
      Control = sbFont
      ControlOptions.OriginalHeight = 28
      ControlOptions.OriginalWidth = 29
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object liSourceColor: TdxLayoutItem
      Parent = lgSource
      AlignHorz = ahLeft
      CaptionOptions.Text = 'Color'
      Control = pSourceColor
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 25
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutGroup3
      AlignHorz = ahClient
      Index = 0
    end
    object liColor: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup1
      AlignHorz = ahLeft
      CaptionOptions.Text = 'Color'
      Control = pColor
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 25
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object dxLayoutGroup9: TdxLayoutGroup
      Parent = lcMainGroup_Root
      AlignHorz = ahRight
      AlignVert = avTop
      CaptionOptions.Text = 'Hidden Group'
      Hidden = True
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 1
    end
    object dxLayoutItem9: TdxLayoutItem
      Parent = dxLayoutGroup9
      CaptionOptions.Text = 'btnOK'
      CaptionOptions.Visible = False
      Control = btnOK
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem10: TdxLayoutItem
      Parent = dxLayoutGroup9
      CaptionOptions.Text = 'btnCancel'
      CaptionOptions.Visible = False
      Control = btnCancel
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutSeparatorItem1: TdxLayoutSeparatorItem
      Parent = dxLayoutGroup1
      CaptionOptions.Text = 'Separator'
      Index = 2
    end
    object liStrokeThickness: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup1
      CaptionOptions.Text = 'Line Width'
      Control = seStrokeThickness
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object liDArrowSize: TdxLayoutItem
      Parent = lgTarget
      AlignHorz = ahClient
      CaptionOptions.Text = 'Arrow Size'
      Control = seDArrowSize
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object liSArrowSize: TdxLayoutItem
      Parent = lgSource
      AlignHorz = ahClient
      CaptionOptions.Text = 'Arrow Size'
      Control = seSArrowSize
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object liSLinkedPoint: TdxLayoutItem
      Parent = lgSource
      AlignHorz = ahClient
      CaptionOptions.Text = 'Linked Point'
      Control = seSLinkedPoint
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object liDLinkedPoint: TdxLayoutItem
      Parent = lgTarget
      AlignHorz = ahClient
      CaptionOptions.Text = 'Linked Point'
      Control = seDLinkedPoint
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object liDestColor: TdxLayoutItem
      Parent = lgTarget
      AlignHorz = ahLeft
      CaptionOptions.Text = 'Color'
      Control = pDestColor
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 25
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object liLineStyle: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup1
      CaptionOptions.Text = 'Line Style'
      Control = cbLineStyle
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 2
    end
  end
  object FontDialog: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Left = 268
    Top = 34
  end
  object dxLayoutLookAndFeelList1: TdxLayoutLookAndFeelList
    Left = 264
    Top = 8
    object dxLayoutCxLookAndFeel1: TdxLayoutCxLookAndFeel
      PixelsPerInch = 96
    end
  end
end
