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

unit dxGanttControlCustomDataModel;

{$I cxVer.inc}
{$I dxGanttControl.inc}

interface

uses
  System.UITypes, System.Contnrs,
  Types, SysUtils, Classes, Generics.Defaults, Generics.Collections,
  dxCore, dxCoreClasses,
  dxGanttControlCustomClasses;

type
  TdxGanttControlModelElementList = class;
  TdxGanttControlCustomBaselines = class;
  TdxGanttControlModelUIDElementList = class;
  TdxGanttControlTimephasedDataItems = class;

  TDuration = string;

  TdxTimephasedDataType = (
    AssignmentRemainingWork = 1,
    AssignmentActualWork,
    AssignmentActualOvertimeWork,
    AssignmentBaselineWork,
    AssignmentBaselineCost,
    AssignmentActualCost,
    ResourceBaselineWork,
    ResourceBaselineCost,
    TaskBaselineWork,
    TaskBaselineCost,
    TaskPercentComplete,
    AssignmentBaseline1Work = 16,
    AssignmentBaseline1Cost,
    TaskBaseline1Work,
    TaskBaseline1Cost,
    ResourceBaseline1Work,
    ResourceBaseline1Cost,
    AssignmentBaseline2Work,
    AssignmentBaseline2Cost,
    TaskBaseline2Work,
    TaskBaseline2Cost,
    ResourceBaseline2Work,
    ResourceBaseline2Cost,
    AssignmentBaseline3Work,
    AssignmentBaseline3Cost,
    TaskBaseline3Work,
    TaskBaseline3Cost,
    ResourceBaseline3Work,
    ResourceBaseline3Cost,
    AssignmentBaseline4Work,
    AssignmentBaseline4Cost,
    TaskBaseline4Work,
    TaskBaseline4Cost,
    ResourceBaseline4Work,
    ResourceBaseline4Cost,
    AssignmentBaseline5Work,
    AssignmentBaseline5Cost,
    TaskBaseline5Work,
    TaskBaseline5Cost,
    ResourceBaseline5Work,
    ResourceBaseline5Cost,
    AssignmentBaseline6Work,
    AssignmentBaseline6Cost,
    TaskBaseline6Work,
    TaskBaseline6Cost,
    ResourceBaseline6Work,
    ResourceBaseline6Cost,
    AssignmentBaseline7Work,
    AssignmentBaseline7Cost,
    TaskBaseline7Work,
    TaskBaseline7Cost,
    ResourceBaseline7Work,
    ResourceBaseline7Cost,
    AssignmentBaseline8Work,
    AssignmentBaseline8Cost,
    TaskBaseline8Work,
    TaskBaseline8Cost,
    ResourceBaseline8Work,
    ResourceBaseline8Cost,
    AssignmentBaseline9Work,
    AssignmentBaseline9Cost,
    TaskBaseline9Work,
    TaskBaseline9Cost,
    ResourceBaseline9Work,
    ResourceBaseline9Cost,
    AssignmentBaseline10Work,
    AssignmentBaseline10Cost,
    TaskBaseline10Work,
    TaskBaseline10Cost,
    ResourceBaseline10Work,
    ResourceBaseline10Cost,
    PhysicalPercentComplete);

  TdxTimephasedDataUnit = (Minutes, Hours, Days, Weeks, Months, Years);

  TdxDurationFormat = (
    Minutes = 3, ElapsedMinutes,
    Hours, ElapsedHours,
    Days, ElapsedDays,
    Weeks, ElapsedWeeks,
    Months, ElapsedMonths,
    Percent = 19, ElapsedPercent, Null,
    EstimatedMinutes = 35, EstimatedElapsedMinutes,
    EstimatedHours, EstimatedElapsedHours,
    EstimatedDays, EstimatedElapsedDays,
    EstimatedWeeks, EstimatedElapsedWeeks,
    EstimatedMonths, EstimatedElapsedMonths,
    EstimatedPercent = 51, EstimatedElapsedPercent, EstimatedNull);

  TdxGanttControlBookingType = (Committed, Proposed);

  TdxGanttControlCostRateTable = (A, B, C, D, E);

  { TdxGanttControlCustomDataModel }

  TdxGanttControlCustomDataModel = class(TdxGanttControlPersistent);

  { TdxGanttControlModelElement }

  TdxGanttControlModelElement = class(TdxGanttControlPersistent)
  strict private
    FDataModel: TdxGanttControlCustomDataModel;
  public
    constructor Create(ADataModel: TdxGanttControlCustomDataModel); virtual;

    property DataModel: TdxGanttControlCustomDataModel read FDataModel;
  end;

  { TdxGanttControlModelOwnedElement }

  TdxGanttControlModelOwnedElement = class(TdxGanttControlModelElement)
  strict private
    FOwner: TdxGanttControlModelElement;
  protected
    procedure DoChanged; override;
    procedure ChangeOwner(AOwner: TdxGanttControlModelElement);
  public
    constructor Create(AOwner: TdxGanttControlModelElement); reintroduce; virtual;

    property Owner: TdxGanttControlModelElement read FOwner; // for internal use
  end;

  { TdxGanttControlModelElementListItem }

  TdxGanttControlModelElementListItem = class(TdxGanttControlModelOwnedElement)
  strict private
    FIndex: Integer;
    function InternalGetOwner: TdxGanttControlModelElementList; inline;
    procedure SetIndex(const Value: Integer);
  protected
    procedure DoChanged; override;
    procedure InternalSetIndex(const Value: Integer);

    property Index: Integer read FIndex write SetIndex;
  public
    constructor Create(AOwner: TdxGanttControlModelElement); override;
    property Owner: TdxGanttControlModelElementList read InternalGetOwner; // for internal use
  end;

  { TdxGanttControlModelElementList }

  TdxGanttControlModelElementList = class abstract(TdxGanttControlModelElement)
  public type
  {$REGION 'for internal use'}
    TListChangedEvent = procedure(Sender: TObject; const AItem: TdxGanttControlModelElementListItem;
      AAction: TCollectionNotification) of object;
    TListChangedHandlers  = TdxMulticastMethod<TListChangedEvent>;
  {$ENDREGION}
  strict private
    FList: TdxFastObjectList;

    FListChangedHandlers: TListChangedHandlers;

    procedure ListChangedHandler(Sender: TObject; const Item: TdxGanttControlModelElementListItem;
      Action: TCollectionNotification);

    function GetCount: Integer; inline;
    function GetItem(Index: Integer): TdxGanttControlModelElementListItem; inline;
    procedure UpdateIndexes(AStart, AFinish: Integer);
  protected
    procedure DoAssign(Source: TPersistent); override;
    procedure DoChanged; override;
    procedure DoInternalAdd(AItem: TdxGanttControlModelElementListItem); virtual;
    procedure DoItemChanged(AItem: TdxGanttControlModelElementListItem); virtual;
    procedure DoListChanged(const AItem: TdxGanttControlModelElementListItem; AAction: TCollectionNotification); virtual;
    procedure DoReset; override;
    procedure ItemChanged(AItem: TdxGanttControlModelElementListItem);

    function CreateItem: TdxGanttControlModelElementListItem; virtual; abstract;
    procedure InternalAdd(AItem: TdxGanttControlModelElementListItem); virtual;
    procedure InternalClear; virtual;
    procedure InternalExtract(AItem: TdxGanttControlModelElementListItem); virtual;
    procedure InternalInsert(AIndex: Integer; AItem: TdxGanttControlModelElementListItem); virtual;
    procedure InternalMove(AItem: TdxGanttControlModelElementListItem; ANewIndex: Integer); virtual;
    procedure InternalRemove(AItem: TdxGanttControlModelElementListItem); virtual;
    procedure InternalSort(ACompare: TListSortCompare);
  public
    constructor Create(ADataModel: TdxGanttControlCustomDataModel); override;
    destructor Destroy; override;
    function IndexOf(AItem: TdxGanttControlModelElementListItem): Integer;

    property Count: Integer read GetCount;
    property Items[Index: Integer]: TdxGanttControlModelElementListItem read GetItem; default;
  {$REGION 'for internal use'}
    property ListChangedHandlers: TListChangedHandlers read FListChangedHandlers;
  {$ENDREGION}
  end;

  { TdxGanttControlElementCustomOwnedList }

  TdxGanttControlElementCustomOwnedList = class abstract(TdxGanttControlModelElementList)
  strict private
    FOwner: TdxGanttControlModelElement;
  protected
    procedure DoItemChanged(AItem: TdxGanttControlModelElementListItem); override;
  public
    constructor Create(AOwner: TdxGanttControlModelElement); reintroduce; virtual;

    property Owner: TdxGanttControlModelElement read FOwner; // for internal use
  end;

  { TdxGanttControlModelUIDElement }

  TdxGanttControlModelUIDElement = class abstract(TdxGanttControlModelElementListItem)
  strict private
    FUID: Integer;
    function InternalGetOwner: TdxGanttControlModelUIDElementList; inline;
  protected
    procedure DoAssign(Source: TPersistent); override;
    procedure DoReset; override;
    procedure SetUID(const Value: Integer); virtual;
  public
    constructor Create(AOwner: TdxGanttControlModelElement); override;
    function GetHashCode: Integer; override;

    property Owner: TdxGanttControlModelUIDElementList read InternalGetOwner; // for internal use
    property UID: Integer read FUID;
  end;

  { TdxGanttControlModelUIDElementList }

  TdxGanttControlModelUIDElementList = class abstract(TdxGanttControlModelElementList)
  strict private
    FAutogeneratedUID: Integer;
    FDictionary: TDictionary<Integer, TdxGanttControlModelUIDElement>;
    function GetItem(Index: Integer): TdxGanttControlModelUIDElement; inline;
  protected
    procedure DoAssign(Source: TPersistent); override;
    procedure DoInternalAdd(AItem: TdxGanttControlModelElementListItem); override;
    procedure DoReset; override;
    procedure InternalClear; override;
    procedure InternalInsert(AIndex: Integer; AItem: TdxGanttControlModelElementListItem); override;

    function GetAutogeneratedUIDBaseValue: Integer; virtual;
    function GetNextAutogeneratedUID: Integer;
    procedure ResetAutogeneratedUID;
    procedure UpdateAutogeneratedUID(const Value: Integer);
    property Dictionary: TDictionary<Integer, TdxGanttControlModelUIDElement> read FDictionary;
  public
    constructor Create(ADataModel: TdxGanttControlCustomDataModel); override;
    destructor Destroy; override;

    function GetItemByUID(const AUID: Integer): TdxGanttControlModelUIDElement;

    property Items[Index: Integer]: TdxGanttControlModelUIDElement read GetItem; default;
  end;

  { TdxGanttControlTimePeriod }

  TdxGanttControlTimePeriod = class(TdxGanttControlModelOwnedElement)
  strict private
    FFromDate: TDateTime;
    FToDate: TDateTime;
    procedure SetFromDate(const Value: TDateTime);
    procedure SetToDate(const Value: TDateTime);
  protected
    procedure DoAssign(Source: TPersistent); override;
    procedure DoReset; override;
  public
    property FromDate: TDateTime read FFromDate write SetFromDate;
    property ToDate: TDateTime read FToDate write SetToDate;
  end;

  { TdxGanttControlCustomBaseline }

  TdxGanttControlCustomBaseline = class abstract(TdxGanttControlModelElementListItem)
  strict private
    FNumber: Integer;
    function InternalGetOwner: TdxGanttControlCustomBaselines; inline;
  protected
    procedure DoAssign(Source: TPersistent); override;
    procedure DoAssignCurrentValues(Source: TPersistent); virtual;
    procedure DoDelete; virtual;
    procedure DoReset; override;
    procedure SetNumber(const Value: Integer);
  public
    procedure AssignCurrentValues;

    property Number: Integer read FNumber;
    property Owner: TdxGanttControlCustomBaselines read InternalGetOwner;
  end;

  { TdxGanttControlElementBaseline }

  TdxGanttBaselineAssignedValue = (BudgetedCostOfWorkPerformed, BudgetedCostOfWorkScheduled, Cost, Work);
  TdxGanttBaselineAssignedValues = set of TdxGanttBaselineAssignedValue;

  TdxGanttControlElementBaseline = class(TdxGanttControlCustomBaseline)
  strict private
    FAssignedValues: TdxGanttBaselineAssignedValues;
    FBudgetedCostOfWorkPerformed: Double;
    FBudgetedCostOfWorkScheduled: Double;
    FCost: Double;
    FWork: string;
    procedure SetBudgetedCostOfWorkPerformed(const Value: Double);
    procedure SetBudgetedCostOfWorkScheduled(const Value: Double);
    procedure SetCost(const Value: Double);
    procedure SetWork(const Value: string);
  protected
    procedure DoAssign(Source: TPersistent); override;
    procedure DoReset; override;
  public
  {$REGION 'for internal use'}
    function IsValueAssigned(const AValue: TdxGanttBaselineAssignedValue): Boolean; overload;
    procedure ResetValue(const AValue: TdxGanttBaselineAssignedValue); overload;

    property Work: string read FWork write SetWork;
  {$ENDREGION 'for internal use'}
    property BudgetedCostOfWorkPerformed: Double read FBudgetedCostOfWorkPerformed write SetBudgetedCostOfWorkPerformed;
    property BudgetedCostOfWorkScheduled: Double read FBudgetedCostOfWorkScheduled write SetBudgetedCostOfWorkScheduled;
    property Cost: Double read FCost write SetCost;
  end;

  { TdxGanttControlCustomBaselines }

  TdxGanttControlCustomBaselines = class abstract(TdxGanttControlModelElementList)
  strict private
    FOwner: TdxGanttControlPersistent;
    FCurrentNumber: Integer;
    function GetItem(Index: Integer): TdxGanttControlCustomBaseline; inline;
  protected
    function CalculateIndex(ANumber: Integer): Integer;
    procedure DoInternalAdd(AItem: TdxGanttControlModelElementListItem); override;
    procedure DoItemChanged(AItem: TdxGanttControlModelElementListItem); override;
    procedure Sort;
    property Owner: TdxGanttControlPersistent read FOwner;
  public
    constructor Create(ADataModel: TdxGanttControlCustomDataModel; AOwner: TdxGanttControlPersistent); reintroduce; overload;
    constructor Create(AOwner: TdxGanttControlModelElement); reintroduce; overload;

    function Append: TdxGanttControlCustomBaseline; // for internal use

    procedure Clear;
    procedure Remove(AItem: TdxGanttControlCustomBaseline);

    function Add(const ANumber: Integer): TdxGanttControlCustomBaseline;
    procedure AssignCurrentValues(const ANumber: Integer);
    procedure Delete(const ANumber: Integer);
    function Find(const ANumber: Integer): TdxGanttControlCustomBaseline;

    property Items[Index: Integer]: TdxGanttControlCustomBaseline read GetItem; default;
  end;

  { TdxGanttControlTimephasedDataItem }

  TdxGanttTimephasedDataAssignedValue = (Start, Finish, Value, &Type, &Unit);
  TdxGanttTimephasedDataAssignedValues = set of TdxGanttTimephasedDataAssignedValue;

  TdxGanttControlTimephasedDataItem = class(TdxGanttControlModelElementListItem)
  strict private
    FAssignedValues: TdxGanttTimephasedDataAssignedValues;
    FType: TdxTimephasedDataType;
    FStart: TDateTime;
    FFinish: TDateTime;
    FUnit: TdxTimephasedDataUnit;
    FValue: string;
    function InternalGetOwner: TdxGanttControlTimephasedDataItems; inline;
    function GetOwnerUID: Integer; inline;
    procedure SetFinish(const AValue: TDateTime);
    procedure SetStart(const AValue: TDateTime);
    procedure SetType(const AValue: TdxTimephasedDataType);
    procedure SetUnit(const AValue: TdxTimephasedDataUnit);
    procedure SetValue(const AValue: string);
  protected
    procedure DoAssign(Source: TPersistent); override;
    procedure DoReset; override;
  public
  {$REGION 'for internal use'}
    function IsValueAssigned(const AValue: TdxGanttTimephasedDataAssignedValue): Boolean;
    procedure ResetValue(const AValue: TdxGanttTimephasedDataAssignedValue); overload;
  {$ENDREGION 'for internal use'}

    property Owner: TdxGanttControlTimephasedDataItems read InternalGetOwner; // for internal use
    property OwnerUID: Integer read GetOwnerUID;

    property &Type: TdxTimephasedDataType read FType write SetType;
    property Start: TDateTime read FStart write SetStart;
    property Finish: TDateTime read FFinish write SetFinish;
    property &Unit: TdxTimephasedDataUnit read FUnit write SetUnit;
    property Value: string read FValue write SetValue;
  end;

  { TdxGanttControlTimephasedDataItems }

  TdxGanttControlTimephasedDataItems = class(TdxGanttControlElementCustomOwnedList)
  strict private
    function GetItem(Index: Integer): TdxGanttControlTimephasedDataItem; inline;
    function InternalGetOwner: TdxGanttControlModelUIDElement; inline;
  protected
    function CreateItem: TdxGanttControlModelElementListItem; override;
    property Owner: TdxGanttControlModelUIDElement read InternalGetOwner;
  public
    function Append: TdxGanttControlTimephasedDataItem;
    procedure Clear;
    procedure Remove(AItem: TdxGanttControlTimephasedDataItem);

    property Items[Index: Integer]: TdxGanttControlTimephasedDataItem read GetItem; default;
  end;

  { TdxGanttControlEnterpriseExtendedAttributeValue }

  TdxGanttEnterpriseExtendedAttributeAssignedValue = (Description, Phonetic, Value);
  TdxGanttEnterpriseExtendedAttributeAssignedValues = set of TdxGanttEnterpriseExtendedAttributeAssignedValue;

  TdxGanttControlEnterpriseExtendedAttributeValue = class(TdxGanttControlModelOwnedElement)
  strict private
    FAssignedValues: TdxGanttEnterpriseExtendedAttributeAssignedValues;
    FID: Integer;
    FValue: string;
    FDescription: string;
    FPhonetic: string;
    procedure SetDescription(const Value: string);
    procedure SetID(const Value: Integer);
    procedure SetPhonetic(const Value: string);
    procedure SetValue(const AValue: string);
  protected
    procedure DoAssign(Source: TPersistent); override;
    procedure DoReset; override;
  public
  {$REGION 'for internal use'}
    function IsValueAssigned(const AValue: TdxGanttEnterpriseExtendedAttributeAssignedValue): Boolean;
    procedure ResetValue(const AValue: TdxGanttEnterpriseExtendedAttributeAssignedValue); overload;
  {$ENDREGION 'for internal use'}

    property ID: Integer read FID write SetID;
    property Value: string read FValue write SetValue;
    property Description: string read FDescription write SetDescription;
    property Phonetic: string read FPhonetic write SetPhonetic;
  end;

  { TdxGanttControlEnterpriseExtendedAttribute }

  TdxGanttControlEnterpriseExtendedAttribute = class abstract(TdxGanttControlModelElementListItem)
  strict private
    FFieldIDInHex: string;
    FFieldID: Integer;
    FValue: TdxGanttControlEnterpriseExtendedAttributeValue;
    FFieldValueGUID: string;
  private
    procedure SetFieldID(const Value: Integer);
    procedure SetFieldIDInHex(const Value: string);
    procedure SetFieldValueGUID(const Value: string);
    procedure SetValue(const AValue: TdxGanttControlEnterpriseExtendedAttributeValue);
  protected
    procedure DoAssign(Source: TPersistent); override;
    procedure DoReset; override;
  public
    constructor Create(AOwner: TdxGanttControlModelElement); override;
    destructor Destroy; override;

    property FieldIDInHex: string read FFieldIDInHex write SetFieldIDInHex;
    property FieldID: Integer read FFieldID write SetFieldID;
    property Value: TdxGanttControlEnterpriseExtendedAttributeValue read FValue write SetValue;
    property FieldValueGUID: string read FFieldValueGUID write SetFieldValueGUID;
  end;

  { TdxGanttControlEnterpriseExtendedAttributes }

  TdxGanttControlEnterpriseExtendedAttributes = class(TdxGanttControlElementCustomOwnedList)
  strict private
    function GetItem(Index: Integer): TdxGanttControlEnterpriseExtendedAttribute; inline;
  protected
    function CreateItem: TdxGanttControlModelElementListItem; override;
  public
    function Append: TdxGanttControlEnterpriseExtendedAttribute;
    procedure Clear;
    procedure Remove(AItem: TdxGanttControlEnterpriseExtendedAttribute);

    property Items[Index: Integer]: TdxGanttControlEnterpriseExtendedAttribute read GetItem; default;
  end;

implementation

uses
  Math, RTLConsts;

const
  dxThisUnitName = 'dxGanttControlCustomDataModel';

type
  TdxGanttControlPersistentAccess = class(TdxGanttControlPersistent);

function dxGanttControlCompareBaselines(Item1, Item2: Pointer): Integer;
var
  ABaseline1: TdxGanttControlCustomBaseline absolute Item1;
  ABaseline2: TdxGanttControlCustomBaseline absolute Item2;
begin
  Result := ABaseline1.Number - ABaseline2.Number;
end;

{ TdxGanttControlModelElement }

constructor TdxGanttControlModelElement.Create(
  ADataModel: TdxGanttControlCustomDataModel);
begin
  inherited Create;
  FDataModel := ADataModel;
end;

{ TdxGanttControlModelElementListItem }

procedure TdxGanttControlModelElementListItem.SetIndex(const Value: Integer);
begin
  if Index <> Value then
  begin
    Owner.InternalMove(Self, Value);
    Changed;
  end;
end;

constructor TdxGanttControlModelElementListItem.Create(
  AOwner: TdxGanttControlModelElement);
begin
  inherited Create(AOwner);
  FIndex := -1;
end;

procedure TdxGanttControlModelElementListItem.DoChanged;
begin
  Owner.ItemChanged(Self);
end;

procedure TdxGanttControlModelElementListItem.InternalSetIndex(const Value: Integer);
begin
  FIndex := Value;
end;

function TdxGanttControlModelElementListItem.InternalGetOwner: TdxGanttControlModelElementList;
begin
  Result := TdxGanttControlModelElementList(inherited Owner);
end;

{ TdxGanttControlModelElementList }

constructor TdxGanttControlModelElementList.Create(
  ADataModel: TdxGanttControlCustomDataModel);
begin
  inherited Create(ADataModel);
  FList := TdxFastObjectList.Create;
end;

destructor TdxGanttControlModelElementList.Destroy;
begin
  FreeAndNil(FList);
  inherited Destroy;
end;

procedure TdxGanttControlModelElementList.DoAssign(
  Source: TPersistent);
var
  ASource: TdxGanttControlModelElementList;
  I: Integer;
  AItem: TdxGanttControlModelElementListItem;
begin
  if Safe.Cast(Source, TdxGanttControlModelElementList, ASource) then
  begin
    InternalClear;
    for I := 0 to ASource.Count - 1 do
    begin
      AItem := CreateItem;
      InternalAdd(AItem);
      AItem.Assign(ASource[I]);
    end;
  end;
  inherited DoAssign(Source);
end;

procedure TdxGanttControlModelElementList.ListChangedHandler(
  Sender: TObject; const Item: TdxGanttControlModelElementListItem;
  Action: TCollectionNotification);
begin
  DoListChanged(Item, Action);
  DoItemChanged(Item);
end;

function TdxGanttControlModelElementList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TdxGanttControlModelElementList.GetItem(
  Index: Integer): TdxGanttControlModelElementListItem;
begin
  Result := TdxGanttControlModelElementListItem(FList[Index]);
end;

procedure TdxGanttControlModelElementList.UpdateIndexes(AStart, AFinish: Integer);
var
  I: Integer;
begin
  AStart := Max(0, AStart);
  AFinish := Min(AFinish, Count - 1);
  for I := AStart to AFinish do
    Items[I].InternalSetIndex(I);
end;

procedure TdxGanttControlModelElementList.DoChanged;
begin
  DoItemChanged(nil);
end;

procedure TdxGanttControlModelElementList.DoInternalAdd(AItem: TdxGanttControlModelElementListItem);
begin
  ListChangedHandler(Self, AItem, cnAdded);
end;

procedure TdxGanttControlModelElementList.DoItemChanged(AItem: TdxGanttControlModelElementListItem);
begin
// do nothing
end;

procedure TdxGanttControlModelElementList.DoListChanged(const AItem: TdxGanttControlModelElementListItem; AAction: TCollectionNotification);
begin
  if not FListChangedHandlers.Empty then
    FListChangedHandlers.Invoke(Self, AItem, AAction);
end;

procedure TdxGanttControlModelElementList.DoReset;
begin
  InternalClear;
end;

procedure TdxGanttControlModelElementList.ItemChanged(
  AItem: TdxGanttControlModelElementListItem);
begin
  if IsUpdateLocked then
    Exit;
  DoItemChanged(AItem);
end;

procedure TdxGanttControlModelElementList.InternalAdd(
  AItem: TdxGanttControlModelElementListItem);
begin
  FList.Add(AItem);
  AItem.ChangeOwner(Self);
  AItem.InternalSetIndex(Count - 1);
  DoInternalAdd(AItem);
end;

procedure TdxGanttControlModelElementList.InternalClear;
begin
  FList.Clear;
end;

procedure TdxGanttControlModelElementList.InternalExtract(
  AItem: TdxGanttControlModelElementListItem);
begin
  FList.Extract(AItem);
  UpdateIndexes(AItem.Index, Count);
  ListChangedHandler(Self, AItem, cnExtracted);
end;

procedure TdxGanttControlModelElementList.InternalInsert(
  AIndex: Integer; AItem: TdxGanttControlModelElementListItem);
begin
  FList.Insert(AIndex, AItem);
  AItem.ChangeOwner(Self);
  UpdateIndexes(AItem.Index, Count);
  ListChangedHandler(Self, AItem, cnAdded);
end;

function TdxGanttControlModelElementList.IndexOf(
  AItem: TdxGanttControlModelElementListItem): Integer;
begin
  Result := FList.IndexOf(AItem);
end;

procedure TdxGanttControlModelElementList.InternalMove(
  AItem: TdxGanttControlModelElementListItem; ANewIndex: Integer);
begin
  FList.Move(AItem.Index, ANewIndex);
  if ANewIndex < AItem.Index then
    UpdateIndexes(ANewIndex, AItem.Index)
  else
    UpdateIndexes(AItem.Index, ANewIndex);
  DoItemChanged(AItem);
end;

procedure TdxGanttControlModelElementList.InternalRemove(
  AItem: TdxGanttControlModelElementListItem);
begin
  FList.Remove(AItem);
  ListChangedHandler(Self, AItem, cnRemoved);
  UpdateIndexes(AItem.Index, Count);
end;

procedure TdxGanttControlModelElementList.InternalSort(ACompare: TListSortCompare);
begin
  FList.Sort(ACompare, True);
  UpdateIndexes(0, Count);
end;

{ TdxGanttControlElementCustomOwnedList }

constructor TdxGanttControlElementCustomOwnedList.Create(
  AOwner: TdxGanttControlModelElement);
begin
  inherited Create(AOwner.DataModel);
  FOwner := AOwner;
end;

procedure TdxGanttControlElementCustomOwnedList.DoItemChanged(
  AItem: TdxGanttControlModelElementListItem);
begin
  Owner.Changed;
end;

{ TdxGanttControlModelUIDElement }

constructor TdxGanttControlModelUIDElement.Create(AOwner: TdxGanttControlModelElement);
begin
  inherited Create(AOwner);
  FUID := -1;
end;

procedure TdxGanttControlModelUIDElement.DoAssign(
  Source: TPersistent);
begin
  if Source is TdxGanttControlModelUIDElement then
    SetUID(TdxGanttControlModelUIDElement(Source).UID);
  inherited DoAssign(Source);
end;

procedure TdxGanttControlModelUIDElement.DoReset;
begin
  Owner.UpdateAutogeneratedUID(FUID);
end;

function TdxGanttControlModelUIDElement.GetHashCode: Integer;
begin
  Result := FUID;
end;

function TdxGanttControlModelUIDElement.InternalGetOwner: TdxGanttControlModelUIDElementList;
begin
  Result := TdxGanttControlModelUIDElementList(inherited Owner);
end;

procedure TdxGanttControlModelUIDElement.SetUID(
  const Value: Integer);
begin
  if FUID <> Value then
  begin
    Owner.Dictionary.Remove(FUID);
    FUID := Value;
    if not Owner.Dictionary.ContainsKey(FUID) then
      Owner.Dictionary.Add(FUID, Self);
    Owner.UpdateAutogeneratedUID(Value);
    Changed;
  end;
end;

{ TdxGanttControlModelUIDElementList }

constructor TdxGanttControlModelUIDElementList.Create(ADataModel: TdxGanttControlCustomDataModel);
begin
  inherited Create(ADataModel);
  FDictionary := TDictionary<Integer, TdxGanttControlModelUIDElement>.Create;
end;

destructor TdxGanttControlModelUIDElementList.Destroy;
begin
  FreeAndNil(FDictionary);
  inherited Destroy;
end;

procedure TdxGanttControlModelUIDElementList.DoAssign(
  Source: TPersistent);
begin
  if Source is TdxGanttControlModelUIDElementList then
    ResetAutogeneratedUID;
  inherited DoAssign(Source);
end;

procedure TdxGanttControlModelUIDElementList.DoReset;
begin
  FDictionary.Clear;
  ResetAutogeneratedUID;
  inherited DoReset;
end;

function TdxGanttControlModelUIDElementList.GetItemByUID(
  const AUID: Integer): TdxGanttControlModelUIDElement;
begin
  if not FDictionary.TryGetValue(AUID, Result) then
    Result := nil;
end;

function TdxGanttControlModelUIDElementList.GetAutogeneratedUIDBaseValue: Integer;
begin
  Result := 0;
end;

function TdxGanttControlModelUIDElementList.GetNextAutogeneratedUID: Integer;
begin
  Inc(FAutogeneratedUID);
  Result := FAutogeneratedUID;
end;

procedure TdxGanttControlModelUIDElementList.DoInternalAdd(
  AItem: TdxGanttControlModelElementListItem);
begin
  if TdxGanttControlModelUIDElement(AItem).UID = -1 then
    TdxGanttControlModelUIDElement(AItem).SetUID(GetNextAutogeneratedUID);
  inherited DoInternalAdd(AItem);
end;

procedure TdxGanttControlModelUIDElementList.InternalClear;
begin
  inherited InternalClear;
  FDictionary.Clear;
end;

procedure TdxGanttControlModelUIDElementList.InternalInsert(AIndex: Integer;
  AItem: TdxGanttControlModelElementListItem);
begin
  inherited InternalInsert(AIndex, AItem);
  if TdxGanttControlModelUIDElement(AItem).UID = -1 then
    TdxGanttControlModelUIDElement(AItem).SetUID(GetNextAutogeneratedUID);
end;

procedure TdxGanttControlModelUIDElementList.ResetAutogeneratedUID;
begin
  FAutogeneratedUID := GetAutogeneratedUIDBaseValue;
end;

procedure TdxGanttControlModelUIDElementList.UpdateAutogeneratedUID(
  const Value: Integer);
begin
  FAutogeneratedUID := Max(FAutogeneratedUID, Value);
end;

function TdxGanttControlModelUIDElementList.GetItem(Index: Integer): TdxGanttControlModelUIDElement;
begin
  Result := TdxGanttControlModelUIDElement(inherited Items[Index]);
end;

{ TdxGanttControlModelOwnedElement }

constructor TdxGanttControlModelOwnedElement.Create(
  AOwner: TdxGanttControlModelElement);
begin
  inherited Create(AOwner.DataModel);
  FOwner := AOwner;
end;

procedure TdxGanttControlModelOwnedElement.DoChanged;
begin
  Owner.Changed;
end;

procedure TdxGanttControlModelOwnedElement.ChangeOwner(AOwner: TdxGanttControlModelElement);
begin
  FOwner := AOwner;
end;

{ TdxGanttControlTimePeriod }

procedure TdxGanttControlTimePeriod.DoAssign(Source: TPersistent);
var
  ASource: TdxGanttControlTimePeriod;
begin
  if Safe.Cast(Source, TdxGanttControlTimePeriod, ASource) then
  begin
    FromDate := ASource.FromDate;
    ToDate := ASource.ToDate;
  end;
  inherited DoAssign(Source);
end;

procedure TdxGanttControlTimePeriod.DoReset;
begin
  FFromDate := 0;
  FToDate := 0;
end;

procedure TdxGanttControlTimePeriod.SetFromDate(const Value: TDateTime);
begin
  if FromDate <> Value then
  begin
    FFromDate := Value;
    Changed;
  end;
end;

procedure TdxGanttControlTimePeriod.SetToDate(const Value: TDateTime);
begin
  if ToDate <> Value then
  begin
    FToDate := Value;
    Changed;
  end;
end;

{ TdxGanttControlCustomBaseline }

procedure TdxGanttControlCustomBaseline.DoAssign(Source: TPersistent);
begin
  if Source is TdxGanttControlCustomBaseline then
    FNumber := TdxGanttControlCustomBaseline(Source).Number;
  inherited DoAssign(Source);
end;

procedure TdxGanttControlCustomBaseline.DoAssignCurrentValues(Source: TPersistent);
begin
// do nothing
end;

procedure TdxGanttControlCustomBaseline.DoDelete;
begin
// do nothing
end;

procedure TdxGanttControlCustomBaseline.DoReset;
begin
  FNumber := -1;
end;

function TdxGanttControlCustomBaseline.InternalGetOwner: TdxGanttControlCustomBaselines;
begin
  Result := TdxGanttControlCustomBaselines(inherited Owner);
end;

procedure TdxGanttControlCustomBaseline.SetNumber(const Value: Integer);
begin
  FNumber := Value;
end;

procedure TdxGanttControlCustomBaseline.AssignCurrentValues;
begin
  BeginUpdate;
  try
    DoAssignCurrentValues(Owner.Owner);
  finally
    EndUpdate;
  end;
end;

{ TdxGanttControlElementBaseline }

procedure TdxGanttControlElementBaseline.DoAssign(Source: TPersistent);
var
  ASource: TdxGanttControlElementBaseline;
begin
  if Safe.Cast(Source, TdxGanttControlElementBaseline, ASource) then
  begin
    BudgetedCostOfWorkPerformed := ASource.BudgetedCostOfWorkPerformed;
    BudgetedCostOfWorkScheduled := ASource.BudgetedCostOfWorkScheduled;
    Cost := ASource.Cost;
    Work := ASource.Work;
    FAssignedValues := ASource.FAssignedValues;
  end;
  inherited DoAssign(Source);
end;

procedure TdxGanttControlElementBaseline.DoReset;
begin
  inherited DoReset;
  FAssignedValues := [];
end;

function TdxGanttControlElementBaseline.IsValueAssigned(
  const AValue: TdxGanttBaselineAssignedValue): Boolean;
begin
  Result := AValue in FAssignedValues;
end;

procedure TdxGanttControlElementBaseline.ResetValue(
  const AValue: TdxGanttBaselineAssignedValue);
begin
  if IsValueAssigned(AValue) then
  begin
    Exclude(FAssignedValues, AValue);
    Changed;
  end
end;

procedure TdxGanttControlElementBaseline.SetBudgetedCostOfWorkPerformed(const Value: Double);
begin
  if (BudgetedCostOfWorkPerformed <> Value) or not IsValueAssigned(TdxGanttBaselineAssignedValue.BudgetedCostOfWorkPerformed) then
  begin
    Include(FAssignedValues, TdxGanttBaselineAssignedValue.BudgetedCostOfWorkPerformed);
    FBudgetedCostOfWorkPerformed := Value;
    Changed;
  end;
end;

procedure TdxGanttControlElementBaseline.SetBudgetedCostOfWorkScheduled(const Value: Double);
begin
  if (BudgetedCostOfWorkScheduled <> Value) or not IsValueAssigned(TdxGanttBaselineAssignedValue.BudgetedCostOfWorkScheduled) then
  begin
    Include(FAssignedValues, TdxGanttBaselineAssignedValue.BudgetedCostOfWorkScheduled);
    FBudgetedCostOfWorkScheduled := Value;
    Changed;
  end;
end;

procedure TdxGanttControlElementBaseline.SetCost(const Value: Double);
begin
  if (Cost <> Value) or not IsValueAssigned(TdxGanttBaselineAssignedValue.Cost) then
  begin
    Include(FAssignedValues, TdxGanttBaselineAssignedValue.Cost);
    FCost := Value;
    Changed;
  end;
end;

procedure TdxGanttControlElementBaseline.SetWork(const Value: string);
begin
 if (Work <> Value) or not IsValueAssigned(TdxGanttBaselineAssignedValue.Work) then
  begin
    Include(FAssignedValues, TdxGanttBaselineAssignedValue.Work);
    FWork := Value;
    Changed;
  end;
end;

{ TdxGanttControlCustomBaselines }

constructor TdxGanttControlCustomBaselines.Create(ADataModel: TdxGanttControlCustomDataModel; AOwner: TdxGanttControlPersistent);
begin
  inherited Create(ADataModel);
  FOwner := AOwner;
end;

constructor TdxGanttControlCustomBaselines.Create(AOwner: TdxGanttControlModelElement);
begin
  Create(AOwner.DataModel, AOwner)
end;

function TdxGanttControlCustomBaselines.Append: TdxGanttControlCustomBaseline;
begin
  Result := TdxGanttControlCustomBaseline(CreateItem);
  InternalAdd(Result);
end;

procedure TdxGanttControlCustomBaselines.Clear;
begin
  InternalClear;
end;

function TdxGanttControlCustomBaselines.CalculateIndex(ANumber: Integer): Integer;
begin
  for Result := 0 to Count - 1 do
    if Items[Result].Number > ANumber then
      Exit;
  Result := Count;
end;

procedure TdxGanttControlCustomBaselines.DoInternalAdd(
  AItem: TdxGanttControlModelElementListItem);
var
  ABaseline: TdxGanttControlCustomBaseline absolute AItem;
begin
  if ABaseline.Number = -1 then
  begin
    ABaseline.SetNumber(FCurrentNumber);
    Sort;
  end;
  inherited DoInternalAdd(AItem);
end;

procedure TdxGanttControlCustomBaselines.DoItemChanged(
  AItem: TdxGanttControlModelElementListItem);
begin
  TdxGanttControlPersistentAccess(Owner).Changed;
end;

function TdxGanttControlCustomBaselines.GetItem(
  Index: Integer): TdxGanttControlCustomBaseline;
begin
  Result := TdxGanttControlCustomBaseline(inherited Items[Index]);
end;

procedure TdxGanttControlCustomBaselines.Remove(
  AItem: TdxGanttControlCustomBaseline);
begin
  InternalRemove(AItem);
end;

procedure TdxGanttControlCustomBaselines.Sort;
begin
  InternalSort(dxGanttControlCompareBaselines);
end;

function TdxGanttControlCustomBaselines.Add(const ANumber: Integer): TdxGanttControlCustomBaseline;
begin
  Result := Find(ANumber);
  if Result <> nil then
    Exit;
  FCurrentNumber := ANumber;
  Result := Append;
end;

procedure TdxGanttControlCustomBaselines.AssignCurrentValues(const ANumber: Integer);
var
  ABaseline: TdxGanttControlCustomBaseline;
begin
  ABaseline := Add(ANumber);
  ABaseline.Reset;
  ABaseline.SetNumber(ANumber);
  ABaseline.AssignCurrentValues;
end;

procedure TdxGanttControlCustomBaselines.Delete(const ANumber: Integer);
var
  ABaseline: TdxGanttControlCustomBaseline;
begin
  ABaseline := Find(ANumber);
  if ABaseline <> nil then
  begin
    BeginUpdate;
    try
      ABaseline.DoDelete;
      Remove(ABaseline);
    finally
      EndUpdate;
    end;
  end;
end;

function TdxGanttControlCustomBaselines.Find(const ANumber: Integer): TdxGanttControlCustomBaseline;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
  begin
    if Items[I].Number = ANumber then
      Exit(Items[I]);
    if Items[I].Number > ANumber then
      Break;
  end;
  Result := nil;
end;

{ TdxGanttControlTimephasedDataItem }

procedure TdxGanttControlTimephasedDataItem.DoAssign(Source: TPersistent);
var
  ASource: TdxGanttControlTimephasedDataItem;
begin
  if Safe.Cast(Source, TdxGanttControlTimephasedDataItem, ASource) then
  begin
    &Type := ASource.&Type;
    Start := ASource.Start;
    Finish := ASource.Finish;
    &Unit := ASource.&Unit;
    Value := ASource.Value;
    FAssignedValues := ASource.FAssignedValues;
  end;
  inherited DoAssign(Source);
end;

procedure TdxGanttControlTimephasedDataItem.DoReset;
begin
  FAssignedValues := [];
end;

function TdxGanttControlTimephasedDataItem.InternalGetOwner: TdxGanttControlTimephasedDataItems;
begin
  Result := TdxGanttControlTimephasedDataItems(inherited Owner);
end;

function TdxGanttControlTimephasedDataItem.GetOwnerUID: Integer;
begin
  Result := Owner.Owner.UID;
end;

function TdxGanttControlTimephasedDataItem.IsValueAssigned(const AValue: TdxGanttTimephasedDataAssignedValue): Boolean;
begin
  Result := AValue in FAssignedValues;
end;

procedure TdxGanttControlTimephasedDataItem.ResetValue(const AValue: TdxGanttTimephasedDataAssignedValue);
begin
  if IsValueAssigned(AValue) then
  begin
    Exclude(FAssignedValues, AValue);
    Changed;
  end
end;

procedure TdxGanttControlTimephasedDataItem.SetFinish(
  const AValue: TDateTime);
begin
 if (Finish <> AValue) or not IsValueAssigned(TdxGanttTimephasedDataAssignedValue.Finish) then
  begin
    Include(FAssignedValues, TdxGanttTimephasedDataAssignedValue.Finish);
    FFinish := AValue;
    Changed;
  end;
end;

procedure TdxGanttControlTimephasedDataItem.SetStart(
  const AValue: TDateTime);
begin
 if (Start <> AValue) or not IsValueAssigned(TdxGanttTimephasedDataAssignedValue.Start) then
  begin
    Include(FAssignedValues, TdxGanttTimephasedDataAssignedValue.Start);
    FStart := AValue;
    Changed;
  end;
end;

procedure TdxGanttControlTimephasedDataItem.SetType(
  const AValue: TdxTimephasedDataType);
begin
 if (FType <> AValue) or not IsValueAssigned(TdxGanttTimephasedDataAssignedValue.&Type) then
  begin
    Include(FAssignedValues, TdxGanttTimephasedDataAssignedValue.&Type);
    FType := AValue;
    Changed;
  end;
end;

procedure TdxGanttControlTimephasedDataItem.SetUnit(
  const AValue: TdxTimephasedDataUnit);
begin
 if (FUnit <> AValue) or not IsValueAssigned(TdxGanttTimephasedDataAssignedValue.&Unit) then
  begin
    Include(FAssignedValues, TdxGanttTimephasedDataAssignedValue.&Unit);
    FUnit := AValue;
    Changed;
  end;
end;

procedure TdxGanttControlTimephasedDataItem.SetValue(
  const AValue: string);
begin
 if (Value <> AValue) or not IsValueAssigned(TdxGanttTimephasedDataAssignedValue.Value) then
  begin
    Include(FAssignedValues, TdxGanttTimephasedDataAssignedValue.Value);
    FValue := AValue;
    Changed;
  end;
end;

{ TdxGanttControlTimephasedDataItems }

function TdxGanttControlTimephasedDataItems.Append: TdxGanttControlTimephasedDataItem;
begin
  Result := TdxGanttControlTimephasedDataItem(CreateItem);
  InternalAdd(Result);
end;

procedure TdxGanttControlTimephasedDataItems.Clear;
begin
  InternalClear;
end;

function TdxGanttControlTimephasedDataItems.CreateItem: TdxGanttControlModelElementListItem;
begin
  Result := TdxGanttControlTimephasedDataItem.Create(Self);
end;

function TdxGanttControlTimephasedDataItems.GetItem(
  Index: Integer): TdxGanttControlTimephasedDataItem;
begin
  Result := TdxGanttControlTimephasedDataItem(inherited Items[Index]);
end;

function TdxGanttControlTimephasedDataItems.InternalGetOwner: TdxGanttControlModelUIDElement;
begin
  Result := TdxGanttControlModelUIDElement(inherited Owner);
end;

procedure TdxGanttControlTimephasedDataItems.Remove(
  AItem: TdxGanttControlTimephasedDataItem);
begin
  InternalRemove(AItem);
end;

{ TdxGanttControlEnterpriseExtendedAttributeValue }

procedure TdxGanttControlEnterpriseExtendedAttributeValue.DoAssign(
  Source: TPersistent);
var
  ASource: TdxGanttControlEnterpriseExtendedAttributeValue;
begin
  if Safe.Cast(Source, TdxGanttControlEnterpriseExtendedAttributeValue, ASource) then
  begin
    ID := ASource.ID;
    Value := ASource.Value;
    Description := ASource.Description;
    Phonetic := ASource.Phonetic;
    FAssignedValues := FAssignedValues;
  end;
  inherited DoAssign(Source);
end;

procedure TdxGanttControlEnterpriseExtendedAttributeValue.DoReset;
begin
  FID := -1;
  FAssignedValues := [];
end;

function TdxGanttControlEnterpriseExtendedAttributeValue.IsValueAssigned(
  const AValue: TdxGanttEnterpriseExtendedAttributeAssignedValue): Boolean;
begin
  Result := AValue in FAssignedValues;
end;

procedure TdxGanttControlEnterpriseExtendedAttributeValue.ResetValue(const AValue: TdxGanttEnterpriseExtendedAttributeAssignedValue);
begin
  if IsValueAssigned(AValue) then
  begin
    Exclude(FAssignedValues, AValue);
    Changed;
  end
end;

procedure TdxGanttControlEnterpriseExtendedAttributeValue.SetDescription(
  const Value: string);
begin
  if (Description <> Value) or not IsValueAssigned(TdxGanttEnterpriseExtendedAttributeAssignedValue.Description) then
  begin
    Include(FAssignedValues, TdxGanttEnterpriseExtendedAttributeAssignedValue.Description);
    FDescription := Value;
    Changed;
  end;
end;

procedure TdxGanttControlEnterpriseExtendedAttributeValue.SetID(
  const Value: Integer);
begin
  if ID <> Value then
  begin
    FID := Value;
    Changed;
  end;
end;

procedure TdxGanttControlEnterpriseExtendedAttributeValue.SetPhonetic(
  const Value: string);
begin
  if (Phonetic <> Value) or not IsValueAssigned(TdxGanttEnterpriseExtendedAttributeAssignedValue.Phonetic) then
  begin
    Include(FAssignedValues, TdxGanttEnterpriseExtendedAttributeAssignedValue.Phonetic);
    FPhonetic := Value;
    Changed;
  end;
end;

procedure TdxGanttControlEnterpriseExtendedAttributeValue.SetValue(
  const AValue: string);
begin
  if (FValue <> AValue) or not IsValueAssigned(TdxGanttEnterpriseExtendedAttributeAssignedValue.Value) then
  begin
    Include(FAssignedValues, TdxGanttEnterpriseExtendedAttributeAssignedValue.Value);
    FValue := AValue;
    Changed;
  end;
end;

{ TdxGanttControlEnterpriseExtendedAttribute }

constructor TdxGanttControlEnterpriseExtendedAttribute.Create(
  AOwner: TdxGanttControlModelElement);
begin
  inherited Create(AOwner);
  FValue := TdxGanttControlEnterpriseExtendedAttributeValue.Create(Self);
end;

destructor TdxGanttControlEnterpriseExtendedAttribute.Destroy;
begin
  FreeAndNil(FValue);
  inherited Destroy;
end;

procedure TdxGanttControlEnterpriseExtendedAttribute.DoAssign(
  Source: TPersistent);
var
  ASource: TdxGanttControlEnterpriseExtendedAttribute;
begin
  if Safe.Cast(Source, TdxGanttControlEnterpriseExtendedAttribute, ASource) then
  begin
    FieldIDInHex := ASource.FieldIDInHex;
    FieldID := ASource.FieldID;
    Value := ASource.Value;
    FieldValueGUID := ASource.FieldValueGUID;
  end;
  inherited DoAssign(Source);
end;

procedure TdxGanttControlEnterpriseExtendedAttribute.DoReset;
begin
  FFieldIDInHex := '';
  FFieldID := -1;
  FValue.Reset;
  FFieldValueGUID := '';
end;

procedure TdxGanttControlEnterpriseExtendedAttribute.SetFieldID(
  const Value: Integer);
begin
  if FieldID <> Value then
  begin
    FFieldID := Value;
    Changed;
  end;
end;

procedure TdxGanttControlEnterpriseExtendedAttribute.SetFieldIDInHex(
  const Value: string);
begin
  if FieldIDInHex <> Value then
  begin
    FFieldIDInHex := Value;
    Changed;
  end;
end;

procedure TdxGanttControlEnterpriseExtendedAttribute.SetFieldValueGUID(
  const Value: string);
begin
  if FieldValueGUID <> Value then
  begin
    FFieldValueGUID := Value;
    Changed;
  end;
end;

procedure TdxGanttControlEnterpriseExtendedAttribute.SetValue(
  const AValue: TdxGanttControlEnterpriseExtendedAttributeValue);
begin
  if Value <> AValue then
  begin
    FValue := AValue;
    Changed;
  end;
end;

{ TdxGanttControlEnterpriseExtendedAttributes }

function TdxGanttControlEnterpriseExtendedAttributes.Append: TdxGanttControlEnterpriseExtendedAttribute;
begin
  Result := TdxGanttControlEnterpriseExtendedAttribute(CreateItem);
  InternalAdd(Result);
end;

procedure TdxGanttControlEnterpriseExtendedAttributes.Clear;
begin
  InternalClear;
end;

function TdxGanttControlEnterpriseExtendedAttributes.CreateItem: TdxGanttControlModelElementListItem;
begin
  Result := TdxGanttControlEnterpriseExtendedAttribute.Create(Self);
end;

function TdxGanttControlEnterpriseExtendedAttributes.GetItem(
  Index: Integer): TdxGanttControlEnterpriseExtendedAttribute;
begin
  Result := TdxGanttControlEnterpriseExtendedAttribute(inherited Items[Index]);
end;

procedure TdxGanttControlEnterpriseExtendedAttributes.Remove(
  AItem: TdxGanttControlEnterpriseExtendedAttribute);
begin
  InternalRemove(AItem);
end;

end.
