unit fuQImport3DocxEditor;

{$I QImport3VerCtrl.Inc}

interface

{$IFDEF DOCX}

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
    Vcl.ImgList,
    Vcl.ComCtrls,
    Vcl.ToolWin,
    Vcl.StdCtrls,
    Vcl.Buttons,
    Vcl.ExtCtrls,
    Vcl.Grids,
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
    ImgList,
    ComCtrls,
    ToolWin,
    StdCtrls,
    Buttons,
    ExtCtrls,
    Grids,
  {$ENDIF}
  {$IFDEF QI_UNICODE}
    QImport3WideStringGrid,
  {$ENDIF}
  QImport3StrTypes,
  QImport3Docx,
  fuQImport3PCEditor,
  QImport3Common,
  fuQImport3Loading;

type
  TfmQImport3DocxEditor = class(TfmQImport3PCEditor)
  private
    FTableNumber: Integer;

    procedure SetTableNumber(const Value: Integer);

  protected
    procedure ApplyChanges; override;
    procedure ClearAll; override;
    procedure DoPCChange; override;
    procedure FillGrid; override;
    function MarkFirstRow: Boolean; override;
  public
    property TableNumber: Integer read FTableNumber write SetTableNumber;
  end;

function RunQImportDocxEditor(AImport: TQImport3Docx): boolean;

{$ENDIF}

implementation

{$IFDEF DOCX}

function RunQImportDocxEditor(AImport: TQImport3Docx): boolean;
begin
  with TfmQImport3DocxEditor.Create(nil) do
  try
    Import := AImport;
    FileName := AImport.FileName;
    SkipLines := AImport.SkipFirstRows;
    TableNumber := AImport.TableNumber;
    Result := ShowModal = mrOk;
    if Result then ApplyChanges;
  finally
    Free;
  end;
end;

{$R *.dfm}

procedure TfmQImport3DocxEditor.SetTableNumber(const Value: Integer);
var
  i: Integer;
begin
  for i := 0 to pcGrid.PageCount - 1 do
    if Value = pcGrid.Pages[i].Tag then
    begin
      pcGrid.ActivePage := pcGrid.Pages[i];
      Break;
    end;
  if Assigned(pcGrid.ActivePage) then
  begin
    FTableNumber := pcGrid.ActivePage.Tag;
    SetCurrentGrid;
  end;
end;

procedure TfmQImport3DocxEditor.FillGrid;
var
  TabSheet: TTabSheet;
  StringGrid: TqiStringGrid;
  DocxFile: TDocxFile;
  F: TForm;
  Start, Finish: TDateTime;
  SheetIndex, RowIndex, ColIndex:  Integer;
  Sheet: TDocxSheet;
  Cell: TDocxCol;
begin
  ClearAll;
  if not FileExists(FileName) then Exit;
  DocxFile := TDocxFile.Create;
  try
    DocxFile.FileName := FileName;
    Start := Now;
    F := ShowLoading(Self, FileName);
    try
      Application.ProcessMessages;
      DocxFile.Load;

      for SheetIndex := 0 to DocxFile.Sheets.Count - 1 do
      begin
        Sheet := DocxFile.Sheets[SheetIndex];

        TabSheet := TTabSheet.Create(pcGrid);
        TabSheet.PageControl := pcGrid;
        TabSheet.Caption := 'Table ' + IntToStr(Succ(SheetIndex));
        TabSheet.Tag := Succ(SheetIndex);

        StringGrid := TqiStringGrid.Create(TabSheet);
        StringGrid.Parent := TabSheet;
        StringGrid.Align := alClient;
        StringGrid.DefaultRowHeight := 16;
        StringGrid.ColCount := 1;
        StringGrid.RowCount := 1;
        StringGrid.FixedCols := 0;
        StringGrid.FixedRows := 0;
        StringGrid.Options := StringGrid.Options - [goRangeSelect];
        StringGrid.OnDrawCell := GridDrawCell;
        StringGrid.OnMouseDown := GridMouseDown;

        StringGrid.ColCount := 1;
        StringGrid.RowCount := Min(Sheet.RowCount, DefMapColRowCount);

        if StringGrid.ColCount < Sheet.ColCount then
          StringGrid.ColCount := Sheet.ColCount;

        for RowIndex := 0 to StringGrid.RowCount - 1 do
        begin
          for ColIndex := 0 to Sheet.ColCount - 1 do
          begin
            Cell := Sheet.Cell[ColIndex, RowIndex];
            if not Assigned(Cell) then Continue;
            StringGrid.Objects[ColIndex,RowIndex] := TObject(Cell.DisplayAsIcon);
            StringGrid.Cells[ColIndex, RowIndex] := Cell.Value;
            SetStringGridColWidth(StringGrid, ColIndex, RowIndex);
          end;
        end;

        if SheetIndex = 0 then
          TableNumber := TabSheet.Tag;
      end;

    finally
      Finish := Now;
      while (Finish - Start) < EncodeTime(0, 0, 0, 500) do
        Finish := Now;
      if Assigned(F) then
        F.Free;
    end;
  finally
    DocxFile.Free;
  end;
end;

procedure TfmQImport3DocxEditor.ApplyChanges;
begin
  inherited;
  TQImport3Docx(Import).TableNumber := TableNumber;
end;

procedure TfmQImport3DocxEditor.ClearAll;
begin
  inherited;
  TableNumber := 0;
end;

procedure TfmQImport3DocxEditor.DoPCChange;
begin
  TableNumber := pcGrid.ActivePage.Tag;
end;

function TfmQImport3DocxEditor.MarkFirstRow: Boolean;
begin
  Result := True;
end;

{$ENDIF}

end.
