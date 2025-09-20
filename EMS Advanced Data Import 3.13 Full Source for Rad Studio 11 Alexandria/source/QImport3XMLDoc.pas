unit QImport3XMLDoc;

{$I QImport3VerCtrl.Inc}

interface

{$IFDEF XMLDOC}

uses
  {$IFDEF VCL16}
    {$IFNDEF NOGUI}
      Vcl.ComCtrls,
    {$ENDIF}
    System.Variants,
    System.Math,
    System.SysUtils,
    Winapi.Windows,
    {$IFDEF VCL21}
      System.NetEncoding,
    {$ELSE}
      Soap.EncdDecd,
    {$ENDIF}
    System.Classes,
    System.IniFiles,
  {$ELSE}
    {$IFNDEF NOGUI}
      ComCtrls,
    {$ENDIF}
    {$IFDEF VCL6}
      Variants,
    {$ENDIF}
    Math,
    SysUtils,
    Windows,
    EncdDecd,
    Classes,
    IniFiles,
  {$ENDIF}
  QImport3,
  QImport3StrTypes,
  QImport3XMLBased,
  QImport3XmlSax,
  QImport3BaseDocumentFile,
  QImport3HashTable,
  QImport3WideStrUtils,
  QImport3Common,
  QImport3ValueTable;

type
  TXMLDataLocation = (tlAttributes, tlSubNodes);

  TXMLDocFile = class(TXMLFile)
  private
    FXPath: qiString;
    FNamesList: TQImportHashTable;
    FNamesCounter: Integer;
    FDataLocation: TXMLDataLocation;
    FGrid: TQImport3ValueTable;
    FTextBuffer: TqiStringList;
    FColCount: Integer;
    FRowCount: Integer;
    FPreviewRowCount: Integer;
    procedure OnLoadCell(Sender: TQIXMLStreamProcessor; const AName: qiString;
        Action: TQIXMLNodeAction);
    procedure OnGetCellText(Sender: TQIXMLStreamProcessor; const AText: qiString;
        TextType: TQIXMLTextType);
    function GetCells(ACol, ARow: Integer): qiString;
    procedure SetXPath(const Value: qiString);
    procedure SetDataLocation(const Value: TXMLDataLocation);
    procedure LoadCells;
  protected
    function GetXMLProcessorClass: TQIXMLStreamProcessorClass; override;
    procedure SetMaxRowCount(const Value: Integer); override;
    procedure LoadXML; override;
  public
    constructor Create; overload; override;
    destructor Destroy; override;
    procedure ClearCell(ACol, ARow: Integer);
    procedure Clear; override;
    property XPath: qiString read FXPath write SetXPath;
    property DataLocation: TXMLDataLocation read FDataLocation write SetDataLocation;

    property Cells[ACol, ARow: Integer]: qiString read GetCells;
    property ColCount: Integer read FColCount;
    property RowCount: Integer read FRowCount;
  end;

  TQImport3XMLDoc = class(TQImport3XMLBased)
  private
    FXPath: qiString;
    FDataLocation: TXMLDataLocation;
  protected
    procedure FillImportRow; override;
    procedure DoLoadConfiguration(IniFile: TIniFile); override;
    procedure DoSaveConfiguration(IniFile: TIniFile); override;
    function CreateDocFile: TBaseDocumentFile; override;
    procedure LoadDocFile; override;
  public
  published
    property FileName;
    property XPath: qiString read FXPath write FXPath;
    property DataLocation: TXMLDataLocation read FDataLocation write FDataLocation;
    property SkipFirstRows default 0;
  end;

{$IFNDEF NOGUI}
  TQIXMLTreeBuilder = class(TObject)
  private
    FCurrentNode: TTreeNode;
    FParser: TQISAXParser;
    FTreeView: TTreeView;
    FTagsProcessed: Integer;
    FMaxTagsProcessed: Integer;
    procedure OnLoadElement(Sender: TQIXMLStreamProcessor; const AName: qiString;
        Action: TQIXMLNodeAction);
  public
    constructor Create;
    destructor Destroy; override;
    procedure FillTreeView(const FileName: string; TreeView: TTreeView);
    property MaxTagsProcessed: Integer read FMaxTagsProcessed write FMaxTagsProcessed;
  end;
{$ENDIF}

{$IFNDEF NOGUI}
procedure FillStringGrid(DataGrid: TqiStringGrid; XMLFile: TXMLDocFile);
procedure XMLFile2TreeView(TreeView: TTreeView; XMLFile: TXMLDocFile);
{$ENDIF}

{$ENDIF}

implementation

{$IFDEF XMLDOC}

const
  LF = #13#10;
  //NodeTypes
  qntText       = 3;
  qntComment    = 8;
  ElementImage = 0;
  TextImage = 1;
  AttImage = 2;
  BeginCols = 2;
  BeginRows = 1;
  Base64AttributeFlag = 'binary.base64';
  DatatypeAttributeFlag = 'datatype';

{$IFNDEF NOGUI}
procedure FillStringGrid(DataGrid: TqiStringGrid; XMLFile: TXMLDocFile);
var
  i, j: Integer;
begin
  if not Assigned(XMLFile) then Exit;

  DataGrid.ColCount := XMLFile.ColCount;
  DataGrid.RowCount := Min(XMLFile.RowCount, 30);
  for i := 0 to XMLFile.ColCount - 1 do
    for j := 0 to DataGrid.RowCount - 1 do
      DataGrid.Cells[i, j] := XMLFile.Cells[i, j];

  if DataGrid.RowCount > 1 then
    DataGrid.FixedRows := 1;
  if DataGrid.ColCount > 1 then
    DataGrid.FixedCols := 1;
end;

procedure XMLFile2TreeView(TreeView: TTreeView; XMLFile: TXMLDocFile);
var
  Scanner: TQIXMLTreeBuilder;
begin
  if Assigned(XMLFile) then
  begin
    TreeView.Items.BeginUpdate;
    try
      TreeView.Items.Clear;
      Scanner := TQIXMLTreeBuilder.Create;
      try
        Scanner.MaxTagsProcessed := XMLFile.FPreviewRowCount;
        Scanner.FillTreeView(XMLFile.FileName, TreeView);
      finally
        Scanner.Free;
      end;
    finally
      TreeView.Items.EndUpdate;
    end;
  end;
end;
{$ENDIF}

{ TXMLDocFile }

procedure TXMLDocFile.Clear;
begin
  inherited;
  FGrid.ColumnCount := 0;

  FColCount := 0;
  FRowCount := 0;
end;

procedure TXMLDocFile.ClearCell(ACol, ARow: Integer);
begin
  if (ACol < FGrid.ColumnCount) and (FGrid.RowCount[ACol] > ARow) then
    FGrid[ACol, ARow] := EmptyStr;
end;

constructor TXMLDocFile.Create;

  function GenerateTmpDirName: string;
  var
    Buff: array[0..MAX_PATH - 1] of Char;
  begin
    FillChar(Buff, Length(Buff), 0);
    GetTempPath(MAX_PATH, Buff);
    Result := Buff;
  end;

  function CreateTmpFileStream(const ATmpDir, AFilePrefix: string): TFileStream;

    function GenerateTmpFileName(const ATmpDir, AFilePrefix: string): string;
    var
      Buff: array[0..MAX_PATH - 1] of Char;
    begin
      GetTempFileName(PChar(ATmpDir), PChar(AFilePrefix), 0, Buff);
      Result := Buff;
    end;

  begin
    Result := TFileStream.Create(GenerateTmpFileName(ATmpDir, AFilePrefix),
      fmOpenReadWrite or fmCreate or fmShareDenyWrite);
  end;

var
  TmpDir: string;
begin
  TmpDir := GenerateTmpDirName;
  if not DirectoryExists(TmpDir) then
    CreateDir(TmpDir);

  FGrid := TQImport3ValueTable.Create(
    CreateTmpFileStream(TmpDir, 'pos'), CreateTmpFileStream(TmpDir, 'val'));

  FGrid.ColumnCount := 0;
  FDataLocation := tlAttributes;
  FColCount := 0;
  FRowCount := 0;
  FPreviewRowCount := 256;
  FXPath := sDefaultXPath;
  FTextBuffer := TqiStringList.Create;
  inherited;
end;

destructor TXMLDocFile.Destroy;
begin
  FGrid.Free;
  FTextBuffer.Free;
  inherited;
end;

function TXMLDocFile.GetCells(ACol, ARow: Integer): qiString;
begin
  Result := '';
  if FGrid.ColumnCount > ACol then
    if FGrid.RowCount[ACol] > ARow then
      Result := FGrid[ACol, ARow];
end;

procedure TXMLDocFile.SetDataLocation(const Value: TXMLDataLocation);
begin
  if FDataLocation <> Value then
  begin
    FDataLocation := Value;
    if Loaded then
      LoadCells;
  end;
end;

procedure TXMLDocFile.SetXPath(const Value: qiString);
begin
  if FXPath <> Value then
  begin
    FXPath := Value;
    if Loaded then
      LoadCells;
  end;
end;

procedure TXMLDocFile.LoadCells;
var
  i: Integer;
begin
  if not Loaded or (Length(FXPath) = 0) then Exit;

  FNamesCounter := 0;
  FTextBuffer.Clear;
  FColCount := BeginCols;
  FRowCount := BeginRows;

  FGrid.Clear;
  FGrid.ColumnCount := BeginCols;

  for i := 0 to BeginCols - 1 do
    FGrid.RowCount[i] := BeginRows;

  FGrid[0, 0] := 'Node name';
  FGrid[1, 0] := 'Text';

  FNamesList := TQImportHashTable.Create;
  try
    FParserFlag := False;
    FXMLProcessor.KeepSpaces := False;
    TQIXPathEvaluator(FXMLProcessor).Evaluate(FileName, FXPath);
  finally
    FNamesList.Free;
  end;
end;

procedure TXMLDocFile.LoadXML;
begin
  inherited;
  FXMLProcessor.OnLoadElement := OnLoadCell;
  FXMLProcessor.OnGetText := OnGetCellText;
end;

procedure TXMLDocFile.SetMaxRowCount(const Value: Integer);
begin
  inherited;
  if Value > 256 then
    FPreviewRowCount := Value;
end;

function TXMLDocFile.GetXMLProcessorClass: TQIXMLStreamProcessorClass;
begin
  Result := TQIXPathEvaluator;
end;

procedure TXMLDocFile.OnLoadCell(Sender: TQIXMLStreamProcessor; const AName: qiString; Action: TQIXMLNodeAction);

  function GetIndex(const S: qiString): Integer;
  var
    P: Pointer;
  begin
    Result := -1;
    if Length(S) = 0 then
      Exit;
    if not FNamesList.TryGetValue(S, P) then
    begin
      FNamesList.Add(S, Pointer(FNamesCounter));
      Inc(FNamesCounter);
      FColCount := FNamesCounter + BeginCols;
      FGrid.ColumnCount := FColCount;
      Result := FColCount - 1;
      FGrid.RowCount[Result] := Succ(FRowCount);
      FGrid[Result, 0] := S;
    end
    else begin
      Result := Integer(P) + BeginCols;
      if FGrid.RowCount[Result] < Succ(FRowCount) then
        FGrid.RowCount[Result] := Succ(FRowCount);
    end;
  end;

var
  Name, Value, TagName, Text: qiString;
  Stop, IsBase64: Boolean;
  I, Index: Integer;
begin
  if not Assigned(Sender) then
    Exit;
  Stop := False;
  case Action of
    xnaOpen:
      if not FParserFlag then
      begin
        FGrid.RowCount[0] := Succ(FRowCount);

        FGrid[0, FRowCount] := AName;
        FParserFlag := True;

        FParserResult := EmptyStr;
        FTextBuffer.Clear;
        if FDataLocation <> tlAttributes then
        begin
          FParserArgument := True;
          Exit;
        end;

        FParserArgument := False;
        while Sender.GetNextAttribute(Name, Value, Stop) do
        begin
          Index := GetIndex(Name);
          if Index < 0 then
            Continue;
          FGrid[Index, FRowCount] := Value;
        end;
      end
      else if not FParserArgument and (FDataLocation = tlSubNodes) then
        FParserArgument := True;
    xnaClose:
      begin
        if not FParserFlag then
          Exit;
        if FParserArgument then
        begin
          if FDataLocation = tlSubNodes then
          begin
            FParserArgument := False;

            IsBase64 := False;
            while Sender.GetNextAttribute(Name, Value, Stop) do
            begin
              IsBase64 := (QICompareText(Name, DatatypeAttributeFlag) = 0) and
                          (QICompareText(Value, Base64AttributeFlag) = 0);
              if IsBase64 then
                Stop := True;
            end;
            FGrid.RowCount[1] := Succ(FRowCount);

            for I := 0 to FTextBuffer.Count - 1 do
              Text := Trim(Text) + #$20 + Trim(FTextBuffer.ValueFromIndex[I]);
            Text := Trim(Text);

            {$IFDEF VCL6}
              if IsBase64 then
                {$IFDEF VCL21}
                FGrid[1, FRowCount] := TNetEncoding.Base64.Encode(Text)
                {$ELSE}
                FGrid[1, FRowCount] := {$IFDEF VCL16}Soap.{$ENDIF}EncdDecd.DecodeString(Text)
                {$ENDIF}
              else
            {$ENDIF}
                FGrid[1, FRowCount] := Text;

            for I := 0 to FTextBuffer.Count - 1 do
            begin
              TagName := FTextBuffer.Names[I];
              Text := FTextBuffer.ValueFromIndex[I];
              {$IFDEF VCL6}
              if IsBase64 then
                {$IFDEF VCL21}
                Text := TNetEncoding.Base64.Encode(Text);
                {$ELSE}
                Text := {$IFDEF VCL16}Soap.{$ENDIF}EncdDecd.DecodeString(Text);
                {$ENDIF}
              {$ENDIF}
              Index := GetIndex(TagName);

              FGrid[Index, FRowCount] := EmptyStr;
              if Length(Trim(Text)) > 0 then
                FGrid[Index, FRowCount] := Trim(Text);

              if Length(FGrid[Index, 0]) = 0 then
                FGrid[Index, 0] := TagName;
              if FGrid.RowCount[0] < FRowCount + 1 then
                FGrid.RowCount[0] := FRowCount + 1;
              FGrid[0, FRowCount] := AName;
            end;

            if FTextBuffer.Count > 0 then
              Inc(FRowCount);
          end;
          FTextBuffer.Clear;
        end
        else begin
          if Length(Trim(FTextBuffer.Text)) > 0 then
          begin
            if FGrid.RowCount[1] < Succ(FRowCount) then
              FGrid.RowCount[1] := Succ(FRowCount);
            FGrid[1, FRowCount] := Trim(FTextBuffer.Text);
          end;
          FParserFlag := False;
          Inc(FRowCount);
        end;
      end;
  else
    Exit;
  end;
  if (MaxRowCount > 0) and (FRowCount > MaxRowCount + 1) then
    Sender.Halt;
end;

procedure TXMLDocFile.OnGetCellText(Sender: TQIXMLStreamProcessor; const AText: qiString; TextType: TQIXMLTextType);
var
  Text, TextTag: qiString;
begin
  if not (FParserFlag and (TextType in [xttText, xttCData])) then
    Exit;

  TextTag := Copy(AText, 1, Pos('=', AText) - 1);
  Text := Copy(AText, Pos('=', AText) + 1, Length(AText));

  if (FDataLocation = tlAttributes) then
  begin
    if (FTextBuffer.Count = 0) and (TextTag = Sender.CurrentTag) then
      FTextBuffer.Add(Text)
  end else
    FTextBuffer.Add(AText);
end;

procedure TQImport3XMLDoc.FillImportRow;
var
  j, k: Integer;
  strValue: qiString;
  mapValue: qiString;
  p: Pointer;
begin
  FImportRow.ClearValues;
  RowIsEmpty := True;
  for j := 0 to FImportRow.Count - 1 do
  begin
    if FImportRow.MapNameIdxHash.TryGetValue(FImportRow[j].Name, p) then
    begin
      k := Integer(p);
{$IFDEF VCL7}
      mapValue := Map.ValueFromIndex[k];
{$ELSE}
      mapValue := Map.Values[FImportRow[j].Name];
{$ENDIF}
      strValue := TXMLDocFile(FDocFile).Cells[Pred(StrToInt(mapValue)), FCounter];
      if AutoTrimValue then
        strValue := Trim(strValue);
      RowIsEmpty := RowIsEmpty and (strValue = '');
      FImportRow.SetValue(Map.Names[k], strValue, False);
      TXMLDocFile(FDocFile).ClearCell(Pred(StrToInt(mapValue)), FCounter);
    end;
    DoUserDataFormat(FImportRow[j]);
  end;
end;

procedure TQImport3XMLDoc.DoLoadConfiguration(IniFile: TIniFile);
begin
  inherited;
  with IniFile do
  begin
    SkipFirstRows := ReadInteger(XML_OPTIONS, XML_SKIP_LINES, SkipFirstRows);
  end;
end;

procedure TQImport3XMLDoc.DoSaveConfiguration(IniFile: TIniFile);
begin
  inherited;
  with IniFile do
  begin
    WriteInteger(XML_OPTIONS, XML_SKIP_LINES, SkipFirstRows);
  end;
end;

function TQImport3XMLDoc.CreateDocFile: TBaseDocumentFile;
begin
  Result := TXMLDocFile.Create;
end;

procedure TQImport3XMLDoc.LoadDocFile;
begin
  inherited;
  TXMLDocFile(FDocFile).DataLocation := FDataLocation;
  TXMLDocFile(FDocFile).XPath := FXPath;
  FTotalRecCount := 0;
  if TXMLDocFile(FDocFile).RowCount > 0 then
    FTotalRecCount := TXMLDocFile(FDocFile).RowCount - SkipFirstRows;
end;

{$IFNDEF NOGUI}
constructor TQIXMLTreeBuilder.Create;
begin
  inherited;
  FParser := TQISAXParser.Create;
  FParser.OnLoadElement := OnLoadElement;
  FCurrentNode := nil;
end;

destructor TQIXMLTreeBuilder.Destroy;
begin
  FParser.Free;
  inherited;
end;

procedure TQIXMLTreeBuilder.FillTreeView(const FileName: string; TreeView:
    TTreeView);
begin
  if not Assigned(TreeView) then
    Exit;
  if FileName = EmptyStr then
    raise Exception.Create(sFileNameNotDefined);
  if not FileExists(FileName) then
    raise Exception.CreateFmt(sFileNotFound, [FileName]);
  FTreeView := TreeView;
  try
    FTagsProcessed := 0;
    FParser.Parse(FileName);
  finally
    FTreeView := nil;
  end;
end;

procedure TQIXMLTreeBuilder.OnLoadElement(Sender: TQIXMLStreamProcessor; const
    AName: qiString; Action: TQIXMLNodeAction);
var
  Name, Value: qiString;
  Stop: Boolean;
  Node: TTreeNode;
begin
  if not Assigned(Sender) then
    Exit;
  case Action of
    xnaOpen:
      begin
        Stop := False;
        FCurrentNode := FTreeView.Items.AddChild(FCurrentNode, AName);
        if Assigned(FCurrentNode) then
        begin
          FCurrentNode.ImageIndex := ElementImage;
          FCurrentNode.SelectedIndex := ElementImage;
          while Sender.GetNextAttribute(Name, Value, Stop) do
          begin
            Node := FTreeView.Items.AddChild(FCurrentNode, Concat('@', Name, ' = "',
              Trim(Value), '"'));
            Node.ImageIndex := AttImage;
            Node.SelectedIndex := AttImage;
            Node.Data := Pointer(2);
          end;
          Inc(FTagsProcessed);
          if FTagsProcessed = MaxTagsProcessed then
            Sender.Halt;
        end;
      end;
    xnaClose:
      begin
        if Assigned(FCurrentNode) then
          FCurrentNode := FCurrentNode.Parent;
      end;
  else
    Exit;
  end;
end;
{$ENDIF}

{$ENDIF}

end.
