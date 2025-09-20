unit QImport3XLSUtils;

{$I QImport3VerCtrl.Inc}

interface

uses
  {$IFDEF VCL16}
    System.Classes,
    System.SysUtils,
    System.Math,
  {$ELSE}
    Classes,
    SysUtils,
    Math,
  {$ENDIF}
  QImport3XLSCommon,
  QImport3XLSFile,
  QImport3XLSConsts;

function GetWord(const Data: PByteArray; Offset: integer): word;
procedure SetWord(const Data: PByteArray; Offset: integer; Value: word);
function GetInteger(const Data: PByteArray; Offset: integer): integer;
procedure SetInteger(const Data: PByteArray; const Offset: integer; Value: integer);

function StringToWideStringNoCodePage(const Str: AnsiString): WideString;
function WideStringToStringNoCodePage(const WStr: WideString): AnsiString;
function IsWide(const WStr: WideString): boolean;
function CompareWideStr(const S1, S2: WideString): integer;
function ByteArrayToStr(Buffer: PByteArray; Length: integer): WideString;

procedure ReadMem(var ARecord: TbiffRecord; var Position: integer;
  const Size: integer; const ResPtr: Pointer);
procedure ReadStr(var ARecord: TbiffRecord; var Position: integer;
  var ShortData: AnsiString; var WideData: WideString;
  var OptionFlags, RealOptionFlags: byte; var DestPos: integer;
  const StrLen: integer);

function EncodeRK(Value: double; var RK: longint): boolean;

function GetStrLen(IsWide: boolean; Data: PByteArray; Position: integer;
  UseExtStrLen: boolean; ExtStrLen: integer{longword}): integer{int64};

function ErrCodeToString(ErrCode: integer): WideString;
function StringToErrCode(const ErrStr: WideString): integer;

function Col2Letter(Col: integer): string;    // needs 1 based col number
function Row2Number(Row: integer): string;    // needs 1 based row number
function Letter2Col(Letter: string): integer; // returns 1 based col number
function Number2Row(Number: string): integer; // returns 1 based row number

function CellIsDateTime(Cell: TbiffCell): boolean;

function LoadRecord(Section: TxlsSection; Stream: TStream;
  Header: TBIFF_Header): TbiffRecord;

procedure ObjFreeAndNil(var Obj);

const
  LETTERS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  NUMBERS = '0123456789';

implementation

procedure ObjFreeAndNil(var Obj);
var
  Temp: TObject;
begin
  Temp := TObject(Obj);
  Pointer(Obj) := nil;
  Temp.Free;
end;

function GetWord(const Data: PByteArray; Offset: integer): word;
type
  PWord = ^Word;
begin
//  Result := PWord(PChar(Data) + Offset)^;
  Result := PWord(PAnsiChar(Data) + Offset)^;
end;

procedure SetWord(const Data: PByteArray; Offset: integer; Value: word);
begin
  Move(Value, Data^[Offset], SizeOf(Word));
end;

function GetInteger(const Data: PByteArray; Offset: integer): integer;
type
  PInteger = ^Integer;
begin
//  Result := PInteger(PChar(Data) + Offset)^;
  Result := PInteger(PAnsiChar(Data) + Offset)^;
end;

procedure SetInteger(const Data: PByteArray; const Offset: integer; Value: integer);
begin
  Move(Value, Data^[Offset], SizeOf(Integer))
end;

//function StringToWideStringNoCodePage(const Str: string): WideString;
function StringToWideStringNoCodePage(const Str: AnsiString): WideString;
var
  i: integer;
begin
  SetLength(Result, Length(Str));
  for i := 1 to Length(Str) do
    Result[i] := WideChar(Ord(Str[i]));
end;

//function WideStringToStringNoCodePage(const WStr: WideString): string;
function WideStringToStringNoCodePage(const WStr: WideString): AnsiString;
var
  i: integer;
begin
  SetLength(Result, Length(WStr));
  for i := 1 to Length(WStr) do
    Result[i] := AnsiChar(Chr(Ord(WStr[i]) and $FF));
end;

function IsWide(const WStr: WideString): boolean;
var
  i: integer;
begin
  Result := false;
  for i := 1 to Length(WStr) do
    if Ord(WStr[i]) > $FF then begin
      Result := true;
      Exit;
    end;
end;

function CompareWideStr(const S1, S2: WideString): integer;
var
  i: integer;
begin
  Result := 0;
  if Length(S1) < Length(S2) then
    Result := -1
  else if Length(S1) > Length(S2) then
    Result := 1
  else
    for i := 1 to Length(S1) do begin
      if S1[i] = S2[i] then
        Continue
      else if S1[i] < S2[i] then
        Result := -1
      else Result := 1;
      Exit;
    end;
end;

function ByteArrayToStr(Buffer: PByteArray; Length: integer): WideString;
var
  Str: AnsiString;
begin
  if Buffer[0] = 0 then begin
    SetLength(Str, Length);
    Move(Pointer(Integer(Buffer) + 1)^, Str[1], Length);
    Result := StringToWideStringNoCodePage(Str);
  end
  else Result := WideCharLenToString(PWideChar(Integer(Buffer) + 1), Length);
end;

procedure ReadMem(var ARecord: TbiffRecord; var Position: integer;
  const Size: integer; const ResPtr: Pointer);
var
  l: integer;
begin
  l := ARecord.DataSize - Position;

  if l < 0 then
    raise ExlsFileError.Create(sErrorReadingRecord);

  if (l = 0) and (Size > 0) then begin
    Position := 0;
    ARecord := ARecord.Continue;
    if not Assigned(ARecord) then
      raise ExlsFileError.Create(sErrorReadingRecord);
  end;

  l := ARecord.DataSize - Position;

  if Size <= l then
  begin
    if Assigned(ResPtr) then
      Move(ARecord.Data^[Position], ResPtr^, Size);
    Inc(Position, Size);
  end
  else begin
    ReadMem(ARecord, Position, l, ResPtr);
    if Assigned(ResPtr)
      then ReadMem(ARecord, Position, Size - l, PAnsiChar(ResPtr) + l)
      else ReadMem(ARecord, Position, Size - l, nil);
  end;
end;

procedure ReadStr(var ARecord: TbiffRecord; var Position: integer;
  var ShortData: AnsiString; var WideData: WideString;
  var OptionFlags, RealOptionFlags: byte; var DestPos: integer;
  const StrLen: integer);
var
  l, i: integer;
  ResPtr: Pointer;
  Size, CharSize: integer;
begin
  l := ARecord.DataSize - Position;

  if l < 0 then raise ExlsFileError.Create(sErrorReadingRecord);
  if (l = 0) and (StrLen > 0) then
    if DestPos = 0 then begin
      Position := 0;
      if not Assigned(ARecord.Continue) then
        raise ExlsFileError.Create(sErrorReadingRecord);
      ARecord := ARecord.Continue;
    end
    else begin
      Position := 1;
      if not Assigned(aRecord.Continue) then
        raise ExlsFileError.Create(sErrorReadingRecord);
      ARecord := ARecord.Continue;
      RealOptionFlags := ARecord.Data[0];
      if (RealOptionFlags = 1) and ((OptionFlags and 1) = 0) then begin
        WideData := StringToWideStringNoCodePage(ShortData);
        OptionFlags := OptionFlags or 1;
      end;
    end;

  l := ARecord.DataSize - Position;

  if (RealOptionFlags and 1) = 0 then begin
    Size := StrLen - DestPos;
    ResPtr := @ShortData[DestPos + 1];
    CharSize := 1;
  end
  else begin
    Size := (StrLen - DestPos) * 2;
    ResPtr := @WideData[DestPos + 1];
    CharSize := 2;
  end;

  if Size <= l then begin
    if (RealOptionFlags and 1 = 0) and (OptionFlags and 1 = 1) then
      for i := 0 to Size div CharSize - 1 do
        WideData[DestPos + 1 + i] := WideChar(ARecord.Data^[Position + i])
    else Move(ARecord.Data^[Position], ResPtr^, Size);

    Inc(Position, Size);
    Inc(DestPos, Size div CharSize);
  end
  else begin
    if (RealOptionFlags and 1 = 0) and (OptionFlags and 1 = 1) then
      for i := 0 to l div CharSize - 1 do
        WideData[DestPos + 1 + i] := WideChar(ARecord.Data^[Position + i])
    else Move(ARecord.Data^[Position], ResPtr^, l);
    Inc(Position, l);
    Inc(DestPos, l div CharSize);
    ReadStr(ARecord, Position, ShortData, WideData, OptionFlags,
      RealOptionFlags, DestPos, StrLen);
  end
end;

function EncodeRK(Value: double; var RK: longint): boolean;
var
  d: double;
  pd, pd1: ^longint;
  mask: integer{int64};
  i: integer;
begin
  Result := true;
  for i := 0 to 1 do begin
    d := Value * (1 + 99 * i);
    pd := @d;
    pd1 := pd;
    Inc(pd1);
    if (pd^ = 0) and (pd1^ and 3 = 0) then  begin  //Type 0-2   30 bits IEEE float
      RK := pd1^ + i;
      Exit;
    end;

    mask := $1FFFFFFF;  //29 bits
    if (Int(d) = d) and (d <= Mask) and (d >= - Mask - 1) then begin  //Type 1-3: 30 bits integer
      RK := Round(d) shl 2 + i + 2;
      Exit;
    end;
  end;

  Result := false;
end;

function GetStrLen(IsWide: boolean; Data: PByteArray; Position: integer;
  UseExtStrLen: boolean; ExtStrLen: integer{longword}): integer{int64};
var
  L, rt: Cardinal;
  bsize: byte;
  sz: cardinal;
  P: integer;
  OptionFlags: byte;
begin
  P := Position;
  if UseExtStrLen then
    L := ExtStrLen
  else begin
    if IsWide then begin
      L := GetWord(Data, P);
      Inc(P, 2);
    end
    else begin
      L := Data^[P];
      Inc(P);
    end;
  end;

  OptionFlags := Data^[P];
  Inc(P);

  bsize := OptionFlags and $1;

  rt := 0;
  if (OptionFlags and $8) = $8 then begin //RTF Info
    rt := GetWord(Data, P);
    Inc(P, 2);
  end;

  sz := 0;
  if (OptionFlags and $4) = $4 then begin //Far East Info
    sz := GetInteger(Data, P);
    Inc(P, 4);
  end;
  Result := int64(P - Position) + l shl bsize + rt shl 2 + sz;
end;

function ErrCodeToString(ErrCode: integer): WideString;
begin
  case ErrCode of
    BOOL_ERR_ID_NULL    : Result := BOOL_ERR_STR_NULL;
    BOOL_ERR_ID_DIV_ZERO: Result := BOOL_ERR_STR_DIV_ZERO;
    BOOL_ERR_ID_VALUE   : Result := BOOL_ERR_STR_VALUE;
    BOOL_ERR_ID_REF     : Result := BOOL_ERR_STR_REF;
    BOOL_ERR_ID_NAME    : Result := BOOL_ERR_STR_NAME;
    BOOL_ERR_ID_NUM     : Result := BOOL_ERR_STR_NUM;
    BOOL_ERR_ID_NA      : Result := BOOL_ERR_STR_NA;
    else Result := BOOL_ERR_STR_NULL;
  end;
end;

function StringToErrCode(const ErrStr: WideString): integer;
begin
  if ErrStr = BOOL_ERR_STR_NULL then Result := BOOL_ERR_ID_NULL
  else if ErrStr = BOOL_ERR_STR_DIV_ZERO then Result := BOOL_ERR_ID_DIV_ZERO
  else if ErrStr = BOOL_ERR_STR_VALUE then Result := BOOL_ERR_ID_VALUE
  else if ErrStr = BOOL_ERR_STR_REF then Result := BOOL_ERR_ID_REF
  else if ErrStr = BOOL_ERR_STR_NAME then Result := BOOL_ERR_ID_NAME
  else if ErrStr = BOOL_ERR_STR_NUM then Result := BOOL_ERR_ID_NUM
  else if ErrStr = BOOL_ERR_STR_NA then Result := BOOL_ERR_ID_NA
  else raise ExlsFileError.CreateFmt(sInvalidErrStr, [ErrStr]);
end;

function Col2Letter(Col: integer): string;
var
  n, m, c: integer;
begin
  c := Col - 1;
  Result := EmptyStr;
  n := c div 26;
  m := c mod 26;
  if n > 0 then Result := Result + Copy(LETTERS, n, 1);
  Result := Result + Copy(LETTERS, m + 1, 1);
end;

function Row2Number(Row: integer): string;
begin
  Result := IntToStr(Row);
end;

function Letter2Col(Letter: string): integer;
var
  i: integer;
begin
  Result := 0;
  if Letter = EmptyStr then Exit;
  for i := 1 to Length(Letter) - 1 do
    Result := Result + Pos(Letter[i], LETTERS) * Trunc(Power(26, i));
  Result := Result + Pos(Letter[Length(Letter)], LETTERS);
end;

function Number2Row(Number: string): integer;
begin
  Result := StrToInt(Number);
end;

function CellIsDateTime(Cell: TbiffCell): boolean;
var
  FormatList: TbiffFormatList;
  str: string;
  fmt: integer;
begin
  Result := false;
  FormatList := Cell.Section.Workbook.Globals.FormatList;
  fmt := Cell.FormatIndex;
  if fmt <= High(InternalNumberFormats) then
    Result := fmt in [$0E, $0F, $10, $11, $12, $13, $14, $15, $16]
  else begin
    Dec(fmt, High(InternalNumberFormats));
    if (fmt > 0) and
       (fmt <= FormatList.Count) then begin
      str  := FormatList.Items[fmt].Value;

      Result := (Pos('yy', str) > 0) or (Pos('mm', str) > 0) or
        (Pos('dd', str) > 0) or (Pos('hh', str) > 0) or (Pos('ss', str) > 0) or
        (Pos('YY', str) > 0) or (Pos('MM', str) > 0) or
        (Pos('DD', str) > 0) or (Pos('HH', str) > 0) or (Pos('SS', str) > 0) or
        (Pos('y/', str) > 0) or (Pos('m/', str) > 0) or
        (Pos('d/', str) > 0) or (Pos('h/', str) > 0) or (Pos('s/', str) > 0) or
        (Pos('Y/', str) > 0) or (Pos('M/', str) > 0) or
        (Pos('D/', str) > 0) or (Pos('H/', str) > 0) or (Pos('S/', str) > 0) or
        (Pos('y\', str) > 0) or (Pos('m\', str) > 0) or
        (Pos('d\', str) > 0) or (Pos('h\', str) > 0) or (Pos('s\', str) > 0) or
        (Pos('Y\', str) > 0) or (Pos('M\', str) > 0) or
        (Pos('D\', str) > 0) or (Pos('H\', str) > 0) or (Pos('S\', str) > 0) or
        (Pos('y;', str) > 0) or (Pos('m;', str) > 0) or
        (Pos('d;', str) > 0) or (Pos('h;', str) > 0) or (Pos('s;', str) > 0) or
        (Pos('Y;', str) > 0) or (Pos('M;', str) > 0) or
        (Pos('D;', str) > 0) or (Pos('H;', str) > 0) or (Pos('S;', str) > 0);
    end;
  end;
end;

function LoadRecord(Section: TxlsSection; Stream: TStream; Header: TBIFF_Header): TbiffRecord;

  function ReadHeaderData(Stream: TStream; Header: TBIFF_Header): PByteArray;
  begin
    GetMem(Result, Header.Length);
    try
      if Stream.Read(Result^, Header.Length) <> Header.Length then
        raise Exception.Create(sExcelInvalid);
    except
      FreeMem(Result);
      raise;
    end;
  end;

  function LoadContinueRecord(Section: TxlsSection; Stream: TStream; Header: TBIFF_Header): TbiffContinue;
  begin
    Result := TbiffContinue.Create(Section, Header.ID, Header.Length, ReadHeaderData(Stream, Header));
  end;

var
  headerData: PByteArray;
  biffRec: TbiffRecord;
  nextRecHeader: TBIFF_Header;
  rootRec, prevRec, currRec: TbiffContinue;
begin
  rootRec := nil; prevRec := nil;
  headerData := ReadHeaderData(Stream, Header);

  case Header.ID of
    BIFF_BOF,
    BIFF_BOF_3:
      biffRec := TbiffBOF.Create(Section, Header.ID, Header.Length, headerData);
    BIFF_EOF:
      biffRec := TbiffEOF.Create(Section, Header.ID, Header.Length, headerData);
    BIFF_FORMULA:
      biffRec := TbiffFormula.Create(Section, Header.ID, Header.Length, headerData);
    BIFF_SHRFMLA:
      biffRec := TbiffShrFmla.Create(Section, Header.ID, Header.Length, headerData);
    BIFF_SST:
      biffRec := TbiffSST.Create(Section, Header.ID, Header.Length, headerData);
    BIFF_BOUNDSHEET:
      biffRec := TbiffBoundSheet.Create(Section, Header.ID, Header.Length, headerData);
    BIFF_BLANK:
      biffRec := TbiffBlank.Create(Section, Header.ID, Header.Length, headerData);
    BIFF_BOOLERR:
      biffRec := TbiffBoolErr.Create(Section, Header.ID, Header.Length, headerData);
    BIFF_NUMBER:
      biffRec := TbiffNumber.Create(Section, Header.ID, Header.Length, headerData);
    BIFF_MULBLANK:
      biffRec := TbiffMulBlank.Create(Section, Header.ID, Header.Length, headerData);
    BIFF_MULRK:
      biffRec := TbiffMulRK.Create(Section, Header.ID, Header.Length, headerData);
    BIFF_RK:
      biffRec := TbiffRK.Create(Section, Header.ID, Header.Length, headerData);
    BIFF_STRING:
      biffRec:= TbiffString.Create(Section, Header.ID, Header.Length, headerData);
    BIFF_XF:
      biffRec := TbiffXF.Create(Section, Header.ID, Header.Length, headerData);
    BIFF_FORMAT:
      biffRec := TbiffFormat.Create(Section, Header.ID, Header.Length, headerData);
    BIFF_LABELSST:
      biffRec := TbiffLabelSST.Create(Section, Header.ID, Header.Length, headerData);
    BIFF_LABEL:
      biffRec := TbiffLabel.Create(Section, Header.ID, Header.Length, headerData);
    BIFF_NAME:
      biffRec := TbiffName.Create(Section, Header.ID, Header.Length, headerData);
    BIFF_CONTINUE:
      biffRec := TbiffContinue.Create(Section, Header.ID, Header.Length, headerData);
    BIFF_1904:
      biffRec := Tbiff1904.Create(Section, Header.ID, Header.Length, headerData);
    else
      biffRec := TbiffRecord.Create(Section, Header.ID, Header.Length, headerData);
  end;

  //Peek at the next record...
  while (Header.ID <> 0) and (Header.ID <> BIFF_EOF) do
  begin
    if Stream.Read(nextRecHeader, SizeOf(nextRecHeader)) = SizeOf(nextRecHeader) then
    begin
      if nextRecHeader.ID = BIFF_CONTINUE then
      begin
        currRec := LoadContinueRecord(Section, Stream, nextRecHeader);
        if Assigned(prevRec) then
          prevRec.AddContinue(currRec)
        else
          rootRec := currRec;
        prevRec := currRec;
      end
      else begin
        if nextRecHeader.ID = BIFF_STRING then
          if not (biffRec is TbiffFormula) and not (biffRec is TbiffShrFmla) then
            raise ExlsFileError.Create(sExcelInvalid);
        Stream.Seek(-SizeOf(nextRecHeader), soFromCurrent);
        if Assigned(rootRec) then
          biffRec.AddContinue(rootRec);
        Break;
      end;
    end;
  end;

  Result := biffRec;
end;

end.
