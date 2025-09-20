inherited frmRichEditHyperlinksAndBookmarks: TfrmRichEditHyperlinksAndBookmarks
  Width = 553
  inherited plTop: TPanel
    Width = 553
    Height = 130
    AutoSize = True
    Visible = True
    ExplicitHeight = 130
    object lcTop: TdxLayoutControl
      Left = 0
      Top = 0
      Width = 553
      Height = 130
      Align = alTop
      TabOrder = 0
      AutoSize = True
      ExplicitWidth = 451
      object cbShowBookmarks: TcxCheckBox
        Left = 26
        Top = 33
        Caption = 'Show Bookmarks'
        Properties.OnEditValueChanged = cbShowBookmarksPropertiesEditValueChanged
        State = cbsChecked
        Style.HotTrack = False
        Style.TransparentBorder = False
        TabOrder = 0
        Transparent = True
      end
      object ccbBookmarksColor: TcxColorComboBox
        Left = 133
        Top = 60
        ColorValue = clBlue
        Properties.CustomColors = <>
        Properties.OnEditValueChanged = ccbBookmarksColorPropertiesEditValueChanged
        Style.HotTrack = False
        Style.TransparentBorder = False
        TabOrder = 1
        Width = 121
      end
      object cbShowTooltip: TcxCheckBox
        Left = 289
        Top = 60
        Caption = 'Show Tooltip'
        Properties.OnEditValueChanged = cbShowTooltipPropertiesEditValueChanged
        State = cbsChecked
        Style.HotTrack = False
        Style.TransparentBorder = False
        TabOrder = 5
        Transparent = True
      end
      object cbCtrl: TcxCheckBox
        Left = 378
        Top = 33
        Caption = 'Ctrl'
        Properties.OnChange = cbModifierKeysPropertiesChange
        State = cbsChecked
        Style.HotTrack = False
        Style.TransparentBorder = False
        TabOrder = 2
        Transparent = True
      end
      object cbAlt: TcxCheckBox
        Left = 425
        Top = 33
        Caption = 'Alt'
        Properties.OnChange = cbModifierKeysPropertiesChange
        Style.HotTrack = False
        Style.TransparentBorder = False
        TabOrder = 3
        Transparent = True
      end
      object cbShift: TcxCheckBox
        Left = 467
        Top = 33
        Caption = 'Shift'
        Properties.OnChange = cbModifierKeysPropertiesChange
        Style.HotTrack = False
        Style.TransparentBorder = False
        TabOrder = 4
        Transparent = True
      end
      object lcTopGroup_Root: TdxLayoutGroup
        AlignHorz = ahLeft
        AlignVert = avTop
        LayoutLookAndFeel = llfTop
        ButtonOptions.Buttons = <>
        Hidden = True
        LayoutDirection = ldHorizontal
        ShowBorder = False
        Index = -1
      end
      object lgBookmarks: TdxLayoutGroup
        Parent = lcTopGroup_Root
        AlignHorz = ahLeft
        CaptionOptions.Text = 'Bookmarks'
        ButtonOptions.Buttons = <>
        Index = 0
      end
      object lgHyperlinks: TdxLayoutGroup
        Parent = lcTopGroup_Root
        AlignHorz = ahLeft
        CaptionOptions.Text = 'Hyperlinks'
        ButtonOptions.Buttons = <>
        Index = 1
      end
      object liShowBookmarks: TdxLayoutItem
        Parent = lgBookmarks
        CaptionOptions.Text = 'New Item'
        CaptionOptions.Visible = False
        Control = cbShowBookmarks
        ControlOptions.OriginalHeight = 20
        ControlOptions.OriginalWidth = 98
        ControlOptions.ShowBorder = False
        Index = 0
      end
      object liBookmarksColor: TdxLayoutItem
        Parent = lgBookmarks
        CaptionOptions.Text = 'Bookmarks Color:'
        Control = ccbBookmarksColor
        ControlOptions.OriginalHeight = 22
        ControlOptions.OriginalWidth = 121
        ControlOptions.ShowBorder = False
        Index = 1
      end
      object liAlt: TdxLayoutItem
        Parent = lgKeys
        AlignHorz = ahLeft
        AlignVert = avClient
        CaptionOptions.Text = 'New Item'
        CaptionOptions.Visible = False
        Control = cbAlt
        ControlOptions.OriginalHeight = 17
        ControlOptions.OriginalWidth = 35
        ControlOptions.ShowBorder = False
        Index = 2
      end
      object liCtrl: TdxLayoutItem
        Parent = lgKeys
        CaptionOptions.Text = 'Ctrl'
        CaptionOptions.Visible = False
        Control = cbCtrl
        ControlOptions.OriginalHeight = 20
        ControlOptions.OriginalWidth = 40
        ControlOptions.ShowBorder = False
        Index = 1
      end
      object liShift: TdxLayoutItem
        Parent = lgKeys
        AlignHorz = ahLeft
        AlignVert = avClient
        CaptionOptions.Text = 'Shist'
        CaptionOptions.Visible = False
        Control = cbShift
        ControlOptions.OriginalHeight = 17
        ControlOptions.OriginalWidth = 46
        ControlOptions.ShowBorder = False
        Index = 3
      end
      object liShowTooltip: TdxLayoutItem
        Parent = lgHyperlinks
        AlignHorz = ahLeft
        CaptionOptions.Text = 'New Item'
        CaptionOptions.Visible = False
        Control = cbShowTooltip
        ControlOptions.OriginalHeight = 20
        ControlOptions.OriginalWidth = 95
        ControlOptions.ShowBorder = False
        Index = 1
      end
      object lgKeys: TdxLayoutGroup
        Parent = lgHyperlinks
        AlignHorz = ahLeft
        AlignVert = avTop
        CaptionOptions.Text = 'New Group'
        CaptionOptions.Visible = False
        ButtonOptions.Buttons = <>
        ItemIndex = 2
        LayoutDirection = ldHorizontal
        ShowBorder = False
        Index = 0
      end
      object llbModifierKeys: TdxLayoutLabeledItem
        Parent = lgKeys
        CaptionOptions.Text = 'Modifier Keys:'
        Index = 0
      end
    end
  end
  inherited pnlSeparator: TPanel
    Top = 130
    Width = 553
    ExplicitTop = 50
  end
  inherited lcDescription: TdxLayoutControl
    Width = 553
  end
  inherited RichEditControl: TdxRichEditControl
    Top = 130
    Width = 553
    Height = 101
    ExplicitTop = 50
    ExplicitHeight = 181
  end
  object llflTop: TdxLayoutLookAndFeelList
    Left = 240
    Top = 152
    object llfTop: TdxLayoutCxLookAndFeel
      PixelsPerInch = 96
    end
  end
end
