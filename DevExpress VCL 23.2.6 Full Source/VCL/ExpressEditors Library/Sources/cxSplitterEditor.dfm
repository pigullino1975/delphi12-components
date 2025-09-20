object cxSplitEditor: TcxSplitEditor
  Left = 224
  Top = 210
  AutoSize = True
  BorderStyle = bsDialog
  ClientHeight = 425
  ClientWidth = 521
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object dxLayoutControl1: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 521
    Height = 425
    TabOrder = 0
    AutoSize = True
    LayoutLookAndFeel = dxLayoutSkinLookAndFeel1
    HighlightRoot = False
    object cxBtnOK: TcxButton
      Left = 350
      Top = 390
      Width = 75
      Height = 25
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 14
    end
    object cxBtnCancel: TcxButton
      Left = 431
      Top = 390
      Width = 75
      Height = 25
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 15
    end
    object cxRbHzNone: TcxRadioButton
      AlignWithMargins = True
      Left = 193
      Top = 51
      Caption = 'None'
      Checked = True
      Color = clBtnFace
      ParentColor = False
      TabOrder = 7
      TabStop = True
      OnClick = cxRbHzNoneClick
      AutoSize = True
      ParentBackground = False
      Transparent = True
    end
    object cxCbHzVisible: TcxCheckBox
      AlignWithMargins = True
      Left = 193
      Top = 28
      Caption = 'Visible'
      Properties.OnChange = cxCbHzVisiblePropertiesChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 6
      Transparent = True
    end
    object cxTbHzWidth: TcxTrackBar
      Left = 193
      Top = 140
      Position = 10
      Properties.Frequency = 5
      Properties.Max = 100
      Properties.Min = 10
      Properties.SelectionColor = clGreen
      Properties.SelectionEnd = 60
      Properties.SelectionStart = 30
      Properties.OnChange = cxTbHzWidthPropertiesChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 12
      Height = 49
      Width = 301
    end
    object cxRbHzMp8: TcxRadioButton
      AlignWithMargins = True
      Left = 193
      Top = 74
      Hint = 'MediaPlayer8'
      Caption = 'Media Player 8'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 8
      OnClick = cxRbHzMp8Click
      AutoSize = True
      ParentBackground = False
      Transparent = True
    end
    object cxRbHzXp: TcxRadioButton
      AlignWithMargins = True
      Left = 193
      Top = 97
      Hint = 'XPTaskBar'
      Caption = 'XP Task Bar'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 9
      OnClick = cxRbHzMp8Click
      AutoSize = True
      ParentBackground = False
      Transparent = True
    end
    object cxRbHzMp9: TcxRadioButton
      AlignWithMargins = True
      Left = 287
      Top = 74
      Hint = 'MediaPlayer9'
      Caption = 'Media Player 9'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 10
      OnClick = cxRbHzMp8Click
      AutoSize = True
      ParentBackground = False
      Transparent = True
    end
    object cxRbHzSimple: TcxRadioButton
      AlignWithMargins = True
      Left = 287
      Top = 97
      Hint = 'Simple'
      Caption = 'Simple'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 11
      OnClick = cxRbHzMp8Click
      AutoSize = True
      ParentBackground = False
      Transparent = True
    end
    object cxCbAhd: TcxCheckBox
      AlignWithMargins = True
      Left = 22
      Top = 28
      Caption = 'Allow HotZone Drag'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 0
      Transparent = True
      OnClick = cxCbAhdClick
    end
    object cxCbAp: TcxCheckBox
      AlignWithMargins = True
      Left = 22
      Top = 64
      Caption = 'Auto Position'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 1
      Transparent = True
      OnClick = cxCbApClick
    end
    object cxCbSnap: TcxCheckBox
      AlignWithMargins = True
      Left = 22
      Top = 134
      Caption = 'Auto Snap'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 3
      Transparent = True
      OnClick = cxCbSnapClick
    end
    object cxCbRu: TcxCheckBox
      AlignWithMargins = True
      Left = 22
      Top = 204
      Caption = 'Resize Update'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 5
      Transparent = True
      OnClick = cxCbRuClick
    end
    object cxSeMs: TcxSpinEdit
      AlignWithMargins = True
      Left = 22
      Top = 177
      Properties.MaxValue = 145.000000000000000000
      Properties.SpinButtons.ShowFastButtons = True
      Properties.OnChange = cxSeMsPropertiesChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 4
      Value = 30
      Width = 141
    end
    object cxSePao: TcxSpinEdit
      AlignWithMargins = True
      Left = 22
      Top = 107
      Properties.MaxValue = 200.000000000000000000
      Properties.MinValue = 1.000000000000000000
      Properties.SpinButtons.ShowFastButtons = True
      Properties.OnChange = cxSePaoPropertiesChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 2
      Value = 200
      Width = 141
    end
    object cxGroupBox1: TcxGroupBox
      Left = 10
      Top = 239
      Caption = ' Preview '
      ParentBackground = False
      ParentColor = False
      Style.Color = clBtnFace
      Style.TransparentBorder = False
      TabOrder = 13
      Height = 145
      Width = 496
      object cxGroupBox4: TcxGroupBox
        AlignWithMargins = True
        Left = 7
        Top = 23
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alClient
        PanelStyle.Active = True
        Style.BorderStyle = ebsNone
        TabOrder = 0
        Transparent = True
        Height = 115
        Width = 482
        object cxListBox1: TcxListBox
          Left = 2
          Top = 2
          Width = 145
          Height = 111
          TabStop = False
          Align = alLeft
          ItemHeight = 13
          TabOrder = 0
        end
        object cxSplit: TcxSplitter
          Left = 147
          Top = 2
          Width = 8
          Height = 111
          AutoPosition = False
          AutoSnap = True
          Control = cxListBox1
        end
        object cxListBox2: TcxListBox
          Left = 155
          Top = 2
          Width = 325
          Height = 111
          TabStop = False
          Align = alClient
          ItemHeight = 13
          TabOrder = 2
        end
      end
    end
    object dxLayoutControl1Group_Root: TdxLayoutGroup
      AlignHorz = ahLeft
      AlignVert = avTop
      Hidden = True
      ItemIndex = 1
      ShowBorder = False
      Index = -1
    end
    object dxLayoutGroup2: TdxLayoutGroup
      Parent = dxLayoutAutoCreatedGroup1
      AlignHorz = ahLeft
      CaptionOptions.Text = ' Operation '
      ItemIndex = 1
      Index = 0
    end
    object dxLayoutItem1: TdxLayoutItem
      Parent = dxLayoutGroup2
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Text = 'New Item'
      CaptionOptions.Visible = False
      Control = cxCbAhd
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 113
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem2: TdxLayoutItem
      Parent = dxLayoutGroup2
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Text = 'New Item'
      CaptionOptions.Visible = False
      Control = cxCbAp
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 81
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutGroup3: TdxLayoutGroup
      Parent = dxLayoutGroup2
      AlignHorz = ahLeft
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      ItemIndex = 1
      ShowBorder = False
      Index = 2
    end
    object dxLayoutItem5: TdxLayoutItem
      Parent = dxLayoutGroup3
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.AlignHorz = taCenter
      CaptionOptions.AlignVert = tavTop
      CaptionOptions.Text = 'New Item'
      CaptionOptions.Visible = False
      Control = cxSePao
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 141
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutLabeledItem1: TdxLayoutLabeledItem
      Parent = dxLayoutGroup3
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Text = 'Position after open'
      Index = 0
    end
    object dxLayoutItem6: TdxLayoutItem
      Parent = dxLayoutGroup2
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Text = 'New Item'
      CaptionOptions.Visible = False
      Control = cxCbSnap
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 68
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object dxLayoutGroup4: TdxLayoutGroup
      Parent = dxLayoutGroup2
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      ItemIndex = 1
      ShowBorder = False
      Index = 4
    end
    object dxLayoutLabeledItem2: TdxLayoutLabeledItem
      Parent = dxLayoutGroup4
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Text = 'Min Size'
      Index = 0
    end
    object dxLayoutItem7: TdxLayoutItem
      Parent = dxLayoutGroup4
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'New Item'
      CaptionOptions.Visible = False
      Control = cxSeMs
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 141
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem8: TdxLayoutItem
      Parent = dxLayoutGroup2
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Text = 'New Item'
      CaptionOptions.Visible = False
      Control = cxCbRu
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 87
      ControlOptions.ShowBorder = False
      Index = 5
    end
    object dxLayoutGroup5: TdxLayoutGroup
      Parent = dxLayoutAutoCreatedGroup1
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = ' Hot Zone '
      ItemIndex = 2
      Index = 1
    end
    object dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutControl1Group_Root
      AlignHorz = ahLeft
      LayoutDirection = ldHorizontal
      Index = 0
    end
    object dxLayoutItem9: TdxLayoutItem
      Parent = dxLayoutGroup5
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Text = 'New Item'
      CaptionOptions.Visible = False
      Control = cxCbHzVisible
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 47
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem10: TdxLayoutItem
      Parent = dxLayoutGroup5
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Text = 'New Item'
      CaptionOptions.Visible = False
      Control = cxRbHzNone
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 43
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutGroup6: TdxLayoutGroup
      Parent = dxLayoutAutoCreatedGroup2
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      ItemIndex = 1
      ShowBorder = False
      Index = 0
    end
    object dxLayoutItem11: TdxLayoutItem
      Parent = dxLayoutGroup6
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Text = 'New Item'
      CaptionOptions.Visible = False
      Control = cxRbHzMp8
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 88
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem12: TdxLayoutItem
      Parent = dxLayoutGroup6
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Text = 'New Item'
      CaptionOptions.Visible = False
      Control = cxRbHzXp
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 74
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutGroup7: TdxLayoutGroup
      Parent = dxLayoutAutoCreatedGroup2
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      ItemIndex = 1
      ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup2: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutGroup5
      AlignHorz = ahLeft
      AlignVert = avTop
      LayoutDirection = ldHorizontal
      Index = 2
    end
    object dxLayoutItem13: TdxLayoutItem
      Parent = dxLayoutGroup7
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Text = 'New Item'
      CaptionOptions.Visible = False
      Control = cxRbHzMp9
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 88
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem14: TdxLayoutItem
      Parent = dxLayoutGroup7
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Text = 'New Item'
      CaptionOptions.Visible = False
      Control = cxRbHzSimple
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 48
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutLabeledItem3: TdxLayoutLabeledItem
      Parent = dxLayoutGroup5
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Text = 'HotZone Width'
      Index = 3
    end
    object dxLayoutItem15: TdxLayoutItem
      Parent = dxLayoutGroup5
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Text = 'New Item'
      CaptionOptions.Visible = False
      Control = cxTbHzWidth
      ControlOptions.OriginalHeight = 49
      ControlOptions.OriginalWidth = 301
      ControlOptions.ShowBorder = False
      Index = 4
    end
    object dxLayoutGroup8: TdxLayoutGroup
      Parent = dxLayoutControl1Group_Root
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      ItemIndex = 1
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 2
    end
    object dxLayoutItem17: TdxLayoutItem
      Parent = dxLayoutGroup8
      AlignHorz = ahRight
      AlignVert = avTop
      CaptionOptions.Text = 'New Item'
      CaptionOptions.Visible = False
      Control = cxBtnOK
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem18: TdxLayoutItem
      Parent = dxLayoutGroup8
      AlignHorz = ahRight
      AlignVert = avTop
      CaptionOptions.Text = 'New Item'
      CaptionOptions.Visible = False
      Control = cxBtnCancel
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem3: TdxLayoutItem
      Parent = dxLayoutControl1Group_Root
      CaptionOptions.Text = 'New Item'
      CaptionOptions.Visible = False
      Control = cxGroupBox1
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 145
      ControlOptions.OriginalWidth = 451
      ControlOptions.ShowBorder = False
      Index = 1
    end
  end
  object dxLayoutLookAndFeelList1: TdxLayoutLookAndFeelList
    Left = 368
    Top = 176
    object dxLayoutSkinLookAndFeel1: TdxLayoutSkinLookAndFeel
      PixelsPerInch = 96
    end
  end
end
