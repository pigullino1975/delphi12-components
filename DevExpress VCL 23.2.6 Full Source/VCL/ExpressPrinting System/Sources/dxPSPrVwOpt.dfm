object dxfmOptions: TdxfmOptions
  Left = 303
  Top = 247
  AutoSize = True
  BorderStyle = bsDialog
  Caption = 'Preferences'
  ClientHeight = 273
  ClientWidth = 457
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
  object dxLayoutControl1: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 457
    Height = 273
    TabOrder = 0
    AutoSize = True
    LayoutLookAndFeel = dxLayoutCxLookAndFeel1
    object chbxShowMargins: TcxCheckBox
      Left = 37
      Top = 0
      Caption = '&Margins'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 0
      Transparent = True
      OnClick = FormChanged
    end
    object chbxShowMarginsHints: TcxCheckBox
      Left = 37
      Top = 36
      Caption = 'Margins &hints'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 1
      Transparent = True
      OnClick = FormChanged
    end
    object chbxShowMarginsHintsWhileDragging: TcxCheckBox
      Left = 37
      Top = 72
      Caption = 'Margins hints while &dragging'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 2
      Transparent = True
      OnClick = FormChanged
    end
    object cbxMeasurementUnits: TcxComboBox
      Left = 37
      Top = 162
      Properties.DropDownListStyle = lsFixedList
      Properties.OnChange = FormChanged
      Style.HotTrack = False
      TabOrder = 5
      Width = 170
    end
    object cbxMarginColor: TcxColorComboBox
      Left = 243
      Top = 162
      Properties.CustomColors = <>
      Properties.OnChange = FormChanged
      Style.HotTrack = False
      TabOrder = 6
      Width = 170
    end
    object btnOk: TcxButton
      Left = 203
      Top = 223
      Width = 75
      Height = 23
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 7
    end
    object btnCancel: TcxButton
      Left = 284
      Top = 223
      Width = 75
      Height = 23
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 8
    end
    object btnHelp: TcxButton
      Left = 365
      Top = 223
      Width = 75
      Height = 23
      Anchors = [akRight, akBottom]
      Caption = '&Help'
      TabOrder = 9
      OnClick = btnHelpClick
    end
    object chbxZoomOnRoll: TcxCheckBox
      Left = 243
      Top = -25
      Caption = '&Zoom on roll with IntelliMouse'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 3
      Transparent = True
      OnClick = FormChanged
    end
    object seZoomStep: TcxSpinEdit
      Left = 306
      Top = 11
      Properties.DisplayFormat = '0 %'
      Properties.MaxValue = 20.000000000000000000
      Properties.MinValue = 1.000000000000000000
      Properties.OnChange = FormChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 4
      Value = 1
      Width = 67
    end
    object dxLayoutControl1Group_Root: TdxLayoutGroup
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Visible = False
      Hidden = True
      ShowBorder = False
      Index = -1
    end
    object dxLayoutItem1: TdxLayoutItem
      Parent = gbxShow
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'chbxShowMargins'
      CaptionOptions.Visible = False
      Control = chbxShowMargins
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 175
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem2: TdxLayoutItem
      Parent = gbxShow
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'chbxShowMarginsHints'
      CaptionOptions.Visible = False
      Control = chbxShowMarginsHints
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 175
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem3: TdxLayoutItem
      Parent = gbxShow
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'chbxShowMarginsHintsWhileDragging'
      CaptionOptions.Visible = False
      Control = chbxShowMarginsHintsWhileDragging
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 175
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object lblMeasurementUnits: TdxLayoutItem
      Parent = dxLayoutGroup8
      CaptionOptions.Text = '&Measurement units:'
      CaptionOptions.Layout = clTop
      Control = cbxMeasurementUnits
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 175
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lblMarginsColor: TdxLayoutItem
      Parent = dxLayoutGroup9
      CaptionOptions.Text = '&Margins color:'
      CaptionOptions.Layout = clTop
      Control = cbxMarginColor
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 165
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem8: TdxLayoutItem
      Parent = dxLayoutGroup10
      AlignHorz = ahRight
      AlignVert = avBottom
      CaptionOptions.Text = 'btnOk'
      CaptionOptions.Visible = False
      Control = btnOk
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem9: TdxLayoutItem
      Parent = dxLayoutGroup10
      AlignHorz = ahRight
      AlignVert = avBottom
      CaptionOptions.Text = 'btnCancel'
      CaptionOptions.Visible = False
      Control = btnCancel
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object libtnHelp: TdxLayoutItem
      Parent = dxLayoutGroup10
      AlignHorz = ahRight
      AlignVert = avBottom
      CaptionOptions.Text = 'btnHelp'
      CaptionOptions.Visible = False
      Control = btnHelp
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutItem4: TdxLayoutItem
      Parent = gbxZoomOpt
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Text = 'chbxZoomOnRoll'
      CaptionOptions.Visible = False
      Control = chbxZoomOnRoll
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 166
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lblZoomStep: TdxLayoutItem
      Parent = gbxZoomOpt
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Text = 'Zoom &Step :'
      Control = seZoomStep
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 67
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutGroup1: TdxLayoutGroup
      Parent = dxLayoutControl1Group_Root
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Visible = False
      LayoutDirection = ldTabbed
      ShowBorder = False
      TabbedOptions.ShowFrame = True
      Index = 0
    end
    object tshGeneral: TdxLayoutGroup
      Parent = dxLayoutGroup1
      LayoutDirection = ldHorizontal
      Index = 0
    end
    object dxLayoutGroup3: TdxLayoutGroup
      Parent = tshGeneral
      AlignVert = avTop
      CaptionOptions.Text = 'Hidden Group'
      CaptionOptions.Visible = False
      Hidden = True
      ItemIndex = 1
      ShowBorder = False
      Index = 0
    end
    object dxLayoutGroup4: TdxLayoutGroup
      Parent = dxLayoutGroup3
      AlignHorz = ahLeft
      CaptionOptions.Text = 'Hidden Group'
      CaptionOptions.Visible = False
      Hidden = True
      ItemIndex = 1
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 0
    end
    object gbxShow: TdxLayoutGroup
      Parent = dxLayoutGroup4
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = ' &Show '
      SizeOptions.Width = 200
      Index = 0
    end
    object gbxZoomOpt: TdxLayoutGroup
      Parent = dxLayoutGroup4
      AlignHorz = ahClient
      AlignVert = avClient
      SizeOptions.Width = 200
      ItemIndex = 1
      Index = 1
    end
    object dxLayoutGroup7: TdxLayoutGroup
      Parent = dxLayoutGroup3
      AlignHorz = ahLeft
      CaptionOptions.Text = 'Hidden Group'
      CaptionOptions.Visible = False
      Hidden = True
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 1
    end
    object dxLayoutGroup8: TdxLayoutGroup
      Parent = dxLayoutGroup7
      AlignHorz = ahClient
      AlignVert = avClient
      SizeOptions.Width = 200
      Index = 0
    end
    object dxLayoutGroup9: TdxLayoutGroup
      Parent = dxLayoutGroup7
      AlignHorz = ahClient
      AlignVert = avClient
      SizeOptions.Width = 200
      Index = 1
    end
    object dxLayoutGroup10: TdxLayoutGroup
      Parent = dxLayoutControl1Group_Root
      AlignHorz = ahRight
      AlignVert = avTop
      CaptionOptions.Text = 'Hidden Group'
      CaptionOptions.Visible = False
      Hidden = True
      ItemIndex = 2
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 1
    end
  end
  object dxLayoutLookAndFeelList1: TdxLayoutLookAndFeelList
    Left = 216
    Top = 65520
    object dxLayoutCxLookAndFeel1: TdxLayoutCxLookAndFeel
      PixelsPerInch = 96
    end
  end
end
