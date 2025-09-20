object AniEditor: TAniEditor
  Left = 313
  Top = 217
  BorderStyle = bsDialog
  Caption = 'Select ANI file'
  ClientHeight = 168
  ClientWidth = 194
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 4
    Width = 73
    Height = 13
    Caption = 'Animated icon :'
  end
  object Panel1: TPanel
    Left = 8
    Top = 24
    Width = 91
    Height = 89
    TabOrder = 0
    object AniIcon: TAniIcon
      Left = 27
      Top = 26
      Width = 32
      Height = 32
      AniFile.Data = {}
      Animated = False
      AnimateOnEnter = False
      Frame = 0
      Transparent = False
      Center = False
      ButtonStyle = False
      Version = '1.2.0.3'
    end
  end
  object Button1: TButton
    Left = 112
    Top = 24
    Width = 75
    Height = 25
    Caption = 'Play'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 112
    Top = 56
    Width = 75
    Height = 25
    Caption = 'Stop'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 112
    Top = 88
    Width = 75
    Height = 25
    Caption = 'Browse ...'
    TabOrder = 3
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 16
    Top = 136
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 4
  end
  object Button5: TButton
    Left = 104
    Top = 136
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 5
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Animated Icons (*.ANI)|*.ANI'
    Left = 160
    Top = 108
  end
end
