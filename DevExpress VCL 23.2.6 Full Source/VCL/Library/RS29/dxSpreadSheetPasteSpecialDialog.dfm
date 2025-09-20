object dxSpreadSheetPasteSpecialDialogForm: TdxSpreadSheetPasteSpecialDialogForm
  Left = 0
  Top = 0
  AutoSize = True
  BorderStyle = bsDialog
  ClientHeight = 369
  ClientWidth = 321
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lcMain: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 321
    Height = 369
    TabOrder = 0
    AutoSize = True
    LayoutLookAndFeel = dxLayoutCxLookAndFeel1
    object btnCancel: TcxButton
      Left = 235
      Top = 343
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'btnCancel'
      ModalResult = 2
      TabOrder = 1
    end
    object btnOk: TcxButton
      Left = 154
      Top = 343
      Width = 75
      Height = 25
      Caption = 'btnOk'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object lbFormats: TcxListBox
      Left = 10
      Top = 259
      Width = 295
      Height = 78
      ItemHeight = 13
      TabOrder = 11
      OnDblClick = lbFormatsDblClick
    end
    object cbValues: TcxCheckBox
      Left = 10
      Top = 29
      Caption = 'cbValues'
      Properties.OnChange = PasteOptionsChanged
      State = cbsChecked
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 3
      Transparent = True
    end
    object cbFormulas: TcxCheckBox
      Left = 30
      Top = 54
      Caption = 'cbFormulas'
      Properties.OnChange = PasteOptionsChanged
      State = cbsChecked
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 4
      Transparent = True
    end
    object lbPasteOptions: TcxLabel
      Left = 10
      Top = 10
      Caption = 'lbPasteOptions'
      Style.HotTrack = False
      Style.TransparentBorder = False
      Transparent = True
    end
    object cbSkipBlanks: TcxCheckBox
      Left = 10
      Top = 216
      Caption = 'cbSkipBlanks'
      Properties.OnChange = PasteOptionsChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 10
      Transparent = True
    end
    object cbComments: TcxCheckBox
      Left = 10
      Top = 79
      Caption = 'cbComments'
      Properties.OnChange = PasteOptionsChanged
      State = cbsChecked
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 5
      Transparent = True
    end
    object cbStyles: TcxCheckBox
      Left = 10
      Top = 104
      Caption = 'cbStyles'
      Properties.OnChange = PasteOptionsChanged
      State = cbsChecked
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 6
      Transparent = True
    end
    object cbColumnWidths: TcxCheckBox
      Left = 10
      Top = 179
      Caption = 'cbColumnWidths'
      Properties.OnChange = PasteOptionsChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 9
      Transparent = True
    end
    object rbAll: TcxRadioButton
      Left = 30
      Top = 129
      Caption = 'rbAll'
      Checked = True
      Color = 16053234
      ParentColor = False
      TabOrder = 7
      TabStop = True
      AutoSize = True
      ParentBackground = False
      Transparent = True
    end
    object rbNumberFormatting: TcxRadioButton
      Left = 30
      Top = 154
      Caption = 'rbNumberFormatting'
      Color = 16053234
      ParentColor = False
      TabOrder = 8
      AutoSize = True
      ParentBackground = False
      Transparent = True
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
    object dxLayoutItem2: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup1
      AlignVert = avClient
      CaptionOptions.Text = 'cxButton2'
      CaptionOptions.Visible = False
      Control = btnCancel
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup
      Parent = lcMainGroup_Root
      AlignHorz = ahRight
      AlignVert = avBottom
      LayoutDirection = ldHorizontal
      Index = 0
    end
    object dxLayoutItem1: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup1
      AlignHorz = ahLeft
      AlignVert = avClient
      CaptionOptions.Text = 'cxButton1'
      CaptionOptions.Visible = False
      Control = btnOk
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lgPasteOptions: TdxLayoutGroup
      Parent = lcMainGroup_Root
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'New Group'
      ShowBorder = False
      Index = 1
    end
    object lgPasteFormats: TdxLayoutGroup
      Parent = lcMainGroup_Root
      AlignVert = avClient
      CaptionOptions.Text = 'New Group'
      ShowBorder = False
      Index = 2
    end
    object liPasteFormat: TdxLayoutItem
      Parent = lgPasteFormats
      AlignHorz = ahLeft
      AlignVert = avClient
      CaptionOptions.Text = 'Paste As:'
      CaptionOptions.Layout = clTop
      Control = lbFormats
      ControlOptions.OriginalHeight = 78
      ControlOptions.OriginalWidth = 295
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem7: TdxLayoutItem
      Parent = lgPasteOptions
      CaptionOptions.Visible = False
      Control = cbValues
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem6: TdxLayoutItem
      Parent = lgPasteOptions
      Offsets.Left = 20
      CaptionOptions.Visible = False
      Control = cbFormulas
      ControlOptions.AlignHorz = ahLeft
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutItem10: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup2
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = lbPasteOptions
      ControlOptions.OriginalHeight = 13
      ControlOptions.OriginalWidth = 72
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem8: TdxLayoutItem
      Parent = lgPasteOptions
      CaptionOptions.Visible = False
      Control = cbSkipBlanks
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 9
    end
    object dxLayoutSeparatorItem1: TdxLayoutSeparatorItem
      Parent = lgPasteOptions
      SizeOptions.Width = 300
      CaptionOptions.Text = 'Separator'
      Index = 8
    end
    object dxLayoutItem5: TdxLayoutItem
      Parent = lgPasteOptions
      CaptionOptions.Visible = False
      Control = cbComments
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object dxLayoutItem3: TdxLayoutItem
      Parent = lgPasteOptions
      CaptionOptions.Visible = False
      Control = cbStyles
      ControlOptions.AlignHorz = ahLeft
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 61
      ControlOptions.ShowBorder = False
      Index = 4
    end
    object dxLayoutItem9: TdxLayoutItem
      Parent = lgPasteOptions
      CaptionOptions.Visible = False
      Control = cbColumnWidths
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 7
    end
    object dxLayoutItem4: TdxLayoutItem
      Parent = lgPasteOptions
      Offsets.Left = 20
      CaptionOptions.Visible = False
      Control = rbAll
      ControlOptions.AlignHorz = ahLeft
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 42
      ControlOptions.ShowBorder = False
      Index = 5
    end
    object dxLayoutItem11: TdxLayoutItem
      Parent = lgPasteOptions
      Offsets.Left = 20
      CaptionOptions.Visible = False
      Control = rbNumberFormatting
      ControlOptions.AlignHorz = ahLeft
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 120
      ControlOptions.ShowBorder = False
      Index = 6
    end
    object dxLayoutSeparatorItem2: TdxLayoutSeparatorItem
      Parent = dxLayoutAutoCreatedGroup2
      AlignHorz = ahClient
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object dxLayoutAutoCreatedGroup2: TdxLayoutAutoCreatedGroup
      Parent = lgPasteOptions
      LayoutDirection = ldHorizontal
      Index = 0
    end
  end
  object dxLayoutLookAndFeelList: TdxLayoutLookAndFeelList
    Left = 8
    Top = 400
    object dxLayoutCxLookAndFeel1: TdxLayoutCxLookAndFeel
      PixelsPerInch = 96
    end
  end
end
