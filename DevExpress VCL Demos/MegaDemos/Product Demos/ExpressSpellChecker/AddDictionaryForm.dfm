object fmAddDictionary: TfmAddDictionary
  Left = 312
  Top = 264
  AutoSize = True
  BorderStyle = bsDialog
  Caption = 'Add Dictionary'
  ClientHeight = 270
  ClientWidth = 496
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  OnCreate = FormCreate
  TextHeight = 13
  object liCodePage: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 496
    Height = 270
    TabOrder = 0
    AutoSize = True
    LayoutLookAndFeel = dxLayoutSkinLookAndFeel1
    object btnAdd: TcxButton
      Left = 286
      Top = 221
      Width = 97
      Height = 25
      Caption = 'Add'
      Default = True
      ModalResult = 1
      TabOrder = 5
    end
    object btnCancel: TcxButton
      Left = 389
      Top = 221
      Width = 97
      Height = 25
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 6
    end
    object beAffFile: TcxButtonEdit
      Left = 84
      Top = 101
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = beAffFilePropertiesButtonClick
      Properties.OnChange = beAffFilePropertiesChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 1
      Width = 402
    end
    object beDicFile: TcxButtonEdit
      Tag = 1
      Left = 84
      Top = 128
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = beDicFilePropertiesButtonClick
      Properties.OnChange = beAffFilePropertiesChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 2
      Width = 402
    end
    object cbLang: TcxComboBox
      Left = 84
      Top = 155
      Properties.DropDownListStyle = lsEditFixedList
      Properties.ImmediatePost = True
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 3
      Width = 402
    end
    object cbCodePage: TcxComboBox
      Left = 84
      Top = 182
      Properties.DropDownListStyle = lsEditFixedList
      Properties.ImmediatePost = True
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 4
      Width = 402
    end
    object hlLink: TcxLabel
      Left = 124
      Top = 82
      Cursor = crHandPoint
      Caption = 'http://wiki.services.openoffice.org/wiki/Dictionaries'
      ParentColor = False
      Style.HotTrack = False
      Style.TextColor = clBlue
      Style.TextStyle = [fsUnderline]
      Style.TransparentBorder = False
      StyleFocused.BorderStyle = ebsNone
      StyleHot.BorderStyle = ebsNone
      Transparent = True
      OnClick = hlLinkClick
    end
    object liCodePageGroup_Root: TdxLayoutGroup
      AlignHorz = ahClient
      AlignVert = avTop
      Hidden = True
      ItemIndex = 4
      ShowBorder = False
      Index = -1
    end
    object dxLayoutGroup1: TdxLayoutGroup
      Parent = liCodePageGroup_Root
      CaptionOptions.Text = ' Choose a dictionary type '
      ItemIndex = 2
      LayoutDirection = ldHorizontal
      Index = 0
    end
    object lgDictionatyTypeHunspell: TdxLayoutRadioButtonItem
      Parent = dxLayoutGroup1
      CaptionOptions.Text = 'Hunspell (recommended)'
      Checked = True
      TabStop = True
      Index = 0
    end
    object lgDictionatyTypeOpenOffice: TdxLayoutRadioButtonItem
      Parent = dxLayoutGroup1
      CaptionOptions.Text = 'Open Office'
      Index = 1
    end
    object lgDictionatyTypeISpell: TdxLayoutRadioButtonItem
      Parent = dxLayoutGroup1
      CaptionOptions.Text = 'ISpell'
      Index = 2
    end
    object lgLink: TdxLayoutGroup
      Parent = liCodePageGroup_Root
      CaptionOptions.Visible = False
      ItemIndex = 1
      ShowBorder = False
      Index = 1
    end
    object dxLayoutLabeledItem1: TdxLayoutLabeledItem
      Parent = lgLink
      CaptionOptions.AlignHorz = taCenter
      CaptionOptions.Text = 
        'You can download free Hunspell dictionaries at the following URL' +
        ':'
      Index = 0
    end
    object dxLayoutItem1: TdxLayoutItem
      Parent = lgLink
      AlignHorz = ahCenter
      CaptionOptions.Text = 'New Item'
      CaptionOptions.Visible = False
      Control = hlLink
      ControlOptions.OriginalHeight = 13
      ControlOptions.OriginalWidth = 247
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutGroup3: TdxLayoutGroup
      Parent = liCodePageGroup_Root
      CaptionOptions.Visible = False
      ItemIndex = 3
      ShowBorder = False
      Index = 2
    end
    object dxLayoutItem2: TdxLayoutItem
      Parent = dxLayoutGroup3
      CaptionOptions.Text = 'Affix file:'
      Control = beAffFile
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 350
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem3: TdxLayoutItem
      Parent = dxLayoutGroup3
      CaptionOptions.Text = 'Dictionary file:'
      Control = beDicFile
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 350
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem4: TdxLayoutItem
      Parent = dxLayoutGroup3
      CaptionOptions.Text = 'Language:'
      Control = cbLang
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 350
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutItem5: TdxLayoutItem
      Parent = dxLayoutGroup3
      CaptionOptions.Text = 'Code page:'
      Control = cbCodePage
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 350
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object dxLayoutSeparatorItem1: TdxLayoutSeparatorItem
      Parent = liCodePageGroup_Root
      CaptionOptions.Text = 'Separator'
      Index = 3
    end
    object dxLayoutGroup4: TdxLayoutGroup
      Parent = liCodePageGroup_Root
      CaptionOptions.Visible = False
      ItemIndex = 1
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 4
    end
    object dxLayoutItem6: TdxLayoutItem
      Parent = dxLayoutGroup4
      AlignHorz = ahRight
      AlignVert = avTop
      CaptionOptions.Text = 'New Item'
      CaptionOptions.Visible = False
      Control = btnAdd
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 97
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem7: TdxLayoutItem
      Parent = dxLayoutGroup4
      AlignHorz = ahRight
      AlignVert = avTop
      CaptionOptions.Text = 'New Item'
      CaptionOptions.Visible = False
      Control = btnCancel
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 97
      ControlOptions.ShowBorder = False
      Index = 1
    end
  end
  object OpenDialog1: TdxOpenFileDialog
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 416
    Top = 64
  end
  object dxLayoutLookAndFeelList1: TdxLayoutLookAndFeelList
    Left = 384
    Top = 32
    object dxLayoutSkinLookAndFeel1: TdxLayoutSkinLookAndFeel
      PixelsPerInch = 96
    end
  end
end
