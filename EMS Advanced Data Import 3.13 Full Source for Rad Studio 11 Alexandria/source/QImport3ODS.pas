unit QImport3ODS;

{$I QImport3VerCtrl.Inc}

interface

{$IFDEF ODS}

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
  QImport3Common,
  QImport3,
  QImport3WideStrUtils,
  QImport3BaseDocumentFile,
  QImport3XmlSax;

type
  TODSCell = class(TCell);

  TODSCellList = class(TODCellList)
  private
    function GetItem(Index: Integer): TODSCell;
    procedure SetItem(Index: Integer; const Value: TODSCell);
  public
    function Add: TODSCell;
    function GetItemByCoords(X, Y: Integer): TODSCell;
    property Items[Index: Integer]: TODSCell read GetItem write SetItem; default;
  end;

  TODSSpreadSheet = class(TXYSheet)
  private
    function GetCell(Col, Row: Integer): TODSCell;
    function GetCells: TODSCellList;
    procedure SetCell(Col, Row: Integer; const Value: TODSCell);
  protected
    function CreateCells: TCellList; override;
  public
    property Cell[Col, Row: Integer]: TODSCell read GetCell write SetCell;
    property Cells: TODSCellList read GetCells;
  end;

  TODSSpreadSheetList = class(TXMLSheetList)
  private
    function GetItems(Index: integer): TODSSpreadSheet;
    procedure SetItems(Index: integer; Value: TODSSpreadSheet);
  public
    function Add: TODSSpreadSheet;
    function GetSheetByName(Name: qiString): TODSSpreadSheet;
    property Items[Index: integer]: TODSSpreadSheet read GetItems
      write SetItems; default;
  end;

  TODSWorkbook = class(TODContainer)
  private
    FSpaceStr: qiString;
    FIsNotExpanding: Boolean;
    procedure ExpandRowsNCols(ASheet: TODSSpreadSheet; ExpandValue: qiString;
        NumbOfRepRows, NumbOfRepColumns: Integer; IsSpanning: Boolean);
    procedure CompressCells;
    function GetSheets: TODSSpreadSheetList;
  protected
    procedure DoLoad; override;
    function GetErrorMsg: qiString; override;
    function CreateSheets: TXMLSheetList; override;
    procedure OnGetCellText(Sender: TQIXMLStreamProcessor; const aText: qiString;
        TextType: TQIXMLTextType); override;
    procedure OnLoadSheet(Sender: TQIXMLStreamProcessor; const AName: qiString;
        Action: TQIXMLNodeAction); override;
    procedure ParseSheet(Sender: TQISAXParser; const AName: qiString); override;
  public
    constructor Create; override;
    property IsNotExpanding: Boolean read FIsNotExpanding write FIsNotExpanding;
    property Sheets: TODSSpreadSheetList read GetSheets;
  end;

  TODSFile = class(TZipDocumentFile)
  private
    function GetWorkbook: TODSWorkbook;
  protected
    function CreateContainer: TXMLDocContainer; override;
  public
    property Workbook: TODSWorkbook read GetWorkbook;
  end;

  TQImport3ODS = class(TQImport3WorkbookBased)
  private
    FSheetName: qiString;
    FNotExpandMergedValue: Boolean;
    procedure SetSheetName(const Value: qiString);
    procedure SetExpandFlag(const Value: Boolean);
  protected
    procedure FillImportRow; override;
    function ImportData: TQImportResult; override;
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
    property NotExpandMergedValue: Boolean read FNotExpandMergedValue
      write SetExpandFlag default true;
  end;

{$ENDIF}

implementation

{$IFDEF ODS}

{ TODSCellList }

function TODSCellList.Add: TODSCell;
begin
  Result := TODSCell(inherited Add);
end;

function TODSCellList.GetItem(Index: Integer): TODSCell;
begin
  Result := TODSCell(inherited Items[Index]);
end;

function TODSCellList.GetItemByCoords(X, Y: Integer): TODSCell;
begin
  Result := TODSCell(inherited GetItemByCoords(X, Y));
end;

procedure TODSCellList.SetItem(Index: Integer; const Value: TODSCell);
begin
  inherited Items[Index] := Value;
end;

function TODSSpreadSheet.GetCell(Col, Row: Integer): TODSCell;
begin
  Result := TODSCell(inherited Cell[Col, Row]);
end;

function TODSSpreadSheet.GetCells: TODSCellList;
begin
  Result := TODSCellList(FCells);
end;

function TODSSpreadSheet.CreateCells: TCellList;
begin
  Result := TODSCellList.Create(Self, TODSCell);
end;

procedure TODSSpreadSheet.SetCell(Col, Row: Integer; const Value: TODSCell);
begin
  inherited Cell[Col, Row] := Value;
end;

{ TODSSpreadSheetList }

function TODSSpreadSheetList.GetItems(Index: integer): TODSSpreadSheet;
begin
  Result := TODSSpreadSheet(inherited Items[Index]);
end;

procedure TODSSpreadSheetList.SetItems(Index: integer;
  Value: TODSSpreadSheet);
begin
  inherited Items[Index] := Value;
end;

function TODSSpreadSheetList.Add: TODSSpreadSheet;
begin
  Result := TODSSpreadSheet(inherited Add);
end;

function TODSSpreadSheetList.GetSheetByName(Name: qiString): TODSSpreadSheet;
begin
  Result := TODSSpreadSheet(inherited GetTableByName(Name));
end;

procedure TODSWorkbook.ParseSheet(Sender: TQISAXParser; const AName: qiString);
var
  Sheet: TODSSpreadSheet;
  Name, Value: qiString;
  Stop: Boolean;
begin
  if not Assigned(Sender) then
    Exit;
  Stop := False;
  if FCurrentSheet is TODSSpreadSheet then
  begin
    Sheet := TODSSpreadSheet(FCurrentSheet);
    if AName = 'table:table-row' then
    begin
      FColsRepeated := 0;
      Sheet.Y := Sheet.Y + 1;
      Sheet.X := -1;
      while Sender.GetNextAttribute(Name, Value, Stop) do
        if Name = 'table:number-rows-repeated' then
        begin
          FRowsRepeated := StrToInt(Value) - 1;
          Stop := True;
        end;
    end
    else if (AName = 'table:table-cell') or (AName = 'table:covered-table-cell') then
    begin
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

procedure TODSWorkbook.OnGetCellText(Sender: TQIXMLStreamProcessor; const
    aText: qiString; TextType: TQIXMLTextType);
var
  Sheet: TODSSpreadSheet;
begin
  if not ((FCurrentSheet is TODSSpreadSheet) and (TextType = xttText)) then
    Exit;
  Sheet := TODSSpreadSheet(FCurrentSheet);
  if (FRowsRepeated > 0) or (FColsRepeated > 0) then
  begin
    ExpandRowsNCols(Sheet, aText, FRowsRepeated, FColsRepeated, FParserFlag);
    if not FParserFlag then
      Sheet.X := Sheet.X + FColsRepeated;
  end
  else if not Assigned(FCurrentCell) then
  begin
    FCurrentCell := Sheet.Cells.Add;
    if Sheet.RowCount <= Sheet.Y then
      Sheet.RowCount := Sheet.Y + 1;
    FCurrentCell.Row := Sheet.Y;
    FCurrentCell.Col := Sheet.X;
    FCurrentCell.Value := aText;
    Sheet.Cell[Sheet.X, Sheet.Y] := TODSCell(FCurrentCell);
    if Sheet.RowCount = MaxRowCount + 1 then
      Sender.Halt;
  end
  else begin
    if FSpaceStr <> EmptyStr then
      FCurrentCell.Value := FCurrentCell.Value + FSpaceStr + aText
    else
      FCurrentCell.Value := FCurrentCell.Value + aText;
  end;
end;

procedure TODSWorkbook.OnLoadSheet(Sender: TQIXMLStreamProcessor; const AName:
    qiString; Action: TQIXMLNodeAction);
var
  Sheet: TODSSpreadSheet;
  I: Integer;
  Name, Value: qiString;
  Stop: Boolean;
begin
  case Action of
    xnaOpen:
      inherited;
    xnaClose:
      begin
        if not (FCurrentSheet is TODSSpreadSheet) then
          Exit;
        FSpaceStr := EmptyStr;
        Sheet := TODSSpreadSheet(FCurrentSheet);
        if AName = 'table:table-row' then
        begin
          Sheet.Y := Sheet.Y + FRowsRepeated;
          FColsRepeated := 0;
          FRowsRepeated := 0;
        end
        else if AName = 'table:table-cell' then
        begin
          if Assigned(FCurrentCell) then
          begin
            if FParserFlag then
              Exit;
            FCurrentCell := nil;
            if (FRowsRepeated > 0) or (FColsRepeated > 0) then
            begin
              if Sheet.X + FColsRepeated + 1 > Sheet.ColCount then
                Sheet.ColCount := Sheet.X + FColsRepeated + 1;
              if Sheet.Y + FRowsRepeated + 1 > Sheet.RowCount then
                Sheet.RowCount := Sheet.Y + FRowsRepeated + 1;
              Sheet.X := Sheet.X + FColsRepeated;
              Sheet.Y := Sheet.Y + FRowsRepeated;
              FColsRepeated := 0;
              FRowsRepeated := 0;
            end;
          end else begin
            FColsRepeated := 0;
          end;
        end
        else if Assigned(FCurrentCell) and (AName = 'text:s') then
        begin
          FSpaceStr := ' ';
          Stop := False;
          while Sender.GetNextAttribute(Name, Value, Stop) do
          begin
            if Name = 'text:c' then
              for I := 2 to StrToIntDef(Value, 1) do
               FSpaceStr := FSpaceStr + ' ';
          end;
        end
        else if AName = 'table:table' then
          FCurrentSheet := nil;
      end;
  else
    Exit;
  end;
end;

procedure TODSWorkbook.DoLoad;
begin
  inherited;
  CompressCells;
end;

procedure TODSWorkbook.CompressCells;
var
  SheetNum, I, J: Integer;
  Sheet: TODSSpreadSheet;
begin
  for SheetNum := 0 to FSheets.Count - 1 do
  begin
    Sheet := TODSSpreadSheet(FSheets[SheetNum]);
    if not Assigned(Sheet) or (Sheet.ColCount = 0) or (Sheet.RowCount = 0) then
      Continue;

    I := Sheet.ColCount - 1;
    J := Sheet.RowCount - 1;
    while Sheet.Cell[I, J] = nil do
    begin
      Dec(I);
      if I = 0 then
      begin
        I := Sheet.ColCount - 1;
        Dec(J);
      end;
    end;
    if J < Sheet.RowCount - 1 then
      Sheet.RowCount := J + 1;

    if Sheet.RowCount = 0 then
      Continue;
    I := Sheet.ColCount - 1;
    J := Sheet.RowCount - 1;
    while Sheet.Cell[I, J] = nil do
    begin
      Dec(J);
      if J = 0 then
      begin
        J := Sheet.RowCount - 1;
        Dec(I)
      end;
    end;
    if I < Sheet.ColCount - 1 then
      Sheet.ColCount := I + 1;
  end;
end;

procedure TODSWorkBook.ExpandRowsNCols(ASheet: TODSSpreadSheet; ExpandValue:
    qiString; NumbOfRepRows, NumbOfRepColumns: Integer; IsSpanning: Boolean);
var
  I: Integer;
  TempCell: TODSCell;
begin
  I := NumbOfRepRows;
  if ASheet.X + NumbOfRepColumns + 1 > ASheet.ColCount then
    ASheet.ColCount := ASheet.X + NumbOfRepColumns + 1;
  if ASheet.Y + NumbOfRepRows + 1 > ASheet.RowCount then
    ASheet.RowCount := ASheet.Y + NumbOfRepRows + 1;
  if NumbOfRepColumns >= 0 then
  begin
    repeat
      TempCell := nil;
      if not IsSpanning then
      begin
        TempCell := ASheet.Cells.Add;
        TempCell.Row := ASheet.Y + I;
        TempCell.Col := ASheet.X + NumbOfRepColumns;
        TempCell.Value := ExpandValue;
      end
      else if IsNotExpanding then
      begin
        if (NumbOfRepColumns = 0) and (I = 0) then
        begin
          TempCell := ASheet.Cells.Add;
          TempCell.Row := ASheet.Y;
          TempCell.Col := ASheet.X;
          TempCell.Value := ExpandValue;
        end;
      end
      else
      begin
        TempCell := ASheet.Cells.Add;
        TempCell.Row := ASheet.Y + I;
        TempCell.Col := ASheet.X + NumbOfRepColumns;
        TempCell.Value := ExpandValue;
      end;
      if Assigned(TempCell) then
        ASheet.Cell[TempCell.Col, TempCell.Row] := TempCell;
      I := I - 1;
    until (I < 0);
    ExpandRowsNCols(ASheet, ExpandValue, NumbOfRepRows,
      NumbOfRepColumns - 1, IsSpanning);
  end;
end;

constructor TODSWorkbook.Create;
begin
  inherited;
  FIsNotExpanding := true;
end;

function TODSWorkbook.GetErrorMsg: qiString;
begin
  Result := 'No spreadsheets were found';
end;

function TODSWorkbook.GetSheets: TODSSpreadSheetList;
begin
  Result := TODSSpreadSheetList(FSheets);
end;

function TODSWorkbook.CreateSheets: TXMLSheetList;
begin
  Result := TODSSpreadSheetList.Create(TODSSpreadSheet);
end;

function TODSFile.GetWorkbook: TODSWorkbook;
begin
  Result := TODSWorkbook(FContainer);
end;

function TODSFile.CreateContainer: TXMLDocContainer;
begin
  Result := TODSWorkbook.Create;
end;

constructor TQImport3ODS.Create(AOwner: TComponent);
begin
  inherited;
  NotExpandMergedValue := true;
end;

procedure TQImport3ODS.DoLoadConfiguration(IniFile: TIniFile);
begin
  inherited;
  with IniFile do
  begin
    SkipFirstRows := ReadInteger(ODS_OPTIONS, ODS_SKIP_LINES, SkipFirstRows);
    SheetName := ReadString(ODS_OPTIONS, ODS_SHEET_NAME, SheetName);
    NotExpandMergedValue := ReadBool(ODS_OPTIONS, ODS_NOT_EXPAND_MERGED_VALUE, NotExpandMergedValue);
  end;
end;

procedure TQImport3ODS.DoSaveConfiguration(IniFile: TIniFile);
begin
  inherited;
  with IniFile do
  begin
    WriteInteger(ODS_OPTIONS, ODS_SKIP_LINES, SkipFirstRows);
    WriteString(ODS_OPTIONS, ODS_SHEET_NAME, string(SheetName));
    WriteBool(ODS_OPTIONS, ODS_NOT_EXPAND_MERGED_VALUE, NotExpandMergedValue);
  end;
end;

procedure TQImport3ODS.FillImportRow;
var
  i, k: Integer;
  strValue: qiString;
  mapValue: qiString;
  TempSheet: TODSSpreadSheet;
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
      TempSheet := TODSFile(FDocFile).Workbook.Sheets.GetSheetByName(qiString(SheetName));

      Cell := TempSheet.Cell[GetColIdFromColIndex(mapValue) - 1, FCounter];
      if Assigned(Cell) then
        strValue := Cell.Value
      else
        strValue := EmptyStr;

      if AutoTrimValue then
        strValue := Trim(strValue);
      RowIsEmpty := RowIsEmpty and (strValue = '');
      FImportRow.SetValue(Map.Names[k], strValue, False);
      if Assigned(Cell) then
        Cell.Value := EmptyStr;
    end;
    DoUserDataFormat(FImportRow[i]);
  end;
end;

function TQImport3ODS.CreateDocFile: TBaseDocumentFile;
begin
  Result := TODSFile.Create;
end;

function TQImport3ODS.ImportData: TQImportResult;
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

procedure TQImport3ODS.LoadDocFile;
var
  WorkSheet: TODSSpreadSheet;
begin
  TODSFile(FDocFile).Workbook.IsNotExpanding := NotExpandMergedValue;
  inherited;
  WorkSheet := TODSFile(FDocFile).Workbook.Sheets.GetSheetByName(SheetName);
  FTotalRecCount := 0;
  if Assigned(WorkSheet) and (WorkSheet.RowCount > 0) then
    FTotalRecCount := WorkSheet.RowCount - SkipFirstRows;
end;

procedure TQImport3ODS.SetSheetName(const Value: qiString);
begin
  if (FSheetName <> Value) then
    FSheetName := Value;
end;

procedure TQImport3ODS.SetExpandFlag(const Value: Boolean);
begin
  if (Value <> FNotExpandMergedValue) then
    FNotExpandMergedValue := Value;
end;

{$ENDIF}

end.


