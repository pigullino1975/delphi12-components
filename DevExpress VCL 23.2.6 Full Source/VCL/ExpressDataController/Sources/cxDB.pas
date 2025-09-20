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

unit cxDB;

{$I cxVer.inc}

interface

uses
  Generics.Defaults, Generics.Collections, Windows,
  Classes, SysUtils, Variants, DB, dxCore, dxCoreClasses, cxDataUtils;

type
  TcxCustomDataLink = class;
  TcxDBFieldList = TList<TField>;

  { TcxDBAdapterList }

  TDataSetClass = class of TDataSet;

  TcxDBAdapterItem = class
  private
    FDataSetClass: TDataSetClass;
  public
    constructor Create(ADataSetClass: TDataSetClass); virtual;
    property DataSetClass: TDataSetClass read FDataSetClass;
  end;

  TcxDBAdapterItemClass = class of TcxDBAdapterItem;

  TcxDBAdapterList = class
  private
    FItems: TList;
    function GetItem(Index: Integer): TcxDBAdapterItem;
    function GetItemCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function FindAdapter(ADataSetClass: TDataSetClass; var AIndex: Integer): Boolean; virtual;
    procedure RegisterAdapter(ADataSetClass: TDataSetClass; AItemClass: TcxDBAdapterItemClass); virtual;
    procedure UnregisterAdapter(ADataSetClass: TDataSetClass; AItemClass: TcxDBAdapterItemClass); virtual;
    property ItemCount: Integer read GetItemCount;
    property Items[Index: Integer]: TcxDBAdapterItem read GetItem; default;
  end;

  { TcxCustomDataLink }

  TcxForEachDataLinkProc = reference to procedure(ADataLink: TcxCustomDataLink);

  TcxCustomDataLink = class(TcxDoublyLinkedObject)  
  private
    FBufferCount: Integer;
    FDataLink: TDataLink;
    FDataSetLink: TObject;
    FDataSourceLink: TObject;
    FReadOnly: Boolean;
    FUpdating: Boolean;
    FVisualControl: Boolean;
    function GetActive: Boolean;
    function GetActiveRecord: Integer; inline;
    function GetBOF: Boolean;
    function GetBufferCount: Integer;
    function GetDataSet: TDataSet; inline;
    function GetDataSource: TDataSource; inline;
    function GetDataSourceFixed: Boolean;
    function GetEditing: Boolean;
    function GetEOF: Boolean;
    function GetGridMode: Boolean;
    function GetIsLoading: Boolean;
    function GetIsLocate: Boolean;
    function GetRecordCount: Integer; inline;
    procedure SetActiveRecord(const AValue: Integer);
    procedure SetBufferCount(AValue: Integer);
    procedure SetDataSetLink(AValue: TObject);
    procedure SetDataSource(const AValue: TDataSource);
    procedure SetIsLoading(const AValue: Boolean);
    procedure SetIsLocate(const AValue: Boolean);
    procedure SetReadOnly(const AValue: Boolean);
    procedure SetUpdating(const AValue: Boolean);
    procedure SetVisualControl(AValue: Boolean);
  protected
    procedure ActiveChanged; virtual;
    procedure DataSetChanged; virtual;
    procedure DataSetScrolled(Distance: Integer); virtual;
    procedure EditingChanged; virtual;
    function FocusControl(Field: TField): Boolean; virtual;
    procedure LayoutChanged; virtual;
    procedure RecordChanged(Field: TField); virtual;
    procedure UpdateData; virtual;
    class function GetDataLinksByDataSet(ADataSet: TDataSet): IEnumerable; static;

    property DataLink: TDataLink read FDataLink;
    property GridMode: Boolean read GetGridMode;
    property IsLoading: Boolean read GetIsLoading write SetIsLoading;
    property IsLocate: Boolean read GetIsLocate write SetIsLocate;
    property VisualControl: Boolean read FVisualControl write SetVisualControl;
  public
    constructor Create;
    destructor Destroy; override;
    function Edit: Boolean;
    function ExecuteAction(Action: TBasicAction): Boolean; virtual;
    function UpdateAction(Action: TBasicAction): Boolean; virtual;
    procedure UpdateRecord;

    property Active: Boolean read GetActive;
    property ActiveRecord: Integer read GetActiveRecord write SetActiveRecord;
    property BOF: Boolean read GetBOF;
    property BufferCount: Integer read GetBufferCount write SetBufferCount;
    property DataSet: TDataSet read GetDataSet;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property DataSourceFixed: Boolean read GetDataSourceFixed;
    property Editing: Boolean read GetEditing;
    property Eof: Boolean read GetEOF;
    property ReadOnly: Boolean read FReadOnly write SetReadOnly;
    property RecordCount: Integer read GetRecordCount;
    property Updating: Boolean read FUpdating write SetUpdating;
  end;

  { TcxCustomFieldDataLink }

  TcxCustomDBDataBinding = class;

  TcxCustomFieldDataLink = class(TDataLink)
  private
    FField: TField;
    FFieldName: string;
    FEditing: Boolean;
    FModified: Boolean;
    function GetCanModify: Boolean;
    function GetDataComponent: TComponent;
    procedure SetEditing(Value: Boolean);
    procedure SetField(Value: TField);
    procedure SetFieldName(const Value: string);
    procedure UpdateField;
  protected
    FDataBinding: TcxCustomDBDataBinding;
    procedure ActiveChanged; override;
    procedure DataEvent(Event: TDataEvent; Info: TdxNativeInt); override;
    procedure EditingChanged; override;
    procedure LayoutChanged; override;
    procedure RecordChanged(Field: TField); override;
    procedure UpdateData; override;
    procedure DataComponentChanged; virtual;
    procedure UpdateRightToLeft; virtual;
    procedure VisualControlChanged; virtual;
    property DataBinding: TcxCustomDBDataBinding read FDataBinding;
    property DataComponent: TComponent read GetDataComponent;
  public
    constructor Create(ADataBinding: TcxCustomDBDataBinding); virtual;
    function Edit: Boolean;
    procedure Modified;
    procedure Reset;
    property CanModify: Boolean read GetCanModify;
    property Editing: Boolean read FEditing;
    property Field: TField read FField;
    property FieldName: string read FFieldName write SetFieldName;
  end;

  TcxCustomFieldDataLinkClass = class of TcxCustomFieldDataLink;

  { TcxCustomDBDataBinding }

  TcxCustomDBDataBinding = class(TcxCustomDataBinding)
  private
    FRefreshCount: Integer;
    function GetDataField: string;
    function GetDataSource: TDataSource;
    function GetField: TField;
    procedure InternalDataChange;
    procedure SetDataField(const Value: string);
    procedure SetDataSource(Value: TDataSource);
  protected
    FDataLink: TcxCustomFieldDataLink;
    function GetModified: Boolean; override;
    function GetReadOnly: Boolean; override;
    procedure SetReadOnly(Value: Boolean); override;
    procedure VisualControlChanged; override;
    procedure DisableRefresh;
    procedure EnableRefresh;
    function GetDataLinkClass: TcxCustomFieldDataLinkClass; virtual;
    function IsRefreshDisabled: Boolean;
  public
    constructor Create(AOwner, ADataComponent: TComponent); override;
    destructor Destroy; override;
    function CanModify: Boolean; override;
    function ExecuteAction(Action: TBasicAction): Boolean; override;
    function GetStoredValue(AValueSource: TcxDataEditValueSource; AFocused: Boolean): Variant; override;
    function IsControlReadOnly: Boolean; override;
    function IsDataSourceLive: Boolean; override;
    function IsDataStorage: Boolean; override;
    procedure Reset; override;
    function SetEditMode: Boolean; override;
    procedure SetStoredValue(AValueSource: TcxDataEditValueSource; const Value: Variant); override;
    function UpdateAction(Action: TBasicAction): Boolean; override;
    procedure UpdateDataSource; override;
    property Field: TField read GetField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property DataField: string read GetDataField write SetDataField;
    property DataLink: TcxCustomFieldDataLink read FDataLink;
  end;

  TcxDBDataBinding = class(TcxCustomDBDataBinding)
  published
    property DataSource;
    property DataField;
  end;

function CanModifyLookupField(AField: TField): Boolean;
procedure CheckFilterFieldName(var AFieldName: string);
function GetDataSetValues(ADataSet: TDataSet; AFields: TList): Variant;
function GetFilterFieldName(AField: TField; AIgnoreOrigin: Boolean): string;
function IsDataAvailable(AField: TField): Boolean;
function IsDefaultFields(ADataSet: TDataSet): Boolean;
function IsEqualFieldNames(const AFieldName1, AFieldName2: string): Boolean;
function IsFieldCanModify(AField: TField; AIsValueSource: Boolean): Boolean;
function IsFieldFormatted(AField: TField; AIsTextEdit: Boolean): Boolean;
function IsMultipleFieldNames(const AFieldNames: string): Boolean;
function IsSimpleCurrencyField(AField: TField): Boolean;
function GetFieldNamesCount(const AFieldNames: string): Integer;
procedure GetFieldNames(const AFieldNames: string; AList: TStrings);
function GetFieldValue(AField: TField): Variant;
procedure SetDataSetValues(ADataSet: TDataSet; AFields: TList; const AValues: Variant);
procedure SetFieldValue(AField: TField; const AValue: Variant);
function FindField(AFields: TFields; const AName: string): TField; inline;

implementation

uses
  cxVariants;

const
  dxThisUnitName = 'cxDB';

type
  TDataSetAccess = class(TDataSet);
  TDataLinkAccess = class(TDataLink);
  TcxLinkedListAccess = class(TcxDoublyLinkedObjectList);
  TcxDataLink = class;

  { TcxDataSetLink }

  TcxDataSetLink = class
  protected
    DataSet: TDataSet;
    LoadingRefCount: Integer;
    LocateRefCount: Integer;
    RefCount: Integer;
  public
    constructor Create(ADataSet: TDataSet);
  end;

  { TcxDataSourceLink }

  TcxDataSourceLink = class
  strict private type
    TForEachDBDataLinkProc = reference to procedure(var ADataLink: TcxDataLink);
  protected
    DataSource: TDataSource;
    DataSetLink: TcxDataSetLink;
    DataLinks: TcxDoublyLinkedObjectList;
    RealDataLinks: array[Boolean, Boolean] of TcxDataLink;
    RefCount: Integer;
    procedure BufferCountChanged(ADataLink: TcxCustomDataLink; APrevValue, AValue: Integer);
    function DataLinkNeeded(ABufferCount: Integer; AVisualControl: Boolean): TcxDataLink;
    procedure DataSetChanged(ADataSet: TDataSet);
    procedure DataSourceChanged(ADataSource: TDataSource);
    procedure ForEach(AProc: TcxForEachDataLinkProc);
    procedure ForEachDBDataLink(AProc: TForEachDBDataLinkProc);
    procedure FinalizeDataLink(ADataLink: TcxCustomDataLink);
    procedure InitializeDataLink(ADataLink: TcxCustomDataLink);
  public
    constructor Create(ADataSource: TDataSource);
    destructor Destroy; override;
    function Add(ADataLink: TcxCustomDataLink): Integer;
    function Remove(ADataLink: TcxCustomDataLink): Integer; virtual;
    procedure SetDataSetLink(AValue: TcxDataSetLink);
  end;

  { TcxEmptyDataSourceLink }

  TcxEmptyDataSourceLink = class(TcxDataSourceLink)
  public
    constructor Create;
    function Remove(ADataLink: TcxCustomDataLink): Integer; override;
  end;

  { TcxDataLink }

  TcxDataLink = class(TDataLink)
  strict private
    FReferenceCount: Integer;
    FOwner: TcxDataSourceLink;
    FLayoutChangedFlag: Boolean;
    function GetIsLoading: Boolean; inline;
    function GetIsLocate: Boolean; inline;
    procedure SetIsLoading(AValue: Boolean); inline;
    procedure SetIsLocate(AValue: Boolean); inline;
  protected
    class procedure AddReference(ADataLink: TcxDataLink); static;
    class procedure Release(ADataLink: TcxDataLink); static;

    procedure ActiveChanged; override;
    procedure DataEvent(Event: TDataEvent; Info: TdxNativeInt); override;
    procedure DataSetChanged; override;
    procedure DataSetScrolled(Distance: Integer); override;
    procedure EditingChanged; override;
    procedure FocusControl(Field: TFieldRef); override;
    procedure LayoutChanged; override;
    procedure RecordChanged(Field: TField); override;
    procedure UpdateData; override;
    procedure UpdateProperties(ADataLink: TcxCustomDataLink);

    property ReferenceCount: Integer read FReferenceCount;
  public
    constructor Create(AOwner: TcxDataSourceLink; ABufferCount: Integer; AVisualControl: Boolean);
    procedure ForEach(AProc: TcxForEachDataLinkProc);
    procedure ValidateBufferCount;

    property IsLoading: Boolean read GetIsLoading write SetIsLoading;
    property IsLocate: Boolean read GetIsLocate write SetIsLocate;
    property Owner: TcxDataSourceLink read FOwner;
  end;

  { TcxDataLinksController }

  TcxDataLinksController = class sealed
  private type

    TInternalController = class
    private
      FFreeNotificator: TcxFreeNotificator;
    protected
      DataSets: TObjectDictionary<TDataSet, TcxDataSetLink>;
      DataSources: TObjectDictionary<TDataSource, TcxDataSourceLink>;
      EmptyDataSet: TcxDataSetLink;
      EmptyDataSource: TcxDataSourceLink;
      procedure FreeNotificationHandler(Sender: TComponent);
    public
      constructor Create;
      destructor Destroy; override;
      procedure Add(ADataLink: TcxCustomDataLink);
      function AddOrGetDataSetLink(ADataSet: TDataSet): TcxDataSetLink;
      function AddOrGetDataSourceLink(ADataSource: TDataSource): TcxDataSourceLink;
      procedure ChangeDataSource(ADataLink: TcxCustomDataLink; const AValue: TDataSource);
      procedure Remove(ADataLink: TcxCustomDataLink);
      procedure RemoveDataSet(var ADataSetLink: TcxDataSetLink);
      procedure RemoveDataSource(var ADataSourceLink: TcxDataSourceLink);
    end;

  private class var
    IsDestroying: Boolean;
    FDataLinksController: TInternalController;
  protected
    class function Reset: Boolean;
    class destructor Destroy;
  public
    class procedure Add(ADataLink: TcxCustomDataLink);
    class function AddOrGetDataSetLink(ADataSet: TDataSet): TcxDataSetLink;
    class procedure ChangeDataSource(ADataLink: TcxCustomDataLink; const AValue: TDataSource);
    class procedure Remove(ADataLink: TcxCustomDataLink);
    class procedure RemoveDataSet(var ADataSetLink: TcxDataSetLink);
  end;

  { TcxCustomDataLinkEnumerator }

  TcxCustomDataLinkEnumerator = class(TInterfacedObject, IEnumerable)
  private type

    TEnumerator = class (TInterfacedObject, IEnumerator)
    private
      FOwner: TcxCustomDataLinkEnumerator;
      FEnumerator: TEnumerator<TcxDataSourceLink>;
      FDataSourceLink: TcxDataSourceLink;
      FDataLink: TcxCustomDataLink;
    protected
      function GetCurrent: TObject;
      function MoveNext: Boolean;
      procedure Reset;
    public
      constructor Create(AOwner: TcxCustomDataLinkEnumerator);
      destructor Destroy; override;
    end;

  private
    FDataSet: TDataSet;
  protected
    function GetDataSourceLinks: TList<TcxDataSourceLink>;
    function GetEnumerator: IEnumerator;
  public
    constructor Create(ADataSet: TDataSet);
  end;

function CanModifyLookupField(AField: TField): Boolean;
var
  AMasterFields: TcxDBFieldList;
  I: Integer;
begin
  Result := False;
  if Assigned(AField.DataSet) then
  begin
    AMasterFields := TcxDBFieldList.Create;
    try
      AField.DataSet.GetFieldList(AMasterFields, AField.KeyFields);
      Result := AMasterFields.Count > 0;
      for I := 0 to AMasterFields.Count - 1 do
        Result := Result and TField(AMasterFields[I]).CanModify;
    finally
      AMasterFields.Free;
    end;
  end;
end;

procedure CheckFilterFieldName(var AFieldName: string);
begin
  if not IsValidIdent(AFieldName) then
    AFieldName := '[' + AFieldName + ']';
end;

function GetDataSetValues(ADataSet: TDataSet; AFields: TList): Variant;
var
  I: Integer;
begin
  if AFields.Count > 0 then
  begin
    if AFields.Count > 1 then
    begin
      Result := VarArrayCreate([0, AFields.Count - 1], varVariant);
      for I := 0 to AFields.Count - 1 do
        Result[I] := TField(AFields[I]).Value;
    end
    else
      Result := TField(AFields[0]).Value;
  end
  else
    Result := Null;
end;

function GetFilterFieldName(AField: TField; AIgnoreOrigin: Boolean): string;
begin
  Result := '';
  if Assigned(AField) then
  begin
    if not AIgnoreOrigin then
      Result := AField.Origin;
    if Result = '' then
    begin
      Result := AField.FieldName;
      CheckFilterFieldName(Result);
    end;
  end;
end;

function IsDataAvailable(AField: TField): Boolean;
begin
  Result := (AField <> nil) and (AField.DataSet <> nil) and
    (AField.DataSet.State <> dsInactive);
end;

function IsDefaultFields(ADataSet: TDataSet): Boolean;
begin
  Result := (TDataSetAccess(ADataSet).FieldOptions.AutoCreateMode <> acExclusive) or not (lcPersistent in ADataSet.Fields.LifeCycles);
end;

function IsEqualFieldNames(const AFieldName1, AFieldName2: string): Boolean;
begin
  Result := AnsiUpperCase(AFieldName1) = AnsiUpperCase(AFieldName2);
end;

function IsFieldCanModify(AField: TField; AIsValueSource: Boolean): Boolean;
begin
  Result := AField.CanModify and
    (AIsValueSource or not (AField.DataType in ftNonTextTypes) or Assigned(AField.OnSetText));
end;

function IsFieldFormatted(AField: TField; AIsTextEdit: Boolean): Boolean;
begin
  if AField = nil then
    Exit(False);
  Result := Assigned(AField.OnGetText) or (AField.EditMask <> '');
  if not Result then
  begin
    if AField.DataType in ftNonTextTypes  then
      Result := AIsTextEdit // Field.DisplayText!
    else
      if AField is TBooleanField then
        Result := AIsTextEdit // TODO: compare DisplayValues
      else
        if AField is TNumericField then
        begin
          Result := (TNumericField(AField).DisplayFormat <> '') or (TNumericField(AField).EditFormat <> '');
          if not Result then
          begin
            if AField is TFloatField then
              Result := TFloatField(AField).Currency
            else
              if AField is TBCDField then
                Result := TBCDField(AField).Currency
              else
                if AField is TFMTBCDField then
                  Result := TFMTBCDField(AField).Currency
          end;
        end
        else
          if AField is TDateTimeField then
            Result := TDateTimeField(AField).DisplayFormat <> ''
          else
            if AField is TAggregateField then
              Result := (TAggregateField(AField).DisplayFormat <> '') or TAggregateField(AField).Currency
            else
              if AField is TSQLTimeStampField then
                Result := TSQLTimeStampField(AField).DisplayFormat <> '';
  end;
end;

function IsMultipleFieldNames(const AFieldNames: string): Boolean;
var
  APos: Integer;
begin
  APos := 1;
{$WARNINGS OFF}
  ExtractFieldName(AFieldNames, APos);
{$WARNINGS ON}
  Result := APos <= Length(AFieldNames);
end;

function IsSimpleCurrencyField(AField: TField): Boolean;
begin
  Result := False;
  if AField is TNumericField then
  begin
    if AField is TFloatField then
      Result := TFloatField(AField).Currency
    else
    begin
      if AField is TBCDField then
        Result := TBCDField(AField).Currency
      else
        if AField is TFMTBCDField then
          Result := TFMTBCDField(AField).Currency;
    end;
    if Result then
    begin
      if (TNumericField(AField).DisplayFormat <> '') or Assigned(AField.OnGetText) then
        Result := False;
    end;
  end;
end;

function GetFieldNamesCount(const AFieldNames: string): Integer;
var
  APos: Integer;
begin
  Result := 0; // TODO: use GetFieldNames?
  APos := 1;
  while APos <= Length(AFieldNames) do
  begin
    Inc(Result);
  {$WARNINGS OFF}
    ExtractFieldName(AFieldNames, APos);
  {$WARNINGS ON}
  end;
end;

procedure GetFieldNames(const AFieldNames: string; AList: TStrings);
var
  APos: Integer;
begin
  AList.Clear;
  APos := 1;
  while APos <= Length(AFieldNames) do
  {$WARNINGS OFF}
    AList.Add(ExtractFieldName(AFieldNames, APos))
  {$WARNINGS ON}
end;

function GetFieldValue(AField: TField): Variant;
begin
  if AField is TAggregateField then // bug in Delphi (IsNull = True!)
    Result := AField.Value
  else
    if AField.IsNull then
      Result := Null
    else
      Result := AField.Value;
end;

procedure SetDataSetValues(ADataSet: TDataSet; AFields: TList;
  const AValues: Variant);
var
  I: Integer;
begin
  if AFields.Count > 1 then
    for I := 0 to AFields.Count - 1 do
      TField(AFields.List[I]).Value := AValues[I]
  else
    if AFields.Count <> 0 then
      TField(AFields.List[0]).Value := AValues;
end;

procedure SetFieldValue(AField: TField; const AValue: Variant);
begin
  if (AField is TDateTimeField) and (VarType(AValue) = varDouble) then // bug in Delphi
    TDateTimeField(AField).Value := AValue
  else
    AField.Value := AValue;
end;

function FindField(AFields: TFields; const AName: string): TField;
{$IFDEF VER300}  
var
  I: Integer;
{$ENDIF}
begin
{$IFDEF VER300}
  for I := 0 to AFields.Count - 1 do
  begin
    Result := AFields[I];
    if AnsiCompareText(Result.FieldName, AName) = 0 then
      Exit;
  end;
  Result := nil;
{$ELSE}
  Result := AFields.FindField(AName);
{$ENDIF}
end;

{ TcxDBAdapterItem }

constructor TcxDBAdapterItem.Create(ADataSetClass: TDataSetClass);
begin
  inherited Create;
  FDataSetClass := ADataSetClass;
end;

{ TcxDBAdapterList }

constructor TcxDBAdapterList.Create;
begin
  inherited Create;
  FItems := TList.Create;
end;

destructor TcxDBAdapterList.Destroy;
begin
  Clear;
  FItems.Free;
  FItems := nil;
  inherited Destroy;
end;

procedure TcxDBAdapterList.Clear;
var
  I: Integer;
begin
  for I := 0 to FItems.Count - 1 do
    TObject(FItems[I]).Free;
  FItems.Clear;
end;

function TcxDBAdapterList.FindAdapter(ADataSetClass: TDataSetClass;
  var AIndex: Integer): Boolean;
var
  I: Integer;
  AItem: TcxDBAdapterItem;
begin
  Result := False;
  for I := FItems.Count - 1 downto 0 do
  begin
    AItem := TcxDBAdapterItem(FItems.List[I]);
    if ADataSetClass.InheritsFrom(AItem.DataSetClass) then
    begin
      AIndex := I;
      Exit(True);
    end
    else
      if AItem.DataSetClass.InheritsFrom(ADataSetClass) then
        AIndex := I;
  end;
end;

procedure TcxDBAdapterList.RegisterAdapter(ADataSetClass: TDataSetClass;
  AItemClass: TcxDBAdapterItemClass);
var
  AIndex: Integer;
begin
  AIndex := -1;
  if FindAdapter(ADataSetClass, AIndex) then
    FItems.Insert(AIndex + 1, AItemClass.Create(ADataSetClass))
  else
    if AIndex <> -1 then
      FItems.Insert(AIndex, AItemClass.Create(ADataSetClass))
    else
      FItems.Add(AItemClass.Create(ADataSetClass));
end;

procedure TcxDBAdapterList.UnregisterAdapter(ADataSetClass: TDataSetClass;
  AItemClass: TcxDBAdapterItemClass);
var
  I: Integer;
  AItem: TcxDBAdapterItem;
begin
  for I := FItems.Count - 1 downto 0 do
  begin
    AItem := TcxDBAdapterItem(FItems.List[I]);
    if (AItem.DataSetClass = ADataSetClass) and (AItem.ClassType = AItemClass) then
    begin
      AItem.Free;
      FItems.Delete(I);
    end;
  end;
end;

function TcxDBAdapterList.GetItem(Index: Integer): TcxDBAdapterItem;
begin
  Result := TcxDBAdapterItem(FItems[Index]);
end;

function TcxDBAdapterList.GetItemCount: Integer;
begin
  Result := FItems.Count;
end;

{ TcxDataSetLink}

constructor TcxDataSetLink.Create(ADataSet: TDataSet);
begin
  DataSet := ADataSet;
end;

{ TcxDataSourceLink }

constructor TcxDataSourceLink.Create(ADataSource: TDataSource);
begin
  DataSource := ADataSource;
  DataLinks := TcxDoublyLinkedObjectList.Create;
end;

destructor TcxDataSourceLink.Destroy;
begin
  ForEachDBDataLink(
    procedure(var ALink: TcxDataLink)
    begin
      FreeAndNil(ALink);
    end);
  SetDataSetLink(nil);
  DataLinks.Free;
  inherited Destroy;
end;

function TcxDataSourceLink.Add(ADataLink: TcxCustomDataLink): Integer;
begin
  TcxLinkedListAccess(DataLinks).DoAdd(ADataLink);
  ADataLink.FDataSourceLink := Self;
  ADataLink.SetDataSetLink(DataSetLink);
  InitializeDataLink(ADataLink);
  Inc(RefCount);
  Result := RefCount;
end;

function TcxDataSourceLink.Remove(ADataLink: TcxCustomDataLink): Integer;
begin
  DataLinks.Extract(ADataLink);
  Dec(RefCount);
  FinalizeDataLink(ADataLink);
  Result := RefCount;
end;

procedure TcxDataSourceLink.SetDataSetLink(AValue: TcxDataSetLink);
begin
  TcxDataLinksController.RemoveDataSet(DataSetLink);
  DataSetLink := AValue;
  if DataSetLink <> nil then
    Inc(DataSetLink.RefCount);
  ForEach(
    procedure(ADataLink: TcxCustomDataLink)
    begin
      ADataLink.SetDataSetLink(DataSetLink);
    end);
end;

procedure TcxDataSourceLink.BufferCountChanged(ADataLink: TcxCustomDataLink; APrevValue, AValue: Integer);
begin
  if APrevValue = AValue then   
    Exit;
  if (AValue > 1) and (APrevValue > 1) then
    TcxDataLink(ADataLink.DataLink).ValidateBufferCount
  else
    InitializeDataLink(ADataLink);
end;

function TcxDataSourceLink.DataLinkNeeded(ABufferCount: Integer; AVisualControl: Boolean): TcxDataLink;
begin
  if RealDataLinks[ABufferCount > 1, AVisualControl] = nil then
    RealDataLinks[ABufferCount > 1, AVisualControl] := TcxDataLink.Create(Self, ABufferCount, AVisualControl);
  Result := RealDataLinks[ABufferCount > 1, AVisualControl];
  TcxDataLink.AddReference(Result);
end;

procedure TcxDataSourceLink.DataSetChanged(ADataSet: TDataSet);
begin
  SetDataSetLink(TcxDataLinksController.AddOrGetDataSetLink(ADataSet));
  ForEach(
    procedure(ADataLink: TcxCustomDataLink)
    begin
      ADataLink.SetDataSetLink(DataSetLink);
    end)
end;

procedure TcxDataSourceLink.DataSourceChanged(ADataSource: TDataSource);
var
  ADataLink, ANextDataLink: TcxDoublyLinkedObject;
begin
  ADataLink := DataLinks.First;
  while ADataLink <> nil do
  begin
    ANextDataLink := ADataLink.Next;
    TcxDataLinksController.ChangeDataSource(TcxCustomDataLink(ADataLink), ADataSource);
    ADataLink := ANextDataLink;
  end;
end;

procedure TcxDataSourceLink.ForEach(AProc: TcxForEachDataLinkProc);
var
  AItem, APrev: TcxDoublyLinkedObject;
begin
  AItem := DataLinks.Last;
  while AItem <> nil do
  begin
    APrev := AItem.Prev;
    AProc(TcxCustomDataLink(AItem));
    AItem := APrev;
  end;
end;

procedure TcxDataSourceLink.ForEachDBDataLink(AProc: TForEachDBDataLinkProc);
var
  AGridMode, AVisualControl: Boolean;
begin
  for AGridMode := False to True do
    for AVisualControl := False to True do
      if RealDataLinks[AGridMode, AVisualControl] <> nil then
        AProc(RealDataLinks[AGridMode, AVisualControl])
end;

procedure TcxDataSourceLink.FinalizeDataLink(ADataLink: TcxCustomDataLink);
begin
  if ADataLink.FDataLink = nil then
    Exit;
  try
    TcxDataLink.Release(TcxDataLink(ADataLink.FDataLink));
  finally
    ADataLink.FDataLink := nil;
    ADataLink.SetDataSetLink(nil);
  end;
end;

procedure TcxDataSourceLink.InitializeDataLink(ADataLink: TcxCustomDataLink);
var
  AHasData: Boolean;
  ALink: TcxDataLink;
begin
  AHasData := (ADataLink.DataLink <> nil) and (ADataLink.DataSource <> DataSource);
  if (ADataLink.FDataLink <> nil) and (TcxDataLink(ADataLink.FDataLink).ReferenceCount = 1) and
    (RealDataLinks[ADataLink.GridMode, ADataLink.VisualControl] = nil) then
  begin
    RealDataLinks[ADataLink.DataLink.BufferCount > 1, TcxDataLink(ADataLink.DataLink).VisualControl] := nil;
    RealDataLinks[ADataLink.GridMode, ADataLink.VisualControl] := TcxDataLink(ADataLink.DataLink);
    TcxDataLink(ADataLink.DataLink).UpdateProperties(ADataLink);
    Exit;
  end
  else
  begin
    TcxDataLink.Release(TcxDataLink(ADataLink.FDataLink));
    ALink := DataLinkNeeded(ADataLink.FBufferCount, ADataLink.VisualControl);
  end;
  if AHasData then
  begin
    ALink.DataSource := DataSource;
    ADataLink.FDataLink := ALink;
  end
  else
  begin
    ADataLink.FDataLink := ALink;
    ALink.DataSource := DataSource
  end
end;

{ TcxDataLink }

constructor TcxDataLink.Create(AOwner: TcxDataSourceLink; ABufferCount: Integer; AVisualControl: Boolean);
begin
  FOwner := AOwner;
  VisualControl := AVisualControl;
  BufferCount := ABufferCount;
end;

procedure TcxDataLink.UpdateProperties(ADataLink: TcxCustomDataLink);
begin
  VisualControl := ADataLink.VisualControl;
  BufferCount := ADataLink.BufferCount;
  ValidateBufferCount;
end;

class procedure TcxDataLink.AddReference(ADataLink: TcxDataLink);
begin
  if ADataLink <> nil then
    Inc(ADataLink.FReferenceCount);
end;

class procedure TcxDataLink.Release(ADataLink: TcxDataLink);
begin
  if ADataLink <> nil then
    Dec(ADataLink.FReferenceCount);
end;

procedure TcxDataLink.ForEach(AProc: TcxForEachDataLinkProc);
begin
  Owner.ForEach(procedure(ADataLink: TcxCustomDataLink)
  begin
    if ADataLink.DataLink = Self then
      AProc(ADataLink);
  end);
end;

procedure TcxDataLink.ValidateBufferCount;
var
  ABufferCount: Integer;
begin
  ABufferCount := 1;
  ForEach(procedure(ADataLink: TcxCustomDataLink)
    begin
      if ABufferCount < ADataLink.FBufferCount then
        ABufferCount := ADataLink.FBufferCount;
    end);
  BufferCount := ABufferCount;
end;

function TcxDataLink.GetIsLoading: Boolean;
begin
  Result := Owner.DataSetLink.LoadingRefCount > 0;
end;

function TcxDataLink.GetIsLocate: Boolean;
begin
  Result := Owner.DataSetLink.LocateRefCount > 0;
end;

procedure TcxDataLink.SetIsLoading(AValue: Boolean);
begin
  if AValue then
    Inc(Owner.DataSetLink.LoadingRefCount)
  else
    Dec(Owner.DataSetLink.LoadingRefCount)
end;

procedure TcxDataLink.SetIsLocate(AValue: Boolean);
begin
  if AValue then
    Inc(Owner.DataSetLink.LocateRefCount)
  else
    Dec(Owner.DataSetLink.LocateRefCount)
end;

procedure TcxDataLink.ActiveChanged;
var
  I: Integer;
  AList: TList;
begin
  if (DataSource <> Owner.DataSource) or (DataSet <> Owner.DataSetLink.DataSet) then
  begin
    AList := TList.Create;
    try
      ForEach(
        procedure(ADataLink: TcxCustomDataLink)
        begin
          AList.Add(ADataLink);
        end);
      if DataSource <> Owner.DataSource then
        Owner.DataSourceChanged(DataSource)
      else
        Owner.DataSetChanged(DataSet);
      for I := 0 to AList.Count - 1 do
        TcxCustomDataLink(AList.List[I]).ActiveChanged;
    finally
      AList.Free;
    end;
  end
  else
    ForEach(
      procedure(ADataLink: TcxCustomDataLink)
      begin
        ADataLink.ActiveChanged;
      end);
end;

procedure TcxDataLink.DataEvent(Event: TDataEvent; Info: TdxNativeInt);
begin
  inherited DataEvent(Event, Info);
  if (Event = deDisabledStateChange) and not Boolean(Info) then
    FLayoutChangedFlag := True;
end;

procedure TcxDataLink.DataSetChanged;
begin
  if FLayoutChangedFlag then
  begin
    LayoutChanged;
    Exit;
  end;
  if IsLoading or IsLocate then
    Exit;
  ForEach(
    procedure(ADataLink: TcxCustomDataLink)
    begin
      ADataLink.DataSetChanged;
    end);
end;

procedure TcxDataLink.DataSetScrolled(Distance: Integer);
begin
  ForEach(
    procedure(ADataLink: TcxCustomDataLink)
    begin
      ADataLink.DataSetScrolled(Distance)
    end);
end;

procedure TcxDataLink.EditingChanged;
begin
  ForEach(
    procedure(ADataLink: TcxCustomDataLink)
    begin
      ADataLink.EditingChanged;
    end);
end;

procedure TcxDataLink.FocusControl(Field: TFieldRef);
begin
  ForEach(
    procedure(ADataLink: TcxCustomDataLink)
    begin
      if (Field = nil) or (Field^ = nil) then
        Exit;
      if ADataLink.FocusControl(Field^) then
        Field^ := nil; 
    end);
end;

procedure TcxDataLink.LayoutChanged;
begin
  FLayoutChangedFlag := False;
  if IsLoading then Exit;
  ForEach(
    procedure(ADataLink: TcxCustomDataLink)
    begin
      ADataLink.LayoutChanged;
    end);
end;

procedure TcxDataLink.RecordChanged(Field: TField);
begin
  ForEach(
    procedure(ADataLink: TcxCustomDataLink)
    begin
      ADataLink.RecordChanged(Field);
    end);
end;

procedure TcxDataLink.UpdateData;
begin
  ForEach(
    procedure(ADataLink: TcxCustomDataLink)
    begin
      ADataLink.UpdateData;
    end);
end;

{ TcxDataLinksController.TInternalController }

constructor TcxDataLinksController.TInternalController.Create;
begin
  DataSets := TObjectDictionary<TDataSet, TcxDataSetLink>.Create([doOwnsValues]);
  DataSources := TObjectDictionary<TDataSource, TcxDataSourceLink>.Create([doOwnsValues]);
  FFreeNotificator := TcxFreeNotificator.Create(nil);
  FFreeNotificator.OnFreeNotification := FreeNotificationHandler;
  EmptyDataSource := TcxEmptyDataSourceLink.Create;
  EmptyDataSource.SetDataSetLink(AddOrGetDataSetLink(nil));
  DataSources.Add(nil, EmptyDataSource);

  EmptyDataSet := EmptyDataSource.DataSetLink;
end;

destructor TcxDataLinksController.TInternalController.Destroy;

  function GetNames(AList: TEnumerable<TDataSet>): string; overload;
  var
    ADataSet: TDataSet;
  begin
    Result := '';
    for ADataSet in AList do
      Result := ADataSet.Name + ';' + Result;
  end;

  function GetNames(AList: TEnumerable<TDataSource>): string; overload;
  var
    ADataSource: TDataSource;
  begin
    Result := '';
    for ADataSource in AList do
      Result := ADataSource.Name + ';' + Result;
  end;

begin
  FDataLinksController := nil;
  DataSets.Remove(nil);
  EmptyDataSource.DataSetLink := nil;
  DataSources.Remove(nil);
  if (DataSets.Count > 0) or (DataSources.Count > 0) then
    raise EdxException.CreateFmt('DataLinks not empty (%s %s)!!!',
      [GetNames(DataSets.Keys), GetNames(DataSources.Keys)]);
  FreeAndNil(DataSources);
  FreeAndNil(DataSets);
  FreeAndNil(FFreeNotificator);
  inherited Destroy;
end;

procedure TcxDataLinksController.TInternalController.Add(ADataLink: TcxCustomDataLink);
begin
  EmptyDataSource.Add(ADataLink);
end;

function TcxDataLinksController.TInternalController.AddOrGetDataSetLink(ADataSet: TDataSet): TcxDataSetLink;
begin
  if not DataSets.TryGetValue(ADataSet, Result) then
  begin
    Result := TcxDataSetLink.Create(ADataSet);
    FFreeNotificator.AddSender(ADataSet);
    DataSets.Add(ADataSet, Result);
  end;
end;

function TcxDataLinksController.TInternalController.AddOrGetDataSourceLink(ADataSource: TDataSource): TcxDataSourceLink;
begin
  if not DataSources.TryGetValue(ADataSource, Result) then
  begin
    FFreeNotificator.AddSender(ADataSource);
    Result := TcxDataSourceLink.Create(ADataSource);
    if ADataSource <> nil then
      Result.SetDataSetLink(AddOrGetDataSetLink(ADataSource.DataSet))
    else
      Result.SetDataSetLink(AddOrGetDataSetLink(nil));
    DataSources.Add(ADataSource, Result);
  end;
end;

procedure TcxDataLinksController.TInternalController.ChangeDataSource(ADataLink: TcxCustomDataLink; const AValue: TDataSource);
var
  APrevActive: Boolean;
begin
  Assert(ADataLink.FDataLink <> nil);
  APrevActive := ADataLink.Active;
  try
    Remove(ADataLink);
    AddOrGetDataSourceLink(AValue).Add(ADataLink);
  finally
    if ((APrevActive <> ADataLink.Active) or (ADataLink.Active and (ADataLink.Prev <> nil))) and
       not (ADataLink.Active and (ADataLink.Prev = nil)) then  
      ADataLink.ActiveChanged;
  end;
end;

procedure TcxDataLinksController.TInternalController.Remove(ADataLink: TcxCustomDataLink);
begin
  if TcxDataSourceLink(ADataLink.FDataSourceLink).Remove(ADataLink) = 0 then
  begin
    RemoveDataSource(TcxDataSourceLink(ADataLink.FDataSourceLink));
    RemoveDataSet(TcxDataSetLink(ADataLink.FDataSetLink));
  end;
end;

procedure TcxDataLinksController.TInternalController.RemoveDataSet(var ADataSetLink: TcxDataSetLink);
begin
  if ADataSetLink <> nil then
    Dec(ADataSetLink.RefCount);
  if (ADataSetLink <> nil) and (ADataSetLink <> EmptyDataSet) and (ADataSetLink.RefCount <= 0) then
  begin
    FFreeNotificator.RemoveSender(ADataSetLink.DataSet);
    DataSets.Remove(ADataSetLink.DataSet);
  end;
  ADataSetLink := nil;
end;

procedure TcxDataLinksController.TInternalController.RemoveDataSource(var ADataSourceLink: TcxDataSourceLink);
begin
  if (ADataSourceLink <> nil) and (ADataSourceLink <> EmptyDataSource) then
  begin
    FFreeNotificator.RemoveSender(ADataSourceLink.DataSource);
    DataSources.Remove(ADataSourceLink.DataSource);
  end;
  ADataSourceLink := nil;
end;

procedure TcxDataLinksController.TInternalController.FreeNotificationHandler(Sender: TComponent);
var
  I: Integer;
  ALinks: TList;
  ADataSetLink: TcxDataSetLink;
  ADataSourceLink: TcxDataSourceLink;
begin
  if (Sender is TDataSource) and DataSources.TryGetValue(Sender as TDataSource, ADataSourceLink) then
  begin
    ADataSourceLink.ForEach(
      procedure(ADataLink: TcxCustomDataLink)
      begin
        ChangeDataSource(ADataLink, nil);
      end);
    DataSources.Remove(Sender as TDataSource);
  end;
  if Sender is TDataSet and DataSets.TryGetValue(Sender as TDataSet, ADataSetLink) then
  begin
    ALinks := TList.Create;
    try
      for ADataSourceLink in DataSources.Values do
        if ADataSourceLink.DataSetLink = ADataSetLink then
          ALinks.Add(ADataSourceLink);
      for I := 0 to ALinks.Count - 1 do
        TcxDataSourceLink(ALinks[I]).SetDataSetLink(EmptyDataSet);
    finally
      ALinks.Free;
    end;
  end;
end;

{ TcxCustomDataLink }

constructor TcxCustomDataLink.Create;
begin
  FBufferCount := 1;
  TcxDataLinksController.Add(Self);
end;

destructor TcxCustomDataLink.Destroy;
begin
  TcxDataLinksController.Remove(Self);
  inherited Destroy;
end;

function TcxCustomDataLink.Edit: Boolean;
begin
  Result := DataLink.Edit;
end;

function TcxCustomDataLink.ExecuteAction(Action: TBasicAction): Boolean;
begin
  Result := DataLink.ExecuteAction(Action);
end;

function TcxCustomDataLink.UpdateAction(Action: TBasicAction): Boolean;
begin
  Result := DataLink.UpdateAction(Action);
end;

procedure TcxCustomDataLink.UpdateRecord;
begin
end;


procedure TcxCustomDataLink.UpdateData;
begin
end;

procedure TcxCustomDataLink.ActiveChanged;
begin
end;

procedure TcxCustomDataLink.DataSetChanged;
begin
end;

procedure TcxCustomDataLink.DataSetScrolled(Distance: Integer);
begin
end;

procedure TcxCustomDataLink.EditingChanged;
begin
end;

function TcxCustomDataLink.FocusControl(Field: TField): Boolean;
begin
  Result := False;
end;

procedure TcxCustomDataLink.LayoutChanged;
begin
end;

procedure TcxCustomDataLink.RecordChanged(Field: TField);
begin
end;

function TcxCustomDataLink.GetActive: Boolean;
begin
  Result := DataLink.Active;
end;

function TcxCustomDataLink.GetActiveRecord: Integer;
begin
  Result := DataLink.ActiveRecord;
end;

function TcxCustomDataLink.GetBOF: Boolean;
begin
  Result := TDataLinkAccess(DataLink).GetBOF;
end;

function TcxCustomDataLink.GetBufferCount: Integer;
begin
  Result := FBufferCount;
  if (DataLink <> nil) and (FBufferCount < DataLink.BufferCount) then
    Result := DataLink.BufferCount;
end;

class function TcxCustomDataLink.GetDataLinksByDataSet(ADataSet: TDataSet): IEnumerable;
begin
  Result := TcxCustomDataLinkEnumerator.Create(ADataSet);
end;

function TcxCustomDataLink.GetDataSource: TDataSource;
begin
  if (FDataSourceLink = nil) or (FDataSetLink = nil) then
    Result := nil
  else
    Result := FDataLink.DataSource;
end;

function TcxCustomDataLink.GetDataSet: TDataSet;
begin
  if (FDataSourceLink = nil) or (FDataSetLink = nil) or (DataSource = nil) then
    Result := nil
  else
    Result := FDataLink.DataSet;
end;

function TcxCustomDataLink.GetDataSourceFixed: Boolean;
begin
  Result := DataLink.DataSourceFixed;
end;

function TcxCustomDataLink.GetEditing: Boolean;
begin
  Result := not ReadOnly and DataLink.Editing;
end;

function TcxCustomDataLink.GetEOF: Boolean;
begin
  Result := TDataLinkAccess(DataLink).GetEOF;
end;

function TcxCustomDataLink.GetGridMode: Boolean;
begin
  Result := FBufferCount > 1;
end;

function TcxCustomDataLink.GetRecordCount: Integer;
begin
  Result := DataLink.RecordCount;
end;

function TcxCustomDataLink.GetIsLoading: Boolean;
begin
  Result := TcxDataLink(FDataLink).IsLoading;
end;

function TcxCustomDataLink.GetIsLocate: Boolean;
begin
  Result := TcxDataLink(FDataLink).IsLocate;
end;

procedure TcxCustomDataLink.SetActiveRecord(const AValue: Integer);
begin
  DataLink.ActiveRecord := AValue;
end;

procedure TcxCustomDataLink.SetBufferCount(AValue: Integer);
var
  APrevBufferCount: Integer;
begin
  if AValue < 1 then
    AValue := 1;
  APrevBufferCount := BufferCount;
  if AValue <> BufferCount then
  begin
    FBufferCount := AValue;
    TcxDataSourceLink(FDataSourceLink).BufferCountChanged(Self, APrevBufferCount, AValue);
  end;
end;

procedure TcxCustomDataLink.SetDataSetLink(AValue: TObject);
begin
  if AValue = FDataSetLink then
    Exit;
  if FDataSetLink <> nil then
    TcxDataLinksController.RemoveDataSet(TcxDataSetLink(FDataSetLink));
  FDataSetLink := AValue;
  if FDataSetLink <> nil then
    Inc(TcxDataSetLink(FDataSetLink).RefCount);
end;

procedure TcxCustomDataLink.SetDataSource(const AValue: TDataSource);
begin
  TcxDataLinksController.ChangeDataSource(Self, AValue);
end;

procedure TcxCustomDataLink.SetIsLoading(const AValue: Boolean);
begin
  TcxDataLink(FDataLink).IsLoading := AValue;
end;

procedure TcxCustomDataLink.SetIsLocate(const AValue: Boolean);
begin
  TcxDataLink(FDataLink).IsLocate := AValue;
end;

procedure TcxCustomDataLink.SetReadOnly(const AValue: Boolean);
begin
  if AValue <> ReadOnly then
  begin
    FReadOnly := AValue;
    EditingChanged;
  end;
end;

procedure TcxCustomDataLink.SetUpdating(const AValue: Boolean);
begin
  FUpdating := AValue;
end;

procedure TcxCustomDataLink.SetVisualControl(AValue: Boolean);
begin
  if AValue <> VisualControl then
  begin
    FVisualControl := AValue;
    TcxDataSourceLink(FDataSourceLink).InitializeDataLink(Self);
  end;
end;

{ TcxCustomFieldDataLink }

constructor TcxCustomFieldDataLink.Create(ADataBinding: TcxCustomDBDataBinding);
begin
  inherited Create;
  VisualControl := False;
  FDataBinding := ADataBinding;
end;

function TcxCustomFieldDataLink.Edit: Boolean;
begin
  if CanModify then
    inherited Edit;
  Result := FEditing;
end;

procedure TcxCustomFieldDataLink.Modified;
begin
  FModified := True;
end;

procedure TcxCustomFieldDataLink.Reset;
begin
  RecordChanged(nil);
end;

procedure TcxCustomFieldDataLink.ActiveChanged;
begin
  UpdateField;
  FDataBinding.DataSetChange;
end;

procedure TcxCustomFieldDataLink.DataEvent(Event: TDataEvent;
  Info: TdxNativeInt);
begin
  if Event = deDataSetChange then
    UpdateField;
  inherited DataEvent(Event, Info);
  if Event = deDataSetChange then
    FDataBinding.DataSetChange;
end;

procedure TcxCustomFieldDataLink.EditingChanged;
begin
  SetEditing(inherited Editing and CanModify);
end;

(*procedure TcxCustomFieldDataLink.FocusControl(Field: TFieldRef);
begin
  if (Field^ <> nil) and (Field^ = FField) and (FDataComponent is TWinControl) then
    if TWinControl(FDataComponent).CanFocus then
    begin
      Field^ := nil;
      TWinControl(FDataComponent).SetFocus;
    end;
end;*)

procedure TcxCustomFieldDataLink.LayoutChanged;
begin
  UpdateField;
end;

procedure TcxCustomFieldDataLink.RecordChanged(Field: TField);
begin
  if (Field = nil) or (Field = FField) then
  begin
    FDataBinding.InternalDataChange;
    if not FDataBinding.IsRefreshDisabled then
      FModified := False;
  end;
end;

procedure TcxCustomFieldDataLink.UpdateData;
begin
  if FModified then
  begin
    if Field <> nil then
      FDataBinding.UpdateData;
    if not FDataBinding.IsRefreshDisabled then
      FModified := False;
  end;
end;

procedure TcxCustomFieldDataLink.DataComponentChanged;
begin
end;

procedure TcxCustomFieldDataLink.UpdateRightToLeft;
begin
end;

procedure TcxCustomFieldDataLink.VisualControlChanged;
begin
end;

function TcxCustomFieldDataLink.GetCanModify: Boolean;
begin
  Result := not ReadOnly and (Field <> nil) and (Field.CanModify or
    (Field.Lookup and CanModifyLookupField(Field)));
end;

function TcxCustomFieldDataLink.GetDataComponent: TComponent;
begin
  Result := FDataBinding.DataComponent;
end;

procedure TcxCustomFieldDataLink.SetEditing(Value: Boolean);
begin
  if FEditing <> Value then
  begin
    FEditing := Value;
    if not FDataBinding.IsRefreshDisabled then
      FModified := False;
  end;
end;

procedure TcxCustomFieldDataLink.SetField(Value: TField);
begin
  if FField <> Value then
  begin
    FField := Value;
    FDataBinding.DataSetChange;
    EditingChanged;
    RecordChanged(nil);
    UpdateRightToLeft;
  end;
end;

procedure TcxCustomFieldDataLink.SetFieldName(const Value: string);
begin
  if FFieldName <> Value then
  begin
    FFieldName :=  Value;
    UpdateField;
  end;
end;

procedure TcxCustomFieldDataLink.UpdateField;
begin
  if Active and (FFieldName <> '') then
  begin
    FField := nil;
    if Assigned(DataComponent) then
      SetField(GetFieldProperty(DataSource.DataSet, DataComponent, FFieldName))
    else
      SetField(DataSource.DataSet.FieldByName(FFieldName));
  end
  else
    SetField(nil);
end;

{ TcxCustomDBDataBinding }

constructor TcxCustomDBDataBinding.Create(AOwner, ADataComponent: TComponent);
begin
  inherited Create(AOwner, ADataComponent);
  FDataLink := GetDataLinkClass.Create(Self);
end;

destructor TcxCustomDBDataBinding.Destroy;
begin
  FDataLink.Free;
  inherited Destroy;
end;

function TcxCustomDBDataBinding.CanModify: Boolean;
begin
  Result := IsDataSourceLive and not Field.ReadOnly;
  Result := Result and (Field.CanModify or (Field.Lookup and CanModifyLookupField(Field)));
end;

function TcxCustomDBDataBinding.ExecuteAction(Action: TBasicAction): Boolean;
begin
  Result := FDataLink.ExecuteAction(Action);
end;

function TcxCustomDBDataBinding.IsControlReadOnly: Boolean;
begin
  Result := ReadOnly;
  if not Result and IsDataSourceLive then
    Result := Field.ReadOnly;
end;

function TcxCustomDBDataBinding.IsDataSourceLive: Boolean;
begin
  Result := IsDataAvailable(FDataLink.FField);
end;

function TcxCustomDBDataBinding.IsDataStorage: Boolean;
begin
  Result := True;
end;

procedure TcxCustomDBDataBinding.Reset;
begin
  FDataLink.Reset;
end;

function TcxCustomDBDataBinding.SetEditMode: Boolean;
begin
  Result := inherited SetEditMode;
  if not Result then
    Exit;

  DisableRefresh;
  try
    FDataLink.Edit;
    Result := FDataLink.Editing;
    if Result then
      FDataLink.Modified;
  finally
    EnableRefresh;
  end;
end;

procedure TcxCustomDBDataBinding.UpdateDataSource;
begin
  FDataLink.UpdateRecord;
end;

function TcxCustomDBDataBinding.GetModified: Boolean;
begin
  Result := IsDataSourceLive and FDataLink.Editing and FDataLink.FModified;
end;

function TcxCustomDBDataBinding.GetReadOnly: Boolean;
begin
  Result := FDataLink.ReadOnly;
end;

function TcxCustomDBDataBinding.GetStoredValue(AValueSource: TcxDataEditValueSource;
  AFocused: Boolean): Variant;
begin
  if not IsDataSourceLive or (Field.IsNull and (AValueSource <> evsText)) then
    Result := Null
  else
    case AValueSource of
      evsKey:
        if Field.KeyFields <> '' then
          Result := Field.DataSet.FieldValues[Field.KeyFields]
        else
          Result := Field.Value;
      evsText:
        if AFocused and FDataLink.CanModify then
          Result := Field.Text
        else
          Result := Field.DisplayText;
    else {evsValue:}
      Result := Field.Value;
    end;
end;

procedure TcxCustomDBDataBinding.SetReadOnly(Value: Boolean);
begin
  if Value <> ReadOnly then
  begin
    FDataLink.ReadOnly := Value;
    DataSetChange;
  end;
end;

procedure TcxCustomDBDataBinding.VisualControlChanged;
begin
  FDataLink.VisualControlChanged;
end;

procedure TcxCustomDBDataBinding.SetStoredValue(AValueSource: TcxDataEditValueSource;
  const Value: Variant);

  procedure SetFieldValueEx(AField: TField; const AValue: Variant);
  begin
    if VarIsStr(Value) and (Value = '') and not(Field.DataType in [ftString, ftWideString]) then
      AField.Value := Null
    else
      AField.Value := Value;
  end;

var
  AFieldList: TcxDBFieldList;
  I: Integer;
begin
  if IsDataSourceLive then
  begin
    DisableRefresh;
    try
      if FDataLink.Edit then
      begin
        if (*(*)AValueSource = evsText(*) or Assigned(Field.OnSetText)*) then
          Field.Text := VarToStr(Value)
        else
          if (AValueSource = evsKey) and (Field.KeyFields <> '') then
            if Pos(';', Field.KeyFields) = 0 then
              SetFieldValueEx(Field.DataSet.FieldByName(Field.KeyFields), Value)
            else
            begin
              AFieldList := TcxDBFieldList.Create;
              try
                Field.DataSet.GetFieldList(AFieldList, Field.KeyFields);
                for I := 0 to AFieldList.Count - 1 do
                  SetFieldValueEx(TField(AFieldList[I]), Value[I]);
              finally
                AFieldList.Free;
              end;
              Field.DataSet.FieldValues[Field.KeyFields] := Value;
            end
          else
            SetFieldValueEx(Field, Value);
      end;
    finally
      EnableRefresh;
    end;
  end;
end;

function TcxCustomDBDataBinding.UpdateAction(Action: TBasicAction): Boolean;
begin
  Result := FDataLink.UpdateAction(Action);
end;

procedure TcxCustomDBDataBinding.DisableRefresh;
begin
  Inc(FRefreshCount);
end;

procedure TcxCustomDBDataBinding.EnableRefresh;
begin
  if FRefreshCount > 0 then
    Dec(FRefreshCount);
end;

function TcxCustomDBDataBinding.GetDataLinkClass: TcxCustomFieldDataLinkClass;
begin
  Result := TcxCustomFieldDataLink;
end;

function TcxCustomDBDataBinding.IsRefreshDisabled: Boolean;
begin
  Result := FRefreshCount > 0;
end;

function TcxCustomDBDataBinding.GetDataField: string;
begin
  Result := FDataLink.FieldName;
end;

function TcxCustomDBDataBinding.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

function TcxCustomDBDataBinding.GetField: TField;
begin
  Result := FDataLink.Field;
end;

procedure TcxCustomDBDataBinding.InternalDataChange;
begin
  if not IsRefreshDisabled then
    DataChange;
end;

procedure TcxCustomDBDataBinding.SetDataField(const Value: string);
begin
  FDataLink.FieldName := Value;
end;

procedure TcxCustomDBDataBinding.SetDataSource(Value: TDataSource);
begin
  FDataLink.DataSource := Value;
end;

{ TcxEmptyDataSourceLink }

constructor TcxEmptyDataSourceLink.Create;
begin
  inherited Create(nil);
end;

function TcxEmptyDataSourceLink.Remove(ADataLink: TcxCustomDataLink): Integer;
begin
  Result := inherited Remove(ADataLink);
  if Result <= 0 then
    if TcxDataLinksController.Reset then
      Dec(Result);
end;

{ TcxDataLinksController }

class destructor TcxDataLinksController.Destroy;
begin
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.DestructorStarted(UnitName, 'TcxDataLinksController.Destroy', SysInit.HInstance);{$ENDIF}
  IsDestroying := True;
  Reset;
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.DestructorFinished(UnitName, 'TcxDataLinksController.Destroy', SysInit.HInstance);{$ENDIF}
end;

class procedure TcxDataLinksController.Add(ADataLink: TcxCustomDataLink);
begin
  if FDataLinksController = nil then
    FDataLinksController := TInternalController.Create;
  FDataLinksController.Add(ADataLink);
end;

class function TcxDataLinksController.AddOrGetDataSetLink(ADataSet: TDataSet): TcxDataSetLink;
begin
  if FDataLinksController = nil then
    FDataLinksController := TInternalController.Create;
  Result := FDataLinksController.AddOrGetDataSetLink(ADataSet);
end;

class procedure TcxDataLinksController.ChangeDataSource(ADataLink: TcxCustomDataLink; const AValue: TDataSource);
begin
  if FDataLinksController = nil then
    FDataLinksController := TInternalController.Create;
  FDataLinksController.ChangeDataSource(ADataLink, AValue);
end;

class procedure TcxDataLinksController.Remove(ADataLink: TcxCustomDataLink);
begin
  if (ADataLink = nil) and (FDataLinksController = nil) then
    Exit;
  Assert(FDataLinksController <> nil);
  FDataLinksController.Remove(ADataLink);
end;

class procedure TcxDataLinksController.RemoveDataSet(var ADataSetLink: TcxDataSetLink);
begin
  if (ADataSetLink = nil) and (FDataLinksController = nil) then
    Exit;
  Assert(FDataLinksController <> nil);
  FDataLinksController.RemoveDataSet(ADataSetLink);
end;

class function TcxDataLinksController.Reset: Boolean;
begin
  Result := IsDestroying;
  if IsDestroying and (FDataLinksController <> nil) then
    if FDataLinksController.EmptyDataSource.RefCount <= 0 then
      FreeAndNil(FDataLinksController);
end;

{ TcxCustomDataLinkEnumerator.TEnumerator }

constructor TcxCustomDataLinkEnumerator.TEnumerator.Create(AOwner: TcxCustomDataLinkEnumerator);
begin
  FOwner := AOwner;
end;

destructor TcxCustomDataLinkEnumerator.TEnumerator.Destroy;
begin
  FreeAndNil(FEnumerator);
  inherited;
end;

function TcxCustomDataLinkEnumerator.TEnumerator.GetCurrent: TObject;
begin
  Result := FDataLink;
end;

function TcxCustomDataLinkEnumerator.TEnumerator.MoveNext: Boolean;
begin
  if FEnumerator = nil then
    FEnumerator := TcxDataLinksController.FDataLinksController.DataSources.Values.GetEnumerator;
  repeat
    if FDataSourceLink = nil then
    begin
      repeat
        Result := FEnumerator.MoveNext;
        if not Result then
          Exit;
        FDataSourceLink := FEnumerator.Current;
      until (FDataSourceLink.DataSource <> nil) and (FDataSourceLink.DataSource.DataSet = FOwner.FDataSet);
      FDataLink := TcxCustomDataLink(FDataSourceLink.DataLinks.First);
      Exit(FDataLink <> nil);
    end;
    FDataLink := TcxCustomDataLink(FDataLink.Next);
    if FDataLink = nil then
      FDataSourceLink := nil
  until FDataLink <> nil;
  Result := True;
end;

procedure TcxCustomDataLinkEnumerator.TEnumerator.Reset;
begin
  FreeAndNil(FEnumerator);
  FDataSourceLink := nil;
  FDataLink := nil;
end;

{ TcxCustomDataLinkEnumerator }

constructor TcxCustomDataLinkEnumerator.Create(ADataSet: TDataSet);
begin
  FDataSet := ADataSet;
end;

function TcxCustomDataLinkEnumerator.GetDataSourceLinks: TList<TcxDataSourceLink>;
var
  AItem: TPair<TDataSource, TcxDataSourceLink>;
begin
  Result := TList<TcxDataSourceLink>.Create;
  for AItem in TcxDataLinksController.FDataLinksController.DataSources do
    if (AItem.Key <> nil) and (AItem.Key.DataSet = FDataSet) then
      Result.Add(AItem.Value);
end;

function TcxCustomDataLinkEnumerator.GetEnumerator: IEnumerator;
begin
  Result := TEnumerator.Create(Self);
end;

end.

