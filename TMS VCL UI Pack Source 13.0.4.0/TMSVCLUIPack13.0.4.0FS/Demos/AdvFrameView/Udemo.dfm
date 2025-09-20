object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'TAdvFrameView demo'
  ClientHeight = 376
  ClientWidth = 662
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    662
    376)
  PixelsPerInch = 96
  TextHeight = 13
  object AdvFrameView1: TAdvFrameView
    Left = 8
    Top = 8
    Width = 649
    Height = 361
    HorzScrollBar.Tracking = True
    VertScrollBar.Tracking = True
    Anchors = [akLeft, akTop, akRight, akBottom]
    Ctl3D = False
    Padding.Left = 10
    Padding.Top = 10
    Padding.Right = 10
    Padding.Bottom = 10
    ParentCtl3D = False
    ParentDoubleBuffered = False
    TabOrder = 0
    Columns = 0
    FrameCreation = fcAll
    Rows = 0
    ItemHeight = 80
    ItemCount = 50
    ItemMinWidth = 180
    OnFrameCreate = AdvFrameView1FrameCreate
    OnFrameSelect = AdvFrameView1FrameSelect
    OnFrameUnSelect = AdvFrameView1FrameUnSelect
    inline Frame21: TFrame2
      Left = 416
      Top = 224
      Width = 197
      Height = 90
      Color = clBtnFace
      ParentBackground = False
      ParentColor = False
      TabOrder = 0
      ExplicitLeft = 416
      ExplicitTop = 224
      inherited CheckBox1: TCheckBox
        Left = 15
        ExplicitLeft = 15
      end
    end
  end
end
