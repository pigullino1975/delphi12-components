object selectdialog: Tselectdialog
  Left = 582
  Top = 105
  BorderStyle = bsSingle
  Caption = 'Select table'
  ClientHeight = 150
  ClientWidth = 177
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object tablelist: TListBox
    Left = 8
    Top = 8
    Width = 161
    Height = 105
    ItemHeight = 13
    TabOrder = 0
  end
  object OK: TButton
    Left = 8
    Top = 120
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = OKClick
  end
  object Cancel: TButton
    Left = 96
    Top = 120
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = CancelClick
  end
end
