unit fuQImport3XlsxEditor;

{$I QImport3VerCtrl.Inc}

interface

{$IFDEF XLSX}

uses
  {$IFDEF VCL16}
    Winapi.Windows,
    Winapi.Messages,
    System.SysUtils,
    System.Variants,
    System.Classes,
    Vcl.Graphics,
    Vcl.Controls,
    Vcl.Forms,
    Vcl.Dialogs,
    Vcl.Buttons,
    Vcl.ExtCtrls,
    Vcl.StdCtrls,
    Vcl.ComCtrls,
    Vcl.ToolWin,
    Vcl.ImgList,
    Vcl.Grids,
    System.Math,
  {$ELSE}
    Windows,
    Messages,
    SysUtils,
    {$IFDEF VCL6}
      Variants,
    {$ENDIF}
    Classes,
    Graphics,
    Controls,
    Forms,
    Dialogs,
    Buttons,
    ExtCtrls,
    StdCtrls,
    ComCtrls,
    ToolWin,
    ImgList,
    Grids,
    Math,
  {$ENDIF}
  {$IFDEF QI_UNICODE}
    QImport3WideStringGrid,
  {$ENDIF}
  QImport3StrTypes,
  QImport3Xlsx,
  fuQImport3PCEditor,
  QImport3Common,
  fuQImport3Loading,
  QImport3XLSUtils;

type
  TfmQImport3XlsxEditor = class(TfmQImport3PCEditor)
  private
    FSheetName: string;
    procedure SetSheetName(const Value: string);

  protected
    procedure ApplyChanges; override;
    procedure ClearAll; override;
    function ColValue: integer; override;
    procedure DoPCChange; override;
    procedure FillGrid; override;
    function GetAutoFillValue(Index: integer): string; override;
    function GetCondition: Boolean; override;
    function GetMapValue(Index: integer): string; override;
    function MarkFirstRow: Boolean; override;
  public
    property SheetName: string read FSheetName write SetSheetName;
  end;

function RunQImportXlsxEditor(AImport: TQImport3Xlsx): boolean;

{$ENDIF}

implementation

{$IFDEF XLSX}

{$R *.dfm}

function RunQImportXlsxEditor(AImport: TQImport3Xlsx): boolean;
begin
  with TfmQImport3XlsxEditor.Create(nil) do
  try
    Import := AImport;
    FileName := AImport.FileName;
    SkipLines := AImport.SkipFirstRows;
    SheetName := string(AImport.SheetName);
    Result := ShowModal = mrOk;
    if Result then ApplyChanges;
  finally
    Free;
  end;
end;

procedure TfmQImport3XlsxEditor.SetSheetName(const Value: string);
var
  i: Integer;
begin
  for i := 0 to pcGrid.PageCount - 1 do
    if pcGrid.Pages[i].Caption = Value then
    begin
      pcGrid.ActivePage := pcGrid.Pages[i];
      Break;
    end;
  if Assigned(pcGrid.ActivePage) then
  begin
    FSheetName := pcGrid.ActivePage.Caption;
    SetCurrentGrid;
  end;
end;

procedure TfmQImport3XlsxEditor.ClearAll;
begin
  SheetName := '';
  inherited;
end;

procedure TfmQImport3XlsxEditor.FillGrid;
var
  TabSheet: TTabSheet;
  StringGrid: TqiStringGrid;
  Start, Finish: TDateTime;
  XlsxFile: TXlsxFile;
  F: TForm;
  SheetIndex, ColIndex, RowIndex: Integer;
  Sheet: TXlsxWorkSheet;
  Cell: TXlsxCell;
begin
  ClearAll;
  if not FileExists(FileName) then Exit;
  XlsxFile := TXlsxFile.Create;
  try
    XlsxFile.FileName := FileName;
    XlsxFile.Workbook.NeedFillMerge := TQImport3Xlsx(Import).NeedFillMerge;
    XlsxFile.Workbook.LoadHiddenSheets := TQImport3Xlsx(Import).LoadHiddenSheet;
    Start := Now;
    F := ShowLoading(Self, FileName);
    try
      Application.ProcessMessages;
      XlsxFile.Load;
      for SheetIndex := 0 to XlsxFile.Workbook.WorkSheets.Count - 1 do
      begin
        Sheet := XlsxFile.Workbook.WorkSheets[SheetIndex];

        TabSheet := TTabSheet.Create(pcGrid);
        TabSheet.PageControl := pcGrid;
        TabSheet.Caption := string(Sheet.Name);

        StringGrid := TqiStringGrid.Create(TabSheet);
        StringGrid.Parent := TabSheet;
        StringGrid.Align := alClient;
        StringGrid.ColCount := DefMapColRowCount;
        StringGrid.RowCount := DefMapColRowCount;
        StringGrid.FixedCols := 1;
        StringGrid.FixedRows := 1;
        StringGrid.DefaultColWidth := 64;
        StringGrid.DefaultRowHeight := 16;
        StringGrid.ColWidths[0] := 30;
        StringGrid.Tag := SheetIndex;
        StringGrid.Options := StringGrid.Options - [goRangeSelect];
        GridFillFixedCells(StringGrid);
        StringGrid.DefaultDrawing := False;
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
    end;
  finally
    XlsxFile.Free;
  end;
end;

procedure TfmQImport3XlsxEditor.ApplyChanges;
begin
  inherited;
  TQImport3Xlsx(Import).SheetName := SheetName;
end;

function TfmQImport3XlsxEditor.ColValue: integer;
begin
  Result := 0;
  if Assigned(lvFields.Selected) then
    if lvFields.Selected.SubItems[0] <> EmptyStr then
      Result := GetColIdFromColIndex(lvFields.Selected.SubItems[0]);
end;

procedure TfmQImport3XlsxEditor.DoPCChange;
begin
  SheetName := pcGrid.ActivePage.Caption;
end;

function TfmQImport3XlsxEditor.GetAutoFillValue(Index: integer): string;
begin
  Result := Col2Letter(Index + 1);
end;

function TfmQImport3XlsxEditor.GetCondition: Boolean;
begin
  Result := (inherited GetCondition) and (pcGrid.PageCount > 0);
end;

function TfmQImport3XlsxEditor.GetMapValue(Index: integer): string;
begin
  Result := Col2Letter(Index);
end;

function TfmQImport3XlsxEditor.MarkFirstRow: Boolean;
begin
  Result := False;
end;

{$ENDIF}

end.
