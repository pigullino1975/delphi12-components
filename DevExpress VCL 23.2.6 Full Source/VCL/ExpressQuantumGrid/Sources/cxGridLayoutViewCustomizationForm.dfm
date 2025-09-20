inherited cxGridLayoutViewCustomizationForm: TcxGridLayoutViewCustomizationForm
  PixelsPerInch = 96
  TextHeight = 13
  AutoScroll = False
  inherited lcMain: TdxLayoutControl
    inherited tvVisibleItems: TdxTreeViewControl
      Left = 46
      Top = 134
      Height = 329
    end
    inherited btnClose: TcxButton
      TabOrder = 29
    end
    inherited cbTabbedView: TcxCheckBox
      TabOrder = 28
    end
    inherited btnAlignBy: TcxButton
      Left = 127
      Top = 106
      TabOrder = 10
    end
    inherited btnTreeViewItemsDelete: TcxButton
      Left = 98
      Top = 106
    end
    inherited btnTreeViewCollapseAll: TcxButton
      Left = 69
      Top = 106
    end
    inherited btnTreeViewExpandAll: TcxButton
      Left = 46
      Top = 106
    end
    inherited btnAvailableItemsViewAsList: TcxButton
      TabOrder = 19
    end
    inherited cxButton2: TcxButton
      Left = 150
      Top = 106
      TabOrder = 11
    end
    inherited cxButton3: TcxButton
      TabOrder = 20
    end
    inherited btnOk: TcxButton
      TabOrder = 25
    end
    inherited btnCancel: TcxButton
      TabOrder = 26
    end
    object cbSaveLayout: TcxCheckBox
      Left = 166
      Top = 492
      Caption = 'Save layout'
      State = cbsChecked
      Style.HotTrack = False
      TabOrder = 24
      Transparent = True
    end
    object gMain: TcxGrid [27]
      Left = 10000
      Top = 10000
      Width = 707
      Height = 429
      TabOrder = 22
      Visible = False
    end
    object cbSaveData: TcxCheckBox [28]
      Left = 253
      Top = 491
      Caption = 'Save data'
      State = cbsChecked
      Style.HotTrack = False
      TabOrder = 27
    end
    object btnConditionalFormatting: TcxButton [29]
      Left = 10
      Top = 489
      Width = 150
      Height = 25
      Caption = 'Conditional Formatting...'
      TabOrder = 23
      OnClick = btnConditionalFormattingClick
    end
    inherited lcMainGroup_Root: TdxLayoutGroup
      ItemIndex = 2
    end
    inherited lcMainItem10: TdxLayoutItem
      CaptionOptions.Text = 'btnTreeViewExpandAll'
    end
    inherited lcMainItem9: TdxLayoutItem
      CaptionOptions.Text = 'btnTreeViewCollapseAll'
    end
    inherited lcMainItem7: TdxLayoutItem
      CaptionOptions.Text = 'btnTreeViewItemsDelete'
    end
    inherited liAlignBy: TdxLayoutItem
      CaptionOptions.Text = 'btnAlignBy'
      Index = 5
    end
    inherited lcMainItem15: TdxLayoutItem
      CaptionOptions.Text = 'btnAvailableItemsExpandAll'
    end
    inherited lcMainItem14: TdxLayoutItem
      CaptionOptions.Text = 'btnAvailableItemsCollapseAll'
    end
    inherited lcMainItem13: TdxLayoutItem
      CaptionOptions.Text = 'btnAddGroup'
    end
    inherited liAddItem: TdxLayoutItem
      CaptionOptions.Text = 'cxButton1'
    end
    inherited liAddCustomItem: TdxLayoutItem
      CaptionOptions.Text = 'btnAddItem'
    end
    inherited lcMainItem11: TdxLayoutItem
      CaptionOptions.Text = 'btnAvailableItemsDelete'
    end
    inherited lcMainItem3: TdxLayoutItem
      CaptionOptions.Text = 'btnAvailableItemsViewAsList'
      Index = 8
    end
    inherited liVisibleItemsMakeFloat: TdxLayoutItem
      Index = 6
    end
    inherited liAvailableItemsMakeFloat: TdxLayoutItem
      Index = 9
    end
    inherited lcMainGroup5: TdxLayoutGroup
      Parent = lcMainTemplateCardGroup
      Index = 0
    end
    inherited lcMainGroup4: TdxLayoutGroup
      Index = 1
    end
    object liSaveLayout: TdxLayoutItem
      Parent = lcMainGroup3
      AlignVert = avCenter
      CaptionOptions.Text = 'cxCheckBox1'
      CaptionOptions.Visible = False
      Control = cbSaveLayout
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 78
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object lcMainTemplateCardGroup: TdxLayoutGroup
      Parent = lcMainTabbedGroup
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'Template Card'
      ButtonOptions.Buttons = <>
      Index = 0
    end
    object lcMainTabbedGroup: TdxLayoutGroup
      Parent = lcMainGroup_Root
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'New Group'
      ButtonOptions.Buttons = <>
      LayoutDirection = ldTabbed
      ShowBorder = False
      OnTabChanged = lcMainTabbedGroupTabChanged
      Index = 1
    end
    object lcMainViewLayoutGroup: TdxLayoutGroup
      Parent = lcMainTabbedGroup
      CaptionOptions.Text = 'View Layout'
      ButtonOptions.Buttons = <>
      Index = 1
    end
    object lcMainItem16: TdxLayoutItem
      Parent = lcMainViewLayoutGroup
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'cxGrid1'
      CaptionOptions.Visible = False
      Control = gMain
      ControlOptions.OriginalHeight = 429
      ControlOptions.OriginalWidth = 707
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object liSaveData: TdxLayoutItem
      Parent = lcMainGroup3
      AlignHorz = ahLeft
      AlignVert = avCenter
      CaptionOptions.Text = 'cxCheckBox1'
      CaptionOptions.Visible = False
      Control = cbSaveData
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 73
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object liConditionalFormatting: TdxLayoutItem
      Parent = lcMainGroup3
      AlignVert = avCenter
      CaptionOptions.Visible = False
      Control = btnConditionalFormatting
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 150
      ControlOptions.ShowBorder = False
      Index = 0
    end
  end
  inherited alMain: TActionList
    object acUseHorizontalScrolling: TAction
      Tag = 1
      Caption = 'Horizontal'
      OnExecute = acUseScrollingExecute
    end
    object acUseVerticalScrolling: TAction
      Caption = 'Vertical'
      OnExecute = acUseScrollingExecute
    end
  end
  inherited pmTreeViewActions: TPopupMenu
    object miGroupScrolling: TMenuItem [13]
      Caption = 'Group Scrolling'
      object miHorizontalScrolling: TMenuItem
        Action = acUseHorizontalScrolling
      end
      object miVerticalScrolling: TMenuItem
        Action = acUseVerticalScrolling
      end
    end
  end
  inherited dxLayoutLookAndFeelList1: TdxLayoutLookAndFeelList
    inherited llfMain: TdxLayoutCxLookAndFeel
      PixelsPerInch = 96
    end
  end
end
