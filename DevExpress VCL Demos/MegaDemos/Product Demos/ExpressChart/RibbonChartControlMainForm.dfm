inherited frmMain: TfrmMain
  Caption = 'frmMain'
  ExplicitWidth = 916
  ExplicitHeight = 632
  PixelsPerInch = 96
  TextHeight = 13
  inherited dxRibbon1: TdxRibbon
    Width = 900
    inherited dxRibbon1Tab1: TdxRibbonTab
      Index = 0
    end
    inherited dxRibbon1Tab2: TdxRibbonTab
      Index = 1
    end
  end
  inherited pnlAllArea: TdxPanel
    ExplicitTop = 133
    ExplicitHeight = 460
    inherited plClient: TdxPanel
      ExplicitHeight = 460
      inherited dxRibbonBackstageView1: TdxRibbonBackstageView
        inherited bvtExport: TdxRibbonBackstageViewTabSheet
          Active = False
          TabVisible = False
        end
        inherited bvtPrint: TdxRibbonBackstageViewTabSheet
          TabVisible = False
        end
        inherited bvtExit: TdxRibbonBackstageViewTabSheet
          Active = True
        end
      end
    end
    inherited NavBarSite: TPanel
      inherited NavBar: TdxNavBar
        ActiveGroupIndex = 2
        object nvgHighlightedFeatures: TdxNavBarGroup [0]
          Caption = 'Highlighted Features'
          SelectedLinkIndex = -1
          TopVisibleLinkIndex = 0
          VisibleForCustomization = False
          CustomStyles.Header = nbsGroupStyle
          CustomStyles.HeaderActive = nbsGroupStyle
          CustomStyles.HeaderActiveHotTracked = nbsGroupStyle
          CustomStyles.HeaderActivePressed = nbsGroupStyle
          CustomStyles.HeaderHotTracked = nbsGroupStyle
          CustomStyles.HeaderPressed = nbsGroupStyle
          Links = <>
        end
        object nvgViews: TdxNavBarGroup [1]
          Caption = 'Views'
          SelectedLinkIndex = -1
          TopVisibleLinkIndex = 0
          CustomStyles.Header = nbsGroupStyle
          CustomStyles.HeaderActive = nbsGroupStyle
          CustomStyles.HeaderActiveHotTracked = nbsGroupStyle
          CustomStyles.HeaderActivePressed = nbsGroupStyle
          CustomStyles.HeaderHotTracked = nbsGroupStyle
          CustomStyles.HeaderPressed = nbsGroupStyle
          Links = <>
        end
        inherited nbgSearch: TdxNavBarGroup
          Links = <>
        end
        object NavBarItem1: TdxNavBarItem [3]
          Caption = 'NavBarItem1'
          CustomStyles.Item = nbsItemStyle
        end
        inherited nbcSearch: TdxNavBarGroupControl
          Top = 57
          ExplicitTop = 57
          GroupIndex = 2
        end
      end
    end
  end
  inherited dxBarManager: TdxBarManager
    PixelsPerInch = 96
    inherited barPrintAndExport: TdxBar
      DockedDockControl = nil
      DockedDockingStyle = dsNone
      FloatClientWidth = 88
      FloatClientHeight = 179
      Visible = False
    end
    inherited barInfo: TdxBar
      DockedDockControl = nil
      DockedDockingStyle = dsNone
      DockedLeft = 681
    end
    inherited barOptions: TdxBar
      DockedDockControl = nil
      DockedDockingStyle = dsNone
      FloatClientWidth = 110
      FloatClientHeight = 126
      ItemLinks = <
        item
          Visible = True
          ItemName = 'btnDesigner'
        end
        item
          Visible = True
          ItemName = 'biPalette'
        end
        item
          Visible = True
          ItemName = 'biShowInspector'
        end>
    end
    inherited barAppearance: TdxBar
      DockedDockControl = nil
      DockedDockingStyle = dsNone
    end
    inherited barView: TdxBar
      DockedDockControl = nil
      DockedDockingStyle = dsNone
      DockedLeft = 391
      FloatClientWidth = 120
      FloatClientHeight = 187
    end
    inherited barNavigation: TdxBar
      DockedDockControl = nil
      DockedDockingStyle = dsNone
      FloatClientWidth = 81
      FloatClientHeight = 50
    end
    inherited biPrintPreview: TdxBarLargeButton
      Visible = ivNever
    end
    inherited biPrint: TdxBarLargeButton
      Visible = ivNever
    end
    inherited biExportToHTML: TdxBarLargeButton
      ImageIndex = 103
    end
    inherited biExportToXML: TdxBarLargeButton
      ImageIndex = 99
    end
    inherited biExportToExcel97: TdxBarLargeButton
      ImageIndex = 97
    end
    inherited biExportToExcel: TdxBarLargeButton
      ImageIndex = 98
    end
    inherited biExportToPDF: TdxBarLargeButton
      ImageIndex = 94
    end
    inherited biExportToText: TdxBarLargeButton
      ImageIndex = 96
    end
    inherited biShowInspector: TdxBarLargeButton
      ImageIndex = 107
    end
    inherited biPageSetup: TdxBarLargeButton
      ImageIndex = 1
    end
    inherited biFullWindowMode: TdxBarLargeButton
      ImageIndex = 45
    end
    inherited BLightStyle: TdxBarLargeButton
      ImageIndex = 106
    end
    object btnDesigner: TdxBarLargeButton [35]
      Caption = 'Designer'
      Category = 0
      Hint = 'Designer'
      Visible = ivAlways
      LargeGlyph.SourceDPI = 96
      LargeGlyph.Data = {
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
        423131353B7D262331333B262331303B2623393B2E477265656E7B66696C6C3A
        233033394332333B7D262331333B262331303B2623393B2E5265647B66696C6C
        3A234431314331433B7D3C2F7374796C653E0D0A3C7265637420793D22313422
        20636C6173733D22477265656E222077696474683D223622206865696768743D
        223132222F3E0D0A3C7061746820636C6173733D2259656C6C6F772220643D22
        4D31302C333068323256384C31302C33307A204D32382C3236682D386C382D38
        5632367A222F3E0D0A3C706F6C79676F6E20636C6173733D22426C7565222070
        6F696E74733D2231342C3820382C3820382C32362031302C32362031342C3232
        20222F3E0D0A3C706F6C79676F6E20636C6173733D225265642220706F696E74
        733D2232322C322031362C322031362C32302032322C313420222F3E0D0A3C2F
        7376673E0D0A}
      OnClick = btnDesignerClick
    end
    object biPalette: TdxRibbonGalleryItem [36]
      Caption = 'Palette'
      Category = 0
      Visible = ivAlways
      LargeGlyph.SourceDPI = 96
      LargeGlyph.Data = {
        3C7376672076657273696F6E3D22312E31222069643D224C617965725F312220
        786D6C6E733D22687474703A2F2F7777772E77332E6F72672F323030302F7376
        672220786D6C6E733A786C696E6B3D22687474703A2F2F7777772E77332E6F72
        672F313939392F786C696E6B2220783D223070782220793D22307078220D0A09
        2076696577426F783D2230203020333220333222207374796C653D22656E6162
        6C652D6261636B67726F756E643A6E6577203020302033322033323B2220786D
        6C3A73706163653D227072657365727665223E0D0A3C7374796C652074797065
        3D22746578742F637373223E0D0A092E59656C6C6F777B66696C6C3A23464642
        3131353B7D0D0A092E5265647B66696C6C3A234431314331433B7D0D0A092E42
        6C61636B7B66696C6C3A233732373237323B7D0D0A092E426C75657B66696C6C
        3A233131373744373B7D0D0A092E57686974657B66696C6C3A23464646464646
        3B7D0D0A092E477265656E7B66696C6C3A233033394332333B7D0D0A092E7374
        307B6F7061636974793A302E37353B7D0D0A092E7374317B6F7061636974793A
        302E353B7D0D0A092E7374327B6F7061636974793A302E32353B7D0D0A092E73
        74337B66696C6C3A234646423131353B7D0D0A3C2F7374796C653E0D0A3C6720
        69643D2245646974436F6C6F7273223E0D0A093C7061746820636C6173733D22
        426C61636B2220643D224D32392C30483143302E352C302C302C302E352C302C
        3176323863302C302E352C302E352C312C312C3168323863302E352C302C312D
        302E352C312D3156314333302C302E352C32392E352C302C32392C307A204D32
        382C3238483256326832365632387A222F3E0D0A093C7061746820636C617373
        3D2259656C6C6F772220643D224D31302C31304834563468365631307A204D31
        382C34682D367636683656347A204D31302C31324834763668365631327A222F
        3E0D0A093C7061746820636C6173733D22477265656E2220643D224D31302C32
        364834762D3668365632367A204D31382C3132682D36763668365631327A222F
        3E0D0A093C7061746820636C6173733D225265642220643D224D32362C313068
        2D36563468365631307A204D32362C3132682D36763668365631327A222F3E0D
        0A093C7061746820636C6173733D22426C75652220643D224D32362C3236682D
        36762D3668365632367A204D31382C3230682D36763668365632307A222F3E0D
        0A093C6720636C6173733D22737431223E0D0A09093C7265637420783D223422
        20793D2231322220636C6173733D22477265656E222077696474683D22362220
        6865696768743D2236222F3E0D0A09093C7061746820636C6173733D22526564
        2220643D224D31382C3130682D36563468365631307A204D32362C3230682D36
        763668365632307A222F3E0D0A09093C7061746820636C6173733D22426C7565
        2220643D224D32362C3138682D36762D3668365631387A204D31382C3132682D
        36763668365631327A222F3E0D0A093C2F673E0D0A093C6720636C6173733D22
        737431223E0D0A09093C7265637420783D2232302220793D2232302220636C61
        73733D22426C7565222077696474683D223622206865696768743D2236222F3E
        0D0A093C2F673E0D0A3C2F673E0D0A3C2F7376673E0D0A}
      GalleryFilter.Categories = <>
      GalleryInRibbonOptions.Collapsed = True
      ItemLinks = <>
    end
  end
  inherited dxComponentPrinter: TdxComponentPrinter
    PixelsPerInch = 96
  end
  inherited RibbonApplicationMenu: TdxBarApplicationMenu
    PixelsPerInch = 96
  end
  inherited dxPSEngineController1: TdxPSEngineController
    Active = True
  end
  inherited ilBarSmall: TcxImageList
    FormatVersion = 1
  end
  inherited dxLayoutLookAndFeelList1: TdxLayoutLookAndFeelList
    inherited dxLayoutSkinLookAndFeel1: TdxLayoutSkinLookAndFeel
      PixelsPerInch = 96
    end
    inherited dxLayoutSkinLookAndFeelDescription: TdxLayoutSkinLookAndFeel
      PixelsPerInch = 96
    end
    inherited dxLayoutSkinLookAndFeelBoldItemCaption: TdxLayoutSkinLookAndFeel
      PixelsPerInch = 96
    end
  end
end
