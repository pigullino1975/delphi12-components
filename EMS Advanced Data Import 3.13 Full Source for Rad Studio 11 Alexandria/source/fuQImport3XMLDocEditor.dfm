inherited fmQImport3XMLDocEditor: TfmQImport3XMLDocEditor
  Caption = 'fmQImport3XMLDocEditor'
  PixelsPerInch = 96
  TextHeight = 13
  inherited laColumn: TLabel
    Left = 237
    Top = 93
  end
  inherited laSkip_01: TLabel
    Left = 356
    Top = 93
  end
  inherited laSkip_02: TLabel
    Left = 432
    Top = 93
  end
  object laXPath: TLabel [5]
    Left = 183
    Top = 35
    Width = 29
    Height = 21
    AutoSize = False
    Caption = 'XPath'
    FocusControl = edXPath
    Layout = tlCenter
  end
  object bFillGrig: TSpeedButton [6]
    Left = 537
    Top = 35
    Width = 20
    Height = 48
    Hint = 'Fill grid'
    Anchors = [akTop, akRight]
    Glyph.Data = {
      36040000424D3604000000000000360000002800000010000000100000000100
      2000000000000004000000000000000000000000000000000000FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF008000000080000000FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF0080000000FF000000FF0000008000
      0000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF0080000000FF000000FF000000FF000000FF00
      000080000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF0080000000FF000000FF000000FF000000FF000000FF00
      0000FF00000080000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF0080000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF00000080000000FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF0080000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF00000080000000FF00FF00FF00FF00FF00FF00FF00
      FF0080000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF00000080000000FF00FF00FF00FF00FF00FF00FF00
      FF0080000000800000008000000080000000FF000000FF000000FF000000FF00
      000080000000800000008000000080000000FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF0080000000FF000000FF000000FF000000FF00
      000080000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF0080000000FF000000FF000000FF000000FF00
      000080000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF0080000000FF000000FF000000FF000000FF00
      000080000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF0080000000FF000000FF000000FF000000FF00
      000080000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF0080000000FF000000FF000000FF000000FF00
      000080000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00800000008000000080000000800000008000
      000080000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
    ParentShowHint = False
    ShowHint = True
    OnClick = bFillGrigClick
  end
  object laDataLocation: TLabel [7]
    Left = 183
    Top = 62
    Width = 67
    Height = 21
    AutoSize = False
    Caption = 'Data Location'
    FocusControl = cbDataLocation
    Layout = tlCenter
  end
  inherited paFileName: TPanel
    inherited bvlBrowse: TBevel
      Anchors = [akTop, akRight]
    end
  end
  inherited paGrid: TPanel
    Top = 120
    Height = 224
    TabOrder = 7
  end
  inherited paButtons: TPanel
    TabOrder = 8
  end
  inherited cbColumn: TComboBox
    Top = 90
    TabOrder = 5
  end
  inherited ToolBar: TToolBar
    Top = 89
    TabOrder = 4
  end
  inherited paFields: TPanel
    object bBuildTree: TSpeedButton [0]
      Left = 3
      Top = 164
      Width = 95
      Height = 23
      Hint = 'Fill grid'
      Caption = 'Builld TreeView'
      ParentShowHint = False
      ShowHint = True
      OnClick = bBuildTreeClick
    end
    object bGetXPath: TSpeedButton [1]
      Left = 104
      Top = 164
      Width = 67
      Height = 23
      Hint = 'Fill grid'
      Caption = 'Get XPath'
      ParentShowHint = False
      ShowHint = True
      OnClick = bGetXPathClick
    end
    inherited lvFields: TListView
      Height = 155
      Anchors = [akLeft, akTop, akRight]
    end
    object tvXMLDoc: TTreeView
      Left = 3
      Top = 193
      Width = 168
      Height = 109
      Anchors = [akLeft, akTop, akRight, akBottom]
      Indent = 19
      PopupMenu = pmTreeView
      TabOrder = 1
      OnDblClick = bGetXPathClick
    end
  end
  inherited edSkip: TEdit
    Left = 399
    Top = 90
    TabOrder = 6
  end
  object edXPath: TEdit [15]
    Left = 256
    Top = 35
    Width = 276
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 2
    Text = '/'
  end
  object cbDataLocation: TComboBox [16]
    Left = 256
    Top = 62
    Width = 276
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    ItemIndex = 0
    TabOrder = 3
    Text = 'Attributes'
    Items.Strings = (
      'Attributes'
      'Sub Nodes Text')
  end
  object pmTreeView: TPopupMenu
    Left = 24
    Top = 256
    object miGetXPath: TMenuItem
      Caption = 'Get XPath'
      OnClick = bGetXPathClick
    end
  end
  inherited odFileName: TOpenDialog
    DefaultExt = 'txt'
    Filter = 'XML files (*.xml)|*.xml'
  end
end
