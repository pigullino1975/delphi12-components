object SelectForm: TSelectForm
  Left = 329
  Top = 133
  BorderStyle = bsDialog
  Caption = 'SelectForm'
  ClientHeight = 243
  ClientWidth = 272
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object title: TLabel
    Left = 8
    Top = 8
    Width = 16
    Height = 13
    Caption = 'title'
  end
  object SelectList: TListBox
    Left = 8
    Top = 24
    Width = 177
    Height = 209
    ItemHeight = 13
    TabOrder = 0
    OnClick = SelectListClick
    OnDblClick = SelectListDblClick
  end
  object okbtn: TButton
    Left = 192
    Top = 208
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = okbtnClick
  end
  object cancelbtn: TButton
    Left = 192
    Top = 176
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = cancelbtnClick
  end
  object CheckSelectList: TCheckListBox
    Left = 8
    Top = 24
    Width = 178
    Height = 211
    ItemHeight = 13
    TabOrder = 3
    OnClick = SelectListClick
    OnDblClick = SelectListDblClick
  end
end
