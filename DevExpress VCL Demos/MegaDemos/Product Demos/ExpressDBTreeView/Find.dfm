object FindForm: TFindForm
  Left = 476
  Top = 317
  BorderIcons = [biSystemMenu]
  Caption = 'Find'
  ClientHeight = 55
  ClientWidth = 198
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object SerachEdit: TEdit
    Left = 4
    Top = 4
    Width = 189
    Height = 21
    TabOrder = 0
    OnChange = SerachEditChange
  end
  object Button1: TButton
    Left = 120
    Top = 28
    Width = 74
    Height = 21
    Caption = 'Close'
    TabOrder = 1
    OnClick = Button1Click
  end
end
