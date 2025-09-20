object cxSchedulerRecurrenceEventEditorForm: TcxSchedulerRecurrenceEventEditorForm
  Left = 277
  Top = 263
  AutoSize = True
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Event recurrence'
  ClientHeight = 369
  ClientWidth = 561
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lcMain: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 561
    Height = 369
    TabOrder = 0
    AutoSize = True
    LayoutLookAndFeel = dxLayoutCxLookAndFeel
    ShowDesignSelectors = False
    object btnOk: TcxButton
      Left = 115
      Top = 324
      Width = 110
      Height = 23
      Caption = '&Ok'
      Default = True
      TabOrder = 38
      OnClick = btnOkClick
    end
    object btnRemove: TcxButton
      Left = 347
      Top = 324
      Width = 110
      Height = 23
      Caption = '&Remove recurrence'
      Enabled = False
      ModalResult = 3
      TabOrder = 40
    end
    object btnCancel: TcxButton
      Left = 231
      Top = 324
      Width = 110
      Height = 23
      Cancel = True
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 39
    end
    object deStart: TcxDateEdit
      Left = 55
      Top = 219
      Properties.DateButtons = [btnToday]
      Properties.InputKind = ikStandard
      Properties.OnChange = DoChange
      Properties.OnEditValueChanged = deStartPropertiesEditValueChanged
      Style.HotTrack = False
      TabOrder = 32
      Width = 135
    end
    object rbNoEndDate: TcxRadioButton
      Left = 196
      Top = 219
      Caption = 'No end date'
      Checked = True
      Color = clBtnFace
      ParentColor = False
      TabOrder = 33
      TabStop = True
      OnClick = rbNoEndDateClick
      AutoSize = True
      GroupIndex = 1
      ParentBackground = False
      Transparent = True
    end
    object rbEndAfter: TcxRadioButton
      Left = 196
      Top = 244
      Caption = 'End after:'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 34
      TabStop = True
      OnClick = DoChange
      AutoSize = True
      GroupIndex = 1
      ParentBackground = False
      Transparent = True
    end
    object meEndAfter: TcxMaskEdit
      Tag = 11452416
      Left = 287
      Top = 242
      Properties.MaskKind = emkRegExpr
      Properties.EditMask = '\d{0,4}'
      Properties.MaxLength = 0
      Properties.OnChange = meEndAfterPropertiesChange
      Properties.OnEditValueChanged = meEndAfterPropertiesEditValueChanged
      Style.HotTrack = False
      TabOrder = 35
      OnExit = meEndAfterExit
      Width = 46
    end
    object rbEndBy: TcxRadioButton
      Left = 196
      Top = 271
      Caption = 'End by:'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 36
      TabStop = True
      OnClick = DoChange
      AutoSize = True
      GroupIndex = 1
      ParentBackground = False
      Transparent = True
    end
    object deEndBy: TcxDateEdit
      Tag = 11453468
      Left = 287
      Top = 269
      Properties.DateButtons = [btnToday]
      Properties.InputKind = ikStandard
      Properties.OnChange = deEndByPropertiesChange
      Properties.OnEditValueChanged = deEndByPropertiesEditValueChanged
      Style.HotTrack = False
      TabOrder = 37
      Width = 109
    end
    object rbYearly: TcxRadioButton
      Tag = 3
      Left = 22
      Top = 156
      Caption = 'Yearly'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 6
      TabStop = True
      OnClick = SelectPeriodicityClick
      AutoSize = True
      GroupIndex = 2
      ParentBackground = False
      Transparent = True
    end
    object rbDaily: TcxRadioButton
      Left = 22
      Top = 87
      Caption = 'Daily'
      Checked = True
      Color = clBtnFace
      ParentColor = False
      TabOrder = 3
      TabStop = True
      OnClick = SelectPeriodicityClick
      AutoSize = True
      GroupIndex = 2
      ParentBackground = False
      Transparent = True
    end
    object rbWeekly: TcxRadioButton
      Tag = 1
      Left = 22
      Top = 110
      Caption = 'Weekly'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 4
      OnClick = SelectPeriodicityClick
      AutoSize = True
      GroupIndex = 2
      ParentBackground = False
      Transparent = True
    end
    object rbMonthly: TcxRadioButton
      Tag = 2
      Left = 22
      Top = 133
      Caption = 'Monthly'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 5
      TabStop = True
      OnClick = SelectPeriodicityClick
      AutoSize = True
      GroupIndex = 2
      ParentBackground = False
      Transparent = True
    end
    object rbDay: TcxRadioButton
      Left = 10000
      Top = 10000
      Caption = 'Day'
      Checked = True
      Color = clBtnFace
      ParentColor = False
      TabOrder = 7
      TabStop = True
      Visible = False
      OnClick = DoChange
      AutoSize = True
      GroupIndex = 3
      ParentBackground = False
      Transparent = True
    end
    object meNumOfDay: TcxMaskEdit
      Tag = 11533468
      Left = 10000
      Top = 10000
      Properties.MaskKind = emkRegExpr
      Properties.EditMask = '\d{0,4}'
      Properties.MaxLength = 0
      Properties.OnChange = SetDayRadioButtonChecked
      Style.HotTrack = False
      TabOrder = 8
      Visible = False
      OnExit = ValidateNumber
      Width = 32
    end
    object meNumMonth: TcxMaskEdit
      Tag = 11533468
      Left = 10000
      Top = 10000
      Properties.MaskKind = emkRegExpr
      Properties.EditMask = '\d{0,4}'
      Properties.MaxLength = 0
      Properties.OnChange = SetDayRadioButtonChecked
      Style.HotTrack = False
      TabOrder = 9
      Visible = False
      OnExit = ValidateNumber
      Width = 32
    end
    object rbThe: TcxRadioButton
      Left = 10000
      Top = 10000
      Caption = 'The'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 10
      TabStop = True
      Visible = False
      OnClick = DoChange
      AutoSize = True
      GroupIndex = 3
      ParentBackground = False
      Transparent = True
    end
    object cbWeek: TcxComboBox
      Tag = 11534460
      Left = 10000
      Top = 10000
      Properties.DropDownListStyle = lsFixedList
      Properties.OnChange = SetTheRadioButtonChecked
      Style.HotTrack = False
      TabOrder = 11
      Visible = False
      Width = 65
    end
    object cbDay: TcxComboBox
      Tag = 11534460
      Left = 10000
      Top = 10000
      Properties.DropDownListStyle = lsFixedList
      Properties.DropDownRows = 10
      Properties.OnChange = SetTheRadioButtonChecked
      Style.HotTrack = False
      TabOrder = 12
      Visible = False
      Width = 95
    end
    object meNumMonth1: TcxMaskEdit
      Tag = 11534460
      Left = 10000
      Top = 10000
      Properties.MaskKind = emkRegExpr
      Properties.EditMask = '\d{0,4}'
      Properties.MaxLength = 0
      Properties.OnChange = SetTheRadioButtonChecked
      Style.HotTrack = False
      TabOrder = 13
      Visible = False
      OnExit = ValidateNumber
      Width = 32
    end
    object rbEvery: TcxRadioButton
      Left = 160
      Top = 97
      Caption = 'Every'
      Checked = True
      Color = clBtnFace
      ParentColor = False
      TabOrder = 14
      TabStop = True
      OnClick = DoChange
      AutoSize = True
      GroupIndex = 4
      ParentBackground = False
      Transparent = True
    end
    object meDay: TcxMaskEdit
      Left = 225
      Top = 95
      Properties.MaskKind = emkRegExpr
      Properties.EditMask = '\d{0,4}'
      Properties.MaxLength = 0
      Properties.OnChange = meDayPropertiesChange
      Style.HotTrack = False
      TabOrder = 15
      OnExit = ValidateNumber
      Width = 40
    end
    object rbEveryWeekday: TcxRadioButton
      Left = 160
      Top = 122
      Caption = 'Every weekday'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 16
      TabStop = True
      OnClick = rbEveryWeekdayClick
      AutoSize = True
      GroupIndex = 4
      ParentBackground = False
      Transparent = True
    end
    object meNumOfWeek: TcxMaskEdit
      Left = 10000
      Top = 10000
      Properties.MaskKind = emkRegExpr
      Properties.EditMask = '\d{0,4}'
      Properties.MaxLength = 0
      Properties.OnChange = DoChange
      Style.HotTrack = False
      TabOrder = 17
      Visible = False
      OnExit = ValidateNumber
      Width = 40
    end
    object rbEvery1: TcxRadioButton
      Left = 10000
      Top = 10000
      Caption = 'Every'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 25
      Visible = False
      OnClick = DoChange
      AutoSize = True
      GroupIndex = 5
      ParentBackground = False
      Transparent = True
    end
    object cbMonths: TcxComboBox
      Tag = 11588656
      Left = 10000
      Top = 10000
      Properties.DropDownListStyle = lsFixedList
      Properties.OnChange = cbMonthsPropertiesChange
      Style.HotTrack = False
      TabOrder = 26
      Visible = False
      Width = 95
    end
    object meDayOfMonth: TcxMaskEdit
      Tag = 11588656
      Left = 10000
      Top = 10000
      Properties.MaskKind = emkRegExpr
      Properties.EditMask = '\d{0,4}'
      Properties.MaxLength = 0
      Properties.OnChange = cbMonthsPropertiesChange
      Style.HotTrack = False
      TabOrder = 27
      Visible = False
      OnExit = ValidateNumber
      Width = 32
    end
    object rbThe1: TcxRadioButton
      Left = 10000
      Top = 10000
      Caption = 'The'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 28
      Visible = False
      AutoSize = True
      GroupIndex = 5
      ParentBackground = False
      Transparent = True
    end
    object cbWeek1: TcxComboBox
      Tag = 11589716
      Left = 10000
      Top = 10000
      Properties.DropDownListStyle = lsFixedList
      Properties.OnChange = cbWeek1PropertiesChange
      Style.HotTrack = False
      TabOrder = 29
      Visible = False
      Width = 65
    end
    object cbDay1: TcxComboBox
      Tag = 11589716
      Left = 10000
      Top = 10000
      Properties.DropDownListStyle = lsFixedList
      Properties.DropDownRows = 10
      Properties.OnChange = cbWeek1PropertiesChange
      Style.HotTrack = False
      TabOrder = 30
      Visible = False
      Width = 95
    end
    object cbMonths1: TcxComboBox
      Tag = 11589716
      Left = 10000
      Top = 10000
      Properties.DropDownListStyle = lsFixedList
      Properties.OnChange = cbWeek1PropertiesChange
      Style.HotTrack = False
      TabOrder = 31
      Visible = False
      Width = 95
    end
    object cbDayOfWeek1: TcxCheckBox
      Tag = 1
      Left = 10000
      Top = 10000
      Caption = 'Monday'
      Properties.OnChange = DoChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 18
      Transparent = True
      Visible = False
    end
    object cbDayOfWeek2: TcxCheckBox
      Tag = 2
      Left = 10000
      Top = 10000
      Caption = 'Tuesday'
      Properties.OnChange = DoChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 20
      Transparent = True
      Visible = False
    end
    object cbDayOfWeek3: TcxCheckBox
      Tag = 3
      Left = 10000
      Top = 10000
      Caption = 'Wednesday'
      Properties.OnChange = DoChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 22
      Transparent = True
      Visible = False
    end
    object cbDayOfWeek4: TcxCheckBox
      Tag = 4
      Left = 10000
      Top = 10000
      Caption = 'Thursday'
      Properties.OnChange = DoChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 24
      Transparent = True
      Visible = False
    end
    object cbDayOfWeek5: TcxCheckBox
      Tag = 5
      Left = 10000
      Top = 10000
      Caption = 'Friday'
      Properties.OnChange = DoChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 19
      Transparent = True
      Visible = False
    end
    object cbDayOfWeek6: TcxCheckBox
      Tag = 6
      Left = 10000
      Top = 10000
      Caption = 'Saturday'
      Properties.OnChange = DoChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 21
      Transparent = True
      Visible = False
    end
    object cbDayOfWeek7: TcxCheckBox
      Tag = 7
      Left = 10000
      Top = 10000
      Caption = 'Sunday'
      Properties.OnChange = DoChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 23
      Transparent = True
      Visible = False
    end
    object teStart: TcxTimeEdit
      Left = 55
      Top = 28
      Properties.TimeFormat = tfHourMin
      Properties.OnChange = DoChange
      Properties.OnEditValueChanged = StartTimeChanged
      Style.HotTrack = False
      TabOrder = 0
      Width = 90
    end
    object teEnd: TcxTimeEdit
      Left = 178
      Top = 28
      AutoSize = False
      Properties.TimeFormat = tfHourMin
      Properties.OnChange = DoChange
      Properties.OnEditValueChanged = EndTimeChanged
      Style.HotTrack = False
      TabOrder = 1
      Height = 21
      Width = 90
    end
    object cbDuration: TcxComboBox
      Left = 324
      Top = 28
      AutoSize = False
      Properties.ImmediateDropDownWhenKeyPressed = False
      Properties.ImmediatePost = True
      Properties.IncrementalSearch = False
      Properties.OnChange = DoChange
      Properties.OnPopup = cbDurationPropertiesPopup
      Properties.OnValidate = cbDurationPropertiesValidate
      Style.HotTrack = False
      TabOrder = 2
      Height = 21
      Width = 121
    end
    object lcMainGroup_Root: TdxLayoutGroup
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Visible = False
      Hidden = True
      ItemIndex = 1
      ShowBorder = False
      Index = -1
    end
    object dxLayoutItem1: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup1
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Visible = False
      Control = btnOk
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 110
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem3: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup1
      AlignHorz = ahLeft
      AlignVert = avClient
      CaptionOptions.Visible = False
      Control = btnRemove
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 110
      ControlOptions.ShowBorder = False
      Enabled = False
      Index = 2
    end
    object dxLayoutItem2: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup1
      AlignVert = avClient
      CaptionOptions.Visible = False
      Control = btnCancel
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 110
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lbStart1: TdxLayoutItem
      Parent = gbRange
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Text = 'Start:'
      Control = deStart
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 135
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem4: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup2
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = rbNoEndDate
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 79
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem5: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup3
      AlignHorz = ahClient
      AlignVert = avCenter
      SizeOptions.AssignedValues = [sovSizableHorz]
      SizeOptions.SizableHorz = False
      SizeOptions.Width = 85
      CaptionOptions.Visible = False
      Control = rbEndAfter
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 113
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lbOccurrences: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup3
      CaptionOptions.Text = 'occurrences'
      CaptionOptions.Layout = clRight
      Control = meEndAfter
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 46
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem6: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup4
      AlignHorz = ahLeft
      AlignVert = avCenter
      SizeOptions.AssignedValues = [sovSizableHorz]
      SizeOptions.SizableHorz = False
      SizeOptions.Width = 85
      CaptionOptions.Visible = False
      Control = rbEndBy
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 57
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem7: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup4
      AlignHorz = ahRight
      Control = deEndBy
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 109
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutEmptySpaceItem1: TdxLayoutEmptySpaceItem
      Parent = lcMainGroup_Root
      SizeOptions.Height = 10
      SizeOptions.Width = 10
      CaptionOptions.Text = 'Empty Space Item'
      Index = 3
    end
    object dxLayoutItem11: TdxLayoutItem
      Parent = pnlPeriodicity
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = rbYearly
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 50
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object dxLayoutItem8: TdxLayoutItem
      Parent = pnlPeriodicity
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = rbDaily
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 43
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem9: TdxLayoutItem
      Parent = pnlPeriodicity
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = rbWeekly
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 55
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem10: TdxLayoutItem
      Parent = pnlPeriodicity
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = rbMonthly
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 58
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup
      Parent = lcMainGroup_Root
      AlignHorz = ahCenter
      LayoutDirection = ldHorizontal
      Index = 4
    end
    object gbRange: TdxLayoutGroup
      Parent = lcMainGroup_Root
      CaptionOptions.Text = 'Range of recurrence'
      LayoutDirection = ldHorizontal
      Index = 2
    end
    object dxLayoutAutoCreatedGroup2: TdxLayoutAutoCreatedGroup
      Parent = gbRange
      AlignHorz = ahLeft
      Index = 1
    end
    object dxLayoutAutoCreatedGroup3: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutAutoCreatedGroup2
      LayoutDirection = ldHorizontal
      Index = 1
    end
    object dxLayoutAutoCreatedGroup4: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutAutoCreatedGroup2
      LayoutDirection = ldHorizontal
      Index = 2
    end
    object gbPattern: TdxLayoutGroup
      Parent = lcMainGroup_Root
      CaptionOptions.Text = 'Recurrence pattern'
      ItemIndex = 2
      LayoutDirection = ldHorizontal
      Index = 1
    end
    object pnlPeriodicity: TdxLayoutGroup
      Parent = gbPattern
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      Offsets.Bottom = 2
      Offsets.Top = 2
      SizeOptions.Width = 110
      ItemIndex = 2
      ShowBorder = False
      Index = 0
    end
    object dxLayoutSeparatorItem1: TdxLayoutSeparatorItem
      Parent = gbPattern
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object pnlViewsHost: TdxLayoutGroup
      Parent = gbPattern
      AlignHorz = ahClient
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      SizeOptions.AssignedValues = [sovSizableHorz]
      SizeOptions.SizableHorz = True
      SizeOptions.Width = 400
      ItemIndex = 1
      LayoutDirection = ldTabbed
      ShowBorder = False
      TabbedOptions.HideTabs = True
      Index = 2
    end
    object pnlMonthly: TdxLayoutGroup
      Parent = pnlViewsHost
      ItemIndex = 1
      Index = 0
    end
    object dxLayoutItem12: TdxLayoutItem
      Parent = pnlMonthlyDay
      AlignHorz = ahLeft
      AlignVert = avCenter
      SizeOptions.AssignedValues = [sovSizableHorz]
      SizeOptions.SizableHorz = True
      SizeOptions.Width = 58
      CaptionOptions.Visible = False
      CaptionOptions.Layout = clRight
      Control = rbDay
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 39
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lbOfEvery: TdxLayoutItem
      Parent = pnlMonthlyDay
      AlignHorz = ahLeft
      AlignVert = avCenter
      CaptionOptions.Text = 'of every'
      CaptionOptions.Layout = clRight
      Control = meNumOfDay
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 32
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lbMonths: TdxLayoutItem
      Parent = pnlMonthlyDay
      AlignHorz = ahLeft
      AlignVert = avCenter
      CaptionOptions.Text = 'month(s)'
      CaptionOptions.Layout = clRight
      Control = meNumMonth
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 32
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object pnlMonthlyDay: TdxLayoutGroup
      Parent = pnlMonthly
      AlignVert = avTop
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 0
    end
    object pnlMonthlyThe: TdxLayoutGroup
      Parent = pnlMonthly
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 1
    end
    object dxLayoutItem13: TdxLayoutItem
      Parent = pnlMonthlyThe
      AlignVert = avCenter
      SizeOptions.AssignedValues = [sovSizableHorz]
      SizeOptions.SizableHorz = True
      SizeOptions.Width = 58
      CaptionOptions.Visible = False
      Control = rbThe
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 38
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem14: TdxLayoutItem
      Parent = pnlMonthlyThe
      AlignVert = avCenter
      Control = cbWeek
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 65
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lbOfEvery1: TdxLayoutItem
      Parent = pnlMonthlyThe
      AlignVert = avCenter
      CaptionOptions.Text = 'of every'
      CaptionOptions.Layout = clRight
      Control = cbDay
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 95
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object lbMonths1: TdxLayoutItem
      Parent = pnlMonthlyThe
      AlignVert = avCenter
      CaptionOptions.Text = 'month(s)'
      CaptionOptions.Layout = clRight
      Control = meNumMonth1
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 32
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object pnlDaily: TdxLayoutGroup
      Parent = pnlViewsHost
      CaptionOptions.Text = 'New Group'
      LayoutDirection = ldHorizontal
      Index = 1
    end
    object dxLayoutItem15: TdxLayoutItem
      Parent = dxLayoutGroup2
      AlignHorz = ahLeft
      AlignVert = avCenter
      SizeOptions.AssignedValues = [sovSizableHorz]
      SizeOptions.SizableHorz = False
      SizeOptions.Width = 59
      CaptionOptions.Visible = False
      Control = rbEvery
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 48
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lbDay: TdxLayoutItem
      Parent = dxLayoutGroup2
      AlignHorz = ahLeft
      AlignVert = avCenter
      CaptionOptions.Text = 'day'
      CaptionOptions.Layout = clRight
      Control = meDay
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 40
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutGroup2: TdxLayoutGroup
      Parent = dxLayoutAutoCreatedGroup5
      AlignVert = avTop
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 0
    end
    object dxLayoutItem16: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup5
      SizeOptions.AssignedValues = [sovSizableHorz, sovSizableVert]
      SizeOptions.SizableHorz = False
      SizeOptions.SizableVert = False
      SizeOptions.Width = 170
      CaptionOptions.Visible = False
      Control = rbEveryWeekday
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 113
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup5: TdxLayoutAutoCreatedGroup
      Parent = pnlDaily
      Index = 0
    end
    object pnlWeekly: TdxLayoutGroup
      Parent = pnlViewsHost
      CaptionOptions.Text = 'New Group'
      ItemIndex = 2
      Index = 2
    end
    object dxLayoutAutoCreatedGroup6: TdxLayoutAutoCreatedGroup
      Parent = pnlWeekly
      LayoutDirection = ldHorizontal
      Index = 0
    end
    object lbRecurEvery: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup6
      AlignHorz = ahLeft
      CaptionOptions.Text = 'Rec&ur every'
      Control = meNumOfWeek
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 40
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lbWeeksOn: TdxLayoutLabeledItem
      Parent = dxLayoutAutoCreatedGroup6
      AlignVert = avClient
      CaptionOptions.Text = 'week(s) on:'
      Index = 1
    end
    object pnlYearly: TdxLayoutGroup
      Parent = pnlViewsHost
      LayoutDirection = ldHorizontal
      Index = 3
    end
    object dxLayoutItem24: TdxLayoutItem
      Parent = dxLayoutGroup3
      AlignHorz = ahLeft
      AlignVert = avCenter
      SizeOptions.AssignedValues = [sovSizableHorz]
      SizeOptions.SizableHorz = True
      SizeOptions.Width = 58
      CaptionOptions.Visible = False
      Control = rbEvery1
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 48
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem25: TdxLayoutItem
      Parent = dxLayoutGroup3
      AlignHorz = ahLeft
      AlignVert = avCenter
      Control = cbMonths
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 95
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem26: TdxLayoutItem
      Parent = dxLayoutGroup3
      AlignVert = avCenter
      Control = meDayOfMonth
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 32
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutGroup3: TdxLayoutGroup
      Parent = dxLayoutAutoCreatedGroup8
      AlignVert = avTop
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      ItemIndex = 2
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 0
    end
    object dxLayoutItem27: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup9
      AlignHorz = ahLeft
      AlignVert = avCenter
      SizeOptions.AssignedValues = [sovSizableHorz]
      SizeOptions.SizableHorz = True
      SizeOptions.Width = 58
      CaptionOptions.Visible = False
      Control = rbThe1
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 38
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutAutoCreatedGroup8: TdxLayoutAutoCreatedGroup
      Parent = pnlYearly
      Index = 0
    end
    object dxLayoutItem28: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup9
      AlignVert = avCenter
      Control = cbWeek1
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 65
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup9: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutAutoCreatedGroup8
      AlignVert = avTop
      LayoutDirection = ldHorizontal
      Index = 1
    end
    object dxLayoutItem29: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup9
      AlignVert = avCenter
      Control = cbDay1
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 95
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object lbOf: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup9
      AlignVert = avCenter
      CaptionOptions.Text = 'of'
      Control = cbMonths1
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 95
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object dxLayoutItem17: TdxLayoutItem
      Parent = dxLayoutGroup4
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = cbDayOfWeek1
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 58
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem18: TdxLayoutItem
      Parent = dxLayoutGroup5
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = cbDayOfWeek2
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 61
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem19: TdxLayoutItem
      Parent = dxLayoutGroup6
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = cbDayOfWeek3
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 77
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem20: TdxLayoutItem
      Parent = dxLayoutGroup8
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = cbDayOfWeek4
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 65
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutGroup1: TdxLayoutGroup
      Parent = pnlWeekly
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Text = 'New Group'
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 1
    end
    object dxLayoutItem21: TdxLayoutItem
      Parent = dxLayoutGroup4
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = cbDayOfWeek5
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 50
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem22: TdxLayoutItem
      Parent = dxLayoutGroup5
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = cbDayOfWeek6
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 64
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem23: TdxLayoutItem
      Parent = dxLayoutGroup7
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Visible = False
      Control = cbDayOfWeek7
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 56
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object gbTime: TdxLayoutGroup
      Parent = lcMainGroup_Root
      CaptionOptions.Text = 'Event Time'
      ItemIndex = 2
      LayoutDirection = ldHorizontal
      Index = 0
    end
    object lbStart: TdxLayoutItem
      Parent = gbTime
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Text = 'Start:'
      Control = teStart
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 90
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lbEnd: TdxLayoutItem
      Parent = gbTime
      AlignHorz = ahLeft
      AlignVert = avClient
      CaptionOptions.Text = 'End:'
      Control = teEnd
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 90
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lbDuration: TdxLayoutItem
      Parent = gbTime
      AlignVert = avClient
      CaptionOptions.Text = 'Duration:'
      Control = cbDuration
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutGroup4: TdxLayoutGroup
      Parent = dxLayoutAutoCreatedGroup10
      AlignHorz = ahLeft
      AlignVert = avClient
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      SizeOptions.AssignedValues = [sovSizableHorz, sovSizableVert]
      SizeOptions.SizableHorz = False
      SizeOptions.SizableVert = False
      SizeOptions.Width = 80
      ButtonOptions.Visible = False
      ItemIndex = 1
      ShowBorder = False
      Index = 0
    end
    object dxLayoutGroup5: TdxLayoutGroup
      Parent = dxLayoutAutoCreatedGroup10
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      SizeOptions.AssignedValues = [sovSizableHorz, sovSizableVert]
      SizeOptions.SizableHorz = False
      SizeOptions.SizableVert = False
      SizeOptions.Width = 80
      ButtonOptions.Visible = False
      ItemIndex = 1
      ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup10: TdxLayoutAutoCreatedGroup
      Parent = pnlWeekly
      LayoutDirection = ldHorizontal
      Index = 2
    end
    object dxLayoutGroup6: TdxLayoutGroup
      Parent = dxLayoutGroup7
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      SizeOptions.AssignedValues = [sovSizableHorz, sovSizableVert]
      SizeOptions.SizableHorz = False
      SizeOptions.SizableVert = False
      SizeOptions.Width = 80
      ButtonOptions.Visible = False
      ShowBorder = False
      Index = 0
    end
    object dxLayoutGroup7: TdxLayoutGroup
      Parent = dxLayoutAutoCreatedGroup10
      AlignHorz = ahLeft
      CaptionOptions.Text = 'New Group'
      SizeOptions.AssignedValues = [sovSizableHorz, sovSizableVert]
      SizeOptions.SizableHorz = False
      SizeOptions.SizableVert = False
      SizeOptions.Height = 39
      ShowBorder = False
      Index = 2
    end
    object dxLayoutGroup8: TdxLayoutGroup
      Parent = dxLayoutAutoCreatedGroup10
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      SizeOptions.AssignedValues = [sovSizableHorz, sovSizableVert]
      SizeOptions.SizableHorz = True
      SizeOptions.SizableVert = True
      SizeOptions.Height = 34
      SizeOptions.Width = 79
      ButtonOptions.Visible = False
      ShowBorder = False
      Index = 3
    end
  end
  object dxLayoutLookAndFeelList: TdxLayoutLookAndFeelList
    Left = 408
    Top = 8
    object dxLayoutCxLookAndFeel: TdxLayoutCxLookAndFeel
      PixelsPerInch = 96
    end
  end
end
