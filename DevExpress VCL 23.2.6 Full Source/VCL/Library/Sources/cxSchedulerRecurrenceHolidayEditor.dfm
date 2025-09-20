object cxSchedulerRecurrenceHolidayEditorForm: TcxSchedulerRecurrenceHolidayEditorForm
  Left = 277
  Top = 263
  AutoSize = True
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Event recurrence'
  ClientHeight = 305
  ClientWidth = 540
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lcMain: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 540
    Height = 305
    TabOrder = 0
    AutoSize = True
    LayoutLookAndFeel = dxLayoutCxLookAndFeel
    object btnOk: TcxButton
      Left = 80
      Top = 363
      Width = 110
      Height = 23
      Caption = '&Ok'
      Default = True
      TabOrder = 35
      OnClick = btnOkClick
    end
    object btnRemove: TcxButton
      Left = 312
      Top = 363
      Width = 110
      Height = 23
      Caption = '&Remove recurrence'
      Enabled = False
      ModalResult = 3
      TabOrder = 37
    end
    object btnCancel: TcxButton
      Left = 196
      Top = 363
      Width = 110
      Height = 23
      Cancel = True
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 36
    end
    object deStart: TcxDateEdit
      Left = 58
      Top = 239
      Properties.DateButtons = [btnToday]
      Properties.InputKind = ikStandard
      Properties.OnChange = DoChange
      Properties.OnEditValueChanged = deStartPropertiesEditValueChanged
      Properties.OnValidate = deStartPropertiesValidate
      Style.HotTrack = False
      TabOrder = 29
      Width = 135
    end
    object rbNoEndDate: TcxRadioButton
      Left = 199
      Top = 239
      Caption = 'No end date'
      Checked = True
      Color = 16448250
      ParentColor = False
      TabOrder = 30
      TabStop = True
      OnClick = rbNoEndDateClick
      AutoSize = True
      GroupIndex = 1
      ParentBackground = False
      Transparent = True
    end
    object rbEndAfter: TcxRadioButton
      Left = 199
      Top = 268
      Caption = 'End after:'
      Color = 16448250
      ParentColor = False
      TabOrder = 31
      OnClick = DoChange
      AutoSize = True
      GroupIndex = 1
      ParentBackground = False
      Transparent = True
    end
    object meEndAfter: TcxMaskEdit
      Tag = 11452416
      Left = 318
      Top = 267
      Properties.MaskKind = emkRegExpr
      Properties.EditMask = '\d{0,4}'
      Properties.MaxLength = 0
      Properties.OnChange = meEndAfterPropertiesChange
      Properties.OnEditValueChanged = meEndAfterPropertiesEditValueChanged
      Style.HotTrack = False
      TabOrder = 32
      OnExit = meEndAfterExit
      Width = 46
    end
    object rbEndBy: TcxRadioButton
      Left = 199
      Top = 299
      Caption = 'End by:'
      Color = 16448250
      ParentColor = False
      TabOrder = 33
      OnClick = DoChange
      AutoSize = True
      GroupIndex = 1
      ParentBackground = False
      Transparent = True
    end
    object deEndBy: TcxDateEdit
      Tag = 11453468
      Left = 267
      Top = 298
      Properties.DateButtons = [btnToday]
      Properties.InputKind = ikStandard
      Properties.OnChange = deEndByPropertiesChange
      Properties.OnEditValueChanged = deEndByPropertiesEditValueChanged
      Style.HotTrack = False
      TabOrder = 34
      Width = 109
    end
    object rbYearly: TcxRadioButton
      Tag = 3
      Left = 25
      Top = 139
      Caption = 'Yearly'
      Color = 16448250
      ParentColor = False
      TabOrder = 3
      OnClick = SelectPeriodicityClick
      AutoSize = True
      GroupIndex = 2
      ParentBackground = False
      Transparent = True
    end
    object rbDaily: TcxRadioButton
      Left = 25
      Top = 55
      Caption = 'Daily'
      Checked = True
      Color = 16448250
      ParentColor = False
      TabOrder = 0
      TabStop = True
      OnClick = SelectPeriodicityClick
      AutoSize = True
      GroupIndex = 2
      ParentBackground = False
      Transparent = True
    end
    object rbWeekly: TcxRadioButton
      Tag = 1
      Left = 25
      Top = 83
      Caption = 'Weekly'
      Color = 16448250
      ParentColor = False
      TabOrder = 1
      OnClick = SelectPeriodicityClick
      AutoSize = True
      GroupIndex = 2
      ParentBackground = False
      Transparent = True
    end
    object rbMonthly: TcxRadioButton
      Tag = 2
      Left = 25
      Top = 111
      Caption = 'Monthly'
      Color = 16448250
      ParentColor = False
      TabOrder = 2
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
      Color = 16448250
      ParentColor = False
      TabOrder = 4
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
      TabOrder = 5
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
      TabOrder = 6
      Visible = False
      OnExit = ValidateNumber
      Width = 32
    end
    object rbThe: TcxRadioButton
      Left = 10000
      Top = 10000
      Caption = 'The'
      Color = 16448250
      ParentColor = False
      TabOrder = 7
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
      TabOrder = 8
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
      TabOrder = 9
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
      TabOrder = 10
      Visible = False
      OnExit = ValidateNumber
      Width = 32
    end
    object rbEvery: TcxRadioButton
      Left = 10000
      Top = 10000
      Caption = 'Every'
      Checked = True
      Color = 16448250
      ParentColor = False
      TabOrder = 11
      TabStop = True
      Visible = False
      OnClick = DoChange
      AutoSize = True
      GroupIndex = 4
      ParentBackground = False
      Transparent = True
    end
    object meDay: TcxMaskEdit
      Left = 10000
      Top = 10000
      Properties.MaskKind = emkRegExpr
      Properties.EditMask = '\d{0,4}'
      Properties.MaxLength = 0
      Properties.OnChange = meDayPropertiesChange
      Style.HotTrack = False
      TabOrder = 12
      Visible = False
      OnExit = ValidateNumber
      Width = 40
    end
    object rbEveryWeekday: TcxRadioButton
      Left = 10000
      Top = 10000
      Caption = 'Every weekday'
      Color = 16448250
      ParentColor = False
      TabOrder = 13
      Visible = False
      OnClick = rbEveryWeekdayClick
      AutoSize = True
      GroupIndex = 4
      ParentBackground = False
      Transparent = True
    end
    object meNumOfWeek: TcxMaskEdit
      Left = 181
      Top = 64
      Properties.MaskKind = emkRegExpr
      Properties.EditMask = '\d{0,4}'
      Properties.MaxLength = 0
      Properties.OnChange = DoChange
      Style.HotTrack = False
      TabOrder = 14
      OnExit = ValidateNumber
      Width = 40
    end
    object rbEvery1: TcxRadioButton
      Left = 10000
      Top = 10000
      Caption = 'Every'
      Checked = True
      Color = 16448250
      ParentColor = False
      TabOrder = 22
      TabStop = True
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
      TabOrder = 24
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
      TabOrder = 25
      Visible = False
      OnExit = ValidateNumber
      Width = 32
    end
    object rbThe1: TcxRadioButton
      Left = 10000
      Top = 10000
      Caption = 'The'
      Color = 16448250
      ParentColor = False
      TabOrder = 23
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
      TabOrder = 26
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
      TabOrder = 27
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
      TabOrder = 28
      Visible = False
      Width = 95
    end
    object cbDayOfWeek1: TcxCheckBox
      Tag = 1
      Left = 117
      Top = 95
      Caption = 'Sunday'
      Properties.OnChange = DoChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 15
      Transparent = True
    end
    object cbDayOfWeek2: TcxCheckBox
      Tag = 2
      Left = 213
      Top = 95
      Caption = 'Monday'
      Properties.OnChange = DoChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 17
      Transparent = True
    end
    object cbDayOfWeek3: TcxCheckBox
      Tag = 3
      Left = 309
      Top = 95
      Caption = 'Tuesday'
      Properties.OnChange = DoChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 19
      Transparent = True
    end
    object cbDayOfWeek4: TcxCheckBox
      Tag = 4
      Left = 384
      Top = 95
      Caption = 'Wednesday'
      Properties.OnChange = DoChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 21
      Transparent = True
    end
    object cbDayOfWeek5: TcxCheckBox
      Tag = 5
      Left = 117
      Top = 131
      Caption = 'Thursday'
      Properties.OnChange = DoChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 16
      Transparent = True
    end
    object cbDayOfWeek6: TcxCheckBox
      Tag = 6
      Left = 213
      Top = 131
      Caption = 'Friday'
      Properties.OnChange = DoChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 18
      Transparent = True
    end
    object cbDayOfWeek7: TcxCheckBox
      Tag = 7
      Left = 309
      Top = 131
      Caption = 'Saturday'
      Properties.OnChange = DoChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 20
      Transparent = True
    end
    object lcMainGroup_Root: TdxLayoutGroup
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Visible = False
      Hidden = True
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
      ControlOptions.OriginalHeight = 25
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
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 84
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem5: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup3
      AlignHorz = ahClient
      AlignVert = avCenter
      CaptionOptions.Visible = False
      Control = rbEndAfter
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 113
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lbOccurrences: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup3
      CaptionOptions.Text = 'occurrences'
      CaptionOptions.Layout = clRight
      Control = meEndAfter
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 46
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem6: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup4
      AlignHorz = ahLeft
      AlignVert = avCenter
      CaptionOptions.Visible = False
      Control = rbEndBy
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 62
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem7: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup4
      Control = deEndBy
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 109
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutEmptySpaceItem1: TdxLayoutEmptySpaceItem
      Parent = lcMainGroup_Root
      SizeOptions.Height = 10
      SizeOptions.Width = 10
      CaptionOptions.Text = 'Empty Space Item'
      Index = 2
    end
    object dxLayoutItem11: TdxLayoutItem
      Parent = pnlPeriodicity
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = rbYearly
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 55
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object dxLayoutItem8: TdxLayoutItem
      Parent = pnlPeriodicity
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = rbDaily
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 48
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem9: TdxLayoutItem
      Parent = pnlPeriodicity
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = rbWeekly
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 60
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem10: TdxLayoutItem
      Parent = pnlPeriodicity
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = rbMonthly
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 63
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup
      Parent = lcMainGroup_Root
      AlignHorz = ahCenter
      LayoutDirection = ldHorizontal
      Index = 3
    end
    object gbRange: TdxLayoutGroup
      Parent = lcMainGroup_Root
      CaptionOptions.Text = 'Range of recurrence'
      LayoutDirection = ldHorizontal
      Index = 1
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
      Index = 0
    end
    object pnlPeriodicity: TdxLayoutGroup
      Parent = gbPattern
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      Offsets.Bottom = 2
      Offsets.Top = 2
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
      ItemIndex = 2
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
      CaptionOptions.Visible = False
      CaptionOptions.Layout = clRight
      Control = rbDay
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 44
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
      ControlOptions.OriginalHeight = 25
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
      ControlOptions.OriginalHeight = 25
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
      CaptionOptions.Visible = False
      Control = rbThe
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 43
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem14: TdxLayoutItem
      Parent = pnlMonthlyThe
      AlignVert = avCenter
      Control = cbWeek
      ControlOptions.OriginalHeight = 25
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
      ControlOptions.OriginalHeight = 25
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
      ControlOptions.OriginalHeight = 25
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
      Parent = dxLayoutGroup3
      AlignHorz = ahLeft
      AlignVert = avCenter
      CaptionOptions.Visible = False
      Control = rbEvery
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 53
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lbDay: TdxLayoutItem
      Parent = dxLayoutGroup3
      AlignHorz = ahLeft
      AlignVert = avCenter
      CaptionOptions.Text = 'day'
      CaptionOptions.Layout = clRight
      Control = meDay
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 40
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutGroup3: TdxLayoutGroup
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
      CaptionOptions.Visible = False
      Control = rbEveryWeekday
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 22
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
      ItemIndex = 1
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
      ControlOptions.OriginalHeight = 25
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
      ItemIndex = 1
      LayoutDirection = ldHorizontal
      Index = 3
    end
    object dxLayoutItem24: TdxLayoutItem
      Parent = dxLayoutGroup4
      AlignHorz = ahLeft
      AlignVert = avCenter
      CaptionOptions.Visible = False
      Control = rbEvery1
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 53
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem25: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup10
      AlignHorz = ahLeft
      AlignVert = avTop
      Control = cbMonths
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 95
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem26: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup10
      AlignVert = avClient
      Control = meDayOfMonth
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 32
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutGroup4: TdxLayoutGroup
      Parent = dxLayoutAutoCreatedGroup9
      AlignVert = avTop
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 0
    end
    object dxLayoutItem27: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup9
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Visible = False
      Control = rbThe1
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 43
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup9: TdxLayoutAutoCreatedGroup
      Parent = pnlYearly
      Index = 0
    end
    object dxLayoutItem28: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup12
      AlignVert = avClient
      Control = cbWeek1
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 65
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem29: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup12
      AlignVert = avCenter
      Control = cbDay1
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 95
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lbOf: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup12
      AlignVert = avClient
      CaptionOptions.Text = 'of'
      Control = cbMonths1
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 95
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutItem17: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup8
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Visible = False
      Control = cbDayOfWeek1
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 61
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem18: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup11
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Visible = False
      Control = cbDayOfWeek2
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 63
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem19: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup7
      AlignVert = avClient
      CaptionOptions.Visible = False
      Control = cbDayOfWeek3
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 90
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem20: TdxLayoutItem
      Parent = dxLayoutGroup1
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Visible = False
      Control = cbDayOfWeek4
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 82
      ControlOptions.ShowBorder = False
      Index = 3
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
      Parent = dxLayoutAutoCreatedGroup8
      CaptionOptions.Visible = False
      Control = cbDayOfWeek5
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 90
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem22: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup11
      CaptionOptions.Visible = False
      Control = cbDayOfWeek6
      ControlOptions.OriginalHeight = 30
      ControlOptions.OriginalWidth = 90
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem23: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup7
      AlignVert = avClient
      CaptionOptions.Visible = False
      Control = cbDayOfWeek7
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 90
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup8: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutGroup1
      AlignHorz = ahLeft
      Index = 0
    end
    object dxLayoutAutoCreatedGroup11: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutGroup1
      AlignHorz = ahLeft
      Index = 1
    end
    object dxLayoutAutoCreatedGroup7: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutGroup1
      Index = 2
    end
    object dxLayoutGroup2: TdxLayoutGroup
      Parent = pnlYearly
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      ItemIndex = 1
      ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup10: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutGroup2
      AlignHorz = ahLeft
      AlignVert = avTop
      LayoutDirection = ldHorizontal
      Index = 0
    end
    object dxLayoutAutoCreatedGroup12: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutGroup2
      AlignVert = avTop
      LayoutDirection = ldHorizontal
      Index = 1
    end
  end
  object dxLayoutLookAndFeelList: TdxLayoutLookAndFeelList
    Left = 416
    Top = 65528
    object dxLayoutCxLookAndFeel: TdxLayoutCxLookAndFeel
      PixelsPerInch = 96
    end
  end
end
