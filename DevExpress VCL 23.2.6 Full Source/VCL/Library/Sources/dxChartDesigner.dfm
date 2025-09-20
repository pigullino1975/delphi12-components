object frmChartDesigner: TfrmChartDesigner
  Left = 0
  Top = 0
  Caption = 'frmChartDesigner'
  ClientHeight = 553
  ClientWidth = 840
  Color = clBtnFace
  Constraints.MinHeight = 500
  Constraints.MinWidth = 600
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  Position = poOwnerFormCenter
  ShowHint = True
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnKeyPress = FormKeyPress
  OnResize = FormResize
  OnShow = FormShow
  TextHeight = 13
  object lcMain: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 840
    Height = 553
    Align = alClient
    TabOrder = 0
    LayoutLookAndFeel = llfMain
    CustomizeFormTabbedView = True
    HighlightRoot = False
    object btnOk: TcxButton
      Left = 678
      Top = 519
      Width = 75
      Height = 25
      Caption = 'btnOk'
      ModalResult = 1
      TabOrder = 49
    end
    object btnCancel: TcxButton
      Left = 759
      Top = 519
      Width = 75
      Height = 25
      Action = aCancel
      ModalResult = 2
      TabOrder = 50
    end
    object btnClose: TcxButton
      Left = 597
      Top = 519
      Width = 75
      Height = 25
      Action = aClose
      TabOrder = 48
    end
    object seTitleMaxLineCount: TcxSpinEdit
      Left = 10000
      Top = 10000
      Properties.AssignedValues.MinValue = True
      Properties.OnChange = OptionDisplayValueChange
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 57
      Visible = False
      Width = 121
    end
    object cbTitleVisibility: TcxCheckBox
      Left = 10000
      Top = 10000
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 59
      Transparent = True
      Visible = False
    end
    object cbTitleWordWrap: TcxCheckBox
      Left = 10000
      Top = 10000
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 58
      Transparent = True
      Visible = False
    end
    object cbTitleDock: TcxComboBox
      Left = 10000
      Top = 10000
      Properties.DropDownListStyle = lsFixedList
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 63
      Visible = False
      Width = 121
    end
    object cbTitleAlignment: TcxComboBox
      Left = 10000
      Top = 10000
      Properties.DropDownListStyle = lsFixedList
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 61
      Visible = False
      Width = 121
    end
    object teTitleText: TcxTextEdit
      Left = 10000
      Top = 10000
      Properties.OnChange = OptionDisplayValueChange
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 60
      Visible = False
      Width = 121
    end
    object fncbAppearance: TcxFontNameComboBox
      Left = 10000
      Top = 10000
      Properties.FontPreview.ShowButtons = False
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 22
      Visible = False
      Width = 74
    end
    object seFontSize: TcxSpinEdit
      Left = 10000
      Top = 10000
      Properties.MinValue = 1.000000000000000000
      Properties.OnChange = OptionDisplayValueChange
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 23
      Value = 1
      Visible = False
      Width = 74
    end
    object ceFontColor: TdxColorEdit
      Left = 10000
      Top = 10000
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 24
      Width = 74
    end
    object seMarginTop: TcxSpinEdit
      Left = 10000
      Top = 10000
      Properties.OnChange = OptionDisplayValueChange
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 44
      Visible = False
      Width = 74
    end
    object seMarginBottom: TcxSpinEdit
      Left = 10000
      Top = 10000
      Properties.OnChange = OptionDisplayValueChange
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 47
      Visible = False
      Width = 74
    end
    object seMarginLeft: TcxSpinEdit
      Left = 10000
      Top = 10000
      Properties.OnChange = OptionDisplayValueChange
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 45
      Visible = False
      Width = 74
    end
    object seMarginRight: TcxSpinEdit
      Left = 10000
      Top = 10000
      Properties.OnChange = OptionDisplayValueChange
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 46
      Visible = False
      Width = 74
    end
    object seBorderWidth: TcxSpinEdit
      Left = 10000
      Top = 10000
      Properties.AssignedValues.MinValue = True
      Properties.OnChange = OptionDisplayValueChange
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 26
      Visible = False
      Width = 74
    end
    object ceBorderColor: TdxColorEdit
      Left = 10000
      Top = 10000
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 25
      Width = 74
    end
    object cbLegendAlignmentHorizontal: TcxComboBox
      Left = 10000
      Top = 10000
      Properties.DropDownListStyle = lsFixedList
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 52
      Visible = False
      Width = 121
    end
    object cbLegendAlignmentVertical: TcxComboBox
      Left = 10000
      Top = 10000
      Properties.DropDownListStyle = lsFixedList
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 53
      Visible = False
      Width = 121
    end
    object cbLegendDirection: TcxComboBox
      Left = 10000
      Top = 10000
      Properties.DropDownListStyle = lsFixedList
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 54
      Visible = False
      Width = 121
    end
    object sePaddingTop: TcxSpinEdit
      Left = 10000
      Top = 10000
      Properties.OnChange = OptionDisplayValueChange
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 39
      Visible = False
      Width = 74
    end
    object sePaddingLeft: TcxSpinEdit
      Left = 10000
      Top = 10000
      Properties.OnChange = OptionDisplayValueChange
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 40
      Visible = False
      Width = 74
    end
    object sePaddingRight: TcxSpinEdit
      Left = 10000
      Top = 10000
      Properties.OnChange = OptionDisplayValueChange
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 41
      Visible = False
      Width = 74
    end
    object sePaddingBottom: TcxSpinEdit
      Left = 10000
      Top = 10000
      Properties.OnChange = OptionDisplayValueChange
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 42
      Visible = False
      Width = 74
    end
    object ceBackgroundColor: TdxColorEdit
      Left = 10000
      Top = 10000
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 31
      Width = 74
    end
    object ceBackgroundGradientEndColor: TdxColorEdit
      Left = 10000
      Top = 10000
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 33
      Width = 74
    end
    object cbBackgroundMode: TcxComboBox
      Left = 10000
      Top = 10000
      Properties.DropDownListStyle = lsFixedList
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 30
      Visible = False
      Width = 74
    end
    object cbBackgroundGradientMode: TcxComboBox
      Left = 10000
      Top = 10000
      Properties.DropDownListStyle = lsFixedList
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 36
      Visible = False
      Width = 74
    end
    object ceBackgroundPatternColor: TdxColorEdit
      Left = 10000
      Top = 10000
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 34
      Width = 74
    end
    object icbBackgroundHatchStyle: TcxImageComboBox
      Left = 10000
      Top = 10000
      Properties.Images = ilHatch
      Properties.Items = <>
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 35
      Visible = False
      Width = 74
    end
    object iBackgroundTexture: TcxImage
      Left = 10000
      Top = 10000
      Properties.GraphicClassName = 'TdxSmartImage'
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 37
      Visible = False
      Height = 100
      Width = 74
    end
    object cbSeriesSortBy: TcxComboBox
      Left = 10000
      Top = 10000
      Properties.DropDownListStyle = lsFixedList
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 89
      Visible = False
      Width = 103
    end
    object cbSeriesSortOrder: TcxComboBox
      Left = 10000
      Top = 10000
      Properties.DropDownListStyle = lsFixedList
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 90
      Visible = False
      Width = 103
    end
    object cbSeriesShowInLegend: TcxComboBox
      Left = 10000
      Top = 10000
      Properties.DropDownListStyle = lsFixedList
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 88
      Visible = False
      Width = 124
    end
    object cbTopNMode: TcxComboBox
      Left = 10000
      Top = 10000
      Properties.DropDownListStyle = lsFixedList
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 92
      Visible = False
      Width = 100
    end
    object seTopNCount: TcxSpinEdit
      Left = 10000
      Top = 10000
      Properties.MinValue = 1.000000000000000000
      Properties.ValueType = vtInt
      Properties.OnChange = OptionDisplayValueChange
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 97
      Value = 1
      Visible = False
      Width = 121
    end
    object seTopNThresholdValue: TcxSpinEdit
      Left = 10000
      Top = 10000
      Properties.AssignedValues.MinValue = True
      Properties.ValueType = vtFloat
      Properties.OnChange = OptionDisplayValueChange
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 93
      Visible = False
      Width = 121
    end
    object seTopNThresholdPercent: TcxSpinEdit
      Left = 10000
      Top = 10000
      Properties.AssignedValues.MinValue = True
      Properties.MaxValue = 100.000000000000000000
      Properties.ValueType = vtFloat
      Properties.OnChange = OptionDisplayValueChange
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 95
      Visible = False
      Width = 121
    end
    object seLegendMaxCaptionWidth: TcxSpinEdit
      Left = 10000
      Top = 10000
      Properties.MinValue = 1.000000000000000000
      Properties.OnChange = OptionDisplayValueChange
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 51
      Value = 1
      Visible = False
      Width = 121
    end
    object btnDown: TcxButton
      Left = 33
      Top = 10
      Width = 23
      Height = 22
      Action = aDown
      SpeedButtonOptions.CanBeFocused = False
      TabOrder = 1
    end
    object btnUp: TcxButton
      Left = 10
      Top = 10
      Width = 23
      Height = 22
      Action = aUp
      SpeedButtonOptions.CanBeFocused = False
      TabOrder = 0
    end
    object seValueLabelsLineLength: TcxSpinEdit
      Left = 10000
      Top = 10000
      Properties.AssignedValues.MinValue = True
      Properties.ValueType = vtFloat
      Properties.OnChange = OptionDisplayValueChange
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 67
      Visible = False
      Width = 121
    end
    object seValueLabelsMaxWidth: TcxSpinEdit
      Left = 10000
      Top = 10000
      Properties.AssignedValues.MinValue = True
      Properties.ValueType = vtFloat
      Properties.OnChange = OptionDisplayValueChange
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 64
      Visible = False
      Width = 121
    end
    object seValueLabelsMaxLineCount: TcxSpinEdit
      Left = 10000
      Top = 10000
      Properties.AssignedValues.MinValue = True
      Properties.OnChange = OptionDisplayValueChange
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 65
      Visible = False
      Width = 121
    end
    object cbValueLabelsTextAlignment: TcxComboBox
      Left = 10000
      Top = 10000
      Properties.DropDownListStyle = lsFixedList
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 69
      Visible = False
      Width = 121
    end
    object teValueLabelsTextFormat: TcxTextEdit
      Left = 10000
      Top = 10000
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 68
      Visible = False
      Width = 121
    end
    object seMarkerSize: TcxSpinEdit
      Left = 10000
      Top = 10000
      Properties.AssignedValues.MinValue = True
      Properties.OnChange = OptionDisplayValueChange
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 55
      Visible = False
      Width = 151
    end
    object cbMarkerType: TcxComboBox
      Left = 10000
      Top = 10000
      Properties.DropDownListStyle = lsFixedList
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 56
      Visible = False
      Width = 156
    end
    object seWholeRangeMaxValue: TcxSpinEdit
      Left = 10000
      Top = 10000
      Properties.ValueType = vtFloat
      Properties.OnChange = OptionDisplayValueChange
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 78
      Visible = False
      Width = 121
    end
    object seWholeRangeMinValue: TcxSpinEdit
      Left = 10000
      Top = 10000
      Properties.ValueType = vtFloat
      Properties.OnChange = OptionDisplayValueChange
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 79
      Visible = False
      Width = 121
    end
    object seVisualRangeMaxValue: TcxSpinEdit
      Left = 10000
      Top = 10000
      Properties.ValueType = vtFloat
      Properties.OnChange = OptionDisplayValueChange
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 80
      Visible = False
      Width = 121
    end
    object seVisualRangeMinValue: TcxSpinEdit
      Left = 10000
      Top = 10000
      Properties.ValueType = vtFloat
      Properties.OnChange = OptionDisplayValueChange
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 86
      Visible = False
      Width = 121
    end
    object seAxisSideMargin: TcxSpinEdit
      Left = 10000
      Top = 10000
      Properties.ValueType = vtFloat
      Properties.OnChange = OptionDisplayValueChange
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 83
      Visible = False
      Width = 121
    end
    object ceAppearanceAxisGridlinesColor: TdxColorEdit
      Left = 10000
      Top = 10000
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 2
      Width = 74
    end
    object ceAppearanceAxisGridlinesMinorColor: TdxColorEdit
      Left = 10000
      Top = 10000
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 5
      Width = 74
    end
    object seAppearanceAxisThickness: TcxSpinEdit
      Left = 10000
      Top = 10000
      Properties.AssignedValues.MinValue = True
      Properties.ValueType = vtFloat
      Properties.OnChange = OptionDisplayValueChange
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 9
      Visible = False
      Width = 74
    end
    object seAppearanceAxisTicksThickness: TcxSpinEdit
      Left = 10000
      Top = 10000
      Properties.AssignedValues.MinValue = True
      Properties.ValueType = vtFloat
      Properties.OnChange = OptionDisplayValueChange
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 10
      Visible = False
      Width = 74
    end
    object seAppearanceAxisTicksLength: TcxSpinEdit
      Left = 10000
      Top = 10000
      Properties.AssignedValues.MinValue = True
      Properties.ValueType = vtFloat
      Properties.OnChange = OptionDisplayValueChange
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 11
      Visible = False
      Width = 74
    end
    object cbTitleAxisPosition: TcxComboBox
      Left = 10000
      Top = 10000
      Properties.DropDownListStyle = lsFixedList
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 62
      Visible = False
      Width = 97
    end
    object seDiagramDimension: TcxSpinEdit
      Left = 10000
      Top = 10000
      Properties.MinValue = 1.000000000000000000
      Properties.OnChange = OptionDisplayValueChange
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 70
      Value = 1
      Visible = False
      Width = 121
    end
    object cbDiagramLayoutDirection: TcxComboBox
      Left = 10000
      Top = 10000
      Properties.DropDownListStyle = lsFixedList
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 71
      Visible = False
      Width = 121
    end
    object seSeriesViewHoleRadius: TcxSpinEdit
      Left = 10000
      Top = 10000
      Properties.ValueType = vtFloat
      Properties.OnChange = OptionDisplayValueChange
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 99
      Visible = False
      Width = 121
    end
    object seSeriesViewStartAngle: TcxSpinEdit
      Left = 10000
      Top = 10000
      Properties.ValueType = vtFloat
      Properties.OnChange = OptionDisplayValueChange
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 94
      Visible = False
      Width = 121
    end
    object cbSeriesViewExplodedValueMode: TcxComboBox
      Left = 10000
      Top = 10000
      Properties.DropDownListStyle = lsFixedList
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 96
      Visible = False
      Width = 121
    end
    object cbSeriesViewSweepDirection: TcxComboBox
      Left = 10000
      Top = 10000
      Properties.DropDownListStyle = lsFixedList
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 98
      Visible = False
      Width = 121
    end
    object cbAxisAlignment: TcxComboBox
      Left = 10000
      Top = 10000
      Properties.DropDownListStyle = lsFixedList
      Properties.OnChange = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 81
      Visible = False
      Width = 121
    end
    object cbValueLabelsPosition: TcxComboBox
      Left = 10000
      Top = 10000
      Properties.DropDownListStyle = lsFixedList
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 66
      Visible = False
      Width = 121
    end
    object sePaddingAll: TcxSpinEdit
      Left = 10000
      Top = 10000
      Properties.UseNullString = True
      Properties.OnChange = OptionDisplayValueChange
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 38
      Visible = False
      Width = 74
    end
    object seMarginAll: TcxSpinEdit
      Left = 10000
      Top = 10000
      Properties.UseNullString = True
      Properties.OnChange = OptionDisplayValueChange
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 43
      Visible = False
      Width = 74
    end
    object seAxisMinorCount: TcxSpinEdit
      Left = 10000
      Top = 10000
      Properties.AssignedValues.MinValue = True
      Properties.OnChange = OptionDisplayValueChange
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 82
      Visible = False
      Width = 121
    end
    object seAppearanceAxisGridlinesThickness: TcxSpinEdit
      Left = 10000
      Top = 10000
      Properties.MinValue = 1.000000000000000000
      Properties.OnChange = OptionDisplayValueChange
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 4
      Value = 1
      Visible = False
      Width = 74
    end
    object seAppearanceAxisGridlinesMinorThickness: TcxSpinEdit
      Left = 10000
      Top = 10000
      Properties.MinValue = 1.000000000000000000
      Properties.OnChange = OptionDisplayValueChange
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 7
      Value = 1
      Visible = False
      Width = 74
    end
    object cbAppearanceAxisGridlinesStyle: TcxComboBox
      Left = 10000
      Top = 10000
      Properties.DropDownListStyle = lsFixedList
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 3
      Visible = False
      Width = 74
    end
    object cbAppearanceAxisGridlinesMinorStyle: TcxComboBox
      Left = 10000
      Top = 10000
      Properties.DropDownListStyle = lsFixedList
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 6
      Visible = False
      Width = 74
    end
    object cbAxisValueLabelsAlignment: TcxComboBox
      Left = 10000
      Top = 10000
      Properties.DropDownListStyle = lsFixedList
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 75
      Visible = False
      Width = 76
    end
    object cbAxisValueLabelsPosition: TcxComboBox
      Left = 10000
      Top = 10000
      Properties.DropDownListStyle = lsFixedList
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 73
      Visible = False
      Width = 76
    end
    object seAxisValueLabelsMaxLineCount: TcxSpinEdit
      Left = 10000
      Top = 10000
      Properties.AssignedValues.MinValue = True
      Properties.OnChange = OptionDisplayValueChange
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 77
      Visible = False
      Width = 76
    end
    object seAxisValueLabelsMaxWidth: TcxSpinEdit
      Left = 10000
      Top = 10000
      Properties.AssignedValues.MinValue = True
      Properties.ValueType = vtFloat
      Properties.OnChange = OptionDisplayValueChange
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 72
      Visible = False
      Width = 76
    end
    object seAxisValueLabelsAngle: TcxSpinEdit
      Left = 10000
      Top = 10000
      Properties.ValueType = vtFloat
      Properties.OnChange = OptionDisplayValueChange
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 74
      Visible = False
      Width = 76
    end
    object seAxisValueLabelsResolveOverlappingIndent: TcxSpinEdit
      Left = 10000
      Top = 10000
      Properties.AssignedValues.MinValue = True
      Properties.ValueType = vtFloat
      Properties.OnChange = OptionDisplayValueChange
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 76
      Visible = False
      Width = 76
    end
    object cbAxisTicksCrossKind: TcxComboBox
      Left = 10000
      Top = 10000
      Properties.DropDownListStyle = lsFixedList
      Properties.OnChange = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 84
      Visible = False
      Width = 117
    end
    object cbAxisTicksMinorCrossKind: TcxComboBox
      Left = 10000
      Top = 10000
      Properties.DropDownListStyle = lsFixedList
      Properties.OnChange = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 85
      Visible = False
      Width = 117
    end
    object seAppearanceAxisTicksMinorThickness: TcxSpinEdit
      Left = 10000
      Top = 10000
      Properties.AssignedValues.MinValue = True
      Properties.ValueType = vtFloat
      Properties.OnChange = OptionDisplayValueChange
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 12
      Visible = False
      Width = 74
    end
    object seAppearanceAxisTicksMinorLength: TcxSpinEdit
      Left = 10000
      Top = 10000
      Properties.AssignedValues.MinValue = True
      Properties.ValueType = vtFloat
      Properties.OnChange = OptionDisplayValueChange
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 13
      Visible = False
      Width = 74
    end
    object cbAppearanceAxisInterlacedMode: TcxComboBox
      Left = 10000
      Top = 10000
      Properties.DropDownListStyle = lsFixedList
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 14
      Visible = False
      Width = 74
    end
    object ceAppearanceAxisInterlacedColor: TdxColorEdit
      Left = 10000
      Top = 10000
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 15
      Width = 74
    end
    object ceAppearanceAxisInterlacedGradientEndColor: TdxColorEdit
      Left = 10000
      Top = 10000
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 17
      Width = 74
    end
    object ceAppearanceAxisInterlacedPattern: TdxColorEdit
      Left = 10000
      Top = 10000
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 18
      Width = 74
    end
    object icbAppearanceAxisInterlacedStyle: TcxImageComboBox
      Left = 10000
      Top = 10000
      Properties.Images = ilHatch
      Properties.Items = <>
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 19
      Visible = False
      Width = 74
    end
    object cbAppearanceAxisInterlacedGradient: TcxComboBox
      Left = 10000
      Top = 10000
      Properties.DropDownListStyle = lsFixedList
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 20
      Visible = False
      Width = 74
    end
    object iAppearanceAxisInterlacedTexture: TcxImage
      Left = 10000
      Top = 10000
      Properties.GraphicClassName = 'TdxSmartImage'
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 21
      Visible = False
      Height = 100
      Width = 74
    end
    object ceAppearanceAxisColor: TdxColorEdit
      Left = 10000
      Top = 10000
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 8
      Width = 74
    end
    object ceAppearanceStrokeColor: TdxColorEdit
      Left = 10000
      Top = 10000
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 27
      Width = 74
    end
    object seAppearanceStrokeThickness: TcxSpinEdit
      Left = 10000
      Top = 10000
      Properties.AssignedValues.MinValue = True
      Properties.OnChange = OptionDisplayValueChange
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 29
      Visible = False
      Width = 74
    end
    object cbAppearanceStrokeStyle: TcxComboBox
      Left = 10000
      Top = 10000
      Properties.DropDownListStyle = lsFixedList
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 28
      Visible = False
      Width = 74
    end
    object seSeriesBarWidth: TcxSpinEdit
      Left = 10000
      Top = 10000
      Properties.AssignedValues.MinValue = True
      Properties.ValueType = vtFloat
      Properties.OnChange = OptionDisplayValueChange
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 91
      Visible = False
      Width = 79
    end
    object ceAppearanceAxisInterlacedGradientBeginColor: TdxColorEdit
      Left = 10000
      Top = 10000
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 16
      Width = 74
    end
    object ceBackgroundGradientBeginColor: TdxColorEdit
      Left = 10000
      Top = 10000
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 32
      Width = 74
    end
    object teSeriesCaption: TcxTextEdit
      Left = 10000
      Top = 10000
      Properties.OnChange = OptionDisplayValueChange
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 87
      Text = 'teSeriesCaption'
      Visible = False
      Width = 121
    end
    object seValueLabelsResolveOverlappingIndent: TcxSpinEdit
      Left = 10000
      Top = 10000
      Properties.AssignedValues.MinValue = True
      Properties.ValueType = vtInt
      Properties.OnChange = OptionDisplayValueChange
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 100
      Visible = False
      Width = 76
    end
    object cbValueLabelsResolveOverlappingMode: TcxComboBox
      Left = 10000
      Top = 10000
      Properties.DropDownListStyle = lsFixedList
      Properties.OnEditValueChanged = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 101
      Visible = False
      Width = 121
    end
    object cbAxisTicksLabelAlignment: TcxComboBox
      Left = 10000
      Top = 10000
      Properties.DropDownListStyle = lsFixedList
      Properties.OnChange = OptionEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 102
      Visible = False
      Width = 87
    end
    object lcMainGroup_Root: TdxLayoutGroup
      AlignHorz = ahClient
      AlignVert = avClient
      Hidden = True
      ShowBorder = False
      Index = -1
    end
    object dxLayoutGroup1: TdxLayoutGroup
      Parent = lgMain
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'Toolbar'
      Hidden = True
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 0
    end
    object lgAllOptions: TdxLayoutGroup
      Parent = dxLayoutGroup8
      AlignHorz = ahRight
      CaptionOptions.Text = 'options'
      SizeOptions.Width = 200
      LayoutDirection = ldTabbed
      ShowBorder = False
      Index = 2
    end
    object lbButtons: TdxLayoutGroup
      Parent = lcMainGroup_Root
      AlignHorz = ahRight
      AlignVert = avBottom
      CaptionOptions.Text = 'buttons'
      Hidden = True
      ItemIndex = 1
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 1
    end
    object lgMain: TdxLayoutGroup
      Parent = dxLayoutGroup8
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'New Group'
      Hidden = True
      ItemIndex = 1
      ShowBorder = False
      Index = 0
    end
    object dxLayoutGroup7: TdxLayoutGroup
      Parent = lgMain
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'New Group'
      Hidden = True
      ItemIndex = 2
      LayoutDirection = ldHorizontal
      ShowBorder = False
      UseIndent = False
      Index = 1
    end
    object dxLayoutGroup8: TdxLayoutGroup
      Parent = lcMainGroup_Root
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'New Group'
      Hidden = True
      ItemIndex = 2
      LayoutDirection = ldHorizontal
      ShowBorder = False
      UseIndent = False
      Index = 0
    end
    object lsiTreeView: TdxLayoutSplitterItem
      Parent = dxLayoutGroup7
      AlignHorz = ahLeft
      Offsets.Left = 2
      Offsets.Right = 2
      SizeOptions.AssignedValues = [sovSizableHorz, sovSizableVert]
      SizeOptions.SizableHorz = False
      SizeOptions.SizableVert = False
      CaptionOptions.Text = 'Splitter'
      OnCanResize = lsiTreeViewCanResize
      Index = 1
    end
    object lsiOptions: TdxLayoutSplitterItem
      Parent = dxLayoutGroup8
      AlignHorz = ahRight
      Offsets.Left = 2
      Offsets.Right = 2
      SizeOptions.AssignedValues = [sovSizableHorz, sovSizableVert]
      SizeOptions.SizableHorz = False
      SizeOptions.SizableVert = False
      CaptionOptions.Text = 'Splitter'
      OnCanResize = lsiOptionsCanResize
      Index = 1
    end
    object liTreeView: TdxLayoutItem
      Parent = dxLayoutGroup7
      AlignHorz = ahLeft
      AlignVert = avClient
      CaptionOptions.Text = 'dxNewTreeView1'
      ControlOptions.OriginalHeight = 100
      ControlOptions.OriginalWidth = 200
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lgOptions: TdxLayoutGroup
      Parent = lgAllOptions
      CaptionOptions.Text = 'Options'
      ScrollOptions.Vertical = smAuto
      Index = 0
    end
    object liOk: TdxLayoutItem
      Parent = lbButtons
      AlignHorz = ahRight
      AlignVert = avTop
      CaptionOptions.Text = 'cxButton1'
      CaptionOptions.Visible = False
      Control = btnOk
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object liCancel: TdxLayoutItem
      Parent = lbButtons
      AlignHorz = ahRight
      AlignVert = avTop
      CaptionOptions.Text = 'cxButton2'
      CaptionOptions.Visible = False
      Control = btnCancel
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object liChartControl: TdxLayoutItem
      Parent = dxLayoutGroup7
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'Chart Control'
      ControlOptions.OriginalHeight = 250
      ControlOptions.OriginalWidth = 300
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object liClose: TdxLayoutItem
      Parent = lbButtons
      AlignHorz = ahRight
      AlignVert = avTop
      CaptionOptions.Text = 'New Item'
      CaptionOptions.Visible = False
      Control = btnClose
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lgDiagramOptions: TdxLayoutGroup
      CaptionOptions.Text = 'Diagram Options'
      Hidden = True
      ShowBorder = False
      Index = -1
    end
    object lgSeriesOptions: TdxLayoutGroup
      CaptionOptions.Text = 'Series'
      Hidden = True
      ShowBorder = False
      Index = -1
    end
    object lliOptionsGeneral: TdxLayoutLabeledItem
      Parent = lgOptionsGeneral
      LayoutLookAndFeel = llfGroupCaptions
      Offsets.Bottom = -3
      CaptionOptions.Text = 'GENERAL'
      Index = 0
    end
    object lsiOptionsGeneral: TdxLayoutSeparatorItem
      Parent = lgOptionsGeneral
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object lgAppearance: TdxLayoutGroup
      Parent = lgAllOptions
      CaptionOptions.Text = 'Appearance'
      Visible = False
      ScrollOptions.Vertical = smAuto
      ShowBorder = False
      Index = 1
    end
    object lgLegend: TdxLayoutGroup
      CaptionOptions.Text = 'Legend'
      Hidden = True
      ShowBorder = False
      Index = -1
    end
    object lgTitle: TdxLayoutGroup
      CaptionOptions.Text = 'New Group'
      ShowBorder = False
      Index = -1
    end
    object lgTitles: TdxLayoutGroup
      CaptionOptions.Text = 'Titles'
      ShowBorder = False
      Index = -1
    end
    object liTitleVisible: TdxLayoutItem
      Parent = lgTitleGeneral
      CaptionOptions.Text = 'Visibility:'
      Control = cbTitleVisibility
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 84
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object liTitleWordWrap: TdxLayoutItem
      Parent = lgTitleGeneral
      CaptionOptions.Text = 'Word Wrap:'
      Control = cbTitleWordWrap
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 84
      ControlOptions.ShowBorder = False
      Index = 5
    end
    object liTitleMaxLineCount: TdxLayoutItem
      Parent = lgTitleGeneral
      CaptionOptions.Text = 'Max Line Count:'
      Control = seTitleMaxLineCount
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 6
    end
    object liTitleDock: TdxLayoutItem
      Parent = lgTitleGeneral
      CaptionOptions.Text = 'Dock:'
      Control = cbTitleDock
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object liTitleAlignment: TdxLayoutItem
      Parent = lgTitleGeneral
      CaptionOptions.Text = 'Alignment:'
      Control = cbTitleAlignment
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object lgOptionsGeneral: TdxLayoutGroup
      CaptionOptions.Text = 'General'
      ShowBorder = False
      UseIndent = False
      Index = -1
    end
    object liTitleText: TdxLayoutItem
      Parent = lgTitleGeneral
      CaptionOptions.Text = 'Text:'
      Control = teTitleText
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lliFont: TdxLayoutLabeledItem
      Parent = dxLayoutGroup2
      LayoutLookAndFeel = llfGroupCaptions
      Offsets.Bottom = -3
      CaptionOptions.Text = 'FONT'
      Index = 0
    end
    object lsiFont: TdxLayoutSeparatorItem
      Parent = dxLayoutGroup2
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object dxLayoutGroup2: TdxLayoutGroup
      Parent = lgAppearanceFont
      CaptionOptions.Text = 'New Group'
      ShowBorder = False
      UseIndent = False
      Index = 0
    end
    object liFontName: TdxLayoutItem
      Parent = lgAppearanceFont
      CaptionOptions.Text = 'Name:'
      Control = fncbAppearance
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object liFontSize: TdxLayoutItem
      Parent = lgAppearanceFont
      CaptionOptions.Text = 'Size:'
      Control = seFontSize
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object lcbiFontBold: TdxLayoutCheckBoxItem
      Parent = lgFontStyle
      CaptionOptions.Text = 'Bold'
      OnClick = OptionEditValueChanged
      Index = 0
    end
    object lcbiFontItalic: TdxLayoutCheckBoxItem
      Parent = lgFontStyle
      CaptionOptions.Text = 'Italic'
      OnClick = OptionEditValueChanged
      Index = 1
    end
    object lcbiFontUnderline: TdxLayoutCheckBoxItem
      Parent = lgFontStyle
      CaptionOptions.Text = 'Underline'
      OnClick = OptionEditValueChanged
      Index = 2
    end
    object lcbiFontStrikeout: TdxLayoutCheckBoxItem
      Parent = lgFontStyle
      CaptionOptions.Text = 'Strikethrough'
      OnClick = OptionEditValueChanged
      Index = 3
    end
    object liFontColor: TdxLayoutItem
      Parent = lgAppearanceFont
      CaptionOptions.Text = 'Color:'
      Control = ceFontColor
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 5
    end
    object lgAppearanceFont: TdxLayoutGroup
      Parent = lgAppearance
      CaptionOptions.Text = 'New Group'
      ShowBorder = False
      Index = 6
    end
    object lgAppearanceMargins: TdxLayoutGroup
      Parent = lgAppearance
      CaptionOptions.Text = 'Margins'
      ShowBorder = False
      Index = 11
    end
    object lliMargins: TdxLayoutLabeledItem
      Parent = dxLayoutGroup3
      LayoutLookAndFeel = llfGroupCaptions
      Offsets.Bottom = -3
      CaptionOptions.Text = 'MARGINS'
      Index = 0
    end
    object dxLayoutGroup3: TdxLayoutGroup
      Parent = lgAppearanceMargins
      CaptionOptions.Text = 'New Group'
      ShowBorder = False
      UseIndent = False
      Index = 0
    end
    object dxLayoutSeparatorItem1: TdxLayoutSeparatorItem
      Parent = dxLayoutGroup3
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object liMarginTop: TdxLayoutItem
      Parent = lgAppearanceMargins
      CaptionOptions.Text = 'Top'
      Control = seMarginTop
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 40
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object liMarginBottom: TdxLayoutItem
      Parent = lgAppearanceMargins
      CaptionOptions.Text = 'Bottom'
      Control = seMarginBottom
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 40
      ControlOptions.ShowBorder = False
      Index = 5
    end
    object liMarginLeft: TdxLayoutItem
      Parent = lgAppearanceMargins
      CaptionOptions.Text = 'Left'
      Control = seMarginLeft
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 40
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object liMarginRight: TdxLayoutItem
      Parent = lgAppearanceMargins
      CaptionOptions.Text = 'Right'
      Control = seMarginRight
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 40
      ControlOptions.ShowBorder = False
      Index = 4
    end
    object lgAppearanceBorder: TdxLayoutGroup
      Parent = lgAppearance
      CaptionOptions.Text = 'Appearance Border'
      ItemIndex = 3
      ShowBorder = False
      Index = 7
    end
    object lgTitleGeneral: TdxLayoutGroup
      Parent = lgTitle
      CaptionOptions.Text = 'Title General'
      Offsets.Bottom = 10
      ItemIndex = 4
      ShowBorder = False
      Index = 0
    end
    object lliBorder: TdxLayoutLabeledItem
      Parent = dxLayoutGroup4
      LayoutLookAndFeel = llfGroupCaptions
      Offsets.Bottom = -3
      CaptionOptions.Text = 'BORDER'
      Index = 0
    end
    object dxLayoutSeparatorItem2: TdxLayoutSeparatorItem
      Parent = dxLayoutGroup4
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object dxLayoutGroup4: TdxLayoutGroup
      Parent = lgAppearanceBorder
      CaptionOptions.Text = 'New Group'
      ShowBorder = False
      UseIndent = False
      Index = 0
    end
    object liBorderColor: TdxLayoutItem
      Parent = lgAppearanceBorder
      CaptionOptions.Text = 'Color:'
      Control = ceBorderColor
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object liBorderWidth: TdxLayoutItem
      Parent = lgAppearanceBorder
      CaptionOptions.Text = 'Width:'
      Control = seBorderWidth
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object lgAppearanceOther: TdxLayoutGroup
      CaptionOptions.Text = 'Appearance Other'
      ItemControlAreaAlignment = catOwn
      ShowBorder = False
      Index = -1
    end
    object lliAppearanceOther: TdxLayoutLabeledItem
      Parent = dxLayoutGroup5
      LayoutLookAndFeel = llfGroupCaptions
      Offsets.Bottom = -3
      CaptionOptions.Text = 'OTHER'
      Index = 0
    end
    object dxLayoutSeparatorItem3: TdxLayoutSeparatorItem
      Parent = dxLayoutGroup5
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object dxLayoutGroup5: TdxLayoutGroup
      Parent = lgAppearanceOther
      CaptionOptions.Text = 'New Group'
      ShowBorder = False
      UseIndent = False
      Index = 0
    end
    object lgFontStyle: TdxLayoutGroup
      Parent = lgAppearanceFont
      CaptionOptions.Text = 'Style'
      ItemIndex = 3
      ShowBorder = False
      WrapItemsMode = wmImmediateChildren
      Index = 4
    end
    object lcbiTitlesVisible: TdxLayoutCheckBoxItem
      Parent = lgTitlesGeneral
      CaptionOptions.Text = 'Visibility:'
      CaptionOptions.Layout = clLeft
      OnClick = OptionEditValueChanged
      Index = 0
    end
    object lcbiLegendVisible: TdxLayoutCheckBoxItem
      Parent = lgLegendGeneral
      CaptionOptions.Text = 'Visibility:'
      CaptionOptions.Layout = clLeft
      OnClick = OptionEditValueChanged
      Index = 0
    end
    object liLegendDirection: TdxLayoutItem
      Parent = lgLegendLayout
      CaptionOptions.Text = 'Direction:'
      Control = cbLegendDirection
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object lcbiLegendCaptions: TdxLayoutCheckBoxItem
      Parent = lgLegendGeneral
      CaptionOptions.Text = 'Captions:'
      CaptionOptions.Layout = clLeft
      OnClick = OptionEditValueChanged
      Index = 1
    end
    object lcbiLegendButtons: TdxLayoutCheckBoxItem
      Parent = lgLegendGeneral
      CaptionOptions.Text = 'Buttons:'
      CaptionOptions.Layout = clLeft
      OnClick = OptionEditValueChanged
      Index = 3
    end
    object lcbiLegendImages: TdxLayoutCheckBoxItem
      Parent = lgLegendGeneral
      CaptionOptions.Text = 'Images:'
      CaptionOptions.Layout = clLeft
      OnClick = OptionEditValueChanged
      Index = 4
    end
    object lgLegendGeneral: TdxLayoutGroup
      Parent = lgLegend
      CaptionOptions.Text = 'New Group'
      Offsets.Bottom = 10
      ItemIndex = 2
      ShowBorder = False
      Index = 0
    end
    object lgLegendLayout: TdxLayoutGroup
      Parent = lgLegend
      CaptionOptions.Text = 'New Group'
      Offsets.Bottom = 10
      ShowBorder = False
      Index = 1
    end
    object lgOptionsLayout: TdxLayoutGroup
      CaptionOptions.Text = 'Layout'
      ItemIndex = 1
      ShowBorder = False
      UseIndent = False
      Index = -1
    end
    object dxLayoutSeparatorItem4: TdxLayoutSeparatorItem
      Parent = lgOptionsLayout
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object lliOptionsLayout: TdxLayoutLabeledItem
      Parent = lgOptionsLayout
      LayoutLookAndFeel = llfGroupCaptions
      Offsets.Bottom = -3
      CaptionOptions.Text = 'LAYOUT'
      Index = 0
    end
    object liLegendAlignmentHorizontal: TdxLayoutItem
      Parent = lgLegendLayout
      CaptionOptions.Text = 'Horizontal:'
      Control = cbLegendAlignmentHorizontal
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object liLegendAlignmentVertical: TdxLayoutItem
      Parent = lgLegendLayout
      CaptionOptions.Text = 'Vertical:'
      Control = cbLegendAlignmentVertical
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lcbiFont: TdxLayoutCheckBoxItem
      Parent = lgAppearanceFont
      CaptionOptions.Text = 'Parent Font:'
      CaptionOptions.Layout = clLeft
      OnClick = OptionEditValueChanged
      Index = 1
    end
    object lcbiBorder: TdxLayoutCheckBoxItem
      Parent = lgAppearanceBorder
      CaptionOptions.Text = 'Border'
      CaptionOptions.Layout = clLeft
      CheckBoxOptions.AllowGrayed = True
      OnClick = OptionEditValueChanged
      Index = 1
    end
    object lgAppearancePadding: TdxLayoutGroup
      Parent = lgAppearance
      CaptionOptions.Text = 'Appearance Padding'
      ShowBorder = False
      Index = 10
    end
    object lliPadding: TdxLayoutLabeledItem
      Parent = dxLayoutGroup11
      LayoutLookAndFeel = llfGroupCaptions
      Offsets.Bottom = -3
      CaptionOptions.Text = 'PADDING'
      Index = 0
    end
    object dxLayoutSeparatorItem5: TdxLayoutSeparatorItem
      Parent = dxLayoutGroup11
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object dxLayoutGroup11: TdxLayoutGroup
      Parent = lgAppearancePadding
      CaptionOptions.Text = 'New Group'
      ShowBorder = False
      UseIndent = False
      Index = 0
    end
    object liPaddingTop: TdxLayoutItem
      Parent = lgAppearancePadding
      CaptionOptions.Text = 'Top'
      Control = sePaddingTop
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 40
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object liPaddingBottom: TdxLayoutItem
      Parent = lgAppearancePadding
      CaptionOptions.Text = 'Bottom'
      Control = sePaddingBottom
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 40
      ControlOptions.ShowBorder = False
      Index = 5
    end
    object liPaddingLeft: TdxLayoutItem
      Parent = lgAppearancePadding
      CaptionOptions.Text = 'Left'
      Control = sePaddingLeft
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 40
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object liPaddingRight: TdxLayoutItem
      Parent = lgAppearancePadding
      CaptionOptions.ShowAccelChar = False
      CaptionOptions.Text = 'Right'
      Control = sePaddingRight
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 40
      ControlOptions.ShowBorder = False
      Index = 4
    end
    object lgAppearanceBackground: TdxLayoutGroup
      Parent = lgAppearance
      CaptionOptions.Text = 'Appearance Background'
      ItemIndex = 4
      ShowBorder = False
      Index = 9
    end
    object lliBackground: TdxLayoutLabeledItem
      Parent = dxLayoutGroup12
      LayoutLookAndFeel = llfGroupCaptions
      Offsets.Bottom = -3
      CaptionOptions.Text = 'BACKGROUND'
      Index = 0
    end
    object dxLayoutSeparatorItem6: TdxLayoutSeparatorItem
      Parent = dxLayoutGroup12
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object liBackgroundColor: TdxLayoutItem
      Parent = lgAppearanceBackground
      CaptionOptions.Text = 'Color:'
      Control = ceBackgroundColor
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 116
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object liBackgroundGradientEndColor: TdxLayoutItem
      Parent = lgAppearanceBackground
      CaptionOptions.Text = 'End Color'
      Control = ceBackgroundGradientEndColor
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 116
      ControlOptions.ShowBorder = False
      Index = 5
    end
    object liBackgroundMode: TdxLayoutItem
      Parent = lgAppearanceBackground
      CaptionOptions.Text = 'Mode:'
      Control = cbBackgroundMode
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object liBackgroundHatchStyle: TdxLayoutItem
      Parent = lgAppearanceBackground
      CaptionOptions.Text = 'Style:'
      Control = icbBackgroundHatchStyle
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 7
    end
    object liBackgroundGradientMode: TdxLayoutItem
      Parent = lgAppearanceBackground
      CaptionOptions.Text = 'Gradient:'
      Control = cbBackgroundGradientMode
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 102
      ControlOptions.ShowBorder = False
      Index = 8
    end
    object dxLayoutGroup12: TdxLayoutGroup
      Parent = lgAppearanceBackground
      CaptionOptions.Text = 'New Group'
      ShowBorder = False
      UseIndent = False
      Index = 0
    end
    object lcbiParentBackground: TdxLayoutCheckBoxItem
      Parent = lgAppearanceBackground
      CaptionOptions.Text = 'Background'
      CaptionOptions.Layout = clLeft
      OnClick = OptionEditValueChanged
      Index = 1
    end
    object liBackgroundPatternColor: TdxLayoutItem
      Parent = lgAppearanceBackground
      CaptionOptions.Text = 'Pattern:'
      Control = ceBackgroundPatternColor
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 824
      ControlOptions.ShowBorder = False
      Index = 6
    end
    object liBackgroundTexture: TdxLayoutItem
      Parent = lgAppearanceBackground
      CaptionOptions.Text = 'Texture'
      Control = iBackgroundTexture
      ControlOptions.OriginalHeight = 100
      ControlOptions.OriginalWidth = 140
      ControlOptions.ShowBorder = False
      Index = 9
    end
    object lgSeriesGeneral: TdxLayoutGroup
      Parent = lgSeriesOptions
      CaptionOptions.Text = 'Series General'
      Hidden = True
      ItemIndex = 1
      ShowBorder = False
      Index = 0
    end
    object lcbiSeriesVisible: TdxLayoutCheckBoxItem
      Parent = lgSeriesGeneral
      CaptionOptions.Text = 'Visibility'
      CaptionOptions.Layout = clLeft
      OnClick = OptionEditValueChanged
      Index = 0
    end
    object liSeriesSortBy: TdxLayoutItem
      Parent = lgSeriesGeneral
      CaptionOptions.Text = 'Sort By'
      Control = cbSeriesSortBy
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 103
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object liSeriesSortOrder: TdxLayoutItem
      Parent = lgSeriesGeneral
      CaptionOptions.Text = 'Sort Order'
      Control = cbSeriesSortOrder
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 103
      ControlOptions.ShowBorder = False
      Index = 4
    end
    object liSeriesShowInLegend: TdxLayoutItem
      Parent = lgSeriesGeneral
      CaptionOptions.Text = 'Show in Legend'
      Control = cbSeriesShowInLegend
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 124
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object lgSeriesTopNOptions: TdxLayoutGroup
      Parent = lgSeriesOptions
      CaptionOptions.Text = 'Top N Option'
      Hidden = True
      ShowBorder = False
      Index = 1
    end
    object dxLayoutGroup13: TdxLayoutGroup
      Parent = lgSeriesTopNOptions
      CaptionOptions.Text = 'New Group'
      Hidden = True
      ItemIndex = 1
      ShowBorder = False
      UseIndent = False
      Index = 0
    end
    object dxLayoutSeparatorItem7: TdxLayoutSeparatorItem
      Parent = dxLayoutGroup13
      AlignVert = avClient
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object lliSeriesTopN: TdxLayoutLabeledItem
      Parent = dxLayoutGroup13
      LayoutLookAndFeel = llfGroupCaptions
      Offsets.Bottom = -3
      CaptionOptions.Text = 'TOP N'
      Index = 0
    end
    object lcbiSeriesTopNEnabled: TdxLayoutCheckBoxItem
      Parent = lgSeriesTopNOptions
      CaptionOptions.Text = 'Enabled'
      CaptionOptions.Layout = clLeft
      OnClick = OptionEditValueChanged
      Index = 1
    end
    object liTopNMode: TdxLayoutItem
      Parent = lgSeriesTopNOptions
      CaptionOptions.Text = 'Mode'
      Control = cbTopNMode
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 100
      ControlOptions.ShowBorder = False
      OnCaptionClick = OptionEditValueChanged
      Index = 2
    end
    object lcbiTopNShowOthers: TdxLayoutCheckBoxItem
      Parent = lgSeriesTopNOptions
      CaptionOptions.Text = 'Show Others'
      CaptionOptions.Layout = clLeft
      OnClick = OptionEditValueChanged
      Index = 6
    end
    object liTopNThresholdPercent: TdxLayoutItem
      Parent = lgSeriesTopNOptions
      CaptionOptions.Text = 'Threshold Percent'
      Control = seTopNThresholdPercent
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 4
    end
    object liTopNCount: TdxLayoutItem
      Parent = lgSeriesTopNOptions
      CaptionOptions.Text = 'Count'
      Control = seTopNCount
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 5
    end
    object liTopNThresholdValue: TdxLayoutItem
      Parent = lgSeriesTopNOptions
      CaptionOptions.Text = 'Threshold Value'
      Control = seTopNThresholdValue
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object liLegendMaxCaptionWidth: TdxLayoutItem
      Parent = lgLegendGeneral
      CaptionOptions.Text = 'Max Caption Width'
      Control = seLegendMaxCaptionWidth
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutItem9: TdxLayoutItem
      Parent = dxLayoutGroup15
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Text = 'New Item'
      CaptionOptions.Visible = False
      Control = btnUp
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 23
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem10: TdxLayoutItem
      Parent = dxLayoutGroup15
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Text = 'New Item'
      CaptionOptions.Visible = False
      Control = btnDown
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 23
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutGroup15: TdxLayoutGroup
      Parent = dxLayoutGroup1
      CaptionOptions.Text = 'New Group'
      Offsets.Right = 10
      Hidden = True
      LayoutDirection = ldHorizontal
      ShowBorder = False
      UseIndent = False
      Index = 0
    end
    object lgValueLabels: TdxLayoutGroup
      CaptionOptions.Text = 'Values Label'
      Hidden = True
      ShowBorder = False
      Index = -1
    end
    object lgValueLabelsGeneral: TdxLayoutGroup
      Parent = lgValueLabels
      CaptionOptions.Text = 'General'
      Offsets.Bottom = 10
      Hidden = True
      ItemIndex = 1
      ShowBorder = False
      Index = 0
    end
    object lgValueLabelsText: TdxLayoutGroup
      Parent = lgValueLabels
      CaptionOptions.Text = 'Text Options'
      Hidden = True
      ItemIndex = 1
      ShowBorder = False
      Index = 1
    end
    object lcbiValueLabelsVisible: TdxLayoutCheckBoxItem
      Parent = lgValueLabelsGeneral
      CaptionOptions.Text = 'Visible'
      CaptionOptions.Layout = clLeft
      OnClick = OptionEditValueChanged
      Index = 0
    end
    object lcbiValueLabelsLineVisible: TdxLayoutCheckBoxItem
      Parent = lgValueLabelsGeneral
      CaptionOptions.Text = 'Line'
      CaptionOptions.Layout = clLeft
      CheckBoxOptions.AllowGrayed = True
      OnClick = OptionEditValueChanged
      Index = 2
    end
    object liValueLabelsLineLength: TdxLayoutItem
      Parent = lgValueLabelsGeneral
      CaptionOptions.Text = 'Line Length'
      Control = seValueLabelsLineLength
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object liValueLabelsAlignment: TdxLayoutItem
      Parent = lgValueLabelsText
      CaptionOptions.Text = 'Alignment'
      Control = cbValueLabelsTextAlignment
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object liValueLabelsFormat: TdxLayoutItem
      Parent = lgValueLabelsText
      CaptionOptions.Text = 'Format'
      Control = teValueLabelsTextFormat
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object liValueLabelsMaxWidth: TdxLayoutItem
      Parent = lgValueLabelsText
      CaptionOptions.Text = 'MaxWidth'
      Control = seValueLabelsMaxWidth
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object liValueLabelsMaxLineCount: TdxLayoutItem
      Parent = lgValueLabelsText
      CaptionOptions.Text = 'Max Line Count'
      Control = seValueLabelsMaxLineCount
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 4
    end
    object lliTextOptions: TdxLayoutLabeledItem
      Parent = lgValueLabelsTextCaption
      LayoutLookAndFeel = llfGroupCaptions
      Offsets.Bottom = -3
      CaptionOptions.Text = 'TEXT OPTIONS'
      Index = 0
    end
    object dxLayoutSeparatorItem8: TdxLayoutSeparatorItem
      Parent = lgValueLabelsTextCaption
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object lgValueLabelsTextCaption: TdxLayoutGroup
      Parent = lgValueLabelsText
      CaptionOptions.Text = 'New Group'
      Hidden = True
      ShowBorder = False
      UseIndent = False
      Index = 0
    end
    object lgMarkers: TdxLayoutGroup
      CaptionOptions.Text = 'Marker Options'
      Hidden = True
      ShowBorder = False
      Index = -1
    end
    object lcbiMarkerVisible: TdxLayoutCheckBoxItem
      Parent = lgMarkersGeneral
      CaptionOptions.Text = 'Visible'
      CaptionOptions.Layout = clLeft
      OnClick = OptionEditValueChanged
      Index = 0
    end
    object liMarkerType: TdxLayoutItem
      Parent = lgMarkersGeneral
      CaptionOptions.Text = 'Type'
      Control = cbMarkerType
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 156
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object liMarkerSize: TdxLayoutItem
      Parent = lgMarkersGeneral
      CaptionOptions.Text = 'Size'
      Control = seMarkerSize
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 151
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object lgAxis: TdxLayoutGroup
      CaptionOptions.Text = 'Axis'
      Hidden = True
      ItemIndex = 1
      ShowBorder = False
      Index = -1
    end
    object lgAxisGeneral: TdxLayoutGroup
      Parent = lgAxis
      CaptionOptions.Text = 'Axis General'
      Hidden = True
      ItemIndex = 4
      ShowBorder = False
      Index = 0
    end
    object lgAxisVisualRange: TdxLayoutGroup
      Parent = lgAxis
      CaptionOptions.Text = 'Visual Range'
      Hidden = True
      ShowBorder = False
      Index = 3
    end
    object lgAxisWholeRange: TdxLayoutGroup
      Parent = lgAxis
      CaptionOptions.Text = 'Whole Range'
      Hidden = True
      ItemIndex = 3
      ShowBorder = False
      Index = 4
    end
    object lcbiAxisVisible: TdxLayoutCheckBoxItem
      Parent = lgAxisGeneral
      CaptionOptions.Text = 'Visible'
      CaptionOptions.Layout = clLeft
      OnClick = OptionEditValueChanged
      Index = 0
    end
    object liAxisVisualRangeMinValue: TdxLayoutItem
      Parent = lgAxisVisualRange
      CaptionOptions.Text = 'Min Value'
      Control = seVisualRangeMinValue
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object liAxisVisualRangeMaxValue: TdxLayoutItem
      Parent = lgAxisVisualRange
      CaptionOptions.Text = 'Max Value'
      Control = seVisualRangeMaxValue
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object liAxisWholeRangeMinValue: TdxLayoutItem
      Parent = lgAxisWholeRange
      CaptionOptions.Text = 'Min Value'
      Control = seWholeRangeMinValue
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object liAxisWholeRangeMaxValue: TdxLayoutItem
      Parent = lgAxisWholeRange
      CaptionOptions.Text = 'Max Value'
      Control = seWholeRangeMaxValue
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object lcbiAxisVisualRangeAuto: TdxLayoutCheckBoxItem
      Parent = lgAxisVisualRange
      CaptionOptions.Text = 'Auto'
      CaptionOptions.Layout = clLeft
      OnClick = OptionEditValueChanged
      Index = 1
    end
    object lcbiAxisWholeRangeAuto: TdxLayoutCheckBoxItem
      Parent = lgAxisWholeRange
      CaptionOptions.Text = 'Auto'
      CaptionOptions.Layout = clLeft
      OnClick = OptionEditValueChanged
      Index = 1
    end
    object dxLayoutSeparatorItem9: TdxLayoutSeparatorItem
      Parent = dxLayoutGroup18
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object dxLayoutSeparatorItem10: TdxLayoutSeparatorItem
      Parent = dxLayoutGroup19
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object lliAxisVisualRange: TdxLayoutLabeledItem
      Parent = dxLayoutGroup18
      LayoutLookAndFeel = llfGroupCaptions
      Offsets.Bottom = -3
      CaptionOptions.Text = 'Visual Range'
      Index = 0
    end
    object lliAxisWholeRange: TdxLayoutLabeledItem
      Parent = dxLayoutGroup19
      LayoutLookAndFeel = llfGroupCaptions
      Offsets.Bottom = -3
      CaptionOptions.Text = 'Whole Range'
      Index = 0
    end
    object dxLayoutGroup18: TdxLayoutGroup
      Parent = lgAxisVisualRange
      CaptionOptions.Text = 'New Group'
      Hidden = True
      ShowBorder = False
      UseIndent = False
      Index = 0
    end
    object dxLayoutGroup19: TdxLayoutGroup
      Parent = lgAxisWholeRange
      CaptionOptions.Text = 'New Group'
      Hidden = True
      ShowBorder = False
      UseIndent = False
      Index = 0
    end
    object lgMarkersGeneral: TdxLayoutGroup
      Parent = lgMarkers
      CaptionOptions.Text = 'New Group'
      ShowBorder = False
      Index = 0
    end
    object liAxisSideMargin: TdxLayoutItem
      Parent = lgAxisGeneral
      CaptionOptions.Text = 'Side Margin'
      Control = seAxisSideMargin
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object lgAppearanceAxis: TdxLayoutGroup
      Tag = -1
      Parent = lgAppearance
      CaptionOptions.Text = 'Axis Appearance'
      Hidden = True
      ShowBorder = False
      Index = 2
    end
    object liAppearanceAxisGridlinesColor: TdxLayoutItem
      Parent = lgAppearanceAxisGridlines
      CaptionOptions.Text = 'Color'
      Control = ceAppearanceAxisGridlinesColor
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 103
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object liAppearanceAxisGridlinesMinorColor: TdxLayoutItem
      Parent = lgAppearanceAxisMinorGridlines
      CaptionOptions.Text = 'MinorColor'
      Control = ceAppearanceAxisGridlinesMinorColor
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 103
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object liAppearanceAxisThickness: TdxLayoutItem
      Parent = lgAppearanceAxis
      CaptionOptions.Text = 'Thickness'
      Control = seAppearanceAxisThickness
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 59
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object liAppearanceAxisTicksThickness: TdxLayoutItem
      Parent = lgAppearanceAxisTicks
      CaptionOptions.Text = 'Thickness'
      Control = seAppearanceAxisTicksThickness
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 59
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object liAppearanceAxisTicksLength: TdxLayoutItem
      Parent = lgAppearanceAxisTicks
      CaptionOptions.Text = 'Length'
      Control = seAppearanceAxisTicksLength
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 59
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object lliAppearanceAxis: TdxLayoutLabeledItem
      Parent = dxLayoutGroup20
      LayoutLookAndFeel = llfGroupCaptions
      Offsets.Bottom = -3
      CaptionOptions.Text = 'AXIS'
      Index = 0
    end
    object dxLayoutSeparatorItem11: TdxLayoutSeparatorItem
      Parent = dxLayoutGroup20
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object dxLayoutGroup20: TdxLayoutGroup
      Parent = lgAppearanceAxis
      CaptionOptions.Text = 'New Group'
      Hidden = True
      ItemIndex = 1
      ShowBorder = False
      UseIndent = False
      Index = 0
    end
    object liTitleAxisPosition: TdxLayoutItem
      Parent = lgTitleGeneral
      CaptionOptions.Text = 'Position:'
      Control = cbTitleAxisPosition
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 97
      ControlOptions.ShowBorder = False
      Index = 4
    end
    object liDiagramLayoutDirection: TdxLayoutItem
      Parent = lgDiagramGeneral
      CaptionOptions.Text = 'LayoutDirection'
      Control = cbDiagramLayoutDirection
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object liDiagramDimension: TdxLayoutItem
      Parent = lgDiagramGeneral
      CaptionOptions.Text = 'Dimension'
      Control = seDiagramDimension
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object lgDiagramGeneral: TdxLayoutGroup
      Parent = lgDiagramOptions
      CaptionOptions.Text = 'Diagram General'
      Hidden = True
      ItemIndex = 3
      ShowBorder = False
      Index = 0
    end
    object lcbiDiagramVisible: TdxLayoutCheckBoxItem
      Parent = lgDiagramGeneral
      CaptionOptions.Text = 'Visible'
      CaptionOptions.Layout = clLeft
      OnClick = OptionEditValueChanged
      Index = 0
    end
    object lgSeriesViewOptions: TdxLayoutGroup
      Parent = lgSeriesOptions
      CaptionOptions.Text = 'View'
      Hidden = True
      ItemIndex = 1
      ShowBorder = False
      Index = 2
    end
    object lliSeriesView: TdxLayoutLabeledItem
      Parent = dxLayoutGroup22
      LayoutLookAndFeel = llfGroupCaptions
      Offsets.Bottom = -3
      CaptionOptions.Text = 'VIEW'
      Index = 0
    end
    object dxLayoutSeparatorItem12: TdxLayoutSeparatorItem
      Parent = dxLayoutGroup22
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object liSeriesViewHoleRadius: TdxLayoutItem
      Parent = lgSeriesViewOptions
      CaptionOptions.Text = 'HoleRadius'
      Control = seSeriesViewHoleRadius
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object liSeriesViewStartAngle: TdxLayoutItem
      Parent = lgSeriesViewOptions
      CaptionOptions.Text = 'StartAngle'
      Control = seSeriesViewStartAngle
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object liSeriesViewSweepDirection: TdxLayoutItem
      Parent = lgSeriesViewOptions
      CaptionOptions.Text = 'SweepDirection'
      Control = cbSeriesViewSweepDirection
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object liSeriesViewExplodedValueMode: TdxLayoutItem
      Parent = lgSeriesViewOptions
      CaptionOptions.Text = 'ExplodedValueMode'
      Control = cbSeriesViewExplodedValueMode
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 4
    end
    object dxLayoutGroup22: TdxLayoutGroup
      Parent = lgSeriesViewOptions
      CaptionOptions.Text = 'New Group'
      Hidden = True
      ShowBorder = False
      UseIndent = False
      Index = 0
    end
    object lgTitlesGeneral: TdxLayoutGroup
      Parent = lgTitles
      CaptionOptions.Text = 'Titles General'
      Hidden = True
      ShowBorder = False
      Index = 0
    end
    object liAxisAlignment: TdxLayoutItem
      Parent = lgAxisGeneral
      CaptionOptions.Text = 'Alignment'
      Control = cbAxisAlignment
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lcbiAxisReverse: TdxLayoutCheckBoxItem
      Parent = lgAxisGeneral
      CaptionOptions.Text = 'Reverse'
      CaptionOptions.Layout = clLeft
      OnClick = OptionEditValueChanged
      Index = 4
    end
    object liValueLabelsPosition: TdxLayoutItem
      Parent = lgValueLabelsGeneral
      CaptionOptions.Text = 'Position'
      Control = cbValueLabelsPosition
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object liPaddingAll: TdxLayoutItem
      Parent = lgAppearancePadding
      CaptionOptions.Text = 'All'
      Control = sePaddingAll
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object liMarginAll: TdxLayoutItem
      Parent = lgAppearanceMargins
      CaptionOptions.Text = 'All'
      Control = seMarginAll
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lcbiAxisGridlines: TdxLayoutCheckBoxItem
      Parent = lgAxisGridlinesGeneral
      CaptionOptions.Text = 'Visible'
      CaptionOptions.Layout = clLeft
      OnClick = OptionEditValueChanged
      Index = 0
    end
    object lcbiAxisInterlaced: TdxLayoutCheckBoxItem
      Parent = lgAppearanceAxisInterlaced
      CaptionOptions.Text = 'Interlaced'
      CaptionOptions.Layout = clLeft
      OnClick = OptionEditValueChanged
      Index = 1
    end
    object lcbiDiagramRotated: TdxLayoutCheckBoxItem
      Parent = lgDiagramGeneral
      CaptionOptions.Text = 'Rotated'
      CaptionOptions.Layout = clLeft
      OnClick = OptionEditValueChanged
      Index = 3
    end
    object liAxisMinorCount: TdxLayoutItem
      Parent = lgAxisGeneral
      CaptionOptions.Text = 'Minor Count'
      Control = seAxisMinorCount
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object lgAxisGridlines: TdxLayoutGroup
      CaptionOptions.Text = 'New Group'
      Hidden = True
      ShowBorder = False
      Index = -1
    end
    object lcbiAxisGridlinesMinorVisible: TdxLayoutCheckBoxItem
      Parent = lgAxisGridlinesGeneral
      CaptionOptions.Text = 'Minor Visible'
      CaptionOptions.Layout = clLeft
      OnClick = OptionEditValueChanged
      Index = 1
    end
    object lgAxisGridlinesGeneral: TdxLayoutGroup
      Parent = lgAxisGridlines
      CaptionOptions.Text = 'New Group'
      ShowBorder = False
      Index = 0
    end
    object lgAppearanceAxisGridlines: TdxLayoutGroup
      Tag = -1
      Parent = lgAppearance
      CaptionOptions.Text = 'Axis Gridlines'
      Hidden = True
      ItemIndex = 3
      ShowBorder = False
      Index = 0
    end
    object lliAppearanceAxisGridlines: TdxLayoutLabeledItem
      Parent = dxLayoutGroup6
      LayoutLookAndFeel = llfGroupCaptions
      Offsets.Bottom = -3
      CaptionOptions.Text = 'gridlines'
      Index = 0
    end
    object dxLayoutSeparatorItem13: TdxLayoutSeparatorItem
      Parent = dxLayoutGroup6
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object dxLayoutGroup6: TdxLayoutGroup
      Parent = lgAppearanceAxisGridlines
      CaptionOptions.Text = 'New Group'
      Hidden = True
      ShowBorder = False
      UseIndent = False
      Index = 0
    end
    object liAppearanceAxisGridlinesMinorStyle: TdxLayoutItem
      Parent = lgAppearanceAxisMinorGridlines
      CaptionOptions.Text = 'MinorStyle'
      Control = cbAppearanceAxisGridlinesMinorStyle
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 76
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object liAppearanceAxisGridlinesStyle: TdxLayoutItem
      Parent = lgAppearanceAxisGridlines
      CaptionOptions.Text = 'Style'
      Control = cbAppearanceAxisGridlinesStyle
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 76
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object liAppearanceAxisGridlinesThickness: TdxLayoutItem
      Parent = lgAppearanceAxisGridlines
      CaptionOptions.Text = 'Thickness'
      Control = seAppearanceAxisGridlinesThickness
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object liAppearanceAxisGridlinesMinorThickness: TdxLayoutItem
      Parent = lgAppearanceAxisMinorGridlines
      CaptionOptions.Text = 'MinorThickness'
      Control = seAppearanceAxisGridlinesMinorThickness
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object lgAxisValueLabels: TdxLayoutGroup
      CaptionOptions.Text = 'New Group'
      Hidden = True
      ItemIndex = 1
      ShowBorder = False
      Index = -1
    end
    object lgAxisValueLabelsGeneral: TdxLayoutGroup
      Parent = lgAxisValueLabels
      CaptionOptions.Text = 'New Group'
      Hidden = True
      ItemIndex = 1
      ShowBorder = False
      Index = 0
    end
    object liAxisValueLabelsAlignment: TdxLayoutItem
      Parent = lgAxisValueLabelsGeneral
      CaptionOptions.Text = 'Alignment'
      Control = cbAxisValueLabelsAlignment
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 76
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object liAxisValueLabelsMaxLineCount: TdxLayoutItem
      Parent = lgAxisValueLabelsGeneral
      CaptionOptions.Text = 'MaxLineCount'
      Control = seAxisValueLabelsMaxLineCount
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 76
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object liAxisValueLabelsAngle: TdxLayoutItem
      Parent = lgAxisValueLabelsGeneral
      CaptionOptions.Text = 'Angle'
      Control = seAxisValueLabelsAngle
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 76
      ControlOptions.ShowBorder = False
      Index = 5
    end
    object liAxisValueLabelsPosition: TdxLayoutItem
      Parent = lgAxisValueLabelsGeneral
      CaptionOptions.Text = 'Position'
      Control = cbAxisValueLabelsPosition
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 76
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object liAxisValueLabelsMaxWidth: TdxLayoutItem
      Parent = lgAxisValueLabelsGeneral
      CaptionOptions.Text = 'MaxWidth'
      Control = seAxisValueLabelsMaxWidth
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 76
      ControlOptions.ShowBorder = False
      Index = 4
    end
    object lcbiAxisValueLabelsVisible: TdxLayoutCheckBoxItem
      Parent = lgAxisValueLabelsGeneral
      CaptionOptions.Text = 'Visible'
      CaptionOptions.Layout = clLeft
      OnClick = OptionEditValueChanged
      Index = 0
    end
    object liAxisValueLabelsResolveOverlappingIndent: TdxLayoutItem
      Parent = lgAxisValueLabelsResolveOverlapping
      CaptionOptions.Text = 'Indent'
      Control = seAxisValueLabelsResolveOverlappingIndent
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 76
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lgAxisValueLabelsResolveOverlapping: TdxLayoutGroup
      Parent = lgAxisValueLabels
      CaptionOptions.Text = 'New Group'
      Hidden = True
      ShowBorder = False
      Index = 1
    end
    object lliAxisValueLabelsResolveOverlapping: TdxLayoutLabeledItem
      Parent = dxLayoutGroup10
      LayoutLookAndFeel = llfGroupCaptions
      Offsets.Bottom = -3
      CaptionOptions.Text = 'Resolve Overlapping'
      Index = 0
    end
    object dxLayoutSeparatorItem14: TdxLayoutSeparatorItem
      Parent = dxLayoutGroup10
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object dxLayoutGroup10: TdxLayoutGroup
      Parent = lgAxisValueLabelsResolveOverlapping
      CaptionOptions.Text = 'New Group'
      Hidden = True
      ShowBorder = False
      UseIndent = False
      Index = 0
    end
    object lgAxisTicks: TdxLayoutGroup
      Parent = lgAxis
      CaptionOptions.Text = 'New Group'
      Hidden = True
      ItemIndex = 2
      ShowBorder = False
      Index = 1
    end
    object lliAxisTicks: TdxLayoutLabeledItem
      Parent = dxLayoutGroup9
      LayoutLookAndFeel = llfGroupCaptions
      Offsets.Bottom = -3
      CaptionOptions.Text = 'Ticks'
      Index = 0
    end
    object dxLayoutSeparatorItem15: TdxLayoutSeparatorItem
      Parent = dxLayoutGroup9
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object dxLayoutGroup9: TdxLayoutGroup
      Parent = lgAxisTicks
      CaptionOptions.Text = 'New Group'
      ShowBorder = False
      UseIndent = False
      Index = 0
    end
    object lcbiAxisTicksVisible: TdxLayoutCheckBoxItem
      Parent = lgAxisTicks
      CaptionOptions.Text = 'Visible'
      CaptionOptions.Layout = clLeft
      OnClick = OptionEditValueChanged
      Index = 1
    end
    object lcbiAxisTicksMinorVisible: TdxLayoutCheckBoxItem
      Parent = lgAxisMinorTicks
      CaptionOptions.Text = 'Minor'
      CaptionOptions.Layout = clLeft
      OnClick = OptionEditValueChanged
      Index = 1
    end
    object liAxisTicksCrossKind: TdxLayoutItem
      Parent = lgAxisTicks
      CaptionOptions.Text = 'CrossKind'
      Control = cbAxisTicksCrossKind
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 117
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object liAxisTicksMinorCrossKind: TdxLayoutItem
      Parent = lgAxisMinorTicks
      CaptionOptions.Text = 'MinorCrossKind'
      Control = cbAxisTicksMinorCrossKind
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 117
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object lgAppearanceAxisTicks: TdxLayoutGroup
      Tag = -1
      Parent = lgAppearance
      CaptionOptions.Text = 'New Group'
      Hidden = True
      ItemIndex = 2
      ShowBorder = False
      Index = 3
    end
    object lliAppearanceAxisTicks: TdxLayoutLabeledItem
      Parent = dxLayoutGroup14
      LayoutLookAndFeel = llfGroupCaptions
      Offsets.Bottom = -3
      CaptionOptions.Text = 'Tick Marks'
      Index = 0
    end
    object dxLayoutSeparatorItem16: TdxLayoutSeparatorItem
      Parent = dxLayoutGroup14
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object dxLayoutGroup14: TdxLayoutGroup
      Parent = lgAppearanceAxisTicks
      CaptionOptions.Text = 'New Group'
      Hidden = True
      ShowBorder = False
      UseIndent = False
      Index = 0
    end
    object liAppearanceAxisTicksMinorLength: TdxLayoutItem
      Parent = lgAppearanceAxisMinorTicks
      CaptionOptions.Text = 'MinorLength'
      Control = seAppearanceAxisTicksMinorLength
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 76
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object liAppearanceAxisTicksMinorThickness: TdxLayoutItem
      Parent = lgAppearanceAxisMinorTicks
      CaptionOptions.Text = 'MinorThickness'
      Control = seAppearanceAxisTicksMinorThickness
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 76
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object liAppearanceAxisColor: TdxLayoutItem
      Parent = lgAppearanceAxis
      CaptionOptions.Text = 'Color'
      Control = ceAppearanceAxisColor
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 76
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lgAppearanceAxisInterlaced: TdxLayoutGroup
      Tag = -1
      Parent = lgAppearance
      CaptionOptions.Text = 'Interlaced'
      Hidden = True
      ShowBorder = False
      Index = 5
    end
    object lliAppearanceAxisInterlaced: TdxLayoutLabeledItem
      Parent = dxLayoutGroup21
      AlignHorz = ahClient
      AlignVert = avTop
      LayoutLookAndFeel = llfGroupCaptions
      Offsets.Bottom = -3
      CaptionOptions.Text = 'Interlaced'
      Index = 0
    end
    object dxLayoutSeparatorItem17: TdxLayoutSeparatorItem
      Parent = dxLayoutGroup21
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object dxLayoutGroup21: TdxLayoutGroup
      Parent = lgAppearanceAxisInterlaced
      CaptionOptions.Text = 'New Group'
      Hidden = True
      ShowBorder = False
      UseIndent = False
      Index = 0
    end
    object liAppearanceAxisInterlacedMode: TdxLayoutItem
      Parent = lgAppearanceAxisInterlaced
      CaptionOptions.Text = 'Mode'
      Control = cbAppearanceAxisInterlacedMode
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 76
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object liAppearanceAxisInterlacedColor: TdxLayoutItem
      Parent = lgAppearanceAxisInterlaced
      CaptionOptions.Text = 'Color'
      Control = ceAppearanceAxisInterlacedColor
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 76
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object liAppearanceAxisInterlacedGradientEndColor: TdxLayoutItem
      Parent = lgAppearanceAxisInterlaced
      CaptionOptions.Text = 'End Color'
      Control = ceAppearanceAxisInterlacedGradientEndColor
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 76
      ControlOptions.ShowBorder = False
      Index = 5
    end
    object liAppearanceAxisInterlacedPattern: TdxLayoutItem
      Parent = lgAppearanceAxisInterlaced
      CaptionOptions.Text = 'Pattern'
      Control = ceAppearanceAxisInterlacedPattern
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 76
      ControlOptions.ShowBorder = False
      Index = 6
    end
    object liAppearanceAxisInterlacedStyle: TdxLayoutItem
      Parent = lgAppearanceAxisInterlaced
      CaptionOptions.Text = 'Style'
      Control = icbAppearanceAxisInterlacedStyle
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 76
      ControlOptions.ShowBorder = False
      Index = 7
    end
    object liAppearanceAxisInterlacedGradient: TdxLayoutItem
      Parent = lgAppearanceAxisInterlaced
      CaptionOptions.Text = 'Gradient'
      Control = cbAppearanceAxisInterlacedGradient
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 76
      ControlOptions.ShowBorder = False
      Index = 8
    end
    object liAppearanceAxisInterlacedTexture: TdxLayoutItem
      Parent = lgAppearanceAxisInterlaced
      CaptionOptions.Text = 'Texture'
      Control = iAppearanceAxisInterlacedTexture
      ControlOptions.OriginalHeight = 100
      ControlOptions.OriginalWidth = 76
      ControlOptions.ShowBorder = False
      Index = 9
    end
    object liAppearanceStrokeColor: TdxLayoutItem
      Parent = lgAppearanceStroke
      CaptionOptions.Text = 'Color'
      Control = ceAppearanceStrokeColor
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 76
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lgAppearanceStroke: TdxLayoutGroup
      Parent = lgAppearance
      CaptionOptions.Text = 'Stroke Options'
      ShowBorder = False
      Index = 8
    end
    object liAppearanceStrokeStyle: TdxLayoutItem
      Parent = lgAppearanceStroke
      CaptionOptions.Text = 'Style'
      Control = cbAppearanceStrokeStyle
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 76
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object liAppearanceStrokeThickness: TdxLayoutItem
      Parent = lgAppearanceStroke
      CaptionOptions.Text = 'Thickness'
      Control = seAppearanceStrokeThickness
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 76
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object lliAppearanceStroke: TdxLayoutLabeledItem
      Parent = dxLayoutGroup23
      LayoutLookAndFeel = llfGroupCaptions
      Offsets.Bottom = -3
      CaptionOptions.Text = 'Stroke'
      Index = 0
    end
    object dxLayoutSeparatorItem18: TdxLayoutSeparatorItem
      Parent = dxLayoutGroup23
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object dxLayoutGroup23: TdxLayoutGroup
      Parent = lgAppearanceStroke
      CaptionOptions.Text = 'New Group'
      ShowBorder = False
      UseIndent = False
      Index = 0
    end
    object liSeriesBarWidth: TdxLayoutItem
      Parent = lgSeriesGeneral
      CaptionOptions.Text = 'BarWidth'
      Control = seSeriesBarWidth
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 79
      ControlOptions.ShowBorder = False
      Index = 5
    end
    object lgChartOptions: TdxLayoutGroup
      CaptionOptions.Text = 'New Group'
      Index = -1
    end
    object liAppearanceAxisInterlacedGradientBeginColor: TdxLayoutItem
      Parent = lgAppearanceAxisInterlaced
      CaptionOptions.Text = 'Begin Color'
      Control = ceAppearanceAxisInterlacedGradientBeginColor
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 4
    end
    object liBackgroundGradientBeginColor: TdxLayoutItem
      Parent = lgAppearanceBackground
      CaptionOptions.Text = 'Begin Color'
      Control = ceBackgroundGradientBeginColor
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 4
    end
    object lgAxisMinorTicks: TdxLayoutGroup
      Parent = lgAxis
      CaptionOptions.Text = 'New Group'
      Hidden = True
      ItemIndex = 2
      ShowBorder = False
      Index = 2
    end
    object lliAxisMinorTicks: TdxLayoutLabeledItem
      Parent = dxLayoutGroup25
      LayoutLookAndFeel = llfGroupCaptions
      Offsets.Bottom = -3
      CaptionOptions.Text = 'Minor Ticks'
      Index = 0
    end
    object dxLayoutSeparatorItem19: TdxLayoutSeparatorItem
      Parent = dxLayoutGroup25
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object dxLayoutGroup25: TdxLayoutGroup
      Parent = lgAxisMinorTicks
      CaptionOptions.Text = 'New Group'
      ShowBorder = False
      UseIndent = False
      Index = 0
    end
    object lgAppearanceAxisMinorTicks: TdxLayoutGroup
      Tag = -1
      Parent = lgAppearance
      CaptionOptions.Text = 'New Group'
      ItemIndex = 2
      ShowBorder = False
      Index = 4
    end
    object dxLayoutSeparatorItem20: TdxLayoutSeparatorItem
      Parent = dxLayoutGroup24
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object lliAppearanceAxisMinorTicks: TdxLayoutLabeledItem
      Parent = dxLayoutGroup24
      LayoutLookAndFeel = llfGroupCaptions
      Offsets.Bottom = -3
      CaptionOptions.Text = 'Minor Ticks'
      Index = 0
    end
    object dxLayoutGroup24: TdxLayoutGroup
      Parent = lgAppearanceAxisMinorTicks
      CaptionOptions.Text = 'New Group'
      ShowBorder = False
      UseIndent = False
      Index = 0
    end
    object lgAppearanceAxisMinorGridlines: TdxLayoutGroup
      Tag = -1
      Parent = lgAppearance
      CaptionOptions.Text = 'New Group'
      Hidden = True
      ItemIndex = 1
      ShowBorder = False
      Index = 1
    end
    object lliAppearanceAxisMinorGridlines: TdxLayoutLabeledItem
      Parent = dxLayoutGroup27
      LayoutLookAndFeel = llfGroupCaptions
      Padding.Bottom = -3
      Padding.AssignedValues = [lpavBottom]
      CaptionOptions.Text = 'minor gridlines'
      Index = 0
    end
    object dxLayoutSeparatorItem21: TdxLayoutSeparatorItem
      Parent = dxLayoutGroup27
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object dxLayoutGroup27: TdxLayoutGroup
      Parent = lgAppearanceAxisMinorGridlines
      CaptionOptions.Text = 'New Group'
      ShowBorder = False
      UseIndent = False
      Index = 0
    end
    object liSeriesCaption: TdxLayoutItem
      Parent = lgSeriesGeneral
      CaptionOptions.Text = 'Caption'
      Control = teSeriesCaption
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lgValueLabelsResolveOverlapping: TdxLayoutGroup
      Parent = lgValueLabels
      CaptionOptions.Text = 'New Group'
      Hidden = True
      ItemIndex = 2
      ShowBorder = False
      Index = 2
    end
    object lgValueLabelsResolveOverlappingCaption: TdxLayoutGroup
      Parent = lgValueLabelsResolveOverlapping
      CaptionOptions.Text = 'New Group'
      Hidden = True
      ShowBorder = False
      UseIndent = False
      Index = 0
    end
    object lliValueLabelsResolveOverlapping: TdxLayoutLabeledItem
      Parent = lgValueLabelsResolveOverlappingCaption
      LayoutLookAndFeel = llfGroupCaptions
      Offsets.Bottom = -3
      CaptionOptions.Text = 'Resolve Overlapping'
      Index = 0
    end
    object dxLayoutSeparatorItem22: TdxLayoutSeparatorItem
      Parent = lgValueLabelsResolveOverlappingCaption
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object liValueLabelsResolveOverlappingIndent: TdxLayoutItem
      Parent = lgValueLabelsResolveOverlapping
      CaptionOptions.Text = 'Indent'
      Control = seValueLabelsResolveOverlappingIndent
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 76
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object liValueLabelsResolveOverlappingMode: TdxLayoutItem
      Parent = lgValueLabelsResolveOverlapping
      CaptionOptions.Text = 'Mode'
      Control = cbValueLabelsResolveOverlappingMode
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object liAxisTicksLabelAlignment: TdxLayoutItem
      Parent = lgAxisTicks
      CaptionOptions.Text = 'LabelAlignment'
      Control = cbAxisTicksLabelAlignment
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 87
      ControlOptions.ShowBorder = False
      Index = 3
    end
  end
  object lfMain: TdxLayoutLookAndFeelList
    Left = 264
    object llfMain: TdxLayoutCxLookAndFeel
      PixelsPerInch = 96
    end
    object llfGroupCaptions: TdxLayoutCxLookAndFeel
      ItemOptions.CaptionOptions.Font.Charset = DEFAULT_CHARSET
      ItemOptions.CaptionOptions.Font.Color = clWindowText
      ItemOptions.CaptionOptions.Font.Height = -12
      ItemOptions.CaptionOptions.Font.Name = 'Segoe UI'
      ItemOptions.CaptionOptions.Font.Style = [fsBold]
      ItemOptions.CaptionOptions.UseDefaultFont = False
      PixelsPerInch = 96
    end
  end
  object ilTreeView: TcxImageList
    SourceDPI = 96
    FormatVersion = 1
    Left = 120
    Top = 80
    Bitmap = {
      494C010115001800040010001000FFFFFFFF2110FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000006000000001002000000000000060
      0000000000000000000000000000000000004224048ECF7210FA462605920000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C76E0FF608040033D37410FD0201
      0019000000000000000000000000000000000000000000000000000000000000
      0000000000003C210487CD7010F9462605920000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000003E22048AC76E0FF66D3C08B6B463
      0EEA4124048D0100001700000000000000000000000000000000000000000201
      001E23130268CF7210FA08040033CF7210FA0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000100
      00153E220489B3630DE9703D08B8CD7010F94D2B05993B20048691500BD19E57
      0CDB442505904D2A0599C76E0FF54224048E0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000001000015CF7210FA08040033D27410FC2A170372050200270000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000003E22048AC76E0FF53E22048900000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000006364F8E14A9F3F905344C8B00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000C02141D5714ABF7FB00060A3314ADF9FC031E2B6A000204210000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000006364F8E14A9F3F9084667A2094F
      74AC1194D6EA094C6EA807415F9C13A3EBF507405E9B0637508F0F81BADA0F7D
      B5D706364F8E0639539214A9F3F9063953920000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000013A5EDF600060A3314ADF9FC0212
      1A530000000A0000000000000000000000000000000000000000000000000003
      05260322317114ABF7FB00060A3314A9F5FA0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000005334A8A13A4EDF605334A8A0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000532498913A3EBF505334A8A0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000808408E1A1AC9FA0808408E0000
      0000000000000000000008083C8A1A1AC7F90808408E00000000000000000000
      00000000000008083C8A1A1AC9FA090943920000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000001919C3F6000008331B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF000008331B1BD1FF1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF000008331B1BC9FA0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000008083C8A1919C2F608083C8A0000
      00000000000000000000070739861919C1F508083C8A00000000000000000000
      000000000000070739861919C2F60808408E0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000004224058ECE7110FA462605920000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000004224048ECE7110FA4224048E0000
      000000000000000000003E22048ACD7010F947270593140A014E2B1703734A29
      0597744009BCD47410FD08040033CE7110FA00000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FF0000000000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FF00000000000000001B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF00000000C76E0FF608040033D77610FFD776
      10FFD77610FFD77610FFD77610FF08040033D17310FC6E3C08B6462605922715
      026D1109014944250590C76E0FF53F23048A00000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FF0000000000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FF00000000000000001B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF000000003E22048AC76E0FF63E22048A0000
      000000000000000000003B200486C76D0FF53E22048A00000000000000000000
      00000000000000000000000000000000000000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FF0000000000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFBD7E
      30FF8D8D6BFF5B9CA8FF2BAAE3FF00000000000000001B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1A2F
      D7FF1854E3FF1779EEFF15A0FAFF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000071958EFFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FF000000000000000023ADEDFF43A3C5FF6399
      9EFF859075FFA5864DFFC57B26FFBD7E30FF8D8D6BFF5B9CA8FF2BAAE3FF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF000000000000000015A6FCFF168DF4FF1773
      ECFF185AE5FF1941DDFF1A29D5FF1A2FD7FF1854E3FF1779EEFF15A0FAFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF000000000000000000000000000000000000
      0000000000000000000006364F8E14A9F3F905344C8B00000000000000000000
      0000000000000000000000000000000000000000000014B1FFFF71958EFFD776
      10FFD27410FC6A3A08B36E3C08B6D57610FED77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FF000000000000000014B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF000000000000000014B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF000000000000000000000000000000000000
      00000000000C02141D5714ABF7FB00060A3314ADF9FC031E2B6A000204210000
      0000000000000000000000000000000000000000000014B1FFFF14B1FFFF6582
      77EE532D069F351D037F351D037F5F3407AAD07210FBD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FF000000000000000014B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF000000000000000014B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF0000000006364F8E14A9F3F9084667A2094F
      74AC1194D6EA094C6EA807415F9C13A3EBF507405E9B0637508F0F81BADA0F7D
      B5D706364F8E0639539214A9F3F9063953920000000014B1FFFF0D6FA0CA0002
      031E0C06003D351D037F351D037F351D037F532D069FC96E0FF7D77610FFD776
      10FFC77B23FF829078FF38A6D3FF000000000000000014B1FFFF14B1FFFF14B1
      FFFF1597F7FF1864E8FF1A33D8FF1A36D9FF176DEAFF15A4FBFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF000000000000000014B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF0000000013A5EDF600060A3314ADF9FC0212
      1A530000000A0000000000000000000000000000000000000000000000000003
      05260322317114ABF7FB00060A3314A9F5FA0000000007405E9B000000070000
      0000000000000C06003D351D037F351D037F351D037F472705938A6F40E9529E
      B3FF18B0FAFF14B1FFFF14B1FFFF00000000000000001597F7FF1864E8FF1A33
      D8FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1ED2FF1948DFFF1681
      F0FF14ADFEFF14B1FFFF14B1FFFF000000000000000014B1FFFF14B1FFFF14B1
      FFFF36A7D5FF779486FFB88036FFB5813AFF6B9795FF25ACEAFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF0000000005334A8A13A4EDF605334A8A0000
      000000000000000000000808408E1A1AC9FA0909439200000000000000000000
      0000000000000532498913A3EBF505334A8A0000000000000000000000000000
      000000000000000000000C06003D231302670A0500380000000B0002031D0E79
      AED314B1FFFF14B1FFFF14B1FFFF00000000000000001B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1B
      D1FF1A26D5FF185BE5FF1594F6FF000000000000000036A7D5FF779486FFB880
      36FFD77610FFD77610FFD77610FFD77610FFD77610FFD47714FF9C8958FF539E
      B2FF19B0F9FF14B1FFFF14B1FFFF000000000000000000000000000000000000
      000000000000000003201B1BC9FB000008331B1BCDFD00000116000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      01100B638FBF14B1FFFF14B1FFFF00000000000000001B1BD1FF1B1BD1FF1B1B
      D1FF12128ED20606327E0000052901010C3E0F0F73BD1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF0000000000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFC87A22FF849076FF3AA6D0FF000000000000000000000000000000000000
      021D0A0A49971818BAF10F0F73BD1919C1F5111182CA1818B7EF05052B740000
      0006000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000007094B6DA714B1FFFF000000000000000012128ED20606327E0000
      0529000000000000000000000000000000000000000001010C3E0F0F73BD1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF0000000000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FF000000000808408E1A1AC9FA0F0F78C11818
      B6EE0808408E0000011900000000000000000000000001010B3B111182CA1414
      9ADB020214500000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000105344C8B000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000101
      0C3E0F0F73BD1B1BD1FF1B1BD1FF0000000000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FF000000001919C3F6000008331B1BCCFC0000
      0117000000000000000000000000000000000000000000000000000000010303
      1A5C1616A5E2141496D81A1AC7F9090943920000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000001010C3E0F0F73BD0000000000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FF0000000008083C8A1919C3F60808408E0000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000A1A1AC7F9000008331B1BC9FA0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000008083C8A1919C3F60808408E0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000001B1BD1FF1B1B
      D1FF1B1BD1FF000000001B1BD1FF1B1BD1FF1B1BD1FF000000001B1BD1FF1B1B
      D1FF1B1BD1FF000000000000000000000000000000001C1C1C7F1C1C1C7F1C1C
      1C7F14B1FFFF14B1FFFF14B1FFFF00000000000000001C1C1C7F1C1C1C7F1C1C
      1C7F14B1FFFF14B1FFFF14B1FFFF000000000000000000000000717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000001B1BD1FF1B1B
      D1FF1B1BD1FF000000001B1BD1FF1B1BD1FF1B1BD1FF000000001B1BD1FF1B1B
      D1FF1B1BD1FF000000000000000000000000000000001C1C1C7F1C1C1C7F1C1C
      1C7F14B1FFFF14B1FFFF14B1FFFF00000000000000001C1C1C7F1C1C1C7F1C1C
      1C7F14B1FFFF14B1FFFF14B1FFFF000000000000000000000000717171FF0000
      0000000000003F3F3FBF00000000000000003F3F3FBF00000000000000003F3F
      3FBF00000000000000003F3F3FBF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000001B1BD1FF1B1B
      D1FF1B1BD1FF000000001B1BD1FF1B1BD1FF1B1BD1FF000000001B1BD1FF1B1B
      D1FF1B1BD1FF000000000000000000000000000000001C1C1C7F1C1C1C7F1C1C
      1C7F14B1FFFF14B1FFFF14B1FFFF00000000000000001C1C1C7F1C1C1C7F1C1C
      1C7F14B1FFFF14B1FFFF14B1FFFF000000000000000000000000717171FF0000
      0000000000003F3F3FBF00000000000000003F3F3FBF00000000000000003F3F
      3FBF00000000000000003F3F3FBF000000000000000000000000000000000000
      0000052D428214B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF129EE3F10000000000000000000000001B1BD1FF1B1B
      D1FF1B1BD1FF0000000014B1FFFF14B1FFFF14B1FFFF000000001B1BD1FF1B1B
      D1FF1B1BD1FF000000000000000000000000000000001C1C1C7F1C1C1C7F1C1C
      1C7F14B1FFFF14B1FFFF14B1FFFF00000000000000001C1C1C7F1C1C1C7F1C1C
      1C7F14B1FFFF14B1FFFF14B1FFFF000000000000000000000000717171FF3F3F
      3FBF3F3F3FBF3F3F3FBF3F3F3FBF3F3F3FBF3F3F3FBF3F3F3FBF3F3F3FBF3F3F
      3FBF3F3F3FBF3F3F3FBF3F3F3FBF00000000000000000000000000000000052D
      428214B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF00000000000000000000000014B1FFFF14B1
      FFFF14B1FFFF0000000014B1FFFF14B1FFFF14B1FFFF0000000014B1FFFF14B1
      FFFF14B1FFFF000000000000000000000000000000001C1C1C7F1C1C1C7F1C1C
      1C7FD77610FFD77610FFD77610FF00000000000000001C1C1C7F1C1C1C7F1C1C
      1C7F14B1FFFF14B1FFFF14B1FFFF000000000000000000000000717171FF0000
      0000000000003F3F3FBF00000000000000003F3F3FBF00000000000000003F3F
      3FBF00000000000000003F3F3FBF000000000000000000000000052D428214B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF00000000000000000000000014B1FFFF14B1
      FFFF14B1FFFF0000000014B1FFFF14B1FFFF14B1FFFF0000000014B1FFFF14B1
      FFFF14B1FFFF000000000000000000000000000000001C1C1C7F1C1C1C7F1C1C
      1C7FD77610FFD77610FFD77610FF00000000000000001B1BD1FF1B1BD1FF1B1B
      D1FF14B1FFFF14B1FFFF14B1FFFF000000000000000000000000717171FF0000
      0000000000003F3F3FBF00000000000000003F3F3FBF00000000000000003F3F
      3FBF00000000000000003F3F3FBF0000000000000000052D428214B1FFFF14B1
      FFFF01080B3700070A3414B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF00000000000000000000000014B1FFFF14B1
      FFFF14B1FFFF0000000014B1FFFF14B1FFFF14B1FFFF0000000014B1FFFF14B1
      FFFF14B1FFFF000000000000000000000000000000001C1C1C7F1C1C1C7F1C1C
      1C7FD77610FFD77610FFD77610FF00000000000000001B1BD1FF1B1BD1FF1B1B
      D1FF14B1FFFF14B1FFFF14B1FFFF000000000000000000000000717171FF3F3F
      3FBF3F3F3FBF3F3F3FBF3F3F3FBF3F3F3FBF3F3F3FBF3F3F3FBF3F3F3FBF3F3F
      3FBF3F3F3FBF3F3F3FBF3F3F3FBF0000000000000000042A3E7E14B1FFFF14B1
      FFFF01090E3C01080B3714B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF00000000000000000000000014B1FFFF14B1
      FFFF14B1FFFF0000000014B1FFFF14B1FFFF14B1FFFF00000000D77610FFD776
      10FFD77610FF000000000000000000000000000000001C1C1C7F1C1C1C7F1C1C
      1C7FD77610FFD77610FFD77610FF00000000000000001B1BD1FF1B1BD1FF1B1B
      D1FF14B1FFFF14B1FFFF14B1FFFF000000000000000000000000717171FF0000
      0000000000003F3F3FBF00000000000000003F3F3FBF00000000000000003F3F
      3FBF00000000000000003F3F3FBF000000000000000000000000042A3E7E14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF000000000000000000000000D77610FFD776
      10FFD77610FF0000000014B1FFFF14B1FFFF14B1FFFF00000000D77610FFD776
      10FFD77610FF000000000000000000000000000000001B1BD1FF1B1BD1FF1B1B
      D1FFD77610FFD77610FFD77610FF00000000000000001B1BD1FF1B1BD1FF1B1B
      D1FF14B1FFFF14B1FFFF14B1FFFF000000000000000000000000717171FF0000
      0000000000003F3F3FBF00000000000000003F3F3FBF00000000000000003F3F
      3FBF00000000000000003F3F3FBF00000000000000000000000000000000042A
      3E7E14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF000000000000000000000000D77610FFD776
      10FFD77610FF00000000D77610FFD77610FFD77610FF00000000D77610FFD776
      10FFD77610FF000000000000000000000000000000001B1BD1FF1B1BD1FF1B1B
      D1FFD77610FFD77610FFD77610FF00000000000000001B1BD1FF1B1BD1FF1B1B
      D1FFD77610FFD77610FFD77610FF000000000000000000000000717171FF3F3F
      3FBF3F3F3FBF3F3F3FBF3F3F3FBF3F3F3FBF3F3F3FBF3F3F3FBF3F3F3FBF3F3F
      3FBF3F3F3FBF3F3F3FBF3F3F3FBF000000000000000000000000000000000000
      0000042A3E7E14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF129BE0EF000000000000000000000000D77610FFD776
      10FFD77610FF00000000D77610FFD77610FFD77610FF00000000D77610FFD776
      10FFD77610FF000000000000000000000000000000001B1BD1FF1B1BD1FF1B1B
      D1FFD77610FFD77610FFD77610FF00000000000000001B1BD1FF1B1BD1FF1B1B
      D1FFD77610FFD77610FFD77610FF000000000000000000000000717171FF0000
      0000000000003F3F3FBF00000000000000003F3F3FBF00000000000000003F3F
      3FBF00000000000000003F3F3FBF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D77610FFD776
      10FFD77610FF00000000D77610FFD77610FFD77610FF00000000D77610FFD776
      10FFD77610FF000000000000000000000000000000001B1BD1FF1B1BD1FF1B1B
      D1FFD77610FFD77610FFD77610FF00000000000000001B1BD1FF1B1BD1FF1B1B
      D1FFD77610FFD77610FFD77610FF000000000000000000000000717171FF0000
      0000000000003F3F3FBF00000000000000003F3F3FBF00000000000000003F3F
      3FBF00000000000000003F3F3FBF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000717171FF3F3F
      3FBF3F3F3FBF3F3F3FBF3F3F3FBF3F3F3FBF3F3F3FBF3F3F3FBF3F3F3FBF3F3F
      3FBF3F3F3FBF3F3F3FBF3F3F3FBF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000004224048ECF7210FA462605920000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C76E0FF608040033CD7010F90000
      0000000000000000000006364F8E14A9F5FA0639539200000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000003E22048AC76D0FF5BA670EEE391F
      0484000000020000000013A3EBF500060A3314A9F5FA00000000000000000000
      0000000000000000000000000000000000000000000000000000D77610FFD776
      10FFD77610FF0000000014B1FFFF14B1FFFF14B1FFFF000000001B1BD1FF1B1B
      D1FF1B1BD1FF00000000000000000000000000000000000000001B1BD1FF1B1B
      D1FF1B1BD1FF000000001B1BD1FF1B1BD1FF1B1BD1FF000000001B1BD1FF1B1B
      D1FF1B1BD1FF000000000000000000000000000000001C1C1C7F1C1C1C7F1C1C
      1C7F14B1FFFF14B1FFFF14B1FFFF00000000000000001C1C1C7F1C1C1C7F1C1C
      1C7F14B1FFFF14B1FFFF14B1FFFF0000000000000000000000000201001A8649
      0AC9633608AD092D3D83129ADEEE13A3EBF5129CE1F0010B1040000000000000
      0000000000004124048DCE7110FA462605920000000000000000D77610FFD776
      10FFD77610FF0000000014B1FFFF14B1FFFF14B1FFFF000000001B1BD1FF1B1B
      D1FF1B1BD1FF00000000000000000000000000000000000000001B1BD1FF1B1B
      D1FF1B1BD1FF000000001B1BD1FF1B1BD1FF1B1BD1FF000000001B1BD1FF1B1B
      D1FF1B1BD1FF000000000000000000000000000000001C1C1C7F1C1C1C7F1C1C
      1C7F14B1FFFF14B1FFFF14B1FFFF00000000000000001C1C1C7F1C1C1C7F1C1C
      1C7F14B1FFFF14B1FFFF14B1FFFF000000000000000000000000000000000000
      0013867349EBB0803CFD060706390000000001090D3B1192D1E7010B10410603
      002B2D190375D07210FB08040033CF7210FA0000000000000000D77610FFD776
      10FFD77610FF0000000014B1FFFF14B1FFFF14B1FFFF000000001B1BD1FF1B1B
      D1FF1B1BD1FF000000000000000000000000000000000000000014B1FFFF14B1
      FFFF14B1FFFF000000001B1BD1FF1B1BD1FF1B1BD1FF000000001B1BD1FF1B1B
      D1FF1B1BD1FF000000000000000000000000000000001C1C1C7F1C1C1C7F1C1C
      1C7F14B1FFFF14B1FFFF14B1FFFF00000000000000001C1C1C7F1C1C1C7F1C1C
      1C7F14B1FFFF14B1FFFF14B1FFFF0000000000000000000000000002031C0D71
      A3CC094D70AA341D057FBF690FF0CF7210FA512C069D624A27C0BE7C2CFEAC66
      19EA472705934A290597C76E0FF54224048E0000000000000000D77610FFD776
      10FFD77610FF0000000014B1FFFF14B1FFFF14B1FFFF000000001B1BD1FF1B1B
      D1FF1B1BD1FF000000000000000000000000000000000000000014B1FFFF14B1
      FFFF14B1FFFF0000000014B1FFFF14B1FFFF14B1FFFF000000001B1BD1FF1B1B
      D1FF1B1BD1FF000000000000000000000000000000001C1C1C7F1C1C1C7F1C1C
      1C7F14B1FFFF14B1FFFF14B1FFFF00000000000000001C1C1C7F1C1C1C7F1C1C
      1C7F14B1FFFF14B1FFFF14B1FFFF0000000006364F8E14A9F3F9129CE1F0052C
      40800000000100000000C76D0FF508040033D27410FC2B1703720C100F541192
      D1E7010B10400000000000000000000000000000000000000000D77610FFD776
      10FFD77610FF0000000014B1FFFF14B1FFFF14B1FFFF000000001B1BD1FF1B1B
      D1FF1B1BD1FF0000000000000000000000000000000000000000D77610FFD776
      10FFD77610FF0000000014B1FFFF14B1FFFF14B1FFFF000000001B1BD1FF1B1B
      D1FF1B1BD1FF000000000000000000000000000000001B1BD1FF1B1BD1FF1B1B
      D1FF14B1FFFF14B1FFFF14B1FFFF00000000000000001C1C1C7F1C1C1C7F1C1C
      1C7F14B1FFFF14B1FFFF14B1FFFF0000000013A5EDF600060A3314A9F3F90000
      000000000000000000003E22048AC76E0FF64124048D00000000000000000109
      0D3B1192D1E7010B104000000000000000000000000000000000D77610FFD776
      10FFD77610FF0000000014B1FFFF14B1FFFF14B1FFFF000000001B1BD1FF1B1B
      D1FF1B1BD1FF0000000000000000000000000000000000000000D77610FFD776
      10FFD77610FF0000000014B1FFFF14B1FFFF14B1FFFF000000001B1BD1FF1B1B
      D1FF1B1BD1FF000000000000000000000000000000001B1BD1FF1B1BD1FF1B1B
      D1FF14B1FFFF14B1FFFF14B1FFFF00000000000000001C1C1C7F1C1C1C7F1C1C
      1C7FD77610FFD77610FFD77610FF0000000005334A8A13A5EDF606364F8E0000
      0000000000000000000000000000000000000000000000000000000000000000
      000001090D3B129CE1F014A9F5FA063953920000000000000000000000000000
      0000000000000000000014B1FFFF14B1FFFF14B1FFFF000000001B1BD1FF1B1B
      D1FF1B1BD1FF0000000000000000000000000000000000000000000000000000
      00000000000000000000D77610FFD77610FFD77610FF0000000014B1FFFF14B1
      FFFF14B1FFFF000000000000000000000000000000001B1BD1FF1B1BD1FF1B1B
      D1FF14B1FFFF14B1FFFF14B1FFFF00000000000000001C1C1C7F1C1C1C7F1C1C
      1C7FD77610FFD77610FFD77610FF000000000000000000000000000000000000
      000000000000000000000808408E1A1AC9FA0909439200000000000000000000
      00000000000013A4EDF600060A3314A9F5FA0000000000000000000000000000
      0000000000000000000014B1FFFF14B1FFFF14B1FFFF000000001B1BD1FF1B1B
      D1FF1B1BD1FF0000000000000000000000000000000000000000000000000000
      00000000000000000000D77610FFD77610FFD77610FF0000000014B1FFFF14B1
      FFFF14B1FFFF0000000000000000000000000000000000000000000000000000
      0000D77610FFD77610FFD77610FF00000000000000001C1C1C7F1C1C1C7F1C1C
      1C7FD77610FFD77610FFD77610FF000000000000000000000000000000000000
      000000000000000003201B1BC9FB000008331B1BCDFD00000116000000000000
      00000000000005334A8A13A5EDF606364F8E0000000000000000000000000000
      0000000000000000000014B1FFFF14B1FFFF14B1FFFF000000001B1BD1FF1B1B
      D1FF1B1BD1FF0000000000000000000000000000000000000000000000000000
      00000000000000000000D77610FFD77610FFD77610FF0000000014B1FFFF14B1
      FFFF14B1FFFF0000000000000000000000000000000000000000000000000000
      0000D77610FFD77610FFD77610FF00000000000000001C1C1C7F1C1C1C7F1C1C
      1C7FD77610FFD77610FFD77610FF000000000000000000000000000000000000
      021D0A0A49971818BAF10F0F73BD1919C1F5111182CA1818B7EF05052B740000
      0006000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000001B1BD1FF1B1B
      D1FF1B1BD1FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D77610FFD776
      10FFD77610FF0000000000000000000000000000000000000000000000000000
      0000D77610FFD77610FFD77610FF00000000000000001B1BD1FF1B1BD1FF1B1B
      D1FF000000000000000000000000000000000808408E1A1AC9FA0F0F78C11818
      B6EE0808408E0000011900000000000000000000000001010B3B111182CA1414
      9ADB020214500000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000001B1BD1FF1B1B
      D1FF1B1BD1FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D77610FFD776
      10FFD77610FF0000000000000000000000000000000000000000000000000000
      0000D77610FFD77610FFD77610FF00000000000000001B1BD1FF1B1BD1FF1B1B
      D1FF000000000000000000000000000000001919C3F6000008331B1BCCFC0000
      0117000000000000000000000000000000000000000000000000000000010303
      1A5C1616A5E2141496D81A1AC7F9090943920000000000000000000000000000
      00000000000000000000000000000000000000000000000000001B1BD1FF1B1B
      D1FF1B1BD1FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D77610FFD776
      10FFD77610FF0000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000001B1BD1FF1B1BD1FF1B1B
      D1FF0000000000000000000000000000000008083C8A1919C3F60808408E0000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000A1A1AC7F9000008331B1BC9FA0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000008083C8A1919C3F60808408E0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0003030318570D0D66B21616A9E6000000001191D1E70A567DB302151E590000
      0003000000000000000000000000000000000000000000000000000000000000
      0003030318570D0D66B21616A9E6000000001191D1E70A567DB302151E590000
      0003000000000000000000000000000000000000000000000000000000000000
      0003030318570D0D66B21616A9E60000000012A1E7F30C6490C0031B27650000
      0006000000000000000000000000000000000000000014B1FFFF14B1FFFF14B1
      FFFFD77610FFD77610FFD77610FF000000000000000014B1FFFF14B1FFFF14B1
      FFFFD77610FFD77610FFD77610FF000000000000000000000000000003231111
      85CB1B1BD1FF1B1BD1FF1B1BD1FF0000000014B1FFFF14B1FFFF14B1FFFF0D71
      A3CC000204210000000000000000000000000000000000000000000003231111
      85CB1B1BD1FF1B1BD1FF1B1BD1FF0000000014B1FFFF14B1FFFF14B1FFFF0D71
      A3CC000204210000000000000000000000000000000000000000000003231111
      85CB1B1BD1FF1B1BD1FF1B1BD1FF0000000014B1FFFF14B1FFFF14B1FFFF0F7D
      B3D6000305260000000000000000000000000000000014B1FFFF14B1FFFF14B1
      FFFFD77610FFD77610FFD77610FF000000000000000014B1FFFF14B1FFFF14B1
      FFFFD77610FFD77610FFD77610FF0000000000000000000004241616ACE71B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF0000000014B1FFFF14B1FFFF14B1FFFF0C6C
      9BC70101011C04020026000000000000000000000000000004241616ACE71B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF0000000014B1FFFF14B1FFFF14B1FFFF0C6C
      9BC70101011C04020026000000000000000000000000000004241616ACE71B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF0000000014B1FFFF14B1FFFF14B1FFFF0C65
      92C1010101180402002600000000000000000000000014B1FFFF14B1FFFF14B1
      FFFFD77610FFD77610FFD77610FF000000000000000014B1FFFF14B1FFFF14B1
      FFFFD77610FFD77610FFD77610FF0000000000000003121287CD1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF0000000014B1FFFF14B1FFFF0C6A99C60101
      011A7B4309C197530BD6000000060000000000000003121287CD1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF0000000014B1FFFF14B1FFFF0C6A99C60101
      011A7B4309C197530BD6000000060000000000000003121287CD1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF0000000014B1FFFF14B1FFFF0C6592C10101
      01187B4309C197530BD600000006000000000000000014B1FFFF14B1FFFF14B1
      FFFFD77610FFD77610FFD77610FF000000000000000014B1FFFF14B1FFFF14B1
      FFFFD77610FFD77610FFD77610FF0000000003031A5B1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF0000000014B1FFFF0C6896C4010101197B43
      09C1D77610FFD77610FF201102630000000003031A5B1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF0000000014B1FFFF0C6896C4010101197B43
      09C1D77610FFD77610FF201102630000000003031A5B1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF0C0C60AD01010835000000000004062A042B3F7F010101187B43
      09C1D77610FFD77610FF20110263000000000000000014B1FFFF14B1FFFF14B1
      FFFFD77610FFD77610FFD77610FF000000000000000014B1FFFF14B1FFFF14B1
      FFFFD77610FFD77610FFD77610FF000000000E0E6AB61B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF000000000C6592C1010101187B4309C1D776
      10FFD77610FFD77610FF744009BC000000000E0E6AB61B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF000000000C6592C1010101187B4309C1D776
      10FFD77610FFD77610FF744009BC000000000E0E6AB61B1BD1FF1B1BD1FF1B1B
      D1FF0C0C5EAB0000000100000000000000000000000000000000351D037FD776
      10FFD77610FFD77610FF744009BC000000000000000014B1FFFF14B1FFFF14B1
      FFFFD77610FFD77610FFD77610FF000000000000000014B1FFFF14B1FFFF14B1
      FFFFD77610FFD77610FFD77610FF000000001717B0EA1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF00000000010101187B4309C1D77610FFD776
      10FFD77610FFD77610FFBC670EEF000000001717B0EA1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF00000000010101187B4309C1D77610FFD776
      10FFD77610FFD77610FFBC670EEF000000001717B0EA1B1BD1FF1B1BD1FF1B1B
      D1FF0000062D000000000000000000000000000000000000000004020026D776
      10FFD77610FFD77610FFBC670EEF000000000000000000000000000000000000
      0000D77610FFD77610FFD77610FF000000000000000014B1FFFF14B1FFFF14B1
      FFFFD77610FFD77610FFD77610FF000000001B1BCAFB1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF0000000D4023048BD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FF000000001B1BCAFB1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF0000000D4023048BD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FF000000001B1BCAFB1B1BD1FF1B1BD1FF1B1B
      D1FF00000006000000000000000000000000000000000000000000000002D776
      10FFD77610FFD77610FFD77610FF000000000000000000000000000000000000
      0000D77610FFD77610FFD77610FF000000000000000014B1FFFF14B1FFFF14B1
      FFFFD77610FFD77610FFD77610FF000000001717B0EA1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF10107CC400000118784209BFD77610FFD776
      10FFD77610FFD77610FFBB670EEE000000001717B0EA1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF10107CC400000118784209BFD77610FFD776
      10FFD77610FFD77610FFBB670EEE000000001717B0EA1B1BD1FF1B1BD1FF1B1B
      D1FF00000427000000000000000000000000000000000000000005020027D776
      10FFD77610FFD77610FFBB670EEE000000000000000000000000000000000000
      0000D77610FFD77610FFD77610FF000000000000000014B1FFFF14B1FFFF14B1
      FFFFD77610FFD77610FFD77610FF000000000E0E6AB61B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF10107CC400000118784209BFD776
      10FFD77610FFD77610FF723E08B9000000000E0E6AB61B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF10107CC400000118784209BFD776
      10FFD77610FFD77610FF723E08B9000000000E0E6AB61B1BD1FF1B1BD1FF1B1B
      D1FF0A0A509E0000000000000000000000000000000000000000351D037FD776
      10FFD77610FFD77610FF723E08B9000000000000000000000000000000000000
      0000D77610FFD77610FFD77610FF000000000000000014B1FFFF14B1FFFF14B1
      FFFF0000000000000000000000000000000003031A5C1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF10107CC4000001187842
      09BFD77610FFD77610FF1D10025F0000000003031A5C1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF10107CC4000001187842
      09BFD77610FFD77610FF1D10025F0000000003031A5C1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF0A0A4B9A0000021E000000000000021D05052C76000000147842
      09BFD77610FFD77610FF1D10025F000000000000000000000000000000000000
      0000D77610FFD77610FFD77610FF000000000000000014B1FFFF14B1FFFF14B1
      FFFF000000000000000000000000000000000000000412128ACF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF10107CC40000
      0118784209BF92500BD200000004000000000000000412128ACF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF10107CC40000
      0118784209BF92500BD200000004000000000000000412128ACF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1A1AC4F71B1BD1FF1B1BD1FF0F0F71BC0000
      0014784209BF92500BD200000004000000000000000000000000000000000000
      0000000000000000000000000000000000000000000014B1FFFF14B1FFFF14B1
      FFFF0000000000000000000000000000000000000000000004261717AEE91B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1010
      7CC40000011803020023000000000000000000000000000004261717AEE91B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1010
      7CC40000011803020023000000000000000000000000000004261717AEE91B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF0F0F
      71BC000000140302002300000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000004261212
      8ACF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1212
      8CD1000004240000000000000000000000000000000000000000000004261212
      8ACF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1212
      8CD1000004240000000000000000000000000000000000000000000004261212
      8ACF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1414
      93D6000004270000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000403031A5B0E0E6AB61717B0EA1B1BC9FB1717B1EB0E0E6BB703031B5D0000
      0004000000000000000000000000000000000000000000000000000000000000
      000403031A5B0E0E6AB61717B0EA1B1BC9FB1717B1EB0E0E6BB703031B5D0000
      0004000000000000000000000000000000000000000000000000000000000000
      000403031A5B0E0E6AB61717B0EA1B1BC9FB1717B1EB0E0E6CB803031C5F0000
      0005000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C16A0FF2D77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFC56C0FF40000000000000000717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF717171FF717171FF717171FF14B1FFFF14B1FFFF14B1FFFF0000
      0000229C02FF229C02FF229C02FF00000000D77610FFD77610FFD77610FF0000
      00001B1BD1FF1B1BD1FF1B1BD1FF000000001B1BD1FF1B1BD1FF1B1BD1FF0000
      0000D77610FFD77610FFD77610FF00000000229C02FF229C02FF229C02FF0000
      000014B1FFFF14B1FFFF14B1FFFF0000000000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FF0000000000000000717171FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000001C1C1C7F14B1FFFF14B1FFFF14B1FFFF0000
      0000229C02FF229C02FF229C02FF00000000D77610FFD77610FFD77610FF0000
      00001B1BD1FF1B1BD1FF1B1BD1FF000000001B1BD1FF1B1BD1FF1B1BD1FF0000
      0000D77610FFD77610FFD77610FF00000000229C02FF229C02FF229C02FF0000
      000014B1FFFF14B1FFFF14B1FFFF0000000000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FF0000000000000000717171FF0000000014B1
      FFFF14B1FFFF14B1FFFF00000000000000000000000000000000000000000000
      00000000000000000000000000001C1C1C7F14B1FFFF14B1FFFF14B1FFFF0000
      0000229C02FF229C02FF229C02FF00000000D77610FFD77610FFD77610FF0000
      00001B1BD1FF1B1BD1FF1B1BD1FF000000001B1BD1FF1B1BD1FF1B1BD1FF0000
      0000D77610FFD77610FFD77610FF00000000229C02FF229C02FF229C02FF0000
      000014B1FFFF14B1FFFF14B1FFFF0000000000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD77610FFD776
      10FFD77610FFD77610FFD77610FF0000000000000000717171FF0000000014B1
      FFFF14B1FFFF14B1FFFF0000000000000000717171FF717171FF717171FF7171
      71FF717171FF00000000000000001C1C1C7F14B1FFFF14B1FFFF14B1FFFF0000
      0000229C02FF229C02FF229C02FF00000000D77610FFD77610FFD77610FF0000
      00001B1BD1FF1B1BD1FF1B1BD1FF000000001B1BD1FF1B1BD1FF1B1BD1FF0000
      0000D77610FFD77610FFD77610FF00000000229C02FF229C02FF229C02FF0000
      000014B1FFFF14B1FFFF14B1FFFF0000000000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFFFFFFFFFFFFFFFFFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FF0000000000000000717171FF0000000014B1
      FFFF14B1FFFF14B1FFFF00000000000000000000000000000000000000000000
      00000000000000000000000000001C1C1C7F14B1FFFF14B1FFFF14B1FFFF0000
      0000229C02FF229C02FF229C02FF00000000D77610FFD77610FFD77610FF0000
      00001B1BD1FF1B1BD1FF1B1BD1FF000000000000000000000000000000000000
      0000D77610FFD77610FFD77610FF00000000229C02FF229C02FF229C02FF0000
      000014B1FFFF14B1FFFF14B1FFFF0000000000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFFFFFFFFFFFFFFFFFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FF0000000000000000717171FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000001C1C1C7F0000000000000000000000000000
      0000229C02FF229C02FF229C02FF00000000D77610FFD77610FFD77610FF0000
      00001B1BD1FF1B1BD1FF1B1BD1FF000000000000000000000000000000000000
      0000D77610FFD77610FFD77610FF00000000229C02FF229C02FF229C02FF0000
      000014B1FFFF14B1FFFF14B1FFFF0000000000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFFFFFFFFFFFFFFFFFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FF0000000000000000717171FF00000000D776
      10FFD77610FFD77610FF00000000000000000000000000000000000000000000
      00000000000000000000000000001C1C1C7F0000000000000000000000000000
      0000229C02FF229C02FF229C02FF00000000D77610FFD77610FFD77610FF0000
      00001B1BD1FF1B1BD1FF1B1BD1FF000000000000000000000000000000000000
      0000D77610FFD77610FFD77610FF00000000229C02FF229C02FF229C02FF0000
      000014B1FFFF14B1FFFF14B1FFFF0000000000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFFFFFFFFFFFFFFFFFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FF0000000000000000717171FF00000000D776
      10FFD77610FFD77610FF0000000000000000717171FF717171FF717171FF7171
      71FF717171FF00000000000000001C1C1C7F0000000000000000000000000000
      0000229C02FF229C02FF229C02FF00000000D77610FFD77610FFD77610FF0000
      00001B1BD1FF1B1BD1FF1B1BD1FF000000000000000000000000000000000000
      000000000000000000000000000000000000229C02FF229C02FF229C02FF0000
      000014B1FFFF14B1FFFF14B1FFFF0000000000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFFFFFFFFFFFFFFFFFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FF0000000000000000717171FF00000000D776
      10FFD77610FFD77610FF00000000000000000000000000000000000000000000
      00000000000000000000000000001C1C1C7F0000000000000000000000000000
      000000000000000000000000000000000000D77610FFD77610FFD77610FF0000
      00001B1BD1FF1B1BD1FF1B1BD1FF000000000000000000000000000000000000
      000000000000000000000000000000000000229C02FF229C02FF229C02FF0000
      000014B1FFFF14B1FFFF14B1FFFF0000000000000000D77610FFD77610FFD776
      10FFFFFFFFFFD77610FFD77610FFFFFFFFFFFFFFFFFFD77610FFD77610FFFFFF
      FFFFD77610FFD77610FFD77610FF0000000000000000717171FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000001C1C1C7F0000000000000000000000000000
      000000000000000000000000000000000000D77610FFD77610FFD77610FF0000
      00001B1BD1FF1B1BD1FF1B1BD1FF000000000000000000000000000000000000
      000000000000000000000000000000000000229C02FF229C02FF229C02FF0000
      000014B1FFFF14B1FFFF14B1FFFF0000000000000000D77610FFD77610FFD776
      10FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFD77610FFD77610FFD77610FF0000000000000000717171FF000000001B1B
      D1FF1B1BD1FF1B1BD1FF00000000000000000000000000000000000000000000
      00000000000000000000000000001C1C1C7F0000000000000000000000000000
      000000000000000000000000000000000000D77610FFD77610FFD77610FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000014B1FFFF14B1FFFF14B1FFFF0000000000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FF0000000000000000717171FF000000001B1B
      D1FF1B1BD1FF1B1BD1FF0000000000000000717171FF717171FF717171FF7171
      71FF717171FF00000000000000001C1C1C7F0000000000000000000000000000
      000000000000000000000000000000000000D77610FFD77610FFD77610FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000014B1FFFF14B1FFFF14B1FFFF0000000000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FF0000000000000000717171FF000000001B1B
      D1FF1B1BD1FF1B1BD1FF00000000000000000000000000000000000000000000
      00000000000000000000000000001C1C1C7F0000000000000000000000000000
      000000000000000000000000000000000000D77610FFD77610FFD77610FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000014B1FFFF14B1FFFF14B1FFFF0000000000000000BF690FF0D77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFC16A0FF20000000000000000717171FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000001C1C1C7F0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000717171FF1C1C1C7F1C1C
      1C7F1C1C1C7F1C1C1C7F1C1C1C7F1C1C1C7F1C1C1C7F1C1C1C7F1C1C1C7F1C1C
      1C7F1C1C1C7F1C1C1C7F1C1C1C7F1C1C1C7F424D3E000000000000003E000000
      2800000040000000600000000100010000000000000300000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000}
    DesignInfo = 5243000
    ImageInfo = <
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F6373732220786D6C3A737061
          63653D227072657365727665223E2E426C61636B7B66696C6C3A233732373237
          323B7D262331333B262331303B2623393B2E59656C6C6F777B66696C6C3A2346
          46423131353B7D262331333B262331303B2623393B2E426C75657B66696C6C3A
          233131373744373B7D262331333B262331303B2623393B2E477265656E7B6669
          6C6C3A233033394332333B7D262331333B262331303B2623393B2E5265647B66
          696C6C3A234431314331433B7D262331333B262331303B2623393B2E57686974
          657B66696C6C3A234646464646463B7D262331333B262331303B2623393B2E73
          74307B6F7061636974793A302E37353B7D262331333B262331303B2623393B2E
          7374317B6F7061636974793A302E353B7D262331333B262331303B2623393B2E
          7374327B6F7061636974793A302E32353B7D3C2F7374796C653E0D0A3C672069
          643D224368617274223E0D0A09093C7265637420793D2231382220636C617373
          3D2259656C6C6F77222077696474683D223622206865696768743D223130222F
          3E0D0A09093C7265637420783D22382220793D2231322220636C6173733D2247
          7265656E222077696474683D223622206865696768743D223136222F3E0D0A09
          093C7265637420783D2231362220793D22322220636C6173733D22426C756522
          2077696474683D223622206865696768743D223236222F3E0D0A09093C726563
          7420783D2232342220793D22382220636C6173733D2252656422207769647468
          3D223622206865696768743D223230222F3E0D0A093C2F673E0D0A3C2F737667
          3E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F6373732220786D6C3A737061
          63653D227072657365727665223E2E59656C6C6F777B66696C6C3A2346464231
          31353B7D262331333B262331303B2623393B2E5265647B66696C6C3A23443131
          4331433B7D262331333B262331303B2623393B2E426C61636B7B66696C6C3A23
          3732373237323B7D262331333B262331303B2623393B2E426C75657B66696C6C
          3A233131373744373B7D262331333B262331303B2623393B2E57686974657B66
          696C6C3A234646464646463B7D262331333B262331303B2623393B2E47726565
          6E7B66696C6C3A233033394332333B7D262331333B262331303B2623393B2E73
          74307B6F7061636974793A302E37353B7D262331333B262331303B2623393B2E
          7374317B6F7061636974793A302E353B7D262331333B262331303B2623393B2E
          7374327B6F7061636974793A302E32353B7D262331333B262331303B2623393B
          2E7374337B66696C6C3A234646423131353B7D3C2F7374796C653E0D0A3C672F
          3E0D0A3C672069643D224368617274536572696573223E0D0A09093C72656374
          20793D2232302220636C6173733D22526564222077696474683D223622206865
          696768743D2238222F3E0D0A09093C7265637420783D22382220793D22313422
          20636C6173733D22426C7565222077696474683D223622206865696768743D22
          3134222F3E0D0A09093C7265637420783D2232342220793D22322220636C6173
          733D2259656C6C6F77222077696474683D223622206865696768743D22323622
          2F3E0D0A09093C7265637420783D2231362220793D22382220636C6173733D22
          477265656E222077696474683D223622206865696768743D223230222F3E0D0A
          093C2F673E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F6373732220786D6C3A737061
          63653D227072657365727665223E2E426C75657B66696C6C3A23313137374437
          3B7D262331333B262331303B2623393B2E57686974657B66696C6C3A23464646
          4646463B7D3C2F7374796C653E0D0A3C7061746820636C6173733D22426C7565
          2220643D224D32392C33304833632D302E362C302D312D302E342D312D315633
          63302D302E362C302E342D312C312D3168323663302E362C302C312C302E342C
          312C317632364333302C32392E362C32392E362C33302C32392C33307A222F3E
          0D0A3C706F6C79676F6E20636C6173733D2257686974652220706F696E74733D
          2231302C3820382C3820382C313020382C31322031302C31322031302C313020
          31342C31302031342C32322031322C32322031322C32342032302C3234203230
          2C32322031382C32322031382C31302032322C31302032322C31322032342C31
          322020202623393B32342C31302032342C3820222F3E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F6373732220786D6C3A737061
          63653D227072657365727665223E2E59656C6C6F777B66696C6C3A2346464231
          31353B7D262331333B262331303B2623393B2E5265647B66696C6C3A23443131
          4331433B7D262331333B262331303B2623393B2E426C61636B7B66696C6C3A23
          3732373237323B7D262331333B262331303B2623393B2E426C75657B66696C6C
          3A233131373744373B7D262331333B262331303B2623393B2E57686974657B66
          696C6C3A234646464646463B7D262331333B262331303B2623393B2E47726565
          6E7B66696C6C3A233033394332333B7D262331333B262331303B2623393B2E73
          74307B6F7061636974793A302E37353B7D262331333B262331303B2623393B2E
          7374317B6F7061636974793A302E353B7D262331333B262331303B2623393B2E
          7374327B6F7061636974793A302E32353B7D262331333B262331303B2623393B
          2E7374337B66696C6C3A234646423131353B7D3C2F7374796C653E0D0A3C6720
          69643D2253686F774C6567656E64223E0D0A09093C6720636C6173733D227374
          31223E0D0A0909093C706F6C79676F6E20636C6173733D22426C61636B222070
          6F696E74733D2233302C3020342C3020342C322033302C322033302C32382033
          322C32382033322C322033322C30202623393B2623393B222F3E0D0A09093C2F
          673E0D0A09093C7265637420783D22362220793D22342220636C6173733D2252
          6564222077696474683D223622206865696768743D2236222F3E0D0A09093C72
          65637420783D22362220793D2231322220636C6173733D22426C756522207769
          6474683D223622206865696768743D2236222F3E0D0A09093C7265637420783D
          22362220793D2232302220636C6173733D2259656C6C6F77222077696474683D
          223622206865696768743D2236222F3E0D0A09093C7061746820636C6173733D
          22426C61636B2220643D224D342C323856304832763330683330762D3248347A
          204D32362C38483136563668313056387A204D32362C31344831367632683130
          5631347A204D32362C323248313676326831305632327A222F3E0D0A093C2F67
          3E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D2243
          72656174655F4261725F43686172742220786D6C6E733D22687474703A2F2F77
          77772E77332E6F72672F323030302F7376672220786D6C6E733A786C696E6B3D
          22687474703A2F2F7777772E77332E6F72672F313939392F786C696E6B222078
          3D223070782220793D22307078222076696577426F783D223020302033322033
          3222207374796C653D22656E61626C652D6261636B67726F756E643A6E657720
          3020302033322033323B2220786D6C3A73706163653D22707265736572766522
          3E262331333B262331303B3C7374796C6520747970653D22746578742F637373
          2220786D6C3A73706163653D227072657365727665223E2E426C75657B66696C
          6C3A233131373744373B7D262331333B262331303B2623393B2E59656C6C6F77
          7B66696C6C3A234646423131353B7D3C2F7374796C653E0D0A3C706174682063
          6C6173733D2259656C6C6F772220643D224D382C323848325631366836563238
          7A204D32342C34682D36763234683656347A222F3E0D0A3C7061746820636C61
          73733D22426C75652220643D224D31342C32384838563668365632387A204D33
          302C3130682D3676313868365631307A222F3E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F6373732220786D6C3A737061
          63653D227072657365727665223E2E5265647B66696C6C3A234431314331433B
          7D262331333B262331303B2623393B2E59656C6C6F777B66696C6C3A23464642
          3131353B7D262331333B262331303B2623393B2E426C75657B66696C6C3A2331
          31373744373B7D262331333B262331303B2623393B2E477265656E7B66696C6C
          3A233033394332333B7D262331333B262331303B2623393B2E426C61636B7B66
          696C6C3A233732373237323B7D262331333B262331303B2623393B2E57686974
          657B66696C6C3A234646464646463B7D262331333B262331303B2623393B2E73
          74307B6F7061636974793A302E353B7D262331333B262331303B2623393B2E73
          74317B6F7061636974793A302E37353B7D262331333B262331303B2623393B2E
          7374327B6F7061636974793A302E33353B7D262331333B262331303B2623393B
          2E7374337B6F7061636974793A302E36353B7D3C2F7374796C653E0D0A3C6720
          69643D22506965223E0D0A09093C7061746820636C6173733D22426C75652220
          643D224D32362E332C352E314C31362E342C31356C392E392C392E3963322E33
          2D322E362C332E372D362E312C332E372D392E395332382E362C372E382C3236
          2E332C352E317A222F3E0D0A09093C7061746820636C6173733D225265642220
          643D224D31342C3136762D31762D302E344C32342E392C332E374332322E322C
          312E342C31382E382C302C31352C3043362E372C302C302C362E372C302C3135
          63302C372E392C362E322C31342E342C31342C31342E395631367A222F3E0D0A
          09093C7061746820636C6173733D2259656C6C6F772220643D224D31362C3239
          2E3963332E342D302E322C362E352D312E362C382E392D332E374C31362C3137
          2E345632392E397A222F3E0D0A093C2F673E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F6373732220786D6C3A737061
          63653D227072657365727665223E2E5265647B66696C6C3A234431314331433B
          7D262331333B262331303B2623393B2E59656C6C6F777B66696C6C3A23464642
          3131353B7D262331333B262331303B2623393B2E426C75657B66696C6C3A2331
          31373744373B7D262331333B262331303B2623393B2E477265656E7B66696C6C
          3A233033394332333B7D262331333B262331303B2623393B2E426C61636B7B66
          696C6C3A233732373237323B7D262331333B262331303B2623393B2E57686974
          657B66696C6C3A234646464646463B7D262331333B262331303B2623393B2E73
          74307B6F7061636974793A302E353B7D262331333B262331303B2623393B2E73
          74317B6F7061636974793A302E37353B7D262331333B262331303B2623393B2E
          7374327B6F7061636974793A302E33353B7D262331333B262331303B2623393B
          2E7374337B6F7061636974793A302E36353B7D3C2F7374796C653E0D0A3C6720
          69643D22506965223E0D0A09093C7061746820636C6173733D22426C75652220
          643D224D32362E332C352E314C31362E342C31356C392E392C392E3963322E33
          2D322E362C332E372D362E312C332E372D392E395332382E362C372E382C3236
          2E332C352E317A222F3E0D0A09093C7061746820636C6173733D225265642220
          643D224D31342C3136762D31762D302E344C32342E392C332E374332322E322C
          312E342C31382E382C302C31352C3043362E372C302C302C362E372C302C3135
          63302C372E392C362E322C31342E342C31342C31342E395631367A222F3E0D0A
          09093C7061746820636C6173733D2259656C6C6F772220643D224D31362C3239
          2E3963332E342D302E322C362E352D312E362C382E392D332E374C31362C3137
          2E345632392E397A222F3E0D0A093C2F673E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F6373732220786D6C3A737061
          63653D227072657365727665223E2E5265647B66696C6C3A234431314331433B
          7D262331333B262331303B2623393B2E59656C6C6F777B66696C6C3A23464642
          3131353B7D262331333B262331303B2623393B2E426C75657B66696C6C3A2331
          31373744373B7D262331333B262331303B2623393B2E477265656E7B66696C6C
          3A233033394332333B7D262331333B262331303B2623393B2E426C61636B7B66
          696C6C3A233732373237323B7D262331333B262331303B2623393B2E57686974
          657B66696C6C3A234646464646463B7D262331333B262331303B2623393B2E73
          74307B6F7061636974793A302E353B7D262331333B262331303B2623393B2E73
          74317B6F7061636974793A302E37353B7D262331333B262331303B2623393B2E
          7374327B6F7061636974793A302E33353B7D262331333B262331303B2623393B
          2E7374337B6F7061636974793A302E36353B7D3C2F7374796C653E0D0A3C6720
          69643D22446F7567686E7574223E0D0A09093C7061746820636C6173733D2259
          656C6C6F772220643D224D31392E322C32302E36632D302E392C302E372D322C
          312E312D332E322C312E3356333063332E342D302E322C362E352D312E362C38
          2E392D332E374C31392E322C32302E367A222F3E0D0A09093C7061746820636C
          6173733D22426C75652220643D224D32362E332C352E316C2D352E372C352E37
          4332312E352C31322C32322C31332E342C32322C3135732D302E352C332D312E
          342C342E326C352E372C352E3763322E332D322E362C332E372D362E312C332E
          372D392E395332382E362C372E382C32362E332C352E3120202623393B262339
          3B7A222F3E0D0A09093C7061746820636C6173733D225265642220643D224D38
          2C31342E3963302D332E392C332E312D372C372D3763312E362C302C332C302E
          352C342E322C312E346C352E372D352E374332322E322C312E342C31382E382C
          302C31352C3043362E372C302C302C362E372C302C313520202623393B262339
          3B63302C372E392C362E322C31342E342C31342C31342E39762D382E31433130
          2E362C32312E342C382C31382E352C382C31342E397A222F3E0D0A093C2F673E
          0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F6373732220786D6C3A737061
          63653D227072657365727665223E2E5265647B66696C6C3A234431314331433B
          7D262331333B262331303B2623393B2E59656C6C6F777B66696C6C3A23464642
          3131353B7D262331333B262331303B2623393B2E426C75657B66696C6C3A2331
          31373744373B7D262331333B262331303B2623393B2E477265656E7B66696C6C
          3A233033394332333B7D262331333B262331303B2623393B2E426C61636B7B66
          696C6C3A233732373237323B7D262331333B262331303B2623393B2E57686974
          657B66696C6C3A234646464646463B7D262331333B262331303B2623393B2E73
          74307B6F7061636974793A302E353B7D262331333B262331303B2623393B2E73
          74317B6F7061636974793A302E37353B7D262331333B262331303B2623393B2E
          7374327B6F7061636974793A302E33353B7D262331333B262331303B2623393B
          2E7374337B6F7061636974793A302E36353B7D3C2F7374796C653E0D0A3C6720
          69643D224C696E65223E0D0A09093C7061746820636C6173733D2259656C6C6F
          772220643D224D32392C3130632D312E372C302D332C312E332D332C3363302C
          302E352C302E312C302E392C302E332C312E336C2D31302C31304331352E392C
          32342E312C31352E352C32342C31352C3234632D302E362C302D312E312C302E
          322D312E352C302E3420202623393B2623393B4C352E382C313843352E392C31
          372E372C362C31372E342C362C313763302D312E372D312E332D332D332D3373
          2D332C312E332D332C3373312E332C332C332C3363302E362C302C312E312D30
          2E322C312E352D302E346C372E372C362E34632D302E312C302E332D302E322C
          302E372D302E322C3120202623393B2623393B63302C312E372C312E332C332C
          332C3373332D312E332C332D3363302D302E352D302E312D302E392D302E332D
          312E336C31302D313063302E342C302E322C302E382C302E332C312E332C302E
          3363312E372C302C332D312E332C332D335333302E372C31302C32392C31307A
          204D332C313820202623393B2623393B632D302E362C302D312D302E342D312D
          3173302E342D312C312D3173312C302E342C312C3153332E362C31382C332C31
          387A204D31352C3238632D302E362C302D312D302E342D312D3173302E342D31
          2C312D3173312C302E342C312C315331352E362C32382C31352C32387A204D32
          392C313420202623393B2623393B632D302E362C302D312D302E342D312D3173
          302E342D312C312D3173312C302E342C312C315332392E362C31342C32392C31
          347A222F3E0D0A09093C7061746820636C6173733D22426C75652220643D224D
          32392C3230632D312C302D312E392C302E352D322E342C312E334C31382C3138
          2E38632D302E312D312E362D312E342D322E382D332D322E38632D312E372C30
          2D332C312E332D332C3363302C302E342C302E312C302E372C302E322C316C2D
          372E372C362E3420202623393B2623393B43342E312C32362E322C332E362C32
          362C332C3236632D312E372C302D332C312E332D332C3373312E332C332C332C
          3373332D312E332C332D3363302D302E342D302E312D302E372D302E322D316C
          372E372D362E3463302E342C302E332C312C302E342C312E352C302E34202026
          23393B2623393B63312C302C312E392D302E352C322E342D312E336C382E362C
          322E3563302E312C312E362C312E342C322E382C332C322E3863312E372C302C
          332D312E332C332D335333302E372C32302C32392C32307A204D332C3330632D
          302E362C302D312D302E342D312D3173302E342D312C312D3173312C302E342C
          312C3120202623393B2623393B53332E362C33302C332C33307A204D31352C32
          30632D302E362C302D312D302E342D312D3173302E342D312C312D3173312C30
          2E342C312C315331352E362C32302C31352C32307A204D32392C3234632D302E
          362C302D312D302E342D312D3173302E342D312C312D3173312C302E342C312C
          3120202623393B2623393B5332392E362C32342C32392C32347A222F3E0D0A09
          093C7061746820636C6173733D225265642220643D224D32392C30632D312E37
          2C302D332C312E332D332C3363302C302E322C302C302E342C302E312C302E35
          6C2D392E322C352E324331362E342C382E332C31352E372C382C31352C38632D
          302E382C302D312E352C302E332D322E312C302E384C362C352E342020262339
          3B2623393B43362C352E322C362C352E312C362C3563302D312E372D312E332D
          332D332D3353302C332E332C302C3573312E332C332C332C3363302E382C302C
          312E352D302E332C322E312D302E386C362E392C332E3563302C302E312C302C
          302E322C302C302E3363302C312E372C312E332C332C332C3373332D312E332C
          332D3320202623393B2623393B63302D302E312C302D302E332C302D302E346C
          392E312D352E324332372E362C352E372C32382E332C362C32392C3663312E37
          2C302C332D312E332C332D335333302E372C302C32392C307A204D332C364332
          2E342C362C322C352E362C322C3573302E342D312C312D3163302E362C302C31
          2C302E342C312C3120202623393B2623393B53332E362C362C332C367A204D31
          352C3132632D302E362C302D312D302E342D312D3173302E342D312C312D3163
          302E362C302C312C302E342C312C315331352E362C31322C31352C31327A204D
          32392C34632D302E362C302D312D302E342D312D3173302E342D312C312D3163
          302E362C302C312C302E342C312C3120202623393B2623393B5332392E362C34
          2C32392C347A222F3E0D0A093C2F673E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F6373732220786D6C3A737061
          63653D227072657365727665223E2E5265647B66696C6C3A234431314331433B
          7D262331333B262331303B2623393B2E59656C6C6F777B66696C6C3A23464642
          3131353B7D262331333B262331303B2623393B2E426C75657B66696C6C3A2331
          31373744373B7D262331333B262331303B2623393B2E477265656E7B66696C6C
          3A233033394332333B7D262331333B262331303B2623393B2E426C61636B7B66
          696C6C3A233732373237323B7D262331333B262331303B2623393B2E57686974
          657B66696C6C3A234646464646463B7D262331333B262331303B2623393B2E73
          74307B6F7061636974793A302E353B7D262331333B262331303B2623393B2E73
          74317B6F7061636974793A302E37353B7D262331333B262331303B2623393B2E
          7374327B6F7061636974793A302E33353B7D262331333B262331303B2623393B
          2E7374337B6F7061636974793A302E36353B7D3C2F7374796C653E0D0A3C6720
          69643D22426172223E0D0A09093C7265637420783D22342220793D2231362220
          636C6173733D22426C7565222077696474683D223622206865696768743D2231
          32222F3E0D0A09093C7265637420783D2231322220793D2231302220636C6173
          733D2259656C6C6F77222077696474683D223622206865696768743D22313822
          2F3E0D0A09093C7265637420783D2232302220793D22342220636C6173733D22
          526564222077696474683D223622206865696768743D223234222F3E0D0A093C
          2F673E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F6373732220786D6C3A737061
          63653D227072657365727665223E2E5265647B66696C6C3A234431314331433B
          7D262331333B262331303B2623393B2E59656C6C6F777B66696C6C3A23464642
          3131353B7D262331333B262331303B2623393B2E426C75657B66696C6C3A2331
          31373744373B7D262331333B262331303B2623393B2E477265656E7B66696C6C
          3A233033394332333B7D262331333B262331303B2623393B2E426C61636B7B66
          696C6C3A233732373237323B7D262331333B262331303B2623393B2E57686974
          657B66696C6C3A234646464646463B7D262331333B262331303B2623393B2E73
          74307B6F7061636974793A302E353B7D262331333B262331303B2623393B2E73
          74317B6F7061636974793A302E37353B7D262331333B262331303B2623393B2E
          7374327B6F7061636974793A302E33353B7D262331333B262331303B2623393B
          2E7374337B6F7061636974793A302E36353B7D3C2F7374796C653E0D0A3C6720
          69643D22426172537461636B6564223E0D0A09093C7061746820636C6173733D
          225265642220643D224D31302C32384834762D3468365632387A204D31382C32
          32682D36763668365632327A204D32362C3136682D3676313268365631367A22
          2F3E0D0A09093C7061746820636C6173733D2259656C6C6F772220643D224D31
          302C32344834762D3468365632347A204D31382C3136682D3676366836563136
          7A204D32362C3130682D36763668365631307A222F3E0D0A09093C7061746820
          636C6173733D22426C75652220643D224D31302C32304834762D346836563230
          7A204D31382C3130682D36763668365631307A204D32362C34682D3676366836
          56347A222F3E0D0A093C2F673E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F6373732220786D6C3A737061
          63653D227072657365727665223E2E5265647B66696C6C3A234431314331433B
          7D262331333B262331303B2623393B2E59656C6C6F777B66696C6C3A23464642
          3131353B7D262331333B262331303B2623393B2E426C75657B66696C6C3A2331
          31373744373B7D262331333B262331303B2623393B2E477265656E7B66696C6C
          3A233033394332333B7D262331333B262331303B2623393B2E426C61636B7B66
          696C6C3A233732373237323B7D262331333B262331303B2623393B2E57686974
          657B66696C6C3A234646464646463B7D262331333B262331303B2623393B2E73
          74307B6F7061636974793A302E353B7D262331333B262331303B2623393B2E73
          74317B6F7061636974793A302E37353B7D262331333B262331303B2623393B2E
          7374327B6F7061636974793A302E33353B7D262331333B262331303B2623393B
          2E7374337B6F7061636974793A302E36353B7D3C2F7374796C653E0D0A3C6720
          69643D2253696465427953696465426172537461636B6564223E0D0A09093C67
          20636C6173733D22737430223E0D0A0909093C7061746820636C6173733D2242
          6C61636B2220643D224D382C32384832762D3868365632387A204D32342C3130
          682D3676313868365631307A222F3E0D0A09093C2F673E0D0A09093C70617468
          20636C6173733D2259656C6C6F772220643D224D31342C323848385631346836
          5632387A204D33302C3138682D3676313068365631387A222F3E0D0A09093C70
          61746820636C6173733D225265642220643D224D382C32304832762D36683656
          32307A204D32342C34682D367636683656347A222F3E0D0A09093C7061746820
          636C6173733D22426C75652220643D224D31342C31344838563668365631347A
          204D33302C3130682D36763868365631307A222F3E0D0A093C2F673E0D0A3C2F
          7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F6373732220786D6C3A737061
          63653D227072657365727665223E2E5265647B66696C6C3A234431314331433B
          7D262331333B262331303B2623393B2E59656C6C6F777B66696C6C3A23464642
          3131353B7D262331333B262331303B2623393B2E426C75657B66696C6C3A2331
          31373744373B7D262331333B262331303B2623393B2E477265656E7B66696C6C
          3A233033394332333B7D262331333B262331303B2623393B2E426C61636B7B66
          696C6C3A233732373237323B7D262331333B262331303B2623393B2E57686974
          657B66696C6C3A234646464646463B7D262331333B262331303B2623393B2E73
          74307B6F7061636974793A302E353B7D262331333B262331303B2623393B2E73
          74317B6F7061636974793A302E37353B7D262331333B262331303B2623393B2E
          7374327B6F7061636974793A302E33353B7D262331333B262331303B2623393B
          2E7374337B6F7061636974793A302E36353B7D3C2F7374796C653E0D0A3C6720
          69643D22426172537461636B65643130305F7832355F223E0D0A09093C673E0D
          0A0909093C7061746820636C6173733D2259656C6C6F772220643D224D31302C
          32384834762D3868365632387A204D31382C3232682D36763668365632327A20
          4D32362C3230682D36763868365632307A222F3E0D0A0909093C706174682063
          6C6173733D2259656C6C6F772220643D224D31302C32304834762D3868365632
          307A204D31382C3130682D3676313268365631307A204D32362C3134682D3676
          3668365631347A222F3E0D0A0909093C7061746820636C6173733D2259656C6C
          6F772220643D224D31302C31324834563468365631327A204D31382C34682D36
          7636683656347A204D32362C34682D36763130683656347A222F3E0D0A09093C
          2F673E0D0A09093C673E0D0A0909093C7061746820636C6173733D2252656422
          20643D224D31302C32384834762D3868365632387A204D31382C3232682D3676
          3668365632327A204D32362C3230682D36763868365632307A222F3E0D0A0909
          093C7061746820636C6173733D2259656C6C6F772220643D224D31302C323048
          34762D3868365632307A204D31382C3130682D3676313268365631307A204D32
          362C3134682D36763668365631347A222F3E0D0A0909093C7061746820636C61
          73733D22426C75652220643D224D31302C31324834563468365631327A204D31
          382C34682D367636683656347A204D32362C34682D36763130683656347A222F
          3E0D0A09093C2F673E0D0A093C2F673E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F6373732220786D6C3A737061
          63653D227072657365727665223E2E5265647B66696C6C3A234431314331433B
          7D262331333B262331303B2623393B2E59656C6C6F777B66696C6C3A23464642
          3131353B7D262331333B262331303B2623393B2E426C75657B66696C6C3A2331
          31373744373B7D262331333B262331303B2623393B2E477265656E7B66696C6C
          3A233033394332333B7D262331333B262331303B2623393B2E426C61636B7B66
          696C6C3A233732373237323B7D262331333B262331303B2623393B2E57686974
          657B66696C6C3A234646464646463B7D262331333B262331303B2623393B2E73
          74307B6F7061636974793A302E353B7D262331333B262331303B2623393B2E73
          74317B6F7061636974793A302E37353B7D262331333B262331303B2623393B2E
          7374327B6F7061636974793A302E33353B7D262331333B262331303B2623393B
          2E7374337B6F7061636974793A302E36353B7D3C2F7374796C653E0D0A3C6720
          69643D2253696465427953696465426172537461636B65643130305F7832355F
          223E0D0A09093C7061746820636C6173733D2259656C6C6F772220643D224D31
          342C32384838762D3868365632387A204D33302C3130682D3676313868365631
          307A222F3E0D0A09093C6720636C6173733D22737430223E0D0A0909093C7061
          746820636C6173733D22426C61636B2220643D224D382C323848325631326836
          5632387A204D32342C3138682D3676313068365631387A222F3E0D0A09093C2F
          673E0D0A09093C7061746820636C6173733D22426C75652220643D224D31342C
          32304838563468365632307A204D33302C34682D367636683656347A222F3E0D
          0A09093C7061746820636C6173733D225265642220643D224D382C3132483256
          3468365631327A204D32342C34682D36763134683656347A222F3E0D0A093C2F
          673E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224D
          616A6F725F4D696E6F725F486F72697A6F6E74616C5F477269646C696E657322
          20786D6C6E733D22687474703A2F2F7777772E77332E6F72672F323030302F73
          76672220786D6C6E733A786C696E6B3D22687474703A2F2F7777772E77332E6F
          72672F313939392F786C696E6B2220783D223070782220793D22307078222076
          696577426F783D2230203020333220333222207374796C653D22656E61626C65
          2D6261636B67726F756E643A6E6577203020302033322033323B2220786D6C3A
          73706163653D227072657365727665223E262331333B262331303B3C7374796C
          6520747970653D22746578742F6373732220786D6C3A73706163653D22707265
          7365727665223E2E426C61636B7B66696C6C3A233732373237323B7D26233133
          3B262331303B2623393B2E7374307B6F7061636974793A302E37353B7D3C2F73
          74796C653E0D0A3C672069643D22477269646C696E6573223E0D0A09093C706F
          6C79676F6E20636C6173733D22426C61636B2220706F696E74733D22362C3236
          20362C3220342C3220342C32382033302C32382033302C3236202623393B222F
          3E0D0A09093C6720636C6173733D22737430223E0D0A0909093C706174682063
          6C6173733D22426C61636B2220643D224D362C34683476344836763268347634
          483676326834763448367632683476346832762D34683476346832762D346834
          76346832762D34683476346832762D34762D32762D34762D32762D3456385634
          5632682D32682D34682D32682D34682D32682D34682D3220202623393B262339
          3B2623393B483656347A204D32342C3468347634682D3456347A204D32342C31
          3068347634682D345631307A204D32342C313668347634682D345631367A204D
          31382C3468347634682D3456347A204D31382C313068347634682D345631307A
          204D31382C313668347634682D345631367A204D31322C3468347634682D3456
          347A20202623393B2623393B2623393B204D31322C313068347634682D345631
          307A204D31322C313668347634682D345631367A222F3E0D0A09093C2F673E0D
          0A093C2F673E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F6373732220786D6C3A737061
          63653D227072657365727665223E2E426C75657B66696C6C3A23313137374437
          3B7D262331333B262331303B2623393B2E59656C6C6F777B66696C6C3A234646
          423131353B7D262331333B262331303B2623393B2E426C61636B7B66696C6C3A
          233732373237323B7D262331333B262331303B2623393B2E477265656E7B6669
          6C6C3A233033394332333B7D262331333B262331303B2623393B2E5265647B66
          696C6C3A234431314331433B7D262331333B262331303B2623393B2E7374307B
          6F7061636974793A302E37353B7D262331333B262331303B2623393B2E737431
          7B6F7061636974793A302E353B7D3C2F7374796C653E0D0A3C672069643D224C
          6162656C223E0D0A09093C7061746820636C6173733D2259656C6C6F77222064
          3D224D32392C384831306C2D382C386C382C3868313963302E352C302C312D30
          2E352C312D3156394333302C382E352C32392E352C382C32392C387A204D3130
          2C3138632D312E312C302D322D302E392D322D3263302D312E312C302E392D32
          2C322D3220202623393B2623393B73322C302E392C322C324331322C31372E31
          2C31312E312C31382C31302C31387A222F3E0D0A093C2F673E0D0A3C2F737667
          3E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F6373732220786D6C3A737061
          63653D227072657365727665223E2E5265647B66696C6C3A234431314331433B
          7D262331333B262331303B2623393B2E59656C6C6F777B66696C6C3A23464642
          3131353B7D262331333B262331303B2623393B2E426C75657B66696C6C3A2331
          31373744373B7D262331333B262331303B2623393B2E477265656E7B66696C6C
          3A233033394332333B7D262331333B262331303B2623393B2E426C61636B7B66
          696C6C3A233732373237323B7D262331333B262331303B2623393B2E57686974
          657B66696C6C3A234646464646463B7D262331333B262331303B2623393B2E73
          74307B6F7061636974793A302E353B7D262331333B262331303B2623393B2E73
          74317B6F7061636974793A302E37353B7D262331333B262331303B2623393B2E
          7374327B6F7061636974793A302E33353B7D262331333B262331303B2623393B
          2E7374337B6F7061636974793A302E36353B7D3C2F7374796C653E0D0A3C6720
          69643D2241726561223E0D0A09093C6720636C6173733D22737430223E0D0A09
          09093C706F6C79676F6E20636C6173733D22426C75652220706F696E74733D22
          31322C32302032302E352C31322E342031342C313020372E362C31362E342026
          23393B2623393B222F3E0D0A09093C2F673E0D0A09093C7061746820636C6173
          733D2259656C6C6F772220643D224D372E362C31362E344C322C32325631324C
          372E362C31362E347A204D32302E352C31322E344C33302C313656344C32302E
          352C31322E347A222F3E0D0A09093C706F6C79676F6E20636C6173733D22426C
          75652220706F696E74733D2231322C323020372E362C31362E3420322C323220
          322C32382033302C32382033302C31362032302E352C31322E34202623393B22
          2F3E0D0A093C2F673E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F6373732220786D6C3A737061
          63653D227072657365727665223E2E5265647B66696C6C3A234431314331433B
          7D262331333B262331303B2623393B2E59656C6C6F777B66696C6C3A23464642
          3131353B7D262331333B262331303B2623393B2E426C75657B66696C6C3A2331
          31373744373B7D262331333B262331303B2623393B2E477265656E7B66696C6C
          3A233033394332333B7D262331333B262331303B2623393B2E426C61636B7B66
          696C6C3A233732373237323B7D262331333B262331303B2623393B2E57686974
          657B66696C6C3A234646464646463B7D262331333B262331303B2623393B2E73
          74307B6F7061636974793A302E353B7D262331333B262331303B2623393B2E73
          74317B6F7061636974793A302E37353B7D262331333B262331303B2623393B2E
          7374327B6F7061636974793A302E33353B7D262331333B262331303B2623393B
          2E7374337B6F7061636974793A302E36353B7D3C2F7374796C653E0D0A3C6720
          69643D2241726561537461636B6564223E0D0A09093C706F6C79676F6E20636C
          6173733D22426C75652220706F696E74733D22322C323820322C32322031342C
          32302033302C32342033302C3238202623393B222F3E0D0A09093C706F6C7967
          6F6E20636C6173733D2259656C6C6F772220706F696E74733D22322C31322031
          342C31362033302C31302033302C32342031342C323020322C3232202623393B
          222F3E0D0A09093C706F6C79676F6E20636C6173733D225265642220706F696E
          74733D22322C3620322C31322031342C31362033302C31302033302C32203134
          2C3130202623393B222F3E0D0A093C2F673E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F6373732220786D6C3A737061
          63653D227072657365727665223E2E5265647B66696C6C3A234431314331433B
          7D262331333B262331303B2623393B2E59656C6C6F777B66696C6C3A23464642
          3131353B7D262331333B262331303B2623393B2E426C75657B66696C6C3A2331
          31373744373B7D262331333B262331303B2623393B2E477265656E7B66696C6C
          3A233033394332333B7D262331333B262331303B2623393B2E426C61636B7B66
          696C6C3A233732373237323B7D262331333B262331303B2623393B2E57686974
          657B66696C6C3A234646464646463B7D262331333B262331303B2623393B2E73
          74307B6F7061636974793A302E353B7D262331333B262331303B2623393B2E73
          74317B6F7061636974793A302E37353B7D262331333B262331303B2623393B2E
          7374327B6F7061636974793A302E33353B7D262331333B262331303B2623393B
          2E7374337B6F7061636974793A302E36353B7D3C2F7374796C653E0D0A3C6720
          69643D2241726561537461636B65643130305F7832355F223E0D0A09093C706F
          6C79676F6E20636C6173733D225265642220706F696E74733D22322C32382032
          2C32322031342C32302033302C32342033302C3238202623393B222F3E0D0A09
          093C706F6C79676F6E20636C6173733D2259656C6C6F772220706F696E74733D
          22322C31302031342C31342033302C382033302C32342031342C323020322C32
          32202623393B222F3E0D0A09093C706F6C79676F6E20636C6173733D22426C75
          652220706F696E74733D22322C3220322C31302031342C31342033302C382033
          302C32202623393B222F3E0D0A093C2F673E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F6373732220786D6C3A737061
          63653D227072657365727665223E2E5265647B66696C6C3A234431314331433B
          7D262331333B262331303B2623393B2E59656C6C6F777B66696C6C3A23464642
          3131353B7D262331333B262331303B2623393B2E426C75657B66696C6C3A2331
          31373744373B7D262331333B262331303B2623393B2E477265656E7B66696C6C
          3A233033394332333B7D262331333B262331303B2623393B2E426C61636B7B66
          696C6C3A233732373237323B7D262331333B262331303B2623393B2E57686974
          657B66696C6C3A234646464646463B7D262331333B262331303B2623393B2E73
          74307B6F7061636974793A302E353B7D262331333B262331303B2623393B2E73
          74317B6F7061636974793A302E37353B7D262331333B262331303B2623393B2E
          7374327B6F7061636974793A302E33353B7D262331333B262331303B2623393B
          2E7374337B6F7061636974793A302E36353B7D3C2F7374796C653E0D0A3C6720
          69643D224C696E65537461636B6564223E0D0A09093C7061746820636C617373
          3D22426C75652220643D224D32392C3236632D312E322C302D322E322C302E37
          2D322E372C312E366C2D382E342D312E324331372E372C32352E312C31362E35
          2C32342C31352C3234632D312E332C302D322E342C302E382D322E382C324835
          2E3820202623393B2623393B632D302E342D312E322D312E352D322D322E382D
          32632D312E372C302D332C312E332D332C3373312E332C332C332C3363312E33
          2C302C322E342D302E382C322E382D3268362E3463302E342C312E322C312E35
          2C322C322E382C3263312E312C302C322E312D302E362C322E362D312E366C38
          2E342C312E3220202623393B2623393B63302E332C312E342C312E362C322E34
          2C332C322E3463312E372C302C332D312E332C332D334333322C32372E342C33
          302E372C32362C32392C32367A204D332C3238632D302E362C302D312D302E34
          2D312D3173302E342D312C312D3173312C302E342C312C3153332E362C32382C
          332C32387A204D31352C323820202623393B2623393B632D302E362C302D312D
          302E342D312D3173302E342D312C312D3173312C302E342C312C315331352E36
          2C32382C31352C32387A204D32392C3330632D302E362C302D312D302E342D31
          2D3173302E342D312C312D3173312C302E342C312C315332392E362C33302C32
          392C33307A222F3E0D0A09093C7061746820636C6173733D225265642220643D
          224D32392C30632D312E372C302D332C312E332D332C3363302C302E322C302C
          302E342C302E312C302E356C2D392E322C352E324331362E342C382E332C3135
          2E372C382C31352C38632D302E382C302D312E352C302E332D322E312C302E38
          4C362C352E3420202623393B2623393B43362C352E322C362C352E312C362C35
          63302D312E372D312E332D332D332D3353302C332E332C302C3573312E332C33
          2C332C3363302E382C302C312E352D302E332C322E312D302E386C362E392C33
          2E3563302C302E312C302C302E322C302C302E3363302C312E372C312E332C33
          2C332C3373332D312E332C332D3320202623393B2623393B63302D302E312C30
          2D302E332C302D302E346C392E312D352E324332372E362C352E372C32382E33
          2C362C32392C3663312E372C302C332D312E332C332D335333302E372C302C32
          392C307A204D332C3643322E342C362C322C352E362C322C3573302E342D312C
          312D3163302E362C302C312C302E342C312C3120202623393B2623393B53332E
          362C362C332C367A204D31352C3132632D302E362C302D312D302E342D312D31
          73302E342D312C312D3163302E362C302C312C302E342C312C315331352E362C
          31322C31352C31327A204D32392C34632D302E362C302D312D302E342D312D31
          73302E342D312C312D3163302E362C302C312C302E342C312C3120202623393B
          2623393B5332392E362C342C32392C347A222F3E0D0A09093C7061746820636C
          6173733D2259656C6C6F772220643D224D32392C3132632D312E362C302D322E
          392C312E322D332C322E386C2D382E352C322E354331362E392C31362E352C31
          362C31362C31352C3136632D312C302D312E382C302E352D322E342C312E324C
          362C313563302D312E372D312E342D332D332D3320202623393B2623393B632D
          312E372C302D332C312E332D332C3373312E332C332C332C3363312C302C312E
          382D302E352C322E342D312E324C31322C313963302C302C302C302C302C3063
          302C312E372C312E332C332C332C3363312E362C302C322E392D312E332C332D
          322E396C382E372D322E3520202623393B2623393B4332372E312C31372E352C
          32382C31382C32392C313863312E372C302C332D312E332C332D334333322C31
          332E342C33302E372C31322C32392C31327A204D332C3136632D302E362C302D
          312D302E342D312D3173302E342D312C312D3163302E362C302C312C302E342C
          312C3153332E362C31362C332C31367A20202623393B2623393B204D31352C32
          30632D302E362C302D312D302E342D312D3173302E342D312C312D3163302E36
          2C302C312C302E342C312C315331352E362C32302C31352C32307A204D32392C
          3136632D302E362C302D312D302E342D312D3173302E342D312C312D3173312C
          302E342C312C315332392E362C31362C32392C31367A222F3E0D0A093C2F673E
          0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F6373732220786D6C3A737061
          63653D227072657365727665223E2E5265647B66696C6C3A234431314331433B
          7D262331333B262331303B2623393B2E59656C6C6F777B66696C6C3A23464642
          3131353B7D262331333B262331303B2623393B2E426C75657B66696C6C3A2331
          31373744373B7D262331333B262331303B2623393B2E477265656E7B66696C6C
          3A233033394332333B7D262331333B262331303B2623393B2E426C61636B7B66
          696C6C3A233732373237323B7D262331333B262331303B2623393B2E57686974
          657B66696C6C3A234646464646463B7D262331333B262331303B2623393B2E73
          74307B6F7061636974793A302E353B7D262331333B262331303B2623393B2E73
          74317B6F7061636974793A302E37353B7D262331333B262331303B2623393B2E
          7374327B6F7061636974793A302E33353B7D262331333B262331303B2623393B
          2E7374337B6F7061636974793A302E36353B7D3C2F7374796C653E0D0A3C6720
          69643D224C696E65537461636B65643130305F7832355F223E0D0A09093C7061
          746820636C6173733D225265642220643D224D32392C30632D312E332C302D32
          2E342C302E382D322E382C32682D382E34632D302E342D312E322D312E352D32
          2D322E382D32732D322E342C302E382D322E382C3248352E3843352E342C302E
          382C342E332C302C332C3043312E332C302C302C312E332C302C332020262339
          3B2623393B73312E332C332C332C3363312E332C302C322E342D302E382C322E
          382D3268362E3463302E342C312E322C312E352C322C322E382C3273322E342D
          302E382C322E382D3268382E3463302E342C312E322C312E352C322C322E382C
          3263312E372C302C332D312E332C332D335333302E372C302C32392C307A204D
          332C3420202623393B2623393B43322E342C342C322C332E362C322C3373302E
          342D312C312D3173312C302E342C312C3153332E362C342C332C347A204D3135
          2C34632D302E362C302D312D302E342D312D3173302E342D312C312D3173312C
          302E342C312C315331352E362C342C31352C347A204D32392C34632D302E362C
          302D312D302E342D312D3120202623393B2623393B73302E342D312C312D3173
          312C302E342C312C315332392E362C342C32392C347A222F3E0D0A09093C7061
          746820636C6173733D2259656C6C6F772220643D224D32392C38632D312E362C
          302D322E392C312E322D332C322E386C2D382E352C322E354331362E392C3132
          2E352C31362C31322C31352C3132632D312C302D312E382C302E352D322E342C
          312E324C362C313163302D312E372D312E342D332D332D3320202623393B2623
          393B632D312E372C302D332C312E332D332C3373312E332C332C332C3363312C
          302C312E382D302E352C322E342D312E324C31322C313563302C302C302C302C
          302C3063302C312E372C312E332C332C332C3363312E362C302C322E392D312E
          332C332D322E396C382E372D322E3520202623393B2623393B4332372E312C31
          332E352C32382C31342C32392C313463312E372C302C332D312E332C332D3343
          33322C392E342C33302E372C382C32392C387A204D332C3132632D302E362C30
          2D312D302E342D312D3173302E342D312C312D3163302E362C302C312C302E34
          2C312C3153332E362C31322C332C31327A20202623393B2623393B204D31352C
          3136632D302E362C302D312D302E342D312D3173302E342D312C312D3163302E
          362C302C312C302E342C312C315331352E362C31362C31352C31367A204D3239
          2C3132632D302E362C302D312D302E342D312D3173302E342D312C312D317331
          2C302E342C312C315332392E362C31322C32392C31327A222F3E0D0A09093C70
          61746820636C6173733D22426C75652220643D224D32392C3234632D312C302D
          312E392C302E352D322E352C312E334C31382C32322E38632D302E312D312E35
          2D312E342D322E382D332D322E38632D312E372C302D332C312E332D332C3363
          302C302E312C302C302E332C302C302E346C2D372C332E3520202623393B2623
          393B43342E352C32362E332C332E382C32362C332C3236632D312E372C302D33
          2C312E332D332C3373312E332C332C332C3373332D312E332C332D3363302D30
          2E312C302D302E322C302D302E346C362E392D332E3563302E352C302E352C31
          2E332C302E392C322E312C302E3920202623393B2623393B63312E312C302C32
          2D302E362C322E352D312E346C382E352C322E3563302E312C312E362C312E34
          2C322E392C332C322E3963312E372C302C332D312E332C332D335333302E372C
          32342C32392C32347A204D332C3330632D302E362C302D312D302E342D312D31
          73302E342D312C312D3173312C302E342C312C3120202623393B2623393B5333
          2E362C33302C332C33307A204D31352C3234632D302E362C302D312D302E342D
          312D3173302E342D312C312D3173312C302E342C312C315331352E362C32342C
          31352C32347A204D32392C3238632D302E362C302D312D302E342D312D317330
          2E342D312C312D3173312C302E342C312C3120202623393B2623393B5332392E
          362C32382C32392C32387A222F3E0D0A093C2F673E0D0A3C2F7376673E0D0A}
      end>
  end
  object ilTreeViewCommands: TcxImageList
    SourceDPI = 96
    FormatVersion = 1
    Left = 120
    Top = 136
    Bitmap = {
      494C010107000800040010001000FFFFFFFF2110FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000002000000001002000000000000020
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000014B1FFFF14B1
      FFFF14B1FFFF0000000014B1FFFF14B1FFFF14B1FFFF0000000014B1FFFF14B1
      FFFF14B1FFFF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000636363EF717171FF717171FF717171FF717171FF717171FF717171FF6565
      65F100000000000000000000000000000000000000000000000014B1FFFF14B1
      FFFF14B1FFFF0000000014B1FFFF14B1FFFF14B1FFFF0000000014B1FFFF14B1
      FFFF14B1FFFF0000000000000000000000000000000000000000000000000000
      00000000000000000000000000001E8A02EF1F8C02F100000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF00000000000000000000000000000000000000000000000014B1FFFF14B1
      FFFF14B1FFFF0000000014B1FFFF14B1FFFF14B1FFFF0000000014B1FFFF14B1
      FFFF14B1FFFF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000229C02FF229C02FF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF00000000000000000000000000000000000000000000000014B1FFFF14B1
      FFFF14B1FFFF0000000014B1FFFF14B1FFFF14B1FFFF0000000014B1FFFF14B1
      FFFF14B1FFFF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000229C02FF229C02FF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000014B1FFFF14B1FFFF14B1FFFF0000000014B1FFFF14B1
      FFFF14B1FFFF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000229C02FF229C02FF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000014B1FFFF14B1FFFF14B1FFFF0000000014B1FFFF14B1
      FFFF14B1FFFF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000229C02FF229C02FF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000014B1FFFF14B1
      FFFF14B1FFFF00000000000000000000000000000000000000001E8A02EF229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF1F8C02F100000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF000000000000000000000000000000000000000000000000000000000000
      00000000000000000000371E0482CE7110FA522C069D0000000014B1FFFF14B1
      FFFF14B1FFFF00000000000000000000000000000000000000001E8702ED229C
      02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C02FF229C
      02FF229C02FF1E8902EF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF000000000000000000000000000000000000000000000000000000000000
      0000000000000301001EC16A0FF208040033D77610FF00000008000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000229C02FF229C02FF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000004224048ECD70
      10F9723F08BAB8650EEC6C3C08B5C76D0FF5C46C0FF4130A014C000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000229C02FF229C02FF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF0000000000000000000000000000000000000000C76E0FF60804
      0033D27410FC0301002100000000000000000B06003BB6640EEB130A014C0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000229C02FF229C02FF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000006262
      62ED717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF636363EF00000000000000000000000000000000000000003E22048AC76E
      0FF64224048E000000000000000000000000000000000B06003BC16A0FF2CD70
      10F9462605920000000000000000000000000000000000000000000000000000
      0000000000000000000000000000229C02FF229C02FF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000626262ED636363EF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C76E0FF60804
      0033CF7210FA0000000000000000000000000000000000000000000000000000
      00000000000000000000000000001E8702ED1E8902EF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000003E22048AC76E
      0FF64224048E0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000E0E0E5C5151
      51D86F6F6FFD525252DA0F0F0F5F000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000E0E0E5B717171FF7171
      71FF00000000717171FF717171FF0F0F0F5F0000000000000000000000000000
      0000000000000000000000000000636363EF656565F100000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000004F4F4FD5717171FF7171
      71FF00000000717171FF717171FF525252D90000000000000000000000000000
      0000000000000000000000000000717171FF717171FF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000001D1D
      1D821D1D1D8200000000000000000000000000000000717171FF717171FF7171
      71FF00000000717171FF717171FF717171FF000000006B6B6BF9000000000000
      00000000000000000000000000006F6F6FFD0000000000000000000000000000
      0000000000000000000000000000717171FF717171FF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000131B1B1B7D4B4B4BD06B6B6BF96C6C6CF94B4B4BD01C1C1C7F0000
      0014000000000000000000000000000000000000000000000000000000000000
      0000000000131B1B1B7D4B4B4BD06B6B6BF96C6C6CF94B4B4BD0343434AD7171
      71FF1B1B1B7E00000000000000000000000000000000717171FF717171FF7171
      71FF00000000717171FF717171FF717171FF000000004E4E4ED4717171FF7171
      71FF00000000717171FF717171FF515151D80000000000000000000000000000
      0000000000000000000000000000717171FF717171FF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000F0F
      0F5F636363EF6B6B6BF81414146C0000000D0000000D1313136A6B6B6BF76464
      64F0101010620000000000000000000000000000000000000000000000000F0F
      0F5F636363EF6B6B6BF81414146C0000000D0000000D414141C2717171FF1B1B
      1B7E0303032A00000000000000000000000000000000717171FF717171FF7171
      71FF00000000717171FF717171FF717171FF000000000D0D0D59717171FF7171
      71FF00000000717171FF717171FF0E0E0E5D0000000000000000000000000000
      0000000000000000000000000000717171FF717171FF00000000000000000000
      0000000000000000000000000000000000000000000000000002242424917171
      71FF717171FF1515156E0B0B0B505F5F5FEA606060EB0B0B0B531313136A7171
      71FF717171FF2626269500000002000000000000000000000002242424917171
      71FF717171FF1515156E0A0A0A4F5F5F5FEA646464F0717171FF1B1B1B7E1D1D
      1D82707070FE1E1E1E83000000010000000000000000717171FF717171FF7171
      71FF00000000717171FF717171FF717171FF00000000050505380D0D0D594E4E
      4ED46C6C6CF9505050D60E0E0E5B000000000000000000000000636363EF7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF656565F100000000000000000000000025252592717171FF7171
      71FF717171FF000000115C5C5CE7717171FF717171FF606060EB0000000D7171
      71FF717171FF717171FF27272796000000000000000025252592717171FF7171
      71FF717171FF000000115C5C5CE7717171FF717171FF1B1B1B7E010101197171
      71FF717171FF717171FF242424910000000000000000717171FF717171FF7171
      71FF00000000717171FF717171FF717171FF000000006A6A6AF71D1D1D810202
      0226000000000000000000000000000000000000000000000000626262ED7171
      71FF717171FF717171FF717171FF717171FF717171FF717171FF717171FF7171
      71FF717171FF636363EF0000000000000000000000002323238E717171FF7171
      71FF717171FF000000115C5C5CE6717171FF717171FF5F5F5FEA0000000D7171
      71FF717171FF717171FF2525259200000000000000002222228D717171FF7171
      71FF717171FF00000011606060EC717171FF1B1B1B7E1414146C000000187171
      71FF717171FF717171FF25252592000000000000000000000000000000000000
      000000000000717171FF717171FF717171FF00000000717171FF717171FF7171
      71FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000717171FF717171FF00000000000000000000
      00000000000000000000000000000000000000000000000000012222228D7171
      71FF717171FF151515700A0A0A4D5C5C5CE65C5C5CE70B0B0B501414146C7171
      71FF717171FF2424249100000002000000000000000000000001202020897171
      71FF717171FF444444C6717171FF1B1B1B7E131313690A0A0A4F161616727171
      71FF717171FF2424249100000002000000000000000000000000000000000000
      000000000000717171FF717171FF717171FF00000000717171FF717171FF7171
      71FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000717171FF717171FF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000E0E
      0E5B626262ED6B6B6BF91515157000000011000000111515156E6B6B6BF86262
      62EE0F0F0F5E0000000000000000000000000000000000000000000000000B0B
      0B53696969F6717171FF1B1B1B7E0000000700000009131313696B6B6BF86262
      62EE0F0F0F5E0000000000000000000000000000000000000000000000000000
      000000000000717171FF717171FF717171FF00000000717171FF717171FF7171
      71FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000717171FF717171FF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000001119191979484848CC696969F5696969F5484848CC1A1A1A7B0000
      0012000000000000000000000000000000000000000000000000000000001D1D
      1D82717171FF1B1B1B7E0D0D0D58656565F1666666F2484848CC1A1A1A7B0000
      0012000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000717171FF717171FF7171
      71FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000717171FF717171FF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000001B1B
      1B7E1B1B1B7E0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000717171FF717171FF7171
      71FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000626262ED636363EF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000717171FF717171FF7171
      71FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000200000000100010000000000000100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000}
    DesignInfo = 8913016
    ImageInfo = <
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F6373732220786D6C3A737061
          63653D227072657365727665223E2E426C75657B66696C6C3A23313137374437
          3B7D262331333B262331303B2623393B2E426C61636B7B66696C6C3A23373237
          3237323B7D262331333B262331303B2623393B2E59656C6C6F777B66696C6C3A
          234646423131353B7D262331333B262331303B2623393B2E5265647B66696C6C
          3A234431314331433B7D262331333B262331303B2623393B2E477265656E7B66
          696C6C3A233033394332333B7D262331333B262331303B2623393B2E57686974
          657B66696C6C3A234646464646463B7D262331333B262331303B2623393B2E73
          74307B6F7061636974793A302E353B7D262331333B262331303B2623393B2E73
          74317B6F7061636974793A302E37353B7D262331333B262331303B2623393B2E
          7374327B6F7061636974793A302E313B7D262331333B262331303B2623393B2E
          7374337B6F7061636974793A302E32353B7D262331333B262331303B2623393B
          2E7374347B6F7061636974793A302E343B7D262331333B262331303B2623393B
          2E7374357B6F7061636974793A302E35353B7D262331333B262331303B262339
          3B2E7374367B6F7061636974793A302E373B7D262331333B262331303B262339
          3B2E7374377B6F7061636974793A302E38353B7D262331333B262331303B2623
          393B2E7374387B6F7061636974793A302E323B7D262331333B262331303B2623
          393B2E7374397B6F7061636974793A302E333B7D262331333B262331303B2623
          393B2E737431307B6F7061636974793A302E363B7D262331333B262331303B26
          23393B2E737431317B6F7061636974793A302E383B7D262331333B262331303B
          2623393B2E737431327B6F7061636974793A302E393B7D3C2F7374796C653E0D
          0A3C7061746820636C6173733D22426C61636B2220643D224D382C3234483256
          313468365632347A204D31362C38682D36763136683656387A204D32342C3134
          2E315632682D367631352E334331392E352C31352E362C32312E362C31342E33
          2C32342C31342E317A204D33322C323363302C332E392D332E312C372D372C37
          20202623393B732D372D332E312D372D3763302D332E392C332E312D372C372D
          375333322C31392E312C33322C32337A204D33302C3234762D32682D34762D34
          682D327634682D347632683476346832762D344833307A222F3E0D0A3C2F7376
          673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076696577426F783D222D34202D342033322033
          322220786D6C6E733D22687474703A2F2F7777772E77332E6F72672F32303030
          2F7376672220786D6C3A73706163653D227072657365727665223E20203C6720
          69643D224C617965725F3122207472616E73666F726D3D227472616E736C6174
          65282D342C202D34292220786D6C3A73706163653D227072657365727665223E
          202020203C672069643D224164642220786D6C3A73706163653D227072657365
          727665223E2020202020203C7061746820643D224D32372C2031344C31382C20
          31344C31382C20354331382C20342E352031372E352C20342031372C20344C31
          352C20344331342E352C20342031342C20342E352031342C20354C31342C2031
          344C352C20313443342E352C20313420342C2031342E3520342C2031354C342C
          20313743342C2031372E3520342E352C20313820352C2031384C31342C203138
          4C31342C2032374331342C2032372E352031342E352C2032382031352C203238
          4C31372C2032384331372E352C2032382031382C2032372E352031382C203237
          4C31382C2031384C32372C2031384332372E352C2031382032382C2031372E35
          2032382C2031374C32382C2031354332382C2031342E352032372E352C203134
          2032372C2031347A222066696C6C3D22233732373237322220636C6173733D22
          426C61636B222F3E0D0A09093C2F673E0D0A093C2F673E0D0A3C2F7376673E0D
          0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F637373223E2E426C61636B7B
          66696C6C3A233732373237323B7D3C2F7374796C653E0D0A3C636972636C6520
          636C6173733D22426C61636B222063783D223136222063793D2231362220723D
          2234222F3E0D0A3C7061746820636C6173733D22426C61636B2220643D224D31
          362C3843382C382C322C31362C322C313673362C382C31342C387331342D382C
          31342D385332342C382C31362C387A204D31362C3232632D332E332C302D362D
          322E372D362D3673322E372D362C362D3673362C322E372C362C362020262339
          3B5331392E332C32322C31362C32327A222F3E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F637373223E2E426C61636B7B
          66696C6C3A233732373237323B7D3C2F7374796C653E0D0A3C7061746820636C
          6173733D22426C61636B2220643D224D362C386C322E342C322E3443342E352C
          31322E372C322C31362C322C313673362C382C31342C3863312E382C302C332E
          342D302E342C352D316C332C336C322D324C382C364C362C387A204D31302E39
          2C31322E396C312E352C312E3520202623393B632D302E332C302E352D302E34
          2C312D302E342C312E3663302C322E322C312E382C342C342C3463302E362C30
          2C312E312D302E312C312E362D302E346C312E352C312E35632D302E392C302E
          362D322C302E392D332E312C302E39632D332E332C302D362D322E372D362D36
          20202623393B4331302C31342E392C31302E332C31332E382C31302E392C3132
          2E397A222F3E0D0A3C7061746820636C6173733D22426C61636B2220643D224D
          31362C31326C342C344332302C31332E382C31382E322C31322C31362C31327A
          222F3E0D0A3C7061746820636C6173733D22426C61636B2220643D224D31362C
          38632D312E322C302D322E342C302E322D332E352C302E356C312E372C312E37
          63302E362D302E322C312E312D302E332C312E372D302E3363332E332C302C36
          2C322E372C362C3663302C302E362D302E312C312E322D302E332C312E372020
          2623393B6C332E312C332E314332382C31382E362C33302C31362C33302C3136
          5332342C382C31362C387A222F3E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F6373732220786D6C3A737061
          63653D227072657365727665223E2E426C75657B66696C6C3A23313137374437
          3B7D262331333B262331303B2623393B2E59656C6C6F777B66696C6C3A234646
          423131353B7D262331333B262331303B2623393B2E426C61636B7B66696C6C3A
          233732373237323B7D262331333B262331303B2623393B2E477265656E7B6669
          6C6C3A233033394332333B7D262331333B262331303B2623393B2E5265647B66
          696C6C3A234431314331433B7D262331333B262331303B2623393B2E7374307B
          6F7061636974793A302E37353B7D262331333B262331303B2623393B2E737431
          7B6F7061636974793A302E353B7D3C2F7374796C653E0D0A3C672069643D2254
          72617368223E0D0A09093C7061746820636C6173733D22426C61636B2220643D
          224D382C323763302C302E352C302E352C312C312C3168313463302E352C302C
          312D302E352C312D3156313248385632377A222F3E0D0A09093C706174682063
          6C6173733D22426C61636B2220643D224D32352C36682D37563563302D302E35
          2D302E352D312D312D31682D32632D302E352C302D312C302E352D312C317631
          483743362E352C362C362C362E352C362C37763368323056374332362C362E35
          2C32352E352C362C32352C367A222F3E0D0A093C2F673E0D0A3C2F7376673E0D
          0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F6373732220786D6C3A737061
          63653D227072657365727665223E2E426C61636B7B66696C6C3A233732373237
          323B7D262331333B262331303B2623393B2E426C75657B66696C6C3A23313137
          3744373B7D262331333B262331303B2623393B2E477265656E7B66696C6C3A23
          3033394332333B7D262331333B262331303B2623393B2E59656C6C6F777B6669
          6C6C3A234646423131353B7D262331333B262331303B2623393B2E5265647B66
          696C6C3A234431314331433B7D262331333B262331303B2623393B2E57686974
          657B66696C6C3A234646464646463B7D262331333B262331303B2623393B2E73
          74307B6F7061636974793A302E353B7D262331333B262331303B2623393B2E73
          74317B6F7061636974793A302E37353B7D3C2F7374796C653E0D0A3C67206964
          3D224368616E6765436861727454797065223E0D0A09093C7061746820636C61
          73733D2259656C6C6F772220643D224D31302C33304834762D3868365633307A
          204D31382C3138682D3676313268365631387A204D32362C3134682D36763136
          68365631347A222F3E0D0A09093C7061746820636C6173733D22426C75652220
          643D224D32332C32632D312E372C302D332C312E332D332C3363302C302E352C
          302E312C302E392C302E332C312E336C2D342C344331352E392C31302E312C31
          352E352C31302C31352C3130632D302E392C302D312E362C302E342D322E322C
          302E394C31302C392E3220202623393B2623393B63302D302E312C302D302E31
          2C302D302E3263302D312E372D312E332D332D332D3353342C372E332C342C39
          73312E332C332C332C3363302E392C302C312E362D302E342C322E322D302E39
          6C322E392C312E3763302C302E312C302C302E312C302C302E3263302C312E37
          2C312E332C332C332C3320202623393B2623393B73332D312E332C332D336330
          2D302E352D302E312D302E392D302E332D312E336C342D344332322E312C372E
          392C32322E352C382C32332C3863312E372C302C332D312E332C332D33533234
          2E372C322C32332C327A204D372C3130632D302E362C302D312D302E342D312D
          3173302E342D312C312D3120202623393B2623393B73312C302E342C312C3153
          372E362C31302C372C31307A204D31352C3134632D302E362C302D312D302E34
          2D312D3173302E342D312C312D3173312C302E342C312C315331352E362C3134
          2C31352C31347A204D32332C36632D302E362C302D312D302E342D312D317330
          2E342D312C312D3173312C302E342C312C3120202623393B2623393B5332332E
          362C362C32332C367A222F3E0D0A093C2F673E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F6373732220786D6C3A737061
          63653D227072657365727665223E2E426C75657B66696C6C3A23313137374437
          3B7D262331333B262331303B2623393B2E59656C6C6F777B66696C6C3A234646
          423131353B7D262331333B262331303B2623393B2E426C61636B7B66696C6C3A
          233732373237323B7D262331333B262331303B2623393B2E477265656E7B6669
          6C6C3A233033394332333B7D262331333B262331303B2623393B2E5265647B66
          696C6C3A234431314331433B7D262331333B262331303B2623393B2E7374307B
          6F7061636974793A302E37353B7D262331333B262331303B2623393B2E737431
          7B6F7061636974793A302E353B7D3C2F7374796C653E0D0A3C672069643D2241
          6464223E0D0A09093C7061746820636C6173733D22477265656E2220643D224D
          32372C3134682D39563563302D302E352D302E352D312D312D31682D32632D30
          2E352C302D312C302E352D312C3176394835632D302E352C302D312C302E352D
          312C31763263302C302E352C302E352C312C312C316839763920202623393B26
          23393B63302C302E352C302E352C312C312C31683263302E352C302C312D302E
          352C312D31762D39683963302E352C302C312D302E352C312D31762D32433238
          2C31342E352C32372E352C31342C32372C31347A222F3E0D0A093C2F673E0D0A
          3C2F7376673E0D0A}
      end>
  end
  object pmChart: TPopupMenu
    Images = ilPopupMenu
    Left = 272
    Top = 120
    object XYDiagram1: TMenuItem
      Action = aAddXYDiagram
    end
    object SimpleDiagram1: TMenuItem
      Action = aAddSimpleDiagram
    end
  end
  object ilPopupMenu: TcxImageList
    SourceDPI = 96
    FormatVersion = 1
    Left = 288
    Top = 160
    Bitmap = {
      494C010111001800040010001000FFFFFFFF2110FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000005000000001002000000000000050
      0000000000000000000000000000000000004224048ECF7210FA462605920000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C76E0FF608040033D37410FD0201
      0019000000000000000000000000000000000000000000000000000000000000
      0000000000003C210487CD7010F9462605920000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000003E22048AC76E0FF66D3C08B6B463
      0EEA4124048D0100001700000000000000000000000000000000000000000201
      001E23130268CF7210FA08040033CF7210FA0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000100
      00153E220489B3630DE9703D08B8CD7010F94D2B05993B20048691500BD19E57
      0CDB442505904D2A0599C76E0FF54224048E0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000001000015CF7210FA08040033D27410FC2A170372050200270000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000003E22048AC76E0FF53E22048900000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000006364F8E14A9F3F905344C8B00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000C02141D5714ABF7FB00060A3314ADF9FC031E2B6A000204210000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000006364F8E14A9F3F9084667A2094F
      74AC1194D6EA094C6EA807415F9C13A3EBF507405E9B0637508F0F81BADA0F7D
      B5D706364F8E0639539214A9F3F9063953920000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000013A5EDF600060A3314ADF9FC0212
      1A530000000A0000000000000000000000000000000000000000000000000003
      05260322317114ABF7FB00060A3314A9F5FA0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000005334A8A13A4EDF605334A8A0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000532498913A3EBF505334A8A0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000808408E1A1AC9FA0808408E0000
      0000000000000000000008083C8A1A1AC7F90808408E00000000000000000000
      00000000000008083C8A1A1AC9FA090943920000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000001919C3F6000008331B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF000008331B1BD1FF1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF000008331B1BC9FA0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000008083C8A1919C2F608083C8A0000
      00000000000000000000070739861919C1F508083C8A00000000000000000000
      000000000000070739861919C2F60808408E0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000004224058ECE7110FA462605920000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000004224048ECE7110FA4224048E0000
      000000000000000000003E22048ACD7010F947270593140A014E2B1703734A29
      0597744009BCD47410FD08040033CE7110FA00000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FF0000000000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FF00000000000000001B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF00000000C76E0FF608040033D77610FFD776
      10FFD77610FFD77610FFD77610FF08040033D17310FC6E3C08B6462605922715
      026D1109014944250590C76E0FF53F23048A00000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FF0000000000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FF00000000000000001B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF000000003E22048AC76E0FF63E22048A0000
      000000000000000000003B200486C76D0FF53E22048A00000000000000000000
      00000000000000000000000000000000000000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FF0000000000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFBD7E
      30FF8D8D6BFF5B9CA8FF2BAAE3FF00000000000000001B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1A2F
      D7FF1854E3FF1779EEFF15A0FAFF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000071958EFFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FF000000000000000023ADEDFF43A3C5FF6399
      9EFF859075FFA5864DFFC57B26FFBD7E30FF8D8D6BFF5B9CA8FF2BAAE3FF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF000000000000000015A6FCFF168DF4FF1773
      ECFF185AE5FF1941DDFF1A29D5FF1A2FD7FF1854E3FF1779EEFF15A0FAFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF000000000000000000000000000000000000
      0000000000000000000006364F8E14A9F3F905344C8B00000000000000000000
      0000000000000000000000000000000000000000000014B1FFFF71958EFFD776
      10FFD27410FC6A3A08B36E3C08B6D57610FED77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FF000000000000000014B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF000000000000000014B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF000000000000000000000000000000000000
      00000000000C02141D5714ABF7FB00060A3314ADF9FC031E2B6A000204210000
      0000000000000000000000000000000000000000000014B1FFFF14B1FFFF6582
      77EE532D069F351D037F351D037F5F3407AAD07210FBD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FF000000000000000014B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF000000000000000014B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF0000000006364F8E14A9F3F9084667A2094F
      74AC1194D6EA094C6EA807415F9C13A3EBF507405E9B0637508F0F81BADA0F7D
      B5D706364F8E0639539214A9F3F9063953920000000014B1FFFF0D6FA0CA0002
      031E0C06003D351D037F351D037F351D037F532D069FC96E0FF7D77610FFD776
      10FFC77B23FF829078FF38A6D3FF000000000000000014B1FFFF14B1FFFF14B1
      FFFF1597F7FF1864E8FF1A33D8FF1A36D9FF176DEAFF15A4FBFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF000000000000000014B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF0000000013A5EDF600060A3314ADF9FC0212
      1A530000000A0000000000000000000000000000000000000000000000000003
      05260322317114ABF7FB00060A3314A9F5FA0000000007405E9B000000070000
      0000000000000C06003D351D037F351D037F351D037F472705938A6F40E9529E
      B3FF18B0FAFF14B1FFFF14B1FFFF00000000000000001597F7FF1864E8FF1A33
      D8FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1ED2FF1948DFFF1681
      F0FF14ADFEFF14B1FFFF14B1FFFF000000000000000014B1FFFF14B1FFFF14B1
      FFFF36A7D5FF779486FFB88036FFB5813AFF6B9795FF25ACEAFF14B1FFFF14B1
      FFFF14B1FFFF14B1FFFF14B1FFFF0000000005334A8A13A4EDF605334A8A0000
      000000000000000000000808408E1A1AC9FA0909439200000000000000000000
      0000000000000532498913A3EBF505334A8A0000000000000000000000000000
      000000000000000000000C06003D231302670A0500380000000B0002031D0E79
      AED314B1FFFF14B1FFFF14B1FFFF00000000000000001B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1B
      D1FF1A26D5FF185BE5FF1594F6FF000000000000000036A7D5FF779486FFB880
      36FFD77610FFD77610FFD77610FFD77610FFD77610FFD47714FF9C8958FF539E
      B2FF19B0F9FF14B1FFFF14B1FFFF000000000000000000000000000000000000
      000000000000000003201B1BC9FB000008331B1BCDFD00000116000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      01100B638FBF14B1FFFF14B1FFFF00000000000000001B1BD1FF1B1BD1FF1B1B
      D1FF12128ED20606327E0000052901010C3E0F0F73BD1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF0000000000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFC87A22FF849076FF3AA6D0FF000000000000000000000000000000000000
      021D0A0A49971818BAF10F0F73BD1919C1F5111182CA1818B7EF05052B740000
      0006000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000007094B6DA714B1FFFF000000000000000012128ED20606327E0000
      0529000000000000000000000000000000000000000001010C3E0F0F73BD1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF0000000000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FF000000000808408E1A1AC9FA0F0F78C11818
      B6EE0808408E0000011900000000000000000000000001010B3B111182CA1414
      9ADB020214500000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000105344C8B000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000101
      0C3E0F0F73BD1B1BD1FF1B1BD1FF0000000000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FF000000001919C3F6000008331B1BCCFC0000
      0117000000000000000000000000000000000000000000000000000000010303
      1A5C1616A5E2141496D81A1AC7F9090943920000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000001010C3E0F0F73BD0000000000000000D77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FF0000000008083C8A1919C3F60808408E0000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000A1A1AC7F9000008331B1BC9FA0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000008083C8A1919C3F60808408E0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000001B1BD1FF1B1B
      D1FF1B1BD1FF000000001B1BD1FF1B1BD1FF1B1BD1FF000000001B1BD1FF1B1B
      D1FF1B1BD1FF000000000000000000000000000000001C1C1C7F1C1C1C7F1C1C
      1C7F14B1FFFF14B1FFFF14B1FFFF00000000000000001C1C1C7F1C1C1C7F1C1C
      1C7F14B1FFFF14B1FFFF14B1FFFF000000000000000000000000000000000000
      0000000000000000000000000000D77610FFD77610FF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000371E0482371E048200000000000000000000
      00000000000000000000000000000000000000000000000000001B1BD1FF1B1B
      D1FF1B1BD1FF000000001B1BD1FF1B1BD1FF1B1BD1FF000000001B1BD1FF1B1B
      D1FF1B1BD1FF000000000000000000000000000000001C1C1C7F1C1C1C7F1C1C
      1C7F14B1FFFF14B1FFFF14B1FFFF00000000000000001C1C1C7F1C1C1C7F1C1C
      1C7F14B1FFFF14B1FFFF14B1FFFF000000000000000000000000000000000000
      0000000000000000000000000000D77610FFD77610FF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000371E0482D77610FFD77610FF371E0482000000000000
      00000000000000000000000000000000000000000000000000001B1BD1FF1B1B
      D1FF1B1BD1FF000000001B1BD1FF1B1BD1FF1B1BD1FF000000001B1BD1FF1B1B
      D1FF1B1BD1FF000000000000000000000000000000001C1C1C7F1C1C1C7F1C1C
      1C7F14B1FFFF14B1FFFF14B1FFFF00000000000000001C1C1C7F1C1C1C7F1C1C
      1C7F14B1FFFF14B1FFFF14B1FFFF000000000000000000000000000000000000
      0000000000000000000000000000D77610FFD77610FF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000371E0482D77610FFD77610FFD77610FFD77610FF371E04820000
      00000000000000000000000000000000000000000000000000001B1BD1FF1B1B
      D1FF1B1BD1FF0000000014B1FFFF14B1FFFF14B1FFFF000000001B1BD1FF1B1B
      D1FF1B1BD1FF000000000000000000000000000000001C1C1C7F1C1C1C7F1C1C
      1C7F14B1FFFF14B1FFFF14B1FFFF00000000000000001C1C1C7F1C1C1C7F1C1C
      1C7F14B1FFFF14B1FFFF14B1FFFF000000000000000000000000000000000000
      0000000000000000000000000000D77610FFD77610FF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000371E0482D77610FFD77610FFD77610FFD77610FFD77610FFD77610FF371E
      048200000000000000000000000000000000000000000000000014B1FFFF14B1
      FFFF14B1FFFF0000000014B1FFFF14B1FFFF14B1FFFF0000000014B1FFFF14B1
      FFFF14B1FFFF000000000000000000000000000000001C1C1C7F1C1C1C7F1C1C
      1C7FD77610FFD77610FFD77610FF00000000000000001C1C1C7F1C1C1C7F1C1C
      1C7F14B1FFFF14B1FFFF14B1FFFF000000000000000000000000000000000000
      0000000000000000000000000000D77610FFD77610FF00000000000000000000
      000000000000000000000000000000000000000000000000000000000000371E
      0482D77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FF371E0482000000000000000000000000000000000000000014B1FFFF14B1
      FFFF14B1FFFF0000000014B1FFFF14B1FFFF14B1FFFF0000000014B1FFFF14B1
      FFFF14B1FFFF000000000000000000000000000000001C1C1C7F1C1C1C7F1C1C
      1C7FD77610FFD77610FFD77610FF00000000000000001B1BD1FF1B1BD1FF1B1B
      D1FF14B1FFFF14B1FFFF14B1FFFF000000000000000000000000000000000000
      0000000000000000000000000000D77610FFD77610FF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000D77610FFD77610FF00000000000000000000
      000000000000000000000000000000000000000000000000000014B1FFFF14B1
      FFFF14B1FFFF0000000014B1FFFF14B1FFFF14B1FFFF0000000014B1FFFF14B1
      FFFF14B1FFFF000000000000000000000000000000001C1C1C7F1C1C1C7F1C1C
      1C7FD77610FFD77610FFD77610FF00000000000000001B1BD1FF1B1BD1FF1B1B
      D1FF14B1FFFF14B1FFFF14B1FFFF000000000000000000000000000000000000
      0000000000000000000000000000D77610FFD77610FF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000D77610FFD77610FF00000000000000000000
      000000000000000000000000000000000000000000000000000014B1FFFF14B1
      FFFF14B1FFFF0000000014B1FFFF14B1FFFF14B1FFFF00000000D77610FFD776
      10FFD77610FF000000000000000000000000000000001C1C1C7F1C1C1C7F1C1C
      1C7FD77610FFD77610FFD77610FF00000000000000001B1BD1FF1B1BD1FF1B1B
      D1FF14B1FFFF14B1FFFF14B1FFFF00000000000000000000000000000000341D
      037ED77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD77610FFD776
      10FF341D037E0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000D77610FFD77610FF00000000000000000000
      0000000000000000000000000000000000000000000000000000D77610FFD776
      10FFD77610FF0000000014B1FFFF14B1FFFF14B1FFFF00000000D77610FFD776
      10FFD77610FF000000000000000000000000000000001B1BD1FF1B1BD1FF1B1B
      D1FFD77610FFD77610FFD77610FF00000000000000001B1BD1FF1B1BD1FF1B1B
      D1FF14B1FFFF14B1FFFF14B1FFFF000000000000000000000000000000000000
      0000341D037ED77610FFD77610FFD77610FFD77610FFD77610FFD77610FF341D
      037E000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000D77610FFD77610FF00000000000000000000
      0000000000000000000000000000000000000000000000000000D77610FFD776
      10FFD77610FF00000000D77610FFD77610FFD77610FF00000000D77610FFD776
      10FFD77610FF000000000000000000000000000000001B1BD1FF1B1BD1FF1B1B
      D1FFD77610FFD77610FFD77610FF00000000000000001B1BD1FF1B1BD1FF1B1B
      D1FFD77610FFD77610FFD77610FF000000000000000000000000000000000000
      000000000000341D037ED77610FFD77610FFD77610FFD77610FF341D037E0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000D77610FFD77610FF00000000000000000000
      0000000000000000000000000000000000000000000000000000D77610FFD776
      10FFD77610FF00000000D77610FFD77610FFD77610FF00000000D77610FFD776
      10FFD77610FF000000000000000000000000000000001B1BD1FF1B1BD1FF1B1B
      D1FFD77610FFD77610FFD77610FF00000000000000001B1BD1FF1B1BD1FF1B1B
      D1FFD77610FFD77610FFD77610FF000000000000000000000000000000000000
      00000000000000000000341D037ED77610FFD77610FF341D037E000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000D77610FFD77610FF00000000000000000000
      0000000000000000000000000000000000000000000000000000D77610FFD776
      10FFD77610FF00000000D77610FFD77610FFD77610FF00000000D77610FFD776
      10FFD77610FF000000000000000000000000000000001B1BD1FF1B1BD1FF1B1B
      D1FFD77610FFD77610FFD77610FF00000000000000001B1BD1FF1B1BD1FF1B1B
      D1FFD77610FFD77610FFD77610FF000000000000000000000000000000000000
      0000000000000000000000000000341D037E341D037E00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000D77610FFD77610FF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000004224048ECF7210FA462605920000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C76E0FF608040033CD7010F90000
      0000000000000000000006364F8E14A9F5FA0639539200000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000003E22048AC76D0FF5BA670EEE391F
      0484000000020000000013A3EBF500060A3314A9F5FA00000000000000000000
      0000000000000000000000000000000000000000000000000000D77610FFD776
      10FFD77610FF0000000014B1FFFF14B1FFFF14B1FFFF000000001B1BD1FF1B1B
      D1FF1B1BD1FF00000000000000000000000000000000000000001B1BD1FF1B1B
      D1FF1B1BD1FF000000001B1BD1FF1B1BD1FF1B1BD1FF000000001B1BD1FF1B1B
      D1FF1B1BD1FF000000000000000000000000000000001C1C1C7F1C1C1C7F1C1C
      1C7F14B1FFFF14B1FFFF14B1FFFF00000000000000001C1C1C7F1C1C1C7F1C1C
      1C7F14B1FFFF14B1FFFF14B1FFFF0000000000000000000000000201001A8649
      0AC9633608AD092D3D83129ADEEE13A3EBF5129CE1F0010B1040000000000000
      0000000000004124048DCE7110FA462605920000000000000000D77610FFD776
      10FFD77610FF0000000014B1FFFF14B1FFFF14B1FFFF000000001B1BD1FF1B1B
      D1FF1B1BD1FF00000000000000000000000000000000000000001B1BD1FF1B1B
      D1FF1B1BD1FF000000001B1BD1FF1B1BD1FF1B1BD1FF000000001B1BD1FF1B1B
      D1FF1B1BD1FF000000000000000000000000000000001C1C1C7F1C1C1C7F1C1C
      1C7F14B1FFFF14B1FFFF14B1FFFF00000000000000001C1C1C7F1C1C1C7F1C1C
      1C7F14B1FFFF14B1FFFF14B1FFFF000000000000000000000000000000000000
      0013867349EBB0803CFD060706390000000001090D3B1192D1E7010B10410603
      002B2D190375D07210FB08040033CF7210FA0000000000000000D77610FFD776
      10FFD77610FF0000000014B1FFFF14B1FFFF14B1FFFF000000001B1BD1FF1B1B
      D1FF1B1BD1FF000000000000000000000000000000000000000014B1FFFF14B1
      FFFF14B1FFFF000000001B1BD1FF1B1BD1FF1B1BD1FF000000001B1BD1FF1B1B
      D1FF1B1BD1FF000000000000000000000000000000001C1C1C7F1C1C1C7F1C1C
      1C7F14B1FFFF14B1FFFF14B1FFFF00000000000000001C1C1C7F1C1C1C7F1C1C
      1C7F14B1FFFF14B1FFFF14B1FFFF0000000000000000000000000002031C0D71
      A3CC094D70AA341D057FBF690FF0CF7210FA512C069D624A27C0BE7C2CFEAC66
      19EA472705934A290597C76E0FF54224048E0000000000000000D77610FFD776
      10FFD77610FF0000000014B1FFFF14B1FFFF14B1FFFF000000001B1BD1FF1B1B
      D1FF1B1BD1FF000000000000000000000000000000000000000014B1FFFF14B1
      FFFF14B1FFFF0000000014B1FFFF14B1FFFF14B1FFFF000000001B1BD1FF1B1B
      D1FF1B1BD1FF000000000000000000000000000000001C1C1C7F1C1C1C7F1C1C
      1C7F14B1FFFF14B1FFFF14B1FFFF00000000000000001C1C1C7F1C1C1C7F1C1C
      1C7F14B1FFFF14B1FFFF14B1FFFF0000000006364F8E14A9F3F9129CE1F0052C
      40800000000100000000C76D0FF508040033D27410FC2B1703720C100F541192
      D1E7010B10400000000000000000000000000000000000000000D77610FFD776
      10FFD77610FF0000000014B1FFFF14B1FFFF14B1FFFF000000001B1BD1FF1B1B
      D1FF1B1BD1FF0000000000000000000000000000000000000000D77610FFD776
      10FFD77610FF0000000014B1FFFF14B1FFFF14B1FFFF000000001B1BD1FF1B1B
      D1FF1B1BD1FF000000000000000000000000000000001B1BD1FF1B1BD1FF1B1B
      D1FF14B1FFFF14B1FFFF14B1FFFF00000000000000001C1C1C7F1C1C1C7F1C1C
      1C7F14B1FFFF14B1FFFF14B1FFFF0000000013A5EDF600060A3314A9F3F90000
      000000000000000000003E22048AC76E0FF64124048D00000000000000000109
      0D3B1192D1E7010B104000000000000000000000000000000000D77610FFD776
      10FFD77610FF0000000014B1FFFF14B1FFFF14B1FFFF000000001B1BD1FF1B1B
      D1FF1B1BD1FF0000000000000000000000000000000000000000D77610FFD776
      10FFD77610FF0000000014B1FFFF14B1FFFF14B1FFFF000000001B1BD1FF1B1B
      D1FF1B1BD1FF000000000000000000000000000000001B1BD1FF1B1BD1FF1B1B
      D1FF14B1FFFF14B1FFFF14B1FFFF00000000000000001C1C1C7F1C1C1C7F1C1C
      1C7FD77610FFD77610FFD77610FF0000000005334A8A13A5EDF606364F8E0000
      0000000000000000000000000000000000000000000000000000000000000000
      000001090D3B129CE1F014A9F5FA063953920000000000000000000000000000
      0000000000000000000014B1FFFF14B1FFFF14B1FFFF000000001B1BD1FF1B1B
      D1FF1B1BD1FF0000000000000000000000000000000000000000000000000000
      00000000000000000000D77610FFD77610FFD77610FF0000000014B1FFFF14B1
      FFFF14B1FFFF000000000000000000000000000000001B1BD1FF1B1BD1FF1B1B
      D1FF14B1FFFF14B1FFFF14B1FFFF00000000000000001C1C1C7F1C1C1C7F1C1C
      1C7FD77610FFD77610FFD77610FF000000000000000000000000000000000000
      000000000000000000000808408E1A1AC9FA0909439200000000000000000000
      00000000000013A4EDF600060A3314A9F5FA0000000000000000000000000000
      0000000000000000000014B1FFFF14B1FFFF14B1FFFF000000001B1BD1FF1B1B
      D1FF1B1BD1FF0000000000000000000000000000000000000000000000000000
      00000000000000000000D77610FFD77610FFD77610FF0000000014B1FFFF14B1
      FFFF14B1FFFF0000000000000000000000000000000000000000000000000000
      0000D77610FFD77610FFD77610FF00000000000000001C1C1C7F1C1C1C7F1C1C
      1C7FD77610FFD77610FFD77610FF000000000000000000000000000000000000
      000000000000000003201B1BC9FB000008331B1BCDFD00000116000000000000
      00000000000005334A8A13A5EDF606364F8E0000000000000000000000000000
      0000000000000000000014B1FFFF14B1FFFF14B1FFFF000000001B1BD1FF1B1B
      D1FF1B1BD1FF0000000000000000000000000000000000000000000000000000
      00000000000000000000D77610FFD77610FFD77610FF0000000014B1FFFF14B1
      FFFF14B1FFFF0000000000000000000000000000000000000000000000000000
      0000D77610FFD77610FFD77610FF00000000000000001C1C1C7F1C1C1C7F1C1C
      1C7FD77610FFD77610FFD77610FF000000000000000000000000000000000000
      021D0A0A49971818BAF10F0F73BD1919C1F5111182CA1818B7EF05052B740000
      0006000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000001B1BD1FF1B1B
      D1FF1B1BD1FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D77610FFD776
      10FFD77610FF0000000000000000000000000000000000000000000000000000
      0000D77610FFD77610FFD77610FF00000000000000001B1BD1FF1B1BD1FF1B1B
      D1FF000000000000000000000000000000000808408E1A1AC9FA0F0F78C11818
      B6EE0808408E0000011900000000000000000000000001010B3B111182CA1414
      9ADB020214500000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000001B1BD1FF1B1B
      D1FF1B1BD1FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D77610FFD776
      10FFD77610FF0000000000000000000000000000000000000000000000000000
      0000D77610FFD77610FFD77610FF00000000000000001B1BD1FF1B1BD1FF1B1B
      D1FF000000000000000000000000000000001919C3F6000008331B1BCCFC0000
      0117000000000000000000000000000000000000000000000000000000010303
      1A5C1616A5E2141496D81A1AC7F9090943920000000000000000000000000000
      00000000000000000000000000000000000000000000000000001B1BD1FF1B1B
      D1FF1B1BD1FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D77610FFD776
      10FFD77610FF0000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000001B1BD1FF1B1BD1FF1B1B
      D1FF0000000000000000000000000000000008083C8A1919C3F60808408E0000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000A1A1AC7F9000008331B1BC9FA0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000008083C8A1919C3F60808408E0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0003030318570D0D66B21616A9E6000000001191D1E70A567DB302151E590000
      0003000000000000000000000000000000000000000000000000000000000000
      0003030318570D0D66B21616A9E6000000001191D1E70A567DB302151E590000
      0003000000000000000000000000000000000000000000000000000000000000
      0003030318570D0D66B21616A9E60000000012A1E7F30C6490C0031B27650000
      0006000000000000000000000000000000000000000014B1FFFF14B1FFFF14B1
      FFFFD77610FFD77610FFD77610FF000000000000000014B1FFFF14B1FFFF14B1
      FFFFD77610FFD77610FFD77610FF000000000000000000000000000003231111
      85CB1B1BD1FF1B1BD1FF1B1BD1FF0000000014B1FFFF14B1FFFF14B1FFFF0D71
      A3CC000204210000000000000000000000000000000000000000000003231111
      85CB1B1BD1FF1B1BD1FF1B1BD1FF0000000014B1FFFF14B1FFFF14B1FFFF0D71
      A3CC000204210000000000000000000000000000000000000000000003231111
      85CB1B1BD1FF1B1BD1FF1B1BD1FF0000000014B1FFFF14B1FFFF14B1FFFF0F7D
      B3D6000305260000000000000000000000000000000014B1FFFF14B1FFFF14B1
      FFFFD77610FFD77610FFD77610FF000000000000000014B1FFFF14B1FFFF14B1
      FFFFD77610FFD77610FFD77610FF0000000000000000000004241616ACE71B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF0000000014B1FFFF14B1FFFF14B1FFFF0C6C
      9BC70101011C04020026000000000000000000000000000004241616ACE71B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF0000000014B1FFFF14B1FFFF14B1FFFF0C6C
      9BC70101011C04020026000000000000000000000000000004241616ACE71B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF0000000014B1FFFF14B1FFFF14B1FFFF0C65
      92C1010101180402002600000000000000000000000014B1FFFF14B1FFFF14B1
      FFFFD77610FFD77610FFD77610FF000000000000000014B1FFFF14B1FFFF14B1
      FFFFD77610FFD77610FFD77610FF0000000000000003121287CD1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF0000000014B1FFFF14B1FFFF0C6A99C60101
      011A7B4309C197530BD6000000060000000000000003121287CD1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF0000000014B1FFFF14B1FFFF0C6A99C60101
      011A7B4309C197530BD6000000060000000000000003121287CD1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF0000000014B1FFFF14B1FFFF0C6592C10101
      01187B4309C197530BD600000006000000000000000014B1FFFF14B1FFFF14B1
      FFFFD77610FFD77610FFD77610FF000000000000000014B1FFFF14B1FFFF14B1
      FFFFD77610FFD77610FFD77610FF0000000003031A5B1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF0000000014B1FFFF0C6896C4010101197B43
      09C1D77610FFD77610FF201102630000000003031A5B1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF0000000014B1FFFF0C6896C4010101197B43
      09C1D77610FFD77610FF201102630000000003031A5B1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF0C0C60AD01010835000000000004062A042B3F7F010101187B43
      09C1D77610FFD77610FF20110263000000000000000014B1FFFF14B1FFFF14B1
      FFFFD77610FFD77610FFD77610FF000000000000000014B1FFFF14B1FFFF14B1
      FFFFD77610FFD77610FFD77610FF000000000E0E6AB61B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF000000000C6592C1010101187B4309C1D776
      10FFD77610FFD77610FF744009BC000000000E0E6AB61B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF000000000C6592C1010101187B4309C1D776
      10FFD77610FFD77610FF744009BC000000000E0E6AB61B1BD1FF1B1BD1FF1B1B
      D1FF0C0C5EAB0000000100000000000000000000000000000000351D037FD776
      10FFD77610FFD77610FF744009BC000000000000000014B1FFFF14B1FFFF14B1
      FFFFD77610FFD77610FFD77610FF000000000000000014B1FFFF14B1FFFF14B1
      FFFFD77610FFD77610FFD77610FF000000001717B0EA1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF00000000010101187B4309C1D77610FFD776
      10FFD77610FFD77610FFBC670EEF000000001717B0EA1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF00000000010101187B4309C1D77610FFD776
      10FFD77610FFD77610FFBC670EEF000000001717B0EA1B1BD1FF1B1BD1FF1B1B
      D1FF0000062D000000000000000000000000000000000000000004020026D776
      10FFD77610FFD77610FFBC670EEF000000000000000000000000000000000000
      0000D77610FFD77610FFD77610FF000000000000000014B1FFFF14B1FFFF14B1
      FFFFD77610FFD77610FFD77610FF000000001B1BCAFB1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF0000000D4023048BD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FF000000001B1BCAFB1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF0000000D4023048BD77610FFD77610FFD776
      10FFD77610FFD77610FFD77610FF000000001B1BCAFB1B1BD1FF1B1BD1FF1B1B
      D1FF00000006000000000000000000000000000000000000000000000002D776
      10FFD77610FFD77610FFD77610FF000000000000000000000000000000000000
      0000D77610FFD77610FFD77610FF000000000000000014B1FFFF14B1FFFF14B1
      FFFFD77610FFD77610FFD77610FF000000001717B0EA1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF10107CC400000118784209BFD77610FFD776
      10FFD77610FFD77610FFBB670EEE000000001717B0EA1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF10107CC400000118784209BFD77610FFD776
      10FFD77610FFD77610FFBB670EEE000000001717B0EA1B1BD1FF1B1BD1FF1B1B
      D1FF00000427000000000000000000000000000000000000000005020027D776
      10FFD77610FFD77610FFBB670EEE000000000000000000000000000000000000
      0000D77610FFD77610FFD77610FF000000000000000014B1FFFF14B1FFFF14B1
      FFFFD77610FFD77610FFD77610FF000000000E0E6AB61B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF10107CC400000118784209BFD776
      10FFD77610FFD77610FF723E08B9000000000E0E6AB61B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF10107CC400000118784209BFD776
      10FFD77610FFD77610FF723E08B9000000000E0E6AB61B1BD1FF1B1BD1FF1B1B
      D1FF0A0A509E0000000000000000000000000000000000000000351D037FD776
      10FFD77610FFD77610FF723E08B9000000000000000000000000000000000000
      0000D77610FFD77610FFD77610FF000000000000000014B1FFFF14B1FFFF14B1
      FFFF0000000000000000000000000000000003031A5C1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF10107CC4000001187842
      09BFD77610FFD77610FF1D10025F0000000003031A5C1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF10107CC4000001187842
      09BFD77610FFD77610FF1D10025F0000000003031A5C1B1BD1FF1B1BD1FF1B1B
      D1FF1B1BD1FF0A0A4B9A0000021E000000000000021D05052C76000000147842
      09BFD77610FFD77610FF1D10025F000000000000000000000000000000000000
      0000D77610FFD77610FFD77610FF000000000000000014B1FFFF14B1FFFF14B1
      FFFF000000000000000000000000000000000000000412128ACF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF10107CC40000
      0118784209BF92500BD200000004000000000000000412128ACF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF10107CC40000
      0118784209BF92500BD200000004000000000000000412128ACF1B1BD1FF1B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1A1AC4F71B1BD1FF1B1BD1FF0F0F71BC0000
      0014784209BF92500BD200000004000000000000000000000000000000000000
      0000000000000000000000000000000000000000000014B1FFFF14B1FFFF14B1
      FFFF0000000000000000000000000000000000000000000004261717AEE91B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1010
      7CC40000011803020023000000000000000000000000000004261717AEE91B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1010
      7CC40000011803020023000000000000000000000000000004261717AEE91B1B
      D1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF0F0F
      71BC000000140302002300000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000004261212
      8ACF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1212
      8CD1000004240000000000000000000000000000000000000000000004261212
      8ACF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1212
      8CD1000004240000000000000000000000000000000000000000000004261212
      8ACF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1B1BD1FF1414
      93D6000004270000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000403031A5B0E0E6AB61717B0EA1B1BC9FB1717B1EB0E0E6BB703031B5D0000
      0004000000000000000000000000000000000000000000000000000000000000
      000403031A5B0E0E6AB61717B0EA1B1BC9FB1717B1EB0E0E6BB703031B5D0000
      0004000000000000000000000000000000000000000000000000000000000000
      000403031A5B0E0E6AB61717B0EA1B1BC9FB1717B1EB0E0E6CB803031C5F0000
      000500000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000500000000100010000000000800200000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000}
    DesignInfo = 10486048
    ImageInfo = <
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D2243
          72656174655F4261725F43686172742220786D6C6E733D22687474703A2F2F77
          77772E77332E6F72672F323030302F7376672220786D6C6E733A786C696E6B3D
          22687474703A2F2F7777772E77332E6F72672F313939392F786C696E6B222078
          3D223070782220793D22307078222076696577426F783D223020302033322033
          3222207374796C653D22656E61626C652D6261636B67726F756E643A6E657720
          3020302033322033323B2220786D6C3A73706163653D22707265736572766522
          3E262331333B262331303B3C7374796C6520747970653D22746578742F637373
          2220786D6C3A73706163653D227072657365727665223E2E426C75657B66696C
          6C3A233131373744373B7D262331333B262331303B2623393B2E59656C6C6F77
          7B66696C6C3A234646423131353B7D3C2F7374796C653E0D0A3C706174682063
          6C6173733D2259656C6C6F772220643D224D382C323848325631366836563238
          7A204D32342C34682D36763234683656347A222F3E0D0A3C7061746820636C61
          73733D22426C75652220643D224D31342C32384838563668365632387A204D33
          302C3130682D3676313868365631307A222F3E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F6373732220786D6C3A737061
          63653D227072657365727665223E2E5265647B66696C6C3A234431314331433B
          7D262331333B262331303B2623393B2E59656C6C6F777B66696C6C3A23464642
          3131353B7D262331333B262331303B2623393B2E426C75657B66696C6C3A2331
          31373744373B7D262331333B262331303B2623393B2E477265656E7B66696C6C
          3A233033394332333B7D262331333B262331303B2623393B2E426C61636B7B66
          696C6C3A233732373237323B7D262331333B262331303B2623393B2E57686974
          657B66696C6C3A234646464646463B7D262331333B262331303B2623393B2E73
          74307B6F7061636974793A302E353B7D262331333B262331303B2623393B2E73
          74317B6F7061636974793A302E37353B7D262331333B262331303B2623393B2E
          7374327B6F7061636974793A302E33353B7D262331333B262331303B2623393B
          2E7374337B6F7061636974793A302E36353B7D3C2F7374796C653E0D0A3C6720
          69643D22506965223E0D0A09093C7061746820636C6173733D22426C75652220
          643D224D32362E332C352E314C31362E342C31356C392E392C392E3963322E33
          2D322E362C332E372D362E312C332E372D392E395332382E362C372E382C3236
          2E332C352E317A222F3E0D0A09093C7061746820636C6173733D225265642220
          643D224D31342C3136762D31762D302E344C32342E392C332E374332322E322C
          312E342C31382E382C302C31352C3043362E372C302C302C362E372C302C3135
          63302C372E392C362E322C31342E342C31342C31342E395631367A222F3E0D0A
          09093C7061746820636C6173733D2259656C6C6F772220643D224D31362C3239
          2E3963332E342D302E322C362E352D312E362C382E392D332E374C31362C3137
          2E345632392E397A222F3E0D0A093C2F673E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D2250
          69652220786D6C6E733D22687474703A2F2F7777772E77332E6F72672F323030
          302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F7777772E77
          332E6F72672F313939392F786C696E6B2220783D223070782220793D22307078
          222076696577426F783D2230203020333220333222207374796C653D22656E61
          626C652D6261636B67726F756E643A6E6577203020302033322033323B222078
          6D6C3A73706163653D227072657365727665223E262331333B262331303B3C73
          74796C6520747970653D22746578742F6373732220786D6C3A73706163653D22
          7072657365727665223E2E426C75657B66696C6C3A233131373744373B7D2623
          31333B262331303B2623393B2E5265647B66696C6C3A234431314331433B7D26
          2331333B262331303B2623393B2E59656C6C6F777B66696C6C3A234646423131
          353B7D3C2F7374796C653E0D0A3C7061746820636C6173733D22426C75652220
          643D224D32362E332C352E314C31362E342C31356C392E392C392E3963322E33
          2D322E362C332E372D362E312C332E372D392E394333302C31312E322C32382E
          362C372E382C32362E332C352E317A222F3E0D0A3C7061746820636C6173733D
          225265642220643D224D31342C3136762D31762D302E344C32342E392C332E37
          4332322E322C312E342C31382E382C302C31352C3043362E372C302C302C362E
          372C302C313563302C372E392C362E322C31342E342C31342C31342E39563136
          7A222F3E0D0A3C7061746820636C6173733D2259656C6C6F772220643D224D31
          362C32392E3963332E342D302E322C362E352D312E362C382E392D332E374C31
          362C31372E345632392E397A222F3E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F6373732220786D6C3A737061
          63653D227072657365727665223E2E5265647B66696C6C3A234431314331433B
          7D262331333B262331303B2623393B2E59656C6C6F777B66696C6C3A23464642
          3131353B7D262331333B262331303B2623393B2E426C75657B66696C6C3A2331
          31373744373B7D262331333B262331303B2623393B2E477265656E7B66696C6C
          3A233033394332333B7D262331333B262331303B2623393B2E426C61636B7B66
          696C6C3A233732373237323B7D262331333B262331303B2623393B2E57686974
          657B66696C6C3A234646464646463B7D262331333B262331303B2623393B2E73
          74307B6F7061636974793A302E353B7D262331333B262331303B2623393B2E73
          74317B6F7061636974793A302E37353B7D262331333B262331303B2623393B2E
          7374327B6F7061636974793A302E33353B7D262331333B262331303B2623393B
          2E7374337B6F7061636974793A302E36353B7D3C2F7374796C653E0D0A3C6720
          69643D22446F7567686E7574223E0D0A09093C7061746820636C6173733D2259
          656C6C6F772220643D224D31392E322C32302E36632D302E392C302E372D322C
          312E312D332E322C312E3356333063332E342D302E322C362E352D312E362C38
          2E392D332E374C31392E322C32302E367A222F3E0D0A09093C7061746820636C
          6173733D22426C75652220643D224D32362E332C352E316C2D352E372C352E37
          4332312E352C31322C32322C31332E342C32322C3135732D302E352C332D312E
          342C342E326C352E372C352E3763322E332D322E362C332E372D362E312C332E
          372D392E395332382E362C372E382C32362E332C352E3120202623393B262339
          3B7A222F3E0D0A09093C7061746820636C6173733D225265642220643D224D38
          2C31342E3963302D332E392C332E312D372C372D3763312E362C302C332C302E
          352C342E322C312E346C352E372D352E374332322E322C312E342C31382E382C
          302C31352C3043362E372C302C302C362E372C302C313520202623393B262339
          3B63302C372E392C362E322C31342E342C31342C31342E39762D382E31433130
          2E362C32312E342C382C31382E352C382C31342E397A222F3E0D0A093C2F673E
          0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F6373732220786D6C3A737061
          63653D227072657365727665223E2E5265647B66696C6C3A234431314331433B
          7D262331333B262331303B2623393B2E59656C6C6F777B66696C6C3A23464642
          3131353B7D262331333B262331303B2623393B2E426C75657B66696C6C3A2331
          31373744373B7D262331333B262331303B2623393B2E477265656E7B66696C6C
          3A233033394332333B7D262331333B262331303B2623393B2E426C61636B7B66
          696C6C3A233732373237323B7D262331333B262331303B2623393B2E57686974
          657B66696C6C3A234646464646463B7D262331333B262331303B2623393B2E73
          74307B6F7061636974793A302E353B7D262331333B262331303B2623393B2E73
          74317B6F7061636974793A302E37353B7D262331333B262331303B2623393B2E
          7374327B6F7061636974793A302E33353B7D262331333B262331303B2623393B
          2E7374337B6F7061636974793A302E36353B7D3C2F7374796C653E0D0A3C6720
          69643D224C696E65223E0D0A09093C7061746820636C6173733D2259656C6C6F
          772220643D224D32392C3130632D312E372C302D332C312E332D332C3363302C
          302E352C302E312C302E392C302E332C312E336C2D31302C31304331352E392C
          32342E312C31352E352C32342C31352C3234632D302E362C302D312E312C302E
          322D312E352C302E3420202623393B2623393B4C352E382C313843352E392C31
          372E372C362C31372E342C362C313763302D312E372D312E332D332D332D3373
          2D332C312E332D332C3373312E332C332C332C3363302E362C302C312E312D30
          2E322C312E352D302E346C372E372C362E34632D302E312C302E332D302E322C
          302E372D302E322C3120202623393B2623393B63302C312E372C312E332C332C
          332C3373332D312E332C332D3363302D302E352D302E312D302E392D302E332D
          312E336C31302D313063302E342C302E322C302E382C302E332C312E332C302E
          3363312E372C302C332D312E332C332D335333302E372C31302C32392C31307A
          204D332C313820202623393B2623393B632D302E362C302D312D302E342D312D
          3173302E342D312C312D3173312C302E342C312C3153332E362C31382C332C31
          387A204D31352C3238632D302E362C302D312D302E342D312D3173302E342D31
          2C312D3173312C302E342C312C315331352E362C32382C31352C32387A204D32
          392C313420202623393B2623393B632D302E362C302D312D302E342D312D3173
          302E342D312C312D3173312C302E342C312C315332392E362C31342C32392C31
          347A222F3E0D0A09093C7061746820636C6173733D22426C75652220643D224D
          32392C3230632D312C302D312E392C302E352D322E342C312E334C31382C3138
          2E38632D302E312D312E362D312E342D322E382D332D322E38632D312E372C30
          2D332C312E332D332C3363302C302E342C302E312C302E372C302E322C316C2D
          372E372C362E3420202623393B2623393B43342E312C32362E322C332E362C32
          362C332C3236632D312E372C302D332C312E332D332C3373312E332C332C332C
          3373332D312E332C332D3363302D302E342D302E312D302E372D302E322D316C
          372E372D362E3463302E342C302E332C312C302E342C312E352C302E34202026
          23393B2623393B63312C302C312E392D302E352C322E342D312E336C382E362C
          322E3563302E312C312E362C312E342C322E382C332C322E3863312E372C302C
          332D312E332C332D335333302E372C32302C32392C32307A204D332C3330632D
          302E362C302D312D302E342D312D3173302E342D312C312D3173312C302E342C
          312C3120202623393B2623393B53332E362C33302C332C33307A204D31352C32
          30632D302E362C302D312D302E342D312D3173302E342D312C312D3173312C30
          2E342C312C315331352E362C32302C31352C32307A204D32392C3234632D302E
          362C302D312D302E342D312D3173302E342D312C312D3173312C302E342C312C
          3120202623393B2623393B5332392E362C32342C32392C32347A222F3E0D0A09
          093C7061746820636C6173733D225265642220643D224D32392C30632D312E37
          2C302D332C312E332D332C3363302C302E322C302C302E342C302E312C302E35
          6C2D392E322C352E324331362E342C382E332C31352E372C382C31352C38632D
          302E382C302D312E352C302E332D322E312C302E384C362C352E342020262339
          3B2623393B43362C352E322C362C352E312C362C3563302D312E372D312E332D
          332D332D3353302C332E332C302C3573312E332C332C332C3363302E382C302C
          312E352D302E332C322E312D302E386C362E392C332E3563302C302E312C302C
          302E322C302C302E3363302C312E372C312E332C332C332C3373332D312E332C
          332D3320202623393B2623393B63302D302E312C302D302E332C302D302E346C
          392E312D352E324332372E362C352E372C32382E332C362C32392C3663312E37
          2C302C332D312E332C332D335333302E372C302C32392C307A204D332C364332
          2E342C362C322C352E362C322C3573302E342D312C312D3163302E362C302C31
          2C302E342C312C3120202623393B2623393B53332E362C362C332C367A204D31
          352C3132632D302E362C302D312D302E342D312D3173302E342D312C312D3163
          302E362C302C312C302E342C312C315331352E362C31322C31352C31327A204D
          32392C34632D302E362C302D312D302E342D312D3173302E342D312C312D3163
          302E362C302C312C302E342C312C3120202623393B2623393B5332392E362C34
          2C32392C347A222F3E0D0A093C2F673E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F6373732220786D6C3A737061
          63653D227072657365727665223E2E5265647B66696C6C3A234431314331433B
          7D262331333B262331303B2623393B2E59656C6C6F777B66696C6C3A23464642
          3131353B7D262331333B262331303B2623393B2E426C75657B66696C6C3A2331
          31373744373B7D262331333B262331303B2623393B2E477265656E7B66696C6C
          3A233033394332333B7D262331333B262331303B2623393B2E426C61636B7B66
          696C6C3A233732373237323B7D262331333B262331303B2623393B2E57686974
          657B66696C6C3A234646464646463B7D262331333B262331303B2623393B2E73
          74307B6F7061636974793A302E353B7D262331333B262331303B2623393B2E73
          74317B6F7061636974793A302E37353B7D262331333B262331303B2623393B2E
          7374327B6F7061636974793A302E33353B7D262331333B262331303B2623393B
          2E7374337B6F7061636974793A302E36353B7D3C2F7374796C653E0D0A3C6720
          69643D22426172223E0D0A09093C7265637420783D22342220793D2231362220
          636C6173733D22426C7565222077696474683D223622206865696768743D2231
          32222F3E0D0A09093C7265637420783D2231322220793D2231302220636C6173
          733D2259656C6C6F77222077696474683D223622206865696768743D22313822
          2F3E0D0A09093C7265637420783D2232302220793D22342220636C6173733D22
          526564222077696474683D223622206865696768743D223234222F3E0D0A093C
          2F673E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F6373732220786D6C3A737061
          63653D227072657365727665223E2E5265647B66696C6C3A234431314331433B
          7D262331333B262331303B2623393B2E59656C6C6F777B66696C6C3A23464642
          3131353B7D262331333B262331303B2623393B2E426C75657B66696C6C3A2331
          31373744373B7D262331333B262331303B2623393B2E477265656E7B66696C6C
          3A233033394332333B7D262331333B262331303B2623393B2E426C61636B7B66
          696C6C3A233732373237323B7D262331333B262331303B2623393B2E57686974
          657B66696C6C3A234646464646463B7D262331333B262331303B2623393B2E73
          74307B6F7061636974793A302E353B7D262331333B262331303B2623393B2E73
          74317B6F7061636974793A302E37353B7D262331333B262331303B2623393B2E
          7374327B6F7061636974793A302E33353B7D262331333B262331303B2623393B
          2E7374337B6F7061636974793A302E36353B7D3C2F7374796C653E0D0A3C6720
          69643D22426172537461636B6564223E0D0A09093C7061746820636C6173733D
          225265642220643D224D31302C32384834762D3468365632387A204D31382C32
          32682D36763668365632327A204D32362C3136682D3676313268365631367A22
          2F3E0D0A09093C7061746820636C6173733D2259656C6C6F772220643D224D31
          302C32344834762D3468365632347A204D31382C3136682D3676366836563136
          7A204D32362C3130682D36763668365631307A222F3E0D0A09093C7061746820
          636C6173733D22426C75652220643D224D31302C32304834762D346836563230
          7A204D31382C3130682D36763668365631307A204D32362C34682D3676366836
          56347A222F3E0D0A093C2F673E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F6373732220786D6C3A737061
          63653D227072657365727665223E2E5265647B66696C6C3A234431314331433B
          7D262331333B262331303B2623393B2E59656C6C6F777B66696C6C3A23464642
          3131353B7D262331333B262331303B2623393B2E426C75657B66696C6C3A2331
          31373744373B7D262331333B262331303B2623393B2E477265656E7B66696C6C
          3A233033394332333B7D262331333B262331303B2623393B2E426C61636B7B66
          696C6C3A233732373237323B7D262331333B262331303B2623393B2E57686974
          657B66696C6C3A234646464646463B7D262331333B262331303B2623393B2E73
          74307B6F7061636974793A302E353B7D262331333B262331303B2623393B2E73
          74317B6F7061636974793A302E37353B7D262331333B262331303B2623393B2E
          7374327B6F7061636974793A302E33353B7D262331333B262331303B2623393B
          2E7374337B6F7061636974793A302E36353B7D3C2F7374796C653E0D0A3C6720
          69643D2253696465427953696465426172537461636B6564223E0D0A09093C67
          20636C6173733D22737430223E0D0A0909093C7061746820636C6173733D2242
          6C61636B2220643D224D382C32384832762D3868365632387A204D32342C3130
          682D3676313868365631307A222F3E0D0A09093C2F673E0D0A09093C70617468
          20636C6173733D2259656C6C6F772220643D224D31342C323848385631346836
          5632387A204D33302C3138682D3676313068365631387A222F3E0D0A09093C70
          61746820636C6173733D225265642220643D224D382C32304832762D36683656
          32307A204D32342C34682D367636683656347A222F3E0D0A09093C7061746820
          636C6173733D22426C75652220643D224D31342C31344838563668365631347A
          204D33302C3130682D36763868365631307A222F3E0D0A093C2F673E0D0A3C2F
          7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F6373732220786D6C3A737061
          63653D227072657365727665223E2E5265647B66696C6C3A234431314331433B
          7D262331333B262331303B2623393B2E59656C6C6F777B66696C6C3A23464642
          3131353B7D262331333B262331303B2623393B2E426C75657B66696C6C3A2331
          31373744373B7D262331333B262331303B2623393B2E477265656E7B66696C6C
          3A233033394332333B7D262331333B262331303B2623393B2E426C61636B7B66
          696C6C3A233732373237323B7D262331333B262331303B2623393B2E57686974
          657B66696C6C3A234646464646463B7D262331333B262331303B2623393B2E73
          74307B6F7061636974793A302E353B7D262331333B262331303B2623393B2E73
          74317B6F7061636974793A302E37353B7D262331333B262331303B2623393B2E
          7374327B6F7061636974793A302E33353B7D262331333B262331303B2623393B
          2E7374337B6F7061636974793A302E36353B7D3C2F7374796C653E0D0A3C6720
          69643D22426172537461636B65643130305F7832355F223E0D0A09093C673E0D
          0A0909093C7061746820636C6173733D2259656C6C6F772220643D224D31302C
          32384834762D3868365632387A204D31382C3232682D36763668365632327A20
          4D32362C3230682D36763868365632307A222F3E0D0A0909093C706174682063
          6C6173733D2259656C6C6F772220643D224D31302C32304834762D3868365632
          307A204D31382C3130682D3676313268365631307A204D32362C3134682D3676
          3668365631347A222F3E0D0A0909093C7061746820636C6173733D2259656C6C
          6F772220643D224D31302C31324834563468365631327A204D31382C34682D36
          7636683656347A204D32362C34682D36763130683656347A222F3E0D0A09093C
          2F673E0D0A09093C673E0D0A0909093C7061746820636C6173733D2252656422
          20643D224D31302C32384834762D3868365632387A204D31382C3232682D3676
          3668365632327A204D32362C3230682D36763868365632307A222F3E0D0A0909
          093C7061746820636C6173733D2259656C6C6F772220643D224D31302C323048
          34762D3868365632307A204D31382C3130682D3676313268365631307A204D32
          362C3134682D36763668365631347A222F3E0D0A0909093C7061746820636C61
          73733D22426C75652220643D224D31302C31324834563468365631327A204D31
          382C34682D367636683656347A204D32362C34682D36763130683656347A222F
          3E0D0A09093C2F673E0D0A093C2F673E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F6373732220786D6C3A737061
          63653D227072657365727665223E2E5265647B66696C6C3A234431314331433B
          7D262331333B262331303B2623393B2E59656C6C6F777B66696C6C3A23464642
          3131353B7D262331333B262331303B2623393B2E426C75657B66696C6C3A2331
          31373744373B7D262331333B262331303B2623393B2E477265656E7B66696C6C
          3A233033394332333B7D262331333B262331303B2623393B2E426C61636B7B66
          696C6C3A233732373237323B7D262331333B262331303B2623393B2E57686974
          657B66696C6C3A234646464646463B7D262331333B262331303B2623393B2E73
          74307B6F7061636974793A302E353B7D262331333B262331303B2623393B2E73
          74317B6F7061636974793A302E37353B7D262331333B262331303B2623393B2E
          7374327B6F7061636974793A302E33353B7D262331333B262331303B2623393B
          2E7374337B6F7061636974793A302E36353B7D3C2F7374796C653E0D0A3C6720
          69643D2253696465427953696465426172537461636B65643130305F7832355F
          223E0D0A09093C7061746820636C6173733D2259656C6C6F772220643D224D31
          342C32384838762D3868365632387A204D33302C3130682D3676313868365631
          307A222F3E0D0A09093C6720636C6173733D22737430223E0D0A0909093C7061
          746820636C6173733D22426C61636B2220643D224D382C323848325631326836
          5632387A204D32342C3138682D3676313068365631387A222F3E0D0A09093C2F
          673E0D0A09093C7061746820636C6173733D22426C75652220643D224D31342C
          32304838563468365632307A204D33302C34682D367636683656347A222F3E0D
          0A09093C7061746820636C6173733D225265642220643D224D382C3132483256
          3468365631327A204D32342C34682D36763134683656347A222F3E0D0A093C2F
          673E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F6373732220786D6C3A737061
          63653D227072657365727665223E2E426C75657B66696C6C3A23313137374437
          3B7D262331333B262331303B2623393B2E59656C6C6F777B66696C6C3A234646
          423131353B7D262331333B262331303B2623393B2E426C61636B7B66696C6C3A
          233732373237323B7D262331333B262331303B2623393B2E477265656E7B6669
          6C6C3A233033394332333B7D262331333B262331303B2623393B2E5265647B66
          696C6C3A234431314331433B7D262331333B262331303B2623393B2E7374307B
          6F7061636974793A302E37353B7D262331333B262331303B2623393B2E737431
          7B6F7061636974793A302E353B7D3C2F7374796C653E0D0A3C672069643D2241
          72726F77315570223E0D0A09093C706174682069643D2247726F75705F53656C
          656374696F6E5F335F2220636C6173733D22426C75652220643D224D31342C32
          38563134682D302E3748364C31362C346C31302C3130682D372E334831387631
          344831347A222F3E0D0A093C2F673E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F6373732220786D6C3A737061
          63653D227072657365727665223E2E426C75657B66696C6C3A23313137374437
          3B7D262331333B262331303B2623393B2E59656C6C6F777B66696C6C3A234646
          423131353B7D262331333B262331303B2623393B2E426C61636B7B66696C6C3A
          233732373237323B7D262331333B262331303B2623393B2E477265656E7B6669
          6C6C3A233033394332333B7D262331333B262331303B2623393B2E5265647B66
          696C6C3A234431314331433B7D262331333B262331303B2623393B2E7374307B
          6F7061636974793A302E37353B7D262331333B262331303B2623393B2E737431
          7B6F7061636974793A302E353B7D3C2F7374796C653E0D0A3C672069643D2241
          72726F7731446F776E223E0D0A09093C706174682069643D2247726F75705F53
          656C656374696F6E5F325F2220636C6173733D22426C75652220643D224D3134
          2C34763134682D302E3748366C31302C31306C31302D3130682D372E33483138
          56344831347A222F3E0D0A093C2F673E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F6373732220786D6C3A737061
          63653D227072657365727665223E2E5265647B66696C6C3A234431314331433B
          7D262331333B262331303B2623393B2E59656C6C6F777B66696C6C3A23464642
          3131353B7D262331333B262331303B2623393B2E426C75657B66696C6C3A2331
          31373744373B7D262331333B262331303B2623393B2E477265656E7B66696C6C
          3A233033394332333B7D262331333B262331303B2623393B2E426C61636B7B66
          696C6C3A233732373237323B7D262331333B262331303B2623393B2E57686974
          657B66696C6C3A234646464646463B7D262331333B262331303B2623393B2E73
          74307B6F7061636974793A302E353B7D262331333B262331303B2623393B2E73
          74317B6F7061636974793A302E37353B7D262331333B262331303B2623393B2E
          7374327B6F7061636974793A302E33353B7D262331333B262331303B2623393B
          2E7374337B6F7061636974793A302E36353B7D3C2F7374796C653E0D0A3C6720
          69643D2241726561223E0D0A09093C6720636C6173733D22737430223E0D0A09
          09093C706F6C79676F6E20636C6173733D22426C75652220706F696E74733D22
          31322C32302032302E352C31322E342031342C313020372E362C31362E342026
          23393B2623393B222F3E0D0A09093C2F673E0D0A09093C7061746820636C6173
          733D2259656C6C6F772220643D224D372E362C31362E344C322C32325631324C
          372E362C31362E347A204D32302E352C31322E344C33302C313656344C32302E
          352C31322E347A222F3E0D0A09093C706F6C79676F6E20636C6173733D22426C
          75652220706F696E74733D2231322C323020372E362C31362E3420322C323220
          322C32382033302C32382033302C31362032302E352C31322E34202623393B22
          2F3E0D0A093C2F673E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F6373732220786D6C3A737061
          63653D227072657365727665223E2E5265647B66696C6C3A234431314331433B
          7D262331333B262331303B2623393B2E59656C6C6F777B66696C6C3A23464642
          3131353B7D262331333B262331303B2623393B2E426C75657B66696C6C3A2331
          31373744373B7D262331333B262331303B2623393B2E477265656E7B66696C6C
          3A233033394332333B7D262331333B262331303B2623393B2E426C61636B7B66
          696C6C3A233732373237323B7D262331333B262331303B2623393B2E57686974
          657B66696C6C3A234646464646463B7D262331333B262331303B2623393B2E73
          74307B6F7061636974793A302E353B7D262331333B262331303B2623393B2E73
          74317B6F7061636974793A302E37353B7D262331333B262331303B2623393B2E
          7374327B6F7061636974793A302E33353B7D262331333B262331303B2623393B
          2E7374337B6F7061636974793A302E36353B7D3C2F7374796C653E0D0A3C6720
          69643D2241726561537461636B6564223E0D0A09093C706F6C79676F6E20636C
          6173733D22426C75652220706F696E74733D22322C323820322C32322031342C
          32302033302C32342033302C3238202623393B222F3E0D0A09093C706F6C7967
          6F6E20636C6173733D2259656C6C6F772220706F696E74733D22322C31322031
          342C31362033302C31302033302C32342031342C323020322C3232202623393B
          222F3E0D0A09093C706F6C79676F6E20636C6173733D225265642220706F696E
          74733D22322C3620322C31322031342C31362033302C31302033302C32203134
          2C3130202623393B222F3E0D0A093C2F673E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F6373732220786D6C3A737061
          63653D227072657365727665223E2E5265647B66696C6C3A234431314331433B
          7D262331333B262331303B2623393B2E59656C6C6F777B66696C6C3A23464642
          3131353B7D262331333B262331303B2623393B2E426C75657B66696C6C3A2331
          31373744373B7D262331333B262331303B2623393B2E477265656E7B66696C6C
          3A233033394332333B7D262331333B262331303B2623393B2E426C61636B7B66
          696C6C3A233732373237323B7D262331333B262331303B2623393B2E57686974
          657B66696C6C3A234646464646463B7D262331333B262331303B2623393B2E73
          74307B6F7061636974793A302E353B7D262331333B262331303B2623393B2E73
          74317B6F7061636974793A302E37353B7D262331333B262331303B2623393B2E
          7374327B6F7061636974793A302E33353B7D262331333B262331303B2623393B
          2E7374337B6F7061636974793A302E36353B7D3C2F7374796C653E0D0A3C6720
          69643D2241726561537461636B65643130305F7832355F223E0D0A09093C706F
          6C79676F6E20636C6173733D225265642220706F696E74733D22322C32382032
          2C32322031342C32302033302C32342033302C3238202623393B222F3E0D0A09
          093C706F6C79676F6E20636C6173733D2259656C6C6F772220706F696E74733D
          22322C31302031342C31342033302C382033302C32342031342C323020322C32
          32202623393B222F3E0D0A09093C706F6C79676F6E20636C6173733D22426C75
          652220706F696E74733D22322C3220322C31302031342C31342033302C382033
          302C32202623393B222F3E0D0A093C2F673E0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F6373732220786D6C3A737061
          63653D227072657365727665223E2E5265647B66696C6C3A234431314331433B
          7D262331333B262331303B2623393B2E59656C6C6F777B66696C6C3A23464642
          3131353B7D262331333B262331303B2623393B2E426C75657B66696C6C3A2331
          31373744373B7D262331333B262331303B2623393B2E477265656E7B66696C6C
          3A233033394332333B7D262331333B262331303B2623393B2E426C61636B7B66
          696C6C3A233732373237323B7D262331333B262331303B2623393B2E57686974
          657B66696C6C3A234646464646463B7D262331333B262331303B2623393B2E73
          74307B6F7061636974793A302E353B7D262331333B262331303B2623393B2E73
          74317B6F7061636974793A302E37353B7D262331333B262331303B2623393B2E
          7374327B6F7061636974793A302E33353B7D262331333B262331303B2623393B
          2E7374337B6F7061636974793A302E36353B7D3C2F7374796C653E0D0A3C6720
          69643D224C696E65537461636B6564223E0D0A09093C7061746820636C617373
          3D22426C75652220643D224D32392C3236632D312E322C302D322E322C302E37
          2D322E372C312E366C2D382E342D312E324331372E372C32352E312C31362E35
          2C32342C31352C3234632D312E332C302D322E342C302E382D322E382C324835
          2E3820202623393B2623393B632D302E342D312E322D312E352D322D322E382D
          32632D312E372C302D332C312E332D332C3373312E332C332C332C3363312E33
          2C302C322E342D302E382C322E382D3268362E3463302E342C312E322C312E35
          2C322C322E382C3263312E312C302C322E312D302E362C322E362D312E366C38
          2E342C312E3220202623393B2623393B63302E332C312E342C312E362C322E34
          2C332C322E3463312E372C302C332D312E332C332D334333322C32372E342C33
          302E372C32362C32392C32367A204D332C3238632D302E362C302D312D302E34
          2D312D3173302E342D312C312D3173312C302E342C312C3153332E362C32382C
          332C32387A204D31352C323820202623393B2623393B632D302E362C302D312D
          302E342D312D3173302E342D312C312D3173312C302E342C312C315331352E36
          2C32382C31352C32387A204D32392C3330632D302E362C302D312D302E342D31
          2D3173302E342D312C312D3173312C302E342C312C315332392E362C33302C32
          392C33307A222F3E0D0A09093C7061746820636C6173733D225265642220643D
          224D32392C30632D312E372C302D332C312E332D332C3363302C302E322C302C
          302E342C302E312C302E356C2D392E322C352E324331362E342C382E332C3135
          2E372C382C31352C38632D302E382C302D312E352C302E332D322E312C302E38
          4C362C352E3420202623393B2623393B43362C352E322C362C352E312C362C35
          63302D312E372D312E332D332D332D3353302C332E332C302C3573312E332C33
          2C332C3363302E382C302C312E352D302E332C322E312D302E386C362E392C33
          2E3563302C302E312C302C302E322C302C302E3363302C312E372C312E332C33
          2C332C3373332D312E332C332D3320202623393B2623393B63302D302E312C30
          2D302E332C302D302E346C392E312D352E324332372E362C352E372C32382E33
          2C362C32392C3663312E372C302C332D312E332C332D335333302E372C302C32
          392C307A204D332C3643322E342C362C322C352E362C322C3573302E342D312C
          312D3163302E362C302C312C302E342C312C3120202623393B2623393B53332E
          362C362C332C367A204D31352C3132632D302E362C302D312D302E342D312D31
          73302E342D312C312D3163302E362C302C312C302E342C312C315331352E362C
          31322C31352C31327A204D32392C34632D302E362C302D312D302E342D312D31
          73302E342D312C312D3163302E362C302C312C302E342C312C3120202623393B
          2623393B5332392E362C342C32392C347A222F3E0D0A09093C7061746820636C
          6173733D2259656C6C6F772220643D224D32392C3132632D312E362C302D322E
          392C312E322D332C322E386C2D382E352C322E354331362E392C31362E352C31
          362C31362C31352C3136632D312C302D312E382C302E352D322E342C312E324C
          362C313563302D312E372D312E342D332D332D3320202623393B2623393B632D
          312E372C302D332C312E332D332C3373312E332C332C332C3363312C302C312E
          382D302E352C322E342D312E324C31322C313963302C302C302C302C302C3063
          302C312E372C312E332C332C332C3363312E362C302C322E392D312E332C332D
          322E396C382E372D322E3520202623393B2623393B4332372E312C31372E352C
          32382C31382C32392C313863312E372C302C332D312E332C332D334333322C31
          332E342C33302E372C31322C32392C31327A204D332C3136632D302E362C302D
          312D302E342D312D3173302E342D312C312D3163302E362C302C312C302E342C
          312C3153332E362C31362C332C31367A20202623393B2623393B204D31352C32
          30632D302E362C302D312D302E342D312D3173302E342D312C312D3163302E36
          2C302C312C302E342C312C315331352E362C32302C31352C32307A204D32392C
          3136632D302E362C302D312D302E342D312D3173302E342D312C312D3173312C
          302E342C312C315332392E362C31362C32392C31367A222F3E0D0A093C2F673E
          0D0A3C2F7376673E0D0A}
      end
      item
        ImageClass = 'TdxSmartImage'
        Image.Data = {
          3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
          462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
          617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
          2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
          77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
          22307078222076696577426F783D2230203020333220333222207374796C653D
          22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
          3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
          303B3C7374796C6520747970653D22746578742F6373732220786D6C3A737061
          63653D227072657365727665223E2E5265647B66696C6C3A234431314331433B
          7D262331333B262331303B2623393B2E59656C6C6F777B66696C6C3A23464642
          3131353B7D262331333B262331303B2623393B2E426C75657B66696C6C3A2331
          31373744373B7D262331333B262331303B2623393B2E477265656E7B66696C6C
          3A233033394332333B7D262331333B262331303B2623393B2E426C61636B7B66
          696C6C3A233732373237323B7D262331333B262331303B2623393B2E57686974
          657B66696C6C3A234646464646463B7D262331333B262331303B2623393B2E73
          74307B6F7061636974793A302E353B7D262331333B262331303B2623393B2E73
          74317B6F7061636974793A302E37353B7D262331333B262331303B2623393B2E
          7374327B6F7061636974793A302E33353B7D262331333B262331303B2623393B
          2E7374337B6F7061636974793A302E36353B7D3C2F7374796C653E0D0A3C6720
          69643D224C696E65537461636B65643130305F7832355F223E0D0A09093C7061
          746820636C6173733D225265642220643D224D32392C30632D312E332C302D32
          2E342C302E382D322E382C32682D382E34632D302E342D312E322D312E352D32
          2D322E382D32732D322E342C302E382D322E382C3248352E3843352E342C302E
          382C342E332C302C332C3043312E332C302C302C312E332C302C332020262339
          3B2623393B73312E332C332C332C3363312E332C302C322E342D302E382C322E
          382D3268362E3463302E342C312E322C312E352C322C322E382C3273322E342D
          302E382C322E382D3268382E3463302E342C312E322C312E352C322C322E382C
          3263312E372C302C332D312E332C332D335333302E372C302C32392C307A204D
          332C3420202623393B2623393B43322E342C342C322C332E362C322C3373302E
          342D312C312D3173312C302E342C312C3153332E362C342C332C347A204D3135
          2C34632D302E362C302D312D302E342D312D3173302E342D312C312D3173312C
          302E342C312C315331352E362C342C31352C347A204D32392C34632D302E362C
          302D312D302E342D312D3120202623393B2623393B73302E342D312C312D3173
          312C302E342C312C315332392E362C342C32392C347A222F3E0D0A09093C7061
          746820636C6173733D2259656C6C6F772220643D224D32392C38632D312E362C
          302D322E392C312E322D332C322E386C2D382E352C322E354331362E392C3132
          2E352C31362C31322C31352C3132632D312C302D312E382C302E352D322E342C
          312E324C362C313163302D312E372D312E342D332D332D3320202623393B2623
          393B632D312E372C302D332C312E332D332C3373312E332C332C332C3363312C
          302C312E382D302E352C322E342D312E324C31322C313563302C302C302C302C
          302C3063302C312E372C312E332C332C332C3363312E362C302C322E392D312E
          332C332D322E396C382E372D322E3520202623393B2623393B4332372E312C31
          332E352C32382C31342C32392C313463312E372C302C332D312E332C332D3343
          33322C392E342C33302E372C382C32392C387A204D332C3132632D302E362C30
          2D312D302E342D312D3173302E342D312C312D3163302E362C302C312C302E34
          2C312C3153332E362C31322C332C31327A20202623393B2623393B204D31352C
          3136632D302E362C302D312D302E342D312D3173302E342D312C312D3163302E
          362C302C312C302E342C312C315331352E362C31362C31352C31367A204D3239
          2C3132632D302E362C302D312D302E342D312D3173302E342D312C312D317331
          2C302E342C312C315332392E362C31322C32392C31327A222F3E0D0A09093C70
          61746820636C6173733D22426C75652220643D224D32392C3234632D312C302D
          312E392C302E352D322E352C312E334C31382C32322E38632D302E312D312E35
          2D312E342D322E382D332D322E38632D312E372C302D332C312E332D332C3363
          302C302E312C302C302E332C302C302E346C2D372C332E3520202623393B2623
          393B43342E352C32362E332C332E382C32362C332C3236632D312E372C302D33
          2C312E332D332C3373312E332C332C332C3373332D312E332C332D3363302D30
          2E312C302D302E322C302D302E346C362E392D332E3563302E352C302E352C31
          2E332C302E392C322E312C302E3920202623393B2623393B63312E312C302C32
          2D302E362C322E352D312E346C382E352C322E3563302E312C312E362C312E34
          2C322E392C332C322E3963312E372C302C332D312E332C332D335333302E372C
          32342C32392C32347A204D332C3330632D302E362C302D312D302E342D312D31
          73302E342D312C312D3173312C302E342C312C3120202623393B2623393B5333
          2E362C33302C332C33307A204D31352C3234632D302E362C302D312D302E342D
          312D3173302E342D312C312D3173312C302E342C312C315331352E362C32342C
          31352C32347A204D32392C3238632D302E362C302D312D302E342D312D317330
          2E342D312C312D3173312C302E342C312C3120202623393B2623393B5332392E
          362C32382C32392C32387A222F3E0D0A093C2F673E0D0A3C2F7376673E0D0A}
      end>
  end
  object alMain: TActionList
    Images = ilPopupMenu
    Left = 320
    Top = 120
    object aAddXYDiagram: TAction
      Category = 'Diagram'
      Caption = 'XY-Diagram'
      ImageIndex = 0
      OnExecute = aAddDiagramExecute
    end
    object aAddSimpleDiagram: TAction
      Tag = 1
      Category = 'Diagram'
      Caption = 'Simple Diagram'
      ImageIndex = 1
      OnExecute = aAddDiagramExecute
    end
    object aAddPieSeries: TAction
      Category = 'Series'
      Caption = 'aAddPieSeries'
      ImageIndex = 2
      OnExecute = aAddSeriesExecute
      OnUpdate = aAddSeriesUpdate
    end
    object aAddDoughnutSeries: TAction
      Tag = 1
      Category = 'Series'
      Caption = 'aAddDoughnutSeries'
      ImageIndex = 3
      OnExecute = aAddSeriesExecute
      OnUpdate = aAddSeriesUpdate
    end
    object aAddAreaSeries: TAction
      Tag = 8
      Category = 'Series'
      Caption = 'aAddAreaSeries'
      ImageIndex = 12
      OnExecute = aAddSeriesExecute
      OnUpdate = aAddSeriesUpdate
    end
    object aAddLineSeries: TAction
      Tag = 2
      Category = 'Series'
      Caption = 'aAddLineSeries'
      ImageIndex = 4
      OnExecute = aAddSeriesExecute
      OnUpdate = aAddSeriesUpdate
    end
    object aAddBarSeries: TAction
      Tag = 3
      Category = 'Series'
      Caption = 'aAddBarSeries'
      ImageIndex = 5
      OnExecute = aAddSeriesExecute
      OnUpdate = aAddSeriesUpdate
    end
    object aAddStackedBarSeries: TAction
      Tag = 4
      Category = 'Series'
      Caption = 'aAddStackedBarSeries'
      ImageIndex = 6
      OnExecute = aAddSeriesExecute
      OnUpdate = aAddSeriesUpdate
    end
    object aAddStackedBarSideBySideSeries: TAction
      Tag = 5
      Category = 'Series'
      Caption = 'aAddStackedBarSideBySideSeries'
      ImageIndex = 7
      OnExecute = aAddSeriesExecute
      OnUpdate = aAddSeriesUpdate
    end
    object aAddFullStackedBarSeries: TAction
      Tag = 6
      Category = 'Series'
      Caption = 'aAddFullStackedBarSeries'
      ImageIndex = 8
      OnExecute = aAddSeriesExecute
      OnUpdate = aAddSeriesUpdate
    end
    object aAddFullStackedBarSideBySideSeries: TAction
      Tag = 7
      Category = 'Series'
      Caption = 'aAddFullStackedBarSideBySideSeries'
      ImageIndex = 9
      OnExecute = aAddSeriesExecute
      OnUpdate = aAddSeriesUpdate
    end
    object aClose: TAction
      Category = 'Form'
      Caption = 'aClose'
      ShortCut = 27
      OnExecute = aCloseExecute
    end
    object aCancel: TAction
      Category = 'Form'
      Caption = 'aCancel'
      OnExecute = aCancelExecute
    end
    object aUp: TAction
      Tag = -1
      Category = 'Toolbar'
      ImageIndex = 10
      ShortCut = 16422
      OnExecute = aUpAndDownExecute
      OnUpdate = aUpAndDownUpdate
    end
    object aDown: TAction
      Tag = 1
      Category = 'Toolbar'
      ImageIndex = 11
      ShortCut = 16424
      OnExecute = aUpAndDownExecute
      OnUpdate = aUpAndDownUpdate
    end
    object aAddStackedAreaSeries: TAction
      Tag = 9
      Category = 'Series'
      Caption = 'aAddStackedAreaSeries'
      ImageIndex = 13
      OnExecute = aAddSeriesExecute
      OnUpdate = aAddSeriesUpdate
    end
    object aAddFullStackedAreaSeries: TAction
      Tag = 10
      Category = 'Series'
      Caption = 'aAddFullStackedAreaSeries'
      ImageIndex = 14
      OnExecute = aAddSeriesExecute
      OnUpdate = aAddSeriesUpdate
    end
    object aAddStackedLineSeries: TAction
      Tag = 11
      Category = 'Series'
      Caption = 'aAddStackedLineSeries'
      ImageIndex = 15
      OnExecute = aAddSeriesExecute
      OnUpdate = aAddSeriesUpdate
    end
    object aAddFullStackedLineSeries: TAction
      Tag = 12
      Category = 'Series'
      Caption = 'aAddFullStackedLineSeries'
      ImageIndex = 16
      OnExecute = aAddSeriesExecute
      OnUpdate = aAddSeriesUpdate
    end
  end
  object pmSeries: TPopupMenu
    Images = ilPopupMenu
    Left = 265
    Top = 184
    object miAddPieSeries: TMenuItem
      Action = aAddPieSeries
    end
    object miAddDoughnutSeries: TMenuItem
      Action = aAddDoughnutSeries
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object miAddAreaSeries: TMenuItem
      Action = aAddAreaSeries
    end
    object miAddStackedAreaSeries: TMenuItem
      Action = aAddStackedAreaSeries
    end
    object miAddFullStackedAreaSeries: TMenuItem
      Action = aAddFullStackedAreaSeries
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object miAddBarSeries: TMenuItem
      Action = aAddBarSeries
    end
    object miAddStackedBarSeries: TMenuItem
      Action = aAddStackedBarSeries
    end
    object miAddFullStackedBarSeries: TMenuItem
      Action = aAddFullStackedBarSeries
    end
    object miAddStackedBarSideBySideSeries: TMenuItem
      Action = aAddStackedBarSideBySideSeries
    end
    object miAddFullStackedBarSideBySideSeries: TMenuItem
      Action = aAddFullStackedBarSideBySideSeries
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object miAddLineSeries: TMenuItem
      Action = aAddLineSeries
    end
    object miAddStackedLineSeries: TMenuItem
      Action = aAddStackedLineSeries
    end
    object miAddFullStackedLineSeries: TMenuItem
      Action = aAddFullStackedLineSeries
    end
  end
  object tPostEditValueUpdate: TTimer
    Enabled = False
    Interval = 200
    OnTimer = tPostEditValueUpdateTimer
    Left = 416
    Top = 280
  end
  object ilHatch: TcxImageList
    SourceDPI = 96
    Height = 13
    Width = 13
    FormatVersion = 1
    DesignInfo = 22020512
  end
  object tUpdateOptionsFromChart: TTimer
    Enabled = False
    Interval = 250
    OnTimer = tUpdateOptionsFromChartTimer
    Left = 336
    Top = 264
  end
  object tPopulateTreeView: TTimer
    Enabled = False
    Interval = 500
    OnTimer = tPopulateTreeViewTimer
    Left = 232
    Top = 304
  end
end
