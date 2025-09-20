unit QImport3ODT;

{$I QImport3VerCtrl.Inc}

interface

{$IFDEF ODT}

uses 
  {$IFDEF VCL16}
    System.Classes,
    System.SysUtils,
    Winapi.MSXML,
    System.IniFiles,
  {$ELSE}
    Classes,
    SysUtils,
    MSXML,
    IniFiles,
  {$ENDIF}
  QImport3StrTypes,
  QImport3XMLBased,
  QImport3,
  QImport3Common,
  QImport3BaseDocumentFile,
  QImport3XmlSax,
  QImport3WideStrUtils;

type
  TODTCell = class(TCell);

  TODTCellList = class(TODCellList)
  private
    function GetItem(Index: Integer): TODTCell;
    procedure SetItem(Index: Integer; const Value: TODTCell);
  public
    function Add: TODTCell;
    property Items[Index: Integer]: TODTCell read GetItem write SetItem; default;
    function GetItemByCoords(X, Y: Integer): TODTCell;
  end;

  TODTSpreadSheet = class(TXYSheet)
  private
    FIsAfterSubTable: Boolean;
    FIsComplexTable: Boolean;
    FParent: TODTSpreadSheet;
    function GetCell(Col, Row: Integer): TODTCell;
    function GetCells: TODTCellList;
    procedure SetCell(Col, Row: Integer; const Value: TODTCell);
  protected
    function CreateCells: TCellList; override;
    procedure SetColCount(const Value: Integer); override;
    procedure SetRowCount(const Value: Integer); override;
    procedure SetX(const Value: Integer); override;
    procedure SetY(const Value: Integer); override;
  public
    constructor Create(Collection: TCollection); override;
    property Cell[Col, Row: Integer]: TODTCell read GetCell write SetCell;
    property Cells: TODTCellList read GetCells;
    property IsAfterSubTable: Boolean read FIsAfterSubTable write FIsAfterSubTable;
    property IsComplexTable: Boolean read FIsComplexTable write FIsComplexTable;
  end;

  TODSSpreadSheetList = class(TXMLSheetList)
  private
    function GetItems(Index: integer): TODTSpreadSheet;
    procedure SetItems(Index: integer; Value: TODTSpreadSheet);
  public
    function Add: TODTSpreadSheet;
    property Items[Index: integer]: TODTSpreadSheet read GetItems write SetItems; default;
    function GetSheetByName(Name: qiString): TODTSpreadSheet;
  end;

  TODTWorkbook = class(TODContainer)
  private
    procedure ExpandRowsNCols(ASheet: TODTSpreadSheet; ExpandValue: qiString;
        NumbOfRepRows, NumbOfRepColumns: Integer; IsSpanning: Boolean);
    function GetSheets: TODSSpreadSheetList;
  protected
    function GetErrorMsg: qiString; override;
    function CreateSheets: TXMLSheetList; override;
    procedure OnGetCellText(Sender: TQIXMLStreamProcessor; const aText: qiString;
        TextType: TQIXMLTextType); override;
    procedure OnLoadSheet(Sender: TQIXMLStreamProcessor; const AName: qiString;
        Action: TQIXMLNodeAction); override;
    procedure ParseSheet(Sender: TQISAXParser; const AName: qiString); override;
  public
    property Sheets: TODSSpreadSheetList read GetSheets;
  end;

  TODTFile = class(TZipDocumentFile)
    private
      function GetWorkbook: TODTWorkbook;
    protected
      function CreateContainer: TXMLDocContainer; override;
    public
      property Workbook: TODTWorkbook read GetWorkbook;
  end;

  TQImport3ODT = class(TQImport3WorkbookBased)
  private
    FSheetName: qiString;
    FUseHeader: Boolean;
    FUseComplexTables: Boolean;
    procedure SetSheetName(const Value: qiString);
  protected
    procedure StartImport; override;
    function Skip: Boolean; override;
    procedure FillImportRow; override;
    procedure DoLoadConfiguration(IniFile: TIniFile); override;
    procedure DoSaveConfiguration(IniFile: TIniFile); override;
    function CreateDocFile: TBaseDocumentFile; override;
    procedure LoadDocFile; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property FileName;
    property SkipFirstRows default 0;
    property SheetName: qiString read FSheetName write SetSheetName;
    property UseHeader: Boolean read FUseHeader write FUseHeader default false;
    property UseComplexTables: Boolean read FUseComplexTables
      write FUseComplexTables default true;
  end;

{$ENDIF}

implementation

{$IFDEF ODT}

{ TODTCellList }

function TODTCellList.Add: TODTCell;
begin
  Result := TODTCell(inherited Add);
end;

function TODTCellList.GetItem(Index: Integer): TODTCell;
begin
  Result := TODTCell(inherited Items[Index]);
end;

function TODTCellList.GetItemByCoords(X, Y: Integer): TODTCell;
begin
  Result := TODTCell(inherited GetItemByCoords(X, Y));
end;

procedure TODTCellList.SetItem(Index: Integer; const Value: TODTCell);
begin
  inherited Items[Index] := Value;
end;

{ TODTSpreadSheet }

constructor TODTSpreadSheet.Create(Collection: TCollection);
begin
  inherited;
  FIsAfterSubTable := false;
  FIsComplexTable := false;
end;

function TODTSpreadSheet.GetCell(Col, Row: Integer): TODTCell;
begin
  Result := TODTCell(inherited Cell[Col, Row]);
end;

function TODTSpreadSheet.GetCells: TODTCellList;
begin
  Result := TODTCellList(FCells);
end;

function TODTSpreadSheet.CreateCells: TCellList;
begin
  Result := TODTCellList.Create(Self, TODTCell);
end;

procedure TODTSpreadSheet.SetCell(Col, Row: Integer; const Value: TODTCell);
begin
  inherited Cell[Col, Row] := Value;
end;

procedure TODTSpreadSheet.SetColCount(const Value: Integer);
begin
  if ColCount <> Value then
  begin
    if Assigned(FParent) and FParent.IsAfterSubTable then
      FParent.ColCount := FParent.ColCount - ColCount + Value;
    inherited;
  end;
end;

procedure TODTSpreadSheet.SetRowCount(const Value: Integer);
begin
  if RowCount <> Value then
  begin
    if Assigned(FParent) and FParent.IsAfterSubTable then
      FParent.RowCount := FParent.RowCount - RowCount + Value;
    inherited;
  end;
end;

procedure TODTSpreadSheet.SetX(const Value: Integer);
var
  Val, I: Integer;
begin
  if X <> Value then
  begin
    if Assigned(FParent) and FParent.IsAfterSubTable  and (X > -1) then
    begin
      if X < 0 then
        I := 0
      else
        I := X;
      if Value < 0 then
        Val := 0
      else
        Val := Value;
      FParent.X := FParent.X - I + Val;
    end;
    inherited;
  end;
end;

procedure TODTSpreadSheet.SetY(const Value: Integer);
var
  Val: Integer;
begin
  if Y <> Value then
  begin
    if Assigned(FParent) and FParent.IsAfterSubTable and (Y > -1) then
    begin
      if Value < 0 then
        Val := 0
      else
        Val := Value;
      FParent.Y := FParent.Y - Y + Val;
    end;
    inherited;
  end;
end;

{ TODSSpreadSheetList }

function TODSSpreadSheetList.GetItems(Index: integer): TODTSpreadSheet;
begin
  Result := TODTSpreadSheet(inherited Items[Index]);
end;

procedure TODSSpreadSheetList.SetItems(Index: integer;
  Value: TODTSpreadSheet);
begin
  inherited Items[Index] := Value;
end;

function TODSSpreadSheetList.Add: TODTSpreadSheet;
begin
  Result := TODTSpreadSheet(inherited Add);
end;

function TODSSpreadSheetList.GetSheetByName(Name: qiString): TODTSpreadSheet;
begin
  Result := TODTSpreadSheet(inherited GetTableByName(Name));
end;

procedure TODTWorkbook.ParseSheet(Sender: TQISAXParser; const AName: qiString);
var
  Sheet: TODTSpreadSheet;
  Name, Value: qiString;
  Stop: Boolean;
begin
  if not Assigned(Sender) then
    Exit;
  Stop := False;
  if FCurrentSheet is TODTSpreadSheet then
  begin
    Sheet := TODTSpreadSheet(FCurrentSheet);
    if AName = 'table:table-row' then
    begin
      Sheet.IsAfterSubTable := false;
      Sheet.Y := Sheet.Y + 1;
      Sheet.X := -1;
      while Sender.GetNextAttribute(Name, Value, Stop) do
        if Name = 'table:number-rows-repeated' then
        begin
          FRowsRepeated := StrToInt(Value) - 1;
          Stop := True;
        end;
      if Sheet.Y + 1 > Sheet.RowCount then
        Sheet.RowCount := Sheet.Y + 1;
    end
    else if AName = 'table:covered-table-cell' then
    begin
      if not Sheet.IsAfterSubTable then
      begin
        Sheet.X := Sheet.X + 1;
        if Sheet.X + 1 > Sheet.ColCount then
          Sheet.ColCount := Sheet.X + 1;
      end;
    end
    else if AName = 'table:table-cell' then
    begin
      Sheet.IsAfterSubTable := false;
      Sheet.X := Sheet.X + 1;
      if Sheet.X + 1 > Sheet.ColCount then
        Sheet.ColCount := Sheet.X + 1;
      while Sender.GetNextAttribute(Name, Value) do
        if Name = 'table:number-columns-repeated' then
          FColsRepeated := StrToInt(Value) - 1
        else if Name = 'table:number-rows-spanned' then
        begin
          FRowsRepeated := StrToInt(Value) - 1;
          FParserFlag := True;
        end
        else if Name = 'table:number-columns-spanned' then
        begin
          FColsRepeated := StrToInt(Value) - 1;
          FParserFlag := True;
        end
    end
    else if AName = 'table:table' then
    begin
      while Sender.GetNextAttribute(Name, Value, Stop) do
      begin
        if Name = 'table:is-sub-table' then
        begin
          Sheet.IsComplexTable := true;
          Sheet.IsAfterSubTable := true;
          FCurrentSheet := TODTSpreadSheet.Create(nil);
          Stop := True;
        end
        else if (Name = 'table:name') or (Name = 'table:style-name') then
        begin
          FCurrentSheet := Sheets.Add;
          FCurrentSheet.Name := Value;
          Stop := True;
        end
      end;
      if FCurrentSheet <> Sheet then
        TODTSpreadSheet(FCurrentSheet).FParent := Sheet;
    end;
  end
  else if AName = 'table:table' then
  begin
    FCurrentSheet := FSheets.Add;
    FColsRepeated := 0;
    FRowsRepeated := 0;
    FParserFlag := False;
    while Sender.GetNextAttribute(Name, Value, Stop) do
      if (Name = 'table:name') or (Name = 'table:style-name') then
      begin
        FCurrentSheet.Name := Value;
        Stop := True;
      end;
  end;
end;

procedure TODTWorkbook.OnGetCellText(Sender: TQIXMLStreamProcessor; const
    aText: qiString; TextType: TQIXMLTextType);
var
  Sheet: TODTSpreadSheet;
begin
  if not ((FCurrentSheet is TODTSpreadSheet) and (TextType = xttText)) or
    ((Sender.CurrentTag <> 'text:p') and (Sender.CurrentTag <> 'text:span'))
  then
    Exit;
  Sheet := TODTSpreadSheet(FCurrentSheet);
  if (FRowsRepeated > 0) or (FColsRepeated > 0) then
  begin
    ExpandRowsNCols(Sheet, aText, FRowsRepeated, FColsRepeated, FParserFlag);
    if not FParserFlag then
    begin
      Sheet.X := Sheet.X + FColsRepeated;
      Sheet.Y := Sheet.Y + FRowsRepeated;
    end;
  end
  else if not Assigned(FCurrentCell) then
  begin
    while Assigned(Sheet.FParent) and Sheet.FParent.IsAfterSubTable do
      Sheet := Sheet.FParent;
    FCurrentCell := Sheet.Cells.Add;
    FCurrentCell.Row := Sheet.Y;
    FCurrentCell.Col := Sheet.X;
    FCurrentCell.Value := aText;
    Sheet.Cell[Sheet.X, Sheet.Y] := TODTCell(FCurrentCell);
  end
  else
    FCurrentCell.Value := FCurrentCell.Value + aText;
end;

procedure TODTWorkbook.OnLoadSheet(Sender: TQIXMLStreamProcessor; const AName:
    qiString; Action: TQIXMLNodeAction);
var
  Sheet: TODTSpreadSheet;
begin
  case Action of
    xnaOpen:
      inherited;
    xnaClose:
      begin
        if not (FCurrentSheet is TODTSpreadSheet) then
          Exit;
        Sheet := TODTSpreadSheet(FCurrentSheet);
        if Assigned(FCurrentCell) and (aName = 'table:table-cell') then
        begin
          FCurrentCell := nil;
          if (FRowsRepeated > 0) or (FColsRepeated > 0) then
          begin
            Sheet.X := Sheet.X + FColsRepeated;
            Sheet.Y := Sheet.Y + FRowsRepeated;
            if Sheet.X + 1 > Sheet.ColCount then
              Sheet.ColCount := Sheet.X + 1;
            if Sheet.RowCount - 1 > Sheet.Y then
              Sheet.Y := Sheet.RowCount;
            FColsRepeated := 0;
            FRowsRepeated := 0;
          end;
        end
        else if aName = 'table:table' then
        begin
          FCurrentSheet := Sheet.FParent;
          if (FCurrentSheet is TODTSpreadSheet) and
            TODTSpreadSheet(FCurrentSheet).IsAfterSubTable then
          begin
            Sheet.Y := -1;
            FColsRepeated := 0;
            FRowsRepeated := 0;
            Sheet.Free;
          end;
        end;
      end;
  else
    Exit;
  end;
end;

procedure TODTWorkbook.ExpandRowsNCols(ASheet: TODTSpreadSheet; ExpandValue:
    qiString; NumbOfRepRows, NumbOfRepColumns: Integer; IsSpanning: Boolean);
var
  I: Integer;
  TempCell: TODTCell;
  Sheet: TODTSpreadSheet;
begin
  if not (ASheet is TODTSpreadSheet) then
    Exit;
  I := NumbOfRepRows;
  if ASheet.X + NumbOfRepColumns + 1 > ASheet.ColCount then
    ASheet.ColCount := ASheet.X + NumbOfRepColumns + 1;
  if ASheet.Y + NumbOfRepRows + 1 > ASheet.RowCount then
    ASheet.RowCount := ASheet.Y + NumbOfRepRows + 1;
  if NumbOfRepColumns >= 0 then
  begin
    Sheet := ASheet;
    try
      while Assigned(ASheet.FParent) and ASheet.FParent.IsAfterSubTable do
        ASheet := ASheet.FParent;
      repeat
        if not IsSpanning then
        begin
          TempCell := ASheet.Cell[ASheet.X + NumbOfRepColumns, ASheet.Y + I];
          if assigned(TempCell) then
            TempCell.Value := TempCell.Value + ' ' + ExpandValue
          else
          begin
            TempCell := ASheet.Cells.Add;
            TempCell.Row := ASheet.Y + I;
            TempCell.Col := ASheet.X + NumbOfRepColumns;
            TempCell.Value := ExpandValue;
            ASheet.Cell[TempCell.Col, TempCell.Row] := TempCell;
          end
        end
        else if (NumbOfRepColumns = 0) and (I = 0) then
        begin
          TempCell := ASheet.Cell[ASheet.X, ASheet.Y];
          if assigned(TempCell) then
            TempCell.Value := TempCell.Value + ' ' + ExpandValue
          else
          begin
            TempCell := ASheet.Cells.Add;
            TempCell.Row := ASheet.Y;
            TempCell.Col := ASheet.X;
            TempCell.Value := ExpandValue;
            ASheet.Cell[TempCell.Col, TempCell.Row] := TempCell;
          end;
        end;
        I := I - 1;
      until (I < 0);
    finally
      ASheet := Sheet;
    end;
    ExpandRowsNCols(ASheet, ExpandValue, NumbOfRepRows,
      NumbOfRepColumns - 1, IsSpanning);
  end;
end;

function TODTWorkbook.GetErrorMsg: qiString;
begin
  Result := 'No tables were found';
end;

function TODTWorkbook.GetSheets: TODSSpreadSheetList;
begin
  Result := TODSSpreadSheetList(FSheets);
end;

function TODTWorkbook.CreateSheets: TXMLSheetList;
begin
  Result := TODSSpreadSheetList.Create(TODTSpreadSheet);
end;

constructor TQImport3ODT.Create(AOwner: TComponent);
begin
  inherited;
  FUseHeader := false;
  FUseComplexTables := true;
end;

procedure TQImport3ODT.DoLoadConfiguration(IniFile: TIniFile);
begin
  inherited;
  with IniFile do
  begin
    SkipFirstRows := ReadInteger(ODT_OPTIONS, ODT_SKIP_LINES, SkipFirstRows);
    SheetName := ReadString(ODT_OPTIONS, ODT_SHEET_NAME, SheetName);
    UseHeader := ReadBool(ODT_OPTIONS, ODT_USE_HEADER, UseHeader);
    UseComplexTables := ReadBool(ODT_OPTIONS, ODT_COMPLEX_TABLE, UseComplexTables);
  end;
end;

procedure TQImport3ODT.DoSaveConfiguration(IniFile: TIniFile);
begin
  inherited;
  with IniFile do
  begin
    WriteInteger(ODT_OPTIONS, ODT_SKIP_LINES, SkipFirstRows);
    WriteString(ODT_OPTIONS, ODT_SHEET_NAME, string(SheetName));
    WriteBool(ODT_OPTIONS, ODT_USE_HEADER, UseHeader);
    WriteBool(ODT_OPTIONS, ODT_COMPLEX_TABLE, UseComplexTables);
  end;
end;

procedure TQImport3ODT.FillImportRow;
var
  i, k: Integer;
  strValue: qiString;
  mapValue: qiString;
  Sheet: TODTSpreadSheet;
  p: Pointer;
  Cell: TCell;
begin
  FImportRow.ClearValues;
  RowIsEmpty := True;
  for i := 0 to FImportRow.Count - 1 do
  begin
    if FImportRow.MapNameIdxHash.TryGetValue(FImportRow[i].Name, p) then
    begin
      k := Integer(p);
{$IFDEF VCL7}
      mapValue := Map.ValueFromIndex[k];
{$ELSE}
      mapValue := Map.Values[FImportRow[i].Name];
{$ENDIF}
      Sheet := TODTFile(FDocFile).Workbook.Sheets.GetSheetByName(qiString(SheetName));
      Cell := Sheet.Cell[GetColIdFromColIndex(mapValue) - 1, FCounter];
      if Assigned(Cell) then
        strValue := Cell.Value
      else
        strValue := EmptyStr;
      strValue := QReplaceSpecs(strValue);
      if AutoTrimValue then
        strValue := Trim(strValue);
      RowIsEmpty := RowIsEmpty and (strValue = '');
      FImportRow.SetValue(Map.Names[k], strValue, False);
    end;
    DoUserDataFormat(FImportRow[i]);
  end;
end;

function TQImport3ODT.CreateDocFile: TBaseDocumentFile;
begin
  Result := TODTFile.Create;
end;

procedure TQImport3ODT.LoadDocFile;
var
  Sheet: TODTSpreadSheet;
begin
  inherited;
  Sheet := TODTFile(FDocFile).Workbook.Sheets.GetSheetByName(qiString(SheetName));
  FTotalRecCount := 0;
  if Assigned(Sheet) and (Sheet.RowCount > 0) then
    FTotalRecCount := Sheet.RowCount - SkipFirstRows;
end;

function TQImport3ODT.Skip: Boolean;
begin
  if not (UseHeader) then
    Result := inherited Skip
  else
    Result := ((SkipFirstRows + 1) > 0) and (FCounter < (SkipFirstRows + 1));
end;

procedure TQImport3ODT.StartImport;
var
  Sheet: TODTSpreadSheet;
begin
  inherited;
  Sheet := TODTFile(FDocFile).Workbook.Sheets.GetSheetByName(qiString(SheetName));
  if Assigned(Sheet) then
    if (Sheet.IsComplexTable) and not UseComplexTables then
      raise EQImportError.Create('Trying to convert complex tables');
end;

procedure TQImport3ODT.SetSheetName(const Value: qiString);
begin
  if (FSheetName <> Value) then
    FSheetName := Value;
end;

function TODTFile.GetWorkbook: TODTWorkbook;
begin
  Result := TODTWorkbook(FContainer);
end;

function TODTFile.CreateContainer: TXMLDocContainer;
begin
  Result := TODTWorkbook.Create;
end;

{$ENDIF}

end.
