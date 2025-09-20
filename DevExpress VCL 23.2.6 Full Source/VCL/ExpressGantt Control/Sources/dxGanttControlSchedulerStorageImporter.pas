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

unit dxGanttControlSchedulerStorageImporter;

{$I cxVer.inc}
{$I dxGanttControl.inc}

interface

uses
  System.UITypes, System.Contnrs,
  SysUtils, Generics.Defaults, Generics.Collections, Classes, Controls, Forms,
  cxClasses, dxCore, dxCoreClasses,
  cxSchedulerStorage, cxSchedulerRecurrence, dxGanttControlDataModel;

procedure dxGanttControlImportFromSchedulerStorage(AStorage: TcxCustomSchedulerStorage; ADataModel: TdxGanttControlDataModel);

implementation

uses
  RTLConsts, Math, Variants, cxDateUtils,
  dxGanttControlCustomDataModel, dxGanttControlCalendars, dxGanttControlResources, dxGanttControlTasks;

const
  dxThisUnitName = 'dxGanttControlSchedulerStorageImporter';

const
  dxSchedulerInfinityEquivalent = 30;

type
  TcxSchedulerEventAccess = class(TcxSchedulerEvent);
  TcxSchedulerStorageResourcesAccess = class(TcxSchedulerStorageResources);
  TcxCustomSchedulerStorageAccess = class(TcxCustomSchedulerStorage);

  { TdxSchedulerEventLink }

  TdxSchedulerEventLink = class
  private
    FEventFrom: TcxSchedulerEvent;
    FEventTo: TcxSchedulerEvent;
    FRelation: TcxSchedulerEventRelation;

    function GetPredecessorLinkType: TdxGanttControlTaskPredecessorLinkType;
  public
    constructor Create(AEventFrom, AEventTo: TcxSchedulerEvent; ARelation: TcxSchedulerEventRelation);

    property EventFrom: TcxSchedulerEvent read FEventFrom;
    property EventTo: TcxSchedulerEvent read FEventTo;
    property GanttControlTaskPredecessorLinkType: TdxGanttControlTaskPredecessorLinkType read GetPredecessorLinkType;
  end;

  { TdxSchedulerEventLinks }

  TdxSchedulerEventLinks = class(TcxObjectList)
  private
    function GetItem(Index: TdxListIndex): TdxSchedulerEventLink; inline;
  public
    property Items[Index: TdxListIndex]: TdxSchedulerEventLink read GetItem; default;
  end;

  { TdxSchedulerEventList }

  TdxSchedulerEventList = class(TcxObjectList)
  private
    function GetItem(Index: TdxListIndex): TcxSchedulerEvent; inline;
  public
    property Items[Index: TdxListIndex]: TcxSchedulerEvent read GetItem; default;
  end;

var
  dxResourceDictionary: TObjectDictionary<TcxSchedulerStorageResourceItem, TdxGanttControlResource>;

{ TdxSchedulerEventLink }

constructor TdxSchedulerEventLink.Create(AEventFrom, AEventTo: TcxSchedulerEvent; ARelation: TcxSchedulerEventRelation);
begin
  FEventFrom := AEventFrom;
  FEventTo := AEventTo;
  FRelation := ARelation;
end;

function TdxSchedulerEventLink.GetPredecessorLinkType: TdxGanttControlTaskPredecessorLinkType;
begin
  case FRelation of
    trFinishToStart:
      Result := TdxGanttControlTaskPredecessorLinkType.FS;
    trStartToStart:
      Result := TdxGanttControlTaskPredecessorLinkType.SS;
    trFinishToFinish:
      Result := TdxGanttControlTaskPredecessorLinkType.FF;
  else
    Result := TdxGanttControlTaskPredecessorLinkType.SF;
  end;
end;

{ TdxSchedulerEventLinks }

function TdxSchedulerEventLinks.GetItem(Index: TdxListIndex): TdxSchedulerEventLink;
begin
  Result := TdxSchedulerEventLink(inherited Items[Index]);
end;

{ TdxSchedulerEventList }

function TdxSchedulerEventList.GetItem(Index: TdxListIndex): TcxSchedulerEvent;
begin
  Result := TcxSchedulerEvent(inherited Items[Index]);
end;

function ConvertToGanttControlRecurrencePatternData(AEventRecurrenceInfo: TcxSchedulerEventRecurrenceInfo;
  ACalendar: Integer; ADuration: TDuration): TdxGanttControlRecurrencePatternData;

  procedure ConvertAsDaily;
  begin
    Result.&Type := TdxGanttControlRecurrenceType.Daily;
    Result.Interval := AEventRecurrenceInfo.Periodicity;
    if AEventRecurrenceInfo.DayType = cxdtWeekDay then
      Result.DayType := TdxGanttControlRecurrenceDayType.Workday
    else
      Result.DayType := TdxGanttControlRecurrenceDayType.Day;
  end;

  procedure ConvertAsWeekly;
  begin
    Result.&Type := TdxGanttControlRecurrenceType.Weekly;
    Result.Interval := AEventRecurrenceInfo.Periodicity;
    Result.Days := AEventRecurrenceInfo.OccurDays;
  end;

  function IsAbsolute: Boolean;
  begin
    Result := AEventRecurrenceInfo.DayType in [cxdtDay, cxdtEveryDay, cxdtWeekDay, cxdtWeekEndDay];
  end;

  procedure ConvertAsMonthlyOrYearly(AAsMonthly: Boolean);
  const
    ATypeMap: array[Boolean, Boolean] of TdxGanttControlRecurrenceType =
      ((TdxGanttControlRecurrenceType.RelativeYearly, TdxGanttControlRecurrenceType.AbsoluteYearly),
      (TdxGanttControlRecurrenceType.RelativeMonthly, TdxGanttControlRecurrenceType.AbsoluteMonthly));
  begin
    Result.&Type := ATypeMap[AAsMonthly, IsAbsolute];
    if AEventRecurrenceInfo.DayType in [cxdtDay, cxdtEveryDay] then
    begin
      Result.DayType := TdxGanttControlRecurrenceDayType.Day;
      if AEventRecurrenceInfo.DayType = cxdtDay then
        Result.DayOfMonth := AEventRecurrenceInfo.DayNumber
      else
        Result.DayOfMonth := IfThen(AEventRecurrenceInfo.DayNumber < 5, AEventRecurrenceInfo.DayNumber, 31);
      if AAsMonthly then
        Result.Interval := AEventRecurrenceInfo.Periodicity
      else
        Result.Month := AEventRecurrenceInfo.Periodicity;
    end
    else if AEventRecurrenceInfo.DayType in [cxdtSunday .. cxdtSaturday] then
    begin
      Result.Index := TdxGanttControlRecurrenceIndex(AEventRecurrenceInfo.DayNumber - 1);
      Result.DayType := TdxGanttControlRecurrenceDayType(Ord(AEventRecurrenceInfo.DayType) - Ord(cxdtSunday) + Ord(TdxGanttControlRecurrenceDayType.Sunday));
      if AAsMonthly then
        Result.Interval := AEventRecurrenceInfo.Periodicity
      else
        Result.Month := AEventRecurrenceInfo.Periodicity;
    end
    else
    if AEventRecurrenceInfo.DayType in [cxdtWeekDay, cxdtWeekEndDay] then
    begin
      Result.DayType := TdxGanttControlRecurrenceDayType.Day;
      if AAsMonthly then
        Result.Interval := AEventRecurrenceInfo.Periodicity
      else
        Result.Month := AEventRecurrenceInfo.Periodicity;
      Result.DayOfMonth := 0;  
    end;
  end;

begin
  case AEventRecurrenceInfo.Recurrence of
    cxreDaily:   ConvertAsDaily;
    cxreWeekly:  ConvertAsWeekly;
    cxreMonthly: ConvertAsMonthlyOrYearly(True);
  else
    ConvertAsMonthlyOrYearly(False);
  end;

  Result.Start := AEventRecurrenceInfo.Start;
  if AEventRecurrenceInfo.IsInfinity or (AEventRecurrenceInfo.Count > 0) then
  begin
    Result.FinishType := TdxGanttControlRecurrenceFinishType.Count;
    if AEventRecurrenceInfo.IsInfinity then
      Result.Count := dxSchedulerInfinityEquivalent
    else
      Result.Count := AEventRecurrenceInfo.Count;
  end
  else
  begin
    Result.FinishType := TdxGanttControlRecurrenceFinishType.Date;
    Result.Finish := Trunc(AEventRecurrenceInfo.Finish) + 1;
  end;

  Result.Duration := ADuration;
  Result.DurationFormat := TdxDurationFormat.ElapsedDays;
  Result.CalendarUID := ACalendar;

  Result.IsEmpty := False;
end;

procedure ImportResources(AStorage: TcxCustomSchedulerStorage; ADataModel: TdxGanttControlDataModel);
var
  I: Integer;
  AResource: TcxSchedulerStorageResourceItem;
  AGanttResource: TdxGanttControlResource;
begin
  for I := 0 to AStorage.ResourceCount - 1 do
  begin
    AResource := AStorage.Resources.ResourceItems[I];
    AGanttResource := ADataModel.Resources.Append;
    dxResourceDictionary.AddOrSetValue(AResource, AGanttResource);
    AGanttResource.Name := AResource.Name;
    AGanttResource.Inactive := not AResource.Visible;
    AGanttResource.Start := AResource.WorkStart;
    AGanttResource.Finish := AResource.WorkFinish;
  end;
end;

procedure AssignTaskResource(ATaskUID, AResourceUID: Integer; ADataModel: TdxGanttControlDataModel);
begin
  with ADataModel.Assignments.Append do
  begin
    TaskUID := ATaskUID;
    ResourceUID := AResourceUID;
  end;
end;

procedure SetTasksPredecessorLinks(ALinks: TdxSchedulerEventLinks;
  AEventToTaskDictionary: TObjectDictionary<TcxSchedulerEvent, TdxGanttControlTask>);
var
  I: Integer;
  AEventLink: TdxSchedulerEventLink;
  ATask, APredecessor: TdxGanttControlTask;
begin
  for I := 0 to ALinks.Count - 1 do
  begin
    AEventLink := ALinks[I];
    if AEventToTaskDictionary.TryGetValue(AEventLink.EventTo, ATask) and
       AEventToTaskDictionary.TryGetValue(AEventLink.EventFrom, APredecessor) then
      with ATask.PredecessorLinks.Append do
      begin
        PredecessorUID := APredecessor.UID;
        &Type := AEventLink.GanttControlTaskPredecessorLinkType;
        LinkLag := 0;
        LagFormat := TdxGanttControlTaskPredecessorLagFormat.Days;
      end;
  end;
end;

function IsAllOutlineLevelsAssigned(ATasks: TdxGanttControlTasks): Boolean;
var
  I: Integer;
begin
  Result := True;
  for I := 0 to ATasks.Count - 1 do
    if not ATasks[I].IsValueAssigned(TdxGanttTaskAssignedValue.OutlineLevel) then
      Exit(False);
end;

procedure SetOutlineLevel(ATasks: TdxGanttControlTasks;
  AEventToTaskDictionary: TObjectDictionary<TcxSchedulerEvent, TdxGanttControlTask>;
  ATaskToEventDictionary: TObjectDictionary<TdxGanttControlTask, TcxSchedulerEvent>;
  ATaskToPatternTaskDictionary: TObjectDictionary<TdxGanttControlTask, TdxGanttControlTask>);
var
  I: Integer;
  ATask, AParentTask: TdxGanttControlTask;
  AEvent: TcxSchedulerEvent;
begin
  while not IsAllOutlineLevelsAssigned(ATasks) do
    for I := 0 to ATasks.Count - 1 do
    begin
      ATask := ATasks[I];
      if not ATask.IsValueAssigned(TdxGanttTaskAssignedValue.OutlineLevel) then
        if ATaskToEventDictionary.TryGetValue(ATask, AEvent) then
        begin
          if AEvent.ParentGroup = nil then
            ATask.OutlineLevel := 1
          else
            if AEventToTaskDictionary.TryGetValue(AEvent.ParentGroup, AParentTask) and
               AParentTask.IsValueAssigned(TdxGanttTaskAssignedValue.OutlineLevel) then
              ATask.OutlineLevel := AParentTask.OutlineLevel + 1;
        end
        else
        if ATaskToPatternTaskDictionary.TryGetValue(ATask, AParentTask) then
          ATask.OutlineLevel := AParentTask.OutlineLevel + 1;
    end;
end;

procedure SetConstraints(ATasks: TdxGanttControlTasks; AStorage: TcxCustomSchedulerStorage;
  ATaskToEventDictionary: TObjectDictionary<TdxGanttControlTask, TcxSchedulerEvent>);
var
  I: Integer;
  ATask: TdxGanttControlTask;
  AEvent: TcxSchedulerEvent;
  AValue: Variant;
  AMinStart: TDateTime;
begin
  AMinStart := ATasks[0].Start;
  for I := 0 to ATasks.Count - 1 do
  begin
    ATask := ATasks[I];
    if ATask.Summary then
      Continue;
    if not ATaskToEventDictionary.TryGetValue(ATask, AEvent) then
      Continue;
    AValue := TcxSchedulerEventAccess(AEvent).GetValueDefault(TcxCustomSchedulerStorageAccess(AStorage).FStartField, Null);
    if VarIsNull(AValue) then
      Continue;
    if (AEvent.Start <> VarToDateTime(AValue)) or (AEvent.Start > AMinStart) then
    begin
      ATask.ConstraintType := TdxGanttControlTaskConstraintType.StartNoEarlierThan;
      ATask.ConstraintDate := AValue;
    end;
  end;
end;


procedure ImportEvents(AStorage: TcxCustomSchedulerStorage; ADataModel: TdxGanttControlDataModel);
var
  AEventToTaskDictionary: TObjectDictionary<TcxSchedulerEvent, TdxGanttControlTask>;
  ATaskToEventDictionary: TObjectDictionary<TdxGanttControlTask, TcxSchedulerEvent>;
  ATaskToPatternTaskDictionary: TObjectDictionary<TdxGanttControlTask, TdxGanttControlTask>;
  AExceptionEventsDictionary: TObjectDictionary<TcxSchedulerEvent, TdxSchedulerEventList>;
  ACustomEventsDictionary: TObjectDictionary<TcxSchedulerEvent, TdxSchedulerEventList>;
  ALinks: TdxSchedulerEventLinks;
  AEventList: TdxSchedulerEventList;
  AExceptionOrCustomEvents: TcxObjectList;

  procedure CreateDictionaries;
  begin
    AEventToTaskDictionary := TObjectDictionary<TcxSchedulerEvent, TdxGanttControlTask>.Create([]);
    ATaskToEventDictionary := TObjectDictionary<TdxGanttControlTask, TcxSchedulerEvent>.Create([]);
    ATaskToPatternTaskDictionary := TObjectDictionary<TdxGanttControlTask, TdxGanttControlTask>.Create([]);
    AExceptionEventsDictionary := TObjectDictionary<TcxSchedulerEvent, TdxSchedulerEventList>.Create([]);
    ACustomEventsDictionary := TObjectDictionary<TcxSchedulerEvent, TdxSchedulerEventList>.Create([]);
  end;

  procedure DestroyDictionaries;
  begin
    AExceptionEventsDictionary.Free;
    ACustomEventsDictionary.Free;
    ATaskToPatternTaskDictionary.Free;
    AEventToTaskDictionary.Free;
    ATaskToEventDictionary.Free;
  end;

  procedure PopulateExceptionOrCustomEvents;
  var
    I: Integer;
    AEvent: TcxSchedulerEvent;
  begin
    for I := 0 to AStorage.EventCount - 1 do
    begin
      AEvent := AStorage.Events[I];
      if AEvent.EventType = etException then
      begin
        if not AExceptionEventsDictionary.TryGetValue(AEvent.Pattern, AEventList) then
        begin
          AEventList := TdxSchedulerEventList.Create(False);
          AExceptionOrCustomEvents.Add(AEventList);
        end;
        AEventList.Add(AEvent);
        AExceptionEventsDictionary.AddOrSetValue(AEvent.Pattern, AEventList);
      end;
      if AEvent.EventType = etCustom then
      begin
        if not ACustomEventsDictionary.TryGetValue(AEvent.Pattern, AEventList) then
        begin
          AEventList := TdxSchedulerEventList.Create(False);
          AExceptionOrCustomEvents.Add(AEventList);
        end;
        AEventList.Add(AEvent);
        ACustomEventsDictionary.AddOrSetValue(AEvent.Pattern, AEventList);
      end;
    end;
  end;

  function HasExceptionEvent(APattern: TcxSchedulerEvent; AStart: TDateTime): Boolean;
  var
    AEventList: TdxSchedulerEventList;
    I: Integer;
  begin
    Result := False;
    AStart := Trunc(AStart);
    if AExceptionEventsDictionary.TryGetValue(APattern, AEventList) then
      for I := 0 to AEventList.Count - 1 do
      begin
        Result := Trunc(AEventList[I].Start) = AStart;
        if Result then
          Break;
      end;
  end;

  function FindCustomEvent(APattern: TcxSchedulerEvent; const AEventStart: TDateTime): TcxSchedulerEvent;
  var
    ADayStart: Int64;
    AEventList: TdxSchedulerEventList;
    I: Integer;
  begin
    Result := nil;
    ADayStart := Trunc(AEventStart);
    if ACustomEventsDictionary.TryGetValue(APattern, AEventList) then
      for I := 0 to AEventList.Count - 1 do
        if Trunc(AEventList[I].Start) = ADayStart then
        begin
          Result := AEventList[I];
          Break;
        end;
  end;

var
  I, J, N: Integer;
  AEvent, ACustomEvent: TcxSchedulerEvent;
  ATask, APatternTask: TdxGanttControlTask;
  AMinStart, AMaxFinish: TDateTime;
  AGanttResource: TdxGanttControlResource;
  ACalendar: TdxGanttControlCalendar;
  ACalculator: TcxSchedulerOccurrenceCalculator;
  ADuration: TDuration;
begin
  ACalendar := ADataModel.Calendars.GetCalendarByUID(ADataModel.Properties.CalendarUID);
  CreateDictionaries;
  AExceptionOrCustomEvents := TcxObjectList.Create(True);
  try
    ALinks := TdxSchedulerEventLinks.Create(True);
    try
      AMinStart := MaxDateTime;
      AMaxFinish := MinDateTime;
      PopulateExceptionOrCustomEvents;
      for I := 0 to AStorage.EventCount - 1 do
      begin
        AEvent := AStorage.Events[I];
        if AEvent.EventType in [etNone, etPattern] then
        begin
          ATask := ADataModel.Tasks.Append;
          AEventToTaskDictionary.AddOrSetValue(AEvent, ATask);
          ATaskToEventDictionary.AddOrSetValue(ATask, AEvent);
          ATask.Name := AEvent.Caption;
          ATask.Start := AEvent.Start;
          AMinStart := Min(AMinStart, AEvent.Start);
          ATask.Finish := AEvent.Finish;
          AMaxFinish := Max(AMaxFinish, AEvent.Finish);
          ATask.CalendarUID := ACalendar.UID;
          ADuration := TdxGanttControlDuration.Create(ATask.Start, ATask.Finish, ACalendar).ToString;
          if AEvent.EventType <> etPattern then
            ATask.Duration := ADuration;
          ATask.DurationFormat := TdxDurationFormat.ElapsedDays;
          ATask.PercentComplete := AEvent.TaskComplete;
          ATask.Milestone := AEvent.Duration = 0;
          ATask.Recurring := AEvent.IsRecurring;
          ATask.Summary := AEvent.IsGroup or (AEvent.EventType = etPattern);
          ATask.Created := Now;
          for J := 0 to AEvent.ResourceIDCount - 1  do
            if dxResourceDictionary.TryGetValue(
               TcxSchedulerStorageResourcesAccess(AStorage.Resources).GetResourceItemByID(AEvent.ResourceIDs[J]), AGanttResource) then
              AssignTaskResource(ATask.UID, AGanttResource.UID, ADataModel);
          for J := 0 to AEvent.TaskLinks.Count - 1 do
            ALinks.Add(TdxSchedulerEventLink.Create(AEvent, AEvent.TaskLinks[J].Link, AEvent.TaskLinks[J].Relation));

          if AEvent.EventType = etPattern then
          begin
            APatternTask := ATask;
            APatternTask.RecurrencePattern.SetData(ConvertToGanttControlRecurrencePatternData(AEvent.RecurrenceInfo,
              APatternTask.CalendarUID, ADuration));
            ACalculator := TcxSchedulerOccurrenceCalculator.Create(AEvent, 0, cxMaxDate);
            try
              N := 1;
              while (not AEvent.RecurrenceInfo.IsInfinity and ACalculator.GetNextOccurrence) or
                    (AEvent.RecurrenceInfo.IsInfinity and ACalculator.GetNextOccurrence and (N <= dxSchedulerInfinityEquivalent)) do
              begin
                if HasExceptionEvent(AEvent, ACalculator.OccurrenceStart) then
                  Continue;
                ACustomEvent := FindCustomEvent(AEvent, ACalculator.OccurrenceStart);
                ATask := ADataModel.Tasks.Append;
                ATask.Name := Format('%s %d', [AEvent.Caption, N]);
                if ACustomEvent <> nil then
                begin
                  if ACustomEvent.Caption <> AEvent.Caption then
                    ATask.Name := ACustomEvent.Caption;
                  ATask.Start := ACustomEvent.Start;
                  ATask.Finish := ACustomEvent.Finish;
                end
                else
                begin
                  ATask.Start := ACalculator.OccurrenceStart;
                  ATask.Finish := ACalculator.OccurrenceFinish;
                end;
                ATask.CalendarUID := ACalendar.UID;
                ATask.Recurring := True;
                ATask.Duration := TdxGanttControlDuration.Create(ATask.Start, ATask.Finish, ACalendar).ToString;
                ATask.DurationFormat := TdxDurationFormat.ElapsedDays;
                ATaskToPatternTaskDictionary.AddOrSetValue(ATask, APatternTask);
                Inc(N);
              end;
            finally
              ACalculator.Free;
            end;
            APatternTask.Finish := ATask.Finish;
          end;

        end;
      end;
      SetTasksPredecessorLinks(ALinks, AEventToTaskDictionary);
      SetOutlineLevel(ADataModel.Tasks, AEventToTaskDictionary, ATaskToEventDictionary, ATaskToPatternTaskDictionary);
      ADataModel.Tasks[0].Start := AMinStart;
      ADataModel.Tasks[0].Finish := AMaxFinish;
      SetConstraints(ADataModel.Tasks, AStorage, ATaskToEventDictionary);
    finally
      ALinks.Free;
    end;
  finally
    DestroyDictionaries;
    AExceptionOrCustomEvents.Free;
  end;
end;

procedure dxGanttControlImportFromSchedulerStorage(AStorage: TcxCustomSchedulerStorage; ADataModel: TdxGanttControlDataModel);
var
  APreviousCursor: TCursor;
begin
  APreviousCursor := Screen.Cursor;
  ADataModel.Reset;
  dxResourceDictionary := TObjectDictionary<TcxSchedulerStorageResourceItem, TdxGanttControlResource>.Create;
  ADataModel.BeginUpdate;
  try
    Screen.Cursor := crHourGlass;
    ImportResources(AStorage, ADataModel);
    ADataModel.Properties.CalendarUID := ADataModel.Calendars.Create24HoursCalendar.UID;
    ImportEvents(AStorage, ADataModel);
  finally
    dxResourceDictionary.Free;
    ADataModel.EndUpdate;
  end;
  Screen.Cursor := APreviousCursor;
end;

end.
