unit QImport3CSVClasses;

{$I QImport3VerCtrl.Inc}

interface

uses
  {$IFDEF VCL16}
    {$IFDEF QI_UNICODE}
      System.WideStrings,
    {$ENDIF}
    Winapi.Windows,
    System.Classes,
    System.Contnrs,
    System.SysUtils,
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
    Contnrs,
    SysUtils,
  {$ENDIF}
  QImport3StrTypes,
  QImport3StrIDs,
  QImport3Common,
  QImport3Encoding;

const
  DefBufferSize = 512;

type
  TCSVParserState = (psChkBegOfLine, psChkBegOfColumn, psNotQuoted, psQuoted, psChkIntrnQuote, psChkAfterCR);

  TCSVColumn = class(TObject)
  private
    FValue: qiString;
    FName: qiString;
  public
    constructor Create; virtual;
    property Value: qiString read FValue write FValue;
    property Name: qiString read FName write FName;
  end;

  TCSVReader = class(TObject)
  private
    FActive: Boolean;  //true when file is Open
    FColumns: TObjectList;
    FBof: Boolean;
    FEof: Boolean;
    FHeaderPresent: Boolean;
    FReadingHeader: Boolean;
    FFlagExitMainLoop: Boolean;
    FIndexOfLastProcessedColumn: Integer; //zero-based
    FIndexOfLastProcessedLine: Integer; //zero-based
    FBufferColumnValue: array{$IFNDEF VCL6}[0..DefBufferSize - 1]{$ENDIF} of qiChar;
    FBufFldValCapacity: Integer;
    FBufFldValContentLength: Integer;

    FParserState: TCSVParserState;
    FBufferReadFromFile: qiChar;
    FIgnoreSpecialCharacters: Boolean;
    FUseColumnQuoting: Boolean;
    FIgnoreEmptyLines: Boolean;
    FColumnCountAutoDetect: Boolean;
    FColumnCountAutoDetectInProgress: Boolean;
    FColumnSeparatorChar: qiChar;
    FQuoteChar: qiChar;
    FASCIIonly: Boolean;
    FOnColumnCountAutoDetectComplete: TNotifyEvent;

    FBufferReadFromStream: array{$IFNDEF VCL6}[0..DefBufferSize - 1]{$ENDIF} of qiChar;
    FBufferReadFromStreamCapacity: Integer;
    FBufferReadFromStreamContentLength: Integer;
    FBufferReadFromStreamNextCharIndex: Integer;

    procedure DoOpen;
    procedure DoClose;
    procedure OpenCSVSourceAndCreateStream;
    procedure CloseCSVSourceAndDestroyStream;
    procedure ParsingLoopMain;
    procedure ClearColumnDataInaccessibleWhileEndOfLine;
    procedure ClearColumnDataInaccessibleWhileFileClosed;
    procedure ClearColumnDataInaccessibleWhileEof;
    procedure ResetForClose;
    procedure ResetForEndOfFile;
    procedure ResetForNextLine;
    procedure ResetForNextColumn;
    procedure DoEndOfFile;
    procedure AddToColumnValueBuffer;
    procedure HandleQuoteAtBegOfValue(var ASwitchToState: TCSVParserState);
    procedure HandleEndOfLine;
    procedure HandleEmptyLine;
    procedure HandleEndOfFileAtBegOfLine;
    procedure HandleEndOfFileAfterLastColumnInLine;
    procedure SetColumnCountAutoDetectInProgress(const Value: Boolean);
    procedure SetHeaderPresent(const Value: Boolean);
    procedure SetColumnCountAutoDetect(const Value: Boolean);
    function GetColumnCount: Integer;
    procedure SetColumnCount(const Value: Integer);
    function GetColumnSeparatorCharCode: Integer;
    procedure SetColumnSeparatorCharCode(const Value: Integer);
    procedure SetUseColumnQuoting(const Value: Boolean);
    function GetQuoteCharCode: Integer;
    procedure SetQuoteCharCode(const Value: Integer);
    procedure SetIgnoreEmptyLines(const Value: Boolean);
    procedure SetASCIIonly(const Value: Boolean);
    procedure SetIgnoreSpecialCharacters(const Value: Boolean);
    procedure SetActive(const Value: Boolean);
    function GetColumns(Index: Integer): TCSVColumn;
    function GetLineCountProcessedSoFar: Integer;
    function GetCurrentLine: qiString;

    property ColumnCountAutoDetectInProgress: Boolean
      read FColumnCountAutoDetectInProgress
      write SetColumnCountAutoDetectInProgress;

  protected
    FCSVTextStream: TStream;

    function CreateDataSourceStream: TStream; virtual; abstract;

    procedure DoEndOfColumn; virtual;
    procedure DoEndOfLine; virtual;
    function AllowColumnCountChangeEvenInOpenState: Boolean; virtual;
    procedure OnColumnCountAutoDetectCompleted; virtual;

    procedure ThrowErrorWithNoParam(AMsg: qiString);
    procedure ThrowErrorWithLineAndColumnNum(AMsg: qiString);

  public
    constructor Create(ABufferReadFromStreamCapacityInChars: Integer = DefBufferSize); virtual;
    destructor Destroy; override;

    procedure Open;
    procedure Close;
    procedure Next;

    { - False (by default): All lines are considered as lines with values.
      - True: Values in the very first line are considered as the column's names. }
    property HeaderPresent: Boolean read FHeaderPresent write SetHeaderPresent;

    { ColumnCount auto detection is done during/within Open on the base of very
      first line (or on the base of first non-empty line when IgnoreEmptyLines=true).
      "Autodetected" ColumnCount is accessible after Open (Active := true) is complete }
    property ColumnCountAutoDetect: Boolean
      read FColumnCountAutoDetect write SetColumnCountAutoDetect;

    { ColumnCount is always >= 0. Attempt to assign negative value is ignored.
      If ColumnCountAutoDetect is true then assigned value is meaningless and
      will be replaced during Open(). }
    property ColumnCount: Integer read GetColumnCount write SetColumnCount;

    { It is a code (!) and not a char. Virtually any (see also property ASCIIonly)
        unicode character including special characters like TAB, etc. can be
        used as column separator.}
    property ColumnSeparatorCharCode: Integer
      read GetColumnSeparatorCharCode write SetColumnSeparatorCharCode;

    { - False: In this case it is assumed that "quote char" is never used for column
               value surrounding and is considered as ordinary data character
               provided that code is in data char code range, i.e. not special
               character. In other words, value specified as QuoteCharCode (see below)
               is meaningless.
      - True (by default): Column value may or may not be enclosed in characters
                           specified in QuoteCharCode (see below). }
    property UseColumnQuoting: Boolean read FUseColumnQuoting write SetUseColumnQuoting;

    { QuoteCharCode:
      - It is a code (!) and not a char. Virtually any (see also property ASCIIonly)
        unicode character can be used as “quote char”. It is assumed that this
        character is also used as escape character }
    property QuoteCharCode: Integer read GetQuoteCharCode write SetQuoteCharCode;

    { - False (by default): Presence of empty lines in source, which is
        indication of wrong input data format, causes exception.
      - True: Empty lines are ignored. }
    property IgnoreEmptyLines: Boolean read FIgnoreEmptyLines write SetIgnoreEmptyLines;

    { - False (by default): Full Unicode range of characters is handled. Characters
                            with codes less than 0x20 are considered as “special characters”
                            (see property IgnoreSpecialCharacters below).
      - True: Only ASCII range of characters is handled. Characters with codes
              outside range 0x20 – 0x7E are considered as “special characters”
              (see property IgnoreSpecialCharacters below). }
    property ASCIIonly: Boolean read FASCIIonly write SetASCIIonly;

    { - False (by default): Presence of “special characters”, as they defined above
                            in property ASCIIonly description, causes exception.
                            This does not affect line breaks, column separator and
                            quote characters even if last two are from the “special
                            character” range.
      - True: “Special characters” are ignored except line breaks, column separator
              and quote characters even if last two are from the “special character” range. }
    property IgnoreSpecialCharacters: Boolean
      read FIgnoreSpecialCharacters write SetIgnoreSpecialCharacters;

    property Active: Boolean read FActive write SetActive;
    property Bof: Boolean read FBof;
    property Eof: Boolean read FEof;

    {Columns is "zero-based" ( 0 <= Index <= ColumnCount-1)}
    property Columns[Index: Integer]: TCSVColumn read GetColumns;

    property LineCountProcessedSoFar: Integer read GetLineCountProcessedSoFar;

    property CurrentLine: qiString read GetCurrentLine;

    property OnColumnCountAutoDetectComplete: TNotifyEvent
               read FOnColumnCountAutoDetectComplete
               write FOnColumnCountAutoDetectComplete;
  end;

  TCSVFileReader = class(TCSVReader)
  private
    FFileName: string;
    FCharset: TQICharsetType;
    function GetCharset: TQICharsetType;
    procedure SetCharset(const Value: TQICharsetType);
  protected
    function CreateDataSourceStream: TStream; override;
    procedure DoEndOfColumn; override;
    procedure DoEndOfLine; override;
  public
    constructor Create(ABufferReadFromStreamCapacityInChars: Integer = DefBufferSize); override;
    procedure SetFile(const AFileName: string);
    property FileName: string read FFileName;
    property Charset: TQICharsetType read GetCharset write SetCharset;
  end;

implementation

const
  CR = #$0D;
  LF = #$0A;
  DQUOTE = #$22;  // double quote
  COMMA = #$2C;
  CharCodeHex20 = #$20;
  CharCodeHex7E = #$7E;

  BufColValCapacityIncrement = 128;

type
  TCSVParserEvent = (peDataChar, peQuote, peColumnSeparator, peCR, peLF, peEof);

{ TCSVColumn }

constructor TCSVColumn.Create;
begin
  FValue := '';
  FName := '';
end;

{ TCSVReader }

procedure TCSVReader.AddToColumnValueBuffer;
begin
  {$IFDEF VCL6}
  if (FBufFldValContentLength >= FBufFldValCapacity) then
  begin
    FBufFldValCapacity := FBufFldValCapacity + BufColValCapacityIncrement;
    SetLength(FBufferColumnValue, FBufFldValCapacity);
  end;
  {$ENDIF}
  FBufferColumnValue[FBufFldValContentLength] := FBufferReadFromFile;
  Inc(FBufFldValContentLength);
end;

function TCSVReader.AllowColumnCountChangeEvenInOpenState: Boolean;
begin
  Result := ColumnCountAutoDetectInProgress;
end;

procedure TCSVReader.ClearColumnDataInaccessibleWhileEndOfLine;
var
  I: Integer;
begin
  for I := FIndexOfLastProcessedColumn + 1 to ColumnCount - 1 do
    Columns[I].Value := '';
end;

procedure TCSVReader.ClearColumnDataInaccessibleWhileEof;
var
  I: Integer;
begin
  for I := 0 to ColumnCount - 1 do
    Columns[I].Value := '';
end;

procedure TCSVReader.ClearColumnDataInaccessibleWhileFileClosed;
var
  I: Integer;
begin
  ClearColumnDataInaccessibleWhileEof;
  for I := 0 to ColumnCount - 1 do
    Columns[I].Name := '';
end;

procedure TCSVReader.Close;
begin
  Active := False;
end;

procedure TCSVReader.CloseCSVSourceAndDestroyStream;
begin
  if Assigned(FCSVTextStream) then
  begin
    FCSVTextStream.Free;
    FCSVTextStream := nil;
  end;
end;

constructor TCSVReader.Create(ABufferReadFromStreamCapacityInChars: Integer);
begin
  // Input property default values
  FHeaderPresent := False;
  FColumnCountAutoDetect := True;
  FColumnSeparatorChar := COMMA;
  FUseColumnQuoting := True;
  FQuoteChar := DQUOTE;
  FIgnoreEmptyLines := False;
  FASCIIonly := False;
  FIgnoreSpecialCharacters := False;

  FActive := False;
  FBof := False;
  FEof := False;

  FReadingHeader := False;
  FFlagExitMainLoop := False;

  FColumns := TObjectList.Create(True);
  FCSVTextStream := nil;
  FBufFldValCapacity := 0;
  FBufFldValContentLength := 0;

  if (ABufferReadFromStreamCapacityInChars > 0) then
    FBufferReadFromStreamCapacity := ABufferReadFromStreamCapacityInChars
  else
    FBufferReadFromStreamCapacity := DefBufferSize;
  {$IFDEF VCL6}
  SetLength(FBufferReadFromStream, FBufferReadFromStreamCapacity);
  {$ENDIF}
  FBufferReadFromStreamContentLength := 0;
  FBufferReadFromStreamNextCharIndex := 0;
end;

destructor TCSVReader.Destroy;
begin
  Close;
  {$IFDEF VCL6}
  FBufferReadFromStream := nil;
  FBufferColumnValue := nil;
  {$ENDIF}
  FColumns.Free;
  inherited;
end;

procedure TCSVReader.DoClose;
begin
  ResetForClose;
end;

procedure TCSVReader.DoEndOfColumn;
var
  CsvValue: qiString;
begin
  if (ColumnCountAutoDetectInProgress) then
    ColumnCount := ColumnCount + 1;

  if (FIndexOfLastProcessedColumn >= (ColumnCount - 1)) then
    ThrowErrorWithLineAndColumnNum(QImportLoadStr(QIE_CSVWrongNumberOfColumns))
  else
  begin
    Inc(FIndexOfLastProcessedColumn);

    SetString(CsvValue, PqiChar(@FBufferColumnValue[0]), FBufFldValContentLength);

    if (FReadingHeader) then
      Columns[FIndexOfLastProcessedColumn].Name := CsvValue
    else
      Columns[FIndexOfLastProcessedColumn].Value := CsvValue;
    ResetForNextColumn;
  end;
end;

procedure TCSVReader.DoEndOfFile;
begin
  FEof := True;
  ResetForEndOfFile;
  FFlagExitMainLoop := True;
end;

procedure TCSVReader.DoEndOfLine;
begin
  if (FIndexOfLastProcessedColumn <> (ColumnCount - 1)) then
    ThrowErrorWithLineAndColumnNum(QImportLoadStr(QIE_CSVWrongNumberOfColumns))
  else
  begin
    ResetForNextLine;
    FFlagExitMainLoop := True;
  end;

  if (ColumnCountAutoDetectInProgress) then
  begin
    ColumnCountAutoDetectInProgress := False;
    OnColumnCountAutoDetectCompleted;
  end;
end;

procedure TCSVReader.DoOpen;
begin
  try
    ResetForClose; //initial state is set here
    OpenCSVSourceAndCreateStream;
    FBof := True;
    if FCSVTextStream is TEncodedReadStream then
      FEof := TEncodedReadStream(FCSVTextStream).GetEof
    else
      FEof := FCSVTextStream.Position >= FCSVTextStream.Size;

    ColumnCountAutoDetectInProgress := ColumnCountAutoDetect and (not FEof);
    if (HeaderPresent and (not Eof)) then
    begin
      FReadingHeader := True;
      try
        Next;
      finally
        FReadingHeader := False;
      end;
    end;
    if (not FEof) then
      Next;
  except
    DoClose;
    raise;
  end;
end;

function TCSVReader.GetCurrentLine: qiString;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to FColumns.Count - 1 do
  begin
    Result := Result + TCSVColumn(FColumns[I]).Value;
    if I < FColumns.Count - 1 then
      Result := Result + qiChar(FColumnSeparatorChar);
  end;
end;

function TCSVReader.GetColumnCount: Integer;
begin
  Result := FColumns.Count;
end;

function TCSVReader.GetColumns(Index: Integer): TCSVColumn;
begin
  Result := TCSVColumn(FColumns[Index]);
end;

function TCSVReader.GetColumnSeparatorCharCode: Integer;
begin
  Result := Integer(FColumnSeparatorChar);
end;

function TCSVReader.GetQuoteCharCode: Integer;
begin
  Result := Integer(FQuoteChar);
end;

function TCSVReader.GetLineCountProcessedSoFar: Integer;
begin
  if (FIndexOfLastProcessedLine < 0 ) then
    Result := 0
  else
    Result := FIndexOfLastProcessedLine + 1; //FIndexOfLastProcessedLine is zero-based
end;

procedure TCSVReader.HandleEmptyLine;
begin
  if (not IgnoreEmptyLines) then
    HandleEndOfLine;
end;

procedure TCSVReader.HandleEndOfFileAfterLastColumnInLine;
begin
  HandleEndOfLine;
end;

procedure TCSVReader.HandleEndOfFileAtBegOfLine;
begin
  DoEndOfFile;
end;

procedure TCSVReader.HandleEndOfLine;
begin
  // in exact order:
  DoEndOfColumn;
  DoEndOfLine;
end;

procedure TCSVReader.HandleQuoteAtBegOfValue(var ASwitchToState: TCSVParserState);
begin
  if (UseColumnQuoting) then
    ASwitchToState := psQuoted
  else
  begin
    AddToColumnValueBuffer;
    ASwitchToState := psNotQuoted;
  end;
end;

procedure TCSVReader.Next;
begin
  if (Active) then
  begin
    if (not Eof) then
    begin
      FFlagExitMainLoop := False;
      try
        ParsingLoopMain;
        FBof := False;
      except
        Close; //<----- Close if error occures during parsing
        raise;
      end;
    end
    else
    begin
      //Reading “beyond” end of file. Next does nothing.
      //Column values will state cleared, which is done at setting Eof.
    end;
  end
  else
    ThrowErrorWithNoParam(QImportLoadStr(QIE_CSVGettingNextLine) + #13 +
                          QImportLoadStr(QIE_CSVOperationNotAllowedInInactiveState));
end;

procedure TCSVReader.OnColumnCountAutoDetectCompleted;
begin
  if Assigned(FOnColumnCountAutoDetectComplete) then
    FOnColumnCountAutoDetectComplete(Self);
end;

procedure TCSVReader.Open;
begin
  Active := True;
end;

procedure TCSVReader.OpenCSVSourceAndCreateStream;
begin
  CloseCSVSourceAndDestroyStream;
  FCSVTextStream := CreateDataSourceStream;
end;

procedure TCSVReader.ParsingLoopMain;
var
  ParserEvent: TCSVParserEvent;
  ReadingComplete: Boolean;
  CharAsInteger: Integer;
  SwitchToState: TCSVParserState;
begin
  while (not FFlagExitMainLoop) do
  begin
    // GetEvent - begin
    ParserEvent := peEof; //just to init it with something (EndOfFile makes most sense)
    repeat
      ReadingComplete := true;

      //Get next char from FbufferReadFromStream. Read into FbufferReadFromStream from TextReader when necessary === BEGIN
      CharAsInteger := 0; //any not negative
      if (FBufferReadFromStreamNextCharIndex >= FBufferReadFromStreamContentLength) then
      begin
        FBufferReadFromStreamNextCharIndex := 0;
        FBufferReadFromStreamContentLength :=
          FCSVTextStream.Read(FBufferReadFromStream[0], FBufferReadFromStreamCapacity) div SizeOf(qiChar);
        if (FBufferReadFromStreamContentLength <= 0) then //compare "= 0" just in case
        begin
          FBufferReadFromStreamContentLength := 0;
          CharAsInteger := -1;
        end;
      end;
      if not(CharAsInteger < 0) then
      begin
        CharAsInteger := Integer(FBufferReadFromStream[FBufferReadFromStreamNextCharIndex]);
        Inc(FBufferReadFromStreamNextCharIndex);
      end;
      //Get next char from FbufferReadFromStream === END

      if (CharAsInteger <= 0) then
      begin
        // reached end of the stream
        FBufferReadFromFile := qiChar(0);  // just in case put "empty" char there
        ParserEvent := peEof;
       end
      else
      begin
        FBufferReadFromFile := qiChar(CharAsInteger);
        if (FBufferReadFromFile = CR) then
          ParserEvent := peCR
        else if (FBufferReadFromFile = LF) then
          ParserEvent := peLF
        else if (FBufferReadFromFile = FColumnSeparatorChar) then
          ParserEvent := peColumnSeparator
        else if (FBufferReadFromFile = FQuoteChar) then
          ParserEvent := peQuote
        else if ((FBufferReadFromFile >= CharCodeHex20) and
          ((not ASCIIonly) or (ASCIIonly and (FBufferReadFromFile <= qiChar(CharCodeHex7E))))) then
          ParserEvent := peDataChar
        else if (IgnoreSpecialCharacters) then
          ReadingComplete := false
        else
          ThrowErrorWithLineAndColumnNum(Format(QImportLoadStr(QIE_CSVInvalidCharacter),
            [Integer(FBufferReadFromFile)]));
      end;
    until (ReadingComplete);
    // GetEvent - end

    SwitchToState := psChkBegOfLine; // init just to get rid of possible compiler's warning
    case FParserState of
      psChkBegOfLine:
        case ParserEvent of
          peDataChar:
          begin
            AddToColumnValueBuffer;
            FParserState := psNotQuoted;
          end;
          peQuote:
          begin
            HandleQuoteAtBegOfValue( SwitchToState );
            FParserState := SwitchToState;
          end;
          peColumnSeparator:
          begin
            DoEndOfColumn();
            FParserState := psChkBegOfColumn;
          end;
          peCR:
          begin
            // empty line
            HandleEmptyLine;
            FParserState := psChkAfterCR;
          end;
          peLF:
            //empty line that delimited by single LF
            HandleEmptyLine;
            //not changing state
          peEof:
            //Possible situations:
            //    1. Last line of file has line break before Eof.
            //    2. Last line without line break before Eof  containing empty value in
            //    the file with one column per line.
            //    There is no way to differentiate them. Therefore let's assume that
            //    it is always situation "1".
            HandleEndOfFileAtBegOfLine;
            // Not changing state. BTW it does not matter here
        end;{case lParserEvent}
      psChkBegOfColumn:
        case ParserEvent of
          peDataChar:
          begin
            AddToColumnValueBuffer;
            FParserState := psNotQuoted;
          end;
          peQuote:
          begin
            HandleQuoteAtBegOfValue( SwitchToState );
            FParserState := SwitchToState;
          end;
          peColumnSeparator:
            //empty value
            DoEndOfColumn;
            //Not changing state
          peCR:
          begin
            //empty value
            HandleEndOfLine;
            FParserState := psChkAfterCR;
          end;
          peLF:
          begin
            HandleEndOfLine;
            FParserState := psChkBegOfLine;
          end;
          peEof:
          begin
            //empty value
            HandleEndOfFileAfterLastColumnInLine;
            FParserState := psChkBegOfLine; //actually does not matter
          end;
        end;{case lParserEvent}
      psNotQuoted:
        case ParserEvent of
          peDataChar,
          peQuote:
            AddToColumnValueBuffer;
            //Not changing state
          peColumnSeparator:
          begin
            DoEndOfColumn;
            FParserState := psChkBegOfColumn;
          end;
          peCR:
          begin
            HandleEndOfLine;
            FParserState := psChkAfterCR;
          end;
          peLF:
          begin
            HandleEndOfLine;
            FParserState := psChkBegOfLine;
          end;
          peEof:
          begin
            HandleEndOfFileAfterLastColumnInLine;
            FParserState := psChkBegOfLine;
          end;
        end;{case lParserEvent}
      psQuoted:
        case ParserEvent of
          peDataChar,
          peColumnSeparator,
          peCR,
          peLF:
            AddToColumnValueBuffer;
            //Not changing state
          peQuote:
            FParserState := psChkIntrnQuote;
          peEof:
          begin
            FParserState := psChkBegOfLine; //probably does not matter
            ThrowErrorWithLineAndColumnNum(QImportLoadStr(QIE_CSVWrongColumnValueFormat));
          end;
        end;{case lParserEvent}
      psChkIntrnQuote:
        case ParserEvent of
          peDataChar:
          begin
            {if quote was closing quote then here we expect column separator,
             end of line or end of file}
            FParserState := psChkBegOfLine;  //probably does not matter
            ThrowErrorWithLineAndColumnNum(QImportLoadStr(QIE_CSVWrongColumnValueFormat));
          end;
          peQuote:
          begin
            //internal quote character
            AddToColumnValueBuffer;
            FParserState := psQuoted;
          end;
          peColumnSeparator:
          begin
            DoEndOfColumn;
            FParserState := psChkBegOfColumn;
          end;
          peCR:
          begin
            HandleEndOfLine;
            FParserState := psChkAfterCR;
          end;
          peLF:
          begin
            HandleEndOfLine;
            FParserState := psChkBegOfLine;
          end;
          peEof:
          begin
            HandleEndOfFileAfterLastColumnInLine;
            FParserState := psChkBegOfLine;
          end;
        end;{case lParserEvent}
      psChkAfterCR:
        case ParserEvent of
          peDataChar:
          begin
            AddToColumnValueBuffer;
            FParserState := psNotQuoted;
          end;
          peQuote:
          begin
            HandleQuoteAtBegOfValue(SwitchToState);
            FParserState := SwitchToState;
          end;
          peColumnSeparator:
          begin
            //empty value
            DoEndOfColumn;
            FParserState := psChkBegOfColumn;
          end;
          peCR:
            //empty line
            HandleEmptyLine;
            //Not changing state
          peLF:
            //Line delimiter <CR><LF>
            FParserState := psChkBegOfLine;
          peEof:
          begin
            //Same situation as in state psChkBegOfLine (see more in State_BegOfLine_Handler)
            HandleEndOfFileAtBegOfLine;
            FParserState := psChkBegOfLine; //actually does not matter
          end;
        end;{case lParserEvent}
    end; {case FParserState}
  end; {while (not FFlag_ExitMainLoop)}
end;

procedure TCSVReader.ResetForClose;
begin
  FBufFldValCapacity := 0;
  {$IFDEF VCL6}
  SetLength(FBufferColumnValue, FBufFldValCapacity);
  {$ENDIF}
  FBufFldValContentLength := 0;//just in case

  ColumnCountAutoDetectInProgress := False;
  ResetForEndOfFile;
  ResetForNextLine;
  ResetForNextColumn;
  ClearColumnDataInaccessibleWhileFileClosed;
  FIndexOfLastProcessedLine := -1; //zero-based
  FBof := False;
  FEof := False;
  FParserState := psChkBegOfLine;
end;

procedure TCSVReader.ResetForEndOfFile;
begin
  CloseCSVSourceAndDestroyStream;
  ClearColumnDataInaccessibleWhileEof;
end;

procedure TCSVReader.ResetForNextColumn;
begin
  FBufFldValContentLength := 0;
end;

procedure TCSVReader.ResetForNextLine;
begin
  FIndexOfLastProcessedColumn := -1;
  Inc(FIndexOfLastProcessedLine);
end;

procedure TCSVReader.SetActive(const Value: Boolean);
begin
  if (FActive <> Value) then
  begin
    FActive := Value;
    if (FActive) then
      try
        DoOpen;
      except
        FActive := false;
        DoClose;
        raise;
      end
    else
      DoClose;
  end;
end;

procedure TCSVReader.SetASCIIonly(const Value: Boolean);
begin
  if (FASCIIonly <> Value) then
    if (not Active) then
      FASCIIonly := Value
    else
      ThrowErrorWithNoParam(Format(QImportLoadStr(QIE_CSVModifyingInputParameter), ['ASCIIonly']) + #13 +
                            QImportLoadStr(QIE_CSVOperationNotAllowedInActiveState));
end;

procedure TCSVReader.SetColumnCount(const Value: Integer);
var
  I: Integer;
begin
  if ((Value >= 0) and (ColumnCount <> Value)) then
    if ((not Active) or (Active and AllowColumnCountChangeEvenInOpenState)) then
    begin
      if (Value > ColumnCount) then
        for I := ColumnCount to Value - 1 do
          FColumns.Add(TCSVColumn.Create)
      else{Value < ColumnCount}
        for I := ColumnCount - 1 downto Value do
          FColumns.Delete(I);{also will free object because owns it}
    end
    else
      ThrowErrorWithNoParam(Format(QImportLoadStr(QIE_CSVModifyingInputParameter), ['ColumnCount']) + #13 +
                            QImportLoadStr(QIE_CSVOperationNotAllowedInActiveState));
end;

procedure TCSVReader.SetColumnCountAutoDetect(const Value: Boolean);
begin
  if (FColumnCountAutoDetect <> Value) then
    if (not Active) then
      FColumnCountAutoDetect := Value
    else
      ThrowErrorWithNoParam(Format(QImportLoadStr(QIE_CSVModifyingInputParameter), ['ColumnCountAutoDetect']) + #13 +
                            QImportLoadStr(QIE_CSVOperationNotAllowedInActiveState));
end;

procedure TCSVReader.SetColumnCountAutoDetectInProgress(const Value: Boolean);
begin
  if (FColumnCountAutoDetectInProgress <> Value) then
  begin
    FColumnCountAutoDetectInProgress := Value;
    if (FColumnCountAutoDetectInProgress) then
      ColumnCount := 0;
  end;
end;

procedure TCSVReader.SetColumnSeparatorCharCode(const Value: Integer);
begin
  if (FColumnSeparatorChar <> qiChar(Value)) then
    if (not Active) then
      FColumnSeparatorChar := qiChar(Value)
    else
      ThrowErrorWithNoParam(Format(QImportLoadStr(QIE_CSVModifyingInputParameter), ['ColumnSeparatorCharCode']) + #13 +
                            QImportLoadStr(QIE_CSVOperationNotAllowedInActiveState));
end;

procedure TCSVReader.SetHeaderPresent(const Value: Boolean);
begin
  if (FHeaderPresent <> Value) then
    if (not Active) then
      FHeaderPresent := Value
    else
      ThrowErrorWithNoParam(Format(QImportLoadStr(QIE_CSVModifyingInputParameter), ['HeaderPresent']) + #13 +
                            QImportLoadStr(QIE_CSVOperationNotAllowedInActiveState));
end;

procedure TCSVReader.SetIgnoreEmptyLines(const Value: Boolean);
begin
  if (FIgnoreEmptyLines <> Value) then
    if (not Active) then
      FIgnoreEmptyLines := Value
    else
      ThrowErrorWithNoParam(Format(QImportLoadStr(QIE_CSVModifyingInputParameter), ['IgnoreEmptyLines']) + #13 +
                            QImportLoadStr(QIE_CSVOperationNotAllowedInActiveState));
end;

procedure TCSVReader.SetIgnoreSpecialCharacters(const Value: Boolean);
begin
  if (FIgnoreSpecialCharacters <> Value) then
    if (not Active) then
      FIgnoreSpecialCharacters := Value
    else
      ThrowErrorWithNoParam(Format(QImportLoadStr(QIE_CSVModifyingInputParameter), ['IgnoreSpecialCharacters']) + #13 +
                            QImportLoadStr(QIE_CSVOperationNotAllowedInActiveState));
end;

procedure TCSVReader.SetQuoteCharCode(const Value: Integer);
begin
  if (FQuoteChar <> qiChar(Value)) then
    if (not Active) then
      FQuoteChar := qiChar(Value)
    else
      ThrowErrorWithNoParam(Format(QImportLoadStr(QIE_CSVModifyingInputParameter), ['QuoteCharCode']) + #13 +
                            QImportLoadStr(QIE_CSVOperationNotAllowedInActiveState));
end;

procedure TCSVReader.SetUseColumnQuoting(const Value: Boolean);
begin
  if (FUseColumnQuoting <> Value) then
    if (not Active) then
      FUseColumnQuoting := Value
    else
      ThrowErrorWithNoParam(Format(QImportLoadStr(QIE_CSVModifyingInputParameter), ['UseColumnDblQuoting']) + #13 +
                            QImportLoadStr(QIE_CSVOperationNotAllowedInActiveState));
end;

procedure TCSVReader.ThrowErrorWithNoParam(AMsg: qiString);
begin
  raise Exception.Create(AMsg);
end;

procedure TCSVReader.ThrowErrorWithLineAndColumnNum(AMsg: qiString);
begin
  ThrowErrorWithNoParam(QImportLoadStr(QIE_CSVParseError) + #13 + AMsg + #13 +
                        Format(QImportLoadStr(QIE_CSVLineNumberError), [FIndexOfLastProcessedLine
                          + 1{in process} + 1{make it 1-based}]) +
                        ', ' + Format(QImportLoadStr(QIE_CSVColumnNumberError), [FIndexOfLastProcessedColumn
                          + 1{in process} + 1{make it 1-based}]));
end;

constructor TCSVFileReader.Create(ABufferReadFromStreamCapacityInChars: Integer = DefBufferSize);
begin
  inherited Create(ABufferReadFromStreamCapacityInChars);
  FFileName := '';
end;

function TCSVFileReader.CreateDataSourceStream: TStream;
begin
  Result := TEncodedReadStream.Create(FFileName, FCharset);
end;

procedure TCSVFileReader.DoEndOfColumn;
var
  CsvValue: qiString;
begin
  if (FIndexOfLastProcessedColumn >= (ColumnCount - 1)) then
    ColumnCount := ColumnCount + 1;

  Inc(FIndexOfLastProcessedColumn);

  SetString(CsvValue, PqiChar(@FBufferColumnValue[0]), FBufFldValContentLength);

  if (FReadingHeader) then
    Columns[FIndexOfLastProcessedColumn].Name := CsvValue
  else
    Columns[FIndexOfLastProcessedColumn].Value := CsvValue;

  ResetForNextColumn;
end;

procedure TCSVFileReader.DoEndOfLine;
begin
  ClearColumnDataInaccessibleWhileEndOfLine;
  ResetForNextLine;
  FFlagExitMainLoop := True;
end;

function TCSVFileReader.GetCharset: TQICharsetType;
begin
  Result := ctWinDefined;
  if Active then
    Result := FCharset
  else
    ThrowErrorWithNoParam(Format(QImportLoadStr(QIE_CSVGettingProperty), ['Charset']) + #13 +
                          QImportLoadStr(QIE_CSVOperationNotAllowedInInactiveState));
end;

procedure TCSVFileReader.SetCharset(const Value: TQICharsetType);
begin
  if (not Active) then
    FCharset := Value
  else
    ThrowErrorWithNoParam(Format(QImportLoadStr(QIE_CSVSettingProperty), ['Charset']) + #13 +
                          QImportLoadStr(QIE_CSVOperationNotAllowedInActiveState));
end;

procedure TCSVFileReader.SetFile(const AFileName: string);
begin
  if (not Active) then
    FFileName := AFileName
  else
    ThrowErrorWithNoParam(Format(QImportLoadStr(QIE_CSVSettingProperty), ['File']) + #13 +
                          QImportLoadStr(QIE_CSVOperationNotAllowedInActiveState));
end;

end.
