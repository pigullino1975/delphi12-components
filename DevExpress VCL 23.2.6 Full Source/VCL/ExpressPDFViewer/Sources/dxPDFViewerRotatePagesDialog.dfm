object dxPDFViewerRotatePagesDialogForm: TdxPDFViewerRotatePagesDialogForm
  Left = 0
  Top = 0
  AutoSize = True
  BorderStyle = bsDialog
  Caption = 'Rotate Pages'
  ClientHeight = 498
  ClientWidth = 321
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poOwnerFormCenter
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object dxLayoutControl1: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 321
    Height = 498
    TabOrder = 0
    AutoSize = True
    LayoutLookAndFeel = dxLayoutCxLookAndFeel1
    object btnOk: TcxButton
      Left = 155
      Top = 239
      Width = 75
      Height = 25
      Caption = 'Ok'
      ModalResult = 1
      TabOrder = 2
    end
    object btnCancel: TcxButton
      Left = 236
      Top = 239
      Width = 75
      Height = 25
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 3
    end
    object cbRotation: TcxComboBox
      Left = 60
      Top = 10
      Properties.DropDownListStyle = lsFixedList
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 4
      Width = 251
    end
    object cbPageNumbers: TcxComboBox
      Left = 85
      Top = 177
      Properties.DropDownListStyle = lsFixedList
      Properties.OnChange = cbPageNumbersPropertiesChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 0
      Width = 214
    end
    object cbPageOrientation: TcxComboBox
      Left = 85
      Top = 202
      Properties.DropDownListStyle = lsFixedList
      Properties.OnChange = cbPageOrientationPropertiesChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 1
      Width = 214
    end
    object edPageRanges: TcxTextEdit
      Left = 80
      Top = 122
      Properties.ValidateOnEnter = True
      Properties.ValidationErrorIconAlignment = taRightJustify
      Properties.ValidationOptions = [evoShowErrorIcon, evoAllowLoseFocus]
      Properties.OnChange = edPageRangesPropertiesChange
      Properties.OnEditValueChanged = edPageRangesPropertiesEditValueChanged
      Properties.OnValidate = edPageRangesPropertiesValidate
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 5
      OnKeyPress = edPageRangesKeyPress
      Width = 219
    end
    object dxLayoutControl1Group_Root: TdxLayoutGroup
      AlignHorz = ahParentManaged
      AlignVert = avTop
      ButtonOptions.Buttons = <>
      Hidden = True
      ShowBorder = False
      Index = -1
    end
    object dxLayoutItem1: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup1
      AlignHorz = ahRight
      AlignVert = avBottom
      CaptionOptions.Text = 'cxButton1'
      CaptionOptions.Visible = False
      Control = btnOk
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lgPageRange: TdxLayoutGroup
      Parent = dxLayoutControl1Group_Root
      CaptionOptions.Text = 'Page Range'
      ButtonOptions.Buttons = <>
      Index = 3
    end
    object dxLayoutItem2: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup1
      AlignHorz = ahRight
      AlignVert = avClient
      CaptionOptions.Text = 'New Item'
      CaptionOptions.Visible = False
      Control = btnCancel
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutControl1Group_Root
      AlignVert = avBottom
      LayoutDirection = ldHorizontal
      Index = 1
    end
    object liRotation: TdxLayoutItem
      Parent = dxLayoutControl1Group_Root
      AlignHorz = ahClient
      SizeOptions.AssignedValues = [sovSizableHorz]
      SizeOptions.SizableHorz = False
      CaptionOptions.Text = 'Rotation:'
      Control = cbRotation
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 231
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object lrbPageRangeAll: TdxLayoutRadioButtonItem
      Parent = lgPageRange
      CaptionOptions.Text = 'All'
      OnClick = lrbPageRangeCustomClick
      Index = 0
    end
    object lrbPageRangeSelectedPages: TdxLayoutRadioButtonItem
      Parent = lgPageRange
      CaptionOptions.Text = 'Selected Pages'
      OnClick = lrbPageRangeCustomClick
      Index = 1
    end
    object lrbPageRangeCustom: TdxLayoutRadioButtonItem
      Parent = dxLayoutAutoCreatedGroup2
      CaptionOptions.Text = 'Pages:'
      OnClick = lrbPageRangeCustomClick
      Index = 0
    end
    object lrbPageRangeCurrentPage: TdxLayoutRadioButtonItem
      Parent = lgPageRange
      CaptionOptions.Text = 'Current Page'
      OnClick = lrbPageRangeCustomClick
      Index = 2
    end
    object liPageNumbers: TdxLayoutItem
      Parent = lgPageSubset
      CaptionOptions.Text = 'Numbers:'
      Control = cbPageNumbers
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object liPageOrientation: TdxLayoutItem
      Parent = lgPageSubset
      CaptionOptions.Text = 'Orientation:'
      Control = cbPageOrientation
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object liCustomPageRange: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup2
      AlignHorz = ahClient
      Control = edPageRanges
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lgPageSubset: TdxLayoutGroup
      Parent = dxLayoutControl1Group_Root
      AlignVert = avBottom
      CaptionOptions.Text = 'Page Subset'
      ButtonOptions.Buttons = <>
      Index = 0
    end
    object dxLayoutAutoCreatedGroup2: TdxLayoutAutoCreatedGroup
      Parent = lgPageRange
      LayoutDirection = ldHorizontal
      Index = 3
    end
  end
  object dxLayoutLookAndFeelList1: TdxLayoutLookAndFeelList
    Left = 248
    Top = 80
    object dxLayoutCxLookAndFeel1: TdxLayoutCxLookAndFeel
      PixelsPerInch = 96
    end
  end
end
