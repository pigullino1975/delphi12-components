object fmTreeViewEditor: TfmTreeViewEditor
  Left = 190
  Top = 158
  HelpContext = 26100
  BorderIcons = [biSystemMenu]
  Caption = 'TreeView Items Editor'
  ClientHeight = 383
  ClientWidth = 659
  Color = clBtnFace
  Constraints.MinHeight = 261
  Constraints.MinWidth = 550
  ParentFont = True
  OldCreateOrder = True
  ShowHint = True
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object dxLayoutControl1: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 633
    Height = 353
    TabOrder = 0
    CustomizeFormTabbedView = True
    object btNewItem: TButton
      Left = 172
      Top = 28
      Width = 125
      Height = 25
      Action = actNewItem
      Anchors = [akTop, akRight]
      Default = True
      TabOrder = 0
    end
    object btDeleteItem: TButton
      Left = 172
      Top = 90
      Width = 125
      Height = 25
      Action = actDelete
      TabOrder = 2
    end
    object btNewSubItem: TButton
      Left = 172
      Top = 59
      Width = 125
      Height = 25
      Action = actNewSubItem
      TabOrder = 1
    end
    object btOk: TButton
      Left = 197
      Top = 221
      Width = 75
      Height = 25
      Caption = 'OK'
      TabOrder = 10
      OnClick = btOkClick
    end
    object btCancel: TButton
      Left = 278
      Top = 221
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 11
      OnClick = btCancelClick
    end
    object btApply: TButton
      Left = 359
      Top = 221
      Width = 75
      Height = 25
      Caption = '&Apply'
      TabOrder = 12
      OnClick = btApplyItemsClick
    end
    object btHelp: TButton
      Left = 440
      Top = 221
      Width = 75
      Height = 25
      Caption = '&Help'
      TabOrder = 13
      OnClick = btHelpClick
    end
    object tvNodes: TdxTreeViewControl
      Left = 22
      Top = 28
      Width = 144
      Height = 175
      DragMode = dmAutomatic
      OptionsSelection.HideSelection = False
      TabOrder = 4
      OnCollapsed = tvNodesCollapsed
      OnDragDrop = tvNodesDragDrop
      OnDragOver = tvNodesDragOver
      OnEdited = tvNodesEdited
      OnExpanded = tvNodesExpanded
      OnFocusedNodeChanged = tvNodesFocusedNodeChanged
      OnKeyDown = tvNodesKeyDown
      OnNodeStateChanged = tvNodesNodeStateChanged
    end
    object btLoad: TButton
      Left = 172
      Top = 121
      Width = 125
      Height = 25
      Action = actLoad
      TabOrder = 3
    end
    object edItemCaption: TcxTextEdit
      Left = 415
      Top = 28
      Properties.OnChange = edItemCaptionPropertiesChange
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 5
      Width = 88
    end
    object edImageIndex: TcxTextEdit
      Left = 415
      Top = 55
      Properties.ValidationErrorIconAlignment = taRightJustify
      Properties.ValidationOptions = [evoShowErrorIcon]
      Properties.OnChange = edImageIndexPropertiesChange
      Properties.OnValidate = edImageIndexPropertiesValidate
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 6
      OnExit = edImageIndexExit
      Width = 39
    end
    object edStateImageIndex: TcxTextEdit
      Left = 415
      Top = 109
      Properties.ValidationErrorIconAlignment = taRightJustify
      Properties.ValidationOptions = [evoShowErrorIcon]
      Properties.OnChange = edImageIndexPropertiesChange
      Properties.OnValidate = edImageIndexPropertiesValidate
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 8
      OnExit = edStateImageIndexExit
      Width = 39
    end
    object edSelectedImageIndex: TcxTextEdit
      Left = 415
      Top = 82
      Properties.ValidationErrorIconAlignment = taRightJustify
      Properties.ValidationOptions = [evoShowErrorIcon]
      Properties.OnChange = edImageIndexPropertiesChange
      Properties.OnValidate = edImageIndexPropertiesValidate
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 7
      OnExit = edSelectedImageIndexExit
      Width = 39
    end
    object edExpandedImageIndex: TcxTextEdit
      Left = 415
      Top = 136
      Properties.ValidationErrorIconAlignment = taRightJustify
      Properties.ValidationOptions = [evoShowErrorIcon]
      Properties.OnChange = edImageIndexPropertiesChange
      Properties.OnValidate = edImageIndexPropertiesValidate
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 9
      OnExit = edExpandedImageIndexExit
      Width = 39
    end
    object dxLayoutControl1Group_Root: TdxLayoutGroup
      AlignHorz = ahLeft
      AlignVert = avTop
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
    object dxLayoutGroup3: TdxLayoutGroup
      Parent = lgItems
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = ' &Items '
      ButtonOptions.Buttons = <>
      ItemIndex = 1
      LayoutDirection = ldHorizontal
      Index = 0
    end
    object dxLayoutGroup4: TdxLayoutGroup
      Parent = dxLayoutAutoCreatedGroup1
      AlignHorz = ahRight
      AlignVert = avTop
      CaptionOptions.Text = 'Hidden Group'
      ButtonOptions.Buttons = <>
      Hidden = True
      ItemIndex = 2
      ShowBorder = False
      Index = 0
    end
    object dxLayoutItem2: TdxLayoutItem
      Parent = dxLayoutGroup4
      AlignHorz = ahRight
      CaptionOptions.Text = 'New'
      CaptionOptions.Visible = False
      Control = btNewItem
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 125
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem3: TdxLayoutItem
      Parent = dxLayoutGroup4
      AlignHorz = ahRight
      CaptionOptions.Text = 'NewSub'
      CaptionOptions.Visible = False
      Control = btNewSubItem
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 125
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem4: TdxLayoutItem
      Parent = dxLayoutGroup4
      AlignHorz = ahRight
      CaptionOptions.Text = 'Delete'
      CaptionOptions.Visible = False
      Control = btDeleteItem
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 125
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
      SizeOptions.Width = 200
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
      ItemIndex = 6
      ShowBorder = False
      Index = 0
    end
    object dxLayoutGroup7: TdxLayoutGroup
      Parent = dxLayoutGroup1
      AlignHorz = ahRight
      AlignVert = avBottom
      CaptionOptions.Text = 'Hidden Group'
      ButtonOptions.Buttons = <>
      Hidden = True
      ItemControlAreaAlignment = catAuto
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
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 75
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
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 75
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
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 75
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
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object lgItems: TdxLayoutGroup
      Parent = dxLayoutGroup1
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'Items'
      ButtonOptions.Buttons = <>
      Hidden = True
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 0
    end
    object dxLayoutItem1: TdxLayoutItem
      Parent = dxLayoutGroup3
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'New Item'
      CaptionOptions.Visible = False
      Control = tvNodes
      ControlOptions.OriginalHeight = 100
      ControlOptions.OriginalWidth = 144
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem14: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup1
      AlignHorz = ahRight
      CaptionOptions.Visible = False
      Control = btLoad
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 125
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutGroup3
      AlignHorz = ahRight
      Index = 0
    end
    object liNodeEnabled: TdxLayoutCheckBoxItem
      Parent = dxLayoutGroup6
      AlignHorz = ahLeft
      CaptionOptions.Text = 'E&nabled'
      State = cbsChecked
      OnClick = liNodeEnabledClick
      Index = 5
    end
    object dxLayoutItem15: TdxLayoutItem
      Parent = dxLayoutGroup6
      CaptionOptions.Text = '&Caption:'
      Control = edItemCaption
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 111
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem5: TdxLayoutItem
      Parent = dxLayoutGroup6
      AlignHorz = ahLeft
      CaptionOptions.Text = 'I&mage Index:'
      Control = edImageIndex
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 39
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem6: TdxLayoutItem
      Parent = dxLayoutGroup6
      AlignHorz = ahLeft
      CaptionOptions.Text = 'State Inde&x:'
      Control = edStateImageIndex
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 39
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object dxLayoutItem7: TdxLayoutItem
      Parent = dxLayoutGroup6
      AlignHorz = ahLeft
      CaptionOptions.Text = '&Selected Index:'
      Control = edSelectedImageIndex
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 39
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutItem8: TdxLayoutItem
      Parent = dxLayoutGroup6
      AlignHorz = ahLeft
      CaptionOptions.Text = '&Expanded Index:'
      Control = edExpandedImageIndex
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 39
      ControlOptions.ShowBorder = False
      Index = 4
    end
    object liNodeChecked: TdxLayoutCheckBoxItem
      Parent = dxLayoutGroup6
      AlignHorz = ahLeft
      Visible = False
      CaptionOptions.Text = 'C&hecked'
      OnClick = liNodeCheckedClick
      Index = 6
    end
  end
  object dxOpenFileDialog1: TdxOpenFileDialog
    Filter = 'All Files(*.*)|*.*'
    Left = 368
    Top = 65528
  end
  object ActionList1: TActionList
    Left = 448
    object actNewItem: TAction
      Caption = '&New Item'
      Hint = 'Add node'
      ShortCut = 45
      OnExecute = btNewItemClick
    end
    object actNewSubItem: TAction
      Caption = 'N&ew SubItem'
      Hint = 'Add child node'
      ShortCut = 8237
      OnExecute = btNewSubItemClick
    end
    object actDelete: TAction
      Caption = '&Delete'
      Hint = 'Delete node'
      OnExecute = btDeleteItemClick
    end
    object actLoad: TAction
      Caption = '&Load'
      Hint = 'Load nodes'
      ShortCut = 16463
      OnExecute = btLoadClick
    end
  end
end
