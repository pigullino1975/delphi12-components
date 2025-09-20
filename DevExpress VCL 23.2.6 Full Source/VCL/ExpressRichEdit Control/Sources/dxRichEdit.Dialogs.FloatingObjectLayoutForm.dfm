inherited dxFloatingObjectLayoutDialogForm: TdxFloatingObjectLayoutDialogForm
  Caption = 'Layout'
  ClientHeight = 358
  ClientWidth = 539
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 13
  inherited dxLayoutControl1: TdxLayoutControl
    Width = 539
    Height = 358
    object rbHorizontalAbsolutePositionItem: TcxRadioButton [0]
      Tag = 1
      Left = 10000
      Top = 10000
      Caption = 'Absolute &position'
      Color = 16448250
      ParentColor = False
      TabOrder = 1
      Visible = False
      AutoSize = True
      GroupIndex = 1
      ParentBackground = False
      Transparent = True
    end
    object rbHorizontalAlignmentItem: TcxRadioButton [1]
      Left = 10000
      Top = 10000
      Caption = '&Alignment'
      Color = 16448250
      ParentColor = False
      TabOrder = 0
      Visible = False
      AutoSize = True
      GroupIndex = 1
      ParentBackground = False
      Transparent = True
    end
    object cmbHorizontalAlignment: TcxComboBox [2]
      Left = 10000
      Top = 10000
      Properties.DropDownListStyle = lsFixedList
      Style.HotTrack = False
      TabOrder = 2
      Visible = False
      Width = 121
    end
    object cmbHorizontalPositionType: TcxComboBox [3]
      Left = 10000
      Top = 10000
      Properties.DropDownListStyle = lsFixedList
      Style.HotTrack = False
      TabOrder = 4
      Visible = False
      Width = 121
    end
    object seHorizontalAbsolutePosition: TdxMeasurementUnitEdit [4]
      Left = 10000
      Top = 10000
      TabOrder = 3
      Width = 121
    end
    object cmbHorizontalAbsolutePositionRightOf: TcxComboBox [5]
      Left = 10000
      Top = 10000
      Properties.DropDownListStyle = lsFixedList
      Style.HotTrack = False
      TabOrder = 5
      Visible = False
      Width = 121
    end
    object rbVerticalAbsolutePositionItem: TcxRadioButton [6]
      Tag = 1
      Left = 10000
      Top = 10000
      Caption = 'Absolute po&sition'
      Color = 16448250
      ParentColor = False
      TabOrder = 7
      Visible = False
      OnClick = rbVerticalAlignmentItemClick
      AutoSize = True
      GroupIndex = 2
      ParentBackground = False
      Transparent = True
    end
    object seVerticalAbsolutePosition: TdxMeasurementUnitEdit [7]
      Left = 10000
      Top = 10000
      TabOrder = 9
      Width = 121
    end
    object cmbVerticalAbsolutePositionBelow: TcxComboBox [8]
      Left = 10000
      Top = 10000
      Properties.DropDownListStyle = lsFixedList
      Style.HotTrack = False
      TabOrder = 11
      Visible = False
      Width = 121
    end
    object rbVerticalAlignmentItem: TcxRadioButton [9]
      Left = 10000
      Top = 10000
      Caption = 'Ali&gnment'
      Color = 16448250
      ParentColor = False
      TabOrder = 6
      Visible = False
      OnClick = rbVerticalAlignmentItemClick
      AutoSize = True
      GroupIndex = 2
      ParentBackground = False
      Transparent = True
    end
    object cmbVerticalAlignment: TcxComboBox [10]
      Left = 10000
      Top = 10000
      Properties.DropDownListStyle = lsFixedList
      Style.HotTrack = False
      TabOrder = 8
      Visible = False
      Width = 121
    end
    object cmbVerticalPositionType: TcxComboBox [11]
      Left = 10000
      Top = 10000
      Properties.DropDownListStyle = lsFixedList
      Style.HotTrack = False
      TabOrder = 10
      Visible = False
    end
    object cbLock: TcxCheckBox [12]
      Left = 10000
      Top = 10000
      Caption = '&Lock anchor'
      Style.HotTrack = False
      TabOrder = 12
      Transparent = True
      Visible = False
    end
    object btnPresetControlSquare: TcxButton [13]
      Left = 79
      Top = 55
      Width = 40
      Height = 40
      OptionsImage.Glyph.SourceDPI = 96
      OptionsImage.Glyph.Data = {
        3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
        462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D2254
        657874577261705371756172652220786D6C6E733D22687474703A2F2F777777
        2E77332E6F72672F323030302F7376672220786D6C6E733A786C696E6B3D2268
        7474703A2F2F7777772E77332E6F72672F313939392F786C696E6B2220783D22
        3070782220793D22307078222076696577426F783D2230203020333220333222
        207374796C653D22656E61626C652D6261636B67726F756E643A6E6577203020
        302033322033323B2220786D6C3A73706163653D227072657365727665223E26
        2331333B262331303B3C7374796C6520747970653D22746578742F6373732220
        786D6C3A73706163653D227072657365727665223E2E426C61636B7B66696C6C
        3A233732373237323B7D262331333B262331303B2623393B2E426C75657B6669
        6C6C3A233131373744373B7D3C2F7374796C653E0D0A3C7061746820636C6173
        733D22426C61636B2220643D224D33312C30483143302E352C302C302C302E35
        2C302C3176323863302C302E352C302E352C312C312C3168333063302E352C30
        2C312D302E352C312D3156314333322C302E352C33312E352C302C33312C307A
        204D33302C3238483256326832385632387A20202623393B204D362C32324834
        762D3268325632327A204D362C31364834763268325631367A204D362C384834
        7632683256387A204D342C3236683234762D3248345632367A204D362C313248
        34763268325631327A204D342C347632683234563448347A204D32362C323268
        32762D32682D325632327A204D32362C31306832563820202623393B682D3256
        31307A204D32362C31346832762D32682D325631347A204D32362C3138683276
        2D32682D325631387A222F3E0D0A3C7061746820636C6173733D22426C756522
        20643D224D32302E312C31362E324332312E382C31342E352C32342C31312E36
        2C32342C38632D362C302D382C362D382C36732D322D362D382D3663302C332E
        362C322E322C362E352C332E392C382E324331302E382C31362E372C31302C31
        372E372C31302C313920202623393B63302C312E372C312E332C332C332C3373
        332D312E332C332D3363302C312E372C312E332C332C332C3373332D312E332C
        332D334332322C31372E372C32312E322C31362E372C32302E312C31362E327A
        222F3E0D0A3C2F7376673E0D0A}
      PaintStyle = bpsGlyph
      SpeedButtonOptions.GroupIndex = 1
      SpeedButtonOptions.AllowAllUp = True
      TabOrder = 13
    end
    object btnPresetControlTight: TcxButton [14]
      Left = 241
      Top = 55
      Width = 40
      Height = 40
      OptionsImage.Glyph.SourceDPI = 96
      OptionsImage.Glyph.Data = {
        3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
        462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D2254
        6578745772617054696768742220786D6C6E733D22687474703A2F2F7777772E
        77332E6F72672F323030302F7376672220786D6C6E733A786C696E6B3D226874
        74703A2F2F7777772E77332E6F72672F313939392F786C696E6B2220783D2230
        70782220793D22307078222076696577426F783D223020302033322033322220
        7374796C653D22656E61626C652D6261636B67726F756E643A6E657720302030
        2033322033323B2220786D6C3A73706163653D227072657365727665223E2623
        31333B262331303B3C7374796C6520747970653D22746578742F637373222078
        6D6C3A73706163653D227072657365727665223E2E426C61636B7B66696C6C3A
        233732373237323B7D262331333B262331303B2623393B2E426C75657B66696C
        6C3A233131373744373B7D3C2F7374796C653E0D0A3C7061746820636C617373
        3D22426C61636B2220643D224D33312C30483143302E352C302C302C302E352C
        302C3176323863302C302E352C302E352C312C312C3168333063302E352C302C
        312D302E352C312D3156314333322C302E352C33312E352C302C33312C307A20
        4D33302C3238483256326832385632387A20202623393B204D382C3232483476
        2D3268345632327A204D382C31364834763268345631367A204D362C38483476
        32683256387A204D342C3236683234762D3248345632367A204D362C31324834
        763268325631327A204D342C347632683234563448347A204D32342C32326834
        762D32682D345632327A204D32362C31306832563820202623393B682D325631
        307A204D32362C31346832762D32682D325631347A204D32342C31386834762D
        32682D345631387A222F3E0D0A3C7061746820636C6173733D22426C75652220
        643D224D32302E312C31362E324332312E382C31342E352C32342C31312E362C
        32342C38632D362C302D382C362D382C36732D322D362D382D3663302C332E36
        2C322E322C362E352C332E392C382E324331302E382C31362E372C31302C3137
        2E372C31302C313920202623393B63302C312E372C312E332C332C332C337333
        2D312E332C332D3363302C312E372C312E332C332C332C3373332D312E332C33
        2D334332322C31372E372C32312E322C31362E372C32302E312C31362E327A22
        2F3E0D0A3C2F7376673E0D0A}
      PaintStyle = bpsGlyph
      SpeedButtonOptions.GroupIndex = 1
      SpeedButtonOptions.AllowAllUp = True
      TabOrder = 14
    end
    object btnPresetControlThought: TcxButton [15]
      Left = 402
      Top = 55
      Width = 40
      Height = 40
      OptionsImage.Glyph.SourceDPI = 96
      OptionsImage.Glyph.Data = {
        3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
        462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D2254
        657874577261705468726F7567682220786D6C6E733D22687474703A2F2F7777
        772E77332E6F72672F323030302F7376672220786D6C6E733A786C696E6B3D22
        687474703A2F2F7777772E77332E6F72672F313939392F786C696E6B2220783D
        223070782220793D22307078222076696577426F783D22302030203332203332
        22207374796C653D22656E61626C652D6261636B67726F756E643A6E65772030
        20302033322033323B2220786D6C3A73706163653D227072657365727665223E
        262331333B262331303B3C7374796C6520747970653D22746578742F63737322
        20786D6C3A73706163653D227072657365727665223E2E426C61636B7B66696C
        6C3A233732373237323B7D262331333B262331303B2623393B2E426C75657B66
        696C6C3A233131373744373B7D3C2F7374796C653E0D0A3C7061746820636C61
        73733D22426C61636B2220643D224D362C36483456346832347632682D32682D
        32483848367A204D32362C31346832762D32682D325631347A204D32342C3138
        6834762D32682D345631387A204D31362C313063302E352D302E372C312E322D
        312E342C322D32682D3420202623393B4331342E382C382E362C31352E352C39
        2E332C31362C31307A204D32342C32326834762D32682D345632327A204D3236
        2C313068325638682D325631307A204D382C32304834763268345632307A204D
        32382C3234483476326832345632347A204D362C3848347632683256387A204D
        33322C3176323820202623393B63302C302E352D302E352C312D312C31483163
        2D302E352C302D312D302E352D312D31563163302D302E352C302E352D312C31
        2D316833304333312E352C302C33322C302E352C33322C317A204D33302C3248
        3276323668323856327A204D382C31364834763268345631367A204D362C3132
        4834763268325631327A222F3E0D0A3C7061746820636C6173733D22426C7565
        2220643D224D32302E312C31362E324332312E382C31342E352C32342C31312E
        362C32342C38632D362C302D382C362D382C36732D322D362D382D3663302C33
        2E362C322E322C362E352C332E392C382E324331302E382C31362E372C31302C
        31372E372C31302C313920202623393B63302C312E372C312E332C332C332C33
        73332D312E332C332D3363302C312E372C312E332C332C332C3373332D312E33
        2C332D334332322C31372E372C32312E322C31362E372C32302E312C31362E32
        7A222F3E0D0A3C2F7376673E0D0A}
      PaintStyle = bpsGlyph
      SpeedButtonOptions.GroupIndex = 1
      SpeedButtonOptions.AllowAllUp = True
      TabOrder = 15
    end
    object btnPresetControlTopAndBottom: TcxButton [16]
      Left = 79
      Top = 119
      Width = 40
      Height = 40
      OptionsImage.Glyph.SourceDPI = 96
      OptionsImage.Glyph.Data = {
        3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
        462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D2254
        65787457726170546F70416E64426F74746F6D2220786D6C6E733D2268747470
        3A2F2F7777772E77332E6F72672F323030302F7376672220786D6C6E733A786C
        696E6B3D22687474703A2F2F7777772E77332E6F72672F313939392F786C696E
        6B2220783D223070782220793D22307078222076696577426F783D2230203020
        333220333222207374796C653D22656E61626C652D6261636B67726F756E643A
        6E6577203020302033322033323B2220786D6C3A73706163653D227072657365
        727665223E262331333B262331303B3C7374796C6520747970653D2274657874
        2F6373732220786D6C3A73706163653D227072657365727665223E2E426C6163
        6B7B66696C6C3A233732373237323B7D262331333B262331303B2623393B2E42
        6C75657B66696C6C3A233131373744373B7D3C2F7374796C653E0D0A3C706174
        6820636C6173733D22426C61636B2220643D224D362C36483456346832347632
        682D32682D32483848367A204D32382C3234483476326832345632347A204D33
        322C3176323863302C302E352D302E352C312D312C314831632D302E352C302D
        312D302E352D312D31563163302D302E352C302E352D312C312D312020262339
        3B6833304333312E352C302C33322C302E352C33322C317A204D33302C324832
        76323668323856327A222F3E0D0A3C7061746820636C6173733D22426C756522
        20643D224D32302E312C31362E324332312E382C31342E352C32342C31312E36
        2C32342C38632D362C302D382C362D382C36732D322D362D382D3663302C332E
        362C322E322C362E352C332E392C382E324331302E382C31362E372C31302C31
        372E372C31302C313920202623393B63302C312E372C312E332C332C332C3373
        332D312E332C332D3363302C312E372C312E332C332C332C3373332D312E332C
        332D334332322C31372E372C32312E322C31362E372C32302E312C31362E327A
        222F3E0D0A3C2F7376673E0D0A}
      PaintStyle = bpsGlyph
      SpeedButtonOptions.GroupIndex = 1
      SpeedButtonOptions.AllowAllUp = True
      TabOrder = 16
    end
    object btnPresetControlBehind: TcxButton [17]
      Left = 241
      Top = 119
      Width = 40
      Height = 40
      OptionsImage.Glyph.SourceDPI = 96
      OptionsImage.Glyph.Data = {
        3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
        462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D2254
        65787457726170426568696E642220786D6C6E733D22687474703A2F2F777777
        2E77332E6F72672F323030302F7376672220786D6C6E733A786C696E6B3D2268
        7474703A2F2F7777772E77332E6F72672F313939392F786C696E6B2220783D22
        3070782220793D22307078222076696577426F783D2230203020333220333222
        207374796C653D22656E61626C652D6261636B67726F756E643A6E6577203020
        302033322033323B2220786D6C3A73706163653D227072657365727665223E26
        2331333B262331303B3C7374796C6520747970653D22746578742F6373732220
        786D6C3A73706163653D227072657365727665223E2E426C61636B7B66696C6C
        3A233732373237323B7D262331333B262331303B2623393B2E426C75657B6669
        6C6C3A233131373744373B7D262331333B262331303B2623393B2E7374307B6F
        7061636974793A302E353B7D3C2F7374796C653E0D0A3C6720636C6173733D22
        737430223E0D0A09093C7061746820636C6173733D22426C75652220643D224D
        32302E312C31362E324332312E382C31342E352C32342C31312E362C32342C38
        632D362C302D382C362D382C36732D322D362D382D3663302C332E362C322E32
        2C362E352C332E392C382E324331302E382C31362E372C31302C31372E372C31
        302C313920202623393B2623393B63302C312E372C312E332C332C332C337333
        2D312E332C332D3363302C312E372C312E332C332C332C3373332D312E332C33
        2D334332322C31372E372C32312E322C31362E372C32302E312C31362E327A22
        2F3E0D0A093C2F673E0D0A3C7061746820636C6173733D22426C61636B222064
        3D224D342C365634683234763248347A204D32382C3130563848347632483238
        7A204D32382C3134762D32483476324832387A204D32382C3138762D32483476
        324832387A204D32382C3232762D32483476324832387A204D32382C32344834
        76326832345632347A20202623393B204D33322C3176323863302C302E352D30
        2E352C312D312C314831632D302E352C302D312D302E352D312D31563163302D
        302E352C302E352D312C312D316833304333312E352C302C33322C302E352C33
        322C317A204D33302C32483276323668323856327A222F3E0D0A3C2F7376673E
        0D0A}
      PaintStyle = bpsGlyph
      SpeedButtonOptions.GroupIndex = 1
      SpeedButtonOptions.AllowAllUp = True
      TabOrder = 17
    end
    object btnPresetControlInFrontOf: TcxButton [18]
      Left = 402
      Top = 119
      Width = 40
      Height = 40
      OptionsImage.Glyph.SourceDPI = 96
      OptionsImage.Glyph.Data = {
        3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
        462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D2254
        65787457726170496E46726F6E744F66546578742220786D6C6E733D22687474
        703A2F2F7777772E77332E6F72672F323030302F7376672220786D6C6E733A78
        6C696E6B3D22687474703A2F2F7777772E77332E6F72672F313939392F786C69
        6E6B2220783D223070782220793D22307078222076696577426F783D22302030
        20333220333222207374796C653D22656E61626C652D6261636B67726F756E64
        3A6E6577203020302033322033323B2220786D6C3A73706163653D2270726573
        65727665223E262331333B262331303B3C7374796C6520747970653D22746578
        742F6373732220786D6C3A73706163653D227072657365727665223E2E426C61
        636B7B66696C6C3A233732373237323B7D262331333B262331303B2623393B2E
        426C75657B66696C6C3A233131373744373B7D262331333B262331303B262339
        3B2E7374307B6F7061636974793A302E353B7D3C2F7374796C653E0D0A3C7061
        746820636C6173733D22426C61636B2220643D224D33322C3176323863302C30
        2E352D302E352C312D312C314831632D302E352C302D312D302E352D312D3156
        3163302D302E352C302E352D312C312D316833304333312E352C302C33322C30
        2E352C33322C317A204D33302C32483276323668323856327A222F3E0D0A3C67
        20636C6173733D22737430223E0D0A09093C7061746820636C6173733D22426C
        61636B2220643D224D342C365634683234763248347A204D32382C3130563848
        3476324832387A204D32382C3134762D32483476324832387A204D32382C3138
        762D32483476324832387A204D32382C3232762D32483476324832387A204D32
        382C3234483476326832345632347A222F3E0D0A093C2F673E0D0A3C70617468
        20636C6173733D22426C75652220643D224D32302E312C31362E324332312E38
        2C31342E352C32342C31312E362C32342C38632D362C302D382C362D382C3673
        2D322D362D382D3663302C332E362C322E322C362E352C332E392C382E324331
        302E382C31362E372C31302C31372E372C31302C313920202623393B63302C31
        2E372C312E332C332C332C3373332D312E332C332D3363302C312E372C312E33
        2C332C332C3373332D312E332C332D334332322C31372E372C32312E322C3136
        2E372C32302E312C31362E327A222F3E0D0A3C2F7376673E0D0A}
      PaintStyle = bpsGlyph
      SpeedButtonOptions.GroupIndex = 1
      SpeedButtonOptions.AllowAllUp = True
      TabOrder = 18
    end
    object rgTextWrapSideBothSides: TcxRadioButton [19]
      Left = 30
      Top = 203
      Caption = 'Both &sides'
      Color = 16448250
      ParentColor = False
      TabOrder = 19
      OnClick = rgTextWrapSideClick
      AutoSize = True
      ParentBackground = False
      Transparent = True
    end
    object rbTextWrapSideLeftOnly: TcxRadioButton [20]
      Tag = 1
      Left = 149
      Top = 203
      Caption = '&Left only'
      Color = 16448250
      ParentColor = False
      TabOrder = 20
      OnClick = rgTextWrapSideClick
      AutoSize = True
      ParentBackground = False
      Transparent = True
    end
    object rbTextWrapSideRightOnly: TcxRadioButton [21]
      Tag = 2
      Left = 268
      Top = 203
      Caption = '&Right only'
      Color = 16448250
      ParentColor = False
      TabOrder = 21
      OnClick = rgTextWrapSideClick
      AutoSize = True
      ParentBackground = False
      Transparent = True
    end
    object rbTextWrapSideLargestOnly: TcxRadioButton [22]
      Tag = 3
      Left = 387
      Top = 203
      Caption = 'L&argest only'
      Color = 16448250
      ParentColor = False
      TabOrder = 22
      OnClick = rgTextWrapSideClick
      AutoSize = True
      ParentBackground = False
      Transparent = True
    end
    object seTop: TdxMeasurementUnitEdit [23]
      Left = 69
      Top = 251
      TabOrder = 23
      Width = 87
    end
    object seBottom: TdxMeasurementUnitEdit [24]
      Left = 69
      Top = 282
      TabOrder = 24
      Width = 87
    end
    object seLeft: TdxMeasurementUnitEdit [25]
      Left = 307
      Top = 251
      TabOrder = 25
      Width = 87
    end
    object seRight: TdxMeasurementUnitEdit [26]
      Left = 307
      Top = 282
      TabOrder = 26
      Width = 87
    end
    object seHeightAbs: TdxMeasurementUnitEdit [27]
      Left = 10000
      Top = 9987
      TabOrder = 27
      Width = 87
    end
    object seWidthAbs: TdxMeasurementUnitEdit [28]
      Left = 10000
      Top = 9987
      TabOrder = 28
      Width = 87
    end
    object seRotation: TdxMeasurementUnitEdit [29]
      Left = 10000
      Top = 9987
      TabOrder = 29
      Width = 87
    end
    object cbLockAspectRatio: TcxCheckBox [30]
      Left = 10000
      Top = 9987
      Caption = 'Lock &aspect ratio'
      Style.HotTrack = False
      TabOrder = 30
      Transparent = True
      Visible = False
    end
    object lblOriginalSizeWidthValue: TcxLabel [31]
      Left = 10000
      Top = 9987
      Style.HotTrack = False
      Transparent = True
      Visible = False
      Height = 18
      Width = 87
    end
    object lblOriginalSizeHeightValue: TcxLabel [32]
      Left = 10000
      Top = 9987
      Style.HotTrack = False
      Transparent = True
      Visible = False
      Height = 18
      Width = 87
    end
    object btnReset: TcxButton [33]
      Left = 10000
      Top = 9987
      Width = 75
      Height = 25
      Caption = 'Re&set'
      TabOrder = 33
      Visible = False
      OnClick = btnResetClick
    end
    object btnOk: TcxButton [34]
      Left = 356
      Top = 325
      Width = 75
      Height = 25
      Caption = 'Ok'
      Default = True
      ModalResult = 1
      TabOrder = 34
    end
    object btnCancel: TcxButton [35]
      Left = 437
      Top = 325
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 35
    end
    inherited dxLayoutControl1Group_Root: TdxLayoutGroup
      CaptionOptions.Visible = False
    end
    object lcgTabControl: TdxLayoutGroup
      Parent = dxLayoutControl1Group_Root
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      ItemIndex = 1
      LayoutDirection = ldTabbed
      ShowBorder = False
      Index = 0
    end
    object lcgTabPagePosition: TdxLayoutGroup
      Parent = lcgTabControl
      CaptionOptions.Text = 'Position'
      ItemIndex = 1
      Index = 0
    end
    object lcgTabPageTextWrapping: TdxLayoutGroup
      Parent = lcgTabControl
      CaptionOptions.Text = 'Text Wrapping'
      ItemIndex = 2
      Index = 1
    end
    object lcgTabPageSize: TdxLayoutGroup
      Parent = lcgTabControl
      CaptionOptions.Text = 'Size'
      ItemIndex = 9
      Index = 2
    end
    object lblHorizontal: TdxLayoutSeparatorItem
      Parent = lcgTabPagePosition
      AlignHorz = ahClient
      CaptionOptions.Text = 'Horizontal'
      CaptionOptions.Visible = True
      Index = 0
    end
    object lciVertical: TdxLayoutSeparatorItem
      Parent = lcgTabPagePosition
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'Vertical'
      CaptionOptions.Visible = True
      Index = 3
    end
    object lgHorizontalGroup: TdxLayoutGroup
      Parent = lcgTabPagePosition
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      Offsets.Left = 8
      ShowBorder = False
      Index = 2
    end
    object dxLayoutItem1: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup12
      AlignHorz = ahLeft
      AlignVert = avClient
      CaptionOptions.Text = 'cxRadioButton1'
      CaptionOptions.Visible = False
      Control = rbHorizontalAbsolutePositionItem
      ControlOptions.AlignHorz = ahLeft
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 114
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem2: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup12
      AlignHorz = ahLeft
      AlignVert = avClient
      CaptionOptions.Text = 'cxRadioButton2'
      CaptionOptions.Visible = False
      Control = rbHorizontalAlignmentItem
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 79
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem3: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup1
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Text = 'cxComboBox1'
      CaptionOptions.Visible = False
      Control = cmbHorizontalAlignment
      ControlOptions.AlignHorz = ahLeft
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lblHorizontalPositionType: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup2
      CaptionOptions.Text = '&relative to'
      Control = cmbHorizontalPositionType
      ControlOptions.AlignHorz = ahLeft
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem4: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup1
      CaptionOptions.Text = 'dxMeasurementUnitEdit1'
      CaptionOptions.Visible = False
      Control = seHorizontalAbsolutePosition
      ControlOptions.AlignHorz = ahLeft
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lciHorizontalAbsolutePosition: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup2
      AlignVert = avBottom
      CaptionOptions.Text = '&to the right of'
      Control = cmbHorizontalAbsolutePositionRightOf
      ControlOptions.AlignHorz = ahLeft
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lciOptions: TdxLayoutSeparatorItem
      Parent = lcgTabPagePosition
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'Options'
      CaptionOptions.Visible = True
      Index = 5
    end
    object dxLayoutGroup2: TdxLayoutGroup
      Parent = lcgTabPagePosition
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      ItemIndex = 1
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 4
    end
    object dxLayoutItem7: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup3
      AlignHorz = ahLeft
      AlignVert = avClient
      CaptionOptions.Text = 'cxRadioButton2'
      CaptionOptions.Visible = False
      Control = rbVerticalAbsolutePositionItem
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 114
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem9: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup4
      CaptionOptions.Text = 'dxMeasurementUnitEdit1'
      CaptionOptions.Visible = False
      Control = seVerticalAbsolutePosition
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lciVerticalAbsolutePosition: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup13
      CaptionOptions.Text = 'belo&w'
      Control = cmbVerticalAbsolutePositionBelow
      ControlOptions.AlignHorz = ahRight
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem5: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup3
      AlignHorz = ahLeft
      AlignVert = avClient
      CaptionOptions.Text = 'cxRadioButton1'
      CaptionOptions.Visible = False
      Control = rbVerticalAlignmentItem
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 79
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem8: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup4
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Text = 'cxComboBox1'
      CaptionOptions.Visible = False
      Control = cmbVerticalAlignment
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lciVerticalPositionType: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup13
      AlignHorz = ahLeft
      AlignVert = avClient
      CaptionOptions.Text = 'r&elative to'
      Control = cmbVerticalPositionType
      ControlOptions.AlignHorz = ahRight
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem10: TdxLayoutItem
      Parent = lcgTabPagePosition
      CaptionOptions.Text = 'cxCheckBox1'
      CaptionOptions.Visible = False
      Control = cbLock
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 6
    end
    object lciWrappingStyle: TdxLayoutSeparatorItem
      Parent = lcgTabPageTextWrapping
      AlignVert = avTop
      CaptionOptions.Text = 'Text Wrapping'
      CaptionOptions.Visible = True
      Index = 0
    end
    object lciPresetControlSquare: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup5
      AlignHorz = ahClient
      SizeOptions.Width = 100
      CaptionOptions.AlignHorz = taCenter
      CaptionOptions.Text = 'S&quare'
      CaptionOptions.Layout = clBottom
      Control = btnPresetControlSquare
      ControlOptions.AlignHorz = ahCenter
      ControlOptions.OriginalHeight = 40
      ControlOptions.OriginalWidth = 40
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lciPresetControlTight: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup5
      AlignHorz = ahClient
      AlignVert = avClient
      SizeOptions.Width = 100
      CaptionOptions.AlignHorz = taCenter
      CaptionOptions.Text = '&Tight'
      CaptionOptions.Layout = clBottom
      Control = btnPresetControlTight
      ControlOptions.AlignHorz = ahCenter
      ControlOptions.OriginalHeight = 40
      ControlOptions.OriginalWidth = 40
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup5: TdxLayoutAutoCreatedGroup
      Parent = lcgTabPageTextWrapping
      LayoutDirection = ldHorizontal
      Index = 1
    end
    object lciPresetControlThought: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup5
      AlignHorz = ahClient
      AlignVert = avClient
      SizeOptions.Width = 100
      CaptionOptions.AlignHorz = taCenter
      CaptionOptions.Text = 'T&hrough'
      CaptionOptions.Layout = clBottom
      Control = btnPresetControlThought
      ControlOptions.AlignHorz = ahCenter
      ControlOptions.OriginalHeight = 40
      ControlOptions.OriginalWidth = 40
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object lciPresetControlTopAndBottom: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup6
      AlignHorz = ahClient
      AlignVert = avClient
      SizeOptions.Width = 100
      CaptionOptions.AlignHorz = taCenter
      CaptionOptions.Text = 'T&op and bottom'
      CaptionOptions.Layout = clBottom
      Control = btnPresetControlTopAndBottom
      ControlOptions.AlignHorz = ahCenter
      ControlOptions.OriginalHeight = 40
      ControlOptions.OriginalWidth = 40
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lciPresetControlBehind: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup6
      AlignHorz = ahClient
      AlignVert = avClient
      SizeOptions.Width = 100
      CaptionOptions.AlignHorz = taCenter
      CaptionOptions.Text = '&Behind text'
      CaptionOptions.Layout = clBottom
      Control = btnPresetControlBehind
      ControlOptions.AlignHorz = ahCenter
      ControlOptions.OriginalHeight = 40
      ControlOptions.OriginalWidth = 40
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup6: TdxLayoutAutoCreatedGroup
      Parent = lcgTabPageTextWrapping
      LayoutDirection = ldHorizontal
      Index = 2
    end
    object lciPresetControlInFrontOf: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup6
      AlignHorz = ahClient
      AlignVert = avClient
      SizeOptions.Width = 100
      CaptionOptions.AlignHorz = taCenter
      CaptionOptions.Text = 'In &front of text'
      CaptionOptions.Layout = clBottom
      Control = btnPresetControlInFrontOf
      ControlOptions.AlignHorz = ahCenter
      ControlOptions.OriginalHeight = 40
      ControlOptions.OriginalWidth = 40
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object lciWrapText: TdxLayoutSeparatorItem
      Parent = lcgTabPageTextWrapping
      AlignVert = avTop
      CaptionOptions.Text = 'Wrap text'
      CaptionOptions.Visible = True
      Index = 3
    end
    object lciDistance: TdxLayoutSeparatorItem
      Parent = lcgTabPageTextWrapping
      CaptionOptions.Text = 'Distance from text'
      CaptionOptions.Visible = True
      Index = 5
    end
    object lgTextWrapSide: TdxLayoutAutoCreatedGroup
      Parent = lcgTabPageTextWrapping
      LayoutDirection = ldHorizontal
      Index = 4
    end
    object dxLayoutItem11: TdxLayoutItem
      Parent = lgTextWrapSide
      AlignHorz = ahClient
      Offsets.Left = 8
      CaptionOptions.Text = 'cxRadioButton1'
      CaptionOptions.Visible = False
      Control = rgTextWrapSideBothSides
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 113
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lciTextWrapSideLeftOnly: TdxLayoutItem
      Parent = lgTextWrapSide
      AlignHorz = ahClient
      CaptionOptions.Text = 'cxRadioButton2'
      CaptionOptions.Visible = False
      Control = rbTextWrapSideLeftOnly
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 113
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lciTextWrapSideRightOnly: TdxLayoutItem
      Parent = lgTextWrapSide
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'cxRadioButton3'
      CaptionOptions.Visible = False
      Control = rbTextWrapSideRightOnly
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 113
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object lciTextWrapSideLargestOnly: TdxLayoutItem
      Parent = lgTextWrapSide
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'cxRadioButton4'
      CaptionOptions.Visible = False
      Control = rbTextWrapSideLargestOnly
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 113
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object dxLayoutGroup3: TdxLayoutGroup
      Parent = lcgTabPageTextWrapping
      CaptionOptions.Text = 'New Group'
      Offsets.Left = 8
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 6
    end
    object lciTop: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup8
      AlignVert = avTop
      CaptionOptions.Text = 'To&p'
      Control = seTop
      ControlOptions.AlignHorz = ahLeft
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 87
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lciBottom: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup8
      AlignVert = avTop
      CaptionOptions.Text = 'Botto&m'
      Control = seBottom
      ControlOptions.AlignHorz = ahLeft
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 87
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup8: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutGroup3
      AlignHorz = ahClient
      Index = 0
    end
    object lciLeft: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup9
      CaptionOptions.Text = 'L&eft'
      Control = seLeft
      ControlOptions.AlignHorz = ahLeft
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 87
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lciRight: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup9
      CaptionOptions.Text = 'Ri&ght'
      Control = seRight
      ControlOptions.AlignHorz = ahLeft
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 87
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup9: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutGroup3
      AlignHorz = ahClient
      Index = 1
    end
    object lciHeight: TdxLayoutSeparatorItem
      Parent = lcgTabPageSize
      AlignVert = avTop
      CaptionOptions.Text = 'Height'
      CaptionOptions.Visible = True
      Index = 0
    end
    object lciHeightAbsolute: TdxLayoutItem
      Parent = lcgTabPageSize
      Offsets.Left = 8
      CaptionOptions.Text = 'Absolut&e:'
      CaptionOptions.Width = 60
      Control = seHeightAbs
      ControlOptions.AlignHorz = ahLeft
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 87
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lciWidth: TdxLayoutSeparatorItem
      Parent = lcgTabPageSize
      CaptionOptions.Text = 'Width'
      CaptionOptions.Visible = True
      Index = 2
    end
    object lciWidthAbsolute: TdxLayoutItem
      Parent = lcgTabPageSize
      Offsets.Left = 8
      CaptionOptions.Text = 'A&bsolute:'
      Control = seWidthAbs
      ControlOptions.AlignHorz = ahLeft
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 87
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object lciRotate: TdxLayoutSeparatorItem
      Parent = lcgTabPageSize
      CaptionOptions.Text = 'Rotate'
      CaptionOptions.Visible = True
      Index = 4
    end
    object lciRotation: TdxLayoutItem
      Parent = lcgTabPageSize
      Offsets.Left = 8
      CaptionOptions.Text = 'Ro&tation:'
      Control = seRotation
      ControlOptions.AlignHorz = ahLeft
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 87
      ControlOptions.ShowBorder = False
      Index = 5
    end
    object lciScale: TdxLayoutSeparatorItem
      Parent = lcgTabPageSize
      CaptionOptions.Text = 'Scale'
      CaptionOptions.Visible = True
      Index = 6
    end
    object dxLayoutItem12: TdxLayoutItem
      Parent = lcgTabPageSize
      Offsets.Left = 4
      CaptionOptions.Text = 'cxCheckBox1'
      CaptionOptions.Visible = False
      Control = cbLockAspectRatio
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 7
    end
    object lciOriginalSize: TdxLayoutSeparatorItem
      Parent = lcgTabPageSize
      AlignVert = avTop
      CaptionOptions.Text = 'Original size'
      CaptionOptions.Visible = True
      Index = 8
    end
    object lblOriginalSizeWidth: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup10
      AlignVert = avCenter
      SizeOptions.Width = 120
      CaptionOptions.Text = 'Width:'
      Control = lblOriginalSizeWidthValue
      ControlOptions.AlignHorz = ahLeft
      ControlOptions.AlignVert = avCenter
      ControlOptions.OriginalHeight = 18
      ControlOptions.OriginalWidth = 87
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup10: TdxLayoutAutoCreatedGroup
      Parent = lcgTabPageSize
      LayoutDirection = ldHorizontal
      Index = 9
    end
    object lciOriginalSizeHeight: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup10
      AlignHorz = ahLeft
      AlignVert = avCenter
      Offsets.Left = 8
      SizeOptions.Width = 120
      CaptionOptions.Text = 'Height:'
      Control = lblOriginalSizeHeightValue
      ControlOptions.AlignHorz = ahLeft
      ControlOptions.AlignVert = avCenter
      ControlOptions.OriginalHeight = 18
      ControlOptions.OriginalWidth = 87
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem15: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup10
      AlignHorz = ahRight
      AlignVert = avClient
      CaptionOptions.Text = 'cxButton1'
      CaptionOptions.Visible = False
      Control = btnReset
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutItem13: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup11
      AlignHorz = ahClient
      CaptionOptions.Text = 'cxButton1'
      CaptionOptions.Visible = False
      Control = btnOk
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem14: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup11
      AlignVert = avClient
      CaptionOptions.Text = 'cxButton2'
      CaptionOptions.Visible = False
      Control = btnCancel
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup11: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutControl1Group_Root
      AlignHorz = ahRight
      LayoutDirection = ldHorizontal
      Index = 1
    end
    object dxLayoutGroup1: TdxLayoutGroup
      Parent = dxLayoutGroup5
      AlignHorz = ahLeft
      AlignVert = avClient
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      ItemIndex = 1
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutGroup1
      AlignHorz = ahLeft
      Index = 0
    end
    object dxLayoutAutoCreatedGroup2: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutGroup1
      Index = 1
    end
    object dxLayoutAutoCreatedGroup12: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutGroup5
      AlignHorz = ahLeft
      AlignVert = avClient
      Index = 0
    end
    object dxLayoutGroup4: TdxLayoutGroup
      Parent = dxLayoutGroup2
      AlignHorz = ahLeft
      AlignVert = avClient
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      ItemIndex = 1
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup4: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutGroup4
      AlignHorz = ahLeft
      Index = 0
    end
    object dxLayoutAutoCreatedGroup13: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutGroup4
      AlignHorz = ahLeft
      Index = 1
    end
    object dxLayoutAutoCreatedGroup3: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutGroup2
      AlignHorz = ahLeft
      Index = 0
    end
    object dxLayoutGroup5: TdxLayoutGroup
      Parent = lcgTabPagePosition
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      ItemIndex = 1
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 1
    end
  end
  inherited dxLayoutLookAndFeelList1: TdxLayoutLookAndFeelList
    inherited dxLayoutCxLookAndFeel1: TdxLayoutCxLookAndFeel
      PixelsPerInch = 96
    end
  end
end
