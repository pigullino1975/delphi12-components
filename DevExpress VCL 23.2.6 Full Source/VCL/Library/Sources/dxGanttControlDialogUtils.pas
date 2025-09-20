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

unit dxGanttControlDialogUtils;  // for internal use

{$I cxVer.inc}
{$I dxGanttControl.inc}

interface

uses
  SysUtils, Controls, DateUtils,
  dxCore, dxMeasurementUnitEdit, cxEdit, cxCalendar,
  dxLayoutControl, dxLayoutContainer,
  dxGanttControlCustomDataModel,
  dxGanttControlStrs,
  dxGanttControlCalendars;

type
  TdxGanttControlDialogUtils = class
  public
    class procedure DateValidateHandler(Sender: TcxDateEdit; AAsStartDate: Boolean); static;
    class function GetDurationDescription(AFormat: TdxDurationFormat): string; static;
    class function GetDurationFormat(const S: string; var AError: Boolean; var AErrorText: TCaption): TdxDurationFormat; static;
    class function GetDurationText(ADurationEditHelper: TdxMeasurementUnitEditHelper;
      ADuration: TdxGanttControlDuration; AFormat: TdxDurationFormat): string; static;
    class procedure InitializeDurationUnits; static;
    class function IsDurationElapsed(AFormat: TdxDurationFormat): Boolean; static;
    class function IsDurationEstimated(AFormat: TdxDurationFormat): Boolean; static;
    class procedure PopulatePossibleDescriptions(ADurationEditHelper: TdxMeasurementUnitEditHelper; AEstimatedPresentToo: Boolean); static;
    class procedure SetControlsReadOnly(ALayoutControl: TdxCustomLayoutControl; AReadOnly: Boolean); static;
  end;

var
  dxduElapsedTimePrefix, dxduEstimatedTimePostfix,
  dxduMinuteExtraShort, dxduMinute, dxduMinutes, dxduMinuteShort, dxduMinutesShort,
  dxduHourExtraShort, dxduHour, dxduHours, dxduHourShort, dxduHoursShort,
  dxduDayExtraShort, dxduDay, dxduDays,
  dxduWeekExtraShort, dxduWeek, dxduWeeks, dxduWeekShort, dxduWeeksShort,
  dxduMonthExtraShort, dxduMonth, dxduMonths, dxduMonthShort, dxduMonthsShort: string;

implementation

uses
  cxButtons;

const
  dxThisUnitName = 'dxGanttControlDialogUtils';

type
  TcxDateEditAccess = class(TcxDateEdit);

class procedure TdxGanttControlDialogUtils.DateValidateHandler(Sender: TcxDateEdit; AAsStartDate: Boolean);
begin
  if TcxDateEditAccess(Sender).FCloseUpReason <> crEnter then
    Exit;
  if (Sender.Text <> '') and (Sender.CurrentDate > 0) and (TimeOf(Sender.CurrentDate) = 0) then
    if AAsStartDate then
      Sender.Date := Int(Sender.CurrentDate) + 8/24
    else
      Sender.Date := Int(Sender.CurrentDate) + 17/24;
end;

class function TdxGanttControlDialogUtils.GetDurationDescription(AFormat: TdxDurationFormat): string;
begin
  case AFormat of
    TdxDurationFormat.Minutes, TdxDurationFormat.EstimatedMinutes:
      Result := dxduMinuteExtraShort;
    TdxDurationFormat.ElapsedMinutes, TdxDurationFormat.EstimatedElapsedMinutes:
      Result := dxduElapsedTimePrefix + dxduMinuteExtraShort;
    TdxDurationFormat.Hours, TdxDurationFormat.EstimatedHours:
      Result := dxduHourExtraShort;
    TdxDurationFormat.ElapsedHours, TdxDurationFormat.EstimatedElapsedHours:
      Result := dxduElapsedTimePrefix + dxduHourExtraShort;
    TdxDurationFormat.Days, TdxDurationFormat.EstimatedDays, TdxDurationFormat.Null, TdxDurationFormat.EstimatedNull:
      Result := dxduDayExtraShort;
    TdxDurationFormat.ElapsedDays, TdxDurationFormat.EstimatedElapsedDays:
      Result := dxduElapsedTimePrefix + dxduDayExtraShort;
    TdxDurationFormat.Weeks, TdxDurationFormat.EstimatedWeeks:
      Result := dxduWeekExtraShort;
    TdxDurationFormat.ElapsedWeeks, TdxDurationFormat.EstimatedElapsedWeeks:
      Result := dxduElapsedTimePrefix + dxduWeekExtraShort;
    TdxDurationFormat.Months, TdxDurationFormat.EstimatedMonths:
      Result := dxduMonthExtraShort;
    TdxDurationFormat.ElapsedMonths, TdxDurationFormat.EstimatedElapsedMonths:
      Result := dxduElapsedTimePrefix + dxduMonthExtraShort;
  end;
  Result := ' ' + Result;
end;

class function TdxGanttControlDialogUtils.GetDurationFormat(const S: string; var AError: Boolean; var AErrorText: TCaption): TdxDurationFormat;

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
  ADescription: string;
begin
  AError := False;
  InitializeDurationUnits;
  AErrorText := Format(cxGetResourceString(@sdxGanttControlMessageInvalidMeasurementUnit), [ADescription]);
  ADescription := AnsiUpperCase(Trim(S));
  Result := TdxDurationFormat.Days;  

  if CheckMeasureUnit(ADescription,
      [dxduDayExtraShort, dxduDay, dxduDays]) then
    Result := TdxDurationFormat.Days
  else
  if CheckMeasureUnit(ADescription,
      [dxduHourExtraShort, dxduHourShort, dxduHoursShort, dxduHour, dxduHours]) then
    Result := TdxDurationFormat.Hours
  else
  if CheckMeasureUnit(ADescription,
      [dxduWeekExtraShort, dxduWeekShort, dxduWeeksShort, dxduWeek, dxduWeeks]) then
    Result := TdxDurationFormat.Weeks
  else
  if CheckMeasureUnit(ADescription,
      [dxduMonthExtraShort, dxduMonthShort, dxduMonthsShort, dxduMonth, dxduMonths]) then
    Result := TdxDurationFormat.Months
  else
  if CheckMeasureUnit(ADescription,
      [dxduMinuteExtraShort, dxduMinuteShort, dxduMinutesShort, dxduMinute, dxduMinutes]) then
    Result := TdxDurationFormat.Minutes
  else

  if CheckMeasureUnit(ADescription,
      [dxduElapsedTimePrefix + dxduDayExtraShort, dxduElapsedTimePrefix + dxduDay, dxduElapsedTimePrefix + dxduDays]) then
    Result := TdxDurationFormat.ElapsedDays
  else
  if CheckMeasureUnit(ADescription,
      [dxduElapsedTimePrefix + dxduHourExtraShort, dxduElapsedTimePrefix + dxduHourShort,
        dxduElapsedTimePrefix + dxduHoursShort, dxduElapsedTimePrefix + dxduHour, dxduElapsedTimePrefix + dxduHours]) then
    Result := TdxDurationFormat.ElapsedHours
  else
  if CheckMeasureUnit(ADescription,
      [dxduElapsedTimePrefix + dxduWeekExtraShort, dxduElapsedTimePrefix + dxduWeekShort,
        dxduElapsedTimePrefix + dxduWeeksShort, dxduElapsedTimePrefix + dxduWeek, dxduElapsedTimePrefix + dxduWeeks]) then
    Result := TdxDurationFormat.ElapsedWeeks
  else
  if CheckMeasureUnit(ADescription,
      [dxduElapsedTimePrefix + dxduMonthExtraShort, dxduElapsedTimePrefix + dxduMonthShort,
       dxduElapsedTimePrefix + dxduMonthsShort, dxduElapsedTimePrefix + dxduMonth, dxduElapsedTimePrefix + dxduMonths]) then
    Result := TdxDurationFormat.ElapsedMonths
  else
  if CheckMeasureUnit(ADescription,
      [dxduElapsedTimePrefix + dxduMinuteExtraShort, dxduElapsedTimePrefix + dxduMinuteShort,
       dxduElapsedTimePrefix + dxduMinutesShort, dxduElapsedTimePrefix + dxduMinute, dxduElapsedTimePrefix + dxduMinutes]) then
    Result := TdxDurationFormat.ElapsedMinutes
  else

  if CheckMeasureUnit(ADescription,
      [dxduDayExtraShort + dxduEstimatedTimePostfix, dxduDay + dxduEstimatedTimePostfix, dxduDays + dxduEstimatedTimePostfix]) then
    Result := TdxDurationFormat.EstimatedDays
  else
  if CheckMeasureUnit(ADescription,
      [dxduHourExtraShort + dxduEstimatedTimePostfix, dxduHourShort + dxduEstimatedTimePostfix,
       dxduHoursShort + dxduEstimatedTimePostfix, dxduHour + dxduEstimatedTimePostfix, dxduHours + dxduEstimatedTimePostfix]) then
    Result := TdxDurationFormat.EstimatedHours
  else
  if CheckMeasureUnit(ADescription,
      [dxduWeekExtraShort + dxduEstimatedTimePostfix, dxduWeekShort + dxduEstimatedTimePostfix,
       dxduWeeksShort + dxduEstimatedTimePostfix, dxduWeek + dxduEstimatedTimePostfix, dxduWeeks + dxduEstimatedTimePostfix]) then
    Result := TdxDurationFormat.EstimatedWeeks
  else
  if CheckMeasureUnit(ADescription,
      [dxduMonthExtraShort + dxduEstimatedTimePostfix, dxduMonthShort + dxduEstimatedTimePostfix,
       dxduMonthsShort + dxduEstimatedTimePostfix, dxduMonth + dxduEstimatedTimePostfix, dxduMonths + dxduEstimatedTimePostfix]) then
    Result := TdxDurationFormat.EstimatedMonths
  else
  if CheckMeasureUnit(ADescription,
      [dxduMinuteExtraShort + dxduEstimatedTimePostfix, dxduMinuteShort + dxduEstimatedTimePostfix,
       dxduMinutesShort + dxduEstimatedTimePostfix, dxduMinute + dxduEstimatedTimePostfix, dxduMinutes + dxduEstimatedTimePostfix]) then
    Result := TdxDurationFormat.EstimatedMinutes
  else

  if CheckMeasureUnit(ADescription,
      [dxduElapsedTimePrefix + dxduDayExtraShort + dxduEstimatedTimePostfix,
       dxduElapsedTimePrefix + dxduDay + dxduEstimatedTimePostfix,
       dxduElapsedTimePrefix + dxduDays + dxduEstimatedTimePostfix]) then
    Result := TdxDurationFormat.EstimatedElapsedDays
  else
  if CheckMeasureUnit(ADescription,
      [dxduElapsedTimePrefix + dxduHourExtraShort + dxduEstimatedTimePostfix,
       dxduElapsedTimePrefix + dxduHourShort + dxduEstimatedTimePostfix,
       dxduElapsedTimePrefix + dxduHoursShort + dxduEstimatedTimePostfix,
       dxduElapsedTimePrefix + dxduHour + dxduEstimatedTimePostfix,
       dxduElapsedTimePrefix + dxduHours + dxduEstimatedTimePostfix]) then
    Result := TdxDurationFormat.EstimatedElapsedHours
  else
  if CheckMeasureUnit(ADescription,
      [dxduElapsedTimePrefix + dxduWeekExtraShort + dxduEstimatedTimePostfix,
       dxduElapsedTimePrefix + dxduWeekShort + dxduEstimatedTimePostfix,
       dxduElapsedTimePrefix + dxduWeeksShort + dxduEstimatedTimePostfix,
       dxduElapsedTimePrefix + dxduWeek + dxduEstimatedTimePostfix,
       dxduElapsedTimePrefix + dxduWeeks + dxduEstimatedTimePostfix]) then
    Result := TdxDurationFormat.EstimatedElapsedWeeks
  else
  if CheckMeasureUnit(ADescription,
      [dxduElapsedTimePrefix + dxduMonthExtraShort + dxduEstimatedTimePostfix,
       dxduElapsedTimePrefix + dxduMonthShort + dxduEstimatedTimePostfix,
       dxduElapsedTimePrefix + dxduMonthsShort + dxduEstimatedTimePostfix,
       dxduElapsedTimePrefix + dxduMonth + dxduEstimatedTimePostfix,
       dxduElapsedTimePrefix + dxduMonths + dxduEstimatedTimePostfix]) then
    Result := TdxDurationFormat.EstimatedElapsedMonths
  else
  if CheckMeasureUnit(ADescription,
      [dxduElapsedTimePrefix + dxduMinuteExtraShort + dxduEstimatedTimePostfix,
       dxduElapsedTimePrefix + dxduMinuteShort + dxduEstimatedTimePostfix,
       dxduElapsedTimePrefix + dxduMinutesShort + dxduEstimatedTimePostfix,
       dxduElapsedTimePrefix + dxduMinute + dxduEstimatedTimePostfix,
       dxduElapsedTimePrefix + dxduMinutes + dxduEstimatedTimePostfix]) then
    Result := TdxDurationFormat.EstimatedElapsedMinutes
  else
    AError := True;
end;

class function TdxGanttControlDialogUtils.GetDurationText(ADurationEditHelper: TdxMeasurementUnitEditHelper;
  ADuration: TdxGanttControlDuration; AFormat: TdxDurationFormat): string;
begin
  Result := '';
  case AFormat of
    TdxDurationFormat.Minutes, TdxDurationFormat.EstimatedMinutes:
      Result := ADurationEditHelper.GetTextFromValue(ADuration.ToMinutes);

    TdxDurationFormat.ElapsedMinutes, TdxDurationFormat.EstimatedElapsedMinutes:
      Result := ADurationEditHelper.GetTextFromValue(ADuration.ToElapsedMinutes);

    TdxDurationFormat.Hours, TdxDurationFormat.EstimatedHours:
      Result := ADurationEditHelper.GetTextFromValue(ADuration.ToHours);

    TdxDurationFormat.ElapsedHours,TdxDurationFormat.EstimatedElapsedHours:
      Result := ADurationEditHelper.GetTextFromValue(ADuration.ToElapsedHours);

    TdxDurationFormat.Days, TdxDurationFormat.Null,
    TdxDurationFormat.EstimatedDays, TdxDurationFormat.EstimatedNull:
      Result := ADurationEditHelper.GetTextFromValue(ADuration.ToDays);

    TdxDurationFormat.ElapsedDays, TdxDurationFormat.EstimatedElapsedDays:
      Result := ADurationEditHelper.GetTextFromValue(ADuration.ToElapsedDays);

    TdxDurationFormat.Weeks, TdxDurationFormat.EstimatedWeeks:
      Result := ADurationEditHelper.GetTextFromValue(ADuration.ToWeeks);

    TdxDurationFormat.ElapsedWeeks, TdxDurationFormat.EstimatedElapsedWeeks:
      Result := ADurationEditHelper.GetTextFromValue(ADuration.ToElapsedWeeks);

    TdxDurationFormat.Months, TdxDurationFormat.EstimatedMonths:
      Result := ADurationEditHelper.GetTextFromValue(ADuration.ToMonths);

    TdxDurationFormat.ElapsedMonths,TdxDurationFormat.EstimatedElapsedMonths:
      Result := ADurationEditHelper.GetTextFromValue(ADuration.ToElapsedMonths);
  else
    Result := ADurationEditHelper.GetTextFromValue(ADuration.ToDays);
  end;
end;

class procedure TdxGanttControlDialogUtils.InitializeDurationUnits;
begin
  dxduMinuteExtraShort := cxGetResourceString(@sdxGanttControlDurationFormatMinuteExtraShort);
  dxduMinute := cxGetResourceString(@sdxGanttControlDurationFormatMinute);
  dxduMinutes := cxGetResourceString(@sdxGanttControlDurationFormatMinutes);
  dxduMinuteShort := cxGetResourceString(@sdxGanttControlDurationFormatMinuteShort);
  dxduMinutesShort := cxGetResourceString(@sdxGanttControlDurationFormatMinutesShort);
  dxduHourExtraShort := cxGetResourceString(@sdxGanttControlDurationFormatHourExtraShort);
  dxduHour := cxGetResourceString(@sdxGanttControlDurationFormatHour);
  dxduHours := cxGetResourceString(@sdxGanttControlDurationFormatHours);
  dxduHourShort := cxGetResourceString(@sdxGanttControlDurationFormatHourShort);
  dxduHoursShort := cxGetResourceString(@sdxGanttControlDurationFormatHoursShort);
  dxduDayExtraShort := cxGetResourceString(@sdxGanttControlDurationFormatDayExtraShort);
  dxduDay := cxGetResourceString(@sdxGanttControlDurationFormatDay);
  dxduDays := cxGetResourceString(@sdxGanttControlDurationFormatDays);
  dxduWeekExtraShort := cxGetResourceString(@sdxGanttControlDurationFormatWeekExtraShort);
  dxduWeek := cxGetResourceString(@sdxGanttControlDurationFormatWeek);
  dxduWeeks := cxGetResourceString(@sdxGanttControlDurationFormatWeeks);
  dxduWeekShort := cxGetResourceString(@sdxGanttControlDurationFormatWeekShort);
  dxduWeeksShort := cxGetResourceString(@sdxGanttControlDurationFormatWeeksShort);
  dxduMonthExtraShort := cxGetResourceString(@sdxGanttControlDurationFormatMonthExtraShort);
  dxduMonth := cxGetResourceString(@sdxGanttControlDurationFormatMonth);
  dxduMonths := cxGetResourceString(@sdxGanttControlDurationFormatMonths);
  dxduMonthShort := cxGetResourceString(@sdxGanttControlDurationFormatMonthShort);
  dxduMonthsShort := cxGetResourceString(@sdxGanttControlDurationFormatMonthsShort);
  dxduElapsedTimePrefix := cxGetResourceString(@sdxGanttControlDurationFormatElapsedTimePrefix);
  dxduEstimatedTimePostfix := cxGetResourceString(@sdxGanttControlDurationFormatEstimatedTimePostfix);
end;

class function TdxGanttControlDialogUtils.IsDurationElapsed(AFormat: TdxDurationFormat): Boolean;
begin
  Result := AFormat in [TdxDurationFormat.ElapsedMinutes, TdxDurationFormat.EstimatedElapsedMinutes,
    TdxDurationFormat.ElapsedHours, TdxDurationFormat.EstimatedElapsedHours,
    TdxDurationFormat.ElapsedDays, TdxDurationFormat.EstimatedElapsedDays, TdxDurationFormat.EstimatedNull,
    TdxDurationFormat.ElapsedWeeks, TdxDurationFormat.EstimatedElapsedWeeks,
    TdxDurationFormat.ElapsedMonths, TdxDurationFormat.EstimatedElapsedMonths];
end;

class function TdxGanttControlDialogUtils.IsDurationEstimated(AFormat: TdxDurationFormat): Boolean;
begin
  Result := AFormat in [TdxDurationFormat.EstimatedMinutes, TdxDurationFormat.EstimatedElapsedMinutes,
    TdxDurationFormat.EstimatedHours, TdxDurationFormat.EstimatedElapsedHours,
    TdxDurationFormat.EstimatedDays, TdxDurationFormat.EstimatedElapsedDays,
    TdxDurationFormat.EstimatedWeeks, TdxDurationFormat.EstimatedElapsedWeeks,
    TdxDurationFormat.EstimatedMonths, TdxDurationFormat.EstimatedElapsedMonths];
end;

class procedure TdxGanttControlDialogUtils.PopulatePossibleDescriptions(ADurationEditHelper: TdxMeasurementUnitEditHelper; AEstimatedPresentToo: Boolean);

  procedure InternalAdd(const ADescription: string);
  begin
    ADurationEditHelper.AddPossibleDescription(ADescription);
    ADurationEditHelper.AddPossibleDescription(dxduElapsedTimePrefix + ADescription);
    if AEstimatedPresentToo then
    begin
      ADurationEditHelper.AddPossibleDescription(ADescription + dxduEstimatedTimePostfix);
      ADurationEditHelper.AddPossibleDescription(dxduElapsedTimePrefix + ADescription + dxduEstimatedTimePostfix);
    end;
  end;

begin
  InternalAdd(dxduMinuteExtraShort);
  InternalAdd(dxduMinute);
  InternalAdd(dxduMinutes);
  InternalAdd(dxduMinuteShort);
  InternalAdd(dxduMinutesShort);
  InternalAdd(dxduHourExtraShort);
  InternalAdd(dxduHour);
  InternalAdd(dxduHours);
  InternalAdd(dxduHourShort);
  InternalAdd(dxduHoursShort);
  InternalAdd(dxduDayExtraShort);
  InternalAdd(dxduDay);
  InternalAdd(dxduDays);
  InternalAdd(dxduWeekExtraShort);
  InternalAdd(dxduWeek);
  InternalAdd(dxduWeeks);
  InternalAdd(dxduWeekShort);
  InternalAdd(dxduWeeksShort);
  InternalAdd(dxduMonthExtraShort);
  InternalAdd(dxduMonth);
  InternalAdd(dxduMonths);
  InternalAdd(dxduMonthShort);
  InternalAdd(dxduMonthsShort);
end;

class procedure TdxGanttControlDialogUtils.SetControlsReadOnly(
  ALayoutControl: TdxCustomLayoutControl; AReadOnly: Boolean);

  procedure SetEnabledStateButtons(ALayoutGroup: TdxCustomLayoutGroup; AEnabled: Boolean);
  var
    I: Integer;
  begin
    for I := 0 to ALayoutGroup.Count - 1 do
    begin
      if ALayoutGroup.Items[I] is TdxCustomLayoutGroup then
        SetEnabledStateButtons(TdxCustomLayoutGroup(ALayoutGroup.Items[I]), AEnabled)
      else if ALayoutGroup.Items[I] is TdxCustomLayoutCheckableItem then
        ALayoutGroup.Items[I].Enabled := AEnabled;
    end;
  end;

var
  I: Integer;
  AEdit: TcxCustomEdit;
  AButton: TcxButton;
begin
  for I := 0 to ALayoutControl.ControlCount - 1 do
  begin
    if Safe.Cast(ALayoutControl.Controls[I], TcxCustomEdit, AEdit) then
      AEdit.ActiveProperties.ReadOnly := AReadOnly
    else if Safe.Cast(ALayoutControl.Controls[I], TcxButton, AButton) then
      if AButton.ModalResult <> mrCancel then
        AButton.Enabled := not AReadOnly;
  end;
  SetEnabledStateButtons(ALayoutControl.Items, not AReadOnly);
end;


initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  TdxGanttControlDialogUtils.InitializeDurationUnits;
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.
