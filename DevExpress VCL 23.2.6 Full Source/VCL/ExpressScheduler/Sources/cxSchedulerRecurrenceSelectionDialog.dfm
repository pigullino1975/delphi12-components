object fmRecurrenceSelectionForm: TfmRecurrenceSelectionForm
  Left = 217
  Top = 476
  AutoSize = True
  BorderStyle = bsDialog
  Caption = 'fmRecurrenceSelectionForm'
  ClientHeight = 153
  ClientWidth = 300
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lcMain: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 300
    Height = 153
    TabOrder = 0
    AutoSize = True
    LayoutLookAndFeel = dxLayoutCxLookAndFeel1
    object Image: TImage
      Left = 10
      Top = 10
      Width = 49
      Height = 49
      Center = True
      Picture.Data = {
        0D546478536D617274496D6167653C3F786D6C2076657273696F6E3D22312E30
        2220656E636F64696E673D225554462D38223F3E0D0A3C737667207665727369
        6F6E3D22312E31222069643D224C617965725F312220786D6C6E733D22687474
        703A2F2F7777772E77332E6F72672F323030302F7376672220786D6C6E733A78
        6C696E6B3D22687474703A2F2F7777772E77332E6F72672F313939392F786C69
        6E6B2220783D223070782220793D22307078222076696577426F783D22302030
        20333220333222207374796C653D22656E61626C652D6261636B67726F756E64
        3A6E6577203020302033322033323B2220786D6C3A73706163653D2270726573
        65727665223E262331333B262331303B3C7374796C6520747970653D22746578
        742F6373732220786D6C3A73706163653D227072657365727665223E2E426C61
        636B7B66696C6C3A233732373237323B7D262331333B262331303B2623393B2E
        5265647B66696C6C3A234431314331433B7D262331333B262331303B2623393B
        2E59656C6C6F777B66696C6C3A234646423131353B7D262331333B262331303B
        2623393B2E477265656E7B66696C6C3A233033394332333B7D3C2F7374796C65
        3E0D0A3C672069643D225761726E696E67223E0D0A09093C7061746820636C61
        73733D2259656C6C6F772220643D224D31342E392C342E3763302E362D312C31
        2E352D312C322E312C306C31322E372C32312E3563302E362C312C302E312C31
        2E382D312C312E3848332E33632D312E322C302D312E362D302E382D312D312E
        384C31342E392C342E377A222F3E0D0A09093C636972636C6520636C6173733D
        22426C61636B222063783D223136222063793D2232322220723D2232222F3E0D
        0A09093C7265637420783D2231342220793D2231302220636C6173733D22426C
        61636B222077696474683D223422206865696768743D2238222F3E0D0A093C2F
        673E0D0A3C2F7376673E0D0A}
      Stretch = True
      Transparent = True
    end
    object rbOccurrence: TcxRadioButton
      Left = 64
      Top = 65
      Caption = 'rbOccurrence'
      Checked = True
      Color = 16448250
      ParentColor = False
      TabOrder = 0
      TabStop = True
      AutoSize = True
      ParentBackground = False
      Transparent = True
    end
    object rbSeries: TcxRadioButton
      Left = 64
      Top = 93
      Caption = 'rbSeries'
      Color = 16448250
      ParentColor = False
      TabOrder = 1
      AutoSize = True
      ParentBackground = False
      Transparent = True
    end
    object btnOk: TcxButton
      Left = 48
      Top = 121
      Width = 90
      Height = 23
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 2
    end
    object btnCancel: TcxButton
      Left = 144
      Top = 121
      Width = 90
      Height = 23
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 3
    end
    object lcMainGroup_Root: TdxLayoutGroup
      AlignHorz = ahClient
      AlignVert = avTop
      Hidden = True
      ShowBorder = False
      Index = -1
    end
    object dxLayoutItem1: TdxLayoutItem
      Parent = dxLayoutGroup1
      AlignHorz = ahLeft
      AlignVert = avTop
      Control = Image
      ControlOptions.OriginalHeight = 49
      ControlOptions.OriginalWidth = 49
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutGroup2: TdxLayoutGroup
      Parent = lcMainGroup_Root
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'Hidden Group'
      Hidden = True
      ItemIndex = 1
      ShowBorder = False
      Index = 1
    end
    object dxLayoutGroup3: TdxLayoutGroup
      Parent = dxLayoutGroup2
      AlignHorz = ahLeft
      CaptionOptions.Text = 'Hidden Group'
      Offsets.Left = 54
      Hidden = True
      ShowBorder = False
      Index = 0
    end
    object dxLayoutItem2: TdxLayoutItem
      Parent = dxLayoutGroup3
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'rbOccurrence'
      CaptionOptions.Visible = False
      Control = rbOccurrence
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 201
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem3: TdxLayoutItem
      Parent = dxLayoutGroup3
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'rbSeries'
      CaptionOptions.Visible = False
      Control = rbSeries
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 193
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutGroup4: TdxLayoutGroup
      Parent = dxLayoutGroup2
      AlignHorz = ahCenter
      CaptionOptions.Text = 'Hidden Group'
      Hidden = True
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 1
    end
    object dxLayoutItem4: TdxLayoutItem
      Parent = dxLayoutGroup4
      CaptionOptions.Text = 'btnOk'
      CaptionOptions.Visible = False
      Control = btnOk
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 90
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem5: TdxLayoutItem
      Parent = dxLayoutGroup4
      CaptionOptions.Text = 'btnCancel'
      CaptionOptions.Visible = False
      Control = btnCancel
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 90
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lbMessage: TdxLayoutLabeledItem
      Parent = dxLayoutGroup1
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.WordWrap = True
      Index = 1
    end
    object dxLayoutGroup1: TdxLayoutGroup
      Parent = lcMainGroup_Root
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'New Group'
      SizeOptions.Width = 200
      ItemIndex = 1
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 0
    end
  end
  object dxLayoutLookAndFeelList1: TdxLayoutLookAndFeelList
    object dxLayoutCxLookAndFeel1: TdxLayoutCxLookAndFeel
      PixelsPerInch = 96
    end
  end
end
