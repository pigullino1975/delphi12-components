unit QImport3XMLBased;

{$I QImport3VerCtrl.Inc}

interface

{$IFDEF VCL6}

uses
  {$IFDEF VCL16}
    System.StrUtils,
    System.Variants,
    Winapi.Windows,
    System.Classes,
    System.SysUtils,
    System.IniFiles,
  {$ELSE}
    StrUtils,
    Variants,
    Windows,
    Classes,
    SysUtils,
    IniFiles,
  {$ENDIF}
  QImport3StrTypes,
  QImport3,
  QImport3Common,
  QImport3XmlSax,
  QImport3BaseDocumentFile,
  QImport3ZipFile;

type
  TXMLSheet = class;

  TCell = class(TCollectionItem)
  private
    FRow: Integer;
    FCol: Integer;
    FValue: qiString;
    function GetSheet: TXMLSheet;
    procedure MapCell;
    procedure UnMapCell;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    property Value: qiString read FValue write FValue;
    property Row: Integer read FRow write FRow;
    property Col: Integer read FCol write FCol;
    property Sheet: TXMLSheet read GetSheet;
  end;

  TCellList = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TCell;
    procedure SetItem(Index: Integer; const Value: TCell);
  public
    function Add: TCell;
    property Items[Index: Integer]: TCell read GetItem write SetItem; default;
  end;

  TODCellList = class(TCellList)
  public
    function GetItemByCoords(X, Y: Integer): TCell;
  end;

  TCellMap = array of array of Pointer;

  TXMLSheet = class(TCollectionItem)
  private
    FName: string;
    FColCount: Integer;
    FRowCount: Integer;
    function GetCell(Col, Row: Integer): TCell;
    procedure SetCell(Col, Row: Integer; const Value: TCell);
  protected
    FCellMap: TCellMap;
    FCells: TCellList;
    function CreateCells: TCellList; virtual;
    procedure SetColCount(const Value: Integer); virtual;
    procedure SetRowCount(const Value: Integer); virtual;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    property Cell[Col, Row: Integer]: TCell read GetCell write SetCell;
    property Name: string read FName write FName;
    property ColCount: Integer read FColCount write SetColCount;
    property RowCount: Integer read FRowCount write SetRowCount;
  end;

  TXYSheet = class(TXMLSheet)
  private
    FX: Integer;
    FY: Integer;
  protected
    procedure SetX(const Value: Integer); virtual;
    procedure SetY(const Value: Integer); virtual;
  public
    constructor Create(Collection: TCollection); override;
    property X: Integer read FX write SetX;
    property Y: Integer read FY write SetY;
  end;

  TXMLSheetList = class(TCollection)
  private
    function GetItems(Index: integer): TXMLSheet;
    procedure SetItems(Index: integer; Value: TXMLSheet);
  public
    function Add: TXMLSheet;
    property Items[Index: integer]: TXMLSheet read GetItems write SetItems; default;
    function GetTableByName(Name: qiString): TXMLSheet;
  end;

  TXMLDocContainer = class
  private
    FWorkDir: string;
    FMaxRowCount: Integer;
  protected
    FSAXParser: TQISAXParser;
    FCurrentSheet: TXMLSheet;
    FParserFlag: Boolean;
    FParserArgument: Variant;
    FParserResult: string;
    FCurrentCell: TCell;
    FSheets: TXMLSheetList;
    procedure DoLoad; virtual;
    procedure DoBeforeLoad; virtual;
    procedure DoAfterLoad; virtual;
    function CreateSheets: TXMLSheetList; virtual;
    procedure OnGetCellText(Sender: TQIXMLStreamProcessor; const Text: qiString;
        TextType: TQIXMLTextType); virtual; abstract;
    procedure OnLoadSheet(Sender: TQIXMLStreamProcessor; const AName: qiString;
        Action: TQIXMLNodeAction); virtual; abstract;
    procedure LoadSheets; virtual; abstract;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Load;
    property WorkDir: string read FWorkDir write FWorkDir;
    property MaxRowCount: Integer read FMaxRowCount write FMaxRowCount;
  end;

  TODContainer = class(TXMLDocContainer)
  private
    procedure FindTables(NameOfFile: qiString);
  protected
    FileName: qiString;
    FColsRepeated: Integer;
    FRowsRepeated: Integer;
    procedure OnLoadSheet(Sender: TQIXMLStreamProcessor; const AName: qiString;
        Action: TQIXMLNodeAction); override;
    procedure ParseSheet(Sender: TQISAXParser; const AName: qiString); virtual; abstract;
    function GetErrorMsg: qiString; virtual; abstract;
    procedure LoadSheets; override;
  public
    constructor Create; override;
  end;

  TXMLDocumentFile = class(TBaseDocumentFile)
  protected
    procedure DoLoad; override;
    procedure LoadXML; virtual; abstract;
  end;

  TZipDocumentFile = class(TXMLDocumentFile)
  protected
    FContainer: TXMLDocContainer;
    FCurrFolder: qiString;
    procedure DoAfterLoad; override;
    procedure DoBeforeLoad; override;
    procedure DoLoad; override;
    function CreateContainer: TXMLDocContainer; virtual; abstract;
    procedure LoadXML; override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Decompress;
    procedure DeleteTempFolder;
  end;

  TXMLFile = class(TXMLDocumentFile)
  protected
    FXMLProcessor: TQIXMLStreamProcessor;
    FParserFlag: Boolean;
    FParserArgument: Variant;
    FParserResult: string;
    function GetXMLProcessorClass: TQIXMLStreamProcessorClass; virtual;
    procedure LoadXML; override;
  public
    constructor Create; override;
    destructor Destroy; override;
  end;

  TQImport3XMLBased = class(TQImport3)
  private
    FOnAfterAnalysis: TNotifyEvent;
    FOnBeforeAnalysis: TNotifyEvent;
  protected
    FCounter: Integer;
    FDocFile: TBaseDocumentFile;
    procedure ChangeCondition; override;
    function CheckCondition: Boolean; override;
    function CreateDocFile: TBaseDocumentFile; virtual; abstract;
    procedure LoadDocFile; virtual;
    procedure DoAfterImport; override;
    procedure DoBeforeImport; override;
    procedure FinishImport; override;
    function Skip: Boolean; override;
    procedure StartImport; override;
    function ImportData: TQImportResult; override;
    procedure DoBeforeAnalysis; dynamic;
    procedure DoAfterAnalysis; dynamic;
  published
    property FileName;
    property SkipFirstRows default 0;
    property OnAfterAnalysis: TNotifyEvent read FOnAfterAnalysis write FOnAfterAnalysis;
    property OnBeforeAnalysis: TNotifyEvent read FOnBeforeAnalysis write FOnBeforeAnalysis;
  end;

  TQImport3WorkbookBased = class(TQImport3XMLBased)
  private
    FSheetName: string;
    procedure SetSheetName(const Value: string);
  published
    property SheetName: string read FSheetName write SetSheetName;
  end;

{$ENDIF}

implementation

{$IFDEF VCL6}

{ TCell }

constructor TCell.Create(Collection: TCollection);
begin
  inherited;
  FCol := 0;
  FRow := 0;
  FValue := '';
end;

destructor TCell.Destroy;
begin
  UnMapCell;
  inherited Destroy;
end;

function TCell.GetSheet: TXMLSheet;
begin
  if Assigned(Collection) then
    Result := TXMLSheet(Collection.Owner)
  else
    Result := nil;
end;

procedure TCell.MapCell;
begin
  if not Assigned(Sheet) then
    Exit;
  Sheet.FCellMap[FCol, FRow] := Self;
end;

procedure TCell.UnMapCell;
begin
  if Assigned(Sheet) and (Sheet.FCellMap[Col, Row] = Self) then
    Sheet.FCellMap[Col, Row] := nil;
end;

{ TCellList }

function TCellList.Add: TCell;
begin
  Result := TCell(inherited Add);
end;

function TCellList.GetItem(Index: Integer): TCell;
begin
  Result := TCell(inherited Items[Index]);
end;

procedure TCellList.SetItem(Index: Integer; const Value: TCell);
begin
  inherited Items[Index] := Value;
end;

constructor TXMLSheet.Create(Collection: TCollection);
begin
  inherited;
  FColCount := 0;
  FRowCount := 0;
  FCells := CreateCells;
end;

destructor TXMLSheet.Destroy;
begin
  FCells.Free;
  inherited;
end;

function TXMLSheet.GetCell(Col, Row: Integer): TCell;
begin
  Result := TCell(FCellMap[Col, Row]);
end;

function TXMLSheet.CreateCells: TCellList;
begin
  Result := TCellList.Create(Self, TCell);
end;

procedure TXMLSheet.SetCell(Col, Row: Integer; const Value: TCell);
begin
  if RowCount < Row + 1 then
    RowCount := Row + 1;
  if ColCount < Col + 1 then
    ColCount := Col + 1;
  if Assigned(Value) then
  begin
    Value.Row := Row;
    Value.Col := Col;
    Value.MapCell;
  end
  else
    FCellMap[Col, Row] := Value;
end;

procedure TXMLSheet.SetColCount(const Value: Integer);
begin
  if FColCount <> Value then
  begin
    FColCount := Value;
    SetLength(FCellMap, Value, FRowCount);
  end;
end;

procedure TXMLSheet.SetRowCount(const Value: Integer);
begin
  if FRowCount <> Value then
  begin
    FRowCount := Value;
    SetLength(FCellMap, FColCount, Value);
  end;
end;

{ TXMLSheetList }

function TXMLSheetList.GetItems(Index: integer): TXMLSheet;
begin
  Result := TXMLSheet(inherited Items[Index]);
end;

procedure TXMLSheetList.SetItems(Index: integer;
  Value: TXMLSheet);
begin
  inherited Items[Index] := Value;
end;

function TXMLSheetList.Add: TXMLSheet;
begin
  Result := TXMLSheet(inherited Add);
end;

function TXMLSheetList.GetTableByName(Name: qiString): TXMLSheet;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Self.Count - 1 do
    if UpperCase(Items[i].Name) = UpperCase(Name) then
    begin
      Result := Items[i];
      Break;
    end;
end;

constructor TXMLDocContainer.Create;
begin
  inherited;
  FMaxRowCount := -1;
  FWorkDir := '';
  FSheets := CreateSheets;
end;

destructor TXMLDocContainer.Destroy;
begin
  FSheets.Free;
  inherited;
end;

procedure TXMLDocContainer.DoLoad;
begin
  LoadSheets;
end;

procedure TXMLDocContainer.DoBeforeLoad;
begin
end;

procedure TXMLDocContainer.DoAfterLoad;
begin
end;

function TXMLDocContainer.CreateSheets: TXMLSheetList;
begin
  Result := TXMLSheetList.Create(TXMLSheet);
end;

procedure TXMLDocContainer.Load;
begin
  FParserFlag := False;
  if Length(FWorkDir) > 0 then
  begin
    DoBeforeLoad;
    try
      FSAXParser := TQISAXParser.Create;
      try
        DoLoad;
      finally
        FreeAndNil(FSAXParser);
      end;
    finally
      DoAfterLoad;
    end;                
  end;
end;

procedure TQImport3XMLBased.ChangeCondition;
begin
  Inc(FCounter);
end;

function TQImport3XMLBased.CheckCondition: Boolean;
begin
  Result := FCounter < (FTotalRecCount + SkipFirstRows);
end;

procedure TQImport3XMLBased.DoBeforeAnalysis;
begin
  if Assigned(FOnBeforeAnalysis) then
    FOnBeforeAnalysis(Self);
end;

procedure TQImport3XMLBased.DoAfterAnalysis;
begin
  if Assigned(FOnAfterAnalysis) then
    FOnAfterAnalysis(Self);
end;

procedure TQImport3XMLBased.DoAfterImport;
begin
  FreeAndNil(FDocFile);
  inherited;
end;

procedure TQImport3XMLBased.DoBeforeImport;
begin
  FDocFile := CreateDocFile;
  if ImportRecCount > 0 then
    FDocFile.MaxRowCount := ImportRecCount + SkipFirstRows;
  FDocFile.FileName := FileName;
  LoadDocFile;
  inherited;
end;

procedure TQImport3XMLBased.FinishImport;
begin
  if not Canceled and not IsCSV then
  begin
    if CommitAfterDone then
      DoNeedCommit
    else if (CommitRecCount > 0) and ((ImportedRecs + ErrorRecs) mod CommitRecCount > 0) then
      DoNeedCommit;
  end;
end;

function TQImport3XMLBased.ImportData: TQImportResult;
begin
  Result := qirOk;
  try
    try
      if Canceled  and not CanContinue then
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

procedure TQImport3XMLBased.LoadDocFile;
begin
  FDocFile.Load;
end;

function TQImport3XMLBased.Skip: Boolean;
begin
  Result := (SkipFirstRows > 0) and (FCounter < SkipFirstRows);
end;

procedure TQImport3XMLBased.StartImport;
begin
  inherited;
  FCounter := 0;
end;

{ TZipDocumentFile }

constructor TZipDocumentFile.Create;
begin
  inherited;
  FContainer := CreateContainer;
end;

destructor TZipDocumentFile.Destroy;
begin
  FContainer.Free;
  inherited;
end;

procedure TZipDocumentFile.Decompress;

  function GetTempDir: string;
  var
    Buffer: array[0..MAX_PATH] of AnsiChar;
  begin
    GetTempPathA(SizeOf(Buffer) - 1, Buffer);
    Result := string(StrPas(Buffer));
  end;

var
  Guid: TGUID;
begin
  {$IFDEF VCL6}
  CreateGUID(Guid);
  FCurrFolder := IncludeTrailingPathDelimiter(GetTempDir) + GUIDToString(Guid) + '\';
  {$ELSE}
  FCurrFolder := ExtractFileDir(ParamStr(0)) + '\temp\';
  {$ENDIF}
  TQImport3ZipFile.Extract(FileName, FCurrFolder);
end;

procedure TZipDocumentFile.DeleteTempFolder;
begin
  FullRemoveDir(FCurrFolder, True, False, True);
end;

procedure TZipDocumentFile.DoAfterLoad;
begin
  DeleteTempFolder;
  inherited;
end;

procedure TZipDocumentFile.DoBeforeLoad;
begin
  inherited;
  if MaxRowCount > 0 then
    FContainer.MaxRowCount := MaxRowCount;
  Decompress;
end;

{ TZipDocumentFile }

procedure TZipDocumentFile.DoLoad;
begin
  if DirectoryExists(FCurrFolder) then
    inherited;
end;

procedure TZipDocumentFile.LoadXML;
begin
  inherited;
  FContainer.WorkDir := FCurrFolder;
  FContainer.Load;
end;

function TODCellList.GetItemByCoords(X, Y: Integer): TCell;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Self.Count - 1 do
    if (Items[i].Row = Y) and (Items[i].Col = X) then
    begin
      Result := Items[i];
      Break;
    end;
end;

{ TXYSheet }

constructor TXYSheet.Create(Collection: TCollection);
begin
  inherited;
  FX := -1;
  FY := -1;
end;

procedure TXYSheet.SetX(const Value: Integer);
begin
  FX := Value;
end;

procedure TXYSheet.SetY(const Value: Integer);
begin
  FY := Value;
end;

constructor TODContainer.Create;
begin
  inherited;
  FileName := '';
end;

{ TODContainer }

procedure TODContainer.FindTables(NameOfFile: qiString);
begin
  FSAXParser.OnLoadElement := OnLoadSheet;
  FSAXParser.OnGetText := OnGetCellText;
  FSAXParser.Parse(NameOfFile);
  if FSheets.Count = 0 then
    raise Exception.Create(GetErrorMsg);
end;

procedure TODContainer.OnLoadSheet(Sender: TQIXMLStreamProcessor; const AName:
    qiString; Action: TQIXMLNodeAction);
begin
  if not (Assigned(Sender) and (Action = xnaOpen)) then
    Exit;
  ParseSheet(TQISAXParser(Sender), AName);
end;

procedure TODContainer.LoadSheets;
var
  SRec: TSearchRec;
begin
  if FindFirst(FWorkDir + 'content.xml', faDirectory, SRec) = 0 then
  try
    FindTables(FWorkDir + 'content.xml');
  finally
    {$IFDEF VCL16}System.{$ENDIF}SysUtils.FindClose(SRec);
  end
  else
    FindTables(FWorkDir + FileName);
end;

{ TQImport3WorkbookBased }

procedure TQImport3WorkbookBased.SetSheetName(const Value: string);
begin
  if FSheetName <> Value then
    FSheetName := Value;
end;

{ TXMLFile }

constructor TXMLFile.Create;
begin
  inherited;
  FXMLProcessor := GetXMLProcessorClass.Create;
end;

destructor TXMLFile.Destroy;
begin
  FreeAndNil(FXMLProcessor);
  inherited;
end;

function TXMLFile.GetXMLProcessorClass: TQIXMLStreamProcessorClass;
begin
  Result := TQIXMLStreamProcessor;
end;

procedure TXMLFile.LoadXML;
begin
  inherited;
  FParserFlag := False;
end;

{ TXMLDocumentFile }

procedure TXMLDocumentFile.DoLoad;
begin
  LoadXML;
  inherited;
end;

{$ENDIF}

end.


