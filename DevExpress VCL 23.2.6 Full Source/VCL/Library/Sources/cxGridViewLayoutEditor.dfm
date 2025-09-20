object cxGridViewLayoutEditor: TcxGridViewLayoutEditor
  Left = 350
  Top = 204
  BorderIcons = [biSystemMenu]
  Caption = 'Layout and Data Editor'
  ClientHeight = 466
  ClientWidth = 692
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lcMain: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 692
    Height = 466
    Align = alClient
    TabOrder = 0
    LayoutLookAndFeel = dxLayoutCxLookAndFeel1
    object btnLayoutCustomization: TcxButton
      Left = 10
      Top = 429
      Width = 150
      Height = 24
      TabOrder = 0
      OnClick = btnLayoutCustomizationClick
    end
    object chbSaveLayout: TcxCheckBox
      Left = 322
      Top = 426
      Caption = 'Save layout'
      State = cbsChecked
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 2
      Transparent = True
    end
    object chbSaveData: TcxCheckBox
      Left = 410
      Top = 426
      Caption = 'Save data'
      State = cbsChecked
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 3
      Transparent = True
    end
    object btnOK: TcxButton
      Left = 526
      Top = 429
      Width = 75
      Height = 24
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 4
    end
    object btnCancel: TcxButton
      Left = 607
      Top = 429
      Width = 75
      Height = 24
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 5
    end
    object btnConditionalFormatting: TcxButton
      Left = 166
      Top = 429
      Width = 150
      Height = 24
      Caption = 'Conditional Formatting...'
      TabOrder = 1
      OnClick = btnConditionalFormattingClick
    end
    object lcMainGroup_Root: TdxLayoutGroup
      AlignHorz = ahClient
      AlignVert = avClient
      Hidden = True
      ItemIndex = 1
      ShowBorder = False
      Index = -1
    end
    object dxLayoutGroup1: TdxLayoutGroup
      Parent = lcMainGroup_Root
      AlignHorz = ahClient
      AlignVert = avBottom
      CaptionOptions.Text = 'Hidden Group'
      Hidden = True
      ItemIndex = 2
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 0
    end
    object pnlLayoutCustomization: TdxLayoutItem
      Parent = dxLayoutGroup1
      AlignHorz = ahLeft
      AlignVert = avCenter
      CaptionOptions.Text = 'btnLayoutCustomization'
      CaptionOptions.Visible = False
      Control = btnLayoutCustomization
      ControlOptions.OriginalHeight = 24
      ControlOptions.OriginalWidth = 150
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutGroup2: TdxLayoutGroup
      Parent = dxLayoutGroup1
      AlignHorz = ahLeft
      AlignVert = avCenter
      CaptionOptions.Text = 'Hidden Group'
      Hidden = True
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 2
    end
    object liSaveLayout: TdxLayoutItem
      Parent = dxLayoutGroup2
      AlignHorz = ahLeft
      AlignVert = avCenter
      CaptionOptions.Text = 'chbSaveLayout'
      CaptionOptions.Visible = False
      Control = chbSaveLayout
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 82
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object liSaveData: TdxLayoutItem
      Parent = dxLayoutGroup2
      AlignHorz = ahLeft
      AlignVert = avCenter
      CaptionOptions.Text = 'chbSaveData'
      CaptionOptions.Visible = False
      Control = chbSaveData
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 74
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutGroup3: TdxLayoutGroup
      Parent = dxLayoutGroup1
      AlignHorz = ahRight
      AlignVert = avCenter
      CaptionOptions.Text = 'Hidden Group'
      Hidden = True
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 3
    end
    object liOK: TdxLayoutItem
      Parent = dxLayoutGroup3
      AlignHorz = ahLeft
      AlignVert = avCenter
      CaptionOptions.Text = 'btnOK'
      CaptionOptions.Visible = False
      Control = btnOK
      ControlOptions.OriginalHeight = 24
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem5: TdxLayoutItem
      Parent = dxLayoutGroup3
      AlignHorz = ahLeft
      AlignVert = avCenter
      CaptionOptions.Text = 'btnCancel'
      CaptionOptions.Visible = False
      Control = btnCancel
      ControlOptions.OriginalHeight = 24
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object liClient: TdxLayoutItem
      Parent = lcMainGroup_Root
      AlignVert = avClient
      Index = 1
    end
    object liConditionalFormatting: TdxLayoutItem
      Parent = dxLayoutGroup1
      AlignVert = avCenter
      CaptionOptions.Text = 'cxButton1'
      CaptionOptions.Visible = False
      Control = btnConditionalFormatting
      ControlOptions.OriginalHeight = 24
      ControlOptions.OriginalWidth = 150
      ControlOptions.ShowBorder = False
      Index = 1
    end
  end
  object pmGrid: TcxGridPopupMenu
    PopupMenus = <>
    Left = 400
    Top = 319
  end
  object dxLayoutLookAndFeelList1: TdxLayoutLookAndFeelList
    object dxLayoutCxLookAndFeel1: TdxLayoutCxLookAndFeel
      LookAndFeel.Kind = lfUltraFlat
      LookAndFeel.NativeStyle = False
      PixelsPerInch = 96
    end
  end
end
