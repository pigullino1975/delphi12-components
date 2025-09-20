{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressSpreadSheet                                       }
{                                                                    }
{           Copyright (c) 2001-2024 Developer Express Inc.           }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSSPREADSHEET CONTROL AND ALL    }
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

unit dxSpreadSheetFormatXLSXReaderConditionalFormatting;

{$I cxVer.inc}

interface

uses
  System.UITypes,
  Types, Windows, SysUtils, Classes, Graphics, Generics.Defaults, Generics.Collections, Variants,
  dxCore, dxCoreClasses, cxClasses, dxCustomTree, dxXMLDoc, dxZIPUtils, dxGDIPlusClasses, dxCoreGraphics,
  cxGeometry, dxHashUtils, dxXMLReader, dxXMLReaderUtils,
  // SpreadSheet;
  dxSpreadSheetClasses,
  dxSpreadSheetConditionalFormatting,
  dxSpreadSheetConditionalFormattingRules,
  dxSpreadSheetContainers,
  dxSpreadSheetCore,
  dxSpreadSheetCoreStyles,
  dxSpreadSheetFormatXLSXReader,
  dxSpreadSheetFormatXLSXUtils,
  dxSpreadSheetFormatUtils,
  dxSpreadSheetPackedFileFormatCore,
  dxSpreadSheetPrinting,
  dxSpreadSheetStrs,
  dxSpreadSheetTypes,
  dxSpreadSheetUtils;

type

  { TdxXLSXConditionalFormattingHandler }

  TdxXLSXConditionalFormattingHandler = class(TdxXLSXNodeHandler)
  strict private
    FConditionalFormatting: TdxSpreadSheetConditionalFormatting;
    FCurrentAreas: TdxSpreadSheetAreaList;
    FCurrentRules: TList;
    FRuleExtensionHandlers: TdxXMLNodeHandlers;
    FRuleHandlers: TdxXMLNodeHandlers;
    FRuleMap: TdxXLSXStringToObjectMap;
    FRulePriorityList: TList;

    procedure ParseAreas(const S: string);
    function ProcessRule(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    function ProcessRuleExt(const AReader: TdxXmlReader): TdxXMLNodeHandler;
  public
    constructor Create(AOwner, AData: TObject); override;
    destructor Destroy; override;
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    procedure OnAttributes(const AReader: TdxXmlReader); override;
    procedure OnEnd; override;
    //
    property ConditionalFormatting: TdxSpreadSheetConditionalFormatting read FConditionalFormatting;
    property CurrentAreas: TdxSpreadSheetAreaList read FCurrentAreas;
    property CurrentRules: TList read FCurrentRules;
    property RuleExtensionHandlers: TdxXMLNodeHandlers read FRuleExtensionHandlers;
    property RuleHandlers: TdxXMLNodeHandlers read FRuleHandlers;
    property RuleMap: TdxXLSXStringToObjectMap read FRuleMap;
    property RulePriorityList: TList read FRulePriorityList;
  end;

  { TdxXLSXConditionalFormattingExtensionsHandler }

  TdxXLSXConditionalFormattingExtensionsHandler = class(TdxXLSXNodeHandler)
  strict private
    FHandler: TdxXLSXConditionalFormattingHandler;

    function ProcessConditionalFormattingExt(const AReader: TdxXmlReader): TdxXMLNodeHandler;
  public
    constructor Create(AOwner, AData: TObject); override;
  end;

implementation

uses
  AnsiStrings, Math, dxColorPicker, cxGraphics, dxTypeHelpers, dxSpreadSheetGraphics, dxSpreadSheetFormulas,
  dxSpreadSheetFormatXLSX, dxSpreadSheetFormatXLSXTags, dxSpreadSheetConditionalFormattingIconSet,
  dxSpreadSheetCoreStrs;

const
  dxThisUnitName = 'dxSpreadSheetFormatXLSXReaderConditionalFormatting';

type
  TdxSpreadSheetConditionalFormattingRuleCustomScaleAccess = class(TdxSpreadSheetConditionalFormattingRuleCustomScale);
  TdxSpreadSheetConditionalFormattingRuleCustomColorScaleAccess = class(TdxSpreadSheetConditionalFormattingRuleCustomColorScale);

  { TdxXLSXConditionalFormattingScaleStop }

  TdxXLSXConditionalFormattingScaleStop = class
  public
    Color: TColor;
    GTE: Boolean;
    Value: Variant;
    ValueType: TdxSpreadSheetConditionalFormattingRuleCustomScaleStopValueType;

    procedure AssignTo(AStop: TdxSpreadSheetConditionalFormattingRuleCustomScaleStop);
  end;

  { TdxXLSXConditionalFormattingScaleStopHandler }

  TdxXLSXConditionalFormattingScaleStopHandler = class(TdxXLSXNodeHandler)
  strict private
    FStop: TdxXLSXConditionalFormattingScaleStop;
    FValue: string;
    FValueType: TdxSpreadSheetConditionalFormattingRuleCustomScaleStopValueType;

    procedure ProcessExpression(const S: string);
  public
    constructor Create(AOwner, AData: TObject); override;
    procedure OnAttributes(const AReader: TdxXmlReader); override;
    procedure OnEnd; override;
  end;

  { TdxXLSXConditionalFormattingCustomRuleHandler }

  TdxXLSXConditionalFormattingCustomRuleHandler = class(TdxXLSXNodeHandler)
  strict private
    FOwner: TdxXLSXConditionalFormattingHandler;
    FPriority: Integer;
  protected
    procedure ApplyRuleSettings(ARule: TdxSpreadSheetConditionalFormattingCustomRule); virtual;
    function CreateRule: TdxSpreadSheetConditionalFormattingCustomRule; virtual;
    function GetRuleClass: TdxSpreadSheetConditionalFormattingCustomRuleClass; virtual; abstract;
  public
    constructor Create(AOwner, AData: TObject); override;
    procedure BeforeDestruction; override;
    procedure OnAttributes(const AReader: TdxXmlReader); override;
    //
    property Owner: TdxXLSXConditionalFormattingHandler read FOwner;
  end;

  { TdxXLSXConditionalFormattingStyleBasedRuleHandler }

  TdxXLSXConditionalFormattingStyleBasedRuleHandler = class(TdxXLSXConditionalFormattingCustomRuleHandler)
  strict private
    FConditionalFormattingStyles: TdxHashTableItemList;
    FStopIfTrue: Boolean;
    FStyleIndex: Integer;
  protected
    procedure ApplyRuleSettings(ARule: TdxSpreadSheetConditionalFormattingCustomRule); override;
  public
    constructor Create(AOwner, AData: TObject); override;
    procedure OnAttributes(const AReader: TdxXmlReader); override;
    //
    property ConditionalFormattingStyles: TdxHashTableItemList read FConditionalFormattingStyles;
  end;

  { TdxXLSXConditionalFormattingExpressionRuleHandler }

  TdxXLSXConditionalFormattingExpressionRuleHandler = class(TdxXLSXConditionalFormattingStyleBasedRuleHandler)
  strict private
    procedure ProcessExpression(const S: string);
  protected
    FExpressions: TStrings;

    procedure ApplyRuleSettings(ARule: TdxSpreadSheetConditionalFormattingCustomRule); override;
    function GetRuleClass: TdxSpreadSheetConditionalFormattingCustomRuleClass; override;
  public
    constructor Create(AOwner, AData: TObject); override;
    destructor Destroy; override;
    procedure AfterConstruction; override;
  end;

  { TdxXLSXConditionalFormattingCellIsRuleHandler }

  TdxXLSXConditionalFormattingCellIsRuleHandler = class(TdxXLSXConditionalFormattingExpressionRuleHandler)
  strict private
    FOperator: TdxSpreadSheetConditionalFormattingRuleCellIsComparisonOperator;
  protected
    procedure ApplyRuleSettings(ARule: TdxSpreadSheetConditionalFormattingCustomRule); override;
    function GetRuleClass: TdxSpreadSheetConditionalFormattingCustomRuleClass; override;
  public
    procedure OnAttributes(const AReader: TdxXmlReader); override;
  end;

  { TdxXLSXConditionalFormattingAboveAverageRuleHandler }

  TdxXLSXConditionalFormattingAboveAverageRuleHandler = class(TdxXLSXConditionalFormattingStyleBasedRuleHandler)
  strict private
    FOperator: TdxSpreadSheetConditionalFormattingRuleAboveOrBelowAverageComparisonOperator;
    FStandardDeviationLevel: Integer;
  protected
    procedure ApplyRuleSettings(ARule: TdxSpreadSheetConditionalFormattingCustomRule); override;
    function GetRuleClass: TdxSpreadSheetConditionalFormattingCustomRuleClass; override;
  public
    procedure OnAttributes(const AReader: TdxXmlReader); override;
  end;

  { TdxXLSXConditionalFormattingTopBottomRuleHandler }

  TdxXLSXConditionalFormattingTopBottomRuleHandler = class(TdxXLSXConditionalFormattingStyleBasedRuleHandler)
  strict private
    FBottom: Boolean;
    FPercents: Boolean;
    FRank: Integer;
  protected
    procedure ApplyRuleSettings(ARule: TdxSpreadSheetConditionalFormattingCustomRule); override;
    function GetRuleClass: TdxSpreadSheetConditionalFormattingCustomRuleClass; override;
  public
    procedure OnAttributes(const AReader: TdxXmlReader); override;
  end;

  { TdxXLSXConditionalFormattingDuplicateValuesRuleHandler }

  TdxXLSXConditionalFormattingDuplicateValuesRuleHandler = class(TdxXLSXConditionalFormattingStyleBasedRuleHandler)
  protected
    function GetRuleClass: TdxSpreadSheetConditionalFormattingCustomRuleClass; override;
  end;

  { TdxXLSXConditionalFormattingUniqueValuesRuleHandler }

  TdxXLSXConditionalFormattingUniqueValuesRuleHandler = class(TdxXLSXConditionalFormattingStyleBasedRuleHandler)
  protected
    function GetRuleClass: TdxSpreadSheetConditionalFormattingCustomRuleClass; override;
  end;

  { TdxXLSXConditionalFormattingCustomScaleRuleHandler }

  TdxXLSXConditionalFormattingCustomScaleRuleHandler = class(TdxXLSXConditionalFormattingCustomRuleHandler)
  strict private
    FExtensionId: string;
    FRuleId: string;
    FStops: TcxObjectList;

    procedure ProcessExtensionId(const S: string);
    function ProcessStop(const AReader: TdxXmlReader): TdxXMLNodeHandler;
  protected
    procedure ApplyRuleSettings(ARule: TdxSpreadSheetConditionalFormattingCustomRule); override;
    function CreateRule: TdxSpreadSheetConditionalFormattingCustomRule; override;
    //
    property Stops: TcxObjectList read FStops;
  public
    constructor Create(AOwner, AData: TObject); override;
    destructor Destroy; override;
    procedure OnAttributes(const AReader: TdxXmlReader); override;
  end;

  { TdxXLSXConditionalFormattingColorScaleRuleHandler }

  TdxXLSXConditionalFormattingColorScaleRuleHandler = class(TdxXLSXConditionalFormattingCustomScaleRuleHandler)
  strict private
    FColorIndex: Integer;

    function ProcessStopColor(const AReader: TdxXmlReader): TdxXMLNodeHandler;
  protected
    function GetRuleClass: TdxSpreadSheetConditionalFormattingCustomRuleClass; override;
  public
    constructor Create(AOwner, AData: TObject); override;
  end;

  { TdxXLSXConditionalFormattingDataBarRuleHandler }

  TdxXLSXConditionalFormattingDataBarRuleHandler = class(TdxXLSXConditionalFormattingCustomScaleRuleHandler)
  strict private
    function ProcessColor(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    function ProcessDataBarStyle(const AReader: TdxXmlReader): TdxXMLNodeHandler;
  protected
    FColor: TColor;
    FShowValue: TdxDefaultBoolean;

    procedure ApplyRuleSettings(ARule: TdxSpreadSheetConditionalFormattingCustomRule); override;
    function GetRuleClass: TdxSpreadSheetConditionalFormattingCustomRuleClass; override;
  public
    constructor Create(AOwner, AData: TObject); override;
  end;

  { TdxXLSXConditionalFormattingDataBarRuleExtensionHandler }

  TdxXLSXConditionalFormattingDataBarRuleExtensionHandler = class(TdxXLSXConditionalFormattingDataBarRuleHandler)
  strict private const
    IdColorAxis = 0;
    IdColorNegative = 3;
    IdColorNegativeBorder = 2;
    IdColorPositive = 4;
    IdColorPositiveBorder = 1;
  strict private
    FAxisPosition: TdxSpreadSheetConditionalFormattingRuleDataBarAxisPosition;
    FColors: array[0..4] of TColor;
    FDirection: TdxSpreadSheetConditionalFormattingRuleDataBarDirection;
    FFillMode: TdxSpreadSheetConditionalFormattingRuleDataBarFillMode;
    FHasBorders: Boolean;
    FNegativeBarBorderColorSameAsPositive: Boolean;
    FNegativeBarColorSameAsPositive: Boolean;

    function ProcessAxisColor(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    function ProcessColor(AColorIndex: Integer): TdxXLSXNodeHandler;
    function ProcessDataBarStyle(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    function ProcessNegativeBarBorderColor(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    function ProcessNegativeBarColor(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    function ProcessPositiveBarBorderColor(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    function ProcessPositiveBarColor(const AReader: TdxXmlReader): TdxXMLNodeHandler;
  protected
    procedure ApplyRuleSettings(ARule: TdxSpreadSheetConditionalFormattingCustomRule); override;
  public
    constructor Create(AOwner, AData: TObject); override;
    procedure AfterConstruction; override;
  end;

  { TdxXLSXConditionalFormattingIconSetRuleHandler }

  TdxXLSXConditionalFormattingIconSetRuleHandler = class(TdxXLSXConditionalFormattingCustomScaleRuleHandler)
  strict private
    FCustomSet: TStrings;
    FCustomSetUsed: Boolean;
    FPresetName: string;
    FReverseOrder: Boolean;
    FShowValue: TdxDefaultBoolean;
  protected
    procedure ApplyRuleSettings(ARule: TdxSpreadSheetConditionalFormattingCustomRule); override;
    function GetRuleClass: TdxSpreadSheetConditionalFormattingCustomRuleClass; override;
    function ProcessCustomIconSetEntry(const AReader: TdxXmlReader): TdxXMLNodeHandler;
    function ProcessIconSetSettings(const AReader: TdxXmlReader): TdxXMLNodeHandler;
  public
    constructor Create(AOwner, AData: TObject); override;
    destructor Destroy; override;
  end;

  { TdxXLSXConditionalFormattingIconSetRuleExtensionHandler }

  TdxXLSXConditionalFormattingIconSetRuleExtensionHandler = class(TdxXLSXConditionalFormattingIconSetRuleHandler)
  public
    constructor Create(AOwner, AData: TObject); override;
  end;

{ TdxXLSXConditionalFormattingScaleStop }

procedure TdxXLSXConditionalFormattingScaleStop.AssignTo(AStop: TdxSpreadSheetConditionalFormattingRuleCustomScaleStop);
const
  ComparisonOperatorMap: array[Boolean] of TdxSpreadSheetConditionalFormattingRuleIconSetStopComparisonOperator = (
    isscoGreaterThan, isscoGreaterThanOrEqual
  );
begin
  AStop.ValueType := ValueType;
  AStop.Value := Value;
  if AStop is TdxSpreadSheetConditionalFormattingRuleColorScaleStop then
    TdxSpreadSheetConditionalFormattingRuleColorScaleStop(AStop).Color := Color;
  if AStop is TdxSpreadSheetConditionalFormattingRuleIconSetStop then
    TdxSpreadSheetConditionalFormattingRuleIconSetStop(AStop).ComparisonOperator := ComparisonOperatorMap[GTE];
end;

{ TdxXLSXConditionalFormattingScaleStopHandler }

constructor TdxXLSXConditionalFormattingScaleStopHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  FStop := AData as TdxXLSXConditionalFormattingScaleStop;
  Handlers.Add(sdxXLSXNamespaceXM, sdxXLSXNodeFunction, ProcessExpression);
end;

procedure TdxXLSXConditionalFormattingScaleStopHandler.OnAttributes(const AReader: TdxXmlReader);
begin
  FValue := AReader.GetAttribute(sdxXLSXAttrVal);
  FValueType := TdxSpreadSheetXLSXHelper.StringToColorScaleStopValueType(AReader.GetAttribute(sdxXLSXAttrTypeLC));
  FStop.GTE := AReader.GetAttributeAsBoolean(sdxXLSXAttrGTE, True);
end;

procedure TdxXLSXConditionalFormattingScaleStopHandler.OnEnd;
var
  AValue: Variant;
  AValueAsDouble: Double;
  AValueType: TdxSpreadSheetConditionalFormattingRuleCustomScaleStopValueType;
begin
  inherited;

  AValueType := FValueType;
  case AValueType of
    cssvtFormula:
      AValue := FValue;
    cssvtPercent, cssvtPercentile:
      AValue := StrToIntDef(FValue, 0);
    cssvtValue:
      if TryStrToFloat(FValue, AValueAsDouble, dxInvariantFormatSettings) then
        AValue := AValueAsDouble
      else
      begin
        AValue := FValue;
        AValueType := cssvtFormula;
      end
  else
    AValue := Null;
  end;

  FStop.ValueType := AValueType;
  FStop.Value := AValue;
end;

procedure TdxXLSXConditionalFormattingScaleStopHandler.ProcessExpression(const S: string);
begin
  FValue := S;
end;

{ TdxXLSXConditionalFormattingExtensionsHandler }

constructor TdxXLSXConditionalFormattingExtensionsHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  FHandler := AData as TdxXLSXConditionalFormattingHandler;
  Handlers.Add(sdxXLSXNodeExt, Skip);
  Handlers.Add(sdxXLSXNamespaceX14, sdxXLSXNodeConditionalFormattings, Skip);
  Handlers.Add(sdxXLSXNamespaceX14, sdxXLSXNodeConditionalFormatting, ProcessConditionalFormattingExt);
end;

function TdxXLSXConditionalFormattingExtensionsHandler.ProcessConditionalFormattingExt(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  Result := FHandler;
end;

{ TdxXLSXConditionalFormattingHandler }

constructor TdxXLSXConditionalFormattingHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  FConditionalFormatting := AData as TdxSpreadSheetConditionalFormatting;
  FCurrentAreas := TdxSpreadSheetAreaList.Create;
  FCurrentRules := TList.Create;
  FRuleMap := TdxXLSXStringToObjectMap.Create;
  FRuleHandlers := TdxXMLNodeHandlers.Create;
  FRuleExtensionHandlers := TdxXMLNodeHandlers.Create;
  FRulePriorityList := TList.Create;
end;

destructor TdxXLSXConditionalFormattingHandler.Destroy;
begin
  FreeAndNil(FRuleHandlers);
  FreeAndNil(FRulePriorityList);
  FreeAndNil(FRuleExtensionHandlers);
  FreeAndNil(FCurrentAreas);
  FreeAndNil(FCurrentRules);
  FreeAndNil(FRuleMap);
  inherited;
end;

procedure TdxXLSXConditionalFormattingHandler.AfterConstruction;
begin
  inherited;
  Handlers.Add(sdxXLSXNodeConditionalFormattingRule, ProcessRule);
  Handlers.Add(sdxXLSXNamespaceX14, sdxXLSXNodeConditionalFormattingRule, ProcessRuleExt);
  Handlers.Add(sdxXLSXNamespaceXM, sdxXLSXNodeSqRef, ParseAreas);

  RuleHandlers.Add(sdxXLSXValueAboveAverage, TdxXLSXConditionalFormattingAboveAverageRuleHandler, Self);
  RuleHandlers.Add(sdxXLSXValueCellIs, TdxXLSXConditionalFormattingCellIsRuleHandler, Self);
  RuleHandlers.Add(sdxXLSXValueColorScale, TdxXLSXConditionalFormattingColorScaleRuleHandler, Self);
  RuleHandlers.Add(sdxXLSXValueExpression, TdxXLSXConditionalFormattingExpressionRuleHandler, Self);
  RuleHandlers.Add(sdxXLSXValueTop10, TdxXLSXConditionalFormattingTopBottomRuleHandler, Self);
  RuleHandlers.Add(sdxXLSXValueTypeDataBar, TdxXLSXConditionalFormattingDataBarRuleHandler, Self);
  RuleHandlers.Add(sdxXLSXValueTypeIconSet, TdxXLSXConditionalFormattingIconSetRuleHandler, Self);

  RuleHandlers.Add('beginsWith', TdxXLSXConditionalFormattingExpressionRuleHandler, Self);
  RuleHandlers.Add('containsText', TdxXLSXConditionalFormattingExpressionRuleHandler, Self);
  RuleHandlers.Add('duplicateValues', TdxXLSXConditionalFormattingDuplicateValuesRuleHandler, Self);
  RuleHandlers.Add('endsWith', TdxXLSXConditionalFormattingExpressionRuleHandler, Self);
  RuleHandlers.Add('notContainsBlanks', TdxXLSXConditionalFormattingExpressionRuleHandler, Self);
  RuleHandlers.Add('notContainsErrors', TdxXLSXConditionalFormattingExpressionRuleHandler, Self);
  RuleHandlers.Add('uniqueValues', TdxXLSXConditionalFormattingUniqueValuesRuleHandler, Self);

  RuleExtensionHandlers.Add(sdxXLSXValueTypeDataBar, TdxXLSXConditionalFormattingDataBarRuleExtensionHandler, Self);
  RuleExtensionHandlers.Add(sdxXLSXValueTypeIconSet, TdxXLSXConditionalFormattingIconSetRuleExtensionHandler, Self);
end;

procedure TdxXLSXConditionalFormattingHandler.BeforeDestruction;
var
  I: Integer;
begin
  inherited;

  RulePriorityList.Pack;
  for I := 0 to RulePriorityList.Count - 1 do
    TdxSpreadSheetCustomConditionalFormattingRule(RulePriorityList.List[I]).Index := I;
end;

procedure TdxXLSXConditionalFormattingHandler.OnAttributes(const AReader: TdxXmlReader);
begin
  CurrentAreas.Clear;
  CurrentRules.Clear;
  ParseAreas(AReader.GetAttribute(sdxXLSXAttrSqRef));
end;

procedure TdxXLSXConditionalFormattingHandler.OnEnd;
var
  I: Integer;
begin
  for I := 0 to CurrentRules.Count - 1 do
    TdxSpreadSheetCustomConditionalFormattingRule(CurrentRules.List[I]).Areas := FCurrentAreas;
end;

procedure TdxXLSXConditionalFormattingHandler.ParseAreas(const S: string);
var
  AArea: TRect;
  AList: TStringList;
  I: Integer;
begin
  AList := TStringList.Create;
  try
    AList.Delimiter := ' ';
    AList.DelimitedText := S;

    FCurrentAreas.Clear;
    FCurrentAreas.Capacity := AList.Count;
    for I := 0 to AList.Count - 1 do
    begin
      AArea := dxStringToReferenceArea(StringReplace(AList[I], '$', '', [rfReplaceAll]));
      if dxSpreadSheetIsValidArea(AArea) then
        FCurrentAreas.Add(AArea);
    end;
  finally
    AList.Free;
  end;
end;

function TdxXLSXConditionalFormattingHandler.ProcessRule(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  Result := RuleHandlers.CreateHandler(Owner, AReader, AReader.GetAttribute(sdxXLSXAttrTypeLC));
end;

function TdxXLSXConditionalFormattingHandler.ProcessRuleExt(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  Result := RuleExtensionHandlers.CreateHandler(Owner, AReader, AReader.GetAttribute(sdxXLSXAttrTypeLC));
end;

{ TdxXLSXConditionalFormattingCustomRuleHandler }

constructor TdxXLSXConditionalFormattingCustomRuleHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  FOwner := AData as TdxXLSXConditionalFormattingHandler;
end;

procedure TdxXLSXConditionalFormattingCustomRuleHandler.BeforeDestruction;
var
  ARule: TdxSpreadSheetConditionalFormattingCustomRule;
begin
  inherited;

  ARule := CreateRule;
  if ARule <> nil then
  begin
    ARule.BeginUpdate;
    try
      ApplyRuleSettings(ARule);
    finally
      ARule.EndUpdate;
    end;
    Owner.CurrentRules.Add(ARule);
  end;
end;

procedure TdxXLSXConditionalFormattingCustomRuleHandler.OnAttributes(const AReader: TdxXmlReader);
begin
  inherited;
  FPriority := AReader.GetAttributeAsInteger(sdxXLSXAttrPriority) - 1;
end;

procedure TdxXLSXConditionalFormattingCustomRuleHandler.ApplyRuleSettings(ARule: TdxSpreadSheetConditionalFormattingCustomRule);
begin
  ARule.Areas := Owner.CurrentAreas;
  if FPriority >= 0 then
  begin
    Owner.RulePriorityList.Count := Max(Owner.RulePriorityList.Count, FPriority + 1);
    Owner.RulePriorityList.Items[FPriority] := ARule;
  end;
end;

function TdxXLSXConditionalFormattingCustomRuleHandler.CreateRule: TdxSpreadSheetConditionalFormattingCustomRule;
var
  ARuleClass: TdxSpreadSheetConditionalFormattingCustomRuleClass;
begin
  ARuleClass := GetRuleClass;
  if ARuleClass <> nil then
    Result := ARuleClass.Create(Owner.ConditionalFormatting)
  else
    Result := nil;
end;

{ TdxXLSXConditionalFormattingStyleBasedRuleHandler }

constructor TdxXLSXConditionalFormattingStyleBasedRuleHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  FConditionalFormattingStyles := Owner.Owner.Owner.ConditionalFormattingStyles;
end;

procedure TdxXLSXConditionalFormattingStyleBasedRuleHandler.ApplyRuleSettings(ARule: TdxSpreadSheetConditionalFormattingCustomRule);
var
  AStyleBasedRule: TdxSpreadSheetConditionalFormattingRuleStyleBased absolute ARule;
begin
  inherited;
  AStyleBasedRule.StopIfTrue := FStopIfTrue;
  if (FStyleIndex >= 0) and (FStyleIndex < ConditionalFormattingStyles.Count) then
    AStyleBasedRule.Style.Handle := TdxSpreadSheetCellStyleHandle(ConditionalFormattingStyles[FStyleIndex]);
end;

procedure TdxXLSXConditionalFormattingStyleBasedRuleHandler.OnAttributes(const AReader: TdxXmlReader);
begin
  inherited;
  FStopIfTrue := AReader.GetAttributeAsBoolean(sdxXLSXAttrStopIfTrue);
  FStyleIndex := AReader.GetAttributeAsInteger(sdxXLSXAttrDfxID, -1);
end;

{ TdxXLSXConditionalFormattingExpressionRuleHandler }

constructor TdxXLSXConditionalFormattingExpressionRuleHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  FExpressions := TStringList.Create;
  FExpressions.Capacity := 2;
end;

destructor TdxXLSXConditionalFormattingExpressionRuleHandler.Destroy;
begin
  FreeAndNil(FExpressions);
  inherited;
end;

procedure TdxXLSXConditionalFormattingExpressionRuleHandler.AfterConstruction;
begin
  inherited;
  Handlers.Add(sdxXLSXNodeFormula, ProcessExpression);
end;

procedure TdxXLSXConditionalFormattingExpressionRuleHandler.ApplyRuleSettings(
  ARule: TdxSpreadSheetConditionalFormattingCustomRule);
begin
  inherited;
  if FExpressions.Count > 0 then
    TdxSpreadSheetConditionalFormattingRuleExpression(ARule).Expression := FExpressions[0];
end;

function TdxXLSXConditionalFormattingExpressionRuleHandler.GetRuleClass: TdxSpreadSheetConditionalFormattingCustomRuleClass;
begin
  Result := TdxSpreadSheetConditionalFormattingRuleExpression;
end;

procedure TdxXLSXConditionalFormattingExpressionRuleHandler.ProcessExpression(const S: string);
begin
  FExpressions.Add(S);
end;

{ TdxXLSXConditionalFormattingCellIsRuleHandler }

function TdxXLSXConditionalFormattingCellIsRuleHandler.GetRuleClass: TdxSpreadSheetConditionalFormattingCustomRuleClass;
begin
  Result := TdxSpreadSheetConditionalFormattingRuleCellIs;
end;

procedure TdxXLSXConditionalFormattingCellIsRuleHandler.ApplyRuleSettings(
  ARule: TdxSpreadSheetConditionalFormattingCustomRule);
begin
  inherited;
  TdxSpreadSheetConditionalFormattingRuleCellIs(ARule).ComparisonOperator := FOperator;
  if FExpressions.Count > 1 then
    TdxSpreadSheetConditionalFormattingRuleCellIs(ARule).Expression2 := FExpressions[1];
end;

procedure TdxXLSXConditionalFormattingCellIsRuleHandler.OnAttributes(const AReader: TdxXmlReader);
begin
  inherited;
  FOperator := TdxSpreadSheetXLSXHelper.StringToCfCellIsRuleOperator(AReader.GetAttribute(sdxXLSXAttrOperator));
end;

{ TdxXLSXConditionalFormattingAboveAverageRuleHandler }

procedure TdxXLSXConditionalFormattingAboveAverageRuleHandler.ApplyRuleSettings(
  ARule: TdxSpreadSheetConditionalFormattingCustomRule);
begin
  inherited;
  TdxSpreadSheetConditionalFormattingRuleAboveOrBelowAverage(ARule).ComparisonOperator := FOperator;
  TdxSpreadSheetConditionalFormattingRuleAboveOrBelowAverage(ARule).StandardDeviationLevel := FStandardDeviationLevel;
end;

function TdxXLSXConditionalFormattingAboveAverageRuleHandler.GetRuleClass: TdxSpreadSheetConditionalFormattingCustomRuleClass;
begin
  Result := TdxSpreadSheetConditionalFormattingRuleAboveOrBelowAverage;
end;

procedure TdxXLSXConditionalFormattingAboveAverageRuleHandler.OnAttributes(const AReader: TdxXmlReader);

  function DecodeComparisonOperator(AIsAbove, AIsEquals: Boolean): TdxSpreadSheetConditionalFormattingRuleAboveOrBelowAverageComparisonOperator;
  const
    Map: array[Boolean, Boolean] of TdxSpreadSheetConditionalFormattingRuleAboveOrBelowAverageComparisonOperator = (
      (abacoBelowAverage, abacoAboveAverage),
      (abacoBelowOrEqualAverage, abacoAboveOrEqualAverage)
    );
  var
    AValue: string;
  begin
    if AReader.TryGetAttribute(sdxXLSXAttrStdDev, AValue) then
    begin
      if AIsAbove then
        Result := abacoAboveAverageOnStandardDeviation
      else
        Result := abacoBelowAverageOnStandardDeviation
    end
    else
      Result := Map[AIsEquals, AIsAbove];
  end;

begin
  inherited;
  FOperator := DecodeComparisonOperator(
    AReader.GetAttributeAsBoolean(sdxXLSXAttrAboveAverage, True),
    AReader.GetAttributeAsBoolean(sdxXLSXAttrEqualAverage, False));
  FStandardDeviationLevel := AReader.GetAttributeAsInteger(sdxXLSXAttrStdDev, 1);
end;

{ TdxXLSXConditionalFormattingDuplicateValuesRuleHandler }

function TdxXLSXConditionalFormattingDuplicateValuesRuleHandler.GetRuleClass: TdxSpreadSheetConditionalFormattingCustomRuleClass;
begin
  Result := TdxSpreadSheetConditionalFormattingRuleDuplicateValues;
end;

{ TdxXLSXConditionalFormattingUniqueValuesRuleHandler }

function TdxXLSXConditionalFormattingUniqueValuesRuleHandler.GetRuleClass: TdxSpreadSheetConditionalFormattingCustomRuleClass;
begin
  Result := TdxSpreadSheetConditionalFormattingRuleUniqueValues;
end;

{ TdxXLSXConditionalFormattingTopBottomRuleHandler }

procedure TdxXLSXConditionalFormattingTopBottomRuleHandler.ApplyRuleSettings(
  ARule: TdxSpreadSheetConditionalFormattingCustomRule);
var
  ATopBottomRule: TdxSpreadSheetConditionalFormattingRuleTopBottomValues absolute ARule;
begin
  inherited;

  if FBottom then
    ATopBottomRule.Direction := tbvdBottom
  else
    ATopBottomRule.Direction := tbvdTop;

  if FPercents then
    ATopBottomRule.ValueType := tbvvtPercent
  else
    ATopBottomRule.ValueType := tbvvtRank;

  ATopBottomRule.Value := FRank;
end;

function TdxXLSXConditionalFormattingTopBottomRuleHandler.GetRuleClass: TdxSpreadSheetConditionalFormattingCustomRuleClass;
begin
  Result := TdxSpreadSheetConditionalFormattingRuleTopBottomValues;
end;

procedure TdxXLSXConditionalFormattingTopBottomRuleHandler.OnAttributes(const AReader: TdxXmlReader);
begin
  inherited;
  FRank := AReader.GetAttributeAsInteger(sdxXLSXAttrRank, 10);
  FBottom := AReader.GetAttributeAsBoolean(sdxXLSXAttrBottom);
  FPercents := AReader.GetAttributeAsBoolean(sdxXLSXAttrPercent);
end;

{ TdxXLSXConditionalFormattingCustomScaleRuleHandler }

constructor TdxXLSXConditionalFormattingCustomScaleRuleHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  FStops := TcxObjectList.Create;
  Handlers.Add(sdxXLSXNamespaceX14, sdxXLSXNodeCFVO, ProcessStop);
  Handlers.Add(sdxXLSXNodeCFVO, ProcessStop);
  Handlers.Add(sdxXLSXNodeExt, Skip);
  Handlers.Add(sdxXLSXNodeExtList, Skip);
  Handlers.Add(sdxXLSXNamespaceX14, sdxXLSXAttrIdLC, ProcessExtensionId);
end;

destructor TdxXLSXConditionalFormattingCustomScaleRuleHandler.Destroy;
begin
  FreeAndNil(FStops);
  inherited;
end;

procedure TdxXLSXConditionalFormattingCustomScaleRuleHandler.OnAttributes(const AReader: TdxXmlReader);
begin
  inherited;
  FRuleId := AReader.GetAttribute(sdxXLSXAttrIdLC);
end;

procedure TdxXLSXConditionalFormattingCustomScaleRuleHandler.ApplyRuleSettings(
  ARule: TdxSpreadSheetConditionalFormattingCustomRule);
var
  AScaleRule: TdxSpreadSheetConditionalFormattingRuleCustomScaleAccess absolute ARule;
  I: Integer;
begin
  inherited;
  for I := 0 to Min(Stops.Count, AScaleRule.StopCount) - 1 do
    TdxXLSXConditionalFormattingScaleStop(Stops.List[I]).AssignTo(AScaleRule.FStops[I]);
  if FExtensionId <> '' then
    Owner.RuleMap.Add(FExtensionId, ARule);
end;

function TdxXLSXConditionalFormattingCustomScaleRuleHandler.CreateRule: TdxSpreadSheetConditionalFormattingCustomRule;
begin
  if (FRuleId <> '') and Owner.RuleMap.TryGetValue(FRuleID, TObject(Result)) then
  begin
    if Result.InheritsFrom(GetRuleClass) then
      Exit;
    Owner.DoError(sdxErrorInvalidReference, [FRuleID, -1], ssmtError);
  end;
  Result := inherited CreateRule;
end;

procedure TdxXLSXConditionalFormattingCustomScaleRuleHandler.ProcessExtensionId(const S: string);
begin
  FExtensionId := S;
end;

function TdxXLSXConditionalFormattingCustomScaleRuleHandler.ProcessStop(const AReader: TdxXmlReader): TdxXMLNodeHandler;
var
  AStop: TdxXLSXConditionalFormattingScaleStop;
begin
  AStop := TdxXLSXConditionalFormattingScaleStop.Create;
  FStops.Add(AStop);
  Result := TdxXLSXConditionalFormattingScaleStopHandler.Create(Owner.Owner, AStop);
end;

{ TdxXLSXConditionalFormattingColorScaleRuleHandler }

constructor TdxXLSXConditionalFormattingColorScaleRuleHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  Handlers.Add(sdxXLSXNodeColor, ProcessStopColor);
  Handlers.Add(sdxXLSXNodeColorScale, Skip);
end;

function TdxXLSXConditionalFormattingColorScaleRuleHandler.GetRuleClass: TdxSpreadSheetConditionalFormattingCustomRuleClass;
begin
  case Stops.Count of
    2: Result := TdxSpreadSheetConditionalFormattingRuleTwoColorScale;
    3: Result := TdxSpreadSheetConditionalFormattingRuleThreeColorScale;
  else
    Result := nil;
  end;
end;

function TdxXLSXConditionalFormattingColorScaleRuleHandler.ProcessStopColor(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  if FColorIndex < Stops.Count then
    Result := TdxXLSXColorHandler.Create(Owner.Owner, @TdxXLSXConditionalFormattingScaleStop(Stops.List[FColorIndex]).Color)
  else
    Result := nil;

  Inc(FColorIndex);
end;

{ TdxXLSXConditionalFormattingDataBarRuleHandler }

constructor TdxXLSXConditionalFormattingDataBarRuleHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  FColor := clDefault;
  FShowValue := bDefault;
  Handlers.Add(sdxXLSXNodeColor, ProcessColor);
  Handlers.Add(sdxXLSXNodeFillColor, ProcessColor);
  Handlers.Add(sdxXLSXNodeDataBar, ProcessDataBarStyle);
end;

function TdxXLSXConditionalFormattingDataBarRuleHandler.GetRuleClass: TdxSpreadSheetConditionalFormattingCustomRuleClass;
begin
  Result := TdxSpreadSheetConditionalFormattingRuleDataBar;
end;

procedure TdxXLSXConditionalFormattingDataBarRuleHandler.ApplyRuleSettings(
  ARule: TdxSpreadSheetConditionalFormattingCustomRule);
begin
  inherited;
  if FShowValue <> bDefault then
    TdxSpreadSheetConditionalFormattingRuleDataBar(ARule).ShowValue := FShowValue = bTrue;
  if FColor <> clDefault then
    TdxSpreadSheetConditionalFormattingRuleDataBar(ARule).Style.PositiveBarColor := FColor;
end;

function TdxXLSXConditionalFormattingDataBarRuleHandler.ProcessColor(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  Result := TdxXLSXColorHandler.Create(Owner.Owner, @FColor);
end;

function TdxXLSXConditionalFormattingDataBarRuleHandler.ProcessDataBarStyle(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  FShowValue := AReader.GetAttributeAsDefaultBoolean(sdxXLSXAttrShowValue);
  Result := Skip(AReader);
end;

{ TdxXLSXConditionalFormattingDataBarRuleExtensionHandler }

constructor TdxXLSXConditionalFormattingDataBarRuleExtensionHandler.Create(AOwner, AData: TObject);
var
  I: Integer;
begin
  inherited;
  for I := Low(FColors) to High(FColors) do
    FColors[I] := clDefault;
end;

procedure TdxXLSXConditionalFormattingDataBarRuleExtensionHandler.AfterConstruction;
begin
  inherited;
  Handlers.Add(sdxXLSXNamespaceX14, sdxXLSXNodeAxisColor, ProcessAxisColor);
  Handlers.Add(sdxXLSXNamespaceX14, sdxXLSXNodeBorderColor, ProcessPositiveBarBorderColor);
  Handlers.Add(sdxXLSXNamespaceX14, sdxXLSXNodeColor, ProcessPositiveBarColor);
  Handlers.Add(sdxXLSXNamespaceX14, sdxXLSXNodeDataBar, ProcessDataBarStyle);
  Handlers.Add(sdxXLSXNamespaceX14, sdxXLSXNodeFillColor, ProcessPositiveBarColor);
  Handlers.Add(sdxXLSXNamespaceX14, sdxXLSXNodeNegativeBorderColor, ProcessNegativeBarBorderColor);
  Handlers.Add(sdxXLSXNamespaceX14, sdxXLSXNodeNegativeFillColor, ProcessNegativeBarColor);
end;

procedure TdxXLSXConditionalFormattingDataBarRuleExtensionHandler.ApplyRuleSettings(ARule: TdxSpreadSheetConditionalFormattingCustomRule);
var
  ADataBarRule: TdxSpreadSheetConditionalFormattingRuleDataBar absolute ARule;
begin
  inherited;
  ADataBarRule.Style.AxisPosition := FAxisPosition;
  ADataBarRule.Style.Direction := FDirection;
  ADataBarRule.Style.FillMode := FFillMode;
  if FColors[IdColorAxis] <> clDefault then
    ADataBarRule.Style.AxisColor := FColors[IdColorAxis];
  if FColors[IdColorPositive] <> clDefault then
    ADataBarRule.Style.PositiveBarColor := FColors[IdColorPositive];
  if FColors[IdColorPositiveBorder] <> clDefault then
    ADataBarRule.Style.PositiveBarBorderColor := FColors[IdColorPositiveBorder];
  if FColors[IdColorNegative] <> clDefault then
    ADataBarRule.Style.NegativeBarColor := FColors[IdColorNegative];
  if FColors[IdColorNegativeBorder] <> clDefault then
    ADataBarRule.Style.NegativeBarBorderColor := FColors[IdColorNegativeBorder];
  if FNegativeBarColorSameAsPositive then
    ADataBarRule.Style.NegativeBarColor := clDefault;
  if FNegativeBarBorderColorSameAsPositive then
    ADataBarRule.Style.NegativeBarBorderColor := clDefault;
  if not FHasBorders then
  begin
    ADataBarRule.Style.NegativeBarBorderColor := clDefault;
    ADataBarRule.Style.PositiveBarBorderColor := clNone;
  end;
end;

function TdxXLSXConditionalFormattingDataBarRuleExtensionHandler.ProcessAxisColor(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  Result := ProcessColor(IdColorAxis);
end;

function TdxXLSXConditionalFormattingDataBarRuleExtensionHandler.ProcessColor(AColorIndex: Integer): TdxXLSXNodeHandler;
begin
  Result := TdxXLSXColorHandler.Create(Owner.Owner, @FColors[AColorIndex]);
end;

function TdxXLSXConditionalFormattingDataBarRuleExtensionHandler.ProcessDataBarStyle(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  FNegativeBarColorSameAsPositive := AReader.GetAttributeAsBoolean(sdxXLSXAttrNegativeBarColorSameAsPositive);
  FNegativeBarBorderColorSameAsPositive := AReader.GetAttributeAsBoolean(sdxXLSXAttrNegativeBarBorderColorSameAsPositive, True);
  FHasBorders := AReader.GetAttributeAsBoolean(sdxXLSXAttrBorder);
  FShowValue := AReader.GetAttributeAsDefaultBoolean(sdxXLSXAttrShowValue);
  FAxisPosition := TdxSpreadSheetXLSXHelper.StringToAxisPosition(AReader.GetAttribute(sdxXLSXAttrAxisPosition));
  FDirection := TdxSpreadSheetXLSXHelper.StringToDataBarDirection(AReader.GetAttribute(sdxXLSXAttrDirection));

  if AReader.GetAttributeAsBoolean(sdxXLSXAttrGradient, True) then
    FFillMode := dbfmGradient
  else
    FFillMode := dbfmSolid;

  Result := Skip(AReader);
end;

function TdxXLSXConditionalFormattingDataBarRuleExtensionHandler.ProcessPositiveBarBorderColor(
  const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  Result := ProcessColor(IdColorPositiveBorder);
end;

function TdxXLSXConditionalFormattingDataBarRuleExtensionHandler.ProcessNegativeBarBorderColor(
  const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  Result := ProcessColor(IdColorNegativeBorder);
end;

function TdxXLSXConditionalFormattingDataBarRuleExtensionHandler.ProcessNegativeBarColor(
  const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  Result := ProcessColor(IdColorNegative);
end;

function TdxXLSXConditionalFormattingDataBarRuleExtensionHandler.ProcessPositiveBarColor(
  const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  Result := ProcessColor(IdColorPositive);
end;

{ TdxXLSXConditionalFormattingIconSetRuleHandler }

constructor TdxXLSXConditionalFormattingIconSetRuleHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  FShowValue := bDefault;
  FCustomSet := TStringList.Create;
  Handlers.Add(sdxXLSXNodeIconSet, ProcessIconSetSettings);
  Handlers.Add(sdxXLSXNodeCFIcon, ProcessCustomIconSetEntry);
end;

destructor TdxXLSXConditionalFormattingIconSetRuleHandler.Destroy;
begin
  FreeAndNil(FCustomSet);
  inherited;
end;

procedure TdxXLSXConditionalFormattingIconSetRuleHandler.ApplyRuleSettings(
  ARule: TdxSpreadSheetConditionalFormattingCustomRule);
const
  OrderMap: array[Boolean] of TdxSpreadSheetConditionalFormattingRuleIconSetOrder = (isioNormal, isioReversed);
var
  AIconSetPreset: TdxSpreadSheetConditionalFormattingIconSetPreset;
  AIconSetRule: TdxSpreadSheetConditionalFormattingRuleIconSet absolute ARule;
  I: Integer;
begin
  AIconSetRule.PresetName := FPresetName;
  AIconSetRule.Order := OrderMap[FReverseOrder];

  inherited;

  if FShowValue <> bDefault then
    AIconSetRule.ShowValue := FShowValue = bTrue;

  if FCustomSetUsed then
  begin
    for I := 0 to Min(AIconSetRule.StopCount, FCustomSet.Count) - 1 do
    begin
      if ConditionalFormattingIconSet.Presets.FindByName(FCustomSet.Names[I], AIconSetPreset) then
        AIconSetRule.Stops[I].IconIndex := AIconSetPreset.IconIndexes[StrToIntDef(FCustomSet.ValueFromIndex[I], 0)];
    end;
  end;
end;

function TdxXLSXConditionalFormattingIconSetRuleHandler.GetRuleClass: TdxSpreadSheetConditionalFormattingCustomRuleClass;
begin
  Result := TdxSpreadSheetConditionalFormattingRuleIconSet;
end;

function TdxXLSXConditionalFormattingIconSetRuleHandler.ProcessCustomIconSetEntry(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  FCustomSet.Add(AReader.GetAttribute(sdxXLSXAttrIconSet) + FCustomSet.NameValueSeparator + AReader.GetAttribute(sdxXLSXAttrIconId));
  Result := nil;
end;

function TdxXLSXConditionalFormattingIconSetRuleHandler.ProcessIconSetSettings(const AReader: TdxXmlReader): TdxXMLNodeHandler;
begin
  FReverseOrder := AReader.GetAttributeAsBoolean(sdxXLSXAttrReverse);
  FCustomSetUsed := AReader.GetAttributeAsBoolean(sdxXLSXAttrCustom);
  FShowValue := AReader.GetAttributeAsDefaultBoolean(sdxXLSXAttrShowValue);
  if not AReader.TryGetAttribute(sdxXLSXAttrIconSet, FPresetName) then
    FPresetName := '3TrafficLights1';
  Result := Skip(AReader);
end;

{ TdxXLSXConditionalFormattingIconSetRuleExtensionHandler }

constructor TdxXLSXConditionalFormattingIconSetRuleExtensionHandler.Create(AOwner, AData: TObject);
begin
  inherited;
  Handlers.Add(sdxXLSXNamespaceX14, sdxXLSXNodeIconSet, ProcessIconSetSettings);
  Handlers.Add(sdxXLSXNamespaceX14, sdxXLSXNodeCFIcon, ProcessCustomIconSetEntry);
end;

end.
