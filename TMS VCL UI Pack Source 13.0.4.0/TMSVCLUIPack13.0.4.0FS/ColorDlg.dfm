object ColorChooser: TColorChooser
  Left = 691
  Top = 457
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Choose colors'
  ClientHeight = 184
  ClientWidth = 250
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
  object PaintBox1: TPaintBox
    Left = 8
    Top = 24
    Width = 233
    Height = 57
    OnMouseDown = PaintBox1MouseDown
    OnPaint = PaintBox1Paint
  end
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 38
    Height = 13
    Caption = 'Preview'
  end
  object Button1: TButton
    Left = 8
    Top = 88
    Width = 75
    Height = 25
    Caption = 'Start color'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 88
    Top = 88
    Width = 75
    Height = 25
    Caption = 'End color'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 168
    Top = 88
    Width = 75
    Height = 25
    Caption = 'Border color'
    TabOrder = 2
    OnClick = Button3Click
  end
  object CheckBox1: TCheckBox
    Left = 8
    Top = 120
    Width = 113
    Height = 17
    Caption = 'Horizontal gradient'
    TabOrder = 3
    OnClick = CheckBox1Click
  end
  object Button4: TButton
    Left = 88
    Top = 152
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 4
  end
  object Button5: TButton
    Left = 168
    Top = 152
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 5
  end
  object CheckBox2: TCheckBox
    Left = 136
    Top = 120
    Width = 97
    Height = 17
    Caption = 'No gradient'
    TabOrder = 6
    OnClick = CheckBox2Click
  end
  object ColorDialog1: TColorDialog
    Left = 40
    Top = 152
  end
end
