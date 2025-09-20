object dxLayoutControlCustomizeForm: TdxLayoutControlCustomizeForm
  Left = 93
  Top = 249
  ActiveControl = btnClose
  BorderIcons = [biSystemMenu]
  ClientHeight = 428
  ClientWidth = 445
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = True
  ShowHint = True
  OnClose = FormClose
  OnKeyDown = FormKeyDown
  OnShortCut = FormShortCut
  PixelsPerInch = 96
  TextHeight = 13
  object lcMain: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 445
    Height = 428
    Align = alClient
    TabOrder = 0
    HighlightRoot = False
    object tvVisibleItems: TdxTreeViewControl
      Left = 24
      Top = 86
      Width = 161
      Height = 287
      Images = ilItems
      OptionsSelection.HideSelection = False
      OptionsSelection.MultiSelect = True
      OptionsSelection.MultiSelectStyle = [msControlSelect, msShiftSelect, msVisibleOnly]
      TabOrder = 13
      OnAddition = tvVisibleItemsAddition
      OnCanFocusNode = tvVisibleItemsCanFocusNode
      OnCanSelectNode = tvVisibleItemsCanSelectNode
      OnCollapsed = tvAvailableItemsCollapsed
      OnCustomDrawNode = tvAvailableItemsCustomDrawNode
      OnDeletion = tvVisibleItemsDeletion
      OnEdited = tvVisibleItemsEdited
      OnEditing = tvVisibleItemsEditing
      OnEnter = tvAvailableItemsEnter
      OnGetEditingText = tvVisibleItemsGetEditingText
      OnKeyDown = FormKeyDown
      OnMouseDown = tvVisibleItemsMouseDown
      OnMouseMove = tvVisibleItemsMouseMove
      OnMouseUp = tvVisibleItemsMouseUp
      OnSelectionChanged = tvVisibleItemsSelectionChanged
    end
    object tvAvailableItems: TdxTreeViewControl
      Left = 225
      Top = 86
      Width = 196
      Height = 287
      Images = ilItems
      OptionsSelection.HideSelection = False
      OptionsSelection.MultiSelect = True
      OptionsSelection.MultiSelectStyle = [msControlSelect, msShiftSelect, msVisibleOnly]
      TabOrder = 22
      OnAddition = tvAvailableItemsAddition
      OnCanFocusNode = tvVisibleItemsCanFocusNode
      OnCanSelectNode = tvVisibleItemsCanSelectNode
      OnCollapsed = tvAvailableItemsCollapsed
      OnCustomDrawNode = tvAvailableItemsCustomDrawNode
      OnDeletion = tvAvailableItemsDeletion
      OnEdited = tvVisibleItemsEdited
      OnEditing = tvVisibleItemsEditing
      OnEnter = tvAvailableItemsEnter
      OnGetEditingText = tvVisibleItemsGetEditingText
      OnKeyDown = FormKeyDown
      OnMouseDown = tvVisibleItemsMouseDown
      OnMouseMove = tvVisibleItemsMouseMove
      OnMouseUp = tvVisibleItemsMouseUp
      OnSelectionChanged = tvVisibleItemsSelectionChanged
    end
    object btnClose: TcxButton
      Left = 359
      Top = 392
      Width = 75
      Height = 25
      Action = acClose
      TabOrder = 24
    end
    object cbTabbedView: TcxCheckBox
      Left = 11
      Top = 396
      Action = acTabbedView
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.TransparentBorder = False
      TabOrder = 23
      Transparent = True
    end
    object btnShowDesignSelectors: TcxButton
      Left = 132
      Top = 11
      Width = 23
      Height = 22
      Action = acShowDesignSelectors
      PaintStyle = bpsGlyph
      SpeedButtonOptions.CanBeFocused = False
      SpeedButtonOptions.AllowAllUp = True
      SpeedButtonOptions.Flat = True
      SpeedButtonOptions.Transparent = True
      TabOrder = 5
    end
    object btnHighlightRoot: TcxButton
      Left = 109
      Top = 11
      Width = 23
      Height = 22
      Action = acHighlightRoot
      PaintStyle = bpsGlyph
      SpeedButtonOptions.CanBeFocused = False
      SpeedButtonOptions.AllowAllUp = True
      SpeedButtonOptions.Flat = True
      SpeedButtonOptions.Transparent = True
      TabOrder = 4
    end
    object btnRestore: TcxButton
      Left = 86
      Top = 11
      Width = 23
      Height = 22
      Action = acRestore
      PaintStyle = bpsGlyph
      SpeedButtonOptions.CanBeFocused = False
      SpeedButtonOptions.AllowAllUp = True
      SpeedButtonOptions.Flat = True
      SpeedButtonOptions.Transparent = True
      TabOrder = 3
    end
    object btnStore: TcxButton
      Left = 63
      Top = 11
      Width = 23
      Height = 22
      Action = acStore
      PaintStyle = bpsGlyph
      SpeedButtonOptions.CanBeFocused = False
      SpeedButtonOptions.AllowAllUp = True
      SpeedButtonOptions.Flat = True
      SpeedButtonOptions.Transparent = True
      TabOrder = 2
    end
    object btnRedo: TcxButton
      Left = 34
      Top = 11
      Width = 23
      Height = 22
      Action = acRedo
      PaintStyle = bpsGlyph
      SpeedButtonOptions.CanBeFocused = False
      SpeedButtonOptions.AllowAllUp = True
      SpeedButtonOptions.Flat = True
      SpeedButtonOptions.Transparent = True
      TabOrder = 1
    end
    object btnUndo: TcxButton
      Left = 11
      Top = 11
      Width = 23
      Height = 22
      Action = acUndo
      PaintStyle = bpsGlyph
      SpeedButtonOptions.CanBeFocused = False
      SpeedButtonOptions.AllowAllUp = True
      SpeedButtonOptions.Flat = True
      SpeedButtonOptions.Transparent = True
      TabOrder = 0
    end
    object btnAlignBy: TcxButton
      Left = 128
      Top = 58
      Width = 24
      Height = 22
      Action = acAlignBy
      DropDownMenu = pmAlign
      Kind = cxbkDropDown
      PaintStyle = bpsGlyph
      SpeedButtonOptions.CanBeFocused = False
      SpeedButtonOptions.Flat = True
      SpeedButtonOptions.Transparent = True
      TabOrder = 12
    end
    object btnTreeViewItemsDelete: TcxButton
      Left = 76
      Top = 58
      Width = 24
      Height = 22
      Action = acTreeViewItemsDelete
      PaintStyle = bpsGlyph
      SpeedButtonOptions.CanBeFocused = False
      SpeedButtonOptions.Flat = True
      SpeedButtonOptions.Transparent = True
      TabOrder = 10
    end
    object btnTreeViewCollapseAll: TcxButton
      Left = 48
      Top = 58
      Width = 22
      Height = 22
      Action = acTreeViewCollapseAll
      PaintStyle = bpsGlyph
      SpeedButtonOptions.CanBeFocused = False
      SpeedButtonOptions.Flat = True
      SpeedButtonOptions.Transparent = True
      TabOrder = 9
    end
    object btnTreeViewExpandAll: TcxButton
      Left = 24
      Top = 58
      Width = 24
      Height = 22
      Action = acTreeViewExpandAll
      PaintStyle = bpsGlyph
      SpeedButtonOptions.CanBeFocused = False
      SpeedButtonOptions.Flat = True
      SpeedButtonOptions.Transparent = True
      TabOrder = 8
    end
    object btnAvailableItemsViewAsList: TcxButton
      Left = 398
      Top = 58
      Width = 23
      Height = 22
      Action = acAvailableItemsViewAsList
      PaintStyle = bpsGlyph
      SpeedButtonOptions.CanBeFocused = False
      SpeedButtonOptions.Flat = True
      SpeedButtonOptions.Transparent = True
      TabOrder = 21
    end
    object btnAvailableItemsDelete: TcxButton
      Left = 346
      Top = 58
      Width = 23
      Height = 22
      Action = acAvailableItemsDelete
      PaintStyle = bpsGlyph
      SpeedButtonOptions.CanBeFocused = False
      SpeedButtonOptions.Flat = True
      SpeedButtonOptions.Transparent = True
      TabOrder = 19
    end
    object btnAddItem: TcxButton
      Left = 323
      Top = 58
      Width = 23
      Height = 22
      Action = acAddCustomItem
      DropDownMenu = pmAddCustomItem
      Kind = cxbkDropDown
      PaintStyle = bpsGlyph
      SpeedButtonOptions.CanBeFocused = False
      SpeedButtonOptions.Flat = True
      SpeedButtonOptions.Transparent = True
      TabOrder = 18
    end
    object btnAddGroup: TcxButton
      Left = 277
      Top = 58
      Width = 23
      Height = 22
      Action = acAddGroup
      PaintStyle = bpsGlyph
      SpeedButtonOptions.CanBeFocused = False
      SpeedButtonOptions.Flat = True
      SpeedButtonOptions.Transparent = True
      TabOrder = 16
    end
    object btnAvailableItemsCollapseAll: TcxButton
      Left = 248
      Top = 58
      Width = 23
      Height = 22
      Action = acAvailableItemsCollapseAll
      PaintStyle = bpsGlyph
      SpeedButtonOptions.CanBeFocused = False
      SpeedButtonOptions.Flat = True
      SpeedButtonOptions.Transparent = True
      TabOrder = 15
    end
    object btnAvailableItemsExpandAll: TcxButton
      Left = 225
      Top = 58
      Width = 23
      Height = 22
      Action = acAvailableItemsExpandAll
      PaintStyle = bpsGlyph
      SpeedButtonOptions.CanBeFocused = False
      SpeedButtonOptions.Flat = True
      SpeedButtonOptions.Transparent = True
      TabOrder = 14
    end
    object cxButton1: TcxButton
      Left = 300
      Top = 58
      Width = 23
      Height = 22
      Action = acAddItem
      PaintStyle = bpsGlyph
      SpeedButtonOptions.CanBeFocused = False
      SpeedButtonOptions.Flat = True
      SpeedButtonOptions.Transparent = True
      TabOrder = 17
    end
    object cxButton2: TcxButton
      Left = 100
      Top = 58
      Width = 22
      Height = 22
      Action = acVisibleItemsMakeFloat
      PaintStyle = bpsGlyph
      SpeedButtonOptions.CanBeFocused = False
      SpeedButtonOptions.Flat = True
      SpeedButtonOptions.Transparent = True
      TabOrder = 11
    end
    object cxButton3: TcxButton
      Left = 369
      Top = 58
      Width = 23
      Height = 22
      Action = acAvailableItemsMakeFloat
      PaintStyle = bpsGlyph
      SpeedButtonOptions.CanBeFocused = False
      SpeedButtonOptions.Flat = True
      SpeedButtonOptions.Transparent = True
      TabOrder = 20
    end
    object cxButton4: TcxButton
      Left = 155
      Top = 11
      Width = 23
      Height = 22
      Action = acShowItemNames
      PaintStyle = bpsGlyph
      SpeedButtonOptions.CanBeFocused = False
      SpeedButtonOptions.AllowAllUp = True
      SpeedButtonOptions.Flat = True
      SpeedButtonOptions.Transparent = True
      TabOrder = 6
    end
    object cxButton5: TcxButton
      Left = 178
      Top = 11
      Width = 23
      Height = 22
      Action = acTransparentBorders
      PaintStyle = bpsGlyph
      SpeedButtonOptions.CanBeFocused = False
      SpeedButtonOptions.AllowAllUp = True
      SpeedButtonOptions.Flat = True
      SpeedButtonOptions.Transparent = True
      TabOrder = 7
    end
    object lcMainGroup_Root: TdxLayoutGroup
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Visible = False
      Hidden = True
      ShowBorder = False
      Index = -1
    end
    object lcMainGroup2: TdxLayoutGroup
      Parent = lcMainGroup_Root
      CaptionOptions.Text = 'New Group'
      LayoutDirection = ldHorizontal
      ShowBorder = False
      UseIndent = False
      Index = 0
    end
    object liUndo: TdxLayoutItem
      Parent = lcMainGroup2
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = btnUndo
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 23
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object liRedo: TdxLayoutItem
      Parent = lcMainGroup2
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = btnRedo
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 23
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lsSeparator4: TdxLayoutSeparatorItem
      Parent = lcMainGroup2
      SizeOptions.AssignedValues = [sovSizableHorz, sovSizableVert]
      SizeOptions.SizableHorz = False
      SizeOptions.SizableVert = False
      CaptionOptions.Text = 'Separator'
      Index = 2
    end
    object liStore: TdxLayoutItem
      Parent = lcMainGroup2
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = btnStore
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 23
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object liRestore: TdxLayoutItem
      Parent = lcMainGroup2
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = btnRestore
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 23
      ControlOptions.ShowBorder = False
      Index = 4
    end
    object liHighlightRoot: TdxLayoutItem
      Parent = lcMainGroup2
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = btnHighlightRoot
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 23
      ControlOptions.ShowBorder = False
      Index = 5
    end
    object liShowDesignSelectors: TdxLayoutItem
      Parent = lcMainGroup2
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = btnShowDesignSelectors
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 23
      ControlOptions.ShowBorder = False
      Index = 6
    end
    object lcMainGroup1: TdxLayoutGroup
      Parent = lcMainGroup_Root
      AlignVert = avClient
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 1
    end
    object lcgTreeView: TdxLayoutGroup
      Parent = lcMainGroup1
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = '&Layout Tree View'
      Index = 0
    end
    object lgTreeView: TdxLayoutGroup
      Parent = lcgTreeView
      AlignHorz = ahClient
      CaptionOptions.Text = 'New Group'
      LayoutDirection = ldHorizontal
      ShowBorder = False
      UseIndent = False
      Index = 0
    end
    object lcMainItem10: TdxLayoutItem
      Parent = lgTreeView
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = btnTreeViewExpandAll
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 24
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lcMainItem9: TdxLayoutItem
      Parent = lgTreeView
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = btnTreeViewCollapseAll
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 22
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lcMainSeparatorItem3: TdxLayoutSeparatorItem
      Parent = lgTreeView
      SizeOptions.AssignedValues = [sovSizableHorz, sovSizableVert]
      SizeOptions.SizableHorz = False
      SizeOptions.SizableVert = False
      CaptionOptions.Text = 'Separator Item'
      Index = 2
    end
    object lcMainItem7: TdxLayoutItem
      Parent = lgTreeView
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = btnTreeViewItemsDelete
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 24
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object lsAlignBy: TdxLayoutSeparatorItem
      Parent = lgTreeView
      SizeOptions.AssignedValues = [sovSizableHorz, sovSizableVert]
      SizeOptions.SizableHorz = False
      SizeOptions.SizableVert = False
      CaptionOptions.Text = 'Separator Item'
      Index = 5
    end
    object liAlignBy: TdxLayoutItem
      Parent = lgTreeView
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = btnAlignBy
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 24
      ControlOptions.ShowBorder = False
      Index = 6
    end
    object lcMainItem6: TdxLayoutItem
      Parent = lcgTreeView
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'cxTreeView1'
      CaptionOptions.Visible = False
      Control = tvVisibleItems
      ControlOptions.OriginalHeight = 326
      ControlOptions.OriginalWidth = 194
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lcgAvailableItems: TdxLayoutGroup
      Parent = lcMainGroup1
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = '&Available Items'
      Index = 2
    end
    object lgAvailableItems: TdxLayoutGroup
      Parent = lcgAvailableItems
      AlignHorz = ahClient
      CaptionOptions.Text = 'New Group'
      LayoutDirection = ldHorizontal
      ShowBorder = False
      UseIndent = False
      Index = 0
    end
    object lcMainItem15: TdxLayoutItem
      Parent = lgAvailableItems
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = btnAvailableItemsExpandAll
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 23
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lcMainItem14: TdxLayoutItem
      Parent = lgAvailableItems
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = btnAvailableItemsCollapseAll
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 23
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lcMainSeparatorItem1: TdxLayoutSeparatorItem
      Parent = lgAvailableItems
      SizeOptions.AssignedValues = [sovSizableHorz, sovSizableVert]
      SizeOptions.SizableHorz = False
      SizeOptions.SizableVert = False
      CaptionOptions.Text = 'Separator Item'
      Index = 2
    end
    object lcMainItem13: TdxLayoutItem
      Parent = lgAvailableItems
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = btnAddGroup
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 23
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object liAddItem: TdxLayoutItem
      Parent = lgAvailableItems
      CaptionOptions.Visible = False
      Control = cxButton1
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 23
      ControlOptions.ShowBorder = False
      Index = 4
    end
    object liAddCustomItem: TdxLayoutItem
      Parent = lgAvailableItems
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = btnAddItem
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 23
      ControlOptions.ShowBorder = False
      Index = 5
    end
    object lcMainItem11: TdxLayoutItem
      Parent = lgAvailableItems
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = btnAvailableItemsDelete
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 23
      ControlOptions.ShowBorder = False
      Index = 6
    end
    object lcMainSeparatorItem2: TdxLayoutSeparatorItem
      Parent = lgAvailableItems
      SizeOptions.AssignedValues = [sovSizableHorz, sovSizableVert]
      SizeOptions.SizableHorz = False
      SizeOptions.SizableVert = False
      CaptionOptions.Text = 'Separator Item'
      Index = 8
    end
    object lcMainItem3: TdxLayoutItem
      Parent = lgAvailableItems
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = btnAvailableItemsViewAsList
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 23
      ControlOptions.ShowBorder = False
      Index = 9
    end
    object lcMainItem8: TdxLayoutItem
      Parent = lcgAvailableItems
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'cxTreeView2'
      CaptionOptions.Visible = False
      Control = tvAvailableItems
      ControlOptions.OriginalHeight = 326
      ControlOptions.OriginalWidth = 193
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lcMainGroup3: TdxLayoutGroup
      Parent = lcMainGroup_Root
      AlignVert = avBottom
      CaptionOptions.Text = 'Hidden Group'
      Hidden = True
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 2
    end
    object lcMainItem4: TdxLayoutItem
      Parent = lcMainGroup3
      AlignHorz = ahLeft
      AlignVert = avCenter
      CaptionOptions.Text = 'cxCheckBox1'
      CaptionOptions.Visible = False
      Control = cbTabbedView
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 84
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lcMainItem1: TdxLayoutItem
      Parent = lcMainGroup3
      AlignHorz = ahRight
      AlignVert = avCenter
      CaptionOptions.Text = 'cxButton1'
      CaptionOptions.Visible = False
      Control = btnClose
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object siMainSplitter: TdxLayoutSplitterItem
      Parent = lcMainGroup1
      SizeOptions.AssignedValues = [sovSizableHorz, sovSizableVert]
      SizeOptions.SizableHorz = False
      SizeOptions.SizableVert = False
      CaptionOptions.Text = 'Splitter'
      Index = 1
    end
    object liVisibleItemsMakeFloat: TdxLayoutItem
      Parent = lgTreeView
      AlignHorz = ahLeft
      CaptionOptions.Text = 'cxButton2'
      CaptionOptions.Visible = False
      Control = cxButton2
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 22
      ControlOptions.ShowBorder = False
      Index = 4
    end
    object liAvailableItemsMakeFloat: TdxLayoutItem
      Parent = lgAvailableItems
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = cxButton3
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 23
      ControlOptions.ShowBorder = False
      Index = 7
    end
    object liShowItemNames: TdxLayoutItem
      Parent = lcMainGroup2
      CaptionOptions.Visible = False
      Control = cxButton4
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 23
      ControlOptions.ShowBorder = False
      Index = 7
    end
    object liTransparentBorders: TdxLayoutItem
      Parent = lcMainGroup2
      CaptionOptions.Text = 'cxButton5'
      CaptionOptions.Visible = False
      Control = cxButton5
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 23
      ControlOptions.ShowBorder = False
      Index = 8
    end
  end
  object pmAlign: TPopupMenu
    Left = 48
    Top = 360
    object Left1: TMenuItem
      Action = acAlignLeftSide
    end
    object Right1: TMenuItem
      Tag = 2
      Action = acAlignRightSide
    end
    object miSeparator3: TMenuItem
      Caption = '-'
    end
    object op1: TMenuItem
      Tag = 1
      Action = acAlignTopSide
    end
    object Bottom1: TMenuItem
      Tag = 3
      Action = acAlignBottomSide
    end
    object miSeparator4: TMenuItem
      Caption = '-'
    end
    object None1: TMenuItem
      Tag = -1
      Action = acAlignNone
    end
  end
  object alMain: TActionList
    Images = ilActions
    Left = 16
    Top = 360
    object acAddGroup: TAction
      Category = 'Buttons'
      Caption = 'Add &Group'
      Hint = 'Add Group'
      ImageIndex = 6
      ShortCut = 32839
      OnExecute = acAddGroupExecute
    end
    object acAddCustomItem: TAction
      Category = 'Buttons'
      Caption = 'Add Item'
      Hint = 'Add Item'
      ImageIndex = 18
      OnExecute = acAddCustomItemExecute
    end
    object acAddItem: TAction
      Category = 'Buttons'
      Caption = 'Add &Item'
      Hint = 'Add Item'
      ImageIndex = 5
      ShortCut = 32841
      OnExecute = acAddItemExecute
    end
    object acAddEmptySpaceItem: TAction
      Category = 'Buttons'
      Caption = 'Add &Empty Space Item'
      Hint = 'Add Empty Space Item'
      ImageIndex = 14
      OnExecute = acAddEmptySpaceItemExecute
    end
    object acAddLabeledItem: TAction
      Category = 'Buttons'
      Caption = 'Add &Label'
      Hint = 'Add Label'
      ImageIndex = 15
      OnExecute = acAddLabeledItemExecute
    end
    object acAddImage: TAction
      Category = 'Buttons'
      Caption = 'Add &Image'
      ImageIndex = 22
      OnExecute = acAddImageExecute
    end
    object acAddSeparator: TAction
      Category = 'Buttons'
      Caption = 'Add &Separator'
      Hint = 'Add Separator'
      ImageIndex = 16
      OnExecute = acAddSeparatorExecute
    end
    object acAddSplitter: TAction
      Category = 'Buttons'
      Caption = 'Add S&plitter'
      Hint = 'Add Splitter'
      ImageIndex = 17
      OnExecute = acAddSplitterExecute
    end
    object acAvailableItemsDelete: TAction
      Category = 'Buttons'
      Caption = 'Delete'
      Hint = 'Delete'
      ImageIndex = 2
      OnExecute = acAvailableItemsDeleteExecute
    end
    object acTreeViewItemsDelete: TAction
      Category = 'Buttons'
      Caption = 'Delete'
      Hint = 'Delete'
      ImageIndex = 2
      OnExecute = acTreeViewItemsDeleteExecute
    end
    object acClose: TAction
      Category = 'Buttons'
      Caption = '&Close'
      Hint = 'Close'
      ShortCut = 27
      OnExecute = acCloseExecute
    end
    object acAvailableItemsExpandAll: TAction
      Category = 'Buttons'
      Caption = 'Expand All'
      Hint = 'Expand All'
      ImageIndex = 3
      OnExecute = acAvailableItemsExpandAllExecute
    end
    object acAvailableItemsCollapseAll: TAction
      Category = 'Buttons'
      Caption = 'Collapse All'
      Hint = 'Collapse All'
      ImageIndex = 1
      OnExecute = acAvailableItemsCollapseAllExecute
    end
    object acTreeViewExpandAll: TAction
      Category = 'Buttons'
      Caption = 'Expand All'
      Hint = 'Expand All'
      ImageIndex = 3
      OnExecute = acTreeViewExpandAllExecute
    end
    object acTreeViewCollapseAll: TAction
      Category = 'Buttons'
      Caption = 'Collapse All'
      Hint = 'Collapse All'
      ImageIndex = 1
      OnExecute = acTreeViewCollapseAllExecute
    end
    object acAlignLeftSide: TAction
      Category = 'ItemAligns'
      Caption = 'Left Side'
      OnExecute = AlignExecute
    end
    object acAlignRightSide: TAction
      Tag = 2
      Category = 'ItemAligns'
      Caption = 'Right Side'
      OnExecute = AlignExecute
    end
    object acAlignTopSide: TAction
      Tag = 1
      Category = 'ItemAligns'
      Caption = 'Top Side'
      OnExecute = AlignExecute
    end
    object acAlignBottomSide: TAction
      Tag = 3
      Category = 'ItemAligns'
      Caption = 'Bottom Side'
      OnExecute = AlignExecute
    end
    object acAlignNone: TAction
      Tag = -1
      Category = 'ItemAligns'
      Caption = 'None'
      OnExecute = AlignExecute
    end
    object acAvailableItemsViewAsList: TAction
      Category = 'Buttons'
      AutoCheck = True
      Caption = 'ViewAsList'
      Hint = 'ViewAsList'
      ImageIndex = 8
      OnExecute = acAvailableItemsViewAsListExecute
    end
    object acTabbedView: TAction
      Category = 'Buttons'
      AutoCheck = True
      Caption = 'Tabbed View'
      Hint = 'Tabbed View'
      ImageIndex = 9
      OnExecute = acTabbedViewExecute
    end
    object acShowItemNames: TAction
      Category = 'Buttons'
      AutoCheck = True
      Caption = 'acShowItemNames'
      Checked = True
      Hint = 'Display Item Names/Captions'
      ImageIndex = 24
      OnExecute = acShowItemNamesExecute
    end
    object acHighlightRoot: TAction
      Category = 'Buttons'
      AutoCheck = True
      Caption = 'acHighlightRoot'
      Hint = 'Highlight Root'
      ImageIndex = 4
      OnExecute = acHighlightRootExecute
    end
    object acShowDesignSelectors: TAction
      Category = 'Buttons'
      AutoCheck = True
      Caption = 'acHighlightControlSelectors'
      Hint = 'Show Design Selectors'
      ImageIndex = 7
      OnExecute = acShowDesignSelectorsExecute
    end
    object acStore: TAction
      Category = 'Buttons'
      Caption = 'Store'
      ImageIndex = 9
      OnExecute = acStoreExecute
    end
    object acRestore: TAction
      Category = 'Buttons'
      Caption = 'acRestore'
      ImageIndex = 10
      OnExecute = acRestoreExecute
    end
    object acTreeViewItemRename: TAction
      Category = 'Buttons'
      Caption = 'Rename'
      Hint = 'Rename'
      ImageIndex = 13
      ShortCut = 113
      OnExecute = acTreeViewItemRenameExecute
    end
    object acAvailableItemRename: TAction
      Category = 'Buttons'
      Caption = 'Rename'
      Hint = 'Rename'
      ImageIndex = 13
      OnExecute = acAvailableItemRenameExecute
    end
    object acUndo: TAction
      Category = 'Buttons'
      Caption = 'Undo'
      Hint = 'Undo'
      ImageIndex = 11
      OnExecute = acUndoExecute
    end
    object acRedo: TAction
      Category = 'Buttons'
      Caption = 'Redo'
      Hint = 'Redo'
      ImageIndex = 12
      OnExecute = acRedoExecute
    end
    object acAlignBy: TAction
      Category = 'ItemAligns'
      Caption = 'acAlignBy'
      Hint = 'Align By'
      ImageIndex = 0
      OnExecute = acAlignByExecute
    end
    object acHAlignLeft: TAction
      Category = 'HAlign'
      Caption = 'ahLeft'
      GroupIndex = 4
      OnExecute = acHAlignExecute
    end
    object acHAlignCenter: TAction
      Tag = 1
      Category = 'HAlign'
      Caption = 'ahCenter'
      GroupIndex = 4
      OnExecute = acHAlignExecute
    end
    object acHAlignRight: TAction
      Tag = 2
      Category = 'HAlign'
      Caption = 'ahRight'
      GroupIndex = 4
      OnExecute = acHAlignExecute
    end
    object acHAlignClient: TAction
      Tag = 3
      Category = 'HAlign'
      Caption = 'ahClient'
      GroupIndex = 4
      OnExecute = acHAlignExecute
    end
    object acHAlignParent: TAction
      Tag = 4
      Category = 'HAlign'
      Caption = 'ahParentManaged'
      GroupIndex = 4
      OnExecute = acHAlignExecute
    end
    object acVAlignTop: TAction
      Category = 'VAlign'
      Caption = 'acVAlignTop'
      GroupIndex = 5
      OnExecute = acVAlignExecute
    end
    object acVAlignCenter: TAction
      Tag = 1
      Category = 'VAlign'
      Caption = 'acVAlignCenter'
      GroupIndex = 5
      OnExecute = acVAlignExecute
    end
    object acVAlignBottom: TAction
      Tag = 2
      Category = 'VAlign'
      Caption = 'acVAlignBottom'
      GroupIndex = 5
      OnExecute = acVAlignExecute
    end
    object acVAlignClient: TAction
      Tag = 3
      Category = 'VAlign'
      Caption = 'acVAlignClient'
      GroupIndex = 5
      OnExecute = acVAlignExecute
    end
    object acVAlignParent: TAction
      Tag = 4
      Category = 'VAlign'
      Caption = 'acVAlignParent'
      GroupIndex = 5
      OnExecute = acVAlignExecute
    end
    object acDirectionHorizontal: TAction
      Category = 'Directions'
      Caption = 'acDirectionHorizontal'
      GroupIndex = 6
      OnExecute = acDirectionsExecute
    end
    object acDirectionVertical: TAction
      Tag = 1
      Category = 'Directions'
      Caption = 'acDirectionVertical'
      GroupIndex = 6
      OnExecute = acDirectionsExecute
    end
    object acDirectionTabbed: TAction
      Tag = 2
      Category = 'Directions'
      Caption = 'acDirectionTabbed'
      GroupIndex = 6
      OnExecute = acDirectionsExecute
    end
    object acBorder: TAction
      Category = 'Buttons'
      Caption = 'acShowBorder'
      GroupIndex = 7
      OnExecute = acBorderExecute
    end
    object acExpandButton: TAction
      Category = 'Buttons'
      Caption = 'Show Expand Button'
      OnExecute = acExpandButtonExecute
    end
    object acTextPositionLeft: TAction
      Category = 'TextPosition'
      Caption = 'acTextPositionLeft'
      GroupIndex = 8
      OnExecute = acTextPositionExecute
    end
    object acTextPositionTop: TAction
      Tag = 1
      Category = 'TextPosition'
      Caption = 'acTextPositionTop'
      GroupIndex = 8
      OnExecute = acTextPositionExecute
    end
    object acTextPositionRight: TAction
      Tag = 2
      Category = 'TextPosition'
      Caption = 'acTextPositionRight'
      GroupIndex = 8
      OnExecute = acTextPositionExecute
    end
    object acTextPositionBottom: TAction
      Tag = 3
      Category = 'TextPosition'
      Caption = 'acTextPositionBottom'
      GroupIndex = 8
      OnExecute = acTextPositionExecute
    end
    object acCaptionAlignHorzLeft: TAction
      Category = 'CaptionAlignHorz'
      Caption = 'acCaptionAlignHorzLeft'
      GroupIndex = 9
      OnExecute = acCaptionAlignHorzExecute
    end
    object acCaptionAlignHorzCenter: TAction
      Tag = 2
      Category = 'CaptionAlignHorz'
      Caption = 'acCaptionAlignHorzCenter'
      GroupIndex = 9
      OnExecute = acCaptionAlignHorzExecute
    end
    object acCaptionAlignHorzRight: TAction
      Tag = 1
      Category = 'CaptionAlignHorz'
      Caption = 'acCaptionAlignHorzRight'
      GroupIndex = 9
      OnExecute = acCaptionAlignHorzExecute
    end
    object acCaption: TAction
      Caption = 'acCaption'
      OnExecute = acCaptionExecute
    end
    object acCaptionAlignVertTop: TAction
      Category = 'CaptionAlignVert'
      Caption = 'acCaptionAlignVertTop'
      GroupIndex = 10
      OnExecute = acCaptionAlignVertExecute
    end
    object acCaptionAlignVertCenter: TAction
      Tag = 1
      Category = 'CaptionAlignVert'
      Caption = 'acCaptionAlignVertCenter'
      GroupIndex = 10
      OnExecute = acCaptionAlignVertExecute
    end
    object acCaptionAlignVertBottom: TAction
      Tag = 2
      Category = 'CaptionAlignVert'
      Caption = 'acCaptionAlignVertBottom'
      GroupIndex = 10
      OnExecute = acCaptionAlignVertExecute
    end
    object acGroup: TAction
      Caption = 'acGroup'
      ImageIndex = 20
      OnExecute = acGroupExecute
    end
    object acUngroup: TAction
      Caption = 'acUngroup'
      ImageIndex = 21
      OnExecute = acUngroupExecute
    end
    object acVisibleItemsMakeFloat: TAction
      Category = 'Buttons'
      Caption = 'Make/Stop Float'
      Hint = 'Make/Stop Float'
      ImageIndex = 23
      OnExecute = acVisibleItemsMakeFloatExecute
    end
    object acAvailableItemsMakeFloat: TAction
      Category = 'Buttons'
      Caption = 'Make/Stop Float'
      Hint = 'Make/Stop Float'
      ImageIndex = 23
      OnExecute = acAvailableItemsFloatExecute
    end
    object acCollapsible: TAction
      Caption = 'acCollapsible'
      OnExecute = acCollapsibleExecute
    end
    object acAddCheckBoxItem: TAction
      Category = 'Buttons'
      Caption = 'Add &Check Box Item'
      ImageIndex = 25
      OnExecute = acAddCheckBoxItemExecute
    end
    object acAddRadioButtonItem: TAction
      Category = 'Buttons'
      Caption = 'Add &Radio Button Item'
      ImageIndex = 26
      OnExecute = acAddRadioButtonItemExecute
    end
    object acTransparentBorders: TAction
      Category = 'Buttons'
      Caption = 'acTransparentBorders'
      Hint = 
        'One or more elements have transparent borders. Click to remove t' +
        'hese borders.'
      ImageIndex = 27
      OnExecute = acTransparentBordersExecute
    end
  end
  object ilActions: TcxImageList
    SourceDPI = 96
    FormatVersion = 1
    Left = 16
    Top = 392
    Bitmap = {
      494C01011C002800040010001000FFFFFFFF2100FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000008000000001002000000000000080
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000505050D6717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF555555DD0000000000000000000000000000
      0000040404352A2A2A9C555555DD6F6F6FFC6F6F6FFD555555DE2B2B2B9E0505
      0538000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000717171FF656565F1404040BF4040
      40BF404040BF404040BF404040BF404040BF404040BF404040BF404040BF4040
      40BF404040BF404040BF636363EF717171FF00000000000000000000000B2C2C
      2C9F717171FF717171FF646464F0464646C9464646C9636363EE717171FF7171
      71FF2F2F2FA50000000D00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000894B0BCCD776
      10FF1B0E025B0000000000000000000000000000000000000000140B0150D776
      10FF93510BD3000000000000000000000000717171FF454545C7000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000404040BF717171FF000000000000000A434343C57171
      71FF4C4C4CD10909094B00000003000000000000000000000003090909484949
      49CD717171FF484848CB0000000D00000000000000000F89C6E114B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF1191D1E700000000000000000000000029170371D776
      10FF703D08B800000000000000000000000000000000000000005F3407A9D776
      10FF2E190377000000000000000000000000717171FF454545C7000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000404040BF717171FF000000002A2A2A9D717171FF3333
      33AC00000008000000000303032E1313136A1414146B04040431000000000000
      00062F2F2FA6717171FF2F2F2FA500000000000000000427397914B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF052C408000000000000000000000000001010018D174
      10FCD27410FC0201001A0000000000000000000000000000000DC76E0FF6D374
      10FD0201001D000000000000000000000000717171FF454545C7000000000000
      000000000000000000000101011A0505053B0000000000000000000000000000
      00000000000000000000404040BF717171FF04040432717171FE4E4E4ED30000
      00080000000A313131A8717171FF717171FF717171FF717171FF353535AE0000
      000C00000006494949CD717171FF0505053900000000000000070F82BCDB14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF5C8091FF5F7D8DFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF0F87C3DF0000000900000000000000000000000000000000713E
      08B9D77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FF7640
      09BD00000000000000000000000000000000717171FF454545C7000000000000
      0000000000000101011A525252D9676767F40606063F00000000000000000000
      00000000000000000000404040BF717171FF27272796717171FF0B0B0B500000
      00002F2F2FA6717171FF717171FF717171FF717171FF717171FF717171FF3535
      35AE0000000009090948717171FF2B2B2B9E0000000000000000010F174D14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF598296FF5C8091FF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF02121A5200000000000000000000000000000000000000001D10
      025ED77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FF1E11
      026100000000000000000000000000000000717171FF454545C7000000000000
      00000101011A525252D9717171FF717171FF676767F40606063F000000000000
      00000000000000000000404040BF717171FF505050D6676767F4000000050202
      0229717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF0404043100000003626262EE555555DE0000000000000000000000000A59
      82B614B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1
      FFFF0A5E87BA0000000000000000000000000000000000000000000000000000
      000CC66D0FF5D77610FF050200270000000003010020D57510FEC76E0FF60000
      000E00000000000000000000000000000000717171FF454545C7000000000101
      011A525252D9717171FF717171FF717171FF717171FF676767F40606063F0000
      00000000000000000000404040BF717171FF686868F54C4C4CD1000000001111
      1163717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF1414146C00000000464646C96F6F6FFD0000000000000000000000000004
      052714A9F3F914B1FFFF14B1FFFF717171FF717171FF14B1FFFF14B1FFFF14A9
      F5FA000406290000000000000000000000000000000000000000000000000000
      00005A3107A5D77610FF381F048300000000311B037BD77610FF5C3207A60000
      000000000000000000000000000000000000717171FF454545C7000000000000
      00174E4E4ED4717171FF2929299A101010606F6F6FFD717171FF676767F40606
      063F0000000000000000404040BF717171FF676767F44D4D4DD2000000001010
      1062717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF1414146B00000000464646C96F6F6FFC0000000000000000000000000000
      000005334A8A14B1FFFF14B1FFFF717171FF717171FF14B1FFFF14B1FFFF0635
      4D8C000000000000000000000000000000000000000000000000000000000000
      0000120A014BD77610FFA3590DDE0000000198530BD6D77610FF120A014B0000
      000000000000000000000000000000000000717171FF454545C7000000000000
      0000000000171B1B1B7D00000002000000000F0F0F5E6F6F6FFD717171FF6767
      67F40404043100000000404040BF717171FF4F4F4FD5686868F5000000060202
      0227717171FE717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF0303032E00000003646464F0555555DD0000000000000000000000000000
      00000000000E1190CFE614B1FFFF717171FF717171FF14B1FFFF1190CFE60000
      000E000000000000000000000000000000000000000000000000000000000000
      000000000005B4630DE9D77610FF2816036FD77610FFB3630DE9000000040000
      000000000000000000000000000000000000717171FF454545C7000000000000
      000000000000000000000000000000000000000000000F0F0F5E6F6F6FFD3838
      38B40000000700000000404040BF717171FF26262694717171FF0B0B0B530000
      00002D2D2DA0717171FF717171FF717171FF717171FF717171FF717171FF3131
      31A8000000000909094B717171FF2A2A2A9B0000000000000000000000000000
      0000000000000217225E14B1FFFF717171FF717171FF14B1FFFF0217225E0000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000046260592D77610FFC96E0FF7D77610FF44250590000000000000
      000000000000000000000000000000000000717171FF454545C7000000000000
      0000000000000000000000000000000000000000000000000000080808450000
      00070000000000000000404040BF717171FF0303032E707070FE505050D70000
      000A000000082D2D2DA0717171FE717171FF717171FF717171FF2F2F2FA60000
      000A000000084C4C4CD1717171FF040404350000000000000000000000000000
      000000000000000000010C6B99C614B1FFFF14B1FFFF0C6A98C5000000010000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000009050037D77610FFD77610FFD77610FF08040034000000000000
      000000000000000000000000000000000000717171FF454545C7000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000404040BF717171FF0000000028282897717171FF3737
      37B30000000A0000000002020226101010621111116302020229000000000000
      0008333333AC717171FF2C2C2C9F000000000000000000000000000000000000
      0000000000000000000000070A3414AEFBFD14ADFBFD00060932000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000019D560BDAD77610FF98530BD600000000000000000000
      000000000000000000000000000000000000717171FF454545C7000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000404040BF717171FF0000000000000008404040BF7171
      71FF505050D70B0B0B53000000060000000000000000000000050B0B0B4F4E4E
      4ED3717171FF434343C50000000B000000000000000000000000000000000000
      0000000000000000000000000000073D5997063A539200000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000717171FF676767F3454545C74545
      45C7454545C7454545C7454545C7454545C7454545C7454545C7454545C74545
      45C7454545C7454545C7656565F1717171FF0000000000000000000000082828
      2897707070FE717171FF686868F54D4D4DD24C4C4CD1676767F4717171FF7171
      71FE2A2A2A9D0000000A00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000004B4B4BCF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF505050D60000000000000000000000000000
      00000303032E262626944F4F4FD5676767F4686868F5505050D7272727960404
      0431000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000003E3E3EFF3E3E3EFF3E3E3EFF3E3E
      3EFF000000000000000000000000000000000000000000000000000000000000
      00003E3E3EFF3E3E3EFF3E3E3EFF3E3E3EFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000003E3E3EFF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000003E3E3EFF00000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF0000000000000000000000001B1B
      D1FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000201001E0402002600000000000000000000
      0000000000000000000000000000000000003E3E3EFF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000003E3E3EFF00000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF0000000000000000000000001B1B
      D1FF0000000000000000000000000000000000000000636363EF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF666666F2000000000000000000000000000000000000
      000000000000000000000201001EA1580CDDAD5F0DE504020026000000000000
      0000000000000000000000000000000000003E3E3EFF0000000000000000D776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FF000000000000
      00000000000000000000000000003E3E3EFF00000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF0000000000000000000000001B1B
      D1FF0000000000000000000000000000000000000000717171FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000717171FF000000000000000000000000000000000000
      0000000000000201001A96530BD5CF7210FBD07210FBA1580CDD030200220000
      000000000000000000000000000000000000000000000000000000000000D776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FF000000000000
      00000000000000000000000000000000000000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF0000000000000000000000001B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF0000000000000000717171FF00000000229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF0824007C020A00420826
      007F0109003E00000000717171FF000000000000000000000000000000000000
      00000000000000000000000000002F1A03783C21048700000000000000000000
      000000000000000000000000000000000000000000000000000000000000D776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FF000000000000
      00000000000000000000000000000000000000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF0000000000000000000000000000
      00000000000000000000000000000000000000000000717171FF00000000229C
      02FF229C02FF229C02FF229C02FF229C02FF0824007C020A00420826007F0109
      003E0000000000000000717171FF000000000000000000000000000000000000
      000E0101001800000000000000002F1A03783C21048700000000000000000100
      001601000012000000000000000000000000000000000000000000000000D776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FF000000000000
      00000000000000000000000000000000000000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF0000000000000000000000000000
      00000000000000000000000000000000000000000000717171FF00000000229C
      02FF229C02FF229C02FF229C02FF0824007C000000000109003E0109003E0000
      00000000000000000000717171FF000000000000000000000000010000168B4C
      0BCD0A05003800000000000000002F1A03783C21048700000000000000000704
      003093500BD30201001B0000000000000000000000000000000000000000D776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FF229C02FF229C
      02FF229C02FF00000000000000000000000000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF0000000000000000000000000000
      00000000000000000000000000000000000000000000717171FF000000000824
      007C229C02FF229C02FF0824007C000000000000000000000000000000000000
      00000000000000000000717171FF0000000000000000030100209D560CDAD776
      10FF502C069C361E0480361E0480703D08B87D4509C33C2104873C210487522D
      069ED77610FFA45A0DDF0402002500000000000000000000000000000000D776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FF229C02FF229C
      02FF229C02FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000717171FF000000000000
      00000824007C0824007C00000000000000000000000000000000000000000000
      00000000000000000000717171FF00000000000000000201001D98530BD7D776
      10FF502C069C361E0480361E04807A4309C0743F09BB2F1A03782F1A03784525
      0591D77610FF9A550BD80301001F00000000000000000000000000000000D776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FF229C02FF229C
      02FF229C02FF0000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF0000000000000000717171FF000000000000
      0000000000000000000000000000000000000000000005334A8A14ABF7FB0639
      53920000000000000000717171FF00000000000000000000000001000014864A
      0ACA0A0500380000000000000000361E0480361E048000000000000000000704
      0030894B0BCC0100001500000000000000000000000000000000000000000000
      0000000000000000000000000000229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF0000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF0000000000000000717171FF000000000000
      0000000000000000000000000000000000000000000012A0E7F314B1FFFF14AB
      F7FB0000000000000000717171FF000000000000000000000000000000000000
      000D010000170000000000000000361E0480361E048000000000000000000100
      00130000000E0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF000000000000000000000000000000001B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF00000000000000000000000000000000229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF0000000000000000717171FF000000000000
      00000000000000000000000000000000000000000000052E438312A0E7F30533
      4A8A0000000000000000717171FF000000000000000000000000000000000000
      0000000000000201001D231302686A3B08B46A3B08B423130268030100210000
      0000000000000000000000000000000000003E3E3EFF00000000000000000000
      0000000000000000000000000000229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF00000000000000003E3E3EFF0000000000000000000000000000
      00001B1BD1FF00000000000000000000000000000000229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF0000000000000000717171FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000717171FF000000000000000000000000000000000000
      0000000000000000000147270593D77610FFD77610FF4E2B069A000000020000
      0000000000000000000000000000000000003E3E3EFF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000003E3E3EFF0000000000000000000000000000
      00001B1BD1FF00000000000000000000000000000000229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF0000000000000000606060EB717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF636363EE000000000000000000000000000000000000
      0000000000000000000000000001472705934E2B069A00000002000000000000
      0000000000000000000000000000000000003E3E3EFF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000003E3E3EFF0000000000000000000000000000
      00001B1BD1FF00000000000000000000000000000000229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000010000000200000000000000000000
      0000000000000000000000000000000000003E3E3EFF3E3E3EFF3E3E3EFF3E3E
      3EFF000000000000000000000000000000000000000000000000000000000000
      00003E3E3EFF3E3E3EFF3E3E3EFF3E3E3EFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000006000000060000
      0000000000060000000600000000000000060000000600000000000000060000
      0006000000000000000600000006000000000000000000000000000000000000
      000000000000000000000000001A0000003D0000003E0000001B000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000009090966090909660000
      0000090909660909096600000000090909660909096600000000090909660909
      0966000000000909096609090966000000000000000009090963090909600000
      00030808085D08080860000000030A0A0A6C0B0B0B70000000030808085D0808
      0860000000030808085D09090966000000030000000000000000000000000000
      000100000058042738CE0B6796FF0F83BCFF0F83BDFF0C6898FF04293BD10000
      005D000000010000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000009090966000000000000
      00000000000000000000000000003E3E3EFF3E3E3EFF00000000000000000000
      000000000000000000000909096600000000000000000808085D000000030000
      00000000000000000000000000003A3A3AF73E3E3EFF00000008000000000000
      000000000000000000000808085D00000003000000000000000000000008020E
      14AB0F87C3FF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF0F8A
      C7FF021018B20000000B00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000003E3E3EFF3E3E3EFF00000000000000000000
      0000000000000000000000000000000000000000000000000006000000000000
      00000000000000000000000000003A3A3AF73E3E3EFF00000008000000000000
      0000000000000000000000000006000000000000000000000000010D13AA129F
      E5FF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1
      FFFF12A1E8FF021018B200000001000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000009090966000000000000
      00000000000000000000000000003E3E3EFF3E3E3EFF00000000000000000000
      0000000000000000000009090966000000000000000009090963000000030000
      00000000000000000000000000003A3A3AF73E3E3EFF00000008000000000000
      00000000000000000000090909630000000300000000000000550F85C0FF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF0F8AC7FF0000005D000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000009090966000000000000
      00000000000000000000000000003E3E3EFF3E3E3EFF00000000000000000000
      000000000000000000000909096600000000000000000808085D000000030000
      00000000000000000000000000003A3A3AF73E3E3EFF00000008000000000000
      000000000000000000000808085D0000000300000000032333C914B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF04293CD1000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000003E3E3EFF3E3E3EFF00000000000000000000
      0000000000000000000000000000000000000000000000000006000000000000
      00001111118400000017000000013A3A3AF73E3E3EFF000000080000000F1212
      128B00000001000000000000000600000000000000140B638EFE14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF0B6897FF0000001B0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000009090966000000000000
      00000000000000000000000000003E3E3EFF3E3E3EFF00000000000000000000
      0000000000000000000009090966000000000000000009090963000000031010
      10833E3E3EFF3E3E3EFF000000083A3A3AF73E3E3EFF000000083A3A3AF73E3E
      3EFF14141493000000000909096300000003000000360E7CB4FF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF0F83BDFF0000003E0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000009090966000000000000
      00000000000000000000000000003E3E3EFF3E3E3EFF00000000000000000000
      000000000000000000000909096600000000000000000808085D000000030B0B
      0B6C3E3E3EFE373737F0000000083A3A3AF73E3E3EFF00000008333333E83E3E
      3EFF0F0F0F7C000000000808085D00000003000000340E7BB3FF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF0F83BCFF0000003D0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000003E3E3EFF3E3E3EFF00000000000000000000
      0000000000000000000000000000000000000000000000000006000000000000
      00000B0B0B6C00000008000000003A3A3AF73E3E3EFF00000008000000000D0D
      0D7400000000000000000000000600000000000000130B618DFE14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF0B6796FF0000001A0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000009090966000000000000
      00000000000000000000000000003E3E3EFF3E3E3EFF00000000000000000000
      0000000000000000000009090966000000000000000009090963000000030000
      00000000000000000000000000003A3A3AF73E3E3EFF00000008000000000000
      0000000000000000000009090963000000030000000003202FC614B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF042739CE000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000009090966000000000000
      00000000000000000000000000003E3E3EFF3E3E3EFF00000000000000000000
      000000000000000000000909096600000000000000000808085D000000030000
      00000000000000000000000000003A3A3AF73E3E3EFF00000008000000000000
      000000000000000000000808085D0000000300000000000000500E82BBFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF0F87C3FF00000059000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000003E3E3EFF3E3E3EFF00000000000000000000
      0000000000000000000000000000000000000000000000000006000000000000
      00000000000000000000000000003A3A3AF73E3E3EFF00000008000000000000
      0000000000000000000000000006000000000000000000000000010C11A3129C
      E1FF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1
      FFFF129FE5FF020E15AB00000001000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000009090966000000000000
      00000000000000000000000000003E3E3EFF3E3E3EFF00000000000000000000
      0000000000000000000009090966000000000000000009090963000000090000
      0000000000060000000600000000363636EE3A3A3AF500000008000000060000
      000600000000000000060909096300000003000000000000000000000006010C
      11A30E82BBFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF0F85
      C0FF010D13AA0000000800000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000009090966090909660000
      0000090909660909096600000000090909660909096600000000090909660909
      096600000000090909660909096600000000000000000808085D080808600000
      00030808085D08080860000000030808085D08080860000000030808085D0808
      0860000000030808085D08080860000000030000000000000000000000000000
      00000000005003202FC60B618DFE0E7CB4FF0E7CB4FF0B638EFE032232C90000
      0055000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000012000000350000003500000014000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D77610FF321C037C0F0801440000
      0000000000000000000000000000000000000000000400000008000000080000
      0000000000080000000800000000000000080000000800000000000000080000
      0008000000000000000800000008000000040000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000321C037C391F0484D77610FF391F
      048400000000000000000000000000000000101010803C3C3CFB3A3A3AF70000
      00003A3A3AF73A3A3AF7000000003A3A3AF73A3A3AF7000000003A3A3AF73A3A
      3AF7000000003A3A3AF73C3C3CFB101010800000000000000000D77610FFD776
      10FFD77610FFD77610FF000000000000000000000000D77610FFD77610FFD776
      10FFD77610FFD77610FF00000000000000000100001200000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000D070140D77610FFD77610FFD776
      10FF391F04840000000000000000000000001010108010101080000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000010101080101010800000000000000000000000002E19
      03763D22048900000000000000000000000000000000000000002B180374D776
      10FF341D037E0000000000000000000000002816036F00000000000000000000
      0000000000000000000000000000000000006C3C08B503010020000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000321C037CD77610FFD776
      10FFD77610FF391F048400000000000000000303033C0303033C000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000303033C0303033C0000000000000000000000000302
      0022A1580CDD000000010000000000000000000000000000000084490AC8D776
      10FF050300290000000000000000000000004325058F512C069D000000100000
      000000000000000000000000000000000000D77610FFC66D0FF52D1903760000
      000500000000000000000000000000000000636363EF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF636363EF04040434321C037CD776
      10FFD77610FFD77610FF0D070140000000000404044404040444000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000004040444040404440000000000000000000000000000
      0000884B0BCB0804003400000000000000000000000003010020D57610FE9351
      0BD30000000000000000000000000000000008040033D77610FFC0690FF1512C
      069C190E02580603002D0100001200000008D77610FFD77610FFD77610FF904F
      0BD10A050038000000000000000000000000717171FF00000000000000000000
      000000000000000000000000000000000000000000000000000000000000321C
      037CD77610FF321C037C391F04843E22048A1010108010101080000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000010101080101010800000000000000000000000000000
      00002E190376D77610FFD77610FFD77610FFD77610FFD77610FFD77610FF341D
      037E0000000000000000000000000000000000000000673808B0D77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD37410FD492805950000000F00000000717171FF00000000424242C30A0A
      0A4D00000000434343C40E0E0E5A717171FF5C5C5CE7666666F2202020890000
      00000B06003C391F0484D77610FF864A0ACA0303033C0303033C000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000303033C0303033C0000000000000000000000000000
      00000302002297530BD60000000000000000000000008C4D0BCED77610FF0603
      002C000000000000000000000000000000000000000001010018A65B0DE0D776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFAF600DE6180D0256717171FF000000001515156F6262
      62ED575757DF696969F60000000F717171FF050505380B0B0B536D6D6DFA0000
      0000040404342C18037481470AC6000000110404044404040444000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000004040444040404440000000000000000000000000000
      0000000000008C4D0BCE0603002C0000000004020024D77610FF97530BD60000
      00000000000000000000000000000000000000000000000000000301001F8448
      0AC8D77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFA75C0DE1140A014E717171FF000000000101011B5555
      55DD0909094A393939B500000000717171FF525252DA5F5F5FEA121212670000
      0000636363EF0000000000000000000000001010108010101080000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000010101080101010800000000000000000000000000000
      000000000000301A0379391F048400000000311B037BD77610FF361E04810000
      0000000000000000000000000000000000000000000000000000000000000000
      0002160C01525F3407AAA35A0DDEC76D0FF5D77610FFD77610FFD77610FFD776
      10FFD17310FC4124048D0000000C00000000717171FF00000000000000004444
      44C63F3F3FBE1111116400000000717171FF0505053826262695373737B30000
      0000717171FF0000000000000000000000000303033C0303033C000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000303033C0303033C0000000000000000000000000000
      000000000000040200249A550BD8000000008F4E0BD0D77610FF0603002C0000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D77610FFD77610FFD77610FF874A
      0BCA08040031000000000000000000000000717171FF00000000000000001616
      16716D6D6DFB0000001500000000717171FF5C5C5CE6606060EB1A1A1A7B0000
      0000717171FF0000000000000000000000000404044404040444000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000004040444040404440000000000000000000000000000
      000000000000000000008C4D0BCE170D0155D77610FF97530BD6000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D77610FFC16A0FF22715036E0000
      000300000000000000000000000000000000717171FF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF0000000000000000000000001010108011111184000000080000
      0000000000080000000800000000000000080000000800000000000000080000
      0008000000000000000811111184101010800000000000000000000000000000
      00000000000000000000301A0379B4630DEAD77610FF361E0481000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000633608AD0201001B000000000000
      000000000000000000000000000000000000606060EB717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF636363EE0000000000000000000000000F0F0F7C3A3A3AF73A3A3AF70000
      00003A3A3AF73A3A3AF7000000003A3A3AF73A3A3AF7000000003A3A3AF73A3A
      3AF7000000003A3A3AF73A3A3AF70F0F0F7C0000000000000000000000000000
      0000000000000000000004020024D77610FFD77610FF0603002C000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000666666F27171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF696969F600000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000129BE0EF14B1FFFF14B1FFFF14B1
      FFFF129FE5F20000000000000000000000000000000000000000717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF00000000000000000000000000000000000000000000
      000000000008071E0071166501CE219602FB219702FB176901D1072100760000
      000A000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF717171FF0000000014B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF0000000000000000000000000000000000000000717171FF7171
      71FF000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF00000000000000000000000000000000000000000001
      001A176901D1229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF186E
      02D60002001F0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000010000130000000000000000000000000000
      0000717171FF0000000000000000000000001196D8EB14B1FFFF14B1FFFF14B1
      FFFF129ADEEE0000000000000000000000000000000000000000717171FF7171
      71FF000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF00000000000000000000000000000000000000061664
      01CD229C02FF197102D9030E004E0000000900000008020C0049176B02D3229C
      02FF186E02D60000000A00000000000000000000000000000000000000000000
      000000000000000000000201001E683908B10000000000000000000000000000
      00000000000000000000000000002816036F0000000000000000000000000000
      0000717171FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000717171FF7171
      71FF000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF00000000000000000000000000000000051A0069229C
      02FF197502DD00000014000000000000000000000000000000000000000E176B
      02D3229C02FF0721007600000000000000000000000000000000000000000000
      0000000000042A170372C36B0FF3D77610FF0000000000000000000000000000
      0000000000000000000E4C2905974A2905970000000000000000000000000000
      0000717171FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF00000000000000000000000000000000145B01C3229C
      02FF04120057000000000000000000000000000000000000000000000000020D
      004A229C02FF176902D100000000000000000000000000000000000000000905
      00358C4D0BCED77610FFD77610FFD77610FF00000008010000120603002C180D
      02574E2B069ABC670EEFD77610FF0B06003B0000000000000000000000000000
      0000717171FF000000000000000000000000129BE0EF14B1FFFF14B1FFFF14B1
      FFFF129FE5F20000000000000000000000000000000000000000717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0008229C02FF229702FB0000000000000000000000000000000E45260591D274
      10FCD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FF703D08B8000000000000000000000000000000000000
      0000717171FF717171FF717171FF0000000014B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF0000000000000000000000000000000000000000717171FF7171
      71FF000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0009229C02FF219602FB0000000000000000160C0152AB5E0DE4D77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFAC5F0DE40201001C000000000000000000000000000000000000
      0000717171FF0000000000000000000000001198DCED14B1FFFF14B1FFFF14B1
      FFFF129EE3F10000000000000000000000000000000000000000717171FF7171
      71FF00000000717171FF717171FF717171FF717171FF00000000000000000000
      0000717171FF717171FF00000000000000000000000000000000229C02FF229C
      02FF229C02FF229C02FF0824007C00000000000000000000000000000000030E
      004D229C02FF166601CF00000000000000001109014AA45A0DDFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FF894B0BCC0302002200000000000000000000000000000000000000000000
      0000717171FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000717171FF7171
      71FF00000000717171FF00000000717171FF717171FF00000000000000000000
      0000717171FF717171FF00000000000000000000000000000000229C02FF229C
      02FF229C02FF0A2C01890000000000000000000000000000000000000011196F
      02D7229C02FF071F00730000000000000000000000000000000B3E220489CF72
      10FBD77610FFD77610FFD77610FFD77610FFC76E0FF6A45A0DDF623507AC170D
      0155000000030000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000717171FF7171
      71FF00000000717171FF00000000717171FF717171FF00000000000000000000
      0000717171FF717171FF00000000000000000000000000000000229C02FF229C
      02FF229C02FF1B7802E004110056000000110000000F03100052197002D8229C
      02FF176902D10000000800000000000000000000000000000000000000000703
      002E83480AC7D77610FFD77610FFD77610FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000129FE5F214B1
      FFFF14B1FFFF14B1FFFF13A5EDF6000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000626262EE7171
      71FF00000000717171FF717171FF717171FF717171FF00000000000000000000
      0000717171FF666666F200000000000000000000000000000000229C02FF0A2D
      018A176701D0229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF1767
      01D00001001B0000000000000000000000000000000000000000000000000000
      0000000000022414026ABE690FF0D77610FF0000000000000000000000000000
      000000000000000000000000000000000000000000000000000014B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000824007C0000
      000000000007061C006D156001C81F8E02F31F8E02F3156001C9061C006E0000
      0007000000000000000000000000000000000000000000000000000000000000
      00000000000000000000020100195F3407A90000000000000000000000000000
      00000000000000000000000000000000000000000000000000001198DCED14B1
      FFFF14B1FFFF14B1FFFF129EE3F1000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000A0C0C0C73282828CD3C3C3CFA3C3C
      3CFA292929CF0D0D0D760000000B0000000000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFCF780FFF778B09FF369804FF229C
      02FF359803FF748B08FFCE780FFF00000000229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF000000000000
      00000000000000000000000000000000000000000000229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF000000000000000000000000000000000000
      00000000000000000000010101242D2D2DD93E3E3EFF1D1D1DAF000000140000
      00121B1B1BA93E3E3EFF2E2E2EDC0101012800000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD0780FFF479405FF229C02FF229C02FF229C
      02FF229C02FF229C02FF439505FF0000000E229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF000000000000
      00000000000000000000000000000000000000000000229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF0000000000000000229C02FF229C02FF229C
      02FF229C02FF229C02FF394F33FF3E3E3EFF3E3E3EFF259208FF385331FF3950
      33FF249506FF3E3E3EFF3E3E3EFF2C2C2CD700000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FF7A8A09FF229C02FF229C02FF229C02FFFFFF
      FFFF229C02FF229C02FF229C02FF0A2E018B229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF000000000000
      00000000000000000000000000000000000000000000229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF0000000000000000229C02FF229C02FF229C
      02FF229C02FF229C02FF385231FF3E3E3EFF3E3E3EFF259209FF37562FFF3853
      31FF249507FF3E3E3EFF3E3E3EFF2B2B2BD400000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FF3A9704FF229C02FF229C02FF229C02FFFFFF
      FFFF229C02FF229C02FF229C02FF1C7E02E5229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF000000000000
      00000000000000000000000000000000000000000000229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF0000000000000000229C02FF229C02FF229C
      02FF229C02FF229C02FF259109FF394F33FF3E3E3EFF36592DFF259209FF2592
      08FF355B2BFF3E3E3EFF2C2C2CD70101012400000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FF289B02FF229C02FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF000000000000
      00000000000000000000000000000000000000000000229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF0000000000000000229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF239A03FF2D751BFF385430FF3D433BFF3D43
      3BFF385231FF0B0B0B6E000000090000000000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FF3C9704FF229C02FF229C02FF229C02FFFFFF
      FFFF229C02FF229C02FF229C02FF1B7C02E3229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF00000000229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF0000000000000000229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF00000000000000000000000000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FF7D8909FF229C02FF229C02FF229C02FFFFFF
      FFFF229C02FF229C02FF229C02FF0A2B0187229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF00000000229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF0000000000000000229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF00000000000000000000000000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD17710FF4B9405FF229C02FF229C02FF229C
      02FF229C02FF229C02FF479405FF0000000B229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF00000000229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF0000000000000000229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF00000000000000000000000000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD17710FF7D8909FF3C9704FF289B
      02FF3A9704FF7A8A09FFD0780FFF00000000229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF00000000229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF0000000000000000229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF00000000000000000000000000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FF000000000000000000000000000000000000
      00000000000000000000D77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF00000000229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF0000000000000000229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF00000000000000000000000000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FF000000000000000000000000000000000000
      00000000000000000000D77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF00000000229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF0000000000000000229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF00000000000000000000000000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FF000000000000000000000000000000000000
      00000000000000000000D77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF00000000229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF0000000000000000229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF00000000000000000000000000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FF000000000000000000000000000000000000
      00000000000000000000D77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF00000000229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF0000000000000000229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF00000000000000000000000000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FF000000000000000000000000000000000000
      00000000000000000000D77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF00000000229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000D77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000737272FF737272FF737272FF7372
      72FF737272FF737272FF737272FF737272FF737272FF737272FF737272FF7372
      72FF737272FF737272FF737272FF737272FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000737272FF737272FF737272FF7372
      72FF737272FF737272FF737272FF737272FF737272FF737272FF737272FF7372
      72FF737272FF737272FF737272FF737272FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000737272FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF737272FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000737272FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF737272FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000737272FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF737272FF0000000000000000000000000000
      0000000000010000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000737272FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF737272FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000737272FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF737272FF0000000000000000000000000707
      348112128FD30000011700000000000000000000000000000000000001141212
      89CF08083B89000000000000000000000000737272FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF737272FF737272FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF737272FF0000000000000000717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF0000000000000000737272FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF737272FF0000000000000000000000001111
      7FC71B1BD1FF131390D40000011700000000000000000000011412128AD01B1B
      D1FF121289CF000000000000000000000000737272FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF737272FF737272FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF737272FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000737272FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF737272FF0000000000000000000000000000
      0011111184CB1B1BD1FF131390D4000001170000011412128AD01B1BD1FF1212
      8AD000000114000000000000000000000000737272FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF737272FF737272FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF737272FF0000000000000000717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF000000000000
      000000000000000000000000000000000000737272FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF737272FF0000000000000000000000000000
      000000000011111184CB1B1BD1FF131390D412128AD01B1BD1FF12128AD00000
      011400000000000000000000000000000000737272FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF737272FF737272FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF737272FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000737272FFFFFFFFFFFFFFFFFF7372
      72FF737272FF737272FF737272FF737272FF737272FF737272FF737272FF7372
      72FF737272FFFFFFFFFFFFFFFFFF737272FF0000000000000000000000000000
      00000000000000000011111184CB1B1BD1FF1B1BD1FF12128AD0000001140000
      000000000000000000000000000000000000737272FFFFFFFFFFFFFFFFFF7372
      72FF737272FF737272FF737272FF737272FF737272FF737272FF737272FF7372
      72FF737272FFFFFFFFFFFFFFFFFF737272FF0000000000000000717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF0000000000000000737272FFFFFFFFFFFFFFFFFF7372
      72FF737272FF737272FF737272FF737272FF737272FF737272FF737272FF7372
      72FF737272FFFFFFFFFFFFFFFFFF737272FF0000000000000000000000000000
      0000000000000000011412128AD01B1BD1FF1B1BD1FF131390D4000001170000
      000000000000000000000000000000000000737272FFFFFFFFFFFFFFFFFF7372
      72FF737272FF737272FF737272FF737272FF737272FF737272FF737272FF7372
      72FF737272FFFFFFFFFFFFFFFFFF737272FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000737272FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF737272FF0000000000000000000000000000
      00000000011412128AD01B1BD1FF12128AD0111184CB1B1BD1FF131390D40000
      011700000000000000000000000000000000737272FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF737272FF737272FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF737272FF0000000000000000717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF000000000000
      000000000000000000000000000000000000737272FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF737272FF0000000000000000000000000000
      011412128AD01B1BD1FF12128AD00000011400000011111184CB1B1BD1FF1313
      90D400000117000000000000000000000000737272FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF737272FF737272FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF737272FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000737272FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF737272FF0000000000000000000000001111
      84CB1B1BD1FF12128AD000000114000000000000000000000011111184CB1B1B
      D1FF12128FD3000000010000000000000000737272FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF737272FF737272FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF737272FF0000000000000000717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF0000000000000000737272FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF737272FF0000000000000000000000000505
      2A73111185CB0000011400000000000000000000000000000000000000111111
      7FC70606307B000000000000000000000000737272FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF737272FF737272FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF737272FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000737272FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF737272FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000737272FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF737272FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000737272FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF737272FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000737272FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF737272FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000737272FF737272FF737272FF7372
      72FF737272FF737272FF737272FF737272FF737272FF737272FF737272FF7372
      72FF737272FF737272FF737272FF737272FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000737272FF737272FF737272FF7372
      72FF737272FF737272FF737272FF737272FF737272FF737272FF737272FF7372
      72FF737272FF737272FF737272FF737272FF424D3E000000000000003E000000
      2800000040000000800000000100010000000000000400000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000}
    DesignInfo = 25690128
    ImageInfo = <
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D2241
          6C69676E5F4C6566742220786D6C6E733D22687474703A2F2F7777772E77332E
          6F72672F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A
          2F2F7777772E77332E6F72672F313939392F786C696E6B2220783D2230707822
          20793D22307078222076696577426F783D223020302033322033322220737479
          6C653D22656E61626C652D6261636B67726F756E643A6E657720302030203332
          2033323B2220786D6C3A73706163653D227072657365727665223E262331333B
          262331303B3C7374796C6520747970653D22746578742F637373223E2E426C61
          636B7B66696C6C3A233732373237323B7D3C2F7374796C653E0D0A3C70617468
          2069643D22416C69676E5F4C6566745F325F2220636C6173733D22426C61636B
          2220643D224D32382C384834563668323456387A204D32302C31304834763268
          31365631307A204D32382C3134483476326832345631347A204D32382C323248
          3476326832345632327A204D32302C3138483476326831365631382020262339
          3B7A222F3E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020313620313622207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203136203136
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F6373732220786D6C3A737061
          63653D227072657365727665223E2E57686974657B66696C6C3A234646464646
          463B7D262331333B262331303B2623393B2E426C61636B7B66696C6C3A233733
          373337343B7D3C2F7374796C653E0D0A3C7265637420636C6173733D22576869
          7465222077696474683D22313622206865696768743D223136222F3E0D0A3C70
          61746820636C6173733D22426C61636B2220643D224D302C3076313668313656
          3048307A204D31352C3135483156316831345631357A222F3E0D0A3C72656374
          20636C6173733D22426C61636B2220783D22332220793D223722207769647468
          3D22313022206865696768743D2232222F3E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F6373732220786D6C3A737061
          63653D227072657365727665223E2E426C75657B66696C6C3A23313137374437
          3B7D262331333B262331303B2623393B2E59656C6C6F777B66696C6C3A234646
          423131353B7D262331333B262331303B2623393B2E426C61636B7B66696C6C3A
          233732373237323B7D262331333B262331303B2623393B2E477265656E7B6669
          6C6C3A233033394332333B7D262331333B262331303B2623393B2E5265647B66
          696C6C3A234431314331433B7D262331333B262331303B2623393B2E7374307B
          6F7061636974793A302E37353B7D262331333B262331303B2623393B2E737431
          7B6F7061636974793A302E353B7D3C2F7374796C653E0D0A3C672069643D2244
          656C657465223E0D0A09093C673E0D0A0909093C7061746820636C6173733D22
          5265642220643D224D31382E382C31366C362E392D362E3963302E342D302E34
          2C302E342D312C302D312E346C2D312E342D312E34632D302E342D302E342D31
          2D302E342D312E342C304C31362C31332E324C392E312C362E33632D302E342D
          302E342D312D302E342D312E342C3020202623393B2623393B2623393B4C362E
          332C372E37632D302E342C302E342D302E342C312C302C312E346C362E392C36
          2E396C2D362E392C362E39632D302E342C302E342D302E342C312C302C312E34
          6C312E342C312E3463302E342C302E342C312C302E342C312E342C306C362E39
          2D362E396C362E392C362E3920202623393B2623393B2623393B63302E342C30
          2E342C312C302E342C312E342C306C312E342D312E3463302E342D302E342C30
          2E342D312C302D312E344C31382E382C31367A222F3E0D0A09093C2F673E0D0A
          09093C673E0D0A0909093C7061746820636C6173733D225265642220643D224D
          31382E382C31366C362E392D362E3963302E342D302E342C302E342D312C302D
          312E346C2D312E342D312E34632D302E342D302E342D312D302E342D312E342C
          304C31362C31332E324C392E312C362E33632D302E342D302E342D312D302E34
          2D312E342C3020202623393B2623393B2623393B4C362E332C372E37632D302E
          342C302E342D302E342C312C302C312E346C362E392C362E396C2D362E392C36
          2E39632D302E342C302E342D302E342C312C302C312E346C312E342C312E3463
          302E342C302E342C312C302E342C312E342C306C362E392D362E396C362E392C
          362E3920202623393B2623393B2623393B63302E342C302E342C312C302E342C
          312E342C306C312E342D312E3463302E342D302E342C302E342D312C302D312E
          344C31382E382C31367A222F3E0D0A09093C2F673E0D0A093C2F673E0D0A3C2F
          7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020313620313622207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203136203136
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F6373732220786D6C3A737061
          63653D227072657365727665223E2E57686974657B66696C6C3A234646464646
          463B7D262331333B262331303B2623393B2E426C61636B7B66696C6C3A233733
          373337343B7D3C2F7374796C653E0D0A3C7265637420636C6173733D22576869
          7465222077696474683D22313622206865696768743D223136222F3E0D0A3C70
          61746820636C6173733D22426C61636B2220643D224D302C3076313668313656
          3048307A204D31352C3135483156316831345631357A222F3E0D0A3C706F6C79
          676F6E20636C6173733D22426C61636B2220706F696E74733D2231332C372039
          2C3720392C3320372C3320372C3720332C3720332C3920372C3920372C313320
          392C313320392C392031332C39222F3E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F6373732220786D6C3A737061
          63653D227072657365727665223E2E477265656E7B66696C6C3A233033394332
          333B7D262331333B262331303B2623393B2E426C61636B7B66696C6C3A233346
          334633463B7D3C2F7374796C653E0D0A3C7265637420783D22322220793D2232
          2220636C6173733D22477265656E222077696474683D22323422206865696768
          743D223234222F3E0D0A3C7061746820636C6173733D22426C61636B2220643D
          224D32322C3138632D352E352C302D31302C342E312D31302C3663302C322C34
          2E352C362C31302C367331302D342C31302D364333322C32322C32372E352C31
          382C32322C31387A204D32322C3238632D322E322C302D342D312E382D342D34
          2063302D322E322C312E382D342C342D3473342C312E382C342C344332362C32
          362E322C32342E322C32382C32322C32387A222F3E0D0A3C636972636C652063
          6C6173733D22426C61636B222063783D223232222063793D2232342220723D22
          32222F3E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D223020302033322033322220786D6C3A7370
          6163653D227072657365727665223E262331333B262331303B3C7374796C6520
          747970653D22746578742F6373732220786D6C3A73706163653D227072657365
          727665223E2E426C75657B66696C6C3A233131373744377D262331333B262331
          303B2623393B2E426C61636B7B66696C6C3A233346334633467D262331333B26
          2331303B2623393B2E477265656E7B66696C6C3A233033394332337D26233133
          3B262331303B2623393B2E57686974657B66696C6C3A234646464646467D3C2F
          7374796C653E0D0A3C7265637420783D22322220793D22322220636C6173733D
          22426C7565222077696474683D22323822206865696768743D223238222F3E0D
          0A3C636972636C652063783D223233222063793D2232312220636C6173733D22
          57686974652220723D2236222F3E0D0A3C7061746820636C6173733D22477265
          656E2220643D224D32332C3132632D352C302D392C342D392C3963302C352C34
          2C392C392C3973392D342C392D394333322C31362C32382C31322C32332C3132
          7A204D32382C3232682D347634682D32762D34682D34762D326834762D346832
          763468345632327A222F3E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D223020302033322033322220786D6C3A7370
          6163653D227072657365727665223E262331333B262331303B3C7374796C6520
          747970653D22746578742F6373732220786D6C3A73706163653D227072657365
          727665223E2E426C75657B66696C6C3A233131373744373B7D262331333B2623
          31303B2623393B2E477265656E7B66696C6C3A233033394332333B7D3C2F7374
          796C653E0D0A3C7265637420783D2231322220793D22302220636C6173733D22
          426C7565222077696474683D22323022206865696768743D223230222F3E0D0A
          3C7265637420783D22302220793D2231322220636C6173733D22477265656E22
          2077696474683D22323022206865696768743D223230222F3E0D0A3C2F737667
          3E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D223020302033322033322220786D6C3A7370
          6163653D227072657365727665223E262331333B262331303B3C7374796C6520
          747970653D22746578742F637373223E2E477265656E7B66696C6C3A23303339
          4332333B7D3C2F7374796C653E0D0A3C7265637420783D22322220793D223222
          20636C6173733D22477265656E222077696474683D2232382220686569676874
          3D223238222F3E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F6373732220786D6C3A737061
          63653D227072657365727665223E2E477265656E7B66696C6C3A233033394332
          333B7D262331333B262331303B2623393B2E426C61636B7B66696C6C3A233732
          373237323B7D262331333B262331303B2623393B2E5265647B66696C6C3A2344
          31314331433B7D262331333B262331303B2623393B2E59656C6C6F777B66696C
          6C3A234646423131353B7D262331333B262331303B2623393B2E426C75657B66
          696C6C3A233131373744373B7D262331333B262331303B2623393B2E57686974
          657B66696C6C3A234646464646463B7D262331333B262331303B2623393B2E73
          74307B6F7061636974793A302E353B7D262331333B262331303B2623393B2E73
          74317B6F7061636974793A302E37353B7D3C2F7374796C653E0D0A3C67206964
          3D22496E736572745472656556696577223E0D0A09093C7061746820636C6173
          733D2259656C6C6F772220643D224D31332C38483543342E342C382C342C372E
          362C342C37563363302D302E352C302E342D312C312D31683863302E362C302C
          312C302E352C312C3176344331342C372E362C31332E362C382C31332C387A20
          4D32362C3137762D3420202623393B2623393B63302D302E362D302E352D312D
          312D31682D38632D302E352C302D312C302E342D312C31763463302C302E352C
          302E352C312C312C3168384332352E352C31382C32362C31372E352C32362C31
          377A204D32362C3237762D3463302D302E352D302E352D312D312D31682D3863
          2D302E352C302D312C302E352D312C3120202623393B2623393B763463302C30
          2E352C302E352C312C312C3168384332352E352C32382C32362C32372E352C32
          362C32377A222F3E0D0A09093C706F6C79676F6E20636C6173733D22426C6163
          6B2220706F696E74733D2231342C31362031342C31342031302C31342031302C
          313020382C313020382C32362031342C32362031342C32342031302C32342031
          302C3136202623393B222F3E0D0A093C2F673E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F637373223E2E426C61636B7B
          66696C6C3A233732373237323B7D3C2F7374796C653E0D0A3C7061746820636C
          6173733D22426C61636B2220643D224D31382C36682D387638683856367A204D
          31342C3132682D32563868325631327A222F3E0D0A3C7061746820636C617373
          3D22426C61636B2220643D224D32342C3676313048385636483543342E342C36
          2C342C362E342C342C3776323263302C302E362C302E342C312C312C31683232
          63302E362C302C312D302E342C312D31563138762D32563763302D302E362D30
          2E342D312D312D314832347A204D32342C3236483820202623393B762D366831
          365632367A222F3E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F6373732220786D6C3A737061
          63653D227072657365727665223E2E477265656E7B66696C6C3A233033394332
          333B7D262331333B262331303B2623393B2E426C61636B7B66696C6C3A233732
          373237323B7D262331333B262331303B2623393B2E5265647B66696C6C3A2344
          31314331433B7D262331333B262331303B2623393B2E59656C6C6F777B66696C
          6C3A234646423131353B7D262331333B262331303B2623393B2E426C75657B66
          696C6C3A233131373744373B7D262331333B262331303B2623393B2E57686974
          657B66696C6C3A234646464646463B7D262331333B262331303B2623393B2E73
          74307B6F7061636974793A302E353B7D262331333B262331303B2623393B2E73
          74317B6F7061636974793A302E37353B7D3C2F7374796C653E0D0A3C67206964
          3D2252657365744C61796F75744F7074696F6E73223E0D0A09093C7061746820
          636C6173733D22477265656E2220643D224D31362C34632D332E332C302D362E
          332C312E332D382E352C332E354C342C3476313068302E3268342E314831346C
          2D332E362D332E364331312E382C382E392C31332E382C382C31362C3863342E
          342C302C382C332E362C382C38732D332E362C382D382C3820202623393B2623
          393B632D332E372C302D362E382D322E362D372E372D3648342E3263312C352E
          372C352E392C31302C31312E382C313063362E362C302C31322D352E342C3132
          2D31325332322E362C342C31362C347A222F3E0D0A093C2F673E0D0A3C2F7376
          673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D2255
          6E646F2220786D6C6E733D22687474703A2F2F7777772E77332E6F72672F3230
          30302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F7777772E
          77332E6F72672F313939392F786C696E6B2220783D223070782220793D223070
          78222076696577426F783D2230203020333220333222207374796C653D22656E
          61626C652D6261636B67726F756E643A6E6577203020302033322033323B2220
          786D6C3A73706163653D227072657365727665223E262331333B262331303B3C
          7374796C6520747970653D22746578742F637373223E2E426C75657B66696C6C
          3A233131373744373B7D3C2F7374796C653E0D0A3C7061746820636C6173733D
          22426C75652220643D224D33322C323663302C302C302D382D31362D3876364C
          302C31344C31362C3476364333322C31302C33322C32362C33322C32367A222F
          3E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D2252
          65646F2220786D6C6E733D22687474703A2F2F7777772E77332E6F72672F3230
          30302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F7777772E
          77332E6F72672F313939392F786C696E6B2220783D223070782220793D223070
          78222076696577426F783D2230203020333220333222207374796C653D22656E
          61626C652D6261636B67726F756E643A6E6577203020302033322033323B2220
          786D6C3A73706163653D227072657365727665223E262331333B262331303B3C
          7374796C6520747970653D22746578742F637373223E2E426C75657B66696C6C
          3A233131373744373B7D3C2F7374796C653E0D0A3C7061746820636C6173733D
          22426C75652220643D224D31362C313056346C31362C31304C31362C3234762D
          3643302C31382C302C32362C302C323653302C31302C31362C31307A222F3E0D
          0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F6373732220786D6C3A737061
          63653D227072657365727665223E2E59656C6C6F777B66696C6C3A2346464231
          31353B7D262331333B262331303B2623393B2E5265647B66696C6C3A23443131
          4331433B7D262331333B262331303B2623393B2E426C61636B7B66696C6C3A23
          3732373237323B7D262331333B262331303B2623393B2E426C75657B66696C6C
          3A233131373744373B7D262331333B262331303B2623393B2E57686974657B66
          696C6C3A234646464646463B7D262331333B262331303B2623393B2E47726565
          6E7B66696C6C3A233033394332333B7D262331333B262331303B2623393B2E73
          74307B6F7061636974793A302E37353B7D262331333B262331303B2623393B2E
          7374317B6F7061636974793A302E353B7D262331333B262331303B2623393B2E
          7374327B6F7061636974793A302E32353B7D262331333B262331303B2623393B
          2E7374337B66696C6C3A234646423131353B7D3C2F7374796C653E0D0A3C672F
          3E0D0A3C672069643D2252656E616D65223E0D0A09093C7061746820636C6173
          733D22426C61636B2220643D224D32312E362C31302E3363302D302E372D302E
          332D312E332D302E392D312E374332302E312C382E322C31392E312C382C3137
          2E392C3848313476392E39563138683463312E322C302C322E322D302E322C32
          2E392D302E3820202623393B2623393B4332312E372C31362E362C32322C3136
          2C32322C313563302D302E362D302E322D312E322D302E372D312E36632D302E
          352D302E342D312E312D302E372D312E382D302E3863302E362D302E322C312E
          312D302E352C312E352D302E394332312E342C31312E332C32312E362C31302E
          392C32312E362C31302E337A20202623393B2623393B204D31362E342C392E37
          68302E3963312E312C302C312E372C302E342C312E372C312E3163302C302E34
          2D302E312C302E372D302E342C302E394331382E342C31312E392C31382C3132
          2C31372E352C3132682D312E3156392E377A204D31392C31352E38632D302E33
          2C302E322D302E382C302E342D312E332C302E3420202623393B2623393B682D
          312E33762D322E3668312E3363302E352C302C302E392C302E312C312E332C30
          2E3363302E332C302E322C302E352C302E362C302E352C302E394331392E352C
          31352E332C31392E342C31352E362C31392C31352E387A204D31372E322C3232
          4831632D302E352C302D312D302E352D312D31563520202623393B2623393B63
          302D302E352C302E352D312C312D3168323463302E352C302C312C302E352C31
          2C3176382E326C2D322C32563648327631346831372E324C31372E322C32327A
          204D342E312C313868322E326C302E362D322E3368332E326C302E362C322E33
          4831334C392E382C3848372E344C342E312C31387A20202623393B2623393B20
          4D382E342C31302E3763302E312D302E332C302E312D302E362C302E312D302E
          3968302E3163302C302E332C302E312C302E362C302E312C302E396C312C332E
          3348372E344C382E342C31302E377A222F3E0D0A09093C7061746820636C6173
          733D22426C75652220643D224D32392C32316C2D382C386C2D342D346C382D38
          4C32392C32317A204D33302C32306C312E372D312E3763302E342D302E342C30
          2E342D312C302D312E334C32392C31342E33632D302E342D302E342D312D302E
          342D312E332C304C32362C31364C33302C32307A20202623393B2623393B204D
          31362C3236763468344C31362C32367A222F3E0D0A093C2F673E0D0A3C2F7376
          673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E312220786D6C6E73
          3D22687474703A2F2F7777772E77332E6F72672F323030302F7376672220786D
          6C6E733A786C696E6B3D22687474703A2F2F7777772E77332E6F72672F313939
          392F786C696E6B2220783D223070782220793D22307078222076696577426F78
          3D223020302033322033322220786D6C3A73706163653D227072657365727665
          223E262331333B262331303B3C7374796C6520747970653D22746578742F6373
          73223E2E426C61636B7B66696C6C3A233346334633463B7D3C2F7374796C653E
          0D0A3C67207472616E73666F726D3D226D617472697828312C20302C20302C20
          312C202D302E3233333039312C202D302E36343129223E0D0A09093C72656374
          20783D2232302E322220793D22342E3635392220636C6173733D22426C61636B
          222077696474683D223422206865696768743D2232222F3E0D0A09093C706F6C
          79676F6E20636C6173733D22426C61636B2220706F696E74733D2232362E3220
          342E3635392032362E3220362E3635392032392E3220362E3635392032392E32
          20392E3635392033312E3220392E3635392033312E3220342E363539222F3E0D
          0A09093C7265637420783D22382E322220793D22342E3635392220636C617373
          3D22426C61636B222077696474683D223422206865696768743D2232222F3E0D
          0A09093C706F6C79676F6E20636C6173733D22426C61636B2220706F696E7473
          3D22332E3220362E36353920362E3220362E36353920362E3220342E36353920
          312E3220342E36353920312E3220392E36353920332E3220392E363539222F3E
          0D0A09093C7265637420783D22312E322220793D2231372E3635392220636C61
          73733D22426C61636B222077696474683D223222206865696768743D2234222F
          3E0D0A09093C7265637420783D2231342E322220793D22342E3635392220636C
          6173733D22426C61636B222077696474683D223422206865696768743D223222
          2F3E0D0A09093C706F6C79676F6E20636C6173733D22426C61636B2220706F69
          6E74733D22332E322032332E36353920312E322032332E36353920312E322032
          382E36353920362E322032382E36353920362E322032362E36353920332E3220
          32362E363539222F3E0D0A09093C7265637420783D22312E322220793D223131
          2E3635392220636C6173733D22426C61636B222077696474683D223222206865
          696768743D2234222F3E0D0A09093C706F6C79676F6E20636C6173733D22426C
          61636B2220706F696E74733D2232362E322032362E3635392032362E32203238
          2E3635392033312E322032382E3635392033312E322032332E3635392032392E
          322032332E3635392032392E322032362E363539222F3E0D0A09093C72656374
          20783D2232392E322220793D2231372E3635392220636C6173733D22426C6163
          6B222077696474683D223222206865696768743D2234222F3E0D0A09093C7265
          637420783D2232392E322220793D2231312E3635392220636C6173733D22426C
          61636B222077696474683D223222206865696768743D2234222F3E0D0A09093C
          7265637420783D2232302E322220793D2232362E3635392220636C6173733D22
          426C61636B222077696474683D223422206865696768743D2232222F3E0D0A09
          093C7265637420783D22382E322220793D2232362E3635392220636C6173733D
          22426C61636B222077696474683D223422206865696768743D2232222F3E0D0A
          09093C706F6C79676F6E20636C6173733D22426C61636B2220706F696E74733D
          2231342E322032362E3635392031382E322032362E3635392031382E32203238
          2E3635392031342E322032382E363539222F3E0D0A093C2F673E0D0A3C2F7376
          673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F637373223E2E426C75657B66
          696C6C3A233131373744373B7D3C2F7374796C653E0D0A3C7061746820636C61
          73733D22426C75652220643D224D32382C3236682D322E374C31382C346C2D32
          2C306C302C306C2D322C304C362E372C323648347632683268326834762D3248
          382E376C322D3668382E376C322C36483138763268346C302C3068346C302C30
          68325632367A204D31312E332C31384C31352C3720202623393B6C332E372C31
          314831312E337A222F3E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D222D34363320323635203332203332222073
          74796C653D22656E61626C652D6261636B67726F756E643A6E6577202D343633
          203236352033322033323B2220786D6C3A73706163653D227072657365727665
          223E262331333B262331303B3C7374796C6520747970653D22746578742F6373
          732220786D6C3A73706163653D227072657365727665223E2E426C61636B7B66
          696C6C3A233346334633463B7D262331333B262331303B2623393B2E7374307B
          6F7061636974793A302E343B7D3C2F7374796C653E0D0A3C6720636C6173733D
          22737430223E0D0A09093C7265637420783D222D3434332220793D2232363722
          20636C6173733D22426C61636B222077696474683D223422206865696768743D
          2232222F3E0D0A09093C706F6C79676F6E20636C6173733D22426C61636B2220
          706F696E74733D222D3433372C323637202D3433372C323639202D3433352C32
          3639202D3433352C323731202D3433332C323731202D3433332C323637202623
          393B222F3E0D0A09093C7265637420783D222D3435352220793D223236372220
          636C6173733D22426C61636B222077696474683D223422206865696768743D22
          32222F3E0D0A09093C7265637420783D222D3433352220793D22323733222063
          6C6173733D22426C61636B222077696474683D223222206865696768743D2234
          222F3E0D0A09093C706F6C79676F6E20636C6173733D22426C61636B2220706F
          696E74733D222D3435392C323639202D3435372C323639202D3435372C323637
          202D3436312C323637202D3436312C323731202D3435392C323731202623393B
          222F3E0D0A09093C7265637420783D222D3434332220793D223239332220636C
          6173733D22426C61636B222077696474683D223422206865696768743D223222
          2F3E0D0A09093C7265637420783D222D3436312220793D223238352220636C61
          73733D22426C61636B222077696474683D223222206865696768743D2234222F
          3E0D0A09093C706F6C79676F6E20636C6173733D22426C61636B2220706F696E
          74733D222D3433352C323933202D3433372C323933202D3433372C323935202D
          3433332C323935202D3433332C323931202D3433352C323931202623393B222F
          3E0D0A09093C7265637420783D222D3433352220793D223237392220636C6173
          733D22426C61636B222077696474683D223222206865696768743D2234222F3E
          0D0A09093C7265637420783D222D3435352220793D223239332220636C617373
          3D22426C61636B222077696474683D223422206865696768743D2232222F3E0D
          0A09093C7265637420783D222D3434392220793D223236372220636C6173733D
          22426C61636B222077696474683D223422206865696768743D2232222F3E0D0A
          09093C7265637420783D222D3436312220793D223237392220636C6173733D22
          426C61636B222077696474683D223222206865696768743D2234222F3E0D0A09
          093C706F6C79676F6E20636C6173733D22426C61636B2220706F696E74733D22
          2D3435392C323931202D3436312C323931202D3436312C323935202D3435372C
          323935202D3435372C323933202D3435392C323933202623393B222F3E0D0A09
          093C7265637420783D222D3436312220793D223237332220636C6173733D2242
          6C61636B222077696474683D223222206865696768743D2234222F3E0D0A0909
          3C7265637420783D222D3434392220793D223239332220636C6173733D22426C
          61636B222077696474683D223422206865696768743D2232222F3E0D0A09093C
          7265637420783D222D3433352220793D223238352220636C6173733D22426C61
          636B222077696474683D223222206865696768743D2234222F3E0D0A093C2F67
          3E0D0A3C7265637420783D222D3435392220793D223237392220636C6173733D
          22426C61636B222077696474683D22323422206865696768743D223422207472
          616E73666F726D3D226D617472697828302C20312C202D312C20302C202D3136
          362C2037323829222F3E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E6577202D3436332032363520
          33322033323B2220786D6C3A73706163653D227072657365727665223E262331
          333B262331303B3C7374796C6520747970653D22746578742F6373732220786D
          6C3A73706163653D227072657365727665223E2E426C61636B7B66696C6C3A23
          3346334633463B7D262331333B262331303B2623393B2E7374307B6F70616369
          74793A302E343B7D3C2F7374796C653E0D0A3C67207472616E73666F726D3D22
          6D617472697828312C20302C20302C20312C203436332E3034303139322C202D
          3236342E39323939303129223E0D0A09093C6720636C6173733D22737430223E
          0D0A0909093C7265637420783D222D3434332220793D223236372220636C6173
          733D22426C61636B222077696474683D223422206865696768743D2232222F3E
          0D0A0909093C706F6C79676F6E20636C6173733D22426C61636B2220706F696E
          74733D222D3433372C323637202D3433372C323639202D3433352C323639202D
          3433352C323731202D3433332C323731202D3433332C323637202623393B222F
          3E0D0A0909093C7265637420783D222D3435352220793D223236372220636C61
          73733D22426C61636B222077696474683D223422206865696768743D2232222F
          3E0D0A0909093C7265637420783D222D3433352220793D223237332220636C61
          73733D22426C61636B222077696474683D223222206865696768743D2234222F
          3E0D0A0909093C706F6C79676F6E20636C6173733D22426C61636B2220706F69
          6E74733D222D3435392C323639202D3435372C323639202D3435372C32363720
          2D3436312C323637202D3436312C323731202D3435392C323731202623393B22
          2F3E0D0A0909093C7265637420783D222D3434332220793D223239332220636C
          6173733D22426C61636B222077696474683D223422206865696768743D223222
          2F3E0D0A0909093C7265637420783D222D3436312220793D223238352220636C
          6173733D22426C61636B222077696474683D223222206865696768743D223422
          2F3E0D0A0909093C706F6C79676F6E20636C6173733D22426C61636B2220706F
          696E74733D222D3433352C323933202D3433372C323933202D3433372C323935
          202D3433332C323935202D3433332C323931202D3433352C323931202623393B
          222F3E0D0A0909093C7265637420783D222D3433352220793D22323739222063
          6C6173733D22426C61636B222077696474683D223222206865696768743D2234
          222F3E0D0A0909093C7265637420783D222D3435352220793D22323933222063
          6C6173733D22426C61636B222077696474683D223422206865696768743D2232
          222F3E0D0A0909093C7265637420783D222D3434392220793D22323637222063
          6C6173733D22426C61636B222077696474683D223422206865696768743D2232
          222F3E0D0A0909093C7265637420783D222D3436312220793D22323739222063
          6C6173733D22426C61636B222077696474683D223222206865696768743D2234
          222F3E0D0A0909093C706F6C79676F6E20636C6173733D22426C61636B222070
          6F696E74733D222D3435392C323931202D3436312C323931202D3436312C3239
          35202D3435372C323935202D3435372C323933202D3435392C32393320262339
          3B222F3E0D0A0909093C7265637420783D222D3436312220793D223237332220
          636C6173733D22426C61636B222077696474683D223222206865696768743D22
          34222F3E0D0A0909093C7265637420783D222D3434392220793D223239332220
          636C6173733D22426C61636B222077696474683D223422206865696768743D22
          32222F3E0D0A0909093C7265637420783D222D3433352220793D223238352220
          636C6173733D22426C61636B222077696474683D223222206865696768743D22
          34222F3E0D0A09093C2F673E0D0A09093C7265637420783D222D343439222079
          3D223236392220636C6173733D22426C61636B222077696474683D2234222068
          65696768743D223234222F3E0D0A09093C706F6C79676F6E20636C6173733D22
          426C61636B2220706F696E74733D222D3435332C323739202D3435332C323737
          202D3435372C323831202D3435332C323835202D3435332C323833202D343531
          2C323833202D3435312C32373920222F3E0D0A09093C706F6C79676F6E20636C
          6173733D22426C61636B2220706F696E74733D222D3434312C323739202D3434
          312C323737202D3433372C323831202D3434312C323835202D3434312C323833
          202D3434332C323833202D3434332C32373920222F3E0D0A093C2F673E0D0A3C
          2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D223020302033322033322220786D6C3A7370
          6163653D227072657365727665223E262331333B262331303B3C7374796C6520
          747970653D22746578742F6373732220786D6C3A73706163653D227072657365
          727665223E2E59656C6C6F777B66696C6C3A234646423131353B7D262331333B
          262331303B2623393B2E426C61636B7B66696C6C3A233346334633463B7D3C2F
          7374796C653E0D0A3C636972636C652063783D223136222063793D2231362220
          636C6173733D2259656C6C6F772220723D22313422207374726F6B653D22426C
          61636B22207374726F6B652D77696474683D2231222F3E0D0A3C2F7376673E0D
          0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E312220786D6C6E73
          3D22687474703A2F2F7777772E77332E6F72672F323030302F7376672220786D
          6C6E733A786C696E6B3D22687474703A2F2F7777772E77332E6F72672F313939
          392F786C696E6B2220783D223070782220793D22307078222076696577426F78
          3D223020302033322033322220656E61626C652D6261636B67726F756E643D22
          6E6577203020302033322033322220786D6C3A73706163653D22707265736572
          7665223E262331333B262331303B3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F6373732220786D6C3A737061
          63653D227072657365727665223E2E426C61636B7B66696C6C3A233346334633
          463B7D262331333B262331303B2623393B2E426C75657B66696C6C3A23313137
          3744373B7D262331333B262331303B2623393B2E477265656E7B66696C6C3A23
          3033394332333B7D3C2F7374796C653E0D0A3C706F6C79676F6E20636C617373
          3D22426C61636B2220706F696E74733D2233302C322033302C382033322C3820
          33322C302032342C302032342C3220222F3E0D0A3C706F6C79676F6E20636C61
          73733D22426C61636B2220706F696E74733D22322C3220382C3220382C302030
          2C3020302C3820322C3820222F3E0D0A3C706F6C79676F6E20636C6173733D22
          426C61636B2220706F696E74733D22322C333020322C323420302C323420302C
          333220382C333220382C333020222F3E0D0A3C706F6C79676F6E20636C617373
          3D22426C61636B2220706F696E74733D2233302C33302032342C33302032342C
          33322033322C33322033322C32342033302C323420222F3E0D0A3C7265637420
          783D2231342220793D22362220636C6173733D22477265656E22207769647468
          3D22313222206865696768743D223132222F3E0D0A3C7265637420783D223622
          20793D2231322220636C6173733D22426C7565222077696474683D2231342220
          6865696768743D223134222F3E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F6373732220786D6C3A737061
          63653D227072657365727665223E2E426C75657B66696C6C3A23313137374437
          3B7D262331333B262331303B2623393B2E477265656E7B66696C6C3A23303339
          4332333B7D262331333B262331303B2623393B2E5265647B66696C6C3A234431
          314331433B7D3C2F7374796C653E0D0A3C706F6C79676F6E20636C6173733D22
          5265642220706F696E74733D22382C3820322C3820322C31302031302C313020
          31302C3220382C3220222F3E0D0A3C706F6C79676F6E20636C6173733D225265
          642220706F696E74733D2232342C32342033302C32342033302C32322032322C
          32322032322C33302032342C333020222F3E0D0A3C7265637420783D22313822
          20793D22322220636C6173733D22477265656E222077696474683D2231322220
          6865696768743D223132222F3E0D0A3C7265637420783D22322220793D223136
          2220636C6173733D22426C7565222077696474683D2231342220686569676874
          3D223134222F3E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F6373732220786D6C3A737061
          63653D227072657365727665223E2E426C75657B66696C6C3A23313137374437
          3B7D262331333B262331303B2623393B2E59656C6C6F777B66696C6C3A234646
          423131353B7D262331333B262331303B2623393B2E426C61636B7B66696C6C3A
          233732373237323B7D262331333B262331303B2623393B2E477265656E7B6669
          6C6C3A233033394332333B7D262331333B262331303B2623393B2E5265647B66
          696C6C3A234431314331433B7D262331333B262331303B2623393B2E7374307B
          6F7061636974793A302E37353B7D262331333B262331303B2623393B2E737431
          7B6F7061636974793A302E353B7D3C2F7374796C653E0D0A3C672069643D2249
          6D616765223E0D0A09093C7061746820636C6173733D22426C61636B2220643D
          224D32392C34483343322E352C342C322C342E352C322C3576323263302C302E
          352C302E352C312C312C3168323663302E352C302C312D302E352C312D315635
          4333302C342E352C32392E352C342C32392C347A204D32382C32364834563668
          32345632367A222F3E0D0A09093C636972636C6520636C6173733D2259656C6C
          6F77222063783D223231222063793D2231312220723D2233222F3E0D0A09093C
          706F6C79676F6E20636C6173733D22477265656E2220706F696E74733D223230
          2C32342031302C313420362C313820362C3234202623393B222F3E0D0A09093C
          6720636C6173733D22737431223E0D0A0909093C706F6C79676F6E20636C6173
          733D22477265656E2220706F696E74733D2232322C32342031382C3230203230
          2C31382032362C3234202623393B2623393B222F3E0D0A09093C2F673E0D0A09
          3C2F673E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E312220786D6C6E73
          3D22687474703A2F2F7777772E77332E6F72672F323030302F7376672220786D
          6C6E733A786C696E6B3D22687474703A2F2F7777772E77332E6F72672F313939
          392F786C696E6B222076696577426F783D22302030203332203332223E0D0A09
          3C7374796C6520747970653D22746578742F637373223E2E426C75657B66696C
          6C3A233131373744373B7D3C2F7374796C653E0D0A093C672069643D224D756C
          74696C696E6522207472616E73666F726D3D226D617472697828302E352C2030
          2C20302C20302E352C20322C203229223E0D0A09093C7061746820636C617373
          3D22426C75652220643D224D20312E3839382032352E3937204C2031372E3039
          322032352E3937204C2031372E3039322032352E3237204C2031372E30393220
          31372E3937204C2032372E3934352032372E3937204C2031372E303932203337
          2E3937204C2031372E3039322033302E3637204C2031372E3039322032392E39
          37204C20312E3839382032392E3937204C20312E3839382032352E3937205A22
          207374796C653D2222207472616E73666F726D3D226D6174726978282D312C20
          302C20302C202D312C2032392E3834323939362C2035352E3933393939382922
          2F3E0D0A09093C7061746820636C6173733D22426C75652220643D224D203236
          2E3035392033302E303131204C2032362E3035392034342E303131204C203235
          2E3335392034342E303131204C2031382E3035392034342E303131204C203238
          2E3035392035342E303131204C2033382E3035392034342E303131204C203330
          2E3735392034342E303131204C2033302E3035392034342E303131204C203330
          2E3035392033302E303131204C2032362E3035392033302E303131205A222F3E
          0D0A09093C7061746820636C6173733D22426C75652220643D224D2032352E39
          36372032372E353437204C2032352E3936372031332E353437204C2032352E32
          36372031332E353437204C2031372E3936372031332E353437204C2032372E39
          363720332E353437204C2033372E3936372031332E353437204C2033302E3636
          372031332E353437204C2032392E3936372031332E353437204C2032392E3936
          372032372E353437204C2032352E3936372032372E353437205A222F3E0D0A09
          093C7061746820636C6173733D22426C75652220643D224D2032382E30323920
          32362E303236204C2034332E3232332032362E303236204C2034332E32323320
          32352E333236204C2034332E3232332031382E303236204C2035342E30373620
          32382E303236204C2034332E3232332033382E303236204C2034332E32323320
          33302E373236204C2034332E3232332033302E303236204C2032382E30323920
          33302E303236204C2032382E3032392032362E303236205A222F3E0D0A093C2F
          673E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D2246
          6F6E742220786D6C6E733D22687474703A2F2F7777772E77332E6F72672F3230
          30302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F7777772E
          77332E6F72672F313939392F786C696E6B2220783D223070782220793D223070
          78222076696577426F783D2230203020333220333222207374796C653D22656E
          61626C652D6261636B67726F756E643A6E6577203020302033322033323B2220
          786D6C3A73706163653D227072657365727665223E262331333B262331303B3C
          7374796C6520747970653D22746578742F637373223E2E426C75657B66696C6C
          3A233131373744373B7D3C2F7374796C653E0D0A3C7061746820636C6173733D
          22426C75652220643D224D32312E372C32384832364C31372E332C34682D302E
          34682D332E39682D302E344C342C323868342E336C322E322D3668392E314C32
          312E372C32387A204D31312E392C31384C31352C392E346C332E312C382E3648
          31312E397A222F3E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020313820313822207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203138203138
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F637373223E2E426C61636B7B
          66696C6C3A233732373237323B7D3C2F7374796C653E0D0A3C7061746820636C
          6173733D22426C61636B2220643D224D302C3176313663302C302E362C302E34
          2C312C312C3168313663302E362C302C312D302E342C312D31563163302D302E
          362D302E342D312D312D31483143302E342C302C302C302E342C302C317A204D
          31362C3136483256326831345631367A222F3E0D0A3C706F6C79676F6E20636C
          6173733D22426C61636B2220706F696E74733D2231322C3520382C3920362C37
          20342C3920362C313120382C31332031302C31312031342C3720222F3E0D0A3C
          2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020313820313822207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203138203138
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F637373223E2E426C61636B7B
          66696C6C3A233732373237323B7D3C2F7374796C653E0D0A3C7061746820636C
          6173733D22426C61636B2220643D224D392C30222F3E0D0A3C7061746820636C
          6173733D22426C61636B2220643D224D392C3043342C302C302C342C302C3963
          302C352C342C392C392C3963352C302C392D342C392D394331382C342C31342C
          302C392C307A204D392C3136632D332E392C302D372D332E312D372D3763302D
          332E392C332E312D372C372D3720202623393B63332E392C302C372C332E312C
          372C374331362C31322E392C31322E392C31362C392C31367A222F3E0D0A3C63
          6972636C6520636C6173733D22426C61636B222063783D2239222063793D2239
          2220723D2235222F3E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F6373732220786D6C3A737061
          63653D227072657365727665223E2E426C61636B7B66696C6C3A233732373237
          323B7D262331333B262331303B2623393B2E5265647B66696C6C3A2344313143
          31433B7D262331333B262331303B2623393B2E59656C6C6F777B66696C6C3A23
          4646423131353B7D262331333B262331303B2623393B2E477265656E7B66696C
          6C3A233033394332333B7D3C2F7374796C653E0D0A3C672069643D225761726E
          696E67223E0D0A09093C7061746820636C6173733D2259656C6C6F772220643D
          224D31342E392C342E3763302E362D312C312E352D312C322E312C306C31322E
          372C32312E3563302E362C312C302E312C312E382D312C312E3848332E33632D
          312E322C302D312E362D302E382D312D312E384C31342E392C342E377A222F3E
          0D0A09093C636972636C6520636C6173733D22426C61636B222063783D223136
          222063793D2232322220723D2232222F3E0D0A09093C7265637420783D223134
          2220793D2231302220636C6173733D22426C61636B222077696474683D223422
          206865696768743D2238222F3E0D0A093C2F673E0D0A3C2F7376673E0D0A}
      end>
  end
  object ilItems: TcxImageList
    SourceDPI = 96
    FormatVersion = 1
    Left = 112
    Top = 360
    Bitmap = {
      494C010122002800040010001000FFFFFFFF2110FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000009000000001002000000000000090
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF717171FF717171FF717171FF717171FF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF0000000000000000000000000000
      000000000000000000000000000000000000000000000000000014B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF717171FF717171FF717171FF717171FF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF717171FF717171FF717171FF717171FF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF717171FF717171FF717171FF717171FF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF717171FF717171FF717171FF717171FF717171FF14B1
      FFFF000000000000000014B1FFFF00000000717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF14B1
      FFFF717171FF717171FF14B1FFFF717171FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF717171FF717171FF717171FF717171FF717171FF14B1
      FFFF000000000000000014B1FFFF00000000717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF14B1
      FFFF717171FF717171FF14B1FFFF717171FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF717171FF717171FF717171FF717171FF717171FF1AAD
      F6FF14B1FFFF14B1FFFF129FE5F200000000717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF1AAD
      F6FF14B1FFFF14B1FFFF19AEF8FF717171FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000B02020217000000010000000000000000717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7777
      77FF7E7E7EFF727272FF717171FF717171FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00001C1C1C801C1C1C801C1C1C801C1C1C801C1C1C8027272780848484B8F5F5
      F5FDCCCCCCFFCFCFCFE63131317000000001717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF888888FFD8D8D8FFF8F8
      F8FFCCCCCCFFF1F1F1FFB0B0B0FF717171FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF717171FF717171FF858585FFF4F4F4FFFFFFFFFF8F8F
      8FFF4A4A4AFFE1E1E1FFFFFFFFFF4A4A4A8A717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF858585FFF4F4F4FFFFFFFFFF8F8F
      8FFF4A4A4AFFE1E1E1FFFFFFFFFFBFBFBFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF717171FF717171FFCECECEFFFBFBFBFFF9F9F9FFDBDB
      DBFF818181FFFFFFFFFFF5F5F5FFFBFBFBFD717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FFCECECEFFFBFBFBFFF9F9F9FFDBDB
      DBFF818181FFFFFFFFFFF5F5F5FFFEFEFEFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF717171FF717171FFF0F0F0FF797979FFB8B8B8FFAFAF
      AFFF6D6D6DFFC9C9C9FF787878FFD0D0D0FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FFF0F0F0FF797979FFB8B8B8FFAFAF
      AFFF6D6D6DFFC9C9C9FF787878FFD0D0D0FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF717171FF717171FFE2E2E2FF545454FF838383FF7D7D
      7DFF595959FF8D8D8DFF595959FFA1A1A1FF717171FF717171FF717171FF7171
      71FF717171FF000000000000000000000000D6D6D6F6545454FF838383FF7D7D
      7DFF595959FF8D8D8DFF595959FFA1A1A1FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF717171FF717171FFDCDCDCFFE6E6E6FFF2F2F2FFDBDB
      DBFF818181FFFFFFFFFFD8D8D8FFFFFFFFFF717171FF717171FF717171FF7171
      71FF717171FF00000000717171FF717171FFDCDCDCFFE6E6E6FFF2F2F2FFDBDB
      DBFF818181FFFFFFFFFFD8D8D8FFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF717171FF717171FF969696FFFEFEFEFFFFFFFFFF9999
      99FF575757FFE3E3E3FFFFFFFFFF868686B9717171FF717171FF717171FF7171
      71FF717171FF00000000717171FF717171FF969696FFFEFEFEFFFFFFFFFF9999
      99FF575757FFE3E3E3FFFFFFFFFF868686B90000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF717171FF717171FF717171FFA1A1A1FFF5F5F5FFE6E6
      E6FFA4A4A4FFFFFFFFFF787878AF010101100000000000000000000000000000
      000000000000000000000000000000000000000000001C1C1C56DCDCDCEDE6E6
      E6FFA4A4A4FFFFFFFFFF787878AF010101100000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF717171FF717171FF717171FF717171FF717171FF1C1C
      1C80000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000014B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF717171FF717171FF717171FF717171FF717171FF1C1C
      1C8000000000000000000000000000000000717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF0000000000000000000000000000
      000000000000000000000000000000000000000000000000000014B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF717171FF717171FF717171FF717171FF717171FF1C1C
      1C8000000000000000000000000000000000717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF0000000000000000000000000000
      000000000000000000000000000000000000000000000000000014B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF717171FF717171FF717171FF717171FF717171FF1C1C
      1C8000000000000000000000000000000000717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF0000000000000000000000000000
      000000000000000000000000000000000000000000000000000014B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF1C1C1C801C1C1C801C1C1C801C1C
      1C801C1C1C801C1C1C801C1C1C8007070740000000001C1C1C801C1C1C801C1C
      1C801C1C1C801C1C1C801C1C1C801C1C1C800000000000000000000000000000
      0000717171FF717171FF717171FF717171FF717171FF717171FF717171FF1C1C
      1C8000000000000000000000000000000000717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF1C1C1C801C1C1C801C1C1C801C1C
      1C801C1C1C801C1C1C801C1C1C8007070740000000001C1C1C801C1C1C8014B1
      FFFF1C1C1C801C1C1C8014B1FFFF1C1C1C80717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF1C1C1C8000000000717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF0000000000000000000000000000
      0000717171FF717171FF717171FF717171FF717171FF717171FF717171FF1C1C
      1C8000000000000000000000000000000000717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF1C1C1C8000000000717171FF717171FF14B1
      FFFF717171FF717171FF14B1FFFF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF1C1C1C8000000000717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF0000000000000000000000000000
      0000717171FF717171FF717171FF717171FF717171FF717171FF717171FF1C1C
      1C8000000000000000000000000000000000717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF1C1C1C8000000000717171FF717171FF1AAD
      F6FF14B1FFFF14B1FFFF19AEF8FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF1C1C1C8000000000717171FF717171FF7777
      77FF7E7E7EFF727272FF717171FF717171FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000B02020217000000010000000000000000717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7777
      77FF7E7E7EFF727272FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF1C1C1C8000000000717171FF717171FF7777
      77FF7E7E7EFF727272FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF1C1C1C8000000000888888FFD8D8D8FFF8F8
      F8FFCCCCCCFFF1F1F1FFB0B0B0FF717171FF0000000000000000000000000000
      00001C1C1C801C1C1C801C1C1C801C1C1C801C1C1C8027272780848484B8F5F5
      F5FDCCCCCCFFCFCFCFE63131317000000001717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF888888FFD8D8D8FFF8F8
      F8FFCCCCCCFFF1F1F1FFB0B0B0FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF1C1C1C8000000000888888FFD8D8D8FFF8F8
      F8FFCCCCCCFFF1F1F1FFB0B0B0FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF1C1C1C8004040422F4F4F4FFFFFFFFFF8F8F
      8FFF4A4A4AFFE1E1E1FFFFFFFFFFBFBFBFFF0000000000000000000000000000
      0000717171FF717171FF717171FF717171FF858585FFF4F4F4FFFFFFFFFF8F8F
      8FFF4A4A4AFFE1E1E1FFFFFFFFFF4A4A4A8A717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF858585FFF4F4F4FFFFFFFFFF8F8F
      8FFF4A4A4AFFE1E1E1FFFFFFFFFFBFBFBFFF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF1C1C1C8004040422F4F4F4FFFFFFFFFF8F8F
      8FFF4A4A4AFFE1E1E1FFFFFFFFFFBFBFBFFF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF1C1C1C806C6C6CA6FBFBFBFFF9F9F9FFDBDB
      DBFF818181FFFFFFFFFFF5F5F5FFFEFEFEFF0000000000000000000000000000
      0000717171FF717171FF717171FF717171FFCECECEFFFBFBFBFFF9F9F9FFDBDB
      DBFF818181FFFFFFFFFFF5F5F5FFFBFBFBFD717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FFCECECEFFFBFBFBFFF9F9F9FFDBDB
      DBFF818181FFFFFFFFFFF5F5F5FFFEFEFEFF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF1C1C1C806C6C6CA6FBFBFBFFF9F9F9FFDBDB
      DBFF818181FFFFFFFFFFF5F5F5FFFEFEFEFF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF1C1C1C80D7D7D7ED797979FFB8B8B8FFAFAF
      AFFF6D6D6DFFC9C9C9FF787878FFD0D0D0FF0000000000000000000000000000
      0000717171FF717171FF717171FF717171FFF0F0F0FF797979FFB8B8B8FFAFAF
      AFFF6D6D6DFFC9C9C9FF787878FFD0D0D0FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FFF0F0F0FF797979FFB8B8B8FFAFAF
      AFFF6D6D6DFFC9C9C9FF787878FFD0D0D0FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF1C1C1C80D7D7D7ED797979FFB8B8B8FFAFAF
      AFFF6D6D6DFFC9C9C9FF787878FFD0D0D0FF0000000000000000000000000000
      000000000000000000000000000000000000D6D6D6F6545454FF838383FF7D7D
      7DFF595959FF8D8D8DFF595959FFA1A1A1FF0000000000000000000000000000
      0000717171FF717171FF717171FF717171FFE2E2E2FF545454FF838383FF7D7D
      7DFF595959FF8D8D8DFF595959FFA1A1A1FF717171FF717171FF717171FF7171
      71FF717171FF000000000000000000000000D6D6D6F6545454FF838383FF7D7D
      7DFF595959FF8D8D8DFF595959FFA1A1A1FF0000000000000000000000000000
      000000000000000000000000000000000000D6D6D6F6545454FF838383FF7D7D
      7DFF595959FF8D8D8DFF595959FFA1A1A1FF0000000000000000000000000000
      0000000000000000000000000000000000008F8F8FBFE6E6E6FFF2F2F2FFDBDB
      DBFF818181FFFFFFFFFFD8D8D8FFFFFFFFFF0000000000000000000000000000
      0000717171FF717171FF717171FF717171FFDCDCDCFFE6E6E6FFF2F2F2FFDBDB
      DBFF818181FFFFFFFFFFD8D8D8FFFFFFFFFF717171FF717171FF717171FF7171
      71FF717171FF00000000717171FF717171FFDCDCDCFFE6E6E6FFF2F2F2FFDBDB
      DBFF818181FFFFFFFFFFD8D8D8FFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000008F8F8FBFE6E6E6FFF2F2F2FFDBDB
      DBFF818181FFFFFFFFFFD8D8D8FFFFFFFFFF0000000000000000000000000000
      00000000000000000000000000000000000010101040FBFBFBFDFFFFFFFF9999
      99FF575757FFE3E3E3FFFFFFFFFF868686B90000000000000000000000000000
      0000717171FF717171FF717171FF717171FF969696FFFEFEFEFFFFFFFFFF9999
      99FF575757FFE3E3E3FFFFFFFFFF868686B9717171FF717171FF717171FF7171
      71FF717171FF00000000717171FF717171FF969696FFFEFEFEFFFFFFFFFF9999
      99FF575757FFE3E3E3FFFFFFFFFF868686B90000000000000000000000000000
      00000000000000000000000000000000000010101040FBFBFBFDFFFFFFFF9999
      99FF575757FFE3E3E3FFFFFFFFFF868686B90000000000000000000000000000
      000000000000000000000000000000000000000000001C1C1C56DCDCDCEDE6E6
      E6FFA4A4A4FFFFFFFFFF787878AF010101100000000000000000000000000000
      0000717171FF717171FF717171FF717171FF717171FFA1A1A1FFF5F5F5FFE6E6
      E6FFA4A4A4FFFFFFFFFF787878AF010101100000000000000000000000000000
      000000000000000000000000000000000000000000001C1C1C56DCDCDCEDE6E6
      E6FFA4A4A4FFFFFFFFFF787878AF010101100000000000000000000000000000
      000000000000000000000000000000000000000000001C1C1C56DCDCDCEDE6E6
      E6FFA4A4A4FFFFFFFFFF787878AF010101100000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000014B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF0000000000000000000000000000
      0000717171FF717171FF717171FF717171FF717171FF717171FF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF0000000000000000000000000000
      000000000000000000000000000000000000000000000000000014B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF0000000000000000000000000000
      000000000000000000000000000000000000000000000000000014B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF0000000000000000000000000000
      0000717171FF717171FF717171FF717171FF717171FF717171FF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF0000000000000000000000000000
      000000000000000000000000000000000000000000000000000014B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF0000000000000000000000000000
      0000717171FF717171FF717171FF717171FF717171FF717171FF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF0000000000000000000000000000
      000000000000000000000000000000000000000000000000000014B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF0000000000000000000000000000
      0000717171FF717171FF717171FF717171FF717171FF717171FF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF1C1C1C801C1C1C801C1C1C801C1C
      1C801C1C1C801C1C1C801C1C1C8007070740000000001C1C1C801C1C1C8014B1
      FFFF1C1C1C801C1C1C8014B1FFFF1C1C1C800000000000000000000000000000
      0000717171FF717171FF717171FF717171FF717171FF717171FF717171FF14B1
      FFFF000000000000000014B1FFFF00000000717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF14B1
      FFFF717171FF717171FF14B1FFFF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF1C1C1C8000000000717171FF717171FF14B1
      FFFF717171FF717171FF14B1FFFF717171FF0000000000000000000000000000
      0000717171FF717171FF717171FF717171FF717171FF717171FF717171FF14B1
      FFFF000000000000000014B1FFFF00000000717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF14B1
      FFFF717171FF717171FF14B1FFFF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF1C1C1C8000000000717171FF717171FF1AAD
      F6FF14B1FFFF14B1FFFF19AEF8FF717171FF0000000000000000000000000000
      0000717171FF717171FF717171FF717171FF717171FF717171FF717171FF1AAD
      F6FF14B1FFFF14B1FFFF129FE5F200000000717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF1AAD
      F6FF14B1FFFF14B1FFFF19AEF8FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF1C1C1C8000000000717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF1C1C1C8000000000717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF0000000000000000000000000000
      00001C1C1C801C1C1C801C1C1C801C1C1C801C1C1C801C1C1C801C1C1C800707
      074000000000000000000000000000000000717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF1C1C1C8000000000717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF0000000000000000000000000000
      0000717171FF717171FF717171FF717171FF717171FF717171FF717171FF1C1C
      1C8000000000000000000000000000000000717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF1C1C1C8000000000717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF0000000000000000000000000000
      0000717171FF717171FF717171FF717171FF717171FF717171FF717171FF1C1C
      1C8000000000000000000000000000000000717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF1C1C1C8000000000717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF0000000000000000000000000000
      0000717171FF717171FF717171FF717171FF717171FF717171FF717171FF1C1C
      1C8000000000000000000000000000000000717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF717171FF717171FF717171FF717171FF717171FF1C1C
      1C8000000000000000000000000000000000717171FF717171FF717171FF7171
      71FF717171FF0000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000717171FF717171FF717171FF7171
      71FF717171FF00000000717171FF717171FF717171FF717171FF717171FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF717171FF717171FF717171FF717171FF717171FF1C1C
      1C8000000000000000000000000000000000717171FF717171FF717171FF7171
      71FF717171FF00000000717171FF717171FF717171FF717171FF717171FF0000
      000000000000000000000000000000000000717171FF717171FF717171FF7171
      71FF717171FF00000000717171FF717171FF717171FF717171FF717171FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF717171FF717171FF717171FF717171FF717171FF1C1C
      1C8000000000000000000000000000000000717171FF717171FF717171FF7171
      71FF717171FF00000000717171FF717171FF717171FF717171FF717171FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF717171FF717171FF717171FF717171FF717171FF1C1C
      1C80000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF0000000000000000000000000000
      000000000000000000000000000000000000000000000000000014B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF717171FF717171FF717171FF717171FF717171FF1C1C
      1C80000000000000000000000000000000000000000000000000000000000000
      0000229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF717171FF717171FF717171FF717171FF717171FF1C1C
      1C80000000000000000000000000000000000000000000000000000000000000
      0000229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF717171FF717171FF717171FF717171FF717171FF1C1C
      1C80000000000000000000000000000000000000000000000000000000000000
      0000229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF717171FF717171FF717171FF717171FF717171FF1C1C
      1C80000000000000000000000000000000000000000000000000000000000000
      0000229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF14B1
      FFFF000000000000000014B1FFFF00000000D77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FF14B1
      FFFFD77610FFD77610FF14B1FFFFD77610FF1C1C1C801C1C1C801C1C1C801C1C
      1C801C1C1C801C1C1C801C1C1C8007070740000000001C1C1C801C1C1C801C1C
      1C801C1C1C801C1C1C801C1C1C801C1C1C800000000000000000000000000000
      0000717171FF717171FF717171FF717171FF717171FF717171FF717171FF1C1C
      1C80000000000000000000000000000000000000000000000000000000000000
      0000229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF14B1
      FFFF000000000000000014B1FFFF00000000D77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FF14B1
      FFFFD77610FFD77610FF14B1FFFFD77610FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF1C1C1C8000000000717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF0000000000000000000000000000
      0000717171FF717171FF717171FF717171FF717171FF717171FF717171FF1C1C
      1C80000000000000000000000000000000000000000000000000000000000000
      0000229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF15B0
      EFFF14B1FFFF14B1FFFF129FE5F200000000D77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FF21AD
      F0FF14B1FFFF14B1FFFF1EAEF3FFD77610FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF1C1C1C8000000000717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF0000000000000000000000000000
      0000717171FF717171FF717171FF717171FF717171FF717171FF717171FF1C1C
      1C80000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000B02020217000000010000000000000000D77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD97C
      1AFFDB8325FFD77711FFD77610FFD77610FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF1C1C1C8000000000717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000361E0480361E0480361E0480361E0480361E048039281680848484B8F5F5
      F5FDCCCCCCFFCFCFCFE63131317000000001D77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFDD8C35FFF4D9BDFFF9F8
      F7FFCCCCCCFFFBF2E8FFE9B379FFD77611FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF1C1C1C8000000000717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF0000000000000000000000000000
      00001C1C1C801C1C1C801C1C1C801C1C1C801C1C1C801C1C1C801C1C1C800707
      0740000000000000000000000000000000000000000000000000000000000000
      0000D77610FFD77610FFD77610FFD77610FFDC892FFFFCF5EDFFFFFFFFFF8F8F
      8FFF4A4A4AFFE1E1E1FFFFFFFFFF4A4A4A8AD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFDC892FFFFCF5EDFFFFFFFFFF8F8F
      8FFF4A4A4AFFE1E1E1FFFFFFFFFFEDC192FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF1C1C1C8000000000717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF0000000000000000000000000000
      0000717171FF717171FF717171FF717171FF717171FF717171FF717171FF1C1C
      1C80000000000000000000000000000000000000000000000000000000000000
      0000D77610FFD77610FFD77610FFD77610FFF1D0ACFFFBFBFBFFF9F9F9FFDBDB
      DBFF818181FFFFFFFFFFF5F5F5FFFBFBFBFDD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFF1D0ACFFFBFBFBFFF9F9F9FFDBDB
      DBFF818181FFFFFFFFFFF5F5F5FFFFFEFDFF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF1C1C1C8000000000717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF0000000000000000000000000000
      0000717171FF717171FF717171FF717171FF717171FF717171FF717171FF1C1C
      1C80000000000000000000000000000000000000000000000000000000000000
      0000D77610FFD77610FFD77610FFD77610FFF7F0E9FF797979FFB8B8B8FFAFAF
      AFFF6D6D6DFFC9C9C9FF787878FFD0D0D0FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFF7F0E9FF797979FFB8B8B8FFAFAF
      AFFF6D6D6DFFC9C9C9FF787878FFD0D0D0FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF1C1C1C8000000000717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF0000000000000000000000000000
      0000717171FF717171FF717171FF717171FF717171FF717171FF717171FF1C1C
      1C80000000000000000000000000000000000000000000000000000000000000
      0000D77610FFD77610FFD77610FFD77610FFE6E2DEFF545454FF838383FF7D7D
      7DFF595959FF8D8D8DFF595959FFA1A1A1FFD77610FFD77610FFD77610FFD776
      10FFD77610FF000000000000000000000000D6D6D6F6545454FF838383FF7D7D
      7DFF595959FF8D8D8DFF595959FFA1A1A1FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF717171FF717171FF717171FF717171FF717171FF1C1C
      1C80000000000000000000000000000000000000000000000000000000000000
      0000D77610FFD77610FFD77610FFD77610FFF5DDC3FFE6E6E6FFF2F2F2FFDBDB
      DBFF818181FFFFFFFFFFD8D8D8FFFFFFFFFFD77610FFD77610FFD77610FFD776
      10FFD77610FF00000000229C02FF229C02FFC8E6C0FFE6E6E6FFF2F2F2FFDBDB
      DBFF818181FFFFFFFFFFD8D8D8FFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF717171FF717171FF717171FF717171FF717171FF1C1C
      1C80000000000000000000000000000000000000000000000000000000000000
      0000D77610FFD77610FFD77610FFD77610FFE1994CFFFFFEFDFFFFFFFFFF9999
      99FF575757FFE3E3E3FFFFFFFFFF868686B9D77610FFD77610FFD77610FFD776
      10FFD77610FF00000000229C02FF229C02FF5AB542FFFDFEFDFFFFFFFFFF9999
      99FF575757FFE3E3E3FFFFFFFFFF868686B90000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF717171FF717171FF717171FF717171FF717171FF1C1C
      1C80000000000000000000000000000000000000000000000000000000000000
      0000D77610FFD77610FFD77610FFD77610FFD77610FFE5A560FFFCF5EEFFE6E6
      E6FFA4A4A4FFFFFFFFFF787878AF010101100000000000000000000000000000
      000000000000000000000000000000000000000000001C1C1C56DCDCDCEDE6E6
      E6FFA4A4A4FFFFFFFFFF787878AF010101100000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF717171FF717171FF717171FF717171FF717171FF1C1C
      1C80000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF0927
      0180000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000014B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF0927
      018000000000000000000000000000000000D77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF0000000000000000000000000000
      000000000000000000000000000000000000000000000000000014B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF0927
      018000000000000000000000000000000000D77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF0000000000000000000000000000
      000000000000000000000000000000000000000000000000000014B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF0927
      018000000000000000000000000000000000D77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF0000000000000000000000000000
      000000000000000000000000000000000000000000000000000014B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF0927018009270180092701800927
      01800927018009270180092701800209004000000000361E0480361E0480361E
      0480361E0480361E0480361E0480361E04800000000000000000000000000000
      0000229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF0927
      018000000000000000000000000000000000D77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF0927018009270180092701800927
      01800927018009270180092701800209004000000000361E0480361E048014B1
      FFFF361E0480361E048014B1FFFF361E0480229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF0927018000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF0000000000000000000000000000
      0000229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF0927
      018000000000000000000000000000000000D77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF0927018000000000D77610FFD77610FF14B1
      FFFFD77610FFD77610FF14B1FFFFD77610FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF0927018000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF0000000000000000000000000000
      0000229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF0927
      018000000000000000000000000000000000D77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF0927018000000000D77610FFD77610FF21AD
      F0FF14B1FFFF14B1FFFF1EAEF3FFD77610FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF0927018000000000D77610FFD77610FFD97C
      1AFFDB8325FFD77711FFD77610FFD77610FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000B02020217000000010000000000000000D77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD97C
      1AFFDB8325FFD77711FFD77610FFD77610FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF0927018000000000D77610FFD77610FFD97C
      1AFFDB8325FFD77711FFD77610FFD77610FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF0927018000000000DD8C35FFF4D9BDFFF9F8
      F7FFCCCCCCFFFBF2E8FFE9B379FFD77611FF0000000000000000000000000000
      0000361E0480361E0480361E0480361E0480361E048039281680848484B8F5F5
      F5FDCCCCCCFFCFCFCFE63131317000000001D77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFDD8C35FFF4D9BDFFF9F8
      F7FFCCCCCCFFFBF2E8FFE9B379FFD77611FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF0927018000000000DD8C35FFF4D9BDFFF9F8
      F7FFCCCCCCFFFBF2E8FFE9B379FFD77611FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF0927018004040422FCF5EDFFFFFFFFFF8F8F
      8FFF4A4A4AFFE1E1E1FFFFFFFFFFEDC192FF0000000000000000000000000000
      0000D77610FFD77610FFD77610FFD77610FFDC892FFFFCF5EDFFFFFFFFFF8F8F
      8FFF4A4A4AFFE1E1E1FFFFFFFFFF4A4A4A8AD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFDC892FFFFCF5EDFFFFFFFFFF8F8F
      8FFF4A4A4AFFE1E1E1FFFFFFFFFFEDC192FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF0927018004040422FCF5EDFFFFFFFFFF8F8F
      8FFF4A4A4AFFE1E1E1FFFFFFFFFFEDC192FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF092701806C6C6CA6FBFBFBFFF9F9F9FFDBDB
      DBFF818181FFFFFFFFFFF5F5F5FFFFFEFDFF0000000000000000000000000000
      0000D77610FFD77610FFD77610FFD77610FFF1D0ACFFFBFBFBFFF9F9F9FFDBDB
      DBFF818181FFFFFFFFFFF5F5F5FFFBFBFBFDD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFF1D0ACFFFBFBFBFFF9F9F9FFDBDB
      DBFF818181FFFFFFFFFFF5F5F5FFFFFEFDFF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF092701806C6C6CA6FBFBFBFFF9F9F9FFDBDB
      DBFF818181FFFFFFFFFFF5F5F5FFFFFEFDFF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF09270180D7D7D7ED797979FFB8B8B8FFAFAF
      AFFF6D6D6DFFC9C9C9FF787878FFD0D0D0FF0000000000000000000000000000
      0000D77610FFD77610FFD77610FFD77610FFF7F0E9FF797979FFB8B8B8FFAFAF
      AFFF6D6D6DFFC9C9C9FF787878FFD0D0D0FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFF7F0E9FF797979FFB8B8B8FFAFAF
      AFFF6D6D6DFFC9C9C9FF787878FFD0D0D0FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF09270180D7D7D7ED797979FFB8B8B8FFAFAF
      AFFF6D6D6DFFC9C9C9FF787878FFD0D0D0FF0000000000000000000000000000
      000000000000000000000000000000000000D6D6D6F6545454FF838383FF7D7D
      7DFF595959FF8D8D8DFF595959FFA1A1A1FF0000000000000000000000000000
      0000D77610FFD77610FFD77610FFD77610FFE6E2DEFF545454FF838383FF7D7D
      7DFF595959FF8D8D8DFF595959FFA1A1A1FFD77610FFD77610FFD77610FFD776
      10FFD77610FF000000000000000000000000D6D6D6F6545454FF838383FF7D7D
      7DFF595959FF8D8D8DFF595959FFA1A1A1FF0000000000000000000000000000
      000000000000000000000000000000000000D6D6D6F6545454FF838383FF7D7D
      7DFF595959FF8D8D8DFF595959FFA1A1A1FF0000000000000000000000000000
      0000000000000000000000000000000000008F8F8FBFE6E6E6FFF2F2F2FFDBDB
      DBFF818181FFFFFFFFFFD8D8D8FFFFFFFFFF0000000000000000000000000000
      0000D77610FFD77610FFD77610FFD77610FFF5DDC3FFE6E6E6FFF2F2F2FFDBDB
      DBFF818181FFFFFFFFFFD8D8D8FFFFFFFFFFD77610FFD77610FFD77610FFD776
      10FFD77610FF00000000229C02FF229C02FFC8E6C0FFE6E6E6FFF2F2F2FFDBDB
      DBFF818181FFFFFFFFFFD8D8D8FFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000008F8F8FBFE6E6E6FFF2F2F2FFDBDB
      DBFF818181FFFFFFFFFFD8D8D8FFFFFFFFFF0000000000000000000000000000
      00000000000000000000000000000000000010101040FBFBFBFDFFFFFFFF9999
      99FF575757FFE3E3E3FFFFFFFFFF868686B90000000000000000000000000000
      0000D77610FFD77610FFD77610FFD77610FFE1994CFFFFFEFDFFFFFFFFFF9999
      99FF575757FFE3E3E3FFFFFFFFFF868686B9D77610FFD77610FFD77610FFD776
      10FFD77610FF00000000229C02FF229C02FF5AB542FFFDFEFDFFFFFFFFFF9999
      99FF575757FFE3E3E3FFFFFFFFFF868686B90000000000000000000000000000
      00000000000000000000000000000000000010101040FBFBFBFDFFFFFFFF9999
      99FF575757FFE3E3E3FFFFFFFFFF868686B90000000000000000000000000000
      000000000000000000000000000000000000000000001C1C1C56DCDCDCEDE6E6
      E6FFA4A4A4FFFFFFFFFF787878AF010101100000000000000000000000000000
      0000D77610FFD77610FFD77610FFD77610FFD77610FFE5A560FFFCF5EEFFE6E6
      E6FFA4A4A4FFFFFFFFFF787878AF010101100000000000000000000000000000
      000000000000000000000000000000000000000000001C1C1C56DCDCDCEDE6E6
      E6FFA4A4A4FFFFFFFFFF787878AF010101100000000000000000000000000000
      000000000000000000000000000000000000000000001C1C1C56DCDCDCEDE6E6
      E6FFA4A4A4FFFFFFFFFF787878AF010101100000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000014B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF0000000000000000000000000000
      0000229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF0000000000000000000000000000
      000000000000000000000000000000000000000000000000000014B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF0000000000000000000000000000
      000000000000000000000000000000000000000000000000000014B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF0000000000000000000000000000
      0000229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF0000000000000000000000000000
      000000000000000000000000000000000000000000000000000014B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF0000000000000000000000000000
      0000229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF0000000000000000000000000000
      000000000000000000000000000000000000000000000000000014B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF0000000000000000000000000000
      0000229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF0927018009270180092701800927
      01800927018009270180092701800209004000000000361E0480361E048014B1
      FFFF361E0480361E048014B1FFFF361E04800000000000000000000000000000
      0000229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF14B1
      FFFF000000000000000014B1FFFF00000000D77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FF14B1
      FFFFD77610FFD77610FF14B1FFFFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF0927018000000000D77610FFD77610FF14B1
      FFFFD77610FFD77610FF14B1FFFFD77610FF0000000000000000000000000000
      0000229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF14B1
      FFFF000000000000000014B1FFFF00000000D77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FF14B1
      FFFFD77610FFD77610FF14B1FFFFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF0927018000000000D77610FFD77610FF21AD
      F0FF14B1FFFF14B1FFFF1EAEF3FFD77610FF0000000000000000000000000000
      0000229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF15B0
      EFFF14B1FFFF14B1FFFF129FE5F200000000D77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FF21AD
      F0FF14B1FFFF14B1FFFF1EAEF3FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF0927018000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF0927018000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF0000000000000000000000000000
      0000361E0480361E0480361E0480361E0480361E0480361E0480361E04800D07
      014000000000000000000000000000000000D77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF0927018000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF0000000000000000000000000000
      0000D77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FF361E
      048000000000000000000000000000000000D77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF0927018000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF0000000000000000000000000000
      0000D77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FF361E
      048000000000000000000000000000000000D77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF0927018000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF0000000000000000000000000000
      0000D77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FF361E
      048000000000000000000000000000000000D77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000D77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FF361E
      048000000000000000000000000000000000D77610FFD77610FFD77610FFD776
      10FFD77610FF0000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D77610FFD77610FFD77610FFD776
      10FFD77610FF00000000229C02FF229C02FF229C02FF229C02FF229C02FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000D77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FF361E
      048000000000000000000000000000000000D77610FFD77610FFD77610FFD776
      10FFD77610FF00000000229C02FF229C02FF229C02FF229C02FF229C02FF0000
      000000000000000000000000000000000000D77610FFD77610FFD77610FFD776
      10FFD77610FF00000000229C02FF229C02FF229C02FF229C02FF229C02FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000D77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FF361E
      048000000000000000000000000000000000D77610FFD77610FFD77610FFD776
      10FFD77610FF00000000229C02FF229C02FF229C02FF229C02FF229C02FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000D77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FF361E
      0480000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000505050D6717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF555555DD0000000000000000000000000000
      0000040404352A2A2A9C555555DD6F6F6FFC6F6F6FFD555555DE2B2B2B9E0505
      0538000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF0927
      018000000000000000000000000000000000717171FF656565F1404040BF4040
      40BF404040BF404040BF404040BF404040BF404040BF404040BF404040BF4040
      40BF404040BF404040BF636363EF717171FF00000000000000000000000B2C2C
      2C9F717171FF717171FF646464F0464646C9464646C9636363EE717171FF7171
      71FF2F2F2FA50000000D00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF0927
      018000000000000000000000000000000000717171FF454545C7000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000404040BF717171FF000000000000000A434343C57171
      71FF4C4C4CD10909094B00000003000000000000000000000003090909484949
      49CD717171FF484848CB0000000D000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF0927
      018000000000000000000000000000000000717171FF454545C7000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000404040BF717171FF000000002A2A2A9D717171FF3333
      33AC00000008000000000303032E1313136A1414146B04040431000000000000
      00062F2F2FA6717171FF2F2F2FA5000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF0927
      018000000000000000000000000000000000717171FF454545C7000000000000
      000000000000000000000101011A0505053B0000000000000000000000000000
      00000000000000000000404040BF717171FF04040432717171FE4E4E4ED30000
      00080000000A313131A8717171FF717171FF717171FF717171FF353535AE0000
      000C00000006494949CD717171FF050505390927018009270180092701800927
      01800927018009270180092701800209004000000000361E0480361E0480361E
      0480361E0480361E0480361E0480361E04800000000000000000000000000000
      0000229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF0927
      018000000000000000000000000000000000717171FF454545C7000000000000
      0000000000000101011A525252D9676767F40606063F00000000000000000000
      00000000000000000000404040BF717171FF27272796717171FF0B0B0B500000
      00002F2F2FA6717171FF717171FF717171FF717171FF717171FF717171FF3535
      35AE0000000009090948717171FF2B2B2B9E229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF0927018000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF0000000000000000000000000000
      0000229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF0927
      018000000000000000000000000000000000717171FF454545C7000000000000
      00000101011A525252D9717171FF717171FF676767F40606063F000000000000
      00000000000000000000404040BF717171FF505050D6676767F4000000050202
      0229717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF0404043100000003626262EE555555DE229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF0927018000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF0000000000000000000000000000
      0000229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF0927
      018000000000000000000000000000000000717171FF454545C7000000000101
      011A525252D9717171FF717171FF717171FF717171FF676767F40606063F0000
      00000000000000000000404040BF717171FF686868F54C4C4CD1000000001111
      1163717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF1414146C00000000464646C96F6F6FFD229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF0927018000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000717171FF454545C7000000000000
      00174E4E4ED4717171FF2929299A101010606F6F6FFD717171FF676767F40606
      063F0000000000000000404040BF717171FF676767F44D4D4DD2000000001010
      1062717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF1414146B00000000464646C96F6F6FFC229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF0927018000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF0000000000000000000000000000
      0000361E0480361E0480361E0480361E0480361E0480361E0480361E04800D07
      014000000000000000000000000000000000717171FF454545C7000000000000
      0000000000171B1B1B7D00000002000000000F0F0F5E6F6F6FFD717171FF6767
      67F40404043100000000404040BF717171FF4F4F4FD5686868F5000000060202
      0227717171FE717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF0303032E00000003646464F0555555DD229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF0927018000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF0000000000000000000000000000
      0000D77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FF361E
      048000000000000000000000000000000000717171FF454545C7000000000000
      000000000000000000000000000000000000000000000F0F0F5E6F6F6FFD3838
      38B40000000700000000404040BF717171FF26262694717171FF0B0B0B530000
      00002D2D2DA0717171FF717171FF717171FF717171FF717171FF717171FF3131
      31A8000000000909094B717171FF2A2A2A9B229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF0927018000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF0000000000000000000000000000
      0000D77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FF361E
      048000000000000000000000000000000000717171FF454545C7000000000000
      0000000000000000000000000000000000000000000000000000080808450000
      00070000000000000000404040BF717171FF0303032E707070FE505050D70000
      000A000000082D2D2DA0717171FE717171FF717171FF717171FF2F2F2FA60000
      000A000000084C4C4CD1717171FF04040435229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF0927018000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF0000000000000000000000000000
      0000D77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FF361E
      048000000000000000000000000000000000717171FF454545C7000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000404040BF717171FF0000000028282897717171FF3737
      37B30000000A0000000002020226101010621111116302020229000000000000
      0008333333AC717171FF2C2C2C9F000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000D77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FF361E
      048000000000000000000000000000000000717171FF454545C7000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000404040BF717171FF0000000000000008404040BF7171
      71FF505050D70B0B0B53000000060000000000000000000000050B0B0B4F4E4E
      4ED3717171FF434343C50000000B000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000D77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FF361E
      048000000000000000000000000000000000717171FF676767F3454545C74545
      45C7454545C7454545C7454545C7454545C7454545C7454545C7454545C74545
      45C7454545C7454545C7656565F1717171FF0000000000000000000000082828
      2897707070FE717171FF686868F54D4D4DD24C4C4CD1676767F4717171FF7171
      71FE2A2A2A9D0000000A00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000D77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FF361E
      0480000000000000000000000000000000004B4B4BCF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF505050D60000000000000000000000000000
      00000303032E262626944F4F4FD5676767F4686868F5505050D7272727960404
      0431000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000D77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FF361E
      0480000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000009090966090909660000
      0000090909660909096600000000090909660909096600000000090909660909
      0966000000000909096609090966000000000000000009090966090909660000
      0000090909660909096600000000090909660909096600000000090909660909
      0966000000000909096609090966000000000000000009090966090909660000
      0000090909660909096600000000090909660909096600000000090909660909
      0966000000000909096609090966000000000000000009090966090909660000
      0000090909660909096600000000090909660909096600000000090909660909
      0966000000000909096609090966000000000000000009090966000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000009090966000000000000000009090966000000000000
      00000000000000000000000000003E3E3EFF3E3E3EFF00000000000000000000
      0000000000000000000009090966000000000000000009090966000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000009090966000000000000000009090966000000000000
      00000000000000000000000000003E3E3EFF3E3E3EFF00000000000000000000
      0000000000000000000009090966000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000003E3E3EFF3E3E3EFF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000111111841111118400000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000003E3E3EFF3E3E3EFF00000000000000000000
      0000000000000000000000000000000000000000000009090966000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000009090966000000000000000009090966000000000000
      00000000000000000000000000003E3E3EFF3E3E3EFF00000000000000000000
      0000000000000000000009090966000000000000000009090966000000000000
      00000000000000000000111111843E3E3EFF3E3E3EFF11111184000000000000
      0000000000000000000009090966000000000000000009090966000000000000
      00000000000000000000000000003E3E3EFF3E3E3EFF00000000000000000000
      0000000000000000000009090966000000000000000009090966000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000009090966000000000000000009090966000000000000
      00000000000000000000000000003E3E3EFF3E3E3EFF00000000000000000000
      0000000000000000000009090966000000000000000009090966000000000000
      00000000000000000000000000003E3E3EFF3E3E3EFF00000000000000000000
      0000000000000000000009090966000000000000000009090966000000000000
      00000000000000000000000000003E3E3EFF3E3E3EFF00000000000000000000
      0000000000000000000009090966000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000003E3E3EFF3E3E3EFF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00001111118400000000000000003E3E3EFF3E3E3EFF00000000000000001111
      11840000000000000000000000000000000000000000090909663E3E3EFF3E3E
      3EFF3E3E3EFF3E3E3EFF3E3E3EFF3E3E3EFF3E3E3EFF3E3E3EFF3E3E3EFF3E3E
      3EFF3E3E3EFF3E3E3EFF09090966000000000000000009090966000000000000
      00000000000000000000000000003E3E3EFF3E3E3EFF00000000000000000000
      00000000000000000000090909660000000000000000090909663E3E3EFF3E3E
      3EFF3E3E3EFF3E3E3EFF3E3E3EFF3E3E3EFF3E3E3EFF3E3E3EFF3E3E3EFF3E3E
      3EFF3E3E3EFF3E3E3EFF09090966000000000000000009090966000000001111
      11843E3E3EFF3E3E3EFF000000003E3E3EFF3E3E3EFF000000003E3E3EFF3E3E
      3EFF1111118400000000090909660000000000000000090909663E3E3EFF3E3E
      3EFF3E3E3EFF3E3E3EFF3E3E3EFF3E3E3EFF3E3E3EFF3E3E3EFF3E3E3EFF3E3E
      3EFF3E3E3EFF3E3E3EFF09090966000000000000000009090966000000000000
      00000000000000000000000000003E3E3EFF3E3E3EFF00000000000000000000
      00000000000000000000090909660000000000000000090909663E3E3EFF3E3E
      3EFF3E3E3EFF3E3E3EFF3E3E3EFF3E3E3EFF3E3E3EFF3E3E3EFF3E3E3EFF3E3E
      3EFF3E3E3EFF3E3E3EFF09090966000000000000000009090966000000000F0F
      0F7C3E3E3EFF3E3E3EFF000000003E3E3EFF3E3E3EFF000000003E3E3EFF3E3E
      3EFF0F0F0F7C0000000009090966000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000003E3E3EFF3E3E3EFF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000F0F0F7C00000000000000003E3E3EFF3E3E3EFF00000000000000000F0F
      0F7C000000000000000000000000000000000000000009090966000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000009090966000000000000000009090966000000000000
      00000000000000000000000000003E3E3EFF3E3E3EFF00000000000000000000
      0000000000000000000009090966000000000000000009090966000000000000
      00000000000000000000000000003E3E3EFF3E3E3EFF00000000000000000000
      0000000000000000000009090966000000000000000009090966000000000000
      00000000000000000000000000003E3E3EFF3E3E3EFF00000000000000000000
      0000000000000000000009090966000000000000000009090966000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000009090966000000000000000009090966000000000000
      00000000000000000000000000003E3E3EFF3E3E3EFF00000000000000000000
      0000000000000000000009090966000000000000000009090966000000000000
      000000000000000000000F0F0F7C3E3E3EFF3E3E3EFF0F0F0F7C000000000000
      0000000000000000000009090966000000000000000009090966000000000000
      00000000000000000000000000003E3E3EFF3E3E3EFF00000000000000000000
      0000000000000000000009090966000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000003E3E3EFF3E3E3EFF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000F0F0F7C0F0F0F7C00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000003E3E3EFF3E3E3EFF00000000000000000000
      0000000000000000000000000000000000000000000009090966000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000009090966000000000000000009090966000000000000
      00000000000000000000000000003E3E3EFF3E3E3EFF00000000000000000000
      0000000000000000000009090966000000000000000009090966000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000009090966000000000000000009090966000000000000
      00000000000000000000000000003E3E3EFF3E3E3EFF00000000000000000000
      0000000000000000000009090966000000000000000009090966090909660000
      0000090909660909096600000000090909660909096600000000090909660909
      0966000000000909096609090966000000000000000009090966090909660000
      0000090909660909096600000000090909660909096600000000090909660909
      0966000000000909096609090966000000000000000009090966090909660000
      0000090909660909096600000000090909660909096600000000090909660909
      0966000000000909096609090966000000000000000009090966090909660000
      0000090909660909096600000000090909660909096600000000090909660909
      0966000000000909096609090966000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FF00000000101010803E3E3EFF3E3E3EFF0000
      00003E3E3EFF3E3E3EFF000000003E3E3EFF3E3E3EFF000000003E3E3EFF3E3E
      3EFF000000003E3E3EFF3E3E3EFF101010800000000000000000894B0BCCD776
      10FF1B0E025B0000000000000000000000000000000000000000140B0150D776
      10FF93510BD300000000000000000000000000000000636363EF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF666666F20000000000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FF000000001010108010101080000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000001010108010101080000000000000000029170371D776
      10FF703D08B800000000000000000000000000000000000000005F3407A9D776
      10FF2E19037700000000000000000000000000000000717171FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000717171FF0000000000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FF000000000404044004040440000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000404044004040440000000000000000001010018D174
      10FCD27410FC0201001A0000000000000000000000000000000DC76E0FF6D374
      10FD0201001D00000000000000000000000000000000717171FF00000000229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF0824007C020A00420826
      007F0109003E00000000717171FF0000000000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FF000000000404044004040440000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000404044004040440000000000000000000000000713E
      08B9D77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FF7640
      09BD0000000000000000000000000000000000000000717171FF00000000229C
      02FF229C02FF229C02FF229C02FF229C02FF0824007C020A00420826007F0109
      003E0000000000000000717171FF0000000000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FF000000001010108010101080000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000010101080101010800000000000000000000000001D10
      025ED77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FF1E11
      02610000000000000000000000000000000000000000717171FF00000000229C
      02FF229C02FF229C02FF229C02FF0824007C000000000109003E0109003E0000
      00000000000000000000717171FF0000000000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FF000000000404044004040440000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000004040440040404400000000000000000000000000000
      000CC66D0FF5D77610FF050200270000000003010020D57510FEC76E0FF60000
      000E0000000000000000000000000000000000000000717171FF000000000824
      007C229C02FF229C02FF0824007C000000000000000000000000000000000000
      00000000000000000000717171FF0000000000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FF000000000404044004040440000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000004040440040404400000000000000000000000000000
      00005A3107A5D77610FF381F048300000000311B037BD77610FF5C3207A60000
      00000000000000000000000000000000000000000000717171FF000000000000
      00000824007C0824007C00000000000000000000000000000000000000000000
      00000000000000000000717171FF0000000000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FF000000001010108010101080000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000010101080101010800000000000000000000000000000
      0000120A014BD77610FFA3590DDE0000000198530BD6D77610FF120A014B0000
      00000000000000000000000000000000000000000000717171FF000000000000
      0000000000000000000000000000000000000000000005334A8A14ABF7FB0639
      53920000000000000000717171FF0000000000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FF000000000404044004040440000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000004040440040404400000000000000000000000000000
      000000000005B4630DE9D77610FF2816036FD77610FFB3630DE9000000040000
      00000000000000000000000000000000000000000000717171FF000000000000
      0000000000000000000000000000000000000000000012A0E7F314B1FFFF14AB
      F7FB0000000000000000717171FF0000000000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FF000000000404044004040440000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000004040440040404400000000000000000000000000000
      00000000000046260592D77610FFC96E0FF7D77610FF44250590000000000000
      00000000000000000000000000000000000000000000717171FF000000000000
      00000000000000000000000000000000000000000000052E438312A0E7F30533
      4A8A0000000000000000717171FF0000000000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FF000000001010108010101080000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000010101080101010800000000000000000000000000000
      00000000000009050037D77610FFD77610FFD77610FF08040034000000000000
      00000000000000000000000000000000000000000000717171FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000717171FF0000000000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FF00000000101010803E3E3EFF3E3E3EFF0000
      00003E3E3EFF3E3E3EFF000000003E3E3EFF3E3E3EFF000000003E3E3EFF3E3E
      3EFF000000003E3E3EFF3E3E3EFF101010800000000000000000000000000000
      000000000000000000019D560BDAD77610FF98530BD600000000000000000000
      00000000000000000000000000000000000000000000606060EB717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF636363EE0000000000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000900000000100010000000000800400000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000}
    DesignInfo = 23593072
    ImageInfo = <
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D222D34363320323635203332203332222073
          74796C653D22656E61626C652D6261636B67726F756E643A6E6577202D343633
          203236352033322033323B2220786D6C3A73706163653D227072657365727665
          223E262331333B262331303B3C7374796C6520747970653D22746578742F6373
          73223E2E426C75657B66696C6C3A233131373744373B7D3C2F7374796C653E0D
          0A3C7265637420783D222D3436312220793D223236372220636C6173733D2242
          6C7565222077696474683D22323822206865696768743D223238222F3E0D0A3C
          2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D222D34363320323635203332203332222073
          74796C653D22656E61626C652D6261636B67726F756E643A6E6577202D343633
          203236352033322033323B2220786D6C3A73706163653D227072657365727665
          223E262331333B262331303B3C7374796C6520747970653D22746578742F6373
          73223E2E426C61636B7B66696C6C3A233346334633463B7D3C2F7374796C653E
          0D0A3C7265637420783D222D3434332220793D223236392220636C6173733D22
          426C61636B222077696474683D223422206865696768743D2232222F3E0D0A3C
          706F6C79676F6E20636C6173733D22426C61636B2220706F696E74733D222D34
          33372C323639202D3433372C323731202D3433342C323731202D3433342C3237
          34202D3433322C323734202D3433322C32363920222F3E0D0A3C726563742078
          3D222D3435352220793D223236392220636C6173733D22426C61636B22207769
          6474683D223422206865696768743D2232222F3E0D0A3C706F6C79676F6E2063
          6C6173733D22426C61636B2220706F696E74733D222D3436302C323731202D34
          35372C323731202D3435372C323639202D3436322C323639202D3436322C3237
          34202D3436302C32373420222F3E0D0A3C7265637420783D222D343632222079
          3D223238322220636C6173733D22426C61636B222077696474683D2232222068
          65696768743D2234222F3E0D0A3C7265637420783D222D3434392220793D2232
          36392220636C6173733D22426C61636B222077696474683D2234222068656967
          68743D2232222F3E0D0A3C706F6C79676F6E20636C6173733D22426C61636B22
          20706F696E74733D222D3436302C323838202D3436322C323838202D3436322C
          323933202D3435372C323933202D3435372C323931202D3436302C3239312022
          2F3E0D0A3C7265637420783D222D3436322220793D223237362220636C617373
          3D22426C61636B222077696474683D223222206865696768743D2234222F3E0D
          0A3C706F6C79676F6E20636C6173733D22426C61636B2220706F696E74733D22
          2D3433372C323931202D3433372C323933202D3433322C323933202D3433322C
          323838202D3433342C323838202D3433342C32393120222F3E0D0A3C72656374
          20783D222D3433342220793D223238322220636C6173733D22426C61636B2220
          77696474683D223222206865696768743D2234222F3E0D0A3C7265637420783D
          222D3433342220793D223237362220636C6173733D22426C61636B2220776964
          74683D223222206865696768743D2234222F3E0D0A3C7265637420783D222D34
          34332220793D223239312220636C6173733D22426C61636B222077696474683D
          223422206865696768743D2232222F3E0D0A3C7265637420783D222D34353522
          20793D223239312220636C6173733D22426C61636B222077696474683D223422
          206865696768743D2232222F3E0D0A3C706F6C79676F6E20636C6173733D2242
          6C61636B2220706F696E74733D222D3434392C323931202D3434352C32393120
          2D3434352C323933202D3434392C32393320222F3E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D2246
          6F6E742220786D6C6E733D22687474703A2F2F7777772E77332E6F72672F3230
          30302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F7777772E
          77332E6F72672F313939392F786C696E6B2220783D223070782220793D223070
          78222076696577426F783D2230203020333220333222207374796C653D22656E
          61626C652D6261636B67726F756E643A6E6577203020302033322033323B2220
          786D6C3A73706163653D227072657365727665223E262331333B262331303B3C
          7374796C6520747970653D22746578742F637373223E2E426C75657B66696C6C
          3A233131373744373B7D3C2F7374796C653E0D0A3C7061746820636C6173733D
          22426C75652220643D224D32312E372C32384832364C31372E332C34682D302E
          34682D332E39682D302E344C342C323868342E336C322E322D3668392E314C32
          312E372C32387A204D31312E392C31384C31352C392E346C332E312C382E3648
          31312E397A222F3E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F6373732220786D6C3A737061
          63653D227072657365727665223E2E426C75657B66696C6C3A23313137374437
          3B7D262331333B262331303B2623393B2E59656C6C6F777B66696C6C3A234646
          423131353B7D262331333B262331303B2623393B2E426C61636B7B66696C6C3A
          233732373237323B7D262331333B262331303B2623393B2E477265656E7B6669
          6C6C3A233033394332333B7D262331333B262331303B2623393B2E5265647B66
          696C6C3A234431314331433B7D262331333B262331303B2623393B2E7374307B
          6F7061636974793A302E37353B7D262331333B262331303B2623393B2E737431
          7B6F7061636974793A302E353B7D3C2F7374796C653E0D0A3C672069643D2249
          6D616765223E0D0A09093C7061746820636C6173733D22426C61636B2220643D
          224D32392C34483343322E352C342C322C342E352C322C3576323263302C302E
          352C302E352C312C312C3168323663302E352C302C312D302E352C312D315635
          4333302C342E352C32392E352C342C32392C347A204D32382C32364834563668
          32345632367A222F3E0D0A09093C636972636C6520636C6173733D2259656C6C
          6F77222063783D223231222063793D2231312220723D2233222F3E0D0A09093C
          706F6C79676F6E20636C6173733D22477265656E2220706F696E74733D223230
          2C32342031302C313420362C313820362C3234202623393B222F3E0D0A09093C
          6720636C6173733D22737431223E0D0A0909093C706F6C79676F6E20636C6173
          733D22477265656E2220706F696E74733D2232322C32342031382C3230203230
          2C31382032362C3234202623393B2623393B222F3E0D0A09093C2F673E0D0A09
          3C2F673E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D222D34363320323635203332203332222073
          74796C653D22656E61626C652D6261636B67726F756E643A6E6577202D343633
          203236352033322033323B2220786D6C3A73706163653D227072657365727665
          223E262331333B262331303B3C7374796C6520747970653D22746578742F6373
          732220786D6C3A73706163653D227072657365727665223E2E426C61636B7B66
          696C6C3A233346334633463B7D262331333B262331303B2623393B2E7374307B
          6F7061636974793A302E343B7D3C2F7374796C653E0D0A3C6720636C6173733D
          22737430223E0D0A09093C7265637420783D222D3434332220793D2232363722
          20636C6173733D22426C61636B222077696474683D223422206865696768743D
          2232222F3E0D0A09093C706F6C79676F6E20636C6173733D22426C61636B2220
          706F696E74733D222D3433372C323637202D3433372C323639202D3433352C32
          3639202D3433352C323731202D3433332C323731202D3433332C323637202623
          393B222F3E0D0A09093C7265637420783D222D3435352220793D223236372220
          636C6173733D22426C61636B222077696474683D223422206865696768743D22
          32222F3E0D0A09093C7265637420783D222D3433352220793D22323733222063
          6C6173733D22426C61636B222077696474683D223222206865696768743D2234
          222F3E0D0A09093C706F6C79676F6E20636C6173733D22426C61636B2220706F
          696E74733D222D3435392C323639202D3435372C323639202D3435372C323637
          202D3436312C323637202D3436312C323731202D3435392C323731202623393B
          222F3E0D0A09093C7265637420783D222D3434332220793D223239332220636C
          6173733D22426C61636B222077696474683D223422206865696768743D223222
          2F3E0D0A09093C7265637420783D222D3436312220793D223238352220636C61
          73733D22426C61636B222077696474683D223222206865696768743D2234222F
          3E0D0A09093C706F6C79676F6E20636C6173733D22426C61636B2220706F696E
          74733D222D3433352C323933202D3433372C323933202D3433372C323935202D
          3433332C323935202D3433332C323931202D3433352C323931202623393B222F
          3E0D0A09093C7265637420783D222D3433352220793D223237392220636C6173
          733D22426C61636B222077696474683D223222206865696768743D2234222F3E
          0D0A09093C7265637420783D222D3435352220793D223239332220636C617373
          3D22426C61636B222077696474683D223422206865696768743D2232222F3E0D
          0A09093C7265637420783D222D3434392220793D223236372220636C6173733D
          22426C61636B222077696474683D223422206865696768743D2232222F3E0D0A
          09093C7265637420783D222D3436312220793D223237392220636C6173733D22
          426C61636B222077696474683D223222206865696768743D2234222F3E0D0A09
          093C706F6C79676F6E20636C6173733D22426C61636B2220706F696E74733D22
          2D3435392C323931202D3436312C323931202D3436312C323935202D3435372C
          323935202D3435372C323933202D3435392C323933202623393B222F3E0D0A09
          093C7265637420783D222D3436312220793D223237332220636C6173733D2242
          6C61636B222077696474683D223222206865696768743D2234222F3E0D0A0909
          3C7265637420783D222D3434392220793D223239332220636C6173733D22426C
          61636B222077696474683D223422206865696768743D2232222F3E0D0A09093C
          7265637420783D222D3433352220793D223238352220636C6173733D22426C61
          636B222077696474683D223222206865696768743D2234222F3E0D0A093C2F67
          3E0D0A3C7265637420783D222D3435392220793D223237392220636C6173733D
          22426C61636B222077696474683D22323422206865696768743D2234222F3E0D
          0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D222D34363320323635203332203332222073
          74796C653D22656E61626C652D6261636B67726F756E643A6E6577202D343633
          203236352033322033323B2220786D6C3A73706163653D227072657365727665
          223E262331333B262331303B3C7374796C6520747970653D22746578742F6373
          732220786D6C3A73706163653D227072657365727665223E2E426C61636B7B66
          696C6C3A233346334633463B7D262331333B262331303B2623393B2E7374307B
          6F7061636974793A302E343B7D3C2F7374796C653E0D0A3C6720636C6173733D
          22737430223E0D0A09093C7265637420783D222D3434332220793D2232363722
          20636C6173733D22426C61636B222077696474683D223422206865696768743D
          2232222F3E0D0A09093C706F6C79676F6E20636C6173733D22426C61636B2220
          706F696E74733D222D3433372C323637202D3433372C323639202D3433352C32
          3639202D3433352C323731202D3433332C323731202D3433332C323637202623
          393B222F3E0D0A09093C7265637420783D222D3435352220793D223236372220
          636C6173733D22426C61636B222077696474683D223422206865696768743D22
          32222F3E0D0A09093C7265637420783D222D3433352220793D22323733222063
          6C6173733D22426C61636B222077696474683D223222206865696768743D2234
          222F3E0D0A09093C706F6C79676F6E20636C6173733D22426C61636B2220706F
          696E74733D222D3435392C323639202D3435372C323639202D3435372C323637
          202D3436312C323637202D3436312C323731202D3435392C323731202623393B
          222F3E0D0A09093C7265637420783D222D3434332220793D223239332220636C
          6173733D22426C61636B222077696474683D223422206865696768743D223222
          2F3E0D0A09093C7265637420783D222D3436312220793D223238352220636C61
          73733D22426C61636B222077696474683D223222206865696768743D2234222F
          3E0D0A09093C706F6C79676F6E20636C6173733D22426C61636B2220706F696E
          74733D222D3433352C323933202D3433372C323933202D3433372C323935202D
          3433332C323935202D3433332C323931202D3433352C323931202623393B222F
          3E0D0A09093C7265637420783D222D3433352220793D223237392220636C6173
          733D22426C61636B222077696474683D223222206865696768743D2234222F3E
          0D0A09093C7265637420783D222D3435352220793D223239332220636C617373
          3D22426C61636B222077696474683D223422206865696768743D2232222F3E0D
          0A09093C7265637420783D222D3434392220793D223236372220636C6173733D
          22426C61636B222077696474683D223422206865696768743D2232222F3E0D0A
          09093C7265637420783D222D3436312220793D223237392220636C6173733D22
          426C61636B222077696474683D223222206865696768743D2234222F3E0D0A09
          093C706F6C79676F6E20636C6173733D22426C61636B2220706F696E74733D22
          2D3435392C323931202D3436312C323931202D3436312C323935202D3435372C
          323935202D3435372C323933202D3435392C323933202623393B222F3E0D0A09
          093C7265637420783D222D3436312220793D223237332220636C6173733D2242
          6C61636B222077696474683D223222206865696768743D2234222F3E0D0A0909
          3C7265637420783D222D3434392220793D223239332220636C6173733D22426C
          61636B222077696474683D223422206865696768743D2232222F3E0D0A09093C
          7265637420783D222D3433352220793D223238352220636C6173733D22426C61
          636B222077696474683D223222206865696768743D2234222F3E0D0A093C2F67
          3E0D0A3C7265637420783D222D3435392220793D223237392220636C6173733D
          22426C61636B222077696474683D22323422206865696768743D223422207472
          616E73666F726D3D226D617472697828302C20312C202D312C20302C202D3136
          362C2037323829222F3E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D222D34363320323635203332203332222073
          74796C653D22656E61626C652D6261636B67726F756E643A6E6577202D343633
          203236352033322033323B2220786D6C3A73706163653D227072657365727665
          223E262331333B262331303B3C7374796C6520747970653D22746578742F6373
          732220786D6C3A73706163653D227072657365727665223E2E426C61636B7B66
          696C6C3A233346334633463B7D262331333B262331303B2623393B2E7374307B
          6F7061636974793A302E343B7D3C2F7374796C653E0D0A3C6720636C6173733D
          2273743022207472616E73666F726D3D226D617472697828302C20312C202D31
          2C20302C202D3136362C2037323829223E0D0A09093C7265637420783D222D34
          34332220793D223236372220636C6173733D22426C61636B222077696474683D
          223422206865696768743D2232222F3E0D0A09093C706F6C79676F6E20636C61
          73733D22426C61636B2220706F696E74733D222D3433372C323637202D343337
          2C323639202D3433352C323639202D3433352C323731202D3433332C32373120
          2D3433332C323637202623393B222F3E0D0A09093C7265637420783D222D3435
          352220793D223236372220636C6173733D22426C61636B222077696474683D22
          3422206865696768743D2232222F3E0D0A09093C7265637420783D222D343335
          2220793D223237332220636C6173733D22426C61636B222077696474683D2232
          22206865696768743D2234222F3E0D0A09093C706F6C79676F6E20636C617373
          3D22426C61636B2220706F696E74733D222D3435392C323639202D3435372C32
          3639202D3435372C323637202D3436312C323637202D3436312C323731202D34
          35392C323731202623393B222F3E0D0A09093C7265637420783D222D34343322
          20793D223239332220636C6173733D22426C61636B222077696474683D223422
          206865696768743D2232222F3E0D0A09093C7265637420783D222D3436312220
          793D223238352220636C6173733D22426C61636B222077696474683D22322220
          6865696768743D2234222F3E0D0A09093C706F6C79676F6E20636C6173733D22
          426C61636B2220706F696E74733D222D3433352C323933202D3433372C323933
          202D3433372C323935202D3433332C323935202D3433332C323931202D343335
          2C323931202623393B222F3E0D0A09093C7265637420783D222D343335222079
          3D223237392220636C6173733D22426C61636B222077696474683D2232222068
          65696768743D2234222F3E0D0A09093C7265637420783D222D3435352220793D
          223239332220636C6173733D22426C61636B222077696474683D223422206865
          696768743D2232222F3E0D0A09093C7265637420783D222D3434392220793D22
          3236372220636C6173733D22426C61636B222077696474683D22342220686569
          6768743D2232222F3E0D0A09093C7265637420783D222D3436312220793D2232
          37392220636C6173733D22426C61636B222077696474683D2232222068656967
          68743D2234222F3E0D0A09093C706F6C79676F6E20636C6173733D22426C6163
          6B2220706F696E74733D222D3435392C323931202D3436312C323931202D3436
          312C323935202D3435372C323935202D3435372C323933202D3435392C323933
          202623393B222F3E0D0A09093C7265637420783D222D3436312220793D223237
          332220636C6173733D22426C61636B222077696474683D223222206865696768
          743D2234222F3E0D0A09093C7265637420783D222D3434392220793D22323933
          2220636C6173733D22426C61636B222077696474683D22342220686569676874
          3D2232222F3E0D0A09093C7265637420783D222D3433352220793D2232383522
          20636C6173733D22426C61636B222077696474683D223222206865696768743D
          2234222F3E0D0A093C2F673E0D0A3C7265637420783D222D3434392220793D22
          3236392220636C6173733D22426C61636B222077696474683D22342220686569
          6768743D22323422207472616E73666F726D3D226D617472697828302C20312C
          202D312C20302C202D3136362C2037323829222F3E0D0A3C706F6C79676F6E20
          636C6173733D22426C61636B2220706F696E74733D222D34343620323732202D
          34343620323730202D34353020323734202D34343620323738202D3434362032
          3736202D34343420323736202D3434342032373222207472616E73666F726D3D
          226D617472697828302C20312C202D312C20302C202D3137332C203732312922
          2F3E0D0A3C706F6C79676F6E20636C6173733D22426C61636B2220706F696E74
          733D222D34343820323836202D34343820323834202D34343420323838202D34
          343820323932202D34343820323930202D34353020323930202D343530203238
          3622207472616E73666F726D3D226D617472697828302C20312C202D312C2030
          2C202D3135392C2037333529222F3E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D222D34363320323635203332203332222073
          74796C653D22656E61626C652D6261636B67726F756E643A6E6577202D343633
          203236352033322033323B2220786D6C3A73706163653D227072657365727665
          223E262331333B262331303B3C7374796C6520747970653D22746578742F6373
          732220786D6C3A73706163653D227072657365727665223E2E426C61636B7B66
          696C6C3A233346334633463B7D262331333B262331303B2623393B2E7374307B
          6F7061636974793A302E343B7D3C2F7374796C653E0D0A3C6720636C6173733D
          22737430223E0D0A09093C7265637420783D222D3434332220793D2232363722
          20636C6173733D22426C61636B222077696474683D223422206865696768743D
          2232222F3E0D0A09093C706F6C79676F6E20636C6173733D22426C61636B2220
          706F696E74733D222D3433372C323637202D3433372C323639202D3433352C32
          3639202D3433352C323731202D3433332C323731202D3433332C323637202623
          393B222F3E0D0A09093C7265637420783D222D3435352220793D223236372220
          636C6173733D22426C61636B222077696474683D223422206865696768743D22
          32222F3E0D0A09093C7265637420783D222D3433352220793D22323733222063
          6C6173733D22426C61636B222077696474683D223222206865696768743D2234
          222F3E0D0A09093C706F6C79676F6E20636C6173733D22426C61636B2220706F
          696E74733D222D3435392C323639202D3435372C323639202D3435372C323637
          202D3436312C323637202D3436312C323731202D3435392C323731202623393B
          222F3E0D0A09093C7265637420783D222D3434332220793D223239332220636C
          6173733D22426C61636B222077696474683D223422206865696768743D223222
          2F3E0D0A09093C7265637420783D222D3436312220793D223238352220636C61
          73733D22426C61636B222077696474683D223222206865696768743D2234222F
          3E0D0A09093C706F6C79676F6E20636C6173733D22426C61636B2220706F696E
          74733D222D3433352C323933202D3433372C323933202D3433372C323935202D
          3433332C323935202D3433332C323931202D3433352C323931202623393B222F
          3E0D0A09093C7265637420783D222D3433352220793D223237392220636C6173
          733D22426C61636B222077696474683D223222206865696768743D2234222F3E
          0D0A09093C7265637420783D222D3435352220793D223239332220636C617373
          3D22426C61636B222077696474683D223422206865696768743D2232222F3E0D
          0A09093C7265637420783D222D3434392220793D223236372220636C6173733D
          22426C61636B222077696474683D223422206865696768743D2232222F3E0D0A
          09093C7265637420783D222D3436312220793D223237392220636C6173733D22
          426C61636B222077696474683D223222206865696768743D2234222F3E0D0A09
          093C706F6C79676F6E20636C6173733D22426C61636B2220706F696E74733D22
          2D3435392C323931202D3436312C323931202D3436312C323935202D3435372C
          323935202D3435372C323933202D3435392C323933202623393B222F3E0D0A09
          093C7265637420783D222D3436312220793D223237332220636C6173733D2242
          6C61636B222077696474683D223222206865696768743D2234222F3E0D0A0909
          3C7265637420783D222D3434392220793D223239332220636C6173733D22426C
          61636B222077696474683D223422206865696768743D2232222F3E0D0A09093C
          7265637420783D222D3433352220793D223238352220636C6173733D22426C61
          636B222077696474683D223222206865696768743D2234222F3E0D0A093C2F67
          3E0D0A3C7265637420783D222D3434392220793D223236392220636C6173733D
          22426C61636B222077696474683D223422206865696768743D223234222F3E0D
          0A3C706F6C79676F6E20636C6173733D22426C61636B2220706F696E74733D22
          2D3435332C323739202D3435332C323737202D3435372C323831202D3435332C
          323835202D3435332C323833202D3435312C323833202D3435312C3237392022
          2F3E0D0A3C706F6C79676F6E20636C6173733D22426C61636B2220706F696E74
          733D222D3434312C323739202D3434312C323737202D3433372C323831202D34
          34312C323835202D3434312C323833202D3434332C323833202D3434332C3237
          3920222F3E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020313820313822207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203138203138
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F637373223E2E426C61636B7B
          66696C6C3A233732373237323B7D3C2F7374796C653E0D0A3C7061746820636C
          6173733D22426C61636B2220643D224D302C3176313663302C302E362C302E34
          2C312C312C3168313663302E362C302C312D302E342C312D31563163302D302E
          362D302E342D312D312D31483143302E342C302C302C302E342C302C317A204D
          31362C3136483256326831345631367A222F3E0D0A3C706F6C79676F6E20636C
          6173733D22426C61636B2220706F696E74733D2231322C3520382C3920362C37
          20342C3920362C313120382C31332031302C31312031342C3720222F3E0D0A3C
          2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020313820313822207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203138203138
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F637373223E2E426C61636B7B
          66696C6C3A233732373237323B7D3C2F7374796C653E0D0A3C7061746820636C
          6173733D22426C61636B2220643D224D392C30222F3E0D0A3C7061746820636C
          6173733D22426C61636B2220643D224D392C3043342C302C302C342C302C3963
          302C352C342C392C392C3963352C302C392D342C392D394331382C342C31342C
          302C392C307A204D392C3136632D332E392C302D372D332E312D372D3763302D
          332E392C332E312D372C372D3720202623393B63332E392C302C372C332E312C
          372C374331362C31322E392C31322E392C31362C392C31367A222F3E0D0A3C63
          6972636C6520636C6173733D22426C61636B222063783D2239222063793D2239
          2220723D2235222F3E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D223020302033322033322220786D6C3A7370
          6163653D227072657365727665223E262331333B262331303B3C7374796C6520
          747970653D22746578742F6373732220786D6C3A73706163653D227072657365
          727665223E2E426C75657B66696C6C3A233131373744373B7D262331333B2623
          31303B2623393B2E477265656E7B66696C6C3A233033394332333B7D3C2F7374
          796C653E0D0A3C7265637420783D2231382220793D22382220636C6173733D22
          426C7565222077696474683D22313522206865696768743D223135222F3E0D0A
          3C7265637420783D22302220793D22382220636C6173733D22477265656E2220
          77696474683D22313522206865696768743D223135222F3E0D0A3C2F7376673E
          0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D223020302033322033322220786D6C3A7370
          6163653D227072657365727665223E262331333B262331303B3C7374796C6520
          747970653D22746578742F6373732220786D6C3A73706163653D227072657365
          727665223E2E426C75657B66696C6C3A233131373744373B7D262331333B2623
          31303B2623393B2E477265656E7B66696C6C3A233033394332333B7D3C2F7374
          796C653E0D0A3C7265637420783D22382220793D222220636C6173733D22426C
          7565222077696474683D22313522206865696768743D223135222F3E0D0A3C72
          65637420783D22382220793D2231382220636C6173733D22477265656E222077
          696474683D22313522206865696768743D223135222F3E0D0A3C2F7376673E0D
          0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F6373732220786D6C3A737061
          63653D227072657365727665223E2E426C75657B66696C6C3A23313137374437
          3B7D262331333B262331303B2623393B2E477265656E7B66696C6C3A23303339
          4332333B7D3C2F7374796C653E0D0A3C706F6C79676F6E20636C6173733D2242
          6C75652220706F696E74733D2231302C382031302C3220302C3220302C333020
          33322C33302033322C3820222F3E0D0A3C7265637420783D2231322220793D22
          322220636C6173733D22477265656E222077696474683D223130222068656967
          68743D2234222F3E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D223020302033322033322220786D6C3A7370
          6163653D227072657365727665223E262331333B262331303B3C7374796C6520
          747970653D22746578742F6373732220786D6C3A73706163653D227072657365
          727665223E262331333B262331303B2623393B2E426C75657B66696C6C3A2331
          31373744373B7D262331333B262331303B2623393B2E477265656E7B66696C6C
          3A233033394332333B7D262331333B262331303B2623393B2E59656C6C6F777B
          66696C6C3A234646423131353B7D262331333B262331303B3C2F7374796C653E
          0D0A3C7265637420783D2231382220793D22382220636C6173733D22426C7565
          222077696474683D22313522206865696768743D223135222F3E0D0A3C726563
          7420783D22302220793D22382220636C6173733D22477265656E222077696474
          683D22313522206865696768743D223135222F3E0D0A3C7061746820636C6173
          733D2259656C6C6F772220643D224D33302C3234762D3563302D302E362D302E
          342D312D312D31682D36632D302E362C302D312C302E342D312C317635682D32
          7638683132762D384833307A204D32342C3234762D34683476344832347A222F
          3E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D223020302033322033322220786D6C3A7370
          6163653D227072657365727665223E262331333B262331303B3C7374796C6520
          747970653D22746578742F6373732220786D6C3A73706163653D227072657365
          727665223E262331333B262331303B2623393B2E426C75657B66696C6C3A2331
          31373744373B7D262331333B262331303B2623393B2E477265656E7B66696C6C
          3A233033394332333B7D262331333B262331303B2623393B2E59656C6C6F777B
          66696C6C3A234646423131353B7D262331333B262331303B3C2F7374796C653E
          0D0A3C7265637420783D22382220793D222220636C6173733D22426C75652220
          77696474683D22313522206865696768743D223135222F3E0D0A3C7265637420
          783D22382220793D2231382220636C6173733D22477265656E22207769647468
          3D22313522206865696768743D223135222F3E0D0A3C7061746820636C617373
          3D2259656C6C6F772220643D224D33302C3234762D3563302D302E362D302E34
          2D312D312D31682D36632D302E362C302D312C302E342D312C317635682D3276
          38683132762D384833307A204D32342C3234762D34683476344832347A222F3E
          0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F6373732220786D6C3A737061
          63653D227072657365727665223E2E426C75657B66696C6C3A23313137374437
          7D262331333B262331303B2623393B2E477265656E7B66696C6C3A2330333943
          32337D262331333B262331303B2623393B2E59656C6C6F777B66696C6C3A2346
          46423131357D3C2F7374796C653E0D0A3C706F6C79676F6E20636C6173733D22
          426C75652220706F696E74733D2231302C382031302C3220302C3220302C3330
          2033322C33302033322C3820222F3E0D0A3C7265637420783D2231322220793D
          22322220636C6173733D22477265656E222077696474683D2231302220686569
          6768743D2234222F3E0D0A3C7061746820636C6173733D2259656C6C6F772220
          643D224D33302C3234762D3563302D302E362D302E342D312D312D31682D3663
          2D302E362C302D312C302E342D312C317635682D327638683132762D38483330
          7A204D32342C3234762D34683476344832347A222F3E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D223020302033322033322220786D6C3A7370
          6163653D227072657365727665223E262331333B262331303B3C7374796C6520
          747970653D22746578742F6373732220786D6C3A73706163653D227072657365
          727665223E262331333B262331303B2623393B2E426C75657B66696C6C3A2331
          31373744373B7D262331333B262331303B2623393B2E477265656E7B66696C6C
          3A233033394332333B7D262331333B262331303B2623393B2E426C61636B7B66
          696C6C3A233346334633467D262331333B262331303B2623393B2E5768697465
          7B66696C6C3A234646464646467D262331333B262331303B3C2F7374796C653E
          0D0A3C7265637420783D2231382220793D22382220636C6173733D22426C7565
          222077696474683D22313522206865696768743D223135222F3E0D0A3C726563
          7420783D22302220793D22382220636C6173733D22477265656E222077696474
          683D22313522206865696768743D223135222F3E0D0A3C672069643D224D756C
          74696C696E6522207472616E73666F726D3D226D617472697828302E32373839
          33392C20302C20302C20302E3239343334392C2031362E3634313534382C202D
          302E3735313536312922207374796C653D22223E0D0A09093C636972636C6520
          636C6173733D22576869746522207374726F6B653D2257686974652220737472
          6F6B652D77696474683D2231222063783D22363432222063793D223538362220
          723D22353622207472616E73666F726D3D226D617472697828302E3533373235
          372C20302C20302C20302E35303934392C202D3331362E3933323932322C202D
          3236392E37393031363129222F3E0D0A09093C7061746820636C6173733D2242
          6C61636B2220643D224D20312E3839382032352E353937204C2031372E303932
          2032352E353937204C2031372E3039322031382E3639204C2032372E39343520
          32382E353734204C2031372E3039322033382E343537204C2031372E30393220
          33312E3535204C20312E3839382033312E3535204C20312E3839382032352E35
          3937205A22207374796C653D2222207472616E73666F726D3D226D6174726978
          282D312C20302C20302C202D312C2032392E3834333030372C2035372E313436
          39393429222F3E0D0A09093C7061746820636C6173733D22426C61636B222064
          3D224D2032342E3937312032392E343432204C2032342E3937312034332E3737
          34204C2031382E3834382034332E373734204C2032382E3330322035342E3031
          31204C2033372E3135342034332E373734204C2033312E3033322034332E3737
          34204C2033312E3033322032392E343432204C2032342E3937312032392E3434
          32205A22207374796C653D22222F3E0D0A09093C7061746820636C6173733D22
          426C61636B2220643D224D2032352E3031372032372E353437204C2032352E30
          31372031332E353437204C2031382E3938382031332E353437204C2032382E30
          323420332E353437204C2033372E3036322031332E353437204C2033312E3033
          322031332E353437204C2033312E3033322032372E353437204C2032352E3031
          372032372E353437205A22207374796C653D22222F3E0D0A09093C7061746820
          636C6173733D22426C61636B2220643D224D2032372E3735382032352E353837
          204C2034332E31312032352E353837204C2034332E31312031382E363337204C
          2035342E3037362032382E353735204C2034332E31312033382E353133204C20
          34332E31312033312E353632204C2032372E3735382033312E353632204C2032
          372E3735382032352E353837205A22207374796C653D22222F3E0D0A093C2F67
          3E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D223020302033322033322220786D6C3A7370
          6163653D227072657365727665223E262331333B262331303B3C7374796C6520
          747970653D22746578742F6373732220786D6C3A73706163653D227072657365
          727665223E262331333B262331303B2623393B2E426C75657B66696C6C3A2331
          31373744373B7D262331333B262331303B2623393B2E477265656E7B66696C6C
          3A233033394332333B7D262331333B262331303B2623393B2E426C61636B7B66
          696C6C3A233346334633467D262331333B262331303B2623393B2E5768697465
          7B66696C6C3A234646464646467D262331333B262331303B3C2F7374796C653E
          0D0A3C7265637420783D22382220793D222220636C6173733D22426C75652220
          77696474683D22313522206865696768743D223135222F3E0D0A3C7265637420
          783D22382220793D2231382220636C6173733D22477265656E22207769647468
          3D22313522206865696768743D223135222F3E0D0A3C672069643D224D756C74
          696C696E6522207472616E73666F726D3D226D617472697828302E3237383933
          392C20302C20302C20302E3239343334392C2031362E3634313534382C202D30
          2E3735313536312922207374796C653D22223E0D0A09093C636972636C652063
          6C6173733D22576869746522207374726F6B653D22576869746522207374726F
          6B652D77696474683D2231222063783D22363432222063793D22353836222072
          3D22353622207472616E73666F726D3D226D617472697828302E353337323537
          2C20302C20302C20302E35303934392C202D3331362E3933323932322C202D32
          36392E37393031363129222F3E0D0A09093C7061746820636C6173733D22426C
          61636B2220643D224D20312E3839382032352E353937204C2031372E30393220
          32352E353937204C2031372E3039322031382E3639204C2032372E3934352032
          382E353734204C2031372E3039322033382E343537204C2031372E3039322033
          312E3535204C20312E3839382033312E3535204C20312E3839382032352E3539
          37205A22207374796C653D2222207472616E73666F726D3D226D617472697828
          2D312C20302C20302C202D312C2032392E3834333030372C2035372E31343639
          393429222F3E0D0A09093C7061746820636C6173733D22426C61636B2220643D
          224D2032342E3937312032392E343432204C2032342E3937312034332E373734
          204C2031382E3834382034332E373734204C2032382E3330322035342E303131
          204C2033372E3135342034332E373734204C2033312E3033322034332E373734
          204C2033312E3033322032392E343432204C2032342E3937312032392E343432
          205A22207374796C653D22222F3E0D0A09093C7061746820636C6173733D2242
          6C61636B2220643D224D2032352E3031372032372E353437204C2032352E3031
          372031332E353437204C2031382E3938382031332E353437204C2032382E3032
          3420332E353437204C2033372E3036322031332E353437204C2033312E303332
          2031332E353437204C2033312E3033322032372E353437204C2032352E303137
          2032372E353437205A22207374796C653D22222F3E0D0A09093C706174682063
          6C6173733D22426C61636B2220643D224D2032372E3735382032352E35383720
          4C2034332E31312032352E353837204C2034332E31312031382E363337204C20
          35342E3037362032382E353735204C2034332E31312033382E353133204C2034
          332E31312033312E353632204C2032372E3735382033312E353632204C203237
          2E3735382032352E353837205A22207374796C653D22222F3E0D0A093C2F673E
          0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F6373732220786D6C3A737061
          63653D227072657365727665223E262331333B262331303B2623393B2E426C75
          657B66696C6C3A233131373744377D262331333B262331303B2623393B2E4772
          65656E7B66696C6C3A233033394332337D262331333B262331303B2623393B2E
          426C61636B7B66696C6C3A233346334633467D262331333B262331303B262339
          3B2E57686974657B66696C6C3A234646464646467D262331333B262331303B3C
          2F7374796C653E0D0A3C706F6C79676F6E20636C6173733D22426C7565222070
          6F696E74733D2231302C382031302C3220302C3220302C33302033322C333020
          33322C3820222F3E0D0A3C7265637420783D2231322220793D22322220636C61
          73733D22477265656E222077696474683D22313022206865696768743D223422
          2F3E0D0A3C672069643D224D756C74696C696E6522207472616E73666F726D3D
          226D617472697828302E3237383933392C20302C20302C20302E323934333439
          2C2031362E3634313534382C202D302E3735313536312922207374796C653D22
          223E0D0A09093C636972636C6520636C6173733D22576869746522207374726F
          6B653D22576869746522207374726F6B652D77696474683D2231222063783D22
          363432222063793D223538362220723D22353622207472616E73666F726D3D22
          6D617472697828302E3533373235372C20302C20302C20302E35303934392C20
          2D3331362E3933323932322C202D3236392E37393031363129222F3E0D0A0909
          3C7061746820636C6173733D22426C61636B2220643D224D20312E3839382032
          352E353937204C2031372E3039322032352E353937204C2031372E3039322031
          382E3639204C2032372E3934352032382E353734204C2031372E303932203338
          2E343537204C2031372E3039322033312E3535204C20312E3839382033312E35
          35204C20312E3839382032352E353937205A22207374796C653D222220747261
          6E73666F726D3D226D6174726978282D312C20302C20302C202D312C2032392E
          3834333030372C2035372E31343639393429222F3E0D0A09093C706174682063
          6C6173733D22426C61636B2220643D224D2032342E3937312032392E34343220
          4C2032342E3937312034332E373734204C2031382E3834382034332E37373420
          4C2032382E3330322035342E303131204C2033372E3135342034332E37373420
          4C2033312E3033322034332E373734204C2033312E3033322032392E34343220
          4C2032342E3937312032392E343432205A22207374796C653D22222F3E0D0A09
          093C7061746820636C6173733D22426C61636B2220643D224D2032352E303137
          2032372E353437204C2032352E3031372031332E353437204C2031382E393838
          2031332E353437204C2032382E30323420332E353437204C2033372E30363220
          31332E353437204C2033312E3033322031332E353437204C2033312E30333220
          32372E353437204C2032352E3031372032372E353437205A22207374796C653D
          22222F3E0D0A09093C7061746820636C6173733D22426C61636B2220643D224D
          2032372E3735382032352E353837204C2034332E31312032352E353837204C20
          34332E31312031382E363337204C2035342E3037362032382E353735204C2034
          332E31312033382E353133204C2034332E31312033312E353632204C2032372E
          3735382033312E353632204C2032372E3735382032352E353837205A22207374
          796C653D22222F3E0D0A093C2F673E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D223020302033322033322220786D6C3A7370
          6163653D227072657365727665223E262331333B262331303B3C7374796C6520
          747970653D22746578742F6373732220786D6C3A73706163653D227072657365
          727665223E262331333B262331303B2623393B2E426C75657B66696C6C3A2331
          31373744373B7D262331333B262331303B2623393B2E477265656E7B66696C6C
          3A233033394332333B7D262331333B262331303B2623393B2E59656C6C6F777B
          66696C6C3A234646423131353B7D262331333B262331303B2623393B2E426C61
          636B7B66696C6C3A233346334633467D262331333B262331303B2623393B2E57
          686974657B66696C6C3A234646464646467D262331333B262331303B3C2F7374
          796C653E0D0A3C7265637420783D2231382220793D22382220636C6173733D22
          426C7565222077696474683D22313522206865696768743D223135222F3E0D0A
          3C7265637420783D22302220793D22382220636C6173733D22477265656E2220
          77696474683D22313522206865696768743D223135222F3E0D0A3C7061746820
          636C6173733D2259656C6C6F772220643D224D33302C3234762D3563302D302E
          362D302E342D312D312D31682D36632D302E362C302D312C302E342D312C3176
          35682D327638683132762D384833307A204D32342C3234762D34683476344832
          347A222F3E0D0A3C672069643D224D756C74696C696E6522207472616E73666F
          726D3D226D617472697828302E3237383933392C20302C20302C20302E323934
          3334392C2031362E3634313534382C202D302E3735313536312922207374796C
          653D22223E0D0A09093C636972636C6520636C6173733D225768697465222073
          74726F6B653D22576869746522207374726F6B652D77696474683D2231222063
          783D22363432222063793D223538362220723D22353622207472616E73666F72
          6D3D226D617472697828302E3533373235372C20302C20302C20302E35303934
          392C202D3331362E3933323932322C202D3236392E37393031363129222F3E0D
          0A09093C7061746820636C6173733D22426C61636B2220643D224D20312E3839
          382032352E353937204C2031372E3039322032352E353937204C2031372E3039
          322031382E3639204C2032372E3934352032382E353734204C2031372E303932
          2033382E343537204C2031372E3039322033312E3535204C20312E3839382033
          312E3535204C20312E3839382032352E353937205A22207374796C653D222220
          7472616E73666F726D3D226D6174726978282D312C20302C20302C202D312C20
          32392E3834333030372C2035372E31343639393429222F3E0D0A09093C706174
          6820636C6173733D22426C61636B2220643D224D2032342E3937312032392E34
          3432204C2032342E3937312034332E373734204C2031382E3834382034332E37
          3734204C2032382E3330322035342E303131204C2033372E3135342034332E37
          3734204C2033312E3033322034332E373734204C2033312E3033322032392E34
          3432204C2032342E3937312032392E343432205A22207374796C653D22222F3E
          0D0A09093C7061746820636C6173733D22426C61636B2220643D224D2032352E
          3031372032372E353437204C2032352E3031372031332E353437204C2031382E
          3938382031332E353437204C2032382E30323420332E353437204C2033372E30
          36322031332E353437204C2033312E3033322031332E353437204C2033312E30
          33322032372E353437204C2032352E3031372032372E353437205A2220737479
          6C653D22222F3E0D0A09093C7061746820636C6173733D22426C61636B222064
          3D224D2032372E3735382032352E353837204C2034332E31312032352E353837
          204C2034332E31312031382E363337204C2035342E3037362032382E35373520
          4C2034332E31312033382E353133204C2034332E31312033312E353632204C20
          32372E3735382033312E353632204C2032372E3735382032352E353837205A22
          207374796C653D22222F3E0D0A093C2F673E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D223020302033322033322220786D6C3A7370
          6163653D227072657365727665223E262331333B262331303B3C7374796C6520
          747970653D22746578742F6373732220786D6C3A73706163653D227072657365
          727665223E262331333B262331303B2623393B2E426C75657B66696C6C3A2331
          31373744377D262331333B262331303B2623393B2E477265656E7B66696C6C3A
          233033394332337D262331333B262331303B2623393B2E59656C6C6F777B6669
          6C6C3A234646423131357D262331333B262331303B2623393B2E426C61636B7B
          66696C6C3A233346334633467D262331333B262331303B2623393B2E57686974
          657B66696C6C3A234646464646467D262331333B262331303B3C2F7374796C65
          3E0D0A3C7265637420783D22382220793D222220636C6173733D22426C756522
          2077696474683D22313522206865696768743D223135222F3E0D0A3C72656374
          20783D22382220793D2231382220636C6173733D22477265656E222077696474
          683D22313522206865696768743D223135222F3E0D0A3C7061746820636C6173
          733D2259656C6C6F772220643D224D33302C3234762D3563302D302E362D302E
          342D312D312D31682D36632D302E362C302D312C302E342D312C317635682D32
          7638683132762D384833307A204D32342C3234762D34683476344832347A222F
          3E0D0A3C672069643D224D756C74696C696E6522207472616E73666F726D3D22
          6D617472697828302E3237383933392C20302C20302C20302E3239343334392C
          2031362E3634313534382C202D302E3735313536312922207374796C653D2222
          3E0D0A09093C636972636C6520636C6173733D22576869746522207374726F6B
          653D22576869746522207374726F6B652D77696474683D2231222063783D2236
          3432222063793D223538362220723D22353622207472616E73666F726D3D226D
          617472697828302E3533373235372C20302C20302C20302E35303934392C202D
          3331362E3933323932322C202D3236392E37393031363129222F3E0D0A09093C
          7061746820636C6173733D22426C61636B2220643D224D20312E383938203235
          2E353937204C2031372E3039322032352E353937204C2031372E303932203138
          2E3639204C2032372E3934352032382E353734204C2031372E3039322033382E
          343537204C2031372E3039322033312E3535204C20312E3839382033312E3535
          204C20312E3839382032352E353937205A22207374796C653D2222207472616E
          73666F726D3D226D6174726978282D312C20302C20302C202D312C2032392E38
          34333030372C2035372E31343639393429222F3E0D0A09093C7061746820636C
          6173733D22426C61636B2220643D224D2032342E3937312032392E343432204C
          2032342E3937312034332E373734204C2031382E3834382034332E373734204C
          2032382E3330322035342E303131204C2033372E3135342034332E373734204C
          2033312E3033322034332E373734204C2033312E3033322032392E343432204C
          2032342E3937312032392E343432205A22207374796C653D22222F3E0D0A0909
          3C7061746820636C6173733D22426C61636B2220643D224D2032352E30313720
          32372E353437204C2032352E3031372031332E353437204C2031382E39383820
          31332E353437204C2032382E30323420332E353437204C2033372E3036322031
          332E353437204C2033312E3033322031332E353437204C2033312E3033322032
          372E353437204C2032352E3031372032372E353437205A22207374796C653D22
          222F3E0D0A09093C7061746820636C6173733D22426C61636B2220643D224D20
          32372E3735382032352E353837204C2034332E31312032352E353837204C2034
          332E31312031382E363337204C2035342E3037362032382E353735204C203433
          2E31312033382E353133204C2034332E31312033312E353632204C2032372E37
          35382033312E353632204C2032372E3735382032352E353837205A2220737479
          6C653D22222F3E0D0A093C2F673E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F6373732220786D6C3A737061
          63653D227072657365727665223E262331333B262331303B2623393B2E426C75
          657B66696C6C3A233131373744377D262331333B262331303B2623393B2E4772
          65656E7B66696C6C3A233033394332337D262331333B262331303B2623393B2E
          426C61636B7B66696C6C3A233346334633467D262331333B262331303B262339
          3B2E57686974657B66696C6C3A234646464646467D262331333B262331303B26
          23393B2E59656C6C6F777B66696C6C3A234646423131357D262331333B262331
          303B3C2F7374796C653E0D0A3C706F6C79676F6E20636C6173733D22426C7565
          2220706F696E74733D2231302C382031302C3220302C3220302C33302033322C
          33302033322C3820222F3E0D0A3C7265637420783D2231322220793D22322220
          636C6173733D22477265656E222077696474683D22313022206865696768743D
          2234222F3E0D0A3C7061746820636C6173733D2259656C6C6F772220643D224D
          33302C3234762D3563302D302E362D302E342D312D312D31682D36632D302E36
          2C302D312C302E342D312C317635682D327638683132762D384833307A204D32
          342C3234762D34683476344832347A222F3E0D0A3C672069643D224D756C7469
          6C696E6522207472616E73666F726D3D226D617472697828302E323738393339
          2C20302C20302C20302E3239343334392C2031362E3634313534382C202D302E
          3735313536312922207374796C653D22223E0D0A09093C636972636C6520636C
          6173733D22576869746522207374726F6B653D22576869746522207374726F6B
          652D77696474683D2231222063783D22363432222063793D223538362220723D
          22353622207472616E73666F726D3D226D617472697828302E3533373235372C
          20302C20302C20302E35303934392C202D3331362E3933323932322C202D3236
          392E37393031363129222F3E0D0A09093C7061746820636C6173733D22426C61
          636B2220643D224D20312E3839382032352E353937204C2031372E3039322032
          352E353937204C2031372E3039322031382E3639204C2032372E393435203238
          2E353734204C2031372E3039322033382E343537204C2031372E303932203331
          2E3535204C20312E3839382033312E3535204C20312E3839382032352E353937
          205A22207374796C653D2222207472616E73666F726D3D226D6174726978282D
          312C20302C20302C202D312C2032392E3834333030372C2035372E3134363939
          3429222F3E0D0A09093C7061746820636C6173733D22426C61636B2220643D22
          4D2032342E3937312032392E343432204C2032342E3937312034332E37373420
          4C2031382E3834382034332E373734204C2032382E3330322035342E30313120
          4C2033372E3135342034332E373734204C2033312E3033322034332E37373420
          4C2033312E3033322032392E343432204C2032342E3937312032392E34343220
          5A22207374796C653D22222F3E0D0A09093C7061746820636C6173733D22426C
          61636B2220643D224D2032352E3031372032372E353437204C2032352E303137
          2031332E353437204C2031382E3938382031332E353437204C2032382E303234
          20332E353437204C2033372E3036322031332E353437204C2033312E30333220
          31332E353437204C2033312E3033322032372E353437204C2032352E30313720
          32372E353437205A22207374796C653D22222F3E0D0A09093C7061746820636C
          6173733D22426C61636B2220643D224D2032372E3735382032352E353837204C
          2034332E31312032352E353837204C2034332E31312031382E363337204C2035
          342E3037362032382E353735204C2034332E31312033382E353133204C203433
          2E31312033312E353632204C2032372E3735382033312E353632204C2032372E
          3735382032352E353837205A22207374796C653D22222F3E0D0A093C2F673E0D
          0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D223020302033322033322220786D6C3A7370
          6163653D227072657365727665223E262331333B262331303B3C7374796C6520
          747970653D22746578742F6373732220786D6C3A73706163653D227072657365
          727665223E262331333B262331303B2623393B2E477261797B66696C6C3A2337
          32373237327D262331333B262331303B3C2F7374796C653E0D0A3C7265637420
          783D2231382220793D22382220636C6173733D2247726179222077696474683D
          22313522206865696768743D223135222F3E0D0A3C7265637420783D22302220
          793D22382220636C6173733D2247726179222077696474683D22313522206865
          696768743D223135222F3E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D223020302033322033322220786D6C3A7370
          6163653D227072657365727665223E262331333B262331303B3C7374796C6520
          747970653D22746578742F6373732220786D6C3A73706163653D227072657365
          727665223E262331333B262331303B2623393B2E477261797B66696C6C3A2337
          32373237327D262331333B262331303B3C2F7374796C653E0D0A3C7265637420
          783D22382220793D222220636C6173733D2247726179222077696474683D2231
          3522206865696768743D223135222F3E0D0A3C7265637420783D22382220793D
          2231382220636C6173733D2247726179222077696474683D2231352220686569
          6768743D223135222F3E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F637373223E2E477261797B66
          696C6C3A233732373237327D3C2F7374796C653E0D0A3C706F6C79676F6E2063
          6C6173733D22477261792220706F696E74733D2231302C382031302C3220302C
          3220302C33302033322C33302033322C3820222F3E0D0A3C7265637420783D22
          31322220793D22322220636C6173733D2247726179222077696474683D223130
          22206865696768743D2234222F3E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D223020302033322033322220786D6C3A7370
          6163653D227072657365727665223E262331333B262331303B3C7374796C6520
          747970653D22746578742F6373732220786D6C3A73706163653D227072657365
          727665223E262331333B262331303B2623393B2E477261797B66696C6C3A2337
          32373237327D262331333B262331303B2623393B2E59656C6C6F777B66696C6C
          3A234646423131357D262331333B262331303B3C2F7374796C653E0D0A3C7265
          637420783D2231382220793D22382220636C6173733D22477261792220776964
          74683D22313522206865696768743D223135222F3E0D0A3C7265637420783D22
          302220793D22382220636C6173733D2247726179222077696474683D22313522
          206865696768743D223135222F3E0D0A3C7061746820636C6173733D2259656C
          6C6F772220643D224D33302C3234762D3563302D302E362D302E342D312D312D
          31682D36632D302E362C302D312C302E342D312C317635682D32763868313276
          2D384833307A204D32342C3234762D34683476344832347A222F3E0D0A3C2F73
          76673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D223020302033322033322220786D6C3A7370
          6163653D227072657365727665223E262331333B262331303B3C7374796C6520
          747970653D22746578742F6373732220786D6C3A73706163653D227072657365
          727665223E262331333B262331303B2623393B2E477261797B66696C6C3A2337
          32373237327D262331333B262331303B2623393B2E59656C6C6F777B66696C6C
          3A234646423131357D262331333B262331303B3C2F7374796C653E0D0A3C7265
          637420783D22382220793D222220636C6173733D224772617922207769647468
          3D22313522206865696768743D223135222F3E0D0A3C7265637420783D223822
          20793D2231382220636C6173733D2247726179222077696474683D2231352220
          6865696768743D223135222F3E0D0A3C7061746820636C6173733D2259656C6C
          6F772220643D224D33302C3234762D3563302D302E362D302E342D312D312D31
          682D36632D302E362C302D312C302E342D312C317635682D327638683132762D
          384833307A204D32342C3234762D34683476344832347A222F3E0D0A3C2F7376
          673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F6373732220786D6C3A737061
          63653D227072657365727665223E262331333B262331303B2623393B2E477261
          797B66696C6C3A233732373237327D262331333B262331303B2623393B2E5965
          6C6C6F777B66696C6C3A234646423131357D262331333B262331303B3C2F7374
          796C653E0D0A3C706F6C79676F6E20636C6173733D22477261792220706F696E
          74733D2231302C382031302C3220302C3220302C33302033322C33302033322C
          3820222F3E0D0A3C7265637420783D2231322220793D22322220636C6173733D
          2247726179222077696474683D22313022206865696768743D2234222F3E0D0A
          3C7061746820636C6173733D2259656C6C6F772220643D224D33302C3234762D
          3563302D302E362D302E342D312D312D31682D36632D302E362C302D312C302E
          342D312C317635682D327638683132762D384833307A204D32342C3234762D34
          683476344832347A222F3E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D223020302033322033322220786D6C3A7370
          6163653D227072657365727665223E262331333B262331303B3C7374796C6520
          747970653D22746578742F6373732220786D6C3A73706163653D227072657365
          727665223E262331333B262331303B2623393B2E477261797B66696C6C3A2337
          32373237327D262331333B262331303B2623393B2E57686974657B66696C6C3A
          234646464646467D262331333B262331303B2623393B2E426C61636B7B66696C
          6C3A233346334633467D262331333B262331303B3C2F7374796C653E0D0A3C72
          65637420783D2231382220793D22382220636C6173733D224772617922207769
          6474683D22313522206865696768743D223135222F3E0D0A3C7265637420783D
          22302220793D22382220636C6173733D2247726179222077696474683D223135
          22206865696768743D223135222F3E0D0A3C672069643D224D756C74696C696E
          6522207472616E73666F726D3D226D617472697828302E3237383933392C2030
          2C20302C20302E3239343334392C2031362E3634313534382C202D302E373531
          3536312922207374796C653D22223E0D0A09093C636972636C6520636C617373
          3D22576869746522207374726F6B653D22576869746522207374726F6B652D77
          696474683D2231222063783D22363432222063793D223538362220723D223536
          22207472616E73666F726D3D226D617472697828302E3533373235372C20302C
          20302C20302E35303934392C202D3331362E3933323932322C202D3236392E37
          393031363129222F3E0D0A09093C7061746820636C6173733D22426C61636B22
          20643D224D20312E3839382032352E353937204C2031372E3039322032352E35
          3937204C2031372E3039322031382E3639204C2032372E3934352032382E3537
          34204C2031372E3039322033382E343537204C2031372E3039322033312E3535
          204C20312E3839382033312E3535204C20312E3839382032352E353937205A22
          207374796C653D2222207472616E73666F726D3D226D6174726978282D312C20
          302C20302C202D312C2032392E3834333030372C2035372E3134363939342922
          2F3E0D0A09093C7061746820636C6173733D22426C61636B2220643D224D2032
          342E3937312032392E343432204C2032342E3937312034332E373734204C2031
          382E3834382034332E373734204C2032382E3330322035342E303131204C2033
          372E3135342034332E373734204C2033312E3033322034332E373734204C2033
          312E3033322032392E343432204C2032342E3937312032392E343432205A2220
          7374796C653D22222F3E0D0A09093C7061746820636C6173733D22426C61636B
          2220643D224D2032352E3031372032372E353437204C2032352E303137203133
          2E353437204C2031382E3938382031332E353437204C2032382E30323420332E
          353437204C2033372E3036322031332E353437204C2033312E3033322031332E
          353437204C2033312E3033322032372E353437204C2032352E3031372032372E
          353437205A22207374796C653D22222F3E0D0A09093C7061746820636C617373
          3D22426C61636B2220643D224D2032372E3735382032352E353837204C203433
          2E31312032352E353837204C2034332E31312031382E363337204C2035342E30
          37362032382E353735204C2034332E31312033382E353133204C2034332E3131
          2033312E353632204C2032372E3735382033312E353632204C2032372E373538
          2032352E353837205A22207374796C653D22222F3E0D0A093C2F673E0D0A3C2F
          7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D223020302033322033322220786D6C3A7370
          6163653D227072657365727665223E262331333B262331303B3C7374796C6520
          747970653D22746578742F6373732220786D6C3A73706163653D227072657365
          727665223E262331333B262331303B2623393B2E477261797B66696C6C3A2337
          32373237327D262331333B262331303B2623393B2E57686974657B66696C6C3A
          234646464646467D262331333B262331303B2623393B2E426C61636B7B66696C
          6C3A233346334633467D262331333B262331303B3C2F7374796C653E0D0A3C72
          65637420783D22382220793D222220636C6173733D2247726179222077696474
          683D22313522206865696768743D223135222F3E0D0A3C7265637420783D2238
          2220793D2231382220636C6173733D2247726179222077696474683D22313522
          206865696768743D223135222F3E0D0A3C672069643D224D756C74696C696E65
          22207472616E73666F726D3D226D617472697828302E3237383933392C20302C
          20302C20302E3239343334392C2031362E3634313534382C202D302E37353135
          36312922207374796C653D22223E0D0A09093C636972636C6520636C6173733D
          22576869746522207374726F6B653D22576869746522207374726F6B652D7769
          6474683D2231222063783D22363432222063793D223538362220723D22353622
          207472616E73666F726D3D226D617472697828302E3533373235372C20302C20
          302C20302E35303934392C202D3331362E3933323932322C202D3236392E3739
          3031363129222F3E0D0A09093C7061746820636C6173733D22426C61636B2220
          643D224D20312E3839382032352E353937204C2031372E3039322032352E3539
          37204C2031372E3039322031382E3639204C2032372E3934352032382E353734
          204C2031372E3039322033382E343537204C2031372E3039322033312E353520
          4C20312E3839382033312E3535204C20312E3839382032352E353937205A2220
          7374796C653D2222207472616E73666F726D3D226D6174726978282D312C2030
          2C20302C202D312C2032392E3834333030372C2035372E31343639393429222F
          3E0D0A09093C7061746820636C6173733D22426C61636B2220643D224D203234
          2E3937312032392E343432204C2032342E3937312034332E373734204C203138
          2E3834382034332E373734204C2032382E3330322035342E303131204C203337
          2E3135342034332E373734204C2033312E3033322034332E373734204C203331
          2E3033322032392E343432204C2032342E3937312032392E343432205A222073
          74796C653D22222F3E0D0A09093C7061746820636C6173733D22426C61636B22
          20643D224D2032352E3031372032372E353437204C2032352E3031372031332E
          353437204C2031382E3938382031332E353437204C2032382E30323420332E35
          3437204C2033372E3036322031332E353437204C2033312E3033322031332E35
          3437204C2033312E3033322032372E353437204C2032352E3031372032372E35
          3437205A22207374796C653D22222F3E0D0A09093C7061746820636C6173733D
          22426C61636B2220643D224D2032372E3735382032352E353837204C2034332E
          31312032352E353837204C2034332E31312031382E363337204C2035342E3037
          362032382E353735204C2034332E31312033382E353133204C2034332E313120
          33312E353632204C2032372E3735382033312E353632204C2032372E37353820
          32352E353837205A22207374796C653D22222F3E0D0A093C2F673E0D0A3C2F73
          76673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F6373732220786D6C3A737061
          63653D227072657365727665223E262331333B262331303B2623393B2E477261
          797B66696C6C3A233732373237327D262331333B262331303B2623393B2E5768
          6974657B66696C6C3A234646464646467D262331333B262331303B2623393B2E
          426C61636B7B66696C6C3A233346334633467D262331333B262331303B3C2F73
          74796C653E0D0A3C706F6C79676F6E20636C6173733D22477261792220706F69
          6E74733D2231302C382031302C3220302C3220302C33302033322C3330203332
          2C3820222F3E0D0A3C7265637420783D2231322220793D22322220636C617373
          3D2247726179222077696474683D22313022206865696768743D2234222F3E0D
          0A3C672069643D224D756C74696C696E6522207472616E73666F726D3D226D61
          7472697828302E3237383933392C20302C20302C20302E3239343334392C2031
          362E3634313534382C202D302E3735313536312922207374796C653D22223E0D
          0A09093C636972636C6520636C6173733D22576869746522207374726F6B653D
          22576869746522207374726F6B652D77696474683D2231222063783D22363432
          222063793D223538362220723D22353622207472616E73666F726D3D226D6174
          72697828302E3533373235372C20302C20302C20302E35303934392C202D3331
          362E3933323932322C202D3236392E37393031363129222F3E0D0A09093C7061
          746820636C6173733D22426C61636B2220643D224D20312E3839382032352E35
          3937204C2031372E3039322032352E353937204C2031372E3039322031382E36
          39204C2032372E3934352032382E353734204C2031372E3039322033382E3435
          37204C2031372E3039322033312E3535204C20312E3839382033312E3535204C
          20312E3839382032352E353937205A22207374796C653D2222207472616E7366
          6F726D3D226D6174726978282D312C20302C20302C202D312C2032392E383433
          3030372C2035372E31343639393429222F3E0D0A09093C7061746820636C6173
          733D22426C61636B2220643D224D2032342E3937312032392E343432204C2032
          342E3937312034332E373734204C2031382E3834382034332E373734204C2032
          382E3330322035342E303131204C2033372E3135342034332E373734204C2033
          312E3033322034332E373734204C2033312E3033322032392E343432204C2032
          342E3937312032392E343432205A22207374796C653D22222F3E0D0A09093C70
          61746820636C6173733D22426C61636B2220643D224D2032352E303137203237
          2E353437204C2032352E3031372031332E353437204C2031382E393838203133
          2E353437204C2032382E30323420332E353437204C2033372E3036322031332E
          353437204C2033312E3033322031332E353437204C2033312E3033322032372E
          353437204C2032352E3031372032372E353437205A22207374796C653D22222F
          3E0D0A09093C7061746820636C6173733D22426C61636B2220643D224D203237
          2E3735382032352E353837204C2034332E31312032352E353837204C2034332E
          31312031382E363337204C2035342E3037362032382E353735204C2034332E31
          312033382E353133204C2034332E31312033312E353632204C2032372E373538
          2033312E353632204C2032372E3735382032352E353837205A22207374796C65
          3D22222F3E0D0A093C2F673E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D223020302033322033322220786D6C3A7370
          6163653D227072657365727665223E262331333B262331303B3C7374796C6520
          747970653D22746578742F6373732220786D6C3A73706163653D227072657365
          727665223E262331333B262331303B2623393B2E477261797B66696C6C3A2337
          32373237327D262331333B262331303B2623393B2E57686974657B66696C6C3A
          234646464646467D262331333B262331303B2623393B2E59656C6C6F777B6669
          6C6C3A234646423131357D262331333B262331303B2623393B2E426C61636B7B
          66696C6C3A233346334633467D262331333B262331303B3C2F7374796C653E0D
          0A3C7265637420783D2231382220793D22382220636C6173733D224772617922
          2077696474683D22313522206865696768743D223135222F3E0D0A3C72656374
          20783D22302220793D22382220636C6173733D2247726179222077696474683D
          22313522206865696768743D223135222F3E0D0A3C7061746820636C6173733D
          2259656C6C6F772220643D224D33302C3234762D3563302D302E362D302E342D
          312D312D31682D36632D302E362C302D312C302E342D312C317635682D327638
          683132762D384833307A204D32342C3234762D34683476344832347A222F3E0D
          0A3C672069643D224D756C74696C696E6522207472616E73666F726D3D226D61
          7472697828302E3237383933392C20302C20302C20302E3239343334392C2031
          362E3634313534382C202D302E3735313536312922207374796C653D22223E0D
          0A09093C636972636C6520636C6173733D22576869746522207374726F6B653D
          22576869746522207374726F6B652D77696474683D2231222063783D22363432
          222063793D223538362220723D22353622207472616E73666F726D3D226D6174
          72697828302E3533373235372C20302C20302C20302E35303934392C202D3331
          362E3933323932322C202D3236392E37393031363129222F3E0D0A09093C7061
          746820636C6173733D22426C61636B2220643D224D20312E3839382032352E35
          3937204C2031372E3039322032352E353937204C2031372E3039322031382E36
          39204C2032372E3934352032382E353734204C2031372E3039322033382E3435
          37204C2031372E3039322033312E3535204C20312E3839382033312E3535204C
          20312E3839382032352E353937205A22207374796C653D2222207472616E7366
          6F726D3D226D6174726978282D312C20302C20302C202D312C2032392E383433
          3030372C2035372E31343639393429222F3E0D0A09093C7061746820636C6173
          733D22426C61636B2220643D224D2032342E3937312032392E343432204C2032
          342E3937312034332E373734204C2031382E3834382034332E373734204C2032
          382E3330322035342E303131204C2033372E3135342034332E373734204C2033
          312E3033322034332E373734204C2033312E3033322032392E343432204C2032
          342E3937312032392E343432205A22207374796C653D22222F3E0D0A09093C70
          61746820636C6173733D22426C61636B2220643D224D2032352E303137203237
          2E353437204C2032352E3031372031332E353437204C2031382E393838203133
          2E353437204C2032382E30323420332E353437204C2033372E3036322031332E
          353437204C2033312E3033322031332E353437204C2033312E3033322032372E
          353437204C2032352E3031372032372E353437205A22207374796C653D22222F
          3E0D0A09093C7061746820636C6173733D22426C61636B2220643D224D203237
          2E3735382032352E353837204C2034332E31312032352E353837204C2034332E
          31312031382E363337204C2035342E3037362032382E353735204C2034332E31
          312033382E353133204C2034332E31312033312E353632204C2032372E373538
          2033312E353632204C2032372E3735382032352E353837205A22207374796C65
          3D22222F3E0D0A093C2F673E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D223020302033322033322220786D6C3A7370
          6163653D227072657365727665223E262331333B262331303B3C7374796C6520
          747970653D22746578742F6373732220786D6C3A73706163653D227072657365
          727665223E262331333B262331303B2623393B2E477261797B66696C6C3A2337
          32373237327D262331333B262331303B2623393B2E57686974657B66696C6C3A
          234646464646467D262331333B262331303B2623393B2E59656C6C6F777B6669
          6C6C3A234646423131357D262331333B262331303B2623393B2E426C61636B7B
          66696C6C3A233346334633467D262331333B262331303B3C2F7374796C653E0D
          0A3C7265637420783D22382220793D222220636C6173733D2247726179222077
          696474683D22313522206865696768743D223135222F3E0D0A3C726563742078
          3D22382220793D2231382220636C6173733D2247726179222077696474683D22
          313522206865696768743D223135222F3E0D0A3C7061746820636C6173733D22
          59656C6C6F772220643D224D33302C3234762D3563302D302E362D302E342D31
          2D312D31682D36632D302E362C302D312C302E342D312C317635682D32763868
          3132762D384833307A204D32342C3234762D34683476344832347A222F3E0D0A
          3C672069643D224D756C74696C696E6522207472616E73666F726D3D226D6174
          72697828302E3237383933392C20302C20302C20302E3239343334392C203136
          2E3634313534382C202D302E3735313536312922207374796C653D22223E0D0A
          09093C636972636C6520636C6173733D22576869746522207374726F6B653D22
          576869746522207374726F6B652D77696474683D2231222063783D2236343222
          2063793D223538362220723D22353622207472616E73666F726D3D226D617472
          697828302E3533373235372C20302C20302C20302E35303934392C202D333136
          2E3933323932322C202D3236392E37393031363129222F3E0D0A09093C706174
          6820636C6173733D22426C61636B2220643D224D20312E3839382032352E3539
          37204C2031372E3039322032352E353937204C2031372E3039322031382E3639
          204C2032372E3934352032382E353734204C2031372E3039322033382E343537
          204C2031372E3039322033312E3535204C20312E3839382033312E3535204C20
          312E3839382032352E353937205A22207374796C653D2222207472616E73666F
          726D3D226D6174726978282D312C20302C20302C202D312C2032392E38343330
          30372C2035372E31343639393429222F3E0D0A09093C7061746820636C617373
          3D22426C61636B2220643D224D2032342E3937312032392E343432204C203234
          2E3937312034332E373734204C2031382E3834382034332E373734204C203238
          2E3330322035342E303131204C2033372E3135342034332E373734204C203331
          2E3033322034332E373734204C2033312E3033322032392E343432204C203234
          2E3937312032392E343432205A22207374796C653D22222F3E0D0A09093C7061
          746820636C6173733D22426C61636B2220643D224D2032352E3031372032372E
          353437204C2032352E3031372031332E353437204C2031382E3938382031332E
          353437204C2032382E30323420332E353437204C2033372E3036322031332E35
          3437204C2033312E3033322031332E353437204C2033312E3033322032372E35
          3437204C2032352E3031372032372E353437205A22207374796C653D22222F3E
          0D0A09093C7061746820636C6173733D22426C61636B2220643D224D2032372E
          3735382032352E353837204C2034332E31312032352E353837204C2034332E31
          312031382E363337204C2035342E3037362032382E353735204C2034332E3131
          2033382E353133204C2034332E31312033312E353632204C2032372E37353820
          33312E353632204C2032372E3735382032352E353837205A22207374796C653D
          22222F3E0D0A093C2F673E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F6373732220786D6C3A737061
          63653D227072657365727665223E262331333B262331303B2623393B2E477261
          797B66696C6C3A233732373237327D262331333B262331303B2623393B2E5768
          6974657B66696C6C3A234646464646467D262331333B262331303B2623393B2E
          59656C6C6F777B66696C6C3A234646423131357D262331333B262331303B2623
          393B2E426C61636B7B66696C6C3A233346334633467D262331333B262331303B
          3C2F7374796C653E0D0A3C706F6C79676F6E20636C6173733D22477261792220
          706F696E74733D2231302C382031302C3220302C3220302C33302033322C3330
          2033322C3820222F3E0D0A3C7265637420783D2231322220793D22322220636C
          6173733D2247726179222077696474683D22313022206865696768743D223422
          2F3E0D0A3C7061746820636C6173733D2259656C6C6F772220643D224D33302C
          3234762D3563302D302E362D302E342D312D312D31682D36632D302E362C302D
          312C302E342D312C317635682D327638683132762D384833307A204D32342C32
          34762D34683476344832347A222F3E0D0A3C672069643D224D756C74696C696E
          6522207472616E73666F726D3D226D617472697828302E3237383933392C2030
          2C20302C20302E3239343334392C2031362E3634313534382C202D302E373531
          3536312922207374796C653D22223E0D0A09093C636972636C6520636C617373
          3D22576869746522207374726F6B653D22576869746522207374726F6B652D77
          696474683D2231222063783D22363432222063793D223538362220723D223536
          22207472616E73666F726D3D226D617472697828302E3533373235372C20302C
          20302C20302E35303934392C202D3331362E3933323932322C202D3236392E37
          393031363129222F3E0D0A09093C7061746820636C6173733D22426C61636B22
          20643D224D20312E3839382032352E353937204C2031372E3039322032352E35
          3937204C2031372E3039322031382E3639204C2032372E3934352032382E3537
          34204C2031372E3039322033382E343537204C2031372E3039322033312E3535
          204C20312E3839382033312E3535204C20312E3839382032352E353937205A22
          207374796C653D2222207472616E73666F726D3D226D6174726978282D312C20
          302C20302C202D312C2032392E3834333030372C2035372E3134363939342922
          2F3E0D0A09093C7061746820636C6173733D22426C61636B2220643D224D2032
          342E3937312032392E343432204C2032342E3937312034332E373734204C2031
          382E3834382034332E373734204C2032382E3330322035342E303131204C2033
          372E3135342034332E373734204C2033312E3033322034332E373734204C2033
          312E3033322032392E343432204C2032342E3937312032392E343432205A2220
          7374796C653D22222F3E0D0A09093C7061746820636C6173733D22426C61636B
          2220643D224D2032352E3031372032372E353437204C2032352E303137203133
          2E353437204C2031382E3938382031332E353437204C2032382E30323420332E
          353437204C2033372E3036322031332E353437204C2033312E3033322031332E
          353437204C2033312E3033322032372E353437204C2032352E3031372032372E
          353437205A22207374796C653D22222F3E0D0A09093C7061746820636C617373
          3D22426C61636B2220643D224D2032372E3735382032352E353837204C203433
          2E31312032352E353837204C2034332E31312031382E363337204C2035342E30
          37362032382E353735204C2034332E31312033382E353133204C2034332E3131
          2033312E353632204C2032372E3735382033312E353632204C2032372E373538
          2032352E353837205A22207374796C653D22222F3E0D0A093C2F673E0D0A3C2F
          7376673E0D0A}
      end>
  end
  object pmTreeViewActions: TPopupMenu
    Images = ilActions
    OnPopup = pmTreeViewActionsPopup
    Left = 80
    Top = 360
    object Undo1: TMenuItem
      Action = acUndo
    end
    object Redo1: TMenuItem
      Action = acRedo
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object miExpandAll: TMenuItem
      Action = acTreeViewExpandAll
    end
    object miCollapseAll: TMenuItem
      Action = acTreeViewCollapseAll
    end
    object miSeparator1: TMenuItem
      Caption = '-'
    end
    object miTreeViewDelete: TMenuItem
      Action = acTreeViewItemsDelete
    end
    object miSeparator2: TMenuItem
      Caption = '-'
    end
    object miAlignBy: TMenuItem
      Action = acAlignBy
    end
    object miAlignHorz: TMenuItem
      Caption = 'AlignHorz'
      object miHLeft: TMenuItem
        Action = acHAlignLeft
      end
      object miHCenter: TMenuItem
        Action = acHAlignCenter
      end
      object miHRight: TMenuItem
        Action = acHAlignRight
      end
      object miHClient: TMenuItem
        Action = acHAlignClient
      end
      object miHParentManaged: TMenuItem
        Action = acHAlignParent
      end
    end
    object miAlignVert: TMenuItem
      Caption = 'miAlignVert'
      object miVAlignTop: TMenuItem
        Action = acVAlignTop
      end
      object miVAlignCenter: TMenuItem
        Action = acVAlignCenter
      end
      object miVAlignBottom: TMenuItem
        Action = acVAlignBottom
      end
      object miVAlignClient: TMenuItem
        Action = acVAlignClient
      end
      object miVAlignParent: TMenuItem
        Action = acVAlignParent
      end
    end
    object N7: TMenuItem
      Caption = '-'
    end
    object miDirection: TMenuItem
      Caption = 'miDirection'
      object miDirectionHorizontal: TMenuItem
        Action = acDirectionHorizontal
      end
      object miDirectionVertical: TMenuItem
        Action = acDirectionVertical
      end
      object miDirectionTabbed: TMenuItem
        Action = acDirectionTabbed
      end
    end
    object miBorder: TMenuItem
      Action = acBorder
    end
    object miExpandButton: TMenuItem
      Action = acExpandButton
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object miGroup: TMenuItem
      Action = acGroup
    end
    object miUngroup: TMenuItem
      Action = acUngroup
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object miCollapsible: TMenuItem
      Action = acCollapsible
    end
    object miCaption: TMenuItem
      Action = acCaption
    end
    object miTextPosition: TMenuItem
      Caption = 'TextPosition'
      ImageIndex = 19
      object miTextPositionLeft: TMenuItem
        Action = acTextPositionLeft
      end
      object miTextPositionTop: TMenuItem
        Action = acTextPositionTop
      end
      object miTextPositionRight: TMenuItem
        Action = acTextPositionRight
      end
      object miTextPositionBottom: TMenuItem
        Action = acTextPositionBottom
      end
    end
    object miCaptionAlignHorz: TMenuItem
      Caption = 'CaptionAlignHorz'
      object miCaptionAlignHorzLeft: TMenuItem
        Action = acCaptionAlignHorzLeft
      end
      object miCaptionAlignHorzCenter: TMenuItem
        Action = acCaptionAlignHorzCenter
      end
      object miCaptionAlignHorzRight: TMenuItem
        Action = acCaptionAlignHorzRight
      end
    end
    object miCaptionAlignVert: TMenuItem
      Caption = 'CaptionAlignVert'
      object miCaptionAlignVertTop: TMenuItem
        Action = acCaptionAlignVertTop
      end
      object miCaptionAlignVertCenter: TMenuItem
        Action = acCaptionAlignVertCenter
      end
      object miCaptionAlignVertBottom: TMenuItem
        Action = acCaptionAlignVertBottom
      end
    end
    object miTreeViewItemRename: TMenuItem
      Action = acTreeViewItemRename
    end
  end
  object pmAvailableItemsActions: TPopupMenu
    Images = ilActions
    OnPopup = pmAvailableItemsActionsPopup
    Left = 78
    Top = 392
    object Undo2: TMenuItem
      Action = acUndo
    end
    object Redo2: TMenuItem
      Action = acRedo
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object ExpandAll1: TMenuItem
      Action = acAvailableItemsExpandAll
    end
    object CollapseAll1: TMenuItem
      Action = acAvailableItemsCollapseAll
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object AddGroup1: TMenuItem
      Action = acAddGroup
    end
    object AddItem1: TMenuItem
      Action = acAddItem
    end
    object AddEmptySpaceItem1: TMenuItem
      Action = acAddEmptySpaceItem
    end
    object AddLabel1: TMenuItem
      Action = acAddLabeledItem
    end
    object AddImage2: TMenuItem
      Action = acAddImage
    end
    object acAddSeparator1: TMenuItem
      Action = acAddSeparator
    end
    object AddSplitter1: TMenuItem
      Action = acAddSplitter
    end
    object AddCheckBoxItem1: TMenuItem
      Action = acAddCheckBoxItem
    end
    object AddRadioButtonItem1: TMenuItem
      Action = acAddRadioButtonItem
    end
    object Delete1: TMenuItem
      Action = acAvailableItemsDelete
      SubMenuImages = ilActions
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object Rename2: TMenuItem
      Action = acAvailableItemRename
      ShortCut = 113
    end
  end
  object pmAddCustomItem: TPopupMenu
    Images = ilActions
    Left = 152
    Top = 360
    object AddEmptySpaceItem2: TMenuItem
      Action = acAddEmptySpaceItem
    end
    object acAddLabeledItem1: TMenuItem
      Action = acAddLabeledItem
    end
    object AddImage1: TMenuItem
      Action = acAddImage
    end
    object acAddSeparator2: TMenuItem
      Action = acAddSeparator
    end
    object acAddSplitter1: TMenuItem
      Action = acAddSplitter
    end
    object acAddCheckBoxItem1: TMenuItem
      Action = acAddCheckBoxItem
    end
    object acAddRadioButtonItem1: TMenuItem
      Action = acAddRadioButtonItem
    end
  end
end
