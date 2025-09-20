{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressEntityMapping Framework                           }
{                                                                    }
{           Copyright (c) 2016-2024 Developer Express Inc.           }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSENTITYMAPPING FRAMEWORK AND    }
{   ALL ACCOMPANYING VCL CONTROLS AS PART OF AN EXECUTABLE PROGRAM   }
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

unit dxEMF.Utils;

interface

{$I cxVer.inc}
{$I dxEMF.inc}

uses
  Types, SysUtils, Classes, Generics.Defaults, Generics.Collections, DB, TypInfo, RTTI, SyncObjs, StrUtils, FmtBcd,
  dxCoreClasses, dxGenerics;

type

  TdxHash = Cardinal;

  { TdxFormatterHelper }

  TdxFormatterHelper = class
  public type
    TFunc = reference to function (const Arg1: string): string;
  public
    class function ExtractFromBrackets(const AValue: string): string;
    class function Concat(const AOperands: array of string; const ADelimiter: string = ','): string; overload; static;
    class function Concat(AOperands: TList<string>; AFunc: TFunc; const ADelimiter: string = ','): string; overload; static;
    class function CommaText(AOperands: TList<string>; const ADelimiter: string = ','): string; overload; static;
    class function GetName<T: record>(const AValue: T): string;
  end;

  { TValueHelper }

  TValueHelper = record helper for TValue
  private
    function ConvertInteger: Variant; inline;
    function ConvertOrdinal: Variant; inline;
  {$IF (CompilerVersion < 25) and Defined(CPUX64)}
  private
    procedure UpdateObject(AObject: TObject);
  public
    class function FromObject(AObject: TObject): TValue; static;
  {$IFEND}
  public
    class function ConvertArray(ASourceTypeInfo, ADestinationTypeInfo: PTypeInfo; ASourceBuffer: Pointer): TValue; static;
    class function FromNullable<T>(const AValue: TdxNullableValue<T>): TValue; static;
    function ConvertAsArray(ADestinationTypeInfo: PTypeInfo): TValue;
    function AsBCD: TBCD;
    function AsCardinal: Cardinal;
    function AsDateTime: TDateTime;
    function AsDouble: Double;
    function AsGUID: TGUID;
    function AsSingle: Single;
    function GetFieldType: TFieldType;
    function Equals(const AValue: TValue): Boolean;
    function IsBoolean: Boolean;
    function IsDateTime: Boolean;
    function IsDouble: Boolean;
    function IsEnumeration: Boolean;
    function IsInterface: Boolean;
    function IsNumeric: Boolean;
    function IsNullOrEmpty: Boolean;
    function IsRecord: Boolean;
    function IsSingle: Boolean;
    function IsString: Boolean;
    function ToFloat: Extended;
    function ToVariant: Variant;
  end;

  { TdxSmartValue }

  TdxSmartValue = record
  private type

    THolder = class(TInterfacedObject)
    strict private
      FObject: TObject;
    public
      constructor Create(const AObject: TObject);
      destructor Destroy; override;
    end;

  private
    FHolder: IInterface;
    FValue: TValue;
  public
    constructor Create(const AValue: TValue);
    class operator Implicit(const AValue: TdxSmartValue): TValue;
    class operator Implicit(const AValue: TValue): TdxSmartValue;
    class operator Implicit(const AObject: TObject): TdxSmartValue;
    class operator Implicit(AObject: TInterfacedObject): TdxSmartValue;
    class operator Implicit(const AInterface: IInterface): TdxSmartValue;
    class operator Implicit(const AValue: string): TdxSmartValue;
    class operator Equal(const A, B: TdxSmartValue): Boolean;
    class operator Equal(const A: TdxSmartValue; B: TObject): Boolean;
    class operator Equal(const A: TdxSmartValue; const B: TValue): Boolean;
    class operator Equal(A: TObject; const B: TdxSmartValue): Boolean;
    class operator Equal(const A: TValue; const B: TdxSmartValue): Boolean;
    class operator NotEqual(const A, B: TdxSmartValue): Boolean;
    class operator NotEqual(const A: TdxSmartValue; B: TObject): Boolean;
    class operator NotEqual(const A: TdxSmartValue; const B: TValue): Boolean;
    class operator NotEqual(A: TObject; const B: TdxSmartValue): Boolean;
    class operator NotEqual(const A: TValue; const B: TdxSmartValue): Boolean;
    function AsInterface: IInterface; inline;
    function AsObject: TObject; inline;
    function &As<T>: T;
    property Value: TValue read FValue;
  end;

  {$NODEFINE TdxSmartValue}
  (*$HPPEMIT 'namespace Dxemf{ namespace Utils{' *)
  (*$HPPEMIT 'struct DECLSPEC_DRECORD TdxSmartValue {};' *)
  (*$HPPEMIT '} }' *)

  { TdxSequentialGuid }

  TdxSequentialGuid = class
  public const
    SQLOrderMap: array[0 .. 15] of Word = (3, 2, 1, 0, 5, 4, 7, 6, 8, 9, 10, 11, 12, 13, 14, 15);
  strict private
    FCurrentGuid: TGUID;
  public
    constructor Create; overload;
    constructor Create(APreviousGuid: TGuid); overload;
    procedure CreateGUID(out AGuid: TGUID);

    property CurrentGuid: TGuid read FCurrentGuid;
  end;

  { TdxHashSetString }

  TdxHashSetString = class(TDictionary<string, Byte>)
  public
    procedure Add(const AValue: string);
    function Contains(const AValue: string): Boolean;
  end;

  { TdxObjectDictionary<T> }

  TdxObjectDictionary<T> = class(TObjectDictionary<TObject, T>);

  { TdxEMFDefault }

  TdxEMFDefault = class
  private
    class function GetMaxInSize: Integer; static;
  public
    class var DefaultCaseSensitive: Boolean;
    class function GetTerminalInSize(ASize: Integer; AParametersPerObject: Integer): Integer; overload; static;
    class function GetTerminalInSize(ASize: Integer): Integer; overload; static;
    class property MaxInSize: Integer read GetMaxInSize;
  end;

  { TdxObjectSet }

  TdxObjectSet = class
  public type
    TEnumerator = TDictionary<TObject, Byte>.TKeyEnumerator;
  strict private
    FDictionary: TDictionary<TObject, Byte>;
    function GetCount: Integer;
    function GetIsReadOnly: Boolean;
    function GetIsSynchronized: Boolean;
    function GetSyncRoot: TObject;
  public
    constructor Create; overload;
    constructor Create(ACapacity: Integer); overload;
    destructor Destroy; override;

    procedure Add(AItem: TObject); inline;
    procedure Clear;
    function Contains(AItem: TObject): Boolean;
    function Remove(AItem: TObject): Boolean; inline;
    function GetEnumerator: TEnumerator;
    function ToArray: TArray<TObject>;

    property Count: Integer read GetCount;
    property IsReadOnly: Boolean read GetIsReadOnly;
    property IsSynchronized: Boolean read GetIsSynchronized;
    property SyncRoot: TObject read GetSyncRoot;
  end;


  { TdxMRUCache<K, V> }

  TdxMRUCache<K, V> = class
  strict private type

    TElement = record
      Next: Integer;
      Prev: Integer;
      ElementKey: K;
      ElementValue: V;
    end;

  private
    FHead: Integer;
    FKeys: TArray<TElement>;
    FOwnsValues: Boolean;
  strict private
    FCache: TDictionary<K, Integer>;
    FFreeList: Integer;
    FTail: Integer;
    procedure AddElement(const AKey: K; const AValue: V); inline;
    procedure BuildKeysList(AElementCount: Integer);
    function GetFreeList: Integer; inline;
    function GetItem(const Key: K): V; inline;
    procedure InsertInFront(AIndex: Integer);
    function RemoveOldest: Integer; inline;
    procedure SetItem(const AKey: K; const AValue: V); inline;
    procedure Unlink(AIndex: Integer);
    procedure UpdateElement(AIndex: Integer; const AKey: K; AValue: V); inline;
  protected
    function IsEqualValue(const ALeft, ARight: V): Boolean; virtual;
    procedure FreeValue(const AValue: V); virtual;
  public
    constructor Create(ACount: Integer);
    destructor Destroy; override;
    procedure AddOrSetValue(const AKey: K; const AValue: V);
    procedure Clear; virtual;
    function TryGetValue(const AKey: K; var AValue: V): Boolean;
    property Items[const AKey: K]: V read GetItem write SetItem; default;
  end;

  { TdxObjectMRUCache<K; V> }

  TdxObjectMRUCache<K; V: class> = class(TdxMRUCache<K, V>)
  strict private
    function GetItem(const AKey: K): V; inline;
    procedure SetItem(const AKey: K; const AValue: V); inline;
    procedure DestroyOwnedValues;
  protected
    procedure FreeValue(const AValue: V); override;
    function IsEqualValue(const ALeft, ARight: V): Boolean; override;
  public
    constructor Create(ACount: Integer; AOwnsValues: Boolean = True);
    destructor Destroy; override;
    procedure Clear; override;
    property Items[const AKey: K]: V read GetItem write SetItem; default;
  end;

  { TdxArray }

  TdxArray<T> = record
  private
    FPosition: Integer;
    FValue: TArray<T>;
    function GetCount: Integer; inline;
    procedure SetCount(const AValue: Integer);
  public
    constructor Create(ACapacity: Integer);
    class function Select<TTo>(const AArray: TArray<T>; AFunc: TFunc<T, TTo>): TArray<TTo>; static;
    procedure Add(const AItem: T);
    procedure AddRange(AList: TList<T>); overload;
    procedure AddRange(const AValues: array of T); overload;
    property Count: Integer read GetCount write SetCount;
    function ToArray: TArray<T>;
  end;


function Equals(AObjectA, AObjectB: TObject): Boolean;
function NotImplemented: Pointer;

function GetValueHash(const AValue: string): Integer; overload;
function GetValueHash(const AGUID: TGUID): Integer; overload;
function GetValueHash(const ABCD: TBCD): Integer; overload;
function GetValueHash(const AData: TValue): Integer; overload;
function GetValueHash(const AData: array of TValue): Integer; overload;

function ReplaceText(const AText, AFromText, AToText: string): string; inline;

function IsNullableType(ATypeInfo: PTypeInfo): Boolean;
function IsRecord(ATypeKind: TTypeKind): Boolean; inline;
function TryGetUnderlyingRttiType(ATypeInfo: PTypeInfo; out AUnderlyingType: TRttiType): Boolean;
function TryGetUnderlyingType(ATypeInfo: PTypeInfo; out AUnderlyingTypeInfo: PTypeInfo): Boolean;
procedure GetUnderlyingValue(const AValue: TValue; out AUnderlyingValue: TValue);
function TryGetUnderlyingValue(const AValue: TValue; out AUnderlyingValue: TValue): Boolean;
procedure SetUnderlyingValue(var AValue: TValue; const AUnderlyingValue: TValue);
function TrySetUnderlyingValue(var AValue: TValue; const AUnderlyingValue: TValue): Boolean;

procedure SequentialGuid(out AGUID: TGUID);
function CreateSequential(out AGUID: TGUID): Integer;
function dxStringToGUID(const S: string): TGUID;

function dxGetQualifiedClassName(AClass: TClass): string; inline;

implementation

uses
{$IFDEF DELPHIXE8}
  System.Hash,
{$ENDIF}
  Windows, SysConst, RTLConsts,
  Variants, Math, DateUtils,
  dxCore, dxStringHelper,
  dxEMF.Strs,
  dxHash, TimeSpan;

const
  dxThisUnitName = 'dxEMF.Utils';

type
  PTimeSpan = ^TTimeSpan;
  PdxNullableInteger = ^TdxNullableInteger;
  PdxNullableBoolean = ^TdxNullableBoolean;
  PdxNullableString = ^TdxNullableString;
  PdxNullableSingle = ^TdxNullableSingle;

  TdxNullableDouble = TdxNullableValue<Double>;
  PdxNullableDouble = ^TdxNullableDouble;

function dxGetQualifiedClassName(AClass: TClass): string;
begin
  Result := AClass.QualifiedClassName;
end;

function Equals(AObjectA, AObjectB: TObject): Boolean;
begin
  if (AObjectA = nil) and (AObjectB = nil) then
    Exit(True);
  if (AObjectA = nil) or (AObjectB = nil) then
    Exit(False);
  Result := AObjectA.Equals(AObjectB);
end;

function NotImplemented: Pointer;
begin
  raise ENotImplemented.Create(sdxNotImplemented);
end;

function UuidCreateSequential(out AGUID: TGUID): HResult; stdcall; external 'rpcrt4.dll' name 'UuidCreateSequential';





var
  FSequentialGuid: TdxSequentialGuid;

procedure SequentialGuid(out AGUID: TGUID);
begin
  if FSequentialGuid = nil then
    FSequentialGuid := TdxSequentialGuid.Create;
  FSequentialGuid.CreateGUID(AGUID);
end;

function CreateSequential(out AGUID: TGUID): Integer;
var
  ABytes, ANewBytes: TArray<Byte>;
  I: Integer;
begin
  Result := UuidCreateSequential(AGUID);
  if Result <> 0 then
    SequentialGuid(AGUID); 
  ABytes := AGUID.ToByteArray;
  SetLength(ANewBytes, 16);
  for I := 0 to 15 do
    ANewBytes[I] := ABytes[TdxSequentialGuid.SQLOrderMap[I]];
  AGUID := TGUID.Create(ANewBytes);
end;

function dxStringToGUID(const S: string): TGUID;
begin
  if Length(S) = 36 then
    Result := StringToGUID('{' + S + '}')
  else
    Result := StringToGUID(S);
end;

function IsRecord(ATypeKind: TTypeKind): Boolean;
begin
  Result := ATypeKind in [TTypeKind.tkRecord{$IFDEF DELPHI103}, TTypeKind.tkMRecord{$ENDIF}];
end;

function IsNullableType(ATypeInfo: PTypeInfo): Boolean;
const
  PrefixString = 'TdxNullableValue<';    // DO NOT LOCALIZE
begin
  Result := (ATypeInfo <> nil) and IsRecord(ATypeInfo.Kind)
    and (Pos(PrefixString, GetTypeName(ATypeInfo)) = 1);
end;

function TryGetUnderlyingRttiType(ATypeInfo: PTypeInfo; out AUnderlyingType: TRttiType): Boolean;
var
  AContext: TRttiContext;
  AValueField: TRttiField;
  ARttiType: TRttiType;
begin
  Result := IsNullableType(ATypeInfo);
  if Result then
  begin
    ARttiType := AContext.GetType(ATypeInfo);
    AValueField := ARttiType.GetField('FValue');
    AUnderlyingType := AValueField.FieldType;
  end;
end;

function TryGetUnderlyingType(ATypeInfo: PTypeInfo; out AUnderlyingTypeInfo: PTypeInfo): Boolean;
var
  AUnderlyingType: TRttiType;
begin
  Result := TryGetUnderlyingRttiType(ATypeInfo, AUnderlyingType);
  if Result then
    AUnderlyingTypeInfo := AUnderlyingType.Handle
  else
    AUnderlyingTypeInfo := ATypeInfo;
end;

procedure GetUnderlyingValue(const AValue: TValue; out AUnderlyingValue: TValue);
var
  AContext: TRttiContext;
  ARttiType: TRttiType;
  AHasValueField: TRttiField;
  AInstance: Pointer;
  AValueField: TRttiField;
  AResult: Boolean;
begin
  ARttiType := AContext.GetType(AValue.TypeInfo);
  AHasValueField := ARttiType.GetField('FHasValue');
  if AHasValueField <> nil then
  begin
    AInstance := AValue.GetReferenceToRawData;
    AResult := AHasValueField.GetValue(AInstance).AsBoolean;
    if AResult then
    begin
      AValueField := ARttiType.GetField('FValue');
      AResult := AValueField <> nil;
      if AResult then
        AUnderlyingValue := AValueField.GetValue(AInstance);
    end
    else
      AUnderlyingValue := TValue.Empty
  end;
end;

function TryGetUnderlyingValue(const AValue: TValue; out AUnderlyingValue: TValue): Boolean;
begin
  Result := IsNullableType(AValue.TypeInfo);
  if Result then
    GetUnderlyingValue(AValue, AUnderlyingValue);
end;

procedure SetUnderlyingValue(var AValue: TValue; const AUnderlyingValue: TValue);
var
  AContext: TRttiContext;
  ARttiType: TRttiType;
  AHasValueField: TRttiField;
  AInstance: Pointer;
  AValueField: TRttiField;
  ANotEmpty: Boolean;
  AHandle: PTypeInfo;
begin
  ARttiType := AContext.GetType(AValue.TypeInfo);
  AHasValueField := ARttiType.GetField('FHasValue');
  if AHasValueField <> nil then
  begin
    AInstance := AValue.GetReferenceToRawData;
    ANotEmpty := not AUnderlyingValue.IsEmpty;
    AHasValueField.SetValue(AInstance, TValue.From<Boolean>(ANotEmpty));
    if ANotEmpty then
    begin
      AValueField := ARttiType.GetField('FValue');
      if AValueField <> nil then
      begin
        if AValueField.FieldType.TypeKind = tkEnumeration then
        begin
          AHandle := AValueField.FieldType.Handle;
          if AHandle <> AUnderlyingValue.TypeInfo then
          begin
            AValueField.SetValue(AInstance, TValue.FromOrdinal(AHandle, AUnderlyingValue.AsInt64));
            Exit;
          end;
        end;
        AValueField.SetValue(AInstance, AUnderlyingValue);
      end;
    end
  end
end;

function TrySetUnderlyingValue(var AValue: TValue; const AUnderlyingValue: TValue): Boolean;
begin
  Result := IsNullableType(AValue.TypeInfo);
  if Result then
    SetUnderlyingValue(AValue, AUnderlyingValue);
end;

function NullableValueEquals(const ALeftValue, ARightValue: TValue): boolean;
var
  AUnderlyingLeftValue, AUnderlyingRightValue: TValue;
begin
  if ALeftValue.TypeInfo = System.TypeInfo(TdxNullableInteger) then
    Result := PdxNullableInteger(ALeftValue.GetReferenceToRawData)^ = PdxNullableInteger(ARightValue.GetReferenceToRawData)^
  else
    if ALeftValue.TypeInfo = System.TypeInfo(PdxNullableString) then
      Result := PdxNullableString(ALeftValue.GetReferenceToRawData)^ = PdxNullableString(ARightValue.GetReferenceToRawData)^
    else
      if ALeftValue.TypeInfo = System.TypeInfo(PdxNullableBoolean) then
        Result := PdxNullableBoolean(ALeftValue.GetReferenceToRawData)^ = PdxNullableBoolean(ARightValue.GetReferenceToRawData)^
      else
        if ALeftValue.TypeInfo = System.TypeInfo(PdxNullableSingle) then
          Result := PdxNullableSingle(ALeftValue.GetReferenceToRawData)^ = PdxNullableSingle(ARightValue.GetReferenceToRawData)^
        else
          if ALeftValue.TypeInfo = System.TypeInfo(PdxNullableDouble) then
            Result := PdxNullableDouble(ALeftValue.GetReferenceToRawData)^ = PdxNullableDouble(ARightValue.GetReferenceToRawData)^
          else
          begin
            Result := TryGetUnderlyingValue(ALeftValue, AUnderlyingLeftValue) and
              TryGetUnderlyingValue(ARightValue, AUnderlyingRightValue);
            if Result then
              Result := AUnderlyingLeftValue.Equals(AUnderlyingRightValue);
          end;
end;

function GetValueHash(const AValue: string): Integer; overload;
begin
  Result := Cardinal(dxElfHash(AValue));
end;

function GetValueHash(const AGUID: TGUID): Integer; overload;
begin
  Result := AGUID.D1 xor ((AGUID.D2 shl 16) or AGUID.D3) xor ((AGUID.D4[2] shl 24) or AGUID.D4[7]);
end;

function GetValueHash(const ABCD: TBCD): Integer; overload;
var
  I: Integer;
begin
  Result := ABCD.Precision or (ABCD.SignSpecialPlaces shl 16);
  for I := 0 to 31 do
    Result := Result xor (ABCD.Fraction[I] shl ((I * 8) mod 32));
end;

function GetInt64Hash(AInt64: Int64): Integer; inline;
begin
  Result := Int64Rec(AInt64).Lo xor Int64Rec(AInt64).Hi;
end;

function GetValueHash(const AData: TValue): Integer;
type
  TSingle = record
  case Byte of
    0: (SingleValue: Single);
    1: (CardinalValue: Cardinal);
  end;

  TDouble = record
  case Byte of
    0: (DoubleValue: Double);
    1: (CardinalValue: Int64);
  end;

var
  ASingle: TSingle;
  ADouble: TDouble;
  {$IF SizeOf(Extended) = 10}
  AExtended: Extended;
  {$IFEND}
  AStr: string;
  AUnderlyingValue: TValue;
begin
  case AData.Kind of
    tkInteger:
      Result := AData.AsCardinal;//Cardinal(AData.AsInteger);
    tkChar, tkEnumeration, tkWChar:
      Result := GetInt64Hash(AData.AsOrdinal);
    tkFloat:
      begin
        case GetTypeData(AData.TypeInfo)^.FloatType of
          ftSingle:
            begin
              ASingle.SingleValue := AData.AsSingle;
              Result := ASingle.CardinalValue;
            end;
          {$IF SizeOf(Extended) = 10}
          ftExtended:
            begin
              AExtended := AData.AsExtended;
              {$IFDEF DELPHIXE8}
              Result := THashBobJenkins.GetHashValue(AExtended, SizeOf(AExtended), 0);
              {$ELSE}
              Result := BobJenkinsHash(AExtended, SizeOf(AExtended), 0);
              {$ENDIF}
            end;
          {$IFEND}
          else
            begin
              ADouble.DoubleValue := AData.AsDouble;
              Result := GetInt64Hash(ADouble.CardinalValue);
            end;
        end;
      end;
      tkRecord{$IFDEF DELPHI103}, tkMRecord{$ENDIF}:
      begin
        if AData.TypeInfo = System.TypeInfo(TGUID) then
          Result := GetValueHash(PGUID(AData.GetReferenceToRawData)^)
        else
        if AData.TypeInfo = System.TypeInfo(TBCD) then
          Result := GetValueHash(PBCD(AData.GetReferenceToRawData)^)
        else
          if IsNullableType(AData.TypeInfo) then
          begin
            if TryGetUnderlyingValue(AData, AUnderlyingValue) then
              Result := GetValueHash(AUnderlyingValue)
            else
              Result := 0;
          end
          else
          begin
            Result := 0;
            NotImplemented;
          end;
      end;
    tkInt64:
      Result := GetInt64Hash(AData.AsInt64);
    tkString, tkLString, tkWString, tkUString:
      begin
        AStr := AData.AsString;
        Result := dxElfHash(AStr);
      end;
    else
      Result := Integer($FFFFFFFF);
  end;

end;

function GetValueHash(const AData: array of TValue): Integer; overload;
const
  MagicNumber = $5BD1E995;
var
  I: Integer;
  AHash: Cardinal;
begin
  Result := 0;
  for I := 0 to Length(AData) - 1 do
  begin
    AHash := GetValueHash(AData[I]);
    if I = 0 then
      Result := AHash
    else
    begin
      AHash  := AHash xor ((AHash * MagicNumber) shr 24);
      AHash  := Cardinal(AHash * MagicNumber);
      Result := Cardinal(Result * MagicNumber) xor AHash;
    end;
  end;
end;

function ReplaceText(const AText, AFromText, AToText: string): string;
begin
  Result := StringReplace(AText, AFromText, AToText, [rfReplaceAll]);
end;

{ TdxFormatterHelper }

class function TdxFormatterHelper.Concat(const AOperands: array of string; const ADelimiter: string): string;
var
  AArg: string;
  ASb: TStringBuilder;
begin
  ASb := TStringBuilder.Create;
  try
    for AArg in AOperands do
    begin
      if ASb.Length > 0 then
        ASb.Append(ADelimiter);
      ASb.Append(AArg);
    end;
    Result := ASb.ToString;
  finally
    ASb.Free;
  end;
end;

class function TdxFormatterHelper.Concat(AOperands: TList<string>; AFunc: TFunc; const ADelimiter: string): string;
var
  AArg: string;
  ASb: TStringBuilder;
  I: Integer;
begin
  ASb := TStringBuilder.Create;
  try
    for I := 0 to AOperands.Count - 1 do
    begin
      AArg := AOperands.List[I];
      if I > 0 then
        ASb.Append(ADelimiter);
      ASb.Append(AFunc(AArg));
    end;
    Result := ASb.ToString;
  finally
    ASb.Free;
  end;
end;

class function TdxFormatterHelper.CommaText(AOperands: TList<string>; const ADelimiter: string): string;
var
  AArg: string;
  ASb: TStringBuilder;
  I: Integer;
begin
  ASb := TStringBuilder.Create;
  try
    for I := 0 to AOperands.Count - 1 do
    begin
      AArg := AOperands.List[I];
      if I > 0 then
        ASb.Append(ADelimiter);
      ASb.Append(AArg);
    end;
    Result := ASb.ToString;
  finally
    ASb.Free;
  end;
end;

class function TdxFormatterHelper.ExtractFromBrackets(const AValue: string): string;
var
  APos: Integer;
begin
  APos := AValue.IndexOf('(') + 1;
  if APos > 0 then
    Result := AValue.Substring(APos, AValue.IndexOf(')') - APos)
  else
    Result := '';
end;

class function TdxFormatterHelper.GetName<T>(const AValue: T): string;
var
  AVal: TValue;
begin
  AVal := TValue.From<T>(AValue);
  Result := GetEnumName(TypeInfo(T), AVal.AsOrdinal);
end;

{ TValueHelper }

{$IF (CompilerVersion < 25) and Defined(CPUX64)}
procedure TValueHelper.UpdateObject(AObject: TObject);
begin
  Self.FData.FAsPointer := Pointer(AObject);
end;

class function TValueHelper.FromObject(AObject: TObject): TValue;
begin
  Result := AObject;
  Result.UpdateObject(AObject);
end;
{$IFEND}

function TValueHelper.AsBCD: TBCD;
begin
  if TypeInfo = System.TypeInfo(TBCD) then
    Result := AsType<TBCD>
  else
    case TypeInfo.Kind of
      tkInteger:
        Result := IntegerToBcd(AsInteger);
      tkFloat:
        Result := DoubleToBcd(AsExtended);
      tkInt64:
        Result := IntegerToBcd(AsInt64);
      else
        Result := StrToBcd(ToString)
    end;
end;

function TValueHelper.AsCardinal: Cardinal;
begin
  Result := AsType<Cardinal>;
end;

function TValueHelper.AsDateTime: TDateTime;
begin
  Result := AsType<TDateTime>;
end;

function TValueHelper.AsDouble: Double;
begin
  Result := AsType<Double>;
end;

function TValueHelper.AsGUID: TGUID;
begin
  Result := AsType<TGUID>;
end;

function TValueHelper.AsSingle: Single;
begin
  Result := AsType<Single>;
end;

function TValueHelper.Equals(const AValue: TValue): Boolean;
begin
  if IsNullOrEmpty and AValue.IsNullOrEmpty then
    Exit(True)
  else
    if IsNullOrEmpty or AValue.IsNullOrEmpty then
      Exit(False);
  if IsNumeric and AValue.IsNumeric then
  begin
    if IsOrdinal then
    begin
      if AValue.IsOrdinal then
        Result := AsOrdinal = AValue.AsOrdinal
      else
        if AValue.IsSingle then
          Result := Math.SameValue(AsOrdinal, AValue.AsSingle)
        else
          if AValue.IsDouble then
            Result := Math.SameValue(AsOrdinal, AValue.AsDouble)
          else
            Result := Math.SameValue(AsOrdinal, AValue.AsExtended)
    end
    else
    if IsSingle then
    begin
      if AValue.IsOrdinal then
        Result := Math.SameValue(AsSingle, AValue.AsOrdinal)
      else
        if AValue.IsSingle then
          Result := Math.SameValue(AsSingle, AValue.AsSingle)
        else
          if AValue.IsDouble then
            Result := Math.SameValue(AsSingle, AValue.AsDouble)
          else
            Result := Math.SameValue(AsSingle, AValue.AsExtended);
    end
    else
      if IsDouble then
      begin
        if AValue.IsOrdinal then
          Result := Math.SameValue(AsDouble, AValue.AsOrdinal)
        else
          if AValue.IsSingle then
            Result := Math.SameValue(AsDouble, AValue.AsSingle)
          else
            if AValue.IsDouble then
              Result := Math.SameValue(AsDouble, AValue.AsDouble)
            else
              Result := Math.SameValue(AsDouble, AValue.AsExtended);
      end
      else
      begin
        if AValue.IsOrdinal then
          Result := Math.SameValue(AsExtended, AValue.AsOrdinal)
        else
          if AValue.IsSingle then
            Result := Math.SameValue(AsExtended, AValue.AsSingle)
          else
            if AValue.IsDouble then
              Result := Math.SameValue(AsExtended, AValue.AsDouble)
            else
              Result := Math.SameValue(AsExtended, AValue.AsExtended);
      end;
  end
  else
  if IsEnumeration and AValue.IsEnumeration then
  begin
    Result := AsOrdinal = AValue.AsOrdinal
  end
  else
    if IsString and AValue.IsString then
      Result := AsString = AValue.AsString
    else
    if IsClass and AValue.IsClass then
      Result := AsClass = AValue.AsClass
    else
      if IsObject and AValue.IsObject then
        Result := AsObject = AValue.AsObject
      else
      if IsRecord and AValue.IsRecord then
      begin
        if TypeInfo <> AValue.TypeInfo then
          Result := False
        else
        begin
          if TypeInfo = System.TypeInfo(TGUID) then
            Result := IsEqualGUID(PGUID(GetReferenceToRawData)^, PGUID(AValue.GetReferenceToRawData)^)
          else
          if TypeInfo = System.TypeInfo(TTimeSpan) then
            Result := PTimeSpan(GetReferenceToRawData)^ = PTimeSpan(AValue.GetReferenceToRawData)^
          else
            if IsNullableType(TypeInfo) then
              Result := NullableValueEquals(Self, AValue)
            else
            begin
              Result := False;
              NotImplemented;
            end;
        end;
      end
      else
        Result := False;
end;

class function TValueHelper.FromNullable<T>(const AValue: TdxNullableValue<T>): TValue;
begin
  if AValue.IsNull then
    Result := TValue.Empty
  else
    Result := TValue.From<T>(AValue.Value);
end;

function TValueHelper.GetFieldType: TFieldType;

  function GetTypeInfoFieldType(ATypeInfo: PTypeInfo): TFieldType;
  var
    AUnderlyingTypeInfo: PTypeInfo;
  begin
    if ATypeInfo = nil then
      Exit(TFieldType.ftInteger);
    case ATypeInfo.Kind of
      tkInteger,
      tkEnumeration:
        case ATypeInfo.TypeData.OrdType of
          otSByte:
            Result := TFieldType.ftShortint;
          otUByte:
            if ATypeInfo.Kind = tkEnumeration then
              if TypeInfo = System.TypeInfo(Boolean) then
                Result := TFieldType.ftBoolean
              else
                Result := TFieldType.ftByte
            else
              Result := TFieldType.ftByte;
          otSWord:
            Result := TFieldType.ftSmallint;
          otUWord:
            Result := TFieldType.ftWord;
          otSLong:
            Result := TFieldType.ftInteger;
          otULong:
            Result := TFieldType.ftLongWord;
          else
            Result := TFieldType.ftUnknown;
        end;
      tkChar:
        Result := TFieldType.ftFixedChar;
      tkWChar:
        Result := TFieldType.ftFixedWideChar;
      tkFloat:
        case ATypeInfo.TypeData.FloatType of
          TFloatType.ftSingle:
            Result := TFieldType.ftSingle;
          TFloatType.ftDouble, TFloatType.ftExtended, TFloatType.ftComp:
            begin
              if (TypeInfo = System.TypeInfo(TDateTime)) or (TypeInfo = System.TypeInfo(TDate)) or (TypeInfo = System.TypeInfo(TTime)) then
                Result := TFieldType.ftTime
              else
                Result := TFieldType.ftFloat;
            end;
          TFloatType.ftCurr:
            Result := TFieldType.ftCurrency;
          else
            Result := TFieldType.ftUnknown;
        end;
      tkInt64:
        Result := TFieldType.ftLargeint;
      tkString, tkLString:
        Result := TFieldType.ftString;
      tkWString, tkUString:
        Result := TFieldType.ftWideString;
      tkRecord{$IFDEF DELPHI103}, tkMRecord{$ENDIF}:
        begin
          if ATypeInfo = System.TypeInfo(TGUID) then
            Result := TFieldType.ftGuid
          else
            if ATypeInfo = System.TypeInfo(TBCD) then
              Result := TFieldType.ftFMTBcd
            else
              if IsNullableType(ATypeInfo) then
              begin
                TryGetUnderlyingType(ATypeInfo, AUnderlyingTypeInfo);
                Result := GetTypeInfoFieldType(AUnderlyingTypeInfo);
              end
              else
                Result := TFieldType.ftUnknown;
        end;
      tkDynArray, tkArray:
        Result := TFieldType.ftBlob;
      else
        Result := TFieldType.ftUnknown;
    end;
  end;

begin
  Result := GetTypeInfoFieldType(TypeInfo);
end;

function TValueHelper.IsBoolean: Boolean;
begin
  Result := not IsEmpty and (TypeInfo = System.TypeInfo(Boolean));
end;

function TValueHelper.IsDateTime: Boolean;
begin
  Result :=
    (TypeInfo = System.TypeInfo(TDateTime)) or
    (TypeInfo = System.TypeInfo(TDate)) or
    (TypeInfo = System.TypeInfo(TTime));
end;

function TValueHelper.IsDouble: Boolean;
begin
  Result := TypeInfo = System.TypeInfo(Double);
end;

function TValueHelper.IsEnumeration: Boolean;
begin
  Result := TypeInfo^.Kind = tkEnumeration;
end;

function TValueHelper.IsInterface: Boolean;
begin
  Result := IsType<IInterface>;
end;

function TValueHelper.IsNumeric: Boolean;
begin
  Result := Kind in [tkInteger, tkFloat, tkInt64];
end;

function TValueHelper.IsNullOrEmpty: Boolean;
begin
  Result := IsEmpty  or ((Kind = tkVariant) and (FindVarData(AsVariant)^.VType in [varNull, varEmpty]));
end;

function TValueHelper.IsRecord: Boolean;
begin
  Result := dxEMF.Utils.IsRecord(Kind);
end;

function TValueHelper.IsSingle: Boolean;
begin
  Result := TypeInfo = System.TypeInfo(Single);
end;

function TValueHelper.IsString: Boolean;
begin
  Result := Kind in [tkChar, tkString, tkWChar, tkLString, tkWString, tkUString];
  if not Result then
    Result := IsType<string>;
end;

function TValueHelper.ToFloat: Extended;
begin
  case Kind of
    tkInteger:
      Result := AsInteger;
    tkFloat:
      Result := AsExtended;
    tkInt64:
      Result := AsInt64;
    tkChar, tkString, tkWChar, tkLString, tkWString, tkUString:
      Result := StrToFloat(AsString)
    else
      Result := AsType<Extended>;
  end;
end;

function GetDynArrayElType(ATypeInfo: PTypeInfo): PTypeInfo;
var
  ref: PPTypeInfo;
begin
  ref := GetTypeData(ATypeInfo).DynArrElType;
  if ref = nil then
    Exit(nil);
  Result := ref^;
end;

class function TValueHelper.ConvertArray(ASourceTypeInfo, ADestinationTypeInfo: PTypeInfo; ASourceBuffer: Pointer): TValue;
var
  AArray: Pointer;
  ALength: Longint;
  ASrcElSize, ADstElSize: Integer;
begin
  if (ASourceTypeInfo.Kind <> tkDynArray) or (ADestinationTypeInfo.Kind <> tkDynArray) or
    IsManaged(GetDynArrayElType(ASourceTypeInfo)) or IsManaged(GetDynArrayElType(ADestinationTypeInfo)) then
    NotImplemented;
  AArray := nil;
  ASrcElSize := GetTypeData(ASourceTypeInfo)^.elSize;
  ADstElSize := GetTypeData(ADestinationTypeInfo)^.elSize;
  ALength := (DynArraySize(ASourceBuffer) * ASrcElSize) div ADstElSize;
  DynArraySetLength(AArray, ADestinationTypeInfo, 1, @ALength);
  try
    Move(PByte(ASourceBuffer)^, PByte(AArray)^, ALength * ADstElSize);
    TValue.Make(@AArray, ADestinationTypeInfo, Result);
  finally
    DynArrayClear(AArray, ADestinationTypeInfo);
  end;
end;

function TValueHelper.ConvertAsArray(ADestinationTypeInfo: PTypeInfo): TValue;
var
  APPointer: PPointer;
begin
  APPointer := GetReferenceToRawData;
  Result := TValue.ConvertArray(TypeInfo, ADestinationTypeInfo, APPointer^);
end;

function TValueHelper.ConvertInteger: Variant;
begin
  case TypeData.OrdType of
    otSByte:
      Result := ShortInt(AsInteger);
    otUByte:
      Result := Byte(AsInteger);
    otSWord:
      Result := SmallInt(AsInteger);
    otUWord:
      Result := Word(AsInteger);
    otSLong:
      Result := AsInteger;
    otULong:
      Result := Cardinal(AsInteger);
  end;
end;

function TValueHelper.ConvertOrdinal: Variant;
begin
  case TypeData.OrdType of
    otSByte:
      Result := ShortInt(AsOrdinal);
    otUByte:
      Result := Byte(AsOrdinal);
    otSWord:
      Result := SmallInt(AsOrdinal);
    otUWord:
      Result := Word(AsOrdinal);
    otSLong:
      Result := Integer(AsOrdinal);
    otULong:
      Result := Cardinal(AsOrdinal);
  end;
end;

function TValueHelper.ToVariant: Variant;
var
  AUnderlyingValue: TValue;
begin
  if IsEmpty then
    Exit({$IFDEF DELPHIXER104}Unassigned{$ELSE}Null{$ENDIF});
  case Kind of
    tkInteger:
      Result := ConvertInteger;
    tkEnumeration:
      if TypeInfo = System.TypeInfo(Boolean) then
        Result := AsBoolean
      else
        Result := ConvertOrdinal;
    tkFloat:
      if IsDateTime then
        Result := AsDateTime
      else
        case TypeData.FloatType of
          ftSingle:
            Result := AsType<Single>;
          ftDouble, ftExtended:
            Result := AsType<Double>;
          ftCurr:
            Result := AsType<Currency>;
          else
            Result := AsType<Variant>;
        end;
    tkRecord{$IFDEF DELPHI103}, tkMRecord{$ENDIF}:
      if IsNullableType(TypeInfo) then
      begin
        if TryGetUnderlyingValue(Self, AUnderlyingValue) then
          Result := AUnderlyingValue.ToVariant
        else
          Result := Null;
      end
      else
        if TypeInfo = System.TypeInfo(TGUID) then
          Result := GUIDToString(AsType<TGUID>)
        else
          if TypeInfo = System.TypeInfo(TBCD) then
            VarFMTBcdCreate(Result, AsType<TBCD>)
          else
            Result := AsType<Variant>;
    tkInt64:
      Result := AsOrdinal;
    tkDynArray:
      DynArrayToVariant(Result, PPointer(GetReferenceToRawData)^, TypeInfo);
    tkUString:
      Result := PUnicodeString(GetReferenceToRawData)^; 
    else
      Result := AsType<Variant>
  end;
end;

{ TdxSequentialGuid }

constructor TdxSequentialGuid.Create;
begin
  SysUtils.CreateGUID(FCurrentGuid);
end;

constructor TdxSequentialGuid.Create(APreviousGuid: TGuid);
begin
  FCurrentGuid := APreviousGuid;
end;

procedure TdxSequentialGuid.CreateGUID(out AGuid: TGUID);
var
  ABytes: TArray<Byte>;
  AMapIndex, ABytesIndex: Integer;
begin
  ABytes := FCurrentGuid.ToByteArray;
  for AMapIndex := 0 to 15 do
  begin
    ABytesIndex := SQLOrderMap[AMapIndex];
    Inc(ABytes[ABytesIndex]);
    if ABytes[ABytesIndex] <> 0 then
      Break;
  end;
  FCurrentGuid := TGUID.Create(ABytes);
  AGUID := FCurrentGuid;
end;

{ TdxHashSetString }

procedure TdxHashSetString.Add(const AValue: string);
begin
  inherited Add(AValue, 0);
end;

function TdxHashSetString.Contains(const AValue: string): Boolean;
begin
  Result := inherited ContainsKey(AValue);
end;

{ TdxEMFDefault }

class function TdxEMFDefault.GetMaxInSize: Integer;
begin
  Result := 16;
end;

class function TdxEMFDefault.GetTerminalInSize(ASize: Integer; AParametersPerObject: Integer): Integer;
begin
  if AParametersPerObject <= 1 then
    Result := GetTerminalInSize(ASize)
  else
    Result := GetTerminalInSize(Math.Min(Math.Max(GetTerminalInSize(MaxInt) div AParametersPerObject, 1), ASize));
end;


class function TdxEMFDefault.GetTerminalInSize(ASize: Integer): Integer;
const
  TerminalInSizes: array[0..6] of Integer = (16, 21, 34, 55, 89, 144, 233);
var
  ANum: Integer;
begin
  if ASize <= 16 then
    Exit(ASize);
  ANum := High(TerminalInSizes);
  while ASize < TerminalInSizes[ANum] do
    Dec(ANum);
  Result := TerminalInSizes[ANum];
end;

{ TdxSmartValue.THolder }

constructor TdxSmartValue.THolder.Create(const AObject: TObject);
begin
  inherited Create;
  FObject := AObject;
end;

destructor TdxSmartValue.THolder.Destroy;
begin
  FreeAndNil(FObject);
  inherited;
end;

{ TdxSmartValue }

constructor TdxSmartValue.Create(const AValue: TValue);
begin
  FValue := AValue;
  if AValue.IsObject then
    FHolder := THolder.Create(AValue.AsObject);
end;

class operator TdxSmartValue.Equal(const A: TdxSmartValue; const B: TValue): Boolean;
begin
  Result := A.Value.Equals(B);
end;

class operator TdxSmartValue.Equal(const A: TdxSmartValue; B: TObject): Boolean;
begin
  Result := A.Value.IsObject;
  if Result then
    Result := A.Value.AsObject = B;
end;

class operator TdxSmartValue.Equal(const A, B: TdxSmartValue): Boolean;
begin
  Result := A.Value.Equals(B.Value);
end;

class operator TdxSmartValue.Implicit(const AValue: TdxSmartValue): TValue;
begin
  Result := AValue.FValue;
end;

class operator TdxSmartValue.Implicit(const AObject: TObject): TdxSmartValue;
var
  AValue: TValue;
begin
  {$IF (CompilerVersion < 25) and Defined(CPUX64)}
  AValue := TValue.FromObject(AObject);
  {$ELSE}
  AValue := AObject;
  {$IFEND}
  Result := TdxSmartValue.Create(AValue);
end;

class operator TdxSmartValue.Implicit(AObject: TInterfacedObject): TdxSmartValue;
var
  AInterface: IInterface;
begin
  AInterface := AObject;
  Result := TdxSmartValue.Create(TValue.From<IInterface>(AInterface));
end;

class operator TdxSmartValue.Implicit(const AValue: TValue): TdxSmartValue;
begin
  Result := TdxSmartValue.Create(AValue);
end;

class operator TdxSmartValue.Implicit(const AValue: string): TdxSmartValue;
begin
  Result := TdxSmartValue.Create(AValue);
end;

class operator TdxSmartValue.NotEqual(A: TObject; const B: TdxSmartValue): Boolean;
begin
  Result := not (A = B);
end;

class operator TdxSmartValue.NotEqual(const A: TValue; const B: TdxSmartValue): Boolean;
begin
  Result := not (A = B);
end;

class operator TdxSmartValue.NotEqual(const A: TdxSmartValue; const B: TValue): Boolean;
begin
  Result := not (A = B);
end;

class operator TdxSmartValue.NotEqual(const A: TdxSmartValue; B: TObject): Boolean;
begin
  Result := A.Value.IsObject;
  if Result then
    Result := A.Value.AsObject <> B;
end;

class operator TdxSmartValue.NotEqual(const A, B: TdxSmartValue): Boolean;
begin
  Result := not A.Value.Equals(B.Value);
end;

class operator TdxSmartValue.Implicit(const AInterface: IInterface): TdxSmartValue;
begin
  Result := TdxSmartValue(TValue.From<IInterface>(AInterface));
end;

function TdxSmartValue.AsInterface: IInterface;
begin
  if FValue.IsInterface then
    Result := FValue.AsInterface
  else
    Result := nil;
end;

function TdxSmartValue.AsObject: TObject;
begin
  if FValue.IsObject then
    Result := FValue.AsObject
  else
    Result := nil;
end;

function TdxSmartValue.&As<T>: T;
begin
  Result := FValue.AsType<T>;
end;

class operator TdxSmartValue.Equal(A: TObject; const B: TdxSmartValue): Boolean;
begin
  Result := B.Value.IsObject;
  if Result then
    Result := B.Value.AsObject = A;
end;

class operator TdxSmartValue.Equal(const A: TValue; const B: TdxSmartValue): Boolean;
begin
  Result := B.Value.Equals(A);
end;

{ TdxObjectSet }

constructor TdxObjectSet.Create(ACapacity: Integer);
begin
  inherited Create;
  FDictionary := TDictionary<TObject, Byte>.Create(ACapacity);
end;

constructor TdxObjectSet.Create;
begin
  Create(0);
end;

destructor TdxObjectSet.Destroy;
begin
  FreeAndNil(FDictionary);
  inherited Destroy;
end;

procedure TdxObjectSet.Add(AItem: TObject);
begin
  FDictionary.AddOrSetValue(AItem, 0);
end;

procedure TdxObjectSet.Clear;
begin
  FDictionary.Clear;
end;

function TdxObjectSet.Contains(AItem: TObject): Boolean;
begin
  Result := FDictionary.ContainsKey(AItem);
end;


function TdxObjectSet.GetCount: Integer;
begin
  Result := FDictionary.Count;
end;

function TdxObjectSet.GetIsReadOnly: Boolean;
begin
  Result := False;
end;

function TdxObjectSet.Remove(AItem: TObject): Boolean;
begin
  FDictionary.Remove(AItem);
  Result := True;
end;

function TdxObjectSet.ToArray: TArray<TObject>;
begin
  Result := FDictionary.Keys.ToArray;
end;

function TdxObjectSet.GetEnumerator: TEnumerator;
begin
  Result := FDictionary.Keys.GetEnumerator;
end;

function TdxObjectSet.GetIsSynchronized: Boolean;
begin
  Result := False;
end;

function TdxObjectSet.GetSyncRoot: TObject;
begin
  Result := Self;
end;

{ TdxMRUCache<Key, Value> }

constructor TdxMRUCache<K, V>.Create(ACount: Integer);
begin
  inherited Create;
  BuildKeysList(ACount);
  FCache := TDictionary<K, Integer>.Create(ACount);
end;

destructor TdxMRUCache<K, V>.Destroy;
begin
  FreeAndNil(FCache);
  inherited Destroy;
end;

procedure TdxMRUCache<K, V>.Clear;
begin
  FCache.Clear;
  BuildKeysList(Length(FKeys));
end;

procedure TdxMRUCache<K, V>.FreeValue(const AValue: V);
begin
  // do nothing
end;

function TdxMRUCache<K, V>.IsEqualValue(const ALeft, ARight: V): Boolean;
begin
  Result := TComparer<V>.Default.Compare(ALeft, ARight) = 0;
end;

function TdxMRUCache<K, V>.RemoveOldest: Integer;
begin
  Assert(FTail >= 0, 'List is empty');
  Result := FTail;
  Unlink(FTail);
  FCache.Remove(FKeys[Result].ElementKey);
  if FOwnsValues then
    FreeValue(FKeys[Result].ElementValue);
end;

procedure TdxMRUCache<K, V>.SetItem(const AKey: K; const AValue: V);
begin
  AddOrSetValue(AKey, AValue);
end;

function TdxMRUCache<K, V>.GetFreeList: Integer;
begin
  Assert(FFreeList >= 0, 'Free list is empty');
  Result := FFreeList;
  FFreeList := FKeys[FFreeList].Next;
end;

function TdxMRUCache<K, V>.GetItem(const Key: K): V;
begin
  if not TryGetValue(Key, Result) then
    raise EListError.CreateRes(@SGenericItemNotFound);
end;

procedure TdxMRUCache<K, V>.AddElement(const AKey: K; const AValue: V);
var
  AIndex: Integer;
begin
  if FFreeList < 0 then 
    AIndex := RemoveOldest
  else
    AIndex := GetFreeList;
  InsertInFront(AIndex);
  with FKeys[AIndex] do
  begin
    ElementKey := AKey;
    ElementValue := AValue;
  end;
  FCache.Add(AKey, AIndex);
end;

procedure TdxMRUCache<K, V>.BuildKeysList(AElementCount: Integer);
var
  I, J: Integer;
begin
  SetLength(FKeys, AElementCount);
  Dec(AElementCount);

  for I := 1 to AElementCount do
  begin
    J := I - 1;
    FKeys[J].Next := I;
    FKeys[I].Prev := J;
  end;
  FKeys[AElementCount].Next := -1;
  FKeys[0].Prev := -1;

  FHead := -1;
  FTail := -1;
  FFreeList := 0;
end;

procedure TdxMRUCache<K, V>.InsertInFront(AIndex: Integer);
begin
  FKeys[AIndex].Next := FHead;
  FKeys[AIndex].Prev := -1;
  if FHead >= 0 then
    FKeys[FHead].Prev := AIndex;
  FHead := AIndex;
  if FTail < 0 then
    FTail := FHead;
end;

function TdxMRUCache<K, V>.TryGetValue(const AKey: K; var AValue: V): Boolean;
var
  AIndex: Integer;
begin
  Result := FCache.TryGetValue(AKey, AIndex);
  if Result then
    AValue := FKeys[AIndex].ElementValue
  else
    AValue := Default(V);
end;

procedure TdxMRUCache<K, V>.Unlink(AIndex: Integer);
begin
  if FKeys[AIndex].Next >= 0 then
    FKeys[FKeys[AIndex].Next].Prev := FKeys[AIndex].Prev
  else
  begin
    Assert(FTail = AIndex);
    FTail := FKeys[AIndex].Prev;
  end;
  if FKeys[AIndex].Prev >= 0 then
    FKeys[FKeys[AIndex].Prev].Next := FKeys[AIndex].Next
  else
  begin
    Assert(FHead = AIndex);
    FHead := FKeys[AIndex].Next;
  end;
end;

procedure TdxMRUCache<K, V>.UpdateElement(AIndex: Integer; const AKey: K; AValue: V);
var
  AOldValue: V;
begin
  if not FOwnsValues then
    FKeys[AIndex].ElementValue := AValue
  else
  begin
    AOldValue := FKeys[AIndex].ElementValue;
    if not IsEqualValue(AValue, AOldValue) then
    begin
      FKeys[AIndex].ElementValue := AValue;
      FreeValue(AOldValue);
    end;
  end;
  Unlink(AIndex);
  InsertInFront(AIndex);
end;

procedure TdxMRUCache<K, V>.AddOrSetValue(const AKey: K; const AValue: V);
var
  AIndex: Integer;
begin
  if FCache.TryGetValue(AKey, AIndex) then
    UpdateElement(AIndex, AKey, AValue)
  else
    AddElement(AKey, AValue);
end;

{ TdxObjectMRUCache<Key, Value> }

constructor TdxObjectMRUCache<K, V>.Create(ACount: Integer; AOwnsValues: Boolean = True);
begin
  inherited Create(ACount);
  FOwnsValues := AOwnsValues;
end;

destructor TdxObjectMRUCache<K, V>.Destroy;
begin
  DestroyOwnedValues;
  inherited Destroy;
end;

procedure TdxObjectMRUCache<K, V>.Clear;
begin
  DestroyOwnedValues;
  inherited Clear;
end;

procedure TdxObjectMRUCache<K, V>.DestroyOwnedValues;
begin
  if FOwnsValues then
    while FHead >= 0 do
    begin
      FKeys[FHead].ElementValue.Free;
      FHead := FKeys[FHead].Next;
    end;
end;

procedure TdxObjectMRUCache<K, V>.FreeValue(const AValue: V);
begin
  AValue.Free;
end;

function TdxObjectMRUCache<K, V>.GetItem(const AKey: K): V;
begin
  if not TryGetValue(AKey, Result) then
    Result := nil;
end;

function TdxObjectMRUCache<K, V>.IsEqualValue(const ALeft, ARight: V): Boolean;
begin
  Result := ALeft = ARight;
end;

procedure TdxObjectMRUCache<K, V>.SetItem(const AKey: K; const AValue: V);
begin
  AddOrSetValue(AKey, AValue);
end;

{ TdxArray<T> }

constructor TdxArray<T>.Create(ACapacity: Integer);
begin
  SetLength(FValue, ACapacity);
  FPosition := 0;
end;

function TdxArray<T>.GetCount: Integer;
begin
  Result := FPosition;
end;

procedure TdxArray<T>.Add(const AItem: T);
begin
  if FPosition >= Count then
    Count := Count + 4;
  FValue[FPosition] := AItem;
  Inc(FPosition);
end;

procedure TdxArray<T>.AddRange(AList: TList<T>);
var
  I, ACount: Integer;
begin
  ACount := AList.Count;
  if (ACount + FPosition) > Length(FValue) then
    SetLength(FValue, ACount + FPosition);
  for I := 0 to ACount - 1 do
  begin
    FValue[FPosition] := AList.List[I];
    Inc(FPosition);
  end;
end;

procedure TdxArray<T>.AddRange(const AValues: array of T);
var
  I, ACount: Integer;
begin
  ACount := Length(AValues);
  if (ACount + FPosition) > Length(FValue) then
    SetLength(FValue, ACount + FPosition);
  for I := 0 to ACount - 1 do
  begin
    FValue[FPosition] := AValues[I];
    Inc(FPosition);
  end;
end;

class function TdxArray<T>.Select<TTo>(const AArray: TArray<T>; AFunc: TFunc<T, TTo>): TArray<TTo>;
var
  I: Integer;
begin
  SetLength(Result, Length(AArray));
  for I := 0 to Length(AArray) - 1 do
    Result[I] := AFunc(AArray[I]);
end;

procedure TdxArray<T>.SetCount(const AValue: Integer);
begin
  SetLength(FValue, AValue);
  if FPosition > AValue then
    FPosition := AValue;
end;

function TdxArray<T>.ToArray: TArray<T>;
begin
  if Length(FValue) <> FPosition then
    SetLength(FValue, FPosition);
  Result := FValue;
end;



initialization
finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  FreeAndNil(FSequentialGuid);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.
