object dxSkinsDesignHelperForm: TdxSkinsDesignHelperForm
  Left = 305
  Top = 153
  BorderStyle = bsDialog
  Caption = 'Project Skin Options Editor'
  ClientHeight = 460
  ClientWidth = 430
  Color = clBtnFace
  ParentFont = True
  Position = poScreenCenter
  ShowHint = True
  PixelsPerInch = 96
  TextHeight = 13
  object bOk: TButton
    Left = 226
    Top = 427
    Width = 95
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object bCancel: TButton
    Left = 327
    Top = 427
    Width = 95
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object cbDefault: TCheckBox
    Left = 8
    Top = 427
    Width = 121
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Default'
    TabOrder = 2
  end
  object pnlMain: TPanel
    AlignWithMargins = True
    Left = 8
    Top = 8
    Width = 414
    Height = 414
    Margins.Left = 8
    Margins.Top = 8
    Margins.Right = 8
    Margins.Bottom = 38
    Align = alClient
    BevelInner = bvRaised
    BevelOuter = bvLowered
    FullRepaint = False
    Padding.Left = 5
    Padding.Top = 5
    Padding.Right = 5
    Padding.Bottom = 5
    TabOrder = 3
    object lbSkins: TLabel
      AlignWithMargins = True
      Left = 10
      Top = 56
      Width = 394
      Height = 13
      Align = alTop
      Caption = 'Available skins:'
    end
    object cbSkinsAutoFilling: TCheckBox
      AlignWithMargins = True
      Left = 10
      Top = 10
      Width = 394
      Height = 17
      Align = alTop
      Caption = '&Enable skin support'
      Checked = True
      State = cbChecked
      TabOrder = 0
      OnClick = cbSkinsAutoFillingClick
    end
    object cbShowNotifications: TCheckBox
      AlignWithMargins = True
      Left = 10
      Top = 33
      Width = 394
      Height = 17
      Align = alTop
      Caption = 'Notify about new skins'
      TabOrder = 1
      OnClick = cbShowNotificationsClick
    end
    object bSelectAll: TButton
      Tag = 1
      Left = 314
      Top = 74
      Width = 90
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Select &All'
      TabOrder = 2
      OnClick = bSelectAllClick
    end
    object bSelectNone: TButton
      Left = 314
      Top = 105
      Width = 90
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Select &None'
      TabOrder = 3
      OnClick = bSelectAllClick
    end
    object pnlNotes: TPanel
      AlignWithMargins = True
      Left = 10
      Top = 362
      Width = 394
      Height = 42
      Align = alBottom
      AutoSize = True
      BevelKind = bkFlat
      BevelOuter = bvNone
      Color = clInfoBk
      FullRepaint = False
      ParentBackground = False
      TabOrder = 4
      object lbNotes: TLabel
        AlignWithMargins = True
        Left = 41
        Top = 3
        Width = 346
        Height = 32
        Align = alClient
        Caption = 
          'Note: if you uncheck a skin, whose unit has already been added t' +
          'o the '#39'uses'#39' clause, you need to manually remove this unit.'
        Color = clBtnFace
        ParentColor = False
        Transparent = True
        Layout = tlCenter
        WordWrap = True
      end
      object Image: TImage
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 32
        Height = 32
        Align = alLeft
        AutoSize = True
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
          742F637373223E2E426C75657B66696C6C3A233131373744373B7D3C2F737479
          6C653E0D0A3C7061746820636C6173733D22426C75652220643D224D31362C32
          43382E332C322C322C382E332C322C313673362E332C31342C31342C31347331
          342D362E332C31342D31345332332E372C322C31362C327A204D31362C366331
          2E312C302C322C302E392C322C32732D302E392C322D322C32732D322D302E39
          2D322D3220202623393B5331342E392C362C31362C367A204D32302C3234682D
          38762D326832762D38682D32762D326832683476313068325632347A222F3E0D
          0A3C2F7376673E0D0A}
      end
    end
    object clbSkins: TCheckListBox
      AlignWithMargins = True
      Left = 10
      Top = 75
      Width = 297
      Height = 281
      Margins.Right = 100
      Align = alClient
      ItemHeight = 13
      TabOrder = 5
      OnClickCheck = clbSkinsClickCheck
    end
  end
end
