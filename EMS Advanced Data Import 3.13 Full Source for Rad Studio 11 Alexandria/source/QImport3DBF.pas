unit QImport3DBF;

{$I QImport3VerCtrl.Inc}

interface

uses
{$IFDEF VCL16}
  System.Classes,
  System.IniFiles,
  Winapi.Windows,
  Data.Db,
  System.SysUtils,
{$ELSE}
  Classes,
  IniFiles,
  Windows,
  Db,
  SysUtils,
{$ENDIF}
  QImport3,
  QImport3DBFFile,
  QImport3Encoding,
  QImport3StrTypes,
  QImport3HashTable,
  QImport3Common;

type
  TDBFCharSet = (
    dcsNone, dcsISO8859_1, dcsArmscii8, dcsAscii, dcsCp850, dcsCp852, dcsCp866,
    dcsCp1250, dcsCp1251, dcsCp1256, dcsCp1257, dcsDec8, dcsGeostd8, dcsISO8859_7,
    dcsISO8859_8, dcsHp8, dcsKeybcs2, dcsKoi8r, dcsKoi8u, dcsISO8859_2, dcsISO8859_9,
    dcsISO8859_13, dcsMacce, dcsMacroman, dcsSwe7, dcsUtf8, {dcsUtf16, dcsUtf32,}
    dcsISO8859_3, dcsISO8859_4, dcsISO8859_10, dcsISO8859_14, dcsISO8859_5, dcsISO8859_6,
    dcsCp1026, dcsCp1254, dcsCp1255, dcsCp1258, dcsCp437, dcsCp500, dcsCp737, dcsCp855,
    dcsCp856, dcsCp857, dcsCp860, dcsCp862, dcsCp863, dcsCp864, dcsCp865, dcsCp869,
    dcsCp874, dcsCp875, dcsIceland,
    dcsBig5, dcsKSC5601, dcsEUC, dcsGB2312, dcsSJIS_0208, dcsLatin9, dcsLatin13,
    dcsCp1252, dcsCp1253, dcsCp775, dcsCp858);

  TQImport3DBF = class(TQImport3)
  private
    FDBF: TDBFRead;
    FSourceFieldsHash: TQImportHashTable;
    FSkipDeleted: boolean;
    FCharSet: TDBFCharSet;
    FValueBuffer: TBytes;
    FEncoding: TQIEncoding;
  protected
    function AllowImportRowComplete: Boolean; override;
  protected
    procedure StartImport; override;
    function CheckCondition: boolean; override;
    function Skip: boolean; override;
    procedure FillImportRow; override;
    function ImportData: TQImportResult; override;
    procedure ChangeCondition; override;
    procedure FinishImport; override;
    procedure DoBeforeImport; override;
    procedure DoAfterImport; override;
    procedure DoLoadConfiguration(IniFile: TIniFile); override;
    procedure DoSaveConfiguration(IniFile: TIniFile); override;
  public
    constructor Create(AOwner: TComponent); override;
    function CreateEncoding: TQIEncoding;
    function DBFStrToDateTime(const Str: string): TDateTime;
  published
    property SkipDeleted: boolean read FSkipDeleted write FSkipDeleted default true;
    property SkipFirstRows default 0;
    property CharSet: TDBFCharSet read FCharSet write FCharSet default dcsNone;
    property FileName;
  end;

  procedure FillDBFCharSetList(List: TStrings);

implementation

const
  cQICharsetTypeMAP: array[TDBFCharSet] of TQICharsetType =
    (
      ctWinDefined,   //dcsNone
      ctISO8859_1,    //dcsISO8859_1
      ctArmscii8,     //dcsArmscii8
      ctAscii,        //dcsAscii
      ctCp850,        //dcsCp850
      ctCp852,        //dcsCp852
      ctCp866,        //dcsCp866
      ctCp1250,       //dcsCp1250
      ctCp1251,       //dcsCp1251
      ctCp1256,       //dcsCp1256
      ctCp1257,       //dcsCp1257
      ctDec8,         //dcsDec8
      ctGeostd8,      //dcsGeostd8
      ctISO8859_7,    //dcsISO8859_7
      ctISO8859_8,    //dcsISO8859_8
      ctHp8,          //dcsHp8
      ctKeybcs2,      //dcsKeybcs2
      ctKoi8r,        //dcsKoi8r
      ctKoi8u,        //dcsKoi8u
      ctISO8859_2,    //dcsISO8859_2
      ctISO8859_9,    //dcsISO8859_9
      ctISO8859_13,   //dcsISO8859_13
      ctMacce,        //dcsMacce
      ctMacroman,     //dcsMacroman
      ctSwe7,         //dcsSwe7
      ctUtf8,         //dcsUtf8
      {1200,}         //dcsUtf16
      {12000,}        //dcsUtf32
      ctISO8859_3,    //dcsISO8859_3
      ctISO8859_4,    //dcsISO8859_4
      ctISO8859_10,   //dcsISO8859_10
      ctISO8859_14,   //dcsISO8859_14
      ctISO8859_5,    //dcsISO8859_5
      ctISO8859_6,    //dcsISO8859_6
      ctCp1026,       //dcsCp1026
      ctCp1254,       //dcsCp1254
      ctCp1255,       //dcsCp1255
      ctCp1258,       //dcsCp1258
      ctCp437,        //dcsCp437
      ctCp500,        //dcsCp500
      ctCp737,        //dcsCp737
      ctCp855,        //dcsCp855
      ctCp856,        //dcsCp856
      ctCp857,        //dcsCp857
      ctCp860,        //dcsCp860
      ctCp862,        //dcsCp862
      ctCp863,        //dcsCp863
      ctCp864,        //dcsCp864
      ctCp865,        //dcsCp865
      ctCp869,        //dcsCp869
      ctCp874,        //dcsCp874
      ctCp875,        //dcsCp875
      ctIceland,      //dcsIceland
      ctBig5,         //dcsBig5
      ctKSC5601,      //dcsKSC5601
      ctEUC,          //dcsEUC
      ctGB2312,       //dcsGB2312
      ctSJIS_0208,    //dcsSJIS_0208
      ctLatin9,       //dcsLatin9
      ctLatin13,      //dcsLatin13
      ctCp1252,       //dcsCp1252
      ctCp1253,       //dcsCp1253
      ctCp775,        //dcsCp775
      ctCp858         //dcsCp858
    );

procedure FillDBFCharSetList(List: TStrings);
var
  i: TDBFCharSet;
begin
  List.Clear;
  for i := Succ(Low(TDBFCharSet)) to High(TDBFCharSet) do
    List.AddObject(QICharsetTypeNames[cQICharsetTypeMAP[i]], TObject(i));
  if List.InheritsFrom(TStringList) then
    TStringList(List).Sort;
  List.InsertObject(0, 'None', TObject(dcsNone));
end;

{ TQImport3DBF }

function TQImport3DBF.AllowImportRowComplete: Boolean;
begin
  Result := not (FSkipDeleted and FDBF.Deleted);
end;

procedure TQImport3DBF.DoBeforeImport;
begin
  FDBF := TDBFRead.Create(FileName);
  FTotalRecCount := FDBF.RecordCount;
  if Formats.BooleanTrue.IndexOf('T') < 0 then
    Formats.BooleanTrue.Add('T');
  if Formats.BooleanFalse.IndexOf('F') < 0 then
    Formats.BooleanFalse.Add('F');
  FEncoding := CreateEncoding;
  inherited;
end;

procedure TQImport3DBF.DoAfterImport;
begin
  if Assigned(FDBF) then
    FreeAndNil(FDBF);
  if Assigned(FEncoding) then
    FreeAndNil(FEncoding);
  SetLength(FValueBuffer, 0);
  inherited;
end;

procedure TQImport3DBF.DoLoadConfiguration(IniFile: TIniFile);
begin
  inherited;
  with IniFile do                             
  begin
    SkipFirstRows := ReadInteger(DBF_OPTIONS, DBF_SKIP_LINES, SkipFirstRows);
    CharSet := TDBFCharSet(ReadInteger(DBF_OPTIONS, DBF_CHARSET, Integer(CharSet)));
  end;
end;

procedure TQImport3DBF.DoSaveConfiguration(IniFile: TIniFile);
begin
  inherited;
  with IniFile do
  begin
    WriteInteger(DBF_OPTIONS, DBF_SKIP_LINES, SkipFirstRows);
    WriteInteger(DBF_OPTIONS, DBF_CHARSET, Integer(CharSet));
  end;
end;

constructor TQImport3DBF.Create(AOwner: TComponent);
begin
  inherited;
  SkipFirstRows := 0;
  FSkipDeleted := true;
  FCharSet := dcsNone;
end;

procedure TQImport3DBF.StartImport;
var
  i: integer;
begin
  FSourceFieldsHash := TQImportHashTable.Create(Map.Count);
  for i := 0 to Map.Count - 1 do
{$IFDEF VCL7}
    FSourceFieldsHash.Add(Map.ValueFromIndex[i], Pointer(i));
{$ELSE}
    FSourceFieldsHash.Add(Map.Values[Map.Names[i]], Pointer(i));
{$ENDIF}
end;

function TQImport3DBF.CheckCondition: boolean;
begin
  Result := not FDBF.EOF;
end;

function TQImport3DBF.Skip: boolean;
begin
  Result := false;
end;

procedure TQImport3DBF.FillImportRow;
var
  i, j: integer;
  ansiValue: AnsiString;
  ansiValueLen: Integer;
  Value: WideString;
  p: Pointer;
begin
  FImportRow.ClearValues;
  RowIsEmpty := True;
  for i := 0 to FDBF.FieldCount - 1 do
  begin
    value := '';
    ansiValue := FDBF.GetData(i);
    if ansiValue = '' then
      Value := ''
    else
    begin
      ansiValueLen := Length(ansiValue);
      if Length(FValueBuffer) < ansiValueLen then
        SetLength(FValueBuffer, ansiValueLen);
      CopyMemory(@FValueBuffer[0], @ansiValue[1], ansiValueLen);
      Value := FEncoding.GetString(FValueBuffer, 0, ansiValueLen);
      if FDBF.FieldType[i] = dftDate then
        Value := DateTimeToStr(DBFStrToDateTime(string(Value)))
      else
      begin
        if AutoTrimValue then
          Value := Trim(Value);
      end;
    end;
    if FSourceFieldsHash.TryGetValue({$IFDEF VCL12}string{$ENDIF}(FDBF.FieldName[i]), p) then
    begin
      j := Integer(p);
      RowIsEmpty := RowIsEmpty and (Value = '');
      FImportRow.SetValue(Map.Names[j], qiString(Value), IsBinary(FImportRow[i].ColumnIndex));
      DoUserDataFormat(FImportRow.ColByName(Map.Names[j]));
    end
  end;

  for i := 0 to FImportRow.Count - 1 do
  begin
    if not FImportRow.MapNameIdxHash.TryGetValue(FImportRow[i].Name, p) then
      DoUserDataFormat(FImportRow[i]);
  end;
end;

function TQImport3DBF.ImportData: TQImportResult;
begin
  Result := qirOk;
  try
    try
      if Canceled  and not CanContinue then
      begin
        Result := qirBreak;
        Exit;
      end;
      if (SkipFirstRows > 0) and (FDBF.RecNo <= SkipFirstRows) then
      begin
        DestinationCancel;
        Result := qirContinue;
        Exit;
      end;

      if FSkipDeleted and FDBF.Deleted then
      begin
        Result := qirContinue;
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
    if (ImportRecCount > 0) and ((ImportedRecs + ErrorRecs) mod ImportRecCount = 0) then
      Result := qirBreak;
  end;
end;

procedure TQImport3DBF.ChangeCondition;
begin
  //
end;

procedure TQImport3DBF.FinishImport;
begin
  try
    if not Canceled and not IsCSV then
    begin
      if CommitAfterDone then
        DoNeedCommit
      else
        if (CommitRecCount > 0) and ((ImportedRecs + ErrorRecs) mod CommitRecCount > 0) then
          DoNeedCommit;
    end;
  finally
    FSourceFieldsHash.Free;
  end;
end;

function TQImport3DBF.DBFStrToDateTime(const Str: string): TDateTime;
var
  Year, Month, Day: word;
begin
  try
    Year := StrToIntDef(Copy(Str, 1, 4), 0);
    Month := StrToIntDef(Copy(Str, 5, 2), 0);
    Day := StrToIntDef(Copy(Str, 7, 2), 0);
    Result := EncodeDate(Year, Month, Day);
  except
    Result := 0;
  end;
end;

function TQImport3DBF.CreateEncoding: TQIEncoding;
begin
  Result := TQIEncoding.GetEncoding(cQICharsetTypeMAP[FCharSet]);
end;

end.
