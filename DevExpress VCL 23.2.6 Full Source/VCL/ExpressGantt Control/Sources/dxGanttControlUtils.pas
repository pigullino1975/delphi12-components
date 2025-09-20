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

unit dxGanttControlUtils;

{$I cxVer.inc}
{$I dxGanttControl.inc}

interface

uses
  System.UITypes, System.Contnrs,
  SysUtils, Generics.Defaults, Generics.Collections, Classes,
  dxCore, dxCoreClasses, cxCustomCanvas,
  dxGanttControlCustomDataModel;

type
  EdxGanttControlException = class(EdxException);

  { TdxGanttControlExceptions }

  TdxGanttControlExceptions = class // for internal use
  public
    class procedure ThrowTasksCannotBeLinkedTwiceException; static;
    class procedure ThrowImageNotFoundException; static;
    class procedure ThrowInvalidFileFormatException; static;
    class procedure ThrowOutlineChangeWouldCreateCircularRelationshipException; static;
    class procedure ThrowPositionChangeWouldCreateCircularRelationshipException; static;
    class procedure ThrowUnsupportedFileFormatException; static;
    class procedure ThrowTasksAreAlreadyLinkedException; static;
    class procedure ThrowCannotLinkSummaryTaskToItsSubtaskException; static;
    class procedure ThrowTasksAreAlreadyLinkedThroughAnotherTaskChainException; static;
  end;

  { TdxGanttControlUtils }

  TdxGanttControlUtils = class
  public
    class function GenerateGUID: string; static;

    class function DateTimeToMilliseconds(const ADateTime: TDateTime): Int64; static;
    class function GetShortDateTimeFormat: string; static;
    class function MeasureTextHeight(ATextLayout: TcxCanvasBasedTextLayout; AWidth: Integer; const AText: string;
      AFont: TcxCanvasBasedFont; AIsSingleLine: Boolean): Integer;
    class function MeasureTextWidth(ATextLayout: TcxCanvasBasedTextLayout; const AText: string;
      AFont: TcxCanvasBasedFont): Integer;
  end;

  { TdxGanttControlDurationFieldHelper }

  TdxGanttControlDurationFieldHelper = class // for internal use
  strict private class var
    FDayExtraShortName: string;
    FDayName: string;
    FDaysName: string;
    FElapsedTimePrefix: string;
    FEstimatedTimePostfix: string;
    FHourExtraShortName: string;
    FHourName: string;
    FHourShortName: string;
    FHoursName: string;
    FHoursShortName: string;
    FMinuteExtraShortName: string;
    FMinuteName: string;
    FMinuteShortName: string;
    FMinutesName: string;
    FMinutesShortName: string;
    FMonthExtraShortName: string;
    FMonthName: string;
    FMonthShortName: string;
    FMonthsName: string;
    FMonthsShortName: string;
    FWeekExtraShortName: string;
    FWeekName: string;
    FWeekShortName: string;
    FWeeksName: string;
    FWeeksShortName: string;
  public
    class function GetDurationFormat(const ADescription: string; ADefaultFormat: TdxDurationFormat): TdxDurationFormat; static;
    class procedure InitializeDurationFormatDescriptions; static;

    class property DayExtraShortName: string read FDayExtraShortName;
    class property DayName: string read FDayName;
    class property DaysName: string read FDaysName;
    class property ElapsedTimePrefix: string read FElapsedTimePrefix;
    class property EstimatedTimePostfix: string read FEstimatedTimePostfix;
    class property HourExtraShortName: string read FHourExtraShortName;
    class property HourName: string read FHourName;
    class property HourShortName: string read FHourShortName;
    class property HoursName: string read FHoursName;
    class property HoursShortName: string read FHoursShortName;
    class property MinuteExtraShortName: string read FMinuteExtraShortName;
    class property MinuteName: string read FMinuteName;
    class property MinuteShortName: string read FMinuteShortName;
    class property MinutesName: string read FMinutesName;
    class property MinutesShortName: string read FMinutesShortName;
    class property MonthExtraShortName: string read FMonthExtraShortName;
    class property MonthName: string read FMonthName;
    class property MonthShortName: string read FMonthShortName;
    class property MonthsName: string read FMonthsName;
    class property MonthsShortName: string read FMonthsShortName;
    class property WeekExtraShortName: string read FWeekExtraShortName;
    class property WeekName: string read FWeekName;
    class property WeekShortName: string read FWeekShortName;
    class property WeeksName: string read FWeeksName;
    class property WeeksShortName: string read FWeeksShortName;
  end;

implementation

uses
  cxDrawTextUtils,
  dxCultureInfo,
  dxGanttControlStrs;

const
  dxThisUnitName = 'dxGanttControlUtils';

{ TdxGanttControlExceptions }

class procedure TdxGanttControlExceptions.ThrowImageNotFoundException;
begin
  raise EdxGanttControlException.Create(cxGetResourceString(@sdxGanttControlExceptionImageNotFound));
end;

class procedure TdxGanttControlExceptions.ThrowInvalidFileFormatException;
begin
  raise EdxGanttControlException.Create(cxGetResourceString(@sdxGanttControlExceptionInvalidFileFormat));
end;

class procedure TdxGanttControlExceptions.ThrowOutlineChangeWouldCreateCircularRelationshipException;
begin
  raise EdxGanttControlException.Create(cxGetResourceString(@sdxGanttControlExceptionOutlineChangeWouldCreateCircularRelationship));
end;

class procedure TdxGanttControlExceptions.ThrowPositionChangeWouldCreateCircularRelationshipException;
begin
  raise EdxGanttControlException.Create(cxGetResourceString(@sdxGanttControlExceptionPositionChangeWouldCreateCircularRelationship));
end;

class procedure TdxGanttControlExceptions.ThrowUnsupportedFileFormatException;
begin
  raise EdxGanttControlException.Create(cxGetResourceString(@sdxGanttControlExceptionUnsupportedFileFormat));
end;

class procedure TdxGanttControlExceptions.ThrowCannotLinkSummaryTaskToItsSubtaskException;
begin
  raise EdxGanttControlException.Create(cxGetResourceString(@sdxGanttControlExceptionCannotLinkSummaryTaskToItsSubtask));
end;

class procedure TdxGanttControlExceptions.ThrowTasksAreAlreadyLinkedException;
begin
  raise EdxGanttControlException.Create(cxGetResourceString(@sdxGanttControlExceptionTasksAreAlreadyLinked));
end;

class procedure TdxGanttControlExceptions.ThrowTasksCannotBeLinkedTwiceException;
begin
  raise EdxGanttControlException.Create(cxGetResourceString(@sdxGanttControlExceptionTasksCannotBeLinkedTwice));
end;

class procedure TdxGanttControlExceptions.ThrowTasksAreAlreadyLinkedThroughAnotherTaskChainException;
begin
  raise EdxGanttControlException.Create(cxGetResourceString(@sdxGanttControlExceptionTasksAreAlreadyLinkedThroughAnotherTaskChain));
end;

{ TdxGanttControlUtils }

class function TdxGanttControlUtils.DateTimeToMilliseconds(
  const ADateTime: TDateTime): Int64;
var
  ATimeStamp: TTimeStamp;
begin
  ATimeStamp := DateTimeToTimeStamp(ADateTime);
  Result := ATimeStamp.Date;
  Result := (Result * MSecsPerDay) + ATimeStamp.Time;
end;

class function TdxGanttControlUtils.GenerateGUID: string;
begin
  Result := dxGenerateID;
end;

class function TdxGanttControlUtils.GetShortDateTimeFormat: string;
begin
  Result := TdxCultureInfo.CurrentCulture.FormatSettings.ShortDateFormat + ' ' +
    TdxCultureInfo.CurrentCulture.FormatSettings.ShortTimeFormat;
end;

class function TdxGanttControlUtils.MeasureTextHeight(
  ATextLayout: TcxCanvasBasedTextLayout; AWidth: Integer; const AText: string;
  AFont: TcxCanvasBasedFont; AIsSingleLine: Boolean): Integer;
const
  ASingleLineFlagsMap: array[Boolean] of Integer = (CXTO_WORDBREAK, CXTO_SINGLELINE);
begin
  ATextLayout.SetFlags(ASingleLineFlagsMap[AIsSingleLine] or CXTO_CALCRECT);
  ATextLayout.SetFont(AFont);
  ATextLayout.SetText(AText);
  ATextLayout.SetLayoutConstraints(AWidth, MaxInt);
  Result := ATextLayout.MeasureSize.cy;
end;

class function TdxGanttControlUtils.MeasureTextWidth(
  ATextLayout: TcxCanvasBasedTextLayout; const AText: string;
  AFont: TcxCanvasBasedFont): Integer;
begin
  ATextLayout.SetFlags(CXTO_SINGLELINE or CXTO_CALCRECT);
  ATextLayout.SetFont(AFont);
  ATextLayout.SetText(AText);
  ATextLayout.SetLayoutConstraints(MaxInt, MaxInt);
  Result := ATextLayout.MeasureSize.cx;
end;

{ TdxGanttControlDurationFieldHelper }

class function TdxGanttControlDurationFieldHelper.GetDurationFormat(
  const ADescription: string;
  ADefaultFormat: TdxDurationFormat): TdxDurationFormat;

  function CheckMeasureUnit(const AMeasureUnit: string; ACheckUnits: array of string): Boolean;
  var
    I: Integer;
  begin
    Result := True;
    for I := Low(ACheckUnits) to High(ACheckUnits) do
      if AMeasureUnit = AnsiUpperCase(ACheckUnits[I]) then
        Exit;
    Result := False;
  end;

var
  S: string;
begin
  InitializeDurationFormatDescriptions;
  S := AnsiUpperCase(Trim(ADescription));

  if CheckMeasureUnit(S,
      [DayExtraShortName, DayName, DaysName]) then
    Result := TdxDurationFormat.Days
  else
  if CheckMeasureUnit(S,
      [HourExtraShortName, HourShortName, HoursShortName, HourName, HoursName]) then
    Result := TdxDurationFormat.Hours
  else
  if CheckMeasureUnit(S,
      [WeekExtraShortName, WeekShortName, WeeksShortName, WeekName, WeeksName]) then
    Result := TdxDurationFormat.Weeks
  else
  if CheckMeasureUnit(S,
      [MonthExtraShortName, MonthShortName, MonthsShortName, MonthName, MonthsName]) then
    Result := TdxDurationFormat.Months
  else
  if CheckMeasureUnit(S,
      [MinuteExtraShortName, MinuteShortName, MinutesShortName, MinuteName, MinutesName]) then
    Result := TdxDurationFormat.Minutes
  else

  if CheckMeasureUnit(S,
      [ElapsedTimePrefix + DayExtraShortName, ElapsedTimePrefix + DayName, ElapsedTimePrefix + DaysName]) then
    Result := TdxDurationFormat.ElapsedDays
  else
  if CheckMeasureUnit(S,
      [ElapsedTimePrefix + HourExtraShortName, ElapsedTimePrefix + HourShortName,
        ElapsedTimePrefix + HoursShortName, ElapsedTimePrefix + HourName, ElapsedTimePrefix + HoursName]) then
    Result := TdxDurationFormat.ElapsedHours
  else
  if CheckMeasureUnit(S,
      [ElapsedTimePrefix + WeekExtraShortName, ElapsedTimePrefix + WeekShortName,
        ElapsedTimePrefix + WeeksShortName, ElapsedTimePrefix + WeekName, ElapsedTimePrefix + WeeksName]) then
    Result := TdxDurationFormat.ElapsedWeeks
  else
  if CheckMeasureUnit(S,
      [ElapsedTimePrefix + MonthExtraShortName, ElapsedTimePrefix + MonthShortName,
       ElapsedTimePrefix + MonthsShortName, ElapsedTimePrefix + MonthName, ElapsedTimePrefix + MonthsName]) then
    Result := TdxDurationFormat.ElapsedMonths
  else
  if CheckMeasureUnit(S,
      [ElapsedTimePrefix + MinuteExtraShortName, ElapsedTimePrefix + MinuteShortName,
       ElapsedTimePrefix + MinutesShortName, ElapsedTimePrefix + MinuteName, ElapsedTimePrefix + MinutesName]) then
    Result := TdxDurationFormat.ElapsedMinutes
  else

  if CheckMeasureUnit(S,
      [DayExtraShortName + EstimatedTimePostfix, DayName + EstimatedTimePostfix, DaysName + EstimatedTimePostfix]) then
    Result := TdxDurationFormat.EstimatedDays
  else
  if CheckMeasureUnit(S,
      [HourExtraShortName + EstimatedTimePostfix, HourShortName + EstimatedTimePostfix,
       HoursShortName + EstimatedTimePostfix, HourName + EstimatedTimePostfix, HoursName + EstimatedTimePostfix]) then
    Result := TdxDurationFormat.EstimatedHours
  else
  if CheckMeasureUnit(S,
      [WeekExtraShortName + EstimatedTimePostfix, WeekShortName + EstimatedTimePostfix,
       WeeksShortName + EstimatedTimePostfix, WeekName + EstimatedTimePostfix, WeeksName + EstimatedTimePostfix]) then
    Result := TdxDurationFormat.EstimatedWeeks
  else
  if CheckMeasureUnit(S,
      [MonthExtraShortName + EstimatedTimePostfix, MonthShortName + EstimatedTimePostfix,
       MonthsShortName + EstimatedTimePostfix, MonthName + EstimatedTimePostfix, MonthsName + EstimatedTimePostfix]) then
    Result := TdxDurationFormat.EstimatedMonths
  else
  if CheckMeasureUnit(S,
      [MinuteExtraShortName + EstimatedTimePostfix, MinuteShortName + EstimatedTimePostfix,
       MinutesShortName + EstimatedTimePostfix, MinuteName + EstimatedTimePostfix, MinutesName + EstimatedTimePostfix]) then
    Result := TdxDurationFormat.EstimatedMinutes
  else

  if CheckMeasureUnit(S,
      [ElapsedTimePrefix + DayExtraShortName + EstimatedTimePostfix,
       ElapsedTimePrefix + DayName + EstimatedTimePostfix,
       ElapsedTimePrefix + DaysName + EstimatedTimePostfix]) then
    Result := TdxDurationFormat.EstimatedElapsedDays
  else
  if CheckMeasureUnit(S,
      [ElapsedTimePrefix + HourExtraShortName + EstimatedTimePostfix,
       ElapsedTimePrefix + HourShortName + EstimatedTimePostfix,
       ElapsedTimePrefix + HoursShortName + EstimatedTimePostfix,
       ElapsedTimePrefix + HourName + EstimatedTimePostfix,
       ElapsedTimePrefix + HoursName + EstimatedTimePostfix]) then
    Result := TdxDurationFormat.EstimatedElapsedHours
  else
  if CheckMeasureUnit(S,
      [ElapsedTimePrefix + WeekExtraShortName + EstimatedTimePostfix,
       ElapsedTimePrefix + WeekShortName + EstimatedTimePostfix,
       ElapsedTimePrefix + WeeksShortName + EstimatedTimePostfix,
       ElapsedTimePrefix + WeekName + EstimatedTimePostfix,
       ElapsedTimePrefix + WeeksName + EstimatedTimePostfix]) then
    Result := TdxDurationFormat.EstimatedElapsedWeeks
  else
  if CheckMeasureUnit(S,
      [ElapsedTimePrefix + MonthExtraShortName + EstimatedTimePostfix,
       ElapsedTimePrefix + MonthShortName + EstimatedTimePostfix,
       ElapsedTimePrefix + MonthsShortName + EstimatedTimePostfix,
       ElapsedTimePrefix + MonthName + EstimatedTimePostfix,
       ElapsedTimePrefix + MonthsName + EstimatedTimePostfix]) then
    Result := TdxDurationFormat.EstimatedElapsedMonths
  else
  if CheckMeasureUnit(S,
      [ElapsedTimePrefix + MinuteExtraShortName + EstimatedTimePostfix,
       ElapsedTimePrefix + MinuteShortName + EstimatedTimePostfix,
       ElapsedTimePrefix + MinutesShortName + EstimatedTimePostfix,
       ElapsedTimePrefix + MinuteName + EstimatedTimePostfix,
       ElapsedTimePrefix + MinutesName + EstimatedTimePostfix]) then
    Result := TdxDurationFormat.EstimatedElapsedMinutes

  else
    Result := ADefaultFormat;
end;

class procedure TdxGanttControlDurationFieldHelper.InitializeDurationFormatDescriptions;
begin
  FElapsedTimePrefix := cxGetResourceString(@sdxGanttControlDurationFormatElapsedTimePrefix);
  FEstimatedTimePostfix := cxGetResourceString(@sdxGanttControlDurationFormatEstimatedTimePostfix);
  FMinuteExtraShortName := cxGetResourceString(@sdxGanttControlDurationFormatMinuteExtraShort);
  FMinuteName := cxGetResourceString(@sdxGanttControlDurationFormatMinute);
  FMinutesName := cxGetResourceString(@sdxGanttControlDurationFormatMinutes);
  FMinuteShortName := cxGetResourceString(@sdxGanttControlDurationFormatMinuteShort);
  FMinutesShortName := cxGetResourceString(@sdxGanttControlDurationFormatMinutesShort);
  FHourExtraShortName := cxGetResourceString(@sdxGanttControlDurationFormatHourExtraShort);
  FHourName := cxGetResourceString(@sdxGanttControlDurationFormatHour);
  FHoursName := cxGetResourceString(@sdxGanttControlDurationFormatHours);
  FHourShortName := cxGetResourceString(@sdxGanttControlDurationFormatHourShort);
  FHoursShortName := cxGetResourceString(@sdxGanttControlDurationFormatHoursShort);
  FDayExtraShortName := cxGetResourceString(@sdxGanttControlDurationFormatDayExtraShort);
  FDayName := cxGetResourceString(@sdxGanttControlDurationFormatDay);
  FDaysName := cxGetResourceString(@sdxGanttControlDurationFormatDays);
  FWeekExtraShortName := cxGetResourceString(@sdxGanttControlDurationFormatWeekExtraShort);
  FWeekName := cxGetResourceString(@sdxGanttControlDurationFormatWeek);
  FWeeksName := cxGetResourceString(@sdxGanttControlDurationFormatWeeks);
  FWeekShortName := cxGetResourceString(@sdxGanttControlDurationFormatWeekShort);
  FWeeksShortName := cxGetResourceString(@sdxGanttControlDurationFormatWeeksShort);
  FMonthExtraShortName := cxGetResourceString(@sdxGanttControlDurationFormatMonthExtraShort);
  FMonthName := cxGetResourceString(@sdxGanttControlDurationFormatMonth);
  FMonthsName := cxGetResourceString(@sdxGanttControlDurationFormatMonths);
  FMonthShortName := cxGetResourceString(@sdxGanttControlDurationFormatMonthShort);
  FMonthsShortName := cxGetResourceString(@sdxGanttControlDurationFormatMonthsShort);
end;

end.
