inherited MailClientDemoMailsFrame: TMailClientDemoMailsFrame
  inherited PanelGrid: TdxPanel
    Top = 200
    Height = 556
    ExplicitTop = 200
    ExplicitWidth = 752
    ExplicitHeight = 556
    inherited PanelFilter: TdxPanel
      ExplicitWidth = 751
      inherited PanelButtons: TdxPanel
        ExplicitLeft = 585
      end
      inherited PanelSearch: TdxPanel
        ExplicitWidth = 585
        inherited mrueSearch: TcxMRUEdit
          ExplicitHeight = 21
        end
      end
    end
    inherited grMain: TcxGrid
      Height = 518
      ExplicitWidth = 751
      ExplicitHeight = 518
      inherited tvMain: TcxGridDBTableView
        PopupMenu = pmMails
        OnKeyDown = tvMainKeyDown
        OnCellClick = tvMainCellClick
        OnCellDblClick = tvMainCellDblClick
        OnFocusedRecordChanged = tvMainFocusedRecordChanged
        OnSelectionChanged = tvMainSelectionChanged
        DataController.DataSource = DM.dsMails
        DataController.KeyFieldNames = 'ID'
        DataController.Summary.SummaryGroups = <
          item
            Links = <
              item
                Column = dbcPriority
              end
              item
                Column = dbcSubject
              end
              item
                Column = dbcIsUnread
              end
              item
                Column = dbcFrom
              end
              item
                Column = dbcAttachment
              end
              item
                Column = dbcDateOnly
              end>
            SummaryItems = <
              item
                Format = '# messages'
                Kind = skCount
                OnGetText = tvMainTcxGridDBDataControllerTcxDataSummarySummaryGroups0SummaryItems0GetText
              end>
          end>
        DataController.OnGroupingChanged = tvMainDataControllerGroupingChanged
        DateTimeHandling.Filters = [dtfRelativeDays, dtfRelativeDayPeriods, dtfMonths]
        DateTimeHandling.IgnoreTimeForFiltering = True
        DateTimeHandling.Grouping = dtgByDate
        OptionsCustomize.ColumnHidingOnGrouping = False
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsData.Editing = False
        OptionsData.Inserting = False
        OptionsSelection.CellSelect = False
        OptionsSelection.MultiSelect = True
        Styles.OnGetContentStyle = tvMainStylesGetContentStyle
        object dbcID: TcxGridDBColumn
          DataBinding.FieldName = 'ID'
          Visible = False
        end
        object dbcBoxID: TcxGridDBColumn
          DataBinding.FieldName = 'BoxID'
          Visible = False
          Width = 32
        end
        object dbcPriority: TcxGridDBColumn
          DataBinding.FieldName = 'Priority'
          PropertiesClassName = 'TcxImageComboBoxProperties'
          Properties.DropDownRows = 3
          Properties.Items = <>
          RepositoryItem = DM.edrepMainImagesPriority
          HeaderGlyph.SourceDPI = 96
          HeaderGlyph.Data = {
            3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
            462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
            617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
            2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
            77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
            22307078222076696577426F783D2230203020313620313622207374796C653D
            22656E61626C652D6261636B67726F756E643A6E657720302030203136203136
            3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
            303B3C7374796C6520747970653D22746578742F6373732220786D6C3A737061
            63653D227072657365727665223E2E426C61636B7B66696C6C3A233732373237
            323B7D262331333B262331303B2623393B2E5265647B66696C6C3A2344313143
            31433B7D262331333B262331303B2623393B2E59656C6C6F777B66696C6C3A23
            4646423131353B7D262331333B262331303B2623393B2E477265656E7B66696C
            6C3A233033394332333B7D3C2F7374796C653E0D0A3C672069643D225761726E
            696E67436972636C656432223E0D0A09093C636972636C6520636C6173733D22
            426C61636B222063783D2238222063793D2231312220723D2231222F3E0D0A09
            093C7265637420783D22372220793D22332220636C6173733D22426C61636B22
            2077696474683D223222206865696768743D2236222F3E0D0A093C2F673E0D0A
            3C2F7376673E0D0A}
          HeaderGlyphAlignmentHorz = taCenter
          MinWidth = 25
          Options.HorzSizing = False
          Options.ShowCaption = False
          Options.SortByDisplayText = isbtOff
          Width = 25
        end
        object dbcAttachment: TcxGridDBColumn
          Caption = 'Attachment'
          DataBinding.FieldName = 'IsAttachment'
          RepositoryItem = DM.edrepMainImagesAttachment
          HeaderGlyph.SourceDPI = 96
          HeaderGlyph.SourceHeight = 16
          HeaderGlyph.SourceWidth = 16
          HeaderGlyph.Data = {
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
            6173733D22426C61636B2220643D224D32322C313076313363302C322E382D32
            2E322C352D352C35732D352D322E322D352D35563763302D312E372C312E332D
            332C332D3373332C312E332C332C3376313663302C302E362D302E342C312D31
            2C31732D312D302E342D312D31563130682D3276313320202623393B63302C31
            2E372C312E332C332C332C3373332D312E332C332D33563763302D322E382D32
            2E322D352D352D35732D352C322E322D352C3576313663302C332E392C332E31
            2C372C372C3773372D332E312C372D375631304832327A222F3E0D0A3C2F7376
            673E0D0A}
          HeaderGlyphAlignmentHorz = taCenter
          MinWidth = 25
          Options.HorzSizing = False
          Options.ShowCaption = False
          Options.SortByDisplayText = isbtOff
          Width = 25
        end
        object dbcIsUnread: TcxGridDBColumn
          DataBinding.FieldName = 'IsUnread'
          PropertiesClassName = 'TcxTextEditProperties'
          RepositoryItem = DM.edrepMainImagesStatus
          HeaderGlyph.SourceDPI = 96
          HeaderGlyph.SourceHeight = 16
          HeaderGlyph.SourceWidth = 16
          HeaderGlyph.Data = {
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
            31353B7D262331333B262331303B2623393B2E426C61636B7B66696C6C3A2337
            32373237323B7D3C2F7374796C653E0D0A3C706174682069643D224E65775F43
            6F6D6D656E742220636C6173733D2259656C6C6F772220643D224D32352C396C
            322D32763368336C2D322C326C322C32682D3376336C2D322D326C2D322C3276
            2D33682D336C322D326C2D322D32683356374C32352C397A222F3E0D0A3C706F
            6C79676F6E20636C6173733D22426C61636B2220706F696E74733D2232362C31
            382032362C323220342C323220342C31322032302C31322031382C313020322C
            313020322C32342032382C32342032382C32332032382C32322032382C323020
            222F3E0D0A3C2F7376673E0D0A}
          HeaderGlyphAlignmentHorz = taCenter
          MinWidth = 35
          Options.HorzSizing = False
          Options.ShowCaption = False
          Options.SortByDisplayText = isbtOff
          Width = 35
        end
        object dbcDateOnly: TcxGridDBColumn
          DataBinding.FieldName = 'DateOnly'
          PropertiesClassName = 'TcxDateEditProperties'
          OnGetFilterValues = dbcDateOnlyGetFilterValues
          DateTimeGrouping = dtgRelativeToToday
          GroupIndex = 0
          SortIndex = 0
          SortOrder = soDescending
          Width = 76
        end
        object dbcDate: TcxGridDBColumn
          DataBinding.FieldName = 'Date'
          PropertiesClassName = 'TcxDateEditProperties'
          Properties.ShowTime = False
          Visible = False
          DateTimeGrouping = dtgRelativeToToday
          Width = 88
        end
        object dbcSubject: TcxGridDBColumn
          DataBinding.FieldName = 'Subject'
          OnCustomDrawCell = CustomDrawHighligtingCell
          Options.FilteringPopupIncrementalFiltering = True
          Width = 241
        end
        object dbcFrom: TcxGridDBColumn
          DataBinding.FieldName = 'From'
          OnCustomDrawCell = CustomDrawHighligtingCell
          Width = 160
        end
        object dbcIsUnreadSwitch: TcxGridDBColumn
          DataBinding.FieldName = 'IsUnread'
          RepositoryItem = DM.edrepMainImagesStatusSwitch
          HeaderGlyph.SourceDPI = 96
          HeaderGlyph.Data = {
            3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
            462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
            617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
            2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
            77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
            22307078222076696577426F783D2230203020313620313622207374796C653D
            22656E61626C652D6261636B67726F756E643A6E657720302030203136203136
            3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
            303B3C672069643D225761726E696E67436972636C656432223E0D0A09093C63
            6972636C652066696C6C3D226E6F6E6522207374726F6B653D22233732373237
            3222207374726F6B652D77696474683D2231222063783D2234222063793D2238
            2220723D2232222F3E0D0A09093C636972636C652066696C6C3D226E6F6E6522
            207374726F6B653D222337323732373222207374726F6B652D77696474683D22
            31222063783D223132222063793D22382220723D2232222F3E0D0A09093C7265
            637420783D22362220793D2237222066696C6C3D222337323732373222207769
            6474683D223422206865696768743D2231222F3E0D0A093C2F673E0D0A3C2F73
            76673E0D0A}
          HeaderGlyphAlignmentHorz = taCenter
          MinWidth = 26
          Options.Filtering = False
          Options.HorzSizing = False
          Options.ShowCaption = False
          Options.Sorting = False
          Width = 26
          IsCaptionAssigned = True
        end
        object dbcContentFileName: TcxGridDBColumn
          DataBinding.FieldName = 'FileName'
          DataBinding.IsNullValueType = True
          Visible = False
        end
        object dbcAttachmentID: TcxGridDBColumn
          DataBinding.FieldName = 'AttachmentID'
          Visible = False
        end
        object dbcIsAttachment: TcxGridDBColumn
          DataBinding.FieldName = 'IsAttachment'
          Visible = False
        end
        object dbcContent: TcxGridDBColumn
          DataBinding.FieldName = 'Content'
          Visible = False
        end
      end
    end
  end
  inherited PanelMain: TdxPanel
    Top = 200
    Height = 556
    ExplicitTop = 200
    ExplicitHeight = 556
    inherited lcMain: TdxLayoutControl
      Height = 554
      ExplicitLeft = 0
      ExplicitWidth = 532
      ExplicitHeight = 554
      inherited lblSubject: TcxLabel
        Top = 13
        ExplicitTop = 13
      end
      inherited cxreMain: TcxRichEdit
        Top = 96
        ExplicitTop = 96
        ExplicitHeight = 445
        Height = 445
      end
    end
  end
  inherited bmFrame: TdxBarManager
    PixelsPerInch = 96
    DockControlHeights = (
      0
      0
      200
      0)
    object bmtbMailNew: TdxBar
      Caption = 'New / Respond'
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
          ItemName = 'lbNewMail'
        end
        item
          BeginGroup = True
          UserDefine = [udPaintStyle]
          UserPaintStyle = psCaptionGlyph
          Visible = True
          ItemName = 'bReply'
        end
        item
          UserDefine = [udPaintStyle]
          UserPaintStyle = psCaptionGlyph
          Visible = True
          ItemName = 'bReplyAll'
        end
        item
          UserDefine = [udPaintStyle]
          UserPaintStyle = psCaptionGlyph
          Visible = True
          ItemName = 'bForward'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object bmtbMailDelete: TdxBar
      Caption = 'Delete'
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
          ItemName = 'lbDeleteMail'
        end>
      OneOnRow = True
      Row = 1
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object bmtbMailTags: TdxBar
      Caption = 'Tags'
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
          UserDefine = [udPaintStyle]
          UserPaintStyle = psCaptionGlyph
          Visible = True
          ItemName = 'bChangeUnreadState'
        end
        item
          ViewLevels = [ivlSmallIconWithText, ivlSmallIcon, ivlControlOnly]
          Visible = True
          ItemName = 'siMailPriority'
        end>
      OneOnRow = True
      Row = 2
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object bmtbMailLayout: TdxBar
      Caption = 'Layout'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 142
      DockingStyle = dsTop
      FloatLeft = 1296
      FloatTop = 0
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'lbMailRotate'
        end
        item
          Visible = True
          ItemName = 'lbMailFlip'
        end>
      OneOnRow = True
      Row = 3
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object lbNewMail: TdxBarLargeButton
      Action = actMailNew
      Category = 0
      ScreenTip = DM.stMailNew
      SyncImageIndex = False
      ImageIndex = -1
    end
    object bReply: TdxBarButton
      Action = actMailReply
      Category = 0
      ScreenTip = DM.stMailReply
      ImageIndex = 3
    end
    object bForward: TdxBarButton
      Action = actMailForward
      Category = 0
      ScreenTip = DM.stMailForward
      ImageIndex = 6
    end
    object bReplyAll: TdxBarButton
      Action = actMailReplyAll
      Category = 0
      ScreenTip = DM.stMailReplyAll
      ImageIndex = 4
    end
    object lbMailRotate: TdxBarLargeButton
      Action = actLayoutRotate
      Category = 0
      ScreenTip = DM.stRotate
      SyncImageIndex = False
      ImageIndex = -1
    end
    object lbMailFlip: TdxBarLargeButton
      Action = actLayoutFlip
      Category = 0
      ScreenTip = DM.stFlip
      SyncImageIndex = False
      ImageIndex = -1
    end
    object lbDeleteMail: TdxBarLargeButton
      Action = actMailDelete
      Category = 0
      ScreenTip = DM.stMailDeleteMail
      SyncImageIndex = False
      ImageIndex = -1
    end
    object bChangeUnreadState: TdxBarButton
      Action = actMailUnreadState
      Category = 0
      ScreenTip = DM.stMailUnread
      ImageIndex = 10
    end
    object bMailPriorityLow: TdxBarButton
      Action = actPriorityLow
      Category = 0
      ButtonStyle = bsChecked
      GroupIndex = 1
      ImageIndex = 12
    end
    object bMailPriorityMedium: TdxBarButton
      Action = actPriorityMedium
      Category = 0
      ButtonStyle = bsChecked
      GroupIndex = 1
    end
    object bMailPriorityHigh: TdxBarButton
      Action = actPriorityHigh
      Category = 0
      ButtonStyle = bsChecked
      GroupIndex = 1
      ImageIndex = 13
    end
    object siAttachment: TdxBarSubItem
      Caption = 'Attachment'
      Category = 0
      Visible = ivAlways
      ImageIndex = 14
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bAttachmentSaveAs'
        end
        item
          Visible = True
          ItemName = 'bAttachmentOpen'
        end>
    end
    object bAttachmentSaveAs: TdxBarButton
      Action = actAttachmentSaveAs
      Caption = 'SaveAs ...'
      Category = 0
    end
    object bAttachmentOpen: TdxBarButton
      Action = actAttachmentOpen
      Category = 0
    end
    object siMailPriority: TdxBarSubItem
      Caption = 'Priority'
      Category = 0
      ScreenTip = DM.stMailPriority
      Visible = ivAlways
      ImageIndex = 11
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bMailPriorityLow'
        end
        item
          Visible = True
          ItemName = 'bMailPriorityMedium'
        end
        item
          Visible = True
          ItemName = 'bMailPriorityHigh'
        end>
      ItemOptions.Size = misNormal
      OnPopup = pmPriorityPopup
    end
    object dxBarGroup1: TdxBarGroup
      Items = ()
    end
  end
  inherited alFrame: TActionList
    object actMailNew: TAction [0]
      Caption = 'New Mail'
      ImageIndex = 0
      ShortCut = 16462
      OnExecute = actMailNewExecute
    end
    object actMailReply: TAction [1]
      Caption = 'Reply'
      ShortCut = 16466
      OnExecute = actMailReplyExecute
    end
    object actMailReplyAll: TAction [2]
      Caption = 'Reply All'
      ShortCut = 24658
      OnExecute = actMailReplyAllExecute
    end
    object actMailForward: TAction [3]
      Caption = 'Forward'
      ShortCut = 16454
      OnExecute = actMailForwardExecute
    end
    object actMailDelete: TAction [4]
      Caption = 'Delete'
      ImageIndex = 1
      OnExecute = actMailDeleteExecute
    end
    object actMailUnreadState: TAction [5]
      Caption = 'Read / Unread'
      OnExecute = actMailUnreadStateExecute
    end
    object actAttachmentOpen: TAction [6]
      Caption = 'Open'
      OnExecute = actAttachmentOpenExecute
    end
    object actAttachmentSaveAs: TAction [7]
      Caption = 'Save as...'
      OnExecute = actAttachmentSaveAsExecute
    end
    object actPriorityLow: TAction
      Caption = 'Low Priority'
      GroupIndex = 1
      OnExecute = actPriorityExecute
    end
    object actPriorityMedium: TAction
      Tag = 1
      Caption = 'Medium Priority'
      GroupIndex = 1
      OnExecute = actPriorityExecute
    end
    object actPriorityHigh: TAction
      Tag = 2
      Caption = 'High Priority'
      GroupIndex = 1
      OnExecute = actPriorityExecute
    end
  end
  inherited ComponentPrinter: TdxComponentPrinter
    CurrentLink = ComponentPrinterLink1
    PixelsPerInch = 96
    object ComponentPrinterLink1: TdxGridReportLink
      Component = grMain
      PrinterPage.DMPaper = 1
      PrinterPage.Footer = 200
      PrinterPage.GrayShading = True
      PrinterPage.Header = 200
      PrinterPage.Margins.Bottom = 500
      PrinterPage.Margins.Left = 500
      PrinterPage.Margins.Right = 500
      PrinterPage.Margins.Top = 500
      PrinterPage.PageSize.X = 8500
      PrinterPage.PageSize.Y = 11000
      PrinterPage._dxMeasurementUnits_ = 0
      PrinterPage._dxLastMU_ = 1
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
  object SaveDialog1: TdxSaveFileDialog
    Filter = 'xls - files|*.xls|all files|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Title = 'Save As...'
    Left = 504
    Top = 120
  end
  object pmPriority: TdxRibbonPopupMenu
    BarManager = bmFrame
    ItemLinks = <
      item
        Visible = True
        ItemName = 'bMailPriorityLow'
      end
      item
        Visible = True
        ItemName = 'bMailPriorityMedium'
      end
      item
        Visible = True
        ItemName = 'bMailPriorityHigh'
      end>
    UseOwnFont = False
    OnPopup = pmPriorityPopup
    Left = 329
    Top = 352
    PixelsPerInch = 96
  end
  object pmMails: TdxRibbonPopupMenu
    BarManager = bmFrame
    ItemLinks = <
      item
        Visible = True
        ItemName = 'bReply'
      end
      item
        Visible = True
        ItemName = 'bReplyAll'
      end
      item
        Visible = True
        ItemName = 'bForward'
      end
      item
        Visible = True
        ItemName = 'lbDeleteMail'
      end
      item
        BeginGroup = True
        Visible = True
      end
      item
        BeginGroup = True
        Visible = True
      end
      item
        BeginGroup = True
        Visible = True
        ItemName = 'bChangeUnreadState'
      end
      item
        Visible = True
        ItemName = 'siAttachment'
      end>
    UseOwnFont = False
    OnPopup = pmMailsPopup
    Left = 393
    Top = 352
    PixelsPerInch = 96
  end
  object AutoMakeReadTimer: TTimer
    Enabled = False
    Interval = 3000
    OnTimer = AutoMakeReadTimerTimer
    Left = 704
    Top = 536
  end
  object UpdateMailPreviewTimer: TTimer
    Enabled = False
    Interval = 300
    OnTimer = UpdateMailPreviewTimerTimer
    Left = 592
    Top = 8
  end
  object amMails: TdxUIAdornerManager
    Badges.Active = True
    Left = 248
    Top = 272
    object bdgUrgent: TdxBadge
      TargetElementClassName = 'TdxAdornerTargetElementPath'
      TargetElement.Path = 'grMain.grMainLevel1.tvMain.dbcDateOnly.Header'
      Visible = False
      Alignment.Horz = taCenter
      Background.Glyph.SourceDPI = 96
      Background.Glyph.Data = {
        89504E470D0A1A0A0000000D49484452000000080000000808020000004B6D29
        DC000000017352474200AECE1CE90000000467414D410000B18F0BFC61050000
        00097048597300000EC300000EC301C76FA8640000001249444154185763782B
        A382150D290919150099BB4B4146F6EB1B0000000049454E44AE426082}
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clHighlightText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      Offset.Y = -6
      ParentFont = False
      Text = 'Urgent'
    end
  end
end
