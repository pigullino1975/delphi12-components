object fmFilterControlDialog: TfmFilterControlDialog
  Left = 360
  Top = 200
  AutoScroll = False
  BorderIcons = [biSystemMenu]
  Caption = 'fmFilterControlDialog'
  ClientHeight = 316
  ClientWidth = 552
  Color = clBtnFace
  Constraints.MinHeight = 235
  Constraints.MinWidth = 560
  KeyPreview = True
  OldCreateOrder = False
  OnClose = FormClose
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  Font.Height = -11
  PixelsPerInch = 96
  TextHeight = 13
  object lcMain: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 552
    Height = 316
    Align = alClient
    TabOrder = 0
    AutoSize = True
    LayoutLookAndFeel = dxLayoutSkinLookAndFeel
    object btOpen: TcxButton
      Left = 7
      Top = 283
      Width = 100
      Height = 23
      Hint = 'Open|Opens an existing filter'
      Caption = '&Open...'
      TabOrder = 0
      OnClick = acOpenExecute
    end
    object btSave: TcxButton
      Left = 113
      Top = 283
      Width = 100
      Height = 23
      Hint = 'Save As|Saves the active filter with a new name'
      Caption = 'Save &As...'
      TabOrder = 1
      OnClick = acSaveExecute
    end
    object btApply: TcxButton
      Left = 445
      Top = 283
      Width = 100
      Height = 23
      Caption = 'Apply'
      TabOrder = 4
      OnClick = acApplyExecute
    end
    object btCancel: TcxButton
      Left = 339
      Top = 283
      Width = 100
      Height = 23
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 3
    end
    object btOk: TcxButton
      Left = 233
      Top = 283
      Width = 100
      Height = 23
      Caption = 'Ok'
      ModalResult = 1
      TabOrder = 2
      OnClick = acOkExecute
    end
    object lcMainGroup_Root: TdxLayoutGroup
      AlignHorz = ahClient
      AlignVert = avClient
      Hidden = True
      ShowBorder = False
      UseIndent = False
      Index = -1
    end
    object lgButtons: TdxLayoutGroup
      Parent = lcMainGroup_Root
      AlignHorz = ahClient
      AlignVert = avBottom
      CaptionOptions.Text = 'Hidden Group'
      Offsets.Bottom = 7
      Offsets.Left = 7
      Offsets.Right = 7
      Offsets.Top = 7
      Hidden = True
      ItemIndex = 4
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 0
    end
    object libtOpen: TdxLayoutItem
      Parent = lgButtons
      AlignHorz = ahLeft
      Control = btOpen
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 100
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object libtSave: TdxLayoutItem
      Parent = lgButtons
      AlignHorz = ahLeft
      Control = btSave
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 100
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object libtOk: TdxLayoutItem
      Parent = lgButtons
      AlignHorz = ahRight
      Control = btOk
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 100
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object libtCancel: TdxLayoutItem
      Parent = lgButtons
      AlignHorz = ahRight
      Control = btCancel
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 100
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object libtApply: TdxLayoutItem
      Parent = lgButtons
      AlignHorz = ahRight
      Control = btApply
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 100
      ControlOptions.ShowBorder = False
      Index = 4
    end
    object liFilterControl: TdxLayoutItem
      Parent = lcMainGroup_Root
      AlignHorz = ahClient
      AlignVert = avClient
      Index = 1
    end
  end
  object OpenDialog: TdxOpenFileDialog
    Left = 240
    Top = 8
  end
  object SaveDialog: TdxSaveFileDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 272
    Top = 8
  end
  object dxLayoutLookAndFeelList: TdxLayoutLookAndFeelList
    Left = 256
    Top = 56
    object dxLayoutSkinLookAndFeel: TdxLayoutSkinLookAndFeel
      Offsets.RootItemsAreaOffsetHorz = 0
      Offsets.RootItemsAreaOffsetVert = 0
      PixelsPerInch = 96
    end
  end
end
