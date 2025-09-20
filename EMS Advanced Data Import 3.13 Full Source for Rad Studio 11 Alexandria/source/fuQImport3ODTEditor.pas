unit fuQImport3ODTEditor;

{$I QImport3VerCtrl.Inc}

interface

{$IFDEF ODT}

uses
  {$IFDEF VCL16}
    Winapi.Windows,
    Winapi.Messages,
    System.SysUtils,
    System.Variants,
    System.Classes,
    System.Math,
    Vcl.Graphics,
    Vcl.Controls,
    Vcl.Forms,
    Vcl.Dialogs,
    Vcl.ComCtrls,
    Vcl.Buttons,
    Vcl.StdCtrls,
    Vcl.ImgList,
    Vcl.ToolWin,
    Vcl.Grids,
    Vcl.ExtCtrls,
  {$ELSE}
    Windows,
    Messages,
    SysUtils,
    {$IFDEF VCL6}
      Variants,
    {$ENDIF}
    Classes,
    Math,
    Graphics,
    Controls,
    Forms,
    Dialogs,
    ComCtrls,
    Buttons,
    StdCtrls,
    ImgList,
    ToolWin,
    Grids,
    ExtCtrls,
  {$ENDIF}
  {$IFDEF QI_UNICODE}
    QImport3WideStringGrid,
  {$ENDIF}
  QImport3ODT,
  QImport3Common,
  QImport3StrTypes,
  QImport3BaseDocumentFile,
  QImport3XLSUtils,
  fuQImport3PCEditor,
  fuQImport3Loading;

type
  TfmQImport3ODTEditor = class(TfmQImport3PCEditor)
    cbHeaderRow: TCheckBox;
    procedure cbHeaderRowClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    FODTFile: TODTFile;
    FSheetName: qiString;
    FIsHeaderUsed: Integer;
    procedure SetSheetName(const Value: qiString);
  protected
    procedure ApplyChanges; override;
    procedure ClearAll; override;
    procedure ClearData; override;
    function ColValue: integer; override;
    procedure DoPCChange; override;
    procedure FillGrid; override;
    function GetAutoFillValue(Index: integer): string; override;
    function GetCondition: Boolean; override;
    function GetMapValue(Index: integer): string; override;
    procedure InitObjs; override;
    function MarkFirstRow: Boolean; override;
    procedure TuneButtons; override;
  public
    property SheetName: qiString read FSheetName write SetSheetName;
    property IsHeaderUsed: Integer read FIsHeaderUsed write FIsHeaderUsed;
  end;

var
  fmQImport3ODTEditor: TfmQImport3ODTEditor;

function RunQImportODTEditor(AImport: TQImport3ODT): boolean;

{$ENDIF}

implementation

{$IFDEF ODT}

{$R *.dfm}

function RunQImportODTEditor(AImport: TQImport3ODT): boolean;
begin
  with TfmQImport3ODTEditor.Create(nil) do
  try
    Import := AImport;
    if AImport.UseHeader then
      IsHeaderUsed := 0
    else
      IsHeaderUsed := 1;
    FileName := AImport.FileName;
    SkipLines := AImport.SkipFirstRows;
    SheetName := AImport.SheetName;
    Result := ShowModal = mrOk;
    if Result then ApplyChanges;
  finally
    Free;
  end;
end;

procedure TfmQImport3ODTEditor.SetSheetName(const Value: qiString);
var
  i: Integer;
begin
  if FSheetName <> Value then
  begin
    FSheetName := Value;
     for i := 0 to pcGrid.PageCount - 1 do
      if pcGrid.Pages[i].Caption = string(Value) then
      begin
        pcGrid.ActivePage := pcGrid.Pages[i];
        Break;
      end;
    if assigned(pcGrid.ActivePage) then
      for i := 0 to pcGrid.ActivePage.ComponentCount - 1 do
        if pcGrid.ActivePage.Components[i].Tag = pcGrid.ActivePage.Tag then
          FCurrentStringGrid := TqiStringGrid(pcGrid.ActivePage.Components[i]);
  end;
end;

procedure TfmQImport3ODTEditor.FillGrid;
var
  TabSheet: TTabSheet;
  StringGrid: TqiStringGrid;
  SheetIndex, RowIndex, ColIndex: Integer;
  F: TForm;
  Start, Finish: TDateTime;
  Sheet: TODTSpreadSheet;
  Cell: TODTCell;
begin
  if assigned(FODTFile) then
    FODTFile.Free;
  FODTFile := TODTFile.Create;
  ClearAll;

  if not FileExists(FileName) then Exit;

  FODTFile.FileName := FileName;
  Start := Now;
  F := ShowLoading(Self, FileName);
  try
    Application.ProcessMessages;
    FODTFile.Load;
    for SheetIndex := 0 to FODTFile.Workbook.Sheets.Count - 1 do
    begin
      Sheet := FODTFile.Workbook.Sheets[SheetIndex];

      TabSheet := TTabSheet.Create(pcGrid);
      TabSheet.PageControl := pcGrid;
      TabSheet.Caption := string(Sheet.Name);
      TabSheet.Tag := SheetIndex;

      StringGrid := TqiStringGrid.Create(TabSheet);
      StringGrid.Parent := TabSheet;
      StringGrid.Align := alClient;
      StringGrid.ColCount := DefMapColRowCount;
      StringGrid.RowCount := DefMapColRowCount;
      StringGrid.FixedCols := 1;
      StringGrid.FixedRows := 1;
      StringGrid.Tag := SheetIndex;
      StringGrid.DefaultColWidth := 64;
      StringGrid.DefaultRowHeight := 16;
      StringGrid.ColWidths[0] := 30;
      StringGrid.Options := StringGrid.Options - [goRangeSelect];
      GridFillFixedCells(StringGrid);
      if IsHeaderUsed = 0 then
        for ColIndex := 0 to StringGrid.ColCount - 1 do
          StringGrid.Cells[ColIndex, 0] := EmptyStr;
      StringGrid.OnDrawCell := GridDrawCell;
      StringGrid.OnMouseDown := GridMouseDown;

      for RowIndex := 0 to Min(Sheet.RowCount, DefMapColRowCount) - 1 do
      begin
        for ColIndex := 0 to Sheet.ColCount - 1 do
        begin
          Cell := Sheet.Cell[ColIndex, RowIndex];
          if not Assigned(Cell) then Continue;
          StringGrid.Cells[ColIndex + 1, RowIndex + 1] := Cell.Value;
          SetStringGridColWidth(StringGrid, ColIndex + 1, RowIndex + 1);
        end;
      end;

      if SheetIndex = 0 then
        SheetName := TabSheet.Caption;
    end;
  finally
    Finish := Now;
    while (Finish - Start) < EncodeTime(0, 0, 0, 500) do
      Finish := Now;
    if Assigned(F) then
      F.Free;
    TuneButtons;
  end;
end;


procedure TfmQImport3ODTEditor.ApplyChanges;
begin
  inherited;
  TQImport3ODT(Import).SheetName := SheetName;
  TQImport3ODT(Import).UseHeader := IsHeaderUsed = 0;
end;

procedure TfmQImport3ODTEditor.TuneButtons;
begin
  inherited;
  cbHeaderRow.Enabled := tbtAutoFill.Enabled;
  if cbHeaderRow.Enabled then
    if IsHeaderUsed = 0 then
      cbHeaderRow.Checked := true
    else
      cbHeaderRow.Checked := false;
end;

procedure TfmQImport3ODTEditor.cbHeaderRowClick(Sender: TObject);
var
  i, k, j, W, border: Integer;
  TabSheet: TTabSheet;
  StringGrid: TqiStringGrid;
  TempName: qiString;
  F: TForm;
  Start, Finish: TDateTime;
  SpreadSheet: TODTSpreadSheet;
begin
  if not FileExists(FileName) or (FODTFile.FileName = '') then Exit;
  if cbHeaderRow.Checked then
    IsHeaderUsed := 0
  else
    IsHeaderUsed := 1;
  border := pcGrid.PageCount - 1;
  TempName := SheetName;
  ClearAll;
  Start := Now;
  F := ShowLoading(Self, 'Applying settings');
  try
    Application.ProcessMessages;
    // <pai>
    for k := 0 to border do
    begin
      SpreadSheet := FODTFile.Workbook.Sheets[k];

      TabSheet := TTabSheet.Create(pcGrid);
      TabSheet.PageControl := pcGrid;
      TabSheet.Caption := string(SpreadSheet.Name);
      TabSheet.Tag := k;

      StringGrid := TqiStringGrid.Create(TabSheet);
      StringGrid.Parent := TabSheet;
      StringGrid.Align := alClient;
      StringGrid.ColCount := DefMapColRowCount;
      StringGrid.RowCount := DefMapColRowCount;
      StringGrid.FixedCols := 1;
      StringGrid.FixedRows := 1;
      StringGrid.Tag := k;
      StringGrid.DefaultColWidth := 64;
      StringGrid.DefaultRowHeight := 16;
      StringGrid.ColWidths[0] := 30;
      StringGrid.Options := StringGrid.Options - [goRangeSelect];
      GridFillFixedCells(StringGrid);
      if IsHeaderUsed = 0 then
        for i := 0 to StringGrid.ColCount - 1 do
          StringGrid.Cells[i, 0] := EmptyStr;
      StringGrid.OnDrawCell := GridDrawCell;
      StringGrid.OnMouseDown := GridMouseDown;

      for i := 0 to SpreadSheet.RowCount - 1 do
      begin
        for j := 0 to SpreadSheet.ColCount - 1 do
        begin
          StringGrid.Cells[j + 1 , i + 1 * IsHeaderUsed] := SpreadSheet.Cell[j, i].Value;
          W := StringGrid.Canvas.TextWidth(StringGrid.Cells[j + 1, i + 1 * IsHeaderUsed]);
          if W + 10 > StringGrid.ColWidths[j + 1] then
          begin
            if W + 10 < 130 then
              StringGrid.ColWidths[j + 1] := W + 10
            else
              StringGrid.ColWidths[j + 1] := 130;
          end;
        end;
      end;
    end;
    // </pai>
    SheetName := TempName;
  finally
    Finish := Now;
    while (Finish - Start) < EncodeTime(0, 0, 0, 500) do
      Finish := Now;
    if Assigned(F) then
      F.Free;
  end;
end;

procedure TfmQImport3ODTEditor.ClearAll;
begin
  SheetName := '';
  inherited;
end;

procedure TfmQImport3ODTEditor.ClearData;
begin
  if assigned(FODTFile) then
    FODTFile.Free;
  if assigned(FCurrentStringGrid) then
    FCurrentStringGrid := nil;
  inherited;
end;

function TfmQImport3ODTEditor.ColValue: integer;
begin
  Result := 0;
  if Assigned(lvFields.Selected) then
    if lvFields.Selected.SubItems[0] <> EmptyStr then
      Result := GetColIdFromColIndex(lvFields.Selected.SubItems[0]);
end;

procedure TfmQImport3ODTEditor.DoPCChange;
begin
  SheetName := pcGrid.ActivePage.Caption;
end;

procedure TfmQImport3ODTEditor.FormCloseQuery(Sender: TObject; var CanClose:
    Boolean);
var
  SpreadSheet: TODTSpreadSheet;
begin
  if ModalResult = mrCancel then
    Exit;
  // <pai>
  if Assigned(FODTFile) then
  begin
    SpreadSheet := FODTFile.Workbook.Sheets.GetSheetByName(qiString(SheetName));
    if Assigned(SpreadSheet) and SpreadSheet.IsComplexTable and
      (MessageDlg('Selected table has a complex structure and could be improperly converted' + #10 +
        '(it contains vertically merged cells and/or subtables).'
        + #10 + 'Do you want to convert this table anyway?' + #10 +
        'You could examine internal structure of selected table by pressing No.',
        mtInformation, [mbYes, mbNo], 0) = mrNo) then
    begin
      CanClose := False;
      Exit;
    end;
  end;
  // </pai>
  ApplyChanges;
end;

function TfmQImport3ODTEditor.GetAutoFillValue(Index: integer): string;
begin
  Result := Col2Letter(Index + 1);
end;

function TfmQImport3ODTEditor.GetCondition: Boolean;
begin
  Result := (inherited GetCondition) and (pcGrid.PageCount > 0);
end;

function TfmQImport3ODTEditor.GetMapValue(Index: integer): string;
begin
  Result := Col2Letter(Index);
end;

procedure TfmQImport3ODTEditor.InitObjs;
var
  TabSheet: TTabSheet;
  StringGrid: TqiStringGrid;
  k: Integer;
begin
  FODTFile := TODTFile.Create;
  for k := 0 to 2 do
  begin
    TabSheet := TTabSheet.Create(pcGrid);
    TabSheet.PageControl := pcGrid;
    TabSheet.Caption := 'Table' + IntToStr(k + 1);
    TabSheet.Tag := k;
    StringGrid := TqiStringGrid.Create(TabSheet);
    StringGrid.Parent := TabSheet;
    StringGrid.Align := alClient;
    StringGrid.ColCount := DefMapColRowCount;
    StringGrid.RowCount := DefMapColRowCount;
    StringGrid.FixedCols := 1;
    StringGrid.FixedRows := 1;
    StringGrid.Tag := k;
    StringGrid.DefaultColWidth := 64;
    StringGrid.DefaultRowHeight := 16;
    StringGrid.ColWidths[0] := 30;
    StringGrid.Options := StringGrid.Options - [goRangeSelect];
    GridFillFixedCells(StringGrid);
  end;
  inherited;
end;

function TfmQImport3ODTEditor.MarkFirstRow: Boolean;
begin
  Result := False;
end;

{$ENDIF}

end.
