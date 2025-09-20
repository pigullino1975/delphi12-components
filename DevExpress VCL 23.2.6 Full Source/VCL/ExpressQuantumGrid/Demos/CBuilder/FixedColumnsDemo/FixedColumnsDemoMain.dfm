inherited frmMain: TfrmMain
  Left = 401
  Top = 185
  Caption = 'ExpressQuantumGrid Fixed Columns Demo'
  ClientHeight = 671
  ClientWidth = 1014
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  inherited lbDescription: TLabel
    Width = 1014
    Height = 48
    Caption = 
      'This demo illustrates how to anchor columns to the left or right' +
      ' border of the Table View. Scroll the View horizontally to see h' +
      'ow highlighted columns stick to the left border, one by one. You' +
      ' can right-click a column header to invoke a pop-up menu with an' +
      'chor options available for the column. Use the pane to the right' +
      ' of the Table View to customize column anchor settings.'
  end
  inherited sbMain: TStatusBar
    Top = 652
    Width = 1014
  end
  object Grid: TcxGrid [2]
    Left = 0
    Top = 48
    Width = 778
    Height = 604
    Align = alClient
    TabOrder = 1
    object tvTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      FindPanel.Behavior = fcbSearch
      FindPanel.DisplayMode = fpdmManual
      FindPanel.Location = fplGroupByBox
      ScrollbarAnnotations.CustomAnnotations = <>
      DataController.DataSource = dsCustomers
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      Images = ilImages
      OptionsView.FixedColumnSeparatorWidth = 1
      OptionsView.HighlightFixedColumns = True
      OptionsView.Indicator = True
      object tvTableViewCompanyName: TcxGridDBColumn
        Caption = 'Company Name'
        DataBinding.FieldName = 'CompanyName'
        FixedKind = fkLeft
        HeaderImageIndex = 2
        Width = 230
      end
      object tvTableViewContactTitle: TcxGridDBColumn
        Caption = 'Contact Title'
        DataBinding.FieldName = 'ContactTitle'
        Visible = False
        GroupIndex = 0
        HeaderImageIndex = 12
        Width = 156
      end
      object tvTableViewContactName: TcxGridDBColumn
        Caption = 'Contact Name'
        DataBinding.FieldName = 'ContactName'
        HeaderImageIndex = 0
        Width = 148
      end
      object tvTableViewRegion: TcxGridDBColumn
        DataBinding.FieldName = 'Region'
        HeaderImageIndex = 10
        Width = 101
      end
      object tvTableViewCountry: TcxGridDBColumn
        DataBinding.FieldName = 'Country'
        FixedKind = fkLeftDynamic
        HeaderImageIndex = 7
        Width = 93
      end
      object tvTableViewCity: TcxGridDBColumn
        DataBinding.FieldName = 'City'
        HeaderImageIndex = 6
        Width = 107
      end
      object tvTableViewAddress: TcxGridDBColumn
        DataBinding.FieldName = 'Address'
        FixedKind = fkLeftDynamic
        HeaderImageIndex = 1
        Width = 264
      end
      object tvTableViewPostalCode: TcxGridDBColumn
        Caption = 'Postal Code'
        DataBinding.FieldName = 'PostalCode'
        HeaderImageIndex = 9
        Width = 116
      end
      object tvTableViewPhone: TcxGridDBColumn
        DataBinding.FieldName = 'Phone'
        HeaderImageIndex = 11
      end
      object tvTableViewFax: TcxGridDBColumn
        DataBinding.FieldName = 'Fax'
        HeaderImageIndex = 8
        Width = 114
      end
    end
    object lvlLevel: TcxGridLevel
      GridView = tvTableView
    end
  end
  object gbOptions: TcxGroupBox [3]
    Left = 778
    Top = 48
    Align = alRight
    PanelStyle.Active = True
    Style.BorderStyle = ebsSingle
    TabOrder = 2
    Height = 604
    Width = 236
    object pbFixedColumnOverlayColor: TPaintBox
      Left = 9
      Top = 193
      Width = 220
      Height = 19
      OnClick = pbFixedColumnOverlayColorClick
      OnPaint = pbFixedColumnOverlayColorPaint
    end
    object btnResetFixedColumnHightlightColor: TcxButton
      Tag = 1
      Left = 210
      Top = 193
      Width = 19
      Height = 19
      Hint = 'Reset'
      OptionsImage.ImageIndex = 13
      OptionsImage.Images = ilImages
      OptionsImage.Layout = blGlyphRight
      ParentShowHint = False
      ShowHint = True
      SpeedButtonOptions.CanBeFocused = False
      TabOrder = 0
      Visible = False
      OnClick = btnResetFixedColumnHightlightColorClick
    end
    object seFixedSeparatorWidth: TcxSpinEdit
      Left = 9
      Top = 126
      Properties.AssignedValues.MinValue = True
      Properties.ImmediatePost = True
      Properties.MaxValue = 4.000000000000000000
      Properties.OnEditValueChanged = seFixedSeparatorWidthPropertiesEditValueChanged
      TabOrder = 1
      Value = 1
      Width = 220
    end
    object cbFixStyle: TcxImageComboBox
      Left = 9
      Top = 78
      Properties.Images = ilImages
      Properties.Items = <
        item
          Description = 'Not Fixed'
          ImageIndex = 3
          Value = 0
        end
        item
          Description = 'Fixed Left'
          ImageIndex = 4
          Value = 1
        end
        item
          Description = 'Fixed Right'
          ImageIndex = 5
          Value = 2
        end
        item
          Description = 'Fixed Left (Dynamic)'
          ImageIndex = 4
          Value = 3
        end>
      Properties.OnEditValueChanged = cbFixStylePropertiesEditValueChanged
      TabOrder = 2
      Width = 220
    end
    object cbColumn: TcxImageComboBox
      Left = 9
      Top = 30
      Properties.Images = ilImages
      Properties.Items = <>
      Properties.OnEditValueChanged = cbColumnPropertiesEditValueChanged
      TabOrder = 3
      Width = 220
    end
    object lblColumns: TcxLabel
      Left = 9
      Top = 7
      Caption = 'Column:'
      Transparent = True
    end
    object lblFixStyle: TcxLabel
      Left = 9
      Top = 55
      Caption = 'Fix Style:'
      Transparent = True
    end
    object lblFixedSeparatorWidth: TcxLabel
      Left = 9
      Top = 103
      Caption = 'Fixed Separator Width:'
      Transparent = True
    end
    object cbHighlightFixedColumns: TcxCheckBox
      Left = 9
      Top = 152
      Caption = 'Highlight Fixed Columns'
      Properties.OnEditValueChanged = cbHighlightFixedColumnsPropertiesEditValueChanged
      State = cbsChecked
      Style.TransparentBorder = False
      TabOrder = 7
      Transparent = True
    end
    object lblFixedColumnHighlightColor: TcxLabel
      Left = 9
      Top = 171
      Caption = 'Highlight Color:'
      Transparent = True
    end
  end
  inherited mmMain: TMainMenu
    Left = 172
    Top = 176
  end
  inherited StyleRepository: TcxStyleRepository
    Top = 176
    PixelsPerInch = 96
    inherited GridTableViewStyleSheetDevExpress: TcxGridTableViewStyleSheet
      BuiltIn = True
    end
    inherited GridCardViewStyleSheetDevExpress: TcxGridCardViewStyleSheet
      BuiltIn = True
    end
  end
  inherited cxLookAndFeelController1: TcxLookAndFeelController
    Left = 104
    Top = 176
  end
  object dsCustomers: TDataSource
    DataSet = cdsCustomers
    Left = 240
    Top = 176
  end
  object cdsCustomers: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 312
    Top = 176
    object cdsCustomersCompanyName: TStringField
      FieldName = 'CompanyName'
      Size = 36
    end
    object cdsCustomersContactName: TStringField
      FieldName = 'ContactName'
      Size = 23
    end
    object cdsCustomersContactTitle: TStringField
      FieldName = 'ContactTitle'
      Size = 30
    end
    object cdsCustomersAddress: TStringField
      FieldName = 'Address'
      Size = 46
    end
    object cdsCustomersCity: TStringField
      FieldName = 'City'
      Size = 15
    end
    object cdsCustomersPostalCode: TStringField
      FieldName = 'PostalCode'
      Size = 9
    end
    object cdsCustomersCountry: TStringField
      FieldName = 'Country'
      Size = 11
    end
    object cdsCustomersPhone: TStringField
      FieldName = 'Phone'
      Size = 17
    end
    object cdsCustomersFax: TStringField
      FieldName = 'Fax'
      Size = 17
    end
    object cdsCustomersRegion: TStringField
      FieldName = 'Region'
      Size = 13
    end
  end
  object ilImages: TcxImageList
    SourceDPI = 96
    FormatVersion = 1
    DesignInfo = 11534720
    ImageInfo = <
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          61000000017352474200AECE1CE90000000467414D410000B18F0BFC61050000
          00097048597300000EC300000EC301C76FA864000000A049444154384FDD8F3D
          0A02410C85074F646165E199E6AF9FC26E4B0F63E98D4416110B8B31092F9091
          08BBA57EF098E4252FEC863F21E77C25F5959A1197031DE562868C6DA83EA694
          EEF44EB05CBE1E40B8D3FB8225732BF564C8D886EA89C3A4132C17F740AD755B
          4A39B4D636E4ED638C3B9D5BA9C7AF60CCB32E41175970E039CAE1C00D4111FD
          C653161C34230CCD423E0FCC6CAC117DDD03F1DF2684371393AA689C24F61F00
          00000049454E44AE426082}
      end
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          61000000017352474200AECE1CE90000000467414D410000B18F0BFC61050000
          00097048597300000EC300000EC301C76FA864000000A549444154384F63A019
          A8AFAFE7292A2A9A07C48B727373F9A0C2C481E2E26253A0C65B40FC1F8AEFE6
          E7E75B42A57183D0D050E6C2C2C24AA0865F489AC11828FE1B88EB406AA0CA51
          0150912C101F40D6840D030D390C748D02541B040025428112EFD015E3C240B5
          1F807424543B1501BA4DB830543926C0A6181B862AC704D81463C350E598009B
          626C18AA1C13E052884B1C03E052884B1C03E052884B7C30000606004473F4A3
          FCDD63560000000049454E44AE426082}
      end
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          61000000017352474200AECE1CE90000000467414D410000B18F0BFC61050000
          00097048597300000EC300000EC301C76FA8640000008F49444154384F6318BC
          202F2F4FB5A8A868436161E196D2D25275A83061909F9F2F00D4D803D4F81348
          FF87E25F40DC5F51512108558609424343990B0A0A32800A5F216944C14043DF
          00E9ECFAFA7A16A83608000A3A03F125984222F0152076876AA73280D9828F8D
          17E0D284CCC60B70694266E305B83421B369036036108BA1DA10009B227C18AA
          6DC00103030015FDBE29C26D3DD40000000049454E44AE426082}
      end
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          61000000017352474200AECE1CE90000000467414D410000B18F0BFC61050000
          00097048597300000EC300000EC301C76FA8640000004149444154384F63181C
          A0A8A8E83F3918AA7D58184031009A568F8C491103036C12C48A8101360962C5
          A803B0994CAC1818609320560C0CB049102B36D0808101000E060690B5DC4D96
          0000000049454E44AE426082}
      end
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          61000000017352474200AECE1CE90000000467414D410000B18F0BFC61050000
          00097048597300000EC300000EC301C76FA8640000003649444154384F63181C
          A0A8A8E83F3918AA7D581840311028BB568F8C4162401BEA91312E3130187803
          280614BB60E00D1840C0C00000D0160720A70A928E0000000049454E44AE4260
          82}
      end
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          61000000017352474200AECE1CE90000000467414D410000B18F0BFC61050000
          00097048597300000EC300000EC301C76FA8640000004349444154384F63181C
          A0A8A8E83F3918AA7D58184031009A568F8C718909945DAB47C6203130C0A618
          9B18ED0CA01860B30D9B184E1760538C4D8C76060C2060600000B996072007FA
          E4CD0000000049454E44AE426082}
      end
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          61000000017352474200AECE1CE90000000467414D410000B18F0BFC61050000
          00097048597300000EC300000EC301C76FA8640000006149444154384FCD8D41
          0A003108037DB3FF872DCA066250E9B103213035D4DEC1DD3FCDFF740706DAD7
          E057CEE423396220B75657E806DAEA0A38E04C3E922306726B75856EA0ADAE80
          03CEE423396220B75657E806DAEA0A38E04C3E92A307303B0E07DB37DC585131
          0000000049454E44AE426082}
      end
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          61000000017352474200AECE1CE90000000467414D410000B18F0BFC61050000
          00097048597300000EC300000EC301C76FA8640000016749444154384FAD933F
          4BC35014C5DFE026B8082AA283939BCE6E0E8E4E0E8A28F40384A6499B049C42
          5107A5B8A89BA37E02F113E8AE4E2DB83AFB2F6E6DA3BFFBB8D1975A27BD70B8
          79E7DC7392F792987FAF46A33151AFD79B6118DED233FA3BFD1E7E3F8EE3691D
          1B5E0CAD31FC088EC1AAC0F3BC71FA1DF8202CA36FE978B9D4FCC05DE695B205
          5FC1984B8086C87539441FFB99BEAC94AD200856E07B85D9419624C98C8E1903
          D154E146C2AAD5EA18775A647DA5FC301CAADD1886E5C0ACC0F525D80172806F
          8EA104B4B6DA6D809CB42B5E83739083BEAB39333DB5FF0CD0812EDB39F17D7F
          92F5E910FD3B00C2BEA6417088EBA21334CAFA08D393A377AC590A61CF115CEC
          EA882DD6678ED652DA98288AA6205E1DD182E08C2D2CC84C9AA623AC5F94972D
          CF5A7351101B085F1F4C815AADB6A4FA8572395BAB58D360216E12527A75EC7F
          0E6E1BF4E5CEBF9A8B921F86C103D0065D42E44BEC8016283FF6DFCB984F9CDD
          4EB6849115440000000049454E44AE426082}
      end
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          61000000017352474200AECE1CE90000000467414D410000B18F0BFC61050000
          00097048597300000EC300000EC301C76FA8640000009F49444154384FB5934B
          0E83300C4473A5AA274B72BF2E59F6285DF402608F3C608D425A54F54996339F
          201650FE4AADF5D55A5BF398F78EF8C082471496B0807B71DC197930396101EA
          9C6907B0A0A5513965C7DBBAC9A1D67D960116A6A56098B9E0502398F0F101DF
          0C2E3B6AEA5977CE819A59CF06971D35F5AC3BE7C0C4E2867DA6CFD07B6936B8
          AC5870CB85D1EEBDDFA981FF206E5C19BEED8F94B20121CA251C74C74EB30000
          000049454E44AE426082}
      end
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          61000000017352474200AECE1CE90000000467414D410000B18F0BFC61050000
          00097048597300000EC300000EC301C76FA864000000AF49444154384F631805
          08505858B8BFA8A8E83F91F818541B02E4E5E5890325B281F80D924274FC0E68
          51417171B118541B020025DF0225F3409240F64420FB374C2390FD0788A76565
          654900F99940F66BA8360440527C15883DF2F3F33581FCED40F61E20D605B29D
          81F8124C1D541B02C0246018A8690BD010F592921265207B3DBA3C541B02A02B
          80E25F40FC034D0C8CA1DA10009B227C18AA0D018082EFD115E1C2402F7D826A
          1B050C0C0C006E8BD18C08C93F5D0000000049454E44AE426082}
      end
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          61000000017352474200AECE1CE90000000467414D410000B18F0BFC61050000
          00097048597300000EC300000EC301C76FA8640000012449444154384F638081
          FAFA7A8EA2A2A28EC2C2C205407C06C87E5F5050600D95260C809A9A809AFE23
          63A0D84B205D06A40F02717B7E7EBE0154392A282929B1042AF88C6E00167C11
          A89C11A20B0900258EA129C48981DE72836A4300A0C4057485B830D0A52BA1DA
          100028F11E5D211EFC0FE88A3060789843B58303701A1685F8F03FA09E3FC098
          63021B0034D1048B22BC1868C06AB06618000AACC5A6101B06AA6D0F0D0D6586
          6A8580E2E2626EA0E42CA0E46F20FD02481F06D2CF609A6018287E0EAA053BF8
          FFFF3F3C9EF3F2F2C4811AFEA219721F2A4D1800155BA16906E1AF5069C20018
          B869689A9F00BDAA0395260CD2D2D258815E788364C015A814F100A86925CC00
          A0ED415061E20130C5D90135FF01BA643DD0455C50612860600000A9B6466D45
          370D490000000049454E44AE426082}
      end
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          61000000017352474200AECE1CE90000000467414D410000B18F0BFC61050000
          00097048597300000EC300000EC301C76FA864000000CA49444154384F63183C
          20333353B0A8A8E81810774185480350CDFF41B8B0B0B01B2A4C3C006AFA0233
          008A49730950C30D640380069E874A1107809A162269BE08A445A052C401A006
          3F24038ED5D7D73341A58803A1A1A1CC408DD76186007135548A7800D4E40AC4
          FFA006FC2B2828A8FAFFFF3F636E6E2E1FD0F0834031C2010B54D8003500E69D
          C340FA38129F70140315360231CC25D83061970015B9036DBB85A6118C81E2E7
          A0CAF003604CB01417170701352C036ABC0FA47F03F179209BB428A621606000
          00AE4C9B25E8D135790000000049454E44AE426082}
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
          262331303B3C7374796C6520747970653D22746578742F637373223E2E426C61
          636B7B66696C6C3A233732373237323B7D3C2F7374796C653E0D0A3C70617468
          20636C6173733D22426C61636B2220643D224D32322C3231632D322E362D302E
          372D332D322E332D332D3363312E362D312E362C332D342E372C332D3863302D
          302E322C302D302E352C302D3163302D322E352D322E382D352D352E392D3563
          302C302D302E312C302D302E312C3020202623393B63302C302D302E312C302D
          302E312C304331322E382C342C31302C362E352C31302C3963302C302E352C30
          2C302E382C302C3163302C332E332C312E342C362E342C332C3863302C302E37
          2D302E342C322E332D332C33632D352C312E342D362C312E312D362C37683132
          68313220202623393B4332382C32322E312C32372C32322E342C32322C32317A
          222F3E0D0A3C2F7376673E0D0A}
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
          63653D227072657365727665223E2E59656C6C6F777B66696C6C3A2346464231
          31353B7D262331333B262331303B2623393B2E5265647B66696C6C3A23443131
          4331433B7D262331333B262331303B2623393B2E426C75657B66696C6C3A2331
          31373744373B7D262331333B262331303B2623393B2E477265656E7B66696C6C
          3A233033394332333B7D262331333B262331303B2623393B2E426C61636B7B66
          696C6C3A233732373237323B7D262331333B262331303B2623393B2E57686974
          657B66696C6C3A234646464646463B7D262331333B262331303B2623393B2E73
          74307B6F7061636974793A302E353B7D3C2F7374796C653E0D0A3C672069643D
          2252657365744C61796F75744F7074696F6E73223E0D0A09093C706174682063
          6C6173733D22477265656E2220643D224D31362C34632D332E332C302D362E33
          2C312E332D382E352C332E354C342C3476313068302E3268342E314831346C2D
          332E362D332E364331312E382C382E392C31332E382C382C31362C3863342E34
          2C302C382C332E362C382C38732D332E362C382D382C3820202623393B262339
          3B632D332E372C302D362E382D322E362D372E372D3648342E3263312C352E37
          2C352E392C31302C31312E382C313063362E362C302C31322D352E342C31322D
          31325332322E362C342C31362C347A222F3E0D0A093C2F673E0D0A3C2F737667
          3E0D0A}
      end>
  end
  object gpmPopupMenu: TcxGridPopupMenu
    Grid = Grid
    PopupMenus = <
      item
        GridView = tvTableView
        HitTypes = [gvhtColumnHeader]
        Index = 0
        PopupMenu = pmHeaderPopup
      end>
    UseBuiltInPopupMenus = False
    OnPopup = gpmPopupMenuPopup
    Left = 448
    Top = 176
  end
  object cdFixedColumnOverlayColor: TdxColorDialog
    Color = 66051
    Options.ColorPicker.AllowEditAlpha = False
    Left = 648
    Top = 176
  end
  object pmHeaderPopup: TPopupMenu
    Images = ilImages
    Left = 504
    Top = 176
    object pmiNotFixed: TMenuItem
      Action = acNotFixed
      AutoCheck = True
    end
    object pmiFixedLeft: TMenuItem
      Action = acFixedLeft
      AutoCheck = True
    end
    object pmiFixedRight: TMenuItem
      Action = acFixedRight
      AutoCheck = True
    end
    object FixedLeftDynamic1: TMenuItem
      Action = acFixedDynamic
      AutoCheck = True
    end
  end
  object acHeaderPopup: TActionList
    Left = 568
    Top = 176
    object acNotFixed: TAction
      AutoCheck = True
      Caption = 'Not Fixed'
      GroupIndex = 1
      ImageIndex = 3
      OnExecute = acFixedClick
    end
    object acFixedLeft: TAction
      Tag = 1
      AutoCheck = True
      Caption = 'Fixed Left'
      GroupIndex = 1
      ImageIndex = 4
      OnExecute = acFixedClick
    end
    object acFixedRight: TAction
      Tag = 2
      AutoCheck = True
      Caption = 'Fixed Right'
      GroupIndex = 1
      ImageIndex = 5
      OnExecute = acFixedClick
    end
    object acFixedDynamic: TAction
      Tag = 3
      AutoCheck = True
      Caption = 'Fixed Left (Dynamic)'
      GroupIndex = 1
      ImageIndex = 3
      OnExecute = acFixedClick
    end
  end
end
