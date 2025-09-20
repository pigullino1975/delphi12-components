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

unit dxEMF.DataProvider.ADO;

{$IF (CompilerVersion >= 30) AND (DEFINED(IOS) OR DEFINED(ANDROID))}
  {$HPPEMIT LINKUNIT}
{$ELSE}
  {$IFDEF WIN32}
    {$HPPEMIT '#pragma link "dxEMF.DataProvider.ADO.obj"'}
  {$ELSE}
    {$HPPEMIT '#pragma link "dxEMF.DataProvider.ADO.o"'}
  {$ENDIF}
{$IFEND}

interface

{$I cxVer.inc}
{$I dxEMF.inc}

uses
  Classes, SysUtils, Generics.Defaults, Generics.Collections, DB, Rtti,
  Windows,
  Data.Win.ADODB,
  ADOInt, OleDB,
  dxEMF.Metadata,
  dxEMF.Core.Loader,
  dxEMF.Core,
  dxEMF.Types,
  dxEMF.DB.Query,
  dxEMF.DB.Generator,
  dxEMF.DB.Model,
  dxEMF.DB.SQLConnectionProvider;

type

  { TdxADOCommand }

  TdxADOCommand = class(TdxCustomDBCommand)
  strict private type
    TdxADODataSet = class(TCustomADODataSet);
  strict private
    FCommandExecutor: TdxADODataSet;
    FCommand: TADOCommand;
  protected
    procedure SetCommandText(const Value: string); override;
    procedure PrepareParameters(AConvertParameter: TdxConvertParameter); override;
  public
    constructor Create(AConnection: TADOConnection; AQuery: TdxQuery);
    destructor Destroy; override;
    function ExecuteNonQuery: Integer; override;
    function GetScalar: Variant; override;
  end;

  { EdxODBCError }

  EdxODBCError = class(Exception);

  { TdxADOConnectionVendor }

  TdxADOConnectionVendor = class(TdxCustomConnectionVendor, IdxDBTransaction)
  public type
{$REGION 'ODBC helper'}
    TODBCHelper = class sealed
    public
      const
        ODBC_ADD_DSN        = 1;
        ODBC_CONFIG_DSN     = 2;
        ODBC_REMOVE_DSN     = 3;
        ODBC_ADD_SYS_DSN    = 4;
        ODBC_CONFIG_SYS_DSN = 5;
        ODBC_REMOVE_SYS_DSN = 6;
        SQL_FETCH_NEXT      = 1;
        SQL_FETCH_FIRST     = 2;
        SQL_SUCCESS = 0;
      type
        TSQLConfigDataSource = function( hwndParent: HWND;
                                         fRequest: WORD;
                                         lpszDriver: LPCWSTR;
                                         lpszAttributes: LPCWSTR) : BOOL; stdcall;

    strict private
      class var
        HLib: HMODULE;
        FSQLConfigDataSource: TSQLConfigDataSource;
      class destructor Destroy;
      class function GetSQLConfigDataSource: TSQLConfigDataSource; static;
    public
      class procedure GetDSNList(AList: TStrings); static;
      class property SQLConfigDataSource: TSQLConfigDataSource read GetSQLConfigDataSource;
    end;
{$ENDREGION}
  strict private
    const
      SchemaInfo: array[TdxSchemaInfo] of TSchemaInfo = (
        siTables,
        siViews,
        siProcedures,
        siColumns,
        siIndexes,
        siIndexes,
        siPrimaryKeys,
        siForeignKeys,
        siForeignKeys
      );
  strict private
    class function GetType(AType: TOleEnum): TdxDBColumnType; static;
    function GetConnection: TADOConnection; inline;
    procedure GetColumns(ATable: TdxDBTable; const ASchemaName, ATableName: string);
    procedure GetPrimaryKey(ATable: TdxDBTable; const ASchemaName, ATableName: string);
    procedure GetIndexes(ATable: TdxDBTable; const ASchemaName, ATableName: string);
    procedure GetForeignKeys(ATable: TdxDBTable; const ASchemaName, ATableName: string);
  protected
    class procedure AssignParameterVariant(const AParameter: TParameter; const AValue: Variant); static;
    class procedure AssignParameterValue(const AParameter: TParameter; const AValue: TValue); static;
    procedure Commit;
    procedure Rollback;

    function GetConnectionString: string; override;
    function GetExpectedDBEngine: TdxDBEngine; override;
    function CreateCommand(AQuery: TdxQuery): TdxCustomDBCommand; override;
    function SelectData(AOwner: TComponent; AQuery: TdxQuery): TDataSet; override;
  public
    class function GetConnectionType: TdxConnectionType; override;
    function BeginTransaction: IdxDBTransaction; override;
    function CreateConnection(AProviderSQL: TdxSQLConnectionProvider;
      const ADatabaseName: string = ''): TCustomConnection; override;
    function CreateDataSet(AQuery: TdxQuery; AOwner: TComponent = nil): TDataSet; override;
    function Execute(const ACommandText: string): Integer; override;
    function ExecuteScalar(AConnection: TCustomConnection; const ACommandText: string): Variant; override;
    function GetSchema(ASchemaInfo: TdxSchemaInfo; const ACatalogName, ASchemaName, ATableName: string; const AObjectName: string = ''): TDataSet; override;
    procedure GetTableSchema(ATable: TdxDBTable; ACheckIndexes, ACheckForeignKeys: Boolean); override;
    property Connection: TADOConnection read GetConnection;
  end;

  { TdxEMFADODataProvider }

  TdxEMFADODataProvider = class(TdxEMFCustomDataProvider)
  strict private
    function GetConnection: TADOConnection;
    procedure SetConnection(const Value: TADOConnection);
    function GetConnectionVendor: TdxADOConnectionVendor; inline;
  protected
    function CreateDatabase: Boolean;
    procedure CheckConnectAndCreate; override;
    function CreateConnectionVendor: TdxCustomConnectionVendor; override;
    function CreateLoader(ASession: TdxEMFCustomSession; AConnectionVendor: TdxCustomConnectionVendor; AQuery: TdxQuery;
      AEntityInfo: TdxEntityInfo; APredicate: TdxPredicate = nil): TdxDataLoader; override;
    property ConnectionVendor: TdxADOConnectionVendor read GetConnectionVendor;
  published
    property Connection: TADOConnection read GetConnection write SetConnection;
  end;

implementation

uses
  System.Odbc,
  StrUtils, DateUtils, Variants, TypInfo, IOUtils, Math,
  dxCore,
  dxEMF.Utils.Exceptions,
  dxEMF.Utils,
  dxEMF.DB.SQLGenerator,
  dxEMF.DB.Criteria,
  dxEMF.Core.Pool,
  dxEMF.DB.Utils,
  dxEMF.Strs, dxEMF.Serializer;

const
  dxThisUnitName = 'dxEMF.DataProvider.ADO';

  {$IFDEF WIN32}
  {$HPPEMIT ''}
  {$HPPEMIT '#ifndef USEPACKAGES'}
  {$HPPEMIT '/* automatically link to odbc32.lib */'}
  {$HPPEMIT '#pragma link "odbc32.lib"'}
  {$HPPEMIT '#endif'}
  {$HPPEMIT ''}
  {$ENDIF WIN32}

type

  TdxSQLConnectionProviderAccess = class(TdxSQLConnectionProvider);
  TdxEMFCustomSessionAccess = class(TdxEMFCustomSession);

  { TdxMappingMemberInfoHelper }
  TdxMappingMemberInfoHelper = class helper for TdxMappingMemberInfo
  public
    function GetCorrectFieldType: TFieldType;
  end;

  { TdxADODataSet }

  TdxADODataSet = class(TADODataSet)
  protected
    procedure InternalInitFieldDefs; override;
  end;

  TdxByteStream = class(TCustomMemoryStream)
  public
    constructor Create(ASource: PByte; ALength: Integer);
  end;

  { TdxADOField }

  TdxADOField = record
    ADOField: Field;
    FieldType: TFieldType;
    constructor Create(const AADOField: Field; AFieldType: TFieldType);
    function GetSafeVariant: Variant;
  end;

  { TdxADOLoader }

  TdxADOLoader = class(TdxDataSetLoader<TADODataSet, TdxADOField>)
  strict private
    FEOF: Boolean;
    FRecordset: _Recordset;
    function GetFields(AMemberInfo: TdxMappingMemberInfo; var AFieldIndex: Integer): TArray<TdxADOField>;
    function ToValues(const AFields: TArray<TdxADOField>; AMemberInfo: TdxMappingMemberInfo): TArray<TValue>;
    function ToVariants(const AFields: TArray<TdxADOField>): TArray<Variant>;
  protected
    procedure BeginLoad; override;
    procedure CreateFieldsCache; override;
    function ReadCurrentRecordKeys: TArray<TValue>; override;
    procedure ReadCurrentRecord(AInstance: Pointer); override;
    procedure ReadCurrentRecord(out AValues: TArray<Variant>); override;
    procedure ReadCurrentRecord(out AValues: TArray<TValue>); override;

    function GetEof: boolean; override;
    function MoveNext: Boolean; override;
  end;

{ TdxMappingMemberInfoHelper }

function TdxMappingMemberInfoHelper.GetCorrectFieldType: TFieldType;
begin
  Result := FieldType;
  if Result in [ftBCD, ftFMTBcd] then
    case TypeKind of
      tkInteger:
        Result := ftInteger;
      tkInt64:
        Result := ftLargeint;
      tkFloat:
        Result := ftFloat;
      else
        Result := ftCurrency;
    end;
end;

{ TdxByteStream }

constructor TdxByteStream.Create(ASource: PByte; ALength: Integer);
begin
  inherited Create;
  SetPointer(ASource, ALength);
end;

{ TdxADOField }

constructor TdxADOField.Create(const AADOField: Field; AFieldType: TFieldType);
begin
  ADOField := AADOField;
  FieldType := AFieldType;
end;

function TdxADOField.GetSafeVariant: Variant;
var
  AValue: OleVariant;
  AInt64: Int64;
  AWord: Word;
  ALongWord: LongWord;
  AInteger: Integer;
  ACurrency: Currency;
  ABoolean: Boolean;
begin
  AValue := ADOField.Value;
  if VarType(AValue) = 14 then
  begin
    case FieldType of
      ftSmallint, ftInteger, ftShortInt:
        begin
          AInteger := AValue;
          Exit(AInteger);
        end;
      ftByte, ftWord:
        begin
          AWord := AValue;
          Exit(AWord);
        end;
      ftBoolean:
        begin
          ABoolean := AValue;
          Exit(ABoolean);
        end;
      ftCurrency:
        begin
          ACurrency := AValue;
          Exit(ACurrency);
        end;
      ftAutoInc, ftLargeint:
        begin
          AInt64 := AValue;
          Exit(AInt64);
        end;
      ftLongWord:
        begin
          ALongWord := AValue;
          Exit(ALongWord);
        end;
    end;
  end
  else
    Result := AValue;
end;

{ TdxADOLoader }

procedure TdxADOLoader.BeginLoad;
begin
  DataSet.Open;
  FRecordset := DataSet.Recordset;
  inherited BeginLoad;
end;

procedure TdxADOLoader.CreateFieldsCache;
var
  AFieldsCache: TdxArray<TFieldCache>;
  AKeyFieldsCache: TdxArray<TFieldCache>;
  AMemberInfo: TdxMappingMemberInfo;
  AFields: TArray<TdxADOField>;
  I, AFieldIndex, ACount: Integer;
begin
  FRecordset := DataSet.Recordset;
  ACount := EntityInfo.PersistentProperties.Count;
  AFieldsCache := TdxArray<TFieldCache>.Create(ACount);
  AKeyFieldsCache := TdxArray<TFieldCache>.Create(ACount);
  AFieldIndex := 0;
  for I := 0 to ACount - 1 do
  begin
    AMemberInfo := EntityInfo.PersistentProperties.List[I];
    if AMemberInfo.IsDataMember then
      if not (AMemberInfo.IsAssociationList{ or AMemberInfo.IsAssociationObject}) then
      begin
        if not AMemberInfo.IsLoadable then
        begin
          AFields := nil;
          SetLength(AFields, Max(Length(AMemberInfo.SubMembers), 1)) 
        end
        else
          AFields := GetFields(AMemberInfo, AFieldIndex);

        AFieldsCache.Add(TFieldCache.Create(AMemberInfo, AFields));
        if AMemberInfo.IsKey then
          AKeyFieldsCache.Add(TFieldCache.Create(AMemberInfo, AFields));
      end;
  end;
  FieldsCache := AFieldsCache.ToArray;
  KeyFieldsCache := AKeyFieldsCache.ToArray;
end;

procedure TdxADOLoader.ReadCurrentRecord(AInstance: Pointer);
var
  I: Integer;
  AKeys: TArray<TValue>;
  ARefObject: TObject;
  ASession: TdxEMFCustomSession;
  AMemberInfo: TdxMappingMemberInfo;
  AFields: TArray<TdxADOField>;
begin
  ASession := Session as TdxEMFCustomSession;
  for I := 0 to Length(FieldsCache) - 1 do
  begin
    AMemberInfo := FieldsCache[I].Key;
    AFields := FieldsCache[I].Value;
    if not (AMemberInfo.IsWritable or AMemberInfo.IsSerialize) then
      Continue;
    if AMemberInfo.IsReference then
    begin
      AKeys := ToValues(AFields, AMemberInfo.ReferenceType.KeyProperty.Member);
      ARefObject := TdxEMFCustomSessionAccess(ASession).FindBatch(AMemberInfo.ReferenceType.ClassAttributes.PersistentClass, AKeys);
      AMemberInfo.SetValue(AInstance, ARefObject);
    end
    else
    begin
      if AFields <> nil then
        if Assigned(AMemberInfo.OnSetter) then
          AMemberInfo.OnSetter(AInstance, AFields[0].GetSafeVariant)
        else
          TdxFieldValueConverter.SetValue(AInstance, ToVariants(AFields), AMemberInfo);
    end;
  end;
end;

procedure TdxADOLoader.ReadCurrentRecord(out AValues: TArray<Variant>);
var
  I, J: Integer;
begin
  SetLength(AValues, FieldCount);
  for I := 0 to Length(FieldsCache) - 1 do
    for J := 0 to Length(FieldsCache[I].Value) - 1 do
    begin
      if FieldsCache[I].Value[J].ADOField <> nil then
      AValues[I] := FieldsCache[I].Value[J].GetSafeVariant
      else
        AValues[I] := FieldsCache[I].Key.GetValue(nil).ToVariant;
    end;
end;

function TdxADOLoader.GetEof: boolean;
begin
  if FEOF then
    Exit(True);
  CheckActive;
  Result := FRecordset.EOF;
end;

function TdxADOLoader.GetFields(AMemberInfo: TdxMappingMemberInfo; var AFieldIndex: Integer): TArray<TdxADOField>;
var
  I: Integer;
begin
  if Length(AMemberInfo.SubMembers) > 0 then
  begin
    SetLength(Result, Length(AMemberInfo.SubMembers));
    for I := 0 to Length(AMemberInfo.SubMembers) - 1 do
    begin
      Result[I].ADOField := FRecordset.Fields[AFieldIndex];
      Result[I].FieldType := AMemberInfo.SubMembers[I].GetCorrectFieldType;
      Inc(AFieldIndex);
    end
  end
  else
    if AMemberInfo.IsReference then
    begin
      SetLength(Result, AMemberInfo.ReferenceType.KeyAttributes.Count);
      for I := 0 to Length(Result) - 1 do
      begin
        Result[I].ADOField := FRecordset.Fields[AFieldIndex];
        Result[I].FieldType := AMemberInfo.ReferenceType.KeyAttributes[I].GetCorrectFieldType;
        Inc(AFieldIndex);
      end;
    end
    else
    begin
      Result := TArray<TdxADOField>.Create(TdxADOField.Create(FRecordset.Fields[AFieldIndex], AMemberInfo.GetCorrectFieldType));
      Inc(AFieldIndex);
    end;
end;

function TdxADOLoader.MoveNext: Boolean;
begin
  CheckActive;
  FRecordset.MoveNext;
  Result := not FRecordset.Eof;
  if not Result then
  begin
    FEOF := True;
    FRecordset := nil;
    EndLoad;
  end;
end;

procedure TdxADOLoader.ReadCurrentRecord(out AValues: TArray<TValue>);
var
  I, J: Integer;
begin
  SetLength(AValues, FieldCount);
  for I := 0 to Length(FieldsCache) - 1 do
    for J := 0 to Length(FieldsCache[I].Value) - 1 do
    begin
      if FieldsCache[I].Value[J].ADOField <> nil then
        AValues[I] := TdxFieldValueConverter.ToValue(FieldsCache[I].Value[J].GetSafeVariant, FieldsCache[I].Key)
      else
        AValues[I] := FieldsCache[I].Key.GetValue(nil);
    end;
end;

function TdxADOLoader.ReadCurrentRecordKeys: TArray<TValue>;
var
  I, J, K: Integer;
begin
  SetLength(Result, EntityInfo.KeyProperty.KeyFieldCount);
  K := 0;
  for I := 0 to Length(KeyFieldsCache) - 1 do
    for J := 0 to Length(KeyFieldsCache[I].Value) - 1 do
    begin
      Result[K] := TdxFieldValueConverter.ToValue(KeyFieldsCache[I].Value[J].GetSafeVariant, KeyFieldsCache[I].Key);
      Inc(K);
    end;
end;

function TdxADOLoader.ToValues(const AFields: TArray<TdxADOField>; AMemberInfo: TdxMappingMemberInfo): TArray<TValue>;
var
  I: Integer;
begin
  SetLength(Result, Length(AFields));
  for I := 0 to Length(AFields) - 1 do
    Result[I] := TdxFieldValueConverter.ToValue(AFields[I].GetSafeVariant, AMemberInfo);
end;

function TdxADOLoader.ToVariants(const AFields: TArray<TdxADOField>): TArray<Variant>;
var
  I: Integer;
begin
  SetLength(Result, Length(AFields));
  for I := 0 to Length(AFields) - 1 do
    Result[I] := AFields[I].GetSafeVariant;
end;

{ TdxADOCommand }

constructor TdxADOCommand.Create(AConnection: TADOConnection; AQuery: TdxQuery);
begin
  inherited Create(AQuery);
  FCommandExecutor := TdxADODataSet.Create(nil);
  FCommandExecutor.Connection := AConnection;
  FCommand := TADOCommand.Create(nil);
  FCommand.Connection := AConnection;
  CommandText := AQuery.SQLText;
end;

destructor TdxADOCommand.Destroy;
begin
  FreeAndNil(FCommandExecutor);
  FreeAndNil(FCommand);
  inherited Destroy;
end;

function TdxADOCommand.ExecuteNonQuery: Integer;
begin
  FCommand.Execute(Result, EmptyParam);
end;

function TdxADOCommand.GetScalar: Variant;
var
  I: Integer;
begin
  try
    for I := 0 to FCommand.Parameters.Count - 1 do
      FCommandExecutor.Parameters[I].Value := FCommand.Parameters[I].Value;
    FCommandExecutor.Open;
    try
      if FCommandExecutor.FieldCount > 0 then
        Result := FCommandExecutor.Fields[0].Value
      else
        Result := -1;
    finally
      FCommandExecutor.Close;
    end;
  except
    Result := Null;
  end;
end;

procedure TdxADOCommand.PrepareParameters(AConvertParameter: TdxConvertParameter);
var
  I: Integer;
  AParameter: TParameter;
  AParameterValue: IdxOperandValue;
begin
  for I := 0 to FCommand.Parameters.Count - 1 do
  begin
    AParameter := FCommand.Parameters[I];
    AParameterValue := Query.ParameterValueByName(AParameter.Name);
    if AParameterValue <> nil then
      TdxADOConnectionVendor.AssignParameterValue(AParameter, AConvertParameter(AParameterValue.Value));
  end;
end;

procedure TdxADOCommand.SetCommandText(const Value: string);
begin
  if CommandText = Value then
    Exit;
  inherited SetCommandText(Value);
  if FCommandExecutor <> nil then
    FCommandExecutor.CommandText := Value;
  FCommand.CommandText := Value;
end;

{ TdxADOConnectionVendor.TODBCHelper }

class destructor TdxADOConnectionVendor.TODBCHelper.Destroy;
begin
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.DestructorStarted(UnitName, 'TdxADOConnectionVendor.TODBCHelper.Destroy', SysInit.HInstance);{$ENDIF}
  FreeLibrary(HLib);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.DestructorFinished(UnitName, 'TdxADOConnectionVendor.TODBCHelper.Destroy', SysInit.HInstance);{$ENDIF}
end;

class procedure TdxADOConnectionVendor.TODBCHelper.GetDSNList(AList: TStrings);
var
  ADSN, ADescription: array[0..255] of Char;
  AHenv, aHdbc: Pointer;
  ADSNLength, ADescriptionLength: SQLSMALLINT;
begin
  AList.Clear;
  if SQLAllocEnv(AHenv) <> SQL_SUCCESS then
    raise EdxODBCError.Create('Cannot allocate ODBC handle');

  if SQLAllocConnect(AHenv, aHdbc) <> SQL_SUCCESS then
    raise EdxODBCError.Create('Cannot allocate ODBC connection');

  if SQLDataSourcesW(AHenv, SQL_FETCH_FIRST, ADSN, SizeOf(ADSN), ADSNLength, ADescription, SizeOf(ADescription), ADescriptionLength) = SQL_SUCCESS then
    AList.Add(StrPas(ADSN) + '=' + StrPas(ADescription))
  else
    Exit;

  while SQLDataSourcesW(AHenv, SQL_FETCH_NEXT, ADSN, SizeOf(ADSN), ADSNLength, ADescription, SizeOf(ADescription), ADescriptionLength) = SQL_SUCCESS do
    AList.Add(StrPas(ADSN) + '=' + StrPas(ADescription))
end;

class function TdxADOConnectionVendor.TODBCHelper.GetSQLConfigDataSource: TSQLConfigDataSource;
begin
  if HLib = 0 then
    HLib := LoadLibrary('ODBCCP32');
  if not Assigned(FSQLConfigDataSource) then
    @FSQLConfigDataSource := GetProcAddress(HLib, 'SQLConfigDataSourceW');
  Result := @FSQLConfigDataSource;
end;

{ TdxADOConnectionVendor }

procedure TdxADOConnectionVendor.GetColumns(ATable: TdxDBTable; const ASchemaName, ATableName: string);
var
  ADataSet: TDataSet;
  AFieldSize: TField;
  AColumn: TdxDBColumn;
  I, N, ASize: Integer;
  AType: TdxDBColumnType;
  ASortedList: TArray<TdxDBColumn>;
begin
  ADataSet := GetSchema(TdxSchemaInfo.Columns, '', ASchemaName, ATableName);
  try
    AFieldSize := ADataSet.FieldByName('CHARACTER_MAXIMUM_LENGTH');
    SetLength(ASortedList, ADataSet.RecordCount);
    while not ADataSet.Eof do
    begin
      if AFieldSize.IsNull then
        ASize := 0
      else
        ASize := AFieldSize.AsInteger;
      AType := GetType(ADataSet.FieldByName('DATA_TYPE').AsInteger);
      AColumn := TdxDBColumn.Create(ADataSet.FieldByName('COLUMN_NAME').AsString, False, '', ASize, AType);
      AColumn.IsNullable := SameText(ADataSet.FieldByName('IS_NULLABLE').AsString, 'True');
      if SameText(ADataSet.FieldByName('COLUMN_HASDEFAULT').AsString, 'True') then
        AColumn.DefaultValue := ADataSet.FieldByName('COLUMN_DEFAULT').AsString;
      N := ADataSet.FieldByName('ORDINAL_POSITION').AsInteger;
      Assert(N <= Length(ASortedList));
      ASortedList[N - 1] := AColumn;
      ADataSet.Next;
    end;
    for I := 0 to Length(ASortedList) - 1 do
      ATable.AddColumn(ASortedList[I]);
  finally
    ADataSet.Free
  end;
end;

function TdxADOConnectionVendor.GetConnection: TADOConnection;
begin
  Result := TADOConnection(inherited Connection);
end;

function TdxADOConnectionVendor.GetConnectionString: string;
begin
  Result := Connection.ConnectionString;
end;

procedure TdxADOConnectionVendor.Rollback;
begin
  Connection.RollbackTrans;
end;

function TdxADOConnectionVendor.SelectData(AOwner: TComponent; AQuery: TdxQuery): TDataSet;
begin
  Result := CreateDataSet(AQuery, AOwner);
  if Result <> nil then
  try
    Result.Open;
  except
    FreeAndNil(Result);
    raise;
  end;
end;

class procedure TdxADOConnectionVendor.AssignParameterVariant(const AParameter: TParameter; const AValue: Variant);
var
  AVarType: TVarType;
begin
  AVarType := VarType(AValue);
  case AVarType of
    varBoolean:
      AParameter.DataType := ftBoolean;
    varByte:
      AParameter.DataType := ftByte;
    varUString:
      AParameter.DataType := ftWideString;
    varCurrency:
      AParameter.DataType := ftCurrency;
    varUInt64:
      AParameter.DataType := ftLargeint;
    varDouble, varSingle:
      if AParameter.DataType <> ftDateTime then
        AParameter.DataType := ftFloat;
    varDate:
      begin
        AParameter.DataType := ftDateTime;
        if TimeOf(AValue) > 0 then
          AParameter.ParameterObject.Type_ := adDBTimeStamp; 
      end;
  end;
  AParameter.Value := AValue;
end;

class procedure TdxADOConnectionVendor.AssignParameterValue(const AParameter: TParameter; const AValue: TValue);
var
  ALength: Integer;
  ASource: PByte;
  AStream: TStream;
begin
  if AValue.IsArray then
  begin
    ALength := AValue.GetArrayLength;
    if not (AParameter.DataType in [ftBytes, ftBlob, ftOraBlob, ftOraClob]) then
      AParameter.DataType := ftBlob;
    if ALength > 0 then
    begin
      ASource := PPointer(AValue.GetReferenceToRawData)^;
      AStream := TdxByteStream.Create(ASource, ALength);
      try
        AParameter.LoadFromStream(AStream, AParameter.DataType);
      finally
        AStream.Free;
      end;
    end
    else
      AParameter.Value := Null;
  end
  else
    AssignParameterVariant(AParameter, AValue.ToVariant);
end;

function TdxADOConnectionVendor.BeginTransaction: IdxDBTransaction;
begin
  Connection.BeginTrans;
  Result := Self;
end;

procedure TdxADOConnectionVendor.Commit;
begin
  Connection.CommitTrans;
end;

class function TdxADOConnectionVendor.GetConnectionType: TdxConnectionType;
begin
  Result := TdxConnectionTypes.ADO;
end;

function TdxADOConnectionVendor.CreateCommand(AQuery: TdxQuery): TdxCustomDBCommand;
begin
  Result := TdxADOCommand.Create(Connection, AQuery);
end;

function TdxADOConnectionVendor.CreateConnection(AProviderSQL: TdxSQLConnectionProvider;
  const ADatabaseName: string): TCustomConnection;
var
  AConnectionStrings: TStrings;
  AConnection: TADOConnection;
  ASB: TStringBuilder;
  S: string;
begin
  ProviderSQL := AProviderSQL;
  AConnection := TADOConnection.Create(nil);
  if ADatabaseName <> '' then
  begin
    AConnectionStrings := GetParsedConnectionString;
    try
      ASB := TStringBuilder.Create;
      try
        AConnectionStrings.Values[AProviderSQL.GetConnectionParameter(GetConnectionType, TdxConnectionParameter.Database)] := ADatabaseName;
        for S in AConnectionStrings do
          ASB.Append(S).Append(';');
        AConnection.LoginPrompt := Connection.LoginPrompt;
        AConnection.ConnectionString := ASB.ToString;
      finally
        ASB.Free;
      end
    finally
      AConnectionStrings.Free;
    end
  end
  else
    AConnection.ConnectionString := Connection.ConnectionString;
  Result := AConnection;
end;

function TdxADOConnectionVendor.CreateDataSet(AQuery: TdxQuery; AOwner: TComponent): TDataSet;
var
  I, AMaxStringSize: Integer;
  AParameter: TParameter;
  AResult: TdxADODataSet;
begin
  AResult := TdxADODataSet.Create(AOwner);
  AResult.Connection := Connection;
  AResult.CommandType := TCommandType.cmdText;
  AResult.CommandText := AQuery.SQLText;
  AResult.Prepared := True;
  AResult.CursorType := ctOpenForwardOnly;
  AMaxStringSize := TdxSQLConnectionProviderAccess(ProviderSQL).MaximumStringSize;
  for I := 0 to AResult.Parameters.Count - 1 do
  begin
    AParameter := AResult.Parameters[I];
    if AParameter.DataType in [ftString, ftWideString] then
    begin
      if paLong in AParameter.Attributes then
        if AParameter.Size > AMaxStringSize then
          AParameter.Size := AMaxStringSize; 
    end;
    AssignParameterValue(AParameter, AQuery.ParameterValueByName(AParameter.Name).Value);
  end;
  Result := AResult;
end;

function TdxADOConnectionVendor.GetExpectedDBEngine: TdxDBEngine;
type
  TServerType = TPair<string, TdxDBEngine>;

  function GetDBEngineType(const ADSNName: string; const AExpectedTypes: array of TServerType): TdxDBEngine;
  var
    AStrings: TStringList;
    ADSN: TServerType;
    ADSNDescription: string;
  begin
    AStrings := TStringList.Create;
    try
      TODBCHelper.GetDSNList(AStrings);
      ADSNDescription := AStrings.Values[ADSNName];
      for ADSN in AExpectedTypes do
       if ContainsText(ADSNDescription, ADSN.Key) then
         Exit(ADSN.Value);
      Result := TdxDBEngines.Unknown;
    finally
      AStrings.Free;
    end;
  end;

var
  ADSNName, AFileExtension: string;
  AConnectionString: TStrings;
begin
  if ContainsText(Connection.Provider, 'SQLOLEDB') then
    Result := TdxDBEngines.MSSQL
  else if ContainsText(Connection.ConnectionString, 'MySQL') then
    Result := TdxDBEngines.MySQL
  else if ContainsText(Connection.Provider, 'MSDASQL.1') then
    begin
      AConnectionString := GetParsedConnectionString;
      try
        ADSNName := AConnectionString.Values['Data Source'];
      finally
        AConnectionString.Free;
      end;
      Result := GetDBEngineType(ADSNName, [
        TServerType.Create('SQLite3', TdxDBEngines.SQLite),
        TServerType.Create('Firebird', TdxDBEngines.Firebird)
        ]);
    end
  else if ContainsText(Connection.Provider, 'Microsoft.Jet.OLEDB') or ContainsText(Connection.Provider, 'Microsoft.ACE.OLEDB') then
    begin
      AConnectionString := GetParsedConnectionString;
      try
        AFileExtension := TPath.GetExtension(AConnectionString.Values['Data Source']);
        if ContainsText(AFileExtension, 'mdb') or ContainsText(AFileExtension, 'accdb') then
          Result := TdxDBEngines.MSAccess
        else
          Result := TdxDBEngines.Unknown;
      finally
        AConnectionString.Free;
      end;
    end
  else if ContainsText(Connection.Provider, 'MSDAORA.1') or ContainsText(Connection.Provider, 'Oracle') then
    Result := TdxDBEngines.Oracle
  else
    Result := TdxDBEngines.Unknown;
end;

procedure TdxADOConnectionVendor.GetForeignKeys(ATable: TdxDBTable; const ASchemaName, ATableName: string);
var
  ADataSet: TDataSet;
  AForeignKey: TdxDBForeignKey;
  AForeignKeys: TStringList;
  AIndex: Integer;
begin
  ADataSet := GetSchema(TdxSchemaInfo.ForeignKeys, '', ASchemaName, ATableName);
  try
    AForeignKeys := TStringList.Create;
    try
      while not ADataSet.Eof do
      begin
        AIndex := AForeignKeys.IndexOf(ADataSet.FieldByName('FK_NAME').AsString);
        if AIndex < 0 then
        begin
          AForeignKey := TdxDBForeignKey.Create([ADataSet.FieldByName('FK_COLUMN_NAME').AsString],
            ADataSet.FieldByName('PK_TABLE_NAME').AsString,
            [ADataSet.FieldByName('PK_COLUMN_NAME').AsString]);
          ATable.ForeignKeys.Add(AForeignKey);
          AForeignKeys.AddObject(ADataSet.FieldByName('FK_NAME').AsString, AForeignKey);
        end
        else
        begin
          AForeignKey := TdxDBForeignKey(AForeignKeys.Objects[AIndex]);
          AForeignKey.Columns.Add(ADataSet.FieldByName('FK_COLUMN_NAME').AsString);
          AForeignKey.PrimaryKeyTableKeyColumns.Add(ADataSet.FieldByName('PK_COLUMN_NAME').AsString);
        end;
        ADataSet.Next;
      end;
    finally
      AForeignKeys.Free;
    end;
  finally
    ADataSet.Free;
  end;
end;

procedure TdxADOConnectionVendor.GetIndexes(ATable: TdxDBTable; const ASchemaName, ATableName: string);
var
  ADataSet: TDataSet;
  AIndex: TdxDBIndex;
begin
  ADataSet := GetSchema(TdxSchemaInfo.Indexes, '', ASchemaName, ATableName);
  try
    AIndex := nil;
    while not ADataSet.Eof do
    begin
      if (AIndex = nil) or (AIndex.Name <> ADataSet.FieldByName('INDEX_NAME').AsString) then
      begin
        AIndex := TdxDBIndex.Create(ADataSet.FieldByName('INDEX_NAME').AsString, [ADataSet.FieldByName('COLUMN_NAME').AsString],
          ADataSet.FieldByName('UNIQUE').AsBoolean);
        ATable.Indexes.Add(AIndex);
      end
      else
        AIndex.Columns.Add(ADataSet.FieldByName('COLUMN_NAME').AsString);
      ADataSet.Next;
    end;
  finally
    ADataSet.Free;
  end;
end;

procedure TdxADOConnectionVendor.GetPrimaryKey(ATable: TdxDBTable; const ASchemaName, ATableName: string);
var
  ADataSet: TDataSet;
  AADODataSet: TADODataSet;
  AColumns: TList<string>;
  AColumn: TdxDBColumn;
  AColumnNameField: TField;
  I: Integer;
begin
  AColumns := TList<string>.Create;
  try
    ADataSet := GetSchema(TdxSchemaInfo.PrimaryKeyFields, '', ASchemaName, ATableName);
    try
      AColumnNameField := ADataSet.FieldByName('COLUMN_NAME');
      while not ADataSet.Eof do
      begin
        AColumns.Add(AColumnNameField.AsString);
        ADataSet.Next;
      end;
    finally
      ADataSet.Free;
    end;
    ATable.PrimaryKey := TdxDBPrimaryKey.Create(AColumns);
    for I := 0 to AColumns.Count - 1 do
    begin
      AColumn := ATable.GetColumn(AColumns[I]);
      if AColumn <> nil then
        AColumn.IsKey := True;
    end;
    if (ATable.PrimaryKey <> nil) and (ATable.PrimaryKey.Columns.Count = 1) then
    begin
      AADODataSet := TADODataSet.Create(nil);
      try
        AADODataSet.Connection := Connection;
        AADODataSet.CommandText := 'select [' + ATable.PrimaryKey.Columns[0] + '] from [' +
          ATableName + ']';
        AADODataSet.CursorType := ctOpenForwardOnly;
        AADODataSet.Open;
        if AADODataSet.Fields[0].AutoGenerateValue = TAutoRefreshFlag.arAutoInc then
          ATable.GetColumn(ATable.PrimaryKey.Columns[0]).IsIdentity := True;
        AADODataSet.Close;
      finally
        AADODataSet.Free;
      end;
    end;
  finally
    AColumns.Free;
  end;
end;

function TdxADOConnectionVendor.GetSchema(ASchemaInfo: TdxSchemaInfo; const ACatalogName, ASchemaName, ATableName,
  AObjectName: string): TDataSet;
var
  AADODataSet: TADODataSet;
  V, ACatalog, ASchema, ATable, AObject: Variant;
begin
  AADODataSet := TADODataSet.Create(nil);
  AADODataSet.Connection := Connection;
  if ACatalogName <> '' then
    ACatalog := ACatalogName
  else
    ACatalog := Unassigned;
  if ASchemaName <> '' then
    ASchema := ASchemaName
  else
    ASchema := Unassigned;
  if ATableName <> '' then
    ATable := ATableName
  else
    ATable := Unassigned;
  if AObjectName <> '' then
    AObject := AObjectName
  else
    AObject := Unassigned;
  case ASchemaInfo of
    TdxSchemaInfo.Tables:
      V := VarArrayOf([ACatalog, ASchema, ATable, 'TABLE']);
    TdxSchemaInfo.ForeignKeys:
      V := VarArrayOf([Unassigned, Unassigned, Unassigned, ACatalog, ASchema, ATable]);
    else
      V := VarArrayOf([ACatalog, ASchema, ATable]);
  end;
  Connection.OpenSchema(SchemaInfo[ASchemaInfo], V, EmptyParam, AADODataSet);
  AADODataSet.Open;
  Result := AADODataSet;
end;

procedure TdxADOConnectionVendor.GetTableSchema(ATable: TdxDBTable; ACheckIndexes, ACheckForeignKeys: Boolean);
var
  ASchemaName, ATableName: string;
begin
  ASchemaName := ProviderSQL.ComposeSafeSchemaName(ATable.Name);
  ATableName := ProviderSQL.ComposeSafeTableName(ATable.Name);
  GetColumns(ATable, ASchemaName, ATableName);
  GetPrimaryKey(ATable, ASchemaName, ATableName);
  if ACheckIndexes then
    GetIndexes(ATable, ASchemaName, ATableName);
  if ACheckForeignKeys then
    GetForeignKeys(ATable, ASchemaName, ATableName);
end;

class function TdxADOConnectionVendor.GetType(AType: TOleEnum): TdxDBColumnType;
begin
  case AType of
    adInteger:
      Result := TdxDBColumnType.Int32;
    adVarBinary,
    adBinary:
      Result := TdxDBColumnType.ByteArray;
    adVarWChar,
    adLongVarWChar,
    adWChar,
    adChar:
      Result := TdxDBColumnType.String;
    adBoolean:
      Result := TdxDBColumnType.Boolean;
    adSmallInt,
    adUnsignedTinyInt:
      Result := TdxDBColumnType.Int16;
    adDecimal,
    adCurrency:
      Result := TdxDBColumnType.Decimal;
    adSingle:
      Result := TdxDBColumnType.Single;
    adDouble:
      Result := TdxDBColumnType.Double;
    adDate:
      Result := TdxDBColumnType.DateTime;
    adGuid:
      Result := TdxDBColumnType.Guid;
    adNumeric:
      Result := TdxDBColumnType.Int64;
    else
      Result := TdxDBColumnType.Unknown;
  end;
end;

function TdxADOConnectionVendor.ExecuteScalar(AConnection: TCustomConnection; const ACommandText: string): Variant;
var
  AResult: _Recordset;
begin
  AResult := (AConnection as TADOConnection).Execute(ACommandText);
  Result := AResult.Fields[0].Value;
end;

function TdxADOConnectionVendor.Execute(const ACommandText: string): Integer;
begin
  Connection.Execute(ACommandText, Result);
end;

{ TdxEMFADODataProvider }

function TdxEMFADODataProvider.GetConnection: TADOConnection;
begin
  Result := TADOConnection(inherited Connection);
end;

function TdxEMFADODataProvider.GetConnectionVendor: TdxADOConnectionVendor;
begin
  Result := TdxADOConnectionVendor(inherited ConnectionVendor);
end;


procedure TdxEMFADODataProvider.SetConnection(const Value: TADOConnection);
begin
  inherited Connection := Value;
end;

procedure TdxEMFADODataProvider.CheckConnectAndCreate;
begin
  if Connection = nil then
    raise EArgumentNilException.CreateFmt(sdxConnectionIsNull, [Name]);
  if Connection.Connected then
    Exit;
  try
    Connection.Open;
  except
    on E: Exception do
    begin
      if CanCreateDatabase and CreateDatabase then
      begin
        Connection.Open;
      end
      else
        raise EdxUnableToOpenDatabaseException.Create(E.Message);
    end;
  end;
end;

function TdxEMFADODataProvider.CreateConnectionVendor: TdxCustomConnectionVendor;
begin
  Result := TdxADOConnectionVendor.Create(Connection);
end;

function TdxEMFADODataProvider.CreateDatabase: Boolean;
var
  ADatabaseName: string;
begin
  CheckSQLProvider;
  ADatabaseName := ConnectionVendor.GetDatabaseName(SQLConnectionProvider);
  try
    SQLConnectionProvider.CreateDatabase(ADatabaseName, []);
    Result := True;
  except
    Result := False;
  end;
end;

function TdxEMFADODataProvider.CreateLoader(ASession: TdxEMFCustomSession; AConnectionVendor: TdxCustomConnectionVendor; AQuery: TdxQuery;
  AEntityInfo: TdxEntityInfo; APredicate: TdxPredicate = nil): TdxDataLoader;
var
  ALoader: TdxADOLoader;
begin
  CheckSQLProvider;
  Assert(AEntityInfo <> nil);
  ALoader := TdxADOLoader.Create(ASession, AConnectionVendor.CreateDataSet(AQuery));
  ALoader.EntityInfo := AEntityInfo;
  ALoader.Predicate := APredicate;
  Result := ALoader;
end;


{ TdxADODataSet }

procedure TdxADODataSet.InternalInitFieldDefs;
var
  I: Integer;
begin
  inherited;
  for I := 0 to FieldDefs.Count - 1 do
  begin
    if (FieldDefs[I].DataType = ftInteger) and (Recordset.Fields[I].Type_ = adUnsignedInt) then
      FieldDefs[I].DataType := ftLargeInt; 
  end;
end;

end.

