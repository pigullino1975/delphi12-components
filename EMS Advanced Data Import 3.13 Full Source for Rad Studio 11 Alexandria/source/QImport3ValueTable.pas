unit QImport3ValueTable;

{$I QImport3VerCtrl.Inc}

interface

uses
  {$IFDEF VCL16}
    System.Classes,
    System.SysUtils,
    Winapi.Windows,
  {$ELSE}
    Classes,
    SysUtils,
    Windows,
  {$ENDIF}
  QImport3StrTypes,
  QImport3Common,
  QImport3StrIDs;

type
  TQImport3ValueTable = class
  private
    FColumns: array of Integer;
    FPositionStream, FValueStream: TStream;
    procedure StreamFree(AStream: TStream);
    function CalcStreamPosition(AColumnIndex, ARowIndex: Integer): Int64;
  protected
    function GetColumnCount: Integer;
    procedure SetColumnCount(ANewLength: Integer);
    function GetRowCount(AColumnIndex: Integer): Integer;
    procedure SetRowCount(AColumnIndex, ANewLength: Integer);
    function GetCells(AColumnIndex, ARowIndex: Integer): qiString;
    procedure SetCells(AColumnIndex, ARowIndex: Integer; const AValue: qiString);
  public
    constructor Create(APositionStream, AValueStream: TStream);
    destructor Destroy; override;
    procedure Clear;
    property ColumnCount: Integer read GetColumnCount write SetColumnCount;
    property RowCount[AColumnIndex: Integer]: Integer read GetRowCount write SetRowCount;
    property Cells[AColumnIndex, ARowIndex: Integer]: qiString read GetCells write SetCells; default;
  end;

implementation

type
  PPositionStreamEntry = ^TPositionStreamEntry;
  TPositionStreamEntry = packed record
    Pos: Int64;
    Length: Integer;
  end;

const
  MAX_COLUMNS_COUNT = 256;

{ TQImport3ValueTable }

function TQImport3ValueTable.CalcStreamPosition(AColumnIndex, ARowIndex: Integer): Int64;
begin
  Result := (ARowIndex * MAX_COLUMNS_COUNT + AColumnIndex) * SizeOf(TPositionStreamEntry);
end;

procedure TQImport3ValueTable.Clear;
begin
  FPositionStream.Size := 0;
  FValueStream.Size := 0;
  SetLength(FColumns, 0);
end;

constructor TQImport3ValueTable.Create(APositionStream, AValueStream: TStream);
begin
  inherited Create;
  { TODO -ogmv -cTQImport3ValueTable :create APositionStream & AValueStream here }
  FPositionStream := APositionStream;
  FValueStream := AValueStream;
end;

destructor TQImport3ValueTable.Destroy;
begin
  StreamFree(FPositionStream);
  StreamFree(FValueStream);
  inherited;
end;

procedure TQImport3ValueTable.StreamFree(AStream: TStream);
var
  FileName: string;
begin
  { TODO -ogmv -cTQImport3ValueTable :TFileStream.FileName since D2006 }
{$IFDEF VCL10}
  if AStream is TFileStream then
    FileName := TFileStream(AStream).FileName;
{$ENDIF}
  FreeAndNil(AStream);
  if (Length(FileName) > 0) and FileExists(FileName) then
    {$IFDEF VCL16}System.{$ENDIF}SysUtils.DeleteFile(FileName);
end;

function TQImport3ValueTable.GetCells(AColumnIndex, ARowIndex: Integer): qiString;
var
  StreamPos: Int64;
  Entry: TPositionStreamEntry;
  Buff: array[Word] of qiChar;
begin
  StreamPos := CalcStreamPosition(AColumnIndex, ARowIndex);
  if StreamPos >= FPositionStream.Size then
  begin
    Result := '';
    Exit;
  end;

  FPositionStream.Position := StreamPos;
  FillChar(Entry, SizeOf(TPositionStreamEntry), 0);
  FPositionStream.Read(Entry, SizeOf(TPositionStreamEntry));
  if (Entry.Pos < Low(Longint)) or (Entry.Pos > High(Longint)) then
    FillChar(Entry, SizeOf(TPositionStreamEntry), 0);

  FValueStream.Position := Entry.Pos;
  FillChar(Buff, Sizeof(Buff), 0);
  FValueStream.Read(Pointer(@Buff[0])^, Entry.Length);
  Result := Buff;
end;

function TQImport3ValueTable.GetColumnCount: Integer;
begin
  Result := Length(FColumns);
end;

function TQImport3ValueTable.GetRowCount(AColumnIndex: Integer): Integer;
begin
  if (AColumnIndex < 0) or (AColumnIndex >= ColumnCount) then
    raise EQImportError.CreateFmt(QImportLoadStr(QIE_ColumnIndexError), [AColumnIndex]);
  Result := FColumns[AColumnIndex];
end;

procedure TQImport3ValueTable.SetCells(AColumnIndex, ARowIndex: Integer; const AValue: qiString);
var
  StreamPos: Int64;
  Buff: qiString;
  Entry: TPositionStreamEntry;
begin
  Buff := GetCells(AColumnIndex, ARowIndex);
  if Buff = AValue then Exit;
  
  Buff := AValue;
  FValueStream.Seek(0, soEnd);
  Entry.Pos := FValueStream.Position;
  Entry.Length := Length(Buff) * SizeOf(qiChar);
  FValueStream.Write(Buff[1], Entry.Length);

  StreamPos := CalcStreamPosition(AColumnIndex, ARowIndex);
  if FPositionStream.Size < StreamPos then
    FPositionStream.Size := StreamPos;
  FPositionStream.Position := StreamPos;
  FPositionStream.Write(Entry, SizeOf(TPositionStreamEntry));
end;

procedure TQImport3ValueTable.SetColumnCount(ANewLength: Integer);
begin
  if ANewLength = 0 then
    Clear
  else if ANewLength > MAX_COLUMNS_COUNT then
    raise EQImportError.CreateFmt(QImportLoadStr(QIE_MaxColumnsError), [MAX_COLUMNS_COUNT])
  else
    SetLength(FColumns, ANewLength);
end;

procedure TQImport3ValueTable.SetRowCount(AColumnIndex, ANewLength: Integer);
begin
  if (AColumnIndex < 0) or (AColumnIndex >= ColumnCount) then
    raise EQImportError.CreateFmt(QImportLoadStr(QIE_ColumnIndexError), [AColumnIndex]);
  FColumns[AColumnIndex] := ANewLength
end;

end.
