unit QImport3Docx;

{$I QImport3VerCtrl.Inc}

interface

{$IFDEF DOCX}

uses
  {$IFDEF VCL16}
    System.Classes,
    System.IniFiles,
    System.SysUtils,
    Winapi.msxml,
    Data.DB,
  {$ELSE}
    Classes,
    IniFiles,
    SysUtils,
    msxml,
    DB,
  {$ENDIF}
  QImport3,
  QImport3Common,
  QImport3StrTypes,
  QImport3XMLBased,
  QImport3XmlSax,
  QImport3BaseDocumentFile;

type
  TDocxCol = class(TCell)
  private
    FDisplayAsIcon: Boolean;
  public
    property DisplayAsIcon: Boolean read FDisplayAsIcon write FDisplayAsIcon default False;
  end;

  TDocxColList = class(TCellList)
  private
    function GetItem(Index: Integer): TDocxCol;
    procedure SetItem(Index: Integer; const Value: TDocxCol);
  public
    function Add: TDocxCol;
    property Items[Index: Integer]: TDocxCol read GetItem write SetItem; default;
  end;

  TDocxSheet = class(TXYSheet)
  private
    function GetCell(Col, Row: Integer): TDocxCol;
    function GetCells: TDocxColList;
    procedure SetCell(Col, Row: Integer; const Value: TDocxCol);
  protected
    function CreateCells: TCellList; override;
  public
    property Cell[Col, Row: Integer]: TDocxCol read GetCell write SetCell;
    property Cells: TDocxColList read GetCells;
  end;

  TDocxSheetList = class(TXMLSheetList)
  private
    function GetItem(Index: Integer): TDocxSheet;
    procedure SetItem(Index: Integer; const Value: TDocxSheet);
  public
    function Add: TDocxSheet;
    property Items[Index: Integer]: TDocxSheet read GetItem write SetItem; default;
  end;

  TDocxContainer = class(TXMLDocContainer)
  private
    FRowNum: Integer;
    FColsRepeated: Integer;
    FNeedFillMerge: Boolean;
    function GetSheets: TDocxSheetList;
    function ImageToString(const FileName: string; out AIsIcon: Boolean): qiString;
  protected
    function CreateSheets: TXMLSheetList; override;
    procedure OnGetCellText(Sender: TQIXMLStreamProcessor; const AText: qiString;
        TextType: TQIXMLTextType); override;
    procedure OnLoadSheet(Sender: TQIXMLStreamProcessor; const AName: qiString;
        Action: TQIXMLNodeAction); override;
    procedure LoadSheets; override;
  public
    property Sheets: TDocxSheetList read GetSheets;
  end;

  TDocxFile = class(TZipDocumentFile)
  private
    FNeedFillMerge: Boolean;
    function GetContainer: TDocxContainer;
    function GetSheets: TDocxSheetList;
    procedure SetNeedFillMerge(const Value: Boolean);
  protected
    function CreateContainer: TXMLDocContainer; override;
  public
    property NeedFillMerge: Boolean read FNeedFillMerge
      write SetNeedFillMerge;
    property Container: TDocxContainer read GetContainer;
    property Sheets: TDocxSheetList read GetSheets;
  end;

  TQImport3Docx = class(TQImport3XMLBased)
  private
    FNeedFillMerge: Boolean;
    FSheetNumber: integer;
    procedure SetSheetNumber(const Value: integer);
    procedure SetNeedFillMerge(const Value: Boolean);
  protected
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
    property TableNumber: integer read FSheetNumber
      write SetSheetNumber default 0;
    property NeedFillMerge: Boolean read FNeedFillMerge
      write SetNeedFillMerge default False;
  end;

{$ENDIF}

implementation

{$IFDEF DOCX}

{ TDocxColList }

function TDocxColList.Add: TDocxCol;
begin
  Result := TDocxCol(inherited Add)
end;

function TDocxColList.GetItem(Index: Integer): TDocxCol;
begin
  Result := TDocxCol(inherited Items[Index]);
end;

procedure TDocxColList.SetItem(Index: Integer; const Value: TDocxCol);
begin
  inherited Items[Index] := Value;
end;

function TDocxSheet.GetCell(Col, Row: Integer): TDocxCol;
begin
  Result := TDocxCol(inherited Cell[Col, Row]);
end;

function TDocxSheet.GetCells: TDocxColList;
begin
  Result := TDocxColList(FCells);
end;

function TDocxSheet.CreateCells: TCellList;
begin
  Result := TDocxColList.Create(Self, TDocxCol);
end;

procedure TDocxSheet.SetCell(Col, Row: Integer; const Value: TDocxCol);
begin
  inherited Cell[Col, Row] := Value;
end;

{ TDocxSheetList }

function TDocxSheetList.Add: TDocxSheet;
begin
  Result := TDocxSheet(inherited Add)
end;

function TDocxSheetList.GetItem(Index: Integer): TDocxSheet;
begin
  Result := TDocxSheet(inherited Items[Index]);
end;

procedure TDocxSheetList.SetItem(Index: Integer; const Value: TDocxSheet);
begin
  inherited Items[Index] := Value;
end;

{ TDocxFile }

function TDocxFile.CreateContainer: TXMLDocContainer;
begin
  Result := TDocxContainer.Create;
end;

function TDocxFile.GetContainer: TDocxContainer;
begin
  Result := TDocxContainer(FContainer);
end;

function TDocxFile.GetSheets: TDocxSheetList;
begin
  Result := Container.Sheets;
end;

procedure TDocxFile.SetNeedFillMerge(const Value: Boolean);
begin
  if FNeedFillMerge <> Value then
  begin
    FNeedFillMerge := Value;
    Container.FNeedFillMerge := Value;
  end
end;

{ TQImport3Docx }

procedure TQImport3Docx.SetSheetNumber(const Value: integer);
begin
  FSheetNumber := Value;
end;

procedure TQImport3Docx.SetNeedFillMerge(const Value: Boolean);
begin
  FNeedFillMerge := Value;
end;

procedure TQImport3Docx.FillImportRow;
var
  j, k: Integer;
  strValue: qiString;
  mapIndex: Integer;
  TempSheet: TDocxSheet;
  Col: TQImportCol;
  p: Pointer;
begin
  FImportRow.ClearValues;
  RowIsEmpty := True;
  for j := 0 to FImportRow.Count - 1 do
  begin
    Col := FImportRow[j];
    if FImportRow.MapNameIdxHash.TryGetValue(Col.Name, p) then
    begin
      k := Integer(p);
      strValue := '';
{$IFDEF VCL7}
      mapIndex := StrToInt(Map.ValueFromIndex[k]);
{$ELSE}
      mapIndex := StrToInt(Map.Values[Col.Name]);
{$ENDIF}
      TempSheet := TDocxFile(FDocFile).Container.Sheets[Pred(FSheetNumber)];
      if TempSheet.Cells.Count >= mapIndex then
        strValue := TempSheet.Cell[mapIndex - 1, FCounter].Value;
      if AutoTrimValue then
        strValue := Trim(strValue);
      RowIsEmpty := RowIsEmpty and (strValue = '');
      FImportRow.SetValue(Map.Names[k], strValue, False);
    end;
    DoUserDataFormat(Col);
  end;
end;

procedure TQImport3Docx.DoLoadConfiguration(IniFile: TIniFile);
begin
  inherited;
  with IniFile do
  begin
    SkipFirstRows := ReadInteger(DOCX_OPTIONS, DOCX_SKIP_LINES, SkipFirstRows);
    TableNumber := ReadInteger(DOCX_OPTIONS, DOCX_TABLE_NUMBER, TableNumber);
    NeedFillMerge := ReadBool(DOCX_OPTIONS, DOCX_NEED_FILLMERGE, NeedFillMerge);
  end;
end;

procedure TQImport3Docx.DoSaveConfiguration(IniFile: TIniFile);
begin
  inherited;
  with IniFile do
  begin
    WriteInteger(DOCX_OPTIONS, DOCX_SKIP_LINES, SkipFirstRows);
    WriteInteger(DOCX_OPTIONS, DOCX_TABLE_NUMBER, TableNumber);
    WriteBool(DOCX_OPTIONS, DOCX_NEED_FILLMERGE, NeedFillMerge);
  end;
end;

constructor TQImport3Docx.Create(AOwner: TComponent);
begin
  inherited;
  FSheetNumber := 0;
end;

function TQImport3Docx.CreateDocFile: TBaseDocumentFile;
begin
  Result := TDocxFile.Create;
end;

procedure TQImport3Docx.LoadDocFile;
begin
  TDocxFile(FDocFile).NeedFillMerge := FNeedFillMerge;
  inherited;
  FTotalRecCount := 0;
  if Assigned(FDocFile) and (FSheetNumber > 0) then
    FTotalRecCount := TDocxFile(FDocFile).Container.Sheets[Pred(FSheetNumber)].RowCount - SkipFirstRows;
end;

function TDocxContainer.GetSheets: TDocxSheetList;
begin
  Result := TDocxSheetList(FSheets);
end;

function TDocxContainer.CreateSheets: TXMLSheetList;
begin
  Result := TDocxSheetList.Create(TDocxSheet);
end;

function TDocxContainer.ImageToString(const FileName: string; out AIsIcon:
    Boolean): qiString;
var
  F: TSearchRec;
begin
  if FindFirst(WorkDir + 'word\media\' + FileName + '.*', faAnyFile, F) = 0 then
  try
    Result := FileToBase64(WorkDir + 'word\media\' + F.Name);
    AIsIcon := True;
  finally
    FindClose(F);
  end;
end;

procedure TDocxContainer.OnGetCellText(Sender: TQIXMLStreamProcessor; const
    AText: qiString; TextType: TQIXMLTextType);
begin
  if not (FParserFlag and Assigned(Sender) and
    Assigned(FCurrentCell) and (TextType = xttText)) then
    Exit;
  if (FCurrentCell.Value <> '') and (AText <> '') and (FRowNum > 0) then
    FCurrentCell.Value := FCurrentCell.Value + #13;
  FCurrentCell.Value := FCurrentCell.Value + AText;
end;

procedure TDocxContainer.OnLoadSheet(Sender: TQIXMLStreamProcessor; const
    AName: qiString; Action: TQIXMLNodeAction);
var
  Sheet: TDocxSheet;
  Name, Value: qiString;
  Stop, IsIcon: Boolean;
  TmpCol: TDocxCol;
  I: Integer;
begin
  if not Assigned(Sender) then
    Exit;
  case Action of
    xnaOpen:
      begin
        Stop := False;
        if FCurrentSheet is TDocxSheet then
        begin
          Sheet := TDocxSheet(FCurrentSheet);
          if AName = 'w:tr' then
          begin
            Sheet.Y := Sheet.Y + 1;
            Sheet.X := -1;
            if Sheet.Y + 1 > Sheet.RowCount then
              Sheet.RowCount := Sheet.Y + 1;
          end
          else if AName = 'w:tc' then
          begin
            Sheet.X := Sheet.X + 1;
            if Sheet.X + 1 > Sheet.ColCount then
              Sheet.ColCount := Sheet.X + 1;
            FCurrentCell := Sheet.Cells.Add;
            FCurrentCell.Row := Sheet.Y;
            FCurrentCell.Col := Sheet.X;
            TDocxCol(FCurrentCell).DisplayAsIcon := False;
            Sheet.Cell[FCurrentCell.Col, FCurrentCell.Row] := TDocxCol(FCurrentCell);
          end
          else if FNeedFillMerge and Assigned(FCurrentCell) and (AName = 'w:vMerge') then
          begin
            while Sender.GetNextAttribute(Name, Value, Stop) do
              if Name = 'w:val' then
                Stop := True;
            if not Stop then
            begin
              TmpCol := Sheet.Cell[FCurrentCell.Col, FCurrentCell.Row - 1];
              Assert(Assigned(TmpCol), 'Merging cell is not found!');
              if Assigned(TmpCol) then
                FCurrentCell.Value := TmpCol.Value;
            end;
          end
          else if Assigned(FCurrentCell) and (AName = 'w:gridSpan') then
          begin
            while Sender.GetNextAttribute(Name, Value, Stop) do
              if Name = 'w:val' then
              begin
                FColsRepeated := StrToInt(Value) - 1; // -1 because first cell is already added
                Stop := True;
              end;
          end
          else if (FCurrentCell is TDocxCol) and (AName = 'wp:docPr') then
          begin
            while Sender.GetNextAttribute(Name, Value, Stop) do
              if Name = 'name' then
              begin
                IsIcon := False;
                FCurrentCell.Value := ImageToString(Value, IsIcon);
                TDocxCol(FCurrentCell).DisplayAsIcon := IsIcon;
                Stop := True;
              end;
          end
          else if Assigned(FCurrentCell) and (AName = 'w:t') then
            FParserFlag := True
          else if Assigned(FCurrentCell) and (AName = 'w:r') then
            Inc(FRowNum)
        end
        else if AName = 'w:tbl' then
        begin
          FCurrentSheet := FSheets.Add;
          FParserFlag := False;
        end;
      end;
    xnaClose:
      begin
        if not (FCurrentSheet is TDocxSheet) then
          Exit;
        if Assigned(FCurrentCell) and (AName = 'w:tc') then
        begin
          FCurrentCell := nil;
          FParserFlag := False;
        end
        else if AName = 'w:tbl' then
          FCurrentSheet := nil
        else if Assigned(FCurrentCell) and (AName = 'w:r') and (FColsRepeated > 0) then
        begin
          Sheet := TDocxSheet(FCurrentSheet);
          for I := 1 to FColsRepeated do
          begin
            Sheet.X := Sheet.X + 1;
            TmpCol := Sheet.Cells.Add;
            TmpCol.Row := Sheet.Y;
            TmpCol.Col := Sheet.X;
            Sheet.Cell[TmpCol.Col, TmpCol.Row] := TmpCol;
            if FNeedFillMerge then
              TmpCol.Value := Sheet.Cell[TmpCol.Col - 1, TmpCol.Row].Value;
            if Sheet.X + 1 > Sheet.ColCount then
              Sheet.ColCount := Sheet.X + 1;
          end;
          FColsRepeated := 0;
        end else if Assigned(FCurrentCell) and (AName = 'w:r') then
          Dec(FRowNum);
      end;
  else
    Exit;
  end;
end;

procedure TDocxContainer.LoadSheets;
var
  XmlRec: TSearchRec;
  Path: string;
begin
  Path := WorkDir + 'word\document.xml';
  if FindFirst(Path, faAnyFile, XmlRec) = 0 then
  try
    FRowNum := -1;
    FSAXParser.OnLoadElement := OnLoadSheet;
    FSAXParser.OnGetText := OnGetCellText;
    FSAXParser.Parse(Path);
  finally
    FindClose(XmlRec);
  end;
end;

{$ENDIF}

end.

