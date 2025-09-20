object dxRibbonCustomizationForm: TdxRibbonCustomizationForm
  Left = 246
  Top = 141
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Ribbon Customization'
  ClientHeight = 582
  ClientWidth = 739
  Color = clBtnFace
  Constraints.MinHeight = 300
  Constraints.MinWidth = 618
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lcMain: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 739
    Height = 582
    Align = alClient
    TabOrder = 0
    LayoutLookAndFeel = dxLayoutCxLookAndFeel
    CustomizeFormTabbedView = True
    object cbCommands: TcxComboBox
      Left = 10
      Top = 28
      Properties.DropDownListStyle = lsFixedList
      Properties.OnChange = cbCommandsPropertiesChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 0
      Width = 326
    end
    object btnMoveUp: TcxButton
      Left = 704
      Top = 241
      Width = 25
      Height = 25
      Action = acMoveUp
      OptionsImage.Glyph.SourceDPI = 96
      OptionsImage.Glyph.Data = {
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
        463B7D262331333B262331303B2623393B2E477265656E7B66696C6C3A233033
        394332333B7D262331333B262331303B2623393B2E426C75657B66696C6C3A23
        3131373744373B7D262331333B262331303B2623393B2E59656C6C6F777B6669
        6C6C3A234646423131353B7D262331333B262331303B2623393B2E426C61636B
        7B66696C6C3A233732373237323B7D262331333B262331303B2623393B2E5265
        647B66696C6C3A234431314331433B7D262331333B262331303B2623393B2E73
        74307B6F7061636974793A302E37353B7D262331333B262331303B2623393B2E
        7374317B6F7061636974793A302E353B7D3C2F7374796C653E0D0A3C67206964
        3D224172726F77315570223E0D0A09093C706F6C79676F6E20636C6173733D22
        426C75652220706F696E74733D22382C3020302C3820362C3820362C31362031
        302C31362031302C382031362C38202623393B222F3E0D0A093C2F673E0D0A3C
        2F7376673E0D0A}
      PaintStyle = bpsGlyph
      TabOrder = 11
    end
    object btnMoveDown: TcxButton
      Left = 704
      Top = 272
      Width = 25
      Height = 25
      Action = acMoveDown
      OptionsImage.Glyph.SourceDPI = 96
      OptionsImage.Glyph.Data = {
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
        463B7D262331333B262331303B2623393B2E477265656E7B66696C6C3A233033
        394332333B7D262331333B262331303B2623393B2E426C75657B66696C6C3A23
        3131373744373B7D262331333B262331303B2623393B2E59656C6C6F777B6669
        6C6C3A234646423131353B7D262331333B262331303B2623393B2E426C61636B
        7B66696C6C3A233732373237323B7D262331333B262331303B2623393B2E5265
        647B66696C6C3A234431314331433B7D262331333B262331303B2623393B2E73
        74307B6F7061636974793A302E37353B7D262331333B262331303B2623393B2E
        7374317B6F7061636974793A302E353B7D3C2F7374796C653E0D0A3C67206964
        3D224172726F7731446F776E223E0D0A09093C706F6C79676F6E20636C617373
        3D22426C75652220706F696E74733D22362C302031302C302031302C38203136
        2C3820382C313620302C3820362C38202623393B222F3E0D0A093C2F673E0D0A
        3C2F7376673E0D0A}
      PaintStyle = bpsGlyph
      TabOrder = 12
    end
    object btnRemove: TcxButton
      Left = 342
      Top = 272
      Width = 25
      Height = 25
      Action = acRemove
      OptionsImage.Glyph.SourceDPI = 144
      OptionsImage.Glyph.Data = {
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
        7B6F7061636974793A302E353B7D3C2F7374796C653E0D0A3C672069643D2241
        72726F77314C656674223E0D0A09093C706F6C79676F6E20636C6173733D2242
        6C75652220706F696E74733D2232382C31342031342C31342031342C31332E33
        2031342C3620342C31362031342C32362031342C31382E372031342C31382032
        382C3138202623393B222F3E0D0A093C2F673E0D0A3C2F7376673E0D0A}
      PaintStyle = bpsGlyph
      TabOrder = 3
    end
    object btnAdd: TcxButton
      Left = 342
      Top = 241
      Width = 25
      Height = 25
      Action = acAdd
      OptionsImage.Glyph.SourceDPI = 144
      OptionsImage.Glyph.Data = {
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
        7B6F7061636974793A302E353B7D3C2F7374796C653E0D0A3C672069643D2241
        72726F773152696768745F315F223E0D0A09093C7061746820636C6173733D22
        426C75652220643D224D342C3134683134762D302E3756366C31302C31304C31
        382C3236762D372E3356313848345631347A222F3E0D0A093C2F673E0D0A3C2F
        7376673E0D0A}
      PaintStyle = bpsGlyph
      TabOrder = 2
    end
    object btnNewElement: TcxButton
      Left = 373
      Top = 504
      Width = 75
      Height = 25
      Caption = '&Add'
      DropDownMenu = bpmNewElement
      Kind = cxbkOfficeDropDown
      OptionsImage.Layout = blGlyphTop
      TabOrder = 8
    end
    object btnRename: TcxButton
      Left = 454
      Top = 504
      Width = 75
      Height = 25
      Action = acRename
      TabOrder = 9
    end
    object btnImportExport: TcxButton
      Left = 603
      Top = 504
      Width = 95
      Height = 25
      Caption = 'Im&port/Export'
      DropDownMenu = bpmImportExport
      Kind = cxbkOfficeDropDown
      OptionsImage.Layout = blGlyphTop
      TabOrder = 10
    end
    object btnReset: TcxButton
      Left = 10
      Top = 547
      Width = 75
      Height = 25
      Caption = 'R&eset'
      DropDownMenu = bpmReset
      Kind = cxbkOfficeDropDown
      OptionsImage.Layout = blGlyphTop
      TabOrder = 13
    end
    object btnOK: TcxButton
      Left = 573
      Top = 547
      Width = 75
      Height = 25
      Caption = '&OK'
      Enabled = False
      ModalResult = 1
      TabOrder = 14
    end
    object btnCancel: TcxButton
      Left = 654
      Top = 547
      Width = 75
      Height = 25
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 15
    end
    object tlCommands: TcxTreeList
      Left = 10
      Top = 59
      Width = 326
      Height = 470
      Bands = <
        item
        end>
      DragMode = dmAutomatic
      Navigator.Buttons.CustomButtons = <>
      OptionsBehavior.CopyCaptionsToClipboard = False
      OptionsBehavior.IncSearchItem = tlCommandsMainColumn
      OptionsData.Editing = False
      OptionsData.Deleting = False
      OptionsSelection.HideFocusRect = False
      OptionsView.ColumnAutoWidth = True
      OptionsView.Headers = False
      OptionsView.ShowRoot = False
      OptionsView.TreeLineStyle = tllsNone
      ScrollbarAnnotations.CustomAnnotations = <>
      TabOrder = 1
      OnBeginDragNode = tlCommandsBeginDragNode
      OnClick = acUpdateActionsStateExecute
      OnCollapsing = tlCommandsCollapsing
      OnCustomDrawDataCell = tlCommandsCustomDrawDataCell
      OnDeletion = tlCommandsDeletion
      OnDragOver = tlCommandsDragOver
      OnEndDrag = tlCommandsEndDrag
      OnFocusedNodeChanged = tlCommandsFocusedNodeChanged
      object tlCommandsMainColumn: TcxTreeListColumn
        Position.ColIndex = 0
        Position.RowIndex = 0
        Position.BandIndex = 0
        Summary.FooterSummaryItems = <>
        Summary.GroupFooterSummaryItems = <>
      end
    end
    object tlRibbon: TcxTreeList
      Left = 373
      Top = 118
      Width = 325
      Height = 380
      Bands = <
        item
        end>
      DragMode = dmAutomatic
      Navigator.Buttons.CustomButtons = <>
      OptionsBehavior.CopyCaptionsToClipboard = False
      OptionsBehavior.DragFocusing = True
      OptionsData.Editing = False
      OptionsData.Deleting = False
      OptionsSelection.HideFocusRect = False
      OptionsView.ColumnAutoWidth = True
      OptionsView.CheckGroups = True
      OptionsView.Headers = False
      OptionsView.ShowRoot = False
      OptionsView.TreeLineStyle = tllsNone
      PopupMenu = bpmRibbon
      ScrollbarAnnotations.CustomAnnotations = <>
      Styles.OnGetContentStyle = tlRibbonStylesGetContentStyle
      TabOrder = 7
      OnBeginDragNode = tlCommandsBeginDragNode
      OnClick = acUpdateActionsStateExecute
      OnCollapsing = tlCommandsCollapsing
      OnCustomDrawDataCell = tlCommandsCustomDrawDataCell
      OnDeletion = tlCommandsDeletion
      OnDragOver = tlRibbonDragOver
      OnEndDrag = tlCommandsEndDrag
      OnFocusedNodeChanged = tlCommandsFocusedNodeChanged
      OnMoveTo = tlRibbonMoveTo
      OnNodeCheckChanged = tlRibbonNodeCheckChanged
      object tlRibbonMainColumn: TcxTreeListColumn
        DataBinding.ValueType = 'String'
        Position.ColIndex = 0
        Position.RowIndex = 0
        Position.BandIndex = 0
        Summary.FooterSummaryItems = <>
        Summary.GroupFooterSummaryItems = <>
      end
    end
    object chbShowQATBelowRibbon: TcxCheckBox
      Left = 373
      Top = 82
      Caption = 'Show Quick Access Toolbar below the Ribbon'
      Properties.OnChange = chbShowQATBelowRibbonPropertiesChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 6
      Transparent = True
    end
    object lbRibbonQAT: TcxLabel
      Left = 373
      Top = 59
      Caption = 'Customize &Quick Access Toolbar:'
      Style.HotTrack = False
      Style.TransparentBorder = False
      Properties.Alignment.Vert = taVCenter
      Transparent = True
      Height = 17
      Width = 325
      AnchorY = 68
    end
    object cbRibbon: TcxComboBox
      Left = 373
      Top = 28
      Properties.DropDownListStyle = lsFixedList
      Properties.OnChange = cbRibbonPropertiesChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 4
      Width = 325
    end
    object lcMainGroup_Root: TdxLayoutGroup
      AlignHorz = ahClient
      AlignVert = avClient
      LayoutLookAndFeel = dxLayoutCxLookAndFeel
      Hidden = True
      ItemIndex = 2
      ShowBorder = False
      Index = -1
    end
    object lciCommandsSource: TdxLayoutItem
      Parent = lcgCommands
      AlignVert = avTop
      LayoutLookAndFeel = dxLayoutCxLookAndFeel
      CaptionOptions.Text = 'C&hoose commands from:'
      CaptionOptions.Layout = clTop
      Control = cbCommands
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 326
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lciMoveUp: TdxLayoutItem
      Parent = lcgReordering
      LayoutLookAndFeel = dxLayoutCxLookAndFeel
      CaptionOptions.Text = 'cxButton1'
      CaptionOptions.Visible = False
      Control = btnMoveUp
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 25
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lciMoveDown: TdxLayoutItem
      Parent = lcgReordering
      LayoutLookAndFeel = dxLayoutCxLookAndFeel
      CaptionOptions.Text = 'cxButton2'
      CaptionOptions.Visible = False
      Control = btnMoveDown
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 25
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lciRemove: TdxLayoutItem
      Parent = lcgActions
      LayoutLookAndFeel = dxLayoutCxLookAndFeel
      CaptionOptions.Text = 'cxButton3'
      CaptionOptions.Visible = False
      Control = btnRemove
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 25
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lciAdd: TdxLayoutItem
      Parent = lcgActions
      LayoutLookAndFeel = dxLayoutCxLookAndFeel
      CaptionOptions.Text = 'cxButton4'
      CaptionOptions.Visible = False
      Control = btnAdd
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 25
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lciNewElement: TdxLayoutItem
      Parent = lcgRibbonActions
      AlignHorz = ahLeft
      LayoutLookAndFeel = dxLayoutCxLookAndFeel
      CaptionOptions.Text = 'cxButton5'
      CaptionOptions.Visible = False
      Control = btnNewElement
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lciRename: TdxLayoutItem
      Parent = lcgRibbonActions
      AlignHorz = ahLeft
      LayoutLookAndFeel = dxLayoutCxLookAndFeel
      CaptionOptions.Text = 'cxButton6'
      CaptionOptions.Visible = False
      Control = btnRename
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lciImportExport: TdxLayoutItem
      Parent = lcgRibbonActions
      AlignHorz = ahRight
      LayoutLookAndFeel = dxLayoutCxLookAndFeel
      Visible = False
      CaptionOptions.Text = 'cxButton7'
      CaptionOptions.Visible = False
      Control = btnImportExport
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 95
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object lciReset: TdxLayoutItem
      Parent = lcgControlling
      AlignHorz = ahLeft
      LayoutLookAndFeel = dxLayoutCxLookAndFeel
      CaptionOptions.Text = 'cxButton8'
      CaptionOptions.Visible = False
      Control = btnReset
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lciOK: TdxLayoutItem
      Parent = lcgControlling
      AlignHorz = ahRight
      LayoutLookAndFeel = dxLayoutCxLookAndFeel
      CaptionOptions.Text = 'cxButton9'
      CaptionOptions.Visible = False
      Control = btnOK
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Enabled = False
      Index = 1
    end
    object lciCancel: TdxLayoutItem
      Parent = lcgControlling
      AlignHorz = ahRight
      LayoutLookAndFeel = dxLayoutCxLookAndFeel
      CaptionOptions.Text = 'cxButton10'
      CaptionOptions.Visible = False
      Control = btnCancel
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object lcgCommands: TdxLayoutGroup
      Parent = lcgEditing
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'New Group'
      LayoutLookAndFeel = dxLayoutCxLookAndFeel
      Hidden = True
      ShowBorder = False
      Index = 0
    end
    object lcgActions: TdxLayoutGroup
      Parent = lcgEditing
      AlignHorz = ahLeft
      AlignVert = avCenter
      CaptionOptions.Text = 'New Group'
      LayoutLookAndFeel = dxLayoutCxLookAndFeel
      Hidden = True
      ShowBorder = False
      Index = 1
    end
    object lcgControlling: TdxLayoutGroup
      Parent = lcMainGroup_Root
      AlignHorz = ahClient
      AlignVert = avBottom
      CaptionOptions.Text = 'New Group'
      LayoutLookAndFeel = dxLayoutCxLookAndFeel
      Hidden = True
      ItemIndex = 2
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 2
    end
    object lcgEditing: TdxLayoutGroup
      Parent = lcMainGroup_Root
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'New Group'
      LayoutLookAndFeel = dxLayoutCxLookAndFeel
      Hidden = True
      ItemIndex = 3
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 0
    end
    object lcgRibbon: TdxLayoutGroup
      Parent = lcgEditing
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'New Group'
      LayoutLookAndFeel = dxLayoutCxLookAndFeel
      Hidden = True
      ItemIndex = 4
      ShowBorder = False
      Index = 2
    end
    object lcgRibbonActions: TdxLayoutGroup
      Parent = lcgRibbon
      AlignHorz = ahClient
      AlignVert = avBottom
      CaptionOptions.Text = 'New Group'
      LayoutLookAndFeel = dxLayoutCxLookAndFeel
      Hidden = True
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 4
    end
    object lciSeparator: TdxLayoutSeparatorItem
      Parent = lcMainGroup_Root
      LayoutLookAndFeel = dxLayoutCxLookAndFeel
      SizeOptions.AssignedValues = [sovSizableHorz, sovSizableVert]
      SizeOptions.SizableHorz = False
      SizeOptions.SizableVert = False
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object lcgReordering: TdxLayoutGroup
      Parent = lcgEditing
      AlignHorz = ahRight
      AlignVert = avCenter
      CaptionOptions.Text = 'New Group'
      LayoutLookAndFeel = dxLayoutCxLookAndFeel
      Hidden = True
      ShowBorder = False
      Index = 3
    end
    object lciCommands: TdxLayoutItem
      Parent = lcgCommands
      AlignVert = avClient
      LayoutLookAndFeel = dxLayoutCxLookAndFeel
      Control = tlCommands
      ControlOptions.OriginalHeight = 474
      ControlOptions.OriginalWidth = 326
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lciRibbon: TdxLayoutItem
      Parent = lcgRibbon
      AlignVert = avClient
      LayoutLookAndFeel = dxLayoutCxLookAndFeel
      Control = tlRibbon
      ControlOptions.OriginalHeight = 397
      ControlOptions.OriginalWidth = 325
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object lciShowQATBelowRibbon: TdxLayoutItem
      Parent = lcgRibbon
      CaptionOptions.Text = 'lciShowQATBelowRibbon'
      CaptionOptions.Visible = False
      CaptionOptions.Layout = clTop
      Control = chbShowQATBelowRibbon
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 325
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object lciRibbonQAT: TdxLayoutItem
      Parent = lcgRibbon
      CaptionOptions.Text = 'cxLabel1'
      CaptionOptions.Visible = False
      Control = lbRibbonQAT
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 325
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lciRibbonSource: TdxLayoutItem
      Parent = lcgRibbon
      AlignVert = avTop
      LayoutLookAndFeel = dxLayoutCxLookAndFeel
      Visible = False
      CaptionOptions.Text = 'Customize the Ri&bbon:'
      CaptionOptions.Layout = clTop
      Control = cbRibbon
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 325
      ControlOptions.ShowBorder = False
      Index = 0
    end
  end
  object alActions: TActionList
    Left = 208
    object acAddNewContext: TAction
      Caption = 'Add New &Context'
      OnExecute = acAddNewContextExecute
    end
    object acAddNewTab: TAction
      Caption = 'Add New &Tab'
      OnExecute = acAddNewTabExecute
    end
    object acAddNewGroup: TAction
      Caption = 'Add New &Group'
      OnExecute = acAddNewGroupExecute
    end
    object acAdd: TAction
      Caption = '&Add'
      OnExecute = acAddExecute
    end
    object acRemove: TAction
      Caption = '&Remove'
      ShortCut = 46
      OnExecute = acRemoveExecute
    end
    object acRename: TAction
      Caption = 'Rena&me...'
      ShortCut = 113
      OnExecute = acRenameExecute
    end
    object acShowTab: TAction
      AutoCheck = True
      Caption = '&Show Tab'
      OnExecute = acShowTabExecute
    end
    object acResetAllCustomizations: TAction
      Caption = 'Reset a&ll customizations'
      OnExecute = acResetAllCustomizationsExecute
    end
    object acResetSelectedTab: TAction
      Caption = 'Reset Ta&b'
      OnExecute = acResetSelectedTabExecute
    end
    object acMoveUp: TAction
      Caption = 'Move &Up'
      OnExecute = acMoveUpExecute
    end
    object acMoveDown: TAction
      Caption = 'Move &Down'
      OnExecute = acMoveDownExecute
    end
    object acUpdateActionsState: TAction
      Caption = 'UpdateActionsState'
      OnExecute = acUpdateActionsStateExecute
    end
  end
  object dxLayoutLookAndFeelList: TdxLayoutLookAndFeelList
    Left = 240
    object dxLayoutCxLookAndFeel: TdxLayoutCxLookAndFeel
      PixelsPerInch = 96
    end
  end
  object bmMain: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    PopupMenuLinks = <>
    Style = bmsUseLookAndFeel
    UseSystemFont = True
    Left = 272
    PixelsPerInch = 96
    object bbtnNewContext: TdxBarButton
      Action = acAddNewContext
      Category = 0
    end
    object bbtnNewTab: TdxBarButton
      Action = acAddNewTab
      Category = 0
    end
    object bbtnNewGroup: TdxBarButton
      Action = acAddNewGroup
      Category = 0
    end
    object bsUpperSeparator: TdxBarSeparator
      Caption = 'Upper separator'
      Category = 0
      Hint = 'Upper separator'
      Visible = ivAlways
      ShowCaption = False
    end
    object bbtnRemove: TdxBarButton
      Action = acRemove
      Category = 0
    end
    object bbtnRename: TdxBarButton
      Action = acRename
      Category = 0
    end
    object bbtnResetTab: TdxBarButton
      Action = acResetSelectedTab
      Category = 0
    end
    object bbtnShowTab: TdxBarButton
      Action = acShowTab
      Category = 0
      ButtonStyle = bsChecked
    end
    object bsLowerSeparator: TdxBarSeparator
      Caption = 'Lower separator'
      Category = 0
      Hint = 'Lower separator'
      Visible = ivAlways
      ShowCaption = False
    end
    object bbtnMoveUp: TdxBarButton
      Action = acMoveUp
      Category = 0
    end
    object bbtnMoveDown: TdxBarButton
      Action = acMoveDown
      Category = 0
    end
    object bbtnResetOnlySelectedTab: TdxBarButton
      Action = acResetSelectedTab
      Caption = 'Reset only &selected tab'
      Category = 0
    end
    object bbtnResetAllCustomizations: TdxBarButton
      Action = acResetAllCustomizations
      Category = 0
    end
    object bbtnImportCustomizationFile: TdxBarButton
      Caption = 'Import customization file'
      Category = 0
      Hint = 'Import customization file'
      Visible = ivAlways
    end
    object bbtnExportAllCustomizations: TdxBarButton
      Caption = 'Export all customizations'
      Category = 0
      Hint = 'Export all customizations'
      Visible = ivAlways
    end
  end
  object bpmRibbon: TdxBarPopupMenu
    BarManager = bmMain
    ItemLinks = <
      item
        Visible = True
        ItemName = 'bbtnNewTab'
      end
      item
        Visible = True
        ItemName = 'bbtnNewGroup'
      end
      item
        Visible = True
        ItemName = 'bsUpperSeparator'
      end
      item
        Visible = True
        ItemName = 'bbtnRename'
      end
      item
        Visible = True
        ItemName = 'bbtnShowTab'
      end
      item
        Visible = True
        ItemName = 'bbtnResetTab'
      end
      item
        Visible = True
        ItemName = 'bbtnRemove'
      end
      item
        Visible = True
        ItemName = 'bsLowerSeparator'
      end
      item
        Visible = True
        ItemName = 'bbtnMoveUp'
      end
      item
        Visible = True
        ItemName = 'bbtnMoveDown'
      end>
    UseOwnFont = False
    OnPopup = acUpdateActionsStateExecute
    Left = 384
    Top = 112
    PixelsPerInch = 96
  end
  object bpmReset: TdxBarPopupMenu
    BarManager = bmMain
    ItemLinks = <
      item
        Visible = True
        ItemName = 'bbtnResetOnlySelectedTab'
      end
      item
        Visible = True
        ItemName = 'bbtnResetAllCustomizations'
      end>
    UseOwnFont = False
    OnPopup = acUpdateActionsStateExecute
    Left = 84
    Top = 547
    PixelsPerInch = 96
  end
  object bpmNewElement: TdxBarPopupMenu
    BarManager = bmMain
    ItemLinks = <
      item
        Visible = True
        ItemName = 'bbtnNewTab'
      end
      item
        Visible = True
        ItemName = 'bbtnNewGroup'
      end>
    UseOwnFont = False
    OnPopup = acUpdateActionsStateExecute
    Left = 420
    Top = 528
    PixelsPerInch = 96
  end
  object bpmImportExport: TdxBarPopupMenu
    BarManager = bmMain
    ItemLinks = <
      item
        Visible = True
        ItemName = 'bbtnImportCustomizationFile'
      end
      item
        Visible = True
        ItemName = 'bbtnExportAllCustomizations'
      end>
    UseOwnFont = False
    OnPopup = acUpdateActionsStateExecute
    Left = 670
    Top = 528
    PixelsPerInch = 96
  end
  object cxStyleRepository: TcxStyleRepository
    Left = 304
    PixelsPerInch = 96
    object stNodeDisabled: TcxStyle
    end
  end
end
