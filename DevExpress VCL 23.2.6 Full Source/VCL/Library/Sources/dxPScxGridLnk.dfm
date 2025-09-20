inherited dxfmGridReportLinkDesignWindow: TdxfmGridReportLinkDesignWindow
  Left = 330
  Top = 198
  Caption = 'fmdxGridDesignWindow'
  ClientHeight = 521
  ClientWidth = 800
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  inherited lcMain: TdxLayoutControl
    Width = 800
    Height = 521
    inherited btnApply: TcxButton
      Top = 661
      TabOrder = 96
    end
    inherited btnCancel: TcxButton
      Top = 661
      TabOrder = 95
    end
    inherited btnOK: TcxButton
      Top = 661
      TabOrder = 94
    end
    inherited btnHelp: TcxButton
      Top = 661
      TabOrder = 97
    end
    inherited btnRestoreOriginal: TcxButton
      Top = 661
      TabOrder = 98
    end
    inherited btnRestoreDefaults: TcxButton
      Top = 661
      TabOrder = 99
    end
    inherited btnTitleProperties: TcxButton
      Top = 661
      TabOrder = 100
    end
    inherited btnFootnoteProperties: TcxButton
      Top = 661
      TabOrder = 101
    end
    object imgShow: TcxImage [8]
      Left = 10000
      Top = 10000
      Properties.PopupMenuLayout.MenuItems = []
      Properties.ShowFocusRect = False
      Style.TransparentBorder = False
      TabOrder = 1
      Transparent = True
      Visible = False
      Height = 48
      Width = 48
    end
    object imgOnEveryPage: TcxImage [9]
      Left = 10000
      Top = 10000
      Properties.PopupMenuLayout.MenuItems = []
      Properties.ShowFocusRect = False
      Style.TransparentBorder = False
      TabOrder = 10
      Transparent = True
      Visible = False
      Height = 48
      Width = 48
    end
    object imgSelection: TcxImage [10]
      Left = 10000
      Top = 10000
      Properties.PopupMenuLayout.MenuItems = []
      Properties.ShowFocusRect = False
      Style.TransparentBorder = False
      TabOrder = 17
      Transparent = True
      Visible = False
      Height = 48
      Width = 48
    end
    object imgExpanding: TcxImage [11]
      Left = 10000
      Top = 10000
      Properties.PopupMenuLayout.MenuItems = []
      Properties.ShowFocusRect = False
      Style.TransparentBorder = False
      TabOrder = 21
      Transparent = True
      Visible = False
      Height = 48
      Width = 48
    end
    object imgGridSize: TcxImage [12]
      Left = 10000
      Top = 10000
      Properties.PopupMenuLayout.MenuItems = []
      Properties.ShowFocusRect = False
      Style.TransparentBorder = False
      TabOrder = 26
      Transparent = True
      Visible = False
      Height = 48
      Width = 48
    end
    object imgLookAndFeel: TcxImage [13]
      Left = 10000
      Top = 10000
      Properties.PopupMenuLayout.MenuItems = []
      Properties.ShowFocusRect = False
      Style.TransparentBorder = False
      TabOrder = 39
      Transparent = True
      Visible = False
      Height = 48
      Width = 48
    end
    object imgRefinements: TcxImage [14]
      Left = 10000
      Top = 10000
      Properties.PopupMenuLayout.MenuItems = []
      Properties.ShowFocusRect = False
      Style.TransparentBorder = False
      TabOrder = 42
      Transparent = True
      Visible = False
      Height = 48
      Width = 48
    end
    object imgPreview: TcxImage [15]
      Left = 10000
      Top = 10000
      Properties.PopupMenuLayout.MenuItems = []
      Properties.ShowFocusRect = False
      Style.TransparentBorder = False
      TabOrder = 68
      Transparent = True
      Visible = False
      Height = 48
      Width = 48
    end
    object imgCardSizes: TcxImage [16]
      Left = 10000
      Top = 10000
      Properties.PopupMenuLayout.MenuItems = []
      Properties.ShowFocusRect = False
      Style.TransparentBorder = False
      TabOrder = 73
      Transparent = True
      Visible = False
      Height = 48
      Width = 48
    end
    object imgCardSpacing: TcxImage [17]
      Left = 10000
      Top = 10000
      Properties.PopupMenuLayout.MenuItems = []
      Properties.ShowFocusRect = False
      Style.TransparentBorder = False
      TabOrder = 78
      Transparent = True
      Visible = False
      Height = 48
      Width = 48
    end
    object imgCardFraming: TcxImage [18]
      Left = 10000
      Top = 10000
      Properties.PopupMenuLayout.MenuItems = []
      Properties.ShowFocusRect = False
      Style.TransparentBorder = False
      TabOrder = 82
      Transparent = True
      Visible = False
      Height = 48
      Width = 48
    end
    object imgCardShadow: TcxImage [19]
      Left = 10000
      Top = 10000
      Properties.PopupMenuLayout.MenuItems = []
      Properties.ShowFocusRect = False
      Style.TransparentBorder = False
      TabOrder = 87
      Transparent = True
      Visible = False
      Height = 48
      Width = 48
    end
    object imgCharts: TcxImage [20]
      Left = 10000
      Top = 10000
      Properties.PopupMenuLayout.MenuItems = []
      Properties.ShowFocusRect = False
      Style.TransparentBorder = False
      TabOrder = 91
      Transparent = True
      Visible = False
      Height = 48
      Width = 48
    end
    object imgDetails: TcxImage [21]
      Left = 10000
      Top = 10000
      Properties.PopupMenuLayout.MenuItems = []
      Properties.ShowFocusRect = False
      Style.TransparentBorder = False
      TabOrder = 29
      Transparent = True
      Visible = False
      Height = 48
      Width = 48
    end
    object imgLevels: TcxImage [22]
      Left = 10000
      Top = 10000
      Properties.PopupMenuLayout.MenuItems = []
      Properties.ShowFocusRect = False
      Style.TransparentBorder = False
      TabOrder = 33
      Transparent = True
      Visible = False
      Height = 48
      Width = 48
    end
    object imgPagination: TcxImage [23]
      Left = 10000
      Top = 10000
      Properties.PopupMenuLayout.MenuItems = []
      Properties.ShowFocusRect = False
      Style.TransparentBorder = False
      TabOrder = 50
      Transparent = True
      Visible = False
      Height = 48
      Width = 48
    end
    object pnlPreview: TPanel [24]
      Left = 417
      Top = 29
      Width = 430
      Height = 609
      BevelOuter = bvNone
      Color = 16448250
      ParentBackground = False
      TabOrder = 93
      object PreviewGrid: TcxGrid
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 424
        Height = 603
        Align = alClient
        TabOrder = 0
        LookAndFeel.NativeStyle = False
        RootLevelOptions.DetailTabsPosition = dtpTop
        object PreviewBandedView: TcxGridBandedTableView
          Navigator.Buttons.CustomButtons = <>
          FilterBox.CustomizeDialog = False
          FilterBox.Visible = fvAlways
          ScrollbarAnnotations.CustomAnnotations = <>
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = 'Count = 0'
              Kind = skCount
              Position = spFooter
              Column = colVendorName
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = 'Count = 0'
              Kind = skCount
              Column = colVendorName
            end>
          DataController.Summary.SummaryGroups = <>
          OptionsView.ScrollBars = ssNone
          OptionsView.CellAutoHeight = True
          OptionsView.ColumnAutoWidth = True
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.GroupFooters = gfAlwaysVisible
          Preview.Column = colVendorCountry
          Preview.Visible = True
          OnCustomDrawColumnHeader = PreviewBandedViewCustomDrawColumnHeader
          OnCustomDrawFooterCell = PreviewBandedViewCustomDrawFooterCell
          Bands = <
            item
              Caption = 'Vendor Data'
              Width = 150
            end
            item
              Caption = 'Car Data'
            end>
          OnCustomDrawBandHeader = PreviewBandedViewCustomDrawBandHeader
          object colVendorName: TcxGridBandedColumn
            Caption = 'Name'
            PropertiesClassName = 'TcxTextEditProperties'
            Options.Filtering = False
            Position.BandIndex = 0
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
          object colVendorLogo: TcxGridBandedColumn
            Caption = 'Logo'
            PropertiesClassName = 'TcxImageProperties'
            Properties.GraphicTransparency = gtTransparent
            OnCustomDrawCell = VendorLogoCustomDrawCell
            Options.Filtering = False
            Position.BandIndex = 0
            Position.ColIndex = 1
            Position.RowIndex = 0
          end
          object colVendorCountry: TcxGridBandedColumn
            PropertiesClassName = 'TcxTextEditProperties'
            Position.BandIndex = 0
            Position.ColIndex = 2
            Position.RowIndex = 0
          end
          object colCarModel: TcxGridBandedColumn
            Caption = 'Model'
            PropertiesClassName = 'TcxTextEditProperties'
            Options.Filtering = False
            Position.BandIndex = 1
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
          object colIsSUVModel: TcxGridBandedColumn
            Caption = 'SUV'
            PropertiesClassName = 'TcxCheckBoxProperties'
            Properties.ValueGrayed = #39#39
            OnCustomDrawCell = IsSUVModelCustomDrawCell
            HeaderAlignmentHorz = taCenter
            Options.Filtering = False
            Width = 30
            Position.BandIndex = 1
            Position.ColIndex = 1
            Position.RowIndex = 0
          end
          object colSpeedCount: TcxGridBandedColumn
            Caption = 'Speed Count'
            PropertiesClassName = 'TcxTrackBarProperties'
            Properties.Max = 8
            OnCustomDrawCell = colSpeedCountCustomDrawCell
            Position.BandIndex = 1
            Position.ColIndex = 2
            Position.RowIndex = 0
          end
        end
        object PreviewGridLevel: TcxGridLevel
          Caption = 'Cars'
        end
      end
    end
    object lblShow: TcxLabel [25]
      Left = 10000
      Top = 10000
      Caption = 'Show'
      Style.HotTrack = False
      Transparent = True
      Visible = False
    end
    object chbxShowCaptions: TcxCheckBox [26]
      Left = 10000
      Top = 10000
      Caption = 'Captions'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 2
      Transparent = True
      Visible = False
      OnClick = OptionsViewClick
    end
    object chbxShowBands: TcxCheckBox [27]
      Tag = 1
      Left = 10000
      Top = 10000
      Caption = 'Ba&nds'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 3
      Transparent = True
      Visible = False
      OnClick = OptionsViewClick
    end
    object chbxShowHeaders: TcxCheckBox [28]
      Tag = 2
      Left = 10000
      Top = 10000
      Caption = '&Headers'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 4
      Transparent = True
      Visible = False
      OnClick = OptionsViewClick
    end
    object chbxShowFooters: TcxCheckBox [29]
      Tag = 3
      Left = 10000
      Top = 10000
      Caption = 'Foo&ters'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 5
      Transparent = True
      Visible = False
      OnClick = OptionsViewClick
    end
    object chbxShowGroupFooters: TcxCheckBox [30]
      Tag = 4
      Left = 10000
      Top = 10000
      Caption = 'G&roup Footers'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 6
      Transparent = True
      Visible = False
      OnClick = OptionsViewClick
    end
    object chbxShowExpandButtons: TcxCheckBox [31]
      Tag = 5
      Left = 10000
      Top = 10000
      Caption = 'Expand Buttons'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 7
      Transparent = True
      Visible = False
      OnClick = OptionsViewClick
    end
    object chbxShowFilterBar: TcxCheckBox [32]
      Tag = 6
      Left = 10000
      Top = 10000
      Caption = 'FilterBar'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 8
      Transparent = True
      Visible = False
      OnClick = OptionsViewClick
    end
    object lblOnEveryPage: TcxLabel [33]
      Left = 10000
      Top = 10000
      Caption = 'On Every Page'
      Style.HotTrack = False
      Transparent = True
      Visible = False
    end
    object chbxCaptionsOnEveryPage: TcxCheckBox [34]
      Left = 10000
      Top = 10000
      Caption = 'Captions'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 11
      Transparent = True
      Visible = False
      OnClick = OptionsOnEveryPageClick
    end
    object chbxBandsOnEveryPage: TcxCheckBox [35]
      Tag = 1
      Left = 10000
      Top = 10000
      Caption = 'Ba&nds'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 12
      Transparent = True
      Visible = False
      OnClick = OptionsOnEveryPageClick
    end
    object chbxHeadersOnEveryPage: TcxCheckBox [36]
      Tag = 2
      Left = 10000
      Top = 10000
      Caption = 'Headers'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 13
      Transparent = True
      Visible = False
      OnClick = OptionsOnEveryPageClick
    end
    object chbxFootersOnEveryPage: TcxCheckBox [37]
      Tag = 3
      Left = 10000
      Top = 10000
      Caption = 'Footers'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 14
      Transparent = True
      Visible = False
      OnClick = OptionsOnEveryPageClick
    end
    object chbxFilterBarOnEveryPage: TcxCheckBox [38]
      Tag = 4
      Left = 10000
      Top = 10000
      Caption = 'FilterBar'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 15
      Transparent = True
      Visible = False
      OnClick = OptionsOnEveryPageClick
    end
    object lblSelection: TcxLabel [39]
      Left = 10000
      Top = 10000
      Caption = 'Selection'
      Style.HotTrack = False
      Style.TransparentBorder = False
      Properties.Alignment.Vert = taVCenter
      Transparent = True
      Visible = False
      AnchorY = 10011
    end
    object chbxProcessSelection: TcxCheckBox [40]
      Left = 10000
      Top = 10000
      Caption = 'Process Selection'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 18
      Transparent = True
      Visible = False
      OnClick = OptionsSelectionClick
    end
    object chbxProcessExactSelection: TcxCheckBox [41]
      Tag = 1
      Left = 10000
      Top = 10000
      Caption = 'Process Exact Selection'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 19
      Transparent = True
      Visible = False
      OnClick = OptionsSelectionClick
    end
    object lblExpanding: TcxLabel [42]
      Left = 10000
      Top = 10000
      Caption = 'Expanding'
      Style.HotTrack = False
      Transparent = True
      Visible = False
    end
    object chbxExpandGroupRows: TcxCheckBox [43]
      Left = 10000
      Top = 10000
      Caption = 'Groups'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 22
      Transparent = True
      Visible = False
      OnClick = OptionsExpandingClick
    end
    object chbxExpandMasterRows: TcxCheckBox [44]
      Tag = 1
      Left = 10000
      Top = 10000
      Caption = 'Details'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 23
      Transparent = True
      Visible = False
      OnClick = OptionsExpandingClick
    end
    object chbxExpandCards: TcxCheckBox [45]
      Tag = 2
      Left = 10000
      Top = 10000
      Caption = 'Cards'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 24
      Transparent = True
      Visible = False
      OnClick = OptionsExpandingClick
    end
    object lblGridSize: TcxLabel [46]
      Left = 10000
      Top = 10000
      Caption = 'Size'
      Style.HotTrack = False
      Transparent = True
      Visible = False
    end
    object chbxGridAutoWidth: TcxCheckBox [47]
      Left = 10000
      Top = 10000
      Caption = '&Auto Width'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 27
      Transparent = True
      Visible = False
      OnClick = OptionsSizeClick
    end
    object lblLookAndFeel: TcxLabel [48]
      Left = 10000
      Top = 10000
      Caption = 'Look and Feel'
      Style.HotTrack = False
      Transparent = True
      Visible = False
    end
    object lblRefinements: TcxLabel [49]
      Left = 10000
      Top = 10000
      Caption = 'Refinements'
      Style.HotTrack = False
      Transparent = True
      Visible = False
    end
    object cbxLookAndFeel: TcxComboBox [50]
      Left = 10000
      Top = 10000
      Properties.DropDownListStyle = lsFixedList
      Style.HotTrack = False
      TabOrder = 40
      Visible = False
      OnClick = LookAndFeelClick
      Width = 322
    end
    object chbxTransparentGraphics: TcxCheckBox [51]
      Left = 10000
      Top = 10000
      Caption = 'Transparent &Graphics'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 43
      Transparent = True
      Visible = False
      OnClick = OptionsRefinementClick
    end
    object chbxDisplayGraphicsAsText: TcxCheckBox [52]
      Tag = 1
      Left = 10000
      Top = 10000
      Caption = 'Display Graphics As &Text'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 44
      Transparent = True
      Visible = False
      OnClick = OptionsRefinementClick
    end
    object chbxFlatCheckMarks: TcxCheckBox [53]
      Tag = 2
      Left = 10000
      Top = 10000
      Caption = 'Flat Check &Marks'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 45
      Transparent = True
      Visible = False
      OnClick = OptionsRefinementClick
    end
    object chbxDisplayTrackBarsAsText: TcxCheckBox [54]
      Tag = 4
      Left = 10000
      Top = 10000
      Caption = 'Display Track &Bars As Text'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 46
      Transparent = True
      Visible = False
      OnClick = OptionsRefinementClick
    end
    object chbxSuppressBackgroundBitmaps: TcxCheckBox [55]
      Tag = 1
      Left = 10000
      Top = 10000
      Caption = 'Suppress Background Images'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 47
      Transparent = True
      Visible = False
      OnClick = OptionsFormatingClick
    end
    object chbxConsumeSelectionStyle: TcxCheckBox [56]
      Tag = 2
      Left = 10000
      Top = 10000
      Caption = 'Consume Selection Style'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 48
      Transparent = True
      Visible = False
      OnClick = OptionsFormatingClick
    end
    object lblPreviewOptions: TcxLabel [57]
      Left = 10000
      Top = 10000
      Caption = 'Options'
      Style.HotTrack = False
      Transparent = True
      Visible = False
    end
    object chbxPreviewVisible: TcxCheckBox [58]
      Left = 10000
      Top = 10000
      Caption = 'Visible'
      Style.HotTrack = False
      TabOrder = 69
      Transparent = True
      Visible = False
      OnClick = PreviewVisibleClick
    end
    object chbxPreviewAutoHeight: TcxCheckBox [59]
      Left = 10000
      Top = 10000
      Caption = 'Auto Height'
      Style.HotTrack = False
      TabOrder = 70
      Transparent = True
      Visible = False
      OnClick = PreviewAutoHeightClick
    end
    object sePreviewMaxLineCount: TcxSpinEdit [60]
      Left = 10000
      Top = 10000
      Properties.AssignedValues.MinValue = True
      Properties.MaxValue = 1000.000000000000000000
      Properties.OnChange = PreviewMaxLineCountChanged
      Style.HotTrack = False
      TabOrder = 71
      Visible = False
      Width = 182
    end
    object lblCardSizes: TcxLabel [61]
      Left = 10000
      Top = 10000
      Caption = 'Sizes'
      Style.HotTrack = False
      Style.TransparentBorder = False
      Properties.Alignment.Vert = taVCenter
      Transparent = True
      Visible = False
      AnchorY = 10011
    end
    object lblCardSpacing: TcxLabel [62]
      Left = 10000
      Top = 10000
      Caption = 'Spacing'
      Style.HotTrack = False
      Style.TransparentBorder = False
      Properties.Alignment.Vert = taVCenter
      Transparent = True
      Visible = False
      AnchorY = 10011
    end
    object lblCardFraming: TcxLabel [63]
      Left = 10000
      Top = 10000
      Caption = 'Framing'
      Style.HotTrack = False
      Style.TransparentBorder = False
      Properties.Alignment.Vert = taVCenter
      Transparent = True
      Visible = False
      AnchorY = 10011
    end
    object lblCardShadow: TcxLabel [64]
      Left = 10000
      Top = 10000
      Caption = 'Shadow'
      Style.HotTrack = False
      Style.TransparentBorder = False
      Properties.Alignment.Vert = taVCenter
      Transparent = True
      Visible = False
      AnchorY = 10011
    end
    object chbxCardsAutoWidth: TcxCheckBox [65]
      Left = 10000
      Top = 10000
      Caption = 'Auto Width'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 74
      Transparent = True
      Visible = False
      OnClick = OptionsCardsClick
    end
    object chbxCardsKeepSameWidth: TcxCheckBox [66]
      Tag = 1
      Left = 10000
      Top = 10000
      Caption = 'Keep Same Width'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 75
      Transparent = True
      Visible = False
      OnClick = OptionsCardsClick
    end
    object chbxCardsKeepSameHeight: TcxCheckBox [67]
      Tag = 2
      Left = 10000
      Top = 10000
      Caption = 'Keep Same Height'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 76
      Transparent = True
      Visible = False
      OnClick = OptionsCardsClick
    end
    object seCardsSpaceHorz: TcxSpinEdit [68]
      Left = 10000
      Top = 10000
      Properties.AssignedValues.MinValue = True
      Properties.MaxValue = 20.000000000000000000
      Properties.OnChange = CardSpaceHorzChanged
      Style.HotTrack = False
      TabOrder = 79
      Visible = False
      Width = 217
    end
    object seCardsSpaceVert: TcxSpinEdit [69]
      Left = 10000
      Top = 10000
      Properties.AssignedValues.MinValue = True
      Properties.MaxValue = 20.000000000000000000
      Properties.OnChange = CardSpaceVertChanged
      Style.HotTrack = False
      TabOrder = 80
      Visible = False
      Width = 217
    end
    object chbxCardsBorder: TcxCheckBox [70]
      Tag = 3
      Left = 10000
      Top = 10000
      Caption = 'Border'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 83
      Transparent = True
      Visible = False
      OnClick = OptionsCardsClick
    end
    object chbxCardsHorzLines: TcxCheckBox [71]
      Tag = 4
      Left = 10000
      Top = 10000
      Caption = 'Horizontal Lines'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 84
      Transparent = True
      Visible = False
      OnClick = OptionsCardsClick
    end
    object chbxCardsVertLines: TcxCheckBox [72]
      Tag = 5
      Left = 10000
      Top = 10000
      Caption = 'Vertical Lines'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 85
      Transparent = True
      Visible = False
      OnClick = OptionsCardsClick
    end
    object ccbxCardsShadowColor: TcxColorComboBox [73]
      Left = 10000
      Top = 10000
      Properties.AllowSelectColor = True
      Properties.CustomColors = <>
      Properties.OnChange = CardShadowColorChanged
      Style.HotTrack = False
      TabOrder = 88
      Visible = False
      Width = 217
    end
    object seCardsShadowDepth: TcxSpinEdit [74]
      Left = 10000
      Top = 10000
      Properties.OnChange = CardShadowDepthChanged
      Style.HotTrack = False
      TabOrder = 89
      Visible = False
      Width = 217
    end
    object lblChartsOptions: TcxLabel [75]
      Left = 10000
      Top = 10000
      Caption = 'Options'
      Style.HotTrack = False
      Transparent = True
      Visible = False
    end
    object chbxChartsTransparent: TcxCheckBox [76]
      Left = 10000
      Top = 10000
      Caption = 'Transparent'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 92
      Transparent = True
      Visible = False
      OnClick = chbxChartsTransparentClick
    end
    object chbxUseNativeStyles: TcxCheckBox [77]
      Left = 22
      Top = 48
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 53
      Transparent = True
      OnClick = OptionsFormatingClick
    end
    object lblUseNativeStyles: TcxLabel [78]
      Left = 46
      Top = 52
      Caption = '&Use Native Styles'
      FocusControl = chbxUseNativeStyles
      Style.HotTrack = False
      Style.TransparentBorder = False
      Properties.Alignment.Vert = taVCenter
      Transparent = True
      OnClick = lblUseNativeStylesClick
      AnchorY = 63
    end
    object btnStyleFont: TcxButton [79]
      Left = 323
      Top = 84
      Width = 75
      Height = 23
      Caption = '&Font...'
      TabOrder = 57
      OnClick = StyleFontClick
    end
    object btnStyleColor: TcxButton [80]
      Left = 323
      Top = 113
      Width = 75
      Height = 23
      Caption = 'Co&lor...'
      TabOrder = 58
      OnClick = StyleColorClick
    end
    object btnStyleBackgroundBitmap: TcxButton [81]
      Left = 323
      Top = 142
      Width = 75
      Height = 23
      Caption = '&Bitmap...'
      TabOrder = 59
      OnClick = StyleBackgroundBitmapClick
    end
    object btnStyleBackgroundBitmapClear: TcxButton [82]
      Left = 323
      Top = 171
      Width = 75
      Height = 23
      Caption = 'Cle&ar'
      TabOrder = 60
      OnClick = StyleBackgroundBitmapClearClick
    end
    object btnStyleRestoreDefaults: TcxButton [83]
      Left = 22
      Top = 315
      Width = 145
      Height = 23
      Caption = 'Rest&ore Defaults'
      TabOrder = 55
      OnClick = StyleRestoreDefaultsClick
    end
    object btnStylesSaveAs: TcxButton [84]
      Left = 173
      Top = 315
      Width = 144
      Height = 23
      Caption = 'Save &As...'
      TabOrder = 56
      OnClick = StylesSaveAsClick
    end
    object lblStyleSheets: TcxLabel [85]
      Left = 22
      Top = 344
      Caption = 'Style Sheets'
      Style.HotTrack = False
      Style.TransparentBorder = False
      Properties.Alignment.Vert = taVCenter
      Transparent = True
      AnchorY = 355
    end
    object cbxStyleSheets: TcxComboBox [86]
      Left = 22
      Top = 371
      Properties.DropDownListStyle = lsFixedList
      Properties.OnDrawItem = cbxStyleSheetsPropertiesDrawItem
      Style.HotTrack = False
      TabOrder = 62
      OnClick = cbxStyleSheetsClick
      OnKeyDown = cbxStyleSheetsKeyDown
      Width = 376
    end
    object btnStyleSheetNew: TcxButton [87]
      Left = 22
      Top = 402
      Width = 90
      Height = 23
      Caption = '&New...'
      TabOrder = 63
      OnClick = StyleSheetNewClick
    end
    object btnStyleSheetCopy: TcxButton [88]
      Left = 118
      Top = 402
      Width = 89
      Height = 23
      Caption = '&Copy...'
      TabOrder = 64
      OnClick = StyleSheetCopyClick
    end
    object btnStyleSheetDelete: TcxButton [89]
      Left = 213
      Top = 402
      Width = 90
      Height = 23
      Caption = '&Delete...'
      TabOrder = 65
      OnClick = StyleSheetDeleteClick
    end
    object btnStyleSheetRename: TcxButton [90]
      Left = 309
      Top = 402
      Width = 89
      Height = 23
      Caption = '&Rename...'
      TabOrder = 66
      OnClick = StyleSheetRenameClick
    end
    object lblDetails: TcxLabel [91]
      Left = 10000
      Top = 10000
      Caption = 'Details'
      Style.HotTrack = False
      Transparent = True
      Visible = False
    end
    object chbxStartFromActiveView: TcxCheckBox [92]
      Left = 10000
      Top = 10000
      Caption = 'Start From Active Details'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 30
      Transparent = True
      Visible = False
      OnClick = OptionsDetailsClick
    end
    object chbxOnlyActiveView: TcxCheckBox [93]
      Tag = 1
      Left = 10000
      Top = 10000
      Caption = 'Only Active Details'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 31
      Transparent = True
      Visible = False
      OnClick = OptionsDetailsClick
    end
    object lblLevels: TcxLabel [94]
      Left = 10000
      Top = 10000
      Caption = 'Levels'
      Style.HotTrack = False
      Transparent = True
      Visible = False
    end
    object chbxLevelsUnwrap: TcxCheckBox [95]
      Left = 10000
      Top = 10000
      Caption = '&Unwrap'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 34
      Transparent = True
      Visible = False
      OnClick = OptionsLevelsClick
    end
    object chbxLevelsUnwrapTopLevel: TcxCheckBox [96]
      Tag = 1
      Left = 10000
      Top = 10000
      Caption = 'Unwrap Top Level'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 35
      Transparent = True
      Visible = False
      OnClick = OptionsLevelsClick
    end
    object chbxLevelsRiseActiveLevelOntoTop: TcxCheckBox [97]
      Tag = 2
      Left = 10000
      Top = 10000
      Caption = 'Rise Active Level onto Top'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 36
      Transparent = True
      Visible = False
      OnClick = OptionsLevelsClick
    end
    object chbxLevelsSkipEmptyViews: TcxCheckBox [98]
      Tag = 3
      Left = 10000
      Top = 10000
      Caption = 'Skip Empty Views'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 37
      Transparent = True
      Visible = False
      OnClick = OptionsLevelsClick
    end
    object lblPagination: TcxLabel [99]
      Left = 10000
      Top = 10000
      Caption = 'Pagination'
      Style.HotTrack = False
      Transparent = True
      Visible = False
    end
    object chbxPaginateByTopLevelGroups: TcxCheckBox [100]
      Left = 10000
      Top = 10000
      Caption = 'By TopLevel Groups'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 51
      Transparent = True
      Visible = False
      OnClick = OptionsPaginationClick
    end
    object chbxPaginateOneGroupPerPage: TcxCheckBox [101]
      Tag = 1
      Left = 10000
      Top = 10000
      Caption = 'One Group Per Page'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 52
      Transparent = True
      Visible = False
      OnClick = OptionsPaginationClick
    end
    inherited lcMainGroup_Root: TdxLayoutGroup
      CaptionOptions.Visible = False
    end
    inherited dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup
      Index = 2
    end
    inherited dxLayoutEmptySpaceItem1: TdxLayoutEmptySpaceItem
      Index = 1
    end
    object lblPreviewWindow: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup2
      AlignHorz = ahClient
      AlignVert = avClient
      SizeOptions.Height = 400
      SizeOptions.Width = 400
      CaptionOptions.Text = 'lblPreviewWindow'
      CaptionOptions.Layout = clTop
      Control = pnlPreview
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 400
      ControlOptions.OriginalWidth = 400
      Index = 1
    end
    object dxLayoutItem1: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup38
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = lblShow
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 26
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem2: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup3
      AlignHorz = ahLeft
      Control = imgShow
      ControlOptions.OriginalHeight = 48
      ControlOptions.OriginalWidth = 48
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem3: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup4
      CaptionOptions.Visible = False
      Control = chbxShowCaptions
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 62
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem4: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup4
      CaptionOptions.Visible = False
      Control = chbxShowBands
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 49
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem5: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup4
      CaptionOptions.Visible = False
      Control = chbxShowHeaders
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 60
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutItem6: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup4
      CaptionOptions.Visible = False
      Control = chbxShowFooters
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 57
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object dxLayoutItem7: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup4
      CaptionOptions.Visible = False
      Control = chbxShowGroupFooters
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 89
      ControlOptions.ShowBorder = False
      Index = 4
    end
    object dxLayoutItem8: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup4
      CaptionOptions.Visible = False
      Control = chbxShowExpandButtons
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 96
      ControlOptions.ShowBorder = False
      Index = 5
    end
    object dxLayoutItem9: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup4
      CaptionOptions.Visible = False
      Control = chbxShowFilterBar
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 60
      ControlOptions.ShowBorder = False
      Index = 6
    end
    object dxLayoutItem10: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup39
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = lblOnEveryPage
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 72
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem11: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup5
      AlignHorz = ahLeft
      Control = imgOnEveryPage
      ControlOptions.OriginalHeight = 48
      ControlOptions.OriginalWidth = 48
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem12: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup6
      AlignHorz = ahClient
      CaptionOptions.Visible = False
      Control = chbxCaptionsOnEveryPage
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 62
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem13: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup6
      CaptionOptions.Visible = False
      Control = chbxBandsOnEveryPage
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 49
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem14: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup6
      CaptionOptions.Visible = False
      Control = chbxHeadersOnEveryPage
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 60
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutItem15: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup6
      CaptionOptions.Visible = False
      Control = chbxFootersOnEveryPage
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 57
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object dxLayoutItem16: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup6
      CaptionOptions.Visible = False
      Control = chbxFilterBarOnEveryPage
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 60
      ControlOptions.ShowBorder = False
      Index = 4
    end
    object bvlWarningHost: TdxLayoutItem
      Parent = tshView
      AlignVert = avClient
      SizeOptions.Height = 76
      Index = 4
    end
    object dxLayoutItem17: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup40
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = lblSelection
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 43
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem20: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup7
      AlignHorz = ahLeft
      Control = imgSelection
      ControlOptions.OriginalHeight = 48
      ControlOptions.OriginalWidth = 48
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem18: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup8
      AlignHorz = ahClient
      CaptionOptions.Visible = False
      Control = chbxProcessSelection
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 107
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem19: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup8
      CaptionOptions.Visible = False
      Control = chbxProcessExactSelection
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 137
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem21: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup41
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = lblExpanding
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 50
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object pcMain: TdxLayoutGroup
      Parent = dxLayoutAutoCreatedGroup2
      AlignHorz = ahLeft
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      SizeOptions.Width = 400
      ItemIndex = 3
      LayoutDirection = ldTabbed
      ShowBorder = False
      TabbedOptions.ShowFrame = True
      OnTabChanged = PageControl1Change
      Index = 0
    end
    object dxLayoutAutoCreatedGroup2: TdxLayoutAutoCreatedGroup
      Parent = lcMainGroup_Root
      LayoutDirection = ldHorizontal
      Index = 0
    end
    object tshBehaviors: TdxLayoutGroup
      Parent = pcMain
      CaptionOptions.Text = 'tshBehaviors'
      ItemIndex = 6
      Index = 1
    end
    object tshFormatting: TdxLayoutGroup
      Parent = pcMain
      CaptionOptions.Text = 'tshFormatting'
      ItemIndex = 4
      Index = 2
    end
    object tshStyles: TdxLayoutGroup
      Parent = pcMain
      CaptionOptions.Text = 'tshStyles'
      ItemIndex = 2
      Index = 3
    end
    object tshPreview: TdxLayoutGroup
      Parent = pcMain
      CaptionOptions.Text = 'tshPreview'
      Index = 4
    end
    object tshCards: TdxLayoutGroup
      Parent = pcMain
      CaptionOptions.Text = 'tshCards'
      ItemIndex = 6
      Index = 5
    end
    object tshCharts: TdxLayoutGroup
      Parent = pcMain
      CaptionOptions.Text = 'tshCharts'
      Index = 6
    end
    object tshView: TdxLayoutGroup
      Parent = pcMain
      CaptionOptions.Text = 'tshView'
      ItemIndex = 3
      Index = 0
    end
    object dxLayoutAutoCreatedGroup3: TdxLayoutAutoCreatedGroup
      Parent = tshView
      LayoutDirection = ldHorizontal
      Index = 1
    end
    object dxLayoutAutoCreatedGroup4: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutAutoCreatedGroup3
      AlignHorz = ahClient
      Index = 1
    end
    object dxLayoutAutoCreatedGroup5: TdxLayoutAutoCreatedGroup
      Parent = tshView
      LayoutDirection = ldHorizontal
      Index = 3
    end
    object dxLayoutAutoCreatedGroup6: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutAutoCreatedGroup5
      AlignHorz = ahClient
      Index = 1
    end
    object dxLayoutAutoCreatedGroup7: TdxLayoutAutoCreatedGroup
      Parent = tshBehaviors
      LayoutDirection = ldHorizontal
      Index = 1
    end
    object dxLayoutAutoCreatedGroup8: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutAutoCreatedGroup7
      AlignHorz = ahClient
      Index = 1
    end
    object dxLayoutItem25: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup9
      AlignHorz = ahLeft
      Control = imgExpanding
      ControlOptions.OriginalHeight = 48
      ControlOptions.OriginalWidth = 48
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem22: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup10
      AlignHorz = ahClient
      CaptionOptions.Visible = False
      Control = chbxExpandGroupRows
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 58
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutAutoCreatedGroup9: TdxLayoutAutoCreatedGroup
      Parent = tshBehaviors
      LayoutDirection = ldHorizontal
      Index = 3
    end
    object dxLayoutItem23: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup10
      CaptionOptions.Visible = False
      Control = chbxExpandMasterRows
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 56
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup10: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutAutoCreatedGroup9
      AlignHorz = ahClient
      Index = 1
    end
    object dxLayoutItem24: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup10
      CaptionOptions.Visible = False
      Control = chbxExpandCards
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 52
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutItem26: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup42
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = lblGridSize
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 19
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem29: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup11
      AlignHorz = ahLeft
      Control = imgGridSize
      ControlOptions.OriginalHeight = 48
      ControlOptions.OriginalWidth = 48
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem30: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup11
      AlignHorz = ahClient
      CaptionOptions.Visible = False
      Control = chbxGridAutoWidth
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 78
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup11: TdxLayoutAutoCreatedGroup
      Parent = tshBehaviors
      LayoutDirection = ldHorizontal
      Index = 5
    end
    object dxLayoutItem39: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup45
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = lblLookAndFeel
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 66
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem40: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup46
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = lblRefinements
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 60
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem42: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup16
      AlignHorz = ahLeft
      Control = imgLookAndFeel
      ControlOptions.OriginalHeight = 48
      ControlOptions.OriginalWidth = 48
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem43: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup17
      AlignHorz = ahLeft
      Control = imgRefinements
      ControlOptions.OriginalHeight = 48
      ControlOptions.OriginalWidth = 48
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem45: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup16
      AlignHorz = ahClient
      Control = cbxLookAndFeel
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup16: TdxLayoutAutoCreatedGroup
      Parent = tshFormatting
      LayoutDirection = ldHorizontal
      Index = 1
    end
    object dxLayoutItem46: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup18
      AlignHorz = ahClient
      CaptionOptions.Visible = False
      Control = chbxTransparentGraphics
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 127
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutAutoCreatedGroup17: TdxLayoutAutoCreatedGroup
      Parent = tshFormatting
      LayoutDirection = ldHorizontal
      Index = 3
    end
    object dxLayoutItem47: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup18
      CaptionOptions.Visible = False
      Control = chbxDisplayGraphicsAsText
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 142
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup18: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutAutoCreatedGroup17
      AlignHorz = ahClient
      Index = 1
    end
    object dxLayoutItem48: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup18
      CaptionOptions.Visible = False
      Control = chbxFlatCheckMarks
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 105
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutItem49: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup18
      CaptionOptions.Visible = False
      Control = chbxDisplayTrackBarsAsText
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 151
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object dxLayoutSeparatorItem1: TdxLayoutSeparatorItem
      Parent = dxLayoutAutoCreatedGroup18
      CaptionOptions.Text = 'Separator'
      Index = 4
    end
    object dxLayoutItem50: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup18
      CaptionOptions.Visible = False
      Control = chbxSuppressBackgroundBitmaps
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 165
      ControlOptions.ShowBorder = False
      Index = 5
    end
    object dxLayoutItem51: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup18
      CaptionOptions.Visible = False
      Control = chbxConsumeSelectionStyle
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 141
      ControlOptions.ShowBorder = False
      Index = 6
    end
    object dxLayoutItem54: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup48
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = lblPreviewOptions
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 37
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem55: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup21
      AlignHorz = ahLeft
      Control = imgPreview
      ControlOptions.OriginalHeight = 48
      ControlOptions.OriginalWidth = 48
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem56: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup22
      AlignHorz = ahClient
      CaptionOptions.Visible = False
      Control = chbxPreviewVisible
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 53
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutAutoCreatedGroup21: TdxLayoutAutoCreatedGroup
      Parent = tshPreview
      LayoutDirection = ldHorizontal
      Index = 1
    end
    object dxLayoutItem57: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup22
      CaptionOptions.Visible = False
      Control = chbxPreviewAutoHeight
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 81
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup22: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutAutoCreatedGroup21
      AlignHorz = ahClient
      Index = 1
    end
    object lblPreviewMaxLineCount: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup22
      Offsets.Left = 19
      CaptionOptions.Text = 'lblPreviewMaxLineCount'
      Control = sePreviewMaxLineCount
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 100
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutItem58: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup49
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = lblCardSizes
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 24
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem59: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup50
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = lblCardSpacing
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 37
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem60: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup51
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = lblCardFraming
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 38
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem61: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup52
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = lblCardShadow
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 38
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem62: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup23
      AlignHorz = ahLeft
      Control = imgCardSizes
      ControlOptions.OriginalHeight = 48
      ControlOptions.OriginalWidth = 48
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem63: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup25
      AlignHorz = ahLeft
      Control = imgCardSpacing
      ControlOptions.OriginalHeight = 48
      ControlOptions.OriginalWidth = 48
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem64: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup27
      AlignHorz = ahLeft
      Control = imgCardFraming
      ControlOptions.OriginalHeight = 48
      ControlOptions.OriginalWidth = 48
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem65: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup29
      AlignHorz = ahLeft
      Control = imgCardShadow
      ControlOptions.OriginalHeight = 48
      ControlOptions.OriginalWidth = 48
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem66: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup24
      AlignHorz = ahClient
      CaptionOptions.Visible = False
      Control = chbxCardsAutoWidth
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 78
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutAutoCreatedGroup23: TdxLayoutAutoCreatedGroup
      Parent = tshCards
      LayoutDirection = ldHorizontal
      Index = 1
    end
    object dxLayoutItem67: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup24
      CaptionOptions.Visible = False
      Control = chbxCardsKeepSameWidth
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 108
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup24: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutAutoCreatedGroup23
      AlignHorz = ahClient
      Index = 1
    end
    object dxLayoutItem68: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup24
      CaptionOptions.Visible = False
      Control = chbxCardsKeepSameHeight
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 111
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object lblCardSpaceHorz: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup26
      AlignHorz = ahClient
      CaptionOptions.Text = 'lblCardSpaceHorz'
      Control = seCardsSpaceHorz
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 100
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutAutoCreatedGroup25: TdxLayoutAutoCreatedGroup
      Parent = tshCards
      LayoutDirection = ldHorizontal
      Index = 3
    end
    object lblCardSpaceVert: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup26
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'lblCardSpaceVert'
      Control = seCardsSpaceVert
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 100
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup26: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutAutoCreatedGroup25
      AlignHorz = ahClient
      Index = 1
    end
    object dxLayoutItem69: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup28
      AlignHorz = ahClient
      CaptionOptions.Visible = False
      Control = chbxCardsBorder
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 56
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutAutoCreatedGroup27: TdxLayoutAutoCreatedGroup
      Parent = tshCards
      LayoutDirection = ldHorizontal
      Index = 5
    end
    object dxLayoutItem70: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup28
      CaptionOptions.Visible = False
      Control = chbxCardsHorzLines
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 99
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup28: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutAutoCreatedGroup27
      AlignHorz = ahClient
      Index = 1
    end
    object dxLayoutItem71: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup28
      CaptionOptions.Visible = False
      Control = chbxCardsVertLines
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 86
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object lblCardShadowColor: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup30
      AlignHorz = ahClient
      CaptionOptions.Text = 'lblCardShadowColor'
      Control = ccbxCardsShadowColor
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutAutoCreatedGroup29: TdxLayoutAutoCreatedGroup
      Parent = tshCards
      LayoutDirection = ldHorizontal
      Index = 7
    end
    object lblCardShadowDepth: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup30
      CaptionOptions.Text = 'lblCardShadowDepth'
      Control = seCardsShadowDepth
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup30: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutAutoCreatedGroup29
      AlignHorz = ahClient
      Index = 1
    end
    object dxLayoutItem72: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup53
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = lblChartsOptions
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 37
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem73: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup31
      AlignHorz = ahLeft
      Control = imgCharts
      ControlOptions.OriginalHeight = 48
      ControlOptions.OriginalWidth = 48
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem74: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup31
      AlignHorz = ahClient
      CaptionOptions.Visible = False
      Control = chbxChartsTransparent
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 83
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup31: TdxLayoutAutoCreatedGroup
      Parent = tshCharts
      LayoutDirection = ldHorizontal
      Index = 1
    end
    object dxLayoutItem75: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup32
      AlignHorz = ahLeft
      AlignVert = avCenter
      CaptionOptions.Visible = False
      Control = chbxUseNativeStyles
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 18
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem76: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup32
      AlignHorz = ahLeft
      AlignVert = avCenter
      CaptionOptions.Visible = False
      Control = lblUseNativeStyles
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 84
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup32: TdxLayoutAutoCreatedGroup
      Parent = tshStyles
      LayoutDirection = ldHorizontal
      Index = 0
    end
    object dxLayoutItem77: TdxLayoutItem
      Parent = dxLayoutGroup1
      AlignHorz = ahRight
      CaptionOptions.Visible = False
      Control = btnStyleFont
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem78: TdxLayoutItem
      Parent = dxLayoutGroup1
      AlignHorz = ahRight
      CaptionOptions.Visible = False
      Control = btnStyleColor
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem79: TdxLayoutItem
      Parent = dxLayoutGroup1
      AlignHorz = ahRight
      CaptionOptions.Visible = False
      Control = btnStyleBackgroundBitmap
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutItem80: TdxLayoutItem
      Parent = dxLayoutGroup1
      AlignHorz = ahRight
      CaptionOptions.Visible = False
      Control = btnStyleBackgroundBitmapClear
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object dxLayoutGroup1: TdxLayoutGroup
      Parent = dxLayoutAutoCreatedGroup33
      AlignHorz = ahRight
      CaptionOptions.Text = 'New Group'
      ItemIndex = 3
      ShowBorder = False
      Index = 1
    end
    object bvlStylesHost: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup34
      AlignHorz = ahClient
      AlignVert = avClient
      SizeOptions.Height = 225
      SizeOptions.Width = 225
      Index = 0
    end
    object dxLayoutAutoCreatedGroup33: TdxLayoutAutoCreatedGroup
      Parent = tshStyles
      LayoutDirection = ldHorizontal
      Index = 1
    end
    object dxLayoutItem82: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup35
      AlignHorz = ahClient
      CaptionOptions.Visible = False
      Control = btnStyleRestoreDefaults
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutAutoCreatedGroup34: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutAutoCreatedGroup33
      AlignHorz = ahClient
      Index = 0
    end
    object dxLayoutItem81: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup35
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Visible = False
      Control = btnStylesSaveAs
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup35: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutAutoCreatedGroup34
      LayoutDirection = ldHorizontal
      Index = 1
    end
    object dxLayoutItem83: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup37
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = lblStyleSheets
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 60
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem84: TdxLayoutItem
      Parent = tshStyles
      Control = cbxStyleSheets
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object dxLayoutItem85: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup36
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Visible = False
      Control = btnStyleSheetNew
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem86: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup36
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Visible = False
      Control = btnStyleSheetCopy
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup36: TdxLayoutAutoCreatedGroup
      Parent = tshStyles
      LayoutDirection = ldHorizontal
      Index = 4
    end
    object dxLayoutItem87: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup36
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Visible = False
      Control = btnStyleSheetDelete
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutItem88: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup36
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Visible = False
      Control = btnStyleSheetRename
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object lgDetails: TdxLayoutGroup
      Parent = lgLevels
      CaptionOptions.Text = 'New Group'
      ShowBorder = False
      Index = 0
    end
    object lilblDetails: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup43
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = lblDetails
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 32
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutAutoCreatedGroup12: TdxLayoutAutoCreatedGroup
      Parent = lgDetails
      LayoutDirection = ldHorizontal
      Index = 1
    end
    object dxLayoutItem31: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup12
      AlignHorz = ahLeft
      Control = imgDetails
      ControlOptions.OriginalHeight = 48
      ControlOptions.OriginalWidth = 48
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutAutoCreatedGroup13: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutAutoCreatedGroup12
      AlignHorz = ahClient
      Index = 1
    end
    object dxLayoutItem32: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup13
      AlignHorz = ahClient
      CaptionOptions.Visible = False
      Control = chbxStartFromActiveView
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 143
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem33: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup13
      CaptionOptions.Visible = False
      Control = chbxOnlyActiveView
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 114
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lgLevels: TdxLayoutGroup
      Parent = tshBehaviors
      CaptionOptions.Text = 'New Group'
      ItemIndex = 1
      ShowBorder = False
      Index = 6
    end
    object dxLayoutItem28: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup44
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = lblLevels
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 30
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutAutoCreatedGroup14: TdxLayoutAutoCreatedGroup
      Parent = lgLevels
      LayoutDirection = ldHorizontal
      Index = 2
    end
    object dxLayoutItem34: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup14
      AlignHorz = ahLeft
      Control = imgLevels
      ControlOptions.OriginalHeight = 48
      ControlOptions.OriginalWidth = 48
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutAutoCreatedGroup15: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutAutoCreatedGroup14
      AlignHorz = ahClient
      Index = 1
    end
    object dxLayoutItem35: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup15
      AlignHorz = ahClient
      CaptionOptions.Visible = False
      Control = chbxLevelsUnwrap
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 61
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem36: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup15
      CaptionOptions.Visible = False
      Control = chbxLevelsUnwrapTopLevel
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 110
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem37: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup15
      CaptionOptions.Visible = False
      Control = chbxLevelsRiseActiveLevelOntoTop
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 151
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutItem38: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup15
      CaptionOptions.Visible = False
      Control = chbxLevelsSkipEmptyViews
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 106
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object lgPagination: TdxLayoutGroup
      Parent = tshFormatting
      CaptionOptions.Text = 'New Group'
      ShowBorder = False
      Index = 4
    end
    object dxLayoutItem41: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup47
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = lblPagination
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 50
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutAutoCreatedGroup19: TdxLayoutAutoCreatedGroup
      Parent = lgPagination
      LayoutDirection = ldHorizontal
      Index = 1
    end
    object dxLayoutItem44: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup19
      AlignHorz = ahLeft
      Control = imgPagination
      ControlOptions.OriginalHeight = 48
      ControlOptions.OriginalWidth = 48
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutAutoCreatedGroup20: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutAutoCreatedGroup19
      AlignHorz = ahClient
      Index = 1
    end
    object dxLayoutItem52: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup20
      AlignHorz = ahClient
      CaptionOptions.Visible = False
      Control = chbxPaginateByTopLevelGroups
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 119
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem53: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup20
      CaptionOptions.Visible = False
      Control = chbxPaginateOneGroupPerPage
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 122
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutSeparatorItem2: TdxLayoutSeparatorItem
      Parent = dxLayoutAutoCreatedGroup32
      AlignHorz = ahClient
      AlignVert = avCenter
      CaptionOptions.Text = 'Separator'
      Index = 2
    end
    object dxLayoutSeparatorItem3: TdxLayoutSeparatorItem
      Parent = dxLayoutAutoCreatedGroup37
      AlignHorz = ahClient
      AlignVert = avCenter
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object dxLayoutAutoCreatedGroup37: TdxLayoutAutoCreatedGroup
      Parent = tshStyles
      LayoutDirection = ldHorizontal
      Index = 2
    end
    object dxLayoutSeparatorItem4: TdxLayoutSeparatorItem
      Parent = dxLayoutAutoCreatedGroup38
      AlignHorz = ahClient
      AlignVert = avCenter
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object dxLayoutAutoCreatedGroup38: TdxLayoutAutoCreatedGroup
      Parent = tshView
      LayoutDirection = ldHorizontal
      Index = 0
    end
    object dxLayoutSeparatorItem5: TdxLayoutSeparatorItem
      Parent = dxLayoutAutoCreatedGroup39
      AlignHorz = ahClient
      AlignVert = avCenter
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object dxLayoutAutoCreatedGroup39: TdxLayoutAutoCreatedGroup
      Parent = tshView
      LayoutDirection = ldHorizontal
      Index = 2
    end
    object dxLayoutSeparatorItem6: TdxLayoutSeparatorItem
      Parent = dxLayoutAutoCreatedGroup40
      AlignHorz = ahClient
      AlignVert = avCenter
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object dxLayoutAutoCreatedGroup40: TdxLayoutAutoCreatedGroup
      Parent = tshBehaviors
      LayoutDirection = ldHorizontal
      Index = 0
    end
    object dxLayoutSeparatorItem7: TdxLayoutSeparatorItem
      Parent = dxLayoutAutoCreatedGroup41
      AlignHorz = ahClient
      AlignVert = avCenter
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object dxLayoutAutoCreatedGroup41: TdxLayoutAutoCreatedGroup
      Parent = tshBehaviors
      LayoutDirection = ldHorizontal
      Index = 2
    end
    object dxLayoutSeparatorItem8: TdxLayoutSeparatorItem
      Parent = dxLayoutAutoCreatedGroup42
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object dxLayoutAutoCreatedGroup42: TdxLayoutAutoCreatedGroup
      Parent = tshBehaviors
      LayoutDirection = ldHorizontal
      Index = 4
    end
    object dxLayoutSeparatorItem9: TdxLayoutSeparatorItem
      Parent = dxLayoutAutoCreatedGroup43
      AlignHorz = ahClient
      AlignVert = avCenter
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object dxLayoutAutoCreatedGroup43: TdxLayoutAutoCreatedGroup
      Parent = lgDetails
      LayoutDirection = ldHorizontal
      Index = 0
    end
    object dxLayoutSeparatorItem10: TdxLayoutSeparatorItem
      Parent = dxLayoutAutoCreatedGroup44
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object dxLayoutAutoCreatedGroup44: TdxLayoutAutoCreatedGroup
      Parent = lgLevels
      LayoutDirection = ldHorizontal
      Index = 1
    end
    object dxLayoutSeparatorItem11: TdxLayoutSeparatorItem
      Parent = dxLayoutAutoCreatedGroup45
      AlignHorz = ahClient
      AlignVert = avCenter
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object dxLayoutAutoCreatedGroup45: TdxLayoutAutoCreatedGroup
      Parent = tshFormatting
      LayoutDirection = ldHorizontal
      Index = 0
    end
    object dxLayoutSeparatorItem12: TdxLayoutSeparatorItem
      Parent = dxLayoutAutoCreatedGroup46
      AlignHorz = ahClient
      AlignVert = avCenter
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object dxLayoutAutoCreatedGroup46: TdxLayoutAutoCreatedGroup
      Parent = tshFormatting
      LayoutDirection = ldHorizontal
      Index = 2
    end
    object dxLayoutSeparatorItem13: TdxLayoutSeparatorItem
      Parent = dxLayoutAutoCreatedGroup47
      AlignHorz = ahClient
      AlignVert = avCenter
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object dxLayoutAutoCreatedGroup47: TdxLayoutAutoCreatedGroup
      Parent = lgPagination
      LayoutDirection = ldHorizontal
      Index = 0
    end
    object dxLayoutSeparatorItem14: TdxLayoutSeparatorItem
      Parent = dxLayoutAutoCreatedGroup48
      AlignHorz = ahClient
      AlignVert = avCenter
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object dxLayoutAutoCreatedGroup48: TdxLayoutAutoCreatedGroup
      Parent = tshPreview
      LayoutDirection = ldHorizontal
      Index = 0
    end
    object dxLayoutSeparatorItem15: TdxLayoutSeparatorItem
      Parent = dxLayoutAutoCreatedGroup49
      AlignHorz = ahClient
      AlignVert = avCenter
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object dxLayoutAutoCreatedGroup49: TdxLayoutAutoCreatedGroup
      Parent = tshCards
      LayoutDirection = ldHorizontal
      Index = 0
    end
    object dxLayoutSeparatorItem16: TdxLayoutSeparatorItem
      Parent = dxLayoutAutoCreatedGroup50
      AlignHorz = ahClient
      AlignVert = avCenter
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object dxLayoutAutoCreatedGroup50: TdxLayoutAutoCreatedGroup
      Parent = tshCards
      LayoutDirection = ldHorizontal
      Index = 2
    end
    object dxLayoutSeparatorItem17: TdxLayoutSeparatorItem
      Parent = dxLayoutAutoCreatedGroup51
      AlignHorz = ahClient
      AlignVert = avCenter
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object dxLayoutAutoCreatedGroup51: TdxLayoutAutoCreatedGroup
      Parent = tshCards
      LayoutDirection = ldHorizontal
      Index = 4
    end
    object dxLayoutSeparatorItem18: TdxLayoutSeparatorItem
      Parent = dxLayoutAutoCreatedGroup52
      AlignHorz = ahClient
      AlignVert = avCenter
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object dxLayoutAutoCreatedGroup52: TdxLayoutAutoCreatedGroup
      Parent = tshCards
      LayoutDirection = ldHorizontal
      Index = 6
    end
    object dxLayoutSeparatorItem19: TdxLayoutSeparatorItem
      Parent = dxLayoutAutoCreatedGroup53
      AlignHorz = ahClient
      AlignVert = avCenter
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object dxLayoutAutoCreatedGroup53: TdxLayoutAutoCreatedGroup
      Parent = tshCharts
      LayoutDirection = ldHorizontal
      Index = 0
    end
  end
  inherited dxLayoutLookAndFeelList1: TdxLayoutLookAndFeelList
    Left = 592
    Top = 224
    inherited dxLayoutCxLookAndFeel1: TdxLayoutCxLookAndFeel
      PixelsPerInch = 96
    end
  end
  object pmStyles: TPopupMenu
    Images = ilStylesPopup
    OnPopup = pmStylesPopup
    Left = 204
    Top = 424
    object miStyleFont: TMenuItem
      Caption = '&Font...'
      ImageIndex = 0
      OnClick = StyleFontClick
    end
    object miStyleColor: TMenuItem
      Caption = '&Color...'
      OnClick = StyleColorClick
    end
    object miLine3: TMenuItem
      Caption = '-'
    end
    object miStyleBackgroundBitmap: TMenuItem
      Caption = '&Bitmap...'
      ImageIndex = 1
      ShortCut = 16463
      OnClick = StyleBackgroundBitmapClick
    end
    object miStyleBackgroundBitmapClear: TMenuItem
      Caption = 'Clear'
      ImageIndex = 3
      ShortCut = 16430
      OnClick = StyleBackgroundBitmapClearClick
    end
    object miLine2: TMenuItem
      Caption = '-'
    end
    object miStyleRestoreDefaults: TMenuItem
      Caption = 'Restore Defaults'
      OnClick = StyleRestoreDefaultsClick
    end
    object milLine: TMenuItem
      Caption = '-'
    end
    object miStylesSelectAll: TMenuItem
      Caption = 'Select A&ll'
      ShortCut = 16449
      OnClick = miStylesSelectAllClick
    end
    object miLine4: TMenuItem
      Caption = '-'
    end
    object miStylesSaveAs: TMenuItem
      Caption = 'Save &As...'
      ImageIndex = 2
      ShortCut = 16467
      OnClick = StylesSaveAsClick
    end
  end
  object cxStyleRepository1: TcxStyleRepository
    Left = 236
    Top = 424
    PixelsPerInch = 96
    object styleCardShadow: TcxStyle
    end
    object styleCardBorder: TcxStyle
      AssignedValues = [svColor]
      Color = clWindow
    end
  end
  object ilStylesPopup: TcxImageList
    SourceDPI = 96
    FormatVersion = 1
    DesignInfo = 27787480
  end
end
