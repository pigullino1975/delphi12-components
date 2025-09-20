object fmBaseForm: TfmBaseForm
  Left = 420
  Top = 223
  Caption = 'fmBaseForm'
  ClientHeight = 623
  ClientWidth = 783
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = mmMain
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object lcMain: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 783
    Height = 623
    Align = alClient
    TabOrder = 0
    LayoutLookAndFeel = dxLayoutCxLookAndFeel1
    object lbDescription: TLabel
      Left = 10
      Top = 10
      Width = 763
      Height = 16
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 12937777
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      WordWrap = True
    end
    object lcMainGroup_Root: TdxLayoutGroup
      AlignHorz = ahClient
      AlignVert = avClient
      ButtonOptions.Buttons = <>
      Hidden = True
      ShowBorder = False
      Index = -1
    end
    object liDescription: TdxLayoutItem
      Parent = lcMainGroup_Root
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'lbDescription'
      CaptionOptions.Visible = False
      Control = lbDescription
      ControlOptions.OriginalHeight = 16
      ControlOptions.OriginalWidth = 4
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lgContent: TdxLayoutGroup
      Parent = lcMainGroup_Root
      AlignVert = avClient
      CaptionOptions.Text = 'New Group'
      ButtonOptions.Buttons = <>
      Hidden = True
      ShowBorder = False
      Index = 1
    end
  end
  object mmMain: TMainMenu
    Left = 128
    Top = 8
    object miFile: TMenuItem
      Caption = '&File'
      object miExit: TMenuItem
        Caption = 'E&xit'
        Hint = 'Press to quit the demo-program'
        ShortCut = 32856
        OnClick = miExitClick
      end
    end
    object miAbout: TMenuItem
      Caption = '&About this demo'
      Hint = 'Displays the brief description of the current demo features'
      OnClick = miAboutClick
    end
  end
  object SaveDialog: TdxSaveFileDialog
    Options = [ofOverwritePrompt, ofEnableSizing]
    Left = 24
    Top = 72
  end
  object OpenDialog: TdxOpenFileDialog
    Left = 24
    Top = 136
  end
  object dxLayoutLookAndFeelList1: TdxLayoutLookAndFeelList
    Left = 32
    Top = 8
    object dxLayoutCxLookAndFeel1: TdxLayoutCxLookAndFeel
      PixelsPerInch = 96
    end
  end
  object cxLookAndFeelController1: TcxLookAndFeelController
    Left = 128
    Top = 72
  end
end
