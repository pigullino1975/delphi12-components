object LayoutEditForm: TLayoutEditForm
  Left = 233
  Top = 209
  ActiveControl = cbDescriptions
  AutoSize = True
  BorderStyle = bsDialog
  Caption = 'LayoutEditForm'
  ClientHeight = 91
  ClientWidth = 284
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object LayoutControl: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 284
    Height = 91
    TabOrder = 0
    AutoSize = True
    object btnOK: TButton
      Left = 117
      Top = 57
      Width = 75
      Height = 23
      Caption = 'btnOK'
      Default = True
      ModalResult = 1
      TabOrder = 1
    end
    object btnCancel: TButton
      Left = 198
      Top = 57
      Width = 75
      Height = 23
      Cancel = True
      Caption = 'btnCancel'
      ModalResult = 2
      TabOrder = 2
    end
    object cbDescriptions: TComboBox
      Left = 11
      Top = 30
      Width = 262
      Height = 21
      Style = csDropDownList
      TabOrder = 0
    end
    object LayoutControl1Group0: TdxLayoutGroup
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Visible = False
      Hidden = True
      ShowBorder = False
      Index = -1
    end
    object LayoutControlItemEdit: TdxLayoutItem
      Parent = LayoutControl1Group0
      CaptionOptions.Text = 'Edit1'
      CaptionOptions.Layout = clTop
      Control = cbDescriptions
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 262
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutControl1Group1: TdxLayoutGroup
      Parent = LayoutControl1Group0
      AlignHorz = ahRight
      CaptionOptions.Visible = False
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 1
    end
    object dxLayoutControl1Item2: TdxLayoutItem
      Parent = dxLayoutControl1Group1
      CaptionOptions.Text = 'Button1'
      CaptionOptions.Visible = False
      Control = btnOK
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutControl1Item3: TdxLayoutItem
      Parent = dxLayoutControl1Group1
      CaptionOptions.Text = 'Button2'
      CaptionOptions.Visible = False
      Control = btnCancel
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 1
    end
  end
end
