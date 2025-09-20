object fmListViewEditor: TfmListViewEditor
  Left = 190
  Top = 158
  AutoScroll = False
  HelpContext = 26100
  BorderIcons = [biSystemMenu]
  Caption = 'ListView Items Editor'
  ClientHeight = 379
  ClientWidth = 700
  Color = clBtnFace
  Constraints.MinHeight = 250
  Constraints.MinWidth = 550
  ParentFont = True
  OldCreateOrder = True
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object dxLayoutControl1: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 700
    Height = 379
    Align = alClient
    TabOrder = 0
    AutoSize = True
    LayoutLookAndFeel = dxLayoutCxLookAndFeel1
    object btNewItem: TcxButton
      Left = 328
      Top = 62
      Width = 90
      Height = 24
      Anchors = [akTop, akRight]
      Caption = '&New Item'
      Default = True
      TabOrder = 1
      OnClick = btNewItemClick
    end
    object btDeleteItem: TcxButton
      Left = 328
      Top = 122
      Width = 90
      Height = 24
      Anchors = [akTop, akRight]
      Caption = '&Delete'
      TabOrder = 3
      OnClick = btDeleteItemClick
    end
    object btNewSubItem: TcxButton
      Left = 328
      Top = 92
      Width = 90
      Height = 24
      Anchors = [akTop, akRight]
      Caption = 'N&ew SubItem'
      TabOrder = 2
      OnClick = btNewSubItemClick
    end
    object btOk: TcxButton
      Left = 352
      Top = 345
      Width = 80
      Height = 24
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      TabOrder = 14
      OnClick = btOkClick
    end
    object btCancel: TcxButton
      Left = 438
      Top = 345
      Width = 80
      Height = 24
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 15
      OnClick = btCancelClick
    end
    object btApply: TcxButton
      Left = 524
      Top = 345
      Width = 80
      Height = 24
      Anchors = [akRight, akBottom]
      Caption = '&Apply'
      TabOrder = 16
      OnClick = btApplyItemsClick
    end
    object btHelp: TcxButton
      Left = 610
      Top = 345
      Width = 80
      Height = 24
      Anchors = [akRight, akBottom]
      Caption = '&Help'
      TabOrder = 17
      OnClick = btHelpClick
    end
    object lbColumns: TcxListBox
      Left = 10000
      Top = 10000
      Width = 540
      Height = 255
      DragMode = dmAutomatic
      ItemHeight = 20
      ListStyle = lbOwnerDrawFixed
      MultiSelect = True
      Style.TransparentBorder = False
      TabOrder = 8
      Visible = False
      OnClick = lbColumnsClick
      OnDragDrop = lbColumnsDragDrop
      OnDragOver = lbColumnsDragOver
      OnEndDrag = lbColumnsEndDrag
      OnKeyDown = lbColumnsKeyDown
      OnStartDrag = lbColumnsStartDrag
    end
    object lbGroups: TcxListBox
      Left = 10000
      Top = 10000
      Width = 540
      Height = 255
      DragMode = dmAutomatic
      ItemHeight = 20
      ListStyle = lbOwnerDrawFixed
      MultiSelect = True
      Style.TransparentBorder = False
      TabOrder = 11
      Visible = False
      OnClick = lbGroupsClick
      OnDragDrop = lbGroupsDragDrop
      OnDragOver = lbGroupsDragOver
      OnEndDrag = lbGroupsEndDrag
      OnKeyDown = lbGroupsKeyDown
      OnStartDrag = lbGroupsStartDrag
    end
    object btNewColumn: TcxButton
      Left = 10000
      Top = 10000
      Width = 90
      Height = 24
      Caption = 'New Column'
      TabOrder = 9
      Visible = False
      OnClick = btNewColumnClick
    end
    object btDeleteColumn: TcxButton
      Left = 10000
      Top = 10000
      Width = 90
      Height = 24
      Caption = 'Delete'
      TabOrder = 10
      Visible = False
      OnClick = btDeleteColumnClick
    end
    object btNewGroup: TcxButton
      Left = 10000
      Top = 10000
      Width = 90
      Height = 24
      Caption = 'New Group'
      TabOrder = 12
      Visible = False
      OnClick = btNewGroupClick
    end
    object btDeleteGroup: TcxButton
      Left = 10000
      Top = 10000
      Width = 90
      Height = 24
      Caption = 'Delete'
      TabOrder = 13
      Visible = False
      OnClick = btDeleteGroupClick
    end
    object tvItems: TdxTreeViewControl
      Left = 32
      Top = 62
      Width = 290
      Height = 255
      DragMode = dmAutomatic
      OptionsBehavior.HotTrack = True
      OptionsSelection.HideSelection = False
      OptionsSelection.RightClickSelect = True
      OptionsView.ItemHeight = 20
      TabOrder = 0
      OnCanFocusNode = tvItemsCanFocusNode
      OnDragDrop = tvItemsDragDrop
      OnDragOver = tvItemsDragOver
      OnEdited = tvItemsEdited
      OnEditing = tvItemsEditing
      OnFocusedNodeChanged = tvItemsFocusedNodeChanged
      OnKeyDown = tvItemsKeyDown
    end
    object edItemCaption: TcxTextEdit
      Left = 518
      Top = 62
      Properties.OnChange = ValueChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 4
      OnExit = edItemCaptionExit
      Width = 150
    end
    object edImageIndex: TcxTextEdit
      Left = 518
      Top = 87
      Properties.ValidationErrorIconAlignment = taRightJustify
      Properties.ValidationOptions = [evoShowErrorIcon]
      Properties.OnChange = ValueChange
      Properties.OnValidate = edImageIndexPropertiesValidate
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 5
      OnExit = edImageIndexExit
      Width = 46
    end
    object edStateImageIndex: TcxTextEdit
      Left = 518
      Top = 112
      Properties.ValidationErrorIconAlignment = taRightJustify
      Properties.ValidationOptions = [evoShowErrorIcon]
      Properties.OnChange = ValueChange
      Properties.OnValidate = edStateImageIndexPropertiesValidate
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 6
      OnExit = edStateImageIndexExit
      Width = 46
    end
    object cbGroupID: TcxComboBox
      Left = 518
      Top = 137
      Properties.DropDownListStyle = lsEditFixedList
      Properties.OnEditValueChanged = cbGroupIDPropertiesEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 7
      Width = 150
    end
    object dxLayoutControl1Group_Root: TdxLayoutGroup
      AlignHorz = ahClient
      AlignVert = avClient
      ButtonOptions.Buttons = <>
      Hidden = True
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = -1
    end
    object dxLayoutGroup1: TdxLayoutGroup
      Parent = dxLayoutControl1Group_Root
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'Hidden Group'
      ButtonOptions.Buttons = <>
      Hidden = True
      ShowBorder = False
      Index = 0
    end
    object lgTabs: TdxLayoutGroup
      Parent = dxLayoutGroup1
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'Hidden Group'
      ButtonOptions.Buttons = <>
      Hidden = True
      LayoutDirection = ldTabbed
      ShowBorder = False
      OnTabChanged = lgTabsTabChanged
      OnTabChanging = lgTabsTabChanging
      Index = 0
    end
    object dxLayoutGroup3: TdxLayoutGroup
      Parent = lgItems
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = ' &Items '
      ButtonOptions.Buttons = <>
      LayoutDirection = ldHorizontal
      Index = 0
    end
    object dxLayoutGroup4: TdxLayoutGroup
      Parent = dxLayoutGroup3
      AlignHorz = ahRight
      AlignVert = avTop
      CaptionOptions.Text = 'Hidden Group'
      ButtonOptions.Buttons = <>
      Hidden = True
      ShowBorder = False
      Index = 1
    end
    object dxLayoutItem2: TdxLayoutItem
      Parent = dxLayoutGroup4
      AlignHorz = ahRight
      CaptionOptions.Text = 'New'
      CaptionOptions.Visible = False
      Control = btNewItem
      ControlOptions.OriginalHeight = 24
      ControlOptions.OriginalWidth = 90
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem3: TdxLayoutItem
      Parent = dxLayoutGroup4
      AlignHorz = ahRight
      CaptionOptions.Text = 'NewSub'
      CaptionOptions.Visible = False
      Control = btNewSubItem
      ControlOptions.OriginalHeight = 24
      ControlOptions.OriginalWidth = 90
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem4: TdxLayoutItem
      Parent = dxLayoutGroup4
      AlignHorz = ahRight
      CaptionOptions.Text = 'Delete'
      CaptionOptions.Visible = False
      Control = btDeleteItem
      ControlOptions.OriginalHeight = 24
      ControlOptions.OriginalWidth = 90
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object grpItemProperties: TdxLayoutGroup
      Parent = lgItems
      AlignHorz = ahRight
      AlignVert = avClient
      CaptionOptions.Text = 'Item Properties'
      SizeOptions.AssignedValues = [sovSizableHorz]
      SizeOptions.SizableHorz = True
      SizeOptions.Width = 244
      ButtonOptions.Buttons = <>
      LayoutDirection = ldHorizontal
      Index = 1
    end
    object dxLayoutGroup6: TdxLayoutGroup
      Parent = grpItemProperties
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'Hidden Group'
      ButtonOptions.Buttons = <>
      Hidden = True
      ItemIndex = 4
      ShowBorder = False
      Index = 0
    end
    object dxLayoutItem6: TdxLayoutItem
      Parent = dxLayoutGroup6
      AlignHorz = ahLeft
      CaptionOptions.Text = 'I&mage Index:'
      Control = edImageIndex
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 46
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem7: TdxLayoutItem
      Parent = dxLayoutGroup6
      AlignHorz = ahLeft
      CaptionOptions.Text = '&State Index:'
      Control = edStateImageIndex
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 46
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutGroup7: TdxLayoutGroup
      Parent = dxLayoutGroup1
      AlignHorz = ahRight
      AlignVert = avBottom
      CaptionOptions.Text = 'Hidden Group'
      ButtonOptions.Buttons = <>
      Hidden = True
      ItemControlAreaAlignment = catAuto
      ItemIndex = 3
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 1
    end
    object dxLayoutItem9: TdxLayoutItem
      Parent = dxLayoutGroup7
      AlignHorz = ahRight
      AlignVert = avBottom
      CaptionOptions.Text = 'OkButton'
      CaptionOptions.Visible = False
      Control = btOk
      ControlOptions.OriginalHeight = 24
      ControlOptions.OriginalWidth = 80
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem10: TdxLayoutItem
      Parent = dxLayoutGroup7
      AlignHorz = ahRight
      AlignVert = avBottom
      CaptionOptions.Text = 'Cancel'
      CaptionOptions.Visible = False
      Control = btCancel
      ControlOptions.OriginalHeight = 24
      ControlOptions.OriginalWidth = 80
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem11: TdxLayoutItem
      Parent = dxLayoutGroup7
      AlignHorz = ahRight
      AlignVert = avBottom
      CaptionOptions.Text = 'Apply'
      CaptionOptions.Visible = False
      Control = btApply
      ControlOptions.OriginalHeight = 24
      ControlOptions.OriginalWidth = 80
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutItem12: TdxLayoutItem
      Parent = dxLayoutGroup7
      AlignHorz = ahRight
      AlignVert = avBottom
      Visible = False
      CaptionOptions.Text = 'Button7'
      CaptionOptions.Visible = False
      Control = btHelp
      ControlOptions.OriginalHeight = 24
      ControlOptions.OriginalWidth = 80
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object lgItems: TdxLayoutGroup
      Parent = lgTabs
      CaptionOptions.Text = 'Items'
      ButtonOptions.Buttons = <>
      ItemIndex = 1
      LayoutDirection = ldHorizontal
      Index = 0
    end
    object lgColumns: TdxLayoutGroup
      Parent = lgTabs
      CaptionOptions.Text = 'Columns'
      ButtonOptions.Buttons = <>
      LayoutDirection = ldHorizontal
      Index = 1
    end
    object lgGroups: TdxLayoutGroup
      Parent = lgTabs
      CaptionOptions.Text = 'Groups'
      ButtonOptions.Buttons = <>
      LayoutDirection = ldHorizontal
      Index = 2
    end
    object lgGroupsContainer: TdxLayoutGroup
      Parent = lgGroups
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'Groups'
      ButtonOptions.Buttons = <>
      LayoutDirection = ldHorizontal
      Index = 0
    end
    object lgColumnsContainer: TdxLayoutGroup
      Parent = lgColumns
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'Columns'
      ButtonOptions.Buttons = <>
      LayoutDirection = ldHorizontal
      Index = 0
    end
    object dxLayoutItem13: TdxLayoutItem
      Parent = lgColumnsContainer
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'New Item'
      CaptionOptions.Visible = False
      Control = lbColumns
      ControlOptions.OriginalHeight = 93
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem14: TdxLayoutItem
      Parent = lgGroupsContainer
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'New Item'
      CaptionOptions.Visible = False
      Control = lbGroups
      ControlOptions.OriginalHeight = 93
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutGroup5: TdxLayoutGroup
      Parent = lgColumnsContainer
      AlignHorz = ahRight
      AlignVert = avClient
      CaptionOptions.Text = 'New Group'
      SizeOptions.AssignedValues = [sovSizableHorz]
      SizeOptions.SizableHorz = True
      SizeOptions.Width = 90
      ButtonOptions.Buttons = <>
      ShowBorder = False
      Index = 1
    end
    object dxLayoutItem15: TdxLayoutItem
      Parent = dxLayoutGroup5
      CaptionOptions.Text = 'New Item'
      CaptionOptions.Visible = False
      Control = btNewColumn
      ControlOptions.OriginalHeight = 24
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem16: TdxLayoutItem
      Parent = dxLayoutGroup5
      CaptionOptions.Text = 'New Item'
      CaptionOptions.Visible = False
      Control = btDeleteColumn
      ControlOptions.OriginalHeight = 24
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutGroup10: TdxLayoutGroup
      Parent = lgGroupsContainer
      AlignHorz = ahRight
      AlignVert = avClient
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      SizeOptions.Width = 90
      ButtonOptions.Buttons = <>
      ShowBorder = False
      Index = 1
    end
    object dxLayoutItem17: TdxLayoutItem
      Parent = dxLayoutGroup10
      CaptionOptions.Text = 'New Item'
      CaptionOptions.Visible = False
      Control = btNewGroup
      ControlOptions.OriginalHeight = 24
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem18: TdxLayoutItem
      Parent = dxLayoutGroup10
      CaptionOptions.Text = 'New Item'
      CaptionOptions.Visible = False
      Control = btDeleteGroup
      ControlOptions.OriginalHeight = 24
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem19: TdxLayoutItem
      Parent = dxLayoutGroup3
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'dxTreeViewControl1'
      CaptionOptions.Visible = False
      Control = tvItems
      ControlOptions.OriginalHeight = 100
      ControlOptions.OriginalWidth = 120
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem5: TdxLayoutItem
      Parent = dxLayoutGroup6
      AlignHorz = ahClient
      CaptionOptions.Text = 'Caption:'
      Control = edItemCaption
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem1: TdxLayoutItem
      Parent = dxLayoutGroup6
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 4
    end
    object dxLayoutItem20: TdxLayoutItem
      Parent = dxLayoutGroup6
      CaptionOptions.Text = '&Group:'
      Control = cbGroupID
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 3
    end
  end
  object alTextEditOperationWorkaround: TActionList
    Left = 158
    Top = 6
    object EditCut1: TEditCut
      Category = 'Edit'
      Caption = 'Cu&t'
      Hint = 'Cut|Cuts the selection and puts it on the Clipboard'
      ImageIndex = 0
      ShortCut = 16472
    end
    object EditCopy1: TEditCopy
      Category = 'Edit'
      Caption = '&Copy'
      Hint = 'Copy|Copies the selection and puts it on the Clipboard'
      ImageIndex = 1
      ShortCut = 16451
    end
    object EditPaste1: TEditPaste
      Category = 'Edit'
      Caption = '&Paste'
      Hint = 'Paste|Inserts Clipboard contents'
      ImageIndex = 2
      ShortCut = 16470
    end
    object EditSelectAll1: TEditSelectAll
      Category = 'Edit'
      Caption = 'Select &All'
      Hint = 'Select All|Selects the entire document'
      ShortCut = 16449
    end
    object EditUndo1: TEditUndo
      Category = 'Edit'
      Caption = '&Undo'
      Hint = 'Undo|Reverts the last action'
      ImageIndex = 3
      ShortCut = 16474
    end
    object EditDelete1: TEditDelete
      Category = 'Edit'
      Caption = '&Delete'
      Hint = 'Delete|Erases the selection'
      ImageIndex = 5
      ShortCut = 46
    end
  end
  object dxLayoutLookAndFeelList1: TdxLayoutLookAndFeelList
    Left = 264
    Top = 8
    object dxLayoutCxLookAndFeel1: TdxLayoutCxLookAndFeel
      PixelsPerInch = 96
    end
  end
end
