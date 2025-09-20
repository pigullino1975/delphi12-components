object frmdxMemDataAddField: TfrmdxMemDataAddField
  Left = 0
  Top = 0
  ActiveControl = edName
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'New Field'
  ClientHeight = 299
  ClientWidth = 518
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  TextHeight = 15
  object pnlBottom: TPanel
    Left = 0
    Top = 261
    Width = 518
    Height = 38
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object btnOK: TButton
      Left = 317
      Top = 8
      Width = 92
      Height = 28
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object btnCancel: TButton
      Left = 421
      Top = 8
      Width = 92
      Height = 28
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 518
    Height = 261
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 4
    TabOrder = 1
    object gbFieldProp: TGroupBox
      Left = 4
      Top = 4
      Width = 510
      Height = 102
      Align = alTop
      Caption = 'Field Properties'
      TabOrder = 0
      object LName: TLabel
        Left = 11
        Top = 25
        Width = 35
        Height = 15
        Caption = 'Name:'
      end
      object TLype: TLabel
        Left = 11
        Top = 65
        Width = 27
        Height = 15
        Caption = 'Type:'
      end
      object LComponent: TLabel
        Left = 251
        Top = 25
        Width = 67
        Height = 15
        Caption = 'Component:'
      end
      object LSize: TLabel
        Left = 251
        Top = 65
        Width = 23
        Height = 15
        Caption = 'Size:'
      end
      object edName: TEdit
        Left = 67
        Top = 23
        Width = 173
        Height = 23
        MaxLength = 32767
        TabOrder = 0
        OnChange = edNameChange
      end
      object cbFieldType: TComboBox
        Left = 67
        Top = 61
        Width = 173
        Height = 23
        Style = csDropDownList
        TabOrder = 2
        OnChange = cbFieldTypeChange
      end
      object edComponent: TEdit
        Left = 328
        Top = 23
        Width = 173
        Height = 23
        MaxLength = 32767
        TabOrder = 1
        OnChange = edComponentChange
      end
      object edSize: TEdit
        Left = 328
        Top = 61
        Width = 69
        Height = 23
        MaxLength = 32767
        TabOrder = 3
        OnKeyPress = edSizeKeyPress
      end
    end
    object PanelTop1: TPanel
      Left = 4
      Top = 106
      Width = 510
      Height = 4
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
    end
    object gbFieldType: TRadioGroup
      Left = 4
      Top = 110
      Width = 510
      Height = 57
      Align = alTop
      Caption = 'Field Type'
      Columns = 3
      ItemIndex = 0
      Items.Strings = (
        'Data'
        'Calculated'
        'Lookup')
      TabOrder = 2
      OnClick = gbFieldTypeClick
    end
    object PanelTop2: TPanel
      Left = 4
      Top = 167
      Width = 510
      Height = 4
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 3
    end
    object gbLookup: TGroupBox
      Left = 4
      Top = 171
      Width = 510
      Height = 91
      Align = alTop
      Caption = 'Lookup Definition'
      TabOrder = 4
      object LKeyField: TLabel
        Left = 11
        Top = 28
        Width = 50
        Height = 15
        Caption = 'Key Field:'
      end
      object LLookupField: TLabel
        Left = 11
        Top = 57
        Width = 71
        Height = 15
        Caption = 'Lookup Field:'
      end
      object LDataSet: TLabel
        Left = 270
        Top = 28
        Width = 42
        Height = 15
        Caption = 'Dataset:'
      end
      object LResultField: TLabel
        Left = 270
        Top = 57
        Width = 63
        Height = 15
        Caption = 'Result Field:'
      end
      object cbKeyField: TComboBox
        Left = 100
        Top = 23
        Width = 149
        Height = 23
        Style = csDropDownList
        Enabled = False
        TabOrder = 0
      end
      object cbLookupField: TComboBox
        Left = 100
        Top = 57
        Width = 149
        Height = 23
        Style = csDropDownList
        Enabled = False
        TabOrder = 1
      end
      object cbDataSet: TComboBox
        Left = 355
        Top = 23
        Width = 149
        Height = 23
        Enabled = False
        TabOrder = 2
        OnExit = cbDataSetExit
      end
      object cbResultField: TComboBox
        Left = 355
        Top = 57
        Width = 149
        Height = 23
        Style = csDropDownList
        Enabled = False
        TabOrder = 3
      end
    end
  end
end
