object dxSpreadSheetCellsModificationDialogForm: TdxSpreadSheetCellsModificationDialogForm
  Left = 0
  Top = 0
  AutoSize = True
  BorderStyle = bsDialog
  Caption = 'dxSpreadSheetCellsModificationDialogForm'
  ClientHeight = 193
  ClientWidth = 201
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object lcMain: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 201
    Height = 193
    TabOrder = 0
    AutoSize = True
    LayoutLookAndFeel = dxLayoutCxLookAndFeel
    object lbCaption: TcxLabel
      Left = 10
      Top = 10
      Caption = 'lbCaption'
      Style.HotTrack = False
      Style.TransparentBorder = False
      Transparent = True
    end
    object btnCancel: TcxButton
      Left = 101
      Top = 149
      Width = 85
      Height = 25
      Cancel = True
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 6
    end
    object btnOk: TcxButton
      Left = 10
      Top = 149
      Width = 85
      Height = 25
      Caption = '&OK'
      Default = True
      ModalResult = 1
      TabOrder = 5
    end
    object rbShiftHorizontally: TcxRadioButton
      Left = 10
      Top = 29
      Caption = 'rbShiftHorizontally'
      Checked = True
      Color = 15921906
      ParentColor = False
      TabOrder = 1
      TabStop = True
      AutoSize = True
      ParentBackground = False
      Transparent = True
    end
    object rbShiftVertically: TcxRadioButton
      Left = 10
      Top = 55
      Caption = 'rbShiftVertically'
      Color = 15921906
      ParentColor = False
      TabOrder = 2
      AutoSize = True
      ParentBackground = False
      Transparent = True
    end
    object rbShiftRow: TcxRadioButton
      Left = 10
      Top = 81
      Caption = 'rbShiftRow'
      Color = 15921906
      ParentColor = False
      TabOrder = 3
      AutoSize = True
      ParentBackground = False
      Transparent = True
    end
    object rbShiftColumn: TcxRadioButton
      Left = 10
      Top = 107
      Caption = 'rbShiftColumn'
      Color = 15921906
      ParentColor = False
      TabOrder = 4
      AutoSize = True
      ParentBackground = False
      Transparent = True
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
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Visible = False
      ItemIndex = 1
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 0
    end
    object lcMainItem3: TdxLayoutItem
      Parent = dxLayoutGroup1
      AlignHorz = ahLeft
      CaptionOptions.Text = 'cxLabel1'
      CaptionOptions.Visible = False
      Control = lbCaption
      ControlOptions.OriginalHeight = 13
      ControlOptions.OriginalWidth = 45
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutSeparatorItem1: TdxLayoutSeparatorItem
      Parent = dxLayoutGroup1
      AlignHorz = ahClient
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object lcMainGroup1: TdxLayoutGroup
      Parent = lcMainGroup_Root
      AlignHorz = ahCenter
      AlignVert = avBottom
      CaptionOptions.Text = 'New Group'
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 6
    end
    object lcMainItem2: TdxLayoutItem
      Parent = lcMainGroup1
      AlignHorz = ahClient
      CaptionOptions.Text = 'cxButton1'
      CaptionOptions.Visible = False
      Control = btnCancel
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 85
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lcMainItem1: TdxLayoutItem
      Parent = lcMainGroup1
      CaptionOptions.Text = 'cxButton2'
      CaptionOptions.Visible = False
      Control = btnOk
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 85
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lcMainItem4: TdxLayoutItem
      Parent = lcMainGroup_Root
      CaptionOptions.Text = 'cxRadioButton1'
      CaptionOptions.Visible = False
      Control = rbShiftHorizontally
      ControlOptions.AlignHorz = ahLeft
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 20
      ControlOptions.OriginalWidth = 111
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lcMainItem5: TdxLayoutItem
      Parent = lcMainGroup_Root
      CaptionOptions.Text = 'cxRadioButton2'
      CaptionOptions.Visible = False
      Control = rbShiftVertically
      ControlOptions.AlignHorz = ahLeft
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 20
      ControlOptions.OriginalWidth = 98
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object lcMainItem6: TdxLayoutItem
      Parent = lcMainGroup_Root
      CaptionOptions.Text = 'cxRadioButton3'
      CaptionOptions.Visible = False
      Control = rbShiftRow
      ControlOptions.AlignHorz = ahLeft
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 20
      ControlOptions.OriginalWidth = 76
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object lcMainItem7: TdxLayoutItem
      Parent = lcMainGroup_Root
      CaptionOptions.Text = 'cxRadioButton4'
      CaptionOptions.Visible = False
      Control = rbShiftColumn
      ControlOptions.AlignHorz = ahLeft
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 20
      ControlOptions.OriginalWidth = 90
      ControlOptions.ShowBorder = False
      Index = 4
    end
    object dxLayoutEmptySpaceItem1: TdxLayoutEmptySpaceItem
      Parent = lcMainGroup_Root
      SizeOptions.Height = 10
      SizeOptions.Width = 10
      CaptionOptions.Text = 'Empty Space Item'
      Index = 5
    end
  end
  object dxLayoutLookAndFeelList: TdxLayoutLookAndFeelList
    Left = 152
    object dxLayoutCxLookAndFeel: TdxLayoutCxLookAndFeel
      PixelsPerInch = 96
    end
  end
end
