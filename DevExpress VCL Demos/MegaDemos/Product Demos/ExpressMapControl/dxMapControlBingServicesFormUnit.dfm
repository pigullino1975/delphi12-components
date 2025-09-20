inherited frmBingServices: TfrmBingServices
  Caption = 'Bing Services'
  ClientHeight = 505
  ClientWidth = 880
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  ExplicitWidth = 880
  ExplicitHeight = 505
  PixelsPerInch = 96
  TextHeight = 13
  object dxRibbon1: TdxRibbon [0]
    Left = 0
    Top = 0
    Width = 880
    Height = 126
    BarManager = dxBarManager1
    ColorSchemeName = 'Blue'
    Contexts = <>
    TabOrder = 0
    TabStop = False
    object dxRibbon1Tab1: TdxRibbonTab
      Active = True
      Caption = 'Demo'
      Groups = <
        item
        end
        item
          Caption = 'Bing Services'
          ToolbarName = 'dxBarManager1Bar1'
        end>
      Index = 0
    end
  end
  inherited lcMain: TdxLayoutControl
    Top = 126
    Width = 880
    Height = 379
    TabOrder = 1
    ExplicitTop = 126
    ExplicitWidth = 880
    ExplicitHeight = 379
    inherited pnlMap: TPanel
      Top = 10
      Width = 604
      Height = 321
      ExplicitTop = 10
      ExplicitWidth = 604
      ExplicitHeight = 321
      inherited dxMapControl1: TdxMapControl
        Width = 604
        Height = 321
        CenterPoint.Longitude = -118.255629000000000000
        CenterPoint.Latitude = 34.158506000000000000
        OptionsBehavior.MapItemSelectMode = mismNone
        PopupMenu = dxRibbonPopupMenu1
        ZoomLevel = 14.000000000000000000
        OnMouseDown = dxMapControl1MouseDown
        OnMouseUp = dxMapControl1MouseUp
        ExplicitWidth = 604
        ExplicitHeight = 321
        object dxMapControl1ImageTileLayer1: TdxMapImageTileLayer
          ProviderClassName = 'TdxMapControlBingMapImageryDataProvider'
        end
        object dxMapControl1ItemLayer1: TdxMapItemLayer
          ProjectionClassName = 'TdxMapControlSphericalMercatorProjection'
          ItemStyle.AssignedValues = [mcsvBorderWidth, mcsvBorderColor]
          ItemStyle.BorderColor = -1627389697
          ItemStyle.BorderWidth = 4
          ItemStyleHot.AssignedValues = [mcsvBorderWidth, mcsvBorderColor]
          ItemStyleHot.BorderColor = -8355712
          ItemStyleHot.BorderWidth = 4
          object miManeuverPoint: TdxMapDot
            Style.AssignedValues = [mcsvColor, mcsvBorderColor]
            Style.BorderColor = -1627389952
            Style.Color = -1
            Visible = False
            Size = 2
          end
          object miNewPointPointer: TdxMapDot
            Style.AssignedValues = [mcsvColor, mcsvBorderWidth, mcsvBorderColor]
            Style.BorderColor = -1
            Style.BorderWidth = 1
            Style.Color = -65536
            StyleHot.AssignedValues = [mcsvColor, mcsvBorderWidth, mcsvBorderColor]
            StyleHot.BorderColor = -1
            StyleHot.BorderWidth = 1
            StyleHot.Color = -65536
            Visible = False
            Size = 4
          end
        end
        object dxMapControl1BingMapGeoCodingDataProvider1: TdxMapControlBingMapGeoCodingDataProvider
          OnResponse = dxMapControl1BingMapGeoCodingDataProvider1Response
        end
        object dxMapControl1BingMapReverseGeoCodingDataProvider1: TdxMapControlBingMapReverseGeoCodingDataProvider
          OnResponse = dxMapControl1BingMapReverseGeoCodingDataProvider1Response
        end
        object dxMapControl1BingMapRouteDataProvider1: TdxMapControlBingMapRouteDataProvider
          OnResponse = dxMapControl1BingMapRouteDataProvider1Response
          MaxSolutions = 3
        end
        object dxMapControl1BingMapMajorRoadRouteDataProvider1: TdxMapControlBingMapMajorRoadRouteDataProvider
          OnResponse = dxMapControl1BingMapMajorRoadRouteDataProvider1Response
        end
      end
      object cxImage1: TcxImage
        Left = 392
        Top = 12
        TabStop = False
        Anchors = [akTop, akRight]
        AutoSize = True
        Properties.Center = False
        Properties.FitMode = ifmNormal
        Properties.GraphicClassName = 'TdxSmartImage'
        Properties.ShowFocusRect = False
        Style.BorderStyle = ebsNone
        StyleFocused.BorderStyle = ebsNone
        StyleHot.BorderStyle = ebsNone
        TabOrder = 1
        Transparent = True
        Height = 43
        Width = 182
      end
      object cxTextEdit1: TcxTextEdit
        Left = 404
        Top = 24
        Anchors = [akTop, akRight]
        Properties.OnChange = cxTextEdit1PropertiesChange
        Style.BorderStyle = ebsUltraFlat
        TabOrder = 2
        TextHint = 'Enter search location'
        Width = 161
      end
    end
    object cxComboBox1: TcxComboBox [1]
      Left = 630
      Top = 10
      Anchors = [akLeft, akTop, akRight]
      Properties.DropDownListStyle = lsFixedList
      Properties.OnEditValueChanged = cxComboBox1PropertiesEditValueChanged
      Style.HotTrack = False
      TabOrder = 1
      Width = 240
    end
    object cxListBox1: TcxListBox [2]
      Left = 630
      Top = 37
      Width = 240
      Height = 263
      Anchors = [akLeft, akTop, akRight, akBottom]
      ItemHeight = 13
      TabOrder = 2
      OnClick = cxListBox1Click
    end
    object cxButton1: TcxButton [3]
      Left = 753
      Top = 306
      Width = 117
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Show all route points'
      TabOrder = 4
      OnClick = cxButton1Click
    end
    object cxButton2: TcxButton [4]
      Left = 630
      Top = 306
      Width = 117
      Height = 25
      Action = actClear
      Anchors = [akRight, akBottom]
      TabOrder = 3
    end
    inherited lgContent: TdxLayoutGroup
      LayoutDirection = ldHorizontal
    end
    inherited lsSetupSplitter: TdxLayoutSplitterItem
      AlignHorz = ahRight
      Visible = True
    end
    inherited lgSetupTools: TdxLayoutGroup
      AlignHorz = ahRight
      AlignVert = avClient
      Visible = True
      SizeOptions.Width = 240
      ItemIndex = 1
      Index = 2
    end
    inherited dxLayoutItem1: TdxLayoutItem
      CaptionOptions.Text = 'dxMapControl1'
      Index = 0
    end
    object dxLayoutItem2: TdxLayoutItem
      Parent = dxLayoutGroup2
      AlignHorz = ahClient
      AlignVert = avTop
      Control = cxComboBox1
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem3: TdxLayoutItem
      Parent = dxLayoutGroup2
      AlignHorz = ahClient
      AlignVert = avClient
      Control = cxListBox1
      ControlOptions.OriginalHeight = 269
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem4: TdxLayoutItem
      Parent = dxLayoutGroup1
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Visible = False
      Control = cxButton1
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem5: TdxLayoutItem
      Parent = dxLayoutGroup1
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Visible = False
      Control = cxButton2
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutGroup1: TdxLayoutGroup
      Parent = lgSetupTools
      AlignHorz = ahClient
      AlignVert = avBottom
      CaptionOptions.Text = 'New Group'
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 1
    end
    object dxLayoutGroup2: TdxLayoutGroup
      Parent = lgSetupTools
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'New Group'
      ShowBorder = False
      Index = 0
    end
  end
  inherited dxBarManager1: TdxBarManager
    Categories.Strings = (
      'Default'
      'PopupMenu1')
    Categories.ItemsVisibles = (
      2
      2)
    Categories.Visibles = (
      True
      True)
    PixelsPerInch = 96
    object dxBarManager1Bar1: TdxBar
      Caption = 'Bing Services Demo Options'
      CaptionButtons = <>
      DockedLeft = 0
      DockedTop = 0
      FloatLeft = 831
      FloatTop = 8
      FloatClientWidth = 51
      FloatClientHeight = 66
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'dxBarButton2'
        end
        item
          Visible = True
          ItemName = 'dxBarButton3'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object dxBarLargeButton1: TdxBarLargeButton
      Caption = 'Driving'
      Category = 0
      Hint = 'Driving'
      Visible = ivAlways
      ButtonStyle = bsChecked
      GroupIndex = 1
      Down = True
      OnClick = dxBarLargeButton1Click
    end
    object dxBarLargeButton2: TdxBarLargeButton
      Tag = 1
      Caption = 'Walking'
      Category = 0
      Hint = 'Walking'
      Visible = ivAlways
      ButtonStyle = bsChecked
      GroupIndex = 1
      OnClick = dxBarLargeButton1Click
    end
    object dxBarLargeButton3: TdxBarLargeButton
      Tag = 2
      Caption = 'Transit'
      Category = 0
      Hint = 'Transit'
      Visible = ivAlways
      ButtonStyle = bsChecked
      GroupIndex = 1
      OnClick = dxBarLargeButton1Click
    end
    object dxBarButton1: TdxBarButton
      Caption = 'Driving'
      Category = 0
      Hint = 'Driving'
      Visible = ivAlways
      ButtonStyle = bsChecked
      OnClick = dxBarLargeButton1Click
    end
    object dxBarButton2: TdxBarButton
      Caption = 'Walking'
      Category = 0
      Hint = 'Walking'
      Visible = ivAlways
      ButtonStyle = bsChecked
      OnClick = dxBarLargeButton1Click
    end
    object dxBarButton3: TdxBarButton
      Caption = 'Transit'
      Category = 0
      Hint = 'Transit'
      Visible = ivAlways
      ButtonStyle = bsChecked
      OnClick = dxBarLargeButton1Click
    end
    object Setstartpoint1: TdxBarButton
      Action = actAddStartPoint
      Category = 1
    end
    object Setasstartpoint1: TdxBarButton
      Action = actSetAsStartPoint
      Category = 1
    end
    object Changestartpoint1: TdxBarButton
      Action = actChangeStartPoint
      Category = 1
    end
    object Addroutepoint1: TdxBarButton
      Action = actAddEndPoint
      Category = 1
    end
    object Setasroutepoint1: TdxBarButton
      Action = actSetAsEndPoint
      Category = 1
    end
    object Showroutefrommajorroads1: TdxBarButton
      Action = actRouteFromMajorRoads
      Category = 1
    end
    object Deletepoint1: TdxBarButton
      Action = actDeletePoint
      Category = 1
    end
  end
  object ActionList1: TActionList [3]
    Left = 488
    Top = 264
    object actAddStartPoint: TAction
      Caption = 'Set start point'
      OnExecute = actAddStartPointExecute
    end
    object actAddEndPoint: TAction
      Caption = 'Add end point'
      OnExecute = actAddEndPointExecute
    end
    object actDeletePoint: TAction
      Caption = 'Delete point'
      OnExecute = actDeletePointExecute
    end
    object actChangeStartPoint: TAction
      Caption = 'Change start point'
      OnExecute = actChangeStartPointExecute
    end
    object actClear: TAction
      Caption = 'Clear route points'
      OnExecute = actClearExecute
    end
    object actSetAsStartPoint: TAction
      Caption = 'Set as start point'
      OnExecute = actSetAsStartPointExecute
    end
    object actSetAsEndPoint: TAction
      Caption = 'Set as end point'
      OnExecute = actSetAsEndPointExecute
    end
    object actRouteFromMajorRoads: TAction
      Caption = 'Show route from major roads'
      OnExecute = actRouteFromMajorRoadsExecute
    end
  end
  object dxRibbonPopupMenu1: TdxRibbonPopupMenu [4]
    BarManager = dxBarManager1
    ItemLinks = <
      item
        Visible = True
        ItemName = 'Setstartpoint1'
      end
      item
        Visible = True
        ItemName = 'Setasstartpoint1'
      end
      item
        Visible = True
        ItemName = 'Changestartpoint1'
      end
      item
        Visible = True
        ItemName = 'Addroutepoint1'
      end
      item
        Visible = True
        ItemName = 'Setasroutepoint1'
      end
      item
        Visible = True
        ItemName = 'Showroutefrommajorroads1'
      end
      item
        Visible = True
        ItemName = 'Deletepoint1'
      end>
    Ribbon = dxRibbon1
    UseOwnFont = False
    OnPopup = dxBarPopupMenu1Popup
    Left = 288
    Top = 232
    PixelsPerInch = 96
  end
  inherited dxLayoutMainLookAndFeelList1: TdxLayoutLookAndFeelList
    inherited dxMainCxLookAndFeel1: TdxLayoutCxLookAndFeel
      PixelsPerInch = 96
    end
    inherited dxBigCaptionCxLookAndFeel1: TdxLayoutCxLookAndFeel
      PixelsPerInch = 96
    end
    inherited dxMediumCaptionCxLookAndFeel: TdxLayoutCxLookAndFeel
      PixelsPerInch = 96
    end
  end
end
