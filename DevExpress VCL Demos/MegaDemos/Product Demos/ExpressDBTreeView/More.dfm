object MoreForm: TMoreForm
  Left = 463
  Top = 233
  BorderIcons = [biSystemMenu]
  Caption = 'Additional Components...'
  ClientHeight = 182
  ClientWidth = 253
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 4
    Top = 4
    Width = 74
    Height = 13
    Caption = 'dxTreeViewEdit'
  end
  object dxDBTreeViewEdit: TLabel
    Left = 4
    Top = 48
    Width = 89
    Height = 13
    Caption = 'dxDBTreeViewEdit'
  end
  object Label2: TLabel
    Left = 4
    Top = 92
    Width = 92
    Height = 13
    Caption = 'dxLookupTreeView'
  end
  object Label3: TLabel
    Left = 4
    Top = 136
    Width = 107
    Height = 13
    Caption = 'dxDBLookupTreeView'
  end
  object dxTreeViewEdit1: TdxTreeViewEdit
    Left = 4
    Top = 21
    Width = 245
    Height = 21
    CanSelectParents = True
    ParentColor = False
    TabOrder = 0
    TabStop = True
    TreeViewColor = clWindow
    TreeViewCursor = crDefault
    TreeViewFont.Charset = DEFAULT_CHARSET
    TreeViewFont.Color = clWindowText
    TreeViewFont.Height = -11
    TreeViewFont.Name = 'MS Sans Serif'
    TreeViewFont.Style = []
    TreeViewImages = MainForm.ImageList
    TreeViewIndent = 19
    TreeViewReadOnly = False
    TreeViewShowButtons = True
    TreeViewShowHint = False
    TreeViewShowLines = True
    TreeViewShowRoot = True
    TreeViewSortType = stNone
    OnGetSelectedIndex = dxTreeViewEdit1GetSelectedIndex
    DividedChar = '.'
    Items.NodeData = {
      0104000000250000000000000000000000FFFFFFFFFFFFFFFF00000000030000
      00064900740065006D0020003100290000000100000001000000FFFFFFFFFFFF
      FFFF0000000000000000084900740065006D00200031002E0031002900000001
      00000001000000FFFFFFFFFFFFFFFF0000000000000000084900740065006D00
      200031002E003200290000000100000001000000FFFFFFFFFFFFFFFF00000000
      00000000084900740065006D00200031002E0033002500000000000000000000
      00FFFFFFFFFFFFFFFF0000000002000000064900740065006D00200032002900
      00000200000003000000FFFFFFFFFFFFFFFF0000000000000000084900740065
      006D00200032002E003100290000000200000003000000FFFFFFFFFFFFFFFF00
      00000000000000084900740065006D00200032002E0032002500000000000000
      00000000FFFFFFFFFFFFFFFF0000000000000000064900740065006D00200033
      00250000000000000000000000FFFFFFFFFFFFFFFF0000000000000000064900
      740065006D0020003400}
    TextStyle = tvtsShort
    Alignment = taLeftJustify
  end
  object dxDBTreeViewEdit1: TdxDBTreeViewEdit
    Left = 4
    Top = 64
    Width = 245
    Height = 21
    CanSelectParents = True
    ParentColor = False
    TabOrder = 1
    TabStop = True
    Text = 'ExpressQuantumGrid Suite'
    TreeViewColor = clWindow
    TreeViewCursor = crDefault
    TreeViewFont.Charset = DEFAULT_CHARSET
    TreeViewFont.Color = clWindowText
    TreeViewFont.Height = -11
    TreeViewFont.Name = 'MS Sans Serif'
    TreeViewFont.Style = []
    TreeViewImages = MainForm.ImageList
    TreeViewIndent = 19
    TreeViewReadOnly = False
    TreeViewShowButtons = True
    TreeViewShowHint = False
    TreeViewShowLines = True
    TreeViewShowRoot = True
    TreeViewSortType = stNone
    OnCloseUp = dxDBTreeViewEdit1CloseUp
    OnGetSelectedIndex = dxDBTreeViewEdit1GetSelectedIndex
    DividedChar = '.'
    Items.NodeData = {
      0103000000250000000000000000000000FFFFFFFFFFFFFFFF00000000030000
      00064900740065006D0020003100290000000100000000000000FFFFFFFFFFFF
      FFFF0000000000000000084900740065006D00200031002E0031002900000001
      00000000000000FFFFFFFFFFFFFFFF0000000000000000084900740065006D00
      200031002E003200290000000100000000000000FFFFFFFFFFFFFFFF00000000
      00000000084900740065006D00200031002E0033002500000000000000000000
      00FFFFFFFFFFFFFFFF0000000004000000064900740065006D00200032002900
      00000100000000000000FFFFFFFFFFFFFFFF0000000000000000084900740065
      006D00200032002E003100290000000100000000000000FFFFFFFFFFFFFFFF00
      00000000000000084900740065006D00200032002E0032002900000001000000
      00000000FFFFFFFFFFFFFFFF0000000000000000084900740065006D00200032
      002E003300290000000100000000000000FFFFFFFFFFFFFFFF00000000000000
      00084900740065006D00200032002E003400250000000200000000000000FFFF
      FFFFFFFFFFFF0000000000000000064900740065006D0020003300}
    TextStyle = tvtsShort
    DataField = 'Pr_name'
    DataSource = MainForm.DS1
  end
  object dxLookupTreeView: TdxLookupTreeView
    Left = 4
    Top = 108
    Width = 245
    Height = 21
    CanSelectParents = True
    ParentColor = False
    TabOrder = 2
    TabStop = True
    Text = 'ExpressQuantumGrid Suite'
    TreeViewColor = clWindow
    TreeViewCursor = crDefault
    TreeViewFont.Charset = DEFAULT_CHARSET
    TreeViewFont.Color = clWindowText
    TreeViewFont.Height = -11
    TreeViewFont.Name = 'MS Sans Serif'
    TreeViewFont.Style = []
    TreeViewImages = MainForm.ImageList
    TreeViewIndent = 19
    TreeViewReadOnly = False
    TreeViewShowButtons = True
    TreeViewShowHint = False
    TreeViewShowLines = True
    TreeViewShowRoot = True
    TreeViewSortType = stNone
    OnGetSelectedIndex = dxLookupTreeViewGetSelectedIndex
    DividedChar = '.'
    ImageIndexField = 'Image'
    ListSource = MainForm.DS2
    KeyField = 'Pr_id'
    ListField = 'Pr_name'
    Options = [trDBCanDelete, trDBConfirmDelete, trCanDBNavigate, trSmartRecordCopy, trCheckHasChildren]
    ParentField = 'Pr_parent'
    RootValue = Null
    TextStyle = tvtsShort
    Alignment = taLeftJustify
  end
  object dxDBLookupTreeView: TdxDBLookupTreeView
    Left = 4
    Top = 155
    Width = 245
    Height = 21
    CanSelectParents = True
    ParentColor = False
    TabOrder = 3
    TabStop = True
    Text = 'ExpressQuantumGrid Suite'
    TreeViewColor = clWindow
    TreeViewCursor = crDefault
    TreeViewFont.Charset = DEFAULT_CHARSET
    TreeViewFont.Color = clWindowText
    TreeViewFont.Height = -11
    TreeViewFont.Name = 'MS Sans Serif'
    TreeViewFont.Style = []
    TreeViewImages = MainForm.ImageList
    TreeViewIndent = 19
    TreeViewReadOnly = False
    TreeViewShowButtons = True
    TreeViewShowHint = False
    TreeViewShowLines = True
    TreeViewShowRoot = True
    TreeViewSortType = stNone
    OnGetSelectedIndex = dxDBLookupTreeViewGetSelectedIndex
    DividedChar = '.'
    ImageIndexField = 'Image'
    ListSource = MainForm.DS2
    KeyField = 'Pr_id'
    ListField = 'Pr_name'
    Options = [trDBCanDelete, trDBConfirmDelete, trCanDBNavigate, trSmartRecordCopy, trCheckHasChildren]
    ParentField = 'Pr_parent'
    RootValue = Null
    TextStyle = tvtsShort
    AssignField = 'Pr_parent'
    DataField = 'Pr_parent'
    DataSource = MainForm.DS1
  end
end
