object dxGanttControlRecurringTaskInformationDialogForm: TdxGanttControlRecurringTaskInformationDialogForm
  Left = 0
  Top = 0
  AutoSize = True
  BorderStyle = bsDialog
  Caption = 'Recurring Task Information'
  ClientHeight = 585
  ClientWidth = 769
  Color = clBtnFace
  Font.Height = -11
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lcMain: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 769
    Height = 585
    TabOrder = 0
    AutoSize = True
    LayoutLookAndFeel = dxLayoutCxLookAndFeel1
    CustomizeFormTabbedView = True
    object meDuration: TdxMeasurementUnitEdit
      Left = 493
      Top = 10
      Properties.ValidationOptions = [evoAllowLoseFocus]
      Properties.OnEditValueChanged = meDurationPropertiesEditValueChanged
      Style.TransparentBorder = False
      TabOrder = 1
      Width = 69
    end
    object btnOk: TcxButton
      Left = 406
      Top = 347
      Width = 75
      Height = 25
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 18
      OnClick = btnOkClick
    end
    object btnCancel: TcxButton
      Left = 487
      Top = 347
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 19
      OnClick = btnOkClick
    end
    object edName: TcxTextEdit
      Left = 67
      Top = 10
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 0
      Text = 'edName'
      Width = 374
    end
    object deRangeStart: TcxDateEdit
      Left = 67
      Top = 206
      Properties.ImmediatePost = True
      Properties.OnCloseUp = deRangeStartPropertiesCloseUp
      Properties.OnEditValueChanged = deRangeStartPropertiesEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 14
      Width = 121
    end
    object deRangeEndBy: TcxDateEdit
      Left = 270
      Top = 231
      Properties.ImmediatePost = True
      Properties.OnCloseUp = deRangeEndByPropertiesCloseUp
      Properties.OnEditValueChanged = deRangeEndByPropertiesEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 16
      Width = 121
    end
    object cmbCalendar: TcxComboBox
      Left = 67
      Top = 299
      Properties.DropDownListStyle = lsFixedList
      Properties.OnChange = lrbDailyClick
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 17
      Width = 205
    end
    object seDailyEvery: TcxSpinEdit
      Left = 10000
      Top = 10000
      Properties.ImmediatePost = True
      Properties.MaxValue = 12.000000000000000000
      Properties.MinValue = 1.000000000000000000
      Properties.OnEditValueChanged = deRangeStartPropertiesEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 2
      Value = 1
      Visible = False
      Width = 57
    end
    object seWeeklyEvery: TcxSpinEdit
      Left = 171
      Top = 77
      Properties.ImmediatePost = True
      Properties.MaxValue = 12.000000000000000000
      Properties.MinValue = 1.000000000000000000
      Properties.OnEditValueChanged = deRangeStartPropertiesEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 3
      Value = 1
      Width = 57
    end
    object seMonthlyDay: TcxSpinEdit
      Left = 10000
      Top = 10000
      Properties.ImmediatePost = True
      Properties.MaxValue = 31.000000000000000000
      Properties.MinValue = 1.000000000000000000
      Properties.OnEditValueChanged = deRangeStartPropertiesEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 4
      Value = 1
      Visible = False
      Width = 50
    end
    object seMonthlyDayOfEvery: TcxSpinEdit
      Left = 10000
      Top = 10000
      Properties.ImmediatePost = True
      Properties.MaxValue = 12.000000000000000000
      Properties.MinValue = 1.000000000000000000
      Properties.OnEditValueChanged = deRangeStartPropertiesEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 5
      Value = 1
      Visible = False
      Width = 57
    end
    object cmbMonthlyTheRegularDay: TcxComboBox
      Left = 10000
      Top = 10000
      Properties.DropDownListStyle = lsFixedList
      Properties.OnEditValueChanged = deRangeStartPropertiesEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 6
      Visible = False
      Width = 79
    end
    object cmbMonthlyTheWeekDay: TcxComboBox
      Left = 10000
      Top = 10000
      AutoSize = False
      Properties.DropDownListStyle = lsFixedList
      Properties.OnEditValueChanged = deRangeStartPropertiesEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 7
      Visible = False
      Height = 19
      Width = 100
    end
    object seMonthlyTheDayOfEvery: TcxSpinEdit
      Left = 10000
      Top = 10000
      AutoSize = False
      Properties.ImmediatePost = True
      Properties.MaxValue = 12.000000000000000000
      Properties.MinValue = 1.000000000000000000
      Properties.OnEditValueChanged = deRangeStartPropertiesEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 8
      Value = 1
      Visible = False
      Height = 19
      Width = 57
    end
    object cmbYearlyTheRegularDay: TcxComboBox
      Left = 10000
      Top = 10000
      Properties.DropDownListStyle = lsFixedList
      Properties.OnEditValueChanged = deRangeStartPropertiesEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 11
      Visible = False
      Width = 121
    end
    object cmbYearlyTheRegularWeekDay: TcxComboBox
      Left = 10000
      Top = 10000
      AutoSize = False
      Properties.DropDownListStyle = lsFixedList
      Properties.OnEditValueChanged = deRangeStartPropertiesEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 12
      Visible = False
      Height = 19
      Width = 121
    end
    object cmbYearlyTheMonth: TcxComboBox
      Left = 10000
      Top = 10000
      AutoSize = False
      Properties.DropDownListStyle = lsFixedList
      Properties.DropDownRows = 12
      Properties.OnEditValueChanged = deRangeStartPropertiesEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 13
      Visible = False
      Height = 19
      Width = 121
    end
    object ceYearlyOnDay: TcxSpinEdit
      Left = 10000
      Top = 10000
      Properties.ImmediatePost = True
      Properties.MaxValue = 3.000000000000000000
      Properties.MinValue = 1.000000000000000000
      Properties.OnEditValueChanged = deRangeStartPropertiesEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 9
      Value = 1
      Visible = False
      Width = 57
    end
    object cmbYearlyOnMonth: TcxComboBox
      Left = 10000
      Top = 10000
      Properties.DropDownListStyle = lsFixedList
      Properties.DropDownRows = 12
      Properties.OnChange = cmbYearlyOnMonthPropertiesChange
      Properties.OnEditValueChanged = deRangeStartPropertiesEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 10
      Visible = False
      Width = 121
    end
    object seRangeEndAfter: TcxSpinEdit
      Left = 270
      Top = 206
      Properties.ImmediatePost = True
      Properties.MaxValue = 1000000.000000000000000000
      Properties.MinValue = 1.000000000000000000
      Properties.OnEditValueChanged = seRangeEndAfterPropertiesEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 15
      Value = 1
      Width = 57
    end
    object lcMainGroup_Root: TdxLayoutGroup
      AlignHorz = ahLeft
      AlignVert = avTop
      ButtonOptions.Buttons = <>
      Hidden = True
      ItemIndex = 1
      ShowBorder = False
      Index = -1
    end
    object liDuration: TdxLayoutItem
      Parent = lgTogGroup
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Text = 'Duration'
      Control = meDuration
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 69
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object liBtnOk: TdxLayoutItem
      Parent = lgButtons
      AlignHorz = ahRight
      CaptionOptions.Text = 'cxButton1'
      CaptionOptions.Visible = False
      Control = btnOk
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object liBtnCancel: TdxLayoutItem
      Parent = lgButtons
      AlignHorz = ahRight
      CaptionOptions.Text = 'cxButton1'
      CaptionOptions.Visible = False
      Control = btnCancel
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lgButtons: TdxLayoutGroup
      Parent = lcMainGroup_Root
      CaptionOptions.Text = 'New Group'
      ButtonOptions.Buttons = <>
      ItemIndex = 1
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 5
    end
    object liName: TdxLayoutItem
      Parent = lgTogGroup
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'Task Name'
      Control = edName
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 355
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lgRecurrenceRange: TdxLayoutGroup
      Parent = lcMainGroup_Root
      CaptionOptions.Text = 'Range of recurrence'
      ButtonOptions.Buttons = <>
      ItemIndex = 1
      Index = 2
    end
    object liRangeStart: TdxLayoutItem
      Parent = dxLayoutGroup13
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Text = 'Start'
      Control = deRangeStart
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object liRangeEndBy: TdxLayoutItem
      Parent = dxLayoutGroup6
      AlignHorz = ahLeft
      AlignVert = avTop
      AlignmentConstraint = AlignmentConstraint5
      Control = deRangeEndBy
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object lgTogGroup: TdxLayoutGroup
      Parent = lcMainGroup_Root
      CaptionOptions.Text = 'New Group'
      ButtonOptions.Buttons = <>
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 0
    end
    object lgTabs: TdxLayoutGroup
      Parent = lcMainGroup_Root
      CaptionOptions.Text = 'Tabs'
      ButtonOptions.Buttons = <>
      LayoutDirection = ldTabbed
      ShowBorder = False
      Index = 4
    end
    object liCalendar: TdxLayoutItem
      Parent = lgCalendar
      AlignHorz = ahLeft
      AlignVert = avTop
      SizeOptions.AssignedValues = [sovSizableHorz]
      SizeOptions.SizableHorz = True
      SizeOptions.Width = 253
      CaptionOptions.Text = 'Calendar'
      Control = cmbCalendar
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 205
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lgRecurrencePattern: TdxLayoutGroup
      Parent = lcMainGroup_Root
      CaptionOptions.Text = 'Recurrence pattern'
      ButtonOptions.Buttons = <>
      ItemIndex = 2
      LayoutDirection = ldHorizontal
      Index = 1
    end
    object lgRecurrencePeriod: TdxLayoutGroup
      Parent = lgRecurrencePattern
      AlignHorz = ahLeft
      AlignVert = avClient
      CaptionOptions.Text = 'New Group'
      ButtonOptions.Buttons = <>
      ItemIndex = 3
      ShowBorder = False
      Index = 0
    end
    object lgRecurrencePatternSetup: TdxLayoutGroup
      Parent = lgRecurrencePattern
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'New Group'
      ButtonOptions.Buttons = <>
      ItemIndex = 1
      LayoutDirection = ldTabbed
      ShowBorder = False
      TabbedOptions.HideTabs = True
      Index = 2
    end
    object lrbDaily: TdxLayoutRadioButtonItem
      Parent = lgRecurrencePeriod
      CaptionOptions.Text = 'Daily'
      TabStop = True
      OnClick = lrbDailyClick
      Index = 0
    end
    object lrbWeekly: TdxLayoutRadioButtonItem
      Tag = 1
      Parent = lgRecurrencePeriod
      CaptionOptions.Text = 'Weekly'
      TabStop = True
      OnClick = lrbDailyClick
      Index = 1
    end
    object lrbMonthly: TdxLayoutRadioButtonItem
      Tag = 2
      Parent = lgRecurrencePeriod
      CaptionOptions.Text = 'Monthly'
      TabStop = True
      OnClick = lrbDailyClick
      Index = 2
    end
    object lrbYearly: TdxLayoutRadioButtonItem
      Tag = 3
      Parent = lgRecurrencePeriod
      CaptionOptions.Text = 'Yearly'
      TabStop = True
      OnClick = lrbDailyClick
      Index = 3
    end
    object lgRecurrencePatternSetupDays: TdxLayoutGroup
      Parent = lgRecurrencePatternSetup
      CaptionOptions.Text = 'New Group'
      ButtonOptions.Buttons = <>
      ItemIndex = 1
      ShowBorder = False
      Index = 0
    end
    object lgRecurrencePatternSetupWeeks: TdxLayoutGroup
      Parent = lgRecurrencePatternSetup
      CaptionOptions.Text = 'New Group'
      ButtonOptions.Buttons = <>
      ItemIndex = 2
      Index = 1
    end
    object lgRecurrencePatternSetupMonths: TdxLayoutGroup
      Parent = lgRecurrencePatternSetup
      CaptionOptions.Text = 'New Group'
      ButtonOptions.Buttons = <>
      ItemIndex = 1
      Index = 2
    end
    object lgRecurrencePatternSetupYears: TdxLayoutGroup
      Parent = lgRecurrencePatternSetup
      CaptionOptions.Text = 'New Group'
      ButtonOptions.Buttons = <>
      ItemIndex = 1
      Index = 3
    end
    object dxLayoutGroup1: TdxLayoutGroup
      Parent = lgRecurrencePatternSetupDays
      AlignVert = avTop
      CaptionOptions.Text = 'New Group'
      ButtonOptions.Buttons = <>
      ItemIndex = 1
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 0
    end
    object liDailyEvery: TdxLayoutItem
      Parent = dxLayoutGroup1
      AlignHorz = ahLeft
      AlignVert = avTop
      SizeOptions.AssignedValues = [sovSizableHorz]
      SizeOptions.SizableHorz = True
      SizeOptions.Width = 90
      CaptionOptions.Text = 'Every'
      Control = seDailyEvery
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 57
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object lrbDailyEveryDays: TdxLayoutRadioButtonItem
      Parent = dxLayoutGroup1
      AlignHorz = ahLeft
      AlignVert = avClient
      AlignmentConstraint = AlignmentConstraint6
      CaptionOptions.Text = 'days'
      GroupIndex = 1
      TabStop = True
      OnClick = deRangeStartPropertiesEditValueChanged
      Index = 1
    end
    object lrbDailyEveryWorkdays: TdxLayoutRadioButtonItem
      Parent = dxLayoutGroup2
      AlignHorz = ahLeft
      AlignmentConstraint = AlignmentConstraint6
      CaptionOptions.Text = 'workdays'
      GroupIndex = 1
      TabStop = True
      OnClick = deRangeStartPropertiesEditValueChanged
      Index = 0
    end
    object dxLayoutSeparatorItem2: TdxLayoutSeparatorItem
      Parent = lgRecurrencePattern
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object dxLayoutGroup3: TdxLayoutGroup
      Parent = lgRecurrencePatternSetupWeeks
      CaptionOptions.Text = 'New Group'
      ButtonOptions.Buttons = <>
      ItemIndex = 1
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 0
    end
    object dxLayoutGroup4: TdxLayoutGroup
      Parent = lgRecurrencePatternSetupWeeks
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'New Group'
      ButtonOptions.Buttons = <>
      ItemIndex = 1
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 1
    end
    object liWeeklyRecurEveryWeeks: TdxLayoutItem
      Parent = dxLayoutGroup3
      AlignHorz = ahLeft
      AlignVert = avTop
      SizeOptions.AssignedValues = [sovSizableHorz]
      SizeOptions.SizableHorz = True
      SizeOptions.Width = 121
      CaptionOptions.Text = 'Recur every'
      Control = seWeeklyEvery
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 57
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object liWeeklyRecurEveryWeeksOn: TdxLayoutLabeledItem
      Parent = dxLayoutGroup3
      AlignHorz = ahLeft
      AlignVert = avClient
      CaptionOptions.Text = 'week(s) on:'
      Index = 1
    end
    object lcbSunday: TdxLayoutCheckBoxItem
      Parent = dxLayoutGroup4
      AlignHorz = ahLeft
      AlignVert = avClient
      CaptionOptions.Text = 'Sunday'
      OnClick = deRangeStartPropertiesEditValueChanged
      Index = 0
    end
    object lcbMonday: TdxLayoutCheckBoxItem
      Parent = dxLayoutGroup4
      AlignHorz = ahLeft
      AlignVert = avClient
      AlignmentConstraint = AlignmentConstraint1
      CaptionOptions.Text = 'Monday'
      OnClick = deRangeStartPropertiesEditValueChanged
      Index = 1
    end
    object lcbTuesday: TdxLayoutCheckBoxItem
      Parent = dxLayoutGroup4
      AlignHorz = ahLeft
      AlignVert = avClient
      AlignmentConstraint = AlignmentConstraint2
      CaptionOptions.Text = 'Tuesday'
      OnClick = deRangeStartPropertiesEditValueChanged
      Index = 2
    end
    object lcbWednesday: TdxLayoutCheckBoxItem
      Parent = dxLayoutGroup4
      AlignVert = avClient
      CaptionOptions.Text = 'Wednesday'
      OnClick = deRangeStartPropertiesEditValueChanged
      Index = 3
    end
    object lcbThursday: TdxLayoutCheckBoxItem
      Parent = dxLayoutGroup5
      AlignVert = avClient
      CaptionOptions.Text = 'Thursday'
      OnClick = deRangeStartPropertiesEditValueChanged
      Index = 0
    end
    object lcbFriday: TdxLayoutCheckBoxItem
      Parent = dxLayoutGroup5
      AlignVert = avClient
      AlignmentConstraint = AlignmentConstraint1
      CaptionOptions.Text = 'Friday'
      OnClick = deRangeStartPropertiesEditValueChanged
      Index = 1
    end
    object lcbSaturday: TdxLayoutCheckBoxItem
      Parent = dxLayoutGroup5
      AlignVert = avClient
      AlignmentConstraint = AlignmentConstraint2
      CaptionOptions.Text = 'Saturday'
      OnClick = deRangeStartPropertiesEditValueChanged
      Index = 2
    end
    object liMonthlyDay: TdxLayoutItem
      Parent = dxLayoutGroup9
      AlignHorz = ahLeft
      AlignVert = avClient
      AlignmentConstraint = AlignmentConstraint7
      SizeOptions.AssignedValues = [sovSizableHorz]
      SizeOptions.SizableHorz = True
      SizeOptions.Width = 50
      Control = seMonthlyDay
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 50
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutGroup9: TdxLayoutGroup
      Parent = lgRecurrencePatternSetupMonths
      CaptionOptions.Text = 'New Group'
      ButtonOptions.Buttons = <>
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 0
    end
    object liMonthlyDayOfEvery: TdxLayoutItem
      Parent = dxLayoutGroup9
      AlignHorz = ahLeft
      AlignVert = avClient
      SizeOptions.AssignedValues = [sovSizableHorz]
      SizeOptions.SizableHorz = True
      SizeOptions.Width = 103
      CaptionOptions.Text = 'of every'
      Control = seMonthlyDayOfEvery
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 57
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object lbMonthlyDayOfEveryMonths: TdxLayoutLabeledItem
      Parent = dxLayoutGroup9
      AlignVert = avClient
      CaptionOptions.Text = 'month(s)'
      Index = 3
    end
    object dxLayoutGroup10: TdxLayoutGroup
      Parent = lgRecurrencePatternSetupMonths
      CaptionOptions.Text = 'New Group'
      ButtonOptions.Buttons = <>
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 1
    end
    object lrbMonthlyDay: TdxLayoutRadioButtonItem
      Parent = dxLayoutGroup9
      AlignVert = avClient
      CaptionOptions.Text = 'Day'
      GroupIndex = 2
      TabStop = True
      OnClick = lrbDailyClick
      Index = 0
    end
    object lrbMonthlyThe: TdxLayoutRadioButtonItem
      Parent = dxLayoutGroup10
      AlignHorz = ahLeft
      AlignVert = avClient
      CaptionOptions.Text = 'The'
      GroupIndex = 2
      TabStop = True
      OnClick = lrbDailyClick
      Index = 0
    end
    object liMonthlyTheRegularDay: TdxLayoutItem
      Parent = dxLayoutGroup10
      AlignHorz = ahLeft
      AlignVert = avTop
      AlignmentConstraint = AlignmentConstraint7
      SizeOptions.AssignedValues = [sovSizableHorz]
      SizeOptions.SizableHorz = True
      SizeOptions.Width = 79
      Control = cmbMonthlyTheRegularDay
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 79
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object liMonthlyTheWeekDay: TdxLayoutItem
      Parent = dxLayoutGroup10
      AlignVert = avClient
      SizeOptions.AssignedValues = [sovSizableHorz]
      SizeOptions.SizableHorz = True
      SizeOptions.Width = 100
      Control = cmbMonthlyTheWeekDay
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 100
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object liMonthlyTheDayOfEvery: TdxLayoutItem
      Parent = dxLayoutGroup10
      AlignVert = avClient
      SizeOptions.AssignedValues = [sovSizableHorz]
      SizeOptions.SizableHorz = True
      SizeOptions.Width = 103
      CaptionOptions.Text = 'of every'
      Control = seMonthlyTheDayOfEvery
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 57
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object lbMonthlyTheDayOfEveryMonths: TdxLayoutLabeledItem
      Parent = dxLayoutGroup10
      AlignVert = avClient
      CaptionOptions.Text = 'months'
      Index = 4
    end
    object dxLayoutGroup11: TdxLayoutGroup
      Parent = lgRecurrencePatternSetupYears
      CaptionOptions.Text = 'New Group'
      ButtonOptions.Buttons = <>
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 0
    end
    object dxLayoutGroup12: TdxLayoutGroup
      Parent = lgRecurrencePatternSetupYears
      CaptionOptions.Text = 'New Group'
      ButtonOptions.Buttons = <>
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 1
    end
    object lrbYearlyOn: TdxLayoutRadioButtonItem
      Parent = dxLayoutGroup11
      AlignHorz = ahLeft
      AlignVert = avClient
      CaptionOptions.Text = 'On'
      Checked = True
      GroupIndex = 3
      TabStop = True
      OnClick = lrbDailyClick
      Index = 0
    end
    object lrbYearlyThe: TdxLayoutRadioButtonItem
      Parent = dxLayoutGroup12
      AlignHorz = ahLeft
      AlignVert = avClient
      CaptionOptions.Text = 'The'
      GroupIndex = 3
      TabStop = True
      OnClick = lrbDailyClick
      Index = 0
    end
    object liYearlyTheRegularDay: TdxLayoutItem
      Parent = dxLayoutGroup12
      AlignHorz = ahLeft
      AlignVert = avClient
      Control = cmbYearlyTheRegularDay
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object liYearlyTheRegularWeekDay: TdxLayoutItem
      Parent = dxLayoutGroup12
      AlignVert = avClient
      Control = cmbYearlyTheRegularWeekDay
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object liYearlyTheMonth: TdxLayoutItem
      Parent = dxLayoutGroup12
      AlignVert = avClient
      CaptionOptions.Text = 'of'
      Control = cmbYearlyTheMonth
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object liYearlyOnDay: TdxLayoutItem
      Parent = dxLayoutGroup11
      AlignVert = avClient
      Control = ceYearlyOnDay
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 57
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object liYearlyOnMonth: TdxLayoutItem
      Parent = dxLayoutGroup11
      AlignVert = avClient
      Control = cmbYearlyOnMonth
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutGroup13: TdxLayoutGroup
      Parent = lgRecurrenceRange
      CaptionOptions.Text = 'New Group'
      ButtonOptions.Buttons = <>
      ItemIndex = 1
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 0
    end
    object lrbRangeEndAfter: TdxLayoutRadioButtonItem
      Parent = dxLayoutGroup13
      AlignHorz = ahLeft
      AlignVert = avClient
      AlignmentConstraint = AlignmentConstraint4
      CaptionOptions.Text = 'End after:'
      GroupIndex = 5
      TabStop = True
      OnClick = lrbDailyClick
      Index = 1
    end
    object lrbRangeEndBy: TdxLayoutRadioButtonItem
      Parent = dxLayoutGroup6
      AlignHorz = ahLeft
      AlignVert = avClient
      AlignmentConstraint = AlignmentConstraint4
      CaptionOptions.Text = 'End by:'
      GroupIndex = 5
      TabStop = True
      OnClick = lrbDailyClick
      Index = 0
    end
    object liRangeEndAfterOccurrences: TdxLayoutItem
      Parent = dxLayoutGroup13
      AlignHorz = ahLeft
      AlignVert = avTop
      AlignmentConstraint = AlignmentConstraint5
      CaptionOptions.Text = 'occurrences'
      CaptionOptions.Layout = clRight
      Control = seRangeEndAfter
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 57
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object lgCalendar: TdxLayoutGroup
      Parent = lcMainGroup_Root
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'Calendar for scheduling this task'
      ButtonOptions.Buttons = <>
      LayoutDirection = ldHorizontal
      Index = 3
    end
    object dxLayoutGroup2: TdxLayoutGroup
      Parent = lgRecurrencePatternSetupDays
      CaptionOptions.Text = 'New Group'
      ButtonOptions.Buttons = <>
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 1
    end
    object dxLayoutGroup5: TdxLayoutGroup
      Parent = lgRecurrencePatternSetupWeeks
      CaptionOptions.Text = 'New Group'
      ButtonOptions.Buttons = <>
      ItemIndex = 1
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 2
    end
    object dxLayoutGroup6: TdxLayoutGroup
      Parent = lgRecurrenceRange
      CaptionOptions.Text = 'New Group'
      ButtonOptions.Buttons = <>
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 1
    end
    object AlignmentConstraint7: TdxLayoutAlignmentConstraint
    end
    object AlignmentConstraint1: TdxLayoutAlignmentConstraint
    end
    object AlignmentConstraint4: TdxLayoutAlignmentConstraint
    end
    object AlignmentConstraint6: TdxLayoutAlignmentConstraint
    end
    object AlignmentConstraint2: TdxLayoutAlignmentConstraint
    end
    object AlignmentConstraint5: TdxLayoutAlignmentConstraint
    end
  end
  object dxLayoutLookAndFeelList1: TdxLayoutLookAndFeelList
    Left = 496
    Top = 32
    object dxLayoutCxLookAndFeel1: TdxLayoutCxLookAndFeel
      PixelsPerInch = 96
    end
  end
end
