unit QImport3ASCII;

{$I QImport3VerCtrl.Inc}

interface

uses
  {$IFDEF VCL16}
    {$IFDEF QI_UNICODE}
      System.WideStrings,
    {$ENDIF}
    Winapi.Windows,
    System.Classes,
    System.SysUtils,
    System.IniFiles,
    Data.DB,
    System.StrUtils,
  {$ELSE}
    {$IFDEF QI_UNICODE}
      {$IFDEF VCL10}
        WideStrings,
      {$ELSE}
        QImport3WideStrings,
      {$ENDIF}
    {$ENDIF}
    Windows,
    Classes,
    SysUtils,
    IniFiles,
    DB,
    {$IFDEF VCL7}
      StrUtils,
    {$ENDIF}
  {$ENDIF}
  QImport3,
  QImport3StrTypes,
  QImport3CSVClasses,
  QImport3HashTable,
  QImport3Encoding,
  QImport3StrIDs,
  QImport3Common,
  QImport3WideStrUtils;

type
  TQImport3ASCII = class(TQImport3)
  private
    FComma: AnsiChar;
    FQuote: AnsiChar;
    FEncoding: TQICharsetType;
    FCounter: Integer;
    FBuffStr: qiString;
    FColumns: TqiStrings;
    FCSVReader: TCSVFileReader;
    FColumnsHash: TQImportHashTable;
    FPosDataHash: TQImportHashTable;
    function HasComma: Boolean;
    procedure FillColumnsHash(const Str: qiString);
    procedure ClearColumnsHash;
    procedure ClearPosDataHash;
  protected
    procedure CheckProperties; override;
    procedure StartImport; override;
    function CheckCondition: Boolean; override;
    function Skip: Boolean; override;
    procedure FillImportRow; override;
    function ImportData: TQImportResult; override;
    procedure ChangeCondition; override;
    procedure FinishImport; override;
    procedure DoLoadConfiguration(IniFile: TIniFile); override;
    procedure DoSaveConfiguration(IniFile: TIniFile); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property FileName;
    property SkipFirstRows default 0;
    property Comma: AnsiChar read FComma write FComma;
    property Quote: AnsiChar read FQuote write FQuote;
    property Encoding: TQICharsetType read FEncoding write FEncoding default ctWinDefined;
  end;

implementation

type
  PPosData = ^TPosData;
  TPosData = record
    Pos: Integer;
    Len: Integer;
  end;

  PStrData = ^TStrData;
  TStrData = record
    Str: qiString;
  end;

{ TQImport3ASCII }

constructor TQImport3ASCII.Create(AOwner: TComponent);
begin
  inherited;
  SkipFirstRows := 0;
  FComma := AnsiChar(GetListSeparator);
  FQuote := '"';
  FEncoding := ctWinDefined;
end;

procedure TQImport3ASCII.CheckProperties;
var
  I, J: Integer;
begin
  inherited CheckProperties;
  if HasComma then // example field=2
  begin
    for I := 0 to Map.Count - 1 do
      try
        StrToInt(Map.Values[Map.Names[I]]);
      except
        on E: EConvertError do
          raise EQImportError.Create(QImportLoadStr(QIE_MapMissing));
      end;
  end
  else
  begin // example: field=3;5
    for I := 0 to Map.Count - 1 do
    begin
      J := Pos(';', Map.Values[Map.Names[I]]);
      if J = 0 then
        raise EQImportError.Create(QImportLoadStr(QIE_MapMissing))
      else
      begin
        try
          StrToInt(Copy(Map.Values[Map.Names[I]], 1, J - 1));
        except
          on E:EConvertError do
            raise EQImportError.Create(QImportLoadStr(QIE_MapMissing));
        end;
        try
          StrToInt(Copy(Map.Values[Map.Names[I]], J + 1, Length(Map.Values[Map.Names[I]]) - J));
        except
          on E:EConvertError do
            raise EQImportError.Create(QImportLoadStr(QIE_MapMissing));
        end;
      end;
    end;
  end
end;

procedure TQImport3ASCII.StartImport;
var
  I, K: Integer;
  MapValue: string;
  Data: Pointer;
  PosData: PPosData;
begin
  FCSVReader := TCSVFileReader.Create;
  FCSVReader.SetFile(FileName);
  FCSVReader.ColumnSeparatorCharCode := Ord(FComma);
  FCSVReader.QuoteCharCode := Ord(FQuote);
  FCSVReader.IgnoreEmptyLines := True;
  FCSVReader.Charset := FEncoding;
  FCSVReader.IgnoreSpecialCharacters := True;
  FCSVReader.Open;

  if HasComma then
    FColumns := TqiStringList.Create
  else
  begin
    FColumnsHash := TQImportHashTable.Create(Map.Count);
    FPosDataHash := TQImportHashTable.Create(Map.Count);

    for I := 0 to Map.Count - 1 do
    begin
      if FImportRow.MapNameIdxHash.TryGetValue(Map.Names[I], Data) then
      begin
        K := Integer(Data);
        {$IFDEF VCL7}
        MapValue := Map.ValueFromIndex[K];
        {$ELSE}
        MapValue := Map.Values[Map.Names[K]];
        {$ENDIF}
        New(PosData);
        PosData^.Pos := StrToIntDef(Copy(MapValue, 1, Pos(';', MapValue) - 1), 0);
        PosData^.Len := StrToIntDef(Copy(MapValue, Pos(';', MapValue) + 1, Length(MapValue)), 0);
        FPosDataHash.Add(Map.Names[I], PosData);
      end;
    end;
  end;

  FCounter := 0;
end;

function TQImport3ASCII.CheckCondition: Boolean;
begin
  Result := not FCSVReader.Eof;
end;

function TQImport3ASCII.Skip: Boolean;

  function BuffEmpty: Boolean;
  begin
    if HasComma then
      Result := FColumns.Count = 0
    else
      Result := Length(Trim(FBuffStr)) = 0;
  end;

var
  I: Integer;
begin
  if HasComma then
  begin
    FColumns.Clear;
    for I := 0 to FCSVReader.ColumnCount - 1 do
      FColumns.Add(FCSVReader.Columns[I].Value);
  end
  else
    FBuffStr := FCSVReader.CurrentLine;

  FCSVReader.Next;

  Result := (SkipFirstRows > 0) and (FCounter < SkipFirstRows);
  if Result then
    Inc(FCounter);
  Result := Result or BuffEmpty;
end;

procedure TQImport3ASCII.FillImportRow;
var
  J, K: Integer;
  Data: Pointer;
  StrData: PStrData;
  ColumnValue: qiString;
begin
  FImportRow.ClearValues;

  if not HasComma then
  begin
    ClearColumnsHash;
    FillColumnsHash(FBuffStr);
  end;

  RowIsEmpty := True;
  for J := 0 to FImportRow.Count - 1 do
  begin
    if FImportRow.MapNameIdxHash.TryGetValue(FImportRow[J].Name, Data) then
    begin
      K := Integer(Data);
      try
        ColumnValue := '';
        if HasComma then
        begin
          {$IFDEF VCL7}
            ColumnValue := FColumns[StrToInt(Map.ValueFromIndex[K]) - 1];
          {$ELSE}
            ColumnValue := FColumns[StrToInt(Map.Values[Map.Names[K]]) - 1];
          {$ENDIF}
        end
        else begin
          StrData := FColumnsHash.GetValue(FImportRow[J].Name);
          if StrData <> nil then
            ColumnValue := StrData^.Str;
        end;
      except
        ColumnValue := '';
      end;
      if AutoTrimValue then
        ColumnValue := Trim(ColumnValue);
      RowIsEmpty := RowIsEmpty and (ColumnValue = '');
      FImportRow.SetValue(Map.Names[K], ColumnValue, IsBinary(FImportRow[J].ColumnIndex));
    end;
    DoUserDataFormat(FImportRow[J]);
  end;
end;

function TQImport3ASCII.ImportData: TQImportResult;
begin
  Result := qirOk;
  try
    try
      if Canceled and not CanContinue then
      begin
        Result := qirBreak;
        Exit;
      end;

      DataManipulation;

    except
      on E:Exception do
      begin
        try
          DestinationCancel;
        except
        end;
        DoImportError(E);
        Result := qirContinue;
        Exit;
      end;
    end;
  finally
    if (not IsCSV) and (CommitRecCount > 0) and not CommitAfterDone and
       (
        ((ImportedRecs + ErrorRecs) > 0)
        and ((ImportedRecs + ErrorRecs) mod CommitRecCount = 0)
       )
    then
      DoNeedCommit;
    if (ImportRecCount > 0) and
       ((ImportedRecs + ErrorRecs) mod ImportRecCount = 0) then
      Result := qirBreak;
  end;
end;

procedure TQImport3ASCII.ChangeCondition;
begin
end;

procedure TQImport3ASCII.FinishImport;
begin
  try
    if not Canceled and not IsCSV then
    begin
      if CommitAfterDone then
        DoNeedCommit
      else if (CommitRecCount > 0) and ((ImportedRecs + ErrorRecs) mod CommitRecCount > 0) then
        DoNeedCommit;
    end;
  finally
    if Assigned(FColumns) then
    begin
      FColumns.Clear;
      FColumns.Free;
      FColumns := nil;
    end;

    if Assigned(FCSVReader) then
    begin
      FCSVReader.Close;
      FCSVReader.Free;
      FCSVReader := nil;
    end;

    if Assigned(FColumnsHash) then
    begin
      ClearColumnsHash;
      FColumnsHash.Free;
      FColumnsHash := nil;
    end;

    if Assigned(FPosDataHash) then
    begin
      ClearPosDataHash;
      FPosDataHash.Free;
      FPosDataHash := nil;
    end;
  end;
end;

procedure TQImport3ASCII.DoLoadConfiguration(IniFile: TIniFile);
begin
  inherited;
  with IniFile do
  begin
    SkipFirstRows := ReadInteger(ASCII_OPTIONS, ASCII_SKIP_LINES, SkipFirstRows);
    Encoding := TQICharsetType(ReadInteger(ASCII_OPTIONS, ASCII_ENCODING, Integer(Encoding)));
    Comma := Str2Char(ReadString(ASCII_OPTIONS, ASCII_COMMA,
      Char2Str(Comma)), Comma);
    Quote := Str2Char(ReadString(ASCII_OPTIONS, ASCII_QUOTE,
      Char2Str( Quote)), Quote);
  end;
end;

procedure TQImport3ASCII.DoSaveConfiguration(IniFile: TIniFile);
begin
  inherited;
  with IniFile do
  begin
    WriteInteger(ASCII_OPTIONS, ASCII_SKIP_LINES, SkipFirstRows);
    WriteInteger(ASCII_OPTIONS, ASCII_ENCODING, Integer(Encoding));
    WriteString(ASCII_OPTIONS, ASCII_COMMA, Char2Str(Comma));
    WriteString(ASCII_OPTIONS, ASCII_QUOTE, Char2Str(Quote));
  end;
end;

function TQImport3ASCII.HasComma: Boolean;
begin
  Result := FComma <> #0;
end;

procedure TQImport3ASCII.FillColumnsHash(const Str: qiString);
var
  P, L, I: Integer;
  Data: Pointer;
  StrData: PStrData;
begin 
  for I := 0 to Map.Count - 1 do
  begin
    if FPosDataHash.TryGetValue(Map.Names[I], Data) then
    begin
      P := PPosData(Data)^.Pos;
      L := PPosData(Data)^.Len;
      New(StrData);
      StrData^.Str := Copy(Str, P + 1, L);
      FColumnsHash.Add(Map.Names[I], StrData);
    end;
  end;
end;

procedure TQImport3ASCII.ClearColumnsHash;
var
  i: Integer;
  key: string;
  val: Pointer;
  data: PStrData;
begin
  for i := 0 to Map.Count - 1 do
  begin
    key := Map.Names[I];
    if FColumnsHash.TryGetValue(key, val) then
    begin
      data := val;
      FColumnsHash.Remove(key);
      Finalize(data^.Str);
      Dispose(data);
    end;
  end;
end;

procedure TQImport3ASCII.ClearPosDataHash;
var
  i: Integer;
  key: string;
  val: Pointer;
  data: PPosData;
begin
  for i := 0 to Map.Count - 1 do
  begin
    key := Map.Names[I];
    if FPosDataHash.TryGetValue(key, val) then
    begin
      data := val;
      FPosDataHash.Remove(key);
      Dispose(data);
    end;
  end;
end;

end.
