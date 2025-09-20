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

unit dxSpreadSheetFormatXLSXWriterConditionalFormatting;

{$I cxVer.inc}

interface

uses
  System.UITypes,
  Variants, Types, Windows, SysUtils, Classes, Graphics, dxCore, dxCoreClasses, cxClasses, dxCustomTree,
  dxXMLDoc, dxZIPUtils,
  dxSpreadSheetCore, dxSpreadSheetTypes, dxSpreadSheetClasses, dxSpreadSheetStrs, dxSpreadSheetPackedFileFormatCore,
  dxSpreadSheetUtils, dxSpreadSheetGraphics, Generics.Defaults, Generics.Collections, dxGDIPlusClasses, dxCoreGraphics, cxGeometry,
  dxSpreadSheetPrinting, dxSpreadSheetConditionalFormattingRules, dxSpreadSheetContainers, dxSpreadSheetFormatXLSXWriter,
  dxSpreadSheetConditionalFormatting, dxXMLWriter, dxGenerics;

type

  { TdxXLSXWriterWorksheetConditionalFormattingCustomRuleBuilder }

  TdxXLSXWriterWorksheetConditionalFormattingCustomRuleBuilderClass = class of TdxXLSXWriterWorksheetConditionalFormattingCustomRuleBuilder;
  TdxXLSXWriterWorksheetConditionalFormattingCustomRuleBuilder = class(TdxSpreadSheetCustomFilerSubTask)
  strict private
    FNamePrefix: string;
    FRule: TdxSpreadSheetCustomConditionalFormattingRule;
    FWriter: TdxXmlWriter;

    function GetConditionalFormattingStyles: TdxXLSXWriterResourceList;
    function GetOwner: TdxSpreadSheetXLSXWriter;
  protected
    procedure AddColorNode(const ANodeName: string; AColor: TColor);
    function GetRuleStyleID(out ID: Integer): Boolean; virtual;
    function GetRuleType: TdxXMLString; virtual; abstract;
  public
    constructor Create(AOwner: TdxSpreadSheetCustomFiler; AWriter: TdxXmlWriter;
      ARule: TdxSpreadSheetCustomConditionalFormattingRule; const ANamePrefix: string); virtual;
    procedure Execute; override; final;
    procedure WriteAttributes; virtual;
    procedure WriteChildren; virtual;
    //
    property ConditionalFormattingStyles: TdxXLSXWriterResourceList read GetConditionalFormattingStyles;
    property NamePrefix: string read FNamePrefix;
    property Owner: TdxSpreadSheetXLSXWriter read GetOwner;
    property Rule: TdxSpreadSheetCustomConditionalFormattingRule read FRule;
    property Writer: TdxXmlWriter read FWriter;
  end;

  { TdxXLSXWriterWorksheetConditionalFormattingBuilder }

  TdxXLSXWriterWorksheetConditionalFormattingBuilder = class(TdxSpreadSheetCustomFilerSubTask)
  strict private
    FConditionalFormatting: TdxSpreadSheetCustomConditionalFormatting;
    FWriter: TdxXmlWriter;

    function GetRule(Index: Integer): TdxSpreadSheetCustomConditionalFormattingRule;
    function GetRuleCount: Integer;
  protected
    FRuleBuilders: TdxClassDictionary<TdxXLSXWriterWorksheetConditionalFormattingCustomRuleBuilderClass>;

    function EncodeReferences(AAreas: TdxSpreadSheetAreaList): string;
    function IsCustomFormattedRule(ARule: TdxSpreadSheetCustomConditionalFormattingRule): Boolean;
    function IsExtraIconSetPreset(const APresetName: string): Boolean;
    function IsValidRule(ARule: TdxSpreadSheetCustomConditionalFormattingRule): Boolean;
    procedure RegisterRulesBuilders; virtual;
  public
    constructor Create(AOwner: TdxSpreadSheetCustomFiler; AWriter: TdxXmlWriter;
      AConditionalFormatting: TdxSpreadSheetCustomConditionalFormatting);
    destructor Destroy; override;
    procedure Execute; override;
    //
    property RuleCount: Integer read GetRuleCount;
    property Rules[Index: Integer]: TdxSpreadSheetCustomConditionalFormattingRule read GetRule;
    property Writer: TdxXmlWriter read FWriter;
  end;

  { TdxXLSXWriterWorksheetConditionalFormattingExBuilder }

  TdxXLSXWriterWorksheetConditionalFormattingExBuilder = class(
    TdxXLSXWriterWorksheetConditionalFormattingBuilder)
  protected
    procedure RegisterRulesBuilders; override;
  public
    procedure Execute; override;
  end;

  { TdxXLSXWriterWorksheetConditionalFormattingStyleBasedRuleBuilder }

  TdxXLSXWriterWorksheetConditionalFormattingStyleBasedRuleBuilder = class(
    TdxXLSXWriterWorksheetConditionalFormattingCustomRuleBuilder)
  protected
    function GetRuleStyleID(out ID: Integer): Boolean; override;
  end;

  { TdxXLSXWriterConditionalFormattingAboveAverageRuleBuilder }

  TdxXLSXWriterConditionalFormattingAboveAverageRuleBuilder = class(
    TdxXLSXWriterWorksheetConditionalFormattingStyleBasedRuleBuilder)
  strict private
    function GetRule: TdxSpreadSheetConditionalFormattingRuleAboveOrBelowAverage;
  protected
    function GetRuleType: TdxXMLString; override;
  public
    procedure WriteAttributes; override;
    //
    property Rule: TdxSpreadSheetConditionalFormattingRuleAboveOrBelowAverage read GetRule;
  end;

  { TdxXLSXWriterWorksheetConditionalFormattingExpressionRuleBuilder }

  TdxXLSXWriterWorksheetConditionalFormattingExpressionRuleBuilder = class(
    TdxXLSXWriterWorksheetConditionalFormattingStyleBasedRuleBuilder)
  strict private
    function GetRule: TdxSpreadSheetConditionalFormattingRuleExpression;
  protected
    function GetRuleType: TdxXMLString; override;
  public
    procedure WriteChildren; override;
    //
    property Rule: TdxSpreadSheetConditionalFormattingRuleExpression read GetRule;
  end;

  { TdxXLSXWriterWorksheetConditionalFormattingCellIsRuleBuilder }

  TdxXLSXWriterWorksheetConditionalFormattingCellIsRuleBuilder = class(
    TdxXLSXWriterWorksheetConditionalFormattingExpressionRuleBuilder)
  strict private
    function GetRule: TdxSpreadSheetConditionalFormattingRuleCellIs;
  protected
    function GetRuleType: TdxXMLString; override;
  public
    procedure WriteAttributes; override;
    //
    property Rule: TdxSpreadSheetConditionalFormattingRuleCellIs read GetRule;
  end;

  { TdxXLSXWriterWorksheetConditionalFormattingColorScaleBuilder }

  TdxXLSXWriterWorksheetConditionalFormattingColorScaleBuilder = class(
    TdxXLSXWriterWorksheetConditionalFormattingCustomRuleBuilder)
  strict private
    function GetRule: TdxSpreadSheetConditionalFormattingRuleCustomColorScale;
    function GetStop(Index: Integer): TdxSpreadSheetConditionalFormattingRuleColorScaleStop;
    function GetStopCount: Integer;
  protected
    function GetRuleType: TdxXMLString; override;
    procedure WriteStop(AStop: TdxSpreadSheetConditionalFormattingRuleColorScaleStop);
  public
    procedure WriteChildren; override;
    //
    property Rule: TdxSpreadSheetConditionalFormattingRuleCustomColorScale read GetRule;
    property StopCount: Integer read GetStopCount;
    property Stops[Index: Integer]: TdxSpreadSheetConditionalFormattingRuleColorScaleStop read GetStop;
  end;

  { TdxXLSXWriterWorksheetConditionalFormattingDuplicateValuesRuleBuilder }

  TdxXLSXWriterWorksheetConditionalFormattingDuplicateValuesRuleBuilder = class(
    TdxXLSXWriterWorksheetConditionalFormattingStyleBasedRuleBuilder)
  protected
    function GetRuleType: TdxXMLString; override;
  end;

  { TdxXLSXWriterWorksheetConditionalFormattingDataBarRuleBuilder }

  TdxXLSXWriterWorksheetConditionalFormattingDataBarRuleBuilder = class(
    TdxXLSXWriterWorksheetConditionalFormattingCustomRuleBuilder)
  strict private
    function GetRule: TdxSpreadSheetConditionalFormattingRuleDataBar;
  protected
    function GetRuleType: TdxXMLString; override;
    procedure WriteStop(AStop: TdxSpreadSheetConditionalFormattingRuleCustomScaleStop);
  public
    procedure WriteChildren; override;
    //
    property Rule: TdxSpreadSheetConditionalFormattingRuleDataBar read GetRule;
  end;

  { TdxXLSXWriterWorksheetConditionalFormattingIconSetRuleBuilder }

  TdxXLSXWriterWorksheetConditionalFormattingIconSetRuleBuilder = class(
    TdxXLSXWriterWorksheetConditionalFormattingCustomRuleBuilder)
  strict private
    function EncodeValue(const AStop: TdxSpreadSheetConditionalFormattingRuleIconSetStop): string;
    function GetPresetName: string;
    function GetRule: TdxSpreadSheetConditionalFormattingRuleIconSet;
  protected
    function GetRuleType: TdxXMLString; override;
    procedure WriteStop(AStop: TdxSpreadSheetConditionalFormattingRuleIconSetStop);
    procedure WriteStopCustomIcon(AStop: TdxSpreadSheetConditionalFormattingRuleIconSetStop);
  public
    procedure WriteChildren; override;
    //
    property Rule: TdxSpreadSheetConditionalFormattingRuleIconSet read GetRule;
  end;

  { TdxXLSXWriterConditionalFormattingTopBottomRuleBuilder }

  TdxXLSXWriterConditionalFormattingTopBottomRuleBuilder = class(
    TdxXLSXWriterWorksheetConditionalFormattingStyleBasedRuleBuilder)
  strict private
    function GetRule: TdxSpreadSheetConditionalFormattingRuleTopBottomValues;
  protected
    function GetRuleType: TdxXMLString; override;
  public
    procedure WriteAttributes; override;
    //
    property Rule: TdxSpreadSheetConditionalFormattingRuleTopBottomValues read GetRule;
  end;

  { TdxXLSXWriterWorksheetConditionalFormattingUniqueValuesRuleBuilder }

  TdxXLSXWriterWorksheetConditionalFormattingUniqueValuesRuleBuilder = class(
    TdxXLSXWriterWorksheetConditionalFormattingStyleBasedRuleBuilder)
  protected
    function GetRuleType: TdxXMLString; override;
  end;

implementation

uses
  AnsiStrings, Math, TypInfo, StrUtils, dxColorPicker, cxGraphics, dxHashUtils, dxTypeHelpers,
  dxSpreadSheetFormulas, dxSpreadSheetFormatXLSXTags, dxSpreadSheetFormatXLSX, dxSpreadSheetFormatUtils,
  dxSpreadSheetConditionalFormattingIconSet, dxSpreadSheetCoreFormulasParser, dxSpreadSheetCoreStrs;

const
  dxThisUnitName = 'dxSpreadSheetFormatXLSXWriterConditionalFormatting';

type
  TdxSpreadSheetConditionalFormattingRuleCustomColorScaleAccess = class(TdxSpreadSheetConditionalFormattingRuleCustomColorScale);

{ TdxXLSXWriterWorksheetConditionalFormattingCustomRuleBuilder }

constructor TdxXLSXWriterWorksheetConditionalFormattingCustomRuleBuilder.Create(
  AOwner: TdxSpreadSheetCustomFiler; AWriter: TdxXmlWriter;
  ARule: TdxSpreadSheetCustomConditionalFormattingRule; const ANamePrefix: string);
begin
  inherited Create(AOwner);
  FNamePrefix := ANamePrefix;
  FWriter := AWriter;
  FRule := ARule;
end;

procedure TdxXLSXWriterWorksheetConditionalFormattingCustomRuleBuilder.Execute;
begin
  Writer.WriteStartElement(FNamePrefix, sdxXLSXNodeConditionalFormattingRule, '');
  try
    if NamePrefix <> '' then
      Writer.WriteAttributeString('id', dxGenerateGUID);
    WriteAttributes;
    WriteChildren;
  finally
    Writer.WriteEndElement;
  end;
end;

procedure TdxXLSXWriterWorksheetConditionalFormattingCustomRuleBuilder.WriteAttributes;
var
  APropInfo: PPropInfo;
  ID: Integer;
begin
  Writer.WriteAttributeString(sdxXLSXAttrTypeLC, GetRuleType);
  if GetRuleStyleID(ID) then
    Writer.WriteAttributeInteger(sdxXLSXAttrDfxID, ID);
  Writer.WriteAttributeInteger(sdxXLSXAttrPriority, Rule.Index + 1);

  APropInfo := GetPropInfo(Rule, 'StopIfTrue');
  if (APropInfo <> nil) and (GetOrdProp(Rule, APropInfo) <> 0) then
    Writer.WriteAttributeBoolean(sdxXLSXAttrStopIfTrue, True);
end;

procedure TdxXLSXWriterWorksheetConditionalFormattingCustomRuleBuilder.WriteChildren;
begin
  // do nothing
end;

procedure TdxXLSXWriterWorksheetConditionalFormattingCustomRuleBuilder.AddColorNode(const ANodeName: string; AColor: TColor);
begin
  if cxColorIsValid(AColor) then
  begin
    Writer.WriteStartElement(FNamePrefix, ANodeName, '');
    Writer.WriteAttributeString(sdxXLSXAttrRGB, TdxAlphaColors.ToHexCode(dxColorToAlphaColor(AColor), True));
    Writer.WriteEndElement;
  end;
end;

function TdxXLSXWriterWorksheetConditionalFormattingCustomRuleBuilder.GetRuleStyleID(out ID: Integer): Boolean;
begin
  Result := False;
end;

function TdxXLSXWriterWorksheetConditionalFormattingCustomRuleBuilder.GetConditionalFormattingStyles: TdxXLSXWriterResourceList;
begin
  Result := Owner.ConditionalFormattingStyles;
end;

function TdxXLSXWriterWorksheetConditionalFormattingCustomRuleBuilder.GetOwner: TdxSpreadSheetXLSXWriter;
begin
  Result := TdxSpreadSheetXLSXWriter(inherited Owner);
end;

{ TdxXLSXWriterWorksheetConditionalFormattingBuilder }

constructor TdxXLSXWriterWorksheetConditionalFormattingBuilder.Create(
  AOwner: TdxSpreadSheetCustomFiler; AWriter: TdxXmlWriter; AConditionalFormatting: TdxSpreadSheetCustomConditionalFormatting);
begin
  inherited Create(AOwner);
  FWriter := AWriter;
  FConditionalFormatting := AConditionalFormatting;
  FRuleBuilders := TdxClassDictionary<TdxXLSXWriterWorksheetConditionalFormattingCustomRuleBuilderClass>.Create;
  RegisterRulesBuilders;
end;

destructor TdxXLSXWriterWorksheetConditionalFormattingBuilder.Destroy;
begin
  FreeAndNil(FRuleBuilders);
  inherited Destroy;
end;

procedure TdxXLSXWriterWorksheetConditionalFormattingBuilder.Execute;
var
  AClass: TdxXLSXWriterWorksheetConditionalFormattingCustomRuleBuilderClass;
  ANodeStarted: Boolean;
  APrevAreas: TdxSpreadSheetAreaList;
  ARule: TdxSpreadSheetCustomConditionalFormattingRule;
  I: Integer;
begin
  APrevAreas := nil;
  ANodeStarted := False;
  for I := 0 to RuleCount - 1 do
  begin
    ARule := Rules[I];
    if IsValidRule(ARule) and not IsCustomFormattedRule(ARule) and FRuleBuilders.TryGetValue(ARule.ClassType, AClass) then
    begin
      if not ARule.Areas.Equals(APrevAreas) then
      begin
        if ANodeStarted then
          Writer.WriteEndElement;

        Writer.WriteStartElement(sdxXLSXNodeConditionalFormatting);
        Writer.WriteAttributeString(sdxXLSXAttrSqRef, EncodeReferences(ARule.Areas));
        APrevAreas := ARule.Areas;
        ANodeStarted := True;
      end;
      ExecuteSubTask(AClass.Create(Owner, Writer, ARule, ''));
    end;
  end;
  if ANodeStarted then
    Writer.WriteEndElement;
end;

function TdxXLSXWriterWorksheetConditionalFormattingBuilder.EncodeReferences(AAreas: TdxSpreadSheetAreaList): string;
begin
  Result := StringReplace(AAreas.ToString, AAreas.ValueSeparator, ' ', [rfReplaceAll]);
end;

function TdxXLSXWriterWorksheetConditionalFormattingBuilder.IsCustomFormattedRule(
  ARule: TdxSpreadSheetCustomConditionalFormattingRule): Boolean;
begin
  Result := (ARule is TdxSpreadSheetConditionalFormattingRuleDataBar) or
    (ARule is TdxSpreadSheetConditionalFormattingRuleIconSet) and
    IsExtraIconSetPreset(TdxSpreadSheetConditionalFormattingRuleIconSet(ARule).PresetName);
end;

function TdxXLSXWriterWorksheetConditionalFormattingBuilder.IsExtraIconSetPreset(const APresetName: string): Boolean;
begin
  Result := (APresetName = '') or (APresetName = '3Triangles') or (APresetName = '5Boxes');
end;

function TdxXLSXWriterWorksheetConditionalFormattingBuilder.IsValidRule(
  ARule: TdxSpreadSheetCustomConditionalFormattingRule): Boolean;
begin
  Result := ARule.Areas.Count > 0;
end;

procedure TdxXLSXWriterWorksheetConditionalFormattingBuilder.RegisterRulesBuilders;
begin
  FRuleBuilders.AddOrSetValue(TdxSpreadSheetConditionalFormattingRuleCellIs,
    TdxXLSXWriterWorksheetConditionalFormattingCellIsRuleBuilder);
  FRuleBuilders.AddOrSetValue(TdxSpreadSheetConditionalFormattingRuleExpression,
    TdxXLSXWriterWorksheetConditionalFormattingExpressionRuleBuilder);
  FRuleBuilders.AddOrSetValue(TdxSpreadSheetConditionalFormattingRuleDuplicateValues,
    TdxXLSXWriterWorksheetConditionalFormattingDuplicateValuesRuleBuilder);
  FRuleBuilders.AddOrSetValue(TdxSpreadSheetConditionalFormattingRuleUniqueValues,
    TdxXLSXWriterWorksheetConditionalFormattingUniqueValuesRuleBuilder);
  FRuleBuilders.AddOrSetValue(TdxSpreadSheetConditionalFormattingRuleAboveOrBelowAverage,
    TdxXLSXWriterConditionalFormattingAboveAverageRuleBuilder);
  FRuleBuilders.AddOrSetValue(TdxSpreadSheetConditionalFormattingRuleTopBottomValues,
    TdxXLSXWriterConditionalFormattingTopBottomRuleBuilder);
  FRuleBuilders.AddOrSetValue(TdxSpreadSheetConditionalFormattingRuleThreeColorScale,
    TdxXLSXWriterWorksheetConditionalFormattingColorScaleBuilder);
  FRuleBuilders.AddOrSetValue(TdxSpreadSheetConditionalFormattingRuleTwoColorScale,
    TdxXLSXWriterWorksheetConditionalFormattingColorScaleBuilder);
  FRuleBuilders.AddOrSetValue(TdxSpreadSheetConditionalFormattingRuleIconSet,
    TdxXLSXWriterWorksheetConditionalFormattingIconSetRuleBuilder);
end;

function TdxXLSXWriterWorksheetConditionalFormattingBuilder.GetRule(
  Index: Integer): TdxSpreadSheetCustomConditionalFormattingRule;
begin
  Result := FConditionalFormatting.Rules[Index];
end;

function TdxXLSXWriterWorksheetConditionalFormattingBuilder.GetRuleCount: Integer;
begin
  Result := FConditionalFormatting.RuleCount;
end;

{ TdxXLSXWriterWorksheetConditionalFormattingExBuilder }

procedure TdxXLSXWriterWorksheetConditionalFormattingExBuilder.RegisterRulesBuilders;
begin
  FRuleBuilders.AddOrSetValue(TdxSpreadSheetConditionalFormattingRuleIconSet,
    TdxXLSXWriterWorksheetConditionalFormattingIconSetRuleBuilder);
  FRuleBuilders.AddOrSetValue(TdxSpreadSheetConditionalFormattingRuleDataBar,
    TdxXLSXWriterWorksheetConditionalFormattingDataBarRuleBuilder);
end;

procedure TdxXLSXWriterWorksheetConditionalFormattingExBuilder.Execute;
var
  AClass: TdxXLSXWriterWorksheetConditionalFormattingCustomRuleBuilderClass;
  ANodeStarted: Boolean;
  ARule: TdxSpreadSheetCustomConditionalFormattingRule;
  I: Integer;
begin
  ANodeStarted := False;
  for I := 0 to RuleCount - 1 do
  begin
    ARule := Rules[I];
    if IsValidRule(ARule) and IsCustomFormattedRule(ARule) and FRuleBuilders.TryGetValue(ARule.ClassType, AClass) then
    begin
      if not ANodeStarted then
      begin
        Writer.WriteStartElement(sdxXLSXNodeExtList);
        Writer.WriteStartElement(sdxXLSXNodeExt);
        Writer.WriteAttributeString('xmlns', 'x14', '', 'http://schemas.microsoft.com/office/spreadsheetml/2009/9/main');
        Writer.WriteAttributeString('uri', '{78C0D931-6437-407d-A8EE-F0AAD7539E65}');
        Writer.WriteStartElement(sdxXLSXNamespaceX14, sdxXLSXNodeConditionalFormattings, '');
        ANodeStarted := True;
      end;

      Writer.WriteStartElement(sdxXLSXNamespaceX14, sdxXLSXNodeConditionalFormatting, '');
      try
        Writer.WriteAttributeString('xmlns', 'xm', '', 'http://schemas.microsoft.com/office/excel/2006/main');
        ExecuteSubTask(AClass.Create(Owner, Writer, ARule, sdxXLSXNamespaceX14));
        Writer.WriteElementString('xm', 'sqref', '', EncodeReferences(ARule.Areas));
      finally
        Writer.WriteEndElement;
      end;
    end;
  end;

  if ANodeStarted then
  begin
    Writer.WriteEndElement;
    Writer.WriteEndElement;
    Writer.WriteEndElement;
  end;
end;

{ TdxXLSXWriterWorksheetConditionalFormattingStyleBasedRuleBuilder }

function TdxXLSXWriterWorksheetConditionalFormattingStyleBasedRuleBuilder.GetRuleStyleID(out ID: Integer): Boolean;
begin
  ID := ConditionalFormattingStyles.Add(TdxSpreadSheetConditionalFormattingRuleStyleBased(Rule).Style.Handle);
  Result := True;
end;

{ TdxXLSXWriterConditionalFormattingAboveAverageRuleBuilder }

procedure TdxXLSXWriterConditionalFormattingAboveAverageRuleBuilder.WriteAttributes;
begin
  inherited;
  if Rule.ComparisonOperator in [abacoAboveOrEqualAverage, abacoBelowOrEqualAverage] then
    Writer.WriteAttributeInteger(sdxXLSXAttrEqualAverage, 1);
  if Rule.ComparisonOperator in [abacoBelowAverage, abacoBelowOrEqualAverage, abacoBelowAverageOnStandardDeviation] then
    Writer.WriteAttributeInteger(sdxXLSXAttrAboveAverage, 0);
  if Rule.ComparisonOperator in [abacoAboveAverageOnStandardDeviation, abacoBelowAverageOnStandardDeviation] then
    Writer.WriteAttributeInteger(sdxXLSXAttrStdDev, Rule.StandardDeviationLevel);
end;

function TdxXLSXWriterConditionalFormattingAboveAverageRuleBuilder.GetRule: TdxSpreadSheetConditionalFormattingRuleAboveOrBelowAverage;
begin
  Result := TdxSpreadSheetConditionalFormattingRuleAboveOrBelowAverage(inherited Rule);
end;

function TdxXLSXWriterConditionalFormattingAboveAverageRuleBuilder.GetRuleType: TdxXMLString;
begin
  Result := sdxXLSXValueAboveAverage;
end;

{ TdxXLSXWriterWorksheetConditionalFormattingExpressionRuleBuilder }

procedure TdxXLSXWriterWorksheetConditionalFormattingExpressionRuleBuilder.WriteChildren;
begin
  inherited;
  Writer.WriteElementString(sdxXLSXNodeFormula, dxSpreadSheetFormulaExcludeEqualSymbol(Rule.Expression));
end;

function TdxXLSXWriterWorksheetConditionalFormattingExpressionRuleBuilder.GetRuleType: TdxXMLString;
begin
  Result := sdxXLSXValueExpression;
end;

function TdxXLSXWriterWorksheetConditionalFormattingExpressionRuleBuilder.GetRule: TdxSpreadSheetConditionalFormattingRuleExpression;
begin
  Result := TdxSpreadSheetConditionalFormattingRuleExpression(inherited Rule);
end;

{ TdxXLSXWriterWorksheetConditionalFormattingCellIsRuleBuilder }

procedure TdxXLSXWriterWorksheetConditionalFormattingCellIsRuleBuilder.WriteAttributes;
begin
  inherited;
  Writer.WriteAttributeString(sdxXLSXAttrOperator, dxXLSXCfCellIsRuleOperator[Rule.ComparisonOperator]);
  if Rule.ComparisonOperator in [cicoBetween, cicoNotBetween] then
    Writer.WriteElementString(sdxXLSXNodeFormula, dxSpreadSheetFormulaExcludeEqualSymbol(Rule.Expression2));
end;

function TdxXLSXWriterWorksheetConditionalFormattingCellIsRuleBuilder.GetRuleType: TdxXMLString;
begin
  Result := sdxXLSXValueCellIs;
end;

function TdxXLSXWriterWorksheetConditionalFormattingCellIsRuleBuilder.GetRule: TdxSpreadSheetConditionalFormattingRuleCellIs;
begin
  Result := TdxSpreadSheetConditionalFormattingRuleCellIs(inherited Rule);
end;

{ TdxXLSXWriterWorksheetConditionalFormattingColorScaleBuilder }

procedure TdxXLSXWriterWorksheetConditionalFormattingColorScaleBuilder.WriteChildren;
var
  I: Integer;
begin
  inherited;

  Writer.WriteStartElement(NamePrefix, sdxXLSXNodeColorScale, '');
  try
    for I := 0 to StopCount - 1 do
      WriteStop(Stops[I]);
    for I := 0 to StopCount - 1 do
      AddColorNode(sdxXLSXNodeColor, Stops[I].Color);
  finally
    Writer.WriteEndElement;
  end;
end;

function TdxXLSXWriterWorksheetConditionalFormattingColorScaleBuilder.GetRuleType: TdxXMLString;
begin
  Result := sdxXLSXValueColorScale;
end;

procedure TdxXLSXWriterWorksheetConditionalFormattingColorScaleBuilder.WriteStop(
  AStop: TdxSpreadSheetConditionalFormattingRuleColorScaleStop);
var
  AValueType: AnsiString;
begin
  if AStop.ValueType <> cssvtLimitValue then
    AValueType := dxXLSXScaleStopValueTypeMap[AStop.ValueType]
  else
    if AStop <> Stops[StopCount - 1] then
      AValueType := sdxXLSXValueTypeMin
    else
      AValueType := sdxXLSXValueTypeMax;

  Writer.WriteStartElement(sdxXLSXNodeCFVO);
  Writer.WriteAttributeString(sdxXLSXAttrTypeLC, AValueType);
  if AStop.ValueType <> cssvtLimitValue then
    Writer.WriteAttributeString(sdxXLSXAttrVal, AStop.Value);
  Writer.WriteEndElement;
end;

function TdxXLSXWriterWorksheetConditionalFormattingColorScaleBuilder.GetRule: TdxSpreadSheetConditionalFormattingRuleCustomColorScale;
begin
  Result := TdxSpreadSheetConditionalFormattingRuleCustomColorScale(inherited Rule);
end;

function TdxXLSXWriterWorksheetConditionalFormattingColorScaleBuilder.GetStop(
  Index: Integer): TdxSpreadSheetConditionalFormattingRuleColorScaleStop;
begin
  Result := TdxSpreadSheetConditionalFormattingRuleCustomColorScaleAccess(Rule).Stops[Index];
end;

function TdxXLSXWriterWorksheetConditionalFormattingColorScaleBuilder.GetStopCount: Integer;
begin
  Result := TdxSpreadSheetConditionalFormattingRuleCustomColorScaleAccess(Rule).StopCount;
end;

{ TdxXLSXWriterWorksheetConditionalFormattingDuplicateValuesRuleBuilder }

function TdxXLSXWriterWorksheetConditionalFormattingDuplicateValuesRuleBuilder.GetRuleType: TdxXMLString;
begin
  Result := sdxXLSXValueDuplicateValues;
end;

{ TdxXLSXWriterWorksheetConditionalFormattingDataBarRuleBuilder }

procedure TdxXLSXWriterWorksheetConditionalFormattingDataBarRuleBuilder.WriteChildren;
begin
  inherited;

  Writer.WriteStartElement(NamePrefix, sdxXLSXNodeDataBar, '');
  try
    Writer.WriteAttributeInteger('minLength', 0);
    Writer.WriteAttributeInteger('maxLength', 100);
    Writer.WriteAttributeBoolean(sdxXLSXAttrShowValue, Rule.ShowValue);
    Writer.WriteAttributeBoolean(sdxXLSXAttrBorder, cxColorIsValid(Rule.Style.PositiveBarBorderColor));
    Writer.WriteAttributeBoolean(sdxXLSXAttrGradient, Rule.Style.FillMode = dbfmGradient);
    Writer.WriteAttributeString(sdxXLSXAttrDirection, dxXLSXDataBarDirectionMap[Rule.Style.Direction]);
    Writer.WriteAttributeBoolean(sdxXLSXAttrNegativeBarColorSameAsPositive, Rule.Style.NegativeBarColor = clDefault);
    Writer.WriteAttributeBoolean(sdxXLSXAttrNegativeBarBorderColorSameAsPositive, Rule.Style.NegativeBarBorderColor = clDefault);
    Writer.WriteAttributeString(sdxXLSXAttrAxisPosition, dxXLSXAxisPosition[Rule.Style.AxisPosition]);

    WriteStop(Rule.MinValue);
    WriteStop(Rule.MaxValue);

    AddColorNode(sdxXLSXNodeFillColor, Rule.Style.PositiveBarColor);
    AddColorNode(sdxXLSXNodeBorderColor, Rule.Style.PositiveBarBorderColor);
    AddColorNode(sdxXLSXNodeNegativeFillColor, Rule.Style.NegativeBarColor);
    AddColorNode(sdxXLSXNodeNegativeBorderColor, Rule.Style.NegativeBarBorderColor);
    if Rule.Style.AxisPosition <> dbapNone then
      AddColorNode(sdxXLSXNodeAxisColor, Rule.Style.AxisColor);
  finally
    Writer.WriteEndElement;
  end;
end;

function TdxXLSXWriterWorksheetConditionalFormattingDataBarRuleBuilder.GetRuleType: TdxXMLString;
begin
  Result := sdxXLSXValueTypeDataBar;
end;

procedure TdxXLSXWriterWorksheetConditionalFormattingDataBarRuleBuilder.WriteStop(
  AStop: TdxSpreadSheetConditionalFormattingRuleCustomScaleStop);

  function GetValueType: AnsiString;
  begin
    if AStop.ValueType <> cssvtLimitValue then
      Result := dxXLSXScaleStopValueTypeMap[AStop.ValueType]
    else
      if AStop = Rule.MinValue then
        Result := sdxXLSXValueTypeMin
      else
        Result := sdxXLSXValueTypeMax;
  end;

begin
  Writer.WriteStartElement(NamePrefix, sdxXLSXNodeCFVO, '');
  try
    Writer.WriteAttributeString(sdxXLSXAttrTypeLC, GetValueType);
    if AStop.ValueType <> cssvtLimitValue then
    begin
      if NamePrefix <> '' then
        Writer.WriteElementString(sdxXLSXNamespaceXM, sdxXLSXNodeFunction, '', AStop.Value)
      else
        Writer.WriteAttributeString(sdxXLSXAttrVal, AStop.Value);
    end;
  finally
    Writer.WriteEndElement;
  end;
end;

function TdxXLSXWriterWorksheetConditionalFormattingDataBarRuleBuilder.GetRule: TdxSpreadSheetConditionalFormattingRuleDataBar;
begin
  Result := TdxSpreadSheetConditionalFormattingRuleDataBar(inherited Rule);
end;

{ TdxXLSXWriterWorksheetConditionalFormattingIconSetRuleBuilder }

procedure TdxXLSXWriterWorksheetConditionalFormattingIconSetRuleBuilder.WriteChildren;
var
  I: Integer;
begin
  inherited;

  Writer.WriteStartElement(NamePrefix, sdxXLSXNodeIconSet, '');
  try
    Writer.WriteAttributeString(sdxXLSXAttrIconSet, GetPresetName);
    Writer.WriteAttributeBoolean(sdxXLSXAttrShowValue, Rule.ShowValue);

    if Rule.PresetName = '' then
      Writer.WriteAttributeBoolean(sdxXLSXAttrCustom, True)
    else
      Writer.WriteAttributeBoolean(sdxXLSXAttrReverse, Rule.Order = isioReversed);

    for I := 0 to Rule.StopCount - 1 do
      WriteStop(Rule.Stops[I]);

    if Rule.PresetName = '' then
    begin
      for I := 0 to Rule.StopCount - 1 do
        WriteStopCustomIcon(Rule.Stops[I]);
    end;
  finally
    Writer.WriteEndElement;
  end;
end;

function TdxXLSXWriterWorksheetConditionalFormattingIconSetRuleBuilder.GetRuleType: TdxXMLString;
begin
  Result := sdxXLSXValueTypeIconSet;
end;

procedure TdxXLSXWriterWorksheetConditionalFormattingIconSetRuleBuilder.WriteStop(
  AStop: TdxSpreadSheetConditionalFormattingRuleIconSetStop);
begin
  Writer.WriteStartElement(NamePrefix, sdxXLSXNodeCFVO, '');
  try
    Writer.WriteAttributeString(sdxXLSXAttrTypeLC, dxXLSXScaleStopValueTypeMap[AStop.ValueType]);
    if NamePrefix <> '' then
      Writer.WriteElementString(sdxXLSXNamespaceXM, sdxXLSXNodeFunction, '', EncodeValue(AStop))
    else
      Writer.WriteAttributeString(sdxXLSXAttrVal, EncodeValue(AStop));
    if AStop.ComparisonOperator = isscoGreaterThan then
      Writer.WriteAttributeInteger(sdxXLSXAttrGTE, 0);
  finally
    Writer.WriteEndElement;
  end;
end;

procedure TdxXLSXWriterWorksheetConditionalFormattingIconSetRuleBuilder.WriteStopCustomIcon(
  AStop: TdxSpreadSheetConditionalFormattingRuleIconSetStop);
var
  AIndexInPreset: Integer;
  APreset: TdxSpreadSheetConditionalFormattingIconSetPreset;
begin
  if not ConditionalFormattingIconSet.Presets.FindByIconIndex(AStop.IconIndex, APreset, AIndexInPreset) then
    raise EdxSpreadSheetFormatError.CreateFmt(cxGetResourceString(@sdxErrorInternal), [ClassName]);

  Writer.WriteStartElement(NamePrefix, sdxXLSXNodeCFIcon, '');
  try
    Writer.WriteAttributeString(sdxXLSXAttrIconSet, APreset.Name);
    Writer.WriteAttributeInteger(sdxXLSXAttrIconId, AIndexInPreset);
  finally
    Writer.WriteEndElement;
  end;
end;

function TdxXLSXWriterWorksheetConditionalFormattingIconSetRuleBuilder.EncodeValue(
  const AStop: TdxSpreadSheetConditionalFormattingRuleIconSetStop): string;
begin
  if VarIsNumeric(AStop.Value) then
    Result := dxCore.dxFloatToStr(AStop.Value)
  else
  begin
    Result := AStop.Value;
    if (AStop.ValueType = cssvtFormula) and dxSpreadSheetIsFormula(Result) then
      Delete(Result, 1, 1); 
  end;
end;

function TdxXLSXWriterWorksheetConditionalFormattingIconSetRuleBuilder.GetPresetName: string;
var
  APreset: TdxSpreadSheetConditionalFormattingIconSetPreset;
begin
  Result := Rule.PresetName;
  if Result = '' then
  begin
    if ConditionalFormattingIconSet.Presets.FindByCount(Rule.StopCount, APreset) then
      Result := APreset.Name
    else
      raise EdxSpreadSheetFormatError.CreateFmt(cxGetResourceString(@sdxErrorInternal), [ClassName]);
  end;
end;

function TdxXLSXWriterWorksheetConditionalFormattingIconSetRuleBuilder.GetRule: TdxSpreadSheetConditionalFormattingRuleIconSet;
begin
  Result := TdxSpreadSheetConditionalFormattingRuleIconSet(inherited Rule);
end;

{ TdxXLSXWriterConditionalFormattingTopBottomRuleBuilder }

procedure TdxXLSXWriterConditionalFormattingTopBottomRuleBuilder.WriteAttributes;
begin
  inherited;
  Writer.WriteAttributeInteger(sdxXLSXAttrRank, Rule.Value);
  if Rule.Direction = tbvdBottom then
    Writer.WriteAttributeBoolean(sdxXLSXAttrBottom, True);
  if Rule.ValueType = tbvvtPercent then
    Writer.WriteAttributeBoolean(sdxXLSXAttrPercent, True);
end;

function TdxXLSXWriterConditionalFormattingTopBottomRuleBuilder.GetRule: TdxSpreadSheetConditionalFormattingRuleTopBottomValues;
begin
  Result := TdxSpreadSheetConditionalFormattingRuleTopBottomValues(inherited Rule);
end;

function TdxXLSXWriterConditionalFormattingTopBottomRuleBuilder.GetRuleType: TdxXMLString;
begin
  Result := sdxXLSXValueTop10;
end;

{ TdxXLSXWriterWorksheetConditionalFormattingUniqueValuesRuleBuilder }

function TdxXLSXWriterWorksheetConditionalFormattingUniqueValuesRuleBuilder.GetRuleType: TdxXMLString;
begin
  Result := sdxXLSXValueUniqueValues;
end;

end.
