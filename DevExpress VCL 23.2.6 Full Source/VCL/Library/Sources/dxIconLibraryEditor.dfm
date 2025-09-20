inherited dxfmImagePicker: TdxfmImagePicker
  ActiveControl = nil
  ClientHeight = 707
  ClientWidth = 746
  Constraints.MinHeight = 576
  Constraints.MinWidth = 720
  OnClose = dxFormClose
  OnShortCut = FormShortCut
  PixelsPerInch = 96
  TextHeight = 13
  inherited lcMain: TdxLayoutControl
    Width = 746
    Height = 707
    inherited btnImport: TcxButton
      Left = 10000
      Top = 10000
      Visible = False
    end
    inherited btnClear: TcxButton
      Left = 10000
      Top = 10000
      Visible = False
    end
    inherited btnSave: TcxButton
      Left = 10000
      Top = 10000
      Visible = False
    end
    inherited btnLoad: TcxButton
      Left = 10000
      Top = 10000
      Visible = False
    end
    inherited btnCancel: TcxButton
      Left = 661
      Top = 671
      TabOrder = 29
    end
    inherited btnOk: TcxButton
      Left = 580
      Top = 671
      TabOrder = 28
    end
    inherited pnlImagePaintBox: TPanel
      Left = 10000
      Top = 10000
      Width = 590
      Height = 505
      Visible = False
      inherited ImagePaintBox: TPaintBox
        Width = 588
        Height = 503
      end
    end
    object clbCategories: TcxCheckListBox [7]
      AlignWithMargins = True
      Left = 10000
      Top = 10000
      Width = 169
      Height = 278
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 6
      EditValueFormat = cvfStatesString
      Items = <>
      PopupMenu = pmSelection
      Sorted = True
      Style.StyleController = EditStyleController
      Style.TransparentBorder = False
      TabOrder = 11
      Visible = False
      OnClickCheck = clbCategoriesClickCheck
    end
    object clbSize: TcxCheckListBox [8]
      AlignWithMargins = True
      Left = 10000
      Top = 10000
      Width = 169
      Height = 60
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 6
      EditValueFormat = cvfStatesString
      Items = <>
      PopupMenu = pmSelection
      Style.StyleController = EditStyleController
      Style.TransparentBorder = False
      TabOrder = 12
      Visible = False
      OnClickCheck = clbSizeClickCheck
    end
    object clbCollection: TcxCheckListBox [9]
      AlignWithMargins = True
      Left = 10000
      Top = 10000
      Width = 169
      Height = 90
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 6
      Items = <>
      PopupMenu = pmSelection
      Style.StyleController = EditStyleController
      Style.TransparentBorder = False
      TabOrder = 15
      Visible = False
      OnClickCheck = clbCollectionClickCheck
    end
    object gcIcons: TdxGalleryControl [10]
      Left = 10000
      Top = 10000
      Width = 523
      Height = 499
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 6
      Margins.Bottom = 6
      DragMode = dmAutomatic
      PopupMenu = pmIconGallery
      Visible = False
      Images = ilImages
      LookAndFeel.RenderMode = rmDirectX
      OptionsBehavior.ItemCheckMode = icmSingleRadio
      OptionsBehavior.ItemMultiSelectKind = imskListView
      OptionsBehavior.ItemShowHint = True
      OptionsBehavior.SelectOnRightClick = True
      OptionsView.ColumnAutoWidth = True
      OptionsView.Item.Image.ShowFrame = False
      TabOrder = 17
      OnDblClick = gcIconsDblClick
    end
    object beFind: TcxButtonEdit [11]
      Left = 10000
      Top = 10000
      Properties.Buttons = <
        item
          Default = True
          ImageIndex = 0
          Kind = bkGlyph
        end>
      Properties.Images = ilImages
      Properties.OnButtonClick = beFindPropertiesButtonClick
      Properties.OnChange = beFindPropertiesChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 16
      Visible = False
      Width = 192
    end
    object gcSelection: TdxGalleryControl [12]
      Left = 10
      Top = 617
      Width = 726
      Height = 48
      DragMode = dmAutomatic
      PopupMenu = pmIconsSelection
      OptionsBehavior.ItemCheckMode = icmMultiple
      OptionsBehavior.ItemMultiSelectKind = imskListView
      OptionsBehavior.ItemShowHint = True
      OptionsBehavior.SelectOnRightClick = True
      OptionsView.Item.Image.ShowFrame = False
      TabOrder = 27
      OnDblClick = miIconsSelectionDeleteSelectedClick
      OnDragDrop = gcSelectionDragDrop
      OnDragOver = gcSelectionDragOver
      object gcSelectionGroup: TdxGalleryControlGroup
        Caption = 'Group0'
        ShowCaption = False
      end
    end
    object gcIconsFont: TdxGalleryControl [13]
      Left = 24
      Top = 80
      Width = 698
      Height = 441
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 6
      Margins.Bottom = 6
      DragMode = dmAutomatic
      PopupMenu = pmIconGallery
      LookAndFeel.RenderMode = rmDirectX
      OptionsBehavior.ItemCheckMode = icmSingleRadio
      OptionsBehavior.ItemMultiSelectKind = imskListView
      OptionsBehavior.ItemShowHint = True
      OptionsBehavior.SelectOnRightClick = True
      OptionsView.ColumnAutoWidth = True
      OptionsView.Item.Image.ShowFrame = False
      OptionsView.Item.Text.Position = posBottom
      TabOrder = 19
      OnDblClick = gcIconsFontDblClick
      object FontItemsDefaultGroup: TdxGalleryControlGroup
      end
      object FontIconsHiddenGroup: TdxGalleryControlGroup
        ShowCaption = False
        Visible = False
      end
    end
    object beFindFontIcons: TcxButtonEdit [14]
      Left = 530
      Top = 44
      Properties.Buttons = <
        item
          Default = True
          ImageIndex = 0
          Kind = bkGlyph
        end>
      Properties.Images = ilImages
      Properties.OnButtonClick = beFontIconsFindProperties
      Properties.OnChange = beFontIconsFindPropertiesChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 18
      Width = 192
    end
    object btnColorBlack: TcxButton [15]
      Left = 542
      Top = 527
      Width = 25
      Height = 25
      OptionsImage.ImageIndex = 0
      OptionsImage.Images = ilStandartColors
      SpeedButtonOptions.GroupIndex = 1
      TabOrder = 21
      OnClick = btnColorClick
    end
    object btnColorRed: TcxButton [16]
      Left = 573
      Top = 527
      Width = 25
      Height = 25
      OptionsImage.ImageIndex = 1
      OptionsImage.Images = ilStandartColors
      SpeedButtonOptions.GroupIndex = 1
      TabOrder = 22
      OnClick = btnColorClick
    end
    object btnColorGreen: TcxButton [17]
      Left = 604
      Top = 527
      Width = 25
      Height = 25
      OptionsImage.ImageIndex = 2
      OptionsImage.Images = ilStandartColors
      SpeedButtonOptions.GroupIndex = 1
      TabOrder = 23
      OnClick = btnColorClick
    end
    object btnColorBlue: TcxButton [18]
      Left = 635
      Top = 527
      Width = 25
      Height = 25
      OptionsImage.ImageIndex = 3
      OptionsImage.Images = ilStandartColors
      SpeedButtonOptions.GroupIndex = 1
      TabOrder = 24
      OnClick = btnColorClick
    end
    object btnColorYellow: TcxButton [19]
      Left = 666
      Top = 527
      Width = 25
      Height = 25
      OptionsImage.ImageIndex = 4
      OptionsImage.Images = ilStandartColors
      SpeedButtonOptions.GroupIndex = 1
      TabOrder = 25
      OnClick = btnColorClick
    end
    object btnColorWhite: TcxButton [20]
      Left = 697
      Top = 527
      Width = 25
      Height = 25
      OptionsImage.ImageIndex = 5
      OptionsImage.Images = ilStandartColors
      SpeedButtonOptions.GroupIndex = 1
      TabOrder = 26
      OnClick = btnColorClick
    end
    object btnAddLibraryCollectionRaster: TcxButton [21]
      Left = 10000
      Top = 10000
      Width = 25
      Height = 25
      Action = actAddLibraryCollection
      OptionsImage.ImageIndex = 0
      OptionsImage.Images = ilCollections
      ParentShowHint = False
      ShowHint = True
      SpeedButtonOptions.CanBeFocused = False
      SpeedButtonOptions.Flat = True
      TabOrder = 13
      Visible = False
    end
    object btnRemoveFolderRaster: TcxButton [22]
      Left = 10000
      Top = 10000
      Width = 25
      Height = 25
      Action = actRemoveCollectionRaster
      OptionsImage.ImageIndex = 1
      OptionsImage.Images = ilCollections
      ParentShowHint = False
      ShowHint = True
      SpeedButtonOptions.CanBeFocused = False
      SpeedButtonOptions.Flat = True
      TabOrder = 14
      Visible = False
    end
    object gcIconsVector: TdxGalleryControl [23]
      Left = 10000
      Top = 10000
      Width = 523
      Height = 499
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 6
      Margins.Bottom = 6
      DragMode = dmAutomatic
      PopupMenu = pmIconGallery
      Visible = False
      Images = ilImages
      LookAndFeel.RenderMode = rmDirectX
      OptionsBehavior.ItemCheckMode = icmSingleRadio
      OptionsBehavior.ItemMultiSelectKind = imskListView
      OptionsBehavior.ItemShowHint = True
      OptionsBehavior.SelectOnRightClick = True
      OptionsView.ColumnAutoWidth = True
      OptionsView.Item.Image.ShowFrame = False
      OptionsView.Item.Image.Size.Height = 32
      OptionsView.Item.Image.Size.Width = 32
      TabOrder = 10
      OnDblClick = gcIconsDblClick
    end
    object clbCategoriesVector: TcxCheckListBox [24]
      AlignWithMargins = True
      Left = 10000
      Top = 10000
      Width = 169
      Height = 371
      EditValueFormat = cvfStatesString
      Items = <>
      PopupMenu = pmSelection
      Sorted = True
      Style.HotTrack = False
      Style.StyleController = EditStyleController
      Style.TransparentBorder = False
      TabOrder = 5
      Visible = False
      OnClickCheck = clbCategoriesVectorClickCheck
    end
    object clbCollectionVector: TcxCheckListBox [25]
      AlignWithMargins = True
      Left = 10000
      Top = 10000
      Width = 169
      Height = 97
      EditValueFormat = cvfStatesString
      Items = <>
      PopupMenu = pmSelection
      Sorted = True
      Style.HotTrack = False
      Style.StyleController = EditStyleController
      Style.TransparentBorder = False
      TabOrder = 8
      Visible = False
      OnClickCheck = clbCollectionVectorClickCheck
    end
    object beFindVector: TcxButtonEdit [26]
      Left = 10000
      Top = 10000
      Properties.Buttons = <
        item
          Default = True
          ImageIndex = 0
          Kind = bkGlyph
        end>
      Properties.Images = ilImages
      Properties.OnButtonClick = beFindPropertiesButtonClick
      Properties.OnChange = beFindPropertiesChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 9
      Visible = False
      Width = 192
    end
    object btnRemoveFolderVector: TcxButton [27]
      Left = 10000
      Top = 10000
      Width = 25
      Height = 25
      Action = actRemoveCollectionVector
      OptionsImage.ImageIndex = 1
      OptionsImage.Images = ilCollections
      ParentShowHint = False
      ShowHint = True
      SpeedButtonOptions.CanBeFocused = False
      SpeedButtonOptions.Flat = True
      TabOrder = 7
      Visible = False
    end
    object btnAddCollectionVector: TcxButton [28]
      Left = 10000
      Top = 10000
      Width = 25
      Height = 25
      Action = actAddLibraryCollection
      OptionsImage.ImageIndex = 0
      OptionsImage.Images = ilCollections
      ParentShowHint = False
      ShowHint = True
      SpeedButtonOptions.CanBeFocused = False
      SpeedButtonOptions.Flat = True
      TabOrder = 6
      Visible = False
    end
    object lblNotes: TdxFormattedLabel [29]
      Left = 24
      Top = 527
      Caption = 
        '[B]NOTE[/B]: Developer Express Inc does not embed, include, or d' +
        'istribute this icon font set. You must independently review and ' +
        'agree to [URL=https://www.devexpress.com/go/Microsoft_FontIcons.' +
        'aspx]license[/URL] 3rd party icon collections from their respect' +
        'ive owners. Use these icon fonts only if client machines run Mic' +
        'rosoft Windows'#174' 10 or newer.'
      Style.HotTrack = False
      Style.TransparentBorder = False
      Properties.WordWrap = True
      Transparent = True
      Width = 391
    end
    inherited lgTopGroup: TdxLayoutGroup
      LayoutDirection = ldVertical
    end
    inherited lgMainPageControl: TdxLayoutGroup
      ItemIndex = 3
      OnTabChanged = lgMainPageControlTabChanged
    end
    inherited lgBottomGroup: TdxLayoutGroup
      ItemIndex = 1
    end
    inherited dxLayoutItem12: TdxLayoutItem
      AlignVert = avBottom
    end
    inherited dxLayoutItem13: TdxLayoutItem
      AlignVert = avBottom
    end
    object lgtsFontIcons: TdxLayoutGroup
      Parent = lgMainPageControl
      CaptionOptions.Text = 'Font Icons'
      Index = 3
    end
    object lgtsDXRasterImageGallery: TdxLayoutGroup
      Parent = lgMainPageControl
      CaptionOptions.Text = 'Raster Icons'
      Index = 2
    end
    object lgFontIcons: TdxLayoutGroup
      Parent = lgtsFontIcons
      AlignVert = avClient
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      ItemIndex = 2
      ShowBorder = False
      Index = 0
    end
    object liFontIconsFind: TdxLayoutItem
      Parent = lgFontIcons
      AlignHorz = ahRight
      CaptionOptions.Text = 'New Item'
      CaptionOptions.Visible = False
      Control = beFindFontIcons
      ControlOptions.OriginalHeight = 24
      ControlOptions.OriginalWidth = 192
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object liFontIcons: TdxLayoutItem
      Parent = lgFontIcons
      AlignVert = avClient
      AlignmentConstraint = AlignmentConstraint1
      CaptionOptions.Text = 'New Item'
      CaptionOptions.Visible = False
      Control = gcIconsFont
      ControlOptions.OriginalHeight = 271
      ControlOptions.OriginalWidth = 589
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutGroup3: TdxLayoutGroup
      Parent = dxLayoutAutoCreatedGroup2
      AlignHorz = ahRight
      AlignVert = avTop
      CaptionOptions.Text = 'Color Group'
      CaptionOptions.Visible = False
      SizeOptions.AssignedValues = [sovSizableHorz]
      SizeOptions.SizableHorz = True
      SizeOptions.Width = 239
      Hidden = True
      ItemIndex = 6
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 2
    end
    object dxLayoutLabeledItem1: TdxLayoutLabeledItem
      Parent = dxLayoutGroup3
      AlignVert = avClient
      CaptionOptions.Text = 'Icon Color:'
      Index = 0
    end
    object dxLayoutItem1: TdxLayoutItem
      Parent = dxLayoutGroup3
      AlignVert = avBottom
      CaptionOptions.Text = 'cxButton1'
      CaptionOptions.Visible = False
      Control = btnColorBlack
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 25
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem2: TdxLayoutItem
      Parent = dxLayoutGroup3
      AlignVert = avClient
      CaptionOptions.Text = 'cxButton2'
      CaptionOptions.Visible = False
      Control = btnColorRed
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 25
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutItem3: TdxLayoutItem
      Parent = dxLayoutGroup3
      AlignVert = avClient
      CaptionOptions.Visible = False
      Control = btnColorGreen
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 25
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object dxLayoutItem4: TdxLayoutItem
      Parent = dxLayoutGroup3
      AlignVert = avClient
      CaptionOptions.Visible = False
      Control = btnColorBlue
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 25
      ControlOptions.ShowBorder = False
      Index = 4
    end
    object dxLayoutItem5: TdxLayoutItem
      Parent = dxLayoutGroup3
      AlignVert = avClient
      CaptionOptions.Visible = False
      Control = btnColorYellow
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 25
      ControlOptions.ShowBorder = False
      Index = 5
    end
    object dxLayoutItem6: TdxLayoutItem
      Parent = dxLayoutGroup3
      AlignVert = avClient
      CaptionOptions.Visible = False
      Control = btnColorWhite
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 25
      ControlOptions.ShowBorder = False
      Index = 6
    end
    object dxLayoutGroup2: TdxLayoutGroup
      Parent = lgtsDXRasterImageGallery
      AlignVert = avClient
      CaptionOptions.Text = 'New Group'
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 0
    end
    object dxLayoutGroup1: TdxLayoutGroup
      Parent = dxLayoutGroup2
      CaptionOptions.Text = 'New Group'
      ItemIndex = 6
      ShowBorder = False
      Index = 0
    end
    object liPadding1: TdxLayoutEmptySpaceItem
      Parent = dxLayoutGroup1
      SizeOptions.Height = 10
      Index = 0
    end
    object lbCategories: TdxLayoutLabeledItem
      Parent = dxLayoutGroup1
      CaptionOptions.Text = 'Categories:'
      Index = 1
    end
    object liCategories: TdxLayoutItem
      Parent = dxLayoutGroup1
      AlignHorz = ahClient
      AlignVert = avClient
      AlignmentConstraint = AlignmentConstraint1
      Control = clbCategories
      ControlOptions.OriginalHeight = 84
      ControlOptions.OriginalWidth = 169
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutSplitterItem2: TdxLayoutSplitterItem
      Parent = dxLayoutGroup1
      SizeOptions.AssignedValues = [sovSizableHorz, sovSizableVert]
      SizeOptions.SizableHorz = False
      SizeOptions.SizableVert = False
      CaptionOptions.Text = 'Splitter'
      Index = 3
    end
    object liSize: TdxLayoutItem
      Parent = dxLayoutGroup1
      AlignVert = avTop
      CaptionOptions.Text = 'Size:'
      CaptionOptions.Layout = clTop
      Control = clbSize
      ControlOptions.OriginalHeight = 60
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 4
    end
    object dxLayoutSplitterItem1: TdxLayoutSplitterItem
      Parent = dxLayoutGroup1
      SizeOptions.AssignedValues = [sovSizableHorz, sovSizableVert]
      SizeOptions.SizableHorz = False
      SizeOptions.SizableVert = False
      CaptionOptions.Text = 'Splitter'
      Index = 5
    end
    object liCollections: TdxLayoutItem
      Parent = dxLayoutGroup5
      AlignVert = avBottom
      CaptionOptions.Visible = False
      Control = clbCollection
      ControlOptions.OriginalHeight = 90
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutGroup2
      AlignHorz = ahClient
      Index = 1
    end
    object liSearchBox: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup4
      AlignHorz = ahRight
      Control = beFind
      ControlOptions.OriginalHeight = 24
      ControlOptions.OriginalWidth = 192
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object liGallery: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup1
      AlignHorz = ahClient
      AlignVert = avClient
      AlignmentConstraint = AlignmentConstraint1
      Control = gcIcons
      ControlOptions.OriginalHeight = 294
      ControlOptions.OriginalWidth = 150
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object liSelection: TdxLayoutItem
      Parent = lgTopGroup
      CaptionOptions.Text = 'Selection:'
      CaptionOptions.Layout = clTop
      Control = gcSelection
      ControlOptions.OriginalHeight = 48
      ControlOptions.OriginalWidth = 150
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutGroup5: TdxLayoutGroup
      Parent = dxLayoutGroup1
      AlignVert = avBottom
      CaptionOptions.Text = 'Collection:'
      LayoutLookAndFeel = dxLayoutCxLookAndFeelCompact
      Hidden = True
      ShowBorder = False
      Index = 6
    end
    object dxLayoutLabeledItem2: TdxLayoutLabeledItem
      Parent = dxLayoutAutoCreatedGroup3
      AlignHorz = ahClient
      AlignVert = avCenter
      CaptionOptions.Text = 'Collection:'
      Index = 0
    end
    object dxLayoutItem7: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup3
      AlignVert = avCenter
      CaptionOptions.Text = 'cxButton1'
      CaptionOptions.Visible = False
      Control = btnAddLibraryCollectionRaster
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 25
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem15: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup3
      AlignVert = avCenter
      CaptionOptions.Text = 'cxButton2'
      CaptionOptions.Visible = False
      Control = btnRemoveFolderRaster
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 25
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutAutoCreatedGroup3: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutGroup5
      AlignVert = avBottom
      LayoutDirection = ldHorizontal
      Index = 0
    end
    object lgtsDXVectorImageGallery: TdxLayoutGroup
      Parent = lgMainPageControl
      CaptionOptions.Text = 'Vector Icons'
      ItemIndex = 1
      LayoutDirection = ldHorizontal
      Index = 1
    end
    object dxLayoutAutoCreatedGroup4: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutAutoCreatedGroup1
      LayoutDirection = ldHorizontal
      Index = 0
    end
    object dxLayoutGroup6: TdxLayoutGroup
      Parent = dxLayoutAutoCreatedGroup4
      AlignHorz = ahLeft
      CaptionOptions.Text = 'Hidden Group'
      Hidden = True
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 0
    end
    object dxLayoutItem16: TdxLayoutItem
      Parent = dxLayoutGroup12
      AlignVert = avClient
      AlignmentConstraint = AlignmentConstraint1
      CaptionOptions.Text = 'gcVectorIcons'
      CaptionOptions.Visible = False
      CaptionOptions.Layout = clTop
      Control = gcIconsVector
      ControlOptions.OriginalHeight = 336
      ControlOptions.OriginalWidth = 485
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem18: TdxLayoutItem
      Parent = dxLayoutGroup7
      AlignVert = avClient
      AlignmentConstraint = AlignmentConstraint1
      CaptionOptions.Text = 'Categories:'
      CaptionOptions.Visible = False
      CaptionOptions.Layout = clTop
      Control = clbCategoriesVector
      ControlOptions.OriginalHeight = 97
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutItem19: TdxLayoutItem
      Parent = dxLayoutGroup13
      AlignVert = avBottom
      CaptionOptions.Text = 'Collection:'
      CaptionOptions.Visible = False
      CaptionOptions.Layout = clTop
      Control = clbCollectionVector
      ControlOptions.OriginalHeight = 97
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutGroup7: TdxLayoutGroup
      Parent = lgtsDXVectorImageGallery
      AlignHorz = ahLeft
      AlignVert = avClient
      CaptionOptions.Text = 'New Group'
      SizeOptions.AssignedValues = [sovSizableHorz]
      SizeOptions.SizableHorz = True
      SizeOptions.Width = 169
      Hidden = True
      ItemIndex = 3
      ShowBorder = False
      Index = 0
    end
    object dxLayoutGroup12: TdxLayoutGroup
      Parent = lgtsDXVectorImageGallery
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'New Group'
      Hidden = True
      ShowBorder = False
      Index = 1
    end
    object dxLayoutEmptySpaceItem1: TdxLayoutEmptySpaceItem
      Parent = dxLayoutGroup7
      SizeOptions.Height = 10
      SizeOptions.Width = 10
      CaptionOptions.Text = 'Empty Space Item'
      Index = 0
    end
    object dxLayoutLabeledItem3: TdxLayoutLabeledItem
      Parent = dxLayoutGroup7
      CaptionOptions.Text = 'Categories:'
      Index = 1
    end
    object liSearchBoxVector: TdxLayoutItem
      Parent = dxLayoutGroup12
      AlignHorz = ahRight
      CaptionOptions.Text = 'cxButtonEdit1'
      CaptionOptions.Visible = False
      Control = beFindVector
      ControlOptions.OriginalHeight = 24
      ControlOptions.OriginalWidth = 192
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutGroup13: TdxLayoutGroup
      Parent = dxLayoutGroup7
      CaptionOptions.Text = 'Collection2:'
      LayoutLookAndFeel = dxLayoutCxLookAndFeelCompact
      Hidden = True
      ShowBorder = False
      Index = 3
      Buttons = <
        item
          Glyph.SourceDPI = 144
          Glyph.Data = {
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
            6464436972636C6564223E0D0A09093C7061746820636C6173733D2247726565
            6E2220643D224D31362C3443392E342C342C342C392E342C342C313673352E34
            2C31322C31322C31327331322D352E342C31322D31325332322E362C342C3136
            2C347A204D32342C3138682D367636682D34762D364838762D34683656386834
            763668365631387A222F3E0D0A093C2F673E0D0A3C2F7376673E0D0A}
          Height = 25
          Width = 25
        end
        item
          Glyph.SourceDPI = 144
          Glyph.Data = {
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
            7B6F7061636974793A302E353B7D3C2F7374796C653E0D0A3C672069643D2252
            656D6F7665436972636C6564223E0D0A09093C7061746820636C6173733D2252
            65642220643D224D31362C3443392E342C342C342C392E342C342C313673352E
            342C31322C31322C31327331322D352E342C31322D31325332322E362C342C31
            362C347A204D32342C31384838762D346831365631387A222F3E0D0A093C2F67
            3E0D0A3C2F7376673E0D0A}
          Height = 25
          Width = 25
        end>
    end
    object dxLayoutLabeledItem4: TdxLayoutLabeledItem
      Parent = dxLayoutAutoCreatedGroup6
      AlignHorz = ahClient
      AlignVert = avCenter
      CaptionOptions.Text = 'Collection:'
      Index = 0
    end
    object dxLayoutItem17: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup6
      AlignVert = avCenter
      CaptionOptions.Text = 'cxButton1'
      CaptionOptions.Visible = False
      Control = btnRemoveFolderVector
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 25
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutItem20: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup6
      AlignVert = avCenter
      CaptionOptions.Text = 'cxButton2'
      CaptionOptions.Visible = False
      Control = btnAddCollectionVector
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 25
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup6: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutGroup13
      AlignVert = avBottom
      LayoutDirection = ldHorizontal
      Index = 0
    end
    object liNotes: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup2
      AlignHorz = ahClient
      CaptionOptions.Text = 'dxFormattedLabel1'
      CaptionOptions.Visible = False
      Control = lblNotes
      ControlOptions.OriginalHeight = 52
      ControlOptions.OriginalWidth = 58
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutAutoCreatedGroup2: TdxLayoutAutoCreatedGroup
      Parent = lgFontIcons
      AlignVert = avTop
      LayoutDirection = ldHorizontal
      Index = 2
    end
    object dxLayoutEmptySpaceItem2: TdxLayoutEmptySpaceItem
      Parent = dxLayoutAutoCreatedGroup2
      SizeOptions.Height = 10
      SizeOptions.Width = 55
      CaptionOptions.Text = 'Empty Space Item'
      Index = 1
    end
    object AlignmentConstraint1: TdxLayoutAlignmentConstraint
      Kind = ackTop
    end
  end
  inherited ilImages: TcxImageList
    FormatVersion = 1
    Bitmap = {
      494C01010A009C00040010001000FFFFFFFF2110FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000003000000001002000000000000030
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000021907073A87131392D51A1AC9FA1A1AC9FA131393D608083B890000
      021B000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000303
      18581717B0EA0808408E0000083200000006000000060000073108083E8C1717
      B0EA03031A5B0000000000000000000000000000000000000000000000000000
      00000000000000000000000000000A0A0A400A0A0A4000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000030318571515
      A3E10000062D0000000000000000000000000000000000000000000000000000
      052B1515A0DF03031A5B00000000000000000000000000000000000000000000
      0000000000000000000000000000020202200202022000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000001181717B0EA0000
      062E000000000000000000000000111180C8111185CC00000000000000000000
      00000000052B1717B0EA0000021B000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000007073885090942900000
      000000000000000000000000000010107BC4111180C800000000000000000000
      00000000000008083E8C08083B89000000000000000000000000000000000000
      00000000000000000000000000000909093E0A0A0A4000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000012128DD2010108350000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000731141493D6000000000000000000000000000000000000
      00000000000000000000000000000808083C0C0C0C4800000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000001919C3F60000000A0000
      00000000000000000000000000001B1BD1FF1B1BD1FF00000000000000000000
      000000000000000000061B1BC9FA000000000000000000000000000000000000
      0000000000000000000000000000000000101F1F1F710A0A0A43000000050000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000001919C3F60000000A0000
      00000000000000000000000000001B1BD1FF1B1BD1FF00000000000000000000
      000000000000000000061B1BC9FA000000000000000000000000000000000000
      0000000000000000000000000000000000000000000C101010521D1D1D6E0101
      0117000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000012128CD1010109360000
      00000000000000000000000000001B1BD1FF1B1BD1FF00000000000000000000
      00000000000001010832131392D5000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000404042C1F1F
      1F70000000050000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000007073783090943920000
      00000000000000000000000000001B1BD1FF1B1BD1FF00000000000000000000
      0000000000000808408E07073A87000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000001515
      155D030303260000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000001171717AEE90000
      07300000000000000000000000001B1BD1FF1B1BD1FF00000000000000000000
      00000000062D1717B0EA00000219000000000000000000000000000000000101
      011C1414145B0000000000000000000000000000000000000000000000001414
      145C030303280000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000020216541616
      A5E2000007300000000000000000000000000000000000000000000000000000
      062E1515A2E10303185800000000000000000000000000000000000000000000
      0005202020730303032500000000000000000000000000000001070707351E1E
      1E6F000000060000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000202
      16541717AEE909094392010109360000000A0000000A01010835090942901717
      B0EA030318570000000000000000000000000000000000000000000000000000
      00000202021D1E1E1E70171717630D0D0D4A0E0E0E4C1D1D1D6D171717620000
      0012000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000001170707378312128CD11919C3F61919C3F612128DD2070738850000
      0118000000000000000000000000000000000000000000000000000000000000
      0000000000000000000302020222070707350606063401010119000000000000
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
      00000000000000000000717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000717171FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF717171FF00000000B57936FFB57936FFB579
      36FFB57936FFB57936FFB57936FFB57936FFB57936FFB57936FFB57936FFB579
      36FFB57936FFB57936FFB57936FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000014B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF717171FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF717171FF00000000B57936FFB57936FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFB57936FFB57936FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000010505
      266E000001160000000000000000000000000000000000000000000000000000
      01140505276F00000002000000000000000014B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF717171FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF717171FF00000000B57936FFB57936FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFB57936FFB57936FF0000000000000000000204210A577FB414B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1
      FFFF094A6AA500000000000000000000000000000000000000000505246B1B1B
      D1FF12128FD30000011600000000000000000000000000000000000001141212
      8CD11B1BD1FF0505276F000000000000000014B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF717171FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF717171FF00000000B57936FFB57936FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFB57936FFB57936FF0000000000000000063349890004062A14AB
      F7FB14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B0FDFE01090D3A00000000000000000000000000000000000001131212
      88CE1B1BD1FF12128FD30000011600000000000000000000011412128CD11B1B
      D1FF12128CD100000114000000000000000014B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF717171FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF717171FF00000000B57936FFB57936FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFB57936FFB57936FF00000000000000000B638FBF00070A33073C
      589614B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF0C6A98C500000001000000000000000000000000000000000000
      0113121288CE1B1BD1FF12128FD3000001160000011412128CD11B1BD1FF1212
      8CD10000011400000000000000000000000014B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF717171FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF717171FF00000000B57936FFB57936FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFB57936FFB57936FF00000000000000000B638FBF07415E9B0001
      0217129DE1F014B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF02121A53000000000000000000000000000000000000
      000000000113121288CE1B1BD1FF12128FD312128CD11B1BD1FF12128CD10000
      01140000000000000000000000000000000014B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF717171FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF717171FF00000000B57936FFB57936FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFB57936FFB57936FF00000000000000000B638FBF0B638FBF010D
      13460426377714B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF0F7DB3D6000000000000000000000000000000000000
      00000000000000000113121288CE1B1BD1FF1B1BD1FF12128CD1000001140000
      00000000000000000000000000000000000014B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF717171FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFF717171FF717171FF717171FF00000000B57936FFB57936FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFB57936FFB57936FF00000000000000000B638FBF0B638FBF094D
      70A9000001120000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000011412128CD11B1BD1FF1B1BD1FF12128FD3000001160000
      00000000000000000000000000000000000014B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF717171FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFF717171FF000000000000000000000000B57936FFB57936FFB579
      36FFB57936FFB57936FFB57936FFB57936FFB57936FFB57936FFB57936FFB579
      36FFB57936FFB57936FFB57936FF00000000000000000B638FBF0B638FBF0B63
      8FBF0B638FBF0B638FBF0B638FBF0B638FBF0B638FBF0B638FBF0B638FBF0B63
      8FBF000000000000000000000000000000000000000000000000000000000000
      00000000011412128CD11B1BD1FF12128CD1121288CE1B1BD1FF12128FD30000
      01160000000000000000000000000000000014B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF000000000000000000000000B57936FFB57936FFE1CA
      AFFFE1CAAFFFE1CAAFFFE1CAAFFFE1CAAFFFE1CAAFFFE1CAAFFFE1CAAFFFE1CA
      AFFFB57936FFB57936FFB57936FF00000000000000000B638FBF0B638FBF0B63
      8FBF0B638FBF0B638FBF0B638FBF0B638FBF0B638FBF0B638FBF0B638FBF0A59
      80B5000000000000000000000000000000000000000000000000000000000000
      011412128CD11B1BD1FF12128CD10000011400000113121288CE1B1BD1FF1212
      8FD30000011600000000000000000000000014B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1
      FFFF0000000000000000000000000000000000000000B57936FFB57936FFE1CA
      AFFFE1CAAFFFE1CAAFFFE1CAAFFFE1CAAFFFE1CAAFFFE1CAAFFFB57936FFE1CA
      AFFFB57936FFB57936FFB57936FF00000000000000000B638FBF0B638FBF0B63
      8FBF0B638FBF0B638FBF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000001141212
      8CD11B1BD1FF12128CD100000114000000000000000000000113121288CE1B1B
      D1FF12128FD300000116000000000000000014B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1
      FFFF0000000000000000000000000000000000000000B57936FFB57936FFE1CA
      AFFFE1CAAFFFE1CAAFFFE1CAAFFFE1CAAFFFE1CAAFFFE1CAAFFFB57936FFE1CA
      AFFFB57936FFB57936FFB57936FF00000000000000000A577DB30B638FBF0B63
      8FBF0B638FBF0A5980B500000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000404246A1B1B
      D1FF12128CD10000011400000000000000000000000000000000000001131212
      88CE1B1BD1FF0505266E000000000000000014B1FFFF14B1FFFF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF14B1FFFF14B1
      FFFF0000000000000000000000000000000000000000B57936FFB57936FFE1CA
      AFFFE1CAAFFFE1CAAFFFE1CAAFFFE1CAAFFFE1CAAFFFE1CAAFFFB57936FFE1CA
      AFFFB57936FFB57936FF2B1D0D7E000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000010404
      246A000001140000000000000000000000000000000000000000000000000000
      01130505246B0000000100000000000000000000000000000000717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF000000000000
      00000000000000000000000000000000000000000000B57936FFB57936FFE1CA
      AFFFE1CAAFFFE1CAAFFFE1CAAFFFE1CAAFFFE1CAAFFFE1CAAFFFB57936FFE1CA
      AFFFB57936FF2B1D0D7E00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00001414146D5F5F5FEA606060EB161616710000000000000000000000000000
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
      0000000000030000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000001D1D1D821D1D1D820000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000001001B115001B81F8E
      02F4145B01C40003002500000000000000000000000000000000000200231560
      01C9229A02FE156001C900030026000000000000000000000000717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF00000000000000000000000000000000000000001B1B1B7E717171FF1D1D
      1D82000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000115101B8071E00710000
      0005061C006D166201CB00000000000000000000000000000000135701BF071E
      007100000005061C006D155F01C8000000000000000000000000717171FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7171
      71FF0000000000000000000000000000000000000000000000001B1B1B7E7171
      71FF1D1D1D820000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000001C1C
      1C7F4D4D4DD20000001600000000000000000000000000000000000000144B4B
      4BCF1E1E1E83000000000000000000000000000000001F8E02F3000000090000
      000000000005229C02FF00000008000000000000000000000000209102F60000
      00090000000000000005219602FA000000000000000000000000717171FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7171
      71FF717171FF717171FF00000000000000000000000000000000000000001B1B
      1B7E717171FF1D1D1D8200000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004848
      48CB717171FF4D4D4DD3000000160000000000000000000000144B4B4BD17171
      71FF4B4B4BCF00000000000000000000000000000000135801C0072000750000
      0009071E0071186D02D500000000000000000000000000000000145A01C20720
      007500000009071E0071135701C0000000000000000000000000717171FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7171
      71FFFFFFFFFF717171FF00000000000000000000000000000000000000000000
      00001B1B1B7E717171FF1D1D1D82000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00134A4A4ACE717171FF4D4D4DD300000016000000144B4B4BD1717171FF4B4B
      4BD1000000140000000000000000000000000000000000020022145D01C52196
      02FB145D01C61E8902EF0105002F0000000000000000000200221D8502EB1253
      01BB1F8D02F3135501BD00020020000000000000000000000000717171FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7171
      71FFFFFFFFFF717171FF00000000000000000000000000000000000000000000
      0000000000001B1B1B7E717171FF2E251C92683908B1C76E0FF5C76E0FF66A3A
      08B30503002A0000000000000000000000000000000000000000000000000000
      0000000000134A4A4ACE717171FF4D4D4DD34B4B4BD1717171FF4B4B4BD10000
      0014000000000000000000000000000000000000000000000000000000000000
      00000000000006100054C8760FFCD77610FF96520BD500000011020900400000
      0000000000000000000000000000000000000000000000000000717171FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7171
      71FFFFFFFFFF717171FF00000000000000000000000000000000000000000000
      000000000000000000002C231B8FC57016F82615026C0000000D0000000D2414
      026AB3630EE90503002A00000000000000000000000000000000000000000000
      000000000000000000134A4A4ACE717171FF717171FF4B4B4BD1000000140000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000024140269D77610FFD77610FF4A290597000000000000
      0000000000000000000000000000000000000000000000000000717171FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7171
      71FFFFFFFFFF717171FF00000000000000000000000000000000000000000000
      00000000000000000000653808AF2715036E0000000000000000000000000000
      00002414026A6A3A08B300000000000000000000000000000000000000000000
      000000000000000000144B4B4BD1717171FF717171FF4D4D4DD3000000160000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000001008014608040032351D037FD77610FFD77610FF140B014F0000
      0000000000000000000000000000000000000000000000000000717171FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7171
      71FFFFFFFFFF717171FF00000000000000000000000000000000000000000000
      00000000000000000000C16A0FF2000000110000000000000000000000000000
      00000000000DC76E0FF600000000000000000000000000000000000000000000
      0000000000144B4B4BD1717171FF4B4B4BD14A4A4ACE717171FF4D4D4DD30000
      0016000000000000000000000000000000000000000000000000000000000000
      000001000017B2610DE8B1610DE80201001949280595D77610FFB6640EEB0201
      001B000000000000000000000000000000000000000000000000717171FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7171
      71FFFFFFFFFF717171FF00000000000000000000000000000000000000000000
      00000000000000000000C16A0FF2000000110000000000000000000000000000
      00000000000DC76E0FF600000000000000000000000000000000000000000000
      00144B4B4BD1717171FF4B4B4BD100000014000000134A4A4ACE717171FF4D4D
      4DD3000000160000000000000000000000000000000000000000000000000000
      00016E3C08B7D77610FF5D3307A800000002000000025F3407AAD77610FF7440
      09BC000000020000000000000000000000000000000000000000717171FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF717171FF717171FF7171
      71FFFFFFFFFF717171FF00000000000000000000000000000000000000000000
      00000000000000000000633608AD291603700000000000000000000000000000
      00002615026C683908B100000000000000000000000000000000000000004949
      49CD717171FF4B4B4BD1000000140000000000000000000000134A4A4ACE7171
      71FF4D4D4DD20000000000000000000000000000000000000000000000002917
      0371D77610FF754009BC00000007000000000000000000000007744009BCD776
      10FF2D1903760000000000000000000000000000000000000000717171FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF717171FFFFFFFFFFFFFF
      FFFFFFFFFFFF717171FF00000000000000000000000000000000000000000000
      0000000000000000000004020026B1610DE82916037000000011000000112715
      036EB2610DE80502002800000000000000000000000000000000000000001919
      1979494949CD0000001400000000000000000000000000000000000000134848
      48CB1B1B1B7D000000000000000000000000000000000000000000000000BC67
      0EEF8B4C0BCD0000000E000000000000000000000000000000000000000D894B
      0BCCC36B0FF30000000000000000000000000000000000000000717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FFFFFFFFFFFFFF
      FFFFFFFFFFFF717171FF00000000000000000000000000000000000000000000
      000000000000000000000000000004020026633708AEC16A0FF2C16A0FF26538
      08AF050200280000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000005F34
      07A9010000170000000000000000000000000000000000000000000000000100
      0016603507AB0000000000000000000000000000000000000000000000000000
      0000717171FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFF717171FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000300000000100010000000000800100000000000000000000
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
      000000000000}
    ImageInfo = <
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D22D0
          A1D0BBD0BED0B95F312220786D6C6E733D22687474703A2F2F7777772E77332E
          6F72672F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A
          2F2F7777772E77332E6F72672F313939392F786C696E6B2220783D2230707822
          20793D22307078222076696577426F783D223020302033322033322220737479
          6C653D22656E61626C652D6261636B67726F756E643A6E657720302030203332
          2033323B2220786D6C3A73706163653D227072657365727665223E262331333B
          262331303B3C7374796C6520747970653D22746578742F6373732220786D6C3A
          73706163653D227072657365727665223E2E426C61636B7B66696C6C3A233732
          373237323B7D262331333B262331303B2623393B2E426C75657B66696C6C3A23
          3131373744373B7D3C2F7374796C653E0D0A3C672069643D22D0A1D0BBD0BED0
          B95F32223E0D0A09093C7061746820636C6173733D22426C61636B2220643D22
          4D31332C31374C322C32386C322C326C31312D31316C312D316C2D322D324C31
          332C31377A222F3E0D0A09093C673E0D0A0909093C673E0D0A090909093C7061
          746820636C6173733D22426C75652220643D224D32302C34632D342E342C302D
          382C332E362D382C3873332E362C382C382C3873382D332E362C382D38533234
          2E342C342C32302C347A204D32302C3138632D332E332C302D362D322E372D36
          2D3673322E372D362C362D3673362C322E372C362C3620202623393B2623393B
          2623393B2623393B5332332E332C31382C32302C31387A222F3E0D0A0909093C
          2F673E0D0A09093C2F673E0D0A093C2F673E0D0A3C2F7376673E0D0A}
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
          426C61636B2220643D224D31382E382C31366C362E392D362E3963302E342D30
          2E342C302E342D312C302D312E346C2D312E342D312E34632D302E342D302E34
          2D312D302E342D312E342C304C31362C31332E324C392E312C362E33632D302E
          342D302E342D312D302E342D312E342C3020202623393B2623393B2623393B4C
          362E332C372E37632D302E342C302E342D302E342C312C302C312E346C362E39
          2C362E396C2D362E392C362E39632D302E342C302E342D302E342C312C302C31
          2E346C312E342C312E3463302E342C302E342C312C302E342C312E342C306C36
          2E392D362E396C362E392C362E3920202623393B2623393B2623393B63302E34
          2C302E342C312C302E342C312E342C306C312E342D312E3463302E342D302E34
          2C302E342D312C302D312E344C31382E382C31367A222F3E0D0A09093C2F673E
          0D0A09093C673E0D0A0909093C7061746820636C6173733D22426C61636B2220
          643D224D31382E382C31366C362E392D362E3963302E342D302E342C302E342D
          312C302D312E346C2D312E342D312E34632D302E342D302E342D312D302E342D
          312E342C304C31362C31332E324C392E312C362E33632D302E342D302E342D31
          2D302E342D312E342C3020202623393B2623393B2623393B4C362E332C372E37
          632D302E342C302E342D302E342C312C302C312E346C362E392C362E396C2D36
          2E392C362E39632D302E342C302E342D302E342C312C302C312E346C312E342C
          312E3463302E342C302E342C312C302E342C312E342C306C362E392D362E396C
          362E392C362E3920202623393B2623393B2623393B63302E342C302E342C312C
          302E342C312E342C306C312E342D312E3463302E342D302E342C302E342D312C
          302D312E344C31382E382C31367A222F3E0D0A09093C2F673E0D0A093C2F673E
          0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D22D0
          A1D0BBD0BED0B95F312220786D6C6E733D22687474703A2F2F7777772E77332E
          6F72672F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A
          2F2F7777772E77332E6F72672F313939392F786C696E6B2220783D2230707822
          20793D22307078222076696577426F783D223020302033322033322220737479
          6C653D22656E61626C652D6261636B67726F756E643A6E657720302030203332
          2033323B2220786D6C3A73706163653D227072657365727665223E262331333B
          262331303B2623393B2623393B2623393B2623393B2623393B2623393B262339
          3B3C7374796C6520747970653D22746578742F6373732220786D6C3A73706163
          653D227072657365727665223E2E477265656E7B66696C6C3A23303339433233
          3B7D262331333B262331303B2623393B2E426C75657B66696C6C3A2331313737
          44373B7D3C2F7374796C653E0D0A3C672069643D22437574223E0D0A09093C70
          61746820636C6173733D22426C75652220643D224D31312E382C31352E356C32
          2E382D332E314C372C3443352E382C352E322C352E372C372C362E362C382E33
          4C31312E382C31352E357A222F3E0D0A09093C7061746820636C6173733D2247
          7265656E2220643D224D32392E392C32342E32632D302E332D312E392D312E38
          2D332E362D332E372D34632D312E352D302E342D322E382C302D332E392C302E
          376C2D312E392D322E316C2D312E312C312E366C312E352C32632D302E372C31
          2E312D312C322E342D302E362C332E3920202623393B2623393B63302E352C31
          2E392C322E312C332E342C342E312C332E374332372E362C33302E342C33302E
          352C32372E362C32392E392C32342E327A204D32352C3238632D312E372C302D
          332D312E332D332D3373312E332D332C332D3373332C312E332C332C33533236
          2E372C32382C32352C32387A222F3E0D0A09093C7061746820636C6173733D22
          426C75652220643D224D32352C344C31312E362C31382E376C312E322C312E36
          4C31332C323068346C382E342D31312E374332362E332C372C32362E322C352E
          322C32352C347A222F3E0D0A09093C7061746820636C6173733D22477265656E
          2220643D224D392E372C32302E38632D312E312D302E372D322E352D312D332E
          392D302E37632D312E392C302E352D332E342C322E312D332E372C34632D302E
          352C332E342C322E332C362E322C352E372C352E3863322D302E332C332E362D
          312E382C342E312D332E3720202623393B2623393B63302E342D312E352C302E
          312D322E382D302E362D332E396C312E352D326C2D312E322D312E364C392E37
          2C32302E387A204D372C3238632D312E372C302D332D312E332D332D3373312E
          332D332C332D3373332C312E332C332C3353382E372C32382C372C32387A222F
          3E0D0A093C2F673E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D22D0
          A1D0BBD0BED0B95F312220786D6C6E733D22687474703A2F2F7777772E77332E
          6F72672F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A
          2F2F7777772E77332E6F72672F313939392F786C696E6B2220783D2230707822
          20793D22307078222076696577426F783D223020302033322033322220737479
          6C653D22656E61626C652D6261636B67726F756E643A6E657720302030203332
          2033323B2220786D6C3A73706163653D227072657365727665223E262331333B
          262331303B2623393B2623393B2623393B2623393B2623393B2623393B262339
          3B3C7374796C6520747970653D22746578742F6373732220786D6C3A73706163
          653D227072657365727665223E2E57686974657B66696C6C3A23464646464646
          3B7D262331333B262331303B2623393B2E426C61636B7B66696C6C3A23373237
          3237323B7D3C2F7374796C653E0D0A3C672069643D22436F7079223E0D0A0909
          3C7265637420783D22382220793D22322220636C6173733D22426C61636B2220
          77696474683D22323022206865696768743D223234222F3E0D0A09093C726563
          7420783D2231302220793D22342220636C6173733D2257686974652220776964
          74683D22313622206865696768743D223230222F3E0D0A09093C706174682063
          6C6173733D22426C61636B2220643D224D342C36763234683230563130682D34
          563648347A222F3E0D0A09093C706F6C79676F6E20636C6173733D2257686974
          652220706F696E74733D22362C3820362C32382032322C32382032322C313220
          31382C31322031382C38202623393B222F3E0D0A093C2F673E0D0A3C2F737667
          3E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D22D0
          A1D0BBD0BED0B95F312220786D6C6E733D22687474703A2F2F7777772E77332E
          6F72672F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A
          2F2F7777772E77332E6F72672F313939392F786C696E6B2220783D2230707822
          20793D22307078222076696577426F783D223020302033322033322220737479
          6C653D22656E61626C652D6261636B67726F756E643A6E657720302030203332
          2033323B2220786D6C3A73706163653D227072657365727665223E262331333B
          262331303B2623393B2623393B2623393B2623393B2623393B2623393B262339
          3B3C7374796C6520747970653D22746578742F6373732220786D6C3A73706163
          653D227072657365727665223E2E57686974657B66696C6C3A23464646464646
          3B7D262331333B262331303B2623393B2E426C61636B7B66696C6C3A23373237
          3237323B7D262331333B262331303B2623393B2E59656C6C6F777B66696C6C3A
          234646423131353B7D3C2F7374796C653E0D0A3C672069643D22506173746522
          3E0D0A09093C7265637420793D22342220636C6173733D2259656C6C6F772220
          77696474683D22323422206865696768743D223234222F3E0D0A09093C706F6C
          79676F6E20636C6173733D22426C61636B2220706F696E74733D2233322C3332
          2031322C33322031322C31302032382C31302032382C31342033322C31342026
          23393B222F3E0D0A09093C706F6C79676F6E20636C6173733D22576869746522
          20706F696E74733D2233302C33302031342C33302031342C31322032362C3132
          2032362C31362033302C3136202623393B222F3E0D0A09093C7061746820636C
          6173733D22426C61636B2220643D224D32302C364834563268346C302E362D30
          2E3643392E352C302E352C31302E372C302C31322C30683063312E332C302C32
          2E352C302E352C332E342C312E344C31362C32683456367A222F3E0D0A093C2F
          673E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D223020302033322033322220656E61626C65
          2D6261636B67726F756E643D226E6577203020302033322033322220786D6C3A
          73706163653D227072657365727665223E262331333B262331303B3C706F6C79
          676F6E2066696C6C3D22233337374142352220706F696E74733D22322C322032
          2C33302033302C33302033302C362032362C3220222F3E0D0A3C726563742078
          3D22362220793D223134222066696C6C3D222346464646464622207769647468
          3D22323022206865696768743D223134222F3E0D0A3C7265637420783D223622
          20793D223222206F7061636974793D22302E36222066696C6C3D222346464646
          46462220656E61626C652D6261636B67726F756E643D226E6577202020202220
          77696474683D22313822206865696768743D223130222F3E0D0A3C7265637420
          783D2232302220793D2232222066696C6C3D2223333737414235222077696474
          683D223222206865696768743D2238222F3E0D0A3C2F7376673E0D0A}
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
          7B6F7061636974793A302E353B7D3C2F7374796C653E0D0A3C672069643D2246
          6F6C6465724F70656E223E0D0A09093C6720636C6173733D22737430223E0D0A
          0909093C7061746820636C6173733D2259656C6C6F772220643D224D322E322C
          32352E326C352E352D313063302E332D302E372C312D312E322C312E382D312E
          32483234762D3363302D302E362D302E342D312D312D31483132563763302D30
          2E362D302E342D312D312D31483343322E342C362C322C362E352C322C377631
          3820202623393B2623393B2623393B63302C302E322C302C302E332C302E312C
          302E3443322E312C32352E342C322E322C32352E332C322E322C32352E327A22
          2F3E0D0A09093C2F673E0D0A09093C7061746820636C6173733D2259656C6C6F
          772220643D224D32392E332C313648392E364C342C32366831392E3863302E35
          2C302C312E312D302E322C312E332D302E366C342E392D382E394333302E312C
          31362E322C32392E382C31362C32392E332C31367A222F3E0D0A093C2F673E0D
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
          303B3C7374796C6520747970653D22746578742F637373223E2E5265647B6669
          6C6C3A234431314331433B7D3C2F7374796C653E0D0A3C7061746820636C6173
          733D225265642220643D224D31382E382C31366C382D3863302E342D302E342C
          302E342D312C302D312E346C2D312E342D312E34632D302E342D302E342D312D
          302E342D312E342C306C2D382C386C2D382D38632D302E342D302E342D312D30
          2E342D312E342C304C352E322C362E3620202623393B43342E382C372C342E38
          2C372E362C352E322C386C382C386C2D382C38632D302E342C302E342D302E34
          2C312C302C312E346C312E342C312E3463302E342C302E342C312C302E342C31
          2E342C306C382D386C382C3863302E342C302E342C312C302E342C312E342C30
          6C312E342D312E3420202623393B63302E342D302E342C302E342D312C302D31
          2E344C31382E382C31367A222F3E0D0A3C2F7376673E0D0A}
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
          696E67436972636C656432223E0D0A09093C7061746820636C6173733D225265
          642220643D224D31362C3243382E332C322C322C382E332C322C313673362E33
          2C31342C31342C31347331342D362E332C31342D31345332332E372C322C3136
          2C327A204D31362C323843392E342C32382C342C32322E362C342C313643342C
          392E342C392E342C342C31362C3420202623393B2623393B7331322C352E342C
          31322C31324332382C32322E362C32322E362C32382C31362C32387A222F3E0D
          0A09093C636972636C6520636C6173733D22526564222063783D223136222063
          793D2232322220723D2232222F3E0D0A09093C7265637420783D223134222079
          3D22382220636C6173733D22526564222077696474683D223422206865696768
          743D223130222F3E0D0A093C2F673E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222077696474683D223332707822206865696768743D223332707822
          2076696577426F783D223020302033322033322220656E61626C652D6261636B
          67726F756E643D226E6577203020302033322033322220786D6C3A7370616365
          3D227072657365727665223E262331303B20203C672069643D2269636F6E2220
          786D6C3A73706163653D227072657365727665223E202020203C706174682064
          3D224D31372C3238682D32762D3368325632387A4D31372C3232682D326C302E
          3030332C2D332E30333663302E3135382C2D322E3030362C312E3934322C2D33
          2E30362C332E3636372C2D342E30373963322E3037322C2D312E3232342C342E
          30332C2D322E33382C342E30332C2D352E30343763302C2D312E3734372C2D31
          2E3239342C2D322E3837352C2D322E33382C2D332E353134632D312E3435312C
          2D302E3835342C2D332E3137372C2D312E3233362C2D342E3234342C2D312E32
          3336632D302E3736352C302C2D322E3731352C302E3038372C2D342E3330352C
          302E383937632D312E3537312C302E382C2D322E3333352C322E3035362C2D32
          2E3333352C332E3834682D3263302C2D342E3936372C342E3436332C2D362E37
          33372C382E36342C2D362E37333763322E3931332C302C382E3632342C322E30
          33382C382E3632342C362E37343963302C332E3830382C2D322E3737392C352E
          34352C2D352E3031332C362E373639632D312E3338372C302E3831392C2D322E
          3538372C312E3532382C2D322E3638382C322E3438315632327A222066696C6C
          3D222341304130413022206F7061636974793D22302E35222F3E0D0A093C2F67
          3E0D0A3C2F7376673E0D0A}
      end>
  end
  inherited ActionList: TActionList
    object actF3: TAction
      Caption = 'actF3'
      ShortCut = 114
      OnExecute = actF3Execute
    end
  end
  inherited EditStyleController: TcxEditStyleController
    PixelsPerInch = 96
  end
  inherited pmPictureEditor: TPopupMenu
    Left = 56
    Top = 144
  end
  object pmSelection: TPopupMenu [8]
    OnPopup = pmSelectionPopup
    Left = 128
    Top = 136
    object miCheckSelected: TMenuItem
      Tag = 1
      Caption = '&Check Selected'
      OnClick = miUncheckSelectedClick
    end
    object miUncheckSelected: TMenuItem
      Caption = '&Uncheck Selected'
      OnClick = miUncheckSelectedClick
    end
    object miLine1: TMenuItem
      Caption = '-'
    end
    object miSelectAll: TMenuItem
      Tag = 1
      Caption = '&Select All'
      ShortCut = 16449
      OnClick = miSelectClick
    end
    object miSelectNone: TMenuItem
      Caption = '&Deselect All'
      OnClick = miSelectClick
    end
  end
  object pmIconGallery: TPopupMenu [9]
    OnPopup = pmIconGalleryPopup
    Left = 472
    Top = 144
    object miIconsAddToSelection: TMenuItem
      Caption = 'Add to Selection'
      Default = True
      ShortCut = 45
      OnClick = miIconsAddToSelectionClick
    end
    object miIconsShowInExplorer: TMenuItem
      Caption = 'Show in &Explorer...'
      OnClick = miIconsShowInExplorerClick
    end
    object miLine3: TMenuItem
      Caption = '-'
    end
    object miIconsSelectAll: TMenuItem
      Tag = 1
      Caption = '&Select All'
      ShortCut = 16449
      OnClick = miIconsDeselectAllClick
    end
    object miIconsSelectAllinThisGroup: TMenuItem
      Tag = 1
      Caption = 'Select All in Group'
      OnClick = miIconsSelectAllinThisGroupClick
    end
    object miIconsDeselectAll: TMenuItem
      Caption = '&Deselect All'
      OnClick = miIconsDeselectAllClick
    end
    object miIconsDeselectAllinThisGroup: TMenuItem
      Caption = 'Deselect All in Group'
      OnClick = miIconsSelectAllinThisGroupClick
    end
  end
  object pmIconsSelection: TPopupMenu [10]
    OnPopup = pmIconsSelectionPopup
    Left = 656
    Top = 352
    object miIconsSelectionDeleteSelected: TMenuItem
      Caption = '&Delete Selected'
      Default = True
      ShortCut = 46
      OnClick = miIconsSelectionDeleteSelectedClick
    end
    object miIconsSelectionLocateInIconLibrary: TMenuItem
      Caption = 'Locate in DevExpress Icon Library'
      OnClick = miIconsSelectionLocateInIconLibraryClick
    end
    object miLine4: TMenuItem
      Caption = '-'
    end
    object miIconsSelectionSelectAll: TMenuItem
      Tag = 1
      Caption = '&Select All'
      ShortCut = 16449
      OnClick = miIconsSelectionDeselectAllClick
    end
    object miIconsSelectionDeselectAll: TMenuItem
      Caption = 'Deselect All'
      OnClick = miIconsSelectionDeselectAllClick
    end
  end
  object PrintDialog1: TPrintDialog [11]
    Left = 604
    Top = 352
  end
  object ilStandartColors: TcxImageList [12]
    SourceDPI = 96
    FormatVersion = 1
    Left = 624
    Top = 264
    Bitmap = {
      494C010106000800040010001000FFFFFFFF2110FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000002000000001002000000000000020
      00000000000000000000000000000000000014B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000014B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000014B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000014B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000014B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000014B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000014B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000014B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000014B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000014B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000014B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000014B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000014B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000014B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000014B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000014B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF1B1BD1FF1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF1B1BD1FF1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF1B1BD1FF1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF1B1BD1FF1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF1B1BD1FF1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF1B1BD1FF1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF1B1BD1FF1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF1B1BD1FF1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF1B1BD1FF1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF1B1BD1FF1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF1B1BD1FF1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF1B1BD1FF1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF1B1BD1FF1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF1B1BD1FF1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF1B1BD1FF1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF1B1BD1FF1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF229C02FF229C02FF229C02FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FF424D3E000000000000003E000000
      2800000040000000200000000100010000000000000100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000}
    DesignInfo = 17302128
    ImageInfo = <
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E312220786D6C6E73
          3D22687474703A2F2F7777772E77332E6F72672F323030302F7376672220786D
          6C6E733A786C696E6B3D22687474703A2F2F7777772E77332E6F72672F313939
          392F786C696E6B222076696577426F783D22302030203332203332223E0D0A09
          3C7374796C6520747970653D22746578742F637373223E2E426C61636B7B6669
          6C6C3A233732373237327D3C2F7374796C653E0D0A093C7265637420636C6173
          733D22426C61636B2220783D22302220793D2230222077696474683D22333222
          206865696768743D223332222F3E0D0A3C2F7376673E0D0A}
        Keywords = 'Black'
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E312220786D6C6E73
          3D22687474703A2F2F7777772E77332E6F72672F323030302F7376672220786D
          6C6E733A786C696E6B3D22687474703A2F2F7777772E77332E6F72672F313939
          392F786C696E6B222076696577426F783D22302030203332203332223E0D0A09
          3C7374796C6520747970653D22746578742F637373223E2E5265647B66696C6C
          3A234431314331437D3C2F7374796C653E0D0A093C7265637420636C6173733D
          225265642220783D22302220793D2230222077696474683D2233322220686569
          6768743D223332222F3E0D0A3C2F7376673E0D0A}
        Keywords = 'Red'
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E312220786D6C6E73
          3D22687474703A2F2F7777772E77332E6F72672F323030302F7376672220786D
          6C6E733A786C696E6B3D22687474703A2F2F7777772E77332E6F72672F313939
          392F786C696E6B222076696577426F783D22302030203332203332223E0D0A09
          3C7374796C6520747970653D22746578742F637373223E2E477265656E7B6669
          6C6C3A233033394332337D3C2F7374796C653E0D0A093C7265637420636C6173
          733D22477265656E2220783D22302220793D2230222077696474683D22333222
          206865696768743D223332222F3E0D0A3C2F7376673E0D0A}
        Keywords = 'Green'
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
          6C3A233131373744377D3C2F7374796C653E0D0A093C7265637420636C617373
          3D22426C75652220783D22302220793D2230222077696474683D223332222068
          65696768743D223332222F3E0D0A3C2F7376673E0D0A}
        Keywords = 'Blue'
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E312220786D6C6E73
          3D22687474703A2F2F7777772E77332E6F72672F323030302F7376672220786D
          6C6E733A786C696E6B3D22687474703A2F2F7777772E77332E6F72672F313939
          392F786C696E6B222076696577426F783D22302030203332203332223E0D0A09
          3C7374796C6520747970653D22746578742F637373223E2E59656C6C6F777B66
          696C6C3A234646423131357D3C2F7374796C653E0D0A093C7265637420636C61
          73733D2259656C6C6F772220783D22302220793D2230222077696474683D2233
          3222206865696768743D223332222F3E0D0A3C2F7376673E0D0A}
        Keywords = 'Yellow'
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E312220786D6C6E73
          3D22687474703A2F2F7777772E77332E6F72672F323030302F7376672220786D
          6C6E733A786C696E6B3D22687474703A2F2F7777772E77332E6F72672F313939
          392F786C696E6B222076696577426F783D22302030203332203332223E0D0A09
          3C7374796C6520747970653D22746578742F637373223E2E57686974657B6669
          6C6C3A234646464646467D3C2F7374796C653E0D0A093C7265637420636C6173
          733D2257686974652220783D22302220793D2230222077696474683D22333222
          206865696768743D223332222F3E0D0A3C2F7376673E0D0A}
        Keywords = 'White'
      end>
  end
  inherited dxLayoutLookAndFeelList1: TdxLayoutLookAndFeelList
    Left = 304
    inherited dxLayoutCxLookAndFeel1: TdxLayoutCxLookAndFeel
      PixelsPerInch = 96
    end
    object dxLayoutCxLookAndFeelCompact: TdxLayoutCxLookAndFeel
      Offsets.ControlOffsetVert = 0
      Offsets.ItemOffset = 0
      LookAndFeel.NativeStyle = True
      PixelsPerInch = 96
    end
  end
  object alActions: TActionList
    OnUpdate = alActionsUpdate
    Left = 272
    Top = 152
    object actAddLibraryCollection: TAction
      Hint = 'Add a custom collection'
      OnExecute = actAddLibraryCollectionExecute
    end
    object actRemoveCollectionVector: TAction
      Hint = 'Remove the selected collection'
      OnExecute = actRemoveCollectionVectorExecute
    end
    object actRemoveCollectionRaster: TAction
      Hint = 'Remove the selected collection'
      OnExecute = actRemoveCollectionRasterExecute
    end
  end
  object ilCollections: TcxImageList
    SourceDPI = 96
    FormatVersion = 1
    Left = 368
    Top = 256
    Bitmap = {
      494C010102000800040010001000FFFFFFFF2110FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
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
      000000000008071E0071166401CD219402F9219502F9166501CF071F00730000
      0009000000000000000000000000000000000000000000000000000000000000
      00000000000805052971121287CD1A1AC7F91A1AC7F9121289CF05052A730000
      0009000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000001
      001C176901D2229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF186C
      02D40002001E0000000000000000000000000000000000000000000000000000
      021C12128DD21B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1313
      90D40000021E0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000071769
      02D1229C02FF229C02FF229C02FF0000000000000000229C02FF229C02FF229C
      02FF186C02D40000000900000000000000000000000000000000000000071212
      8DD11B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1B
      D1FF131390D40000000900000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000061D006F229C
      02FF229C02FF229C02FF229C02FF0000000000000000229C02FF229C02FF229C
      02FF229C02FF071F0073000000000000000000000000000000000505276F1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF05052A7300000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000166101CA229C
      02FF229C02FF229C02FF229C02FF0000000000000000229C02FF229C02FF229C
      02FF229C02FF166501CE00000000000000000000000000000000111183CA1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF121288CE00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000209102F6229C
      02FF000000000000000000000000000000000000000000000000000000000000
      0000229C02FF219502F9000000000000000000000000000000001919C2F61B1B
      D1FF000000000000000000000000000000000000000000000000000000000000
      00001B1BD1FF1A1AC7F900000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000001F9002F5229C
      02FF000000000000000000000000000000000000000000000000000000000000
      0000229C02FF219502F9000000000000000000000000000000001919C1F51B1B
      D1FF000000000000000000000000000000000000000000000000000000000000
      00001B1BD1FF1A1AC7F900000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000156001C9229C
      02FF229C02FF229C02FF229C02FF0000000000000000229C02FF229C02FF229C
      02FF229C02FF166401CD00000000000000000000000000000000111182C91B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF121287CD00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000061C006D229C
      02FF229C02FF229C02FF229C02FF0000000000000000229C02FF229C02FF229C
      02FF229C02FF071E0071000000000000000000000000000000000505266D1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF0505297100000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000071666
      01CF229C02FF229C02FF229C02FF0000000000000000229C02FF229C02FF229C
      02FF176A02D20000000800000000000000000000000000000000000000071212
      8ACF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1B
      D1FF12128DD20000000800000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000001
      001A166601CF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF1769
      01D10001001C0000000000000000000000000000000000000000000000000000
      021A12128ACF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1212
      8DD10000021C0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000007061C006D156001C9209002F5209002F5166201CB061D006F0000
      0007000000000000000000000000000000000000000000000000000000000000
      0000000000070505266D111182C91919C1F51919C1F5111184CB0505276F0000
      0007000000000000000000000000000000000000000000000000000000000000
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
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000}
    DesignInfo = 16777584
    ImageInfo = <
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
          7B6F7061636974793A302E353B7D3C2F7374796C653E0D0A3C672069643D2241
          6464436972636C6564223E0D0A09093C7061746820636C6173733D2247726565
          6E2220643D224D31362C3443392E342C342C342C392E342C342C313673352E34
          2C31322C31322C31327331322D352E342C31322D31325332322E362C342C3136
          2C347A204D32342C3138682D367636682D34762D364838762D34683656386834
          763668365631387A222F3E0D0A093C2F673E0D0A3C2F7376673E0D0A}
        FileName = 'SVG Images\Icon Builder\Actions_AddCircled.svg'
        Keywords = 'Icon Builder;Actions;AddCircled'
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
          7B6F7061636974793A302E353B7D3C2F7374796C653E0D0A3C672069643D2252
          656D6F7665436972636C6564223E0D0A09093C7061746820636C6173733D2252
          65642220643D224D31362C3443392E342C342C342C392E342C342C313673352E
          342C31322C31322C31327331322D352E342C31322D31325332322E362C342C31
          362C347A204D32342C31384838762D346831365631387A222F3E0D0A093C2F67
          3E0D0A3C2F7376673E0D0A}
        FileName = 'SVG Images\Icon Builder\Actions_RemoveCircled.svg'
        Keywords = 'Icon Builder;Actions;RemoveCircled'
      end>
  end
  object tmrSearchInGallery: TTimer
    Interval = 500
    OnTimer = tmrSearchInGalleryTimer
    Left = 440
  end
end
