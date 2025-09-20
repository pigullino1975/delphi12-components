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

unit dxGanttControlTaskCommands;

{$I cxVer.inc}
{$I dxGanttControl.inc}

interface

uses
  System.UITypes, System.Contnrs,
  Types, SysUtils, Classes, Graphics, ImgList, Windows, Controls, Dialogs,
  Generics.Defaults, Generics.Collections, Forms, StdCtrls, Variants,
  dxCoreClasses, cxGraphics, cxCustomCanvas, cxGeometry, cxClasses, cxControls,
  cxVariants, cxEdit, cxDrawTextUtils,
  dxGanttControlCustomClasses,
  dxGanttControlCustomDataModel,
  dxGanttControlDataModel,
  dxGanttControlTasks,
  dxGanttControlAssignments,
  dxGanttControlResources,
  dxGanttControlCalendars,
  dxGanttControlCommands;

type
  { TdxGanttControlTaskHistoryItem }

  TdxGanttControlTaskHistoryItem = class abstract(TdxGanttControlHistoryItem)
  strict private
    FTask: TdxGanttControlTask;
  protected
    property Task: TdxGanttControlTask read FTask;
  public
    constructor Create(AHistory: TdxGanttControlHistory; ATask: TdxGanttControlTask); reintroduce; virtual;
  end;

  { TdxGanttControlTaskMakeNotNullHistoryItem }

  TdxGanttControlTaskMakeNotNullHistoryItem = class(TdxGanttControlTaskHistoryItem)
  strict private
    FIsNull: Boolean;
  protected
    procedure DoRedo; override;
    procedure DoUndo; override;
  public
    constructor Create(AHistory: TdxGanttControlHistory; ATask: TdxGanttControlTask); override;
  end;

  { TdxGanttControlTaskSetAssignedValueHistoryItem }

  TdxGanttControlTaskSetAssignedValueHistoryItem = class(TdxGanttControlTaskHistoryItem)
  protected
    FAssignedValue: TdxGanttTaskAssignedValue;
    procedure DoUndo; override;
  end;

  { TdxGanttControlBaselineHistoryItem }

  TdxGanttControlBaselineHistoryItem = class(TdxGanttControlHistoryItem)
  strict private
    FBaseline: TdxGanttControlElementBaseline;
  public
    constructor Create(AOwner: TdxGanttControlHistory; ABaseline: TdxGanttControlElementBaseline); reintroduce;
    property Baseline: TdxGanttControlElementBaseline read FBaseline;
  end;

  { TdxGanttControlTaskBaselineHistoryItem }

  TdxGanttControlTaskBaselineHistoryItem = class(TdxGanttControlBaselineHistoryItem)
  strict private
    function GetBaseline: TdxGanttControlTaskBaseline; inline;
  public
    property Baseline: TdxGanttControlTaskBaseline read GetBaseline;
  end;

  { TdxGanttControlBaselineSetAssignedValueHistoryItem }

  TdxGanttControlBaselineSetAssignedValueHistoryItem = class(TdxGanttControlBaselineHistoryItem)
  protected
    FAssignedValue: TdxGanttBaselineAssignedValue;
    procedure DoUndo; override;
  end;

  { TdxGanttControlTaskBaselineSetAssignedValueHistoryItem }

  TdxGanttControlTaskBaselineSetAssignedValueHistoryItem = class(TdxGanttControlTaskBaselineHistoryItem)
  protected
    FAssignedValue: TdxGanttTaskBaselineAssignedValue;
    procedure DoUndo; override;
  end;

  { TdxGanttControlTaskPredecessorLinkSetAssignedValueHistoryItem }

  TdxGanttControlTaskPredecessorLinkSetAssignedValueHistoryItem = class(TdxGanttControlTaskPredecessorLinkHistoryItem)
  protected
    FAssignedValue: TdxGanttTaskPredecessorLinkAssignedValue;
    procedure DoUndo; override;
  end;

  { TdxGanttControlTaskResetAssignedValueHistoryItem }

  TdxGanttControlTaskResetAssignedValueHistoryItem = class(TdxGanttControlTaskHistoryItem)
  protected
    FAssignedValue: TdxGanttTaskAssignedValue;
    procedure DoRedo; override;
  end;

  { TdxGanttControlBaselineResetAssignedValueHistoryItem }

  TdxGanttControlBaselineResetAssignedValueHistoryItem = class(TdxGanttControlBaselineHistoryItem)
  protected
    FAssignedValue: TdxGanttBaselineAssignedValue;
    procedure DoRedo; override;
  end;

  { TdxGanttControlTaskBaselineResetAssignedValueHistoryItem }

  TdxGanttControlTaskBaselineResetAssignedValueHistoryItem = class(TdxGanttControlTaskBaselineHistoryItem)
  protected
    FAssignedValue: TdxGanttTaskBaselineAssignedValue;
    procedure DoUndo; override;
  end;

  { TdxGanttControlTaskPredecessorLinkResetAssignedValueHistoryItem }

  TdxGanttControlTaskPredecessorLinkResetAssignedValueHistoryItem = class(TdxGanttControlTaskPredecessorLinkHistoryItem)
  protected
    FAssignedValue: TdxGanttTaskPredecessorLinkAssignedValue;
    procedure DoRedo; override;
  end;

  { TdxGanttControlChangeTaskPropertyHistoryItem }

  TdxGanttControlChangeTaskPropertyHistoryItem = class abstract(TdxGanttControlTaskHistoryItem)
  protected
    FNewValue: Variant;
    FOldValue: Variant;

    function GetValue: Variant; virtual; abstract;
    procedure DoSetValue(const Value: Variant); virtual; abstract;
    procedure SetValue(const Value: Variant);

    procedure DoRedo; override;
    procedure DoUndo; override;
  end;
  TdxGanttControlChangeTaskPropertyHistoryItemClass = class of TdxGanttControlChangeTaskPropertyHistoryItem;

  { TdxGanttControlChangeTaskBaselinePropertyHistoryItem }

  TdxGanttControlChangeTaskBaselinePropertyHistoryItem = class abstract(TdxGanttControlTaskBaselineHistoryItem)
  protected
    FNewValue: Variant;
    FOldValue: Variant;

    function GetValue: Variant; virtual; abstract;
    procedure DoSetValue(const Value: Variant); virtual; abstract;
    procedure SetValue(const Value: Variant);

    procedure DoRedo; override;
    procedure DoUndo; override;
  end;
  TdxGanttControlChangeTaskBaselinePropertyHistoryItemClass = class of TdxGanttControlChangeTaskBaselinePropertyHistoryItem;

  { TdxGanttControlChangeTaskBaselineStartHistoryItem }

  TdxGanttControlChangeTaskBaselineStartHistoryItem = class(TdxGanttControlChangeTaskBaselinePropertyHistoryItem)
  protected
    function GetValue: Variant; override;
    procedure DoSetValue(const Value: Variant); override;
  end;

  { TdxGanttControlChangeTaskBaselineFinishHistoryItem }

  TdxGanttControlChangeTaskBaselineFinishHistoryItem = class(TdxGanttControlChangeTaskBaselinePropertyHistoryItem)
  protected
    function GetValue: Variant; override;
    procedure DoSetValue(const Value: Variant); override;
  end;

  { TdxGanttControlChangeTaskBaselineDurationHistoryItem }

  TdxGanttControlChangeTaskBaselineDurationHistoryItem = class(TdxGanttControlChangeTaskBaselinePropertyHistoryItem)
  protected
    function GetValue: Variant; override;
    procedure DoSetValue(const Value: Variant); override;
  end;

  { TdxGanttControlChangeTaskBaselineDurationFormatHistoryItem }

  TdxGanttControlChangeTaskBaselineDurationFormatHistoryItem = class(TdxGanttControlChangeTaskBaselinePropertyHistoryItem)
  protected
    function GetValue: Variant; override;
    procedure DoSetValue(const Value: Variant); override;
  end;

  { TdxGanttControlChangeTaskBaselineEstimatedHistoryItem }

  TdxGanttControlChangeTaskBaselineEstimatedHistoryItem = class(TdxGanttControlChangeTaskBaselinePropertyHistoryItem)
  protected
    function GetValue: Variant; override;
    procedure DoSetValue(const Value: Variant); override;
  end;

  { TdxGanttControlChangeTaskBaselineBudgetedCostOfWorkPerformedHistoryItem }

  TdxGanttControlChangeTaskBaselineBudgetedCostOfWorkPerformedHistoryItem = class(TdxGanttControlChangeTaskBaselinePropertyHistoryItem)
  protected
    function GetValue: Variant; override;
    procedure DoSetValue(const Value: Variant); override;
  end;

  { TdxGanttControlChangeTaskBaselineBudgetedCostOfWorkScheduledHistoryItem }

  TdxGanttControlChangeTaskBaselineBudgetedCostOfWorkScheduledHistoryItem = class(TdxGanttControlChangeTaskBaselinePropertyHistoryItem)
  protected
    function GetValue: Variant; override;
    procedure DoSetValue(const Value: Variant); override;
  end;

  TdxGanttControlChangeTaskBaselineCostHistoryItem = class(TdxGanttControlChangeTaskBaselinePropertyHistoryItem)
  protected
    function GetValue: Variant; override;
    procedure DoSetValue(const Value: Variant); override;
  end;

  { TdxGanttControlChangeTaskOutlineLevelHistoryItem }

  TdxGanttControlChangeTaskOutlineLevelHistoryItem = class(TdxGanttControlChangeTaskPropertyHistoryItem)
  protected
    function GetValue: Variant; override;
    procedure DoSetValue(const Value: Variant); override;
  end;

  { TdxGanttControlChangeTaskSummaryHistoryItem }

  TdxGanttControlChangeTaskSummaryHistoryItem = class(TdxGanttControlChangeTaskPropertyHistoryItem)
  protected
    function GetValue: Variant; override;
    procedure DoSetValue(const Value: Variant); override;
  end;

  { TdxGanttControlChangeTaskNameHistoryItem }

  TdxGanttControlChangeTaskNameHistoryItem = class(TdxGanttControlChangeTaskPropertyHistoryItem)
  protected
    function GetValue: Variant; override;
    procedure DoSetValue(const Value: Variant); override;
  end;

  { TdxGanttControlChangeTaskRollupHistoryItem }

  TdxGanttControlChangeTaskRollupHistoryItem = class(TdxGanttControlChangeTaskPropertyHistoryItem)
  protected
    function GetValue: Variant; override;
    procedure DoSetValue(const Value: Variant); override;
  end;

  { TdxGanttControlChangeTaskDisplayOnTimelineHistoryItem }

  TdxGanttControlChangeTaskDisplayOnTimelineHistoryItem = class(TdxGanttControlChangeTaskPropertyHistoryItem)
  protected
    function GetValue: Variant; override;
    procedure DoSetValue(const Value: Variant); override;
  end;

  { TdxGanttControlChangeRecurringHistoryItem }

  TdxGanttControlChangeRecurringHistoryItem = class(TdxGanttControlChangeTaskPropertyHistoryItem)
  protected
    function GetValue: Variant; override;
    procedure DoSetValue(const Value: Variant); override;
  end;

  { TdxGanttControlChangeRecurrenceInfoHistoryItem }

  TdxGanttControlChangeRecurrenceInfoHistoryItem = class(TdxGanttControlTaskHistoryItem)
  protected
    FNewValue: TdxGanttControlRecurrencePatternData;
    FOldValue: TdxGanttControlRecurrencePatternData;
    procedure DoUndo; override;
    procedure DoRedo; override;
  end;

  { TdxGanttControlChangeTaskCalendarUIDHistoryItem }

  TdxGanttControlChangeTaskCalendarUIDHistoryItem = class(TdxGanttControlChangeTaskPropertyHistoryItem)
  protected
    function GetValue: Variant; override;
    procedure DoSetValue(const Value: Variant); override;
  end;

  { TdxGanttControlChangeTaskPercentCompleteHistoryItem }

  TdxGanttControlChangeTaskPercentCompleteHistoryItem = class(TdxGanttControlChangeTaskPropertyHistoryItem)
  protected
    function GetValue: Variant; override;
    procedure DoSetValue(const Value: Variant); override;
  end;

  { TdxGanttControlChangeTaskPercentWorkCompleteHistoryItem }

  TdxGanttControlChangeTaskPercentWorkCompleteHistoryItem = class(TdxGanttControlChangeTaskPropertyHistoryItem)
  protected
    function GetValue: Variant; override;
    procedure DoSetValue(const Value: Variant); override;
  end;

  { TdxGanttControlChangeTaskWorkVarianceHistoryItem }

  TdxGanttControlChangeTaskWorkVarianceHistoryItem = class(TdxGanttControlChangeTaskPropertyHistoryItem)
  protected
    function GetValue: Variant; override;
    procedure DoSetValue(const Value: Variant); override;
  end;

  { TdxGanttControlChangeTaskCompleteDurationHistoryItem }

  TdxGanttControlChangeTaskCompleteDurationHistoryItem = class(TdxGanttControlChangeTaskPropertyHistoryItem)
  protected
    function GetValue: Variant; override;
    procedure DoSetValue(const Value: Variant); override;
  end;

  { TdxGanttControlChangeTaskDurationFormatHistoryItem }

  TdxGanttControlChangeTaskDurationFormatHistoryItem = class(TdxGanttControlChangeTaskPropertyHistoryItem)
  protected
    function GetValue: Variant; override;
    procedure DoSetValue(const Value: Variant); override;
  end;

  { TdxGanttControlChangeTaskEstimatedHistoryItem }

  TdxGanttControlChangeTaskEstimatedHistoryItem = class(TdxGanttControlChangeTaskPropertyHistoryItem)
  protected
    function GetValue: Variant; override;
    procedure DoSetValue(const Value: Variant); override;
  end;

  { TdxGanttControlChangeTaskConstraintTypeHistoryItem }

  TdxGanttControlChangeTaskConstraintTypeHistoryItem = class(TdxGanttControlChangeTaskPropertyHistoryItem)
  protected
    function GetValue: Variant; override;
    procedure DoSetValue(const Value: Variant); override;
  end;

  { TdxGanttControlChangeTaskConstraintDateHistoryItem }

  TdxGanttControlChangeTaskConstraintDateHistoryItem = class(TdxGanttControlChangeTaskPropertyHistoryItem)
  protected
    function GetValue: Variant; override;
    procedure DoSetValue(const Value: Variant); override;
  end;

  { TdxGanttControlChangeManualHistoryItem }

  TdxGanttControlChangeManualHistoryItem = class(TdxGanttControlChangeTaskPropertyHistoryItem)
  protected
    function GetValue: Variant; override;
    procedure DoSetValue(const Value: Variant); override;
  end;

  { TdxGanttControlChangeTaskMilestoneHistoryItem }

  TdxGanttControlChangeTaskMilestoneHistoryItem = class(TdxGanttControlChangeTaskPropertyHistoryItem)
  protected
    function GetValue: Variant; override;
    procedure DoSetValue(const Value: Variant); override;
  end;

  { TdxGanttControlChangeTaskStartHistoryItem }

  TdxGanttControlChangeTaskStartHistoryItem = class(TdxGanttControlChangeTaskPropertyHistoryItem)
  protected
    function GetValue: Variant; override;
    procedure DoSetValue(const Value: Variant); override;
  end;

  { TdxGanttControlChangeTaskFinishHistoryItem }

  TdxGanttControlChangeTaskFinishHistoryItem = class(TdxGanttControlChangeTaskPropertyHistoryItem)
  protected
    function GetValue: Variant; override;
    procedure DoSetValue(const Value: Variant); override;
  end;

  { TdxGanttControlChangeTaskDurationHistoryItem }

  TdxGanttControlChangeTaskDurationHistoryItem = class(TdxGanttControlChangeTaskPropertyHistoryItem)
  protected
    function GetValue: Variant; override;
    procedure DoSetValue(const Value: Variant); override;
  end;

  { TdxGanttControlChangeTaskPredecessorLinkPropertyHistoryItem }

  TdxGanttControlChangeTaskPredecessorLinkPropertyHistoryItem = class abstract(TdxGanttControlChangeTaskPropertyHistoryItem)
  strict private
    FLink: TdxGanttControlTaskPredecessorLink;
  protected
    property Link: TdxGanttControlTaskPredecessorLink read FLink;
  public
    constructor Create(AHistory: TdxGanttControlHistory; ALink: TdxGanttControlTaskPredecessorLink); reintroduce; virtual;
  end;
  TdxGanttControlChangeTaskPredecessorLinkPropertyHistoryItemClass = class of TdxGanttControlChangeTaskPredecessorLinkPropertyHistoryItem;

  { TdxGanttControlChangeTaskPredecessorLinkTypeHistoryItem }

  TdxGanttControlChangeTaskPredecessorLinkTypeHistoryItem = class(TdxGanttControlChangeTaskPredecessorLinkPropertyHistoryItem)
  protected
    function GetValue: Variant; override;
    procedure DoSetValue(const Value: Variant); override;
  end;

  { TdxGanttControlChangeTaskPredecessorLinkLagHistoryItem }

  TdxGanttControlChangeTaskPredecessorLinkLagHistoryItem = class(TdxGanttControlChangeTaskPredecessorLinkPropertyHistoryItem)
  protected
    function GetValue: Variant; override;
    procedure DoSetValue(const Value: Variant); override;
  end;

  { TdxGanttControlChangeTaskPredecessorLinkLagFormatHistoryItem }

  TdxGanttControlChangeTaskPredecessorLinkLagFormatHistoryItem = class(TdxGanttControlChangeTaskPredecessorLinkPropertyHistoryItem)
  protected
    function GetValue: Variant; override;
    procedure DoSetValue(const Value: Variant); override;
  end;

  { TdxGanttControlTaskCustomCommand }

  TdxGanttControlTaskCustomCommand = class abstract(TdxGanttControlCommand)
  strict private
    FTask: TdxGanttControlTask;
  protected
    procedure DoSetAssignedValue(AValue: TdxGanttTaskAssignedValue);

    procedure BeginUpdate; override;
    procedure EndUpdate; override;

    property Task: TdxGanttControlTask read FTask;
  public
    constructor Create(AControl: TdxGanttControlBase; ATask: TdxGanttControlTask); reintroduce; virtual;
  end;

  { TdxGanttControlDeleteTaskCommand }

  TdxGanttControlDeleteTaskCommand = class(TdxGanttControlTaskCustomCommand)
  strict private
    FExecuteNeeded: Boolean;
    FIsLast: Boolean;
    FParentSummary: TdxGanttControlTask;
    FRaiseConfirmation: Boolean;
    procedure DeleteAssignments(ATask: TdxGanttControlTask);
    procedure DeleteTaskCore(AIndex: Integer);
    procedure CheckLinks(ATask: TdxGanttControlTask; ADeletedTasks: TList<TdxGanttControlTask>);
  protected
    procedure AfterExecute; override;
    procedure BeforeExecute; override;
    procedure BeginUpdate; override;
    procedure DoExecute; override;
    procedure EndUpdate; override;
    property RaiseConfirmation: Boolean read FRaiseConfirmation write FRaiseConfirmation;
  public
    constructor Create(AControl: TdxGanttControlBase; ATask: TdxGanttControlTask); override;
    function Enabled: Boolean; override;
  end;

  { TdxGanttControlSetTaskNotNullCommand }

  TdxGanttControlSetTaskNotNullCommand = class(TdxGanttControlTaskCustomCommand)
  protected
    procedure AfterExecute; override;
    procedure BeforeExecute; override;
    procedure DoExecute; override;
  public
    function Enabled: Boolean; override;
  end;

  { TdxGanttControlChangeTaskCommand }

  TdxGanttControlChangeTaskCommand = class(TdxGanttControlTaskCustomCommand)
  strict private
    FCommands: TdxFastObjectList;
    FNewTask: TdxGanttControlTask;
  protected
    procedure DoExecute; override;
  public
    constructor Create(AControl: TdxGanttControlBase; ATask, ANewTask: TdxGanttControlTask); reintroduce;
    destructor Destroy; override;
  end;

  { TdxGanttControlTaskCommand }

  TdxGanttControlTaskCommand = class abstract(TdxGanttControlTaskCustomCommand)
  protected
    procedure BeforeExecute; override;

    procedure MakeTaskNotNull; overload;
    procedure MakeTaskNotNull(ATask: TdxGanttControlTask); overload;
    procedure SetTaskMode;
  end;

  { TdxGanttControlSetTaskModeCommand }

  TdxGanttControlSetTaskModeCommand = class abstract(TdxGanttControlTaskCommand)
  protected
    FLockUpdateSummary: Boolean;
    function IsManual: Boolean; virtual;
    procedure DoExecute; override;

    class function CreateCommand(AControl: TdxGanttControlBase;
      ATask: TdxGanttControlTask): TdxGanttControlSetTaskModeCommand; static;
  public
    function Enabled: Boolean; override;
  end;

  { TdxGanttControlSetTaskManuallyScheduleModeCommand }

  TdxGanttControlSetTaskManuallyScheduleModeCommand = class(TdxGanttControlSetTaskModeCommand)
  protected
    function IsManual: Boolean; override;
  end;

  { TdxGanttControlSetTaskAutoScheduleModeCommand }

  TdxGanttControlSetTaskAutoScheduleModeCommand = class(TdxGanttControlSetTaskModeCommand)
  protected
    procedure DoExecute; override;
    class procedure SetBasicStartAndFinish(AControl: TdxGanttControlBase; ATask: TdxGanttControlTask; AUpdateSummary: Boolean); static;
  end;

  { TdxGanttControlChangeTaskPropertyCommand }

  TdxGanttControlChangeTaskPropertyCommand = class abstract(TdxGanttControlTaskCommand)
  strict private
    FNewValue: Variant;
    FOldIsAssigned: Boolean;
  protected
    procedure BeforeExecute; override;
    procedure DoExecute; override;

    function GetAssignedValue: TdxGanttTaskAssignedValue; virtual; abstract;
    function GetChangeValueHistoryItemClass: TdxGanttControlChangeTaskPropertyHistoryItemClass; virtual; abstract;
    function GetValue: Variant; virtual;
    function GetValidValue: Variant;
    function HasAssignedValue: Boolean; virtual;
    procedure SetAssignedValue;
    procedure SetValue; virtual;
    procedure ResetAssignedValue; overload;
    procedure ResetAssignedValue(AAssignedValue: TdxGanttTaskAssignedValue); overload;
    function ValidateValue(const AValue: Variant): Variant; virtual;

    function IsNewValueValid: Boolean; virtual;

    property NewValue: Variant read FNewValue;
    property OldIsAssigned: Boolean read FOldIsAssigned;
  public
    constructor Create(AControl: TdxGanttControlBase; ATask: TdxGanttControlTask;
      const ANewValue: Variant); reintroduce; virtual;
    function Enabled: Boolean; override;
  end;
  TdxGanttControlChangeTaskPropertyCommandClass = class of TdxGanttControlChangeTaskPropertyCommand;

  { TdxGanttControlChangeTaskDependentPropertyCustomCommand }

  TdxGanttControlChangeTaskDependentPropertyCustomCommand = class abstract(TdxGanttControlChangeTaskPropertyCommand)
  protected
    FLockUpdateSummary: Boolean;
    FIsDependent: Boolean;
  end;

  { TdxGanttControlChangeTaskDependentPropertyCommand }

  TdxGanttControlChangeTaskDependentPropertyCommand = class(TdxGanttControlChangeTaskDependentPropertyCustomCommand)
  strict private
    FCachedMinStart: TDateTime;
  protected
    procedure AdjustStartAndFinish(ATask: TdxGanttControlTask);
    procedure SetFinish(ATask: TdxGanttControlTask; Value: TDateTime);
    procedure SetStart(ATask: TdxGanttControlTask; Value: TDateTime);

    procedure CalculateDependentLinks;
    procedure CalculateDependentSummary;
    function DoIsNewValueValid: Boolean; virtual;
    function GetMinStart: TDateTime;
    function IsNewValueValid: Boolean; override;
    procedure SetConstraint(AType: TdxGanttControlTaskConstraintType; AValue: TDateTime);
    procedure SetManual;
    procedure SetMilestone(Value: Boolean = True);
  protected
    procedure AfterExecute; override;
    procedure BeforeExecute; override;
  public
    constructor Create(AControl: TdxGanttControlBase;
      ATask: TdxGanttControlTask; const ANewValue: Variant); override;
  end;

  { TdxGanttControlChangeTaskOutlineLevelCommand }

  TdxGanttControlChangeTaskOutlineLevelCommand = class abstract(TdxGanttControlChangeTaskDependentPropertyCustomCommand)
  strict private
    FPreviousSummary: TdxGanttControlTask;
    procedure CheckLinks(ATask: TdxGanttControlTask);
  protected
    procedure AfterExecute; override;
    procedure BeforeExecute; override;
    function GetAssignedValue: TdxGanttTaskAssignedValue; override;
    function GetChangeValueHistoryItemClass: TdxGanttControlChangeTaskPropertyHistoryItemClass; override;

    function GetPreviousTask: TdxGanttControlTask;
    function GetSubTasks(ARecursive: Boolean = False): TList<TdxGanttControlTask>;
    procedure SetTaskSummary(ATask: TdxGanttControlTask; ANewValue: Boolean);
    procedure SetTaskAutoScheduleMode(ATask: TdxGanttControlTask);
  end;

  { TdxGanttControlIncreaseTaskOutlineLevelCommand }

  TdxGanttControlIncreaseTaskOutlineLevelCommand = class(TdxGanttControlChangeTaskOutlineLevelCommand)
  strict private
    FSubTasks: TList<TdxGanttControlTask>;
  protected
    procedure AfterExecute; override;
    procedure BeforeExecute; override;
  public
    constructor Create(AControl: TdxGanttControlBase; ATask: TdxGanttControlTask); reintroduce;
    destructor Destroy; override;
    function Enabled: Boolean; override;
  end;

  { TdxGanttControlDecreaseTaskOutlineLevelCommand }

  TdxGanttControlDecreaseTaskOutlineLevelCommand = class(TdxGanttControlChangeTaskOutlineLevelCommand)
  protected
    procedure AfterExecute; override;
    procedure BeforeExecute; override;
  public
    constructor Create(AControl: TdxGanttControlBase; ATask: TdxGanttControlTask); reintroduce;
    function Enabled: Boolean; override;
  end;

  { TdxGanttControlChangeTaskSummaryCommand }

  TdxGanttControlChangeTaskSummaryCommand = class(TdxGanttControlChangeTaskPropertyCommand)
  protected
    procedure AfterExecute; override;
    function GetAssignedValue: TdxGanttTaskAssignedValue; override;
    function GetChangeValueHistoryItemClass: TdxGanttControlChangeTaskPropertyHistoryItemClass; override;
  end;

  { TdxGanttControlChangeTaskNameCommand }

  TdxGanttControlChangeTaskNameCommand = class(TdxGanttControlChangeTaskPropertyCommand)
  protected
    function GetAssignedValue: TdxGanttTaskAssignedValue; override;
    function GetChangeValueHistoryItemClass: TdxGanttControlChangeTaskPropertyHistoryItemClass; override;
  end;

  { TdxGanttControlChangeTaskRollupCommand }

  TdxGanttControlChangeTaskRollupCommand = class(TdxGanttControlChangeTaskPropertyCommand)
  protected
    function GetAssignedValue: TdxGanttTaskAssignedValue; override;
    function GetChangeValueHistoryItemClass: TdxGanttControlChangeTaskPropertyHistoryItemClass; override;
  end;

  { TdxGanttControlChangeTaskDisplayOnTimelineCommand }

  TdxGanttControlChangeTaskDisplayOnTimelineCommand = class(TdxGanttControlChangeTaskPropertyCommand)
  protected
    function GetAssignedValue: TdxGanttTaskAssignedValue; override;
    function GetChangeValueHistoryItemClass: TdxGanttControlChangeTaskPropertyHistoryItemClass; override;
  end;

  { TdxGanttControlChangeTaskRecurringCommand }

  TdxGanttControlChangeTaskRecurringCommand = class(TdxGanttControlChangeTaskPropertyCommand)
  protected
    function GetAssignedValue: TdxGanttTaskAssignedValue; override;
    function GetChangeValueHistoryItemClass: TdxGanttControlChangeTaskPropertyHistoryItemClass; override;
  end;

  { TdxGanttControlChangeTaskRecurrencePatternCommand }

  TdxGanttControlChangeTaskRecurrencePatternCommand = class(TdxGanttControlTaskCommand)
  strict private
    FNewValue: TdxGanttControlRecurrencePatternData;
  protected
    procedure AfterExecute; override;
    procedure DoExecute; override;
  public
    constructor Create(AControl: TdxGanttControlBase;
      ATask: TdxGanttControlTask; const ANewRecurrencePattern: TdxGanttControlRecurrencePattern); reintroduce;
    function Enabled: Boolean; override;
  end;

  { TdxGanttControlChangeTaskCalendarUIDCommand }

  TdxGanttControlChangeTaskCalendarUIDCommand = class(TdxGanttControlChangeTaskPropertyCommand)
  protected
    function GetAssignedValue: TdxGanttTaskAssignedValue; override;
    function GetChangeValueHistoryItemClass: TdxGanttControlChangeTaskPropertyHistoryItemClass; override;
  end;

  { TdxGanttControlSetTaskMilestoneCommand }

  TdxGanttControlSetTaskMilestoneCommand = class(TdxGanttControlChangeTaskPropertyCommand)
  protected
    procedure AfterExecute; override;
    function GetAssignedValue: TdxGanttTaskAssignedValue; override;
    function GetChangeValueHistoryItemClass: TdxGanttControlChangeTaskPropertyHistoryItemClass; override;
  end;

  { TdxGanttControlChangeTaskDurationFormatCommand }

  TdxGanttControlChangeTaskDurationFormatCommand = class(TdxGanttControlChangeTaskDependentPropertyCommand)
  strict private
    FIsElapsed: Boolean;
  protected
    procedure AfterExecute; override;
    procedure BeforeExecute; override;
    function GetAssignedValue: TdxGanttTaskAssignedValue; override;
    function GetChangeValueHistoryItemClass: TdxGanttControlChangeTaskPropertyHistoryItemClass; override;
  end;

  { TdxGanttControlChangeTaskEstimatedCommand }

  TdxGanttControlChangeTaskEstimatedCommand = class(TdxGanttControlChangeTaskPropertyCommand)
  protected
    function GetAssignedValue: TdxGanttTaskAssignedValue; override;
    function GetChangeValueHistoryItemClass: TdxGanttControlChangeTaskPropertyHistoryItemClass; override;
  end;

  { TdxGanttControlChangeTaskManualCommand }

  TdxGanttControlChangeTaskManualCommand = class(TdxGanttControlChangeTaskDependentPropertyCustomCommand)
  protected
    function GetAssignedValue: TdxGanttTaskAssignedValue; override;
    function GetChangeValueHistoryItemClass: TdxGanttControlChangeTaskPropertyHistoryItemClass; override;
    procedure SetValue; override;
  end;

  { TdxGanttControlChangeSummaryManualCommand }

  TdxGanttControlChangeSummaryManualCommand = class(TdxGanttControlChangeTaskPropertyCommand)
  protected
    function GetAssignedValue: TdxGanttTaskAssignedValue; override;
    function GetChangeValueHistoryItemClass: TdxGanttControlChangeTaskPropertyHistoryItemClass; override;
  public
    function Enabled: Boolean; override;
  end;

  { TdxGanttControlChangeTaskPercentCompleteCustomCommand }

  TdxGanttControlChangeTaskPercentCompleteCustomCommand = class abstract(TdxGanttControlChangeTaskDependentPropertyCustomCommand)
  protected
    procedure AfterExecute; override;
    function CanChangeAssignment(AAssignment: TdxGanttControlAssignment): Boolean; virtual;

    procedure CalculateParentSummaryPercentComplete;
    procedure CalculateParentSummaryPercentWorkComplete;
  end;

  { TdxGanttControlChangeTaskPercentCompleteCommand }

  TdxGanttControlChangeTaskPercentCompleteCommand = class(TdxGanttControlChangeTaskPercentCompleteCustomCommand)
  protected
    procedure AfterExecute; override;
    function CanChangeAssignment(AAssignment: TdxGanttControlAssignment): Boolean; override;
    function GetAssignedValue: TdxGanttTaskAssignedValue; override;
    function GetChangeValueHistoryItemClass: TdxGanttControlChangeTaskPropertyHistoryItemClass; override;
  end;

  { TdxGanttControlChangeTaskPercentWorkCompleteCommand }

  TdxGanttControlChangeTaskPercentWorkCompleteCommand = class(TdxGanttControlChangeTaskPercentCompleteCustomCommand)
  protected
    procedure AfterExecute; override;
    function CanChangeAssignment(AAssignment: TdxGanttControlAssignment): Boolean; override;
    function GetAssignedValue: TdxGanttTaskAssignedValue; override;
    function GetChangeValueHistoryItemClass: TdxGanttControlChangeTaskPropertyHistoryItemClass; override;
  end;

  { TdxGanttControlChangeTaskCompleteDurationCommand }

  TdxGanttControlChangeTaskCompleteDurationCommand = class(TdxGanttControlChangeTaskPercentCompleteCustomCommand)
  protected
    function GetAssignedValue: TdxGanttTaskAssignedValue; override;
    function GetChangeValueHistoryItemClass: TdxGanttControlChangeTaskPropertyHistoryItemClass; override;
  end;

  { TdxGanttControlChangeTaskWorkVarianceCommand }

  TdxGanttControlChangeTaskWorkVarianceCommand = class(TdxGanttControlChangeTaskDependentPropertyCustomCommand)
  protected
    function GetAssignedValue: TdxGanttTaskAssignedValue; override;
    function GetChangeValueHistoryItemClass: TdxGanttControlChangeTaskPropertyHistoryItemClass; override;
  end;

  { TdxGanttControlChangeTaskConstraintCommand }

  TdxGanttControlChangeTaskConstraintCommand = class abstract(TdxGanttControlChangeTaskDependentPropertyCommand)
  protected
    procedure AfterExecute; override;
  end;

  { TdxGanttControlChangeTaskConstraintTypeCommand }

  TdxGanttControlChangeTaskConstraintTypeCommand = class(TdxGanttControlChangeTaskConstraintCommand)
  protected
    function GetAssignedValue: TdxGanttTaskAssignedValue; override;
    function GetChangeValueHistoryItemClass: TdxGanttControlChangeTaskPropertyHistoryItemClass; override;
  public
    function Enabled: Boolean; override;
  end;

  { TdxGanttControlChangeTaskConstraintDateCommand }

  TdxGanttControlChangeTaskConstraintDateCommand = class(TdxGanttControlChangeTaskConstraintCommand)
  protected
    function GetAssignedValue: TdxGanttTaskAssignedValue; override;
    function GetChangeValueHistoryItemClass: TdxGanttControlChangeTaskPropertyHistoryItemClass; override;
  public
    function Enabled: Boolean; override;
  end;

  { TdxGanttControlChangeTaskTimeBoundsCommand }

  TdxGanttControlChangeTaskTimeBoundsCommand = class abstract(TdxGanttControlChangeTaskDependentPropertyCommand)
  public
    function Enabled: Boolean; override;
  end;

  { TdxGanttControlChangeTaskStartCommand }

  TdxGanttControlChangeTaskStartCommand = class(TdxGanttControlChangeTaskTimeBoundsCommand)
  protected
    procedure AfterExecute; override;
    procedure BeforeExecute; override;
    function DoIsNewValueValid: Boolean; override;
    function GetAssignedValue: TdxGanttTaskAssignedValue; override;
    function GetChangeValueHistoryItemClass: TdxGanttControlChangeTaskPropertyHistoryItemClass; override;
    procedure SetValue; override;
    function ValidateValue(const AValue: Variant): Variant; override;
  end;

  { TdxGanttControlChangeTaskFinishCommand }

  TdxGanttControlChangeTaskFinishCommand = class(TdxGanttControlChangeTaskTimeBoundsCommand)
  strict private
    procedure SetDuration;
    procedure SetStart;
  protected
    procedure AfterExecute; override;
    procedure BeforeExecute; override;
    function GetAssignedValue: TdxGanttTaskAssignedValue; override;
    function GetChangeValueHistoryItemClass: TdxGanttControlChangeTaskPropertyHistoryItemClass; override;
  end;

  { TdxGanttControlChangeTaskDurationCommand }

  TdxGanttControlChangeTaskDurationCommand = class(TdxGanttControlChangeTaskTimeBoundsCommand)
  strict private
    FOldSeconds: Int64;
  protected
    procedure AfterExecute; override;
    procedure BeforeExecute; override;
    function GetAssignedValue: TdxGanttTaskAssignedValue; override;
    function GetChangeValueHistoryItemClass: TdxGanttControlChangeTaskPropertyHistoryItemClass; override;
  end;

  { TdxGanttControlChangeTaskPredecessorsCommand }

  TdxGanttControlChangeTaskPredecessorsCommand = class(TdxGanttControlChangeTaskPropertyCommand)
  strict private
    FRaiseValidateException: Boolean;
    function CanCreatePredecessorLink(APredecessorUID: Integer): Boolean;
    procedure DeletePredecessorLink(AIndex: Integer); overload;
  protected
    procedure AfterExecute; override;
    procedure CreatePredecessorLink(APredecessorUID: Integer);
    class procedure DeletePredecessorLink(AControl: TdxGanttControlBase; ATask: TdxGanttControlTask; AIndex: Integer); overload; static;
    function GetAssignedValue: TdxGanttTaskAssignedValue; override;
    function GetChangeValueHistoryItemClass: TdxGanttControlChangeTaskPropertyHistoryItemClass; override;
    procedure SetValueAsArray(const Value: Variant);
    procedure SetValueAsString(const Value: string);
    procedure SetValue; override;
  public
    property RaiseValidateException: Boolean read FRaiseValidateException write FRaiseValidateException;
  end;

  { TdxGanttControlTaskAddPredecessorCommand }

  TdxGanttControlTaskAddPredecessorCommand = class(TdxGanttControlChangeTaskPredecessorsCommand)
  protected
    procedure SetValue; override;
  end;

  { TdxGanttControlChangeTaskPredecessorLinkPropertyCommand }

  TdxGanttControlChangeTaskPredecessorLinkPropertyCommand = class(TdxGanttControlTaskCommand)
  strict private
    FLink: TdxGanttControlTaskPredecessorLink;
    FNewValue: Variant;
  protected
    FIsDependent: Boolean;

    procedure AfterExecute; override;
    procedure DoExecute; override;

    function GetAssignedValue: TdxGanttTaskPredecessorLinkAssignedValue; virtual; abstract;
    function GetChangeValueHistoryItemClass: TdxGanttControlChangeTaskPredecessorLinkPropertyHistoryItemClass; virtual; abstract;
    function GetValue: Variant; virtual;
    procedure SetAssignedValue;
    procedure SetValue;
    procedure ResetAssignedValue;

    property Link: TdxGanttControlTaskPredecessorLink read FLink;
    property NewValue: Variant read FNewValue;
  public
    constructor Create(AControl: TdxGanttControlBase; ALink: TdxGanttControlTaskPredecessorLink; const ANewValue: Variant); reintroduce;
    function Enabled: Boolean; override;
  end;

  { TdxGanttControlChangeTaskPredecessorLinkTypeCommand }

  TdxGanttControlChangeTaskPredecessorLinkTypeCommand = class(TdxGanttControlChangeTaskPredecessorLinkPropertyCommand)
  protected
    function GetAssignedValue: TdxGanttTaskPredecessorLinkAssignedValue; override;
    function GetChangeValueHistoryItemClass: TdxGanttControlChangeTaskPredecessorLinkPropertyHistoryItemClass; override;
  end;

  { TdxGanttControlChangeTaskPredecessorLinkLagCommand }

  TdxGanttControlChangeTaskPredecessorLinkLagCommand = class(TdxGanttControlChangeTaskPredecessorLinkPropertyCommand)
  protected
    function GetAssignedValue: TdxGanttTaskPredecessorLinkAssignedValue; override;
    function GetChangeValueHistoryItemClass: TdxGanttControlChangeTaskPredecessorLinkPropertyHistoryItemClass; override;
  end;

  { TdxGanttControlChangeTaskPredecessorLinkLagFormatCommand }

  TdxGanttControlChangeTaskPredecessorLinkLagFormatCommand = class(TdxGanttControlChangeTaskPredecessorLinkPropertyCommand)
  protected
    function GetAssignedValue: TdxGanttTaskPredecessorLinkAssignedValue; override;
    function GetChangeValueHistoryItemClass: TdxGanttControlChangeTaskPredecessorLinkPropertyHistoryItemClass; override;
  end;

  { TdxGanttControlChangeTaskPredecessorCommand }

  TdxGanttControlChangeTaskPredecessorCommand = class(TdxGanttControlTaskCommand)
  strict private
    FCommands: TdxFastObjectList;
    FLink: TdxGanttControlTaskPredecessorLink;
    FNewLink: TdxGanttControlTaskPredecessorLink;
    procedure Delete;
  protected
    procedure DoExecute; override;
    procedure AfterExecute; override;
  public
    constructor Create(AControl: TdxGanttControlBase; ALink, ANewLink: TdxGanttControlTaskPredecessorLink); reintroduce;
    destructor Destroy; override;
    function Enabled: Boolean; override;
  end;

  { TdxGanttControlChangeTaskResourcesCommand }

  TdxGanttControlChangeTaskResourcesCommand = class(TdxGanttControlChangeTaskPropertyCommand)
  strict private
    procedure CreateAssignment(AResourceUID: Integer);
    procedure DeleteAssignment(AIndex: Integer); overload;
  protected
    function GetAssignedValue: TdxGanttTaskAssignedValue; override;
    function GetChangeValueHistoryItemClass: TdxGanttControlChangeTaskPropertyHistoryItemClass; override;
    function HasAssignedValue: Boolean; override;
    procedure SetValue; override;
    procedure SetValueAsArray(const Value: Variant);
    procedure SetValueAsString(const Value: string);
  end;

  { TdxGanttControlChangeTaskExtendedAttributeValueCommand }

  TdxGanttControlChangeTaskExtendedAttributeValueCommand = class(TdxGanttControlChangeTaskPropertyCommand)
  strict private
    FFieldName: string;
  protected
    function GetAssignedValue: TdxGanttTaskAssignedValue; override;
    function GetChangeValueHistoryItemClass: TdxGanttControlChangeTaskPropertyHistoryItemClass; override;
    function HasAssignedValue: Boolean; override;
    procedure SetValue; override;
  public
    constructor Create(AControl: TdxGanttControlBase; ATask: TdxGanttControlTask; const AFieldName: string;
      const ANewValue: Variant); reintroduce; virtual;
  end;

  { TdxGanttControlMoveTaskCommand }

  TdxGanttControlMoveTaskCommand = class(TdxGanttControlTaskCustomCommand)
  strict private
    FNewIndex: Integer;
    FOldSummary: TdxGanttControlTask;
    FOutlineLevel: Integer;
    procedure DeleteLastBlankTasks;
  protected
    procedure AfterExecute; override;
    procedure BeforeExecute; override;
    procedure DoExecute; override;
  public
    constructor Create(AControl: TdxGanttControlBase; ATask: TdxGanttControlTask; ANewIndex, AOutlineLevel: Integer); reintroduce;
  end;

  { TdxGanttControlTaskSetBaselineCommand }

  TdxGanttControlTaskSetBaselineCommand = class(TdxGanttControlTaskCustomCommand)
  strict private
    FBaseline: TdxGanttControlTaskBaseline;
    FCommands: TdxFastObjectList;
    FNumber: Integer;
  protected
    procedure DoExecute; override;
  public
    constructor Create(AControl: TdxGanttControlBase; ATask: TdxGanttControlTask; ANumber: Integer); reintroduce;
    destructor Destroy; override;
    function Enabled: Boolean; override;
  end;

  { TdxGanttControlTaskBaselineUpdatePropertyCommand }

  TdxGanttControlTaskBaselineUpdatePropertyCommand = class(TdxGanttControlTaskCustomCommand)
  strict private
    FBaseline: TdxGanttControlTaskBaseline;
  protected
    procedure DoExecute; override;
    function GetBaselineValue: Variant; virtual; abstract;
    function GetSetValueHistoryItemClass: TdxGanttControlChangeTaskBaselinePropertyHistoryItemClass; virtual; abstract;
    function GetTaskValue: Variant; virtual; abstract;
    function IsBaselineValueAssigned: Boolean; virtual; abstract;
    function IsTaskValueAssigned: Boolean; virtual; abstract;
    procedure ResetAssignedValue; virtual; abstract;
    procedure SetAssignedValue; virtual; abstract;
    procedure SetValue;
  public
    constructor Create(AControl: TdxGanttControlBase; ATask: TdxGanttControlTask; ABaseline: TdxGanttControlTaskBaseline); reintroduce;
    function Enabled: Boolean; override;
    property Baseline: TdxGanttControlTaskBaseline read FBaseline;
  end;

  { TdxGanttControlTaskBaselineUpdateStartCommand }

  TdxGanttControlTaskBaselineUpdateStartCommand = class(TdxGanttControlTaskBaselineUpdatePropertyCommand)
  protected
    function GetBaselineValue: Variant; override;
    function GetSetValueHistoryItemClass: TdxGanttControlChangeTaskBaselinePropertyHistoryItemClass; override;
    function GetTaskValue: Variant; override;
    function IsBaselineValueAssigned: Boolean; override;
    function IsTaskValueAssigned: Boolean; override;
    procedure ResetAssignedValue; override;
    procedure SetAssignedValue; override;
  end;

  { TdxGanttControlTaskBaselineUpdateFinishCommand }

  TdxGanttControlTaskBaselineUpdateFinishCommand = class(TdxGanttControlTaskBaselineUpdatePropertyCommand)
  protected
    function GetBaselineValue: Variant; override;
    function GetSetValueHistoryItemClass: TdxGanttControlChangeTaskBaselinePropertyHistoryItemClass; override;
    function GetTaskValue: Variant; override;
    function IsBaselineValueAssigned: Boolean; override;
    function IsTaskValueAssigned: Boolean; override;
    procedure ResetAssignedValue; override;
    procedure SetAssignedValue; override;
  end;

  { TdxGanttControlTaskBaselineUpdateDurationCommand }

  TdxGanttControlTaskBaselineUpdateDurationCommand = class(TdxGanttControlTaskBaselineUpdatePropertyCommand)
  protected
    function GetBaselineValue: Variant; override;
    function GetSetValueHistoryItemClass: TdxGanttControlChangeTaskBaselinePropertyHistoryItemClass; override;
    function GetTaskValue: Variant; override;
    function IsBaselineValueAssigned: Boolean; override;
    function IsTaskValueAssigned: Boolean; override;
    procedure ResetAssignedValue; override;
    procedure SetAssignedValue; override;
  end;

  { TdxGanttControlTaskBaselineUpdateDurationFormatCommand }

  TdxGanttControlTaskBaselineUpdateDurationFormatCommand = class(TdxGanttControlTaskBaselineUpdatePropertyCommand)
  protected
    function GetBaselineValue: Variant; override;
    function GetSetValueHistoryItemClass: TdxGanttControlChangeTaskBaselinePropertyHistoryItemClass; override;
    function GetTaskValue: Variant; override;
    function IsBaselineValueAssigned: Boolean; override;
    function IsTaskValueAssigned: Boolean; override;
    procedure ResetAssignedValue; override;
    procedure SetAssignedValue; override;
  end;

  { TdxGanttControlTaskBaselineUpdateEstimatedCommand }

  TdxGanttControlTaskBaselineUpdateEstimatedCommand = class(TdxGanttControlTaskBaselineUpdatePropertyCommand)
  protected
    function GetBaselineValue: Variant; override;
    function GetSetValueHistoryItemClass: TdxGanttControlChangeTaskBaselinePropertyHistoryItemClass; override;
    function GetTaskValue: Variant; override;
    function IsBaselineValueAssigned: Boolean; override;
    function IsTaskValueAssigned: Boolean; override;
    procedure ResetAssignedValue; override;
    procedure SetAssignedValue; override;
  end;

  { TdxGanttControlTaskBaselineUpdateBudgetedCostOfWorkPerformedCommand }

  TdxGanttControlTaskBaselineUpdateBudgetedCostOfWorkPerformedCommand = class(TdxGanttControlTaskBaselineUpdatePropertyCommand)
  protected
    function GetBaselineValue: Variant; override;
    function GetSetValueHistoryItemClass: TdxGanttControlChangeTaskBaselinePropertyHistoryItemClass; override;
    function GetTaskValue: Variant; override;
    function IsBaselineValueAssigned: Boolean; override;
    function IsTaskValueAssigned: Boolean; override;
    procedure ResetAssignedValue; override;
    procedure SetAssignedValue; override;
  end;

  { TdxGanttControlTaskBaselineUpdateBudgetedCostOfWorkScheduledCommand }

  TdxGanttControlTaskBaselineUpdateBudgetedCostOfWorkScheduledCommand = class(TdxGanttControlTaskBaselineUpdatePropertyCommand)
  protected
    function GetBaselineValue: Variant; override;
    function GetSetValueHistoryItemClass: TdxGanttControlChangeTaskBaselinePropertyHistoryItemClass; override;
    function GetTaskValue: Variant; override;
    function IsBaselineValueAssigned: Boolean; override;
    function IsTaskValueAssigned: Boolean; override;
    procedure ResetAssignedValue; override;
    procedure SetAssignedValue; override;
  end;

  { TdxGanttControlTaskBaselineUpdateCostCommand }

  TdxGanttControlTaskBaselineUpdateCostCommand = class(TdxGanttControlTaskBaselineUpdatePropertyCommand)
  protected
    function GetBaselineValue: Variant; override;
    function GetSetValueHistoryItemClass: TdxGanttControlChangeTaskBaselinePropertyHistoryItemClass; override;
    function GetTaskValue: Variant; override;
    function IsBaselineValueAssigned: Boolean; override;
    function IsTaskValueAssigned: Boolean; override;
    procedure ResetAssignedValue; override;
    procedure SetAssignedValue; override;
  end;

  { TdxGanttControlTaskCommandHelper }

  TdxGanttControlTaskCommandHelper = class // for internal use
  public
    class function GetOccurrences(ARecurringTask: TdxGanttControlTask): TList<TdxGanttControlTask>; static;
    class function GetSubTasks(ASummary: TdxGanttControlTask; AIncludeBlanks, ARecursive: Boolean): TList<TdxGanttControlTask>; static;
    class function GetSummary(ATask: TdxGanttControlTask): TdxGanttControlTask; static;
  end;

  { TdxGanttControlOccurrencesCalculator }

  TdxGanttControlOccurrencesCalculator = class
  strict private
    FCalendar: TdxGanttControlCalendar;
    FRecurringTask: TdxGanttControlTask;

    function CalculateCertainDay(ADate: TDateTime): TDateTime;
    function IsBreak(AList: TList<TDateTime>): Boolean; inline;

    function GetNextDailyOccurrence(const APrevious: TDateTime; out ANext: TDateTime): Boolean;
    function GetNextWeeklyOccurrence(const APrevious: TDateTime; out ANext: TDateTime): Boolean;
    function GetNextMonthlyOccurrence(const APrevious: TDateTime; out ANext: TDateTime): Boolean;
    function GetNextYearlyOccurrence(const APrevious: TDateTime; out ANext: TDateTime): Boolean;

    function GetFirstDayOfWeek(ADate: TDateTime): TDateTime;

    function GetDataModelProperties: TdxGanttControlDataModelProperties; inline;
    function GetRecurrencePattern: TdxGanttControlRecurrencePattern; inline;
  protected
    function IsValid: Boolean;

    procedure PopulateOccurrences(AList: TList<TDateTime>);

    property DataModelProperties: TdxGanttControlDataModelProperties read GetDataModelProperties;
    property RecurrencePattern: TdxGanttControlRecurrencePattern read GetRecurrencePattern;
  public
    constructor Create(ARecurringTask: TdxGanttControlTask);

    class function GeDescription(ARecurringTask: TdxGanttControlTask): string; static;
    class function GetOccurrences(ARecurringTask: TdxGanttControlTask): TList<TDateTime>; static;
  end;


implementation

uses
  Math, DateUtils, RTLConsts,
  dxCore, cxDateUtils, dxCultureInfo, dxStringHelper,
  dxMessageDialog,
  dxGanttControl,
  dxGanttControlUtils,
  dxGanttControlStrs,
  dxGanttControlExtendedAttributes,
  dxGanttControlResourceCommands,
  dxGanttControlExtendedAttributeCommands,
  dxGanttControlTaskDependencyDialog;

const
  dxThisUnitName = 'dxGanttControlTaskCommands';

type
  TGetNextDailyOccurrenceProc = function(const APrevious: TDateTime; out ANext: TDateTime): Boolean of object;

  TdxGanttControlTasksAccess = class(TdxGanttControlTasks);
  TdxGanttControlTaskAccess = class(TdxGanttControlTask);
  TdxGanttControlTaskPredecessorLinksAccess = class(TdxGanttControlTaskPredecessorLinks);
  TdxGanttControlTaskDependencyDialogFormAccess = class(TdxGanttControlTaskDependencyDialogForm);

  { TdxTaskCalculator }

  TdxTaskCalculator = class abstract
  strict private
    FControl: TdxGanttControlBase;
    FTask: TdxGanttControlTask;
    function GetDataModel: TdxGanttControlDataModel;
  public
    constructor Create(AControl: TdxGanttControlBase; ATask: TdxGanttControlTask);

    class function AllowLink(ATask, APredecessor: TdxGanttControlTask): Boolean; overload; static;
    class function AllowLink(ATask: TdxGanttControlTask; APredecessorUID: Integer): Boolean; overload; static;
    class function CalculateBasicStart(ATask: TdxGanttControlTask): TDateTime; static;
    class function GetSubTasks(ASummary: TdxGanttControlTask; AIncludeBlanks, ARecursive: Boolean): TList<TdxGanttControlTask>; static;
    class function GetSummary(ATask: TdxGanttControlTask): TdxGanttControlTask; static;
    class function IsSummary(ATask: TdxGanttControlTask): Boolean; static;
    class procedure ResetConstraint(AControl: TdxGanttControlBase; ATask: TdxGanttControlTask); static;
    class procedure SetCompleteDuration(AControl: TdxGanttControlBase; ATask: TdxGanttControlTask; const AValue: Integer); static;
    class procedure SetDuration(AControl: TdxGanttControlBase; ATask: TdxGanttControlTask; const AValue: string); static;
    class procedure SetFinish(AControl: TdxGanttControlBase; ATask: TdxGanttControlTask; const AValue: TDateTime); static;
    class procedure SetPercentComplete(AControl: TdxGanttControlBase; ATask: TdxGanttControlTask; const AValue: Variant); static;
    class procedure SetPercentWorkComplete(AControl: TdxGanttControlBase; ATask: TdxGanttControlTask; const AValue: Variant); static;
    class procedure SetStart(AControl: TdxGanttControlBase; ATask: TdxGanttControlTask; const AValue: TDateTime); static;
    class procedure SetWorkVariance(AControl: TdxGanttControlBase; ATask: TdxGanttControlTask; AValue: Double); static;
    class procedure UpdateCompleteDuration(AControl: TdxGanttControlBase; ATask: TdxGanttControlTask); static;
    class procedure UpdateDuration(AControl: TdxGanttControlBase; ATask: TdxGanttControlTask); static;
    class procedure UpdateWorkVariance(AControl: TdxGanttControlBase; ATask: TdxGanttControlTask); static;

    procedure Calculate; virtual; abstract;

    property Control: TdxGanttControlBase read FControl;
    property DataModel: TdxGanttControlDataModel read GetDataModel;
    property Task: TdxGanttControlTask read FTask;
  end;

  { TdxDependentSummariesCalculator }

  TdxDependentSummaryCalculator = class(TdxTaskCalculator)
  strict private
    class function GetChildren(ASummary: TdxGanttControlTask): TList<TdxGanttControlTask>; static;
    class function GetDates(AList: TList<TdxGanttControlTask>): TList<TDateTime>; static;
    class function GetTaskCount(AList: TList<TdxGanttControlTask>; ADateTime: TDateTime): Integer; static;
  protected
    class function GetTotalSummaryDuration(ASummary: TdxGanttControlTask): Int64; static;
  public
    procedure Calculate; override;
    class procedure CalculateSummaryStartAndFinish(AControl: TdxGanttControlBase; ASummary: TdxGanttControlTask); static;

    class procedure CalculateParentSummaryPercentWorkComplete(AControl: TdxGanttControlBase; ATask: TdxGanttControlTask); static;
    class procedure CalculateSummaryWorkVariance(AControl: TdxGanttControlBase; ASummary: TdxGanttControlTask); static;
    class procedure CalculateSummaryPercentWorkComplete(AControl: TdxGanttControlBase; ASummary: TdxGanttControlTask); static;
    class procedure UpdateSummaryPercentWorkComplete(AControl: TdxGanttControlBase; ASummary: TdxGanttControlTask); static;

    class procedure CalculateParentSummaryPercentComplete(AControl: TdxGanttControlBase; ATask: TdxGanttControlTask); static;
    class procedure CalculateSummaryCompleteDuration(AControl: TdxGanttControlBase; ASummary: TdxGanttControlTask); static;
    class procedure CalculateSummaryPercentComplete(AControl: TdxGanttControlBase; ASummary: TdxGanttControlTask); static;
    class procedure UpdateSummaryPercentComplete(AControl: TdxGanttControlBase; ASummary: TdxGanttControlTask); static;

    class procedure UpdateSummary(AControl: TdxGanttControlBase; ASummary: TdxGanttControlTask); static;
  end;

  { TdxDependentLinkCalculator }

  TdxDependentLinksCalculator = class(TdxTaskCalculator)
  protected
    class procedure CalculateStartAndFinish(ATask: TdxGanttControlTask; var AStart, AFinish: TDateTime); static;
    class procedure DoCalculateStartAndFinish(ATask: TdxGanttControlTask; var AStart, AFinish: TDateTime); static;
    class procedure UpdateLateAsPossibleTasks(AControl: TdxGanttControlBase); static;
  public
    procedure Calculate; override;
    class procedure CalculateLink(AControl: TdxGanttControlBase; ATask: TdxGanttControlTask; AForce: Boolean); static;
    class function CalculateMinStart(ATask: TdxGanttControlTask): TDateTime; static;
    class function CheckLinks(ATask: TdxGanttControlTask): Boolean; static;
    class procedure UpdateTaskStart(AControl: TdxGanttControlBase; ATask: TdxGanttControlTask); static;
  end;

  { TdxGanttControlTaskCandidatePredecessorLinks }

  TdxGanttControlTaskCandidatePredecessorLinks = class(TdxGanttControlTaskPredecessorLinks)
  protected
    procedure DoChanged; override;
  public
    class function CreateFromString(ATask: TdxGanttControlTask; const Value: string): TdxGanttControlTaskCandidatePredecessorLinks;
    function CheckDuplicate: Boolean;
    function IsEqual(AItem1, AItem2: TdxGanttControlTaskPredecessorLink): Boolean;
    procedure RemoveDuplicated;
  end;

  { TdxGanttControlTaskCandidateResource }

  TdxGanttControlTaskCandidateResource = class
  private
    FResource: TdxGanttControlResource;
    FName: string;
  public
    constructor Create(AResource: TdxGanttControlResource); overload;
    constructor Create(const AName: string); overload;

    property Resource: TdxGanttControlResource read FResource;
    property Name: string read FName;
  end;

  { TdxGanttControlTaskCandidateResources }

  TdxGanttControlTaskCandidateResources = class(TcxObjectList)
  public
    class function CreateFromString(ATask: TdxGanttControlTask; const Value: string): TdxGanttControlTaskCandidateResources;
    function CheckDuplicate: Boolean;
    function IsEqual(AItem1, AItem2: TdxGanttControlTaskCandidateResource): Boolean;
    procedure RemoveDuplicated;
  end;


  { TdxTaskStartComparer }

  TdxTaskStartComparer = class(TInterfacedObject, IComparer<TdxGanttControlTask>)
  protected
    function Compare(const Left, Right: TdxGanttControlTask): Integer;
  end;

  { TdxTaskIDComparer }

  TdxTaskIDComparer = class(TInterfacedObject, IComparer<TdxGanttControlTask>)
  protected
    function Compare(const Left, Right: TdxGanttControlTask): Integer;
  end;

  { TdxTaskCalculator }

constructor TdxTaskCalculator.Create(
  AControl: TdxGanttControlBase; ATask: TdxGanttControlTask);
begin
  inherited Create;
  FControl := AControl;
  FTask := ATask;
end;

class procedure TdxTaskCalculator.SetCompleteDuration(AControl: TdxGanttControlBase; ATask: TdxGanttControlTask; const AValue: Integer);
begin
  with TdxGanttControlChangeTaskCompleteDurationCommand.Create(AControl, ATask, AValue) do
  try
    FIsDependent := True;
    Execute;
  finally
    Free;
  end;
end;

class procedure TdxTaskCalculator.SetDuration(AControl: TdxGanttControlBase;
  ATask: TdxGanttControlTask; const AValue: string);
begin
  with TdxGanttControlChangeTaskDurationCommand.Create(AControl, ATask, AValue) do
  try
    FIsDependent := True;
    Execute;
  finally
    Free;
  end;
end;

class procedure TdxTaskCalculator.SetFinish(AControl: TdxGanttControlBase; ATask: TdxGanttControlTask; const AValue: TDateTime);
begin
  with TdxGanttControlChangeTaskFinishCommand.Create(AControl, ATask, AValue) do
  try
    FIsDependent := True;
    Execute;
  finally
    Free;
  end;
end;

class procedure TdxTaskCalculator.SetPercentComplete(AControl: TdxGanttControlBase; ATask: TdxGanttControlTask; const AValue: Variant);
begin
  with TdxGanttControlChangeTaskPercentCompleteCommand.Create(AControl, ATask, AValue) do
  try
    FIsDependent := True;
    Execute;
  finally
    Free;
  end;
end;

class procedure TdxTaskCalculator.SetPercentWorkComplete(
  AControl: TdxGanttControlBase; ATask: TdxGanttControlTask;
  const AValue: Variant);
begin
  with TdxGanttControlChangeTaskPercentWorkCompleteCommand.Create(AControl, ATask, AValue) do
  try
    FIsDependent := True;
    Execute;
  finally
    Free;
  end;
end;

class procedure TdxTaskCalculator.SetStart(AControl: TdxGanttControlBase; ATask: TdxGanttControlTask; const AValue: TDateTime);
begin
  with TdxGanttControlChangeTaskStartCommand.Create(AControl, ATask, AValue) do
  try
    FIsDependent := True;
    Execute;
  finally
    Free;
  end;
end;

class procedure TdxTaskCalculator.SetWorkVariance(AControl: TdxGanttControlBase; ATask: TdxGanttControlTask; AValue: Double);
begin
  with TdxGanttControlChangeTaskWorkVarianceCommand.Create(AControl, ATask, AValue) do
  try
    FIsDependent := True;
    Execute;
  finally
    Free;
  end;
end;

class procedure TdxTaskCalculator.UpdateCompleteDuration(AControl: TdxGanttControlBase; ATask: TdxGanttControlTask);

  procedure UpdateSummaryCompleteDuration;
  var
    ATotal: Integer;
    ATasks: TdxGanttControlTasks;
    I: Integer;
  begin
    ATotal := 0;
    ATasks := ATask.Owner;
    for I := ATask.ID + 1 to ATasks.Count - 1 do
    begin
      if ATasks[I].Blank then
        Continue;
      if ATasks[I].OutlineLevel = ATask.OutlineLevel then
        Break;
      if ATasks[I].OutlineLevel > ATask.OutlineLevel + 1 then
        Continue;
      if not ATask.IsValueAssigned(TdxGanttTaskAssignedValue.CompleteDuration) then
        UpdateCompleteDuration(AControl, ATasks[I]);
      ATotal := ATotal + ATasks[I].CompleteDuration;
    end;
    if ATotal > 0 then
      SetCompleteDuration(AControl, ATask, ATotal);
  end;

var
  ASeconds: Int64;
  ATaskCompleteDuration: Integer;
begin
  if ATask.Summary then
    UpdateSummaryCompleteDuration
  else if ATask.IsValueAssigned(TdxGanttTaskAssignedValue.Duration) then
  begin
    ASeconds := TdxGanttControlDuration.Create(ATask.Duration).ToSeconds;
    ATaskCompleteDuration := MulDiv(ASeconds, 1000, 60);
    SetCompleteDuration(AControl, ATask, ATaskCompleteDuration);
  end;
end;

class procedure TdxTaskCalculator.UpdateDuration(AControl: TdxGanttControlBase;
  ATask: TdxGanttControlTask);
var
  ADuration: TdxGanttControlDuration;
begin
  ADuration := TdxGanttControlDuration.Create(ATask.Start, ATask.Finish, ATask.RealCalendar, ATask.RealDurationFormat);
  SetDuration(AControl, ATask, ADuration.ToString);
end;

class procedure TdxTaskCalculator.UpdateWorkVariance(AControl: TdxGanttControlBase; ATask: TdxGanttControlTask);

  procedure CalculateWorkVariance(ACalculatedSummary: TdxGanttControlTask);
  var
    ATotal: Double;
    ATasks: TdxGanttControlTasks;
    I: Integer;
  begin
    ATotal := 0;
    ATasks := ACalculatedSummary.Owner;
    for I := ACalculatedSummary.ID + 1 to ATasks.Count - 1 do
    begin
      if ATasks[I].Blank then
        Continue;
      if ATasks[I].OutlineLevel = ACalculatedSummary.OutlineLevel then
        Break;
      if ATasks[I].OutlineLevel > ACalculatedSummary.OutlineLevel + 1 then
        Continue;
      if not ACalculatedSummary.IsValueAssigned(TdxGanttTaskAssignedValue.WorkVariance) then
        UpdateWorkVariance(AControl, ATasks[I]);
      ATotal := ATotal + ATasks[I].WorkVariance;
    end;
    if ATotal > 0 then
      SetWorkVariance(AControl, ACalculatedSummary, ATotal);
  end;

var
  ASeconds: Int64;
  AResourceCount: Integer;
  ATaskWorkVariance: Double;
begin
  if ATask.Summary then
    CalculateWorkVariance(ATask)
  else if ATask.IsValueAssigned(TdxGanttTaskAssignedValue.Duration) then
  begin
    ASeconds := TdxGanttControlDuration.Create(ATask.Duration).ToSeconds;
    AResourceCount := Length(ATask.Resources);
    if AResourceCount > 1 then
      ASeconds := ASeconds * AResourceCount;
    ATaskWorkVariance := MulDiv(ASeconds, 1000, 60);
    SetWorkVariance(AControl, ATask, ATaskWorkVariance);
  end;
end;

function TdxTaskCalculator.GetDataModel: TdxGanttControlDataModel;
begin
  Result := TdxGanttControlDataModel(Task.DataModel);
end;

class function TdxTaskCalculator.AllowLink(ATask, APredecessor: TdxGanttControlTask): Boolean;

  function CheckChain(ATask, APredecessor: TdxGanttControlTask): Boolean;
  var
    I: Integer;
  begin
    Result := (ATask <> APredecessor) and (ATask <> nil) and (APredecessor <> nil);
    if not Result then
      Exit;
    if APredecessor.IsValueAssigned(TdxGanttTaskAssignedValue.PredecessorLinks) then
      for I := 0 to APredecessor.PredecessorLinks.Count - 1 do
      begin
        Result := CheckChain(ATask, APredecessor.Owner.GetItemByUID(APredecessor.PredecessorLinks[I].PredecessorUID));
        if not Result then
          Exit;
      end;
  end;

  function CheckSummaryChain(ATask, APredecessor: TdxGanttControlTask): Boolean;
  var
    I: Integer;
  begin
    Result := CheckChain(ATask, APredecessor);
    if not Result then
      Exit;
    if APredecessor.Summary then
    begin
      for I := APredecessor.ID + 1 to APredecessor.Owner.Count - 1 do
      begin
        if APredecessor.Owner[I].OutlineLevel <= APredecessor.OutlineLevel then
            Break;
        Result := CheckSummaryChain(ATask, APredecessor.Owner[I]);
        if not Result then
          Exit;
      end;
    end;
  end;

var
  I: Integer;
  ASummary: TdxGanttControlTask;
  ASubTasks: TList<TdxGanttControlTask>;
begin
  Result := CheckChain(ATask, APredecessor);
  if not Result then
    Exit;
  if APredecessor.Summary then
  begin
    ASummary := GetSummary(ATask);
    while ASummary <> nil do
    begin
      if ASummary = APredecessor then
        Exit(False);
      ASummary := GetSummary(ASummary);
    end;
    ASubTasks := GetSubTasks(APredecessor, False, False);
    try
      for I := 0 to ASubTasks.Count - 1 do
      begin
        Result := AllowLink(ATask, ASubTasks[I]);
        if not Result then
          Exit(False);
      end;
    finally
      ASubTasks.Free;
    end;
  end;
  if ATask.Summary then
  begin
    for I := ATask.ID + 1 to ATask.Owner.Count - 1 do
    begin
      if ATask.Owner[I].OutlineLevel <= ATask.OutlineLevel then
        Break;
      Result := CheckSummaryChain(ATask.Owner[I], APredecessor);
      if not Result then
        Exit;
    end;
  end;
  ASummary := GetSummary(APredecessor);
  while ASummary <> nil do
  begin
    Result := CheckChain(ATask, ASummary);
    if not Result then
      Exit;
    ASummary := GetSummary(ASummary);
  end;
end;

class function TdxTaskCalculator.AllowLink(ATask: TdxGanttControlTask; APredecessorUID: Integer): Boolean;
var
  APredecessor: TdxGanttControlTask;
begin
  APredecessor := ATask.Owner.GetItemByUID(APredecessorUID);
  Result := AllowLink(ATask, APredecessor);
end;

class function TdxTaskCalculator.GetSubTasks(ASummary: TdxGanttControlTask; AIncludeBlanks, ARecursive: Boolean): TList<TdxGanttControlTask>;
var
  I: Integer;
  AItems: TdxGanttControlTasks;
  ATask: TdxGanttControlTask;
  AComparer: IComparer<TdxGanttControlTask>;
begin
  AComparer := TdxTaskIDComparer.Create;
  Result := TList<TdxGanttControlTask>.Create(AComparer);
  if ASummary.Blank then
    Exit;
  AItems := ASummary.Owner;
  for I := ASummary.ID + 1 to AItems.Count - 1 do
  begin
    ATask := AItems[I];
    if ATask.Blank and not AIncludeBlanks then
      Continue;
    if not ATask.Blank and (ATask.OutlineLevel <= ASummary.OutlineLevel) then
      Break;
    if ARecursive or (ATask.OutlineLevel = ASummary.OutlineLevel + 1) then
      Result.Add(ATask);
  end;
end;

class function TdxTaskCalculator.GetSummary(
  ATask: TdxGanttControlTask): TdxGanttControlTask;
var
  I: Integer;
begin
  Result := nil;
  if ATask.OutlineLevel = 0 then
    Exit;
  for I := ATask.ID - 1 downto 0 do
    if (ATask.Owner[I].Summary) and (ATask.Owner[I].OutlineLevel = ATask.OutlineLevel - 1) then
      Exit(ATask.Owner[I]);
end;

class function TdxTaskCalculator.IsSummary(ATask: TdxGanttControlTask): Boolean;
begin
  Result := (ATask <> nil) and ATask.IsValueAssigned(TdxGanttTaskAssignedValue.Summary) and ATask.Summary;
end;

class procedure TdxTaskCalculator.ResetConstraint(AControl: TdxGanttControlBase; ATask: TdxGanttControlTask);
begin
  with TdxGanttControlChangeTaskConstraintTypeCommand.Create(AControl, ATask, Null) do
  try
    Execute;
  finally
    Free;
  end;
  with TdxGanttControlChangeTaskConstraintDateCommand.Create(AControl, ATask, Null) do
  try
    Execute;
  finally
    Free;
  end;
end;

class function TdxTaskCalculator.CalculateBasicStart(ATask: TdxGanttControlTask): TDateTime;
var
  ACalendar: TdxGanttControlCalendar;
  AConstraintDate: TDateTime;
  ADuration: TdxGanttControlDuration;
  ADataModel: TdxGanttControlDataModel;
begin
  ADataModel := TdxGanttControlDataModel(ATask.DataModel);
  ACalendar := ATask.RealCalendar;
  Result := InvalidDate;
  if not ATask.Manual and ATask.IsValueAssigned(TdxGanttTaskAssignedValue.ConstraintType) and
    ATask.IsValueAssigned(TdxGanttTaskAssignedValue.ConstraintDate) then
  begin
    AConstraintDate := ATask.ConstraintDate;
    ADuration := TdxGanttControlDuration.Create(ATask.RealDuration);
    case ATask.ConstraintType of
      TdxGanttControlTaskConstraintType.AsSoonAsPossible:
        Result := ADataModel.RealProjectStart;
      TdxGanttControlTaskConstraintType.AsLateAsPossible:
        Result := ADuration.GetWorkStart(ADataModel.RealProjectFinish, ATask.RealCalendar, ATask.RealDurationFormat);

      TdxGanttControlTaskConstraintType.MustStartOn,
      TdxGanttControlTaskConstraintType.StartNoEarlierThan,
      TdxGanttControlTaskConstraintType.StartNoLaterThan:
        Result := AConstraintDate;

      TdxGanttControlTaskConstraintType.MustFinishOn,
      TdxGanttControlTaskConstraintType.FinishNoEarlierThan,
      TdxGanttControlTaskConstraintType.FinishNoLaterThan:
        Result := ADuration.GetWorkStart(AConstraintDate, ATask.RealCalendar, ATask.RealDurationFormat);
    end;
  end;
  if Result = InvalidDate then
    Result := ACalendar.GetNextWorkTime(ADataModel.RealProjectStart);
end;

{ TdxDependentSummariesCalculator }

procedure TdxDependentSummaryCalculator.Calculate;
var
  ASummary: TdxGanttControlTask;
begin
  ASummary := GetSummary(Task);
  while (ASummary <> nil) and ASummary.Manual do
    ASummary := GetSummary(ASummary);
  CalculateSummaryStartAndFinish(Control, ASummary);
end;

class procedure TdxDependentSummaryCalculator.CalculateSummaryWorkVariance(AControl: TdxGanttControlBase; ASummary: TdxGanttControlTask);
begin
  if ASummary = nil then
    Exit;
  UpdateWorkVariance(AControl, ASummary);
  CalculateSummaryWorkVariance(AControl, GetSummary(ASummary));
end;

class procedure TdxDependentSummaryCalculator.CalculateSummaryPercentWorkComplete(AControl: TdxGanttControlBase; ASummary: TdxGanttControlTask);

  procedure SetPercentWorkComplete(ATask: TdxGanttControlTask; Value: Double);
  var
    AIntValue: Integer;
  begin
    AIntValue := Trunc(Value);
    if Frac(Value) >= 0.5 then
      Inc(AIntValue);
    TdxTaskCalculator.SetPercentWorkComplete(AControl, ATask, AIntValue);
    if not ATask.Summary then
      TdxTaskCalculator.SetPercentComplete(AControl, ATask, AIntValue);
  end;

  procedure UpdateInnerSummaries;
  var
    I: Integer;
    AList: TList<TdxGanttControlTask>;
  begin
    AList := TList<TdxGanttControlTask>.Create;
    try
      for I := ASummary.ID + 1 to ASummary.Owner.Count - 1 do
      begin
        if ASummary.Blank then
          Continue;
        if ASummary.Owner[I].OutlineLevel = ASummary.OutlineLevel then
          Break;
        if ASummary.Owner[I].Summary then
          AList.Add(ASummary.Owner[I]);
      end;
      for I := AList.Count - 1 downto 0 do
        UpdateSummaryPercentWorkComplete(AControl, AList[I]);
    finally
      AList.Free
    end;
  end;

var
  AList: TList<TdxGanttControlTask>;
  ATask: TdxGanttControlTask;
  I, J: Integer;
  ACount: Integer;
  AWorkVariance: Double;
  AWorkCompleted, ABeforeWorkCompleted: Double;
  ATaskWorkVariance: Double;
  ATaskPercentCompleteArray: TArray<Double>;
  AStart, AFinish: TDateTime;
  AWorkStart, AWorkFinish: TDateTime;
  ADurationInSeconds: Int64;
  ATaskDurationInSeconds: Int64;
  ATaskPercentComplete: Double;
  ADates: TList<TDateTime>;
  AIsElapsedFormat: Boolean;
  ATaskDuration: TdxGanttControlDuration;
begin
  if not ASummary.IsValueAssigned(TdxGanttTaskAssignedValue.WorkVariance) then
    TdxDependentSummaryCalculator.CalculateSummaryWorkVariance(AControl, ASummary);
  AWorkVariance := ASummary.WorkVariance;
  AWorkCompleted := AWorkVariance * ASummary.GetRealPercentWorkComplete / 100;
  AList := GetChildren(ASummary);
  try
    if AList.Count = 0 then
      Exit;
    SetLength(ATaskPercentCompleteArray, AList.Count);
    for I := 0 to AList.Count - 1 do
    begin
      if AWorkCompleted = AWorkVariance then
        ATaskPercentCompleteArray[I] := 100
      else
        ATaskPercentCompleteArray[I] := 0;
      ATask := AList[I];
      if not ATask.IsValueAssigned(TdxGanttTaskAssignedValue.WorkVariance) then
        UpdateWorkVariance(AControl, ATask);
    end;
    if (AWorkCompleted > 0) and (AWorkCompleted < AWorkVariance) then
    begin
      ADates := GetDates(AList);
      try
        for I := 0 to ADates.Count - 1 do
        begin
          AStart := ADates[I];
          if I < ADates.Count - 1 then
            AFinish := ADates[I + 1]
          else
            AFinish := ADates.Last;
          ABeforeWorkCompleted := AWorkCompleted;
          for J := 0 to AList.Count - 1 do
          begin
            ATask := AList[J];
            ATaskDuration := TdxGanttControlDuration.Create(ATask.Duration);
            ATaskDurationInSeconds := ATaskDuration.ToSeconds;
            if ATaskDurationInSeconds > 0 then
            begin
              if ATask.Finish <= AStart then
                Continue;
              if ATask.Start >= AFinish then
                Break;
            end;
            if ATaskDurationInSeconds = 0 then
            begin
              if AWorkCompleted > 0 then
                ATaskPercentCompleteArray[J] := 100;
            end
            else
            begin
              ACount := GetTaskCount(AList, AStart);
              if ACount = 0 then
                Continue;
              if ABeforeWorkCompleted <= 0 then
                Break;
              AIsElapsedFormat := TdxGanttControlDuration.IsElapsedFormat(ATask.DurationFormat);
              AWorkStart := ATask.RealCalendar.GetNextWorkTime(AStart);
              AWorkFinish := ATask.RealCalendar.GetPreviousWorkTime(AFinish);
              ADurationInSeconds := TdxGanttControlDuration.Create(AWorkStart, AWorkFinish, ATask.RealCalendar, AIsElapsedFormat).ToSeconds;
              if ADurationInSeconds = 0 then
                Continue;
              ATaskWorkVariance := ATask.WorkVariance * ADurationInSeconds / ATaskDurationInSeconds;
              ATaskPercentComplete := Min(100, (ABeforeWorkCompleted / ACount) / ATaskWorkVariance * 100) * (ADurationInSeconds / ATaskDurationInSeconds);
              AWorkCompleted := AWorkCompleted - ATask.WorkVariance * ATaskPercentComplete / 100;
              ATaskPercentCompleteArray[J] := ATaskPercentCompleteArray[J] + ATaskPercentComplete;
            end;
          end;
        end;
      finally
        ADates.Free;
      end;
    end;
    for I := 0 to AList.Count - 1 do
      SetPercentWorkComplete(AList[I], ATaskPercentCompleteArray[I]);
  finally
    AList.Free;
  end;
  UpdateInnerSummaries;
end;

class procedure TdxDependentSummaryCalculator.UpdateSummaryPercentWorkComplete(AControl: TdxGanttControlBase; ASummary: TdxGanttControlTask);
var
  AWorkVariance, ATaskWorkVariance: Double;
  ATaskDuration: Int64;
  ATasks: TdxGanttControlTasks;
  I: Integer;
  APercentComplete: Integer;
  AResourceCount: Integer;
begin
  AWorkVariance := 0;
  if not ASummary.IsValueAssigned(TdxGanttTaskAssignedValue.WorkVariance) then
    CalculateSummaryWorkVariance(AControl, ASummary);
  ATasks := ASummary.Owner;
  for I := ASummary.ID + 1 to ATasks.Count - 1 do
  begin
    if ATasks[I].Blank then
      Continue;
    if ATasks[I].OutlineLevel = ASummary.OutlineLevel then
      Break;
    if ATasks[I].OutlineLevel > ASummary.OutlineLevel + 1 then
      Break;
    if not ATasks[I].IsValueAssigned(TdxGanttTaskAssignedValue.PercentWorkComplete) or (ATasks[I].GetRealPercentWorkComplete = 0) then
      Continue;
    if ATasks[I].Summary then
    begin
      if not ATasks[I].IsValueAssigned(TdxGanttTaskAssignedValue.WorkVariance) then
        CalculateSummaryWorkVariance(AControl, ATasks[I]);
    end;
    if ATasks[I].IsValueAssigned(TdxGanttTaskAssignedValue.WorkVariance) then
      ATaskWorkVariance := ATasks[I].WorkVariance
    else
      if ATasks[I].IsValueAssigned(TdxGanttTaskAssignedValue.Duration) then
      begin
        ATaskDuration := TdxGanttControlDuration.Create(ATasks[I].Duration).ToSeconds;
        AResourceCount := Length(ATasks[I].Resources);
        if AResourceCount > 1 then
          ATaskDuration := ATaskDuration * AResourceCount;
        ATaskWorkVariance := MulDiv(ATaskDuration, 1000, 60);
        SetWorkVariance(AControl, ATasks[I], ATaskWorkVariance);
      end
      else
        ATaskWorkVariance := 0;
    AWorkVariance := AWorkVariance + ATaskWorkVariance * ATasks[I].GetRealPercentWorkComplete / 100;
  end;
  if ASummary.WorkVariance > 0 then
  begin
    APercentComplete := Min(Round(AWorkVariance / ASummary.WorkVariance * 100), 100);
    SetPercentWorkComplete(AControl, ASummary, APercentComplete);
  end;
end;

class procedure TdxDependentSummaryCalculator.CalculateParentSummaryPercentComplete(AControl: TdxGanttControlBase; ATask: TdxGanttControlTask);
var
  ASummary: TdxGanttControlTask;
begin
  ASummary := GetSummary(ATask);
  if ASummary = nil then
    Exit;
  TdxDependentSummaryCalculator.UpdateSummaryPercentComplete(AControl, ASummary);
  CalculateParentSummaryPercentComplete(AControl, ASummary);
end;

class procedure TdxDependentSummaryCalculator.CalculateSummaryCompleteDuration(AControl: TdxGanttControlBase; ASummary: TdxGanttControlTask);
begin
  if ASummary = nil then
    Exit;
  UpdateCompleteDuration(AControl, ASummary);
end;

class procedure TdxDependentSummaryCalculator.CalculateSummaryPercentComplete(AControl: TdxGanttControlBase; ASummary: TdxGanttControlTask);

  procedure SetPercentComplete(ATask: TdxGanttControlTask; Value: Double);
  var
    AIntValue: Integer;
  begin
    AIntValue := Trunc(Value);
    if Frac(Value) >= 0.5 then
      Inc(AIntValue);
    TdxTaskCalculator.SetPercentComplete(AControl, ATask, AIntValue);
    if not ATask.Summary then
      TdxTaskCalculator.SetPercentWorkComplete(AControl, ATask, AIntValue);
  end;

  procedure UpdateInnerSummaries;
  var
    I: Integer;
    AList: TList<TdxGanttControlTask>;
  begin
    AList := TList<TdxGanttControlTask>.Create;
    try
      for I := ASummary.ID + 1 to ASummary.Owner.Count - 1 do
      begin
        if ASummary.Blank then
          Continue;
        if ASummary.Owner[I].OutlineLevel = ASummary.OutlineLevel then
          Break;
        if ASummary.Owner[I].Summary then
          AList.Add(ASummary.Owner[I]);
      end;
      for I := AList.Count - 1 downto 0 do
        UpdateSummaryPercentComplete(AControl, AList[I]);
    finally
      AList.Free
    end;
  end;

var
  AList: TList<TdxGanttControlTask>;
  ATask: TdxGanttControlTask;
  I, J: Integer;
  ACount: Integer;
  ACompleteDuration: Double;
  ACompleted, ABeforeWorkCompleted: Double;
  ATaskWorkVariance: Double;
  ATaskPercentCompleteArray: TArray<Double>;
  AStart, AFinish: TDateTime;
  AWorkStart, AWorkFinish: TDateTime;
  ADurationInSeconds: Int64;
  ATaskDurationInSeconds: Int64;
  ATaskPercentComplete: Double;
  ADates: TList<TDateTime>;
  AIsElapsedFormat: Boolean;
  ATaskDuration: TdxGanttControlDuration;
begin
  if not ASummary.IsValueAssigned(TdxGanttTaskAssignedValue.CompleteDuration) then
    TdxDependentSummaryCalculator.CalculateSummaryCompleteDuration(AControl, ASummary);
  ACompleteDuration := ASummary.CompleteDuration;
  ACompleted := ACompleteDuration * ASummary.GetRealPercentComplete / 100;
  AList := GetChildren(ASummary);
  try
    if AList.Count = 0 then
      Exit;
    SetLength(ATaskPercentCompleteArray, AList.Count);
    for I := 0 to AList.Count - 1 do
    begin
      if ACompleted = ACompleteDuration then
        ATaskPercentCompleteArray[I] := 100
      else
        ATaskPercentCompleteArray[I] := 0;
      ATask := AList[I];
      if not ATask.IsValueAssigned(TdxGanttTaskAssignedValue.CompleteDuration) then
        UpdateCompleteDuration(AControl, ATask);
    end;
    if (ACompleted > 0) and (ACompleted < ACompleteDuration) then
    begin
      ADates := GetDates(AList);
      try
        for I := 0 to ADates.Count - 1 do
        begin
          AStart := ADates[I];
          if I < ADates.Count - 1 then
            AFinish := ADates[I + 1]
          else
            AFinish := ADates.Last;
          ABeforeWorkCompleted := ACompleted;
          for J := 0 to AList.Count - 1 do
          begin
            ATask := AList[J];
            ATaskDuration := TdxGanttControlDuration.Create(ATask.Duration);
            ATaskDurationInSeconds := ATaskDuration.ToSeconds;
            if ATaskDurationInSeconds > 0 then
            begin
              if ATask.Finish <= AStart then
                Continue;
              if ATask.Start >= AFinish then
                Break;
            end;
            if ATaskDurationInSeconds = 0 then
            begin
              if ACompleted > 0 then
                ATaskPercentCompleteArray[J] := 100;
            end
            else
            begin
              ACount := GetTaskCount(AList, AStart);
              if ACount = 0 then
                Continue;
              if ABeforeWorkCompleted <= 0 then
                Break;
              AIsElapsedFormat := TdxGanttControlDuration.IsElapsedFormat(ATask.DurationFormat);
              AWorkStart := ATask.RealCalendar.GetNextWorkTime(AStart);
              AWorkFinish := ATask.RealCalendar.GetPreviousWorkTime(AFinish);
              ADurationInSeconds := TdxGanttControlDuration.Create(AWorkStart, AWorkFinish, ATask.RealCalendar, AIsElapsedFormat).ToSeconds;
              if ADurationInSeconds = 0 then
                Continue;
              ATaskWorkVariance := ATask.CompleteDuration * ADurationInSeconds / ATaskDurationInSeconds;
              ATaskPercentComplete := Min(100, (ABeforeWorkCompleted / ACount) / ATaskWorkVariance * 100) * (ADurationInSeconds / ATaskDurationInSeconds);
              ACompleted := ACompleted - ATask.CompleteDuration * ATaskPercentComplete / 100;
              ATaskPercentCompleteArray[J] := ATaskPercentCompleteArray[J] + ATaskPercentComplete;
            end;
          end;
        end;
      finally
        ADates.Free;
      end;
    end;
    for I := 0 to AList.Count - 1 do
      SetPercentComplete(AList[I], ATaskPercentCompleteArray[I]);
  finally
    AList.Free;
  end;
  UpdateInnerSummaries;
end;

class procedure TdxDependentSummaryCalculator.UpdateSummaryPercentComplete(AControl: TdxGanttControlBase; ASummary: TdxGanttControlTask);

  function AreAllSubTasksCompleted: Boolean;
  var
    ATasks: TdxGanttControlTasks;
    I: Integer;
  begin
    ATasks := ASummary.Owner;
    for I := ASummary.ID + 1 to ATasks.Count - 1 do
    begin
      if ATasks[I].Blank then
        Continue;
      if ATasks[I].OutlineLevel = ASummary.OutlineLevel then
        Break;
      if ATasks[I].OutlineLevel > ASummary.OutlineLevel + 1 then
        Break;
      if not ATasks[I].IsValueAssigned(TdxGanttTaskAssignedValue.PercentComplete) or (ATasks[I].GetRealPercentComplete < 100) then
        Exit(False);
    end;
    Result := True;
  end;

var
  ACompleteDuration, ATaskCompleteDuration: Double;
  ATasks: TdxGanttControlTasks;
  I: Integer;
  APercentComplete: Integer;
begin
  ACompleteDuration := 0;
  if not ASummary.IsValueAssigned(TdxGanttTaskAssignedValue.CompleteDuration) then
    CalculateSummaryCompleteDuration(AControl, ASummary);
  ATasks := ASummary.Owner;
  for I := ASummary.ID + 1 to ATasks.Count - 1 do
  begin
    if ATasks[I].Blank then
      Continue;
    if ATasks[I].OutlineLevel = ASummary.OutlineLevel then
      Break;
    if ATasks[I].OutlineLevel > ASummary.OutlineLevel + 1 then
      Break;
    if not ATasks[I].IsValueAssigned(TdxGanttTaskAssignedValue.PercentComplete) or (ATasks[I].GetRealPercentComplete = 0) then
      Continue;
    if not ATasks[I].IsValueAssigned(TdxGanttTaskAssignedValue.CompleteDuration) then
      UpdateCompleteDuration(AControl, ATasks[I]);
    ATaskCompleteDuration := ATasks[I].CompleteDuration;
    ACompleteDuration := ACompleteDuration + ATaskCompleteDuration * ATasks[I].GetRealPercentComplete / 100;
  end;
  if ASummary.CompleteDuration > 0 then
  begin
    APercentComplete := Min(Round(ACompleteDuration / ASummary.CompleteDuration * 100), 100);
    if (APercentComplete = 100) and not AreAllSubTasksCompleted then
      Dec(APercentComplete);
    SetPercentComplete(AControl, ASummary, APercentComplete);
  end;
end;

class procedure TdxDependentSummaryCalculator.UpdateSummary(AControl: TdxGanttControlBase; ASummary: TdxGanttControlTask);
begin
  if not IsSummary(ASummary) then
    Exit;
  CalculateSummaryStartAndFinish(AControl, ASummary);
  CalculateSummaryCompleteDuration(AControl, ASummary);
  UpdateSummaryPercentComplete(AControl, ASummary);
  CalculateSummaryWorkVariance(AControl, ASummary);
  UpdateSummaryPercentWorkComplete(AControl, ASummary);
  UpdateSummary(AControl, GetSummary(ASummary));
end;

class function TdxDependentSummaryCalculator.GetTotalSummaryDuration(ASummary: TdxGanttControlTask): Int64;
var
  ATasks: TdxGanttControlTasks;
  I: Integer;
begin
  Result := 0;
  ATasks := ASummary.Owner;
  for I := ASummary.ID + 1 to ATasks.Count - 1 do
  begin
    if ATasks[I].Blank then
      Continue;
    if ATasks[I].OutlineLevel = ASummary.OutlineLevel then
      Break;
    if ATasks[I].OutlineLevel = ASummary.OutlineLevel + 1 then
    begin
      if ATasks[I].Summary then
        Result := GetTotalSummaryDuration(ATasks[I])
      else
        if ATasks[I].IsValueAssigned(TdxGanttTaskAssignedValue.Duration) then
          Result := Result + TdxGanttControlDuration.Create(ATasks[I].Duration).ToSeconds;
    end;
  end;
end;

class procedure TdxDependentSummaryCalculator.CalculateParentSummaryPercentWorkComplete(AControl: TdxGanttControlBase; ATask: TdxGanttControlTask);
var
  ASummary: TdxGanttControlTask;
begin
  ASummary := GetSummary(ATask);
  if ASummary = nil then
    Exit;
  TdxDependentSummaryCalculator.UpdateSummaryPercentWorkComplete(AControl, ASummary);
  CalculateParentSummaryPercentWorkComplete(AControl, ASummary);
end;

class procedure TdxDependentSummaryCalculator.CalculateSummaryStartAndFinish(AControl: TdxGanttControlBase; ASummary: TdxGanttControlTask);

  procedure CalculateTimeBounds(ASummary: TdxGanttControlTask; var AStart, AFinish: TDateTime);
  var
    I: Integer;
    ATask: TdxGanttControlTask;
  begin
    for I := ASummary.Owner.IndexOf(ASummary) + 1 to ASummary.Owner.Count - 1 do
    begin
      ATask := ASummary.Owner[I];
      if ATask.Blank or (ATask.ConstraintType = TdxGanttControlTaskConstraintType.AsLateAsPossible) then
        Continue;
      if ATask.OutlineLevel <= ASummary.OutlineLevel then
        Break;
      if ATask.OutlineLevel > ASummary.OutlineLevel + 1 then
        Continue;
      if ATask.IsValueAssigned(TdxGanttTaskAssignedValue.Start) then
        AStart := Min(AStart, ATask.Start);
      if ATask.IsValueAssigned(TdxGanttTaskAssignedValue.Finish) then
        AFinish := Max(AFinish, ATask.Finish);
      if ATask.Summary and ATask.Manual then
        CalculateTimeBounds(ATask, AStart, AFinish);
    end;
  end;

var
  AStart, AFinish: TDateTime;
begin
  if (ASummary = nil) or ASummary.Manual then
    Exit;
  AStart := MaxDateTime;
  AFinish := MinDateTime;
  CalculateTimeBounds(ASummary, AStart, AFinish);
  if (AStart <> ASummary.Start) and (AStart <> MaxDateTime) then
    SetStart(AControl, ASummary, AStart);
  if (AFinish <> ASummary.Finish) and (AFinish <> MinDateTime) then
    SetFinish(AControl, ASummary, AFinish);
  if (AStart = MaxDateTime) and (AFinish = MinDateTime) then
  begin
    SetStart(AControl, ASummary, TdxTaskCalculator.CalculateBasicStart(ASummary));
    SetFinish(AControl, ASummary, ASummary.Start);
  end;
  UpdateDuration(AControl, ASummary);
end;

class function TdxDependentSummaryCalculator.GetChildren(ASummary: TdxGanttControlTask): TList<TdxGanttControlTask>;
var
  I: Integer;
  AComparer: IComparer<TdxGanttControlTask>;
begin
  Result := TList<TdxGanttControlTask>.Create;
  for I := ASummary.ID + 1 to ASummary.Owner.Count - 1 do
  begin
    if ASummary.Blank then
      Continue;
    if ASummary.Owner[I].OutlineLevel = ASummary.OutlineLevel then
      Break;
    if ASummary.Owner[I].Summary then
      Continue;
    if not ASummary.Owner[I].IsValueAssigned(TdxGanttTaskAssignedValue.Duration) or not ASummary.Owner[I].IsValueAssigned(TdxGanttTaskAssignedValue.Start) then
      Continue;
    Result.Add(ASummary.Owner[I]);
  end;
  AComparer := TdxTaskStartComparer.Create;
  Result.Sort(AComparer);
end;

class function TdxDependentSummaryCalculator.GetDates(AList: TList<TdxGanttControlTask>): TList<TDateTime>;
var
  I, AIndex: Integer;
begin
  Result := TList<TDateTime>.Create;
  for I := 0 to AList.Count - 1 do
  begin
    if not Result.BinarySearch(AList[I].Start, AIndex) then
      Result.Insert(AIndex, AList[I].Start);
    if not Result.BinarySearch(AList[I].Finish, AIndex) then
      Result.Insert(AIndex, AList[I].Finish);
  end;
end;

class function TdxDependentSummaryCalculator.GetTaskCount(AList: TList<TdxGanttControlTask>; ADateTime: TDateTime): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to AList.Count - 1 do
  begin
    if AList[I].Start = AList[I].Finish then
      Continue;
    if (ADateTime >= AList[I].Start) and (ADateTime < AList[I].Finish) then
      Inc(Result);
  end;
end;

{ TdxDependentLinkCalculator }

procedure TdxDependentLinksCalculator.Calculate;
var
  I: Integer;
  ATask: TdxGanttControlTask;
begin
  TdxGanttControlTasksAccess(Task.Owner).CalculateDirtyTask(Task);
  if TdxGanttControlTasksAccess(Task.Owner).IsDirtyTask(Task) then
    Exit;
  for I := 0 to TdxGanttControlTaskAccess(Task).Links.Count - 1 do
  begin
    ATask := TdxGanttControlTask(TdxGanttControlTaskAccess(Task).Links[I]);
    CalculateLink(Control, ATask, False);
  end;
end;

class procedure TdxDependentLinksCalculator.CalculateLink(AControl: TdxGanttControlBase; ATask: TdxGanttControlTask; AForce: Boolean);

  function GetStart: TDateTime;
  var
    ADuration: TdxGanttControlDuration;
    ADataModel: TdxGanttControlDataModel;
  begin
    Result := MinDateTime;
    if ATask.Manual then
    begin
      if not AForce or not ATask.IsValueAssigned(TdxGanttTaskAssignedValue.PredecessorLinks) or (ATask.PredecessorLinks.Count = 0) then
        if ATask.IsValueAssigned(TdxGanttTaskAssignedValue.Start) then
          Result := ATask.Start;
    end
    else
    begin
      if ATask.IsValueAssigned(TdxGanttTaskAssignedValue.ConstraintType) then
      begin
        ADuration := TdxGanttControlDuration.Create(ATask.RealDuration);
        case ATask.ConstraintType of
          TdxGanttControlTaskConstraintType.StartNoEarlierThan:
            Result := ATask.ConstraintDate;
          TdxGanttControlTaskConstraintType.FinishNoEarlierThan:
            Result := ADuration.GetWorkStart(ATask.ConstraintDate, ATask.RealCalendar, ATask.RealDurationFormat);
        end;
      end;
      if (Result = MinDateTime) and (not ATask.IsValueAssigned(TdxGanttTaskAssignedValue.PredecessorLinks) or (ATask.PredecessorLinks.Count = 0)) then
      begin
        ADataModel := TdxGanttControlDataModel(ATask.DataModel);
        Result := ADataModel.RealProjectStart;
      end;
    end;
  end;

  function GetFinish: TDateTime;
  var
    ADuration: TdxGanttControlDuration;
  begin
    Result := MinDateTime;
    if ATask.Manual then
    begin
      if ATask.IsValueAssigned(TdxGanttTaskAssignedValue.Finish) then
        Result := ATask.Finish;
    end
    else
      if ATask.IsValueAssigned(TdxGanttTaskAssignedValue.ConstraintType) then
      begin
        ADuration := TdxGanttControlDuration.Create(ATask.RealDuration);
        case ATask.ConstraintType of
          TdxGanttControlTaskConstraintType.StartNoEarlierThan:
            Result := ADuration.GetWorkFinish(ATask.ConstraintDate, ATask.RealCalendar, ATask.RealDurationFormat);
          TdxGanttControlTaskConstraintType.FinishNoEarlierThan:
            Result := ATask.ConstraintDate;
        end;
      end;
  end;

  procedure CalculateSummary;
  var
    I: Integer;
  begin
    for I := ATask.ID + 1 to ATask.Owner.Count - 1 do
    begin
      if ATask.Owner[I].Blank then
        Continue;
      if ATask.Owner[I].OutlineLevel = ATask.OutlineLevel + 1 then
        TdxDependentLinksCalculator.CalculateLink(AControl, ATask.Owner[I], False)
      else
        Break;
    end;
  end;

var
  ADuration: TdxGanttControlDuration;
  AStart, AFinish: TDateTime;
begin
  if ATask.Summary then
  begin
    CalculateSummary;
    Exit;
  end;
  if not AForce and ATask.Manual then
    Exit;
  AStart := GetStart;
  AFinish := GetFinish;
  CalculateStartAndFinish(ATask, AStart, AFinish);
  if AStart = MinDateTime then
    AStart := ATask.RealCalendar.GetNextWorkTime(DateOf(ATask.Created));
  if not ATask.IsValueAssigned(TdxGanttTaskAssignedValue.Start) or (ATask.Start <> AStart) then
  begin
    ADuration := TdxGanttControlDuration.Create(ATask.RealDuration);
    if not ADuration.IsZero then
      AStart := ATask.RealCalendar.GetNextWorkTime(AStart);
    SetStart(AControl, ATask, AStart);
    SetDuration(AControl, ATask, ADuration.ToString);
  end;
end;

class function TdxDependentLinksCalculator.CalculateMinStart(ATask: TdxGanttControlTask): TDateTime;
var
  AFinish: TDateTime;
begin
  Result := MinDateTime;
  AFinish := MinDateTime;
  CalculateStartAndFinish(ATask, Result, AFinish);
  if Result = MinDateTime then
    Result := TdxGanttControlDataModel(ATask.DataModel).RealProjectStart;
end;

class procedure TdxDependentLinksCalculator.UpdateTaskStart(AControl: TdxGanttControlBase; ATask: TdxGanttControlTask);
var
  AStart: TDateTime;
begin
  if not ATask.IsValueAssigned(TdxGanttTaskAssignedValue.Start) or not ATask.IsValueAssigned(TdxGanttTaskAssignedValue.Manual) or ATask.Manual then
    Exit;

  AStart := CalculateMinStart(ATask);
  TdxTaskCalculator.SetStart(AControl, ATask, AStart);
end;

class procedure TdxDependentLinksCalculator.CalculateStartAndFinish(ATask: TdxGanttControlTask; var AStart, AFinish: TDateTime);

  procedure CalculateTaskAsLateAsPossible(ACalculatedTask: TdxGanttControlTask; var ACurrentFinish: TDateTime);
  var
    I: Integer;
    ADuration: TdxGanttControlDuration;
    ALinks: TdxFastList;
  begin
    ADuration := TdxGanttControlDuration.Create(ATask.RealDuration);
    if ACalculatedTask.IsValueAssigned(TdxGanttTaskAssignedValue.ConstraintType) and ACalculatedTask.IsValueAssigned(TdxGanttTaskAssignedValue.ConstraintDate) and
      (ACalculatedTask.ConstraintType in [TdxGanttControlTaskConstraintType.FinishNoLaterThan, TdxGanttControlTaskConstraintType.StartNoLaterThan]) then
    begin
      if ACalculatedTask.ConstraintType = TdxGanttControlTaskConstraintType.FinishNoLaterThan then
        ACurrentFinish := Min(ACurrentFinish, ADuration.GetWorkStart(ACalculatedTask.ConstraintDate, ACalculatedTask.RealCalendar, ACalculatedTask.RealDurationFormat))
      else
        ACurrentFinish := Min(ACurrentFinish, ACalculatedTask.ConstraintDate);
      Exit;
    end;
    TdxGanttControlTasksAccess(ATask.Owner).CalculateDirtyTask(ACalculatedTask);
    ALinks := TdxGanttControlTaskAccess(ACalculatedTask).Links;
    for I := 0 to ALinks.Count - 1 do
    begin
      CalculateTaskAsLateAsPossible(TdxGanttControlTask(ALinks[I]), ACurrentFinish);
      ACurrentFinish := Min(ACurrentFinish, ADuration.GetWorkStart(ACurrentFinish, ACalculatedTask.RealCalendar, ACalculatedTask.RealDurationFormat));
    end;
  end;

  procedure CalculateConstraintAsLateAsPossible;
  begin
    AFinish := TdxGanttControlDataModel(ATask.DataModel).RealProjectFinish;
    CalculateTaskAsLateAsPossible(ATask, AFinish);
  end;

  procedure CalculateConstraint(ADuration: TdxGanttControlDuration);
  begin
    case ATask.ConstraintType of
      TdxGanttControlTaskConstraintType.AsLateAsPossible:
        CalculateConstraintAsLateAsPossible;
      TdxGanttControlTaskConstraintType.StartNoEarlierThan:
        AStart := Max(AStart, ATask.ConstraintDate);
      TdxGanttControlTaskConstraintType.StartNoLaterThan:
        AStart := Min(AStart, ATask.ConstraintDate);
      TdxGanttControlTaskConstraintType.FinishNoEarlierThan:
        AFinish := Max(AFinish, ATask.ConstraintDate);
      TdxGanttControlTaskConstraintType.FinishNoLaterThan:
        AStart := Min(AStart, ADuration.GetWorkStart(ATask.ConstraintDate, ATask.RealCalendar, ATask.RealDurationFormat));
    end;
  end;

var
  ASummary: TdxGanttControlTask;
  ADuration: TdxGanttControlDuration;
  AOldFinish: TDateTime;
  AHasConstraint: Boolean;
begin
  if ATask.Summary then
    Exit;
  if ATask.RealDuration = '' then
    Exit;
  if ATask.IsValueAssigned(TdxGanttTaskAssignedValue.ConstraintType) and ATask.IsValueAssigned(TdxGanttTaskAssignedValue.ConstraintDate) and
    (ATask.ConstraintType in [TdxGanttControlTaskConstraintType.MustStartOn, TdxGanttControlTaskConstraintType.MustFinishOn]) then
  begin
    if ATask.ConstraintType = TdxGanttControlTaskConstraintType.MustStartOn then
      AStart := ATask.ConstraintDate
    else
    begin
      ADuration := TdxGanttControlDuration.Create(ATask.RealDuration);
      AStart := ADuration.GetWorkStart(ATask.ConstraintDate, ATask.RealCalendar, ATask.RealDurationFormat);
    end;
  end
  else
  begin
    AOldFinish := AFinish;
    DoCalculateStartAndFinish(ATask, AStart, AFinish);
    ASummary := GetSummary(ATask);
    while ASummary <> nil do
    begin
      if not ASummary.Manual then
        DoCalculateStartAndFinish(ASummary, AStart, AFinish);
      ASummary := GetSummary(ASummary);
    end;
    ADuration := TdxGanttControlDuration.Create(ATask.RealDuration);
    AHasConstraint := ATask.IsValueAssigned(TdxGanttTaskAssignedValue.ConstraintType) and
      (ATask.IsValueAssigned(TdxGanttTaskAssignedValue.ConstraintDate) or (ATask.ConstraintType = TdxGanttControlTaskConstraintType.AsLateAsPossible));
    if AHasConstraint then
      CalculateConstraint(ADuration);
    if AFinish <> AOldFinish then
    begin
      if AHasConstraint and
        (ATask.ConstraintType in [TdxGanttControlTaskConstraintType.FinishNoLaterThan, TdxGanttControlTaskConstraintType.AsLateAsPossible]) then
      begin
        if ADuration.IsZero then
          AStart := AFinish
        else
          AStart := ADuration.GetWorkStart(AFinish, ATask.RealCalendar, ATask.RealDurationFormat);
      end
      else
      begin
        if ADuration.IsZero then
          AStart := Max(AStart, AFinish)
        else
          AStart := Max(AStart, ADuration.GetWorkStart(AFinish, ATask.RealCalendar, ATask.RealDurationFormat));
      end;
    end;
  end;
  if not ATask.IsValueAssigned(TdxGanttTaskAssignedValue.Start) or (ATask.Start <> AStart) then
    if not ADuration.IsZero then
      AStart := ATask.RealCalendar.GetNextWorkTime(AStart);
end;

class function TdxDependentLinksCalculator.CheckLinks(
  ATask: TdxGanttControlTask): Boolean;
var
  I: Integer;
begin
  Result := True;
  if (ATask = nil) or not ATask.IsValueAssigned(TdxGanttTaskAssignedValue.PredecessorLinks) then
    Exit;
  for I := 0 to ATask.PredecessorLinks.Count - 1 do
  begin
    if not TdxTaskCalculator.AllowLink(ATask, ATask.PredecessorLinks[I].PredecessorUID) then
      Exit(False);
  end;
end;

class procedure TdxDependentLinksCalculator.DoCalculateStartAndFinish(ATask: TdxGanttControlTask; var AStart, AFinish: TDateTime);

  function GetPredecessorDuration(APredecessor: TdxGanttControlTask): TDateTime;
  var
    ADuration: TdxGanttControlDuration;
  begin
    ADuration := TdxGanttControlDuration.Create(APredecessor.Duration);
    Result := OneSecond * ADuration.Second + OneMinute * ADuration.Minute +
      OneHour * ADuration.Hour;
  end;

  function GetLinkLagDuration(APredecessor: TdxGanttControlTask; ALink: TdxGanttControlTaskPredecessorLink): TdxGanttControlDuration;
  var
    ALag: Integer;
    H, M, S: Integer;
  begin
    ALag := Abs(ALink.LinkLag);
    if ALink.IsPercentLagFormat then
      ALag := Ceil(GetPredecessorDuration(APredecessor) * ALag * 24 * 60 * 10 / 100);
    H := Trunc(ALag / 10 / 60);
    ALag := ALag - H * 10 * 60;
    M := Trunc(ALag / 10);
    ALag := ALag - M * 10;
    S := Trunc(ALag * 60 / 10);
    Result := TdxGanttControlDuration.Create(Format('PT%dH%dM%dS', [H, M, S]));
  end;

  function GetNextDateTime(ADateTime: TDateTime; APredecessor: TdxGanttControlTask; ALink: TdxGanttControlTaskPredecessorLink): TDateTime;
  var
    ALinkLagDuration: TdxGanttControlDuration;
  begin
    Result := ADateTime;
    if not ALink.IsElapsedLagFormat then
      if ALink.LinkLag > 0 then
        ADateTime := ATask.RealCalendar.GetNextWorkTime(ADateTime)
      else
        ADateTime := ATask.RealCalendar.GetPreviousWorkTime(ADateTime);
    ALinkLagDuration := GetLinkLagDuration(APredecessor, ALink);
    if ALink.LinkLag > 0 then
      Result := ALinkLagDuration.GetWorkFinish(ADateTime, ATask.RealCalendar, ALink.IsElapsedLagFormat)
    else if ALink.LinkLag < 0 then
      Result := ALinkLagDuration.GetWorkStart(ATask.RealCalendar.GetPreviousWorkTime(ADateTime), ATask.RealCalendar, ALink.IsElapsedLagFormat);
  end;

var
  I: Integer;
  ALink: TdxGanttControlTaskPredecessorLink;
  APredecessor: TdxGanttControlTask;
  APredecessorLinks: TdxGanttControlTaskPredecessorLinks;
  ALinkType: TdxGanttControlTaskPredecessorLinkType;
begin
  APredecessorLinks := ATask.PredecessorLinks;
  for I := 0 to APredecessorLinks.Count - 1 do
  begin
    ALink := APredecessorLinks[I];
    if not ALink.IsValueAssigned(TdxGanttTaskPredecessorLinkAssignedValue.PredecessorUID) then
      Continue;
    APredecessor := ATask.Owner.GetItemByUID(ALink.PredecessorUID);
    if APredecessor = nil then
      Continue;
    if not ALink.IsValueAssigned(TdxGanttTaskPredecessorLinkAssignedValue.&Type) then
      ALinkType := TdxGanttControlTaskPredecessorLinkType.FS
    else
      ALinkType := ALink.&Type;
    if ATask.Summary and (ALinkType in [TdxGanttControlTaskPredecessorLinkType.FF, TdxGanttControlTaskPredecessorLinkType.SF]) then
      Continue;
    case ALinkType of
      TdxGanttControlTaskPredecessorLinkType.FF:
        if APredecessor.IsValueAssigned(TdxGanttTaskAssignedValue.Finish) then
          AFinish := Max(GetNextDateTime(APredecessor.Finish, APredecessor, ALink), AFinish);
      TdxGanttControlTaskPredecessorLinkType.FS:
        if APredecessor.IsValueAssigned(TdxGanttTaskAssignedValue.Finish) then
          AStart := Max(GetNextDateTime(APredecessor.Finish, APredecessor, ALink), AStart);
      TdxGanttControlTaskPredecessorLinkType.SF:
        if APredecessor.IsValueAssigned(TdxGanttTaskAssignedValue.Start) then
          AFinish := Max(GetNextDateTime(APredecessor.Start, APredecessor, ALink), AFinish);
      TdxGanttControlTaskPredecessorLinkType.SS:
        if APredecessor.IsValueAssigned(TdxGanttTaskAssignedValue.Start) then
          AStart := Max(GetNextDateTime(APredecessor.Start, APredecessor, ALink), AStart);
    end;
  end;
end;

class procedure TdxDependentLinksCalculator.UpdateLateAsPossibleTasks(AControl: TdxGanttControlBase);
var
  I: Integer;
  ALateAsPossibleTasks: TdxFastList;
  AStart: TDateTime;
  ATask: TdxGanttControlTask;
begin
  ALateAsPossibleTasks := TdxGanttControlTasksAccess(TdxCustomGanttControl(AControl).DataModel.Tasks).LateAsPossibleTasks;
  for I := 0 to ALateAsPossibleTasks.Count - 1 do
  begin
    ATask := TdxGanttControlTask(ALateAsPossibleTasks[I]);
    AStart := CalculateMinStart(ATask);
    if (AStart > MinDateTime) and (CompareDateTime(ATask.Start, AStart) <> 0) then
      SetStart(AControl, ATask, AStart);
  end;
end;

{ TdxGanttControlTaskCandidatePredecessorLinks }

function TdxGanttControlTaskCandidatePredecessorLinks.CheckDuplicate: Boolean;
var
  I, J: Integer;
begin
  Result := True;
  for I := 1 to Count - 1 do
    for J := 0 to I - 1 do
      if IsEqual(Items[I], Items[J]) then
        Exit(False);
end;

class function TdxGanttControlTaskCandidatePredecessorLinks.CreateFromString(
  ATask: TdxGanttControlTask; const Value: string): TdxGanttControlTaskCandidatePredecessorLinks;

  function ExtractID(const S: string; var AStartPos: Integer; out AUID: Integer): Boolean;
  var
    st: string;
    I: Integer;
  begin
    st := '';
    for I := AStartPos to Length(S) do
      if CharInSet(S[I], ['0'..'9']) then
        st := st + S[I]
      else
      begin
        AStartPos := I;
        Break;
      end;
    Result := TryStrToInt(st, AUID);
  end;

  function ExtractLinkType(const S: string; var AStartPos: Integer; out AType: TdxGanttControlTaskPredecessorLinkType): Boolean;
  var
    FF, FS, SF, SS: string;
    L: Integer;
  begin
    FF := AnsiUpperCase(cxGetResourceString(@sdxGanttControlTaskPredecessorLinkTypeFF));
    FS := AnsiUpperCase(cxGetResourceString(@sdxGanttControlTaskPredecessorLinkTypeFS));
    SF := AnsiUpperCase(cxGetResourceString(@sdxGanttControlTaskPredecessorLinkTypeSF));
    SS := AnsiUpperCase(cxGetResourceString(@sdxGanttControlTaskPredecessorLinkTypeSS));
    L := Length(S);
    Result := True;
    if (AStartPos + Length(FS) - 1 <= L) and (CompareMem(@S[AStartPos], @FS[1], Length(FS) * SizeOf(Char))) then
    begin
      AType := TdxGanttControlTaskPredecessorLinkType.FS;
      AStartPos := AStartPos + Length(FS);
    end
    else
    if (AStartPos + Length(FF) - 1 <= L) and (CompareMem(@S[AStartPos], @FF[1], Length(FF) * SizeOf(Char))) then
    begin
      AType := TdxGanttControlTaskPredecessorLinkType.FF;
      AStartPos := AStartPos + Length(FF);
    end
    else
    if (AStartPos + Length(SF) - 1 <= L) and (CompareMem(@S[AStartPos], @SF[1], Length(SF) * SizeOf(Char))) then
    begin
      AType := TdxGanttControlTaskPredecessorLinkType.SF;
      AStartPos := AStartPos + Length(SF);
    end
    else
    if (AStartPos + Length(SS) - 1 <= L) and (CompareMem(@S[AStartPos], @SS[1], Length(SS) * SizeOf(Char))) then
    begin
      AType := TdxGanttControlTaskPredecessorLinkType.SS;
      AStartPos := AStartPos + Length(SS);
    end
    else
      Result := False;
  end;

  function ExtractLinkLag(const S: string; var AStartPos: Integer; out ALag: Double): Boolean;
  var
    I, P: Integer;
  begin
    if AStartPos > Length(S) then
    begin
      Result := True;
      ALag := 0;
      Exit;
    end;
    P := Length(S);
    for I := AStartPos to Length(S) do
      if not CharInSet(S[I], ['-', '+', TdxCultureInfo.CurrentCulture.FormatSettings.DecimalSeparator, '0'..'9']) then
      begin
        P := I - 1;
        Break;
      end;
    Result := TryStrToFloat(Copy(S, AStartPos, P - AStartPos + 1), ALag, TdxCultureInfo.CurrentCulture.FormatSettings);
    AStartPos := P + 1;
  end;

  function ExtractLagFormat(const S: string; var AStartPos: Integer;
    out ALagFormat: TdxGanttControlTaskPredecessorLagFormat): Boolean;
  var
    L: Integer;
    AError: Boolean;
    AErrText: TCaption;
  begin
    L := Length(S);
    if AStartPos > L then
    begin
      Result := True;
      ALagFormat := TdxGanttControlTaskPredecessorLagFormat.Days;
    end
    else
    begin
      TdxGanttControlTaskDependencyDialogFormAccess.InitializeMeasurementUnits;
      ALagFormat := TdxGanttControlTaskDependencyDialogFormAccess.GetLagFormat(
        Copy(S, AStartPos, L - AStartPos + 1), AError, AErrText);
      Result := not AError;
    end;
  end;

  function DoParse(AToken: string; out APredecessorID: Integer; out ALinkType: TdxGanttControlTaskPredecessorLinkType;
    out ALinkLag: Double; out ALagFormat: TdxGanttControlTaskPredecessorLagFormat): Boolean;
  var
    AStartPos: Integer;
  begin
    AToken := AnsiUpperCase(TdxStringHelper.Replace(AToken, ' ', ''));
    AStartPos := 1;
    Result := ExtractID(AToken, AStartPos, APredecessorID) and ExtractLinkType(AToken, AStartPos, ALinkType) and
      ExtractLinkLag(AToken, AStartPos, ALinkLag) and ExtractLagFormat(AToken, AStartPos, ALagFormat);
  end;

  function PopulateLinkFromToken(ALink: TdxGanttControlTaskPredecessorLink; AToken: string): Boolean;
  var
    APredecessorID: Integer;
    ALinkType: TdxGanttControlTaskPredecessorLinkType;
    ALinkLag: Double;
    ALagFormat: TdxGanttControlTaskPredecessorLagFormat;
  begin
    Result := True;
    if TryStrToInt(AToken, APredecessorID) then
    begin
      if APredecessorID < 0 then
        Result := False
      else
      begin
        ALinkType := TdxGanttControlTaskPredecessorLinkType.FS;
        ALinkLag := 0;
        ALagFormat := TdxGanttControlTaskPredecessorLagFormat.Days;
      end
    end
    else
      Result := DoParse(AToken, APredecessorID, ALinkType, ALinkLag, ALagFormat);
    if Result then
    begin
      if APredecessorID <= ATask.Owner.Count - 1 then
        ALink.PredecessorUID := ATask.Owner.Items[APredecessorID].UID
      else
        ALink.PredecessorUID := -APredecessorID;
      ALink.&Type := ALinkType;
      ALink.LagFormat := ALagFormat;
      ALink.LinkLag := TdxGanttControlTaskDependencyDialogFormAccess.GetLinkLag(ALinkLag, ALagFormat);
    end;
  end;

var
  AError: Boolean;
  ATokens: TStringList;
  AToken: string;
  ALink: TdxGanttControlTaskPredecessorLink;
  I: Integer;
begin
  AError := False;
  Result := TdxGanttControlTaskCandidatePredecessorLinks.Create(ATask);
  ATokens := TStringList.Create;
  try
    ATokens.Delimiter := TdxCultureInfo.CurrentCulture.FormatSettings.ListSeparator;
    ATokens.DelimitedText := TdxStringHelper.Replace(Value, ' ', '');
    for I := 0 to ATokens.Count - 1 do
    begin
      AToken := ATokens[I];
      if AToken <> '' then
      begin
        ALink := Result.Append;
        AError := not PopulateLinkFromToken(ALink, AToken);
        if AError then
          Break;
      end;
    end;
  finally
    ATokens.Free;
  end;
  if AError then
    FreeAndNil(Result);
end;

procedure TdxGanttControlTaskCandidatePredecessorLinks.DoChanged;
begin
// do nothing
end;

function TdxGanttControlTaskCandidatePredecessorLinks.IsEqual(
  AItem1, AItem2: TdxGanttControlTaskPredecessorLink): Boolean;
begin
  Result := AItem1.PredecessorUID = AItem2.PredecessorUID;
end;

procedure TdxGanttControlTaskCandidatePredecessorLinks.RemoveDuplicated;
var
  AIndex, I: Integer;
begin
  AIndex := 0;
  while AIndex < Count - 1 do
  begin
    for I := Count - 1 downto AIndex + 1 do
      if IsEqual(Items[AIndex], Items[I]) then
        Remove(Items[I]);
    Inc(AIndex);
  end;
end;

{ TdxTaskStartComparer }

function TdxTaskStartComparer.Compare(const Left, Right: TdxGanttControlTask): Integer;
begin
  if not Left.IsValueAssigned(TdxGanttTaskAssignedValue.Start) and not Right.IsValueAssigned(TdxGanttTaskAssignedValue.Start) then
    Result := 0
  else
  begin
    if not Left.IsValueAssigned(TdxGanttTaskAssignedValue.Start) then
      Exit(1)
    else if not Right.IsValueAssigned(TdxGanttTaskAssignedValue.Start) then
      Exit(-1);
    Result := Sign(Left.Start - Right.Start);
    if Result = 0 then
      Result := Sign(TdxGanttControlDuration.Create(Left.RealDuration).ToSeconds - TdxGanttControlDuration.Create(Right.RealDuration).ToSeconds);
  end;
end;

{ TdxTaskIDComparer }

function TdxTaskIDComparer.Compare(const Left, Right: TdxGanttControlTask): Integer;
begin
  Result := Sign(Left.ID - Right.ID);
end;

{ TdxGanttControlTaskCandidateResource }

constructor TdxGanttControlTaskCandidateResource.Create(AResource: TdxGanttControlResource);
begin
  inherited Create;
  FResource := AResource;
end;

constructor TdxGanttControlTaskCandidateResource.Create(const AName: string);
begin
  inherited Create;
  FResource := nil;
  FName := AName;
end;

{ TdxGanttControlTaskCandidateResources }

class function TdxGanttControlTaskCandidateResources.CreateFromString(
  ATask: TdxGanttControlTask; const Value: string): TdxGanttControlTaskCandidateResources;

  procedure AddCandidate(const AName: string);
  var
    AResource: TdxGanttControlResource;
  begin
    if AName <> '' then
    begin
      AResource := (ATask.DataModel as TdxGanttControlDataModel).Resources.GetItemByName(AName);
      if AResource <> nil then
        Result.Add(TdxGanttControlTaskCandidateResource.Create(AResource))
      else
        Result.Add(TdxGanttControlTaskCandidateResource.Create(AName));
    end;
  end;

var
  S: string;
  P: Integer;
begin
  Result := TdxGanttControlTaskCandidateResources.Create(True);
  S := Trim(Value);
  if S = '' then
    Exit;
  P := Pos(TdxCultureInfo.CurrentCulture.FormatSettings.ListSeparator, S);
  while P > 0 do
  begin
    AddCandidate(Trim(Copy(S, 1, P - 1)));
    System.Delete(S, 1, P);
    P := Pos(TdxCultureInfo.CurrentCulture.FormatSettings.ListSeparator, S);
  end;
  if S <> '' then
    AddCandidate(Trim(S));
end;

function TdxGanttControlTaskCandidateResources.CheckDuplicate: Boolean;
var
  I, J: Integer;
  AResource: TdxGanttControlTaskCandidateResource;
begin
  Result := True;
  for I := 1 to Count - 1 do
  begin
    AResource := TdxGanttControlTaskCandidateResource(Items[I]);
    for J := 0 to I - 1 do
      if IsEqual(AResource, TdxGanttControlTaskCandidateResource(Items[J])) then
        Exit(False);
  end;
end;

function TdxGanttControlTaskCandidateResources.IsEqual(AItem1, AItem2: TdxGanttControlTaskCandidateResource): Boolean;
begin
  Result := ((AItem1.Resource <> nil) and (AItem2.Resource <> nil) and (AItem1.Resource.UID = AItem2.Resource.UID)) or
            ((AItem1.Resource = nil) and (AItem2.Resource = nil) and (AItem1.Name = AItem2.Name));
end;

procedure TdxGanttControlTaskCandidateResources.RemoveDuplicated;
var
  AIndex, I: Integer;
  AResource: TdxGanttControlTaskCandidateResource;
begin
  AIndex := 0;
  while AIndex < Count - 1 do
  begin
    AResource := TdxGanttControlTaskCandidateResource(Items[AIndex]);
    for I := Count - 1 downto AIndex + 1 do
      if IsEqual(AResource, TdxGanttControlTaskCandidateResource(Items[I])) then
        Remove(Items[I]);
    Inc(AIndex);
  end;
end;

{ TdxGanttControlTaskHistoryItem }

constructor TdxGanttControlTaskHistoryItem.Create(
  AHistory: TdxGanttControlHistory; ATask: TdxGanttControlTask);
begin
  inherited Create(AHistory);
  FTask := ATask;
end;

{ TdxGanttControlTaskMakeNotNullHistoryItem }

constructor TdxGanttControlTaskMakeNotNullHistoryItem.Create(
  AHistory: TdxGanttControlHistory; ATask: TdxGanttControlTask);
begin
  inherited Create(AHistory, ATask);
  FIsNull := ATask.Blank;
end;

procedure TdxGanttControlTaskMakeNotNullHistoryItem.DoRedo;
begin
  inherited DoRedo;
  Task.Blank := False;
end;

procedure TdxGanttControlTaskMakeNotNullHistoryItem.DoUndo;
begin
  Task.Blank := FIsNull;
  inherited DoUndo;
end;

{ TdxGanttControlTaskSetAssignedValueHistoryItem }

procedure TdxGanttControlTaskSetAssignedValueHistoryItem.DoUndo;
begin
  Task.ResetValue(FAssignedValue);
  inherited DoUndo;
end;

{ TdxGanttControlTaskBaselineHistoryItem }

function TdxGanttControlTaskBaselineHistoryItem.GetBaseline: TdxGanttControlTaskBaseline;
begin
  Result := TdxGanttControlTaskBaseline(inherited Baseline);
end;

{ TdxGanttControlTaskBaselineSetAssignedValueHistoryItem }

procedure TdxGanttControlTaskBaselineSetAssignedValueHistoryItem.DoUndo;
begin
  Baseline.ResetValue(FAssignedValue);
  inherited DoUndo;
end;

{ TdxGanttControlBaselineHistoryItem }

constructor TdxGanttControlBaselineHistoryItem.Create(
  AOwner: TdxGanttControlHistory; ABaseline: TdxGanttControlElementBaseline);
begin
  inherited Create(AOwner);
  FBaseline := ABaseline;
end;

{ TdxGanttControlBaselineSetAssignedValueHistoryItem }

procedure TdxGanttControlBaselineSetAssignedValueHistoryItem.DoUndo;
begin
  Baseline.ResetValue(FAssignedValue);
  inherited DoUndo;
end;

{ TdxGanttControlTaskPredecessorLinkSetAssignedValueHistoryItem }

procedure TdxGanttControlTaskPredecessorLinkSetAssignedValueHistoryItem.DoUndo;
begin
  Link.ResetValue(FAssignedValue);
  inherited DoUndo;
end;

{ TdxGanttControlTaskResetAssignedValueHistoryItem }

procedure TdxGanttControlTaskResetAssignedValueHistoryItem.DoRedo;
begin
  Task.ResetValue(FAssignedValue);
  inherited DoRedo;
end;

{ TdxGanttControlBaselineResetAssignedValueHistoryItem }

procedure TdxGanttControlBaselineResetAssignedValueHistoryItem.DoRedo;
begin
  Baseline.ResetValue(FAssignedValue);
  inherited DoRedo;
end;

{ TdxGanttControlTaskBaselineResetAssignedValueHistoryItem }

procedure TdxGanttControlTaskBaselineResetAssignedValueHistoryItem.DoUndo;
begin
  Baseline.ResetValue(FAssignedValue);
  inherited DoRedo;
end;

{ TdxGanttControlTaskPredecessorLinkResetAssignedValueHistoryItem }

procedure TdxGanttControlTaskPredecessorLinkResetAssignedValueHistoryItem.DoRedo;
begin
  Link.ResetValue(FAssignedValue);
  inherited DoRedo;
end;

{ TdxGanttControlChangeTaskPropertyHistoryItem }

procedure TdxGanttControlChangeTaskPropertyHistoryItem.SetValue(const Value: Variant);
begin
  if not VarIsNull(Value) then
    DoSetValue(Value);
end;

procedure TdxGanttControlChangeTaskPropertyHistoryItem.DoRedo;
begin
  inherited DoRedo;
  FOldValue := GetValue;
  SetValue(FNewValue);
end;

procedure TdxGanttControlChangeTaskPropertyHistoryItem.DoUndo;
begin
  SetValue(FOldValue);
  inherited DoUndo;
end;

{ TdxGanttControlChangeTaskBaselinePropertyHistoryItem }

procedure TdxGanttControlChangeTaskBaselinePropertyHistoryItem.DoRedo;
begin
  inherited DoRedo;
  FOldValue := GetValue;
  SetValue(FNewValue);
end;

procedure TdxGanttControlChangeTaskBaselinePropertyHistoryItem.DoUndo;
begin
  SetValue(FOldValue);
  inherited DoUndo;
end;

procedure TdxGanttControlChangeTaskBaselinePropertyHistoryItem.SetValue(
  const Value: Variant);
begin
  if not VarIsNull(Value) then
    DoSetValue(Value);
end;

{ TdxGanttControlChangeTaskBaselineStartHistoryItem }

procedure TdxGanttControlChangeTaskBaselineStartHistoryItem.DoSetValue(
  const Value: Variant);
begin
  Baseline.Start := VarToDateTime(Value);
end;

function TdxGanttControlChangeTaskBaselineStartHistoryItem.GetValue: Variant;
begin
  Result := Baseline.Start;
end;

{ TdxGanttControlChangeTaskBaselineFinishHistoryItem }

procedure TdxGanttControlChangeTaskBaselineFinishHistoryItem.DoSetValue(
  const Value: Variant);
begin
  Baseline.Finish := VarToDateTime(Value);
end;

function TdxGanttControlChangeTaskBaselineFinishHistoryItem.GetValue: Variant;
begin
  Result := Baseline.Finish;
end;

{ TdxGanttControlChangeTaskBaselineDurationHistoryItem }

procedure TdxGanttControlChangeTaskBaselineDurationHistoryItem.DoSetValue(
  const Value: Variant);
begin
  Baseline.Duration := VarToStr(Value);
end;

function TdxGanttControlChangeTaskBaselineDurationHistoryItem.GetValue: Variant;
begin
  Result := Baseline.Duration;
end;

{ TdxGanttControlChangeTaskBaselineDurationFormatHistoryItem }

procedure TdxGanttControlChangeTaskBaselineDurationFormatHistoryItem.DoSetValue(
  const Value: Variant);
begin
  Baseline.DurationFormat := Value;
end;

function TdxGanttControlChangeTaskBaselineDurationFormatHistoryItem.GetValue: Variant;
begin
  Result := Baseline.DurationFormat;
end;

{ TdxGanttControlChangeTaskBaselineEstimatedHistoryItem }

procedure TdxGanttControlChangeTaskBaselineEstimatedHistoryItem.DoSetValue(
  const Value: Variant);
begin
  Baseline.Estimated := Value;
end;

function TdxGanttControlChangeTaskBaselineEstimatedHistoryItem.GetValue: Variant;
begin
  Result := Baseline.Estimated;
end;

{ TdxGanttControlChangeTaskBaselineBudgetedCostOfWorkPerformedHistoryItem }

procedure TdxGanttControlChangeTaskBaselineBudgetedCostOfWorkPerformedHistoryItem.DoSetValue(
  const Value: Variant);
begin
  Baseline.BudgetedCostOfWorkPerformed := Value;
end;

function TdxGanttControlChangeTaskBaselineBudgetedCostOfWorkPerformedHistoryItem.GetValue: Variant;
begin
  Result := Baseline.BudgetedCostOfWorkPerformed;
end;

{ TdxGanttControlChangeTaskBaselineBudgetedCostOfWorkScheduledHistoryItem }

procedure TdxGanttControlChangeTaskBaselineBudgetedCostOfWorkScheduledHistoryItem.DoSetValue(
  const Value: Variant);
begin
  Baseline.BudgetedCostOfWorkScheduled := Value;
end;

function TdxGanttControlChangeTaskBaselineBudgetedCostOfWorkScheduledHistoryItem.GetValue: Variant;
begin
  Result := Baseline.BudgetedCostOfWorkScheduled;
end;

{ TdxGanttControlChangeTaskBaselineCostHistoryItem }

procedure TdxGanttControlChangeTaskBaselineCostHistoryItem.DoSetValue(
  const Value: Variant);
begin
  Baseline.Cost := Value;
end;

function TdxGanttControlChangeTaskBaselineCostHistoryItem.GetValue: Variant;
begin
  Result := Baseline.Cost;
end;

{ TdxGanttControlChangeTaskOutlineLevelHistoryItem }

function TdxGanttControlChangeTaskOutlineLevelHistoryItem.GetValue: Variant;
begin
  Result := Task.OutlineLevel;
end;

procedure TdxGanttControlChangeTaskOutlineLevelHistoryItem.DoSetValue(
  const Value: Variant);
begin
  Task.OutlineLevel := Value;
end;

{ TdxGanttControlChangeTaskSummaryHistoryItem }

procedure TdxGanttControlChangeTaskSummaryHistoryItem.DoSetValue(
  const Value: Variant);
begin
  Task.Summary := Value;
end;

function TdxGanttControlChangeTaskSummaryHistoryItem.GetValue: Variant;
begin
  Result := Task.Summary;
end;

{ TdxGanttControlChangeTaskNameHistoryItem }

function TdxGanttControlChangeTaskNameHistoryItem.GetValue: Variant;
begin
  Result := Task.Name;
end;

procedure TdxGanttControlChangeTaskNameHistoryItem.DoSetValue(
  const Value: Variant);
begin
  Task.Name := VarToStr(Value);
end;

{ TdxGanttControlChangeTaskRollupHistoryItem }

procedure TdxGanttControlChangeTaskRollupHistoryItem.DoSetValue(
  const Value: Variant);
begin
  Task.Rollup := Value;
end;

function TdxGanttControlChangeTaskRollupHistoryItem.GetValue: Variant;
begin
  Result := Task.Rollup;
end;

{ TdxGanttControlChangeTaskDisplayOnTimelineHistoryItem }

procedure TdxGanttControlChangeTaskDisplayOnTimelineHistoryItem.DoSetValue(
  const Value: Variant);
begin
  Task.DisplayOnTimeline := Value;
end;

function TdxGanttControlChangeTaskDisplayOnTimelineHistoryItem.GetValue: Variant;
begin
  Result := Task.DisplayOnTimeline;
end;

{ TdxGanttControlChangeRecurringHistoryItem }

procedure TdxGanttControlChangeRecurringHistoryItem.DoSetValue(
  const Value: Variant);
begin
  Task.Recurring := Value;
end;

function TdxGanttControlChangeRecurringHistoryItem.GetValue: Variant;
begin
  Result := Task.Recurring;
end;

{ TdxGanttControlChangeRecurrenceInfoHistoryItem }

procedure TdxGanttControlChangeRecurrenceInfoHistoryItem.DoRedo;
begin
  Task.RecurrencePattern.GetData(FOldValue);
  Task.RecurrencePattern.SetData(FNewValue);
end;

procedure TdxGanttControlChangeRecurrenceInfoHistoryItem.DoUndo;
begin
  Task.RecurrencePattern.SetData(FOldValue);
end;

{ TdxGanttControlChangeTaskCalendarUIDHistoryItem }

procedure TdxGanttControlChangeTaskCalendarUIDHistoryItem.DoSetValue(
  const Value: Variant);
begin
  Task.CalendarUID := Value;
end;

function TdxGanttControlChangeTaskCalendarUIDHistoryItem.GetValue: Variant;
begin
  Result := Task.CalendarUID;
end;

{ TdxGanttControlChangeTaskPercentCompleteHistoryItem }

function TdxGanttControlChangeTaskPercentCompleteHistoryItem.GetValue: Variant;
begin
  Result := Task.PercentComplete;
end;

procedure TdxGanttControlChangeTaskPercentCompleteHistoryItem.DoSetValue(
  const Value: Variant);
begin
  Task.PercentComplete := Value;
end;

{ TdxGanttControlChangeTaskPercentWorkCompleteHistoryItem }

function TdxGanttControlChangeTaskPercentWorkCompleteHistoryItem.GetValue: Variant;
begin
  Result := Task.PercentWorkComplete;
end;

procedure TdxGanttControlChangeTaskPercentWorkCompleteHistoryItem.DoSetValue(const Value: Variant);
begin
  Task.PercentWorkComplete := Value;
end;

{ TdxGanttControlChangeTaskWorkVarianceHistoryItem }

function TdxGanttControlChangeTaskWorkVarianceHistoryItem.GetValue: Variant;
begin
  Result := Task.WorkVariance;
end;

procedure TdxGanttControlChangeTaskWorkVarianceHistoryItem.DoSetValue(const Value: Variant);
begin
  Task.WorkVariance := Value;
end;

{ TdxGanttControlChangeTaskCompleteDurationHistoryItem }

function TdxGanttControlChangeTaskCompleteDurationHistoryItem.GetValue: Variant;
begin
  Result := Task.CompleteDuration;
end;

procedure TdxGanttControlChangeTaskCompleteDurationHistoryItem.DoSetValue(const Value: Variant);
begin
  Task.CompleteDuration := Value;
end;

{ TdxGanttControlChangeTaskDurationFormatHistoryItem }

function TdxGanttControlChangeTaskDurationFormatHistoryItem.GetValue: Variant;
begin
  Result := Task.DurationFormat;
end;

procedure TdxGanttControlChangeTaskDurationFormatHistoryItem.DoSetValue(const Value: Variant);
begin
  Task.DurationFormat := Value;
end;

{ TdxGanttControlChangeTaskEstimatedHistoryItem }

function TdxGanttControlChangeTaskEstimatedHistoryItem.GetValue: Variant;
begin
  Result := Task.Estimated;
end;

procedure TdxGanttControlChangeTaskEstimatedHistoryItem.DoSetValue(const Value: Variant);
begin
  Task.Estimated := Value;
end;

{ TdxGanttControlChangeTaskConstraintTypeHistoryItem }

function TdxGanttControlChangeTaskConstraintTypeHistoryItem.GetValue: Variant;
begin
  Result := Task.ConstraintType;
end;

procedure TdxGanttControlChangeTaskConstraintTypeHistoryItem.DoSetValue(
  const Value: Variant);
begin
  Task.ConstraintType := Value;
end;

{ TdxGanttControlChangeTaskConstraintDateHistoryItem }

function TdxGanttControlChangeTaskConstraintDateHistoryItem.GetValue: Variant;
begin
  Result := Task.ConstraintDate;
end;

procedure TdxGanttControlChangeTaskConstraintDateHistoryItem.DoSetValue(
  const Value: Variant);
begin
  Task.ConstraintDate := Value;
end;

{ TdxGanttControlChangeManualHistoryItem }

function TdxGanttControlChangeManualHistoryItem.GetValue: Variant;
begin
  Result := Task.Manual;
end;

procedure TdxGanttControlChangeManualHistoryItem.DoSetValue(const Value: Variant);
begin
  Task.Manual := Value;
end;

{ TdxGanttControlChangeTaskMilestoneHistoryItem }

function TdxGanttControlChangeTaskMilestoneHistoryItem.GetValue: Variant;
begin
  Result := Task.Milestone;
end;

procedure TdxGanttControlChangeTaskMilestoneHistoryItem.DoSetValue(
  const Value: Variant);
begin
  Task.Milestone := Value;
end;

{ TdxGanttControlChangeTaskStartHistoryItem }

function TdxGanttControlChangeTaskStartHistoryItem.GetValue: Variant;
begin
  Result := Task.Start;
end;

procedure TdxGanttControlChangeTaskStartHistoryItem.DoSetValue(const Value: Variant);
begin
  Task.Start := VarToDateTime(Value);
end;

{ TdxGanttControlChangeTaskFinishHistoryItem }

function TdxGanttControlChangeTaskFinishHistoryItem.GetValue: Variant;
begin
  Result := Task.Finish;
end;

procedure TdxGanttControlChangeTaskFinishHistoryItem.DoSetValue(const Value: Variant);
begin
  Task.Finish := VarToDateTime(Value);
end;

{ TdxGanttControlChangeTaskDurationHistoryItem }

function TdxGanttControlChangeTaskDurationHistoryItem.GetValue: Variant;
begin
  Result := Task.Duration;
end;

procedure TdxGanttControlChangeTaskDurationHistoryItem.DoSetValue(const Value: Variant);
begin
  Task.Duration := VarToStr(Value);
end;

{ TdxGanttControlChangeTaskPredecessorLinkPropertyHistoryItem }

constructor TdxGanttControlChangeTaskPredecessorLinkPropertyHistoryItem.Create(AHistory: TdxGanttControlHistory; ALink: TdxGanttControlTaskPredecessorLink);
begin
  inherited Create(AHistory, ALink.Task);
  FLink := ALink;
end;

{ TdxGanttControlChangeTaskPredecessorLinkTypeHistoryItem }

function TdxGanttControlChangeTaskPredecessorLinkTypeHistoryItem.GetValue: Variant;
begin
  Result := Link.&Type;
end;

procedure TdxGanttControlChangeTaskPredecessorLinkTypeHistoryItem.DoSetValue(const Value: Variant);
begin
  Link.&Type := Value;
end;

{ TdxGanttControlChangeTaskPredecessorLinkLagHistoryItem }

function TdxGanttControlChangeTaskPredecessorLinkLagHistoryItem.GetValue: Variant;
begin
  Result := Link.LinkLag;
end;

procedure TdxGanttControlChangeTaskPredecessorLinkLagHistoryItem.DoSetValue(const Value: Variant);
begin
  Link.LinkLag := Value;
end;

{ TdxGanttControlChangeTaskPredecessorLinkLagFormatHistoryItem }

function TdxGanttControlChangeTaskPredecessorLinkLagFormatHistoryItem.GetValue: Variant;
begin
  Result := Link.LagFormat;
end;

procedure TdxGanttControlChangeTaskPredecessorLinkLagFormatHistoryItem.DoSetValue(const Value: Variant);
begin
  Link.LagFormat := Value;
end;

{ TdxGanttControlTaskCustomCommand }

constructor TdxGanttControlTaskCustomCommand.Create(
  AControl: TdxGanttControlBase; ATask: TdxGanttControlTask);
begin
  inherited Create(AControl);
  FTask := ATask
end;

procedure TdxGanttControlTaskCustomCommand.DoSetAssignedValue(
  AValue: TdxGanttTaskAssignedValue);
var
  AHistoryItem: TdxGanttControlTaskSetAssignedValueHistoryItem;
  AHistory: TdxGanttControlHistory;
begin
  AHistory := Control.History;
  AHistoryItem := TdxGanttControlTaskSetAssignedValueHistoryItem.Create(AHistory, Task);
  AHistoryItem.FAssignedValue := AValue;
  AHistory.AddItem(AHistoryItem);
  AHistoryItem.Execute;
end;

procedure TdxGanttControlTaskCustomCommand.BeginUpdate;
begin
  inherited BeginUpdate;
  if Task <> nil then
    Task.BeginUpdate;
end;

procedure TdxGanttControlTaskCustomCommand.EndUpdate;
begin
  if Task <> nil then
    Task.EndUpdate;
  inherited EndUpdate;
end;

{ TdxGanttControlDeleteTaskCommand }

procedure TdxGanttControlDeleteTaskCommand.AfterExecute;
var
  I: Integer;
  ASubTasks: TList<TdxGanttControlTask>;
begin
  if not FExecuteNeeded then
    Exit;
  inherited AfterExecute;
  if FIsLast then
    for I := Task.Owner.Count - 1 downto 0 do
    begin
      if Task.Owner[I].Blank then
        DeleteTaskCore(I)
      else
        Break;
    end;
  if FParentSummary <> nil then
    TdxDependentSummaryCalculator.UpdateSummary(Control, FParentSummary);
  if (FParentSummary = nil) or (FParentSummary.ID = 0) then
    Exit;
  ASubTasks := TdxTaskCalculator.GetSubTasks(FParentSummary, False, False);
  try
    if ASubTasks.Count = 0 then
      with TdxGanttControlChangeTaskSummaryCommand.Create(Control, FParentSummary, False) do
      try
        Execute;
      finally
        Free;
      end;
  finally
    ASubTasks.Free;
  end;
end;

procedure TdxGanttControlDeleteTaskCommand.BeforeExecute;
begin
  inherited BeforeExecute;
  FExecuteNeeded := Task.Blank or not FRaiseConfirmation or not Control.OptionsBehavior.ConfirmDelete or
    (dxMessageDlg(GetDeletingTaskConfirmation(Task), mtConfirmation, mbYesNo, 0) = mrYes);
  if FExecuteNeeded then
  begin
    FIsLast := Task.Owner[Task.Owner.Count - 1] = Task;
    FParentSummary := TdxTaskCalculator.GetSummary(Task);
  end;
end;

procedure TdxGanttControlDeleteTaskCommand.BeginUpdate;
begin
  inherited BeginUpdate;
  DataModel.BeginUpdate;
end;

procedure TdxGanttControlDeleteTaskCommand.DoExecute;
var
  I: Integer;
  ASubTasks: TList<TdxGanttControlTask>;
  ASubTask: TdxGanttControlTask;
begin
  if not FExecuteNeeded then
    Exit;
  inherited DoExecute;
  TdxGanttControlTasksAccess(Task.Owner).CalculateDirtyTasks;
  TdxGanttControlTasksAccess(Task.Owner).AddDirtyTask(Task.UID);
  ASubTasks := TdxTaskCalculator.GetSubTasks(Task, True, True);
  try
    for I := ASubTasks.Count - 1 downto 0 do
    begin
      ASubTask := ASubTasks[I];
      CheckLinks(ASubTask, ASubTasks);
      DeleteAssignments(ASubTask);
      DeleteTaskCore(ASubTask.ID);
    end;
    CheckLinks(Task, ASubTasks);
    DeleteAssignments(Task);
    DeleteTaskCore(Task.ID);
  finally
    ASubTasks.Free;
  end;
end;

function TdxGanttControlDeleteTaskCommand.Enabled: Boolean;
begin
  Result := inherited Enabled and (Task <> nil);
end;

procedure TdxGanttControlDeleteTaskCommand.EndUpdate;
begin
  inherited EndUpdate;
  DataModel.EndUpdate;
end;

procedure TdxGanttControlDeleteTaskCommand.DeleteAssignments(ATask: TdxGanttControlTask);
var
  I: Integer;
begin
  if ATask.Blank then
    Exit;
  for I := DataModel.Assignments.Count - 1 downto 0 do
  begin
    if DataModel.Assignments[I].TaskUID = ATask.UID then
      TdxGanttControlChangeResourceCustomCommand.DeleteAssignment(Control, DataModel.Assignments, I);
  end;
end;

procedure TdxGanttControlDeleteTaskCommand.DeleteTaskCore(AIndex: Integer);
var
  AHistoryItem: TdxGanttControlRemoveItemHistoryItem;
  AHistory: TdxGanttControlHistory;
begin
  AHistory := Control.History;
  AHistoryItem := TdxGanttControlRemoveItemHistoryItem.Create(AHistory, Task.Owner);
  AHistoryItem.Index := AIndex;
  AHistory.AddItem(AHistoryItem);
  AHistoryItem.Execute;
end;

procedure TdxGanttControlDeleteTaskCommand.CheckLinks(
  ATask: TdxGanttControlTask; ADeletedTasks: TList<TdxGanttControlTask>);

  procedure DeleteLink(ALink: TdxGanttControlTaskPredecessorLink);
  begin
    with TdxGanttControlChangeTaskPredecessorCommand.Create(Control, ALink, nil) do
    try
      Execute;
    finally
      Free;
    end;
  end;

var
  I, AIndex: Integer;
  ALink: TdxGanttControlTask;
  APredecessor: TdxGanttControlTaskPredecessorLink;
begin
  if ATask.Blank then
    Exit;
  for I := ATask.PredecessorLinks.Count - 1 downto 0 do
  begin
    if not ATask.PredecessorLinks[I].IsValueAssigned(TdxGanttTaskPredecessorLinkAssignedValue.PredecessorUID) then
      Continue;
    ALink := ATask.Owner.GetItemByUID(ATask.PredecessorLinks[I].PredecessorUID);
    if (ALink <> nil) and not ADeletedTasks.BinarySearch(ALink, AIndex) then
    begin
      TdxGanttControlTasksAccess(ATask.Owner).AddDirtyTask(ATask.UID);
      DeleteLink(ATask.PredecessorLinks[I]);
    end;
  end;
  TdxGanttControlTasksAccess(ATask.Owner).CalculateDirtyTask(ATask);
  if TdxGanttControlTasksAccess(ATask.Owner).IsDirtyTask(ATask) then
    Exit;
  for I := 0 to TdxGanttControlTaskAccess(ATask).Links.Count - 1 do
  begin
    ALink := TdxGanttControlTask(TdxGanttControlTaskAccess(ATask).Links[I]);
    if ADeletedTasks.BinarySearch(ALink, AIndex) then
      Continue;
    TdxGanttControlTasksAccess(ATask.Owner).AddDirtyTask(ALink.UID);
    APredecessor := ALink.PredecessorLinks.GetItemByPredecessorUID(ATask.UID);
    while APredecessor <> nil do
    begin
      DeleteLink(APredecessor);
      APredecessor := ALink.PredecessorLinks.GetItemByPredecessorUID(ATask.UID);
    end;
  end;
end;

constructor TdxGanttControlDeleteTaskCommand.Create(
  AControl: TdxGanttControlBase; ATask: TdxGanttControlTask);
begin
  inherited Create(AControl, ATask);
  FRaiseConfirmation := True;
end;

{ TdxGanttControlSetTaskNotNullCommand }

procedure TdxGanttControlSetTaskNotNullCommand.AfterExecute;
var
  AOutlineLevel: Integer;
  I: Integer;
begin
  AOutlineLevel := Task.Owner[0].OutlineLevel + 1;
  for I := Task.ID - 1 downto 0 do
  begin
    if Task.Owner[I].Blank then
      Continue;
    if Task.Owner[I].Summary then
      AOutlineLevel := Task.Owner[I].OutlineLevel + 1
    else
      AOutlineLevel := Task.Owner[I].OutlineLevel;
    Break;
  end;
  with TdxGanttControlChangeTaskOutlineLevelCommand.Create(Control, Task, AOutlineLevel) do
  try
    Execute;
  finally
    Free;
  end;
  inherited AfterExecute;
end;

procedure TdxGanttControlSetTaskNotNullCommand.BeforeExecute;
begin
  inherited BeforeExecute;
  if not Task.IsValueAssigned(TdxGanttTaskAssignedValue.Blank) then
    DoSetAssignedValue(TdxGanttTaskAssignedValue.Blank);
end;

procedure TdxGanttControlSetTaskNotNullCommand.DoExecute;
var
  AHistoryItem: TdxGanttControlTaskMakeNotNullHistoryItem;
  AHistory: TdxGanttControlHistory;
begin
  inherited DoExecute;
  AHistory := Control.History;
  AHistoryItem := TdxGanttControlTaskMakeNotNullHistoryItem.Create(AHistory, Task);
  AHistory.AddItem(AHistoryItem);
  AHistoryItem.Execute;
end;

function TdxGanttControlSetTaskNotNullCommand.Enabled: Boolean;
begin
  Result := inherited Enabled and (not Task.IsValueAssigned(TdxGanttTaskAssignedValue.Blank) or Task.Blank);
end;

{ TdxGanttControlChangeTaskCommand }

constructor TdxGanttControlChangeTaskCommand.Create(
  AControl: TdxGanttControlBase; ATask, ANewTask: TdxGanttControlTask);
begin
  inherited Create(AControl, ATask);
  FNewTask := ANewTask;
  FCommands := TdxFastObjectList.Create;
  if FNewTask <> nil then
  begin
    FCommands.Add(TdxGanttControlChangeTaskSummaryCommand.Create(Control, Task, FNewTask.Summary));
    FCommands.Add(TdxGanttControlChangeTaskNameCommand.Create(Control, Task, FNewTask.Name));
    FCommands.Add(TdxGanttControlChangeTaskPercentCompleteCommand.Create(Control, Task, FNewTask.PercentComplete));
    FCommands.Add(TdxGanttControlChangeTaskPercentWorkCompleteCommand.Create(Control, Task, FNewTask.PercentWorkComplete));
    FCommands.Add(TdxGanttControlChangeTaskCalendarUIDCommand.Create(Control, Task, FNewTask.CalendarUID));
    FCommands.Add(TdxGanttControlChangeTaskManualCommand.Create(Control, Task, FNewTask.Manual));
    FCommands.Add(TdxGanttControlChangeTaskConstraintTypeCommand.Create(Control, Task, FNewTask.ConstraintType));
    FCommands.Add(TdxGanttControlChangeTaskConstraintDateCommand.Create(Control, Task, FNewTask.ConstraintDate));
    FCommands.Add(TdxGanttControlChangeTaskStartCommand.Create(Control, Task, FNewTask.Start));
    FCommands.Add(TdxGanttControlChangeTaskFinishCommand.Create(Control, Task, FNewTask.Finish));
    FCommands.Add(TdxGanttControlChangeTaskDurationCommand.Create(Control, Task, FNewTask.Duration));
    FCommands.Add(TdxGanttControlChangeTaskDurationFormatCommand.Create(Control, Task, FNewTask.DurationFormat));
    FCommands.Add(TdxGanttControlChangeTaskEstimatedCommand.Create(Control, Task, FNewTask.Estimated));
    FCommands.Add(TdxGanttControlChangeTaskDisplayOnTimelineCommand.Create(Control, Task, FNewTask.DisplayOnTimeline));
    FCommands.Add(TdxGanttControlChangeTaskRecurringCommand.Create(Control, Task, FNewTask.Recurring));
    FCommands.Add(TdxGanttControlChangeTaskRecurrencePatternCommand.Create(Control, Task, FNewTask.RecurrencePattern));
  end;
end;

destructor TdxGanttControlChangeTaskCommand.Destroy;
begin
  FreeAndNil(FCommands);
  inherited Destroy;
end;

procedure TdxGanttControlChangeTaskCommand.DoExecute;
var
  I: Integer;
  ACommand: TdxGanttControlChangeTaskPropertyCommand;
begin
  if FNewTask = nil then
  begin
    with TdxGanttControlDeleteTaskCommand.Create(Control, Task) do
    try
      RaiseConfirmation := False;
      Execute;
    finally
      Free;
    end;
  end
  else
  begin
    for I := 0 to FCommands.Count - 1 do
    begin
      if FCommands[I] is TdxGanttControlChangeTaskPropertyCommand then
      begin
        ACommand := TdxGanttControlChangeTaskPropertyCommand(FCommands[I]);
        if FNewTask.IsValueAssigned(ACommand.GetAssignedValue) then
          ACommand.Execute;
      end
      else
        TdxGanttControlTaskCommand(FCommands[I]).Execute;
    end;
  end;
end;

{ TdxGanttControlTaskCommand }

procedure TdxGanttControlTaskCommand.BeforeExecute;
begin
  inherited BeforeExecute;
  if Task.Blank then
  begin
    MakeTaskNotNull;
    SetTaskMode;
  end;
end;

procedure TdxGanttControlTaskCommand.MakeTaskNotNull;
begin
  MakeTaskNotNull(Task);
end;

procedure TdxGanttControlTaskCommand.MakeTaskNotNull(ATask: TdxGanttControlTask);
begin
  with TdxGanttControlSetTaskNotNullCommand.Create(Control, ATask) do
  try
    Execute;
  finally
    Free;
  end;
end;

procedure TdxGanttControlTaskCommand.SetTaskMode;
begin
  with TdxGanttControlSetTaskModeCommand.CreateCommand(Control, Task) do
  try
    Execute;
  finally
    Free;
  end;
end;

{ TdxGanttControlSetTaskModeCommand }

class function TdxGanttControlSetTaskModeCommand.CreateCommand(AControl: TdxGanttControlBase;
  ATask: TdxGanttControlTask): TdxGanttControlSetTaskModeCommand;
var
  ADataModel: TdxGanttControlDataModel;
  AManual: Boolean;
begin
  ADataModel := TdxCustomGanttControl(AControl).DataModel;
  AManual := ADataModel.Properties.MarkNewTasksAsManuallyScheduled;
  if AManual then
    Result := TdxGanttControlSetTaskManuallyScheduleModeCommand.Create(AControl, ATask)
  else
    Result := TdxGanttControlSetTaskAutoScheduleModeCommand.Create(AControl, ATask);
end;

procedure TdxGanttControlSetTaskModeCommand.DoExecute;
var
  AHistoryItem: TdxGanttControlChangeManualHistoryItem;
  AHistory: TdxGanttControlHistory;
begin
  inherited DoExecute;
  AHistory := Control.History;
  AHistoryItem := TdxGanttControlChangeManualHistoryItem.Create(AHistory, Task);
  AHistoryItem.FNewValue := IsManual;
  AHistory.AddItem(AHistoryItem);
  AHistoryItem.Execute;
end;

function TdxGanttControlSetTaskModeCommand.Enabled: Boolean;
begin
  Result := inherited Enabled and (not Task.Blank) and
    (not Task.IsValueAssigned(TdxGanttTaskAssignedValue.Manual) or (Task.Manual <> IsManual));
end;

function TdxGanttControlSetTaskModeCommand.IsManual: Boolean;
begin
  Result := False;
end;

{ TdxGanttControlSetTaskManuallyScheduleModeCommand }

function TdxGanttControlSetTaskManuallyScheduleModeCommand.IsManual: Boolean;
begin
  Result := True;
end;

{ TdxGanttControlSetTaskAutoScheduleModeCommand }

procedure TdxGanttControlSetTaskAutoScheduleModeCommand.DoExecute;
begin
  inherited DoExecute;
  TdxGanttControlSetTaskAutoScheduleModeCommand.SetBasicStartAndFinish(Control, Task, not FLockUpdateSummary);
end;

class procedure TdxGanttControlSetTaskAutoScheduleModeCommand.SetBasicStartAndFinish(AControl: TdxGanttControlBase; ATask: TdxGanttControlTask;
  AUpdateSummary: Boolean);
var
  ADuration: string;
  AStart: TDateTime;
  ACalendar: TdxGanttControlCalendar;
begin
  if ATask.Summary then
  begin
    TdxDependentSummaryCalculator.CalculateSummaryStartAndFinish(AControl, ATask);
    Exit;
  end;
  if ATask.IsValueAssigned(TdxGanttTaskAssignedValue.ConstraintType) and ATask.IsValueAssigned(TdxGanttTaskAssignedValue.ConstraintDate) and
      (ATask.ConstraintType <> TdxGanttControlTaskConstraintType.AsSoonAsPossible) then
    Exit;
  ADuration := ATask.RealDuration;
  ACalendar := ATask.RealCalendar;
  AStart := TdxDependentLinksCalculator.CalculateMinStart(ATask);
  with TdxGanttControlChangeTaskStartCommand.Create(AControl, ATask, AStart) do
  try
    FLockUpdateSummary := not AUpdateSummary;
    FIsDependent := True;
    Execute;
  finally
    Free;
  end;
  if ADuration = '' then
    with TdxGanttControlChangeTaskFinishCommand.Create(AControl, ATask, ACalendar.GetFinishWorkTime(AStart)) do
    try
      FLockUpdateSummary := not AUpdateSummary;
      FIsDependent := True;
      Execute;
    finally
      Free;
    end;
end;

{ TdxGanttControlChangeTaskPropertyCommand }

constructor TdxGanttControlChangeTaskPropertyCommand.Create(
  AControl: TdxGanttControlBase; ATask: TdxGanttControlTask;
  const ANewValue: Variant);
begin
  inherited Create(AControl, ATask);
  FNewValue := ANewValue;
end;

procedure TdxGanttControlChangeTaskPropertyCommand.BeforeExecute;
begin
  if HasAssignedValue then
    FOldIsAssigned := Task.IsValueAssigned(GetAssignedValue);
  inherited BeforeExecute;
end;

procedure TdxGanttControlChangeTaskPropertyCommand.DoExecute;
begin
  if HasAssignedValue and not VarIsNull(FNewValue) and not Task.IsValueAssigned(GetAssignedValue) then
    SetAssignedValue;
  SetValue;
  if HasAssignedValue and VarIsNull(FNewValue) then
    ResetAssignedValue;
  inherited DoExecute;
end;

function TdxGanttControlChangeTaskPropertyCommand.Enabled: Boolean;
begin
  Result := inherited Enabled and ((GetChangeValueHistoryItemClass = nil) or
    not Task.IsValueAssigned(GetAssignedValue) or not VarEquals(GetValue, NewValue));
end;

function TdxGanttControlChangeTaskPropertyCommand.GetValue: Variant;
begin
  if GetChangeValueHistoryItemClass = nil then
    Exit(Null);

  with GetChangeValueHistoryItemClass.Create(Control.History, Task) do
  try
    Result := GetValue;
  finally
    Free;
  end;
end;

function TdxGanttControlChangeTaskPropertyCommand.GetValidValue: Variant;
begin
  Result := NewValue;
  if not IsNewValueValid then
    Result := ValidateValue(Result);
end;

function TdxGanttControlChangeTaskPropertyCommand.HasAssignedValue: Boolean;
begin
  Result := True;
end;

procedure TdxGanttControlChangeTaskPropertyCommand.ResetAssignedValue;
begin
  ResetAssignedValue(GetAssignedValue);
end;

procedure TdxGanttControlChangeTaskPropertyCommand.ResetAssignedValue(AAssignedValue: TdxGanttTaskAssignedValue);
var
  AHistoryItem: TdxGanttControlTaskResetAssignedValueHistoryItem;
  AHistory: TdxGanttControlHistory;
begin
  if not Task.IsValueAssigned(AAssignedValue) then
    Exit;
  AHistory := Control.History;
  AHistoryItem := TdxGanttControlTaskResetAssignedValueHistoryItem.Create(AHistory, Task);
  AHistoryItem.FAssignedValue := AAssignedValue;
  AHistory.AddItem(AHistoryItem);
  AHistoryItem.Execute;
end;

function TdxGanttControlChangeTaskPropertyCommand.IsNewValueValid: Boolean;
begin
  Result := True;
end;

procedure TdxGanttControlChangeTaskPropertyCommand.SetAssignedValue;
begin
  DoSetAssignedValue(GetAssignedValue);
end;

procedure TdxGanttControlChangeTaskPropertyCommand.SetValue;
var
  AHistoryItem: TdxGanttControlChangeTaskPropertyHistoryItem;
  ANewValue: Variant;
begin
  ANewValue := GetValidValue;
  if (ANewValue = GetValue) and FOldIsAssigned then
    Exit;
  AHistoryItem := GetChangeValueHistoryItemClass.Create(Control.History, Task);
  AHistoryItem.FNewValue := ANewValue;
  Control.History.AddItem(AHistoryItem);
  AHistoryItem.Execute;
end;

function TdxGanttControlChangeTaskPropertyCommand.ValidateValue(
  const AValue: Variant): Variant;
begin
  Result := AValue;
end;

{ TdxGanttControlChangeTaskOutlineLevelCommand }

procedure TdxGanttControlChangeTaskOutlineLevelCommand.AfterExecute;
var
  ASummary: TdxGanttControlTask;
begin
  ASummary := TdxTaskCalculator.GetSummary(Task);
  CheckLinks(ASummary);
  if not Task.IsValueAssigned(TdxGanttTaskAssignedValue.PercentComplete) or (Task.GetRealPercentComplete = 0) then
    TdxDependentLinksCalculator.CalculateLink(Control, Task, False);
  inherited AfterExecute;
  if FLockUpdateSummary then
    Exit;
  if (FPreviousSummary <> ASummary) and (FPreviousSummary <> nil) and FPreviousSummary.Summary then
    TdxDependentSummaryCalculator.UpdateSummary(Control, FPreviousSummary);
  if ASummary <> nil then
    TdxDependentSummaryCalculator.UpdateSummary(Control, ASummary);
end;

procedure TdxGanttControlChangeTaskOutlineLevelCommand.BeforeExecute;
begin
  inherited BeforeExecute;
  FPreviousSummary := TdxTaskCalculator.GetSummary(Task);
end;

function TdxGanttControlChangeTaskOutlineLevelCommand.GetAssignedValue: TdxGanttTaskAssignedValue;
begin
  Result := TdxGanttTaskAssignedValue.OutlineLevel;
end;

function TdxGanttControlChangeTaskOutlineLevelCommand.GetChangeValueHistoryItemClass: TdxGanttControlChangeTaskPropertyHistoryItemClass;
begin
  Result := TdxGanttControlChangeTaskOutlineLevelHistoryItem;
end;

procedure TdxGanttControlChangeTaskOutlineLevelCommand.CheckLinks(ATask: TdxGanttControlTask);
begin
  if not TdxDependentLinksCalculator.CheckLinks(ATask) then
    TdxGanttControlExceptions.ThrowOutlineChangeWouldCreateCircularRelationshipException;
end;

function TdxGanttControlChangeTaskOutlineLevelCommand.GetPreviousTask: TdxGanttControlTask;
var
  I: Integer;
begin
  for I := Task.ID - 1 downto 0 do
  begin
    Result := Task.Owner[I];
    if not Result.Blank and (Result.OutlineLevel <= Task.OutlineLevel) then
      Exit;
  end;
  Result := nil;
end;

function TdxGanttControlChangeTaskOutlineLevelCommand.GetSubTasks(ARecursive: Boolean = False): TList<TdxGanttControlTask>;
begin
  Result := TdxTaskCalculator.GetSubTasks(Task, True, ARecursive);
end;

procedure TdxGanttControlChangeTaskOutlineLevelCommand.SetTaskSummary(
  ATask: TdxGanttControlTask; ANewValue: Boolean);

  procedure DeletePredecessorLinksByUID(APredecessorLinks: TdxGanttControlTaskPredecessorLinks; AUID: Integer);
  var
    I: Integer;
  begin
    for I := APredecessorLinks.Count - 1 downto 0 do
      if APredecessorLinks[I].PredecessorUID = AUID then
        TdxGanttControlChangeTaskPredecessorsCommand.DeletePredecessorLink(Control, TdxGanttControlTask(APredecessorLinks.Owner), I);
  end;

var
  I: Integer;
  ASubTasks: TList<TdxGanttControlTask>;
  ASetAutoScheduleModeNeeded: Boolean;
begin
  if ANewValue then
  begin
    if Task <> ATask then
    begin
      DeletePredecessorLinksByUID(Task.PredecessorLinks, ATask.UID);
      ASubTasks := GetSubTasks(True);
      try
        for I := 0 to ASubTasks.Count - 1 do
          DeletePredecessorLinksByUID(ASubTasks[I].PredecessorLinks, ATask.UID);
      finally
        ASubTasks.Free;
      end;
    end
    else
    begin
      ASubTasks := GetSubTasks(True);
      try
        for I := 0 to ASubTasks.Count - 1 do
        begin
          DeletePredecessorLinksByUID(ASubTasks[I].PredecessorLinks, Task.UID);
          DeletePredecessorLinksByUID(Task.PredecessorLinks, ASubTasks[I].UID);
        end;
      finally
        ASubTasks.Free;
      end;
    end;
  end;
  with TdxGanttControlChangeTaskSummaryCommand.Create(Control, ATask, ANewValue) do
  try
    ASetAutoScheduleModeNeeded := ANewValue and Enabled;
    Execute;
  finally
    Free;
  end;
  if ATask.IsValueAssigned(TdxGanttTaskAssignedValue.Summary) and ATask.Summary then
    CheckLinks(ATask);
  if ASetAutoScheduleModeNeeded then
    SetTaskAutoScheduleMode(ATask);
  if ATask.Summary then
    TdxDependentSummaryCalculator.UpdateSummary(Control, ATask);
end;

procedure TdxGanttControlChangeTaskOutlineLevelCommand.SetTaskAutoScheduleMode(
  ATask: TdxGanttControlTask);
begin
  with TdxGanttControlSetTaskAutoScheduleModeCommand.Create(Control, ATask) do
  try
    Execute;
  finally
    Free;
  end;
end;

{ TdxGanttControlIncreaseTaskOutlineLevelCommand }

constructor TdxGanttControlIncreaseTaskOutlineLevelCommand.Create(
  AControl: TdxGanttControlBase; ATask: TdxGanttControlTask);
var
  AValue: Integer;
begin
  if ATask.Blank or not ATask.IsValueAssigned(TdxGanttTaskAssignedValue.OutlineLevel) then
    AValue := 1
  else
    AValue := ATask.OutlineLevel + 1;
  inherited Create(AControl, ATask, AValue);
end;

destructor TdxGanttControlIncreaseTaskOutlineLevelCommand.Destroy;
begin
  FreeAndNil(FSubTasks);
  inherited;
end;

procedure TdxGanttControlIncreaseTaskOutlineLevelCommand.AfterExecute;
var
  I: Integer;
begin
  inherited AfterExecute;
  for I := 0 to FSubTasks.Count - 1 do
    with TdxGanttControlIncreaseTaskOutlineLevelCommand.Create(Control, FSubTasks[I]) do
    try
      Execute;
    finally
      Free;
    end;
end;

procedure TdxGanttControlIncreaseTaskOutlineLevelCommand.BeforeExecute;
var
  ATask: TdxGanttControlTask;
begin
  inherited BeforeExecute;
  ATask := GetPreviousTask;
  SetTaskSummary(ATask, True);
  FSubTasks := GetSubTasks;
end;

function TdxGanttControlIncreaseTaskOutlineLevelCommand.Enabled: Boolean;
var
  ATask: TdxGanttControlTask;
begin
  Result := not Task.Blank and inherited Enabled;
  if Result then
  begin
    ATask := GetPreviousTask;
    Result := ATask.OutlineLevel >= Task.OutlineLevel;
  end;
end;

{ TdxGanttControlDecreaseTaskOutlineLevelCommand }

constructor TdxGanttControlDecreaseTaskOutlineLevelCommand.Create(
  AControl: TdxGanttControlBase; ATask: TdxGanttControlTask);
var
  AValue: Integer;
begin
  if ATask.Blank or not ATask.IsValueAssigned(TdxGanttTaskAssignedValue.OutlineLevel) then
    AValue := 1
  else
    AValue := ATask.OutlineLevel - 1;
  inherited Create(AControl, ATask, AValue);
end;

procedure TdxGanttControlDecreaseTaskOutlineLevelCommand.AfterExecute;
var
  AList: TList<TdxGanttControlTask>;
begin
  if not FIsDependent then
  begin
    AList := GetSubTasks;
    try
      SetTaskSummary(Task, AList.Count > 0);
    finally
      AList.Free;
    end;
  end;
  inherited AfterExecute;
end;

procedure TdxGanttControlDecreaseTaskOutlineLevelCommand.BeforeExecute;
var
  ASummary: TdxGanttControlTask;
  I: Integer;
  AHasTasksInSummary: Boolean;
  AList: TList<TdxGanttControlTask>;
begin
  inherited BeforeExecute;
  ASummary := TdxTaskCalculator.GetSummary(Task);
  if ASummary = nil then
    Exit;
  if not FIsDependent then
  begin
    AHasTasksInSummary := False;
    for I := ASummary.ID + 1 to Task.ID - 1 do
      if not ASummary.Owner[I].Blank then
      begin
        AHasTasksInSummary := True;
        Break;
      end;
    if not AHasTasksInSummary then
      SetTaskSummary(ASummary, False);
  end;
  AList := GetSubTasks;
  try
    for I := 0 to AList.Count - 1 do
      with TdxGanttControlDecreaseTaskOutlineLevelCommand.Create(Control, AList[I]) do
      try
        FIsDependent := True;
        Execute;
      finally
        Free;
      end;
  finally
    AList.Free;
  end;
end;

function TdxGanttControlDecreaseTaskOutlineLevelCommand.Enabled: Boolean;
var
  ATask: TdxGanttControlTask;
begin
  Result := not Task.Blank and (NewValue >= 1) and inherited Enabled;
  if Result then
  begin
    ATask := GetPreviousTask;
    Result := ATask.OutlineLevel <= Task.OutlineLevel;
  end;
end;

{ TdxGanttControlChangeTaskSummaryCommand }

procedure TdxGanttControlChangeTaskSummaryCommand.AfterExecute;
var
  AStart: TDateTime;
  APercentComplete: Integer;
  ADuration: TdxGanttControlDuration;
begin
  inherited AfterExecute;
  if Task.IsValueAssigned(TdxGanttTaskAssignedValue.Summary) and Task.Summary and not Task.Manual then
    TdxTaskCalculator.ResetConstraint(Control, Task);
  if Task.IsValueAssigned(TdxGanttTaskAssignedValue.Summary) and not Task.Summary and not Task.Manual then
  begin
    if not Task.IsValueAssigned(TdxGanttTaskAssignedValue.PercentComplete) or (Task.GetRealPercentComplete = 0) then
    begin
      APercentComplete := -1;
      if Task.PredecessorLinks.Count = 0 then
      begin
        AStart := TdxTaskCalculator.CalculateBasicStart(Task);
        TdxTaskCalculator.SetStart(Control, Task, AStart);
      end
      else
        TdxDependentLinksCalculator.CalculateLink(Control, Task, False);
    end
    else
      APercentComplete := Task.GetRealPercentComplete;
    ADuration := TdxGanttControlDuration.Create(TdxGanttControlDataModel.DefaultTaskDuration);
    TdxTaskCalculator.SetDuration(Control, Task, TdxGanttControlDataModel.DefaultTaskDuration);
    TdxTaskCalculator.SetFinish(Control, Task, ADuration.GetWorkFinish(Task.Start, Task.RealCalendar, Task.DurationFormat));
    if APercentComplete > 0 then
      TdxTaskCalculator.SetPercentComplete(Control, Task, APercentComplete);
  end;
end;

function TdxGanttControlChangeTaskSummaryCommand.GetAssignedValue: TdxGanttTaskAssignedValue;
begin
  Result := TdxGanttTaskAssignedValue.Summary;
end;

function TdxGanttControlChangeTaskSummaryCommand.GetChangeValueHistoryItemClass: TdxGanttControlChangeTaskPropertyHistoryItemClass;
begin
  Result := TdxGanttControlChangeTaskSummaryHistoryItem;
end;

{ TdxGanttControlChangeTaskNameCommand }

function TdxGanttControlChangeTaskNameCommand.GetAssignedValue: TdxGanttTaskAssignedValue;
begin
  Result := TdxGanttTaskAssignedValue.Name;
end;

function TdxGanttControlChangeTaskNameCommand.GetChangeValueHistoryItemClass: TdxGanttControlChangeTaskPropertyHistoryItemClass;
begin
  Result := TdxGanttControlChangeTaskNameHistoryItem;
end;

{ TdxGanttControlChangeTaskRollupCommand }

function TdxGanttControlChangeTaskRollupCommand.GetAssignedValue: TdxGanttTaskAssignedValue;
begin
  Result := TdxGanttTaskAssignedValue.Rollup;
end;

function TdxGanttControlChangeTaskRollupCommand.GetChangeValueHistoryItemClass: TdxGanttControlChangeTaskPropertyHistoryItemClass;
begin
  Result := TdxGanttControlChangeTaskRollupHistoryItem;
end;

{ TdxGanttControlChangeTaskDisplayOnTimelineCommand }

function TdxGanttControlChangeTaskDisplayOnTimelineCommand.GetAssignedValue: TdxGanttTaskAssignedValue;
begin
  Result := TdxGanttTaskAssignedValue.DisplayOnTimeline;
end;

function TdxGanttControlChangeTaskDisplayOnTimelineCommand.GetChangeValueHistoryItemClass: TdxGanttControlChangeTaskPropertyHistoryItemClass;
begin
  Result := TdxGanttControlChangeTaskDisplayOnTimelineHistoryItem;
end;

{ TdxGanttControlChangeTaskRecurringCommand }

function TdxGanttControlChangeTaskRecurringCommand.GetAssignedValue: TdxGanttTaskAssignedValue;
begin
  Result := TdxGanttTaskAssignedValue.Recurring;
end;

function TdxGanttControlChangeTaskRecurringCommand.GetChangeValueHistoryItemClass: TdxGanttControlChangeTaskPropertyHistoryItemClass;
begin
  Result := TdxGanttControlChangeRecurringHistoryItem;
end;

{ TdxGanttControlChangeTaskRecurrencePatternCommand }

constructor TdxGanttControlChangeTaskRecurrencePatternCommand.Create(
  AControl: TdxGanttControlBase; ATask: TdxGanttControlTask;
  const ANewRecurrencePattern: TdxGanttControlRecurrencePattern);
begin
  inherited Create(AControl, ATask);
  ANewRecurrencePattern.GetData(FNewValue);
end;

procedure TdxGanttControlChangeTaskRecurrencePatternCommand.AfterExecute;

  function CreateOccurrence(AIndex: Integer): TdxGanttControlTask;
  var
    AHistoryItem: TdxGanttControlCreateItemHistoryItem;
  begin
    AHistoryItem := TdxGanttControlCreateItemHistoryItem.Create(Control.History, DataModel.Tasks);
    AIndex := Task.ID + AIndex + 1;
    AHistoryItem.Index := AIndex;
    Control.History.AddItem(AHistoryItem);
    AHistoryItem.Execute;
    Result := DataModel.Tasks[AIndex];
  end;

  procedure SetOutlineLevel(AOccurrence: TdxGanttControlTask);
  begin
    with TdxGanttControlChangeTaskOutlineLevelCommand.Create(Control, AOccurrence, Task.OutlineLevel + 1) do
    try
      FLockUpdateSummary := True;
      Execute;
    finally
      Free;
    end;
  end;

  procedure SetRecurring(AOccurrence: TdxGanttControlTask);
  begin
    with TdxGanttControlChangeTaskRecurringCommand.Create(Control, AOccurrence, True) do
    try
      Execute;
    finally
      Free;
    end;
  end;

  procedure SetName(AOccurrence: TdxGanttControlTask; AIndex: Integer);
  begin
    with TdxGanttControlChangeTaskNameCommand.Create(Control, AOccurrence, Format('%s %d', [Task.Name, AIndex + 1])) do
    try
      Execute;
    finally
      Free;
    end;
  end;

  procedure SetStart(AOccurrence: TdxGanttControlTask; AStart: TDateTime);
  begin
    AStart := DateOf(AStart) + TimeOf(Task.RecurrencePattern.Start);
    with TdxGanttControlChangeTaskStartCommand.Create(Control, AOccurrence, AStart) do
    try
      FLockUpdateSummary := True;
      Execute;
    finally
      Free;
    end;
  end;

  procedure SetManual(AOccurrence: TdxGanttControlTask);
  begin
    with TdxGanttControlChangeTaskManualCommand.Create(Control, AOccurrence, DataModel.Properties.MarkNewTasksAsManuallyScheduled) do
    try
      FLockUpdateSummary := True;
      Execute;
    finally
      Free;
    end;
  end;

  procedure SetCalendar(AOccurrence: TdxGanttControlTask);
  var
    ACalendarUID: Integer;
  begin
    ACalendarUID := Task.RecurrencePattern.CalendarUID;
    with TdxGanttControlChangeTaskCalendarUIDCommand.Create(Control, AOccurrence, ACalendarUID) do
    try
      Execute;
    finally
      Free;
    end;
  end;

  procedure SetDuration(AOccurrence: TdxGanttControlTask);
  begin
    with TdxGanttControlChangeTaskDurationCommand.Create(Control, AOccurrence, Task.RecurrencePattern.Duration) do
    try
      FLockUpdateSummary := True;
      Execute;
    finally
      Free;
    end;
  end;

  procedure SetDurationFormat(AOccurrence: TdxGanttControlTask);
  begin
    with TdxGanttControlChangeTaskDurationFormatCommand.Create(Control, AOccurrence, Task.RecurrencePattern.DurationFormat) do
    try
      Execute;
    finally
      Free;
    end;
  end;

  procedure SetRollup(AOccurrence: TdxGanttControlTask);
  begin
    with TdxGanttControlChangeTaskRollupCommand.Create(Control, AOccurrence, True) do
    try
      Execute;
    finally
      Free;
    end;
  end;

var
  AOccurrences: TList<TdxGanttControlTask>;
  ACalculated: TList<TDateTime>;
  I: Integer;
  AOccurrence: TdxGanttControlTask;
begin
  SetCalendar(Task);
  inherited AfterExecute;
  AOccurrences := TdxGanttControlTaskCommandHelper.GetOccurrences(Task);
  try
    ACalculated := TdxGanttControlOccurrencesCalculator.GetOccurrences(Task);
    try
      for I := 0 to ACalculated.Count - 1 do
      begin
        if AOccurrences.Count > 0 then
          AOccurrence := AOccurrences[0]
        else
          AOccurrence := CreateOccurrence(I);
        AOccurrence.BeginUpdate;
        try
          SetRecurring(AOccurrence);
          SetManual(AOccurrence);
          SetDuration(AOccurrence);
          SetDurationFormat(AOccurrence);
          SetStart(AOccurrence, ACalculated[I]);
          SetName(AOccurrence, I);
          SetRollup(AOccurrence);
          SetOutlineLevel(AOccurrence);
          SetCalendar(AOccurrence);
          if AOccurrences.Count > 0 then
            AOccurrences.Delete(0);
        finally
          AOccurrence.EndUpdate;
        end;
      end;
      for I := AOccurrences.Count -1 downto 0 do
      begin
        with TdxGanttControlDeleteTaskCommand.Create(Control, AOccurrences[I]) do
        try
          RaiseConfirmation := False;
          Execute;
        finally
          Free;
        end;
      end;
      if ACalculated.Count > 0 then
        with TdxGanttControlChangeTaskManualCommand.Create(Control, Task, False) do
        try
          FLockUpdateSummary := True;
          Execute;
        finally
          Free;
        end;
    finally
      ACalculated.Free;
    end;
  finally
    AOccurrences.Free;
  end;
  TdxDependentSummaryCalculator.UpdateSummary(Control, Task);
end;

procedure TdxGanttControlChangeTaskRecurrencePatternCommand.DoExecute;
var
  AHistoryItem: TdxGanttControlChangeRecurrenceInfoHistoryItem;
begin
  AHistoryItem := TdxGanttControlChangeRecurrenceInfoHistoryItem.Create(Control.History, Task);
  AHistoryItem.FNewValue := FNewValue;
  Control.History.AddItem(AHistoryItem);
  AHistoryItem.Execute;
end;

function TdxGanttControlChangeTaskRecurrencePatternCommand.Enabled: Boolean;
begin
  Result := inherited Enabled and ((Task.IsRecurrencePattern xor not FNewValue.IsEmpty) or
    not(FNewValue.IsEmpty or Task.RecurrencePattern.IsEqual(FNewValue)));
end;

{ TdxGanttControlChangeTaskCalendarUIDCommand }

function TdxGanttControlChangeTaskCalendarUIDCommand.GetAssignedValue: TdxGanttTaskAssignedValue;
begin
  Result := TdxGanttTaskAssignedValue.CalendarUID;
end;

function TdxGanttControlChangeTaskCalendarUIDCommand.GetChangeValueHistoryItemClass: TdxGanttControlChangeTaskPropertyHistoryItemClass;
begin
  Result := TdxGanttControlChangeTaskCalendarUIDHistoryItem;
end;

{ TdxGanttControlChangeTaskPercentCompleteCustomCommand }

procedure TdxGanttControlChangeTaskPercentCompleteCustomCommand.AfterExecute;
var
  I: Integer;
begin
  inherited AfterExecute;
  ResetAssignedValue(TdxGanttTaskAssignedValue.PhysicalPercentComplete);
  ResetAssignedValue(TdxGanttTaskAssignedValue.ActualDuration);
  ResetAssignedValue(TdxGanttTaskAssignedValue.RemainingDuration);
  ResetAssignedValue(TdxGanttTaskAssignedValue.ActualStart);
  ResetAssignedValue(TdxGanttTaskAssignedValue.ActualFinish);
  ResetAssignedValue(TdxGanttTaskAssignedValue.RemainingWork);
  for I := 0 to DataModel.Assignments.Count - 1 do
    if CanChangeAssignment(DataModel.Assignments[I]) then
    begin
      with TdxGanttControlChangeAssignmentPercentWorkCompleteCommand.Create(Control, DataModel.Assignments[I], NewValue) do
      try
        Execute;
      finally
        Free;
      end;
    end;
end;

function TdxGanttControlChangeTaskPercentCompleteCustomCommand.CanChangeAssignment(AAssignment: TdxGanttControlAssignment): Boolean;
begin
  Result := AAssignment.TaskUID = Task.UID;
end;

procedure TdxGanttControlChangeTaskPercentCompleteCustomCommand.CalculateParentSummaryPercentComplete;
begin
  if Task.IsValueAssigned(TdxGanttTaskAssignedValue.Duration) then
    TdxDependentSummaryCalculator.CalculateParentSummaryPercentComplete(Control, Task);
end;

procedure TdxGanttControlChangeTaskPercentCompleteCustomCommand.CalculateParentSummaryPercentWorkComplete;
begin
  if Task.IsValueAssigned(TdxGanttTaskAssignedValue.Duration) then
    TdxDependentSummaryCalculator.CalculateParentSummaryPercentWorkComplete(Control, Task);
end;

{ TdxGanttControlChangeTaskPercentCompleteCommand }

procedure TdxGanttControlChangeTaskPercentCompleteCommand.AfterExecute;
begin
  inherited AfterExecute;
  if not FIsDependent then
  begin
    CalculateParentSummaryPercentComplete;
    if Task.Summary then
    begin
      TdxDependentSummaryCalculator.CalculateSummaryPercentComplete(Control, Task);
      TdxDependentSummaryCalculator.UpdateSummaryPercentWorkComplete(Control, Task);
    end
    else
    begin
      TdxTaskCalculator.SetPercentWorkComplete(Control, Task, NewValue);
      CalculateParentSummaryPercentWorkComplete;
    end;
  end;
end;

function TdxGanttControlChangeTaskPercentCompleteCommand.CanChangeAssignment(AAssignment: TdxGanttControlAssignment): Boolean;
begin
  Result := inherited CanChangeAssignment(AAssignment) and (AAssignment.ResourceUID < 0);
end;

function TdxGanttControlChangeTaskPercentCompleteCommand.GetAssignedValue: TdxGanttTaskAssignedValue;
begin
  Result := TdxGanttTaskAssignedValue.PercentComplete;
end;

function TdxGanttControlChangeTaskPercentCompleteCommand.GetChangeValueHistoryItemClass: TdxGanttControlChangeTaskPropertyHistoryItemClass;
begin
  Result := TdxGanttControlChangeTaskPercentCompleteHistoryItem;
end;

{ TdxGanttControlChangeTaskPercentWorkCompleteCommand }

procedure TdxGanttControlChangeTaskPercentWorkCompleteCommand.AfterExecute;
begin
  inherited AfterExecute;
  if not FIsDependent then
  begin
    CalculateParentSummaryPercentWorkComplete;
    if Task.Summary then
    begin
      TdxDependentSummaryCalculator.CalculateSummaryPercentWorkComplete(Control, Task);
      TdxDependentSummaryCalculator.UpdateSummaryPercentComplete(Control, Task);
    end
    else
    begin
      TdxTaskCalculator.SetPercentComplete(Control, Task, NewValue);
      CalculateParentSummaryPercentComplete;
    end;
  end;
end;

function TdxGanttControlChangeTaskPercentWorkCompleteCommand.CanChangeAssignment(
  AAssignment: TdxGanttControlAssignment): Boolean;
begin
  Result := inherited CanChangeAssignment(AAssignment) and (AAssignment.ResourceUID >= 0);
end;

function TdxGanttControlChangeTaskPercentWorkCompleteCommand.GetAssignedValue: TdxGanttTaskAssignedValue;
begin
  Result := TdxGanttTaskAssignedValue.PercentWorkComplete;
end;

function TdxGanttControlChangeTaskPercentWorkCompleteCommand.GetChangeValueHistoryItemClass: TdxGanttControlChangeTaskPropertyHistoryItemClass;
begin
  Result := TdxGanttControlChangeTaskPercentWorkCompleteHistoryItem;
end;

{ TdxGanttControlChangeTaskCompleteDurationCommand }

function TdxGanttControlChangeTaskCompleteDurationCommand.GetAssignedValue: TdxGanttTaskAssignedValue;
begin
  Result := TdxGanttTaskAssignedValue.CompleteDuration;
end;

function TdxGanttControlChangeTaskCompleteDurationCommand.GetChangeValueHistoryItemClass: TdxGanttControlChangeTaskPropertyHistoryItemClass;
begin
  Result := TdxGanttControlChangeTaskCompleteDurationHistoryItem;
end;

{ TdxGanttControlChangeTaskWorkVarianceCommand }

function TdxGanttControlChangeTaskWorkVarianceCommand.GetAssignedValue: TdxGanttTaskAssignedValue;
begin
  Result := TdxGanttTaskAssignedValue.WorkVariance;
end;

function TdxGanttControlChangeTaskWorkVarianceCommand.GetChangeValueHistoryItemClass: TdxGanttControlChangeTaskPropertyHistoryItemClass;
begin
  Result := TdxGanttControlChangeTaskWorkVarianceHistoryItem;
end;

{ TdxGanttControlSetTaskMilestoneCommand }

procedure TdxGanttControlSetTaskMilestoneCommand.AfterExecute;
begin
  if NewValue then
  begin
    with TdxGanttControlChangeTaskFinishCommand.Create(Control, Task, Task.Start) do
    try
      Execute;
    finally
      Free;
    end;
  end;
  inherited AfterExecute;
end;

function TdxGanttControlSetTaskMilestoneCommand.GetAssignedValue: TdxGanttTaskAssignedValue;
begin
  Result := TdxGanttTaskAssignedValue.Milestone;
end;

function TdxGanttControlSetTaskMilestoneCommand.GetChangeValueHistoryItemClass: TdxGanttControlChangeTaskPropertyHistoryItemClass;
begin
  Result := TdxGanttControlChangeTaskMilestoneHistoryItem;
end;

{ TdxGanttControlChangeTaskDurationFormatCommand }

procedure TdxGanttControlChangeTaskDurationFormatCommand.AfterExecute;
var
  AEstimated: Boolean;
begin
  inherited AfterExecute;
  if (OldIsAssigned <> Task.IsValueAssigned(TdxGanttTaskAssignedValue.DurationFormat)) or (FIsElapsed <> TdxGanttControlDuration.IsElapsedFormat(Task.DurationFormat)) then
    AdjustStartAndFinish(Task);

  AEstimated := Task.IsValueAssigned(TdxGanttTaskAssignedValue.DurationFormat) and (Task.DurationFormat >= TdxDurationFormat.EstimatedMinutes);
  with TdxGanttControlChangeTaskEstimatedCommand.Create(Control, Task, AEstimated) do
  try
    Execute;
  finally
    Free;
  end;
end;

procedure TdxGanttControlChangeTaskDurationFormatCommand.BeforeExecute;
begin
  inherited BeforeExecute;
  if OldIsAssigned then
    FIsElapsed := TdxGanttControlDuration.IsElapsedFormat(Task.DurationFormat);
end;

function TdxGanttControlChangeTaskDurationFormatCommand.GetAssignedValue: TdxGanttTaskAssignedValue;
begin
  Result := TdxGanttTaskAssignedValue.DurationFormat;
end;

function TdxGanttControlChangeTaskDurationFormatCommand.GetChangeValueHistoryItemClass: TdxGanttControlChangeTaskPropertyHistoryItemClass;
begin
  Result := TdxGanttControlChangeTaskDurationFormatHistoryItem;
end;

{ TdxGanttControlChangeTaskEstimatedCommand }

function TdxGanttControlChangeTaskEstimatedCommand.GetAssignedValue: TdxGanttTaskAssignedValue;
begin
  Result := TdxGanttTaskAssignedValue.Estimated;
end;

function TdxGanttControlChangeTaskEstimatedCommand.GetChangeValueHistoryItemClass: TdxGanttControlChangeTaskPropertyHistoryItemClass;
begin
  Result := TdxGanttControlChangeTaskEstimatedHistoryItem;
end;

{ TdxGanttControlChangeTaskManualCommand }

function TdxGanttControlChangeTaskManualCommand.GetAssignedValue: TdxGanttTaskAssignedValue;
begin
  Result := TdxGanttTaskAssignedValue.Manual;
end;

function TdxGanttControlChangeTaskManualCommand.GetChangeValueHistoryItemClass: TdxGanttControlChangeTaskPropertyHistoryItemClass;
begin
  Result := nil;
end;

procedure TdxGanttControlChangeTaskManualCommand.SetValue;
var
  AValue: Boolean;
begin
  if VarIsStr(NewValue) then
    AValue := NewValue = cxGetResourceString(@sdxGanttControlTaskModeManuallyScheduled)
  else
    AValue := (VarType(NewValue) = varBoolean) and NewValue;

  if AValue then
  begin
    with TdxGanttControlSetTaskManuallyScheduleModeCommand.Create(Control, Task) do
    try
      FLockUpdateSummary := Self.FLockUpdateSummary;
      Execute;
    finally
      Free;
    end;
  end
  else
  begin
    with TdxGanttControlSetTaskAutoScheduleModeCommand.Create(Control, Task) do
    try
      FLockUpdateSummary := Self.FLockUpdateSummary;
      Execute;
    finally
      Free;
    end;
  end;
end;

{ TdxGanttControlChangeSummaryManualCommand }

function TdxGanttControlChangeSummaryManualCommand.Enabled: Boolean;
begin
  Result := inherited Enabled and Task.Summary and Task.IsValueAssigned(TdxGanttTaskAssignedValue.Summary);
end;

function TdxGanttControlChangeSummaryManualCommand.GetAssignedValue: TdxGanttTaskAssignedValue;
begin
  Result := TdxGanttTaskAssignedValue.Manual;
end;

function TdxGanttControlChangeSummaryManualCommand.GetChangeValueHistoryItemClass: TdxGanttControlChangeTaskPropertyHistoryItemClass;
begin
  Result := TdxGanttControlChangeManualHistoryItem;
end;

{ TdxGanttControlChangeTaskDependentPropertyCommand }

constructor TdxGanttControlChangeTaskDependentPropertyCommand.Create(
  AControl: TdxGanttControlBase; ATask: TdxGanttControlTask;
  const ANewValue: Variant);
begin
  inherited Create(AControl, ATask, ANewValue);
  FCachedMinStart := InvalidDate;
end;

procedure TdxGanttControlChangeTaskDependentPropertyCommand.AfterExecute;
begin
  if not Task.Summary or not Task.Manual then
    CalculateDependentSummary;
  CalculateDependentLinks;
  inherited AfterExecute;
end;

procedure TdxGanttControlChangeTaskDependentPropertyCommand.BeforeExecute;
begin
  inherited BeforeExecute;
  if Task.Summary and not FIsDependent then
    SetManual;
end;

procedure TdxGanttControlChangeTaskDependentPropertyCommand.AdjustStartAndFinish(ATask: TdxGanttControlTask);
var
  ADuration: TdxGanttControlDuration;
  AStart: TDateTime;
begin
  if ATask.IsValueAssigned(TdxGanttTaskAssignedValue.Duration) then
  begin
    ADuration := TdxGanttControlDuration.Create(ATask.Duration);
    if ATask.IsValueAssigned(TdxGanttTaskAssignedValue.Start) then
    begin
      AStart := ATask.RealCalendar.GetNextWorkTime(ATask.Start);
      if AStart <> ATask.Start then
        SetStart(ATask, AStart)
      else
      begin
        if ADuration.IsZero then
          SetFinish(ATask, AStart)
        else
          SetFinish(ATask, ADuration.GetWorkFinish(AStart, ATask.RealCalendar, ATask.RealDurationFormat));
      end;
    end
    else if ATask.IsValueAssigned(TdxGanttTaskAssignedValue.Finish) then
      SetStart(ATask, ADuration.GetWorkStart(ATask.Finish, ATask.RealCalendar, ATask.RealDurationFormat));
    TdxDependentLinksCalculator.UpdateTaskStart(Control, ATask);
  end
  else
  begin
    with TdxGanttControlChangeTaskFinishCommand.Create(Control, ATask, Null) do
    try
      FIsDependent := True;
      Execute;
    finally
      Free;
    end;
  end;
end;

procedure TdxGanttControlChangeTaskDependentPropertyCommand.SetFinish(ATask: TdxGanttControlTask; Value: TDateTime);
begin
  with TdxGanttControlChangeTaskFinishCommand.Create(Control, ATask, Value) do
  try
    FLockUpdateSummary := Self.FLockUpdateSummary;
    FIsDependent := True;
    Execute;
  finally
    Free;
  end;
end;

procedure TdxGanttControlChangeTaskDependentPropertyCommand.SetStart(ATask: TdxGanttControlTask; Value: TDateTime);
begin
  with TdxGanttControlChangeTaskStartCommand.Create(Control, ATask, Value) do
  try
    FLockUpdateSummary := Self.FLockUpdateSummary;
    FIsDependent := True;
    Execute;
  finally
    Free;
  end;
end;

procedure TdxGanttControlChangeTaskDependentPropertyCommand.CalculateDependentLinks;
begin
  with TdxDependentLinksCalculator.Create(Control, Task) do
  try
    Calculate;
  finally
    Free;
  end;
end;

procedure TdxGanttControlChangeTaskDependentPropertyCommand.CalculateDependentSummary;
begin
  if FLockUpdateSummary then
    Exit;
  with TdxDependentSummaryCalculator.Create(Control, Task) do
  try
    Calculate;
  finally
    Free;
  end;
end;

function TdxGanttControlChangeTaskDependentPropertyCommand.DoIsNewValueValid: Boolean;
begin
  Result := True;
end;

function TdxGanttControlChangeTaskDependentPropertyCommand.GetMinStart: TDateTime;
begin
  if FCachedMinStart = InvalidDate then
    FCachedMinStart := TdxDependentLinksCalculator.CalculateMinStart(Task);
  Result := FCachedMinStart;
end;

function TdxGanttControlChangeTaskDependentPropertyCommand.IsNewValueValid: Boolean;
begin
  Result := FIsDependent or Task.Manual or VarIsNull(NewValue);
  if not Result then
    Result := DoIsNewValueValid;
end;

procedure TdxGanttControlChangeTaskDependentPropertyCommand.SetConstraint(AType: TdxGanttControlTaskConstraintType; AValue: TDateTime);
begin
  with TdxGanttControlChangeTaskConstraintTypeCommand.Create(Control, Task, AType) do
  try
    FLockUpdateSummary := Self.FLockUpdateSummary;
    FIsDependent := True;
    Execute;
  finally
    Free;
  end;
  with TdxGanttControlChangeTaskConstraintDateCommand.Create(Control, Task, AValue) do
  try
    FLockUpdateSummary := Self.FLockUpdateSummary;
    FIsDependent := True;
    Execute;
  finally
    Free;
  end;
end;

procedure TdxGanttControlChangeTaskDependentPropertyCommand.SetManual;
begin
  with TdxGanttControlChangeSummaryManualCommand.Create(Control, Task, True) do
  try
    Execute;
  finally
    Free;
  end;
end;

procedure TdxGanttControlChangeTaskDependentPropertyCommand.SetMilestone(Value: Boolean = True);
begin
  with TdxGanttControlSetTaskMilestoneCommand.Create(Control, Task, Value) do
  try
    FLockUpdateSummary := Self.FLockUpdateSummary;
    Execute;
  finally
    Free;
  end;
end;

{ TdxGanttControlChangeTaskConstraintCommand }

procedure TdxGanttControlChangeTaskConstraintCommand.AfterExecute;
var
  AStart, AFinish: TDateTime;
begin
  inherited AfterExecute;
  if FIsDependent or Task.Manual or not Task.IsValueAssigned(TdxGanttTaskAssignedValue.Start) or
      not Task.IsValueAssigned(TdxGanttTaskAssignedValue.Finish) then
    Exit;
  AStart := Task.Start;
  AFinish := Task.Finish;
  TdxDependentLinksCalculator.CalculateStartAndFinish(Task, AStart, AFinish);
  if CompareDateTime(Task.Start, AStart) <> 0 then
    with TdxGanttControlChangeTaskStartCommand.Create(Control, Task, AStart) do
    try
      FIsDependent := True;
      Execute;
    finally
      Free;
    end;
end;

{ TdxGanttControlChangeTaskConstraintTypeCommand }

function TdxGanttControlChangeTaskConstraintTypeCommand.Enabled: Boolean;
begin
  Result := inherited Enabled and not Task.Manual;
end;

function TdxGanttControlChangeTaskConstraintTypeCommand.GetAssignedValue: TdxGanttTaskAssignedValue;
begin
  Result := TdxGanttTaskAssignedValue.ConstraintType;
end;

function TdxGanttControlChangeTaskConstraintTypeCommand.GetChangeValueHistoryItemClass: TdxGanttControlChangeTaskPropertyHistoryItemClass;
begin
  Result := TdxGanttControlChangeTaskConstraintTypeHistoryItem;
end;

{ TdxGanttControlChangeTaskConstraintDateCommand }

function TdxGanttControlChangeTaskConstraintDateCommand.Enabled: Boolean;
begin
  Result := inherited Enabled and (VarIsNull(NewValue) or (Task.IsValueAssigned(TdxGanttTaskAssignedValue.ConstraintType) and
    (Task.ConstraintType <> TdxGanttControlTaskConstraintType.AsSoonAsPossible)));
end;

function TdxGanttControlChangeTaskConstraintDateCommand.GetAssignedValue: TdxGanttTaskAssignedValue;
begin
  Result := TdxGanttTaskAssignedValue.ConstraintDate;
end;

function TdxGanttControlChangeTaskConstraintDateCommand.GetChangeValueHistoryItemClass: TdxGanttControlChangeTaskPropertyHistoryItemClass;
begin
  Result := TdxGanttControlChangeTaskConstraintDateHistoryItem;
end;

{ TdxGanttControlChangeTaskTimeBoundsCommand }

function TdxGanttControlChangeTaskTimeBoundsCommand.Enabled: Boolean;
begin
  Result := inherited Enabled and (not VarIsNull(NewValue) or Task.Summary or Task.Manual)
end;

{ TdxGanttControlChangeTaskStartCommand }

procedure TdxGanttControlChangeTaskStartCommand.AfterExecute;
begin
  if not Task.IsValueAssigned(TdxGanttTaskAssignedValue.Start) and not FIsDependent then
  begin
    with TdxGanttControlChangeTaskDurationCommand.Create(Control, Task, Null) do
    try
      FLockUpdateSummary := Self.FLockUpdateSummary;
      FIsDependent := True;
      Execute;
    finally
      Free;
    end;
  end;
  ResetAssignedValue(TdxGanttTaskAssignedValue.ActualStart);
  ResetAssignedValue(TdxGanttTaskAssignedValue.ManualStart);
  inherited AfterExecute;
end;

procedure TdxGanttControlChangeTaskStartCommand.BeforeExecute;
begin
  inherited BeforeExecute;
  if not FIsDependent and not VarIsNull(NewValue) then
    SetConstraint(TdxGanttControlTaskConstraintType.StartNoEarlierThan, NewValue);
end;

function TdxGanttControlChangeTaskStartCommand.DoIsNewValueValid: Boolean;
begin
  Result := CompareDateTime(NewValue, GetMinStart) >= 0;
end;

function TdxGanttControlChangeTaskStartCommand.GetAssignedValue: TdxGanttTaskAssignedValue;
begin
  Result := TdxGanttTaskAssignedValue.Start;
end;

function TdxGanttControlChangeTaskStartCommand.GetChangeValueHistoryItemClass: TdxGanttControlChangeTaskPropertyHistoryItemClass;
begin
  Result := TdxGanttControlChangeTaskStartHistoryItem;
end;

procedure TdxGanttControlChangeTaskStartCommand.SetValue;
var
  ATaskDuration: string;
  ADuration: TdxGanttControlDuration;
begin
  ATaskDuration := Task.RealDuration;
  inherited SetValue;
  if Task.IsValueAssigned(TdxGanttTaskAssignedValue.Start) and
    (not Task.Summary or not FIsDependent) then
  begin
    if (ATaskDuration = '') and Task.IsValueAssigned(TdxGanttTaskAssignedValue.Finish) and (Task.Start >= Task.Finish) then
      ATaskDuration := TdxGanttControlDataModel.DefaultTaskDuration;
    if ATaskDuration <> '' then
    begin
      ADuration := TdxGanttControlDuration.Create(ATaskDuration);
      with TdxGanttControlChangeTaskFinishCommand.Create(Control, Task, ADuration.GetWorkFinish(Task.Start, Task.RealCalendar, Task.RealDurationFormat)) do
      try
        FIsDependent := True;
        Execute;
      finally
        Free;
      end;
    end;
  end;
end;

function TdxGanttControlChangeTaskStartCommand.ValidateValue(const AValue: Variant): Variant;
begin
  Result := Max(AValue, GetMinStart);
end;

{ TdxGanttControlChangeTaskFinishCommand }

procedure TdxGanttControlChangeTaskFinishCommand.AfterExecute;
begin
  if Task.IsValueAssigned(TdxGanttTaskAssignedValue.Finish) then
  begin
    if not FIsDependent and Task.IsValueAssigned(TdxGanttTaskAssignedValue.Start) and (Task.Start > Task.Finish) then
    begin
      if Task.IsValueAssigned(TdxGanttTaskAssignedValue.Manual) and not Task.Manual then
        SetStart
      else
      begin
        with TdxGanttControlChangeTaskStartCommand.Create(Control, Task, Task.Finish) do
        try
          FIsDependent := True;
          Execute;
        finally
          Free;
        end;
        if not Task.IsValueAssigned(TdxGanttTaskAssignedValue.Milestone) or not Task.Milestone then
          SetMilestone;
      end;
    end;
    if Task.IsValueAssigned(TdxGanttTaskAssignedValue.Start) then
      SetDuration
    else if Task.IsValueAssigned(TdxGanttTaskAssignedValue.Duration) then
      SetStart;
  end
  else if not FIsDependent then
  begin
    with TdxGanttControlChangeTaskDurationCommand.Create(Control, Task, Null) do
    try
      FIsDependent := True;
      Execute;
    finally
      Free;
    end;
  end;
  if Task.ID = 0 then
    TdxDependentLinksCalculator.UpdateLateAsPossibleTasks(Control);
  ResetAssignedValue(TdxGanttTaskAssignedValue.ActualFinish);
  ResetAssignedValue(TdxGanttTaskAssignedValue.ManualFinish);
  inherited AfterExecute;
end;

procedure TdxGanttControlChangeTaskFinishCommand.BeforeExecute;
begin
  inherited BeforeExecute;
  if not FIsDependent and not VarIsNull(NewValue) then
    SetConstraint(TdxGanttControlTaskConstraintType.FinishNoEarlierThan, NewValue);
end;

function TdxGanttControlChangeTaskFinishCommand.GetAssignedValue: TdxGanttTaskAssignedValue;
begin
  Result := TdxGanttTaskAssignedValue.Finish;
end;

function TdxGanttControlChangeTaskFinishCommand.GetChangeValueHistoryItemClass: TdxGanttControlChangeTaskPropertyHistoryItemClass;
begin
  Result := TdxGanttControlChangeTaskFinishHistoryItem;
end;

procedure TdxGanttControlChangeTaskFinishCommand.SetDuration;
begin
  TdxTaskCalculator.UpdateDuration(Control, Task);
end;

procedure TdxGanttControlChangeTaskFinishCommand.SetStart;
var
  ADuration: TdxGanttControlDuration;
begin
  ADuration := TdxGanttControlDuration.Create(Task.Duration);
  with TdxGanttControlChangeTaskStartCommand.Create(Control, Task, ADuration.GetWorkStart(Task.Finish, Task.RealCalendar, Task.RealDurationFormat)) do
  try
    FIsDependent := True;
    Execute;
  finally
    Free;
  end;
end;

{ TdxGanttControlChangeTaskDurationCommand }

procedure TdxGanttControlChangeTaskDurationCommand.AfterExecute;
var
  APercentComplete: Integer;
  ADurationAsSeconds: Int64;
begin
  if not FIsDependent then
    AdjustStartAndFinish(Task);
  if not VarIsNull(NewValue) and Task.IsValueAssigned(TdxGanttTaskAssignedValue.Start) and Task.IsValueAssigned(TdxGanttTaskAssignedValue.Finish) then
    SetMilestone(Task.Start = Task.Finish);
  TdxTaskCalculator.UpdateWorkVariance(Control, Task);
  TdxTaskCalculator.UpdateCompleteDuration(Control, Task);
  TdxDependentSummaryCalculator.CalculateSummaryWorkVariance(Control, TdxDependentSummaryCalculator.GetSummary(Task));
  TdxDependentSummaryCalculator.CalculateSummaryCompleteDuration(Control, TdxDependentSummaryCalculator.GetSummary(Task));
  if not Task.Summary and Task.IsValueAssigned(TdxGanttTaskAssignedValue.PercentComplete) then
  begin
    ADurationAsSeconds := TdxGanttControlDuration.Create(Task.Duration).ToSeconds;
    if ADurationAsSeconds = 0 then
    begin
      if Task.GetRealPercentWorkComplete > 0 then
        APercentComplete := 100
      else
        APercentComplete := 0;
    end
    else
      APercentComplete := Max(0, Min(100, Ceil(FOldSeconds * Task.GetRealPercentWorkComplete / ADurationAsSeconds)));
    with TdxGanttControlChangeTaskPercentWorkCompleteCommand.Create(Control, Task, APercentComplete) do
    try
      Execute;
    finally
      Free;
    end;
  end;
  ResetAssignedValue(TdxGanttTaskAssignedValue.ActualDuration);
  ResetAssignedValue(TdxGanttTaskAssignedValue.RemainingDuration);
  inherited AfterExecute;
end;

procedure TdxGanttControlChangeTaskDurationCommand.BeforeExecute;
var
  ADuration: TdxGanttControlDuration;
begin
  inherited BeforeExecute;
  if Task.IsValueAssigned(TdxGanttTaskAssignedValue.Duration) then
  begin
    ADuration := TdxGanttControlDuration.Create(Task.Duration);
    FOldSeconds := ADuration.ToSeconds;
  end
  else
    FOldSeconds := 0;
end;

function TdxGanttControlChangeTaskDurationCommand.GetAssignedValue: TdxGanttTaskAssignedValue;
begin
  Result := TdxGanttTaskAssignedValue.Duration;
end;

function TdxGanttControlChangeTaskDurationCommand.GetChangeValueHistoryItemClass: TdxGanttControlChangeTaskPropertyHistoryItemClass;
begin
  Result := TdxGanttControlChangeTaskDurationHistoryItem;
end;

{ TdxGanttControlChangeTaskPredecessorsCommand }

procedure TdxGanttControlChangeTaskPredecessorsCommand.AfterExecute;
begin
  inherited AfterExecute;
  TdxDependentLinksCalculator.CalculateLink(Control, Task, True)
end;

class procedure TdxGanttControlChangeTaskPredecessorsCommand.DeletePredecessorLink(AControl: TdxGanttControlBase; ATask: TdxGanttControlTask; AIndex: Integer);
var
  AHistoryItem: TdxGanttControlRemoveItemHistoryItem;
begin
  AHistoryItem := TdxGanttControlRemovePredecessorHistoryItem.Create(AControl.History, ATask);
  AHistoryItem.Index := AIndex;
  AControl.History.AddItem(AHistoryItem);
  AHistoryItem.Execute;
end;

function TdxGanttControlChangeTaskPredecessorsCommand.CanCreatePredecessorLink(APredecessorUID: Integer): Boolean;
begin
  Result := (Task.PredecessorLinks.GetItemByPredecessorUID(APredecessorUID) = nil) and TdxTaskCalculator.AllowLink(Task, APredecessorUID);
end;

procedure TdxGanttControlChangeTaskPredecessorsCommand.CreatePredecessorLink(
  APredecessorUID: Integer);

  function CreateNewTask: Integer;
  var
    AHistoryItem: TdxGanttControlCreateItemHistoryItem;
    AHistory: TdxGanttControlHistory;
  begin
    AHistory := Control.History;
    AHistoryItem := TdxGanttControlCreateItemHistoryItem.Create(AHistory, Task.Owner);
    AHistoryItem.Index := Task.Owner.Count;
    AHistory.AddItem(AHistoryItem);
    AHistoryItem.Execute;
    Result := Task.Owner[AHistoryItem.Index].UID;
  end;

  function IsTaskSummary(ATask, ACandidate: TdxGanttControlTask): Boolean;
  begin
    Result := ATask = ACandidate;
    if not Result and (ATask <> nil) then
      Result := IsTaskSummary(TdxTaskCalculator.GetSummary(ATask), ACandidate);
  end;

var
  AHistoryItem: TdxGanttControlCreateItemHistoryItem;
  APredecessor: TdxGanttControlTask;
  ATask: TdxGanttControlTask;
begin
  if APredecessorUID < 0 then
    APredecessorUID := CreateNewTask;
  ATask := Task.Owner.GetItemByUID(APredecessorUID);
  if not ATask.IsValueAssigned(TdxGanttTaskAssignedValue.Blank) or ATask.Blank then
  begin
    MakeTaskNotNull(ATask);
    with TdxGanttControlSetTaskModeCommand.CreateCommand(Control, ATask) do
    try
      Execute;
    finally
      Free;
    end;
    if ATask.Manual then
      TdxGanttControlSetTaskAutoScheduleModeCommand.SetBasicStartAndFinish(Control, ATask, True);
  end;
  if not CanCreatePredecessorLink(APredecessorUID) then
  begin
    if FRaiseValidateException then
    begin
      if Task.PredecessorLinks.GetItemByPredecessorUID(APredecessorUID) <> nil then
        TdxGanttControlExceptions.ThrowTasksCannotBeLinkedTwiceException
      else
      begin
        APredecessor := Task.Owner.GetItemByUID(APredecessorUID);
        if APredecessor <> nil then
        begin
          if APredecessor.PredecessorLinks.GetItemByPredecessorUID(Task.UID) <> nil then
            TdxGanttControlExceptions.ThrowTasksAreAlreadyLinkedException
          else if IsTaskSummary(Task, APredecessor) then
            TdxGanttControlExceptions.ThrowCannotLinkSummaryTaskToItsSubtaskException
          else
            TdxGanttControlExceptions.ThrowTasksAreAlreadyLinkedThroughAnotherTaskChainException;
        end;
      end;
    end;
    Exit;
  end;
  AHistoryItem := TdxGanttControlCreatePredecessorHistoryItem.Create(Control.History, Task);
  AHistoryItem.Index := Task.PredecessorLinks.Count;
  Control.History.AddItem(AHistoryItem);
  AHistoryItem.Execute;
  Task.PredecessorLinks[AHistoryItem.Index].PredecessorUID := APredecessorUID;
end;

procedure TdxGanttControlChangeTaskPredecessorsCommand.DeletePredecessorLink(
  AIndex: Integer);
begin
  TdxGanttControlChangeTaskPredecessorsCommand.DeletePredecessorLink(Control, Task, AIndex);
end;

function TdxGanttControlChangeTaskPredecessorsCommand.GetAssignedValue: TdxGanttTaskAssignedValue;
begin
  Result := TdxGanttTaskAssignedValue.PredecessorLinks;
end;

function TdxGanttControlChangeTaskPredecessorsCommand.GetChangeValueHistoryItemClass: TdxGanttControlChangeTaskPropertyHistoryItemClass;
begin
  Result := nil;
end;

procedure TdxGanttControlChangeTaskPredecessorsCommand.SetValue;
var
  AValue: string;
begin
  if VarIsNull(NewValue) or VarIsArray(NewValue) or VarIsType(NewValue, varInteger) then
    SetValueAsArray(NewValue)
  else
    if VarIsStr(NewValue) then
    begin
      AValue := Trim(VarToStr(NewValue));
      if AValue = '' then
        SetValueAsArray(Null)
      else
        SetValueAsString(AValue);
    end;
end;

procedure TdxGanttControlChangeTaskPredecessorsCommand.SetValueAsArray(const Value: Variant);
var
  AList: TList<Integer>;
  I: Integer;
  ATask: TdxGanttControlTask;
begin
  AList := TList<Integer>.Create;
  try
    if not VarIsNull(Value) then
      if VarIsArray(Value) then
        for I := VarArrayLowBound(Value, 1) to VarArrayHighBound(Value, 1) do
          AList.Add(Value[I])
      else
        AList.Add(Value);
    for I := Task.PredecessorLinks.Count - 1 downto 0 do
    begin
      if not Task.PredecessorLinks[I].IsValueAssigned(TdxGanttTaskPredecessorLinkAssignedValue.PredecessorUID) then
      begin
        DeletePredecessorLink(I);
        Continue;
      end;
      ATask := Task.Owner.GetItemByUID(Task.PredecessorLinks[I].PredecessorUID);
      if ATask = nil then
      begin
        DeletePredecessorLink(I);
        Continue;
      end;
      if AList.IndexOf(ATask.ID) <> -1 then
        AList.Extract(ATask.ID)
      else
        DeletePredecessorLink(I);
    end;
    for I := 0 to AList.Count - 1 do
      CreatePredecessorLink(Task.Owner[AList[I]].UID);
  finally
    AList.Free;
  end;
end;

procedure TdxGanttControlChangeTaskPredecessorsCommand.SetValueAsString(const Value: string);

  procedure ChangeIndex(ALink: TdxGanttControlTaskPredecessorLink; ANewIndex: Integer);
  var
    AHistoryItem: TdxGanttControlListChangeIndexItem;
    AHistory: TdxGanttControlHistory;
    AIndex: Integer;
  begin
    AIndex := Task.PredecessorLinks.IndexOf(ALink);
    if AIndex = ANewIndex then
      Exit;
    AHistory := Control.History;
    AHistoryItem := TdxGanttControlListChangeIndexItem.Create(AHistory, Task.PredecessorLinks);
    AHistoryItem.Index := AIndex;
    AHistoryItem.NewIndex := ANewIndex;
    AHistory.AddItem(AHistoryItem);
    AHistoryItem.Execute;
  end;

var
  ALinks: TdxGanttControlTaskCandidatePredecessorLinks;
  I: Integer;
  ALink: TdxGanttControlTaskPredecessorLink;
begin
  ALinks := TdxGanttControlTaskCandidatePredecessorLinks.CreateFromString(Task, Value);
  try
    if ALinks = nil then
    begin
      dxMessageDlg(cxGetResourceString(@sdxGanttControlMessageInvalidPredecessorInformation), mtWarning, [mbOK], 0);
      Exit;
    end;
    if not ALinks.CheckDuplicate then
    begin
      ALinks.RemoveDuplicated;
      dxMessageDlg(cxGetResourceString(@sdxGanttControlExceptionTasksCannotBeLinkedTwice), mtInformation, [mbOK], 0);
    end;
    for I := Task.PredecessorLinks.Count - 1 downto 0 do
    begin
      ALink := ALinks.GetItemByPredecessorUID(Task.PredecessorLinks[I].PredecessorUID);
      if ALink = nil then
        DeletePredecessorLink(I);
    end;
    for I := 0 to ALinks.Count - 1 do
    begin
      ALink := Task.PredecessorLinks.GetItemByPredecessorUID(ALinks[I].PredecessorUID);
      if ALink = nil then
      begin
        CreatePredecessorLink(ALinks[I].PredecessorUID);
        ALink := Task.PredecessorLinks[Task.PredecessorLinks.Count - 1];
      end;
      with TdxGanttControlChangeTaskPredecessorCommand.Create(Control, ALink, ALinks[I]) do
      try
        Execute;
      finally
        Free;
      end;
      ChangeIndex(ALink, I);
    end;
  finally
    ALinks.Free;
  end;
end;

{ TdxGanttControlTaskAddPredecessorCommand }

procedure TdxGanttControlTaskAddPredecessorCommand.SetValue;
begin
  CreatePredecessorLink(NewValue);
end;

{ TdxGanttControlChangeTaskPredecessorLinkPropertyCommand }

procedure TdxGanttControlChangeTaskPredecessorLinkPropertyCommand.AfterExecute;
begin
  inherited AfterExecute;
  if not FIsDependent then
    TdxDependentLinksCalculator.CalculateLink(Control, Link.Task, True);
end;

constructor TdxGanttControlChangeTaskPredecessorLinkPropertyCommand.Create(
  AControl: TdxGanttControlBase; ALink: TdxGanttControlTaskPredecessorLink;
  const ANewValue: Variant);
begin
  inherited Create(AControl, ALink.Task);
  FLink := ALink;
  FNewValue := ANewValue;
end;

procedure TdxGanttControlChangeTaskPredecessorLinkPropertyCommand.DoExecute;
begin
  if not VarIsNull(FNewValue) and not FLink.IsValueAssigned(GetAssignedValue) then
    SetAssignedValue;
  SetValue;
  if VarIsNull(FNewValue) then
    ResetAssignedValue;
end;

function TdxGanttControlChangeTaskPredecessorLinkPropertyCommand.Enabled: Boolean;
begin
  Result := inherited Enabled and
    (not Link.IsValueAssigned(GetAssignedValue) or (GetValue <> NewValue));
end;

function TdxGanttControlChangeTaskPredecessorLinkPropertyCommand.GetValue: Variant;
begin
  with GetChangeValueHistoryItemClass.Create(Control.History, Link) do
  try
    Result := GetValue;
  finally
    Free;
  end;
end;

procedure TdxGanttControlChangeTaskPredecessorLinkPropertyCommand.ResetAssignedValue;
var
  AHistoryItem: TdxGanttControlTaskPredecessorLinkResetAssignedValueHistoryItem;
  AHistory: TdxGanttControlHistory;
begin
  AHistory := Control.History;
  AHistoryItem := TdxGanttControlTaskPredecessorLinkResetAssignedValueHistoryItem.Create(AHistory, Link);
  AHistoryItem.FAssignedValue := GetAssignedValue;
  AHistory.AddItem(AHistoryItem);
  AHistoryItem.Execute;
end;

procedure TdxGanttControlChangeTaskPredecessorLinkPropertyCommand.SetAssignedValue;
var
  AHistoryItem: TdxGanttControlTaskPredecessorLinkSetAssignedValueHistoryItem;
  AHistory: TdxGanttControlHistory;
begin
  AHistory := Control.History;
  AHistoryItem := TdxGanttControlTaskPredecessorLinkSetAssignedValueHistoryItem.Create(AHistory, Link);
  AHistoryItem.FAssignedValue := GetAssignedValue;
  AHistory.AddItem(AHistoryItem);
  AHistoryItem.Execute;
end;

procedure TdxGanttControlChangeTaskPredecessorLinkPropertyCommand.SetValue;
var
  AHistoryItem: TdxGanttControlChangeTaskPredecessorLinkPropertyHistoryItem;
begin
  AHistoryItem := GetChangeValueHistoryItemClass.Create(Control.History, Link);
  AHistoryItem.FNewValue := NewValue;
  Control.History.AddItem(AHistoryItem);
  AHistoryItem.Execute;
end;

{ TdxGanttControlChangeTaskPredecessorLinkTypeCommand }

function TdxGanttControlChangeTaskPredecessorLinkTypeCommand.GetAssignedValue: TdxGanttTaskPredecessorLinkAssignedValue;
begin
  Result := TdxGanttTaskPredecessorLinkAssignedValue.&Type;
end;

function TdxGanttControlChangeTaskPredecessorLinkTypeCommand.GetChangeValueHistoryItemClass: TdxGanttControlChangeTaskPredecessorLinkPropertyHistoryItemClass;
begin
  Result := TdxGanttControlChangeTaskPredecessorLinkTypeHistoryItem;
end;

{ TdxGanttControlChangeTaskPredecessorLinkLagCommand }

function TdxGanttControlChangeTaskPredecessorLinkLagCommand.GetAssignedValue: TdxGanttTaskPredecessorLinkAssignedValue;
begin
  Result := TdxGanttTaskPredecessorLinkAssignedValue.LinkLag;
end;

function TdxGanttControlChangeTaskPredecessorLinkLagCommand.GetChangeValueHistoryItemClass: TdxGanttControlChangeTaskPredecessorLinkPropertyHistoryItemClass;
begin
  Result := TdxGanttControlChangeTaskPredecessorLinkLagHistoryItem;
end;

{ TdxGanttControlChangeTaskPredecessorLinkLagFormatCommand }

function TdxGanttControlChangeTaskPredecessorLinkLagFormatCommand.GetAssignedValue: TdxGanttTaskPredecessorLinkAssignedValue;
begin
  Result := TdxGanttTaskPredecessorLinkAssignedValue.LagFormat;
end;

function TdxGanttControlChangeTaskPredecessorLinkLagFormatCommand.GetChangeValueHistoryItemClass: TdxGanttControlChangeTaskPredecessorLinkPropertyHistoryItemClass;
begin
  Result := TdxGanttControlChangeTaskPredecessorLinkLagFormatHistoryItem;
end;

{ TdxGanttControlChangeTaskPredecessorCommand }

constructor TdxGanttControlChangeTaskPredecessorCommand.Create(
  AControl: TdxGanttControlBase; ALink,
  ANewLink: TdxGanttControlTaskPredecessorLink);
begin
  inherited Create(AControl, ALink.Task);
  FLink := ALink;
  FNewLink := ANewLink;
  FCommands := TdxFastObjectList.Create;
  if FNewLink <> nil then
  begin
    FCommands.Add(TdxGanttControlChangeTaskPredecessorLinkTypeCommand.Create(Control, FLink, FNewLink.&Type));
    FCommands.Add(TdxGanttControlChangeTaskPredecessorLinkLagCommand.Create(Control, FLink, FNewLink.LinkLag));
    FCommands.Add(TdxGanttControlChangeTaskPredecessorLinkLagFormatCommand.Create(Control, FLink, FNewLink.LagFormat));
  end;
end;

destructor TdxGanttControlChangeTaskPredecessorCommand.Destroy;
begin
  FreeAndNil(FCommands);
  inherited Destroy;
end;

procedure TdxGanttControlChangeTaskPredecessorCommand.AfterExecute;
begin
  inherited AfterExecute;
  TdxDependentLinksCalculator.CalculateLink(Control, Task, True)
end;

procedure TdxGanttControlChangeTaskPredecessorCommand.Delete;
begin
  TdxGanttControlChangeTaskPredecessorsCommand.DeletePredecessorLink(Control, Task, Task.PredecessorLinks.IndexOf(FLink));
end;

procedure TdxGanttControlChangeTaskPredecessorCommand.DoExecute;
var
  I: Integer;
  ACommand: TdxGanttControlChangeTaskPredecessorLinkPropertyCommand;
begin
  inherited DoExecute;
  if FNewLink = nil then
    Delete
  else
    for I := 0 to FCommands.Count - 1 do
    begin
      ACommand := TdxGanttControlChangeTaskPredecessorLinkPropertyCommand(FCommands[I]);
      if FNewLink.IsValueAssigned(ACommand.GetAssignedValue) then
      begin
        ACommand.FIsDependent := True;
        ACommand.Execute;
      end;
    end;
end;

function TdxGanttControlChangeTaskPredecessorCommand.Enabled: Boolean;
var
  I: Integer;
begin
  Result := inherited Enabled;
  if Result and (FNewLink <> nil) then
  begin
    for I := 0 to FCommands.Count - 1 do
      if TdxGanttControlCommand(FCommands[I]).Enabled then
        Exit;
    Result := False;
  end;
end;

{ TdxGanttControlChangeTaskResourcesCommand }

function TdxGanttControlChangeTaskResourcesCommand.GetAssignedValue: TdxGanttTaskAssignedValue;
begin
  Result := TdxGanttTaskAssignedValue(-1); 
end;

function TdxGanttControlChangeTaskResourcesCommand.GetChangeValueHistoryItemClass: TdxGanttControlChangeTaskPropertyHistoryItemClass;
begin
  Result := nil;
end;

function TdxGanttControlChangeTaskResourcesCommand.HasAssignedValue: Boolean;
begin
  Result := False;
end;

procedure TdxGanttControlChangeTaskResourcesCommand.SetValue;
var
  AValue: string;
begin
  if VarIsNull(NewValue) or VarIsArray(NewValue) or VarIsType(NewValue, varInteger) then
    SetValueAsArray(NewValue)
  else
    if VarIsStr(NewValue) then
    begin
      AValue := Trim(VarToStr(NewValue));
      if AValue = '' then
        SetValueAsArray(Null)
      else
        SetValueAsString(AValue);
    end;
end;

procedure TdxGanttControlChangeTaskResourcesCommand.SetValueAsArray(const Value: Variant);
var
  AList: TList<Integer>;
  I: Integer;
  AIndex: Integer;
begin
  AList := TList<Integer>.Create;
  try
    if not VarIsNull(Value) then
      if VarIsArray(Value) then
        for I := VarArrayLowBound(Value, 1) to VarArrayHighBound(Value, 1) do
          AList.Add(Value[I])
      else
        AList.Add(Value);
    for I := DataModel.Assignments.Count - 1 downto 0 do
    begin
      if not DataModel.Assignments[I].IsValueAssigned(TdxGanttAssignmentAssignedValue.ResourceUID) or
          not DataModel.Assignments[I].IsValueAssigned(TdxGanttAssignmentAssignedValue.TaskUID) or
          (DataModel.Assignments[I].TaskUID <> Task.UID) or (DataModel.Assignments[I].ResourceUID < 0) then
        Continue;

      AIndex := AList.IndexOf(DataModel.Assignments[I].ResourceUID);
      if AIndex <> -1 then
        AList.Delete(AIndex)
      else
        DeleteAssignment(I);
    end;
    for I := 0 to AList.Count - 1 do
      CreateAssignment(AList[I]);
  finally
    AList.Free;
  end;
end;

procedure TdxGanttControlChangeTaskResourcesCommand.SetValueAsString(const Value: string);

  function CreateNewResource: TdxGanttControlResource;
  var
    AResources: TdxGanttControlResources;
    AHistoryItem: TdxGanttControlCreateItemHistoryItem;
  begin
    AResources := TdxGanttControlDataModel(Task.DataModel).Resources;
    AHistoryItem := TdxGanttControlCreateItemHistoryItem.Create(Control.History, AResources);
    AHistoryItem.Index := AResources.Count;
    Control.History.AddItem(AHistoryItem);
    AHistoryItem.Execute;
    Result := AResources[AHistoryItem.Index];
  end;

  function AddNewResource(const AName: string): Integer;
  var
    AResource: TdxGanttControlResource;
  begin
    AResource := CreateNewResource;
    with TdxGanttControlChangeResourceNameCommand.Create(Control, AResource, AName) do
    try
      Execute;
    finally
      Free;
    end;
    Result := AResource.UID;
  end;

var
  AResources: TdxGanttControlTaskCandidateResources;
  AResource: TdxGanttControlTaskCandidateResource;
  I, AUID: Integer;
  AArray: TArray<Integer>;
begin
  AResources := TdxGanttControlTaskCandidateResources.CreateFromString(Task, Value);
  try
    if not AResources.CheckDuplicate then
    begin
      AResources.RemoveDuplicated;
      dxMessageDlg(cxGetResourceString(@sdxGanttControlMessageTwiceResourcesInformation), mtInformation, [mbOK], 0);
    end;

    SetLength(AArray, AResources.Count);
    for I := 0 to AResources.Count - 1 do
    begin
      AResource := TdxGanttControlTaskCandidateResource(AResources[I]);
      if AResource.Resource <> nil then
        AUID := AResource.Resource.UID
      else
        AUID := AddNewResource(AResource.Name);
      AArray[I] := AUID;
    end;
    SetValueAsArray(AArray);
  finally
    AResources.Free;
  end;
end;

procedure TdxGanttControlChangeTaskResourcesCommand.CreateAssignment(AResourceUID: Integer);
var
  AHistoryItem: TdxGanttControlCreateItemHistoryItem;
begin
  AHistoryItem := TdxGanttControlCreateItemHistoryItem.Create(Control.History, DataModel.Assignments);
  AHistoryItem.Index := DataModel.Assignments.Count;
  Control.History.AddItem(AHistoryItem);
  AHistoryItem.Execute;
  DataModel.Assignments[AHistoryItem.Index].TaskUID := Task.UID;
  DataModel.Assignments[AHistoryItem.Index].ResourceUID := AResourceUID;
end;

procedure TdxGanttControlChangeTaskResourcesCommand.DeleteAssignment(AIndex: Integer);
begin
  TdxGanttControlChangeResourceCustomCommand.DeleteAssignment(Control, DataModel.Assignments, AIndex);
end;

{ TdxGanttControlChangeTaskExtendedAttributeValueCommand }

constructor TdxGanttControlChangeTaskExtendedAttributeValueCommand.Create(
  AControl: TdxGanttControlBase; ATask: TdxGanttControlTask;
  const AFieldName: string; const ANewValue: Variant);
begin
  inherited Create(AControl, ATask, ANewValue);
  FFieldName := AFieldName;
end;

function TdxGanttControlChangeTaskExtendedAttributeValueCommand.GetAssignedValue: TdxGanttTaskAssignedValue;
begin
  Result := TdxGanttTaskAssignedValue.ExtendedAttributes;
end;

function TdxGanttControlChangeTaskExtendedAttributeValueCommand.GetChangeValueHistoryItemClass: TdxGanttControlChangeTaskPropertyHistoryItemClass;
begin
  Result := nil;
end;

function TdxGanttControlChangeTaskExtendedAttributeValueCommand.HasAssignedValue: Boolean;
begin
  Result := False;
end;

procedure TdxGanttControlChangeTaskExtendedAttributeValueCommand.SetValue;
var
  AGetExtendedAttributes: TdxGetGanttControlExtendedAttributeValues;
  ATask: TdxGanttControlTask;
begin
  ATask := Task;
  AGetExtendedAttributes := function: TdxGanttControlExtendedAttributeValues
    begin
      Result := ATask.ExtendedAttributes;
    end;

  with TdxGanttControlChangeExtendedAttributeValueCommand.Create(Control, AGetExtendedAttributes, FFieldName, NewValue) do
  try
    Execute;
  finally
    Free;
  end;
end;

{ TdxGanttControlMoveTaskCommand }

constructor TdxGanttControlMoveTaskCommand.Create(AControl: TdxGanttControlBase;
  ATask: TdxGanttControlTask; ANewIndex, AOutlineLevel: Integer);
begin
  inherited Create(AControl, ATask);
  FNewIndex := ANewIndex;
  FOutlineLevel := AOutlineLevel;
end;

procedure TdxGanttControlMoveTaskCommand.AfterExecute;

  procedure CheckOldSummary;
  var
    AList: TList<TdxGanttControlTask>;
  begin
    AList := TdxTaskCalculator.GetSubTasks(FOldSummary, True, True);
    try
      if AList.Count > 0 then
        Exit;
    finally
      AList.Free;
    end;
    with TdxGanttControlChangeTaskSummaryCommand.Create(Control, FOldSummary, False) do
    try
      Execute;
    finally
      Free;
    end;
  end;

var
  ASummary: TdxGanttControlTask;
begin
  inherited AfterExecute;
  DeleteLastBlankTasks;
  ASummary := TdxTaskCalculator.GetSummary(Task);
  if ASummary = FOldSummary then
    Exit;
  CheckOldSummary;
  TdxDependentSummaryCalculator.UpdateSummary(Control, FOldSummary);
  TdxDependentSummaryCalculator.UpdateSummary(Control, ASummary);
end;

procedure TdxGanttControlMoveTaskCommand.BeforeExecute;
begin
  inherited BeforeExecute;
  FOldSummary := TdxTaskCalculator.GetSummary(Task);
end;

procedure TdxGanttControlMoveTaskCommand.DeleteLastBlankTasks;
var
  I: Integer;
  AHistoryItem: TdxGanttControlRemoveItemHistoryItem;
  AHistory: TdxGanttControlHistory;
begin
  AHistory := Control.History;
  for I := DataModel.Tasks.Count - 1 downto 0 do
  begin
    if not DataModel.Tasks[I].Blank then
      Break;
    AHistoryItem := TdxGanttControlRemoveItemHistoryItem.Create(AHistory, DataModel.Tasks);
    AHistoryItem.Index := I;
    AHistory.AddItem(AHistoryItem);
    AHistoryItem.Execute;
  end;
end;

procedure TdxGanttControlMoveTaskCommand.DoExecute;

  procedure CorrectOutlineLevel(ATask: TdxGanttControlTask; AValue: Integer);
  var
    AHistoryItem: TdxGanttControlChangeTaskOutlineLevelHistoryItem;
    AHistory: TdxGanttControlHistory;
  begin
    if AValue = 0 then
      Exit;
    AHistory := Control.History;
    AHistoryItem := TdxGanttControlChangeTaskOutlineLevelHistoryItem.Create(AHistory, ATask);
    AHistoryItem.FNewValue := ATask.OutlineLevel + AValue;
    AHistory.AddItem(AHistoryItem);
    AHistoryItem.Execute;
  end;

  procedure ChangeIndex(AIndex, ANewIndex: Integer);
  var
    AHistoryItem: TdxGanttControlListChangeIndexItem;
    AHistory: TdxGanttControlHistory;
  begin
    AHistory := Control.History;
    AHistoryItem := TdxGanttControlListChangeIndexItem.Create(AHistory, DataModel.Tasks);
    AHistoryItem.Index := AIndex;
    AHistoryItem.NewIndex := ANewIndex;
    AHistory.AddItem(AHistoryItem);
    AHistoryItem.Execute;
  end;

  procedure CheckLinks(ATask: TdxGanttControlTask);
  var
    ASummary: TdxGanttControlTask;
  begin
    if not TdxDependentLinksCalculator.CheckLinks(ATask) then
      TdxGanttControlExceptions.ThrowPositionChangeWouldCreateCircularRelationshipException;

    ASummary := TdxTaskCalculator.GetSummary(ATask);
    while ASummary <> nil do
    begin
      if not TdxDependentLinksCalculator.CheckLinks(ASummary) then
        TdxGanttControlExceptions.ThrowPositionChangeWouldCreateCircularRelationshipException;
      ASummary := TdxTaskCalculator.GetSummary(ASummary);
    end;
  end;

var
  AList: TList<TdxGanttControlTask>;
  AIndex: Integer;
  ANewIndex: Integer;
  I: Integer;
  ALevel: Integer;
begin
  inherited DoExecute;
  ALevel := FOutlineLevel - Task.OutlineLevel;
  AList := TdxTaskCalculator.GetSubTasks(Task, True, True);
  try
    AIndex := DataModel.Tasks.Count - 1;
    for I := AList.Count - 1 downto 0 do
    begin
      if AList[I].Blank and (AList[I] = DataModel.Tasks[AIndex]) then
        AList.Delete(I)
      else
        Break;
      Dec(AIndex);
    end;
    AIndex := DataModel.Tasks.IndexOf(Task);
    ANewIndex := FNewIndex;
    ChangeIndex(AIndex, ANewIndex);
    CorrectOutlineLevel(DataModel.Tasks[ANewIndex], ALevel);
    CheckLinks(DataModel.Tasks[ANewIndex]);
    for I := 0 to AList.Count - 1 do
    begin
      if AIndex > ANewIndex then
      begin
        Inc(AIndex);
        Inc(ANewIndex);
      end;
      ChangeIndex(AIndex, ANewIndex);
      CorrectOutlineLevel(DataModel.Tasks[ANewIndex], ALevel);
      CheckLinks(DataModel.Tasks[ANewIndex]);
    end;
  finally
    AList.Free;
  end;
end;

{ TdxGanttControlTaskSetBaselineCommand }

constructor TdxGanttControlTaskSetBaselineCommand.Create(
  AControl: TdxGanttControlBase; ATask: TdxGanttControlTask; ANumber: Integer);
begin
  inherited Create(AControl, ATask);
  FNumber := ANumber;
  FBaseline := Task.Baselines.Find(ANumber);
  FCommands := TdxFastObjectList.Create;
  if FBaseline <> nil then
  begin
    FCommands.Add(TdxGanttControlTaskBaselineUpdateStartCommand.Create(Control, Task, FBaseline));
    FCommands.Add(TdxGanttControlTaskBaselineUpdateFinishCommand.Create(Control, Task, FBaseline));
    FCommands.Add(TdxGanttControlTaskBaselineUpdateDurationCommand.Create(Control, Task, FBaseline));
    FCommands.Add(TdxGanttControlTaskBaselineUpdateDurationFormatCommand.Create(Control, Task, FBaseline));
    FCommands.Add(TdxGanttControlTaskBaselineUpdateEstimatedCommand.Create(Control, Task, FBaseline));
    FCommands.Add(TdxGanttControlTaskBaselineUpdateBudgetedCostOfWorkPerformedCommand.Create(Control, Task, FBaseline));
    FCommands.Add(TdxGanttControlTaskBaselineUpdateBudgetedCostOfWorkScheduledCommand.Create(Control, Task, FBaseline));
    FCommands.Add(TdxGanttControlTaskBaselineUpdateCostCommand.Create(Control, Task, FBaseline));
  end;
end;

destructor TdxGanttControlTaskSetBaselineCommand.Destroy;
begin
  FreeAndNil(FCommands);
  inherited Destroy;
end;

procedure TdxGanttControlTaskSetBaselineCommand.DoExecute;
var
  AItem: TdxGanttControlCreateBaselineHistoryItem;
  I: Integer;
  ACommand: TdxGanttControlTaskBaselineUpdatePropertyCommand;
begin
  inherited DoExecute;
  if FBaseline = nil then
  begin
    AItem := TdxGanttControlCreateBaselineHistoryItem.Create(Control.History, Task.Baselines);
    AItem.Number := FNumber;
    Control.History.AddItem(AItem);
    AItem.Execute;
    FBaseline := Task.Baselines[AItem.Index];
    FBaseline.AssignCurrentValues;
  end
  else
  begin
    for I := 0 to FCommands.Count - 1 do
    begin
      ACommand := TdxGanttControlTaskBaselineUpdatePropertyCommand(FCommands[I]);
      ACommand.Execute;
    end;
  end;
end;

function TdxGanttControlTaskSetBaselineCommand.Enabled: Boolean;
var
  I: Integer;
  ACommand: TdxGanttControlTaskBaselineUpdatePropertyCommand;
begin
  Result := inherited Enabled and not Task.Blank;
  if Result and (FBaseline <> nil) then
  begin
    for I := 0 to FCommands.Count - 1 do
    begin
      ACommand := TdxGanttControlTaskBaselineUpdatePropertyCommand(FCommands[I]);
      if ACommand.Enabled then
        Exit;
    end;
    Result := False;
  end;
end;

{ TdxGanttControlTaskBaselineUpdatePropertyCommand }

constructor TdxGanttControlTaskBaselineUpdatePropertyCommand.Create(
  AControl: TdxGanttControlBase; ATask: TdxGanttControlTask;
  ABaseline: TdxGanttControlTaskBaseline);
begin
  inherited Create(AControl, ATask);
  FBaseline := ABaseline;
end;

procedure TdxGanttControlTaskBaselineUpdatePropertyCommand.DoExecute;
begin
  inherited DoExecute;
  if not IsTaskValueAssigned then
    ResetAssignedValue
  else
  begin
    if not IsBaselineValueAssigned then
      SetAssignedValue
    else
      SetValue;
  end;
end;

function TdxGanttControlTaskBaselineUpdatePropertyCommand.Enabled: Boolean;
begin
  Result := inherited Enabled and
    ((IsTaskValueAssigned <> IsBaselineValueAssigned) or
    (VarCompare(GetTaskValue, GetBaselineValue) <> 0));
end;

procedure TdxGanttControlTaskBaselineUpdatePropertyCommand.SetValue;
var
  AItem: TdxGanttControlChangeTaskBaselinePropertyHistoryItem;
begin
  AItem := GetSetValueHistoryItemClass.Create(Control.History, Baseline);
  AItem.FNewValue := GetTaskValue;
  Control.History.AddItem(AItem);
  AItem.Execute;
end;

{ TdxGanttControlTaskBaselineUpdateStartCommand }

function TdxGanttControlTaskBaselineUpdateStartCommand.GetBaselineValue: Variant;
begin
  Result := Baseline.Start;
end;

function TdxGanttControlTaskBaselineUpdateStartCommand.GetSetValueHistoryItemClass: TdxGanttControlChangeTaskBaselinePropertyHistoryItemClass;
begin
  Result := TdxGanttControlChangeTaskBaselineStartHistoryItem;
end;

function TdxGanttControlTaskBaselineUpdateStartCommand.GetTaskValue: Variant;
begin
  Result := Task.Start;
end;

function TdxGanttControlTaskBaselineUpdateStartCommand.IsBaselineValueAssigned: Boolean;
begin
  Result := Baseline.IsValueAssigned(TdxGanttTaskBaselineAssignedValue.Start);
end;

function TdxGanttControlTaskBaselineUpdateStartCommand.IsTaskValueAssigned: Boolean;
begin
  Result := Task.IsValueAssigned(TdxGanttTaskAssignedValue.Start);
end;

procedure TdxGanttControlTaskBaselineUpdateStartCommand.ResetAssignedValue;
var
  AItem: TdxGanttControlTaskBaselineResetAssignedValueHistoryItem;
begin
  AItem := TdxGanttControlTaskBaselineResetAssignedValueHistoryItem.Create(Control.History, Baseline);
  AItem.FAssignedValue := TdxGanttTaskBaselineAssignedValue.Start;
  Control.History.AddItem(AItem);
  AItem.Execute;
end;

procedure TdxGanttControlTaskBaselineUpdateStartCommand.SetAssignedValue;
var
  AItem: TdxGanttControlTaskBaselineSetAssignedValueHistoryItem;
begin
  AItem := TdxGanttControlTaskBaselineSetAssignedValueHistoryItem.Create(Control.History, Baseline);
  AItem.FAssignedValue := TdxGanttTaskBaselineAssignedValue.Start;
  Control.History.AddItem(AItem);
  AItem.Execute;
end;

{ TdxGanttControlTaskBaselineSetFinishCommand }

function TdxGanttControlTaskBaselineUpdateFinishCommand.GetBaselineValue: Variant;
begin
  Result := Baseline.Finish;
end;

function TdxGanttControlTaskBaselineUpdateFinishCommand.GetSetValueHistoryItemClass: TdxGanttControlChangeTaskBaselinePropertyHistoryItemClass;
begin
  Result := TdxGanttControlChangeTaskBaselineFinishHistoryItem;
end;

function TdxGanttControlTaskBaselineUpdateFinishCommand.GetTaskValue: Variant;
begin
  Result := Task.Finish;
end;

function TdxGanttControlTaskBaselineUpdateFinishCommand.IsBaselineValueAssigned: Boolean;
begin
  Result := Baseline.IsValueAssigned(TdxGanttTaskBaselineAssignedValue.Finish);
end;

function TdxGanttControlTaskBaselineUpdateFinishCommand.IsTaskValueAssigned: Boolean;
begin
  Result := Task.IsValueAssigned(TdxGanttTaskAssignedValue.Finish);
end;

procedure TdxGanttControlTaskBaselineUpdateFinishCommand.ResetAssignedValue;
var
  AItem: TdxGanttControlTaskBaselineResetAssignedValueHistoryItem;
begin
  AItem := TdxGanttControlTaskBaselineResetAssignedValueHistoryItem.Create(Control.History, Baseline);
  AItem.FAssignedValue := TdxGanttTaskBaselineAssignedValue.Finish;
  Control.History.AddItem(AItem);
  AItem.Execute;
end;

procedure TdxGanttControlTaskBaselineUpdateFinishCommand.SetAssignedValue;
var
  AItem: TdxGanttControlTaskBaselineSetAssignedValueHistoryItem;
begin
  AItem := TdxGanttControlTaskBaselineSetAssignedValueHistoryItem.Create(Control.History, Baseline);
  AItem.FAssignedValue := TdxGanttTaskBaselineAssignedValue.Finish;
  Control.History.AddItem(AItem);
  AItem.Execute;
end;


{ TdxGanttControlTaskBaselineUpdateDurationCommand }

function TdxGanttControlTaskBaselineUpdateDurationCommand.GetBaselineValue: Variant;
begin
  Result := Baseline.Duration;
end;

function TdxGanttControlTaskBaselineUpdateDurationCommand.GetSetValueHistoryItemClass: TdxGanttControlChangeTaskBaselinePropertyHistoryItemClass;
begin
  Result := TdxGanttControlChangeTaskBaselineDurationHistoryItem;
end;

function TdxGanttControlTaskBaselineUpdateDurationCommand.GetTaskValue: Variant;
begin
  Result := Task.Duration;
end;

function TdxGanttControlTaskBaselineUpdateDurationCommand.IsBaselineValueAssigned: Boolean;
begin
  Result := Baseline.IsValueAssigned(TdxGanttTaskBaselineAssignedValue.Duration);
end;

function TdxGanttControlTaskBaselineUpdateDurationCommand.IsTaskValueAssigned: Boolean;
begin
  Result := Task.IsValueAssigned(TdxGanttTaskAssignedValue.Duration);
end;

procedure TdxGanttControlTaskBaselineUpdateDurationCommand.ResetAssignedValue;
var
  AItem: TdxGanttControlTaskBaselineResetAssignedValueHistoryItem;
begin
  AItem := TdxGanttControlTaskBaselineResetAssignedValueHistoryItem.Create(Control.History, Baseline);
  AItem.FAssignedValue := TdxGanttTaskBaselineAssignedValue.Duration;
  Control.History.AddItem(AItem);
  AItem.Execute;
end;

procedure TdxGanttControlTaskBaselineUpdateDurationCommand.SetAssignedValue;
var
  AItem: TdxGanttControlTaskBaselineResetAssignedValueHistoryItem;
begin
  AItem := TdxGanttControlTaskBaselineResetAssignedValueHistoryItem.Create(Control.History, Baseline);
  AItem.FAssignedValue := TdxGanttTaskBaselineAssignedValue.Duration;
  Control.History.AddItem(AItem);
  AItem.Execute;
end;

{ TdxGanttControlTaskBaselineUpdateDurationFormatCommand }

function TdxGanttControlTaskBaselineUpdateDurationFormatCommand.GetBaselineValue: Variant;
begin
  Result := Baseline.DurationFormat;
end;

function TdxGanttControlTaskBaselineUpdateDurationFormatCommand.GetSetValueHistoryItemClass: TdxGanttControlChangeTaskBaselinePropertyHistoryItemClass;
begin
  Result := TdxGanttControlChangeTaskBaselineDurationFormatHistoryItem;
end;

function TdxGanttControlTaskBaselineUpdateDurationFormatCommand.GetTaskValue: Variant;
begin
  Result := Task.DurationFormat;
end;

function TdxGanttControlTaskBaselineUpdateDurationFormatCommand.IsBaselineValueAssigned: Boolean;
begin
  Result := Baseline.IsValueAssigned(TdxGanttTaskBaselineAssignedValue.DurationFormat);
end;

function TdxGanttControlTaskBaselineUpdateDurationFormatCommand.IsTaskValueAssigned: Boolean;
begin
  Result := Task.IsValueAssigned(TdxGanttTaskAssignedValue.DurationFormat);
end;

procedure TdxGanttControlTaskBaselineUpdateDurationFormatCommand.ResetAssignedValue;
var
  AItem: TdxGanttControlTaskBaselineResetAssignedValueHistoryItem;
begin
  AItem := TdxGanttControlTaskBaselineResetAssignedValueHistoryItem.Create(Control.History, Baseline);
  AItem.FAssignedValue := TdxGanttTaskBaselineAssignedValue.DurationFormat;
  Control.History.AddItem(AItem);
  AItem.Execute;
end;

procedure TdxGanttControlTaskBaselineUpdateDurationFormatCommand.SetAssignedValue;
var
  AItem: TdxGanttControlTaskBaselineResetAssignedValueHistoryItem;
begin
  AItem := TdxGanttControlTaskBaselineResetAssignedValueHistoryItem.Create(Control.History, Baseline);
  AItem.FAssignedValue := TdxGanttTaskBaselineAssignedValue.DurationFormat;
  Control.History.AddItem(AItem);
  AItem.Execute;
end;

{ TdxGanttControlTaskBaselineUpdateEstimatedCommand }

function TdxGanttControlTaskBaselineUpdateEstimatedCommand.GetBaselineValue: Variant;
begin
  Result := Baseline.Estimated;
end;

function TdxGanttControlTaskBaselineUpdateEstimatedCommand.GetSetValueHistoryItemClass: TdxGanttControlChangeTaskBaselinePropertyHistoryItemClass;
begin
  Result := TdxGanttControlChangeTaskBaselineEstimatedHistoryItem;
end;

function TdxGanttControlTaskBaselineUpdateEstimatedCommand.GetTaskValue: Variant;
begin
  Result := Task.Estimated;
end;

function TdxGanttControlTaskBaselineUpdateEstimatedCommand.IsBaselineValueAssigned: Boolean;
begin
  Result := Baseline.IsValueAssigned(TdxGanttTaskBaselineAssignedValue.Estimated);
end;

function TdxGanttControlTaskBaselineUpdateEstimatedCommand.IsTaskValueAssigned: Boolean;
begin
  Result := Task.IsValueAssigned(TdxGanttTaskAssignedValue.Estimated);
end;

procedure TdxGanttControlTaskBaselineUpdateEstimatedCommand.ResetAssignedValue;
var
  AItem: TdxGanttControlTaskBaselineResetAssignedValueHistoryItem;
begin
  AItem := TdxGanttControlTaskBaselineResetAssignedValueHistoryItem.Create(Control.History, Baseline);
  AItem.FAssignedValue := TdxGanttTaskBaselineAssignedValue.Estimated;
  Control.History.AddItem(AItem);
  AItem.Execute;
end;

procedure TdxGanttControlTaskBaselineUpdateEstimatedCommand.SetAssignedValue;
var
  AItem: TdxGanttControlTaskBaselineResetAssignedValueHistoryItem;
begin
  AItem := TdxGanttControlTaskBaselineResetAssignedValueHistoryItem.Create(Control.History, Baseline);
  AItem.FAssignedValue := TdxGanttTaskBaselineAssignedValue.Estimated;
  Control.History.AddItem(AItem);
  AItem.Execute;
end;

{ TdxGanttControlTaskBaselineUpdateBudgetedCostOfWorkPerformedCommand }

function TdxGanttControlTaskBaselineUpdateBudgetedCostOfWorkPerformedCommand.GetBaselineValue: Variant;
begin
  Result := Baseline.BudgetedCostOfWorkPerformed;
end;

function TdxGanttControlTaskBaselineUpdateBudgetedCostOfWorkPerformedCommand.GetSetValueHistoryItemClass: TdxGanttControlChangeTaskBaselinePropertyHistoryItemClass;
begin
  Result := TdxGanttControlChangeTaskBaselineBudgetedCostOfWorkPerformedHistoryItem;
end;

function TdxGanttControlTaskBaselineUpdateBudgetedCostOfWorkPerformedCommand.GetTaskValue: Variant;
begin
  Result := Task.BudgetedCostOfWorkPerformed;
end;

function TdxGanttControlTaskBaselineUpdateBudgetedCostOfWorkPerformedCommand.IsBaselineValueAssigned: Boolean;
begin
  Result := Baseline.IsValueAssigned(TdxGanttBaselineAssignedValue.BudgetedCostOfWorkPerformed);
end;

function TdxGanttControlTaskBaselineUpdateBudgetedCostOfWorkPerformedCommand.IsTaskValueAssigned: Boolean;
begin
  Result := Task.IsValueAssigned(TdxGanttTaskAssignedValue.BudgetedCostOfWorkPerformed);
end;

procedure TdxGanttControlTaskBaselineUpdateBudgetedCostOfWorkPerformedCommand.ResetAssignedValue;
var
  AItem: TdxGanttControlBaselineResetAssignedValueHistoryItem;
begin
  AItem := TdxGanttControlBaselineResetAssignedValueHistoryItem.Create(Control.History, Baseline);
  AItem.FAssignedValue := TdxGanttBaselineAssignedValue.BudgetedCostOfWorkPerformed;
  Control.History.AddItem(AItem);
  AItem.Execute;
end;

procedure TdxGanttControlTaskBaselineUpdateBudgetedCostOfWorkPerformedCommand.SetAssignedValue;
var
  AItem: TdxGanttControlBaselineResetAssignedValueHistoryItem;
begin
  AItem := TdxGanttControlBaselineResetAssignedValueHistoryItem.Create(Control.History, Baseline);
  AItem.FAssignedValue := TdxGanttBaselineAssignedValue.BudgetedCostOfWorkPerformed;
  Control.History.AddItem(AItem);
  AItem.Execute;
end;

{ TdxGanttControlTaskBaselineUpdateBudgetedCostOfWorkScheduledCommand }

function TdxGanttControlTaskBaselineUpdateBudgetedCostOfWorkScheduledCommand.GetBaselineValue: Variant;
begin
  Result := Baseline.BudgetedCostOfWorkScheduled;
end;

function TdxGanttControlTaskBaselineUpdateBudgetedCostOfWorkScheduledCommand.GetSetValueHistoryItemClass: TdxGanttControlChangeTaskBaselinePropertyHistoryItemClass;
begin
  Result := TdxGanttControlChangeTaskBaselineBudgetedCostOfWorkScheduledHistoryItem;
end;

function TdxGanttControlTaskBaselineUpdateBudgetedCostOfWorkScheduledCommand.GetTaskValue: Variant;
begin
  Result := Task.BudgetedCostOfWorkScheduled;
end;

function TdxGanttControlTaskBaselineUpdateBudgetedCostOfWorkScheduledCommand.IsBaselineValueAssigned: Boolean;
begin
  Result := Baseline.IsValueAssigned(TdxGanttBaselineAssignedValue.BudgetedCostOfWorkScheduled);
end;

function TdxGanttControlTaskBaselineUpdateBudgetedCostOfWorkScheduledCommand.IsTaskValueAssigned: Boolean;
begin
  Result := Task.IsValueAssigned(TdxGanttTaskAssignedValue.BudgetedCostOfWorkScheduled);
end;

procedure TdxGanttControlTaskBaselineUpdateBudgetedCostOfWorkScheduledCommand.ResetAssignedValue;
var
  AItem: TdxGanttControlBaselineResetAssignedValueHistoryItem;
begin
  AItem := TdxGanttControlBaselineResetAssignedValueHistoryItem.Create(Control.History, Baseline);
  AItem.FAssignedValue := TdxGanttBaselineAssignedValue.BudgetedCostOfWorkScheduled;
  Control.History.AddItem(AItem);
  AItem.Execute;
end;

procedure TdxGanttControlTaskBaselineUpdateBudgetedCostOfWorkScheduledCommand.SetAssignedValue;
var
  AItem: TdxGanttControlBaselineResetAssignedValueHistoryItem;
begin
  AItem := TdxGanttControlBaselineResetAssignedValueHistoryItem.Create(Control.History, Baseline);
  AItem.FAssignedValue := TdxGanttBaselineAssignedValue.BudgetedCostOfWorkScheduled;
  Control.History.AddItem(AItem);
  AItem.Execute;
end;

{ TdxGanttControlTaskBaselineUpdateCostCommand }

function TdxGanttControlTaskBaselineUpdateCostCommand.GetBaselineValue: Variant;
begin
  Result := Baseline.Cost;
end;

function TdxGanttControlTaskBaselineUpdateCostCommand.GetSetValueHistoryItemClass: TdxGanttControlChangeTaskBaselinePropertyHistoryItemClass;
begin
  Result := TdxGanttControlChangeTaskBaselineCostHistoryItem;
end;

function TdxGanttControlTaskBaselineUpdateCostCommand.GetTaskValue: Variant;
begin
  Result := Task.Cost;
end;

function TdxGanttControlTaskBaselineUpdateCostCommand.IsBaselineValueAssigned: Boolean;
begin
  Result := Baseline.IsValueAssigned(TdxGanttBaselineAssignedValue.Cost);
end;

function TdxGanttControlTaskBaselineUpdateCostCommand.IsTaskValueAssigned: Boolean;
begin
  Result := Task.IsValueAssigned(TdxGanttTaskAssignedValue.Cost);
end;

procedure TdxGanttControlTaskBaselineUpdateCostCommand.ResetAssignedValue;
var
  AItem: TdxGanttControlBaselineResetAssignedValueHistoryItem;
begin
  AItem := TdxGanttControlBaselineResetAssignedValueHistoryItem.Create(Control.History, Baseline);
  AItem.FAssignedValue := TdxGanttBaselineAssignedValue.Cost;
  Control.History.AddItem(AItem);
  AItem.Execute;
end;

procedure TdxGanttControlTaskBaselineUpdateCostCommand.SetAssignedValue;
var
  AItem: TdxGanttControlBaselineResetAssignedValueHistoryItem;
begin
  AItem := TdxGanttControlBaselineResetAssignedValueHistoryItem.Create(Control.History, Baseline);
  AItem.FAssignedValue := TdxGanttBaselineAssignedValue.Cost;
  Control.History.AddItem(AItem);
  AItem.Execute;
end;

{ TdxGanttControlTaskCommandHelper }

class function TdxGanttControlTaskCommandHelper.GetOccurrences(ARecurringTask: TdxGanttControlTask): TList<TdxGanttControlTask>;
var
  I: Integer;
  ATasks: TdxGanttControlTasks;
begin
  Result := TList<TdxGanttControlTask>.Create;
  if not (ARecurringTask.Summary and ARecurringTask.Recurring) then
    Exit;
  ATasks := ARecurringTask.Owner;
  for I := ARecurringTask.ID + 1 to ATasks.Count - 1 do
  begin
    if ATasks[I].Blank then
      Continue;
    if ATasks[I].OutlineLevel = ARecurringTask.OutlineLevel then
      Break;
    if not ATasks[I].Recurring then
      Continue;
    if not ATasks[I].IsRecurrencePattern and (ATasks[I].OutlineLevel - 1 = ARecurringTask.OutlineLevel) then
      Result.Add(ATasks[I]);
  end;
end;

class function TdxGanttControlTaskCommandHelper.GetSubTasks(
  ASummary: TdxGanttControlTask; AIncludeBlanks,
  ARecursive: Boolean): TList<TdxGanttControlTask>;
begin
  Result := TdxTaskCalculator.GetSubTasks(ASummary, AIncludeBlanks, ARecursive);
end;

class function TdxGanttControlTaskCommandHelper.GetSummary(ATask: TdxGanttControlTask): TdxGanttControlTask;
begin
  Result := TdxTaskCalculator.GetSummary(ATask);
end;

{ TdxGanttControlOccurrencesCalculator }

constructor TdxGanttControlOccurrencesCalculator.Create(
  ARecurringTask: TdxGanttControlTask);
begin
  inherited Create;
  FRecurringTask := ARecurringTask;
  if RecurrencePattern.CalendarUID > -1 then
    FCalendar := TdxGanttControlDataModel(FRecurringTask.DataModel).Calendars.GetCalendarByUID(RecurrencePattern.CalendarUID);
  if FCalendar = nil then
    FCalendar := FRecurringTask.RealCalendar;
end;

function TdxGanttControlOccurrencesCalculator.GetNextDailyOccurrence(
  const APrevious: TDateTime; out ANext: TDateTime): Boolean;
var
  I: Integer;
  AIsFirst: Boolean;
begin
  AIsFirst := APrevious = MinDateTime;
  if AIsFirst then
    ANext := RecurrencePattern.Start
  else
    ANext := APrevious;
  if RecurrencePattern.DayType = TdxGanttControlRecurrenceDayType.Day then
  begin
    if not AIsFirst then
      ANext := IncDay(APrevious, RecurrencePattern.Interval)
  end
  else
  begin
    if not AIsFirst then
    begin
      I := RecurrencePattern.Interval;
      while I > 0 do
      begin
        ANext := IncDay(ANext, 1);
        if FCalendar.IsWorkday(ANext) then
          Dec(I);
      end;
    end
    else
      while not FCalendar.IsWorkday(ANext) do
        ANext := IncDay(ANext, 1);
  end;
  Result := (RecurrencePattern.FinishType = TdxGanttControlRecurrenceFinishType.Count) or (ANext <= RecurrencePattern.Finish);
end;

function TdxGanttControlOccurrencesCalculator.GetNextMonthlyOccurrence(
  const APrevious: TDateTime; out ANext: TDateTime): Boolean;
var
  AIsFirst: Boolean;
begin
  AIsFirst := APrevious = MinDateTime;
  if AIsFirst then
    ANext := StartOfTheMonth(RecurrencePattern.Start)
  else
    ANext := IncMonth(StartOfTheMonth(APrevious), RecurrencePattern.Interval);

  if RecurrencePattern.&Type = TdxGanttControlRecurrenceType.AbsoluteMonthly then
    ANext := Min(DateOf(EndOfTheMonth(ANext)), IncDay(ANext, RecurrencePattern.DayOfMonth - 1))
  else
  begin
    ANext := CalculateCertainDay(ANext);
    if ANext < DateOf(RecurrencePattern.Start) then
    begin
      ANext := IncMonth(StartOfTheMonth(ANext), 1);
      ANext := CalculateCertainDay(ANext);
    end;
  end;
  Result := (RecurrencePattern.FinishType = TdxGanttControlRecurrenceFinishType.Count) or (ANext <= RecurrencePattern.Finish);
end;

function TdxGanttControlOccurrencesCalculator.GetNextWeeklyOccurrence(
  const APrevious: TDateTime; out ANext: TDateTime): Boolean;
var
  AFirstWeekDate: TDateTime;
  ALastWeekDate: TDateTime;
  AIsFirst: Boolean;
  ADate: TDateTime;
begin
  AIsFirst := APrevious = MinDateTime;
  if AIsFirst then
  begin
    AFirstWeekDate := GetFirstDayOfWeek(RecurrencePattern.Start);
    ADate := RecurrencePattern.Start;
  end
  else
  begin
    AFirstWeekDate := GetFirstDayOfWeek(APrevious);
    ADate := APrevious + 1;
  end;
  ALastWeekDate := IncDay(AFirstWeekDate, 7);

  Result := False;

  while not Result do
  begin
    ANext := ADate;
    while ANext < ALastWeekDate do
    begin
      if dxDayOfWeek(ANext) in RecurrencePattern.Days then
      begin
        Result := True;
        Break;
      end;
      ANext := IncDay(ANext, 1);
    end;
    AFirstWeekDate := IncDay(AFirstWeekDate, 7 * RecurrencePattern.Interval);
    ALastWeekDate := IncDay(ALastWeekDate, 7 * RecurrencePattern.Interval);
    ADate := AFirstWeekDate;
  end;
  Result := (RecurrencePattern.FinishType = TdxGanttControlRecurrenceFinishType.Count) or (ANext <= RecurrencePattern.Finish);
end;

function TdxGanttControlOccurrencesCalculator.GetNextYearlyOccurrence(
  const APrevious: TDateTime; out ANext: TDateTime): Boolean;
var
  AIsFirst: Boolean;
  Y, M, D: Word;
begin
  AIsFirst := APrevious = MinDateTime;
  if AIsFirst then
    ANext := StartOfTheYear(RecurrencePattern.Start)
  else
    ANext := IncYear(StartOfTheYear(APrevious), 1);

  DecodeDate(ANext, Y, M, D);
  if RecurrencePattern.&Type = TdxGanttControlRecurrenceType.AbsoluteYearly then
  begin
    D := Min(RecurrencePattern.DayOfMonth, DaysPerMonth(Y, RecurrencePattern.Month));
    ANext := EncodeDate(Y, RecurrencePattern.Month, D);
  end
  else
  begin
    ANext := EncodeDate(Y, RecurrencePattern.Month, D);
    ANext := CalculateCertainDay(ANext);
    if ANext < DateOf(RecurrencePattern.Start) then
    begin
      ANext := EncodeDate(Y + 1, RecurrencePattern.Month, 1);
      ANext := CalculateCertainDay(ANext);
    end;
  end;
  Result := (RecurrencePattern.FinishType = TdxGanttControlRecurrenceFinishType.Count) or (ANext <= RecurrencePattern.Finish);
end;

class function TdxGanttControlOccurrencesCalculator.GetOccurrences(
  ARecurringTask: TdxGanttControlTask): TList<TDateTime>;
var
  ACalculator: TdxGanttControlOccurrencesCalculator;
begin
  Result := TList<TDateTime>.Create;
  if not ARecurringTask.IsRecurrencePattern then
    Exit;
  ACalculator := TdxGanttControlOccurrencesCalculator.Create(ARecurringTask);
  try
    ACalculator.PopulateOccurrences(Result);
  finally
    ACalculator.Free;
  end;
end;

function TdxGanttControlOccurrencesCalculator.GetDataModelProperties: TdxGanttControlDataModelProperties;
begin
  Result := TdxGanttControlDataModel(FRecurringTask.DataModel).Properties;
end;

function TdxGanttControlOccurrencesCalculator.GetFirstDayOfWeek(ADate: TDateTime): TDateTime;
begin
  Result := cxGetLocalCalendar.GetFirstDayOfWeek(ADate, DataModelProperties.WeekStartDay);
end;

function TdxGanttControlOccurrencesCalculator.GetRecurrencePattern: TdxGanttControlRecurrencePattern;
begin
  Result := FRecurringTask.RecurrencePattern;
end;

class function TdxGanttControlOccurrencesCalculator.GeDescription(
  ARecurringTask: TdxGanttControlTask): string;
var
  AList: TList<TDateTime>;
  AFrom, ATo: string;
begin
  Result := '';
  if not ARecurringTask.IsRecurrencePattern then
    Exit;
  Result := cxGetResourceString(@sdxGanttControlRecurringTaskHint);
  AList := GetOccurrences(ARecurringTask);
  try
    AFrom := DateTimeToStr(ARecurringTask.RecurrencePattern.Start);
    if ARecurringTask.RecurrencePattern.FinishType = TdxGanttControlRecurrenceFinishType.Date then
      ATo := DateTimeToStr(ARecurringTask.RecurrencePattern.Finish)
    else if AList.Count > 0 then
      ATo := DateTimeToStr(DateOf(AList.Last))
    else
      ATo := AFrom;
    Result := Format(Result, [AList.Count, AFrom, ATo]);
  finally
    AList.Free;
  end;
end;

function TdxGanttControlOccurrencesCalculator.CalculateCertainDay(ADate: TDateTime): TDateTime;
var
  AOffset: Integer;
begin
  AOffset := Ord(RecurrencePattern.DayType) - Ord(TdxGanttControlRecurrenceDayType.Sunday) - (DayOfWeek(StartOfTheMonth(ADate)) - 1);
  if AOffset < 0 then
    Inc(AOffset, 7);
  Inc(AOffset, Ord(RecurrencePattern.Index) * 7);
  if AOffset > DaysInMonth(ADate) - 1 then Dec(AOffset, 7);
  Result := ADate + AOffset;
end;

function TdxGanttControlOccurrencesCalculator.IsBreak(
  AList: TList<TDateTime>): Boolean;
begin
  if RecurrencePattern.FinishType = TdxGanttControlRecurrenceFinishType.Count then
    Result := AList.Count >= RecurrencePattern.Count
  else
    Result := (AList.Count > 0) and (AList.Last >= RecurrencePattern.Finish);
end;

function TdxGanttControlOccurrencesCalculator.IsValid: Boolean;
begin
  if RecurrencePattern.FinishType = TdxGanttControlRecurrenceFinishType.Count then
    Result := RecurrencePattern.Count > 0
  else
    Result := RecurrencePattern.Start <= RecurrencePattern.Finish;
  if not Result then
    Exit;
  case RecurrencePattern.&Type of
    TdxGanttControlRecurrenceType.Daily:
      Result := (RecurrencePattern.Interval > 0) and
        (RecurrencePattern.DayType in [TdxGanttControlRecurrenceDayType.Day, TdxGanttControlRecurrenceDayType.Workday]);
    TdxGanttControlRecurrenceType.Weekly:
      Result := (RecurrencePattern.Interval > 0) and (RecurrencePattern.Days <> []);
    TdxGanttControlRecurrenceType.AbsoluteMonthly:
      Result := (RecurrencePattern.DayOfMonth > 0) and (RecurrencePattern.Interval > 0) and (RecurrencePattern.DayType = TdxGanttControlRecurrenceDayType.Day);
    TdxGanttControlRecurrenceType.RelativeMonthly:
      Result := (RecurrencePattern.DayType >= TdxGanttControlRecurrenceDayType.Sunday) and
        (RecurrencePattern.Interval > 0);
    TdxGanttControlRecurrenceType.AbsoluteYearly:
      Result := (RecurrencePattern.DayOfMonth >= 1) and (RecurrencePattern.Month >= 1) and (RecurrencePattern.Month <= 12) and
        (RecurrencePattern.DayOfMonth <= MonthDays[True][RecurrencePattern.Month]) and (RecurrencePattern.DayType = TdxGanttControlRecurrenceDayType.Day);
    TdxGanttControlRecurrenceType.RelativeYearly:
      Result := (RecurrencePattern.DayType >= TdxGanttControlRecurrenceDayType.Sunday) and (RecurrencePattern.Month >= 1) and (RecurrencePattern.Month <= 12);
  end;
end;

procedure TdxGanttControlOccurrencesCalculator.PopulateOccurrences(
  AList: TList<TDateTime>);
var
  AProc: TGetNextDailyOccurrenceProc;
  APrevious: TDateTime;
begin
  if not IsValid then
    Exit;
  case RecurrencePattern.&Type of
    TdxGanttControlRecurrenceType.Daily: AProc := GetNextDailyOccurrence;
    TdxGanttControlRecurrenceType.Weekly: AProc := GetNextWeeklyOccurrence;
    TdxGanttControlRecurrenceType.AbsoluteMonthly,
    TdxGanttControlRecurrenceType.RelativeMonthly: AProc := GetNextMonthlyOccurrence;
    TdxGanttControlRecurrenceType.AbsoluteYearly,
    TdxGanttControlRecurrenceType.RelativeYearly: AProc := GetNextYearlyOccurrence;
  else
    AProc := nil;
  end;

  APrevious := MinDateTime;

  while not IsBreak(AList) and AProc(APrevious, APrevious) do
    AList.Add(APrevious);
end;

end.
