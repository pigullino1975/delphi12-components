inherited MailClientDemoContactsFrame: TMailClientDemoContactsFrame
  Height = 755
  ExplicitHeight = 755
  inherited PanelGrid: TdxPanel
    Top = 174
    Height = 581
    ExplicitTop = 174
    ExplicitHeight = 581
    inherited grMain: TcxGrid
      Height = 547
      ExplicitHeight = 547
      inherited tvMain: TcxGridDBTableView
        OnDblClick = tvMainDblClick
        OnFocusedRecordChanged = tvMain1FocusedRecordChanged
        DataController.DataSource = DM.dsContacts
        DataController.Summary.SummaryGroups = <
          item
            Links = <
              item
                Column = dbcNameFirstSymbol
              end
              item
                Column = dbcState
              end>
            SummaryItems = <
              item
                Kind = skCount
                Column = dbcNameFirstSymbol
              end>
          end>
        OptionsCustomize.ColumnHidingOnGrouping = False
        OptionsData.Editing = False
        OptionsData.Inserting = False
        OptionsSelection.CellSelect = False
        OptionsView.GroupByBox = False
        object dbcCustomerID: TcxGridDBColumn
          DataBinding.FieldName = 'CustomerId'
          Visible = False
          Width = 20
        end
        object dbcGender: TcxGridDBColumn
          DataBinding.FieldName = 'Gender'
          RepositoryItem = DM.edrepMainImagesGender
          OnCustomDrawCell = dbcGenderCustomDrawCell
          Width = 30
          IsCaptionAssigned = True
        end
        object dbcName: TcxGridDBColumn
          DataBinding.FieldName = 'Name'
          OnCustomDrawCell = CustomDrawHighligtingCell
          Options.FilteringPopupIncrementalFiltering = True
          Width = 105
        end
        object dbcMiddleName: TcxGridDBColumn
          DataBinding.FieldName = 'MiddleName'
          Visible = False
          Width = 118
        end
        object dbcEmail: TcxGridDBColumn
          DataBinding.FieldName = 'Email'
          OnCustomDrawCell = CustomDrawHighligtingCell
          Width = 159
        end
        object dbcState: TcxGridDBColumn
          DataBinding.FieldName = 'State'
          PropertiesClassName = 'TcxTextEditProperties'
          Properties.Alignment.Horz = taCenter
          OnCustomDrawCell = CustomDrawHighligtingCell
          Options.FilteringPopupIncrementalFiltering = True
          Options.FilteringPopupIncrementalFilteringOptions = [ifoHighlightSearchText]
          Width = 51
        end
        object dbcCity: TcxGridDBColumn
          DataBinding.FieldName = 'City'
          OnCustomDrawCell = CustomDrawHighligtingCell
          Options.FilteringPopupIncrementalFiltering = True
          Options.FilteringPopupIncrementalFilteringOptions = [ifoHighlightSearchText]
          Width = 121
        end
        object dbcPhone: TcxGridDBColumn
          DataBinding.FieldName = 'Phone'
          OnCustomDrawCell = CustomDrawHighligtingCell
          Width = 163
        end
        object dbcComments: TcxGridDBColumn
          DataBinding.FieldName = 'Comments'
          Visible = False
          Width = 20
        end
        object dbcPhoto: TcxGridDBColumn
          DataBinding.FieldName = 'Photo'
          Visible = False
          Width = 20
        end
        object dbcDiscountLevel: TcxGridDBColumn
          DataBinding.FieldName = 'DiscountLevel'
          Visible = False
          Width = 20
        end
        object dbcFirstName: TcxGridDBColumn
          DataBinding.FieldName = 'FirstName'
          Visible = False
          Width = 20
        end
        object dbcLastName: TcxGridDBColumn
          DataBinding.FieldName = 'LastName'
          Visible = False
          Width = 20
        end
        object dbcBirthDate: TcxGridDBColumn
          DataBinding.FieldName = 'BirthDate'
          Visible = False
          Width = 20
        end
        object dbcNameFirstSymbol: TcxGridDBColumn
          Caption = 'Name'
          DataBinding.FieldName = 'Name1'
          Visible = False
        end
      end
      object cvContacts: TcxGridDBCardView [1]
        OnDblClick = tvMainDblClick
        Navigator.Buttons.CustomButtons = <>
        ScrollbarAnnotations.CustomAnnotations = <>
        OnGetCellHeight = cvContactsGetCellHeight
        DataController.DataSource = DM.dsContacts
        DataController.Filter.Options = [fcoCaseInsensitive]
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        DataController.OnDataChanged = tvMainDataControllerDataChanged
        OptionsCustomize.LayeredRows = True
        OptionsData.Deleting = False
        OptionsData.Editing = False
        OptionsData.Inserting = False
        OptionsView.FocusRect = False
        OptionsView.CardIndent = 7
        OptionsView.CardWidth = 300
        OptionsView.CellAutoHeight = True
        OptionsView.LayerSeparatorWidth = 2
        RowLayout = rlVertical
        Styles.OnGetContentStyle = cvContactsStylesGetContentStyle
        object ciPhoto: TcxGridDBCardViewRow
          DataBinding.FieldName = 'Photo'
          PropertiesClassName = 'TcxImageProperties'
          Properties.FitMode = ifmProportionalStretch
          Properties.GraphicClassName = 'TdxSmartImage'
          Options.ShowCaption = False
          Position.BeginsLayer = True
          Position.Width = 100
        end
        object ciName: TcxGridDBCardViewRow
          DataBinding.FieldName = 'Name'
          OnCustomDrawCell = CustomDrawHighligtingCell
          Options.ShowCaption = False
          Position.BeginsLayer = True
          Position.LineCount = 2
        end
        object ciPhone: TcxGridDBCardViewRow
          DataBinding.FieldName = 'Phone'
          OnCustomDrawCell = CustomDrawHighligtingCell
          Options.ShowCaption = False
          Position.BeginsLayer = False
          Position.LineCount = 2
        end
        object ciEmail: TcxGridDBCardViewRow
          DataBinding.FieldName = 'Email'
          OnCustomDrawCell = CustomDrawHighligtingCell
          Options.ShowCaption = False
          Position.BeginsLayer = False
          Position.LineCount = 3
        end
        object ciAddress: TcxGridDBCardViewRow
          Caption = 'Address'
          DataBinding.FieldName = 'FullAddress'
          OnCustomDrawCell = CustomDrawHighligtingCell
          Options.ShowCaption = False
          Position.BeginsLayer = False
          Position.LineCount = 2
        end
      end
    end
  end
  object lcCurrentView: TdxLayoutControl [1]
    Left = 48
    Top = 230
    Width = 193
    Height = 179
    TabOrder = 5
    LayoutLookAndFeel = fmMailClientDemoMain.dxLayoutSkinLookAndFeel1
    object rbViewList: TcxRadioButton
      Left = 7
      Top = 7
      Width = 179
      Height = 17
      Action = actContactViewList
      TabOrder = 0
      AutoSize = True
      GroupIndex = 1
      Transparent = True
    end
    object rbViewAlphabetical: TcxRadioButton
      Left = 7
      Top = 33
      Action = actContactViewAlphabetical
      TabOrder = 1
      AutoSize = True
      GroupIndex = 1
      Transparent = True
    end
    object rbViewByState: TcxRadioButton
      Left = 7
      Top = 59
      Action = actContactViewByState
      TabOrder = 2
      AutoSize = True
      GroupIndex = 1
      Transparent = True
    end
    object rbViewCard: TcxRadioButton
      Left = 7
      Top = 98
      Action = actContactViewCard
      TabOrder = 3
      AutoSize = True
      GroupIndex = 1
      Transparent = True
    end
    object lcCurrentViewGroup_Root: TdxLayoutGroup
      AlignHorz = ahClient
      AlignVert = avClient
      Hidden = True
      ShowBorder = False
      Index = -1
    end
    object lcCurrentViewItem1: TdxLayoutItem
      Parent = lcCurrentViewGroup_Root
      CaptionOptions.Text = 'cxRadioButton1'
      CaptionOptions.Visible = False
      Control = rbViewList
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 171
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lcCurrentViewItem2: TdxLayoutItem
      Parent = lcCurrentViewGroup_Root
      CaptionOptions.Text = 'cxRadioButton2'
      CaptionOptions.Visible = False
      Control = rbViewAlphabetical
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 171
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lcCurrentViewItem3: TdxLayoutItem
      Parent = lcCurrentViewGroup_Root
      CaptionOptions.Text = 'cxRadioButton3'
      CaptionOptions.Visible = False
      Control = rbViewByState
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 171
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object lcCurrentViewItem4: TdxLayoutItem
      Parent = lcCurrentViewGroup_Root
      CaptionOptions.Text = 'cxRadioButton4'
      CaptionOptions.Visible = False
      Control = rbViewCard
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 171
      ControlOptions.ShowBorder = False
      Index = 4
    end
    object lcCurrentViewSeparatorItem1: TdxLayoutSeparatorItem
      Parent = lcCurrentViewGroup_Root
      SizeOptions.AssignedValues = [sovSizableHorz, sovSizableVert]
      SizeOptions.SizableHorz = False
      SizeOptions.SizableVert = False
      CaptionOptions.Text = 'Separator'
      Index = 3
    end
  end
  inherited PanelMain: TdxPanel
    Top = 174
    Height = 581
    ExplicitTop = 174
    ExplicitHeight = 581
    inherited lcMain: TdxLayoutControl
      AlignWithMargins = True
      Left = 4
      Width = 524
      Height = 579
      Margins.Left = 4
      Margins.Right = 4
      ExplicitHeight = 579
      inherited lblSubject: TcxLabel
        Top = 13
        ExplicitTop = 13
        ExplicitWidth = 524
        Width = 524
      end
      inherited cxreMain: TcxRichEdit
        Top = 254
        TabOrder = 2
        ExplicitTop = 254
        ExplicitWidth = 516
        ExplicitHeight = 312
        Height = 312
        Width = 516
      end
      object sbPhoto: TcxScrollBox [2]
        Left = 0
        Top = 96
        Width = 524
        Height = 155
        HorzScrollBar.Tracking = True
        TabOrder = 1
        VertScrollBar.Tracking = True
        OnResize = sbPhotoResize
        object cxdbimgPhoto: TcxDBImage
          Left = 0
          Top = 0
          DataBinding.DataField = 'Photo'
          Properties.FitMode = ifmProportionalStretch
          Properties.GraphicClassName = 'TdxSmartImage'
          Style.HotTrack = False
          TabOrder = 0
          Height = 100
          Width = 100
        end
      end
      inherited lgContentCaption: TdxLayoutGroup
        Visible = False
      end
      inherited liRich: TdxLayoutItem
        Index = 2
      end
      object liPhoto: TdxLayoutItem
        Parent = lgRich
        CaptionOptions.Visible = False
        Control = sbPhoto
        ControlOptions.OriginalHeight = 155
        ControlOptions.OriginalWidth = 229
        ControlOptions.ShowBorder = False
        Index = 1
      end
    end
  end
  inherited bmFrame: TdxBarManager
    PixelsPerInch = 96
    DockControlHeights = (
      0
      0
      174
      0)
    object bmFrameBar1: TdxBar
      Caption = 'New / Edit'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 1296
      FloatTop = 0
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'lbContactNew'
        end
        item
          Visible = True
          ItemName = 'lbContactEdit'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'lbContactDelete'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object bmFrameBar2: TdxBar
      Caption = 'Current View'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 58
      DockingStyle = dsTop
      FloatLeft = 1296
      FloatTop = 0
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'lbViewList'
        end
        item
          Visible = True
          ItemName = 'lbViewAlphabetical'
        end
        item
          Visible = True
          ItemName = 'lbViewByState'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'lbViewCard'
        end>
      OneOnRow = True
      Row = 1
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object bmFrameBar3: TdxBar
      Caption = 'Layout'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 116
      DockingStyle = dsTop
      FloatLeft = 1296
      FloatTop = 0
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'lbContactFlip'
        end>
      OneOnRow = True
      Row = 2
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object lbContactNew: TdxBarLargeButton
      Action = actContactNew
      Category = 0
      ScreenTip = DM.stContactNew
      SyncImageIndex = False
      ImageIndex = 53
    end
    object lbContactDelete: TdxBarLargeButton
      Action = actContactDelete
      Category = 0
      ScreenTip = DM.stContactDelete
      SyncImageIndex = False
      ImageIndex = 5
    end
    object lbContactEdit: TdxBarLargeButton
      Action = actContactEdit
      Category = 0
      ScreenTip = DM.stContactEdit
      SyncImageIndex = False
      ImageIndex = 54
    end
    object lbContactFlip: TdxBarLargeButton
      Action = actLayoutFlip
      Category = 0
      ScreenTip = DM.stFlip
    end
    object lbViewList: TdxBarLargeButton
      Action = actContactViewList
      Category = 0
      ButtonStyle = bsChecked
      GroupIndex = 1
    end
    object lbViewCard: TdxBarLargeButton
      Action = actContactViewCard
      Category = 0
      ButtonStyle = bsChecked
      GroupIndex = 1
      SyncImageIndex = False
      ImageIndex = 25
    end
    object lbViewByState: TdxBarLargeButton
      Action = actContactViewByState
      Category = 0
      ButtonStyle = bsChecked
      GroupIndex = 1
    end
    object lbViewAlphabetical: TdxBarLargeButton
      Action = actContactViewAlphabetical
      Category = 0
      ButtonStyle = bsChecked
      GroupIndex = 1
    end
  end
  inherited alFrame: TActionList
    object actContactNew: TAction
      Caption = 'New Contact'
      ImageIndex = 5
      OnExecute = actContactNewExecute
    end
    object actContactEdit: TAction
      Caption = 'Edit Contact'
      ImageIndex = 6
      OnExecute = actContactEditExecute
    end
    object actContactDelete: TAction
      Caption = 'Delete'
      ImageIndex = 1
      OnExecute = actContactDeleteExecute
    end
    object actContactViewList: TAction
      AutoCheck = True
      Caption = 'List'
      GroupIndex = 1
      ImageIndex = 9
      OnExecute = actContactViewExecute
    end
    object actContactViewAlphabetical: TAction
      Tag = 1
      AutoCheck = True
      Caption = 'Alphabetical'
      GroupIndex = 1
      ImageIndex = 10
      OnExecute = actContactViewExecute
    end
    object actContactViewByState: TAction
      Tag = 2
      AutoCheck = True
      Caption = 'By State'
      GroupIndex = 1
      ImageIndex = 8
      OnExecute = actContactViewExecute
    end
    object actContactViewCard: TAction
      Tag = 3
      AutoCheck = True
      Caption = 'Card'
      GroupIndex = 1
      ImageIndex = 7
      OnExecute = actContactViewExecute
    end
  end
  inherited ComponentPrinter: TdxComponentPrinter
    CurrentLink = ComponentPrinterLink1
    PixelsPerInch = 96
    object ComponentPrinterLink1: TdxGridReportLink
      Component = grMain
      DateFormat = 0
      PageNumberFormat = pnfNumeral
      PrinterPage.DMPaper = 1
      PrinterPage.Footer = 200
      PrinterPage.Header = 200
      PrinterPage.Margins.Bottom = 500
      PrinterPage.Margins.Left = 500
      PrinterPage.Margins.Right = 500
      PrinterPage.Margins.Top = 500
      PrinterPage.PageSize.X = 8500
      PrinterPage.PageSize.Y = 11000
      PrinterPage._dxMeasurementUnits_ = 0
      PrinterPage._dxLastMU_ = 1
      TimeFormat = 0
      PixelsPerInch = 96
      BuiltInReportLink = True
    end
  end
  inherited dxLayoutLookAndFeelList1: TdxLayoutLookAndFeelList
    inherited lslfGroup: TdxLayoutSkinLookAndFeel
      PixelsPerInch = 96
    end
    inherited lslfMain: TdxLayoutSkinLookAndFeel
      PixelsPerInch = 96
    end
  end
  object cxStyleRepository1: TcxStyleRepository
    Left = 160
    Top = 128
    PixelsPerInch = 96
    object stName: TcxStyle
      AssignedValues = [svFont]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
    end
  end
end
