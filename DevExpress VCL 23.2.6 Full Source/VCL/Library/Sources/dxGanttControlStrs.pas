{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressGanttControl                                      }
{                                                                    }
{           Copyright (c) 2020-2024 Developer Express Inc.           }
{           ALL RIGHTS RESERVED                                      }
{                                                                    }
{   The entire contents of this file is protected by U.S. and        }
{   International Copyright Laws. Unauthorized reproduction,         }
{   reverse-engineering, and distribution of all or any portion of   }
{   the code contained in this file is strictly prohibited and may   }
{   result in severe civil and criminal penalties and will be        }
{   prosecuted to the maximum extent possible under the law.         }
{                                                                    }
{   RESTRICTIONS                                                     }
{                                                                    }
{   THIS SOURCE CODE AND ALL RESULTING INTERMEDIATE FILES            }
{   (DCU, OBJ, DLL, ETC.) ARE CONFIDENTIAL AND PROPRIETARY TRADE     }
{   SECRETS OF DEVELOPER EXPRESS INC. THE REGISTERED DEVELOPER IS    }
{   LICENSED TO DISTRIBUTE THE EXPRESSGANTTCONTROL AND ALL           }
{   ACCOMPANYING VCL CONTROLS AS PART OF AN EXECUTABLE PROGRAM ONLY. }
{                                                                    }
{   THE SOURCE CODE CONTAINED WITHIN THIS FILE AND ALL RELATED       }
{   FILES OR ANY PORTION OF ITS CONTENTS SHALL AT NO TIME BE         }
{   COPIED, TRANSFERRED, SOLD, DISTRIBUTED, OR OTHERWISE MADE        }
{   AVAILABLE TO OTHER INDIVIDUALS WITHOUT EXPRESS WRITTEN CONSENT   }
{   AND PERMISSION FROM DEVELOPER EXPRESS INC.                       }
{                                                                    }
{   CONSULT THE END USER LICENSE AGREEMENT FOR INFORMATION ON        }
{   ADDITIONAL RESTRICTIONS.                                         }
{                                                                    }
{********************************************************************}

unit dxGanttControlStrs;

{$I cxVer.inc}
{$I dxGanttControl.inc}

interface

uses
  dxCore;

const
  dxGanttControlProductName = 'ExpressGanttControl';

resourcestring
  sdxGanttControlNoDataInfoText = '<No data to display>';

  sdxGanttControlStandardCalendarName = 'Standard';
  sdxGanttControl24HoursCalendarName = '24 Hours';
  sdxGanttControlNightCalendarName = 'Night Shift';

  sdxGanttControlViewChartSheetColumnIndicatorCaption = 'Indicators';
  sdxGanttControlViewChartSheetColumnIndicatorDescription = 'Indicators that help communicate important task related information.';
  sdxGanttControlViewChartSheetColumnTaskModeCaption = 'Task Mode';
  sdxGanttControlViewChartSheetColumnTaskModeDescription = 'You can schedule a task manually or allow the control to schedule it automatically.'#13#10#13#10 +
    'Manually scheduled tasks: You should specify start/end date and duration. The control cannot modify these values but will warn you if manually entered values will generate potential issues within your project.'#13#10#13#10 +
    'Automatically scheduled tasks: The control calculates start/end date and duration based on changes within your project.';
  sdxGanttControlViewChartSheetColumnTaskNameCaption = 'Task Name';
  sdxGanttControlViewChartSheetColumnTaskNameDescription = 'A task name.';
  sdxGanttControlViewChartSheetColumnTaskDurationCaption = 'Duration';
  sdxGanttControlViewChartSheetColumnTaskDurationDescription = 'The total work time span required to complete a task.';
  sdxGanttControlViewChartSheetColumnTaskStartCaption = 'Start';
  sdxGanttControlViewChartSheetColumnTaskStartDescription = 'A task''s scheduled start date and time.';
  sdxGanttControlViewChartSheetColumnTaskFinishCaption = 'Finish';
  sdxGanttControlViewChartSheetColumnTaskFinishDescription = 'A task''s scheduled finish date and time.';
  sdxGanttControlViewChartSheetColumnTaskPredecessorsCaption = 'Predecessors';
  sdxGanttControlViewChartSheetColumnTaskPredecessorsDescription = 'Predecessor tasks ID numbers. Predecessors define whether dependent task(s) can be completed.';
  sdxGanttControlViewChartSheetColumnTaskResourceNameCaption = 'Resource Name';
  sdxGanttControlViewChartSheetColumnTaskResourceNameDescription = 'Lists resource(s) assigned to a task.';
  sdxGanttControlViewChartSheetColumnPercentCompleteCaption = '% Complete';
  sdxGanttControlViewChartSheetColumnPercentCompleteDescription = 'Task progress expressed as a percentage of task duration has been completed.';

  sdxGanttControlSheetExtendedAttributeCostColumnDescription = 'A custom field that stores cost information.';
  sdxGanttControlSheetExtendedAttributeDateColumnDescription = 'A custom field that stores date and time information.';
  sdxGanttControlSheetExtendedAttributeStartColumnDescription = 'A custom field that stores start date and time.';
  sdxGanttControlSheetExtendedAttributeFinishColumnDescription = 'A custom field that stores finish date and time.';
  sdxGanttControlSheetExtendedAttributeFlagColumnDescription = 'A custom field you can use to indicate whether is marked for further action or identification of some kind.';
  sdxGanttControlSheetExtendedAttributeDurationColumnDescription = 'A custom field that stores duration information.';
  sdxGanttControlSheetExtendedAttributeTextColumnDescription = 'A custom field that stores a text value.';
  sdxGanttControlSheetExtendedAttributeNumberColumnDescription = 'A custom field that stores a numeric value.';

  sdxGanttControlViewResourceSheetColumnIndicatorCaption = 'Indicators';
  sdxGanttControlViewResourceSheetColumnIndicatorDescription = '';
  sdxGanttControlViewResourceSheetColumnResourceNameCaption = 'Resource Name';
  sdxGanttControlViewResourceSheetColumnResourceNameDescription = 'A resource name.';
  sdxGanttControlViewResourceSheetColumnTypeCaption = 'Type';
  sdxGanttControlViewResourceSheetColumnTypeDescription = 'Specifies whether the resource is work, material, or cost related.'#13#10#13#10 +
    'Work resource - people and equipment.'#13#10'Material resource - consumable supplies.'#13#10'Cost resource - independent costs necessary to complete a task (for instance, a plane ticket).';
  sdxGanttControlViewResourceSheetColumnGroupCaption = 'Group';
  sdxGanttControlViewResourceSheetColumnGroupDescription = 'The name of the group that a resource belongs to.';
  sdxGanttControlViewResourceSheetColumnBaseCalendarCaption = 'Base Calendar';
  sdxGanttControlViewResourceSheetColumnBaseCalendarDescription = 'Specifies the base calendar used for the resource calendar. Calendars define work time for resources.';

  sdxGanttControlViewTimelineStartText = 'Start';
  sdxGanttControlViewTimelineFinishText = 'Finish';

  sdxGanttControlResourceTypeWork = 'Work';
  sdxGanttControlResourceTypeMaterial = 'Material';
  sdxGanttControlResourceTypeCost = 'Cost';

  sdxGanttControlTaskModeManuallyScheduled = 'Manually Scheduled';
  sdxGanttControlTaskModeAutoScheduled = 'Auto Scheduled';

  sdxGanttControlViewChartThirdsOfMonthsCaptionBegin = 'B';
  sdxGanttControlViewChartThirdsOfMonthsCaptionMiddle = 'M';
  sdxGanttControlViewChartThirdsOfMonthsCaptionEnd = 'E';
  sdxGanttControlViewChartFirstQuarter = '1st Quarter';
  sdxGanttControlViewChartSecondQuarter = '2nd Quarter';
  sdxGanttControlViewChartThirdQuarter = '3rd Quarter';
  sdxGanttControlViewChartFourthQuarter = '4th Quarter';
  sdxGanttControlViewChartQuarters = 'Qtr %d';
  sdxGanttControlViewChartHalfYears = 'H%d';

  sdxGanttControlTaskPredecessorLinkTypeFF = 'FF';
  sdxGanttControlTaskPredecessorLinkTypeFS = 'FS';
  sdxGanttControlTaskPredecessorLinkTypeSF = 'SF';
  sdxGanttControlTaskPredecessorLinkTypeSS = 'SS';

  sdxGanttControlDurationFormatElapsedTimePrefix = 'e';
  sdxGanttControlDurationFormatEstimatedTimePostfix = '?';
  sdxGanttControlDurationFormatMinuteExtraShort = 'm';
  sdxGanttControlDurationFormatMinute = 'minute';
  sdxGanttControlDurationFormatMinutes = 'minutes';
  sdxGanttControlDurationFormatMinuteShort = 'min';
  sdxGanttControlDurationFormatMinutesShort = 'mins';
  sdxGanttControlDurationFormatHourExtraShort = 'h';
  sdxGanttControlDurationFormatHour = 'hour';
  sdxGanttControlDurationFormatHours = 'hours';
  sdxGanttControlDurationFormatHourShort = 'hr';
  sdxGanttControlDurationFormatHoursShort = 'hrs';
  sdxGanttControlDurationFormatDayExtraShort = 'd';
  sdxGanttControlDurationFormatDay = 'day';
  sdxGanttControlDurationFormatDays = 'days';
  sdxGanttControlDurationFormatWeekExtraShort = 'w';
  sdxGanttControlDurationFormatWeek = 'week';
  sdxGanttControlDurationFormatWeeks = 'weeks';
  sdxGanttControlDurationFormatWeekShort = 'wk';
  sdxGanttControlDurationFormatWeeksShort = 'wks';
  sdxGanttControlDurationFormatMonthExtraShort = 'mo';
  sdxGanttControlDurationFormatMonth = 'month';
  sdxGanttControlDurationFormatMonths = 'months';
  sdxGanttControlDurationFormatMonthShort = 'mon';
  sdxGanttControlDurationFormatMonthsShort = 'mons';

  sdxGanttControlTaskID = '(ID %d)';
  sdxGanttControlResourceID = '(ID %d)';

  sdxGanttControlTaskConstraintTypeALAP = 'As Late As Possible';
  sdxGanttControlTaskConstraintTypeASAP = 'As Soon As Possible';
  sdxGanttControlTaskConstraintTypeFNET = 'Finish No Earlier Than';
  sdxGanttControlTaskConstraintTypeFNLT = 'Finish No Later Than';
  sdxGanttControlTaskConstraintTypeMFO = 'Must Finish On';
  sdxGanttControlTaskConstraintTypeMSO = 'Must Start On';
  sdxGanttControlTaskConstraintTypeSNET = 'Start No Earlier Than';
  sdxGanttControlTaskConstraintTypeSNLT = 'Start No Later Than';

  sdxGanttControlConfirmationDeleteSummary = '''%s'' is a summary task. If you delete it, all its subtasks will be deleted as well. Do you wish to continue?';
  sdxGanttControlConfirmationDeleteTask = 'Are you sure you want to delete the ''%s'' task?';
  sdxGanttControlConfirmationDeleteResource = 'Are you sure you want to delete the ''%s'' resource?';
  sdxGanttControlConfirmationDeleteLink = 'Are you sure you want to delete the link?';

  sdxGanttControlTaskDependencyDialogCaption = 'Task Dependency';
  sdxGanttControlTaskDependencyDialogFrom = 'From:';
  sdxGanttControlTaskDependencyDialogTo = 'To:';
  sdxGanttControlTaskDependencyDialogLinkType = '&Type:';
  sdxGanttControlTaskDependencyDialogLinkTypeFS = 'Finish-to-Start (FS)';
  sdxGanttControlTaskDependencyDialogLinkTypeSS = 'Start-to-Start (SS)';
  sdxGanttControlTaskDependencyDialogLinkTypeFF = 'Finish-to-Finish (FF)';
  sdxGanttControlTaskDependencyDialogLinkTypeSF = 'Start-to-Finish (SF)';
  sdxGanttControlTaskDependencyDialogLinkTypeNone = '(None)';
  sdxGanttControlTaskDependencyDialogLag = '&Lag:';

  sdxGanttControlTimelineTaskHintFinishCaption = 'Task Finish:';
  sdxGanttControlTimelineTaskHintCompleteCaption = '% Complete:';
  sdxGanttControlTimelineTaskHintDurationCaption = 'Duration:';
  sdxGanttControlTimelineTaskHintStartCaption = 'Task Start:';

  sdxGanttControlTaskInformationDialogCaption = 'Task Information';
  sdxGanttControlTaskInformationDialogSummaryCaption = 'Summary Task Information';
  sdxGanttControlTaskInformationDialogGeneralTabCaption = 'General';
  sdxGanttControlTaskInformationDialogAdvancedTabCaption = 'Advanced';
  sdxGanttControlTaskInformationDialogName = '&Name:';
  sdxGanttControlTaskInformationDialogDuration = '&Duration:';
  sdxGanttControlTaskInformationDialogEstimated = '&Estimated';
  sdxGanttControlTaskInformationDialogPercentComplete = '&Percent Complete:';
  sdxGanttControlTaskInformationDialogScheduleMode = 'Schedule &Mode:';
  sdxGanttControlTaskInformationDialogManuallySchedule = 'Manually Scheduled';
  sdxGanttControlTaskInformationDialogAutoSchedule = 'Auto Scheduled';
  sdxGanttControlTaskInformationDialogDates = 'Dates';
  sdxGanttControlTaskInformationDialogDateStart = '&Start:';
  sdxGanttControlTaskInformationDialogDateFinish = '&Finish:';
  sdxGanttControlTaskInformationDialogDisplayOnTimeline = 'Display on &Timeline';
  sdxGanttControlTaskInformationDialogConstrainTask = 'Constrain Task';
  sdxGanttControlTaskInformationDialogConstraintType = 'Constraint Ty&pe:';
  sdxGanttControlTaskInformationDialogConstraintDate = 'Constraint Da&te:';
  sdxGanttControlTaskInformationDialogCalendar = 'C&alendar';

  sdxGanttControlRecurringTaskInformationDialogCaption = 'Recurring Task Information';
  sdxGanttControlRecurringTaskInformationDialogTaskName = '&Task Name:';
  sdxGanttControlRecurringTaskInformationDialogTaskDuration = 'Durat&ion:';
  sdxGanttControlRecurringTaskInformationDialogRecurrencePattern = 'Recurrence Pattern';
  sdxGanttControlRecurringTaskInformationDialogDaily = 'Dai&ly';
  sdxGanttControlRecurringTaskInformationDialogWeekly = '&Weekly';
  sdxGanttControlRecurringTaskInformationDialogMonthly = 'Mont&hly';
  sdxGanttControlRecurringTaskInformationDialogYearly = '&Yearly';
  sdxGanttControlRecurringTaskInformationDialogDailyEvery = 'Every';
  sdxGanttControlRecurringTaskInformationDialogDailyEveryDays = 'Day(s)';
  sdxGanttControlRecurringTaskInformationDialogDailyEveryWorkdays = 'Workday(s)';
  sdxGanttControlRecurringTaskInformationDialogWeeklyRecurEvery = 'Recur Every';
  sdxGanttControlRecurringTaskInformationDialogWeeklyRecurWeeksOn = 'Week(s) on:';
  sdxGanttControlRecurringTaskInformationDialogFirst = 'First';
  sdxGanttControlRecurringTaskInformationDialogSecond = 'Second';
  sdxGanttControlRecurringTaskInformationDialogThird = 'Third';
  sdxGanttControlRecurringTaskInformationDialogFourth = 'Fourth';
  sdxGanttControlRecurringTaskInformationDialogLast = 'Last';
  sdxGanttControlRecurringTaskInformationDialogDay = 'Day';
  sdxGanttControlRecurringTaskInformationDialogOfEvery = 'of Every';
  sdxGanttControlRecurringTaskInformationDialogMonths = 'Month(s)';
  sdxGanttControlRecurringTaskInformationDialogThe = 'Th&e';
  sdxGanttControlRecurringTaskInformationDialogOn = '&On';
  sdxGanttControlRecurringTaskInformationDialogOf = 'of';
  sdxGanttControlRecurringTaskInformationDialogRange = 'Range of Recurrence';
  sdxGanttControlRecurringTaskInformationDialogRangeStart = '&Start:';
  sdxGanttControlRecurringTaskInformationDialogRangeEndAfter = 'End after:';
  sdxGanttControlRecurringTaskInformationDialogRangeEndAfterOccurrences = 'Occurrence(s)';
  sdxGanttControlRecurringTaskInformationDialogRangeEndBy = 'End &by:';
  sdxGanttControlRecurringTaskInformationDialogSchedulingCalendar = 'Calendar for Scheduling This Task';
  sdxGanttControlRecurringTaskInformationDialogSchedulingCalendarName = 'Cale&ndar:';

  sdxGanttControlChooseDetailsDialogCaption = 'Choose Details';
  sdxGanttControlChooseDetailsDialogDescription = 'Select details to display for items within this sheet.';
  sdxGanttControlChooseDetailsDialogDetails = 'Details:';
  sdxGanttControlChooseDetailsDialogColumnWidthDescription = 'Column width (in pixels):';

  sdxGanttControlDialogDelete = '&Delete';
  sdxGanttControlDialogOk = 'OK';
  sdxGanttControlDialogCancel = 'Cancel';
  sdxGanttControlCaptionNone = 'None';

  sdxGanttControlExceptionImageNotFound = 'Image not found';
  sdxGanttControlExceptionInvalidDuration = '''%s'' is invalid duration';
  sdxGanttControlExceptionInvalidDurationFormat = 'Invalid duration format';
  sdxGanttControlExceptionInvalidFileFormat = 'Invalid file format';
  sdxGanttControlExceptionUnsupportedFileFormat = 'The file format is not supported';
  sdxGanttControlExceptionTasksAreAlreadyLinked = 'These tasks are already linked to each other.';
  sdxGanttControlExceptionTasksAreAlreadyLinkedThroughAnotherTaskChain = 'You cannot link these tasks because they are already linked through another task chain.';
  sdxGanttControlExceptionTasksCannotBeLinkedTwice = 'You cannot link a predecessor task to the same successor task twice.';
  sdxGanttControlExceptionOutlineChangeWouldCreateCircularRelationship = 'This outline change will generate a circular relationship. To eliminate illogical relationships between individual tasks, check dependencies for tasks from which you are indenting, and try again.';
  sdxGanttControlExceptionCannotLinkSummaryTaskToItsSubtask = 'You cannot link a summary to its subtask. Outdent the subtask to the summary’s outline level and try again.';
  sdxGanttControlExceptionPositionChangeWouldCreateCircularRelationship = 'This position change will generate a circular relationship. To eliminate illogical relationships between individuals tasks, review associated task dependencies and try again.';

  sdxGanttControlMessageInvalidDurationFormat = 'Invalid duration format. Specify a duration using standard format notation (for instance, 4 hours or 2 d).';
  sdxGanttControlMessageInvalidLagValue = 'Invalid lag time.'#13#10 +
    'To resolve the issue, try the following:'#13#10 +
    '- Fixed lag time: Enter a number and duration format in the Lag field (for instance, 5d or 5ed for elapsed time).'#13#10 +
    '- Enter a percentage value (50% or 50e% for elapsed time percentage) to express lag time as a percentage of a predecessor’s task duration.'#13#10 +
    '- Insert "-" before lag value to specify a lead time.';
  sdxGanttControlMessageInvalidMeasurementUnit = 'The "%s" is invalid measurement unit.';
  sdxGanttControlMessageInvalidPercentageCompletedValue = 'Percentage completed (% Complete) values must be between 0 and 100.';
  sdxGanttControlMessageInvalidSummaryTaskLink = 'The predecessors of a task or of an inserted project summary task ' +
    'must have a finish-to-start or start-to-start dependency.'#13#10'Select the tasks you want to link in a ' +
    'finish-to-start or start-to-start dependency, and then click Link Tasks ' +
    'button on the Task tab. Selected summary tasks are also linked';
  sdxGanttControlMessageInvalidPredecessorInformation = 'Invalid predecessor information.'#13#10 +
    'To resolve this issue, try the following:.'#13#10 +
    '- Only enter positive integers for relationships between tasks in the same project..'#13#10 +
    '- To include a dependency type and a lead time, specify the predecessor ID, dependency type, "+"  and lead or lag time (for example, 2FS+3d).';
  sdxGanttControlMessageInvalidWeekSchedule = 'To schedule a recurring task, you must specify one or more days for the recurrence pattern.'#13#10#13#10 +
    'Check the appropriate checkbox(es) to the right of the Weekly recurrence interval to specify the day(s) used for this recurrence pattern.';
  sdxGanttControlMessageTwiceResourcesInformation = 'You cannot assign the same resource to a task twice. To associate the same resource with different tasks, use resource contouring.';

  sdxGanttControlTaskCompletedHint = 'This task was completed on'#13#10'%s.';
  sdxGanttControlTaskHasConstraintHint = 'This task has a ''%s'' constraint on %s.';
  sdxGanttControlRecurringTaskHint = 'This task occurs %d times between %s and %s.';


  sdxGanttControlCommandAddTaskToTimelineCaption = 'Add to Timeline';
  sdxGanttControlCommandScrollToTaskCaption = 'Scroll to Task';
  sdxGanttControlCommandInsertTaskCaption = 'Insert Task';
  sdxGanttControlCommandInsertRecurringTaskCaption = 'Insert Recurring Task...';
  sdxGanttControlCommandDeleteTaskCaption = 'Delete Task';
  sdxGanttControlCommandDeleteTasksCaption = 'Delete Tasks';
  sdxGanttControlCommandInformationCaption = 'Information...';
  sdxGanttControlCommandGoToTaskCaption = 'Go to Task';
  sdxGanttControlCommandRemoveFromTimelineCaption = 'Remove from Timeline';
  sdxGanttControlCommandRenameColumnCaption = 'Rename Column';
  sdxGanttControlCommandWordWrapCaption = 'Word Wrap';
  sdxGanttControlCommandInsertColumnCaption = 'Insert Column';
  sdxGanttControlCommandShowChooseColumnDetailsDialogCaption = 'More...';
  sdxGanttControlCommandHideColumnCaption = 'Hide Column';
  sdxGanttControlCommandBestFitColumnCaption = 'Best Fit';
  sdxGanttControlCommandBestFitAllColumnsCaption = 'Best Fit (all columns)';

implementation

const
  dxThisUnitName = 'dxGanttControlStrs';

procedure AddGanttControlResourceStringNames(AProduct: TdxProductResourceStrings);
begin
  AProduct.Add('sdxGanttControlStandardCalendarName', @sdxGanttControlStandardCalendarName);
  AProduct.Add('sdxGanttControl24HoursCalendarName', @sdxGanttControl24HoursCalendarName);
  AProduct.Add('sdxGanttControlNightCalendarName', @sdxGanttControlNightCalendarName);

  AProduct.Add('sdxGanttControlViewChartSheetColumnIndicatorCaption', @sdxGanttControlViewChartSheetColumnIndicatorCaption);
  AProduct.Add('sdxGanttControlViewChartSheetColumnIndicatorDescription', @sdxGanttControlViewChartSheetColumnIndicatorDescription);
  AProduct.Add('sdxGanttControlViewChartSheetColumnTaskModeCaption', @sdxGanttControlViewChartSheetColumnTaskModeCaption);
  AProduct.Add('sdxGanttControlViewChartSheetColumnTaskModeDescription', @sdxGanttControlViewChartSheetColumnTaskModeDescription);
  AProduct.Add('sdxGanttControlViewChartSheetColumnTaskNameCaption', @sdxGanttControlViewChartSheetColumnTaskNameCaption);
  AProduct.Add('sdxGanttControlViewChartSheetColumnTaskNameDescription', @sdxGanttControlViewChartSheetColumnTaskNameDescription);
  AProduct.Add('sdxGanttControlViewChartSheetColumnTaskDurationCaption', @sdxGanttControlViewChartSheetColumnTaskDurationCaption);
  AProduct.Add('sdxGanttControlViewChartSheetColumnTaskDurationDescription', @sdxGanttControlViewChartSheetColumnTaskDurationDescription);
  AProduct.Add('sdxGanttControlViewChartSheetColumnTaskStartCaption', @sdxGanttControlViewChartSheetColumnTaskStartCaption);
  AProduct.Add('sdxGanttControlViewChartSheetColumnTaskStartDescription', @sdxGanttControlViewChartSheetColumnTaskStartDescription);
  AProduct.Add('sdxGanttControlViewChartSheetColumnTaskFinishCaption', @sdxGanttControlViewChartSheetColumnTaskFinishCaption);
  AProduct.Add('sdxGanttControlViewChartSheetColumnTaskFinishDescription', @sdxGanttControlViewChartSheetColumnTaskFinishDescription);
  AProduct.Add('sdxGanttControlViewChartSheetColumnTaskPredecessorsCaption', @sdxGanttControlViewChartSheetColumnTaskPredecessorsCaption);
  AProduct.Add('sdxGanttControlViewChartSheetColumnTaskPredecessorsDescription', @sdxGanttControlViewChartSheetColumnTaskPredecessorsDescription);
  AProduct.Add('sdxGanttControlViewChartSheetColumnTaskResourceNameCaption', @sdxGanttControlViewChartSheetColumnTaskResourceNameCaption);
  AProduct.Add('sdxGanttControlViewChartSheetColumnTaskResourceNameDescription', @sdxGanttControlViewChartSheetColumnTaskResourceNameDescription);
  AProduct.Add('sdxGanttControlViewChartSheetColumnPercentCompleteCaption', @sdxGanttControlViewChartSheetColumnPercentCompleteCaption);
  AProduct.Add('sdxGanttControlViewChartSheetColumnPercentCompleteDescription', @sdxGanttControlViewChartSheetColumnPercentCompleteDescription);

  AProduct.Add('sdxGanttControlViewResourceSheetColumnIndicatorCaption', @sdxGanttControlViewResourceSheetColumnIndicatorCaption);
  AProduct.Add('sdxGanttControlViewResourceSheetColumnIndicatorDescription', @sdxGanttControlViewResourceSheetColumnIndicatorDescription);
  AProduct.Add('sdxGanttControlViewResourceSheetColumnResourceNameCaption', @sdxGanttControlViewResourceSheetColumnResourceNameCaption);
  AProduct.Add('sdxGanttControlViewResourceSheetColumnResourceNameDescription', @sdxGanttControlViewResourceSheetColumnResourceNameDescription);
  AProduct.Add('sdxGanttControlViewResourceSheetColumnTypeCaption', @sdxGanttControlViewResourceSheetColumnTypeCaption);
  AProduct.Add('sdxGanttControlViewResourceSheetColumnTypeDescription', @sdxGanttControlViewResourceSheetColumnTypeDescription);
  AProduct.Add('sdxGanttControlViewResourceSheetColumnGroupCaption', @sdxGanttControlViewResourceSheetColumnGroupCaption);
  AProduct.Add('sdxGanttControlViewResourceSheetColumnGroupDescription', @sdxGanttControlViewResourceSheetColumnGroupDescription);
  AProduct.Add('sdxGanttControlViewResourceSheetColumnBaseCalendarCaption', @sdxGanttControlViewResourceSheetColumnBaseCalendarCaption);
  AProduct.Add('sdxGanttControlViewResourceSheetColumnBaseCalendarDescription', @sdxGanttControlViewResourceSheetColumnBaseCalendarDescription);

  AProduct.Add('sdxGanttControlViewTimelineStartText', @sdxGanttControlViewTimelineStartText);
  AProduct.Add('sdxGanttControlViewTimelineFinishText', @sdxGanttControlViewTimelineFinishText);

  AProduct.Add('sdxGanttControlResourceTypeWork', @sdxGanttControlResourceTypeWork);
  AProduct.Add('sdxGanttControlResourceTypeMaterial', @sdxGanttControlResourceTypeMaterial);
  AProduct.Add('sdxGanttControlResourceTypeCost', @sdxGanttControlResourceTypeCost);

  AProduct.Add('sdxGanttControlTaskModeManuallyScheduled', @sdxGanttControlTaskModeManuallyScheduled);
  AProduct.Add('sdxGanttControlTaskModeAutoScheduled', @sdxGanttControlTaskModeAutoScheduled);

  AProduct.Add('sdxGanttControlViewChartThirdsOfMonthsCaptionBegin', @sdxGanttControlViewChartThirdsOfMonthsCaptionBegin);
  AProduct.Add('sdxGanttControlViewChartThirdsOfMonthsCaptionMiddle', @sdxGanttControlViewChartThirdsOfMonthsCaptionMiddle);
  AProduct.Add('sdxGanttControlViewChartThirdsOfMonthsCaptionEnd', @sdxGanttControlViewChartThirdsOfMonthsCaptionEnd);
  AProduct.Add('sdxGanttControlViewChartFirstQuarter', @sdxGanttControlViewChartFirstQuarter);
  AProduct.Add('sdxGanttControlViewChartSecondQuarter', @sdxGanttControlViewChartSecondQuarter);
  AProduct.Add('sdxGanttControlViewChartThirdQuarter', @sdxGanttControlViewChartThirdQuarter);
  AProduct.Add('sdxGanttControlViewChartFourthQuarter', @sdxGanttControlViewChartFourthQuarter);
  AProduct.Add('sdxGanttControlViewChartQuarters', @sdxGanttControlViewChartQuarters);
  AProduct.Add('sdxGanttControlViewChartHalfYears', @sdxGanttControlViewChartHalfYears);

  AProduct.Add('sdxGanttControlTaskPredecessorLinkTypeFF', @sdxGanttControlTaskPredecessorLinkTypeFF);
  AProduct.Add('sdxGanttControlTaskPredecessorLinkTypeFS', @sdxGanttControlTaskPredecessorLinkTypeFS);
  AProduct.Add('sdxGanttControlTaskPredecessorLinkTypeSF', @sdxGanttControlTaskPredecessorLinkTypeSF);
  AProduct.Add('sdxGanttControlTaskPredecessorLinkTypeSS', @sdxGanttControlTaskPredecessorLinkTypeSS);

  AProduct.Add('sdxGanttControlDurationFormatElapsedTimePrefix', @sdxGanttControlDurationFormatElapsedTimePrefix);
  AProduct.Add('sdxGanttControlDurationFormatEstimatedTimePostfix', @sdxGanttControlDurationFormatEstimatedTimePostfix);
  AProduct.Add('sdxGanttControlDurationFormatMinuteExtraShort', @sdxGanttControlDurationFormatMinuteExtraShort);
  AProduct.Add('sdxGanttControlDurationFormatMinute', @sdxGanttControlDurationFormatMinute);
  AProduct.Add('sdxGanttControlDurationFormatMinutes', @sdxGanttControlDurationFormatMinutes);
  AProduct.Add('sdxGanttControlDurationFormatMinuteShort', @sdxGanttControlDurationFormatMinuteShort);
  AProduct.Add('sdxGanttControlDurationFormatMinutesShort', @sdxGanttControlDurationFormatMinutesShort);
  AProduct.Add('sdxGanttControlDurationFormatHourExtraShort', @sdxGanttControlDurationFormatHourExtraShort);
  AProduct.Add('sdxGanttControlDurationFormatHour', @sdxGanttControlDurationFormatHour);
  AProduct.Add('sdxGanttControlDurationFormatHours', @sdxGanttControlDurationFormatHours);
  AProduct.Add('sdxGanttControlDurationFormatHourShort', @sdxGanttControlDurationFormatHourShort);
  AProduct.Add('sdxGanttControlDurationFormatHoursShort', @sdxGanttControlDurationFormatHoursShort);
  AProduct.Add('sdxGanttControlDurationFormatDayExtraShort', @sdxGanttControlDurationFormatDayExtraShort);
  AProduct.Add('sdxGanttControlDurationFormatDay', @sdxGanttControlDurationFormatDay);
  AProduct.Add('sdxGanttControlDurationFormatDays', @sdxGanttControlDurationFormatDays);
  AProduct.Add('sdxGanttControlDurationFormatWeekExtraShort', @sdxGanttControlDurationFormatWeekExtraShort);
  AProduct.Add('sdxGanttControlDurationFormatWeek', @sdxGanttControlDurationFormatWeek);
  AProduct.Add('sdxGanttControlDurationFormatWeeks', @sdxGanttControlDurationFormatWeeks);
  AProduct.Add('sdxGanttControlDurationFormatWeekShort', @sdxGanttControlDurationFormatWeekShort);
  AProduct.Add('sdxGanttControlDurationFormatWeeksShort', @sdxGanttControlDurationFormatWeeksShort);
  AProduct.Add('sdxGanttControlDurationFormatMonthExtraShort', @sdxGanttControlDurationFormatMonthExtraShort);
  AProduct.Add('sdxGanttControlDurationFormatMonth', @sdxGanttControlDurationFormatMonth);
  AProduct.Add('sdxGanttControlDurationFormatMonths', @sdxGanttControlDurationFormatMonths);
  AProduct.Add('sdxGanttControlDurationFormatMonthShort', @sdxGanttControlDurationFormatMonthShort);
  AProduct.Add('sdxGanttControlDurationFormatMonthsShort', @sdxGanttControlDurationFormatMonthsShort);

  AProduct.Add('sdxGanttControlTaskID', @sdxGanttControlTaskID);
  AProduct.Add('sdxGanttControlResourceID', @sdxGanttControlResourceID);

  AProduct.Add('sdxGanttControlTaskConstraintTypeALAP', @sdxGanttControlTaskConstraintTypeALAP);
  AProduct.Add('sdxGanttControlTaskConstraintTypeASAP', @sdxGanttControlTaskConstraintTypeASAP);
  AProduct.Add('sdxGanttControlTaskConstraintTypeFNET', @sdxGanttControlTaskConstraintTypeFNET);
  AProduct.Add('sdxGanttControlTaskConstraintTypeFNLT', @sdxGanttControlTaskConstraintTypeFNLT);
  AProduct.Add('sdxGanttControlTaskConstraintTypeMFO', @sdxGanttControlTaskConstraintTypeMFO);
  AProduct.Add('sdxGanttControlTaskConstraintTypeMSO', @sdxGanttControlTaskConstraintTypeMSO);
  AProduct.Add('sdxGanttControlTaskConstraintTypeSNET', @sdxGanttControlTaskConstraintTypeSNET);
  AProduct.Add('sdxGanttControlTaskConstraintTypeSNLT', @sdxGanttControlTaskConstraintTypeSNLT);

  AProduct.Add('sdxGanttControlConfirmationDeleteSummary', @sdxGanttControlConfirmationDeleteSummary);
  AProduct.Add('sdxGanttControlConfirmationDeleteTask', @sdxGanttControlConfirmationDeleteTask);
  AProduct.Add('sdxGanttControlConfirmationDeleteResource', @sdxGanttControlConfirmationDeleteResource);
  AProduct.Add('sdxGanttControlConfirmationDeleteLink', @sdxGanttControlConfirmationDeleteLink);

  AProduct.Add('sdxGanttControlTaskDependencyDialogCaption', @sdxGanttControlTaskDependencyDialogCaption);
  AProduct.Add('sdxGanttControlTaskDependencyDialogFrom', @sdxGanttControlTaskDependencyDialogFrom);
  AProduct.Add('sdxGanttControlTaskDependencyDialogTo', @sdxGanttControlTaskDependencyDialogTo);
  AProduct.Add('sdxGanttControlTaskDependencyDialogLinkType', @sdxGanttControlTaskDependencyDialogLinkType);
  AProduct.Add('sdxGanttControlTaskDependencyDialogLinkTypeFS', @sdxGanttControlTaskDependencyDialogLinkTypeFS);
  AProduct.Add('sdxGanttControlTaskDependencyDialogLinkTypeSS', @sdxGanttControlTaskDependencyDialogLinkTypeSS);
  AProduct.Add('sdxGanttControlTaskDependencyDialogLinkTypeFF', @sdxGanttControlTaskDependencyDialogLinkTypeFF);
  AProduct.Add('sdxGanttControlTaskDependencyDialogLinkTypeSF', @sdxGanttControlTaskDependencyDialogLinkTypeSF);
  AProduct.Add('sdxGanttControlTaskDependencyDialogLinkTypeNone', @sdxGanttControlTaskDependencyDialogLinkTypeNone);
  AProduct.Add('sdxGanttControlTaskDependencyDialogLag', @sdxGanttControlTaskDependencyDialogLag);

  AProduct.Add('sdxGanttControlTimelineTaskHintFinishCaption', @sdxGanttControlTimelineTaskHintFinishCaption);
  AProduct.Add('sdxGanttControlTimelineTaskHintCompleteCaption', @sdxGanttControlTimelineTaskHintCompleteCaption);
  AProduct.Add('sdxGanttControlTimelineTaskHintDurationCaption', @sdxGanttControlTimelineTaskHintDurationCaption);
  AProduct.Add('sdxGanttControlTimelineTaskHintStartCaption', @sdxGanttControlTimelineTaskHintStartCaption);

  AProduct.Add('sdxGanttControlTaskInformationDialogCaption', @sdxGanttControlTaskInformationDialogCaption);
  AProduct.Add('sdxGanttControlTaskInformationDialogSummaryCaption', @sdxGanttControlTaskInformationDialogSummaryCaption);
  AProduct.Add('sdxGanttControlTaskInformationDialogGeneralTabCaption', @sdxGanttControlTaskInformationDialogGeneralTabCaption);
  AProduct.Add('sdxGanttControlTaskInformationDialogAdvancedTabCaption', @sdxGanttControlTaskInformationDialogAdvancedTabCaption);
  AProduct.Add('sdxGanttControlTaskInformationDialogName', @sdxGanttControlTaskInformationDialogName);
  AProduct.Add('sdxGanttControlTaskInformationDialogDuration', @sdxGanttControlTaskInformationDialogDuration);
  AProduct.Add('sdxGanttControlTaskInformationDialogEstimated', @sdxGanttControlTaskInformationDialogEstimated);
  AProduct.Add('sdxGanttControlTaskInformationDialogPercentComplete', @sdxGanttControlTaskInformationDialogPercentComplete);
  AProduct.Add('sdxGanttControlTaskInformationDialogScheduleMode', @sdxGanttControlTaskInformationDialogScheduleMode);
  AProduct.Add('sdxGanttControlTaskInformationDialogManuallySchedule', @sdxGanttControlTaskInformationDialogManuallySchedule);
  AProduct.Add('sdxGanttControlTaskInformationDialogAutoSchedule', @sdxGanttControlTaskInformationDialogAutoSchedule);
  AProduct.Add('sdxGanttControlTaskInformationDialogDates', @sdxGanttControlTaskInformationDialogDates);
  AProduct.Add('sdxGanttControlTaskInformationDialogDateStart', @sdxGanttControlTaskInformationDialogDateStart);
  AProduct.Add('sdxGanttControlTaskInformationDialogDateFinish', @sdxGanttControlTaskInformationDialogDateFinish);
  AProduct.Add('sdxGanttControlTaskInformationDialogDisplayOnTimeline', @sdxGanttControlTaskInformationDialogDisplayOnTimeline);
  AProduct.Add('sdxGanttControlTaskInformationDialogConstrainTask', @sdxGanttControlTaskInformationDialogConstrainTask);
  AProduct.Add('sdxGanttControlTaskInformationDialogConstraintType', @sdxGanttControlTaskInformationDialogConstraintType);
  AProduct.Add('sdxGanttControlTaskInformationDialogConstraintDate', @sdxGanttControlTaskInformationDialogConstraintDate);
  AProduct.Add('sdxGanttControlTaskInformationDialogCalendar', @sdxGanttControlTaskInformationDialogCalendar);

  AProduct.Add('sdxGanttControlRecurringTaskInformationDialogCaption', @sdxGanttControlRecurringTaskInformationDialogCaption);
  AProduct.Add('sdxGanttControlRecurringTaskInformationDialogTaskName', @sdxGanttControlRecurringTaskInformationDialogTaskName);
  AProduct.Add('sdxGanttControlRecurringTaskInformationDialogTaskDuration', @sdxGanttControlRecurringTaskInformationDialogTaskDuration);
  AProduct.Add('sdxGanttControlRecurringTaskInformationDialogRecurrencePattern', @sdxGanttControlRecurringTaskInformationDialogRecurrencePattern);
  AProduct.Add('sdxGanttControlRecurringTaskInformationDialogDaily', @sdxGanttControlRecurringTaskInformationDialogDaily);
  AProduct.Add('sdxGanttControlRecurringTaskInformationDialogWeekly', @sdxGanttControlRecurringTaskInformationDialogWeekly);
  AProduct.Add('sdxGanttControlRecurringTaskInformationDialogMonthly', @sdxGanttControlRecurringTaskInformationDialogMonthly);
  AProduct.Add('sdxGanttControlRecurringTaskInformationDialogYearly', @sdxGanttControlRecurringTaskInformationDialogYearly);
  AProduct.Add('sdxGanttControlRecurringTaskInformationDialogDailyEvery', @sdxGanttControlRecurringTaskInformationDialogDailyEvery);
  AProduct.Add('sdxGanttControlRecurringTaskInformationDialogDailyEveryDays', @sdxGanttControlRecurringTaskInformationDialogDailyEveryDays);
  AProduct.Add('sdxGanttControlRecurringTaskInformationDialogWeeklyRecurEvery', @sdxGanttControlRecurringTaskInformationDialogWeeklyRecurEvery);
  AProduct.Add('sdxGanttControlRecurringTaskInformationDialogWeeklyRecurWeeksOn', @sdxGanttControlRecurringTaskInformationDialogWeeklyRecurWeeksOn);
  AProduct.Add('sdxGanttControlRecurringTaskInformationDialogFirst', @sdxGanttControlRecurringTaskInformationDialogFirst);
  AProduct.Add('sdxGanttControlRecurringTaskInformationDialogSecond', @sdxGanttControlRecurringTaskInformationDialogSecond);
  AProduct.Add('sdxGanttControlRecurringTaskInformationDialogThird', @sdxGanttControlRecurringTaskInformationDialogThird);
  AProduct.Add('sdxGanttControlRecurringTaskInformationDialogFourth', @sdxGanttControlRecurringTaskInformationDialogFourth);
  AProduct.Add('sdxGanttControlRecurringTaskInformationDialogLast', @sdxGanttControlRecurringTaskInformationDialogLast);
  AProduct.Add('sdxGanttControlRecurringTaskInformationDialogDay', @sdxGanttControlRecurringTaskInformationDialogDay);
  AProduct.Add('sdxGanttControlRecurringTaskInformationDialogOfEvery', @sdxGanttControlRecurringTaskInformationDialogOfEvery);
  AProduct.Add('sdxGanttControlRecurringTaskInformationDialogMonths', @sdxGanttControlRecurringTaskInformationDialogMonths);
  AProduct.Add('sdxGanttControlRecurringTaskInformationDialogOn', @sdxGanttControlRecurringTaskInformationDialogOn);
  AProduct.Add('sdxGanttControlRecurringTaskInformationDialogRange', @sdxGanttControlRecurringTaskInformationDialogRange);
  AProduct.Add('sdxGanttControlRecurringTaskInformationDialogRangeStart', @sdxGanttControlRecurringTaskInformationDialogRangeStart);
  AProduct.Add('sdxGanttControlRecurringTaskInformationDialogRangeEndAfter', @sdxGanttControlRecurringTaskInformationDialogRangeEndAfter);
  AProduct.Add('sdxGanttControlRecurringTaskInformationDialogRangeEndAfterOccurrences', @sdxGanttControlRecurringTaskInformationDialogRangeEndAfterOccurrences);
  AProduct.Add('sdxGanttControlRecurringTaskInformationDialogRangeEndBy', @sdxGanttControlRecurringTaskInformationDialogRangeEndBy);
  AProduct.Add('sdxGanttControlRecurringTaskInformationDialogSchedulingCalendar', @sdxGanttControlRecurringTaskInformationDialogSchedulingCalendar);
  AProduct.Add('sdxGanttControlRecurringTaskInformationDialogSchedulingCalendarName', @sdxGanttControlRecurringTaskInformationDialogSchedulingCalendarName);

  AProduct.Add('sdxGanttControlDialogDelete', @sdxGanttControlDialogDelete);
  AProduct.Add('sdxGanttControlDialogOk', @sdxGanttControlDialogOk);
  AProduct.Add('sdxGanttControlDialogCancel', @sdxGanttControlDialogCancel);

  AProduct.Add('sdxGanttControlCaptionNone', @sdxGanttControlCaptionNone);

  AProduct.Add('sdxGanttControlExceptionImageNotFound', @sdxGanttControlExceptionImageNotFound);
  AProduct.Add('sdxGanttControlExceptionInvalidDuration', @sdxGanttControlExceptionInvalidDuration);
  AProduct.Add('sdxGanttControlExceptionInvalidDurationFormat', @sdxGanttControlExceptionInvalidDurationFormat);
  AProduct.Add('sdxGanttControlExceptionInvalidFileFormat', @sdxGanttControlExceptionInvalidFileFormat);
  AProduct.Add('sdxGanttControlExceptionUnsupportedFileFormat', @sdxGanttControlExceptionUnsupportedFileFormat);
  AProduct.Add('sdxGanttControlExceptionTasksAreAlreadyLinked', @sdxGanttControlExceptionTasksAreAlreadyLinked);
  AProduct.Add('sdxGanttControlExceptionTasksAreAlreadyLinkedThroughAnotherTaskChain', @sdxGanttControlExceptionTasksAreAlreadyLinkedThroughAnotherTaskChain);
  AProduct.Add('sdxGanttControlExceptionTasksCannotBeLinkedTwice', @sdxGanttControlExceptionTasksCannotBeLinkedTwice);
  AProduct.Add('sdxGanttControlExceptionOutlineChangeWouldCreateCircularRelationship', @sdxGanttControlExceptionOutlineChangeWouldCreateCircularRelationship);
  AProduct.Add('sdxGanttControlExceptionCannotLinkSummaryTaskToItsSubtask', @sdxGanttControlExceptionCannotLinkSummaryTaskToItsSubtask);
  AProduct.Add('sdxGanttControlExceptionPositionChangeWouldCreateCircularRelationship', @sdxGanttControlExceptionPositionChangeWouldCreateCircularRelationship);

  AProduct.Add('sdxGanttControlMessageInvalidDurationFormat', @sdxGanttControlMessageInvalidDurationFormat);
  AProduct.Add('sdxGanttControlMessageInvalidLagValue', @sdxGanttControlMessageInvalidLagValue);
  AProduct.Add('sdxGanttControlMessageInvalidMeasurementUnit', @sdxGanttControlMessageInvalidMeasurementUnit);
  AProduct.Add('sdxGanttControlMessageInvalidPercentageCompletedValue', @sdxGanttControlMessageInvalidPercentageCompletedValue);
  AProduct.Add('sdxGanttControlMessageInvalidSummaryTaskLink', @sdxGanttControlMessageInvalidSummaryTaskLink);
  AProduct.Add('sdxGanttControlMessageInvalidPredecessorInformation', @sdxGanttControlMessageInvalidPredecessorInformation);
  AProduct.Add('sdxGanttControlMessageInvalidWeekSchedule', @sdxGanttControlMessageInvalidWeekSchedule);
  AProduct.Add('sdxGanttControlMessageTwiceResourcesInformation', @sdxGanttControlMessageTwiceResourcesInformation);

  AProduct.Add('sdxGanttControlTaskCompletedHint', @sdxGanttControlTaskCompletedHint);
  AProduct.Add('sdxGanttControlTaskHasConstraintHint', @sdxGanttControlTaskHasConstraintHint);
  AProduct.Add('sdxGanttControlRecurringTaskHint', @sdxGanttControlRecurringTaskHint);

  AProduct.Add('sdxGanttControlCommandAddTaskToTimelineCaption', @sdxGanttControlCommandAddTaskToTimelineCaption);
  AProduct.Add('sdxGanttControlCommandScrollToTaskCaption', @sdxGanttControlCommandScrollToTaskCaption);
  AProduct.Add('sdxGanttControlCommandInsertTaskCaption', @sdxGanttControlCommandInsertTaskCaption);
  AProduct.Add('sdxGanttControlCommandInsertRecurringTaskCaption', @sdxGanttControlCommandInsertRecurringTaskCaption);
  AProduct.Add('sdxGanttControlCommandDeleteTaskCaption', @sdxGanttControlCommandDeleteTaskCaption);
  AProduct.Add('sdxGanttControlCommandDeleteTasksCaption', @sdxGanttControlCommandDeleteTasksCaption);
  AProduct.Add('sdxGanttControlCommandInformationCaption', @sdxGanttControlCommandInformationCaption);
  AProduct.Add('sdxGanttControlCommandGoToTaskCaption', @sdxGanttControlCommandGoToTaskCaption);
  AProduct.Add('sdxGanttControlCommandRemoveFromTimelineCaption', @sdxGanttControlCommandRemoveFromTimelineCaption);

  AProduct.Add('sdxGanttControlSheetExtendedAttributeCostColumnDescription', @sdxGanttControlSheetExtendedAttributeCostColumnDescription);
  AProduct.Add('sdxGanttControlSheetExtendedAttributeDateColumnDescription', @sdxGanttControlSheetExtendedAttributeDateColumnDescription);
  AProduct.Add('sdxGanttControlSheetExtendedAttributeStartColumnDescription', @sdxGanttControlSheetExtendedAttributeStartColumnDescription);
  AProduct.Add('sdxGanttControlSheetExtendedAttributeFinishColumnDescription', @sdxGanttControlSheetExtendedAttributeFinishColumnDescription);
  AProduct.Add('sdxGanttControlSheetExtendedAttributeFlagColumnDescription', @sdxGanttControlSheetExtendedAttributeFlagColumnDescription);
  AProduct.Add('sdxGanttControlSheetExtendedAttributeDurationColumnDescription', @sdxGanttControlSheetExtendedAttributeDurationColumnDescription);
  AProduct.Add('sdxGanttControlSheetExtendedAttributeTextColumnDescription', @sdxGanttControlSheetExtendedAttributeTextColumnDescription);
  AProduct.Add('sdxGanttControlSheetExtendedAttributeNumberColumnDescription', @sdxGanttControlSheetExtendedAttributeNumberColumnDescription);
  AProduct.Add('sdxGanttControlCommandRenameColumnCaption', @sdxGanttControlCommandRenameColumnCaption);
  AProduct.Add('sdxGanttControlCommandWordWrapCaption', @sdxGanttControlCommandWordWrapCaption);
  AProduct.Add('sdxGanttControlCommandInsertColumnCaption', @sdxGanttControlCommandInsertColumnCaption);
  AProduct.Add('sdxGanttControlCommandHideColumnCaption', @sdxGanttControlCommandHideColumnCaption);
  AProduct.Add('sdxGanttControlCommandShowChooseColumnDetailsDialogCaption', @sdxGanttControlCommandShowChooseColumnDetailsDialogCaption);
  AProduct.Add('sdxGanttControlCommandBestFitColumnCaption', @sdxGanttControlCommandBestFitColumnCaption);
  AProduct.Add('sdxGanttControlCommandBestFitAllColumnsCaption', @sdxGanttControlCommandBestFitAllColumnsCaption);
  AProduct.Add('sdxGanttControlChooseDetailsDialogCaption', @sdxGanttControlChooseDetailsDialogCaption);
  AProduct.Add('sdxGanttControlChooseDetailsDialogDescription', @sdxGanttControlChooseDetailsDialogDescription);
  AProduct.Add('sdxGanttControlChooseDetailsDialogDetails', @sdxGanttControlChooseDetailsDialogDetails);
  AProduct.Add('sdxGanttControlChooseDetailsDialogColumnWidthDescription', @sdxGanttControlChooseDetailsDialogColumnWidthDescription);
end;


initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  dxResourceStringsRepository.RegisterProduct(dxGanttControlProductName, @AddGanttControlResourceStringNames);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  dxResourceStringsRepository.UnRegisterProduct(dxGanttControlProductName, @AddGanttControlResourceStringNames);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.
