inherited MailClientDemoCalendarFrame: TMailClientDemoCalendarFrame
  Width = 834
  ExplicitWidth = 834
  object Scheduler: TcxScheduler [0]
    Left = 0
    Top = 290
    Width = 834
    Height = 336
    DateNavigator.Visible = False
    ViewAgenda.ShowLocations = False
    ViewDay.Active = True
    ViewDay.GroupingKind = gkNone
    Align = alClient
    ControlBox.Visible = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    OptionsView.ShowEventsWithoutResource = True
    OptionsView.ViewPosition = vpRight
    Storage = DM.SchedulerUnboundStorage
    TabOrder = 0
    OnEventSelectionChanged = SchedulerEventSelectionChanged
    Selection = 7
    Splitters = {
      010000007E000000900000008300000090000000010000009500000071020000}
    StoredClientBounds = {0100000001000000410300004F010000}
  end
  inherited bmFrame: TdxBarManager
    Categories.Strings = (
      'Default'
      'ViewDayTimeLine'
      'ViewTimeGridTimeLine')
    Categories.ItemsVisibles = (
      2
      2
      2)
    Categories.Visibles = (
      True
      True
      True)
    PixelsPerInch = 96
    DockControlHeights = (
      0
      0
      290
      0)
    object bmFrameBar1: TdxBar
      Caption = 'Apointment'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 844
      FloatTop = 0
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'ShowF'
        end
        item
          Visible = True
          ItemName = 'lbCalendarNewRepeatingEvent'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object bmFrameBar2: TdxBar
      Caption = 'Navigate'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 58
      DockingStyle = dsTop
      FloatLeft = 844
      FloatTop = 0
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'lbCalendarNavigatePrior'
        end
        item
          Visible = True
          ItemName = 'lbCalendarNavigateNext'
        end
        item
          Visible = True
          ItemName = 'lbCalendarGoToDay'
        end
        item
          Visible = True
          ItemName = 'lbCalendarZoomIn'
        end
        item
          Visible = True
          ItemName = 'lbCalendarZoomOut'
        end>
      OneOnRow = True
      Row = 1
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object bmFrameBar3: TdxBar
      Caption = 'Arrange'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 116
      DockingStyle = dsTop
      FloatLeft = 844
      FloatTop = 0
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'lbCalendarViewAgenda'
        end
        item
          Visible = True
          ItemName = 'lbCalendarViewDay'
        end
        item
          Visible = True
          ItemName = 'lbCalendarViewWorkWeek'
        end
        item
          Visible = True
          ItemName = 'lbCalendarViewWeek'
        end
        item
          Visible = True
          ItemName = 'lbCalendarViewMonth'
        end
        item
          Visible = True
          ItemName = 'lbCalendarViewTimeline'
        end>
      OneOnRow = True
      Row = 2
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object bmFrameBar4: TdxBar
      Caption = 'Group By'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 174
      DockingStyle = dsTop
      FloatLeft = 844
      FloatTop = 0
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'lbCalendarNoGroup'
        end
        item
          Visible = True
          ItemName = 'lbCalendarGroupByDate'
        end
        item
          Visible = True
          ItemName = 'lbCalendarGroupByResource'
        end>
      OneOnRow = False
      Row = 3
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object bmFrameBar5: TdxBar
      Caption = 'Layout'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 327
      DockedTop = 174
      DockingStyle = dsTop
      FloatLeft = 844
      FloatTop = 0
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'lbCalendarLayoutCompressWeekend'
        end
        item
          Visible = True
          ItemName = 'lbCalendarWorktime'
        end
        item
          Visible = True
          ItemName = 'lbCalendarViewDayTimelines'
        end
        item
          Visible = True
          ItemName = 'lbCalendarAgendaOptions'
        end>
      OneOnRow = False
      Row = 3
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object tbActions: TdxBar
      Tag = 1
      Caption = 'Actions'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 232
      DockingStyle = dsTop
      FloatLeft = 1190
      FloatTop = 8
      FloatClientWidth = 51
      FloatClientHeight = 108
      ItemLinks = <
        item
          Visible = True
          ItemName = 'lbOpenEventEditDialog'
        end
        item
          Visible = True
          ItemName = 'lbDeleteEvent'
        end>
      OneOnRow = False
      Row = 4
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object tbOptions: TdxBar
      Tag = 1
      Caption = 'Options'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 116
      DockedTop = 232
      DockingStyle = dsTop
      FloatLeft = 1299
      FloatTop = 19
      FloatClientWidth = 100
      FloatClientHeight = 118
      ItemLinks = <
        item
          Visible = True
          ItemName = 'siShowTimeAs'
        end
        item
          Visible = True
          ItemName = 'siLabelAs'
        end
        item
          Visible = True
          ItemName = 'lbRecurrence'
        end
        item
          UserDefine = [udWidth]
          UserWidth = 94
          Visible = True
          ItemName = 'cbReminder'
        end>
      OneOnRow = False
      Row = 4
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object ShowF: TdxBarLargeButton
      Caption = 'New Appointment'
      Category = 0
      Hint = 'New Appointment'
      ScreenTip = DM.stCalendarNew
      Visible = ivAlways
      OnClick = ShowFClick
      LargeImageIndex = 22
      SyncImageIndex = False
      ImageIndex = 30
    end
    object lbCalendarNewRepeatingEvent: TdxBarLargeButton
      Caption = 'New Recurring Appointment'
      Category = 0
      Hint = 'New Recurring Appointment'
      ScreenTip = DM.stCalendarNewRecurring
      Visible = ivAlways
      OnClick = lbCalendarNewRepeatingEventClick
      LargeImageIndex = 29
      SyncImageIndex = False
      ImageIndex = 43
    end
    object lbCalendarNavigatePrior: TdxBarLargeButton
      Caption = 'Backward'
      Category = 0
      Hint = 'Backward'
      ScreenTip = DM.stCalendarBack
      Visible = ivAlways
      OnClick = lbCalendarNavigatePriorClick
      LargeImageIndex = 23
      SyncImageIndex = False
      ImageIndex = 35
    end
    object lbCalendarNavigateNext: TdxBarLargeButton
      Caption = 'Forward'
      Category = 0
      Hint = 'Forward'
      ScreenTip = DM.stCalendarForward
      Visible = ivAlways
      OnClick = lbCalendarNavigateNextClick
      LargeImageIndex = 25
      SyncImageIndex = False
      ImageIndex = 38
    end
    object lbCalendarGoToDay: TdxBarLargeButton
      Caption = 'Go to Today'
      Category = 0
      Hint = 'Go to Today'
      ScreenTip = DM.stCalendarGoToToday
      Visible = ivAlways
      OnClick = lbCalendarGoToDayClick
      LargeImageIndex = 4
      SyncImageIndex = False
      ImageIndex = 24
    end
    object lbCalendarZoomIn: TdxBarLargeButton
      Caption = 'Zoom In'
      Category = 0
      Hint = 'Zoom In'
      ScreenTip = DM.stCalendarZoomIn
      Visible = ivAlways
      OnClick = lbCalendarZoomInClick
      LargeImageIndex = 35
      SyncImageIndex = False
      ImageIndex = 49
    end
    object lbCalendarZoomOut: TdxBarLargeButton
      Caption = 'Zoom Out'
      Category = 0
      Hint = 'Zoom Out'
      ScreenTip = DM.stCalendarZoomOut
      Visible = ivAlways
      OnClick = lbCalendarZoomOutClick
      LargeImageIndex = 36
      SyncImageIndex = False
      ImageIndex = 50
    end
    object lbCalendarViewDay: TdxBarLargeButton
      Caption = 'Day View'
      Category = 0
      Hint = 'Day View'
      ScreenTip = DM.stCalendarViewDay
      Visible = ivAlways
      ButtonStyle = bsChecked
      GroupIndex = 21
      OnClick = lbCalendarChangeViewClick
      LargeImageIndex = 24
      SyncImageIndex = False
      ImageIndex = 37
    end
    object lbCalendarViewWorkWeek: TdxBarLargeButton
      Tag = 1
      Caption = 'Work Week View'
      Category = 0
      Hint = 'Work Week View'
      ScreenTip = DM.stCalendarViewWeekWork
      Visible = ivAlways
      ButtonStyle = bsChecked
      GroupIndex = 21
      OnClick = lbCalendarChangeViewClick
      LargeImageIndex = 34
      SyncImageIndex = False
      ImageIndex = 48
    end
    object lbCalendarViewWeek: TdxBarLargeButton
      Tag = 2
      Caption = 'Week View'
      Category = 0
      Hint = 'Week View'
      ScreenTip = DM.stCalendarViewWeek
      Visible = ivAlways
      ButtonStyle = bsChecked
      GroupIndex = 21
      OnClick = lbCalendarChangeViewClick
      LargeImageIndex = 33
      SyncImageIndex = False
      ImageIndex = 47
    end
    object lbCalendarViewMonth: TdxBarLargeButton
      Tag = 3
      Caption = 'Month View'
      Category = 0
      Hint = 'Month View'
      ScreenTip = DM.stCalendarViewMonth
      Visible = ivAlways
      ButtonStyle = bsChecked
      GroupIndex = 21
      OnClick = lbCalendarChangeViewClick
      LargeImageIndex = 28
      SyncImageIndex = False
      ImageIndex = 42
    end
    object lbCalendarViewTimeline: TdxBarLargeButton
      Tag = 4
      Caption = 'Timeline View'
      Category = 0
      Hint = 'Timeline View'
      ScreenTip = DM.stCalendarViewTimeline
      Visible = ivAlways
      ButtonStyle = bsChecked
      GroupIndex = 21
      OnClick = lbCalendarChangeViewClick
      LargeImageIndex = 32
      SyncImageIndex = False
      ImageIndex = 46
    end
    object lbCalendarNoGroup: TdxBarLargeButton
      Caption = 'Group by None'
      Category = 0
      Hint = 'Group by None'
      ScreenTip = DM.stCalendarGroupNone
      Visible = ivAlways
      ButtonStyle = bsChecked
      GroupIndex = 22
      OnClick = GroupByClick
      LargeImageIndex = 27
      SyncImageIndex = False
      ImageIndex = 40
    end
    object lbCalendarGroupByDate: TdxBarLargeButton
      Tag = 1
      Caption = 'Group by Date'
      Category = 0
      Hint = 'Group by Date'
      ScreenTip = DM.stCalendarGroupDate
      Visible = ivAlways
      ButtonStyle = bsChecked
      GroupIndex = 22
      OnClick = GroupByClick
      LargeImageIndex = 26
      SyncImageIndex = False
      ImageIndex = 39
    end
    object lbCalendarGroupByResource: TdxBarLargeButton
      Tag = 2
      Caption = 'Group by Resource'
      Category = 0
      Hint = 'Group by Resource'
      ScreenTip = DM.stCalendarGroupResource
      Visible = ivAlways
      ButtonStyle = bsChecked
      GroupIndex = 22
      OnClick = GroupByClick
      LargeImageIndex = 38
      SyncImageIndex = False
      ImageIndex = 41
    end
    object lbCalendarLayoutCompressWeekend: TdxBarLargeButton
      Caption = 'Compress Weekend'
      Category = 0
      Enabled = False
      Hint = 'Compress Weekend'
      ScreenTip = DM.stCalendarLayoutCompressWeekend
      Visible = ivAlways
      ButtonStyle = bsChecked
      OnClick = lbCalendarLayoutCompressWeekendClick
      LargeImageIndex = 37
      SyncImageIndex = False
      ImageIndex = 36
    end
    object lbCalendarWorktime: TdxBarLargeButton
      Caption = 'Working Hours'
      Category = 0
      Hint = 'Working Hours'
      ScreenTip = DM.stCalendarLayoutWorkingHours
      Visible = ivAlways
      ButtonStyle = bsChecked
      OnClick = lbCalendarWorktimeClick
      LargeImageIndex = 30
      SyncImageIndex = False
      ImageIndex = 44
    end
    object lbCalendarViewDayTimelines: TdxBarSubItem
      Caption = 'Time Scales'
      Category = 0
      ScreenTip = DM.stCalendarLayoutTimeScales
      Visible = ivAlways
      ImageIndex = 45
      LargeImageIndex = 31
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bCalendarTimelines60Minutes'
        end
        item
          Visible = True
          ItemName = 'bCalendarTimelines30Minutes'
        end
        item
          Visible = True
          ItemName = 'bCalendarTimelines15Minutes'
        end
        item
          Visible = True
          ItemName = 'bCalendarTimelines10Minutes'
        end
        item
          Visible = True
          ItemName = 'bCalendarTimelines6Minutes'
        end
        item
          Visible = True
          ItemName = 'bCalendarTimelines5Minutes'
        end
        item
          Visible = True
          ItemName = 'bCalendarTimelinesMonth'
        end
        item
          Visible = True
          ItemName = 'bCalendarTimelinesWeek'
        end
        item
          Visible = True
          ItemName = 'bCalendarTimelinesDay'
        end>
      ItemOptions.Size = misNormal
    end
    object bCalendarTimelinesTimeStep: TdxBarSubItem
      Caption = 'TimeStep'
      Category = 0
      Visible = ivAlways
      ItemLinks = <>
    end
    object bbFree: TdxBarButton
      Caption = 'Free'
      Category = 0
      Hint = 'Free'
      Visible = ivAlways
      ButtonStyle = bsChecked
      ImageIndex = 0
      OnClick = ShowTimeAsClick
    end
    object bbTentative: TdxBarButton
      Tag = 1
      Caption = 'Tentative'
      Category = 0
      Hint = 'Tentative'
      Visible = ivAlways
      ButtonStyle = bsChecked
      ImageIndex = 1
      OnClick = ShowTimeAsClick
    end
    object bbBusy: TdxBarButton
      Tag = 2
      Caption = 'Busy'
      Category = 0
      Hint = 'Busy'
      Visible = ivAlways
      ButtonStyle = bsChecked
      ImageIndex = 2
      OnClick = ShowTimeAsClick
    end
    object bbOutOfOffice: TdxBarButton
      Tag = 3
      Caption = 'Out Of Office'
      Category = 0
      Hint = 'Out Of Office'
      Visible = ivAlways
      ButtonStyle = bsChecked
      ImageIndex = 3
      UnclickAfterDoing = False
      OnClick = ShowTimeAsClick
    end
    object siShowTimeAs: TdxBarSubItem
      Caption = 'Show Time As'
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbFree'
        end
        item
          Visible = True
          ItemName = 'bbTentative'
        end
        item
          Visible = True
          ItemName = 'bbBusy'
        end
        item
          Visible = True
          ItemName = 'bbOutOfOffice'
        end>
      OnPopup = siShowTimeAsPopup
    end
    object siLabelAs: TdxBarSubItem
      Caption = 'Label As'
      Category = 0
      ScreenTip = DM.stAppointmentLabelAs
      Visible = ivAlways
      ItemLinks = <>
    end
    object lbCalendarViewAgenda: TdxBarLargeButton
      Tag = 5
      Caption = 'Agenda View'
      Category = 0
      Hint = 'Agenda View'
      ScreenTip = DM.stCalendarViewAgenda
      Visible = ivAlways
      ButtonStyle = bsChecked
      GroupIndex = 21
      OnClick = lbCalendarChangeViewClick
      LargeImageIndex = 63
      SyncImageIndex = False
      ImageIndex = 75
    end
    object lbCalendarAgendaOptions: TdxBarSubItem
      Caption = 'Agenda Options'
      Category = 0
      Visible = ivAlways
      ImageIndex = 75
      LargeImageIndex = 64
      ItemLinks = <
        item
          Visible = True
          ItemName = 'lbCalendarAgendaDayHeaders'
        end
        item
          Visible = True
          ItemName = 'lbCalendarAgendaDisplayMode'
        end
        item
          Visible = True
          ItemName = 'lbCalendarAgendaShowLocations'
        end
        item
          Visible = True
          ItemName = 'lbCalendarAgendaShowResources'
        end
        item
          Visible = True
          ItemName = 'lbCalendarAgendaShowTimeAsClock'
        end>
    end
    object lbCalendarAgendaDayHeaders: TdxBarSubItem
      Caption = 'Day Headers'
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'lbCalendarAgendaDayHeadersHorizontal'
        end
        item
          Visible = True
          ItemName = 'lbCalendarAgendaDayHeadersVertical'
        end>
    end
    object lbCalendarAgendaDisplayMode: TdxBarSubItem
      Caption = 'Display Mode'
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'lbCalendarAgendaDisplayModeAllDays'
        end
        item
          Visible = True
          ItemName = 'lbCalendarAgendaDisplayModeSelectedDays'
        end
        item
          Visible = True
          ItemName = 'lbCalendarAgendaDisplayModeSelectedNonEmptyDays'
        end>
    end
    object lbCalendarAgendaDayHeadersHorizontal: TdxBarButton
      Caption = 'Horizontal'
      Category = 0
      Hint = 'Horizontal'
      Visible = ivAlways
      ButtonStyle = bsChecked
      GroupIndex = 25
      Down = True
      OnClick = lbCalendarAgendaDayHeadersHorizontalClick
    end
    object lbCalendarAgendaDayHeadersVertical: TdxBarButton
      Tag = 1
      Caption = 'Vertical'
      Category = 0
      Hint = 'Vertical'
      Visible = ivAlways
      ButtonStyle = bsChecked
      GroupIndex = 25
      OnClick = lbCalendarAgendaDayHeadersHorizontalClick
    end
    object lbCalendarAgendaDisplayModeAllDays: TdxBarButton
      Caption = 'All Days'
      Category = 0
      Hint = 'All Days'
      Visible = ivAlways
      ButtonStyle = bsChecked
      GroupIndex = 26
      Down = True
      OnClick = lbCalendarAgendaDisplayModeAllDaysClick
    end
    object lbCalendarAgendaDisplayModeSelectedDays: TdxBarButton
      Tag = 1
      Caption = 'Selected Days Only'
      Category = 0
      Hint = 'Selected Days Only'
      Visible = ivAlways
      ButtonStyle = bsChecked
      GroupIndex = 26
      OnClick = lbCalendarAgendaDisplayModeAllDaysClick
    end
    object lbCalendarAgendaDisplayModeSelectedNonEmptyDays: TdxBarButton
      Tag = 2
      Caption = 'Selected Non-Empty Days Only'
      Category = 0
      Hint = 'Selected Non-Empty Days Only'
      Visible = ivAlways
      ButtonStyle = bsChecked
      GroupIndex = 26
      OnClick = lbCalendarAgendaDisplayModeAllDaysClick
    end
    object lbCalendarAgendaShowLocations: TdxBarButton
      Caption = 'Show Locations'
      Category = 0
      Hint = 'Show Locations'
      Visible = ivAlways
      ButtonStyle = bsChecked
      OnClick = lbCalendarAgendaShowLocationsClick
    end
    object lbCalendarAgendaShowResources: TdxBarButton
      Caption = 'Show Resources'
      Category = 0
      Hint = 'Show Resources'
      Visible = ivAlways
      ButtonStyle = bsChecked
      Down = True
      OnClick = lbCalendarAgendaShowResourcesClick
    end
    object lbCalendarAgendaShowTimeAsClock: TdxBarButton
      Caption = 'Time As Clock'
      Category = 0
      Hint = 'Time As Clock'
      Visible = ivAlways
      ButtonStyle = bsChecked
      OnClick = lbCalendarAgendaShowTimeAsClockClick
    end
    object bCalendarTimelines60Minutes: TdxBarButton
      Tag = 60
      Caption = '60 Minutes'
      Category = 1
      Hint = '60 Minutes'
      Visible = ivAlways
      ButtonStyle = bsChecked
      GroupIndex = 23
      OnClick = bCalendarTimelinesClick
    end
    object bCalendarTimelines30Minutes: TdxBarButton
      Tag = 30
      Caption = '30 Minutes'
      Category = 1
      Hint = '30 Minutes'
      Visible = ivAlways
      ButtonStyle = bsChecked
      GroupIndex = 23
      OnClick = bCalendarTimelinesClick
    end
    object bCalendarTimelines15Minutes: TdxBarButton
      Tag = 15
      Caption = '15 Minutes'
      Category = 1
      Hint = '15 Minutes'
      Visible = ivAlways
      ButtonStyle = bsChecked
      GroupIndex = 23
      OnClick = bCalendarTimelinesClick
    end
    object bCalendarTimelines10Minutes: TdxBarButton
      Tag = 10
      Caption = '10 Minutes'
      Category = 1
      Hint = '10 Minutes'
      Visible = ivAlways
      ButtonStyle = bsChecked
      GroupIndex = 23
      OnClick = bCalendarTimelinesClick
    end
    object bCalendarTimelines6Minutes: TdxBarButton
      Tag = 6
      Caption = '6 Minutes'
      Category = 1
      Hint = '6 Minutes'
      Visible = ivAlways
      ButtonStyle = bsChecked
      GroupIndex = 23
      OnClick = bCalendarTimelinesClick
    end
    object bCalendarTimelines5Minutes: TdxBarButton
      Tag = 5
      Caption = '5 Minutes'
      Category = 1
      Hint = '5 Minutes'
      Visible = ivAlways
      ButtonStyle = bsChecked
      GroupIndex = 23
      OnClick = bCalendarTimelinesClick
    end
    object lbOpenEventEditDialog: TdxBarLargeButton
      Caption = 'Open'
      Category = 2
      Hint = 'Open'
      ScreenTip = DM.stAppointmentOpen
      Visible = ivAlways
      OnClick = lbOpenEventEditDialogClick
      LargeImageIndex = 45
    end
    object lbDeleteEvent: TdxBarLargeButton
      Caption = 'Delete'
      Category = 2
      Hint = 'Delete'
      ScreenTip = DM.stAppointmentDelete
      Visible = ivAlways
      OnClick = lbDeleteEventClick
      LargeImageIndex = 1
      SyncImageIndex = False
      ImageIndex = -1
    end
    object lbRecurrence: TdxBarLargeButton
      Caption = 'Recurrence'
      Category = 2
      Hint = 'Recurrence'
      ScreenTip = DM.stAppointmentRecurrence
      Visible = ivAlways
      ButtonStyle = bsChecked
      OnClick = lbRecurrenceClick
      LargeImageIndex = 46
    end
    object bCalendarTimelinesMonth: TdxBarButton
      Tag = 3
      Caption = 'Month'
      Category = 2
      Hint = 'Month'
      Visible = ivAlways
      ButtonStyle = bsChecked
      OnClick = bCalendarTimelinesClick
    end
    object bCalendarTimelinesWeek: TdxBarButton
      Tag = 2
      Caption = 'Week'
      Category = 2
      Hint = 'Week'
      Visible = ivAlways
      ButtonStyle = bsChecked
      OnClick = bCalendarTimelinesClick
    end
    object bCalendarTimelinesDay: TdxBarButton
      Tag = 1
      Caption = 'Day'
      Category = 2
      Hint = 'Day'
      Visible = ivAlways
      ButtonStyle = bsChecked
      OnClick = bCalendarTimelinesClick
    end
    object cbReminder: TcxBarEditItem
      Caption = 'Reminder:'
      Category = 2
      Hint = 'Reminder:'
      ScreenTip = DM.stAppointmentReminder
      Visible = ivAlways
      PropertiesClassName = 'TcxComboBoxProperties'
      Properties.DropDownListStyle = lsEditFixedList
      Properties.OnChange = cbReminderChange
      InternalEditValue = 0
    end
  end
  inherited ComponentPrinter: TdxComponentPrinter
    CurrentLink = ComponentPrinterLink1
    PixelsPerInch = 96
    object ComponentPrinterLink1: TcxSchedulerReportLink
      Component = Scheduler
      PrinterPage.DMPaper = 1
      PrinterPage.Footer = 200
      PrinterPage.Header = 200
      PrinterPage.Margins.Bottom = 500
      PrinterPage.Margins.Left = 500
      PrinterPage.Margins.Right = 500
      PrinterPage.Margins.Top = 500
      PrinterPage.PageSize.X = 8500
      PrinterPage.PageSize.Y = 11000
      PrinterPage._dxMeasurementUnits_ = 0
      PrinterPage._dxLastMU_ = 1
      PixelsPerInch = 96
      BuiltInReportLink = True
    end
  end
  object ilShowTimeAs: TcxImageList
    SourceDPI = 96
    Height = 32
    Width = 32
    FormatVersion = 1
    DesignInfo = 21495952
  end
  object ilLabelAs: TcxImageList
    SourceDPI = 96
    Height = 32
    Width = 32
    FormatVersion = 1
    DesignInfo = 21496040
  end
end
