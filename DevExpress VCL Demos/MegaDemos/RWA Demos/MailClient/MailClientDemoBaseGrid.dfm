inherited MailClientDemoBaseGridFrame: TMailClientDemoBaseGridFrame
  Width = 1286
  Height = 756
  OnResize = FrameResize
  ExplicitWidth = 1286
  ExplicitHeight = 756
  object PanelGrid: TdxPanel [0]
    Left = 0
    Top = 0
    Width = 836
    Height = 756
    Align = alClient
    Frame.Scale = False
    Frame.Visible = False
    TabOrder = 1
    object PanelFilter: TdxPanel
      Left = 0
      Top = 0
      Width = 836
      Height = 37
      Align = alTop
      Frame.Borders = []
      Frame.Scale = False
      TabOrder = 1
      object PanelButtons: TdxPanel
        Left = 674
        Top = 0
        Width = 162
        Height = 37
        Align = alRight
        Frame.Scale = False
        Frame.Visible = False
        TabOrder = 0
        ExplicitHeight = 34
        object cxbSearch: TcxButton
          Left = 5
          Top = 5
          Width = 71
          Height = 23
          Caption = 'Search'
          OptionsImage.ImageIndex = 22
          OptionsImage.Images = DM.cxGridsImageList_16
          TabOrder = 0
          OnClick = cxbSearchClick
        end
        object cxbSearchClear: TcxButton
          Left = 80
          Top = 5
          Width = 75
          Height = 23
          Caption = 'Clear'
          OptionsImage.ImageIndex = 23
          OptionsImage.Images = DM.cxGridsImageList_16
          TabOrder = 1
          OnClick = cxbSearchClearClick
        end
      end
      object PanelSearch: TdxPanel
        Left = 0
        Top = 0
        Width = 674
        Height = 37
        Align = alClient
        Frame.Scale = False
        Frame.Visible = False
        TabOrder = 1
        ExplicitWidth = 577
        ExplicitHeight = 35
        DesignSize = (
          674
          37)
        object mrueSearch: TcxMRUEdit
          Left = 4
          Top = 5
          Margins.Left = 5
          Margins.Top = 5
          Anchors = [akLeft, akTop, akRight]
          Properties.ImmediatePost = True
          Properties.ShowEllipsis = False
          Properties.OnChange = mrueSearchPropertiesChange
          Style.Edges = [bLeft, bTop, bRight, bBottom]
          Style.HotTrack = False
          Style.Shadow = False
          Style.TransparentBorder = False
          TabOrder = 0
          Height = 23
          Width = 668
        end
      end
    end
    object grMain: TcxGrid
      Left = 0
      Top = 37
      Width = 836
      Height = 723
      Align = alClient
      BorderStyle = cxcbsNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      ExplicitTop = 36
      ExplicitWidth = 743
      ExplicitHeight = 718
      object tvMain: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        ScrollbarAnnotations.CustomAnnotations = <>
        DataController.Filter.Options = [fcoCaseInsensitive]
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <
          item
            Kind = skCount
          end>
        DataController.Summary.SummaryGroups = <>
        DataController.OnDataChanged = tvMainDataControllerDataChanged
        OptionsView.CellEndEllipsis = True
        OptionsView.FocusRect = False
        OptionsView.ColumnAutoWidth = True
        OptionsView.GridLines = glHorizontal
        OptionsView.HeaderFilterButtonShowMode = fbmSmartTag
        Styles.UseOddEvenStyles = bFalse
      end
      object grMainLevel1: TcxGridLevel
        GridView = tvMain
      end
    end
  end
  object PanelMain: TdxPanel [1]
    Left = 836
    Top = 0
    Width = 450
    Height = 756
    Align = alRight
    Frame.Borders = [bLeft]
    Frame.Drag.DetectionAreaSize = 6
    Frame.Drag.Enabled = True
    Frame.Scale = False
    TabOrder = 0
    object lcMain: TdxLayoutControl
      Left = 0
      Top = 0
      Width = 449
      Height = 756
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alClient
      TabOrder = 0
      LayoutLookAndFeel = lslfMain
      ExplicitLeft = 6
      ExplicitWidth = 526
      ExplicitHeight = 754
      object lblSubject: TcxLabel
        Left = 8
        Top = 7
        Caption = 'Subject'
        ParentFont = False
        Style.Font.Charset = DEFAULT_CHARSET
        Style.Font.Color = clWindowText
        Style.Font.Height = -19
        Style.Font.Name = 'Segoe UI'
        Style.Font.Style = [fsBold]
        Style.HotTrack = False
        Style.TransparentBorder = True
        Style.IsFontAssigned = True
        Properties.WordWrap = True
        Transparent = True
        Width = 449
      end
      object cxreMain: TcxRichEdit
        Left = 8
        Top = 90
        Properties.AllowObjects = True
        Properties.AutoURLDetect = True
        Properties.ReadOnly = True
        Properties.ScrollBars = ssVertical
        Properties.OnURLClick = cxreMainPropertiesURLClick
        Style.Edges = []
        Style.HotTrack = False
        TabOrder = 1
        Height = 659
        Width = 441
      end
      object lgRoot: TdxLayoutGroup
        AlignHorz = ahClient
        AlignVert = avClient
        Hidden = True
        LayoutDirection = ldHorizontal
        ShowBorder = False
        Index = -1
      end
      object lgRich: TdxLayoutGroup
        Parent = lgRoot
        AlignHorz = ahClient
        AlignVert = avClient
        CaptionOptions.Text = 'New Group'
        CaptionOptions.Visible = False
        LayoutLookAndFeel = lslfGroup
        ShowBorder = False
        Index = 0
      end
      object liSubject: TdxLayoutItem
        Parent = lgContentCaption
        AlignHorz = ahClient
        AlignVert = avTop
        Offsets.Left = 8
        CaptionOptions.Text = 'cxLabel1'
        CaptionOptions.Visible = False
        Control = lblSubject
        ControlOptions.OriginalHeight = 29
        ControlOptions.OriginalWidth = 70
        ControlOptions.ShowBorder = False
        Index = 0
      end
      object lgContentCaption: TdxLayoutGroup
        Parent = lgRich
        AlignHorz = ahClient
        CaptionOptions.Text = 'New Group'
        CaptionOptions.Visible = False
        ShowBorder = False
        Index = 0
      end
      object liSpace: TdxLayoutEmptySpaceItem
        Parent = lgContentCaption
        AlignHorz = ahClient
        AlignVert = avClient
        SizeOptions.Height = 10
        SizeOptions.Width = 10
        CaptionOptions.Text = 'Empty Space Item'
        Index = 1
      end
      object liRich: TdxLayoutItem
        Parent = lgRich
        AlignHorz = ahClient
        AlignVert = avClient
        Padding.Left = 8
        Padding.Right = 8
        Padding.AssignedValues = [lpavLeft, lpavRight]
        CaptionOptions.Text = 'cxRichEdit1'
        CaptionOptions.Visible = False
        Control = cxreMain
        ControlOptions.OriginalHeight = 653
        ControlOptions.OriginalWidth = 583
        ControlOptions.ShowBorder = False
        Index = 1
      end
      object liFrom: TdxLayoutLabeledItem
        Parent = lgContentCaption
        AlignHorz = ahLeft
        AlignVert = avTop
        Offsets.Left = 8
        CaptionOptions.Text = 'From:'
        Index = 2
      end
      object liDate: TdxLayoutLabeledItem
        Parent = lgContentCaption
        AlignHorz = ahLeft
        AlignVert = avTop
        Offsets.Left = 8
        CaptionOptions.Text = 'Date:'
        Index = 3
      end
    end
  end
  inherited bmFrame: TdxBarManager
    PixelsPerInch = 96
    Left = 552
    Top = 288
  end
  inherited alFrame: TActionList
    Left = 616
    Top = 400
    object actLayoutFlip: TAction
      Category = 'Common'
      Caption = 'Flip'
      ImageIndex = 3
      OnExecute = actLayoutFlipExecute
    end
    object actLayoutRotate: TAction
      Category = 'Common'
      Caption = 'Rotate'
      ImageIndex = 2
      OnExecute = actLayoutRotateExecute
    end
  end
  inherited ComponentPrinter: TdxComponentPrinter
    PixelsPerInch = 96
    Left = 576
    Top = 576
  end
  object AutoSearchTimer: TTimer
    Enabled = False
    Interval = 500
    OnTimer = AutoSearchTimerTimer
    Left = 416
    Top = 8
  end
  object dxLayoutLookAndFeelList1: TdxLayoutLookAndFeelList
    Left = 88
    Top = 88
    object lslfGroup: TdxLayoutSkinLookAndFeel
      Offsets.RootItemsAreaOffsetHorz = 0
      Offsets.RootItemsAreaOffsetVert = 0
      PixelsPerInch = 96
    end
    object lslfMain: TdxLayoutSkinLookAndFeel
      Offsets.ItemOffset = 0
      Offsets.RootItemsAreaOffsetHorz = 0
      Offsets.RootItemsAreaOffsetVert = 4
      PixelsPerInch = 96
    end
  end
end
