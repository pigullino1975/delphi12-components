object frmdxMemDataEditor: TfrmdxMemDataEditor
  Left = 100
  Top = 100
  ActiveControl = ListBox
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSizeToolWin
  Caption = 'Columns Editor'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnClose = FormClose
  TextHeight = 15
  object ListBox: TListBox
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 514
    Height = 435
    Margins.Right = 0
    Align = alClient
    DragMode = dmAutomatic
    ItemHeight = 15
    MultiSelect = True
    TabOrder = 0
    OnClick = ListBoxClick
    OnDragDrop = ListBoxDragDrop
    OnDragOver = ListBoxDragOver
    OnEndDrag = ListBoxEndDrag
    OnStartDrag = ListBoxStartDrag
  end
  object pnButtons: TPanel
    Left = 517
    Top = 0
    Width = 107
    Height = 441
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 1
    object BAdd: TButton
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 101
      Height = 25
      Align = alTop
      Caption = '&Add ...'
      TabOrder = 0
      OnClick = BAddClick
    end
    object BDelete: TButton
      AlignWithMargins = True
      Left = 3
      Top = 34
      Width = 101
      Height = 25
      Align = alTop
      Caption = '&Delete'
      TabOrder = 1
      OnClick = BDeleteClick
    end
    object BUp: TButton
      AlignWithMargins = True
      Left = 3
      Top = 65
      Width = 101
      Height = 25
      Align = alTop
      Caption = 'Move &Up'
      TabOrder = 2
      OnClick = miUpClick
    end
    object BDown: TButton
      AlignWithMargins = True
      Left = 3
      Top = 96
      Width = 101
      Height = 25
      Align = alTop
      Caption = 'Move Dow&n'
      TabOrder = 3
      OnClick = miDownClick
    end
  end
  object pmColumns: TPopupMenu
    object miAdd: TMenuItem
      Caption = '&Add...'
      ShortCut = 45
      OnClick = BAddClick
    end
    object miDelete: TMenuItem
      Caption = '&Delete'
      ShortCut = 46
      OnClick = BDeleteClick
    end
    object miUp: TMenuItem
      Caption = 'Move &Up'
      OnClick = miUpClick
    end
    object miDown: TMenuItem
      Caption = 'Move Dow&n'
      OnClick = miDownClick
    end
    object miSelectAll: TMenuItem
      Caption = '&Select All'
      OnClick = miSelectAllClick
    end
    object miSeparator: TMenuItem
      Caption = '-'
    end
    object miShowButtons: TMenuItem
      Caption = '&Show Buttons'
      Checked = True
      OnClick = miShowButtonsClick
    end
  end
end
