{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressGanttControl                                      }
{                                                                    }
{           Copyright (c) 2020-2022 Developer Express Inc.           }
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

unit dxGanttControlExtendedAttributes;

{$I cxVer.inc}
{$I dxGanttControl.inc}

interface

uses
  System.UITypes, System.Contnrs,
  SysUtils, RTLConsts, Generics.Defaults, Generics.Collections, Classes,
  dxCore, dxCoreClasses, dxGenerics,
  dxGanttControlCustomClasses,
  dxGanttControlCustomDataModel;

type
  TdxGanttControlExtendedAttribute = class;
  TdxGanttControlExtendedAttributes = class;

  TdxGanttControlExtendedAttributeCFType = (Cost, Date, Duration, Finish, Flag, Number, Start, Text, Unknown);
  TdxGanttControlExtendedAttributeLevel = (Unknown = -1, Task = 20, Resource = 21, Assignment = 23);

  { TdxGanttControlExtendedAttributeValue }

  TdxGanttExtendedAttributeValueAssignedValue = (FieldID, Value, DurationFormat, ValueGUID);
  TdxGanttExtendedAttributeValueAssignedValues = set of TdxGanttExtendedAttributeValueAssignedValue;

  TdxGanttControlExtendedAttributeValue = class(TdxGanttControlModelElementListItem)
  strict private
    FAssignedValues: TdxGanttExtendedAttributeValueAssignedValues;
    FDurationAsDisplayValue: Variant;
    FDurationFormat: TdxDurationFormat;
    FFieldID: Integer;
    FValue: Variant;
    FValueGUID: string;
    function GetDurationAsDisplayValue: Variant;
    function GetExtendedAttribute: TdxGanttControlExtendedAttribute;
    function GetExtendedAttributes: TdxGanttControlExtendedAttributes;
    function GetType: TdxGanttControlExtendedAttributeCFType;
    procedure SetDurationFormat(const Value: TdxDurationFormat);
    procedure SetFieldID(const Value: Integer);
    procedure SetValue(const AValue: Variant);
    procedure SetValueGUID(const Value: string);
  protected
    procedure DoAssign(Source: TPersistent); override;
    procedure DoReset; override;
    property ExtendedAttributes: TdxGanttControlExtendedAttributes read GetExtendedAttributes;
  public
  {$REGION 'for internal use'}
    function IsValueAssigned(const AValue: TdxGanttExtendedAttributeValueAssignedValue): Boolean;
    procedure ResetValue(const AValue: TdxGanttExtendedAttributeValueAssignedValue); overload;
  {$ENDREGION 'for internal use'}

    property DurationFormat: TdxDurationFormat read FDurationFormat write SetDurationFormat;
    property ExtendedAttribute: TdxGanttControlExtendedAttribute read GetExtendedAttribute;
    property &Type: TdxGanttControlExtendedAttributeCFType read GetType;
    property Value: Variant read FValue write SetValue;
  {$REGION 'for internal use'}
    property FieldID: Integer read FFieldID write SetFieldID;
    property DurationAsDisplayValue: Variant read GetDurationAsDisplayValue;
    property ValueGUID: string read FValueGUID write SetValueGUID;
  {$ENDREGION}
  end;

  { TdxGanttControlExtendedAttributeValues }

  TdxGanttControlExtendedAttributeValues = class abstract(TdxGanttControlElementCustomOwnedList)
  strict private
    function GetExtendedAttributes: TdxGanttControlExtendedAttributes;
    function GetItem(const AIndexOrFieldName: Variant): TdxGanttControlExtendedAttributeValue;
  protected
    function CreateItem: TdxGanttControlModelElementListItem; override;
    function GetFieldID(const AFieldName: string): Integer; virtual; abstract;
    function GetItemByFieldID(const AFieldID: Integer): TdxGanttControlExtendedAttributeValue;

    property ExtendedAttributes: TdxGanttControlExtendedAttributes read GetExtendedAttributes;
  public
    function Append: TdxGanttControlExtendedAttributeValue;
    procedure Clear;
    procedure Remove(AItem: TdxGanttControlExtendedAttributeValue); overload;

    property Items[const AIndexOrFieldName: Variant]: TdxGanttControlExtendedAttributeValue read GetItem; default;
  end;

  { TdxGanttControlExtendedAttributeLookupValue }

  TdxGanttExtendedAttributeLookupValueAssignedValue = (Value, Description, Phonetic);
  TdxGanttExtendedAttributeLookupValueAssignedValues = set of TdxGanttExtendedAttributeLookupValueAssignedValue;

  TdxGanttControlExtendedAttributeLookupValue = class(TdxGanttControlModelElementListItem) // for internal use
  strict private
    FAssignedValues: TdxGanttExtendedAttributeLookupValueAssignedValues;
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
    function IsValueAssigned(const AValue: TdxGanttExtendedAttributeLookupValueAssignedValue): Boolean;
    procedure ResetValue(const AValue: TdxGanttExtendedAttributeLookupValueAssignedValue); overload;
  {$ENDREGION 'for internal use'}

    property ID: Integer read FID write SetID;
    property Value: string read FValue write SetValue;
    property Description: string read FDescription write SetDescription;
    property Phonetic: string read FPhonetic write SetPhonetic;
  end;

  { TdxGanttControlExtendedAttributeLookupValues }

  TdxGanttControlExtendedAttributeLookupValues = class(TdxGanttControlElementCustomOwnedList) // for internal use
  strict private
    function GetItem(Index: Integer): TdxGanttControlExtendedAttributeLookupValue; inline;
  protected
    function CreateItem: TdxGanttControlModelElementListItem; override;
  public
    function Append: TdxGanttControlExtendedAttributeLookupValue;
    procedure Clear;
    procedure Remove(AItem: TdxGanttControlExtendedAttributeLookupValue);

    property Items[Index: Integer]: TdxGanttControlExtendedAttributeLookupValue read GetItem; default;
  end;

  TdxGanttControlExtendedAttributeHelper = class // for internal use
  public const
    PatternNameMap: array[TdxGanttControlExtendedAttributeCFType] of string = ('Cost', 'Date', 'Duration', 'Finish', 'Flag', 'Number', 'Start', 'Text', '');
    FieldCountMap: array[TdxGanttControlExtendedAttributeCFType] of Integer = (10, 10, 10, 10, 20, 20, 10, 30, 0);
  strict private class var
    FAssignmentFieldIDDictionary: TdxStringIntegerDictionary;
    FFieldNameDictionary: TDictionary<Integer, string>;
    FResourceFieldIDDictionary: TdxStringIntegerDictionary;
    FTaskFieldIDDictionary: TdxStringIntegerDictionary;
    class constructor Initialize;
  {$HINTS OFF}
    class destructor Finalize;
  {$HINTS ON}
  public
    class function GetFieldID(const AFieldName: string; AType: TdxGanttControlExtendedAttributeLevel): Integer; static;
    class function GetFieldLevel(AFieldID: Integer): TdxGanttControlExtendedAttributeLevel; static;
    class function GetFieldName(AFieldID: Integer): string; static;
    class function GetFieldType(AFieldID: Integer): TdxGanttControlExtendedAttributeCFType; static;
  end;

  { TdxGanttControlExtendedAttribute }

  TdxGanttControlExtendedAttributeCalculationType = (None, Rollup, Calculation);

  TdxGanttControlExtendedAttributeRollupType = (Maximum, Minimum, CountAll,
    Sum, Average, AverageFirstSubLevel, CountFirstSubLevel, CountNonSummaries);

  TdxGanttControlExtendedAttributeValueListSortOrder = (Descending, Ascending);

  TdxGanttExtendedAttributeAssignedValue = (FieldID, FieldName, CFType, GUID, ElemType, MaxMultiValues, UserDef,
    Alias, SecondaryGUID, SecondaryPID, AutoRollDown, DefaultGUID, Ltuid, PhoneticAlias, RollupType, CalculationType,
    Formula, RestrictValues, ValueListSortOrder, AppendNewValues, Default);

  TdxGanttExtendedAttributeAssignedValues = set of TdxGanttExtendedAttributeAssignedValue;

  TdxGanttControlExtendedAttribute = class(TdxGanttControlModelElementListItem)
  strict private
    FAssignedValues: TdxGanttExtendedAttributeAssignedValues;
    FFieldID: Integer;
    FFieldName: string;
    FCFType: TdxGanttControlExtendedAttributeCFType;
    FGUID: string;
    FElemType: TdxGanttControlExtendedAttributeLevel;
    FMaxMultiValues: Integer;
    FUserDef: Boolean;
    FAlias: string;
    FSecondaryGUID: string;
    FSecondaryPID: Integer;
    FAutoRollDown: Boolean;
    FDefaultGUID: string;
    FLtuid: string;
    FPhoneticAlias: string;
    FRollupType: TdxGanttControlExtendedAttributeRollupType;
    FCalculationType: TdxGanttControlExtendedAttributeCalculationType;
    FFormula: string;
    FRestrictValues: Boolean;
    FValueListSortOrder: TdxGanttControlExtendedAttributeValueListSortOrder;
    FAppendNewValues: Boolean;
    FDefault: string;
    FValueList: TdxGanttControlExtendedAttributeLookupValues;
    function GetLevel: TdxGanttControlExtendedAttributeLevel;
    procedure SetAlias(const Value: string);
    procedure SetAppendNewValues(const Value: Boolean);
    procedure SetAutoRollDown(const Value: Boolean);
    procedure SetCalculationType(const Value: TdxGanttControlExtendedAttributeCalculationType);
    procedure SetCFType(const Value: TdxGanttControlExtendedAttributeCFType);
    procedure SetDefault(const Value: string);
    procedure SetDefaultGUID(const Value: string);
    procedure SetElemType(const Value: TdxGanttControlExtendedAttributeLevel);
    procedure SetFieldID(const Value: Integer);
    procedure SetFieldName(const Value: string);
    procedure SetFormula(const Value: string);
    procedure SetGUID(const Value: string);
    procedure SetLtuid(const Value: string);
    procedure SetMaxMultiValues(const Value: Integer);
    procedure SetPhoneticAlias(const Value: string);
    procedure SetRestrictValues(const Value: Boolean);
    procedure SetRollupType(const Value: TdxGanttControlExtendedAttributeRollupType);
    procedure SetSecondaryGUID(const Value: string);
    procedure SetSecondaryPID(const Value: Integer);
    procedure SetUserDef(const Value: Boolean);
    procedure SetValueList(const Value: TdxGanttControlExtendedAttributeLookupValues);
    procedure SetValueListSortOrder(const Value: TdxGanttControlExtendedAttributeValueListSortOrder);
  protected
    procedure DoAssign(Source: TPersistent); override;
    procedure DoReset; override;
  public
    constructor Create(AOwner: TdxGanttControlModelElement); override;
    destructor Destroy; override;
  {$REGION 'for internal use'}
    function IsValueAssigned(const AValue: TdxGanttExtendedAttributeAssignedValue): Boolean;
    procedure ResetValue(const AValue: TdxGanttExtendedAttributeAssignedValue); overload;
  {$ENDREGION 'for internal use'}

    property Alias: string read FAlias write SetAlias;
    property FieldName: string read FFieldName write SetFieldName;
    property Level: TdxGanttControlExtendedAttributeLevel read GetLevel;

  {$REGION 'for internal use'}
    property FieldID: Integer read FFieldID write SetFieldID;
    property SecondaryPID: Integer read FSecondaryPID write SetSecondaryPID;
    property CFType: TdxGanttControlExtendedAttributeCFType read FCFType write SetCFType;
    property GUID: string read FGUID write SetGUID;
    property ElemType: TdxGanttControlExtendedAttributeLevel read FElemType write SetElemType;
    property MaxMultiValues: Integer read FMaxMultiValues write SetMaxMultiValues;
    property UserDef: Boolean read FUserDef write SetUserDef;
    property SecondaryGUID: string read FSecondaryGUID write SetSecondaryGUID;
    property AutoRollDown: Boolean read FAutoRollDown write SetAutoRollDown;
    property DefaultGUID: string read FDefaultGUID write SetDefaultGUID;
    property Ltuid: string read FLtuid write SetLtuid;
    property PhoneticAlias: string read FPhoneticAlias write SetPhoneticAlias;
    property RollupType: TdxGanttControlExtendedAttributeRollupType read FRollupType write SetRollupType;
    property CalculationType: TdxGanttControlExtendedAttributeCalculationType read FCalculationType write SetCalculationType;
    property Formula: string read FFormula write SetFormula;
    property RestrictValues: Boolean read FRestrictValues write SetRestrictValues;
    property ValueListSortOrder: TdxGanttControlExtendedAttributeValueListSortOrder read FValueListSortOrder write SetValueListSortOrder;
    property AppendNewValues: Boolean read FAppendNewValues write SetAppendNewValues;
    property Default: string read FDefault write SetDefault;
    property ValueList: TdxGanttControlExtendedAttributeLookupValues read FValueList write SetValueList;
  {$ENDREGION}
  end;

  { TdxGanttControlExtendedAttributes }

  TdxGanttControlExtendedAttributes = class(TdxGanttControlModelElementList)
  strict private
    function GetItem(Index: Integer): TdxGanttControlExtendedAttribute; inline;
  protected
    function CreateItem: TdxGanttControlModelElementListItem; override;
  public
    function Append: TdxGanttControlExtendedAttribute;
    procedure Clear;
    procedure Remove(AItem: TdxGanttControlExtendedAttribute);

  {$REGION 'for internal use'}
    function Add(AFieldID: Integer): TdxGanttControlExtendedAttribute; overload;
    function Find(AFieldID: Integer): TdxGanttControlExtendedAttribute; overload;
  {$ENDREGION}

    function Add(const AFieldName: string; ALevel: TdxGanttControlExtendedAttributeLevel): TdxGanttControlExtendedAttribute; overload;
    function Find(const AFieldName: string; ALevel: TdxGanttControlExtendedAttributeLevel): TdxGanttControlExtendedAttribute; overload;

    property Items[Index: Integer]: TdxGanttControlExtendedAttribute read GetItem; default;
  end;

implementation

uses
  Variants, Math,
  dxStringHelper, cxVariants, dxCultureInfo,
  dxGanttControlDataModel,
  dxGanttControlCalendars;

const
  dxThisUnitName = 'dxGanttControlExtendedAttributes';

type
  TdxGanttControlDataModelPropertiesAccess = class(TdxGanttControlDataModelProperties);

{ TdxGanttControlExtendedAttributeValue }

procedure TdxGanttControlExtendedAttributeValue.DoAssign(
  Source: TPersistent);
var
  ASource: TdxGanttControlExtendedAttributeValue;
begin
  if Safe.Cast(Source, TdxGanttControlExtendedAttributeValue, ASource) then
  begin
    FieldID := ASource.FieldID;
    DurationFormat := ASource.DurationFormat;
    ValueGUID := ASource.ValueGUID;
    Value := ASource.Value;
    FDurationAsDisplayValue := ASource.DurationAsDisplayValue;
    FAssignedValues := ASource.FAssignedValues;
  end;
  inherited DoAssign(Source);
end;

procedure TdxGanttControlExtendedAttributeValue.DoReset;
begin
  FAssignedValues := [];
  FDurationAsDisplayValue := Null;
end;

function TdxGanttControlExtendedAttributeValue.GetDurationAsDisplayValue: Variant;
var
  ADurationFormat: TdxDurationFormat;
  AValue: Double;
begin
  if &Type = TdxGanttControlExtendedAttributeCFType.Duration then
  begin
    if VarIsNull(FDurationAsDisplayValue) then
    begin
      if IsValueAssigned(TdxGanttExtendedAttributeValueAssignedValue.DurationFormat) then
        ADurationFormat := DurationFormat
      else
        ADurationFormat := TdxGanttControlDataModelPropertiesAccess(
          (Owner.DataModel as TdxGanttControlDataModel).Properties).GetActualDurationFormat;

      AValue := TdxGanttControlDuration.GetDurationValue(VarToStr(Value), ADurationFormat);
      FDurationAsDisplayValue := Format('%g %s', [RoundTo(AValue, -4),
        TdxGanttControlDuration.GetDurationMeasurementUnit(ADurationFormat, AValue <> 1, True)],
        TdxCultureInfo.CurrentCulture.FormatSettings);
    end;
    Result := FDurationAsDisplayValue;
  end
  else
    Result := Null;
end;

function TdxGanttControlExtendedAttributeValue.GetExtendedAttribute: TdxGanttControlExtendedAttribute;
begin
  Result := ExtendedAttributes.Find(FieldID);
end;

function TdxGanttControlExtendedAttributeValue.GetExtendedAttributes: TdxGanttControlExtendedAttributes;
begin
  Result := TdxGanttControlDataModel(DataModel).ExtendedAttributes;
end;

function TdxGanttControlExtendedAttributeValue.GetType: TdxGanttControlExtendedAttributeCFType;
begin
  if (ExtendedAttribute <> nil) and (ExtendedAttribute.IsValueAssigned(TdxGanttExtendedAttributeAssignedValue.CFType)) then
    Result := ExtendedAttribute.CFType
  else
    Result := TdxGanttControlExtendedAttributeHelper.GetFieldType(FieldID);
end;

function TdxGanttControlExtendedAttributeValue.IsValueAssigned(
  const AValue: TdxGanttExtendedAttributeValueAssignedValue): Boolean;
begin
  Result := AValue in FAssignedValues;
end;

procedure TdxGanttControlExtendedAttributeValue.ResetValue(
  const AValue: TdxGanttExtendedAttributeValueAssignedValue);
begin
  if IsValueAssigned(AValue) then
  begin
    Exclude(FAssignedValues, AValue);
    Changed;
  end
end;

procedure TdxGanttControlExtendedAttributeValue.SetDurationFormat(const Value: TdxDurationFormat);
begin
  if (DurationFormat <> Value) or not IsValueAssigned(TdxGanttExtendedAttributeValueAssignedValue.DurationFormat) then
  begin
    Include(FAssignedValues, TdxGanttExtendedAttributeValueAssignedValue.DurationFormat);
    FDurationFormat := Value;
    FDurationAsDisplayValue := Null;
    Changed;
  end;
end;

procedure TdxGanttControlExtendedAttributeValue.SetFieldID(
  const Value: Integer);
begin
  if (FieldID <> Value) or not IsValueAssigned(TdxGanttExtendedAttributeValueAssignedValue.FieldID) then
  begin
    Include(FAssignedValues, TdxGanttExtendedAttributeValueAssignedValue.FieldID);
    FFieldID := Value;
    FDurationAsDisplayValue := Null;
    Changed;
  end;
end;

procedure TdxGanttControlExtendedAttributeValue.SetValue(const AValue: Variant);
begin
  if (FValue <> AValue) or not IsValueAssigned(TdxGanttExtendedAttributeValueAssignedValue.Value) then
  begin
    Include(FAssignedValues, TdxGanttExtendedAttributeValueAssignedValue.Value);
    FValue := AValue;
    FDurationAsDisplayValue := Null;
    Changed;
  end;
end;

procedure TdxGanttControlExtendedAttributeValue.SetValueGUID(const Value: string);
begin
  if (ValueGUID <> Value) or not IsValueAssigned(TdxGanttExtendedAttributeValueAssignedValue.ValueGUID) then
  begin
    Include(FAssignedValues, TdxGanttExtendedAttributeValueAssignedValue.ValueGUID);
    FValueGUID := Value;
    Changed;
  end;
end;

{ TdxGanttControlExtendedAttributeValues }

function TdxGanttControlExtendedAttributeValues.Append: TdxGanttControlExtendedAttributeValue;
begin
  Result := TdxGanttControlExtendedAttributeValue(CreateItem);
  InternalAdd(Result);
end;

procedure TdxGanttControlExtendedAttributeValues.Clear;
begin
  InternalClear;
end;

function TdxGanttControlExtendedAttributeValues.CreateItem: TdxGanttControlModelElementListItem;
begin
  Result := TdxGanttControlExtendedAttributeValue.Create(Self);
end;

function TdxGanttControlExtendedAttributeValues.GetExtendedAttributes: TdxGanttControlExtendedAttributes;
begin
  Result := TdxGanttControlDataModel(DataModel).ExtendedAttributes;
end;

function TdxGanttControlExtendedAttributeValues.GetItem(
  const AIndexOrFieldName: Variant): TdxGanttControlExtendedAttributeValue;
var
  AFieldID: Integer;
begin
  if VarIsStr(AIndexOrFieldName) then
  begin
    AFieldID := GetFieldID(AIndexOrFieldName);
    Result := GetItemByFieldID(AFieldID);
  end
  else if VarIsNumeric(AIndexOrFieldName) then
    Result := TdxGanttControlExtendedAttributeValue(inherited Items[AIndexOrFieldName])
  else
    Result := nil;
end;

procedure TdxGanttControlExtendedAttributeValues.Remove(
  AItem: TdxGanttControlExtendedAttributeValue);
begin
  InternalRemove(AItem);
end;

function TdxGanttControlExtendedAttributeValues.GetItemByFieldID(const AFieldID: Integer): TdxGanttControlExtendedAttributeValue;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    if Items[I].FieldID = AFieldID then
      Exit(Items[I]);
  Result := nil;
end;

{ TdxGanttControlExtendedAttributeLookupValue }

procedure TdxGanttControlExtendedAttributeLookupValue.DoAssign(
  Source: TPersistent);
var
  ASource: TdxGanttControlExtendedAttributeLookupValue;
begin
  if Safe.Cast(Source, TdxGanttControlExtendedAttributeLookupValue, ASource) then
  begin
    ID := ASource.ID;
    Value := ASource.Value;
    Description := ASource.Description;
    Phonetic := ASource.Phonetic;
    FAssignedValues := ASource.FAssignedValues;
  end;
  inherited DoAssign(Source);
end;

procedure TdxGanttControlExtendedAttributeLookupValue.DoReset;
begin
  FID := -1;
  FAssignedValues := [];
end;

function TdxGanttControlExtendedAttributeLookupValue.IsValueAssigned(
  const AValue: TdxGanttExtendedAttributeLookupValueAssignedValue): Boolean;
begin
  Result := AValue in FAssignedValues;
end;

procedure TdxGanttControlExtendedAttributeLookupValue.ResetValue(
  const AValue: TdxGanttExtendedAttributeLookupValueAssignedValue);
begin
  if IsValueAssigned(AValue) then
  begin
    Exclude(FAssignedValues, AValue);
    Changed;
  end
end;

procedure TdxGanttControlExtendedAttributeLookupValue.SetDescription(const Value: string);
begin
  if (Description <> Value) or not IsValueAssigned(TdxGanttExtendedAttributeLookupValueAssignedValue.Description) then
  begin
    Include(FAssignedValues, TdxGanttExtendedAttributeLookupValueAssignedValue.Description);
    FDescription := Value;
    Changed;
  end;
end;

procedure TdxGanttControlExtendedAttributeLookupValue.SetID(const Value: Integer);
begin
  if ID <> Value then
  begin
    FID := Value;
    Changed;
  end;
end;

procedure TdxGanttControlExtendedAttributeLookupValue.SetPhonetic(const Value: string);
begin
  if (Phonetic <> Value) or not IsValueAssigned(TdxGanttExtendedAttributeLookupValueAssignedValue.Phonetic) then
  begin
    Include(FAssignedValues, TdxGanttExtendedAttributeLookupValueAssignedValue.Phonetic);
    FPhonetic := Value;
    Changed;
  end;
end;

procedure TdxGanttControlExtendedAttributeLookupValue.SetValue(const AValue: string);
begin
  if (FValue <> AValue) or not IsValueAssigned(TdxGanttExtendedAttributeLookupValueAssignedValue.Value) then
  begin
    Include(FAssignedValues, TdxGanttExtendedAttributeLookupValueAssignedValue.Value);
    FValue := AValue;
    Changed;
  end;
end;

{ TdxGanttControlExtendedAttributeLookupValues }

function TdxGanttControlExtendedAttributeLookupValues.Append: TdxGanttControlExtendedAttributeLookupValue;
begin
  Result :=  TdxGanttControlExtendedAttributeLookupValue(CreateItem);
  InternalAdd(Result);
end;

procedure TdxGanttControlExtendedAttributeLookupValues.Clear;
begin
  InternalClear;
end;

function TdxGanttControlExtendedAttributeLookupValues.CreateItem: TdxGanttControlModelElementListItem;
begin
  Result := TdxGanttControlExtendedAttributeLookupValue.Create(Self);
end;

function TdxGanttControlExtendedAttributeLookupValues.GetItem(
  Index: Integer): TdxGanttControlExtendedAttributeLookupValue;
begin
  Result := TdxGanttControlExtendedAttributeLookupValue(inherited Items[Index]);
end;

procedure TdxGanttControlExtendedAttributeLookupValues.Remove(
  AItem: TdxGanttControlExtendedAttributeLookupValue);
begin
  InternalRemove(AItem);
end;

{ TdxGanttControlExtendedAttributeHelper }

class constructor TdxGanttControlExtendedAttributeHelper.Initialize;

  procedure AddFieldName(
    AFieldNameDictionary: TdxStringIntegerDictionary;
    const AName: string; AID: Integer);
  begin
    AFieldNameDictionary.Add(AName, AID);
    FFieldNameDictionary.Add(AID, AName);
  end;

  procedure GenerateFieldNames(
    AFieldNameDictionary: TdxStringIntegerDictionary;
    const ABaseName: string; ABaseID, ACount: Integer);
  var
    I: Integer;
    AName: string;
    AID: Integer;
  begin
    for I := 1 to ACount do
    begin
      AName := Format('%s%d', [ABaseName, I]);
      AID := ABaseID + I - 1;
      AddFieldName(AFieldNameDictionary, AName, AID);
    end;
  end;

  function CreateTaskCustomFields: TdxStringIntegerDictionary;
  begin
    Result := TdxStringIntegerDictionary.Create;
    AddFieldName(Result, 'Cost1', 188743786);
    AddFieldName(Result, 'Cost2', 188743787);
    AddFieldName(Result, 'Cost3', 188743788);
    AddFieldName(Result, 'Cost4', 188743938);
    AddFieldName(Result, 'Cost5', 188743939);
    AddFieldName(Result, 'Cost6', 188743940);
    AddFieldName(Result, 'Cost7', 188743941);
    AddFieldName(Result, 'Cost8', 188743942);
    AddFieldName(Result, 'Cost9', 188743943);
    AddFieldName(Result, 'Cost10', 188743944);
    GenerateFieldNames(Result, 'Date', 188743945, 10);
    AddFieldName(Result, 'Duration1', 188743783);
    AddFieldName(Result, 'Duration2', 188743784);
    AddFieldName(Result, 'Duration3', 188743785);
    AddFieldName(Result, 'Duration4', 188743955);
    AddFieldName(Result, 'Duration5', 188743956);
    AddFieldName(Result, 'Duration6', 188743957);
    AddFieldName(Result, 'Duration7', 188743958);
    AddFieldName(Result, 'Duration8', 188743959);
    AddFieldName(Result, 'Duration9', 188743960);
    AddFieldName(Result, 'Duration10', 188743961);
    AddFieldName(Result, 'Finish1', 188743733);
    AddFieldName(Result, 'Finish2', 188743736);
    AddFieldName(Result, 'Finish3', 188743739);
    AddFieldName(Result, 'Finish4', 188743742);
    AddFieldName(Result, 'Finish5', 188743745);
    AddFieldName(Result, 'Finish6', 188743963);
    AddFieldName(Result, 'Finish7', 188743965);
    AddFieldName(Result, 'Finish8', 188743967);
    AddFieldName(Result, 'Finish9', 188743969);
    AddFieldName(Result, 'Finish10', 188743971);
    GenerateFieldNames(Result, 'Flag', 188743752, 10);
    GenerateFieldNames(Result, 'Flag1', 188743972, 9);
    AddFieldName(Result, 'Flag20', 	188743981);
    AddFieldName(Result, 'Number1', 	188743767);
    AddFieldName(Result, 'Number2', 	188743768);
    AddFieldName(Result, 'Number3', 	188743769);
    AddFieldName(Result, 'Number4', 	188743770);
    AddFieldName(Result, 'Number5', 	188743771);
    AddFieldName(Result, 'Number6', 	188743982);
    AddFieldName(Result, 'Number7', 	188743983);
    AddFieldName(Result, 'Number8', 	188743984);
    AddFieldName(Result, 'Number9', 	188743985);
    AddFieldName(Result, 'Number10', 	188743986);
    AddFieldName(Result, 'Number11', 	188743987);
    AddFieldName(Result, 'Number12', 	188743988);
    AddFieldName(Result, 'Number13', 	188743989);
    AddFieldName(Result, 'Number14', 	188743990);
    AddFieldName(Result, 'Number15', 	188743991);
    AddFieldName(Result, 'Number16', 	188743992);
    AddFieldName(Result, 'Number17', 	188743993);
    AddFieldName(Result, 'Number18', 	188743994);
    AddFieldName(Result, 'Number19', 	188743995);
    AddFieldName(Result, 'Number20', 	188743996);
    AddFieldName(Result, 'Outline Code1', 188744096);
    AddFieldName(Result, 'Outline Code2', 188744098);
    AddFieldName(Result, 'Outline Code3', 188744100);
    AddFieldName(Result, 'Outline Code4', 188744102);
    AddFieldName(Result, 'Outline Code5', 188744104);
    AddFieldName(Result, 'Outline Code6', 188744106);
    AddFieldName(Result, 'Outline Code7', 188744108);
    AddFieldName(Result, 'Outline Code8', 188744110);
    AddFieldName(Result, 'Outline Code9', 188744112);
    AddFieldName(Result, 'Outline Code10', 188744114);
    AddFieldName(Result, 'Start1', 188743732);
    AddFieldName(Result, 'Start2', 188743735);
    AddFieldName(Result, 'Start3', 188743738);
    AddFieldName(Result, 'Start4', 188743741);
    AddFieldName(Result, 'Start5', 188743744);
    AddFieldName(Result, 'Start6', 188743962);
    AddFieldName(Result, 'Start7', 188743964);
    AddFieldName(Result, 'Start8', 188743966);
    AddFieldName(Result, 'Start9', 188743968);
    AddFieldName(Result, 'Start10', 188743970);
    AddFieldName(Result, 'Text1', 188743731);
    AddFieldName(Result, 'Text2', 188743734);
    AddFieldName(Result, 'Text3', 188743737);
    AddFieldName(Result, 'Text4', 188743740);
    AddFieldName(Result, 'Text5', 188743743);
    AddFieldName(Result, 'Text6', 188743746);
    AddFieldName(Result, 'Text7', 188743747);
    AddFieldName(Result, 'Text8', 188743748);
    AddFieldName(Result, 'Text9', 188743749);
    AddFieldName(Result, 'Text10', 188743750);
    AddFieldName(Result, 'Text11', 188743997);
    AddFieldName(Result, 'Text12', 188743998);
    AddFieldName(Result, 'Text13', 188743999);
    AddFieldName(Result, 'Text14', 188744000);
    AddFieldName(Result, 'Text15', 188744001);
    AddFieldName(Result, 'Text16', 188744002);
    AddFieldName(Result, 'Text17', 188744003);
    AddFieldName(Result, 'Text18', 188744004);
    AddFieldName(Result, 'Text19', 188744005);
    AddFieldName(Result, 'Text20', 188744006);
    AddFieldName(Result, 'Text21', 188744007);
    AddFieldName(Result, 'Text22', 188744008);
    AddFieldName(Result, 'Text23', 188744009);
    AddFieldName(Result, 'Text24', 188744010);
    AddFieldName(Result, 'Text25', 188744011);
    AddFieldName(Result, 'Text26', 188744012);
    AddFieldName(Result, 'Text27', 188744013);
    AddFieldName(Result, 'Text28', 188744014);
    AddFieldName(Result, 'Text29', 188744015);
    AddFieldName(Result, 'Text30', 188744016);
  end;

  function CreateResourceCustomFields: TdxStringIntegerDictionary;
  begin
    Result := TdxStringIntegerDictionary.Create;
    GenerateFieldNames(Result, 'Date', 205521069, 9);
    AddFieldName(Result, 'Duration1', 205521013);
    AddFieldName(Result, 'Duration2', 205521014);
    AddFieldName(Result, 'Duration3', 205521015);
    AddFieldName(Result, 'Duration4', 205521079);
    AddFieldName(Result, 'Duration5', 205521080);
    AddFieldName(Result, 'Duration6', 205521081);
    AddFieldName(Result, 'Duration7', 205521082);
    AddFieldName(Result, 'Duration8', 205521083);
    AddFieldName(Result, 'Duration9', 205521084);
    AddFieldName(Result, 'Duration10', 205521085);
    AddFieldName(Result, 'Finish1', 205521003);
    AddFieldName(Result, 'Finish2', 205521004);
    AddFieldName(Result, 'Finish3', 205521005);
    AddFieldName(Result, 'Finish4', 205521006);
    AddFieldName(Result, 'Finish5', 205521007);
    AddFieldName(Result, 'Finish6', 205521086);
    AddFieldName(Result, 'Finish7', 205521087);
    AddFieldName(Result, 'Finish8', 205521088);
    AddFieldName(Result, 'Finish9', 205521089);
    AddFieldName(Result, 'Finish10', 205521090);
    AddFieldName(Result, 'Flag1', 205521023);
    AddFieldName(Result, 'Flag2', 205521024);
    AddFieldName(Result, 'Flag3', 205521025);
    AddFieldName(Result, 'Flag4', 205521026);
    AddFieldName(Result, 'Flag5', 205521027);
    AddFieldName(Result, 'Flag6', 205521028);
    AddFieldName(Result, 'Flag7', 205521029);
    AddFieldName(Result, 'Flag8', 205521030);
    AddFieldName(Result, 'Flag9', 205521031);
    AddFieldName(Result, 'Flag10', 205521022);
    AddFieldName(Result, 'Flag11', 205521091);
    AddFieldName(Result, 'Flag12', 205521092);
    AddFieldName(Result, 'Flag13', 205521093);
    AddFieldName(Result, 'Flag14', 205521094);
    AddFieldName(Result, 'Flag15', 205521095);
    AddFieldName(Result, 'Flag16', 205521096);
    AddFieldName(Result, 'Flag17', 205521097);
    AddFieldName(Result, 'Flag18', 205521098);
    AddFieldName(Result, 'Flag19', 205521099);
    AddFieldName(Result, 'Flag20', 205521100);
    AddFieldName(Result, 'Number1', 205521008);
    AddFieldName(Result, 'Number2', 205521009);
    AddFieldName(Result, 'Number3', 205521010);
    AddFieldName(Result, 'Number4', 205521011);
    AddFieldName(Result, 'Number5', 205521012);
    AddFieldName(Result, 'Number6', 205521101);
    AddFieldName(Result, 'Number7', 205521102);
    AddFieldName(Result, 'Number8', 205521103);
    AddFieldName(Result, 'Number9', 205521104);
    AddFieldName(Result, 'Number10', 205521105);
    AddFieldName(Result, 'Number11', 205521106);
    AddFieldName(Result, 'Number12', 205521107);
    AddFieldName(Result, 'Number13', 205521108);
    AddFieldName(Result, 'Number14', 205521109);
    AddFieldName(Result, 'Number15', 205521110);
    AddFieldName(Result, 'Number16', 205521111);
    AddFieldName(Result, 'Number17', 205521112);
    AddFieldName(Result, 'Number18', 205521113);
    AddFieldName(Result, 'Number19', 205521114);
    AddFieldName(Result, 'Number20', 205521115);
    AddFieldName(Result, 'Outline Code1', 205521174);
    AddFieldName(Result, 'Outline Code2', 205521176);
    AddFieldName(Result, 'Outline Code3', 205521178);
    AddFieldName(Result, 'Outline Code4', 205521180);
    AddFieldName(Result, 'Outline Code5', 205521182);
    AddFieldName(Result, 'Outline Code6', 205521184);
    AddFieldName(Result, 'Outline Code7', 205521186);
    AddFieldName(Result, 'Outline Code8', 205521188);
    AddFieldName(Result, 'Outline Code9', 205521190);
    AddFieldName(Result, 'Outline Code10', 205521192);
    AddFieldName(Result, 'Start1', 205520998);
    AddFieldName(Result, 'Start2', 205520999);
    AddFieldName(Result, 'Start3', 205521000);
    AddFieldName(Result, 'Start4', 205521001);
    AddFieldName(Result, 'Start5', 205521002);
    AddFieldName(Result, 'Start6', 205521116);
    AddFieldName(Result, 'Start7', 205521117);
    AddFieldName(Result, 'Start8', 205521118);
    AddFieldName(Result, 'Start9', 205521119);
    AddFieldName(Result, 'Start10', 205521120);
    AddFieldName(Result, 'Text1', 205520904);
    AddFieldName(Result, 'Text2', 205520905);
    AddFieldName(Result, 'Text3', 205520926);
    AddFieldName(Result, 'Text4', 205520927);
    AddFieldName(Result, 'Text5', 205520928);
    AddFieldName(Result, 'Text6', 205520993);
    AddFieldName(Result, 'Text7', 205520994);
    AddFieldName(Result, 'Text8', 205520995);
    AddFieldName(Result, 'Text9', 205520996);
    AddFieldName(Result, 'Text10', 205520997);
    AddFieldName(Result, 'Text11', 205521121);
    AddFieldName(Result, 'Text12', 205521122);
    AddFieldName(Result, 'Text13', 205521123);
    AddFieldName(Result, 'Text14', 205521124);
    AddFieldName(Result, 'Text15', 205521125);
    AddFieldName(Result, 'Text16', 205521126);
    AddFieldName(Result, 'Text17', 205521127);
    AddFieldName(Result, 'Text18', 205521128);
    AddFieldName(Result, 'Text19', 205521129);
    AddFieldName(Result, 'Text20', 205521130);
    AddFieldName(Result, 'Text21', 205521131);
    AddFieldName(Result, 'Text22', 205521132);
    AddFieldName(Result, 'Text23', 205521133);
    AddFieldName(Result, 'Text24', 205521134);
    AddFieldName(Result, 'Text25', 205521135);
    AddFieldName(Result, 'Text26', 205521136);
    AddFieldName(Result, 'Text27', 205521137);
    AddFieldName(Result, 'Text28', 205521138);
    AddFieldName(Result, 'Text29', 205521139);
    AddFieldName(Result, 'Text30', 205521140);
    AddFieldName(Result, 'Cost1', 205521019);
    AddFieldName(Result, 'Cost2', 205521020);
    AddFieldName(Result, 'Cost3', 205521021);
    AddFieldName(Result, 'Cost4', 205521062);
    AddFieldName(Result, 'Cost5', 205521063);
    AddFieldName(Result, 'Cost6', 205521064);
    AddFieldName(Result, 'Cost7', 205521065);
    AddFieldName(Result, 'Cost8', 205521066);
    AddFieldName(Result, 'Cost9', 205521067);
    AddFieldName(Result, 'Cost10', 205521068);
  end;

  function CreateAssignmentCustomFields: TdxStringIntegerDictionary;
  begin
    Result := TdxStringIntegerDictionary.Create;
    GenerateFieldNames(Result, 'Date', 255852710, 10);
    AddFieldName(Result, 'Duration1', 255852657);
    AddFieldName(Result, 'Duration2', 255852658);
    AddFieldName(Result, 'Duration3', 255852659);
    AddFieldName(Result, 'Duration4', 255852720);
    AddFieldName(Result, 'Duration5', 255852721);
    AddFieldName(Result, 'Duration6', 255852722);
    AddFieldName(Result, 'Duration7', 255852723);
    AddFieldName(Result, 'Duration8', 255852724);
    AddFieldName(Result, 'Duration9', 255852725);
    AddFieldName(Result, 'Duration10', 255852726);
    AddFieldName(Result, 'Finish1', 255852647);
    AddFieldName(Result, 'Finish2', 255852648);
    AddFieldName(Result, 'Finish3', 255852649);
    AddFieldName(Result, 'Finish4', 255852650);
    AddFieldName(Result, 'Finish5', 255852651);
    AddFieldName(Result, 'Finish6', 255852727);
    AddFieldName(Result, 'Finish7', 255852728);
    AddFieldName(Result, 'Finish8', 255852729);
    AddFieldName(Result, 'Finish9', 255852730);
    AddFieldName(Result, 'Finish10', 255852731);
    GenerateFieldNames(Result, 'Flag', 255852667, 9);
    AddFieldName(Result, 'Flag10', 255852666);
    AddFieldName(Result, 'Flag11', 255852732);
    AddFieldName(Result, 'Flag12', 255852733);
    AddFieldName(Result, 'Flag13', 255852734);
    AddFieldName(Result, 'Flag14', 255852735);
    AddFieldName(Result, 'Flag15', 255852736);
    AddFieldName(Result, 'Flag16', 255852737);
    AddFieldName(Result, 'Flag17', 255852738);
    AddFieldName(Result, 'Flag18', 255852739);
    AddFieldName(Result, 'Flag19', 255852740);
    AddFieldName(Result, 'Flag20', 255852741);
    AddFieldName(Result, 'Number1', 255852652);
    AddFieldName(Result, 'Number2', 255852653);
    AddFieldName(Result, 'Number3', 255852654);
    AddFieldName(Result, 'Number4', 255852655);
    AddFieldName(Result, 'Number5', 255852656);
    AddFieldName(Result, 'Number6', 255852742);
    AddFieldName(Result, 'Number7', 255852743);
    AddFieldName(Result, 'Number8', 255852744);
    AddFieldName(Result, 'Number9', 255852745);
    AddFieldName(Result, 'Number10', 255852746);
    GenerateFieldNames(Result, 'Number1', 255852747, 9);
    AddFieldName(Result, 'Number20', 255852756);
    AddFieldName(Result, 'Start1', 255852642);
    AddFieldName(Result, 'Start2', 255852643);
    AddFieldName(Result, 'Start3', 255852644);
    AddFieldName(Result, 'Start4', 255852645);
    AddFieldName(Result, 'Start5', 255852646);
    AddFieldName(Result, 'Start6', 255852757);
    AddFieldName(Result, 'Start7', 255852758);
    AddFieldName(Result, 'Start8', 255852759);
    AddFieldName(Result, 'Start9', 255852760);
    AddFieldName(Result, 'Start10', 255852761);
    GenerateFieldNames(Result, 'Text', 255852632, 10);
    GenerateFieldNames(Result, 'Text1', 255852762, 9);
    AddFieldName(Result, 'Text20', 255852771);
    GenerateFieldNames(Result, 'Text2', 255852772, 9);
    AddFieldName(Result, 'Text30', 255852781);
    AddFieldName(Result, 'Cost1', 255852663);
    AddFieldName(Result, 'Cost2', 255852664);
    AddFieldName(Result, 'Cost3', 255852665);
    AddFieldName(Result, 'Cost4', 255852703);
    AddFieldName(Result, 'Cost5', 255852704);
    AddFieldName(Result, 'Cost6', 255852705);
    AddFieldName(Result, 'Cost7', 255852706);
    AddFieldName(Result, 'Cost8', 255852707);
    AddFieldName(Result, 'Cost9', 255852708);
    AddFieldName(Result, 'Cost10', 255852709);
  end;

begin
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.ConstructorStarted(UnitName, 'TdxGanttControlExtendedAttributeHelper.Initialize', SysInit.HInstance);{$ENDIF}
  FFieldNameDictionary := TDictionary<Integer, string>.Create;
  FResourceFieldIDDictionary := CreateResourceCustomFields;
  FTaskFieldIDDictionary := CreateTaskCustomFields;
  FAssignmentFieldIDDictionary := CreateAssignmentCustomFields;
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.ConstructorFinished(UnitName, 'TdxGanttControlExtendedAttributeHelper.Initialize', SysInit.HInstance);{$ENDIF}
end;

class destructor TdxGanttControlExtendedAttributeHelper.Finalize;
begin
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.DestructorStarted(UnitName, 'TdxGanttControlExtendedAttributeHelper.Finalize', SysInit.HInstance);{$ENDIF}
  FreeAndNil(FAssignmentFieldIDDictionary);
  FreeAndNil(FTaskFieldIDDictionary);
  FreeAndNil(FFieldNameDictionary);
  FreeAndNil(FResourceFieldIDDictionary);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.DestructorFinished(UnitName, 'TdxGanttControlExtendedAttributeHelper.Finalize', SysInit.HInstance);{$ENDIF}
end;

class function TdxGanttControlExtendedAttributeHelper.GetFieldID(
  const AFieldName: string;
  AType: TdxGanttControlExtendedAttributeLevel): Integer;
begin
  case AType of
    TdxGanttControlExtendedAttributeLevel.Task:
      if not FTaskFieldIDDictionary.TryGetValue(AFieldName, Result) then
        Result := -1;
    TdxGanttControlExtendedAttributeLevel.Resource:
      if not FResourceFieldIDDictionary.TryGetValue(AFieldName, Result) then
        Result := -1;
    TdxGanttControlExtendedAttributeLevel.Assignment:
      if not FAssignmentFieldIDDictionary.TryGetValue(AFieldName, Result) then
        Result := -1;
  else
    Result := -1;
  end;
end;

class function TdxGanttControlExtendedAttributeHelper.GetFieldLevel(
  AFieldID: Integer): TdxGanttControlExtendedAttributeLevel;
var
  AName: string;
  AID: Integer;
begin
  Result := TdxGanttControlExtendedAttributeLevel.Unknown;
  if not FFieldNameDictionary.TryGetValue(AFieldID, AName) then
    Exit;
  if FTaskFieldIDDictionary.TryGetValue(AName, AID) and (AFieldID = AID) then
    Result := TdxGanttControlExtendedAttributeLevel.Task
  else if FResourceFieldIDDictionary.TryGetValue(AName, AID) and (AFieldID = AID) then
    Result := TdxGanttControlExtendedAttributeLevel.Resource
  else if FAssignmentFieldIDDictionary.TryGetValue(AName, AID) and (AFieldID = AID) then
    Result := TdxGanttControlExtendedAttributeLevel.Assignment;
end;

class function TdxGanttControlExtendedAttributeHelper.GetFieldName(
  AFieldID: Integer): string;
begin
  if not FFieldNameDictionary.TryGetValue(AFieldID, Result) then
    Result := '';
end;

class function TdxGanttControlExtendedAttributeHelper.GetFieldType(
  AFieldID: Integer): TdxGanttControlExtendedAttributeCFType;
var
  AResult: TdxGanttControlExtendedAttributeCFType;
  AFieldName: string;
begin
  Result := TdxGanttControlExtendedAttributeCFType.Unknown;
  if not FFieldNameDictionary.TryGetValue(AFieldID, AFieldName) then
    Exit;
  for AResult := TdxGanttControlExtendedAttributeCFType.Cost to TdxGanttControlExtendedAttributeCFType.Text do
    if TdxStringHelper.StartsWith(AFieldName, TdxGanttControlExtendedAttributeHelper.PatternNameMap[AResult]) then
      Exit(AResult);
end;

{ TdxGanttControlExtendedAttribute }

constructor TdxGanttControlExtendedAttribute.Create(
  AOwner: TdxGanttControlModelElement);
begin
  inherited Create(AOwner);
  FValueList := TdxGanttControlExtendedAttributeLookupValues.Create(Self);
end;

destructor TdxGanttControlExtendedAttribute.Destroy;
begin
  FreeAndNil(FValueList);
  inherited Destroy;
end;

procedure TdxGanttControlExtendedAttribute.DoAssign(Source: TPersistent);
var
  ASource: TdxGanttControlExtendedAttribute;
begin
  if Safe.Cast(Source, TdxGanttControlExtendedAttribute, ASource) then
  begin
    FieldID := ASource.FieldID;
    FieldName := ASource.FieldName;
    CFType := ASource.CFType;
    GUID := ASource.GUID;
    ElemType := ASource.ElemType;
    MaxMultiValues := ASource.MaxMultiValues;
    UserDef := ASource.UserDef;
    Alias := ASource.Alias;
    SecondaryGUID := ASource.SecondaryGUID;
    SecondaryPID := ASource.SecondaryPID;
    AutoRollDown := ASource.AutoRollDown;
    DefaultGUID := ASource.DefaultGUID;
    Ltuid := ASource.Ltuid;
    PhoneticAlias := ASource.PhoneticAlias;
    RollupType := ASource.RollupType;
    CalculationType := ASource.CalculationType;
    Formula := ASource.Formula;
    RestrictValues := ASource.RestrictValues;
    ValueListSortOrder := ASource.ValueListSortOrder;
    AppendNewValues := ASource.AppendNewValues;
    Default := ASource.Default;
    ValueList := ASource.ValueList;
    FAssignedValues := ASource.FAssignedValues;
  end;
  inherited DoAssign(Source);
end;

procedure TdxGanttControlExtendedAttribute.DoReset;
begin
  FValueList.Reset;
  FAssignedValues := [];
end;

function TdxGanttControlExtendedAttribute.GetLevel: TdxGanttControlExtendedAttributeLevel;
begin
  Result := TdxGanttControlExtendedAttributeHelper.GetFieldLevel(FieldID);
end;

function TdxGanttControlExtendedAttribute.IsValueAssigned(
  const AValue: TdxGanttExtendedAttributeAssignedValue): Boolean;
begin
  Result := AValue in FAssignedValues;
end;

procedure TdxGanttControlExtendedAttribute.ResetValue(
  const AValue: TdxGanttExtendedAttributeAssignedValue);
begin
  if IsValueAssigned(AValue) then
  begin
    Exclude(FAssignedValues, AValue);
    Changed;
  end
end;

procedure TdxGanttControlExtendedAttribute.SetAlias(const Value: string);
begin
  if (Alias <> Value) or not IsValueAssigned(TdxGanttExtendedAttributeAssignedValue.Alias) then
  begin
    Include(FAssignedValues, TdxGanttExtendedAttributeAssignedValue.Alias);
    FAlias := Value;
    Changed;
  end;
end;

procedure TdxGanttControlExtendedAttribute.SetAppendNewValues(const Value: Boolean);
begin
  if (AppendNewValues <> Value) or not IsValueAssigned(TdxGanttExtendedAttributeAssignedValue.AppendNewValues) then
  begin
    Include(FAssignedValues, TdxGanttExtendedAttributeAssignedValue.AppendNewValues);
    FAppendNewValues := Value;
    Changed;
  end;
end;

procedure TdxGanttControlExtendedAttribute.SetAutoRollDown(const Value: Boolean);
begin
  if (AutoRollDown <> Value) or not IsValueAssigned(TdxGanttExtendedAttributeAssignedValue.AutoRollDown) then
  begin
    Include(FAssignedValues, TdxGanttExtendedAttributeAssignedValue.AutoRollDown);
    FAutoRollDown := Value;
    Changed;
  end;
end;

procedure TdxGanttControlExtendedAttribute.SetCalculationType(
  const Value: TdxGanttControlExtendedAttributeCalculationType);
begin
  if (CalculationType <> Value) or not IsValueAssigned(TdxGanttExtendedAttributeAssignedValue.CalculationType) then
  begin
    Include(FAssignedValues, TdxGanttExtendedAttributeAssignedValue.CalculationType);
    FCalculationType := Value;
    Changed;
  end;
end;

procedure TdxGanttControlExtendedAttribute.SetCFType(
  const Value: TdxGanttControlExtendedAttributeCFType);
begin
  if (CFType <> Value) or not IsValueAssigned(TdxGanttExtendedAttributeAssignedValue.CFType) then
  begin
    Include(FAssignedValues, TdxGanttExtendedAttributeAssignedValue.CFType);
    FCFType := Value;
    Changed;
  end;
end;

procedure TdxGanttControlExtendedAttribute.SetDefault(const Value: string);
begin
  if (Default <> Value) or not IsValueAssigned(TdxGanttExtendedAttributeAssignedValue.Default) then
  begin
    Include(FAssignedValues, TdxGanttExtendedAttributeAssignedValue.Default);
    FDefault := Value;
    Changed;
  end;
end;

procedure TdxGanttControlExtendedAttribute.SetDefaultGUID(const Value: string);
begin
  if (DefaultGUID <> Value) or not IsValueAssigned(TdxGanttExtendedAttributeAssignedValue.DefaultGUID) then
  begin
    Include(FAssignedValues, TdxGanttExtendedAttributeAssignedValue.DefaultGUID);
    FDefaultGUID := Value;
    Changed;
  end;
end;

procedure TdxGanttControlExtendedAttribute.SetElemType(
  const Value: TdxGanttControlExtendedAttributeLevel);
begin
  if (ElemType <> Value) or not IsValueAssigned(TdxGanttExtendedAttributeAssignedValue.ElemType) then
  begin
    Include(FAssignedValues, TdxGanttExtendedAttributeAssignedValue.ElemType);
    FElemType := Value;
    Changed;
  end;
end;

procedure TdxGanttControlExtendedAttribute.SetFieldID(const Value: Integer);
begin
  if (FieldID <> Value) or not IsValueAssigned(TdxGanttExtendedAttributeAssignedValue.FieldID) then
  begin
    Include(FAssignedValues, TdxGanttExtendedAttributeAssignedValue.FieldID);
    FFieldID := Value;
    Changed;
  end;
end;

procedure TdxGanttControlExtendedAttribute.SetFieldName(const Value: string);
begin
  if (FieldName <> Value) or not IsValueAssigned(TdxGanttExtendedAttributeAssignedValue.FieldName) then
  begin
    Include(FAssignedValues, TdxGanttExtendedAttributeAssignedValue.FieldName);
    FFieldName := Value;
    Changed;
  end;
end;

procedure TdxGanttControlExtendedAttribute.SetFormula(const Value: string);
begin
  if (Formula <> Value) or not IsValueAssigned(TdxGanttExtendedAttributeAssignedValue.Formula) then
  begin
    Include(FAssignedValues, TdxGanttExtendedAttributeAssignedValue.Formula);
    FFormula := Value;
    Changed;
  end;
end;

procedure TdxGanttControlExtendedAttribute.SetGUID(const Value: string);
begin
  if (GUID <> Value) or not IsValueAssigned(TdxGanttExtendedAttributeAssignedValue.GUID) then
  begin
    Include(FAssignedValues, TdxGanttExtendedAttributeAssignedValue.GUID);
    FGUID := Value;
    Changed;
  end;
end;

procedure TdxGanttControlExtendedAttribute.SetLtuid(const Value: string);
begin
  if (Ltuid <> Value) or not IsValueAssigned(TdxGanttExtendedAttributeAssignedValue.Ltuid) then
  begin
    Include(FAssignedValues, TdxGanttExtendedAttributeAssignedValue.Ltuid);
    FLtuid := Value;
    Changed;
  end;
end;

procedure TdxGanttControlExtendedAttribute.SetMaxMultiValues(const Value: Integer);
begin
  if (MaxMultiValues <> Value) or not IsValueAssigned(TdxGanttExtendedAttributeAssignedValue.MaxMultiValues) then
  begin
    Include(FAssignedValues, TdxGanttExtendedAttributeAssignedValue.MaxMultiValues);
    FMaxMultiValues := Value;
    Changed;
  end;
end;

procedure TdxGanttControlExtendedAttribute.SetPhoneticAlias(const Value: string);
begin
  if (PhoneticAlias <> Value) or not IsValueAssigned(TdxGanttExtendedAttributeAssignedValue.PhoneticAlias) then
  begin
    Include(FAssignedValues, TdxGanttExtendedAttributeAssignedValue.PhoneticAlias);
    FPhoneticAlias := Value;
    Changed;
  end;
end;

procedure TdxGanttControlExtendedAttribute.SetRestrictValues(const Value: Boolean);
begin
  if (RestrictValues <> Value) or not IsValueAssigned(TdxGanttExtendedAttributeAssignedValue.RestrictValues) then
  begin
    Include(FAssignedValues, TdxGanttExtendedAttributeAssignedValue.RestrictValues);
    FRestrictValues := Value;
    Changed;
  end;
end;

procedure TdxGanttControlExtendedAttribute.SetRollupType(
  const Value: TdxGanttControlExtendedAttributeRollupType);
begin
  if (RollupType <> Value) or not IsValueAssigned(TdxGanttExtendedAttributeAssignedValue.RollupType) then
  begin
    Include(FAssignedValues, TdxGanttExtendedAttributeAssignedValue.RollupType);
    FRollupType := Value;
    Changed;
  end;
end;

procedure TdxGanttControlExtendedAttribute.SetSecondaryGUID(const Value: string);
begin
  if (SecondaryGUID <> Value) or not IsValueAssigned(TdxGanttExtendedAttributeAssignedValue.SecondaryGUID) then
  begin
    Include(FAssignedValues, TdxGanttExtendedAttributeAssignedValue.SecondaryGUID);
    FSecondaryGUID := Value;
    Changed;
  end;
end;

procedure TdxGanttControlExtendedAttribute.SetSecondaryPID(const Value: Integer);
begin
  if (SecondaryPID <> Value) or not IsValueAssigned(TdxGanttExtendedAttributeAssignedValue.SecondaryPID) then
  begin
    Include(FAssignedValues, TdxGanttExtendedAttributeAssignedValue.SecondaryPID);
    FSecondaryPID := Value;
    Changed;
  end;
end;

procedure TdxGanttControlExtendedAttribute.SetUserDef(const Value: Boolean);
begin
  if (UserDef <> Value) or not IsValueAssigned(TdxGanttExtendedAttributeAssignedValue.UserDef) then
  begin
    Include(FAssignedValues, TdxGanttExtendedAttributeAssignedValue.UserDef);
    FUserDef := Value;
    Changed;
  end;
end;

procedure TdxGanttControlExtendedAttribute.SetValueList(
  const Value: TdxGanttControlExtendedAttributeLookupValues);
begin
  FValueList.Assign(Value);
end;

procedure TdxGanttControlExtendedAttribute.SetValueListSortOrder(
  const Value: TdxGanttControlExtendedAttributeValueListSortOrder);
begin
  if (ValueListSortOrder <> Value) or not IsValueAssigned(TdxGanttExtendedAttributeAssignedValue.ValueListSortOrder) then
  begin
    Include(FAssignedValues, TdxGanttExtendedAttributeAssignedValue.ValueListSortOrder);
    FValueListSortOrder := Value;
    Changed;
  end;
end;

{ TdxGanttControlExtendedAttributes }

function TdxGanttControlExtendedAttributes.Append: TdxGanttControlExtendedAttribute;
begin
  Result := TdxGanttControlExtendedAttribute(CreateItem);
  InternalAdd(Result);
end;

procedure TdxGanttControlExtendedAttributes.Clear;
begin
  InternalClear;
end;

function TdxGanttControlExtendedAttributes.Add(
  AFieldID: Integer): TdxGanttControlExtendedAttribute;
var
  ALevel: TdxGanttControlExtendedAttributeLevel;
  AFieldName: string;
begin
  Result := Find(AFieldID);
  if Result <> nil then
    Exit;
  Result := Append;
  ALevel := TdxGanttControlExtendedAttributeHelper.GetFieldLevel(AFieldID);
  AFieldName := TdxGanttControlExtendedAttributeHelper.GetFieldName(AFieldID);
  if ALevel = TdxGanttControlExtendedAttributeLevel.Assignment then
  begin
    Result.FieldID := TdxGanttControlExtendedAttributeHelper.GetFieldID(AFieldName, TdxGanttControlExtendedAttributeLevel.Resource);
    Result.SecondaryPID := AFieldID;
  end
  else
  begin
    Result.FieldID := AFieldID;
    if ALevel = TdxGanttControlExtendedAttributeLevel.Resource then
      Result.SecondaryPID := TdxGanttControlExtendedAttributeHelper.GetFieldID(AFieldName, TdxGanttControlExtendedAttributeLevel.Assignment);
  end;
  Result.FieldName := AFieldName;
end;

function TdxGanttControlExtendedAttributes.Add(const AFieldName: string; ALevel: TdxGanttControlExtendedAttributeLevel): TdxGanttControlExtendedAttribute;
var
  AFieldID: Integer;
begin
  AFieldID := TdxGanttControlExtendedAttributeHelper.GetFieldID(AFieldName, ALevel);
  if AFieldID = -1 then
    Result := nil
  else
    Result := Add(AFieldID);
end;

function TdxGanttControlExtendedAttributes.Find(const AFieldName: string; ALevel: TdxGanttControlExtendedAttributeLevel): TdxGanttControlExtendedAttribute;
var
  AFieldID: Integer;
begin
  AFieldID := TdxGanttControlExtendedAttributeHelper.GetFieldID(AFieldName, ALevel);
  if AFieldID = -1 then
    Result := nil
  else
    Result := Find(AFieldID);
end;

function TdxGanttControlExtendedAttributes.CreateItem: TdxGanttControlModelElementListItem;
begin
  Result := TdxGanttControlExtendedAttribute.Create(Self);
end;

function TdxGanttControlExtendedAttributes.Find(
  AFieldID: Integer): TdxGanttControlExtendedAttribute;
var
  I: Integer;
  ALevel: TdxGanttControlExtendedAttributeLevel;
begin
  ALevel := TdxGanttControlExtendedAttributeHelper.GetFieldLevel(AFieldID);
  for I := 0 to Count - 1 do
  begin
    if ALevel = TdxGanttControlExtendedAttributeLevel.Assignment then
    begin
      if Items[I].SecondaryPID = AFieldID then
        Exit(Items[I]);
    end
    else
      if Items[I].FieldID = AFieldID then
        Exit(Items[I]);
  end;
  Result := nil;
end;

function TdxGanttControlExtendedAttributes.GetItem(
  Index: Integer): TdxGanttControlExtendedAttribute;
begin
  Result := TdxGanttControlExtendedAttribute(inherited Items[Index]);
end;

procedure TdxGanttControlExtendedAttributes.Remove(
  AItem: TdxGanttControlExtendedAttribute);
begin
  InternalRemove(AItem);
end;

end.
