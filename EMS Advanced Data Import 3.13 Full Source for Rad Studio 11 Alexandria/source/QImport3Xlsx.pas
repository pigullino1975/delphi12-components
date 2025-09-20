unit QImport3Xlsx;

{$I QImport3VerCtrl.Inc}

interface

{$IFDEF XLSX}

uses
  {$IFDEF VCL16}
    System.Classes,
    System.SysUtils,
    System.IniFiles,
    System.StrUtils,
    System.Variants,
  {$ELSE}
    Classes,
    SysUtils,
    IniFiles,
    StrUtils,
    Variants,
  {$ENDIF}
  QImport3StrTypes,
  QImport3,
  QImport3Common,
  QImport3XMLBased,
  QImport3XlsxMapParser,
  QImport3XmlSax,
  QImport3BaseDocumentFile;

type
  TXlsxStyle = class(TCollectionItem)
  private
    FNumFmtId: Integer;
    FFormatString: String;
  public
    property NumFmtId: Integer read FNumFmtId write FNumFmtId;
    property FormatString: String read FFormatString write FFormatString;
  end;

  TXlsxStyleList = class(TCollection)
  private
    function GetItem(Index: Integer): TXlsxStyle;
    procedure SetItem(Index: Integer; const Value: TXlsxStyle);
  public
    function Add: TXlsxStyle;
    function FindByNumFmtId(NumFmtId: Integer; var TheXlsxStyle: TXlsxStyle): Boolean;
    procedure SetFormatStringByNumFmtId(const NumFmtId: Integer;
      const FormatString: String);

    property Items[Index: Integer]: TXlsxStyle read GetItem write SetItem; default;
  end;

  TXlsxMerge = class(TCollectionItem)
  private
    FRange: qiString;
    FValue: qiString;
    FBeginRow: Integer;
    FBeginCol: Integer;
    FEndRow: Integer;
    FEndCol: Integer;
    FFirstCellName: qiString;
    procedure SetRange(const Value: qiString);
  public
    property Range: qiString read FRange write SetRange;
    property Value: qiString read FValue write FValue;
    property FirstCellName: qiString read FFirstCellName;
    property BeginRow: Integer read FBeginRow;
    property BeginCol: Integer read FBeginCol;
    property EndRow: Integer read FEndRow;
    property EndCol: Integer read FEndCol;
  end;

  TXlsxMergeList = class(TCollection)
  private
    function GetItem(Index: Integer): TXlsxMerge;
    procedure SetItem(Index: Integer; const Value: TXlsxMerge);
  public
    function Add: TXlsxMerge;
    property Items[Index: Integer]: TXlsxMerge read GetItem write SetItem; default;
  end;

  TXlsxWorkSheet = class;

  TXlsxCell = class(TCell)
  private
    FName: string;
    FFormula: string;
    FIsFormulaExist: Boolean;
    FIsMerge: Boolean;
    procedure SetFormula(const Value: string);
    function GetName: string;
    procedure SetName(const Value: string);
  public
    constructor Create(Collection: TCollection); override;
    property Name: string read GetName write SetName;
    property IsMerge: Boolean read FIsMerge write FIsMerge;
    property Formula: string read FFormula write SetFormula;
    property IsFormulaExist: Boolean read FIsFormulaExist;
  end;

  TXlsxCellList = class(TCellList)
  private
    function GetItem(Index: Integer): TXlsxCell;
    procedure SetItem(Index: Integer; const Value: TXlsxCell);
  public
    function Add: TXlsxCell;
    property Items[Index: Integer]: TXlsxCell read GetItem write SetItem; default;
  end;

  TXlsxWorkSheet = class(TXMLSheet)
  private
    FSheetID: integer;
    FMergeCells: TXlsxMergeList;
    FIsHidden: boolean;
    FFileName: qiString;
    function GetCell(Col, Row: Integer): TXlsxCell;
    function GetCells: TXlsxCellList;
    procedure SetCell(Col, Row: Integer; const Value: TXlsxCell);
    procedure SetSheetID(const Value: integer);
  protected
    function CreateCells: TCellList; override;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure FillMerge(Cell: TXlsxCell);
    property Cell[Col, Row: Integer]: TXlsxCell read GetCell write SetCell;
    property SheetID: integer read FSheetID write SetSheetID;
    property Cells: TXlsxCellList read GetCells;
    property MergeCells: TXlsxMergeList read FMergeCells;
    property IsHidden: boolean read FIsHidden write FIsHidden;
    property FileName: qiString read FFileName write FFileName;
  end;

  TXlsxWorkSheetList = class(TXMLSheetList)
  private
    function GetItems(Index: integer): TXlsxWorkSheet;
    procedure SetItems(Index: integer; Value: TXlsxWorkSheet);
  public
    function Add: TXlsxWorkSheet;
    property Items[Index: integer]: TXlsxWorkSheet read GetItems write SetItems; default;
    function GetFirstSheet: TXlsxWorkSheet;
    function GetSheetByName(Name: qiString): TXlsxWorkSheet;
    function GetSheetByID(id: integer): TXlsxWorkSheet;
  end;

  TXMLCType = record
    NodeValueT: Variant;
    NodeValueV: Variant;
    NodeValueS: Variant;
    ValueIsT: WideString;
  end;
  PXMLCType = ^TXMLCType;

  TXlsxWorkbook = class(TXMLDocContainer)
  private
    FCurrentValue: PXMLCType;
    FSharedStringCache: qiString;
    FStylesXfs: TXlsxStyleList;
    FStylesFmt: TXlsxStyleList;
    FLoadHiddenSheets: Boolean;
    FNeedFillMerge: Boolean;
    FImportRecCount: Integer;
    procedure CompressCells;
    procedure LoadSharedStrings;
    procedure LoadStyles;
    procedure LoadWorkSheets;
    function FormatValueByStyle(const Style: TXlsxStyle;
      const Value: Variant): Variant;
    function GetSheets: TXlsxWorkSheetList;
    function GetCurrentSheet: TXlsxWorkSheet;
    function GetCurrentCell: TXlsxCell;
    procedure OnLoadStyle(Sender: TQIXMLStreamProcessor; const AName: qiString;
        Action: TQIXMLNodeAction);
    procedure OnLoadRelationship(Sender: TQIXMLStreamProcessor; const AName:
        qiString; Action: TQIXMLNodeAction);
    procedure OnGetSharedString(Sender: TQIXMLStreamProcessor; const Text:
        qiString; TextType: TQIXMLTextType);
    procedure OnLoadElement(Sender: TQIXMLStreamProcessor; const Name: qiString;
        Action: TQIXMLNodeAction);
    procedure OnLoadCell(Sender: TQIXMLStreamProcessor; const AName: qiString;
        Action: TQIXMLNodeAction);
    procedure SetCurrentSheet(const Value: TXlsxWorkSheet);
  protected
    FSharedStrings: TqiStrings;
    procedure LoadSheet(SheetFile: qiString; Id: integer); virtual;
    function GetCellValue(const XlsxCell: PXMLCType): Variant; virtual;
    procedure DoLoad; override;
    function CreateSheets: TXMLSheetList; override;
    procedure LoadSheets; override;
    procedure OnGetCellText(Sender: TQIXMLStreamProcessor; const Text: qiString;
        TextType: TQIXMLTextType); override;
    procedure OnLoadSheet(Sender: TQIXMLStreamProcessor; const AName: qiString;
        Action: TQIXMLNodeAction); override;
    property CurrentSheet: TXlsxWorkSheet read GetCurrentSheet write
        SetCurrentSheet;
    property CurrentCell: TXlsxCell read GetCurrentCell;
  public
    constructor Create; override;
    destructor Destroy; override;
    property WorkSheets: TXlsxWorkSheetList read GetSheets;
    property LoadHiddenSheets: Boolean read FLoadHiddenSheets write FLoadHiddenSheets;
    property NeedFillMerge: Boolean read FNeedFillMerge write FNeedFillMerge;
    property ImportRecCount: Integer read FImportRecCount write FImportRecCount;
  end;

  TXlsxDirectReadWorkbook = class(TXlsxWorkbook)
  protected
    procedure LoadSheet(SheetFile: qiString; Id: integer); override;
  public
    function GetCellValue(const XlsxCell: PXMLCType): Variant; override;
    procedure FreeSharedStrings;
  end;

  TXlsxFile = class(TZipDocumentFile)
  private
    function GetWorkbook: TXlsxWorkbook;
  protected
    function CreateContainer: TXMLDocContainer; override;
  public
    property Workbook: TXlsxWorkbook read GetWorkbook;
  end;

  TXlsxDirectReadFile = class(TXlsxFile)
  protected
    procedure DoAfterLoad; override;
    function CreateContainer: TXMLDocContainer; override;
  public
    property DocFolder: qiString read FCurrFolder;
  end;

  TXlsxWorksheetReader = class
  private
    FTmpDocFolder: qiString;
    FSAXParser: TQIDirectReadParser;
    FWorksheetFileName: string;
    FParserResult: string;
    FCurrentValue: PXMLCType;
    FXlsxWorkbook: TXlsxDirectReadWorkbook;
    FCurrentCol: Integer;
    FCurrentRow: Integer;
    FCellValue: Variant;
    FCellValueExtracted: Boolean;
    FEof: Boolean;
    procedure ReopenWorksheet(const WorksheetFileName: string);
    procedure DeleteTmpDocFolder;
    function GetDataCell(Col, Row: Integer): qiString;
    function DataAvailable(Col, Row: Integer; var CellValue: qiString): Boolean;
  public
    constructor Create(const TmpDocFolder: string);
    destructor Destroy; override;
    procedure OpenWorkSheet(const XlsxWorkbook: TXlsxWorkbook; const WorksheetFileName: string);
    procedure OnLoadCell(Sender: TQIXMLStreamProcessor; const AName: qiString; Action: TQIXMLNodeAction);
    procedure OnGetCellText(Sender: TQIXMLStreamProcessor; const Text: qiString; TextType: TQIXMLTextType);
    property Cell[Col, Row: Integer]: qiString read GetDataCell;
    property Eof: Boolean read FEof;
  end;

  TXlsxTempRowData = array of qiString;

  TQImport3Xlsx = class(TQImport3WorkbookBased)
  private
    FWorksheetReader: TXlsxWorksheetReader;
    FSheetName: string;
    FLoadHiddenSheet: Boolean;
    FNeedFillMerge: Boolean;
    FMapParserRows: TXlsxMapParserItems;
    FEndImportFlag: Boolean;
    FCurrentRow: Integer;
    FCurrentCol: Integer;
    FTempRowData: TXlsxTempRowData;
    procedure SetSheetName(const Value: string);
    procedure SetLoadHiddenSheet(const Value: Boolean);
    procedure SetNeedFillMerge(const Value: Boolean);
    procedure ParseMap;
  protected
    procedure DoBeforeImport; override;
    procedure DoAfterImport; override;
    function CheckCondition: Boolean; override;
    procedure FillImportRow; override;
    function ImportData: TQImportResult; override;
    procedure DoLoadConfiguration(IniFile: TIniFile); override;
    procedure DoSaveConfiguration(IniFile: TIniFile); override;
    procedure DoUserDefinedImport; override;
    function AllowImportRowComplete: Boolean; override;
    function CreateDocFile: TBaseDocumentFile; override;
    procedure LoadDocFile; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property FileName;
    property SkipFirstRows default 0;
    property SkipFirstCols default 0;
    property SheetName: string read FSheetName write SetSheetName;
    property LoadHiddenSheet: boolean read FLoadHiddenSheet
      write SetLoadHiddenSheet default False;
    property NeedFillMerge: Boolean read FNeedFillMerge
      write SetNeedFillMerge default False;
  end;

{$ENDIF}

implementation

{$IFDEF XLSX}

function XlsxFloatFormat(const StrValue: String; var ResultValue: Variant): Boolean;
var
  TempStrValue: String;
  TempResultValue: Extended;
begin
  TempStrValue := StrValue;
  {$IFDEF VCL6}
    TempStrValue := AnsiReplaceStr(TempStrValue, '.', {$IFDEF VCL17}FormatSettings.{$ENDIF}DecimalSeparator);
  {$ELSE}
    TempStrValue := StringReplace(TempStrValue, '.', DecimalSeparator);
  {$ENDIF}

  {$IFDEF VCL7}
    Result := TryStrToFloat(TempStrValue, TempResultValue);
    if Result then
      ResultValue := TempResultValue;
  {$ELSE}
    try
      TempResultValue := StrToFloat(TempStrValue);
      ResultValue := TempResultValue;
      Result := True;
    except
      Result := False;
    end;
  {$ENDIF}
end;

function XlsxDateTimeFormat(const DateTime: string): TDateTime;
var
  TempStr: string;
const
  cXMLDelimiter = '.';
begin
  TempStr := DateTime;
  if {$IFDEF VCL17}FormatSettings.{$ENDIF}DecimalSeparator <> cXMLDelimiter then
    if Pos(cXMLDelimiter, TempStr) > 0 then
      {$IFDEF VCL6}
      TempStr := AnsiReplaceStr(DateTime, cXMLDelimiter, {$IFDEF VCL17}FormatSettings.{$ENDIF}DecimalSeparator);
      {$ELSE}
      TempStr := StringReplace(DateTime, cXMLDelimiter, DecimalSeparator, [rfReplaceAll, rfIgnoreCase]);
      {$ENDIF}
  Result := StrToFloat(TempStr);
end;

{$IFNDEF VCL6}
function BoolToStr(B: Boolean; UseBoolStrs: Boolean = False): AnsiString;
const
  cSimpleBoolStrs: array [boolean] of AnsiString = ('0', '-1');
begin
  if UseBoolStrs then
  begin
    if B then
      Result := 'True'
    else
      Result := 'False';
  end
  else
    Result := cSimpleBoolStrs[B];
end;
{$ENDIF}

function FormatData(s: string; i: Integer; var r: Double): boolean;
begin
  {$IFDEF VCL7}
    Result := TryStrToFloat(s, r);
    if Result then
      r := Round(r * exp(i * ln(10))) / (exp(i * ln(10)));
  {$ELSE}
    try
      r := Round(StrToFloat(s) * exp(i * ln(10))) / (exp(i * ln(10)));
      Result := True;
    except
      Result := False;
    end;
  {$ENDIF}
end;

function GetXlsxPrecentValue(const AValue: string): string;
var
  snum: string;
  dnum: Double;
  i, digits: Integer;
begin
  Result := AValue;
  {e.g. format 3.2142857142857099E-3}
  if Pos('E-', AValue) > 0 then
  begin
    snum := Copy(AValue, 1, Pos('E-', AValue) - 1);
    if
      {$IFDEF VCL6}
      FormatData(AnsiReplaceStr(snum, '.', {$IFDEF VCL17}FormatSettings.{$ENDIF}DecimalSeparator), 2, dnum)
      {$ELSE}
      FormatData(StringReplace(snum, '.', DecimalSeparator), 2, dnum)
      {$ENDIF} then
    begin
      digits := StrToIntDef(Copy(AValue, Pos('E-', AValue) + 2, Length(AValue)), 0) - 2;
      for i := 0 to digits - 1 do
        dnum := dnum / 10;
      Result := FormatFloat('0.00%', dnum);
    end;
  end else
  {e.g. format 0.55200000000000005}
  begin
    if
      {$IFDEF VCL6}
      FormatData(AnsiReplaceStr(AValue, '.', {$IFDEF VCL17}FormatSettings.{$ENDIF}DecimalSeparator), 4, dnum)
      {$ELSE}
      FormatData(StringReplace(AValue, '.', {$IFDEF VCL17}FormatSettings.{$ENDIF}DecimalSeparator), 4, dnum)
      {$ENDIF} then
    begin
      Result := FormatFloat('0.00%', dnum * 100);
    end;
  end;
end;


{ TXlsxStyleList }

function TXlsxStyleList.FindByNumFmtId(NumFmtId: Integer;
  var TheXlsxStyle: TXlsxStyle): Boolean;
var
  I: Integer;
begin
  TheXlsxStyle := nil;
  for I := 0 to Count - 1 do
    if (Items[I].NumFmtId = NumFmtId) and (Items[I].NumFmtId >= 0) then
      TheXlsxStyle := Items[I];
  Result := Assigned(TheXlsxStyle);
end;

function TXlsxStyleList.GetItem(Index: Integer): TXlsxStyle;
begin
  Result := TXlsxStyle(inherited Items[Index]);
end;

procedure TXlsxStyleList.SetItem(Index: Integer; const Value: TXlsxStyle);
begin
  inherited Items[Index] := Value;
end;

function TXlsxStyleList.Add: TXlsxStyle;
begin
  Result := TXlsxStyle(inherited Add);
end;

procedure TXlsxStyleList.SetFormatStringByNumFmtId(const NumFmtId: Integer;
  const FormatString: String);
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    if Items[I].NumFmtId = NumFmtId then
      Items[I].FormatString := FormatString;
end;

{ TXlsxMerge }

procedure TXlsxMerge.SetRange(const Value: qiString);
begin
  if FRange <> Value then
  begin
    FRange := Value;
    FFirstCellName := Copy(Value, 1, Pos(':', Value) - 1);
    FBeginCol := GetColIdFromString(FFirstCellName);
    FBeginRow := GetRowIdFromString(FFirstCellName);
    FEndCol := GetColIdFromString(Copy(Value, Pos(':', Value)+ 1, Length(Value)));
    FEndRow := GetRowIdFromString(Copy(Value, Pos(':', Value)+ 1, Length(Value)));
  end;
end;

{ TXlsxMergeList }

function TXlsxMergeList.GetItem(Index: Integer): TXlsxMerge;
begin
  Result := TXlsxMerge(inherited Items[Index]);
end;

procedure TXlsxMergeList.SetItem(Index: Integer;
  const Value: TXlsxMerge);
begin
  inherited Items[Index] := Value;
end;

function TXlsxMergeList.Add: TXlsxMerge;
begin
  Result := TXlsxMerge(inherited Add);
end;

{ TXlsxCell }

constructor TXlsxCell.Create(Collection: TCollection);
begin
  inherited;
  FName := '';
  FIsMerge := False;
  FFormula := '';
  FIsFormulaExist := False;
end;

procedure TXlsxCell.SetFormula(const Value: string);
begin
  if FFormula <> Value then
  begin
    FFormula := Value;
    FIsFormulaExist := True;
  end;
end;

function TXlsxCell.GetName: string;
begin
  if not Self.IsMerge then
    Result := FName
  else
    Result := 'Merge';
end;

procedure TXlsxCell.SetName(const Value: string);
begin
  if not Self.IsMerge then
    FName := Value;
end;

{ TXlsxCellList }

function TXlsxCellList.Add: TXlsxCell;
begin
  Result := TXlsxCell(inherited Add);
end;

function TXlsxCellList.GetItem(Index: Integer): TXlsxCell;
begin
  Result := TXlsxCell(inherited Items[Index]);
end;

procedure TXlsxCellList.SetItem(Index: Integer; const Value: TXlsxCell);
begin
  inherited Items[Index] := Value;
end;

{ TXlsxWorkSheet }

procedure TXlsxWorkSheet.SetSheetID(const Value: integer);
const
  sSheetIDCheck = 'Sheet ID must be >= 0!';
begin
  if Value < 0 then
    raise Exception.Create(sSheetIDCheck);

  if FSheetID <> Value then
    FSheetID := Value;
end;

constructor TXlsxWorkSheet.Create(Collection: TCollection);
begin
  inherited;
  FIsHidden := False;
  FMergeCells := TXlsxMergeList.Create(TXlsxMerge);
end;

destructor TXlsxWorkSheet.Destroy;
begin
  FMergeCells.Free;
  inherited;
end;

procedure TXlsxWorkSheet.FillMerge(Cell: TXlsxCell);
var
  i: Integer;
begin
  for i := 0 to FMergeCells.Count - 1 do
    if (Cell.Row in [FMergeCells[i].BeginRow..FMergeCells[i].EndRow]) and
      (Cell.Col in [FMergeCells[i].BeginCol..FMergeCells[i].EndCol]) and
      (not ((Cell.Row = FMergeCells[i].BeginRow) and (Cell.Col = FMergeCells[i].BeginCol)))
    then Cell.Value := FMergeCells[i].Value;
end;

function TXlsxWorkSheet.GetCell(Col, Row: Integer): TXlsxCell;
begin
  Result := TXlsxCell(inherited Cell[Col, Row]);
end;

function TXlsxWorkSheet.GetCells: TXlsxCellList;
begin
  Result := TXlsxCellList(FCells);
end;

function TXlsxWorkSheet.CreateCells: TCellList;
begin
  Result := TXlsxCellList.Create(Self, TXlsxCell);
end;

procedure TXlsxWorkSheet.SetCell(Col, Row: Integer; const Value: TXlsxCell);
begin
  inherited Cell[Col, Row] := Value;
end;

{ TXlsxWorkSheetList }

function TXlsxWorkSheetList.GetItems(Index: integer): TXlsxWorkSheet;
begin
  Result := TXlsxWorkSheet(inherited Items[Index]);
end;

procedure TXlsxWorkSheetList.SetItems(Index: integer;
  Value: TXlsxWorkSheet);
begin
  inherited Items[Index] := Value;
end;

function TXlsxWorkSheetList.Add: TXlsxWorkSheet;
begin
  Result := TXlsxWorkSheet(inherited Add);
end;

function TXlsxWorkSheetList.GetFirstSheet: TXlsxWorkSheet;
const
  sSheetCountMustBeMore0 = 'Sheets Count must be > 0!';
begin
  if Self.Count > 0 then
    Result := Items[0]
  else
    raise Exception.Create(sSheetCountMustBeMore0);
end;

function TXlsxWorkSheetList.GetSheetByName(Name: qiString): TXlsxWorkSheet;
begin
  if Name = qiString('') then
    Result := GetFirstSheet
  else
    Result := TXlsxWorkSheet(inherited GetTableByName(Name));
end;

function TXlsxWorkSheetList.GetSheetByID(id: integer): TXlsxWorkSheet;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Self.Count - 1 do
    if Items[i].SheetID = id then
    begin
      Result := Items[i];
      Break;
    end;
end;

{ TXlsxWorkbook }

procedure TXlsxWorkbook.LoadSharedStrings;
var
  Path: string;
  ARec: TSearchRec;
begin
  Path := WorkDir + 'xl\sharedStrings.xml';
  if (FindFirst(Path, faAnyFile, ARec) = 0) then
  try
    if FImportRecCount = 0 then
      FImportRecCount := -1;
    FSAXParser.OnGetText := OnGetSharedString;
    FSAXParser.OnLoadElement := OnLoadElement;
    FSAXParser.Parse(Path);
  finally
    FindClose(ARec);
  end;
end;

procedure TXlsxWorkbook.LoadStyles;
var
  Path: string;
  XmlFileRec: TSearchRec;
  I: Integer;
begin
  Path := WorkDir + 'xl\styles.xml';
  if FindFirst(Path, faAnyFile, XmlFileRec) = 0 then
  try
    FSAXParser.OnLoadElement := OnLoadStyle;
    FSAXParser.Parse(Path);
    for I := 0 to FStylesFmt.Count - 1 do
      FStylesXfs.SetFormatStringByNumFmtId(FStylesFmt[I].NumFmtId, FStylesFmt[I].FormatString);
  finally
    FindClose(XmlFileRec);
  end;
end;

function GetSheetID(const r_id: string): integer;
begin
  Result := StrToIntDef(Copy(r_id, 4, Length(r_id) - 3),{0} -1);
end;

procedure TXlsxWorkbook.LoadSheets;
var
  Path: string;
  ARec: TSearchRec;
begin
  Path := WorkDir + 'xl\workbook.xml';
  if FindFirst(Path, faAnyFile, ARec) = 0 then
  try
    FSAXParser.OnLoadElement := OnLoadSheet;
    FSAXParser.Parse(Path);
  finally
    FindClose(ARec);
  end;
end;

procedure TXlsxWorkbook.LoadWorkSheets;
var
  Path: string;
  SRec: TSearchRec;
  i: integer;
  filename: string;
begin
  Path := WorkDir + 'xl\_rels\workbook.xml.rels';
  if FindFirst(Path, faDirectory, SRec) = 0 then
  try
    for i := 0 to WorkSheets.Count - 1 do
    begin
      FParserArgument := WorkSheets[i].SheetID;
      FParserResult := '';
      FSAXParser.OnLoadElement := OnLoadRelationship;
      FSAXParser.Parse(Path);
      if FParserResult <> '' then
      begin
        filename := WorkDir + 'xl\' + FParserResult;
        filename := StringReplace(filename, 'xl\\xl\','xl\',[]);
        LoadSheet( filename, WorkSheets[i].SheetID);
      end;
    end;
  finally
    FindClose(SRec);
  end;
end;

procedure TXlsxWorkbook.LoadSheet(SheetFile: qiString; Id: integer);
var
  SRec: TSearchRec;
  I, J: Integer;
  Cell: TXlsxCell;
begin
  if FindFirst(SheetFile, faDirectory, SRec) = 0 then
  try
    CurrentSheet := WorkSheets.GetSheetByID(id);
    if Assigned(CurrentSheet) then
    begin
      CurrentSheet.FileName := SheetFile;
      FSAXParser.OnLoadElement := OnLoadCell;
      FSAXParser.OnGetText := OnGetCellText;
      FSAXParser.Parse(SheetFile);
      for I := 0 to CurrentSheet.Cells.Count - 1 do
      begin
        Cell := CurrentSheet.Cells[I];
        for J := 0 to CurrentSheet.MergeCells.Count - 1 do
          if CurrentSheet.MergeCells[J].FirstCellName = Cell.Name then
            CurrentSheet.MergeCells[J].Value := Cell.Value;
        if NeedFillMerge then
          CurrentSheet.FillMerge(Cell);
      end;
    end;
  finally
    FindClose(SRec);
  end;
end;

function TXlsxWorkbook.FormatValueByStyle(const Style: TXlsxStyle; const Value: Variant): Variant;
type
  TXlsxFormatType = (xftUnknown, xftDate, xftTime, xftDateTime, xftPercent);

  function GetFormatByMask(const Mask: String): TXlsxFormatType;
  const
    DateFlags: array[0..4] of String[2] = ('/m', 'm/', '/M', 'M/', 'yy');
    TimeFlags: array[0..5] of String[2] = (':m', 'm:', ':m', 'm:', ':n', 'n:');
  var
    IsTime,
    IsDate: Boolean;
    I: Integer;
  begin
    Result := xftUnknown;

    for I := 0 to Length(DateFlags) - 1 do
    begin
      IsDate := Pos(String(DateFlags[I]), Style.FormatString) > 0;
      if IsDate then
        Break;
    end;
    for I := 0 to Length(TimeFlags) - 1 do
    begin
      IsTime := Pos(String(TimeFlags[I]), Style.FormatString) > 0;
      if IsTime then
        Break;
    end;

    if IsDate and IsTime then
      Result := xftDateTime
    else
      if IsDate then
        Result := xftDate
      else
        if IsTime then
          Result := xftTime;
  end;

var
  XlsxFormatType: TXlsxFormatType;
begin
  Result := Null;
  if VarIsNull(Value) or (VarToStr(Value) = EmptyStr) then
    Exit;

  XlsxFormatType := xftUnknown;
  case Style.NumFmtId of
    14..17, 164..187:
      if (Style.FormatString = '') and (Style.NumFmtId < 164) then
        XlsxFormatType := xftDate
      else
        XlsxFormatType := GetFormatByMask(Style.FormatString);
    18..21, 45..47:
      XlsxFormatType := xftTime;
    22:
      XlsxFormatType := xftDateTime;
    9, 10:
      XlsxFormatType := xftPercent;
  end;

  case XlsxFormatType of
    xftDate:
      if XlsxFloatFormat(VarToStr(Value), Result) then
        Result := DateToStr(XlsxDateTimeFormat(
          VarToStr(Value)));
    xftTime:
      Result := TimeToStr(XlsxDateTimeFormat(
        VarToStr(Value)));
    xftDateTime:
      Result := DateTimeToStr(XlsxDateTimeFormat(
        VarToStr(Value)));
    xftPercent:
      Result := GetXlsxPrecentValue(VarToStr(Value));
 {   xftUnknown:
      Result := Value; }
  end;
end;

constructor TXlsxWorkbook.Create;
begin
  inherited;
  FStylesXfs := TXlsxStyleList.Create(TXlsxStyle);
  FStylesFmt := TXlsxStyleList.Create(TXlsxStyle);
  FSharedStrings := TqiStringList.Create;
  FSharedStringCache := EmptyStr;
  FLoadHiddenSheets := False;
  FNeedFillMerge := False;
  FImportRecCount := -1;
end;

destructor TXlsxWorkbook.Destroy;
begin
  FreeAndNil(FSharedStrings);
  FreeAndNil(FStylesXfs);
  FreeAndNil(FStylesFmt);
  inherited;
end;

procedure TXlsxWorkbook.DoLoad;
begin
  LoadSharedStrings;
  LoadStyles;
  inherited;
  LoadWorkSheets;
  CompressCells;
end;

procedure TXlsxWorkbook.CompressCells;
var
  SheetNum, I, J: Integer;
  WorkSheet: TXlsxWorkSheet;
begin
  for SheetNum := 0 to WorkSheets.Count - 1 do
  begin
    WorkSheet := WorkSheets[SheetNum];
    if not Assigned(WorkSheet) or (WorkSheet.ColCount = 0) or (WorkSheet.RowCount = 0) then
      Continue;

    I := WorkSheet.ColCount - 1;
    J := WorkSheet.RowCount - 1;
    while WorkSheet.Cell[I, J] = nil do
    begin
      Dec(I);
      if I = -1 then
      begin
        I := WorkSheet.ColCount - 1;
        Dec(J);
      end;
    end;
    if J < WorkSheet.RowCount - 1 then
      WorkSheet.RowCount := J + 1;

    if WorkSheet.RowCount = 0 then
      Continue;

    I := WorkSheet.ColCount - 1;
    J := WorkSheet.RowCount - 1;
    while WorkSheet.Cell[I, J] = nil do
    begin
      Dec(J);
      if J = -1 then
      begin
        J := WorkSheet.RowCount - 1;
        Dec(I)
      end;
    end;
    if I < WorkSheet.ColCount - 1 then
      WorkSheet.ColCount := I + 1;
  end;
end;

function TXlsxWorkbook.GetCellValue(const XlsxCell: PXMLCType): Variant;
var
  NodeValueT: Variant;
  NodeValueV: Variant;
  NodeValueS: Variant;
  StyleIndex: Integer;
  Ind: Double;
begin
  NodeValueT := XlsxCell.NodeValueT;
  NodeValueS := XlsxCell.NodeValueS;
  NodeValueV := XlsxCell.NodeValueV;
  Result := null;
  if Assigned(FSharedStrings) and (NodeValueT = 's') and not VarIsNull(NodeValueV) then
  begin
    Ind := StrToFloatDef(NodeValueV, -1);
    if (Ind < 0) or (Ind >= FSharedStrings.Count) then
    begin
      Result := Null;
      Exit;
    end
    else
      Result := FSharedStrings[Round(NodeValueV)];
  end
  else if (NodeValueT = 'str') and not VarIsNull(NodeValueV) then
    Result := NodeValueV
  else if NodeValueT = 'inlineStr' then
  begin
    if XlsxCell.ValueIsT <> '' then
      Result := XlsxCell.ValueIsT;
  end
  else if (NodeValueT = 'b') and not VarIsNull(NodeValueV) then
    Result := BoolToStr(Boolean(StrToIntDef(NodeValueV, 0)), True)
  else if Assigned(FStylesXfs) and not VarIsNull(NodeValueS) then
  begin
    StyleIndex := NodeValueS;
    if (FStylesXfs.Count > StyleIndex) and (StyleIndex >= 0) then
      Result := FormatValueByStyle(FStylesXfs[StyleIndex], NodeValueV);
  end;
  if VarIsNull(Result) and not VarIsNull(NodeValueV) and
    not XlsxFloatFormat(VarToStr(NodeValueV), Result) then
    Result := NodeValueV;
end;

function TXlsxWorkbook.GetSheets: TXlsxWorkSheetList;
begin
  Result := TXlsxWorkSheetList(FSheets);
end;

function TXlsxWorkbook.CreateSheets: TXMLSheetList;
begin
  Result := TXlsxWorkSheetList.Create(TXlsxWorkSheet);
end;

function TXlsxWorkbook.GetCurrentSheet: TXlsxWorkSheet;
begin
  Result := TXlsxWorkSheet(FCurrentSheet);
end;

function TXlsxWorkbook.GetCurrentCell: TXlsxCell;
begin
  Result := TXlsxCell(FCurrentCell);
end;

procedure TXlsxWorkbook.OnLoadSheet(Sender: TQIXMLStreamProcessor; const AName: qiString; Action: TQIXMLNodeAction);
var
  Name, Value: qiString;
  TempWorkSheet: TXlsxWorkSheet;
begin
  if not (Assigned(Sender) and (Action = xnaOpen) and (AName = 'sheet')) then
    Exit;
  TempWorkSheet := WorkSheets.Add;
  while Sender.GetNextAttribute(Name, Value) do
  begin
    if Name = 'name' then
      TempWorkSheet.Name := Value
    else if (Name = 'state') and (Value = 'hidden') then
      TempWorkSheet.IsHidden := True
    else if Name = 'r:id' then
      TempWorkSheet.SheetID := GetSheetID(Value);
  end;
end;

procedure TXlsxWorkbook.OnLoadStyle(Sender: TQIXMLStreamProcessor; const AName: qiString; Action: TQIXMLNodeAction);
const
  MaxXf = 256;
var
  Name, Value, S: qiString;
  TmpStyle: TXlsxStyle;
  Stop: Boolean;
begin
  if not Assigned(Sender) then
    Exit;
  case Action of
    xnaOpen:
      begin
        Stop := False;
        if AName = 'cellXfs' then
          FParserFlag := True
        else if FParserFlag and (AName = 'xf') then
        begin
          while Sender.GetNextAttribute(Name, Value, Stop) do
          begin
            if Name = 'numFmtId' then
            begin
              TmpStyle := FStylesXfs.Add;
              if Value = '0' then
                TmpStyle.NumFmtId := MaxXf + TmpStyle.Index
              else
                TmpStyle.NumFmtId := StrToInt(Value);
            end;
            Stop := True;
          end;
        end
        else if AName = 'numFmt' then
        begin
          S := '';
          while Sender.GetNextAttribute(Name, Value) do
          begin
            if Name = 'numFmtId' then
              S := Value
            else if (S <> '') and (Name = 'formatCode') then
            begin
              TmpStyle := FStylesFmt.Add;
              TmpStyle.NumFmtId := StrToInt(S);
              TmpStyle.FormatString := Value;
            end;
          end;
        end;
      end;
    xnaClose:
      if AName = 'cellXfs' then
        FParserFlag := False;
  else
    Exit;
  end;
end;

procedure TXlsxWorkbook.OnLoadRelationship(Sender: TQIXMLStreamProcessor; const AName: qiString; Action: TQIXMLNodeAction);
var
  Name, Value: qiString;
  B, Stop: Boolean;
begin
  if not (Assigned(Sender) and (Action = xnaOpen) and (AName = 'Relationship')) then
    Exit;
  B := False;
  Stop := False;
  while Sender.GetNextAttribute(Name, Value, Stop) do
  begin
    if Name = 'Id' then
      if FParserArgument = GetSheetID(Value) then
        B := True
      else
        Stop := True
    else if B and (Name = 'Target') then
    begin
      FParserResult := StringReplace(Value, '/','\', [rfReplaceAll, rfIgnoreCase]);
      Sender.Halt;
      Stop := True;
    end;
  end;
end;

procedure TXlsxWorkbook.OnGetSharedString(Sender: TQIXMLStreamProcessor;
  const Text: qiString; TextType: TQIXMLTextType);
begin
  if (TextType = xttText) and Assigned(Sender) and (Sender.CurrentTag = 't') then
    FSharedStringCache := FSharedStringCache + Text;
end;

procedure TXlsxWorkbook.OnGetCellText(Sender: TQIXMLStreamProcessor; const Text: qiString; TextType: TQIXMLTextType);
begin
  if not (Assigned(FCurrentCell) and (TextType = xttText)) then
    Exit;
  if FParserResult = 'v' then
    FCurrentValue.NodeValueV := Text
  else if FParserResult = 'is' then
    FCurrentValue.ValueIsT := Text
  else if (FParserResult = 'f') and (Text <> '') then
    CurrentCell.Formula := Text;
  FParserResult := '';
end;

procedure TXlsxWorkbook.OnLoadElement(Sender: TQIXMLStreamProcessor; const Name: qiString; Action: TQIXMLNodeAction);
begin
  if (Name = 'si') and (Action = xnaClose) then
  begin
    FSharedStrings.Add(FSharedStringCache);
    FSharedStringCache := '';
    //vv approximately 200 strings by row
    if FSharedStrings.Count = ((ImportRecCount + 1) * 200) then
      Sender.Halt;
  end;
end;

procedure TXlsxWorkbook.OnLoadCell(Sender: TQIXMLStreamProcessor; const AName: qiString; Action: TQIXMLNodeAction);
var
  Name, Value: qiString;
  Stop: Boolean;
  ValueOfNode: Variant;
begin
  if not Assigned(Sender) then
    Exit;
  case Action of
    xnaOpen:
      begin
        Stop := False;
        if AName = 'mergeCell' then
        begin
          while Sender.GetNextAttribute(Name, Value, Stop) do
            if Name = 'ref' then
            begin
              CurrentSheet.MergeCells.Add.Range := Value;
              Stop := True;
            end;
        end
        else if AName = 'c' then
        begin
          FCurrentCell := CurrentSheet.Cells.Add;
          while Sender.GetNextAttribute(Name, Value) do
          begin
            if not Assigned(FCurrentValue) then
              New(FCurrentValue);
            if Name = 'r' then
            begin
              CurrentCell.Name := Value;
              CurrentSheet.Cell[GetColIdFromString(Value) - 1, GetRowIdFromString(Value) - 1] := CurrentCell;
            end
            else if Name = 's' then
              FCurrentValue.NodeValueS := Value
            else if Name = 't' then
              FCurrentValue.NodeValueT := Value;
          end;
        end
        else if (AName = 'v') or (AName = 'f') or (AName = 'is') then
          FParserResult := AName;
      end;
    xnaClose:
      if Assigned(FCurrentCell) and (AName = 'c') then
      begin
        ValueOfNode := GetCellValue(FCurrentValue);
        if VarIsNull(ValueOfNode) then
          FCurrentCell.Value := ''
        else
          FCurrentCell.Value := ValueOfNode;
        FCurrentCell := nil;
        Dispose(FCurrentValue);
        FCurrentValue := nil;

        if CurrentSheet.RowCount = (ImportRecCount + 1) then
          Sender.Halt;
      end;
  end;
end;

procedure TXlsxWorkbook.SetCurrentSheet(const Value: TXlsxWorkSheet);
begin
  FCurrentSheet := Value;
end;

{ TXlsxDirectReadWorkbook }

procedure TXlsxDirectReadWorkbook.LoadSheet(SheetFile: qiString; Id: integer);
var
  SRec: TSearchRec;
begin
  if FindFirst(SheetFile, faDirectory, SRec) = 0 then
  try
    CurrentSheet := WorkSheets.GetSheetByID(id);
    if Assigned(CurrentSheet) then
      CurrentSheet.FileName := SheetFile;
  finally
    FindClose(SRec);
  end;
end;

function TXlsxDirectReadWorkbook.GetCellValue(const XlsxCell: PXMLCType): Variant;
begin
  Result := inherited GetCellValue(XlsxCell);
end;

procedure TXlsxDirectReadWorkbook.FreeSharedStrings;
begin
  FreeAndNil(FSharedStrings);
end;

procedure TQImport3Xlsx.SetSheetName(const Value: string);
begin
  if FSheetName <> Value then
    FSheetName := Value;
end;

procedure TQImport3Xlsx.SetLoadHiddenSheet(const Value: Boolean);
begin
  if FLoadHiddenSheet <> Value then
    FLoadHiddenSheet := Value;
end;

procedure TQImport3Xlsx.SetNeedFillMerge(const Value: Boolean);
begin
  if FNeedFillMerge <> Value then
    FNeedFillMerge := Value;
end;

procedure TQImport3Xlsx.ParseMap;
var
  I: Integer;
begin
  FMapParserRows.Clear;
  for I := 0 to Map.Count - 1 do
    FMapParserRows.Add(Map[I], SkipFirstRows, SkipFirstCols);
end;

procedure TQImport3Xlsx.DoBeforeImport;
begin
  FCurrentRow := -1;
  FCurrentCol := -1;
  FEndImportFlag := False;
  ParseMap;
  inherited;
  FWorksheetReader := TXlsxWorksheetReader.Create(TXlsxDirectReadFile(FDocFile).DocFolder);
end;

procedure TQImport3Xlsx.DoAfterImport;
begin
  FWorksheetReader.Free;
  inherited;
end;

function TQImport3Xlsx.CheckCondition: Boolean;
begin
  Result := not FEndImportFlag;
end;

procedure TQImport3Xlsx.FillImportRow;

  function TryFillTempRowData(ARow, ACol: Integer): Boolean;
  var
    i, Len: Integer;
  begin
    Result := True;
    try
      if (FCurrentRow < ARow) or ((FCurrentRow = ARow) and (FCurrentCol < ACol)) then
      begin
        if FCurrentRow < ARow then
          SetLength(FTempRowData, 0);
        FCurrentRow := ARow;
        FCurrentCol := ACol;
        Len := Length(FTempRowData);
        if Length(FTempRowData) < FCurrentCol then
          SetLength(FTempRowData, FCurrentCol);
        for i := Len to FCurrentCol - 1 do
          FTempRowData[i] := FWorksheetReader.Cell[i + 1, FCurrentRow];
      end;
    except
      Result := False;
    end;
  end;

var
  strValue,
  WorksheetName: qiString;
  i, k, RowTmp, ColTmp,
  WorksheetIndex: Integer;
  p: Pointer;
  Workbook: TXlsxWorkbook;
  WorkSheet: TXlsxWorkSheet;
begin
  FEndImportFlag := True;
  FImportRow.ClearValues;
  RowIsEmpty := True;
  Workbook := TXlsxFile(FDocFile).Workbook;
  for i := 0 to FImportRow.Count - 1 do
  begin
    strValue := EmptyStr;
    if FImportRow.MapNameIdxHash.TryGetValue(FImportRow[i].Name, p) then
    begin
      k := Integer(p);
      if FMapParserRows[k].GetNextRange(RowTmp, ColTmp, WorksheetIndex, WorksheetName) then
      begin
        WorkSheet := nil;
        if Length(WorksheetName) = 0 then
          WorksheetName := SheetName;

        if WorksheetIndex > 0 then
          WorkSheet := Workbook.WorkSheets.GetSheetByID(WorksheetIndex);

        if not Assigned(WorkSheet) then
          WorkSheet := Workbook.WorkSheets.GetSheetByName(WorksheetName);

        if Assigned(WorkSheet) then
        begin
          FWorksheetReader.OpenWorkSheet(Workbook, WorkSheet.FileName);
          if TryFillTempRowData(RowTmp, ColTmp) then
            if (Length(FTempRowData) > 0) and ((ColTmp > 0) and (ColTmp <= Length(FTempRowData))) then
              strValue := FTempRowData[ColTmp - 1];
        end
        else begin
          FEndImportFlag := True;
          FImportSuccess := False;
          Exit;
        end;
      end;

      FEndImportFlag := FEndImportFlag and (FWorksheetReader.Eof or ((RowTmp = 0) and (ColTmp = 0)));

      if AutoTrimValue then
        strValue := Trim(strValue);

      RowIsEmpty := RowIsEmpty and (strValue = '');
      FImportRow.SetValue(Map.Names[k], strValue, False);
    end;
    DoUserDataFormat(FImportRow[i]);
  end;
end;

function TQImport3Xlsx.ImportData: TQImportResult;
begin
  if FEndImportFlag then
  begin
    Result := qirBreak;
    Exit;
  end;
  Result := inherited ImportData;
end;

procedure TQImport3Xlsx.DoLoadConfiguration(IniFile: TIniFile);
begin
  inherited;
  with IniFile do
  begin
    SkipFirstRows := ReadInteger(XLSX_OPTIONS, XLSX_SKIP_LINES, SkipFirstRows);
    SheetName := ReadString(XLSX_OPTIONS, XLSX_SHEET_NAME, SheetName);
    LoadHiddenSheet := ReadBool(XLSX_OPTIONS, XLSX_LOAD_HIDDEN_SHEET, LoadHiddenSheet);
    NeedFillMerge := ReadBool(XLSX_OPTIONS, XLSX_NEED_FILL_MERGE, NeedFillMerge);
  end;
end;

procedure TQImport3Xlsx.DoSaveConfiguration(IniFile: TIniFile);
begin
  inherited;
  with IniFile do
  begin
    WriteInteger(XLSX_OPTIONS, XLSX_SKIP_LINES, SkipFirstRows);
    WriteString(XLSX_OPTIONS, XLSX_SHEET_NAME, SheetName);
    WriteBool(XLSX_OPTIONS, XLSX_LOAD_HIDDEN_SHEET, LoadHiddenSheet);
    WriteBool(XLSX_OPTIONS, XLSX_NEED_FILL_MERGE, NeedFillMerge);
  end;
end;

procedure TQImport3Xlsx.DoUserDefinedImport;
begin
  if not FEndImportFlag then
    inherited;
end;

function TQImport3Xlsx.AllowImportRowComplete: Boolean;
begin
  Result := not FEndImportFlag;
end;

constructor TQImport3Xlsx.Create(AOwner: TComponent);
begin
  inherited;
  FLoadHiddenSheet := False;
  FCurrentRow := -1;
  FCurrentCol := -1;
  SetLength(FTempRowData, 0);
  FMapParserRows := TXlsxMapParserItems.Create;
end;

destructor TQImport3Xlsx.Destroy;
begin
  FMapParserRows.Free;
  SetLength(FTempRowData, 0);
  FTempRowData := nil;
  inherited;
end;  

function TQImport3Xlsx.CreateDocFile: TBaseDocumentFile;
begin
  Result := TXlsxDirectReadFile.Create;
end;

procedure TQImport3Xlsx.LoadDocFile;
var
  WorkSheet: TXlsxWorkSheet;
begin
  TXlsxFile(FDocFile).Workbook.FLoadHiddenSheets := FLoadHiddenSheet;
  TXlsxFile(FDocFile).Workbook.NeedFillMerge := FNeedFillMerge;
  if ImportRecCount > 0 then
    TXlsxFile(FDocFile).Workbook.ImportRecCount := ImportRecCount + SkipFirstRows;
  inherited;
  WorkSheet := TXlsxFile(FDocFile).Workbook.WorkSheets.GetSheetByName(SheetName);
  FTotalRecCount := 0;
  if Assigned(WorkSheet) and (WorkSheet.RowCount > 0) then
    FTotalRecCount := WorkSheet.RowCount - SkipFirstRows;
end;

function TXlsxFile.GetWorkbook: TXlsxWorkbook;
begin
  Result := TXlsxWorkbook(FContainer);
end;

function TXlsxFile.CreateContainer: TXMLDocContainer;
begin
  Result := TXlsxWorkbook.Create;
end;

{ TXlsxDirectReadFile }

procedure TXlsxDirectReadFile.DoAfterLoad;
begin
end;

function TXlsxDirectReadFile.CreateContainer: TXMLDocContainer;
begin
  Result := TXlsxDirectReadWorkbook.Create;
end;

{ TXlsxWorksheetReader }

constructor TXlsxWorksheetReader.Create(const TmpDocFolder: string);
begin
  inherited Create;
  FTmpDocFolder := TmpDocFolder;
  FSAXParser := TQIDirectReadParser.Create;
  FSAXParser.OnLoadElement := OnLoadCell;
  FSAXParser.OnGetText := OnGetCellText;
end;

destructor TXlsxWorksheetReader.Destroy;
begin
  FSAXParser.CloseDocument;
  FSAXParser.Free;
  if Assigned(FXlsxWorkbook) then
    FXlsxWorkbook.FreeSharedStrings;
  DeleteTmpDocFolder;
  inherited;
end;

function TXlsxWorksheetReader.DataAvailable(Col, Row: Integer; var CellValue: qiString): Boolean;
begin
  Result := False;
  CellValue := EmptyStr;

  if FCurrentRow = Row then
  begin
    if FCurrentCol > Col then
    begin
      Result := True;
      Exit;
    end
    else if FCurrentCol = Col then
    begin
      Result := True;
      CellValue := FCellValue;
      Exit;
    end;
  end
  else if FCurrentRow > Row then
    Result := True;
end;

function TXlsxWorksheetReader.GetDataCell(Col, Row: Integer): qiString;
var
  Token: PQIXMLToken;
begin
  if DataAvailable(Col, Row, Result) then
    Exit;

  FEof := not FSAXParser.GetNextToken(Token);
  while not FSAXParser.Halted and not FEof do
  begin
    FSAXParser.DoProcessToken(Token);
    if FCellValueExtracted then
    begin
      FCellValueExtracted := False;
      if DataAvailable(Col, Row, Result) then
        Exit;
    end;
    FEof := not FSAXParser.GetNextToken(Token);
  end;
end;

procedure TXlsxWorksheetReader.OnGetCellText(Sender: TQIXMLStreamProcessor; const Text: qiString; TextType: TQIXMLTextType);
begin
  if not (Assigned(FCurrentValue) and (TextType = xttText)) then
    Exit;
  if FParserResult = 'v' then
    FCurrentValue.NodeValueV := Text
  else if FParserResult = 'is' then
    FCurrentValue.ValueIsT := Text;
  FParserResult := '';
end;

procedure TXlsxWorksheetReader.OnLoadCell(Sender: TQIXMLStreamProcessor; const AName: qiString; Action: TQIXMLNodeAction);
var
  Name, Value: qiString;
begin
  if not Assigned(Sender) then
    Exit;
  case Action of
    xnaOpen:
      begin
        if AName = 'c' then
        begin
          FCellValue := EmptyStr;
          FCellValueExtracted := False;
          while Sender.GetNextAttribute(Name, Value) do
          begin
            if Name = 'r' then
            begin
              FCurrentCol := GetColIdFromString(Value);
              FCurrentRow := GetRowIdFromString(Value);
              New(FCurrentValue);
            end
            else if Name = 's' then
              FCurrentValue.NodeValueS := Value
            else if Name = 't' then
              FCurrentValue.NodeValueT := Value;
          end;
        end
        else if (AName = 'v') or (AName = 'f') or (AName = 'is') then
          FParserResult := AName;
      end;
    xnaClose:
      if Assigned(FCurrentValue) and (AName = 'c') then
      begin
        FCellValue := FXlsxWorkbook.GetCellValue(FCurrentValue);
        if VarIsNull(FCellValue) then
          FCellValue := EmptyStr;
        FCellValueExtracted := True;

        Dispose(FCurrentValue);
        FCurrentValue := nil;
      end;
  end;
end;

procedure TXlsxWorksheetReader.OpenWorkSheet(const XlsxWorkbook: TXlsxWorkbook; const WorksheetFileName: string);
begin
  FXlsxWorkbook := XlsxWorkbook as TXlsxDirectReadWorkbook;
  if FWorksheetFileName <> WorksheetFileName then
  begin
    ReopenWorksheet(WorksheetFileName);
    FWorksheetFileName := WorksheetFileName;
  end;
end;

procedure TXlsxWorksheetReader.ReopenWorksheet(const WorksheetFileName: string);
begin
  FSAXParser.CloseDocument;
  FSAXParser.OpenDocument(WorksheetFileName);
end;

procedure TXlsxWorksheetReader.DeleteTmpDocFolder;
begin
  if DirExists(FTmpDocFolder) then
    FullRemoveDir(FTmpDocFolder, True, False, True);
end;

{$ENDIF}

end.

