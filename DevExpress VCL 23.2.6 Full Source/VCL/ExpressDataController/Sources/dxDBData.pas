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

unit dxDBData;

{$I cxVer.inc}
{$SCOPEDENUMS ON}

interface

uses
  Generics.Defaults, Generics.Collections, Classes, SysUtils, Variants, Types, DB, RTLConsts,
  dxCore, dxCoreClasses, dxTypeHelpers, cxVariants, cxDataStorage, cxDB, cxDBData, dxCustomData;

// this unit for internal use only

type
  TdxDBDataStorage = class;
  TdxDBDataStorageDataSetReader = class;
  TdxDBStorageItemCustomDataBinding = class;

  PdxDBDataRecord = ^TdxDBDataRecord;
  TdxDBDataRecord = packed record 
    Flag: Byte;
    Prior: PdxDBDataRecord;
    Next: PdxDBDataRecord;
    DBRecordIndex: Integer;
    Data: Pointer;
  end;

  { TdxDBDataStorageDataLink }

  TdxDBDataStorageDataLink = class(TcxCustomDataLink)
  private
    FOwner: TdxDBDataStorage;
  protected
    procedure ActiveChanged; override;
    procedure DataSetChanged; override;
    procedure DataSetScrolled(Distance: Integer); override;
    procedure LayoutChanged; override;
    procedure RecordChanged(Field: TField); override;
    procedure UpdateData; override;
  public
    constructor Create(AOwner: TdxDBDataStorage); virtual;

    property Owner: TdxDBDataStorage read FOwner;
  end;

  { TdxDBStorageItem }

  TdxDBStorageItem = class(TdxStorageItem)
  strict private
    FField: TField;
    function GetFieldName: string;
    procedure SetFieldName(const AValue: string);
  protected
    function GetName: string; override;
    procedure SetField(const AValue: TField);
    procedure SetName(const AValue: string); override;
    procedure UpdateFieldValue(ASource: PdxDataRecord); inline;
    procedure UpdateValue(ADest: PdxDataRecord);
  public
    destructor Destroy; override;
    procedure Assign(ASource: TdxStorageItem); override;

    property Field: TField read FField;
    property FieldName: string read GetFieldName write SetFieldName;
  end;

  TdxDataStorageRecordChangedEvent = procedure(ASender: TdxDataStorage; ARecord: PdxDataRecord) of object;

  { TdxDBDataStorage }

  TdxDBDataStorage = class(TdxDataStorage)
  private
    FActiveItems: TdxFastObjectList;
    FDataLink: TdxDBDataStorageDataLink;
    FFieldsItems: TObjectDictionary<TField, TList<TdxDBStorageItem>>;
    FFreeNotificator: TcxFreeNotificator;
    FInternalFocusedRecordIndex: Integer;
    FDirty: Boolean;
    FOnRecordChanged: TdxDataStorageRecordChangedEvent;
    FOnFocusedRecordChanged: TNotifyEvent;
    function GetDataSet: TDataSet;
    function GetDataSource: TDataSource;
    function GetItem(AIndex: Integer): TdxDBStorageItem;
    function GetFocusedRecordIndex: Integer;
    procedure SetDataSource(const AValue: TDataSource);
    procedure SetDirty(AValue: Boolean);
    procedure SetInternalFocusedRecordIndex(const AValue: Integer);
  protected
    function CreateDataLink: TdxDBDataStorageDataLink; virtual;
    function CreateDataSetReader: TdxDBDataStorageDataSetReader; virtual;
    function CreateItem(const AItemLink: TObject): TdxStorageItem; override;
    procedure DataScrolled(ADistance: Integer);
    procedure DoChange; override;
    procedure DoFocusedRecordChanged; virtual;
    procedure DoRecordChanged(ARecord: PdxDataRecord); virtual;
    procedure FreeNotification(AComponent: TComponent); virtual;
    function GetFocusedRecord: PdxDataRecord;
    procedure InitializeItemField(AItem: TdxDBStorageItem; const AFieldName: string);
    procedure InsertNewRecord(AIsAppend: Boolean);
    function IsFieldCompatible(AItem: TdxDBStorageItem; AField: TField): Boolean; virtual;
    function IsUpdateLocked: Boolean; override;
    procedure LoadStorage; virtual;
    procedure UpdateFocusedRecordValues(AField: TField);
    procedure UpdateItem(AItem: TdxDBStorageItem); virtual;
    procedure UpdateItems; virtual;

    property ActiveItems: TdxFastObjectList read FActiveItems;
    property FieldsItems: TObjectDictionary<TField, TList<TdxDBStorageItem>> read FFieldsItems;
    property DataLink: TdxDBDataStorageDataLink read FDataLink;
    property Dirty: Boolean read FDirty write SetDirty;
    property FreeNotificator: TcxFreeNotificator read FFreeNotificator;
    property InternalFocusedRecordIndex: Integer read FInternalFocusedRecordIndex write SetInternalFocusedRecordIndex;
  public
    constructor Create(const AHeaderSize: Integer = 0); override;
    destructor Destroy; override;
    procedure Assign(ASource: TdxDataStorage); override;
    function AddItem(const AFieldName: string; AItemLink: TObject = nil): TdxDBStorageItem; reintroduce;
    procedure CreateAllItems(AMissingItemsOnly: Boolean = False);
    function GetItemByFieldName(const AFieldName: string): TdxDBStorageItem;

    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property DataSet: TDataSet read GetDataSet;
    property Items[AIndex: Integer]: TdxDBStorageItem read GetItem;
    property FocusedRecord: PdxDataRecord read GetFocusedRecord;
    property FocusedRecordIndex: Integer read GetFocusedRecordIndex;
    property OnFocusedRecordChanged: TNotifyEvent read FOnFocusedRecordChanged write FOnFocusedRecordChanged;
    property OnRecordChanged: TdxDataStorageRecordChangedEvent read FOnRecordChanged write FOnRecordChanged;
  end;

  { TdxDBDataStorageDataSetReader }

  TdxDBDataStorageDataSetReader = class
  private
    FDataSet: TDataset;
    FStorage: TdxDBDataStorage;
  public
    constructor Create(AStorage: TdxDBDataStorage);
    destructor Destroy; override;
    procedure LoadAllRecords; virtual;
    procedure UpdateItemValues(AItem: TdxDBStorageItem);

    property Dataset: TDataSet read FDataSet;
    property Storage: TdxDBDataStorage read FStorage;
  end;

  { TdxDBStorageItemCustomDataBinding }

  TdxDBStorageItemCustomDataBinding = class(TdxStorageItemCustomDataBinding)
  private
    FField: TField;
    function GetFieldName: string;
    procedure SetFieldName(const AValue: string);
  protected
    property Field: TField read FField;
    property FieldName: string read GetFieldName write SetFieldName;
  end;

implementation

const
  dxThisUnitName = 'dxDBData';

type
  TDataSetAccess = class(TDataSet);

{ TdxDBDataStorageDataLink }

constructor TdxDBDataStorageDataLink.Create(AOwner: TdxDBDataStorage);
begin
  inherited Create;
  FOwner := AOwner;
end;

procedure TdxDBDataStorageDataLink.ActiveChanged;
begin
  Owner.UpdateItems;
end;

procedure TdxDBDataStorageDataLink.DataSetChanged;
begin
  if DataSet.State = dsInsert then
    Owner.InsertNewRecord(DataSet.Eof)
  else
    Owner.UpdateItems;
end;

procedure TdxDBDataStorageDataLink.DataSetScrolled(Distance: Integer);
begin
  Owner.DataScrolled(Distance);
end;

procedure TdxDBDataStorageDataLink.LayoutChanged;
begin
  DataSetChanged;
end;

procedure TdxDBDataStorageDataLink.RecordChanged(Field: TField);
begin
  Owner.UpdateFocusedRecordValues(Field)
end;

procedure TdxDBDataStorageDataLink.UpdateData;
begin
  Owner.UpdateFocusedRecordValues(nil);
end;

{ TdxDBStorageItem }

destructor TdxDBStorageItem.Destroy;
begin
  if Owner <> nil then
    TdxDBDataStorage(Owner).InitializeItemField(Self, '');
  inherited Destroy;
end;

procedure TdxDBStorageItem.Assign(ASource: TdxStorageItem);
begin
  if ASource is TdxDBStorageItem then
    FieldName := TdxDBStorageItem(ASource).FieldName
  else
    inherited Assign(ASource);
end;

function TdxDBStorageItem.GetName: string;
begin
  Result := GetFieldName;
end;

procedure TdxDBStorageItem.SetField(const AValue: TField);
begin
  if AValue <> FField then
  begin
    FField := AValue;
    if FField <> nil then
      ChangeValueType(GetValueTypeClassByField(FField), IsFieldFormatted(FField, FField.IsBlob))
    else
      Owner.ForEach(FinalizeRecord);
    TdxDBDataStorage(Owner).Changed;
  end;
end;

procedure TdxDBStorageItem.SetName(const AValue: string);
begin
  SetFieldName(AValue);
end;

procedure TdxDBStorageItem.UpdateFieldValue(ASource: PdxDataRecord);
begin
  SetFieldValue(FField, Value[ASource]);
end;

procedure TdxDBStorageItem.UpdateValue(ADest: PdxDataRecord);
begin
  Value[ADest] := GetFieldValue(FField);
  if TextStored then
    DisplayText[ADest] := FField.DisplayText;
end;

function TdxDBStorageItem.GetFieldName: string;
begin
  if FField <> nil then
    Result := FField.FieldName
  else
    Result := inherited GetName;
  inherited SetName(Result);
end;

procedure TdxDBStorageItem.SetFieldName(const AValue: string);
begin
  if AValue <> FieldName then
  begin
    inherited SetName(AValue);
    if Owner <> nil then
      TdxDBDataStorage(Owner).InitializeItemField(Self, AValue);
    if Field = nil then
      ChangeValueType(TcxValueType, False);
    TdxDBDataStorage(Owner).UpdateItem(Self);
  end;
end;

{ TdxDBDataStorage }

constructor TdxDBDataStorage.Create(const AHeaderSize: Integer);
begin
  inherited Create(AHeaderSize + SizeOf(Integer));  
  FInternalFocusedRecordIndex := -1;
  FDataLink := CreateDataLink;
  FFreeNotificator := TcxFreeNotificator.Create(nil);
  FFreeNotificator.OnFreeNotification := FreeNotification;
  FActiveItems := TdxFastObjectList.Create(False);
  FFieldsItems := TObjectDictionary<TField, TList<TdxDBStorageItem>>.Create([doOwnsValues]);
end;

destructor TdxDBDataStorage.Destroy;
begin
  inherited Destroy;
  FreeAndNil(FActiveItems);
  FreeAndNil(FFieldsItems);
  FreeAndNil(FDataLink);
  FreeAndNil(FFreeNotificator);
end;

procedure TdxDBDataStorage.Assign(ASource: TdxDataStorage);
begin
  if ASource is TdxDBDataStorage then
  begin
    BeginUpdate;
    try
      FInternalFocusedRecordIndex := TdxDBDataStorage(ASource).InternalFocusedRecordIndex;
      DataSource := TdxDBDataStorage(ASource).DataSource;
      inherited Assign(ASource);
      FDirty := False;
    finally
      CancelUpdate;
    end;
    Changed;
  end;
end;

function TdxDBDataStorage.AddItem(const AFieldName: string; AItemLink: TObject = nil): TdxDBStorageItem;
begin
  BeginUpdate;
  try
    Result := inherited AddItem(AFieldName, AItemLink, TcxValueType, False) as TdxDBStorageItem;
  finally
    CancelUpdate;
  end;
  UpdateItem(Result);
end;

procedure TdxDBDataStorage.CreateAllItems(AMissingItemsOnly: Boolean = False);
var
  I: Integer;
begin
  if DataSet = nil then Exit;
  BeginUpdate;
  try
    with DataSet do
      for I := 0 to FieldCount - 1 do
        if not AMissingItemsOnly or (GetItemByFieldName(Fields[I].FieldName) = nil) then
          AddItem(Fields[I].FieldName, nil)
  finally
    EndUpdate;
  end;
end;

function TdxDBDataStorage.GetItemByFieldName(const AFieldName: string): TdxDBStorageItem;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to ItemCount - 1 do
    if SameText(Items[I].FieldName, AFieldName) then
      Exit(TdxDBStorageItem(Items[I]));
end;

function TdxDBDataStorage.CreateDataLink: TdxDBDataStorageDataLink;
begin
  Result := TdxDBDataStorageDataLink.Create(Self);
end;

function TdxDBDataStorage.CreateDataSetReader: TdxDBDataStorageDataSetReader;
begin
  Result := TdxDBDataStorageDataSetReader.Create(Self);
end;

function TdxDBDataStorage.CreateItem(const AItemLink: TObject): TdxStorageItem;
begin
  Result := TdxDBStorageItem.Create(Self, AItemLink);
end;

procedure TdxDBDataStorage.DataScrolled(ADistance: Integer);
begin
  InternalFocusedRecordIndex := InternalFocusedRecordIndex + ADistance;
  DoFocusedRecordChanged;
end;

procedure TdxDBDataStorage.DoChange;
begin
  if Dirty then
    Dirty := False
  else
    inherited DoChange;
end;

procedure TdxDBDataStorage.DoFocusedRecordChanged;
begin
  if Assigned(FOnFocusedRecordChanged) then
    OnFocusedRecordChanged(Self);
end;

procedure TdxDBDataStorage.DoRecordChanged(ARecord: PdxDataRecord);
begin
  if Assigned(FOnRecordChanged) then
    OnRecordChanged(Self, ARecord);
end;

procedure TdxDBDataStorage.FreeNotification(AComponent: TComponent);
var
  AItem: TdxStorageItem;
  AList: TList<TdxDBStorageItem>;
begin
  if (AComponent is TField) and FieldsItems.TryGetValue(TField(AComponent), AList) then
  begin
    BeginUpdate;
    try
      for AItem in AList do
      begin
        ActiveItems.Remove(TdxDBStorageItem(AItem));
        TdxDBStorageItem(AItem).SetField(nil);
      end;
      FieldsItems.Remove(TField(AComponent));
    finally
      EndUpdate;
    end;
  end;
end;

function TdxDBDataStorage.GetFocusedRecord: PdxDataRecord;
begin
  Result := nil;
  if (InternalFocusedRecordIndex < 0) or (InternalFocusedRecordIndex >= RecordCount) then
    Exit;
  if (Cursor <> nil) and (PdxDBDataRecord(Cursor).DBRecordIndex = InternalFocusedRecordIndex) then
    Exit(Cursor);
  Result := First;
  while (Result <> nil) and (PdxDBDataRecord(Result).DBRecordIndex <> InternalFocusedRecordIndex) do
    Result := Result.Next;
end;

procedure TdxDBDataStorage.InitializeItemField(AItem: TdxDBStorageItem; const AFieldName: string);
var
  AField: TField;
  AReferenceList: TList<TdxDBStorageItem>;
begin
  AField := nil;
  if DataSet <> nil then
    AField := DataSet.FindField(AFieldName);
  if (AField <> nil) and not IsFieldCompatible(AItem, AField) then
    ErrorFmt('The %s has incompatible field type', [AFieldName]);
  if AField <> AItem.Field then
  begin
    Dirty := True;
    FActiveItems.Remove(AItem);
    if FFieldsItems.TryGetValue(AItem.Field, AReferenceList) then // when some storage items linked to the same field
    begin
      AReferenceList.Remove(AItem);
      if AReferenceList.Count = 0 then
        AItem.Field.RemoveFreeNotification(FreeNotificator);
      FFieldsItems.Remove(AItem.Field);
    end;
    AItem.SetField(AField);
    if AField <> nil then
    begin
      FActiveItems.Add(AItem);
      if not FFieldsItems.TryGetValue(AField, AReferenceList) then
      begin
        AReferenceList := TList<TdxDBStorageItem>.Create;
        FFieldsItems.Add(AField, AReferenceList);
        AField.FreeNotification(FreeNotificator);
      end;
      AReferenceList.Add(AItem);
    end;
  end;
end;

procedure TdxDBDataStorage.InsertNewRecord(AIsAppend: Boolean);
begin
  if AIsAppend then
  begin
    Append;
    InternalFocusedRecordIndex := RecordCount - 1
  end
  else
  begin
    InsertBefore(FocusedRecord);
    ForEach(
      procedure(ARecord: PdxDataRecord)
      begin
        if (ARecord <> Cursor) and (PdxDBDataRecord(ARecord).DBRecordIndex >= InternalFocusedRecordIndex) then
          Inc(PdxDBDataRecord(ARecord).DBRecordIndex);
      end);
  end;
  PdxDBDataRecord(Cursor).DBRecordIndex := InternalFocusedRecordIndex;
  DoRecordChanged(PdxDataRecord(FocusedRecord));
end;

function TdxDBDataStorage.IsFieldCompatible(AItem: TdxDBStorageItem; AField: TField): Boolean;
begin
  Result := True;
end;

function TdxDBDataStorage.IsUpdateLocked: Boolean;
begin
  Result := inherited IsUpdateLocked or ((DataSet <> nil) and DataSet.ControlsDisabled);
end;

procedure TdxDBDataStorage.LoadStorage;
begin
  if Dirty then
    Dirty := False
  else
  begin
    BeginUpdate;
    try
      with CreateDataSetReader do
      try
        LoadAllRecords;
      finally
        Free;
      end;
      Changed;
      DoFocusedRecordChanged;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TdxDBDataStorage.UpdateFocusedRecordValues(AField: TField);
var
  I: Integer;
  AItem: TdxDBStorageItem;
  ARecord: PdxDataRecord;
begin
  ARecord := GetFocusedRecord;
  if ARecord = nil then
    Exit;
  try
    for I := 0 to ActiveItems.Count - 1 do
    begin
      AItem := TdxDBStorageItem(ActiveItems[I]);
      if (AField = nil) or (AItem.Field = AField) then
        AItem.UpdateValue(ARecord);
    end;
  finally
    DoRecordChanged(ARecord);
  end;
end;

procedure TdxDBDataStorage.UpdateItem(AItem: TdxDBStorageItem);
begin
  if IsUpdateLocked or not DataLink.Active then
    Dirty := True
  else
  begin
    BeginUpdate;
    try
      InitializeItemField(AItem, AItem.FieldName);
      if AItem.Field <> nil then
      begin
        if RecordCount > 0 then
        begin
          with CreateDataSetReader do
          try
            UpdateItemValues(AItem);
          finally
            Free;
          end;
        end
        else
         LoadStorage;
        FDirty := False;
      end;
      Changed;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TdxDBDataStorage.UpdateItems;
var
  I: Integer;
begin
  BeginUpdate;
  try
    FInternalFocusedRecordIndex := -1;
    ClearRecords;

    for I := 0 to ItemCount - 1 do
      InitializeItemField(Items[I], Items[I].FieldName);
    Dirty := True;
    Changed;
  finally
    EndUpdate;
  end;
end;

function TdxDBDataStorage.GetDataSet: TDataSet;
begin
  if DataSource <> nil then
    Result := DataSource.DataSet
  else
    Result := nil;
end;

function TdxDBDataStorage.GetDataSource: TDataSource;
begin
  if DataLink = nil then
    Result := nil
  else
    Result := DataLink.DataSource;
end;

function TdxDBDataStorage.GetItem(AIndex: Integer): TdxDBStorageItem;
begin
  Result := TdxDBStorageItem(inherited Items[AIndex]);
end;

function TdxDBDataStorage.GetFocusedRecordIndex: Integer;
var
  ARecord: PdxDataRecord;
begin
  Result := -1;
  ARecord := GetFocusedRecord;
  if ARecord <> nil then
    Result := ARecord.Index;
end;

procedure TdxDBDataStorage.SetDataSource(const AValue: TDataSource);
begin
  DataLink.DataSource := AValue;
end;

procedure TdxDBDataStorage.SetDirty(AValue: Boolean);
begin
  AValue := AValue or IsUpdateLocked;
  if AValue <> FDirty then
  begin
    FDirty := AValue;
    if not Dirty then
      LoadStorage;
  end;
end;

procedure TdxDBDataStorage.SetInternalFocusedRecordIndex(const AValue: Integer);
begin
  FInternalFocusedRecordIndex := AValue;
end;



{ TdxDBStorageItemCustomDataBinding }

function TdxDBStorageItemCustomDataBinding.GetFieldName: string;
begin
  Result := (Item as TdxDBStorageItem).FieldName
end;

procedure TdxDBStorageItemCustomDataBinding.SetFieldName(const AValue: string);
begin
  (Item as TdxDBStorageItem).FieldName := AValue;
end;

{ TdxDBDataStorageDataSetReader }

constructor TdxDBDataStorageDataSetReader.Create(AStorage: TdxDBDataStorage);
begin
  FStorage := AStorage;
  FDataSet := FStorage.DataSet;
  FStorage.DataLink.IsLoading := True;
end;

destructor TdxDBDataStorageDataSetReader.Destroy;
begin
  FStorage.DataLink.IsLoading := False;
  inherited Destroy;
end;

procedure TdxDBDataStorageDataSetReader.LoadAllRecords;
var
  I, AIndex: Integer;
  ARecord: PdxDataRecord;
  ABookmark: TcxDataSetBookmark;
  AItems: TdxFastList;
begin
  Storage.ClearRecords;
  Storage.InternalFocusedRecordIndex := -1;
  AItems := Storage.ActiveItems;
  if (DataSet = nil) or not Storage.DataLink.Active or (AItems.Count = 0) then
    Exit;
  DataSet.DisableControls;
  try
    ABookmark := cxDataSetCreateBookMark(DataSet);
    DataSet.First;
    AIndex := 0;
    while not Dataset.Eof do
    begin
      ARecord := FStorage.Append;
      PdxDBDataRecord(ARecord).DBRecordIndex := AIndex;
      if Dataset.CompareBookmarks(ABookmark.SaveBookmark, DataSet.Bookmark) = 0 then
        FStorage.InternalFocusedRecordIndex := AIndex;
      for I := 0 to AItems.Count - 1 do
        TdxDBStorageItem(AItems[I]).UpdateValue(ARecord);
      DataSet.Next;
      Inc(AIndex);
    end;
    cxDataSetRestoreBookmark(DataSet, ABookmark);
  finally
    DataSet.EnableControls;
  end;
end;

procedure TdxDBDataStorageDataSetReader.UpdateItemValues(AItem: TdxDBStorageItem);
var
  ARecord: PdxDataRecord;
  ABookmark: TcxDataSetBookmark;
begin
  ABookmark := cxDataSetCreateBookMark(DataSet);
  DataSet.DisableControls;
  try
    DataSet.First;
    ARecord := Storage.First;
    while not Dataset.Eof do
    begin
      AItem.UpdateValue(ARecord);
      DataSet.Next;
      ARecord := ARecord.Next;
    end;
  finally
    DataSet.EnableControls;
  end;
  cxDataSetRestoreBookmark(DataSet, ABookmark);
end;


end.

