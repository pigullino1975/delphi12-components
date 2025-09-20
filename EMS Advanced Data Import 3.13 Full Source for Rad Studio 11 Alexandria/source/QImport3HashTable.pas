unit QImport3HashTable;

{$I QImport3VerCtrl.Inc}

interface

uses
  {$IFDEF RTLGENERICS}
    {$IFDEF VCL16}
      System.Generics.Collections,
    {$ELSE}
      Generics.Collections,
    {$ENDIF}
  {$ELSE}
    QImport3EZDSLHsh,
  {$ENDIF}
  {$IFDEF VCL16}
    System.Classes;
  {$ELSE}
    Classes;
  {$ENDIF}

type
  TQImportHashTable = class
  private
    FMap: {$IFDEF RTLGENERICS}TDictionary<string, Pointer>{$ELSE}THashTable{$ENDIF};
  public
    constructor Create(ACapacity: Integer = 0);
    destructor Destroy; override;
    procedure Add(const Key: string; const Value: Pointer);
    procedure Remove(const Key: string);
    procedure Clear;
    function GetValue(const Key: string): Pointer;
    function TryGetValue(const Key: string; out Value: Pointer): Boolean;
    function GetKeys: TStrings;
  end;

implementation

{ TQImportHashTable }

constructor TQImportHashTable.Create(ACapacity: Integer = 0);
begin
  {$IFDEF RTLGENERICS}
  FMap := TDictionary<string, Pointer>.Create(ACapacity);
  {$ELSE}
  FMap := THashTable.Create(False);
  if ACapacity > 0 then
    FMap.TableSize := ACapacity;
  {$ENDIF}
end;

destructor TQImportHashTable.Destroy;
begin
  FMap.Free;
end;

procedure TQImportHashTable.Add(const Key: string; const Value: Pointer);
begin
  {$IFDEF RTLGENERICS}
  FMap.Add(Key, Value);
  {$ELSE}
  FMap.Insert(Key, Value);
  {$ENDIF}
end;

procedure TQImportHashTable.Remove(const Key: string);
begin
  {$IFDEF RTLGENERICS}
  FMap.Remove(Key);
  {$ELSE}
  FMap.Delete(Key);
  {$ENDIF}
end;

procedure TQImportHashTable.Clear;
begin
  {$IFDEF RTLGENERICS}
  FMap.Clear;
  {$ELSE}
  FMap.Empty;
  {$ENDIF}
end;

function TQImportHashTable.GetValue(const Key: string): Pointer;
begin
  {$IFDEF RTLGENERICS}
  Result := FMap[Key];
  {$ELSE}
  Result := FMap.Examine(Key);
  {$ENDIF}
end;

function TQImportHashTable.TryGetValue(const Key: string; out Value: Pointer): Boolean;
begin
  {$IFDEF RTLGENERICS}
  Result := FMap.TryGetValue(Key, Value);
  {$ELSE}
  Result := FMap.Search(Key, Value);
  {$ENDIF}
end;

function TQImportHashTable.GetKeys: TStrings;
{$IFDEF RTLGENERICS}
var
  key: string;
{$ENDIF}
begin
  {$IFDEF RTLGENERICS}
  Result := TStringList.Create;
  for key in FMap.Keys do
    Result.Add(key);
  {$ELSE}
  Result := FMap.GetKeys;
  {$ENDIF}
end;

end.
