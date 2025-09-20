{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressRichEditControl                                   }
{                                                                    }
{           Copyright (c) 2000-2024 Developer Express Inc.           }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSRICHEDITCONTROL AND ALL        }
{   ACCOMPANYING VCL CONTROLS AS PART OF AN EXECUTABLE PROGRAM       }
{   ONLY.                                                            }
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

unit dxRichEdit.DocumentModel.FieldCalculatorService; // for internal use

{$I cxVer.inc}
{$I dxRichEditControl.inc}

interface

uses
  Types, SysUtils, Classes, Generics.Defaults, Generics.Collections,
  dxCore, dxCoreClasses,
  dxGenerics,
  dxRichEdit.Utils.Types,
  dxRichEdit.Utils.Token,
  dxRichEdit.Options.Simple,
  dxRichEdit.DocumentModel.Core,
  dxRichEdit.DocumentModel.Simple,
  dxRichEdit.DocumentModel.PieceTableIterators,
  dxRichEdit.DocumentModel.Fields.Core,
  dxRichEdit.DocumentModel.Fields,
  dxRichEdit.DocumentModel.PieceTable,
  dxRichEdit.DocumentModel.MailMerge;

type
  TdxFieldScanner = class;

  TdxErrors = class(TObject);
  TdxExpressionFieldBase = class(TObject);
  TdxExpressionTree = class(TObject);
  TdxFormulaNodeBase = class(TObject);
  TdxArgumentList = class(TObject);
  TdxExpressionCalculatedField = class(TObject);

  TdxScannerStateType = (
    Simple,
    Expression,
    Instructions,
    EqSwitches,
    EqInstructions);

  { IdxFieldIterator }

  IdxFieldIterator = interface
    function GetPosition: TdxDocumentLogPosition;

    function ReadNextChar: Char;
    function IsEnd: Boolean;
    function PeekNextChar: Char;
    procedure AdvanceNextChar(ASkipNestedFields: Boolean = True); overload;
    function IsFieldCodeStart: Boolean;
    function IsFieldEnd: Boolean;
    function IsFieldCodeEnd: Boolean;

    property Position: TdxDocumentLogPosition read GetPosition;
  end;

  { TdxFieldCalculatorService }

  TdxCreateFieldDelegate = reference to function: TdxCalculatedFieldBase;

  TdxFieldCalculatorService = class(TInterfacedObject, IdxFieldCalculatorService)
  strict private
    type
      TFieldTypes = class(TdxNamedDelegateDictionary<TdxCreateFieldDelegate>);
    class var
      FFieldTypes: TFieldTypes;
  strict private
    class constructor Initialize;
    class destructor Finalize;
  protected
    FUpdateOnLoadOptions: TdxFieldUpdateOnLoadOptions;
    class procedure RegisterFieldType(const AFieldType: string; const ACreator: TdxCreateFieldDelegate); static;
    procedure PrepareSimpleField(APieceTable: TdxPieceTable; AFirstToken: IdxToken;
      AScanner: TdxFieldScanner; ADocumentField: TdxField;
      AUpdateType: TdxUpdateFieldOperationType); virtual;
    function CreateInitializedCalculatedField(APieceTable: TdxSimplePieceTable;
      AFirstToken: IdxToken; AScanner: TdxFieldScanner): TdxCalculatedFieldBase; virtual;
    function CalculateSimpleField(APieceTable: TdxPieceTable; AFirstToken: IdxToken;
      AScanner: TdxFieldScanner; AMailMergeDataMode: TdxMailMergeDataMode;
      ADocumentField: TdxField; AUpdateType: TdxUpdateFieldOperationType): TdxCalculateFieldResult; virtual;
    function CalculateExpressionValue(APieceTable: TdxPieceTable; AScanner: TdxFieldScanner;
      AField: TdxField): TdxCalculateFieldResult; virtual;
    function CalculateInvalidField(APieceTable: TdxPieceTable): TdxCalculateFieldResult; virtual;
    function GetActualUpdateDocVariablesBeforePrint(AModel: TdxDocumentModel;
      AUpdateType: TdxUpdateFieldOperationType): Boolean;
    class function IsSwitchWithArgument(AField: TdxCalculatedFieldBase; AToken: IdxToken): Boolean; static;
    class function IsFieldArgument(ATokenKind: TdxTokenKind): Boolean; static;
  public
    procedure BeginUpdateFieldsOnLoad(AOptions: TdxFieldUpdateOnLoadOptions); virtual;
    procedure EndUpdateFieldsOnLoad; virtual;
    function CalculateField(APieceTable: TdxCustomPieceTable; AField: TdxField; 
      AMailMergeDataMode: TdxMailMergeDataMode; AUpdateType: TdxUpdateFieldOperationType): TdxCalculateFieldResult;
    procedure PrepareField(APieceTable: TdxCustomPieceTable; AField: TdxField; 
      AUpdateType: TdxUpdateFieldOperationType);
    function ParseField(APieceTable: TdxSimplePieceTable; AField: TdxField): TdxCalculatedFieldBase; virtual;
    function GetFirstToken(APieceTable: TdxPieceTable; AField: TdxField): IdxToken; virtual;

    class function CreateField(const AFieldType: string): TdxCalculatedFieldBase; static;
    class function ParseInstructions(AScanner: TdxFieldScanner;
      AField: TdxCalculatedFieldBase): TdxInstructionCollection; static;
  end;

  { TdxScannerStateBase }

  TdxScannerStateBase = class abstract
  strict private
    FScanner: TdxFieldScanner;
    function GetIterator: IdxFieldIterator;
  protected
    function CreateToken(AKind: TdxTokenKind; APosition: TdxDocumentLogPosition = 0;
      const AValue: string = ''; ALength: Integer = 1): IdxToken;
    function GetStateType: TdxScannerStateType; virtual; abstract;
  public
    constructor Create(AScanner: TdxFieldScanner);
    function ReadNextToken: IdxToken; virtual; abstract;
    function GetNextState(AToken: IdxToken): TdxScannerStateType; virtual; abstract;

    property Scanner: TdxFieldScanner read FScanner;
    property Iterator: IdxFieldIterator read GetIterator;
    property StateType: TdxScannerStateType read GetStateType;
  end;

  { TdxScannerStateSimpleToken }

  TdxScannerStateSimpleToken = class(TdxScannerStateBase)
  protected
    function GetStateType: TdxScannerStateType; override;
  public
    function ReadNextToken: IdxToken; override;
    function IsEndOfToken(ACh: Char): Boolean;
    function GetNextState(AToken: IdxToken): TdxScannerStateType; override;
  end;

  { TdxScannerStateExpression }

  TdxScannerStateExpression = class(TdxScannerStateBase)
  protected
    function GetStateType: TdxScannerStateType; override;
  public
    function ReadNextToken: IdxToken; override;
    function GetNextState(AToken: IdxToken): TdxScannerStateType; override;
    function IsEndOfToken(ACh: Char): Boolean;
    function IsSpecialChar(ACh: Char): Boolean;
    function IsConstantChar(ACh: Char): Boolean;
    function ReadConstantToken: IdxToken;
    function ReadSpecialCharToken: IdxToken;
    function IsSwitchStart(ACh: Char): Boolean;
    function ReadSwitchToken(AStart: TdxDocumentLogPosition): IdxToken;
    function ReadFieldSwitchCharacter(AStart: TdxDocumentLogPosition): IdxToken;
    function IsLatinLetter(ACh: Char): Boolean;
  end;

  { TdxScannerStateInstructions }

  TdxScannerStateInstructions = class(TdxScannerStateBase)
  protected
    function GetStateType: TdxScannerStateType; override;
    function IsSwitchStart(ACh: Char): Boolean;
    function ReadSwitchToken(AStart: TdxDocumentLogPosition): IdxToken;
    function ReadFieldSwitchCharacter(AStart: TdxDocumentLogPosition): IdxToken;
    function IsLatinLetter(ACh: Char): Boolean;
  public
    function ReadNextToken: IdxToken; override;
    function GetNextState(AToken: IdxToken): TdxScannerStateType; override;
  end;

  { TdxScannerStateEqSwitches }

  TdxScannerStateEqSwitches = class(TdxScannerStateInstructions)
  protected
    function GetStateType: TdxScannerStateType; override;
  public
    function ReadNextToken: IdxToken; override;
    function GetNextState(AToken: IdxToken): TdxScannerStateType; override;
  end;

  { TdxScannerStateEqInstructions }

  TdxScannerStateEqInstructions = class(TdxScannerStateBase)
  protected
    function GetStateType: TdxScannerStateType; override;
  public
    function ReadNextToken: IdxToken; override;
    function GetNextState(AToken: IdxToken): TdxScannerStateType; override;
    function IsEndOfToken(ACh: Char): Boolean;
  end;

  { TdxFieldScanner }

  TdxFieldScanner = class
  strict private const
      DocPropertyToken = 'DOCPROPERTY';
      EqToken = 'EQ';
  strict private class var
      SimpleTokens: TArray<string>;
      DocPropertyInfoCommonTokens: TArray<string>;
      DocPropertyCategoryTokens: TArray<string>;
      DocumentInformationTokens: TArray<string>;
      TokenDictionary: TdxNamedOrdinalDictionary<TdxTokenKind>;
  strict private
    class constructor Initialize;
    class destructor Finalize;
    class procedure AddTokensToDictionary(const ATokens: TArray<string>; AKind: TdxTokenKind); static;
    class procedure AddTokenToDictionary(const AToken: string; AKind: TdxTokenKind); static;
  strict private
    FCurrentPeekToken: IdxToken;
    FCurrentScanToken: IdxToken;
    FDecimalSeparator: Char;
    FEnableFieldNames: Boolean;
    FIterator: IdxFieldIterator;
    FMaxFieldSwitchLength: Integer;
    FSeparatorChar: Char;
    FState: TdxScannerStateBase;
    FSupportFieldCommonStringFormat: Boolean;
    FTokens: TdxTokenList;
  protected
    function CreateToken(AKind: TdxTokenKind; APosition: TdxDocumentLogPosition = 0;
      const Value: string = ''; ALength: Integer = 1): IdxToken;
    function GetSeparatorChar: Char; virtual;
    function GetDecimalSeparator: Char; virtual;
  public
    constructor Create(const AIterator: IdxFieldIterator; APieceTable: TdxPieceTable); overload;
    constructor Create(const AIterator: IdxFieldIterator; AMaxFieldSwitchLength: Integer;
      AEnableFieldNames: Boolean; ASupportFieldCommonStringFormat: Boolean); overload;
    destructor Destroy; override;

    function Scan: IdxToken;
    procedure SwitchState(AStateType: TdxScannerStateType);
    function Peek: IdxToken;
    function PeekCore: IdxToken;
    function ReadToken: IdxToken;
    function ReadQuotedText: IdxToken;
    procedure SkipWhitespaces(ASkipNestedFields: Boolean);
    function IsFieldStart: Boolean;
    function ScanEntireFieldToken: IdxToken;
    function IsWhiteSpace(ACh: Char): Boolean; virtual;
    procedure ResetPeek;
    function GetTokenKindByVal(const AStrVal: string): TdxTokenKind;
    function IsSwitchToken(AKind: TdxTokenKind): Boolean; virtual;
    function IsValidFirstToken(AToken: IdxToken): Boolean;

    property Iterator: IdxFieldIterator read FIterator;
    property SupportFieldCommonStringFormat: Boolean read FSupportFieldCommonStringFormat;
    property SeparatorChar: Char read GetSeparatorChar;
    property DecimalSeparator: Char read GetDecimalSeparator;
    property State: TdxScannerStateBase read FState;
    property MaxFieldSwitchLength: Integer read FMaxFieldSwitchLength;
    property EnableFieldNames: Boolean read FEnableFieldNames;
  end;

  { TdxDocumentFieldIterator }

  TdxDocumentFieldIterator = class(TcxIUnknownObject, IdxFieldIterator)
  strict private
    FPieceTable: TdxSimplePieceTable;
    FPosition: TdxDocumentModelPosition;
    FCharactersIterator: TdxCharactersDocumentModelIterator;
    FLastRunIndex: TdxRunIndex;
    FCurrentRunText: string;
    FNestedLevel: Integer;
    function GetPosition: TdxDocumentLogPosition;
  protected
    function GetPieceTable: TdxSimplePieceTable; virtual;
    function IsNestedFieldBegin(ARange: TdxTextRunBase): Boolean; virtual;
    function IsNestedFieldEnd(ARange: TdxTextRunBase): Boolean; virtual;
    procedure StartNestedField; virtual;
    procedure EndNestedField; virtual;
    procedure SkipNestedFields; virtual;

    property PieceTable: TdxSimplePieceTable read GetPieceTable;
  public
    constructor Create(APieceTable: TdxSimplePieceTable; AField: TdxField);
    destructor Destroy; override;
    function ReadNextChar: Char;
    function IsEnd: Boolean;
    function PeekNextChar: Char;
    function IsFieldCodeStart: Boolean;
    function IsFieldEnd: Boolean;
    function IsFieldCodeEnd: Boolean;
    procedure AdvanceNextChar(ASkipNestedFields: Boolean = True);

    property Position: TdxDocumentLogPosition read GetPosition;
  end;


implementation

uses
  Character, RTLConsts,
  cxFormats,
  dxRichEdit.DocumentModel.FieldRange,
  dxRichEdit.DocumentModel.Fields.NumPagesField,
  dxRichEdit.DocumentModel.Fields.PageField,
  dxRichEdit.DocumentModel.Fields.DateTimeFields,
  dxRichEdit.DocumentModel.Fields.IfField,
  dxRichEdit.DocumentModel.Fields.PageRefField,
  dxRichEdit.DocumentModel.Fields.DocVariableField,
  dxRichEdit.DocumentModel.Fields.PictureFields,
  dxRichEdit.DocumentModel.Fields.SequenceField,
  dxRichEdit.DocumentModel.Fields.SymbolField,
  dxRichEdit.DocumentModel.Fields.HyperlinkField,
  dxRichEdit.DocumentModel.Fields.MergefieldField,
  dxRichEdit.DocumentModel.Fields.TocField,
  dxRichEdit.DocumentModel.Fields.TocEntryField,
  dxRichEdit.DocumentModel.DocumentProperties;

const
  dxThisUnitName = 'dxRichEdit.DocumentModel.FieldCalculatorService';

type
  TdxTextRunBaseAccess = class(TdxTextRunBase);

{ TdxFieldCalculatorService }

class constructor TdxFieldCalculatorService.Initialize;
begin
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.ConstructorStarted(UnitName, 'TdxFieldCalculatorService.Initialize', SysInit.HInstance);{$ENDIF}
  FFieldTypes := TFieldTypes.Create;
  RegisterFieldType(TdxMergefieldField.FieldType, TdxMergefieldField.CreateField);
  RegisterFieldType(TdxDateField.FieldType, TdxDateField.CreateField);
  RegisterFieldType(TdxTimeField.FieldType, TdxTimeField.CreateField);
  RegisterFieldType(TdxCreateDateField.FieldType, TdxCreateDateField.CreateField);
  RegisterFieldType(TdxIncludePictureField.FieldType, TdxIncludePictureField.CreateField);
  RegisterFieldType(TdxIfField.FieldType, TdxIfField.CreateField);
  RegisterFieldType(TdxHyperlinkField.FieldType, TdxHyperlinkField.CreateField);
  RegisterFieldType(TdxPageField.FieldType, TdxPageField.CreateField);
  RegisterFieldType(TdxNumPagesField.FieldType, TdxNumPagesField.CreateField);
  RegisterFieldType(TdxTocField.FieldType, TdxTocField.CreateField);
  RegisterFieldType(TdxTocEntryField.FieldType, TdxTocEntryField.CreateField);
  RegisterFieldType(TdxPageRefField.FieldType, TdxPageRefField.CreateField);
  RegisterFieldType(TdxDocVariableField.FieldType, TdxDocVariableField.CreateField);
  RegisterFieldType(TdxSequenceField.FieldType, TdxSequenceField.CreateField);
  RegisterFieldType(TdxShapeField.FieldType, TdxShapeField.CreateField);
  RegisterFieldType(TdxSymbolField.FieldType, TdxSymbolField.CreateField);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.ConstructorFinished(UnitName, 'TdxFieldCalculatorService.Initialize', SysInit.HInstance);{$ENDIF}
end;

class destructor TdxFieldCalculatorService.Finalize;
begin
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.DestructorStarted(UnitName, 'TdxFieldCalculatorService.Finalize', SysInit.HInstance);{$ENDIF}
  FreeAndNil(FFieldTypes);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.DestructorFinished(UnitName, 'TdxFieldCalculatorService.Finalize', SysInit.HInstance);{$ENDIF}
end;

class procedure TdxFieldCalculatorService.RegisterFieldType(const AFieldType: string; const ACreator: TdxCreateFieldDelegate);
begin
  if not FFieldTypes.ContainsKey(AFieldType) then
    FFieldTypes.Add(AFieldType, ACreator);
end;

class function TdxFieldCalculatorService.CreateField(const AFieldType: string): TdxCalculatedFieldBase;
var
  ACreator: TdxCreateFieldDelegate;
begin
  if FFieldTypes.TryGetValue(AFieldType, ACreator) then
    Result := ACreator
  else
    Result := nil;
end;

procedure TdxFieldCalculatorService.BeginUpdateFieldsOnLoad(AOptions: TdxFieldUpdateOnLoadOptions);
begin
  FUpdateOnLoadOptions := AOptions;
end;

procedure TdxFieldCalculatorService.EndUpdateFieldsOnLoad;
begin
  FUpdateOnLoadOptions := nil;
end;

function TdxFieldCalculatorService.CalculateField(APieceTable: TdxCustomPieceTable; 
  AField: TdxField; AMailMergeDataMode: TdxMailMergeDataMode; AUpdateType: TdxUpdateFieldOperationType): TdxCalculateFieldResult;
var
  AIterator: TdxDocumentFieldIterator;
  AScanner: TdxFieldScanner;
  AToken: IdxToken;
  ATable: TdxPieceTable absolute APieceTable;
begin
  AIterator := TdxDocumentFieldIterator.Create(ATable, AField);
  try
    AScanner := TdxFieldScanner.Create(AIterator, ATable.DocumentModel.MaxFieldSwitchLength,
      ATable.DocumentModel.EnableFieldNames, ATable.SupportFieldCommonStringFormat);
    try
      AToken := AScanner.Scan;
      case AToken.ActualKind of
        TdxTokenKind.OpEQ:
          begin
            Result := CalculateInvalidField(ATable);
          end;
        TdxTokenKind.Eq:
          begin
            Result := CalculateInvalidField(ATable);
          end;
        else
          Result := CalculateSimpleField(ATable, AToken, AScanner, AMailMergeDataMode, AField, AUpdateType);
      end;
    finally
      AScanner.Free;
    end;
  finally
    AIterator.Free;
  end;
end;

procedure TdxFieldCalculatorService.PrepareField(APieceTable: TdxCustomPieceTable; AField: TdxField; AUpdateType: TdxUpdateFieldOperationType); 
var
  AIterator: TdxDocumentFieldIterator;
  AScanner: TdxFieldScanner;
  AToken: IdxToken;
  ATable: TdxPieceTable absolute APieceTable;
begin
  AIterator := TdxDocumentFieldIterator.Create(ATable, AField);
  try
    AScanner := TdxFieldScanner.Create(AIterator, ATable.DocumentModel.MaxFieldSwitchLength, ATable.DocumentModel.EnableFieldNames, ATable.SupportFieldCommonStringFormat);
    try
      AToken := AScanner.Scan;
      if (AToken.ActualKind <> TdxTokenKind.OpEQ) and (AToken.ActualKind <> TdxTokenKind.Eq) then
        PrepareSimpleField(ATable, AToken, AScanner, AField, AUpdateType);
    finally
      AScanner.Free;
    end;
  finally
    AIterator.Free;
  end;
end;

procedure TdxFieldCalculatorService.PrepareSimpleField(APieceTable: TdxPieceTable; AFirstToken: IdxToken;
  AScanner: TdxFieldScanner; ADocumentField: TdxField; AUpdateType: TdxUpdateFieldOperationType);
var
  AField: TdxCalculatedFieldBase;
  ANeedFreeField: Boolean;
begin
  try
    ANeedFreeField := True;
    AField := CreateInitializedCalculatedField(APieceTable, AFirstToken, AScanner);
    try
      if (AField = nil) or (not AField.CanPrepare) then
        Exit;
      if not (AUpdateType in AField.GetAllowedUpdateFieldTypes(FUpdateOnLoadOptions)) then
        Exit;
      AField.BeforeCalculateFields(APieceTable, ADocumentField);
      ADocumentField.PreparedCalculatedField := AField;
      ANeedFreeField := False;
    finally
      if ANeedFreeField then
        AField.Free;
    end;
  except
  end;
end;

function TdxFieldCalculatorService.CreateInitializedCalculatedField(APieceTable: TdxSimplePieceTable;
  AFirstToken: IdxToken; AScanner: TdxFieldScanner): TdxCalculatedFieldBase;
var
  AInstructions: TdxInstructionCollection;
begin
  Result := CreateField(AFirstToken.Value);
  if Result = nil then
    Exit;
  AInstructions := ParseInstructions(AScanner, Result);
  Result.Initialize(APieceTable, AInstructions);
end;

function TdxFieldCalculatorService.ParseField(APieceTable: TdxSimplePieceTable; AField: TdxField): TdxCalculatedFieldBase;
var
  AIterator: TdxDocumentFieldIterator;
  AScanner: TdxFieldScanner;
  AToken: IdxToken;
begin
  try
    AIterator := TdxDocumentFieldIterator.Create(APieceTable, AField);
    try
      AScanner := TdxFieldScanner.Create(AIterator, APieceTable.DocumentModel.MaxFieldSwitchLength, APieceTable.DocumentModel.EnableFieldNames, APieceTable.SupportFieldCommonStringFormat);
      try
        AToken := AScanner.Scan;
        if (AToken.ActualKind <> TdxTokenKind.OpEQ) and (AToken.ActualKind <> TdxTokenKind.Eq) then
          Exit(CreateInitializedCalculatedField(APieceTable, AToken, AScanner));
      finally
        AScanner.Free;
      end;
    finally
      AIterator.Free;
    end;
  except
  end;
  Result := nil;
end;

function TdxFieldCalculatorService.CalculateSimpleField(APieceTable: TdxPieceTable; AFirstToken: IdxToken;
  AScanner: TdxFieldScanner; AMailMergeDataMode: TdxMailMergeDataMode; ADocumentField: TdxField; AUpdateType: TdxUpdateFieldOperationType): TdxCalculateFieldResult;
var
  AField: TdxCustomCalculatedField;
  AShapeField: TdxShapeField;
  AModel: TdxDocumentModel;
  AUpdateBeforePrint: Boolean;
  AResult: TdxCalculatedFieldValue;
begin
  if ADocumentField.PreparedCalculatedField <> nil then
    AField := ADocumentField.PreparedCalculatedField
  else
    AField := CreateInitializedCalculatedField(APieceTable, AFirstToken, AScanner);
  try
    if ADocumentField.Locked then
    begin
      if not Safe.Cast(AField, TdxShapeField, AShapeField) then
      begin
          Exit(TdxCalculateFieldResult.Create(TdxCalculatedFieldValue.Create(nil, [TdxFieldResultOption.KeepOldResult]), [TdxUpdateFieldOperationType.Normal]));
      end;
    end;
    ADocumentField.PreparedCalculatedField := nil;
    if AField = nil then
      Exit(nil);
    if not (AUpdateType in AField.GetAllowedUpdateFieldTypes(FUpdateOnLoadOptions)) then
      Exit(nil);
    if (AUpdateType = TdxUpdateFieldOperationType.Copy) and not APieceTable.DocumentModel.FieldOptions.UpdateFieldsOnPaste then
      Exit(nil);
    if AField is TdxDocVariableField then
    begin
      AModel := APieceTable.DocumentModel;
      AUpdateBeforePrint := GetActualUpdateDocVariablesBeforePrint(AModel, AUpdateType);
      if not AUpdateBeforePrint then
        Exit(nil);
      if not AModel.FieldOptions.UpdateDocVariablesBeforeCopy and (AUpdateType = TdxUpdateFieldOperationType.Copy) then
        Exit(nil);
    end;
    AResult := AField.Update(APieceTable, AMailMergeDataMode, ADocumentField);
    Result := TdxCalculateFieldResult.Create(AResult, AField.GetAllowedUpdateFieldTypes(FUpdateOnLoadOptions));
  finally
    AField.Free;
  end;
end;

function TdxFieldCalculatorService.CalculateExpressionValue(APieceTable: TdxPieceTable; AScanner: TdxFieldScanner; AField: TdxField): TdxCalculateFieldResult;
begin
  Result := nil;
end;

function TdxFieldCalculatorService.CalculateInvalidField(APieceTable: TdxPieceTable): TdxCalculateFieldResult;
begin
  Result := TdxCalculateFieldResult.Create(TdxCalculatedFieldValue.NullValue, [TdxUpdateFieldOperationType.Normal]);
end;

function TdxFieldCalculatorService.GetActualUpdateDocVariablesBeforePrint(
  AModel: TdxDocumentModel; AUpdateType: TdxUpdateFieldOperationType): Boolean;
begin
  case AModel.DocumentProperties.UpdateDocVariablesBeforePrint of
    TdxUpdateDocVariablesBeforePrint.Never:
      Result := False;
    TdxUpdateDocVariablesBeforePrint.Always:
      Result := True;
    else
      if not AModel.PrintingOptions.UpdateDocVariablesBeforePrint and
          (AUpdateType = TdxUpdateFieldOperationType.CreateModelForExport) then
        Result := False
      else
      if not AModel.FieldOptions.UpdateDocVariablesBeforePrint and
          (AUpdateType in [TdxUpdateFieldOperationType.CreateModelForExport, TdxUpdateFieldOperationType.Copy]) then
        Result := False
      else
        Result := True;
  end;
end;

function TdxFieldCalculatorService.GetFirstToken(APieceTable: TdxPieceTable; AField: TdxField): IdxToken;
var
  AIterator: TdxDocumentFieldIterator;
  AScanner: TdxFieldScanner;
begin
  try
    AIterator := TdxDocumentFieldIterator.Create(APieceTable, AField);
    AScanner := TdxFieldScanner.Create(AIterator, APieceTable.DocumentModel.MaxFieldSwitchLength, APieceTable.DocumentModel.EnableFieldNames, APieceTable.SupportFieldCommonStringFormat);
    Result := AScanner.Scan;
  except
    Result := nil;
  end;
end;

class function TdxFieldCalculatorService.ParseInstructions(AScanner: TdxFieldScanner; AField: TdxCalculatedFieldBase): TdxInstructionCollection;
var
  AToken, AFieldArgument, ANextToken: IdxToken;
  AInterval: TdxDocumentLogInterval;
begin
  Result := TdxInstructionCollection.Create;
  while True do
  begin
    AToken := AScanner.Scan;
    if AToken.ActualKind = TdxTokenKind.Eof then
      Break;

    if IsFieldArgument(AToken.ActualKind) then
      Result.AddArgument(AToken)
    else
    begin
      if IsSwitchWithArgument(AField, AToken) then
      begin
        if AField.IsSwitchArgumentField(AToken.Value) then
        begin
          if AScanner.IsFieldStart then
          begin
            AFieldArgument := AScanner.ScanEntireFieldToken;
            AInterval := TdxDocumentLogInterval.Create(AToken.Position, AFieldArgument.Position - AToken.Position);
            Result.AddSwitch(AToken.Value, AInterval, AFieldArgument);
          end
          else
          begin
            ANextToken := AScanner.Peek;
            if IsFieldArgument(ANextToken.ActualKind) then
              AScanner.Scan;
          end;
        end
        else
        begin
          ANextToken := AScanner.Peek;
          if IsFieldArgument(ANextToken.ActualKind) then
          begin
            AFieldArgument := AScanner.Scan;
            AInterval := TdxDocumentLogInterval.Create(AToken.Position, AFieldArgument.Position - AToken.Position);
            Result.AddSwitch(AToken.Value, AInterval, AFieldArgument);
          end
          else if AField.CanUseSwitchWithoutArgument(AToken.Value) then
          begin
            AInterval := TdxDocumentLogInterval.Create(AToken.Position, ANextToken.Position - AToken.Position);
            Result.AddSwitch(AToken.Value, AInterval);
          end;
        end;
      end
      else
      begin
        ANextToken := AScanner.Peek;
        AInterval := TdxDocumentLogInterval.Create(AToken.Position, ANextToken.Position - AToken.Position);
        Result.AddSwitch(AToken.Value, AInterval);
      end;
    end;
  end;
end;

class function TdxFieldCalculatorService.IsSwitchWithArgument(AField: TdxCalculatedFieldBase; AToken: IdxToken): Boolean;
var
  AKind: TdxTokenKind;
begin
  AKind := AToken.ActualKind;
  Result := (AKind in [TdxTokenKind.NumericFormattingSwitchBegin, TdxTokenKind.GeneralFormattingSwitchBegin,
    TdxTokenKind.DateAndTimeFormattingSwitchBegin, TdxTokenKind.CommonStringFormatSwitchBegin]) or
    AField.IsSwitchWithArgument(AToken.Value);
end;

class function TdxFieldCalculatorService.IsFieldArgument(ATokenKind: TdxTokenKind): Boolean;
begin
  Result := (ATokenKind = TdxTokenKind.Text) or (ATokenKind = TdxTokenKind.QuotedText);
end;

{ TdxScannerStateBase }

constructor TdxScannerStateBase.Create(AScanner: TdxFieldScanner);
begin
  inherited Create;
  FScanner := AScanner;
end;

function TdxScannerStateBase.CreateToken(AKind: TdxTokenKind; APosition: TdxDocumentLogPosition; const AValue: string;
  ALength: Integer): IdxToken;
begin
  Result := FScanner.CreateToken(AKind, APosition, AValue, ALength)
end;

function TdxScannerStateBase.GetIterator: IdxFieldIterator;
begin
  Result := Scanner.Iterator;
end;

{ TdxScannerStateSimpleToken }

function TdxScannerStateSimpleToken.GetStateType: TdxScannerStateType;
begin
  Result := TdxScannerStateType.Simple;
end;

function TdxScannerStateSimpleToken.ReadNextToken: IdxToken;
var
  AStart: TdxDocumentLogPosition;
  AVal: TStringBuilder;
  AFirstChar: Boolean;
  ACh: Char;
  AStrVal: string;
  AKind: TdxTokenKind;
begin
  AStart := Iterator.Position;
  if Iterator.PeekNextChar = '=' then
  begin
    Iterator.AdvanceNextChar;
    Exit(CreateToken(TdxTokenKind.OpEQ, AStart, '=', Iterator.Position - AStart));
  end;

  AVal := TStringBuilder.Create;
  try
    AFirstChar := True;
    while True do
    begin
      ACh := Iterator.PeekNextChar;
      if ((not AFirstChar and IsEndOfToken(ACh))) or (Iterator.IsEnd) then
        Break;
      AFirstChar := False;
      Iterator.AdvanceNextChar;
      AVal.Append(UpperCase(ACh));
    end;
    AStrVal := AVal.ToString;
    AKind := Scanner.GetTokenKindByVal(AStrVal);
    Result := CreateToken(AKind, AStart, AStrVal, Iterator.Position - AStart);
  finally
    AVal.Free;
  end;
end;

function TdxScannerStateSimpleToken.IsEndOfToken(ACh: Char): Boolean;
begin
  Result := Scanner.IsWhiteSpace(ACh) or (ACh = '\');
end;

function TdxScannerStateSimpleToken.GetNextState(AToken: IdxToken): TdxScannerStateType;
begin
  case AToken.ActualKind of
    TdxTokenKind.OpEQ:
      Result := TdxScannerStateType.Expression;
    TdxTokenKind.Eq:
      Result := TdxScannerStateType.EqSwitches;
    else
      Result := TdxScannerStateType.Instructions;
  end;
end;

{ TdxScannerStateExpression }

function TdxScannerStateExpression.GetStateType: TdxScannerStateType;
begin
  Result := TdxScannerStateType.Expression;
end;

function TdxScannerStateExpression.ReadNextToken: IdxToken;
var
  AVal: TStringBuilder;
  AStart: TdxDocumentLogPosition;
  ACh: Char;
  AFieldNameStarted: Boolean;
  AOpenBracketCount, ALength: Integer;
  AStrVal: string;
  ATokenKind: TdxTokenKind;
begin
  AVal := TStringBuilder.Create;
  try
    AStart := Iterator.Position;
    ACh := Iterator.PeekNextChar;

    if IsSpecialChar(ACh) then
      Exit(ReadSpecialCharToken);

    if IsConstantChar(ACh) then
      Exit(ReadConstantToken);

    if ACh = '%' then
    begin
      Iterator.AdvanceNextChar;
      Exit(CreateToken(TdxTokenKind.Percent, AStart, '%', Iterator.Position - AStart));
    end;

    if IsSwitchStart(ACh) then
    begin
      Iterator.AdvanceNextChar;
      Exit(ReadSwitchToken(AStart));
    end;

    AFieldNameStarted := False;
    AOpenBracketCount := 0;
    if Scanner.EnableFieldNames then
      AFieldNameStarted := Iterator.PeekNextChar = '['; 

    while True do
    begin
      ACh := Iterator.PeekNextChar;
      if (not AFieldNameStarted and IsEndOfToken(ACh)) or (AFieldNameStarted and (ACh = #0)) then
        Break;
      Iterator.AdvanceNextChar;
      AVal.Append(ACh);
      if AFieldNameStarted then
      begin
        if ACh = ']' then
        begin
          Dec(AOpenBracketCount);
          if AOpenBracketCount = 0 then
            Break;
        end;
        if ACh = '[' then
          Inc(AOpenBracketCount);
      end;
    end;
    AStrVal := AVal.ToString;
  finally
    AVal.Free;
  end;
  ALength := Iterator.Position - AStart;
  if Scanner.IsWhiteSpace(ACh) then
  begin
    Scanner.SkipWhitespaces(True);
  end;
  if (not Iterator.IsEnd and (Iterator.PeekNextChar = '(')) then
    ATokenKind := TdxTokenKind.FunctionName
  else
    ATokenKind := TdxTokenKind.Text;
  Result := CreateToken(ATokenKind, AStart, AStrVal, ALength);
end;

function TdxScannerStateExpression.GetNextState(AToken: IdxToken): TdxScannerStateType;
begin
  if Scanner.IsSwitchToken(AToken.ActualKind) then
    Result := TdxScannerStateType.Instructions
  else
    Result := StateType;
end;

function TdxScannerStateExpression.IsEndOfToken(ACh: Char): Boolean;
begin
  Result := IsSpecialChar(ACh) or (ACh = #0) or Scanner.IsWhiteSpace(ACh);
end;

function TdxScannerStateExpression.IsSpecialChar(ACh: Char): Boolean;
begin
  Result := CharInSet(ACh, ['+', '-', '*', '/', '^', '(', ')', '=', '<', '>']) or (ACh = Scanner.SeparatorChar);
end;

function TdxScannerStateExpression.IsConstantChar(ACh: Char): Boolean;
begin
  Result := ((ACh >= '0') and (ACh <= '9')) or (ACh = Scanner.DecimalSeparator);
end;

function TdxScannerStateExpression.ReadConstantToken: IdxToken;
var
  AStart: TdxDocumentLogPosition;
  AVal: TStringBuilder;
  ACh: Char;
  AStrVal: string;
begin
  AStart := Iterator.Position;
  AVal := TStringBuilder.Create;
  try
    while True do
    begin
      ACh := Iterator.PeekNextChar;
      if not IsConstantChar(ACh) then
        Break;
      Iterator.AdvanceNextChar;
      AVal.Append(ACh.ToUpper); 
    end;
    AStrVal := AVal.ToString;
    Result := CreateToken(TdxTokenKind.Constant, AStart, AStrVal, Iterator.Position - AStart);
  finally
    AVal.Free;
  end;
end;

function TdxScannerStateExpression.ReadSpecialCharToken: IdxToken;
var
  AStart: TdxDocumentLogPosition;
  ACh, ANextChar: Char;
begin
  AStart := Iterator.Position;
  ACh := Iterator.ReadNextChar;
  ANextChar := Iterator.PeekNextChar;
  case ACh of
    '=':
      Exit(CreateToken(TdxTokenKind.OpEQ, AStart, '=', Iterator.Position - AStart));
    '<':
      case ANextChar of
        '>':
          begin
            Iterator.AdvanceNextChar;
            Exit(CreateToken(TdxTokenKind.OpNEQ, AStart, '<>', Iterator.Position - AStart));
          end;
        '=':
          begin
            Iterator.AdvanceNextChar;
            Exit(CreateToken(TdxTokenKind.OpLOWEQ, AStart, '<=', Iterator.Position - AStart));
          end
      else
        Exit(CreateToken(TdxTokenKind.OpLOW, AStart, '<', Iterator.Position - AStart));
      end;
    '>':
      if ANextChar = '=' then
      begin
        Iterator.AdvanceNextChar;
        Exit(CreateToken(TdxTokenKind.OpHIEQ, AStart, '>=', Iterator.Position - AStart));
      end
      else
        Exit(CreateToken(TdxTokenKind.OpHI, AStart, '>', Iterator.Position - AStart));
    '+':
      Exit(CreateToken(TdxTokenKind.OpPLUS, AStart, '+', Iterator.Position - AStart));
    '-':
      Exit(CreateToken(TdxTokenKind.OpMINUS, AStart, '-', Iterator.Position - AStart));
    '*':
      Exit(CreateToken(TdxTokenKind.OpMUL, AStart, '*', Iterator.Position - AStart));
    '/':
      Exit(CreateToken(TdxTokenKind.OpDIV, AStart, '/', Iterator.Position - AStart));
    '^':
      Exit(CreateToken(TdxTokenKind.OpPOW, AStart, '^', Iterator.Position - AStart));
    '(':
      Exit(CreateToken(TdxTokenKind.OpenParenthesis, AStart, '(', Iterator.Position - AStart));
    ')':
      Exit(CreateToken(TdxTokenKind.CloseParenthesis, AStart, ')', Iterator.Position - AStart));
    else
      if ACh = Scanner.SeparatorChar then
        Exit(CreateToken(TdxTokenKind.SeparatorChar, AStart, Scanner.SeparatorChar, Iterator.Position - AStart))
      else
        Exit(CreateToken(TdxTokenKind.Invalid, AStart, ''));
  end;
end;

function TdxScannerStateExpression.IsSwitchStart(ACh: Char): Boolean;
begin
  Result := ACh = '\';
end;

function TdxScannerStateExpression.ReadSwitchToken(AStart: TdxDocumentLogPosition): IdxToken;
var
  ACh: Char;
begin
  ACh := Iterator.PeekNextChar;
  case ACh of
    '@':
      begin
        Iterator.AdvanceNextChar;
        Exit(CreateToken(TdxTokenKind.DateAndTimeFormattingSwitchBegin, AStart, '\@', Iterator.Position - AStart));
      end;
    '#':
      begin
        Iterator.AdvanceNextChar;
        Exit(CreateToken(TdxTokenKind.NumericFormattingSwitchBegin, AStart, '\#', Iterator.Position - AStart));
      end;
    '*':
      begin
        Iterator.AdvanceNextChar;
        Exit(CreateToken(TdxTokenKind.GeneralFormattingSwitchBegin, AStart, '\*', Iterator.Position - AStart));
      end;
    '!':
      begin
        Iterator.AdvanceNextChar;
        Exit(CreateToken(TdxTokenKind.FieldSwitchCharacter, AStart, '\!', Iterator.Position - AStart));
      end;
    '$':
      if Scanner.SupportFieldCommonStringFormat then
      begin
        Iterator.AdvanceNextChar;
        Exit(CreateToken(TdxTokenKind.CommonStringFormatSwitchBegin, AStart, '\$', Iterator.Position - AStart));
      end
      else
        Exit(ReadFieldSwitchCharacter(AStart)); 
    else
      Exit(ReadFieldSwitchCharacter(AStart));
  end;
end;

function TdxScannerStateExpression.ReadFieldSwitchCharacter(AStart: TdxDocumentLogPosition): IdxToken;
var
  AVal: string;
  AMaxResultLength: Integer;
  ACh: Char;
begin
  AVal := '\';
  AMaxResultLength := Scanner.MaxFieldSwitchLength + 1;
  while Length(AVal) < AMaxResultLength do
  begin
    ACh := Iterator.PeekNextChar.ToLower; 
    if not IsLatinLetter(ACh) then
      Break;
    AVal := AVal + ACh;
    Iterator.AdvanceNextChar;
  end;
  Result := CreateToken(TdxTokenKind.FieldSwitchCharacter, AStart, AVal, Iterator.Position - AStart);
end;

function TdxScannerStateExpression.IsLatinLetter(ACh: Char): Boolean;
begin
  Result := (ACh >= 'a') and (ACh <= 'z');
end;

{ TdxScannerStateInstructions }

function TdxScannerStateInstructions.GetStateType: TdxScannerStateType;
begin
  Result := TdxScannerStateType.Instructions;
end;

function TdxScannerStateInstructions.ReadNextToken: IdxToken;
var
  AStart: TdxDocumentLogPosition;
  AVal: TStringBuilder;
  ACh: Char;
  AStrVal: string;
begin
  AStart := Iterator.Position;
  AVal := TStringBuilder.Create;
  try
    ACh := Iterator.PeekNextChar;
    if IsSwitchStart(ACh) then
    begin
      Iterator.AdvanceNextChar;
      Exit(ReadSwitchToken(AStart));
    end;
    while True do
    begin
      ACh := Iterator.PeekNextChar;
      if (Iterator.IsEnd) or (Scanner.IsWhiteSpace(ACh)) or (IsSwitchStart(ACh)) then
        Break;
      Iterator.AdvanceNextChar;
      AVal.Append(ACh);
    end;
    AStrVal := AVal.ToString;
    Result := CreateToken(TdxTokenKind.Text, AStart, AStrVal, Iterator.Position - AStart);
  finally
    AVal.Free;
  end;
end;

function TdxScannerStateInstructions.GetNextState(AToken: IdxToken): TdxScannerStateType;
begin
  Result := StateType;
end;

function TdxScannerStateInstructions.IsSwitchStart(ACh: Char): Boolean;
begin
  Result := ACh = '\';
end;

function TdxScannerStateInstructions.ReadSwitchToken(AStart: TdxDocumentLogPosition): IdxToken;
var
  ACh: Char;
begin
  ACh := Iterator.PeekNextChar;
  case ACh of
    '@':
      begin
        Iterator.AdvanceNextChar;
        Exit(CreateToken(TdxTokenKind.DateAndTimeFormattingSwitchBegin, AStart, '\@', Iterator.Position - AStart));
      end;
    '#':
      begin
        Iterator.AdvanceNextChar;
        Exit(CreateToken(TdxTokenKind.NumericFormattingSwitchBegin, AStart, '\#', Iterator.Position - AStart));
      end;
    '*':
      begin
        Iterator.AdvanceNextChar;
        Exit(CreateToken(TdxTokenKind.GeneralFormattingSwitchBegin, AStart, '\*', Iterator.Position - AStart));
      end;
    '!':
      begin
        Iterator.AdvanceNextChar;
        Exit(CreateToken(TdxTokenKind.FieldSwitchCharacter, AStart, '\!', Iterator.Position - AStart));
      end;
    '$':
      if Scanner.SupportFieldCommonStringFormat then
      begin
        Iterator.AdvanceNextChar;
        Exit(CreateToken(TdxTokenKind.CommonStringFormatSwitchBegin, AStart, '\$', Iterator.Position - AStart));
      end
      else
        Exit(ReadFieldSwitchCharacter(AStart));
    else
      Exit(ReadFieldSwitchCharacter(AStart));
  end;
end;

function TdxScannerStateInstructions.ReadFieldSwitchCharacter(AStart: TdxDocumentLogPosition): IdxToken;
var
  AVal: string;
  AMaxResultLength: Integer;
  ACh: Char;
begin
  AVal := '\';
  AMaxResultLength := Scanner.MaxFieldSwitchLength + 1;
  while Length(AVal) < AMaxResultLength do
  begin
    ACh := Iterator.PeekNextChar.ToLower;
    if not IsLatinLetter(ACh) then
      Break;
    AVal := AVal + ACh;
    Iterator.AdvanceNextChar;
  end;
  Result := CreateToken(TdxTokenKind.FieldSwitchCharacter, AStart, AVal, Iterator.Position - AStart);
end;

function TdxScannerStateInstructions.IsLatinLetter(ACh: Char): Boolean;
begin
  Result := (ACh >= 'a') and (ACh <= 'z');
end;

{ TdxScannerStateEqSwitches }

function TdxScannerStateEqSwitches.GetStateType: TdxScannerStateType;
begin
  Result := TdxScannerStateType.EqSwitches;
end;

function TdxScannerStateEqSwitches.ReadNextToken: IdxToken;
var
  AStart: TdxDocumentLogPosition;
  AVal: TStringBuilder;
  ACh: Char;
  AStrVal: string;
begin
  AStart := Iterator.Position;
  AVal := TStringBuilder.Create;
  try
    ACh := Iterator.PeekNextChar;
    if ACh = '(' then
    begin
      Iterator.AdvanceNextChar;
      Exit(CreateToken(TdxTokenKind.OpenParenthesis, AStart, '(', Iterator.Position - AStart));
    end;
    if IsSwitchStart(ACh) then
    begin
      Iterator.AdvanceNextChar;
      Exit(ReadSwitchToken(AStart));
    end;
    while True do
    begin
      ACh := Iterator.PeekNextChar;
      if (Iterator.IsEnd) or (Scanner.IsWhiteSpace(ACh)) then
        Break;
      Iterator.AdvanceNextChar;
      AVal.Append(ACh);
    end;
    AStrVal := AVal.ToString;
    Result := CreateToken(TdxTokenKind.Text, AStart, AStrVal, Iterator.Position - AStart);
  finally
    AVal.Free;
  end;
end;

function TdxScannerStateEqSwitches.GetNextState(AToken: IdxToken): TdxScannerStateType;
begin
  if AToken.ActualKind = TdxTokenKind.OpenParenthesis then
    Result := TdxScannerStateType.EqInstructions
  else
    Result := StateType;
end;

{ TdxScannerStateEqInstructions }

function TdxScannerStateEqInstructions.GetStateType: TdxScannerStateType;
begin
  Result := TdxScannerStateType.EqInstructions;
end;

function TdxScannerStateEqInstructions.ReadNextToken: IdxToken;
var
  AStart: TdxDocumentLogPosition;
  AVal: TStringBuilder;
  ACh: Char;
  AStrVal: string;
begin
  AStart := Iterator.Position;
  AVal := TStringBuilder.Create;
  try
    ACh := Iterator.PeekNextChar;
    if ACh = ')' then
    begin
      Iterator.AdvanceNextChar;
      Exit(CreateToken(TdxTokenKind.CloseParenthesis, AStart, ')', Iterator.Position - AStart));
    end;
    if ACh = Scanner.SeparatorChar then
    begin
      Iterator.AdvanceNextChar;
      Exit(CreateToken(TdxTokenKind.SeparatorChar, AStart, ACh, Iterator.Position - AStart));
    end;
    while True do
    begin
      ACh := Iterator.PeekNextChar;
      if (Iterator.IsEnd) or (IsEndOfToken(ACh)) then
        Break;
      Iterator.AdvanceNextChar;
      AVal.Append(ACh);
    end;
    AStrVal := AVal.ToString;
    Result := CreateToken(TdxTokenKind.Text, AStart, AStrVal, Iterator.Position - AStart);
  finally
    AVal.Free;
  end;
end;

function TdxScannerStateEqInstructions.GetNextState(AToken: IdxToken): TdxScannerStateType;
begin
  if AToken.ActualKind = TdxTokenKind.CloseParenthesis then
    Result := TdxScannerStateType.EqSwitches
  else
    Result := StateType;
end;

function TdxScannerStateEqInstructions.IsEndOfToken(ACh: Char): Boolean;
begin
  Result := (ACh = ')') or (ACh = Scanner.SeparatorChar);
end;

{ TdxFieldScanner }

class constructor TdxFieldScanner.Initialize;
begin
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.ConstructorStarted(UnitName, 'TdxFieldScanner.Initialize', SysInit.HInstance);{$ENDIF}
  SimpleTokens := TArray<string>.Create(
    'IF', 'COMPARE', 'CREATEDATE', 'DATE', 'EDITTIME', 'PRINTDATE', 'SAVEDATE', 'TIME',
    'DOCVARIABLE', 'GOTOBUTTON', 'MACROBUTTON', 'PRINT', 'ADVANCE', 'SYMBOL', 'INDEX',
    'RD', 'TA', 'TC', 'TOA', 'TOC', 'XE',
    'AUTOTEXT', 'AUTOTEXTLIST', 'BIBLIOGRAPHY', 'CITATION', 'HYPERLINK',
    'INCLUDEPICTURE', 'INCLUDETEXT', 'LINK', 'NOTEREF', 'PAGEREF', 'QUOTE', 'REF', 'STYLEREF',
    'ADDRESSBLOCK', 'ASK', 'DATABASE', 'FILLIN', 'GREETINGLINE',
    'MERGEFIELD', 'MERGEREC', 'MERGESEQ', 'NEXT', 'SET', 'SKIPIF',
    'NEXTIF',
    'AUTONUM', 'AUTONUMLGL', 'AUTONUMOUT', 'BARCODE', 'LISTNUM', 'PAGE', 'REVNUM',
    'SECTION', 'SECTIONPAGES', 'SEQ',
    'USERADDRESS', 'USERINITIALS', 'USERNAME',
    'FORMCHECKBOX', 'FORMDROPDOWN', 'FORMTEXT');
  DocPropertyInfoCommonTokens := TArray<string>.Create('AUTHOR', 'COMMENTS', 'KEYWORDS',
    'LASTSAVEDBY', 'SUBJECT', 'TEMPLATE', 'TITLE');
  DocPropertyCategoryTokens := TArray<string>.Create(
    'BYTES', 'CATEGORY', 'CHARACTERS', 'CHARACTERSWITHSPACES',
    'COMPANY', 'CREATETIME', 'HYPERLINKBASE', 'LASTPRINTED', 'LASTSAVEDTIME',
    'LINES', 'MANAGER', 'NAMEOFAPPLICATION', 'ODMADOCID', 'PAGES', 'PARAGRAPHS',
    'REVISIONNUMBER', 'SECURITY', 'TOTALEDITINGTIME', 'WORDS');
  DocumentInformationTokens := TArray<string>.Create('FILENAME', 'FILESIZE', 'INFO',
    'NUMCHARS', 'NUMPAGES', 'NUMWORDS');
  TokenDictionary := TdxNamedOrdinalDictionary<TdxTokenKind>.Create;
  AddTokensToDictionary(SimpleTokens, TdxTokenKind.Simple);
  AddTokensToDictionary(DocPropertyInfoCommonTokens, TdxTokenKind.DocPropertyInfoCommon);
  AddTokensToDictionary(DocPropertyCategoryTokens, TdxTokenKind.DocPropertyCategory);
  AddTokenToDictionary(DocPropertyToken, TdxTokenKind.DocProperty);
  AddTokensToDictionary(DocumentInformationTokens, TdxTokenKind.DocumentInformation);
  AddTokenToDictionary(EqToken, TdxTokenKind.Eq);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.ConstructorFinished(UnitName, 'TdxFieldScanner.Initialize', SysInit.HInstance);{$ENDIF}
end;

class destructor TdxFieldScanner.Finalize;
begin
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.DestructorStarted(UnitName, 'TdxFieldScanner.Finalize', SysInit.HInstance);{$ENDIF}
  FreeAndNil(TokenDictionary);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.DestructorFinished(UnitName, 'TdxFieldScanner.Finalize', SysInit.HInstance);{$ENDIF}
end;

constructor TdxFieldScanner.Create(const AIterator: IdxFieldIterator;
  AMaxFieldSwitchLength: Integer; AEnableFieldNames: Boolean; ASupportFieldCommonStringFormat: Boolean);
begin
  inherited Create;
  FDecimalSeparator := dxFormatSettings.DecimalSeparator;
  if DecimalSeparator = ',' then
    FSeparatorChar := ';'
  else
    FSeparatorChar := ',';

  FIterator := AIterator;
  FState := TdxScannerStateSimpleToken.Create(Self);
  FMaxFieldSwitchLength := AMaxFieldSwitchLength;
  FEnableFieldNames := AEnableFieldNames;
  FSupportFieldCommonStringFormat := ASupportFieldCommonStringFormat;
  FTokens := TdxTokenList.Create;
end;

constructor TdxFieldScanner.Create(const AIterator: IdxFieldIterator; APieceTable: TdxPieceTable);
begin
  Create(AIterator, APieceTable.DocumentModel.MaxFieldSwitchLength, APieceTable.DocumentModel.EnableFieldNames, APieceTable.SupportFieldCommonStringFormat);
end;

destructor TdxFieldScanner.Destroy;
begin
  FreeAndNil(FState);
  FreeAndNil(FTokens);
  inherited Destroy;
end;

class procedure TdxFieldScanner.AddTokensToDictionary(const ATokens: TArray<string>; AKind: TdxTokenKind);
var
  ACount, I: Integer;
begin
  ACount := Length(ATokens);
  for I := 0 to ACount - 1 do
    AddTokenToDictionary(ATokens[I], AKind);
end;

class procedure TdxFieldScanner.AddTokenToDictionary(const AToken: string; AKind: TdxTokenKind);
begin
  TokenDictionary.Add(AToken, AKind);
end;

function TdxFieldScanner.CreateToken(AKind: TdxTokenKind; APosition: TdxDocumentLogPosition = 0;
  const Value: string = ''; ALength: Integer = 1): IdxToken;
begin
  FTokens.Add(TdxToken.Create(AKind, APosition, Value, ALength));
  Result := FTokens.Last;
end;

function TdxFieldScanner.GetSeparatorChar: Char;
begin
  Result := FSeparatorChar;
end;

function TdxFieldScanner.GetDecimalSeparator: Char;
begin
  Result := FDecimalSeparator;
end;

function TdxFieldScanner.Scan: IdxToken;
begin
  if (FCurrentScanToken <> nil) and (FCurrentScanToken.Next <> nil) then
    FCurrentScanToken := FCurrentScanToken.Next
  else
    FCurrentScanToken := Peek;
  ResetPeek;
  Result := FCurrentScanToken;
end;

procedure TdxFieldScanner.SwitchState(AStateType: TdxScannerStateType);
begin
  FState.Free;
  case AStateType of
    TdxScannerStateType.EqInstructions:
      FState := TdxScannerStateEqInstructions.Create(Self);
    TdxScannerStateType.EqSwitches:
      FState := TdxScannerStateEqSwitches.Create(Self);
    TdxScannerStateType.Expression:
      FState := TdxScannerStateExpression.Create(Self);
    TdxScannerStateType.Instructions:
      FState := TdxScannerStateInstructions.Create(Self);
    TdxScannerStateType.Simple:
      FState := TdxScannerStateSimpleToken.Create(Self);
  end;
end;

function TdxFieldScanner.Peek: IdxToken;
var
  AToken: IdxToken;
begin
  if (FCurrentPeekToken = nil) or (FCurrentPeekToken.Next = nil) then
  begin
    AToken := PeekCore;
    if AToken.ActualKind <> TdxTokenKind.Eof then
      SwitchState(FState.GetNextState(AToken));
    if FCurrentPeekToken = nil then
    begin
      FCurrentPeekToken := AToken;
      Exit(FCurrentPeekToken);
    end;
    FCurrentPeekToken.Next := AToken;
  end;
  FCurrentPeekToken := FCurrentPeekToken.Next;
  Result := FCurrentPeekToken;
end;

function TdxFieldScanner.PeekCore: IdxToken;
var
  ACh: Char;
begin
  SkipWhitespaces(True);
  if Iterator.IsEnd then
    Exit(CreateToken(TdxTokenKind.Eof, Iterator.Position, ''));
  ACh := Iterator.PeekNextChar;
  if ACh <> '"' then
    Exit(ReadToken)
  else
  begin
    Iterator.AdvanceNextChar;
    Exit(ReadQuotedText);
  end;
end;

function TdxFieldScanner.ReadToken: IdxToken;
begin
  Result := FState.ReadNextToken;
end;

function TdxFieldScanner.ReadQuotedText: IdxToken;
var
  AVal: TStringBuilder;
  ACh: Char;
  ALastCharPosition: TdxDocumentLogPosition;
begin
  Result := CreateToken(TdxTokenKind.QuotedText, Iterator.Position, '');
  AVal := TStringBuilder.Create;
  try
    ALastCharPosition := Iterator.Position;
    ACh := Iterator.ReadNextChar;
    while not Iterator.IsEnd and (ACh <> '"') do
    begin
      AVal.Append(ACh);
      ALastCharPosition := Iterator.Position;
      ACh := Iterator.ReadNextChar;
    end;
    Result.Value := AVal.ToString;
    Result.Length := ALastCharPosition - Result.Position;
  finally
    AVal.Free;
  end;
end;

procedure TdxFieldScanner.SkipWhitespaces(ASkipNestedFields: Boolean);
begin
  while not Iterator.IsEnd and IsWhiteSpace(Iterator.PeekNextChar) do
    Iterator.AdvanceNextChar(ASkipNestedFields);
end;

function TdxFieldScanner.IsFieldStart: Boolean;
begin
  SkipWhitespaces(False);
  Result := Iterator.IsFieldCodeStart;
end;

function TdxFieldScanner.ScanEntireFieldToken: IdxToken;
var
  AStart, AEnd: TdxDocumentLogPosition;
begin
  AStart := Iterator.Position;
  AEnd := AStart;
  repeat
    Iterator.AdvanceNextChar;
    if Iterator.IsFieldCodeEnd then
      AEnd := Iterator.Position;
  until not (not Iterator.IsEnd and not Iterator.IsFieldEnd);
  Result := CreateToken(TdxTokenKind.Template, AStart + 1, '', AEnd - AStart - 1);
end;

function TdxFieldScanner.IsWhiteSpace(ACh: Char): Boolean;
begin
  Result := ACh.IsWhiteSpace;
end;

procedure TdxFieldScanner.ResetPeek;
begin
  FCurrentPeekToken := FCurrentScanToken;
end;

function TdxFieldScanner.GetTokenKindByVal(const AStrVal: string): TdxTokenKind;
begin
  if not TokenDictionary.TryGetValue(AStrVal, Result) then
    Result := TdxTokenKind.Invalid;
end;

function TdxFieldScanner.IsSwitchToken(AKind: TdxTokenKind): Boolean;
begin
  Result := (AKind = TdxTokenKind.FieldSwitchCharacter) or
    (AKind = TdxTokenKind.DateAndTimeFormattingSwitchBegin) or
    (AKind = TdxTokenKind.NumericFormattingSwitchBegin) or
    (AKind = TdxTokenKind.CommonStringFormatSwitchBegin) or
    (AKind = TdxTokenKind.GeneralFormattingSwitchBegin);
end;

function TdxFieldScanner.IsValidFirstToken(AToken: IdxToken): Boolean;
begin
  Result := TokenDictionary.ContainsKey(AToken.Value);
end;

{ TdxDocumentFieldIterator }

constructor TdxDocumentFieldIterator.Create(APieceTable: TdxSimplePieceTable; AField: TdxField);
var
  ARange: TdxTextRunBase;
begin
  inherited Create;
  FCharactersIterator := TdxCharactersDocumentModelIterator.Create(APieceTable);
  FPieceTable := APieceTable;

  FPosition := TdxDocumentModelPosition.FromRunStart(PieceTable, AField.FirstRunIndex + 1);
  SkipNestedFields;
  ARange := PieceTable.Runs[FPosition.RunIndex];
  FCurrentRunText := TdxTextRunBaseAccess(ARange).GetRawTextFast(PieceTable.TextBuffer);
  FLastRunIndex := AField.Code.&End;
end;

destructor TdxDocumentFieldIterator.Destroy;
begin
  FreeAndNil(FCharactersIterator);
  inherited Destroy;
end;

function TdxDocumentFieldIterator.GetPieceTable: TdxSimplePieceTable;
begin
  Result := FPieceTable;
end;

function TdxDocumentFieldIterator.ReadNextChar: Char;
begin
  Result := PeekNextChar;
  AdvanceNextChar;
end;

function TdxDocumentFieldIterator.IsEnd: Boolean;
begin
  Result := FPosition.RunIndex = FLastRunIndex;
end;

function TdxDocumentFieldIterator.GetPosition: TdxDocumentLogPosition;
begin
  Result := FPosition.LogPosition;
end;

function TdxDocumentFieldIterator.PeekNextChar: Char;
begin
  if not IsEnd then
    Result := FCurrentRunText[FPosition.RunOffset + 1]
  else
    Result := #0;
end;

function TdxDocumentFieldIterator.IsFieldCodeStart: Boolean;
begin
  Result := not IsEnd and (PieceTable.Runs[FPosition.RunIndex] is TdxFieldCodeStartRun);
end;

function TdxDocumentFieldIterator.IsFieldEnd: Boolean;
begin
  Result := not IsEnd and (PieceTable.Runs[FPosition.RunIndex] is TdxFieldResultEndRun);
end;

function TdxDocumentFieldIterator.IsFieldCodeEnd: Boolean;
begin
  Result := not IsEnd and (PieceTable.Runs[FPosition.RunIndex] is TdxFieldCodeEndRun);
end;

procedure TdxDocumentFieldIterator.AdvanceNextChar(ASkipNestedFields: Boolean = True);
var
  APrevRunIndex: TdxRunIndex;
begin
  APrevRunIndex := FPosition.RunIndex;
  if APrevRunIndex = FLastRunIndex then
    Exit;
  FPosition := FCharactersIterator.MoveForward(FPosition);
  if FPosition.RunIndex <> APrevRunIndex then
  begin
    if ASkipNestedFields then
      SkipNestedFields;
    if FPosition.RunIndex <> FLastRunIndex then
      FCurrentRunText := TdxTextRunBaseAccess(PieceTable.Runs[FPosition.RunIndex]).GetRawTextFast(PieceTable.TextBuffer);
  end;
end;

function TdxDocumentFieldIterator.IsNestedFieldBegin(ARange: TdxTextRunBase): Boolean;
begin
  Result := ARange is TdxFieldCodeStartRun;
end;

function TdxDocumentFieldIterator.IsNestedFieldEnd(ARange: TdxTextRunBase): Boolean;
begin
  Result := (FNestedLevel > 0) and (ARange is TdxFieldResultEndRun);
end;

procedure TdxDocumentFieldIterator.StartNestedField;
var
  ARanges: TdxTextRunCollection;
  AInnerNestedLevel: Integer;
  ATextRun: TdxTextRunBase;
begin
  ARanges := PieceTable.Runs;
  AInnerNestedLevel := 1;
  while AInnerNestedLevel > 0 do
  begin
    FPosition.RunIndex := FPosition.RunIndex + 1;
    ATextRun := ARanges[FPosition.RunIndex];
    if ATextRun is TdxFieldCodeStartRun then
      Inc(AInnerNestedLevel);
    if ATextRun is TdxFieldCodeEndRun then
      Dec(AInnerNestedLevel);
  end;
  FPosition := TdxDocumentModelPosition.FromRunStart(PieceTable, FPosition.RunIndex + 1);
  Inc(FNestedLevel);
end;

procedure TdxDocumentFieldIterator.EndNestedField;
begin
  FPosition := TdxDocumentModelPosition.FromRunStart(PieceTable, FPosition.RunIndex + 1);
  Dec(FNestedLevel);
end;

procedure TdxDocumentFieldIterator.SkipNestedFields;
var
  APositionChanged: Boolean;
begin
  repeat
    APositionChanged := False;
    while IsNestedFieldBegin(PieceTable.Runs[FPosition.RunIndex]) do
    begin
      StartNestedField;
      APositionChanged := True;
    end;
    while IsNestedFieldEnd(PieceTable.Runs[FPosition.RunIndex]) do
    begin
      EndNestedField;
      APositionChanged := True;
    end;
  until not APositionChanged;
end;


end.
