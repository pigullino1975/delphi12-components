{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressDataController                                    }
{                                                                    }
{           Copyright (c) 1998-2024 Developer Express Inc.           }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSDATACONTROLLER AND ALL         }
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

unit dxCustomData;

{$I cxVer.inc}
{$SCOPEDENUMS ON}

interface

// this unit for internal use only

uses
  Classes, SysUtils, Variants, Types, dxCore, dxCoreClasses, dxTypeHelpers, cxDataStorage, cxVariants;

const
  ValueNotNullFlag = 1;
  ValueTextFlag = 2;

type
  TdxDataStorage = class;
  TdxDataStorageClass = class of TdxDataStorage;
  TdxStorageItem = class;
  EdxDataStorageException = class(Exception);

  { TdxDataRecord }

  PdxDataRecord = ^TdxDataRecord;
  TdxDataRecord = packed record 
    Flag: Byte;
    Prior: PdxDataRecord;
    Next: PdxDataRecord;
    Data: Pointer;
  strict private
    function GetDisplayText(AItem: TdxStorageItem): string; inline;
    function GetIsNull(AItem: TdxStorageItem): Boolean; inline;
    function GetValue(AItem: TdxStorageItem): Variant; inline;
    procedure SetDisplayText(AItem: TdxStorageItem; const AValue: string); inline;
    procedure SetIsNull(AItem: TdxStorageItem; const AValue: Boolean); inline;
    procedure SetValue(AItem: TdxStorageItem; const AValue: Variant); inline;
  public
    function GetFirst: PdxDataRecord; inline;
    function GetLast: PdxDataRecord; inline;
    function Index: Integer; inline;

    property DisplayText[AItem: TdxStorageItem]: string read GetDisplayText write SetDisplayText;
    property IsNull[AItem: TdxStorageItem]: Boolean read GetIsNull write SetIsNull;
    property Value[AItem: TdxStorageItem]: Variant read GetValue write SetValue;
  end;

  { TdxStorageItem }

  TdxStorageItem = class
  private
    FDataOffset: Integer;
    FIndex: Integer;
    FItemLink: TObject;
    FName: string;
    FOwner: TdxDataStorage;
    FRefCount: Integer;
    FTextOffset: Integer;
    FTextStored: Boolean;
    FValueTypeClass: TcxValueTypeClass;
    function CompareValues(AData1, AData2: PAnsiChar): Integer; inline;
    function GetDataSize: Integer; inline;
    function GetDisplayText(ARecord: PdxDataRecord): string; inline;
    function GetIsManaged: Boolean; inline;
    function GetIsNull(ARecord: PdxDataRecord): Boolean; inline;
    function GetValue(ARecord: PdxDataRecord): Variant; inline;
    function GetValueSize: Integer; inline;
    procedure SetDisplayText(ARecord: PdxDataRecord; const AValue: string); inline;
    procedure SetIsNull(ARecord: PdxDataRecord; const AValue: Boolean); inline;
    procedure SetTextStored(AValue: Boolean);
    procedure SetValue(ARecord: PdxDataRecord; const AValue: Variant); inline;
    procedure SetValueTypeClass(AValue: TcxValueTypeClass);
    procedure ValidateTextOffset; inline;
  protected
    procedure ChangeDataOffset(var ANewOffset: Integer); inline;
    procedure CopyTo(ASource, ADest: PdxDataRecord); inline;
    procedure InitializeRecord(ARecord: PdxDataRecord); inline;
    procedure FinalizeRecord(ARecord: PdxDataRecord);
    procedure FinalizeRecordDisplayText(ARecord: PdxDataRecord);
    function GetName: string; virtual;
    procedure LoadDescriptionFromStream(AReader: TcxReader);
    procedure LoadRecordValueFromStream(AReader: TcxReader; ARecord: PdxDataRecord);
    procedure SaveDescriptionToStream(AWriter: TcxWriter);
    procedure SaveRecordValueToStream(AWriter: TcxWriter; ARecord: PdxDataRecord);
    procedure SetName(const AValue: string); virtual;
    procedure SkipRecordValueFromStream(AReader: TcxReader);

    property DataOffset: Integer read FDataOffset;
    property DataSize: Integer read GetDataSize;
    property Name: string read GetName write SetName;
    property IsManaged: Boolean read GetIsManaged;
    property ValueSize: Integer read GetValueSize;
  public
    constructor Create(AOwner: TdxDataStorage; AItemLink: TObject);
    destructor Destroy; override;
    procedure Assign(ASource: TdxStorageItem); virtual;
    function AddRef: Integer;
    procedure ChangeValueType(AValueTypeClass: TcxValueTypeClass; ATextStored: Boolean);
    function Compare(ARecord1, ARecord2: PdxDataRecord): Integer; overload;
    function CompareByDisplayText(ARecord1, ARecord2: PdxDataRecord; ACompareProc: TdxStringCompareProc): Integer; overload;
    function Compare(ARecord1: PdxDataRecord; AItem2: TdxStorageItem; ARecord2: PdxDataRecord): Integer; overload;
    function CompareByDisplayText(ARecord1: PdxDataRecord; AItem2: TdxStorageItem; ARecord2: PdxDataRecord; ACompareProc: TdxStringCompareProc): Integer; overload;
    function IsEqual(AItem: TdxStorageItem): Boolean;
    function Release: Integer;

    property DisplayText[ARecord: PdxDataRecord]: string read GetDisplayText write SetDisplayText;
    property IsNull[ARecord: PdxDataRecord]: Boolean read GetIsNull write SetIsNull;
    property Index: Integer read FIndex;
    property ItemLink: TObject read FItemLink write FItemLink;
    property Owner: TdxDataStorage read FOwner;
    property RefCount: Integer read FRefCount write FRefCount;
    property TextStored: Boolean read FTextStored write SetTextStored;
    property Value[ARecord: PdxDataRecord]: Variant read GetValue write SetValue;
    property ValueTypeClass: TcxValueTypeClass read FValueTypeClass write SetValueTypeClass;
  end;

  TdxDataStorageForEachProc = reference to procedure(ARecord: PdxDataRecord);
  TdxDataStorageForEachIndexProc = reference to procedure(AIndex: Integer; ARecord: PdxDataRecord; var ABreak: Boolean);

  TdxDataStorage = class
  strict private
    FCursor: PdxDataRecord;
    FCursorIndex: Integer;
    FDataOffset: Integer;
    FFirst: PdxDataRecord;
    FHeaderSize: Integer;
    FItems: TdxFastObjectList;
    FLast: PdxDataRecord;
    FLockCount: Integer;
    FManagedItems: TdxFastObjectList;
    FModified: Boolean;
    FRecordCount: Integer;
    FRecordSize: Integer;
    FOnChange: TNotifyEvent;
    function GetCursor: PdxDataRecord; inline;
    function GetCursorIndex: Integer; inline;
    function GetItem(AIndex: Integer): TdxStorageItem; inline;
    function GetItemCount: Integer; inline;
    procedure SetCursor(ARecord: PdxDataRecord); inline;
    procedure SetCursorIndex(AIndex: Integer); inline;
    procedure SetHeaderSize(AValue: Integer);
  protected type
    TdxDataStorageReallocateCallBack = reference to procedure(ARecord: PdxDataRecord);
  protected
    procedure Changed; inline;       
    procedure DoChange; virtual;
    function CreateItem(const AItemLink: TObject): TdxStorageItem; virtual;
    function CreateRecord: PdxDataRecord; inline;
    function CreateRecords(ACount: Integer): PdxDataRecord; inline;
    procedure DoDeleteItem(AItem: TdxStorageItem); virtual;
    procedure DoInsertItem(AItem: TdxStorageItem);
    procedure FinalizeRecordBuffer(ARecord: PdxDataRecord); inline;
    function FindBetween(AStart, AFinish: PdxDataRecord; AStartIndex, AFinishIndex, AIndex: Integer): PdxDataRecord; inline;
    function FindSameItem(AItem: TdxStorageItem; AIndex: Integer): TdxStorageItem;
    function GetRecord(AIndex: Integer): PdxDataRecord;
    procedure InitizelizeRecordBuffer(ARecord: PdxDataRecord); inline;
    procedure InternalAddItem(AItem: TdxStorageItem);
    function InsertRecords(AIndex: Integer; ARecords: PdxDataRecord; ACount: Integer): PdxDataRecord; inline;
    function IsUpdateLocked: Boolean; virtual;
    procedure ReallocRecord(var ARecord: PdxDataRecord; ANewSize: Integer); inline;
    procedure MoveDataAndReallocateRecords(ASource, ADest, ASizeDelta: Integer;
      AFinalizeProc, AInitializeProc: TdxDataStorageReallocateCallBack);
    procedure ValidateItemsOffset;
    //
    property ManagedItems: TdxFastObjectList read FManagedItems; 
    property Modified: Boolean read FModified;
  public
    constructor Create(const AHeaderSize: Integer = 0); virtual; 
    destructor Destroy; override;
    procedure Assign(ASource: TdxDataStorage); virtual;
    function AddItem(const AName: string; AItemLink: TObject;
      AValueTypeClass: TcxValueTypeClass; ATextStored: Boolean): TdxStorageItem;
    function Append: PdxDataRecord;
    procedure BeginUpdate;
    procedure CancelUpdate;
    procedure ChangeRecordsOrder(ARecords: TdxFastList); inline;   
    procedure Clear;
    procedure ClearItems;
    procedure ClearRecords;
    function Clone(ARecord: PdxDataRecord): PdxDataRecord;
    procedure CloneData(ASource, ADest: PdxDataRecord);
    function CreateRecordsList: TdxFastList; inline;              
    procedure Delete(ARecord: PdxDataRecord; ACount: Integer = 1); overload;
    procedure Delete(ARecordIndex: Integer; ACount: Integer = 1); overload;
    procedure DeleteItem(AItem: TdxStorageItem);
    procedure EndUpdate;
    function Extract(const ARecord: PdxDataRecord): PdxDataRecord; inline;
    procedure Exchange(ARecord1, ARecord2: PdxDataRecord); inline;
    function Insert(AIndex: Integer; ACount: Integer = 1): PdxDataRecord;
    function InsertAfter(ARecord: PdxDataRecord; ACount: Integer = 1): PdxDataRecord;
    function InsertBefore(ARecord: PdxDataRecord; ACount: Integer = 1): PdxDataRecord;
    function ItemByName(const AName: string): TdxStorageItem;
    procedure ForEach(AProc: TdxDataStorageForEachProc); overload;
    procedure ForEach(AProc: TdxDataStorageForEachIndexProc); overload;
    procedure ForEach(AStartIndex, AFinishIndex: Integer; AProc: TdxDataStorageForEachIndexProc); overload;
    procedure LoadFromStream(AStream: TStream);
    procedure SaveToStream(AStream: TStream);
    //
    class procedure Error(const AMessage: string);
    class procedure ErrorFmt(const AMessage: string; Args: array of const);

    property Cursor: PdxDataRecord read GetCursor write SetCursor;
    property CursorIndex: Integer read GetCursorIndex write SetCursorIndex;
    property DataOffset: Integer read FDataOffset;
    property HeaderSize: Integer read FHeaderSize write SetHeaderSize;
    property First: PdxDataRecord read FFirst;
    property Last: PdxDataRecord read FLast;
    property ItemCount: Integer read GetItemCount;
    property Items[Index: Integer]: TdxStorageItem read GetItem;
    property RecordCount: Integer read FRecordCount;
    property Records[Index: Integer]: PdxDataRecord read GetRecord; default;
    property RecordSize: Integer read FRecordSize;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  { TdxStorageItemCustomDataBinding }

  TdxStorageItemCustomDataBinding = class(TcxOwnedPersistent)
  private
    FItem: TdxStorageItem;
    function GetDataStorage: TdxDataStorage;
    function GetTextStored: Boolean;
    function GetValueType: string;
    function GetValueTypeClass: TcxValueTypeClass;
    procedure SetTextStored(AValue: Boolean);
    procedure SetValueType(const AValue: string);
    procedure SetValueTypeClass(AValue: TcxValueTypeClass);
    function IsValueTypeStored: Boolean;
  protected
    procedure Changed; virtual; abstract;
    procedure ChangeValueType(AValueTypeClass: TcxValueTypeClass; ATextStored: Boolean);
    procedure DoAssign(Source: TPersistent); override;
    function GetDefaultTextStored: Boolean; virtual;
    function GetDefaultValueTypeClass: TcxValueTypeClass; virtual;
    procedure InternalSetItem(AItem: TdxStorageItem); virtual;
    function IsValueTypeSupported(AValueTypeClass: TcxValueTypeClass): Boolean; virtual;

    property DataStorage: TdxDataStorage read GetDataStorage;
    property Item: TdxStorageItem read FItem;
    property TextStored: Boolean read GetTextStored write SetTextStored default False;
    property ValueType: string read GetValueType write SetValueType stored IsValueTypeStored;
    property ValueTypeClass: TcxValueTypeClass read GetValueTypeClass write SetValueTypeClass;
  public
    constructor Create(AOwner: TPersistent; AStorage: TdxDataStorage; ATextStored: Boolean = False); reintroduce; virtual;
    destructor Destroy; override;
  end;

implementation

uses
  RTLConsts;

const
  dxThisUnitName = 'dxCustomData';

const
  dxDataStorageVersion: Cardinal = 1;

procedure CheckLastAndFirst(const ARecord: PdxDataRecord; var AFirst, ALast: PdxDataRecord); inline;
begin
  if ARecord.Prior = nil then
    AFirst := ARecord;
  if ARecord.Next = nil then
    ALast := ARecord;
end;

procedure CorrectPriorLink(const ARecord: PdxDataRecord); inline;
begin
  if ARecord.Prior <> nil then
    ARecord.Prior.Next := ARecord;
end;

procedure CorrectNextLink(const ARecord: PdxDataRecord); inline;
begin
  if ARecord.Next <> nil then
    ARecord.Next.Prior := ARecord;
end;

function GetBuffer(ARecord: PdxDataRecord; AOffset: Integer): PAnsiChar; inline;
begin
  Result := PAnsiChar(ARecord);
  Inc(Result, AOffset);
end;

function IsNotNullFlag(AFlag: Pointer): Boolean; inline;
begin
  Result := PByte(AFlag)^ and ValueNotNullFlag = ValueNotNullFlag;
end;

{ TdxDataRecord }

function TdxDataRecord.GetFirst: PdxDataRecord;
begin
  Result := @Self;
  while Result.Prior <> nil do
    Result := Result.Prior;
end;

function TdxDataRecord.GetLast: PdxDataRecord;
begin
  Result := @Self;
  while Result.Next <> nil do
    Result := Result.Next;
end;

function TdxDataRecord.Index: Integer;
var
  APrior: PdxDataRecord;
begin
  Result := 0;
  APrior := Prior;
  while APrior <> nil do
  begin
    Inc(Result);
    APrior := APrior.Prior;
  end;
end;

function TdxDataRecord.GetDisplayText(AItem: TdxStorageItem): string;
begin
  Result := AItem.GetDisplayText(@Self);
end;

function TdxDataRecord.GetIsNull(AItem: TdxStorageItem): Boolean;
begin
  Result := AItem.GetIsNull(@Self);
end;

function TdxDataRecord.GetValue(AItem: TdxStorageItem): Variant;
begin
  Result := AItem.GetValue(@Self)
end;

procedure TdxDataRecord.SetDisplayText(AItem: TdxStorageItem; const AValue: string);
begin
  AItem.SetDisplayText(@Self, AValue);
end;

procedure TdxDataRecord.SetIsNull(AItem: TdxStorageItem; const AValue: Boolean);
begin
  AItem.SetIsNull(@Self, AValue);
end;

procedure TdxDataRecord.SetValue(AItem: TdxStorageItem; const AValue: Variant);
begin
  AItem.SetValue(@Self, AValue);
end;

{ TdxStorageItem }

constructor TdxStorageItem.Create(AOwner: TdxDataStorage; AItemLink: TObject);
begin
  FOwner := AOwner;
  FItemLink := AItemLink;
  FIndex := -1;
  FValueTypeClass := TcxValueType;
end;

destructor TdxStorageItem.Destroy;
begin
  if Owner <> nil then
    Owner.DoDeleteItem(Self);
end;

procedure TdxStorageItem.Assign(ASource: TdxStorageItem);
begin
  Name := ASource.Name;
  FItemLink := ASource.ItemLink;
  if FValueTypeClass = nil then
  begin
    FValueTypeClass := ASource.ValueTypeClass;
    FTextStored := ASource.TextStored;
  end
  else
    ChangeValueType(ASource.ValueTypeClass, ASource.TextStored);
end;

function TdxStorageItem.AddRef: Integer;
begin
  Inc(FRefCount);
  Result := FRefCount;
end;

function TdxStorageItem.IsEqual(AItem: TdxStorageItem): Boolean;
begin
  Result := (AItem.Name = Name) and (ValueTypeClass = AItem.ValueTypeClass) and (FTextStored = AItem.TextStored);
end;

function TdxStorageItem.Release: Integer;
begin
  Dec(FRefCount);
  Result := FRefCount;
  if FRefCount <= 0 then
    Free;
end;

function TdxStorageItem.GetValueSize: Integer;
begin
  Result := 1 + TcxValueTypeHelper.GetDataSize(ValueTypeClass); 
end;

function TdxStorageItem.CompareValues(AData1, AData2: PAnsiChar): Integer;
begin
  Result := 0;
  if IsNotNullFlag(AData1) = IsNotNullFlag(AData2) then
  begin
    if IsNotNullFlag(AData1) then
    begin
      Inc(AData1);
      Inc(AData2);
      Result := TcxValueTypeHelper.Compare(FValueTypeClass, AData1, AData2);
    end
  end
  else
    if not IsNotNullFlag(AData1) then
      Result := -1
    else
      Result := 1;
end;

function TdxStorageItem.GetDataSize: Integer;
begin
  Result := ValueSize;
  if TextStored then
    Inc(Result, SizeOf(Pointer));
end;

function TdxStorageItem.GetDisplayText(ARecord: PdxDataRecord): string;
var
  ADataPtr: PAnsiChar;
begin
  ADataPtr := GetBuffer(ARecord, FDataOffset);
  if not IsNotNullFlag(ADataPtr) then
    Exit('');
  if FTextStored then
  begin
    Inc(ADataPtr, ValueSize);
    Result := PString(ADataPtr)^;
  end
  else
    if ValueTypeClass.IsString then
    begin
      Inc(ADataPtr);
      Result := TcxValueTypeHelper.GetDataValue(ValueTypeClass, ADataPtr);
    end
    else
      Result := '';
end;

function TdxStorageItem.GetIsManaged: Boolean;
begin
  Result := ValueTypeClass.IsManaged or TextStored;
end;

function TdxStorageItem.GetIsNull(ARecord: PdxDataRecord): Boolean;
begin
  Result := not IsNotNullFlag(GetBuffer(ARecord, FDataOffset));
end;

function TdxStorageItem.GetValue(ARecord: PdxDataRecord): Variant;
var
  ADataPtr: PAnsiChar;
begin
  ADataPtr := GetBuffer(ARecord, FDataOffset);
  if IsNotNullFlag(ADataPtr) then
  begin
    Inc(ADataPtr);
    Result := TcxValueTypeHelper.GetDataValue(ValueTypeClass, ADataPtr);
  end
  else
    Result := Null;
end;

procedure TdxStorageItem.SetDisplayText(ARecord: PdxDataRecord; const AValue: string);
var
  ADataPtr: PAnsiChar;
begin
  if FTextStored then
  begin
    ADataPtr := GetBuffer(ARecord, FDataOffset);
    if AValue = '' then
      PByte(ADataPtr)^ := PByte(ADataPtr)^ and not ValueTextFlag
    else
      PByte(ADataPtr)^ := PByte(ADataPtr)^ or ValueTextFlag;
    PString(GetBuffer(ARecord, FTextOffset))^ := AValue;
  end;
end;

procedure TdxStorageItem.ValidateTextOffset;
begin
  if FTextStored then
    FTextOffset := FDataOffset + ValueSize
  else
    FTextOffset := FDataOffset + 1;
end;

procedure TdxStorageItem.SetIsNull(ARecord: PdxDataRecord; const AValue: Boolean);
begin
  if IsNotNullFlag(GetBuffer(ARecord, FDataOffset)) <> AValue then
    Exit;
  if AValue then
    FinalizeRecord(ARecord);
end;

procedure TdxStorageItem.SetTextStored(AValue: Boolean);
begin
  if AValue and ValueTypeClass.IsString then
    AValue := False;
  if AValue <> TextStored then
    ChangeValueType(ValueTypeClass, AValue);
end;

procedure TdxStorageItem.SetValue(ARecord: PdxDataRecord; const AValue: Variant);
var
  ADataPtr: PAnsiChar;
begin
  if VarIsNull(AValue) then
    FinalizeRecord(ARecord)
  else
  begin
    ADataPtr := GetBuffer(ARecord, FDataOffset);
    PByte(ADataPtr)^ := PByte(ADataPtr)^ or ValueNotNullFlag;
    Inc(ADataPtr);
    TcxValueTypeHelper.SetDataValue(ValueTypeClass, ADataPtr, AValue);
  end;
end;

procedure TdxStorageItem.SetValueTypeClass(AValue: TcxValueTypeClass);
begin
  if AValue <> FValueTypeClass then
    ChangeValueType(AValue, False);
end;

procedure TdxStorageItem.ChangeDataOffset(var ANewOffset: Integer);
begin
  FDataOffset := ANewOffset;
  ValidateTextOffset;
  Inc(ANewOffset, DataSize);
end;

procedure TdxStorageItem.CopyTo(ASource, ADest: PdxDataRecord);
var
  ASourcePtr, ADestPtr: PAnsiChar;
begin
  InitializeRecord(ADest);
  ASourcePtr := GetBuffer(ASource, FDataOffset);
  ADestPtr := GetBuffer(ADest, FDataOffset);
  if IsNotNullFlag(ASourcePtr) then
  begin
    PByte(ADestPtr)^ := PByte(ASourcePtr)^;
    Inc(ASourcePtr);
    Inc(ADestPtr);
    TcxValueTypeHelper.SetDataValue(ValueTypeClass, ADestPtr,
      TcxValueTypeHelper.GetDataValue(ValueTypeClass, ASourcePtr));
    if TextStored then
    begin
      Inc(ASourcePtr, ValueSize - 1);
      Inc(ADestPtr, ValueSize - 1);
      PString(ADestPtr)^ := PString(ASourcePtr)^;
    end;
  end;
end;

procedure TdxStorageItem.InitializeRecord(ARecord: PdxDataRecord);
begin
  FillChar(GetBuffer(ARecord, FDataOffset)^, GetDataSize, 0);
end;

procedure TdxStorageItem.FinalizeRecord(ARecord: PdxDataRecord);
var
  ADataPtr: PAnsiChar;
begin
  if ValueTypeClass.IsManaged then
  begin
    ADataPtr := GetBuffer(ARecord, FDataOffset + 1);
    if PPointer(ADataPtr)^ <> nil then
    begin
      TcxValueTypeHelper.FreeBuffer(ValueTypeClass, ADataPtr);
      PPointer(ADataPtr)^ := nil;
    end;
  end
  else
    if TextStored then
      PString(GetBuffer(ARecord, FTextOffset))^ := '';
  InitializeRecord(ARecord);
end;

procedure TdxStorageItem.FinalizeRecordDisplayText(ARecord: PdxDataRecord);
begin
  if FTextStored then
    PString(GetBuffer(ARecord, FTextOffset))^ := '';
end;

function TdxStorageItem.GetName: string;
begin
  Result := FName;
end;

procedure TdxStorageItem.SkipRecordValueFromStream(AReader: TcxReader);
var
  AFlag: Byte;
  ABuffer: PAnsiChar;
begin
  AFlag :=  AReader.ReadByte;
  if IsNotNullFlag(@AFlag) then
  begin
    ABuffer := AllocMem(ValueSize);
    try
      TcxValueTypeHelper.ReadDataValue(ValueTypeClass, ABuffer, AReader.Stream as TdxStream);
      TcxValueTypeHelper.FreeBuffer(ValueTypeClass, ABuffer);
    finally
      FreeMem(ABuffer);
    end;
  end;
  if AFlag and ValueTextFlag = ValueTextFlag then
    AReader.ReadString;
end;

procedure TdxStorageItem.LoadDescriptionFromStream(AReader: TcxReader);
var
  ATypeName: string;
begin
  Name := AReader.ReadString;
  ATypeName := AReader.ReadString;
  FValueTypeClass := cxValueTypeClassList.ItemByCaption(ATypeName);
  if FValueTypeClass = nil then
    TdxDataStorage.ErrorFmt('Not registered value type (%s) of %s item', [ATypeName, Name]);
  FDataOffset := AReader.ReadInteger;
  FTextStored := AReader.ReadBoolean;
  ValidateTextOffset;
end;

procedure TdxStorageItem.LoadRecordValueFromStream(AReader: TcxReader; ARecord: PdxDataRecord);
var
  AFlag: Byte;
  ADestPtr: PAnsiChar;
begin
  AFlag :=  AReader.ReadByte;
  ADestPtr := GetBuffer(ARecord, FDataOffset);
  if IsNotNullFlag(@AFlag) then
  begin
    PByte(ADestPtr)^ := ValueNotNullFlag;
    Inc(ADestPtr);
    TcxValueTypeHelper.ReadDataValue(ValueTypeClass, ADestPtr, AReader.Stream as TdxStream)
  end
  else
    SetValue(ARecord, Null);
  if AFlag and ValueTextFlag = ValueTextFlag then
    SetDisplayText(ARecord, AReader.ReadString);
end;

procedure TdxStorageItem.SaveDescriptionToStream(AWriter: TcxWriter);
begin
  AWriter.WriteString(Name);
  AWriter.WriteString(ValueTypeClass.Caption);
  AWriter.WriteInteger(FDataOffset);
  AWriter.WriteBoolean(FTextStored);
end;

procedure TdxStorageItem.SaveRecordValueToStream(AWriter: TcxWriter; ARecord: PdxDataRecord);
var
  AFlag: Byte;
  ADisplayText: string;
  ADataPtr: PAnsiChar;
begin
  ADataPtr := GetBuffer(ARecord, FDataOffset);
  AFlag := PByte(ADataPtr)^;
  if TextStored then
  begin
    ADisplayText := GetDisplayText(ARecord);
    if ADisplayText <> '' then
      AFlag := AFlag or ValueTextFlag;
  end;
  AWriter.WriteByte(AFlag);
  if IsNotNullFlag(ADataPtr) then
  begin
    Inc(ADataPtr);
    TcxValueTypeHelper.WriteDataValue(ValueTypeClass, ADataPtr, AWriter.Stream as TdxStream);
  end;
  if AFlag and ValueTextFlag = ValueTextFlag then
    AWriter.WriteString(ADisplayText);
end;

procedure TdxStorageItem.SetName(const AValue: string);
begin
  FName := AValue;
end;

{ TdxDataStorage }

constructor TdxDataStorage.Create(const AHeaderSize: Integer = 0);
begin
  FItems := TdxFastObjectList.Create;
  FManagedItems := TdxFastObjectList.Create(False);
  FHeaderSize := AHeaderSize;
  FDataOffset := SizeOf(TdxDataRecord) - SizeOf(Pointer) + FHeaderSize;
  FRecordSize := FDataOffset;
end;

destructor TdxDataStorage.Destroy;
begin
  Clear;
  FreeAndNil(FItems);
  FreeAndNil(FManagedItems);
  inherited Destroy;
end;

procedure TdxDataStorage.Assign(ASource: TdxDataStorage);
var
  I: Integer;
  AItem: TdxStorageItem;
  ASourceRecord, ADestRecord: PdxDataRecord;
begin
  if ASource = nil then
    Exit;
  BeginUpdate;
  try
    Clear;
    FHeaderSize := ASource.HeaderSize;
    FDataOffset := ASource.FDataOffset;
    FRecordSize := FDataOffset;
    for I := 0 to ASource.ItemCount - 1 do
    begin
      AItem := CreateItem(ASource.Items[I].ItemLink);
      AItem.FDataOffset := ASource.Items[I].FDataOffset;
      InternalAddItem(AItem);
      Inc(FRecordSize);
      AItem.Assign(ASource.Items[I]);
    end;
    ValidateItemsOffset;
    ASourceRecord := ASource.First;
    while ASourceRecord <> nil do
    begin
      ADestRecord := Append;
      ASource.CloneData(ASourceRecord, ADestRecord);
      ASourceRecord := ASourceRecord.Next;
    end;
  finally
    EndUpdate;
  end;
end;

function TdxDataStorage.GetCursor: PdxDataRecord;
begin
  if FCursorIndex < 0 then
  begin
    FCursorIndex := FRecordCount - 1;
    FCursor := FLast;
  end;
  Result := FCursor;
end;

function TdxDataStorage.GetCursorIndex: Integer;
begin
  if FCursorIndex < 0 then
  begin
    FCursorIndex := FRecordCount - 1;
    FCursor := Last;
  end;
  Result := FCursorIndex;
end;

function TdxDataStorage.GetItem(AIndex: Integer): TdxStorageItem;
begin
  Result := TdxStorageItem(FItems.List[AIndex]);
end;

function TdxDataStorage.GetItemCount: Integer;
begin
  Result := FItems.Count;
end;

function TdxDataStorage.GetRecord(AIndex: Integer): PdxDataRecord;
begin
  if (AIndex < 0) or (AIndex >= FRecordCount) then
    ErrorFmt(SListIndexError, [AIndex]);
  if AIndex = 0 then
    Exit(FFirst)
  else
    if AIndex = FRecordCount - 1 then
      Exit(FLast)
    else
    begin
      if FCursorIndex < 0 then
      begin
        FCursor := FLast;
        FCursorIndex := FRecordCount - 1;
      end;
      if AIndex < FCursorIndex then
        Result := FindBetween(FFirst, FCursor, 0, FCursorIndex, AIndex)
      else
        Result := FindBetween(FCursor, FLast, FCursorIndex, FRecordCount - 1, AIndex)
    end;
end;

procedure TdxDataStorage.SetCursor(ARecord: PdxDataRecord);
begin
  FCursor := ARecord;
  if FCursor = nil then
    FCursorIndex := -1
  else
    if FCursor = FFirst then
      FCursorIndex := 0
    else
      if FCursor = FLast then
        FCursorIndex := FRecordCount - 1
      else
        FCursorIndex := FCursor.Index;
end;

procedure TdxDataStorage.SetCursorIndex(AIndex: Integer);
begin
  FCursor := GetRecord(AIndex);
end;

procedure TdxDataStorage.SetHeaderSize(AValue: Integer);
var
  ASizeDelta: Integer;
begin
  if AValue = FHeaderSize then
    Exit;
  ASizeDelta := AValue - FHeaderSize;
  FHeaderSize := AValue;
  Inc(FDataOffset, ASizeDelta);
  MoveDataAndReallocateRecords(FDataOffset - ASizeDelta, FDataOffset, ASizeDelta, nil, nil);
  ValidateItemsOffset;
end;

function TdxDataStorage.CreateItem(const AItemLink: TObject): TdxStorageItem;
begin
  Result := TdxStorageItem.Create(Self, AItemLink);
end;

procedure TdxDataStorage.Changed;
begin
  FModified := IsUpdateLocked;
  if IsUpdateLocked then
    Exit;
  if not Modified then
    DoChange;
end;

procedure TdxDataStorage.DoChange;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

function TdxDataStorage.CreateRecord: PdxDataRecord;
begin
  Result := AllocMem(FRecordSize);
  InitizelizeRecordBuffer(Result);
end;

function TdxDataStorage.CreateRecords(ACount: Integer): PdxDataRecord;
var
  ANextRecord: PdxDataRecord;
begin
  Result := nil;
  ANextRecord := nil;
  while ACount > 0 do
  begin
    Result := CreateRecord;
    Result.Next := ANextRecord;
    if ANextRecord <> nil then
      ANextRecord.Prior := Result;
    ANextRecord := Result;
    Dec(ACount);
  end;
end;

procedure TdxDataStorage.DoDeleteItem(AItem: TdxStorageItem);
begin
  MoveDataAndReallocateRecords(AItem.DataOffset + AItem.DataSize, AItem.DataOffset,
    -AItem.DataSize, AItem.FinalizeRecord, nil);
  if AItem.IsManaged then
    ManagedItems.Remove(AItem);
  FItems.List[AItem.Index] := nil;
  FItems.Delete(AItem.Index);
  ValidateItemsOffset;
end;

procedure TdxDataStorage.DoInsertItem(AItem: TdxStorageItem);
begin
  MoveDataAndReallocateRecords(AItem.FDataOffset, AItem.FDataOffset + AItem.DataSize, AItem.DataSize, nil, nil);
  ValidateItemsOffset;
end;

function TdxDataStorage.Extract(const ARecord: PdxDataRecord): PdxDataRecord;
begin
  Result := ARecord.Next;
  if ARecord.Prior <> nil then
    ARecord.Prior.Next := ARecord.Next
  else
    FFirst := ARecord.Next;
  if ARecord.Next <> nil then
    ARecord.Next.Prior := ARecord.Prior
  else
  begin
    FLast := ARecord.Prior;
    Result := FLast;
  end;
  Dec(FRecordCount);
  if ARecord = FCursor then
  begin
    FCursor := Result;
    if FCursorIndex >= FRecordCount then
      FCursorIndex := FRecordCount;
  end;
  ARecord.Prior := nil;
  ARecord.Next := nil;
end;

procedure TdxDataStorage.FinalizeRecordBuffer(ARecord: PdxDataRecord);
var
  I: Integer;
begin
  for I := 0 to ManagedItems.Count - 1 do
    TdxStorageItem(ManagedItems[I]).FinalizeRecord(ARecord);
end;

procedure TdxDataStorage.InitizelizeRecordBuffer(ARecord: PdxDataRecord);
var
  I: Integer;
begin
  for I := 0 to ManagedItems.Count - 1 do
    TdxStorageItem(ManagedItems[I]).InitializeRecord(ARecord);
end;

procedure TdxDataStorage.InternalAddItem(AItem: TdxStorageItem);
begin
  if AItem.IsManaged then
    FManagedItems.Add(AItem);
  FItems.Add(AItem);
end;

function TdxDataStorage.InsertRecords(AIndex: Integer; ARecords: PdxDataRecord; ACount: Integer): PdxDataRecord;
var
  ALast: PdxDataRecord;
begin
  if ACount = 0 then
    Exit(nil);
  Result := ARecords;
  ALast := ARecords.GetLast;
  if AIndex < 0 then
    AIndex := 0
  else
    if AIndex > FRecordCount then
      AIndex := FRecordCount;
  if FRecordCount = 0 then 
  begin
    FFirst := Result;
    FLast := ALast;
  end
  else
    if AIndex = 0 then  
    begin
      ALast.Next := FFirst;
      FFirst.Prior := ALast;
      FFirst := Result;
    end
    else
      if AIndex = FRecordCount then 
      begin
        FLast.Next := Result;
        Result.Prior := FLast;
        FLast := ALast;
      end
      else
      begin  
        GetRecord(AIndex);
        FCursor.Prior.Next := Result;
        Result.Prior := FCursor.Prior;
        FCursor.Prior := ALast;
        ALast.Next := FCursor;
      end;
  //
  Inc(FRecordCount, ACount);
  FCursor := Result;
  FCursorIndex := AIndex;
end;

function TdxDataStorage.IsUpdateLocked: Boolean;
begin
  Result := FLockCount > 0;
end;

procedure TdxDataStorage.ReallocRecord(var ARecord: PdxDataRecord; ANewSize: Integer);
var
  APrevPtr: Pointer;
begin
  APrevPtr := ARecord;
  ReallocMem(ARecord, ANewSize);
  if APrevPtr <> ARecord then
  begin
    if APrevPtr = First then
      FFirst := ARecord
    else
      ARecord.Prior.Next := ARecord;
    if ARecord.Next <> nil then
      ARecord.Next.Prior := ARecord
    else
      FLast := ARecord;
    if APrevPtr = FCursor then
      FCursor := ARecord;
  end;
end;

procedure TdxDataStorage.MoveDataAndReallocateRecords(ASource, ADest, ASizeDelta: Integer;
  AFinalizeProc, AInitializeProc: TdxDataStorageReallocateCallBack);
var
  ACopySize: Integer;
  ARecord: PdxDataRecord;
begin
  if (ASizeDelta = 0) and not Assigned(AFinalizeProc) and not Assigned(AInitializeProc) then
    Exit;
  ACopySize := FRecordSize - ASource;
  Inc(FRecordSize, ASizeDelta);
  ARecord := FFirst;
  while ARecord <> nil do
  begin
    if Assigned(AFinalizeProc) then
      AFinalizeProc(ARecord);
    if ASizeDelta > 0 then
      ReallocRecord(ARecord, FRecordSize);
    Move(GetBuffer(ARecord, ASource)^, GetBuffer(ARecord, ADest)^, ACopySize);
    if ASizeDelta < 0 then
      ReallocRecord(ARecord, FRecordSize)
    else
      FillChar(GetBuffer(ARecord, ASource)^, ASizeDelta, 0);
    if Assigned(AInitializeProc) then
      AInitializeProc(ARecord);
    ARecord := ARecord.Next;
  end;
end;

procedure TdxDataStorage.ValidateItemsOffset;
var
  AIndex: Integer;
  AItem: TdxStorageItem;
  ASize, AItemDataOffset: Integer;
begin
  FManagedItems.Clear;
  AItemDataOffset := FDataOffset;
  ASize := FRecordSize;
  for AIndex := 0 to ItemCount - 1 do
  begin
    AItem := Items[AIndex];
    AItem.FIndex := AIndex;
    if AItem.IsManaged then
      ManagedItems.Add(AItem);
    AItem.ChangeDataOffset(AItemDataOffset);
  end;
  FRecordSize := AItemDataOffset;
  if ASize <> FRecordSize then
    ErrorFmt('Invalid record size %d, %d', [ASize, FRecordSize]);
end;

function TdxDataStorage.FindBetween(AStart, AFinish: PdxDataRecord;
  AStartIndex, AFinishIndex, AIndex: Integer): PdxDataRecord;
begin
  if AIndex <= (AStartIndex + AFinishIndex) div 2 then
  begin
    Result := AStart;
    while AStartIndex <> AIndex do
    begin
      Result := Result.Next;
      Inc(AStartIndex);
    end
  end
  else
  begin
    Result := AFinish;
    while AFinishIndex <> AIndex do
    begin
      Result := Result.Prior;
      Dec(AFinishIndex);
    end
  end;
  FCursor := Result;
  FCursorIndex := AIndex;
end;

function TdxDataStorage.FindSameItem(AItem: TdxStorageItem; AIndex: Integer): TdxStorageItem;
begin
  Result := nil;
  if (AIndex < FItems.Count) and Items[AIndex].IsEqual(AItem) then
    Exit(Items[AIndex]);
  if AItem.Name <> '' then
    Result := ItemByName(AItem.Name);
end;

function TdxDataStorage.AddItem(const AName: string; AItemLink: TObject;
  AValueTypeClass: TcxValueTypeClass; ATextStored: Boolean): TdxStorageItem;
begin
  Result := CreateItem(AItemLink);
  Result.FValueTypeClass := AValueTypeClass;
  Result.FTextStored := ATextStored and not AValueTypeClass.IsString;
  Result.FDataOffset := RecordSize;
  InternalAddItem(Result);
  DoInsertItem(Result);
  Result.Name := AName;
end;

function TdxDataStorage.Append: PdxDataRecord;
begin
  Result := CreateRecord;
  Inc(FRecordCount);
  Result.Prior := FLast;
  if FLast <> nil then
    FLast.Next := Result
  else
    FFirst := Result;
  FLast := Result;
  FCursor := Result;
  FCursorIndex := FRecordCount - 1;
end;

procedure TdxStorageItem.ChangeValueType(AValueTypeClass: TcxValueTypeClass; ATextStored: Boolean);
var
  ADelta: Integer;
begin
  if AValueTypeClass = nil then
    Exit;
  if AValueTypeClass.IsString then
    ATextStored := False;
  if (AValueTypeClass = ValueTypeClass) and (ATextStored = TextStored) then
    Exit;
  ADelta := TcxValueTypeHelper.GetDataSize(AValueTypeClass) + 1 - DataSize;
  if ATextStored then
    Inc(ADelta, SizeOf(Pointer));
  if Owner <> nil then
    Owner.MoveDataAndReallocateRecords(FDataOffset + DataSize, FDataOffset + DataSize + ADelta, ADelta, FinalizeRecord, nil);
  FTextStored := ATextStored;
  FValueTypeClass := AValueTypeClass;
  if Owner <> nil then
    Owner.ValidateItemsOffset;
end;

function TdxStorageItem.Compare(ARecord1, ARecord2: PdxDataRecord): Integer;
begin
  Result := CompareValues(GetBuffer(ARecord1, FDataOffset), GetBuffer(ARecord2, FDataOffset));
end;

function TdxStorageItem.CompareByDisplayText(ARecord1, ARecord2: PdxDataRecord;
  ACompareProc: TdxStringCompareProc): Integer;
begin
  Result := ACompareProc(GetDisplayText(ARecord1), GetDisplayText(ARecord2));
end;

function TdxStorageItem.Compare(ARecord1: PdxDataRecord; AItem2: TdxStorageItem; ARecord2: PdxDataRecord): Integer;
begin
  Result := CompareValues(GetBuffer(ARecord1, FDataOffset), GetBuffer(ARecord2, AItem2.FDataOffset));
end;

function TdxStorageItem.CompareByDisplayText(ARecord1: PdxDataRecord; AItem2: TdxStorageItem; ARecord2: PdxDataRecord;
  ACompareProc: TdxStringCompareProc): Integer;
begin
  Result := ACompareProc(GetDisplayText(ARecord1), AItem2.GetDisplayText(ARecord2));
end;

procedure TdxDataStorage.BeginUpdate;
begin
  Inc(FLockCount);
end;

procedure TdxDataStorage.CancelUpdate;
begin
  Dec(FLockCount);
end;

procedure TdxDataStorage.ChangeRecordsOrder(ARecords: TdxFastList);
var
  I: Integer;
  APrior, ANext, ARecord: PdxDataRecord;
begin
  if ARecords.Count = 0 then
    Exit;
  if ARecords.Count <> FRecordCount then
    Error('Inconsistent records');
  APrior := nil;
  ARecord := PdxDataRecord(ARecords.List[0]);
  for I := 0 to ARecords.Count - 1 do
  begin
    if I < ARecords.Count - 1 then
      ANext := PdxDataRecord(ARecords.List[I + 1])
    else
      ANext := nil;
    ARecord.Prior := APrior;
    ARecord.Next := ANext;
    CorrectPriorLink(ARecord);
    CorrectNextLink(ARecord);
    APrior := ARecord;
    ARecord := ANext;
  end;
  FFirst := ARecords.First;
  FLast := ARecords.Last;
  if FCursor <> nil then
    FCursorIndex := FCursor.Index;
  Changed;
end;

procedure TdxDataStorage.Clear;
begin
  ClearRecords;
  ClearItems;
end;

procedure TdxDataStorage.ClearItems;
var
  I: Integer;
begin
  for I := ItemCount - 1 downto 0 do
    Items[I].Free;
end;

procedure TdxDataStorage.ClearRecords;
begin
  try
    while FFirst <> nil do
    begin
      FinalizeRecordBuffer(FFirst);
      if FFirst.Next <> nil then
      begin
        FFirst := FFirst.Next;
        if FFirst.Prior <> nil then
          FreeMem(FFirst.Prior);
      end
      else
      begin
        FreeMem(FFirst);
        FFirst := nil;
      end;
    end;
  finally
    FRecordCount := 0;
    FFirst := nil;
    FLast := nil;
    FCursor := nil;
    FCursorIndex := -1;
    Changed;
  end;
end;

function TdxDataStorage.Clone(ARecord: PdxDataRecord): PdxDataRecord;
begin
  Result := CreateRecord;
  CloneData(ARecord, Result);
end;

procedure TdxDataStorage.CloneData(ASource, ADest: PdxDataRecord);
var
  I: Integer;
begin
  I := SizeOf(TdxDataRecord) - SizeOf(Pointer);
  Move(GetBuffer(ASource, I)^, GetBuffer(ADest, I)^, FRecordSize - I);
  for I := 0 to ManagedItems.Count - 1 do
     TdxStorageItem(ManagedItems[I]).CopyTo(ASource, ADest);
end;

function TdxDataStorage.CreateRecordsList: TdxFastList;
var
  I: Integer;
  ARecord: PdxDataRecord;
begin
  Result := TdxFastList.Create(FRecordCount);
  Result.Count := FRecordCount;
  ARecord := FFirst;
  for I := 0 to FRecordCount - 1 do
  begin
    Result.List[I] := ARecord;
    ARecord := ARecord.Next;
  end;
end;

procedure TdxDataStorage.Delete(ARecord: PdxDataRecord; ACount: Integer = 1);
var
  ANext: PdxDataRecord;
begin
  while (ACount > 0) and (FRecordCount > 0) and (ARecord <> nil) do
  begin
    ANext := ARecord.Next;
    Extract(ARecord);
    FinalizeRecordBuffer(ARecord);
    FreeMem(ARecord);
    ARecord := ANext;
    Dec(ACount);
  end;
end;

procedure TdxDataStorage.Delete(ARecordIndex: Integer; ACount: Integer = 1);
begin
  Delete(GetRecord(ARecordIndex), ACount);
end;

procedure TdxDataStorage.DeleteItem(AItem: TdxStorageItem);
begin
  AItem.Free;
end;

procedure TdxDataStorage.EndUpdate;
begin
  Dec(FLockCount);
  if (FLockCount = 0) and Modified then
    Changed;
end;

procedure TdxDataStorage.Exchange(ARecord1, ARecord2: PdxDataRecord);
begin
  if (ARecord1 = ARecord2) or (ARecord1 = nil) or (ARecord2 = nil) then
    Exit;
  if ARecord1.Prior = ARecord2 then 
    ExchangePointers(ARecord1, ARecord2);
  ExchangePointers(ARecord1.Prior, ARecord2.Prior);
  ExchangePointers(ARecord1.Next, ARecord2.Next);
  if ARecord1.Prior = ARecord1 then 
  begin
    CorrectNextLink(ARecord1);
    CorrectPriorLink(ARecord2);
    ARecord1.Prior := ARecord2;
    ARecord2.Next := ARecord1;
  end
  else
  begin 
    CorrectPriorLink(ARecord1);
    CorrectNextLink(ARecord1);
    CorrectPriorLink(ARecord2);
    CorrectNextLink(ARecord2);
  end;
  CheckLastAndFirst(ARecord1, FFirst, FLast);
  CheckLastAndFirst(ARecord2, FFirst, FLast);
  if (FCursor = ARecord1) or (FCursor = ARecord2) then
    FCursorIndex := FCursor.Index;
end;

class procedure TdxDataStorage.Error(const AMessage: string);
begin
  raise EdxDataStorageException.Create(AMessage);
end;

class procedure TdxDataStorage.ErrorFmt(const AMessage: string; Args: array of const);
begin
  raise EdxDataStorageException.CreateFmt(AMessage, Args);
end;

function TdxDataStorage.Insert(AIndex, ACount: Integer): PdxDataRecord;
begin
  Result := InsertRecords(AIndex, CreateRecords(ACount), ACount);
end;

function TdxDataStorage.InsertAfter(ARecord: PdxDataRecord; ACount: Integer = 1): PdxDataRecord;
var
  ALast: PdxDataRecord;
begin
  if ARecord = nil then
    Result := Insert(FRecordCount, ACount)
  else
  begin
    Result := CreateRecords(ACount);
    ALast := Result.GetLast;
    ALast.Next := ARecord.Next;
    if ALast.Next <> nil then
      ALast.Next.Prior := ALast
    else
      FLast := ALast;
    ARecord.Next := Result;
    Result.Prior := ARecord;
    Inc(FRecordCount, ACount);
    FCursor := Result;
    FCursorIndex := Result.Index;
  end;
end;

function TdxDataStorage.InsertBefore(ARecord: PdxDataRecord; ACount: Integer = 1): PdxDataRecord;
var
  ALast: PdxDataRecord;
begin
  if ARecord = nil then
    Result := Insert(0, ACount)
  else
  begin
    Result := CreateRecords(ACount);
    Result.Prior := ARecord.Prior;
    ALast := Result.GetLast;
    ALast.Next := ARecord;
    ARecord.Prior := ALast;
    if Result.Prior <> nil then
      Result.Prior.Next := Result
    else
      FFirst := Result;
    Inc(FRecordCount, ACount);
    FCursor := Result;
    FCursorIndex := Result.Index;
  end;
end;

function TdxDataStorage.ItemByName(const AName: string): TdxStorageItem;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to FItems.Count - 1 do
    if SameText(TdxStorageItem(FItems[I]).Name, AName) then
      Exit(TdxStorageItem(FItems[I]));
end;

procedure TdxDataStorage.ForEach(AProc: TdxDataStorageForEachIndexProc);
var
  AIndex: Integer;
  ABreak: Boolean;
  ARecord: PdxDataRecord;
begin
  AIndex := 0;
  ABreak := False;
  ARecord := First;
  while (ARecord <> nil) and not ABreak do
  begin
    AProc(AIndex, ARecord, ABreak);
    ARecord := ARecord^.Next;
    Inc(AIndex);
  end;
end;

procedure TdxDataStorage.ForEach(AProc: TdxDataStorageForEachProc);
var
  ARecord: PdxDataRecord;
begin
  ARecord := First;
  while ARecord <> nil do
  begin
    AProc(ARecord);
    ARecord := ARecord^.Next;
  end;
end;

procedure TdxDataStorage.ForEach(AStartIndex, AFinishIndex: Integer; AProc: TdxDataStorageForEachIndexProc);
var
  AIndex: Integer;
  ABreak: Boolean;
  ARecord: PdxDataRecord;
begin
  ABreak := False;
  AIndex := AStartIndex;
  ARecord := GetRecord(AStartIndex);
  while (ARecord <> nil) and not ABreak and (AIndex < AFinishIndex) do
  begin
    AProc(AIndex, ARecord, ABreak);
    ARecord := ARecord^.Next;
    Inc(AIndex);
  end;
end;

procedure TdxDataStorage.LoadFromStream(AStream: TStream);
var
  AReader: TcxReader;
  AdxStream: TdxStream;
  ARecord: PdxDataRecord;
  AItem: TdxStorageItem;
  AItems: TdxFastObjectList;
  AItemsCount, ACount, I, J, AHeaderSize: Integer;
begin
  if ItemCount = 0 then
    Exit;
  AdxStream := TdxStream.Create(AStream);
  try
    AReader := TcxReader.Create(AdxStream, ReadCardinalFunc(AStream));
    try
      AItems := TdxFastObjectList.Create();
      try
        AHeaderSize := AReader.ReadInteger;
        AItemsCount := AReader.ReadInteger;
        ACount := AReader.ReadInteger;
        for I := 0 to AItemsCount - 1 do
        begin
          AItems.Add(TdxStorageItem.Create(nil, nil));
          TdxStorageItem(AItems[I]).LoadDescriptionFromStream(AReader);
          TdxStorageItem(AItems[I]).FItemLink := FindSameItem(TdxStorageItem(AItems[I]), I);
        end;
        ClearRecords;
        for I := 0 to ACount - 1 do
        begin
          ARecord := Append;
          if FHeaderSize = AHeaderSize then
            AStream.ReadBuffer(Pointer(@ARecord.Data)^, AHeaderSize)
          else
            AStream.Seek(AHeaderSize, soFromCurrent);
          for J := 0 to AItems.Count - 1 do
          begin
            AItem := TdxStorageItem(AItems.List[J]);
            if AItem.ItemLink <> nil then
              TdxStorageItem(AItem.ItemLink).LoadRecordValueFromStream(AReader, ARecord)
            else
              AItem.SkipRecordValueFromStream(AReader);
          end;
        end;
      finally
        AItems.Free;
      end;
    finally
      AReader.Free;
    end;
  finally
    AdxStream.Free;
  end;
  Changed;
end;

procedure TdxDataStorage.SaveToStream(AStream: TStream);
var
  I: Integer;
  AWriter: TcxWriter;
  AdxStream: TdxStream;
  ARecord: PdxDataRecord;
begin
  AdxStream := TdxStream.Create(AStream);
  try
    AWriter := TcxWriter.Create(AdxStream);
    try
      AWriter.WriteCardinal(dxDataStorageVersion);
      AWriter.Version := dxDataStorageVersion;
      AWriter.WriteInteger(FHeaderSize);
      AWriter.WriteInteger(FItems.Count);
      AWriter.WriteInteger(FRecordCount);
      for I := 0 to FItems.Count - 1 do
        TdxStorageItem(FItems[I]).SaveDescriptionToStream(AWriter);
      ARecord := First;
      while ARecord <> nil do
      begin
        AdxStream.WriteBuffer(Pointer(@ARecord.Data)^, FHeaderSize);
        for I := 0 to ItemCount - 1 do
          Items[I].SaveRecordValueToStream(AWriter, ARecord);
        ARecord := ARecord.Next;
      end;
    finally
      AWriter.Free;
    end;
  finally
    AdxStream.Free;
  end;
end;

{ TdxStorageItemCustomDataBinding }

constructor TdxStorageItemCustomDataBinding.Create(AOwner: TPersistent; AStorage: TdxDataStorage; ATextStored: Boolean = False);
begin
  inherited Create(AOwner);
  FItem := AStorage.AddItem('', AOwner, GetDefaultValueTypeClass, ATextStored);
  FItem.AddRef;
end;

destructor TdxStorageItemCustomDataBinding.Destroy;
begin
  FItem.Release;
  FItem := nil;
  inherited Destroy;
end;

procedure TdxStorageItemCustomDataBinding.ChangeValueType(AValueTypeClass: TcxValueTypeClass; ATextStored: Boolean);
begin
  if ((AValueTypeClass <> ValueTypeClass) or (ATextStored <> TextStored)) and IsValueTypeSupported(AValueTypeClass) then
  begin
    Item.ChangeValueType(AValueTypeClass, ATextStored);
    Changed;
  end;
end;

function TdxStorageItemCustomDataBinding.GetDataStorage: TdxDataStorage;
begin
  Result := FItem.Owner;
end;

procedure TdxStorageItemCustomDataBinding.DoAssign(Source: TPersistent);
begin
  if IsValueTypeSupported(TdxStorageItemCustomDataBinding(Source).ValueTypeClass) then
  begin
    FItem.Assign(TdxStorageItemCustomDataBinding(Source).Item);
    Changed;
  end;
end;

function TdxStorageItemCustomDataBinding.GetDefaultTextStored: Boolean;
begin
  Result := False;
end;

function TdxStorageItemCustomDataBinding.GetDefaultValueTypeClass: TcxValueTypeClass;
begin
  Result := TcxFloatValueType;
end;

procedure TdxStorageItemCustomDataBinding.InternalSetItem(AItem: TdxStorageItem);
begin
  if AItem <> FItem then
    FItem := AItem;
end;

function TdxStorageItemCustomDataBinding.GetTextStored: Boolean;
begin
  Result := Item.TextStored;
end;

function TdxStorageItemCustomDataBinding.GetValueType: string;
begin
  Result := Item.ValueTypeClass.Caption;
end;

function TdxStorageItemCustomDataBinding.GetValueTypeClass: TcxValueTypeClass;
begin
  Result := Item.ValueTypeClass;
end;

function TdxStorageItemCustomDataBinding.IsValueTypeStored: Boolean;
begin
  Result := ValueTypeClass <> GetDefaultValueTypeClass;
end;

function TdxStorageItemCustomDataBinding.IsValueTypeSupported(AValueTypeClass: TcxValueTypeClass): Boolean;
begin
  Result := True;
end;

procedure TdxStorageItemCustomDataBinding.SetTextStored(AValue: Boolean);
begin
  AValue := AValue and not ValueTypeClass.IsString;
  if AValue <> TextStored then
  begin
    Item.TextStored := AValue;
    Item.ChangeValueType(ValueTypeClass, AValue);
    if AValue = TextStored then
      Changed;
  end;
end;

procedure TdxStorageItemCustomDataBinding.SetValueType(const AValue: string);
begin
  SetValueTypeClass(cxValueTypeClassList.ItemByCaption(AValue));
end;

procedure TdxStorageItemCustomDataBinding.SetValueTypeClass(AValue: TcxValueTypeClass);
begin
  if AValue <> ValueTypeClass then
  begin
    if IsValueTypeSupported(AValue) then
    begin
      Item.ChangeValueType(AValue, TextStored and not AValue.IsString);
      Changed;
    end;
  end;
end;

end.

