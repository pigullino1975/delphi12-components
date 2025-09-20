object fmSelectLanguage: TfmSelectLanguage
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Select Language'
  ClientHeight = 335
  ClientWidth = 250
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object dxLayoutControl1: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 250
    Height = 335
    Align = alClient
    TabOrder = 0
    LayoutLookAndFeel = dxLayoutSkinLookAndFeel3
    ExplicitWidth = 241
    ExplicitHeight = 325
    object cxButton1: TcxButton
      Top = 121
      Width = 158
      Height = 25
      Caption = 'English'
      ModalResult = 1
      TabOrder = 0
      OnClick = cxButton1Click
    end
    object cxButton2: TcxButton
      Tag = 1025
      Top = 188
      Width = 158
      Height = 25
      Caption = 'Arabic'
      ModalResult = 1
      TabOrder = 1
      OnClick = cxButton1Click
    end
    object cxButton3: TcxButton
      Tag = 1037
      Top = 219
      Width = 158
      Height = 25
      Caption = 'Hebrew'
      ModalResult = 1
      TabOrder = 2
      OnClick = cxButton1Click
    end
    object dxLayoutControl1Group_Root: TdxLayoutGroup
      AlignHorz = ahParentManaged
      AlignVert = avParentManaged
      ButtonOptions.Buttons = <>
      Hidden = True
      ItemIndex = 3
      Padding.Left = 28
      Padding.Right = 28
      Padding.AssignedValues = [lpavLeft, lpavRight]
      ShowBorder = False
      Index = -1
    end
    object dxLayoutLabeledItem1: TdxLayoutLabeledItem
      Parent = dxLayoutControl1Group_Root
      CaptionOptions.AlignHorz = taCenter
      CaptionOptions.Text = 
        'DevExpress controls support RTL locales. Please select the langu' +
        'age and locale you want to use.'
      CaptionOptions.WordWrap = True
      LayoutLookAndFeel = dxLayoutSkinLookAndFeel1
      Index = 1
    end
    object dxLayoutItem1: TdxLayoutItem
      Parent = dxLayoutGroup1
      CaptionOptions.Text = 'New Item'
      CaptionOptions.Visible = False
      Control = cxButton1
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem2: TdxLayoutItem
      Parent = dxLayoutGroup1
      CaptionOptions.Text = 'New Item'
      CaptionOptions.Visible = False
      Control = cxButton2
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 4
    end
    object dxLayoutItem3: TdxLayoutItem
      Parent = dxLayoutGroup1
      CaptionOptions.Text = 'New Item'
      CaptionOptions.Visible = False
      Control = cxButton3
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 5
    end
    object dxLayoutLabeledItem2: TdxLayoutLabeledItem
      Parent = dxLayoutGroup1
      AlignHorz = ahLeft
      CaptionOptions.Text = 'Left to Right'
      LayoutLookAndFeel = dxLayoutSkinLookAndFeel2
      Index = 0
    end
    object dxLayoutLabeledItem3: TdxLayoutLabeledItem
      Parent = dxLayoutGroup1
      AlignHorz = ahLeft
      CaptionOptions.Text = 'Right to Left'
      LayoutLookAndFeel = dxLayoutSkinLookAndFeel2
      Index = 3
    end
    object dxLayoutEmptySpaceItem1: TdxLayoutEmptySpaceItem
      Parent = dxLayoutControl1Group_Root
      CaptionOptions.Text = 'Empty Space Item'
      SizeOptions.Height = 10
      SizeOptions.Width = 10
      Index = 0
    end
    object dxLayoutEmptySpaceItem2: TdxLayoutEmptySpaceItem
      Parent = dxLayoutControl1Group_Root
      CaptionOptions.Text = 'Empty Space Item'
      SizeOptions.Height = 10
      SizeOptions.Width = 10
      Index = 2
    end
    object dxLayoutEmptySpaceItem3: TdxLayoutEmptySpaceItem
      Parent = dxLayoutGroup1
      CaptionOptions.Text = 'Empty Space Item'
      SizeOptions.Height = 10
      SizeOptions.Width = 10
      Index = 2
    end
    object dxLayoutGroup1: TdxLayoutGroup
      Parent = dxLayoutControl1Group_Root
      CaptionOptions.Text = 'New Group'
      Offsets.Left = 8
      Offsets.Right = 8
      ButtonOptions.Buttons = <>
      Hidden = True
      Padding.AssignedValues = [lpavLeft, lpavRight]
      ShowBorder = False
      Index = 3
    end
  end
  object dxLayoutLookAndFeelList1: TdxLayoutLookAndFeelList
    Left = 104
    Top = 240
    object dxLayoutSkinLookAndFeel1: TdxLayoutSkinLookAndFeel
      ItemOptions.CaptionOptions.Font.Charset = DEFAULT_CHARSET
      ItemOptions.CaptionOptions.Font.Color = clWindowText
      ItemOptions.CaptionOptions.Font.Height = -12
      ItemOptions.CaptionOptions.Font.Name = 'Segoe UI'
      ItemOptions.CaptionOptions.Font.Style = []
      ItemOptions.CaptionOptions.UseDefaultFont = False
      PixelsPerInch = 96
    end
    object dxLayoutSkinLookAndFeel2: TdxLayoutSkinLookAndFeel
      ItemOptions.CaptionOptions.TextColor = clGray
      PixelsPerInch = 96
    end
    object dxLayoutSkinLookAndFeel3: TdxLayoutSkinLookAndFeel
      PixelsPerInch = 96
    end
  end
  object dxSkinController1: TdxSkinController
    Left = 160
    Top = 80
  end
end
