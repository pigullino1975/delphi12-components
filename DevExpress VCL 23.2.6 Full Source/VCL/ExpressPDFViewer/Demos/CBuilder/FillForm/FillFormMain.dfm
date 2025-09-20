inherited frmPDFFillForm: TfrmPDFFillForm
  Left = 0
  Top = 0
  Caption = 'Fill PDF Form'
  ClientHeight = 596
  ClientWidth = 1005
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  inherited lcMain: TdxLayoutControl
    Width = 1005
    Height = 596
    inherited lbDescription: TLabel
      Width = 985
      Caption = 
        'This demo illustrates how to complete an interactive form in a P' +
        'DF document. Click "Submit" or "Reset" to populate or clear form' +
        ' fields. Click "File | Save As..." to save the filled form as a ' +
        'PDF file.'
    end
    object dxPDFViewer1: TdxPDFViewer [1]
      Left = 10
      Top = 32
      Width = 662
      Height = 554
      OptionsNavigationPane.Attachments.Glyph.SourceDPI = 96
      OptionsNavigationPane.Attachments.Glyph.Data = {
        3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D227574
        662D38223F3E0D0A3C212D2D2047656E657261746F723A2041646F626520496C
        6C7573747261746F722032302E312E302C20535647204578706F727420506C75
        672D496E202E205356472056657273696F6E3A20362E3030204275696C642030
        2920202D2D3E0D0A3C21444F435459504520737667205055424C494320222D2F
        2F5733432F2F4454442053564720312E312F2F454E222022687474703A2F2F77
        77772E77332E6F72672F47726170686963732F5356472F312E312F4454442F73
        766731312E647464223E0D0A3C7376672076657273696F6E3D22312E31222069
        643D224C617965725F312220786D6C6E733D22687474703A2F2F7777772E7733
        2E6F72672F323030302F7376672220786D6C6E733A786C696E6B3D2268747470
        3A2F2F7777772E77332E6F72672F313939392F786C696E6B2220783D22307078
        2220793D22307078220D0A092076696577426F783D2230203020333220333222
        207374796C653D22656E61626C652D6261636B67726F756E643A6E6577203020
        302033322033323B2220786D6C3A73706163653D227072657365727665223E0D
        0A3C7374796C6520747970653D22746578742F637373223E0D0A092E426C6163
        6B7B66696C6C3A233732373237323B7D0D0A3C2F7374796C653E0D0A3C706174
        682069643D224174746163686D656E742220636C6173733D22426C61636B2220
        643D224D31372C3263332E392C302C372C332E312C372C37763133682D325639
        63302D322E382D322E322D352D352D35732D352C322E322D352C357631366330
        2C312E372C312E332C332C332C3373332D312E332C332D335631310D0A096330
        2D302E362D302E342D312D312D31732D312C302E342D312C31763131682D3256
        313163302D312E372C312E332D332C332D3373332C312E332C332C3376313463
        302C322E382D322E322C352D352C35732D352D322E322D352D3556394331302C
        352E312C31332E312C322C31372C327A222F3E0D0A3C2F7376673E0D0A}
      OptionsNavigationPane.Attachments.Visible = bTrue
      OptionsNavigationPane.Bookmarks.Glyph.SourceDPI = 96
      OptionsNavigationPane.Bookmarks.Glyph.Data = {
        3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D227574
        662D38223F3E0D0A3C212D2D2047656E657261746F723A2041646F626520496C
        6C7573747261746F722032302E312E302C20535647204578706F727420506C75
        672D496E202E205356472056657273696F6E3A20362E3030204275696C642030
        2920202D2D3E0D0A3C21444F435459504520737667205055424C494320222D2F
        2F5733432F2F4454442053564720312E312F2F454E222022687474703A2F2F77
        77772E77332E6F72672F47726170686963732F5356472F312E312F4454442F73
        766731312E647464223E0D0A3C7376672076657273696F6E3D22312E31222069
        643D224C617965725F312220786D6C6E733D22687474703A2F2F7777772E7733
        2E6F72672F323030302F7376672220786D6C6E733A786C696E6B3D2268747470
        3A2F2F7777772E77332E6F72672F313939392F786C696E6B2220783D22307078
        2220793D22307078220D0A092076696577426F783D2230203020333220333222
        207374796C653D22656E61626C652D6261636B67726F756E643A6E6577203020
        302033322033323B2220786D6C3A73706163653D227072657365727665223E0D
        0A3C7374796C6520747970653D22746578742F637373223E0D0A092E426C6163
        6B7B66696C6C3A233732373237323B7D0D0A3C2F7374796C653E0D0A3C706F6C
        79676F6E2069643D22426F6F6B6D61726B732220636C6173733D22426C61636B
        2220706F696E74733D2232342C33302031362C323220382C333020382C342032
        342C3420222F3E0D0A3C2F7376673E0D0A}
      OptionsNavigationPane.Thumbnails.Glyph.SourceDPI = 96
      OptionsNavigationPane.Thumbnails.Glyph.Data = {
        3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D227574
        662D38223F3E0D0A3C212D2D2047656E657261746F723A2041646F626520496C
        6C7573747261746F722032302E312E302C20535647204578706F727420506C75
        672D496E202E205356472056657273696F6E3A20362E3030204275696C642030
        2920202D2D3E0D0A3C21444F435459504520737667205055424C494320222D2F
        2F5733432F2F4454442053564720312E312F2F454E222022687474703A2F2F77
        77772E77332E6F72672F47726170686963732F5356472F312E312F4454442F73
        766731312E647464223E0D0A3C7376672076657273696F6E3D22312E31222069
        643D224C617965725F312220786D6C6E733D22687474703A2F2F7777772E7733
        2E6F72672F323030302F7376672220786D6C6E733A786C696E6B3D2268747470
        3A2F2F7777772E77332E6F72672F313939392F786C696E6B2220783D22307078
        2220793D22307078220D0A092076696577426F783D2230203020333220333222
        207374796C653D22656E61626C652D6261636B67726F756E643A6E6577203020
        302033322033323B2220786D6C3A73706163653D227072657365727665223E0D
        0A3C7374796C6520747970653D22746578742F637373223E0D0A092E426C6163
        6B7B66696C6C3A233732373237323B7D0D0A3C2F7374796C653E0D0A3C706174
        682069643D225468756D626E61696C732220636C6173733D22426C61636B2220
        643D224D32382C38682D34563448313276364836763138683136762D36683656
        387A204D32302C32364838563132683476313068385632367A204D32362C3230
        682D34682D32682D36762D38762D3256366838763468345632307A220D0A092F
        3E0D0A3C2F7376673E0D0A}
      OptionsView.HighlightCurrentPage = False
      OptionsZoom.ZoomMode = pzmPageWidth
    end
    object btnSubmit: TcxButton [2]
      Left = 895
      Top = 285
      Width = 100
      Height = 25
      Caption = 'Submit'
      TabOrder = 10
      OnClick = btnSubmitClick
    end
    object teFirstName: TcxTextEdit [3]
      Left = 755
      Top = 32
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 1
      Text = 'Janet'
      Width = 240
    end
    object teLastName: TcxTextEdit [4]
      Left = 755
      Top = 57
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 2
      Text = 'Leverling'
      Width = 240
    end
    object deDateOfBirth: TcxDateEdit [5]
      Left = 755
      Top = 135
      EditValue = 31289d
      Properties.DateButtons = [btnClear, btnNow, btnToday]
      Properties.SaveTime = False
      Properties.ShowTime = False
      Properties.ShowToday = False
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 3
      Width = 240
    end
    object tePassportNo: TcxTextEdit [6]
      Left = 755
      Top = 160
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 4
      Text = '31195855'
      Width = 240
    end
    object cbNationality: TcxComboBox [7]
      Left = 755
      Top = 185
      Properties.DropDownListStyle = lsFixedList
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 5
      Width = 240
    end
    object teAddress: TcxTextEdit [8]
      Left = 755
      Top = 210
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 6
      Text = '98033, 722 Moss Bay Blvd., Kirkland, WA, USA'
      Width = 240
    end
    object teVisaNo: TcxTextEdit [9]
      Left = 755
      Top = 235
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 7
      Text = '73203393'
      Width = 240
    end
    object teFlightNo: TcxTextEdit [10]
      Left = 755
      Top = 260
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 8
      Text = '(KL) KLM 876'
      Width = 240
    end
    object btnReset: TcxButton [11]
      Left = 685
      Top = 285
      Width = 75
      Height = 25
      Caption = 'Reset'
      TabOrder = 9
      OnClick = btnResetClick
    end
    inherited lcMainGroup_Root: TdxLayoutGroup
      ItemIndex = 1
    end
    inherited lgContent: TdxLayoutGroup
      ItemIndex = 2
      LayoutDirection = ldHorizontal
    end
    object dxLayoutItem1: TdxLayoutItem
      Parent = lgContent
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'dxPDFViewer1'
      CaptionOptions.Visible = False
      Control = dxPDFViewer1
      ControlOptions.OriginalHeight = 406
      ControlOptions.OriginalWidth = 665
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutGroup1: TdxLayoutGroup
      Parent = lgContent
      AlignHorz = ahLeft
      AlignVert = avClient
      CaptionOptions.Text = 'File'
      SizeOptions.AssignedValues = [sovSizableHorz]
      SizeOptions.SizableHorz = True
      SizeOptions.Width = 310
      ItemIndex = 9
      ShowBorder = False
      Index = 2
    end
    object dxLayoutItem2: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup1
      AlignHorz = ahRight
      CaptionOptions.Text = 'cxButton2'
      CaptionOptions.Visible = False
      Control = btnSubmit
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 100
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem3: TdxLayoutItem
      Parent = dxLayoutGroup1
      CaptionOptions.Text = 'First Name:'
      Control = teFirstName
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem4: TdxLayoutItem
      Parent = dxLayoutGroup1
      CaptionOptions.Text = 'Last Name:'
      Control = teLastName
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object rbtMale: TdxLayoutRadioButtonItem
      Parent = lgGender
      CaptionOptions.Text = 'Male'
      TabStop = True
      Index = 0
    end
    object rbtFemale: TdxLayoutRadioButtonItem
      Parent = lgGender
      CaptionOptions.Text = 'Female'
      Checked = True
      TabStop = True
      Index = 1
    end
    object lgGender: TdxLayoutGroup
      Parent = dxLayoutGroup1
      CaptionOptions.Text = 'Gender'
      ItemIndex = 1
      LayoutDirection = ldHorizontal
      Index = 2
    end
    object dxLayoutItem5: TdxLayoutItem
      Parent = dxLayoutGroup1
      CaptionOptions.Text = 'Date of Birth:'
      Control = deDateOfBirth
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object dxLayoutItem6: TdxLayoutItem
      Parent = dxLayoutGroup1
      CaptionOptions.Text = 'Passport No.:'
      Control = tePassportNo
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 4
    end
    object dxLayoutItem7: TdxLayoutItem
      Parent = dxLayoutGroup1
      CaptionOptions.Text = 'Nationality'
      Control = cbNationality
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 5
    end
    object dxLayoutItem8: TdxLayoutItem
      Parent = dxLayoutGroup1
      CaptionOptions.Text = 'Address:'
      Control = teAddress
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 6
    end
    object dxLayoutItem9: TdxLayoutItem
      Parent = dxLayoutGroup1
      CaptionOptions.Text = 'Visa No.:'
      Control = teVisaNo
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 7
    end
    object dxLayoutItem10: TdxLayoutItem
      Parent = dxLayoutGroup1
      CaptionOptions.Text = 'Flight No.:'
      Control = teFlightNo
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 8
    end
    object dxLayoutItem11: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup1
      AlignHorz = ahLeft
      AlignVert = avClient
      CaptionOptions.Text = 'cxButton2'
      CaptionOptions.Visible = False
      Control = btnReset
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutSplitterItem1: TdxLayoutSplitterItem
      Parent = lgContent
      SizeOptions.AssignedValues = [sovSizableHorz, sovSizableVert]
      SizeOptions.SizableHorz = False
      SizeOptions.SizableVert = False
      CaptionOptions.Text = 'Splitter'
      Index = 1
    end
    object dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutGroup1
      LayoutDirection = ldHorizontal
      Index = 9
    end
  end
  inherited mmMain: TMainMenu
    inherited miFile: TMenuItem
      object SaveAs1: TMenuItem [0]
        Caption = 'Save As...'
        OnClick = SaveAs1Click
      end
    end
  end
  inherited OpenDialog: TdxOpenFileDialog
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofEnableSizing]
  end
  inherited dxLayoutLookAndFeelList1: TdxLayoutLookAndFeelList
    inherited dxLayoutCxLookAndFeel1: TdxLayoutCxLookAndFeel
      PixelsPerInch = 96
    end
  end
end
