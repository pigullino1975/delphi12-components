unit fuQImport3ODSEditor;

{$I QImport3VerCtrl.Inc}

interface

{$IFDEF ODS}

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
  QImport3ODS,
  QImport3Common,
  QImport3StrTypes,
  QImport3BaseDocumentFile,
  QImport3XLSUtils,
  fuQImport3PCEditor,
  fuQImport3Loading;

type
  TfmQImport3ODSEditor = class(TfmQImport3PCEditor)
  private
    FODSFile: TODSFile;
    FSheetName: qiString;
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
  public
    property SheetName: qiString read FSheetName write SetSheetName;
  end;

var
  fmQImport3ODSEditor: TfmQImport3ODSEditor;

function RunQImportODSEditor(AImport: TQImport3ODS): boolean;

{$ENDIF}

implementation

{$IFDEF ODS}

{$R *.dfm}

function RunQImportODSEditor(AImport: TQImport3ODS): boolean;
begin
  with TfmQImport3ODSEditor.Create(nil) do
  try
    Import := AImport;
    FileName := AImport.FileName;
    SkipLines := AImport.SkipFirstRows;
    SheetName := AImport.SheetName;
    Result := ShowModal = mrOk;
    if Result then ApplyChanges;
  finally
    Free;
  end;
end;

procedure TfmQImport3ODSEditor.FillGrid;
var
  TabSheet: TTabSheet;
  StringGrid: TqiStringGrid;
  SheetIndex, RowIndex, ColIndex: Integer;
  F: TForm;
  Start, Finish: TDateTime;
  Sheet: TODSSpreadSheet;
  Cell: TODSCell;
begin
  FODSFile.Free;
  FODSFile := TODSFile.Create;
  ClearAll;

  if not FileExists(FileName) then Exit;

  FODSFile.FileName := FileName;
  Start := Now;
  F := ShowLoading(Self, FileName);
  FODSFile.Workbook.IsNotExpanding := TQImport3ODS(Import).NotExpandMergedValue;
  try
    Application.ProcessMessages;
    FODSFile.Load;
    for SheetIndex := 0 to FODSFile.Workbook.Sheets.Count - 1 do
    begin
      Sheet := FODSFile.Workbook.Sheets[SheetIndex];

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

procedure TfmQImport3ODSEditor.SetSheetName(const Value: qiString);
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

procedure TfmQImport3ODSEditor.ApplyChanges;
begin
  inherited;
  TQImport3ODS(Import).SheetName := SheetName;
end;

procedure TfmQImport3ODSEditor.ClearAll;
begin
  SheetName := '';
  inherited;
end;

procedure TfmQImport3ODSEditor.ClearData;
begin
  if assigned(FODSFile) then
    FODSFile.Free;
  SheetName := '';
  if assigned(FCurrentStringGrid) then
    FCurrentStringGrid := nil;
  inherited;
end;

function TfmQImport3ODSEditor.ColValue: integer;
begin
  Result := 0;
  if Assigned(lvFields.Selected) then
    if lvFields.Selected.SubItems[0] <> EmptyStr then
      Result := GetColIdFromColIndex(lvFields.Selected.SubItems[0]);
end;

procedure TfmQImport3ODSEditor.DoPCChange;
begin
  SheetName := pcGrid.ActivePage.Caption;
end;

function TfmQImport3ODSEditor.GetAutoFillValue(Index: integer): string;
begin
  Result := Col2Letter(Index + 1);
end;

function TfmQImport3ODSEditor.GetCondition: Boolean;
begin
  Result := (inherited GetCondition) and (pcGrid.PageCount > 0);
end;

function TfmQImport3ODSEditor.GetMapValue(Index: integer): string;
begin
  Result := Col2Letter(Index);
end;

procedure TfmQImport3ODSEditor.InitObjs;
var
  TabSheet: TTabSheet;
  StringGrid: TqiStringGrid;
  k: Integer;
begin
  FODSFile := TODSFile.Create;
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

function TfmQImport3ODSEditor.MarkFirstRow: Boolean;
begin
  Result := False;
end;

{$ENDIF}

end.
