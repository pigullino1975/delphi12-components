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

unit dxGanttControlDataModel;

{$I cxVer.inc}
{$I dxGanttControl.inc}

interface

uses
  System.UITypes, System.Contnrs,
  SysUtils, Generics.Defaults, Generics.Collections, Classes,
  dxCore, dxCoreClasses, cxDateUtils,
  dxGanttControlCustomClasses,
  dxGanttControlCustomDataModel,
  dxGanttControlCalendars,
  dxGanttControlResources,
  dxGanttControlOutlineCodes,
  dxGanttControlExtendedAttributes,
  dxGanttControlAssignments,
  dxGanttControlTasks;

type
  TdxGanttControlDataModel = class;

  { TdxGanttControlDataModelProperties }

  TdxGanttControlCurrencyDigits = (NoDigits, OneDigit, TwoDigits);
  TdxGanttControlCurrencySymbolPosition = (Before, After, BeforeWithSpace, AfterWithSpace);
  TdxGanttControlFixedCostAccrual = (Start = 1, Prorated, &End);
  TdxGanttControlNewTaskStartDate = (ProjectStartDate, CurrentDate);
  TdxGanttControlWorkFormat = (Minutes = 1, Hours, Days, Weeks, Months, Years);

  TdxGanttPropertiesAssignedValue = (ActualsInSync, AdminProject, Author, AutoAddNewResourcesAndTasks, Autolink,
    BaselineForEarnedValue, CalendarUID, Category, Company, CriticalSlackLimit,
    CurrencyCode, CurrencyDigits, CurrencySymbol, CurrencySymbolPosition, DaysPerMonth, DefaultFinishTime,
    DefaultFixedCostAccrual, DefaultOvertimeRate, DefaultStandardRate, DefaultStartTime,
    DefaultTaskEVMethod, DefaultTaskType, DurationFormat, EarnedValueMethod, EditableActualCosts, ExtendedCreationDate,
    ProjectFinish, FiscalYearStart, FYStartDate, GUID, HonorConstraints, InsertedProjectsLikeSummary, LastSaved, Manager,
    MicrosoftProjectServerURL, MinutesPerDay, MinutesPerWeek, MoveCompletedEndsBack, MoveCompletedEndsForward,
    MoveRemainingStartsBack, MoveRemainingStartsForward, MultipleCriticalPaths, Name,
    NewTasksEffortDriven, NewTasksEstimated, NewTaskStartDate,
    RemoveFileProperties, Revision, ScheduleFromStart, SplitsInProgressTasks, SpreadActualCost, SpreadPercentComplete,
    ProjectStart, StatusDate, Subject, TaskUpdatesResource, Title, WeekStartDay, WorkFormat,
    UpdateManuallyScheduledTasksWhenEditingLinks, KeepTaskOnNearestWorkingTimeWhenMadeAutoScheduled);

  TdxGanttPropertiesAssignedValues = set of TdxGanttPropertiesAssignedValue;

  TdxGanttControlDataModelProperties = class(TdxGanttControlModelElement)
  public const
    MinutesPerWorkday = 480;
  strict private
    FAssignedValues: TdxGanttPropertiesAssignedValues;
    FActualsInSync: Boolean;
    FAdminProject: Boolean;
    FAuthor: string;
    FAutoAddNewResourcesAndTasks: Boolean;
    FAutolink: Boolean;
    FBaselineForEarnedValue: Integer;
    FCalendarUID: Integer;
    FCategory: string;
    FCompany: string;
    FProjectCreated: TDateTime;
    FCriticalSlackLimit: Integer;
    FCurrencyCode: string;
    FCurrencyDigits: TdxGanttControlCurrencyDigits;
    FCurrencySymbol: string;
    FCurrencySymbolPosition: TdxGanttControlCurrencySymbolPosition;
    FDaysPerMonth: Integer;
    FDefaultFinishTime: TTime;
    FDefaultFixedCostAccrual: TdxGanttControlFixedCostAccrual;
    FDefaultOvertimeRate: Double;
    FDefaultStandardRate: Double;
    FDefaultStartTime: TTime;
    FDefaultTaskEVMethod: TdxGanttControlTaskEarnedValueMethod;
    FDefaultTaskType: TdxGanttControlTaskType;
    FDurationFormat: TdxDurationFormat;
    FEarnedValueMethod: TdxGanttControlTaskEarnedValueMethod;
    FEditableActualCosts: Boolean;
    FExtendedCreationDate: TDateTime;
    FProjectFinish: TDateTime;
    FFiscalYearStart: Boolean;
    FFYStartDate: TdxGanttControlCalendarMonth;
    FGUID: string;
    FHonorConstraints: Boolean;
    FInsertedProjectsLikeSummary: Boolean;
    FKeepTaskOnNearestWorkingTimeWhenMadeAutoScheduled: Boolean;
    FLastSaved: TDateTime;
    FManager: string;
    FMicrosoftProjectServerURL: Boolean;
    FMinutesPerDay: Integer;
    FMinutesPerWeek: Integer;
    FMoveCompletedEndsBack: Boolean;
    FMoveCompletedEndsForward: Boolean;
    FMoveRemainingStartsBack: Boolean;
    FMoveRemainingStartsForward: Boolean;
    FMultipleCriticalPaths: Boolean;
    FName: string;
    FMarkNewTasksAsManuallyScheduled: Boolean;
    FNewTasksEffortDriven: Boolean;
    FNewTasksEstimated: Boolean;
    FNewTaskStartDate: TdxGanttControlNewTaskStartDate;
    FRemoveFileProperties: Boolean;
    FRevision: Integer;
    FScheduleFromStart: Boolean;
    FSplitsInProgressTasks: Boolean;
    FSpreadActualCost: Boolean;
    FSpreadPercentComplete: Boolean;
    FProjectStart: TDateTime;
    FStatusDate: TDateTime;
    FSubject: string;
    FTaskUpdatesResource: Boolean;
    FUpdateManuallyScheduledTasksWhenEditingLinks: Boolean;
    FTitle: string;
    FWeekStartDay: TDay;
    FWorkFormat: TdxGanttControlWorkFormat;

    procedure SetActualsInSync(const Value: Boolean);
    procedure SetAdminProject(const Value: Boolean);
    procedure SetAuthor(const Value: string);
    procedure SetAutoAddNewResourcesAndTasks(const Value: Boolean);
    procedure SetAutolink(const Value: Boolean);
    procedure SetBaselineForEarnedValue(const Value: Integer);
    procedure SetCalendarUID(const Value: Integer);
    procedure SetCategory(const Value: string);
    procedure SetCompany(const Value: string);
    procedure SetProjectCreated(const Value: TDateTime);
    procedure SetCriticalSlackLimit(const Value: Integer);
    procedure SetCurrencyCode(const Value: string);
    procedure SetCurrencyDigits(const Value: TdxGanttControlCurrencyDigits);
    procedure SetCurrencySymbol(const Value: string);
    procedure SetCurrencySymbolPosition(const Value: TdxGanttControlCurrencySymbolPosition);
    procedure SetDaysPerMonth(const Value: Integer);
    procedure SetDefaultFinishTime(const Value: TTime);
    procedure SetDefaultFixedCostAccrual(const Value: TdxGanttControlFixedCostAccrual);
    procedure SetDefaultOvertimeRate(const Value: Double);
    procedure SetDefaultStandardRate(const Value: Double);
    procedure SetDefaultStartTime(const Value: TTime);
    procedure SetDefaultTaskEVMethod(const Value: TdxGanttControlTaskEarnedValueMethod);
    procedure SetDefaultTaskType(const Value: TdxGanttControlTaskType);
    procedure SetDurationFormat(const Value: TdxDurationFormat);
    procedure SetEarnedValueMethod(const Value: TdxGanttControlTaskEarnedValueMethod);
    procedure SetEditableActualCosts(const Value: Boolean);
    procedure SetExtendedCreationDate(const Value: TDateTime);
    procedure SetProjectFinish(const Value: TDateTime);
    procedure SetFiscalYearStart(const Value: Boolean);
    procedure SetFYStartDate(const Value: TdxGanttControlCalendarMonth);
    procedure SetGUID(const Value: string);
    procedure SetHonorConstraints(const Value: Boolean);
    procedure SetInsertedProjectsLikeSummary(const Value: Boolean);
    procedure SetKeepTaskOnNearestWorkingTimeWhenMadeAutoScheduled(const Value: Boolean);
    procedure SetLastSaved(const Value: TDateTime);
    procedure SetManager(const Value: string);
    procedure SetMicrosoftProjectServerURL(const Value: Boolean);
    procedure SetMinutesPerDay(const Value: Integer);
    procedure SetMinutesPerWeek(const Value: Integer);
    procedure SetMoveCompletedEndsBack(const Value: Boolean);
    procedure SetMoveCompletedEndsForward(const Value: Boolean);
    procedure SetMoveRemainingStartsBack(const Value: Boolean);
    procedure SetMoveRemainingStartsForward(const Value: Boolean);
    procedure SetMultipleCriticalPaths(const Value: Boolean);
    procedure SetName(const Value: string);
    procedure SetMarkNewTasksAsManuallyScheduled(const Value: Boolean);
    procedure SetNewTasksEffortDriven(const Value: Boolean);
    procedure SetNewTasksEstimated(const Value: Boolean);
    procedure SetNewTaskStartDate(const Value: TdxGanttControlNewTaskStartDate);
    procedure SetRemoveFileProperties(const Value: Boolean);
    procedure SetRevision(const Value: Integer);
    procedure SetScheduleFromStart(const Value: Boolean);
    procedure SetSplitsInProgressTasks(const Value: Boolean);
    procedure SetSpreadActualCost(const Value: Boolean);
    procedure SetSpreadPercentComplete(const Value: Boolean);
    procedure SetProjectStart(const Value: TDateTime);
    procedure SetStatusDate(const Value: TDateTime);
    procedure SetSubject(const Value: string);
    procedure SetTaskUpdatesResource(const Value: Boolean);
    procedure SetTitle(const Value: string);
    procedure SetWeekStartDay(const Value: TDay);
    procedure SetWorkFormat(const Value: TdxGanttControlWorkFormat);
    procedure SetUpdateManuallyScheduledTasksWhenEditingLinks(const Value: Boolean);
  protected
    procedure DoAssign(Source: TPersistent); override;
    procedure DoChanged; override;
    procedure DoReset; override;

    function GetActualDurationFormat: TdxDurationFormat;
  public
  {$REGION 'for internal use'}
    function IsValueAssigned(const AValue: TdxGanttPropertiesAssignedValue): Boolean;
    procedure ResetValue(const AValue: TdxGanttPropertiesAssignedValue); overload;
  {$ENDREGION 'for internal use'}

    property CalendarUID: Integer read FCalendarUID write SetCalendarUID;
    property DurationFormat: TdxDurationFormat read FDurationFormat write SetDurationFormat;
    property MarkNewTasksAsManuallyScheduled: Boolean read FMarkNewTasksAsManuallyScheduled write SetMarkNewTasksAsManuallyScheduled;
    property ProjectCreated: TDateTime read FProjectCreated write SetProjectCreated;
    property ProjectFinish: TDateTime read FProjectFinish write SetProjectFinish;
    property ProjectStart: TDateTime read FProjectStart write SetProjectStart;
    property WeekStartDay: TDay read FWeekStartDay write SetWeekStartDay;
  {$REGION 'for internal use'}
    property ActualsInSync: Boolean read FActualsInSync write SetActualsInSync;
    property AdminProject: Boolean read FAdminProject write SetAdminProject;
    property Author: string read FAuthor write SetAuthor;
    property AutoAddNewResourcesAndTasks: Boolean read FAutoAddNewResourcesAndTasks write SetAutoAddNewResourcesAndTasks;
    property Autolink: Boolean read FAutolink write SetAutolink;
    property BaselineForEarnedValue: Integer read FBaselineForEarnedValue write SetBaselineForEarnedValue;
    property Category: string read FCategory write SetCategory;
    property Company: string read FCompany write SetCompany;
    property CriticalSlackLimit: Integer read FCriticalSlackLimit write SetCriticalSlackLimit;
    property CurrencyCode: string read FCurrencyCode write SetCurrencyCode;
    property CurrencyDigits: TdxGanttControlCurrencyDigits read FCurrencyDigits write SetCurrencyDigits;
    property CurrencySymbol: string read FCurrencySymbol write SetCurrencySymbol;
    property CurrencySymbolPosition: TdxGanttControlCurrencySymbolPosition read FCurrencySymbolPosition write SetCurrencySymbolPosition;
    property DaysPerMonth: Integer read FDaysPerMonth write SetDaysPerMonth;
    property DefaultFinishTime: TTime read FDefaultFinishTime write SetDefaultFinishTime;
    property DefaultFixedCostAccrual: TdxGanttControlFixedCostAccrual read FDefaultFixedCostAccrual write SetDefaultFixedCostAccrual;
    property DefaultOvertimeRate: Double read FDefaultOvertimeRate write SetDefaultOvertimeRate;
    property DefaultStandardRate: Double read FDefaultStandardRate write SetDefaultStandardRate;
    property DefaultStartTime: TTime read FDefaultStartTime write SetDefaultStartTime;
    property DefaultTaskEVMethod: TdxGanttControlTaskEarnedValueMethod read FDefaultTaskEVMethod write SetDefaultTaskEVMethod;
    property DefaultTaskType: TdxGanttControlTaskType read FDefaultTaskType write SetDefaultTaskType;
    property EarnedValueMethod: TdxGanttControlTaskEarnedValueMethod read FEarnedValueMethod write SetEarnedValueMethod;
    property EditableActualCosts: Boolean read FEditableActualCosts write SetEditableActualCosts;
    property ExtendedCreationDate: TDateTime read FExtendedCreationDate write SetExtendedCreationDate;
    property FiscalYearStart: Boolean read FFiscalYearStart write SetFiscalYearStart;
    property FYStartDate: TdxGanttControlCalendarMonth read FFYStartDate write SetFYStartDate;
    property GUID: string read FGUID write SetGUID;
    property HonorConstraints: Boolean read FHonorConstraints write SetHonorConstraints;
    property InsertedProjectsLikeSummary: Boolean read FInsertedProjectsLikeSummary write SetInsertedProjectsLikeSummary;
    property KeepTaskOnNearestWorkingTimeWhenMadeAutoScheduled: Boolean
      read FKeepTaskOnNearestWorkingTimeWhenMadeAutoScheduled write SetKeepTaskOnNearestWorkingTimeWhenMadeAutoScheduled;
    property LastSaved: TDateTime read FLastSaved write SetLastSaved;
    property Manager: string read FManager write SetManager;
    property MicrosoftProjectServerURL: Boolean read FMicrosoftProjectServerURL write SetMicrosoftProjectServerURL;
    property MinutesPerDay: Integer read FMinutesPerDay write SetMinutesPerDay;
    property MinutesPerWeek: Integer read FMinutesPerWeek write SetMinutesPerWeek;
    property MoveCompletedEndsBack: Boolean read FMoveCompletedEndsBack write SetMoveCompletedEndsBack;
    property MoveCompletedEndsForward: Boolean read FMoveCompletedEndsForward write SetMoveCompletedEndsForward;
    property MoveRemainingStartsBack: Boolean read FMoveRemainingStartsBack write SetMoveRemainingStartsBack;
    property MoveRemainingStartsForward: Boolean read FMoveRemainingStartsForward write SetMoveRemainingStartsForward;
    property MultipleCriticalPaths: Boolean read FMultipleCriticalPaths write SetMultipleCriticalPaths;
    property Name: string read FName write SetName;
    property NewTasksEffortDriven: Boolean read FNewTasksEffortDriven write SetNewTasksEffortDriven;
    property NewTasksEstimated: Boolean read FNewTasksEstimated write SetNewTasksEstimated;
    property NewTaskStartDate: TdxGanttControlNewTaskStartDate read FNewTaskStartDate write SetNewTaskStartDate;
    property RemoveFileProperties: Boolean read FRemoveFileProperties write SetRemoveFileProperties;
    property Revision: Integer read FRevision write SetRevision;
    property ScheduleFromStart: Boolean read FScheduleFromStart write SetScheduleFromStart;
    property SplitsInProgressTasks: Boolean read FSplitsInProgressTasks write SetSplitsInProgressTasks;
    property SpreadActualCost: Boolean read FSpreadActualCost write SetSpreadActualCost;
    property SpreadPercentComplete: Boolean read FSpreadPercentComplete write SetSpreadPercentComplete;
    property StatusDate: TDateTime read FStatusDate write SetStatusDate;
    property Subject: string read FSubject write SetSubject;
    property TaskUpdatesResource: Boolean read FTaskUpdatesResource write SetTaskUpdatesResource;
    property UpdateManuallyScheduledTasksWhenEditingLinks: Boolean
      read FUpdateManuallyScheduledTasksWhenEditingLinks write SetUpdateManuallyScheduledTasksWhenEditingLinks;
    property Title: string read FTitle write SetTitle;
    property WorkFormat: TdxGanttControlWorkFormat read FWorkFormat write SetWorkFormat;
  {$ENDREGION}
  end;

  { TdxGanttControlDataModelBaseline }

  TdxGanttControlDataModelBaseline = class(TdxGanttControlCustomBaseline)
  strict private
    FCreated: TDateTime;
    FDescription: string;
    procedure SetDescription(const Value: string);
  protected
    procedure SetCreated(const Value: TDateTime);
    procedure DoAssign(Source: TPersistent); override;
    procedure DoAssignCurrentValues(Source: TPersistent); override;
    procedure DoDelete; override;
    procedure DoReset; override;
  public
    property Created: TDateTime read FCreated;
    property Description: string read FDescription write SetDescription;
  end;

  { TdxGanttControlDataModelBaselines }

  TdxGanttControlDataModelBaselines = class(TdxGanttControlCustomBaselines)
  private
    function GetItem(Index: Integer): TdxGanttControlDataModelBaseline;
  protected
    function CreateItem: TdxGanttControlModelElementListItem; override;
    procedure DoItemChanged(AItem: TdxGanttControlModelElementListItem); override;
  public
    function Add(ANumber: Integer): TdxGanttControlDataModelBaseline; reintroduce;
    function Find(ANumber: Integer): TdxGanttControlDataModelBaseline; reintroduce;

    property Items[Index: Integer]: TdxGanttControlDataModelBaseline read GetItem; default;
  end;

  { TdxGanttControlDataModel }

  TdxGanttAssignmentChangedEvent = procedure(Sender: TdxGanttControlDataModel; AAssignment: TdxGanttControlAssignment) of object;
  TdxGanttAssignmentChangedHandlers = TdxMulticastMethod<TdxGanttAssignmentChangedEvent>;
  TdxGanttBaselineChangedEvent = procedure(Sender: TdxGanttControlDataModel; ABaseline: TdxGanttControlDataModelBaseline) of object;
  TdxGanttBaselineChangedHandlers = TdxMulticastMethod<TdxGanttBaselineChangedEvent>;
  TdxGanttResourceChangedEvent = procedure(Sender: TdxGanttControlDataModel; AResource: TdxGanttControlResource) of object;
  TdxGanttResourceChangedHandlers = TdxMulticastMethod<TdxGanttResourceChangedEvent>;
  TdxGanttTaskChangedEvent = procedure(Sender: TdxGanttControlDataModel; ATask: TdxGanttControlTask) of object;
  TdxGanttTaskChangedHandlers = TdxMulticastMethod<TdxGanttTaskChangedEvent>;
  TdxGanttCalendarChangedEvent = procedure(Sender: TdxGanttControlDataModel; ACalendar: TdxGanttControlCalendar) of object;
  TdxGanttCalendarChangedHandlers = TdxMulticastMethod<TdxGanttCalendarChangedEvent>;

  TdxGanttControlDataModelChangedType = (Assignment, Resource, Task, Calendar, Baseline);
  TdxGanttControlDataModelChangedTypes = set of TdxGanttControlDataModelChangedType;

  TdxGanttControlDataModel = class(TdxGanttControlCustomDataModel)
  public const
    DefaultTaskDuration: string = 'PT8H0M0S';
    MinDate = 30682; 
  strict private
    FAssignments: TdxGanttControlAssignments;
    FBaselines: TdxGanttControlDataModelBaselines;
    FCalendars: TdxGanttControlCalendars;
    FExtendedAttributes: TdxGanttControlExtendedAttributes;
    FOutlineCodes: TdxGanttControlOutlineCodes;
    FProperties: TdxGanttControlDataModelProperties;
    FResources: TdxGanttControlResources;
    FTasks: TdxGanttControlTasks;
    FWBSMasks: TdxGanttControlWBSMasks;

    FChangedTypes: TdxGanttControlDataModelChangedTypes;

    FAssignmentChangedHandlers: TdxGanttAssignmentChangedHandlers;
    FBaselineChangedHandlers: TdxGanttBaselineChangedHandlers;
    FCalendarChangedHandlers: TdxGanttCalendarChangedHandlers;
    FLoadedHandlers: TdxNotifyEventHandler;
    FPropertiesChangedHandlers: TdxNotifyEventHandler;
    FResourceChangedHandlers: TdxGanttResourceChangedHandlers;
    FTaskChangedHandlers: TdxGanttTaskChangedHandlers;
    function GetActiveCalendar: TdxGanttControlCalendar; inline;
    function GetRealProjectFinish: TDateTime;
    function GetRealProjectStart: TDateTime;
  protected
    function CreateAssignments: TdxGanttControlAssignments; virtual;
    function CreateBaselines: TdxGanttControlDataModelBaselines; virtual;
    function CreateCalendars: TdxGanttControlCalendars; virtual;
    function CreateExtendedAttributes: TdxGanttControlExtendedAttributes; virtual;
    function CreateOutlineCodes: TdxGanttControlOutlineCodes; virtual;
    function CreateProperties: TdxGanttControlDataModelProperties; virtual;
    function CreateResources: TdxGanttControlResources; virtual;
    function CreateTasks: TdxGanttControlTasks; virtual;
    function CreateWBSMasks: TdxGanttControlWBSMasks; virtual;

    procedure DoLoaded; virtual;
    procedure PropertiesChanged; virtual;

    procedure AssignmentsChangedHandler(Sender: TObject; AItem: TdxGanttControlModelElementListItem);
    procedure BaselinesChangedHandler(Sender: TObject; AItem: TdxGanttControlModelElementListItem);
    procedure CalendarsChangedHandler(Sender: TObject; AItem: TdxGanttControlModelElementListItem);
    procedure ResourcesChangedHandler(Sender: TObject; AItem: TdxGanttControlModelElementListItem);
    procedure TasksChangedHandler(Sender: TObject; AItem: TdxGanttControlModelElementListItem);

    procedure DoAssign(Source: TPersistent); override;
    procedure DoChanged; override;
    procedure DoReset; override;
  public
    constructor Create; virtual;
    destructor Destroy; override;

    procedure LoadFromFile(const AFileName: string);
    procedure LoadFromStream(const AStream: TStream);
    procedure SaveToFile(const AFileName: string);
    procedure SaveToStream(const AStream: TStream);

    property ActiveCalendar: TdxGanttControlCalendar read GetActiveCalendar;

    property Assignments: TdxGanttControlAssignments read FAssignments;
    property Baselines: TdxGanttControlDataModelBaselines read FBaselines;
    property Calendars: TdxGanttControlCalendars read FCalendars;
    property ExtendedAttributes: TdxGanttControlExtendedAttributes read FExtendedAttributes;
    property Properties: TdxGanttControlDataModelProperties read FProperties;
    property Resources: TdxGanttControlResources read FResources;
    property Tasks: TdxGanttControlTasks read FTasks;
  {$REGION 'for internal use'}
    property RealProjectFinish: TDateTime read GetRealProjectFinish;
    property RealProjectStart: TDateTime read GetRealProjectStart;

    property OutlineCodes: TdxGanttControlOutlineCodes read FOutlineCodes;
    property WBSMasks: TdxGanttControlWBSMasks read FWBSMasks;

    property AssignmentChangedHandlers: TdxGanttAssignmentChangedHandlers read FAssignmentChangedHandlers;
    property BaselineChangedHandlers: TdxGanttBaselineChangedHandlers read FBaselineChangedHandlers;
    property CalendarChangedHandlers: TdxGanttCalendarChangedHandlers read FCalendarChangedHandlers;
    property LoadedHandlers: TdxNotifyEventHandler read FLoadedHandlers;
    property PropertiesChangedHandlers: TdxNotifyEventHandler read FPropertiesChangedHandlers;
    property ResourceChangedHandlers: TdxGanttResourceChangedHandlers read FResourceChangedHandlers;
    property TaskChangedHandlers: TdxGanttTaskChangedHandlers read FTaskChangedHandlers;
  {$ENDREGION 'for internal use'}
  end;

implementation

uses
  IOUtils, Math, DateUtils, RTLConsts,
  dxCultureInfo,
  dxGanttControlUtils,
  dxGanttControlImporter,
  dxGanttControlXMLImporter,
  dxGanttControlExporter,
  dxGanttControlXMLExporter;

const
  dxThisUnitName = 'dxGanttControlDataModel';

{ TdxGanttControlDataModelProperties }

procedure TdxGanttControlDataModelProperties.DoAssign(Source: TPersistent);
var
  ASource: TdxGanttControlDataModelProperties;
begin
  if Safe.Cast(Source, TdxGanttControlDataModelProperties, ASource) then
  begin
    ActualsInSync := ASource.ActualsInSync;
    AdminProject := ASource.AdminProject;
    Author := ASource.Author;
    AutoAddNewResourcesAndTasks := ASource.AutoAddNewResourcesAndTasks;
    Autolink := ASource.Autolink;
    BaselineForEarnedValue := ASource.BaselineForEarnedValue;
    CalendarUID := ASource.CalendarUID;
    Category := ASource.Category;
    Company := ASource.Company;
    ProjectCreated := ASource.ProjectCreated;
    CriticalSlackLimit := ASource.CriticalSlackLimit;
    CurrencyCode := ASource.CurrencyCode;
    CurrencyDigits := ASource.CurrencyDigits;
    CurrencySymbol := ASource.CurrencySymbol;
    CurrencySymbolPosition := ASource.CurrencySymbolPosition;
    DaysPerMonth := ASource.DaysPerMonth;
    DefaultFinishTime := ASource.DefaultFinishTime;
    DefaultFixedCostAccrual := ASource.DefaultFixedCostAccrual;
    DefaultOvertimeRate := ASource.DefaultOvertimeRate;
    DefaultStandardRate := ASource.DefaultStandardRate;
    DefaultStartTime := ASource.DefaultStartTime;
    DefaultTaskEVMethod := ASource.DefaultTaskEVMethod;
    DefaultTaskType := ASource.DefaultTaskType;
    DurationFormat := ASource.DurationFormat;
    EarnedValueMethod := ASource.EarnedValueMethod;
    EditableActualCosts := ASource.EditableActualCosts;
    ExtendedCreationDate := ASource.ExtendedCreationDate;
    ProjectFinish := ASource.ProjectFinish;
    FiscalYearStart := ASource.FiscalYearStart;
    FYStartDate := ASource.FYStartDate;
    GUID := ASource.GUID;
    HonorConstraints := ASource.HonorConstraints;
    InsertedProjectsLikeSummary := ASource.InsertedProjectsLikeSummary;
    KeepTaskOnNearestWorkingTimeWhenMadeAutoScheduled := ASource.KeepTaskOnNearestWorkingTimeWhenMadeAutoScheduled;
    LastSaved := ASource.LastSaved;
    Manager := ASource.Manager;
    MicrosoftProjectServerURL := ASource.MicrosoftProjectServerURL;
    MinutesPerDay := ASource.MinutesPerDay;
    MinutesPerWeek := ASource.MinutesPerWeek;
    MoveCompletedEndsBack := ASource.MoveCompletedEndsBack;
    MoveCompletedEndsForward := ASource.MoveCompletedEndsForward;
    MoveRemainingStartsBack := ASource.MoveRemainingStartsBack;
    MoveRemainingStartsForward := ASource.MoveRemainingStartsForward;
    MultipleCriticalPaths := ASource.MultipleCriticalPaths;
    Name := ASource.Name;
    NewTasksEffortDriven := ASource.NewTasksEffortDriven;
    NewTasksEstimated := ASource.NewTasksEstimated;
    NewTaskStartDate := ASource.NewTaskStartDate;
    RemoveFileProperties := ASource.RemoveFileProperties;
    Revision := ASource.Revision;
    ScheduleFromStart := ASource.ScheduleFromStart;
    SplitsInProgressTasks := ASource.SplitsInProgressTasks;
    SpreadActualCost := ASource.SpreadActualCost;
    SpreadPercentComplete := ASource.SpreadPercentComplete;
    ProjectStart := ASource.ProjectStart;
    StatusDate := ASource.StatusDate;
    Subject := ASource.Subject;
    TaskUpdatesResource := ASource.TaskUpdatesResource;
    WeekStartDay := ASource.WeekStartDay;
    WorkFormat := ASource.WorkFormat;
    Title := ASource.Title;
    MarkNewTasksAsManuallyScheduled := ASource.MarkNewTasksAsManuallyScheduled;
    UpdateManuallyScheduledTasksWhenEditingLinks := ASource.UpdateManuallyScheduledTasksWhenEditingLinks;
    FAssignedValues := ASource.FAssignedValues;
  end;
  inherited DoAssign(Source);
end;

procedure TdxGanttControlDataModelProperties.DoChanged;
begin
  TdxGanttControlDataModel(DataModel).PropertiesChanged;
end;

procedure TdxGanttControlDataModelProperties.DoReset;
begin
  FAssignedValues := [];
  ProjectCreated := Now;
  CurrencyDigits := TdxGanttControlCurrencyDigits(Max(2, TdxCultureInfo.CurrentCulture.FormatSettings.CurrencyDecimals));
  CurrencySymbol := TdxCultureInfo.CurrentCulture.FormatSettings.CurrencyString;
  CurrencySymbolPosition := TdxGanttControlCurrencySymbolPosition(TdxCultureInfo.CurrentCulture.FormatSettings.CurrencyFormat);
  DefaultFixedCostAccrual := TdxGanttControlFixedCostAccrual.Prorated;
  DefaultTaskType := TdxGanttControlTaskType.FixedUnits;
  FYStartDate := TdxGanttControlCalendarMonth.January;
  GUID := TdxGanttControlUtils.GenerateGUID;
  WorkFormat := TdxGanttControlWorkFormat.Hours;
  MarkNewTasksAsManuallyScheduled := True;
  WeekStartDay := dxGetStartOfWeek;
  DefaultStartTime := EncodeTime(8, 0, 0, 0);
  DefaultFinishTime := EncodeTime(17, 0, 0, 0);
end;

function TdxGanttControlDataModelProperties.GetActualDurationFormat: TdxDurationFormat;
begin
  if IsValueAssigned(TdxGanttPropertiesAssignedValue.DurationFormat) then
    Result := DurationFormat
  else
    Result := TdxDurationFormat.Days;
end;

function TdxGanttControlDataModelProperties.IsValueAssigned(const AValue: TdxGanttPropertiesAssignedValue): Boolean;
begin
  Result := AValue in FAssignedValues;
end;

procedure TdxGanttControlDataModelProperties.ResetValue(const AValue: TdxGanttPropertiesAssignedValue);
begin
  if IsValueAssigned(AValue) then
  begin
    Exclude(FAssignedValues, AValue);
    Changed;
  end
end;

procedure TdxGanttControlDataModelProperties.SetActualsInSync(const Value: Boolean);
begin
  if (ActualsInSync <> Value) or not IsValueAssigned(TdxGanttPropertiesAssignedValue.ActualsInSync) then
  begin
    Include(FAssignedValues, TdxGanttPropertiesAssignedValue.ActualsInSync);
    FActualsInSync := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelProperties.SetAdminProject(const Value: Boolean);
begin
  if (AdminProject <> Value) or not IsValueAssigned(TdxGanttPropertiesAssignedValue.AdminProject) then
  begin
    Include(FAssignedValues, TdxGanttPropertiesAssignedValue.AdminProject);
    FAdminProject := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelProperties.SetAuthor(const Value: string);
begin
  if (Author <> Value) or not IsValueAssigned(TdxGanttPropertiesAssignedValue.Author) then
  begin
    Include(FAssignedValues, TdxGanttPropertiesAssignedValue.Author);
    FAuthor := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelProperties.SetAutoAddNewResourcesAndTasks(const Value: Boolean);
begin
  if (AutoAddNewResourcesAndTasks <> Value) or not IsValueAssigned(TdxGanttPropertiesAssignedValue.AutoAddNewResourcesAndTasks) then
  begin
    Include(FAssignedValues, TdxGanttPropertiesAssignedValue.AutoAddNewResourcesAndTasks);
    FAutoAddNewResourcesAndTasks := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelProperties.SetAutolink(const Value: Boolean);
begin
  if (Autolink <> Value) or not IsValueAssigned(TdxGanttPropertiesAssignedValue.Autolink) then
  begin
    Include(FAssignedValues, TdxGanttPropertiesAssignedValue.Autolink);
    FAutolink := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelProperties.SetBaselineForEarnedValue(const Value: Integer);
begin
  if (BaselineForEarnedValue <> Value) or not IsValueAssigned(TdxGanttPropertiesAssignedValue.BaselineForEarnedValue) then
  begin
    Include(FAssignedValues, TdxGanttPropertiesAssignedValue.BaselineForEarnedValue);
    FBaselineForEarnedValue := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelProperties.SetCalendarUID(const Value: Integer);
begin
  if (CalendarUID <> Value) or not IsValueAssigned(TdxGanttPropertiesAssignedValue.CalendarUID) then
  begin
    Include(FAssignedValues, TdxGanttPropertiesAssignedValue.CalendarUID);
    FCalendarUID := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelProperties.SetCategory(const Value: string);
begin
  if (Category <> Value) or not IsValueAssigned(TdxGanttPropertiesAssignedValue.Category) then
  begin
    Include(FAssignedValues, TdxGanttPropertiesAssignedValue.Category);
    FCategory := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelProperties.SetCompany(const Value: string);
begin
  if (Company <> Value) or not IsValueAssigned(TdxGanttPropertiesAssignedValue.Company) then
  begin
    Include(FAssignedValues, TdxGanttPropertiesAssignedValue.Company);
    FCompany := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelProperties.SetProjectCreated(const Value: TDateTime);
begin
  if ProjectCreated <> Value then
  begin
    FProjectCreated := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelProperties.SetCriticalSlackLimit(const Value: Integer);
begin
  if (CriticalSlackLimit <> Value) or not IsValueAssigned(TdxGanttPropertiesAssignedValue.CriticalSlackLimit) then
  begin
    Include(FAssignedValues, TdxGanttPropertiesAssignedValue.CriticalSlackLimit);
    FCriticalSlackLimit := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelProperties.SetCurrencyCode(const Value: string);
begin
  if (CurrencyCode <> Value) or not IsValueAssigned(TdxGanttPropertiesAssignedValue.CurrencyCode) then
  begin
    Include(FAssignedValues, TdxGanttPropertiesAssignedValue.CurrencyCode);
    FCurrencyCode := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelProperties.SetCurrencyDigits(const Value: TdxGanttControlCurrencyDigits);
begin
  if (CurrencyDigits <> Value) or not IsValueAssigned(TdxGanttPropertiesAssignedValue.CurrencyDigits) then
  begin
    Include(FAssignedValues, TdxGanttPropertiesAssignedValue.CurrencyDigits);
    FCurrencyDigits := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelProperties.SetCurrencySymbol(const Value: string);
begin
  if (CurrencySymbol <> Value) or not IsValueAssigned(TdxGanttPropertiesAssignedValue.CurrencySymbol) then
  begin
    Include(FAssignedValues, TdxGanttPropertiesAssignedValue.CurrencySymbol);
    FCurrencySymbol := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelProperties.SetCurrencySymbolPosition(
  const Value: TdxGanttControlCurrencySymbolPosition);
begin
  if (CurrencySymbolPosition <> Value) or not IsValueAssigned(TdxGanttPropertiesAssignedValue.CurrencySymbolPosition) then
  begin
    Include(FAssignedValues, TdxGanttPropertiesAssignedValue.CurrencySymbolPosition);
    FCurrencySymbolPosition := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelProperties.SetDaysPerMonth(const Value: Integer);
begin
  if (DaysPerMonth <> Value) or not IsValueAssigned(TdxGanttPropertiesAssignedValue.DaysPerMonth) then
  begin
    Include(FAssignedValues, TdxGanttPropertiesAssignedValue.DaysPerMonth);
    FDaysPerMonth := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelProperties.SetDefaultFinishTime(const Value: TTime);
begin
  if (DefaultFinishTime <> Value) or not IsValueAssigned(TdxGanttPropertiesAssignedValue.DefaultFinishTime) then
  begin
    Include(FAssignedValues, TdxGanttPropertiesAssignedValue.DefaultFinishTime);
    FDefaultFinishTime := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelProperties.SetDefaultFixedCostAccrual(
  const Value: TdxGanttControlFixedCostAccrual);
begin
  if (DefaultFixedCostAccrual <> Value) or not IsValueAssigned(TdxGanttPropertiesAssignedValue.DefaultFixedCostAccrual) then
  begin
    Include(FAssignedValues, TdxGanttPropertiesAssignedValue.DefaultFixedCostAccrual);
    FDefaultFixedCostAccrual := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelProperties.SetDefaultOvertimeRate(
  const Value: Double);
begin
  if not(SameValue(DefaultOvertimeRate, Value) and IsValueAssigned(TdxGanttPropertiesAssignedValue.DefaultOvertimeRate)) then
  begin
    Include(FAssignedValues, TdxGanttPropertiesAssignedValue.DefaultOvertimeRate);
    FDefaultOvertimeRate := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelProperties.SetDefaultStandardRate(
  const Value: Double);
begin
  if not(SameValue(DefaultStandardRate, Value) and IsValueAssigned(TdxGanttPropertiesAssignedValue.DefaultStandardRate)) then
  begin
    Include(FAssignedValues, TdxGanttPropertiesAssignedValue.DefaultStandardRate);
    FDefaultStandardRate := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelProperties.SetDefaultStartTime(const Value: TTime);
begin
  if (DefaultStartTime <> Value) or not IsValueAssigned(TdxGanttPropertiesAssignedValue.DefaultStartTime) then
  begin
    Include(FAssignedValues, TdxGanttPropertiesAssignedValue.DefaultStartTime);
    FDefaultStartTime := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelProperties.SetDefaultTaskEVMethod(
  const Value: TdxGanttControlTaskEarnedValueMethod);
begin
  if (DefaultTaskEVMethod <> Value) or not IsValueAssigned(TdxGanttPropertiesAssignedValue.DefaultTaskEVMethod) then
  begin
    Include(FAssignedValues, TdxGanttPropertiesAssignedValue.DefaultTaskEVMethod);
    FDefaultTaskEVMethod := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelProperties.SetDefaultTaskType(const Value: TdxGanttControlTaskType);
begin
  if (DefaultTaskType <> Value) or not IsValueAssigned(TdxGanttPropertiesAssignedValue.DefaultTaskType) then
  begin
    Include(FAssignedValues, TdxGanttPropertiesAssignedValue.DefaultTaskType);
    FDefaultTaskType := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelProperties.SetDurationFormat(const Value: TdxDurationFormat);
begin
  if (DurationFormat <> Value) or not IsValueAssigned(TdxGanttPropertiesAssignedValue.DurationFormat) then
  begin
    Include(FAssignedValues, TdxGanttPropertiesAssignedValue.DurationFormat);
    FDurationFormat := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelProperties.SetEarnedValueMethod(
  const Value: TdxGanttControlTaskEarnedValueMethod);
begin
  if (EarnedValueMethod <> Value) or not IsValueAssigned(TdxGanttPropertiesAssignedValue.EarnedValueMethod) then
  begin
    Include(FAssignedValues, TdxGanttPropertiesAssignedValue.EarnedValueMethod);
    FEarnedValueMethod := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelProperties.SetEditableActualCosts(const Value: Boolean);
begin
  if (EditableActualCosts <> Value) or not IsValueAssigned(TdxGanttPropertiesAssignedValue.EditableActualCosts) then
  begin
    Include(FAssignedValues, TdxGanttPropertiesAssignedValue.EditableActualCosts);
    FEditableActualCosts := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelProperties.SetExtendedCreationDate(const Value: TDateTime);
begin
  if (ExtendedCreationDate <> Value) or not IsValueAssigned(TdxGanttPropertiesAssignedValue.ExtendedCreationDate) then
  begin
    Include(FAssignedValues, TdxGanttPropertiesAssignedValue.ExtendedCreationDate);
    FExtendedCreationDate := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelProperties.SetProjectFinish(const Value: TDateTime);
begin
  if (ProjectFinish <> Value) or not IsValueAssigned(TdxGanttPropertiesAssignedValue.ProjectFinish) then
  begin
    Include(FAssignedValues, TdxGanttPropertiesAssignedValue.ProjectFinish);
    FProjectFinish := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelProperties.SetFiscalYearStart(const Value: Boolean);
begin
  if (FiscalYearStart <> Value) or not IsValueAssigned(TdxGanttPropertiesAssignedValue.FiscalYearStart) then
  begin
    Include(FAssignedValues, TdxGanttPropertiesAssignedValue.FiscalYearStart);
    FFiscalYearStart := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelProperties.SetFYStartDate(const Value: TdxGanttControlCalendarMonth);
begin
  if (FYStartDate <> Value) or not IsValueAssigned(TdxGanttPropertiesAssignedValue.FYStartDate) then
  begin
    Include(FAssignedValues, TdxGanttPropertiesAssignedValue.FYStartDate);
    FFYStartDate := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelProperties.SetGUID(const Value: string);
begin
  if (GUID <> Value) or not IsValueAssigned(TdxGanttPropertiesAssignedValue.GUID) then
  begin
    Include(FAssignedValues, TdxGanttPropertiesAssignedValue.GUID);
    FGUID := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelProperties.SetHonorConstraints(const Value: Boolean);
begin
  if (HonorConstraints <> Value) or not IsValueAssigned(TdxGanttPropertiesAssignedValue.HonorConstraints) then
  begin
    Include(FAssignedValues, TdxGanttPropertiesAssignedValue.HonorConstraints);
    FHonorConstraints := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelProperties.SetInsertedProjectsLikeSummary(const Value: Boolean);
begin
  if (InsertedProjectsLikeSummary <> Value) or not IsValueAssigned(TdxGanttPropertiesAssignedValue.InsertedProjectsLikeSummary) then
  begin
    Include(FAssignedValues, TdxGanttPropertiesAssignedValue.InsertedProjectsLikeSummary);
    FInsertedProjectsLikeSummary := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelProperties.SetKeepTaskOnNearestWorkingTimeWhenMadeAutoScheduled(const Value: Boolean);
begin
  if (KeepTaskOnNearestWorkingTimeWhenMadeAutoScheduled <> Value) or
    not IsValueAssigned(TdxGanttPropertiesAssignedValue.KeepTaskOnNearestWorkingTimeWhenMadeAutoScheduled) then
  begin
    Include(FAssignedValues, TdxGanttPropertiesAssignedValue.KeepTaskOnNearestWorkingTimeWhenMadeAutoScheduled);
    FKeepTaskOnNearestWorkingTimeWhenMadeAutoScheduled := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelProperties.SetLastSaved(const Value: TDateTime);
begin
  if (LastSaved <> Value) or not IsValueAssigned(TdxGanttPropertiesAssignedValue.LastSaved) then
  begin
    Include(FAssignedValues, TdxGanttPropertiesAssignedValue.LastSaved);
    FLastSaved := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelProperties.SetManager(const Value: string);
begin
  if (Manager <> Value) or not IsValueAssigned(TdxGanttPropertiesAssignedValue.Manager) then
  begin
    Include(FAssignedValues, TdxGanttPropertiesAssignedValue.Manager);
    FManager := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelProperties.SetMicrosoftProjectServerURL(const Value: Boolean);
begin
  if (MicrosoftProjectServerURL <> Value) or not IsValueAssigned(TdxGanttPropertiesAssignedValue.MicrosoftProjectServerURL) then
  begin
    Include(FAssignedValues, TdxGanttPropertiesAssignedValue.MicrosoftProjectServerURL);
    FMicrosoftProjectServerURL := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelProperties.SetMinutesPerDay(const Value: Integer);
begin
  if (MinutesPerDay <> Value) or not IsValueAssigned(TdxGanttPropertiesAssignedValue.MinutesPerDay) then
  begin
    Include(FAssignedValues, TdxGanttPropertiesAssignedValue.MinutesPerDay);
    FMinutesPerDay := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelProperties.SetMinutesPerWeek(const Value: Integer);
begin
  if (MinutesPerWeek <> Value) or not IsValueAssigned(TdxGanttPropertiesAssignedValue.MinutesPerWeek) then
  begin
    Include(FAssignedValues, TdxGanttPropertiesAssignedValue.MinutesPerWeek);
    FMinutesPerWeek := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelProperties.SetMoveCompletedEndsBack(const Value: Boolean);
begin
  if (MoveCompletedEndsBack <> Value) or not IsValueAssigned(TdxGanttPropertiesAssignedValue.MoveCompletedEndsBack) then
  begin
    Include(FAssignedValues, TdxGanttPropertiesAssignedValue.MoveCompletedEndsBack);
    FMoveCompletedEndsBack := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelProperties.SetMoveCompletedEndsForward(const Value: Boolean);
begin
  if (MoveCompletedEndsForward <> Value) or not IsValueAssigned(TdxGanttPropertiesAssignedValue.MoveCompletedEndsForward) then
  begin
    Include(FAssignedValues, TdxGanttPropertiesAssignedValue.MoveCompletedEndsForward);
    FMoveCompletedEndsForward := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelProperties.SetMoveRemainingStartsBack(const Value: Boolean);
begin
  if (MoveRemainingStartsBack <> Value) or not IsValueAssigned(TdxGanttPropertiesAssignedValue.MoveRemainingStartsBack) then
  begin
    Include(FAssignedValues, TdxGanttPropertiesAssignedValue.MoveRemainingStartsBack);
    FMoveRemainingStartsBack := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelProperties.SetMoveRemainingStartsForward(const Value: Boolean);
begin
  if (MoveRemainingStartsForward <> Value) or not IsValueAssigned(TdxGanttPropertiesAssignedValue.MoveRemainingStartsForward) then
  begin
    Include(FAssignedValues, TdxGanttPropertiesAssignedValue.MoveRemainingStartsForward);
    FMoveRemainingStartsForward := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelProperties.SetMultipleCriticalPaths(const Value: Boolean);
begin
  if (MultipleCriticalPaths <> Value) or not IsValueAssigned(TdxGanttPropertiesAssignedValue.MultipleCriticalPaths) then
  begin
    Include(FAssignedValues, TdxGanttPropertiesAssignedValue.MultipleCriticalPaths);
    FMultipleCriticalPaths := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelProperties.SetName(const Value: string);
begin
  if (Name <> Value) or not IsValueAssigned(TdxGanttPropertiesAssignedValue.Name) then
  begin
    Include(FAssignedValues, TdxGanttPropertiesAssignedValue.Name);
    FName := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelProperties.SetMarkNewTasksAsManuallyScheduled(const Value: Boolean);
begin
  if MarkNewTasksAsManuallyScheduled <> Value then
  begin
    FMarkNewTasksAsManuallyScheduled := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelProperties.SetNewTasksEffortDriven(const Value: Boolean);
begin
  if (NewTasksEffortDriven <> Value) or not IsValueAssigned(TdxGanttPropertiesAssignedValue.NewTasksEffortDriven) then
  begin
    Include(FAssignedValues, TdxGanttPropertiesAssignedValue.NewTasksEffortDriven);
    FNewTasksEffortDriven := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelProperties.SetNewTasksEstimated(const Value: Boolean);
begin
  if (NewTasksEstimated <> Value) or not IsValueAssigned(TdxGanttPropertiesAssignedValue.NewTasksEstimated) then
  begin
    Include(FAssignedValues, TdxGanttPropertiesAssignedValue.NewTasksEstimated);
    FNewTasksEstimated := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelProperties.SetNewTaskStartDate(const Value: TdxGanttControlNewTaskStartDate);
begin
  if (NewTaskStartDate <> Value) or not IsValueAssigned(TdxGanttPropertiesAssignedValue.NewTaskStartDate) then
  begin
    Include(FAssignedValues, TdxGanttPropertiesAssignedValue.NewTaskStartDate);
    FNewTaskStartDate := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelProperties.SetRemoveFileProperties(const Value: Boolean);
begin
  if (RemoveFileProperties <> Value) or not IsValueAssigned(TdxGanttPropertiesAssignedValue.RemoveFileProperties) then
  begin
    Include(FAssignedValues, TdxGanttPropertiesAssignedValue.RemoveFileProperties);
    FRemoveFileProperties := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelProperties.SetRevision(const Value: Integer);
begin
  if (Revision <> Value) or not IsValueAssigned(TdxGanttPropertiesAssignedValue.Revision) then
  begin
    Include(FAssignedValues, TdxGanttPropertiesAssignedValue.Revision);
    FRevision := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelProperties.SetScheduleFromStart(const Value: Boolean);
begin
  if (ScheduleFromStart <> Value) or not IsValueAssigned(TdxGanttPropertiesAssignedValue.ScheduleFromStart) then
  begin
    Include(FAssignedValues, TdxGanttPropertiesAssignedValue.ScheduleFromStart);
    FScheduleFromStart := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelProperties.SetSplitsInProgressTasks(const Value: Boolean);
begin
  if (SplitsInProgressTasks <> Value) or not IsValueAssigned(TdxGanttPropertiesAssignedValue.SplitsInProgressTasks) then
  begin
    Include(FAssignedValues, TdxGanttPropertiesAssignedValue.SplitsInProgressTasks);
    FSplitsInProgressTasks := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelProperties.SetSpreadActualCost(const Value: Boolean);
begin
  if (SpreadActualCost <> Value) or not IsValueAssigned(TdxGanttPropertiesAssignedValue.SpreadActualCost) then
  begin
    Include(FAssignedValues, TdxGanttPropertiesAssignedValue.SpreadActualCost);
    FSpreadActualCost := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelProperties.SetSpreadPercentComplete(const Value: Boolean);
begin
  if (SpreadPercentComplete <> Value) or not IsValueAssigned(TdxGanttPropertiesAssignedValue.SpreadPercentComplete) then
  begin
    Include(FAssignedValues, TdxGanttPropertiesAssignedValue.SpreadPercentComplete);
    FSpreadPercentComplete := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelProperties.SetProjectStart(const Value: TDateTime);
begin
  if (ProjectStart <> Value) or not IsValueAssigned(TdxGanttPropertiesAssignedValue.ProjectStart) then
  begin
    Include(FAssignedValues, TdxGanttPropertiesAssignedValue.ProjectStart);
    FProjectStart := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelProperties.SetStatusDate(const Value: TDateTime);
begin
  if (StatusDate <> Value) or not IsValueAssigned(TdxGanttPropertiesAssignedValue.StatusDate) then
  begin
    Include(FAssignedValues, TdxGanttPropertiesAssignedValue.StatusDate);
    FStatusDate := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelProperties.SetSubject(const Value: string);
begin
  if (Subject <> Value) or not IsValueAssigned(TdxGanttPropertiesAssignedValue.Subject) then
  begin
    Include(FAssignedValues, TdxGanttPropertiesAssignedValue.Subject);
    FSubject := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelProperties.SetTaskUpdatesResource(const Value: Boolean);
begin
  if (TaskUpdatesResource <> Value) or not IsValueAssigned(TdxGanttPropertiesAssignedValue.TaskUpdatesResource) then
  begin
    Include(FAssignedValues, TdxGanttPropertiesAssignedValue.TaskUpdatesResource);
    FTaskUpdatesResource := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelProperties.SetTitle(const Value: string);
begin
  if (Title <> Value) or not IsValueAssigned(TdxGanttPropertiesAssignedValue.Title) then
  begin
    Include(FAssignedValues, TdxGanttPropertiesAssignedValue.Title);
    FTitle := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelProperties.SetWeekStartDay(const Value: TDay);
begin
  if (WeekStartDay <> Value) or not IsValueAssigned(TdxGanttPropertiesAssignedValue.WeekStartDay) then
  begin
    Include(FAssignedValues, TdxGanttPropertiesAssignedValue.WeekStartDay);
    FWeekStartDay := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelProperties.SetWorkFormat(const Value: TdxGanttControlWorkFormat);
begin
  if (WorkFormat <> Value) or not IsValueAssigned(TdxGanttPropertiesAssignedValue.WorkFormat) then
  begin
    Include(FAssignedValues, TdxGanttPropertiesAssignedValue.WorkFormat);
    FWorkFormat := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelProperties.SetUpdateManuallyScheduledTasksWhenEditingLinks(const Value: Boolean);
begin
  if (UpdateManuallyScheduledTasksWhenEditingLinks <> Value) or
    not IsValueAssigned(TdxGanttPropertiesAssignedValue.UpdateManuallyScheduledTasksWhenEditingLinks) then
  begin
    Include(FAssignedValues, TdxGanttPropertiesAssignedValue.UpdateManuallyScheduledTasksWhenEditingLinks);
    FUpdateManuallyScheduledTasksWhenEditingLinks := Value;
    Changed;
  end;
end;

{ TdxGanttControlDataModelBaseline }

procedure TdxGanttControlDataModelBaseline.DoAssign(Source: TPersistent);
var
  ASource: TdxGanttControlDataModelBaseline;
begin
  if Safe.Cast(Source, TdxGanttControlDataModelBaseline, ASource) then
  begin
    FCreated := ASource.Created;
    FDescription := ASource.Description;
  end;
  inherited DoAssign(Source);
end;

procedure TdxGanttControlDataModelBaseline.DoAssignCurrentValues(
  Source: TPersistent);
var
  I: Integer;
  ADataModel: TdxGanttControlDataModel;
  AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond: Word;
begin
  inherited DoAssignCurrentValues(Source);
  DecodeDateTime(Now, AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond);
  FCreated := EncodeDateTime(AYear, AMonth, ADay, AHour, AMinute, ASecond, 0);
  if Safe.Cast(Source, TdxGanttControlDataModel, ADataModel) then
  begin
    for I := 0 to ADataModel.Tasks.Count - 1 do
      if not ADataModel.Tasks[I].Blank then
        ADataModel.Tasks[I].Baselines.AssignCurrentValues(Number);
    for I := 0 to ADataModel.Resources.Count - 1 do
      if not ADataModel.Resources[I].Blank then
        ADataModel.Resources[I].Baselines.AssignCurrentValues(Number);
    for I := 0 to ADataModel.Assignments.Count - 1 do
      ADataModel.Assignments[I].Baselines.AssignCurrentValues(Number);
  end;
end;

procedure TdxGanttControlDataModelBaseline.DoDelete;
var
  I: Integer;
  ADataModel: TdxGanttControlDataModel;
begin
  inherited DoDelete;
  ADataModel := TdxGanttControlDataModel(DataModel);
  for I := 0 to ADataModel.Tasks.Count - 1 do
    ADataModel.Tasks[I].Baselines.Delete(Number);
  for I := 0 to ADataModel.Resources.Count - 1 do
    ADataModel.Resources[I].Baselines.Delete(Number);
  for I := 0 to ADataModel.Assignments.Count - 1 do
    ADataModel.Assignments[I].Baselines.Delete(Number);
end;

procedure TdxGanttControlDataModelBaseline.DoReset;
begin
  inherited DoReset;
  FCreated := InvalidDate;
  FDescription := '';
end;

procedure TdxGanttControlDataModelBaseline.SetCreated(const Value: TDateTime);
begin
  if Created <> Value then
  begin
    FCreated := Value;
    Changed;
  end;
end;

procedure TdxGanttControlDataModelBaseline.SetDescription(const Value: string);
begin
  if FDescription <> Value then
  begin
    FDescription := Value;
    Changed;
  end;
end;

{ TdxGanttControlDataModelBaselines }

function TdxGanttControlDataModelBaselines.Add(
  ANumber: Integer): TdxGanttControlDataModelBaseline;
begin
  Result := TdxGanttControlDataModelBaseline(inherited Add(ANumber));
end;

function TdxGanttControlDataModelBaselines.CreateItem: TdxGanttControlModelElementListItem;
begin
  Result := TdxGanttControlDataModelBaseline.Create(Self);
end;

procedure TdxGanttControlDataModelBaselines.DoItemChanged(
  AItem: TdxGanttControlModelElementListItem);
begin
  TdxGanttControlDataModel(DataModel).BaselinesChangedHandler(Self, AItem);
end;

function TdxGanttControlDataModelBaselines.Find(
  ANumber: Integer): TdxGanttControlDataModelBaseline;
begin
  Result := TdxGanttControlDataModelBaseline(inherited Find(ANumber));
end;

function TdxGanttControlDataModelBaselines.GetItem(
  Index: Integer): TdxGanttControlDataModelBaseline;
begin
  Result := TdxGanttControlDataModelBaseline(inherited Items[Index]);
end;

{ TdxGanttControlDataModel }

constructor TdxGanttControlDataModel.Create;
begin
  inherited Create;
  FProperties := CreateProperties;
  FCalendars := CreateCalendars;
  FOutlineCodes := CreateOutlineCodes;
  FResources := CreateResources;
  FTasks := CreateTasks;
  FExtendedAttributes := CreateExtendedAttributes;
  FAssignments := CreateAssignments;
  FWBSMasks := CreateWBSMasks;
  FBaselines := CreateBaselines;
end;

destructor TdxGanttControlDataModel.Destroy;
begin
  FreeAndNil(FBaselines);
  FreeAndNil(FWBSMasks);
  FreeAndNil(FAssignments);
  FreeAndNil(FExtendedAttributes);
  FreeAndNil(FTasks);
  FreeAndNil(FResources);
  FreeAndNil(FOutlineCodes);
  FreeAndNil(FCalendars);
  FreeAndNil(FProperties);
  inherited Destroy;
end;

procedure TdxGanttControlDataModel.DoAssign(Source: TPersistent);
var
  ASource: TdxGanttControlDataModel;
begin
  if Safe.Cast(Source, TdxGanttControlDataModel, ASource) then
  begin
    Tasks.Assign(ASource.Tasks);
    Calendars.Assign(ASource.Calendars);
    Resources.Assign(ASource.Resources);
    OutlineCodes.Assign(ASource.OutlineCodes);
    ExtendedAttributes.Assign(ASource.ExtendedAttributes);
    Assignments.Assign(ASource.Assignments);
    WBSMasks.Assign(ASource.WBSMasks);
    Baselines.Assign(ASource.Baselines);
    Properties.Assign(ASource.Properties);
  end;
  inherited DoAssign(Source);
end;

procedure TdxGanttControlDataModel.DoChanged;
begin
  if TdxGanttControlDataModelChangedType.Assignment in FChangedTypes then
    AssignmentsChangedHandler(Self, nil);
  if TdxGanttControlDataModelChangedType.Resource in FChangedTypes then
    ResourcesChangedHandler(Self, nil);
  if TdxGanttControlDataModelChangedType.Task in FChangedTypes then
    TasksChangedHandler(Self, nil);
  if TdxGanttControlDataModelChangedType.Calendar in FChangedTypes then
    CalendarsChangedHandler(Self, nil);
  if TdxGanttControlDataModelChangedType.Baseline in FChangedTypes then
    BaselinesChangedHandler(Self, nil);
  FChangedTypes := [];
end;

procedure TdxGanttControlDataModel.DoLoaded;
begin
  if not FLoadedHandlers.Empty then
    FLoadedHandlers.Invoke(Self);
end;

procedure TdxGanttControlDataModel.DoReset;
begin
  FAssignments.Reset;
  FBaselines.Reset;
  FCalendars.Reset;
  FExtendedAttributes.Reset;
  FOutlineCodes.Reset;
  FProperties.Reset;
  FResources.Reset;
  FTasks.Reset;
  FWBSMasks.Reset;
end;

function TdxGanttControlDataModel.GetActiveCalendar: TdxGanttControlCalendar;
begin
  if Properties.IsValueAssigned(TdxGanttPropertiesAssignedValue.CalendarUID) then
    Result := Calendars.GetCalendarByUID(Properties.CalendarUID)
  else
    Result := nil;
  if Result = nil then
    Result := Calendars[0];
end;

function TdxGanttControlDataModel.GetRealProjectFinish: TDateTime;
begin
  if Properties.IsValueAssigned(TdxGanttPropertiesAssignedValue.ProjectFinish) then
    Result := Properties.ProjectFinish
  else if Tasks[0].IsValueAssigned(TdxGanttTaskAssignedValue.Finish) then
    Result := Tasks[0].Finish
  else
    Result := ActiveCalendar.GetFinishWorkTime(Trunc(ActiveCalendar.GetNextWorkTime(Trunc(Now))));
end;

function TdxGanttControlDataModel.GetRealProjectStart: TDateTime;
begin
  if Properties.IsValueAssigned(TdxGanttPropertiesAssignedValue.ProjectStart) then
    Result := Properties.ProjectStart
  else if Tasks[0].IsValueAssigned(TdxGanttTaskAssignedValue.Start) then
    Result := Tasks[0].Start
  else
    Result := ActiveCalendar.GetStartWorkTime(Trunc(ActiveCalendar.GetNextWorkTime(Trunc(Now))));
end;

procedure TdxGanttControlDataModel.LoadFromFile(const AFileName: string);
begin
  TdxGanttControlImporters.Import(AFileName, Self);
  DoLoaded;
end;

procedure TdxGanttControlDataModel.LoadFromStream(const AStream: TStream);
begin
  TdxGanttControlImporters.Import(AStream, TdxGanttControlXMLImporter, Self);
  DoLoaded;
end;

procedure TdxGanttControlDataModel.SaveToFile(const AFileName: string);
begin
  TdxGanttControlExporters.Export(AFileName, Self);
end;

procedure TdxGanttControlDataModel.SaveToStream(const AStream: TStream);
begin
  TdxGanttControlExporters.Export(AStream, TdxGanttControlXMLExporter, Self);
end;

procedure TdxGanttControlDataModel.PropertiesChanged;
begin
  if not PropertiesChangedHandlers.Empty then
    PropertiesChangedHandlers.Invoke(Self);
end;

procedure TdxGanttControlDataModel.AssignmentsChangedHandler(Sender: TObject; AItem: TdxGanttControlModelElementListItem);
begin
  if IsUpdateLocked then
  begin
    Include(FChangedTypes, TdxGanttControlDataModelChangedType.Assignment);
    Exit;
  end;
  if not AssignmentChangedHandlers.Empty then
    AssignmentChangedHandlers.Invoke(Self, TdxGanttControlAssignment(AItem));
end;

procedure TdxGanttControlDataModel.BaselinesChangedHandler(Sender: TObject; AItem: TdxGanttControlModelElementListItem);
begin
  if IsUpdateLocked then
  begin
    Include(FChangedTypes, TdxGanttControlDataModelChangedType.Baseline);
    Exit;
  end;
  if not BaselineChangedHandlers.Empty then
    BaselineChangedHandlers.Invoke(Self, TdxGanttControlDataModelBaseline(AItem));
end;

procedure TdxGanttControlDataModel.CalendarsChangedHandler(Sender: TObject; AItem: TdxGanttControlModelElementListItem);
begin
  if IsUpdateLocked then
  begin
    Include(FChangedTypes, TdxGanttControlDataModelChangedType.Calendar);
    Exit;
  end;
  if not CalendarChangedHandlers.Empty then
    CalendarChangedHandlers.Invoke(Self, TdxGanttControlCalendar(AItem));
end;

procedure TdxGanttControlDataModel.ResourcesChangedHandler(Sender: TObject; AItem: TdxGanttControlModelElementListItem);
begin
  if IsUpdateLocked then
  begin
    Include(FChangedTypes, TdxGanttControlDataModelChangedType.Resource);
    Exit;
  end;
  if not ResourceChangedHandlers.Empty then
    ResourceChangedHandlers.Invoke(Self, TdxGanttControlResource(AItem));
end;

procedure TdxGanttControlDataModel.TasksChangedHandler(Sender: TObject;
  AItem: TdxGanttControlModelElementListItem);
begin
  if IsUpdateLocked then
  begin
    Include(FChangedTypes, TdxGanttControlDataModelChangedType.Task);
    Exit;
  end;
  if not TaskChangedHandlers.Empty then
    TaskChangedHandlers.Invoke(Self, TdxGanttControlTask(AItem));
end;

function TdxGanttControlDataModel.CreateAssignments: TdxGanttControlAssignments;
begin
  Result := TdxGanttControlAssignments.Create(Self);
end;

function TdxGanttControlDataModel.CreateBaselines: TdxGanttControlDataModelBaselines;
begin
  Result := TdxGanttControlDataModelBaselines.Create(Self, Self);
end;

function TdxGanttControlDataModel.CreateCalendars: TdxGanttControlCalendars;
begin
  Result := TdxGanttControlCalendars.Create(Self);
end;

function TdxGanttControlDataModel.CreateExtendedAttributes: TdxGanttControlExtendedAttributes;
begin
  Result := TdxGanttControlExtendedAttributes.Create(Self);
end;

function TdxGanttControlDataModel.CreateOutlineCodes: TdxGanttControlOutlineCodes;
begin
  Result := TdxGanttControlOutlineCodes.Create(Self);
end;

function TdxGanttControlDataModel.CreateProperties: TdxGanttControlDataModelProperties;
begin
  Result := TdxGanttControlDataModelProperties.Create(Self);
end;

function TdxGanttControlDataModel.CreateResources: TdxGanttControlResources;
begin
  Result := TdxGanttControlResources.Create(Self);
end;

function TdxGanttControlDataModel.CreateTasks: TdxGanttControlTasks;
begin
  Result := TdxGanttControlTasks.Create(Self);
end;

function TdxGanttControlDataModel.CreateWBSMasks: TdxGanttControlWBSMasks;
begin
  Result := TdxGanttControlWBSMasks.Create(Self);
end;

end.
