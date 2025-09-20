unit fuQImport3XLSEditor;

{$I QImport3VerCtrl.Inc}

{$DEFINE XLSEDITOR_MAX_ROW}

interface

uses
  {$IFDEF VCL16}
    Vcl.Grids,
    Vcl.Forms,
    Data.Db,
    Vcl.Dialogs,
    Vcl.StdCtrls,
    Vcl.Controls,
    Vcl.ExtCtrls,
    System.Classes,
    Winapi.Windows,
    Vcl.ComCtrls,
    Vcl.ToolWin,
    Vcl.Buttons,
    Vcl.ImgList,
    System.SysUtils,
    Winapi.Messages,
    System.Variants,
  {$ELSE}
    Grids,
    Forms,
    Db,
    Dialogs,
    StdCtrls,
    Controls,
    ExtCtrls,
    Classes,
    Windows,
    ComCtrls,
    ToolWin,
    Buttons,
    ImgList,
    SysUtils,
    Messages,
    {$IFDEF VCL6}
      Variants,
    {$ENDIF}
  {$ENDIF}
  {$IFDEF QI_UNICODE}
    QImport3WideStringGrid,
  {$ENDIF}
  QImport3Common,
  QImport3XLS,
  QImport3StrTypes,
  QImport3XLSFile,
  QImport3XLSMapParser,
  fuQImport3PCEditor,
  fuQImport3Loading,
  QImport3XLSCalculate,
  QImport3XLSUtils,
  fuQImport3XLSRangeEdit,
  QImport3XLSCommon;

type
  TfmQImport3XLSEditor = class(TfmQImport3PCEditor)
    lvSelection: TListView;
    lvRanges: TListView;
    RangesBar: TToolBar;
    tbtAddRange: TToolButton;
    tbtEditRange: TToolButton;
    tbtDelRange: TToolButton;
    tbtSeparator_01: TToolButton;
    tbtMoveRangeUp: TToolButton;
    tbtMoveRangeDown: TToolButton;
    tbtAutoFillRows: TToolButton;
    tbtClearAllRanges: TToolButton;
    laSkipCols_01: TLabel;
    edSkipCols: TEdit;
    laSkipCols_02: TLabel;
    procedure tbtAutoFillRowsClick(Sender: TObject);
{    procedure lvXLSFieldsSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);}
    procedure tbtAddRangeClick(Sender: TObject);
    procedure tbtEditRangeClick(Sender: TObject);
    procedure lvRangesChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure tbtMoveRangeUpClick(Sender: TObject);
    procedure tbtMoveRangeDownClick(Sender: TObject);
    procedure tbtDelRangeClick(Sender: TObject);
    procedure lvRangesDblClick(Sender: TObject);
    procedure tbtClearAllRangesClick(Sender: TObject);
    procedure edSkipColsChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FXLSFile: TXLSFile;
    FXLSIsEditingGrid: boolean;
    FXLSGridSelection: TMapRow;
    FXLSDefinedRanges: TMapRow;

    FSkipCols: integer;
    procedure XLSSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure XLSGridExit(Sender: TObject);
    procedure XLSGridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);

    procedure XLSStartEditing;
    procedure XLSFinishEditing;
    procedure XLSApplyEditing;
    procedure XLSDeleteSelectedRanges;
    procedure XLSFillSelection;
    procedure SetSkipCols(const Value: integer);

  protected
    procedure ApplyChanges; override;
    procedure ApplyMapValue(Index: integer); override;
    procedure ClearData; override;
    procedure ClearFieldList; override;
    procedure DoAutoFill; override;
    procedure DoClear; override;
    procedure DoFieldsChange(Item: TListItem; Change: TItemChange); override;
    procedure DoFieldsListEnter; override;
    procedure DoFieldsListExit; override;
    procedure DoPCChange; override;
    procedure FieldsListCallback(var Item: TListItem; ImportType: TAllowedImport);
        override;
    procedure FillGrid; override;
    procedure GridDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
        State: TGridDrawState); override;
    procedure GridMouseDown(Sender: TObject; Button: TMouseButton; Shift:
        TShiftState; X, Y: Integer); override;
    procedure InitObjs; override;
    function MarkFirstRow: Boolean; override;
    procedure SetSkipLines(const Value: Integer); override;
    procedure TuneButtons; override;
  public
    property SkipCols: integer read FSkipCols write SetSkipCols;
  end;

function RunQImportXLSEditor(AImport: TQImport3XLS): boolean;

implementation

{$R *.DFM}

function RunQImportXLSEditor(AImport: TQImport3XLS): boolean;
var
  Editor: TfmQImport3XLSEditor;
begin
  Editor := TfmQImport3XLSEditor.Create(nil);
  try
    Editor.Import := AImport;
    Editor.FileName := AImport.FileName;
    Editor.SkipLines := AImport.SkipFirstRows;
    Editor.SkipCols := AImport.SkipFirstCols;
    Result := (Editor.ShowModal = mrOk);
    if Result then Editor.ApplyChanges;
  finally
    Editor.Free;
  end;
end;

{ TfmQImport3XLSEditor }

procedure TfmQImport3XLSEditor.FieldsListCallback(var Item: TListItem;
    ImportType: TAllowedImport);
var
  j: integer;
begin
  if not Assigned(Item) then
    Exit;
  Item.ImageIndex := 0;
  Item.Data := TMapRow.Create(nil);
  j := Import.Map.IndexOfName(Item.Caption);
  if j > -1 then
    TMapRow(Item.Data).AsString := Import.Map.Values[Import.Map.Names[j]];
end;

procedure TfmQImport3XLSEditor.ClearFieldList;
var
  i, j: integer;
  Item: TListItem;
begin
  for i := lvFields.Items.Count - 1 downto 0 do
  begin
    Item := lvFields.Items[i];
    if Assigned(Item.Data) then
    begin
      for j := 0 to TMapRow(Item.Data).Count - 1 do
        TMapRow(Item.Data).Delete(j);
      TMapRow(Item.Data).Free;
    end;
    lvFields.Items.Delete(i);
  end;
end;

procedure TfmQImport3XLSEditor.FillGrid;
var
  TabSheet: TTabSheet;
  StringGrid: TqiStringGrid;
  k, i, j, n: integer;
  Cell: TbiffCell;
//  V: Variant;
  F: TForm;
  Start, Finish: TDateTime;
  W: integer;
//  ExprLen: word;
//  Expr: PByteArray;
begin
  ClearAll;

  if not FileExists(FileName) then Exit;

  FXLSFile.FileName := FileName;
  Start := Now;
  F := ShowLoading(Self, FileName);
  try
    Application.ProcessMessages;
    FXLSFile.Clear;
{$IFDEF XLSEDITOR_MAX_ROW}
    FXLSFile.LoadRows(XLSEDITOR_MAX_ROW_COUNT);
{$ELSE}
    FXLSFile.Load;
{$ENDIF}

    for k := 0 to FXLSFile.Workbook.WorkSheets.Count - 1 do
    begin
      TabSheet := TTabSheet.Create(pcGrid);
      TabSheet.PageControl := pcGrid;
      TabSheet.Caption := FXLSFile.Workbook.WorkSheets[k].Name;

      StringGrid := TqiStringGrid.Create(TabSheet);
      StringGrid.Parent := TabSheet;
      StringGrid.Align := alClient;
      StringGrid.ColCount := DefMapColRowCount;
{$IFDEF XLSEDITOR_MAX_ROW}
      n := XLSEDITOR_MAX_ROW_COUNT;
{$ELSE}
      n := 256;
{$ENDIF}
      {if (Wizard.ExcelViewerRows > 0) and (Wizard.ExcelViewerRows <= 65536) then
        n := Wizard.ExcelViewerRows;}
      StringGrid.RowCount := n + 1;
      StringGrid.FixedCols := 1;
      StringGrid.FixedRows := 1;
      StringGrid.DefaultColWidth := 64;
      StringGrid.DefaultRowHeight := 16;
      StringGrid.ColWidths[0] := 30;
      StringGrid.Options := StringGrid.Options - [goRangeSelect];
      StringGrid.OnDrawCell := GridDrawCell;
      StringGrid.OnMouseDown := GridMouseDown;
      StringGrid.OnSelectCell := XLSSelectCell;
      StringGrid.OnExit := XLSGridExit;
      StringGrid.OnKeyDown := XLSGridKeyDown;

      GridFillFixedCells(StringGrid);

      for i := 0 to FXLSFile.Workbook.WorkSheets[k].Rows.Count - 1 do
        for j := 0 to FXLSFile.Workbook.WorkSheets[k].Rows[i].Count - 1 do
        begin
          Cell := FXLSFile.Workbook.WorkSheets[k].Rows[i][j];
          if (Cell.Col < StringGrid.ColCount - 1) and
             (Cell.Row < StringGrid.RowCount - 1) then
          begin
            case Cell.CellType of
              bctString  :
                StringGrid.Cells[Cell.Col + 1, Cell.Row + 1] := Cell.AsString;
              bctBoolean :
                if Cell.AsBoolean
                  then StringGrid.Cells[Cell.Col + 1, Cell.Row + 1] := 'true'
                  else StringGrid.Cells[Cell.Col + 1, Cell.Row + 1] := 'false';
              bctNumeric :
                StringGrid.Cells[Cell.Col + 1, Cell.Row + 1] :=
                  FloatToStr(Cell.AsFloat);
              bctDateTime:
                if Cell.IsDateOnly then
                  StringGrid.Cells[Cell.Col + 1, Cell.Row + 1] :=
                    FormatDateTime(Import.Formats.ShortDateFormat, Cell.AsDateTime)
                else if Cell.IsTimeOnly then
                  StringGrid.Cells[Cell.Col + 1, Cell.Row + 1] :=
                    FormatDateTime(Import.Formats.ShortTimeFormat, Cell.AsDateTime)
                else StringGrid.Cells[Cell.Col + 1, Cell.Row + 1] :=
                  FormatDateTime(Import.Formats.ShortDateFormat + ' ' +
                    Import.Formats.ShortTimeFormat, Cell.AsDateTime);
              bctUnknown :
(*  dee test
                if Cell.IsFormula then
                begin
                  ExprLen := GetWord(Cell.Data, 20);
                  if ExprLen > 0 then
                  begin
                    GetMem(Expr, ExprLen);
                    try
                      Move(Cell.Data[22], Expr^, ExprLen);
                      V := CalculateFormula(Cell, Expr, ExprLen);
                    finally
                      FreeMem(Expr);
                    end;
                  end
                  {V := CalculateFormula(Cell, (Cell as TbiffFormula).Expression,
                    (Cell as TbiffFormula).ExprLen);
                  StringGrid.Cells[Cell.Col + 1, Cell.Row + 1] := VarToStr(V);}
                end
                else
*)
                  StringGrid.Cells[Cell.Col + 1, Cell.Row + 1] :=
                    VarToStr(Cell.AsVariant);
            end;
            W := StringGrid.Canvas.TextWidth(StringGrid.Cells[Cell.Col + 1, Cell.Row + 1]);
            if W + 10 > StringGrid.ColWidths[Cell.Col + 1] then
              if W + 10 < 130
                then StringGrid.ColWidths[Cell.Col + 1] := W + 10
                else StringGrid.ColWidths[Cell.Col + 1] := 130;
          end;
        end;
    end;
  finally
    SetCurrentGrid;

    Finish := Now;
    while (Finish - Start) < EncodeTime(0, 0, 0, 500) do
      Finish := Now;

    if Assigned(F) then
      F.Free;
  end;
end;

procedure TfmQImport3XLSEditor.FormShow(Sender: TObject);
begin
  inherited;
  if lvFields.Items.Count > 0 then
    lvFields.ItemFocused := lvFields.Items[0];
end;

procedure TfmQImport3XLSEditor.GridDrawCell(Sender: TObject; ACol, ARow:
    Integer; Rect: TRect; State: TGridDrawState);
var
  i: integer;
begin
  FXLSDefinedRanges.Clear;

  if lvFields.Focused then
  begin
    if Assigned(lvFields.ItemFocused) and
       Assigned(lvFields.ItemFocused.Data) then
      for i := 0 to TMapRow(lvFields.ItemFocused.Data).Count - 1 do
        FXLSDefinedRanges.Add(TMapRow(lvFields.ItemFocused.Data)[i]);
  end
  else begin
    if Assigned(lvFields.ItemFocused) and
       Assigned(lvFields.ItemFocused.Data) and
       Assigned(lvRanges.ItemFocused) then
      FXLSDefinedRanges.Add(TMapRow(lvFields.ItemFocused.Data)[lvRanges.ItemFocused.Index]);
  end;

  if Sender is TqiStringGrid then
    QImport3Common.GridDrawCell(Sender as TqiStringGrid, pcGrid.ActivePage.Caption,
      pcGrid.ActivePage.PageIndex + 1, ACol, ARow, Rect, State,
      FXLSDefinedRanges, SkipCols, SkipLines, FXLSIsEditingGrid,
      FXLSGridSelection);

end;

procedure TfmQImport3XLSEditor.GridMouseDown(Sender: TObject; Button:
    TMouseButton; Shift: TShiftState; X, Y: Integer);

  procedure AddColRowToSelection(IsCol, IsCtrl: boolean; Number: integer);
  var
    str, str1: string;
    N: integer;
  begin
    if IsCol
      then str := Format('[%s]%s-%s;', [pcGrid.ActivePage.Caption, Col2Letter(Number), COLFINISH])
      else str := Format('[%s]%s-%s;', [pcGrid.ActivePage.Caption, Row2Number(Number), ROWFINISH]);

      N := FXLSGridSelection.IndexOfRange(str);
      if N > -1 then FXLSGridSelection.Delete(N);

      if (not IsCtrl) or (N = -1) then
      begin
        str1 := FXLSGridSelection.AsString;
        str1 := str1 + str;
        FXLSGridSelection.AsString := str1;
      end;
  end;

var
  Grid: TqiStringGrid;
  ACol, ARow, SCol, SRow, N, i: integer;
  IsCtrl, IsShift: boolean;

  procedure ChangeCurrentCell(Col, Row: integer);
  var
    Event: TSelectCellEvent;
  begin
    Event := Grid.OnSelectCell;
    Grid.OnSelectCell := nil;
    Grid.Col := Col;
    Grid.Row := Row;
    Grid.OnSelectCell := Event;
  end;

begin
  if not (Sender is TqiStringGrid) then Exit;
  Grid := Sender as TqiStringGrid;

  IsShift := GetKeyState(VK_SHIFT) < 0;
  IsCtrl := GetKeyState(VK_CONTROL) < 0;

  if not (IsShift or IsCtrl) then begin
    Grid.Repaint;
    Exit;
  end;

  Grid.MouseToCell(X, Y, ACol, ARow);

  if not ((ACol = 0) xor (ARow = 0)) then begin
    Grid.Repaint;
    Exit;
  end;

  if not FXLSIsEditingGrid then
    XLSStartEditing;

  if IsCtrl then begin
    if ACol = 0
      then N := ARow
      else N := ACol;

    AddColRowToSelection(ARow = 0, true, N);

    if ACol = 0
      then ChangeCurrentCell(Grid.Col, ARow)
      else ChangeCurrentCell(ACol, Grid.Row);
  end
  else if IsShift then begin
    SCol := Grid.Col;
    SRow := Grid.Row;

    if ACol = 0 then begin
      if SRow <= ARow then
        for i := SRow to ARow do
          AddColRowToSelection(false, false, i)
      else
        for i := SRow downto ARow do
          AddColRowToSelection(false, false, i);
      ChangeCurrentCell(Grid.Col, ARow);
    end
    else begin
      if SCol <= ACol then
        for i := SCol to ACol do
          AddColRowToSelection(true, false, i)
      else
        for i := SCol downto ACol do
          AddColRowToSelection(true, false, i);
      ChangeCurrentCell(ACol, Grid.Row);
    end;
  end;

  XLSFillSelection;
  Grid.Repaint;
end;

procedure TfmQImport3XLSEditor.XLSSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
var
  Grid: TqiStringGrid;
  SCol, SRow, i: integer;
  Str: string;
  IsShift, IsCtrl, Cut: boolean;
begin
  if not (Sender is TqiStringGrid) then Exit;
  Grid := Sender as TqiStringGrid;

  IsShift := GetKeyState(VK_SHIFT) < 0;
  IsCtrl := GetKeyState(VK_CONTROL) < 0;

  if not (IsShift or IsCtrl) then begin
    XLSFinishEditing;
    Exit;
  end;

  SCol := Grid.Col;
  SRow := Grid.Row;

  if IsShift and not ((SCol = ACol) or (SRow = ARow)) then begin
    XLSFinishEditing;
    Exit;
  end;

  if not FXLSIsEditingGrid then
    XLSStartEditing;

  Cut := false;
  if (SCol = ACol) and (SRow = ARow) then begin
  end
  else begin
    if IsShift then begin
      if FXLSGridSelection.Count > 0 then begin

        if SCol <> ACol then begin
          if FXLSGridSelection[FXLSGridSelection.Count - 1].RangeType = rtRow then begin
            if SCol > ACol then begin
              for i := SCol downto ACol + 1 do
                if CellInRange(FXLSGridSelection[FXLSGridSelection.Count - 1],
                     EmptyStr, pcGrid.ActivePage.PageIndex + 1, i, ARow) then begin
                  Cut := true;
                  FXLSGridSelection[FXLSGridSelection.Count - 1].Col2 :=
                    FXLSGridSelection[FXLSGridSelection.Count - 1].Col2 - 1;
                end;
            end
            else begin
              for i := SCol to ACol - 1 do
                if (FXLSGridSelection[FXLSGridSelection.Count - 1].RangeType = rtRow) and
                   CellInRange(FXLSGridSelection[FXLSGridSelection.Count - 1],
                     EmptyStr, pcGrid.ActivePage.PageIndex + 1, i, ARow) then begin
                  Cut := true;
                  FXLSGridSelection[FXLSGridSelection.Count - 1].Col2 :=
                    FXLSGridSelection[FXLSGridSelection.Count - 1].Col2 + 1;
                end;
            end;
          end
        end
        else if SRow <> ARow then begin
          if (FXLSGridSelection[FXLSGridSelection.Count - 1].RangeType = rtCol) then begin
            if SRow > ARow then begin
              for i := SRow downto ARow + 1 do
                if CellInRange(FXLSGridSelection[FXLSGridSelection.Count - 1],
                     EmptyStr, pcGrid.ActivePage.PageIndex + 1, ACol, i) then begin
                  Cut := true;
                  FXLSGridSelection[FXLSGridSelection.Count - 1].Row2 :=
                    FXLSGridSelection[FXLSGridSelection.Count - 1].Row2 - 1;
                end;
            end
            else begin
              for i := SRow to ARow - 1 do
                if CellInRange(FXLSGridSelection[FXLSGridSelection.Count - 1],
                     EmptyStr, pcGrid.ActivePage.PageIndex + 1, ACol, i) then begin
                  Cut := true;
                  FXLSGridSelection[FXLSGridSelection.Count - 1].Row2 :=
                    FXLSGridSelection[FXLSGridSelection.Count - 1].Row2 + 1;
                end;
            end;
          end;
        end;

        if (FXLSGridSelection[FXLSGridSelection.Count - 1].Col2 = SCol) and
           (FXLSGridSelection[FXLSGridSelection.Count - 1].Row2 = SRow) then begin
          if FXLSGridSelection[FXLSGridSelection.Count - 1].Col2 = ACol then begin
            if ARow > SRow
              then SRow := SRow + 1
              else SRow := SRow - 1;
          end
          else if FXLSGridSelection[FXLSGridSelection.Count - 1].Row2 = ARow then begin
            if ACol > SCol
              then SCol := SCol + 1
              else SCol := SCol - 1;
          end;
        end;

      end;
      if not Cut then begin
        str := FXLSGridSelection.AsString;
        if SCol = ACol then begin
          if SRow > ARow then begin
            for i := SRow downto ARow do
              if not CellInRow(FXLSGridSelection, EmptyStr, pcGrid.ActivePage.PageIndex + 1, ACol, i) then
                str := str + Format('[%s]%s%d;', [pcGrid.ActivePage.Caption, Col2Letter(ACol), i]);
          end
          else begin
            for i := SRow to ARow do
              if not CellInRow(FXLSGridSelection, EmptyStr, pcGrid.ActivePage.PageIndex + 1, ACol, i) then
                str := str + Format('[%s]%s%d;', [pcGrid.ActivePage.Caption, Col2Letter(ACol), i]);
          end
        end
        else if SRow = ARow then begin
          if SCol > ACol then begin
            for i := SCol downto ACol do
              if not CellInRow(FXLSGridSelection, EmptyStr, pcGrid.ActivePage.PageIndex + 1, i, ARow) then
                str := str + Format('[%s]%s%d;', [pcGrid.ActivePage.Caption, Col2Letter(i), ARow]);
          end
          else begin
            for i := SCol to ACol do
              if not CellInRow(FXLSGridSelection, EmptyStr, pcGrid.ActivePage.PageIndex + 1, i, ARow) then
                str := str + Format('[%s]%s%d;', [pcGrid.ActivePage.Caption, Col2Letter(i), ARow]);
          end
        end;
        FXLSGridSelection.AsString := str;
      end;
      XLSFillSelection;
    end
    else if IsCtrl then begin
      if not CellInRow(FXLSGridSelection, EmptyStr,
           pcGrid.ActivePage.PageIndex + 1, ACol, ARow) then begin
        str := FXLSGridSelection.AsString;
        str := str + Format('[%s]%s%d;', [pcGrid.ActivePage.Caption, Col2Letter(ACol), ARow]);
        FXLSGridSelection.AsString := str;
      end
      else begin
        RemoveCellFromRow(FXLSGridSelection, EmptyStr,
          pcGrid.ActivePage.PageIndex + 1, ACol, ARow);
      end;
      XLSFillSelection;
    end;
  end;
  Grid.Repaint;
end;

procedure TfmQImport3XLSEditor.XLSGridExit(Sender: TObject);
begin
  XLSFinishEditing;
end;

procedure TfmQImport3XLSEditor.XLSGridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Shift = [] then
    case Key of
      VK_RETURN: XLSApplyEditing;
      VK_ESCAPE: XLSFinishEditing;
    end
end;

procedure TfmQImport3XLSEditor.XLSStartEditing;
begin
  FXLSIsEditingGrid := true;
  lvRanges.Visible := false;
  lvSelection.Visible := true;
  RangesBar.Visible := false;
end;

procedure TfmQImport3XLSEditor.XLSFinishEditing;
begin
  FXLSIsEditingGrid := false;
  FXLSGridSelection.Clear;
  RepaintCurrentGrid;

  lvSelection.Visible:= false;

  lvRanges.Visible := true;
  RangesBar.Visible := true;;
end;

procedure TfmQImport3XLSEditor.XLSApplyEditing;
var
  i: integer;
begin
  if FXLSGridSelection.Count = 0 then Exit;
    if not Assigned(lvFields.Selected) then Exit;

  XLSDeleteSelectedRanges;

  for i := 0 to FXLSGridSelection.Count - 1 do begin
    FXLSGridSelection[i].MapRow := TMapRow(lvFields.Selected.Data);
    TMapRow(lvFields.ItemFocused.Data).Add(FXLSGridSelection[i]);
    with lvRanges.Items.Add do begin
      Caption := FXLSGridSelection[i].AsString;
      Data := FXLSGridSelection[i];
      ImageIndex := 3;
    end;
  end;
  if (lvRanges.Items.Count > 0) and
     not Assigned(lvRanges.ItemFocused) then begin
    lvRanges.Items[0].Focused := true;
    lvRanges.Items[0].Selected := true;
  end;

  XLSFinishEditing;
end;

procedure TfmQImport3XLSEditor.XLSDeleteSelectedRanges;
var
  List: TList;
  i: integer;
begin
  if lvRanges.SelCount = 0 then Exit;

  lvRanges.OnChange := nil;
  try
    List := TList.Create;
    try
      for i := 0 to lvRanges.Items.Count - 1 do
        if lvRanges.Items[i].Selected then
          List.Add(Pointer(i));
      for i := List.Count - 1 downto 0 do begin
        TMapRow(lvFields.ItemFocused.Data).Delete(Integer(List[i]));
        lvRanges.Items[Integer(List[i])].Delete;
        List.Delete(i);
      end;

      if (lvRanges.Items.Count > 0) and Assigned(lvRanges.ItemFocused) and
         not lvRanges.ItemFocused.Selected then
        lvRanges.ItemFocused.Selected := true;

    finally
      List.Free;
    end;
    TuneButtons;
  finally
    lvRanges.OnChange := lvRangesChange;
  end;
end;

procedure TfmQImport3XLSEditor.XLSFillSelection;
var
  i: integer;
begin
//  lvSelection.Items.BeginUpdate;
  try
    lvSelection.Items.Clear;
    FXLSGridSelection.Optimize;
    for i := 0 to FXLSGridSelection.Count - 1 do
      with lvSelection.Items.Add do begin
        Caption := FXLSGridSelection[i].AsString;
        ImageIndex := 3;
      end;
    if lvSelection.Items.Count > 0 then begin
      lvSelection.Items[0].Focused := true;
      lvSelection.Items[0].Selected := true;
    end
  finally
  //  lvSelection.Items.EndUpdate;
  end;
end;

procedure TfmQImport3XLSEditor.TuneButtons;
var
  Condition: boolean;
begin
  inherited;
  Condition := tbtAutoFill.Enabled;
  edSkipCols.Enabled := Condition;
  laSkipCols_01.Enabled := Condition;
  laSkipCols_02.Enabled := Condition;
  tbtAutoFillRows.Enabled := Condition;
  tbtClearAllRanges.Enabled := Condition;
  tbtAddRange.Enabled := Condition;
  tbtEditRange.Enabled := Assigned(lvFields.ItemFocused) and
                             Assigned(lvRanges.ItemFocused) and
                             (FileName <> EmptyStr);
  tbtDelRange.Enabled := Assigned(lvFields.ItemFocused) and
                            (lvRanges.SelCount > 0) and
                            (FileName <> EmptyStr);
  tbtMoveRangeUp.Enabled := Assigned(lvFields.ItemFocused) and
                               Assigned(lvRanges.ItemFocused) and
                               (lvRanges.ItemFocused.Index > 0) and
                               (FileName <> EmptyStr);
  tbtMoveRangeDown.Enabled := Assigned(lvFields.ItemFocused) and
                                 Assigned(lvRanges.ItemFocused) and
                                 (lvRanges.ItemFocused.Index < lvRanges.Items.Count - 1) and
                                 (FileName <> EmptyStr);
end;

procedure TfmQImport3XLSEditor.ClearData;
begin
  inherited;
  FXLSDefinedRanges.Free;
  FXLSGridSelection.Free;
  FXLSFile.Free;
end;

procedure TfmQImport3XLSEditor.ApplyChanges;
begin
  inherited;
  TQImport3XLS(Import).SkipFirstCols := SkipCols;
end;

procedure TfmQImport3XLSEditor.ApplyMapValue(Index: integer);
var
  Item: TListItem;
  str: string;
begin
  Item := lvFields.Items[Index];
  str := TMapRow(Item.Data).AsString;
  if str <> EmptyStr then
    Import.Map.Values[Item.Caption] := str;
end;

procedure TfmQImport3XLSEditor.DoAutoFill;
var
  i, j: integer;
  MapRow: TMapRow;
  MR: TMapRange;
begin
  j := pcGrid.ActivePage.TabIndex;

  for i := 0 to lvFields.Items.Count - 1 do begin
    MapRow := TMapRow(lvFields.Items[i].Data);
    MapRow.Clear;
    if i <= FXLSFile.Workbook.WorkSheets[j].ColCount - 1 then begin
      MR := TMapRange.Create(MapRow);
      MR.Col1 := FXLSFile.Workbook.WorkSheets[j].Cols[i].ColNumber + 1;
      MR.Col2 := MR.Col1;
      MR.Row1 := 0;
      MR.Row2 := 0;
      MR.SheetIDType := sitName;
      MR.SheetName := FXLSFile.Workbook.WorkSheets[j].Name;
      MR.SheetNumber := 0;
      MR.Direction := rdDown;
      MapRow.Add(MR);
    end;
  end;
  if Assigned(lvFields.ItemFocused) then
    lvFieldsChange(lvFields, lvFields.ItemFocused, ctState);
  TuneButtons;
end;

procedure TfmQImport3XLSEditor.DoClear;
var
  k: Integer;
begin
  if not (Assigned(lvFields.ItemFocused) and
          Assigned(lvFields.ItemFocused.Data)) then Exit;

  for k := 0 to TMapRow(lvFields.ItemFocused.Data).Count - 1 do
    TMapRow(lvFields.ItemFocused.Data).Delete(k);

  TMapRow(lvFields.ItemFocused.Data).Clear;
  lvFieldsChange(lvFields, lvFields.ItemFocused, ctState);
end;

procedure TfmQImport3XLSEditor.DoFieldsChange(Item: TListItem; Change:
    TItemChange);
var
  i: integer;
  Row: TMapRow;
begin
  if (csDestroying in ComponentState) then Exit;
  if not Assigned(Item) or not Assigned(Item.Data) then Exit;
  lvRanges.Items.BeginUpdate;
  try
    lvRanges.Items.Clear;
    Row := TMapRow(Item.Data);
    for i := 0 to Row.Count - 1 do
      with lvRanges.Items.Add do begin
        Caption := Row[i].AsString;
        ImageIndex := 3;
        Data := Row[i];
      end;
    if lvRanges.Items.Count > 0 then begin
      lvRanges.Items[0].Focused := true;
      lvRanges.Items[0].Selected := true;
    end
    else
      lvRangesChange(lvRanges, nil, ctState);

    RepaintCurrentGrid;
  finally
    lvRanges.Items.EndUpdate;
  end;
  inherited;
end;

procedure TfmQImport3XLSEditor.DoFieldsListEnter;
begin
  RepaintCurrentGrid;
end;

procedure TfmQImport3XLSEditor.DoFieldsListExit;
begin
  RepaintCurrentGrid;
end;

procedure TfmQImport3XLSEditor.DoPCChange;
begin
  SetCurrentGrid;
end;

procedure TfmQImport3XLSEditor.SetSkipCols(const Value: integer);
begin
  if FSkipCols <> Value then begin
    FSkipCols := Value;
    edSkipCols.Text := IntToStr(FSkipCols);
    RepaintCurrentGrid;
  end;
end;

procedure TfmQImport3XLSEditor.InitObjs;
begin
  inherited;
  FXLSFile := TXLSFile.Create;
  FXLSIsEditingGrid := false;
  FXLSGridSelection := TMapRow.Create(nil);
  FXLSDefinedRanges := TMapRow.Create(nil);
end;

procedure TfmQImport3XLSEditor.tbtAutoFillRowsClick(Sender: TObject);
var
  i, j: integer;
  MapRow: TMapRow;
  MR: TMapRange;
begin
  j := pcGrid.ActivePage.TabIndex;

  for i := 0 to lvFields.Items.Count - 1 do begin
    MapRow := TMapRow(lvFields.Items[i].Data);
    MapRow.Clear;
    if i <= FXLSFile.Workbook.WorkSheets[j].RowCount - 1 then begin
      MR := TMapRange.Create(MapRow);
      MR.Row1 := FXLSFile.Workbook.WorkSheets[j].Rows[i].RowNumber + 1;
      MR.Row2 := MR.Row1;
      MR.Col1 := 0;
      MR.Col2 := 0;
      MR.SheetIDType := sitName;
      MR.SheetName := FXLSFile.Workbook.WorkSheets[j].Name;
      MR.SheetNumber := 0;
      MR.Direction := rdDown;
      MapRow.Add(MR);
    end;
  end;

  if Assigned(lvFields.ItemFocused) then
    lvFieldsChange(lvFields, lvFields.ItemFocused, ctState);
  TuneButtons;
end;

{procedure TfmQImportXLSEditor.lvXLSFieldsSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
var
  i: integer;
  Row: TMapRow;
begin
  if not Assigned(Item) or not Assigned(Item.Data) then Exit;
//  lvRanges.Items.BeginUpdate;
  try
    lvRanges.Items.Clear;
    Row := TMapRow(Item.Data);
    for i := 0 to Row.Count - 1 do
      with lvRanges.Items.Add do begin
        Caption := Row[i].AsString;
        ImageIndex := 3;
        Data := Row[i];
      end;
    if lvRanges.Items.Count > 0 then begin
      lvRanges.Items[0].Focused := true;
      lvRanges.Items[0].Selected := true;
    end
    else lvXLSRangesSelectItem(lvRanges, nil, false);

    RepaintCurrentGrid;
  finally
  //  lvRanges.Items.EndUpdate;
  end;
  TuneButtons;
end;}

procedure TfmQImport3XLSEditor.tbtAddRangeClick(Sender: TObject);
var
  Range: TMapRange;
  MapRow: TMapRow;
  i: integer;
  Item: TListItem;
begin
  MapRow := TMapRow(lvFields.ItemFocused.Data);
  Range := TMapRange.Create(MapRow);
  Range.Col1 := 1;
  Range.Row1 := 0;
  Range.Col2 := 1;
  Range.Row2 := 0;
  Range.Direction := rdDown;
  Range.SheetIDType := sitName;
  Range.SheetName := pcGrid.ActivePage.Caption;
  Range.SheetNumber := pcGrid.ActivePage.PageIndex + 1;
  Range.Update;

  if EditRange(Range, FXLSFile) then begin
    MapRow.Add(Range);
    lvRanges.Items.BeginUpdate;
    try
      Item := lvRanges.Items.Add;
      with Item do begin
        Caption := Range.AsString;
        ImageIndex := 3;
        Data := Range;
      end;
      for i := 0 to lvRanges.Items.Count - 1 do begin
        lvRanges.Items[i].Focused := lvRanges.Items[i] = Item;
        lvRanges.Items[i].Selected := lvRanges.Items[i] = Item;
      end;
    finally
      lvRanges.Items.EndUpdate;
    end;
  end
  else Range.Free;
  TuneButtons;
end;

procedure TfmQImport3XLSEditor.tbtEditRangeClick(Sender: TObject);
begin
  if not Assigned(lvFields.ItemFocused) and
     not Assigned(lvRanges.ItemFocused) then Exit;

  if EditRange(TMapRange(lvRanges.ItemFocused.Data), FXLSFile) then
    lvRanges.ItemFocused.Caption := TMapRange(lvRanges.ItemFocused.Data).AsString;
  RepaintCurrentGrid;
  TuneButtons;
end;

procedure TfmQImport3XLSEditor.lvRangesChange(Sender: TObject;
  Item: TListItem; Change: TItemChange);
begin
  if (csDestroying in ComponentState) then Exit;
  RepaintCurrentGrid;
  TuneButtons;
end;

procedure TfmQImport3XLSEditor.tbtMoveRangeUpClick(Sender: TObject);
var
  Index, i: integer;
begin
  Index := lvRanges.ItemFocused.Index;
  TMapRow(lvFields.ItemFocused.Data).Exchange(Index, Index - 1);
  lvRanges.Items.BeginUpdate;
  try
    lvRanges.Items[Index].Data := TMapRow(lvFields.ItemFocused.Data)[Index];
    lvRanges.Items[Index].Caption := TMapRange(lvRanges.Items[Index].Data).AsString;
    lvRanges.Items[Index - 1].Data := TMapRow(lvFields.ItemFocused.Data)[Index - 1];
    lvRanges.Items[Index - 1].Caption := TMapRange(lvRanges.Items[Index - 1].Data).AsString;
    for i := 0 to lvRanges.Items.Count - 1 do begin
      lvRanges.Items[i].Focused := lvRanges.Items[i] = lvRanges.Items[Index - 1];
      lvRanges.Items[i].Selected := lvRanges.Items[i] = lvRanges.Items[Index - 1];
    end;
  finally
    lvRanges.Items.EndUpdate;
  end;
  TuneButtons;
end;

procedure TfmQImport3XLSEditor.tbtMoveRangeDownClick(Sender: TObject);
var
  Index, i: integer;
begin
  lvRanges.Visible := false;
  lvRanges.Visible := true;
  //Exit;
  
  Index := lvRanges.ItemFocused.Index;
  TMapRow(lvFields.ItemFocused.Data).Exchange(Index, Index + 1);
  lvRanges.Items.BeginUpdate;
  try
    lvRanges.Items[Index].Data := TMapRow(lvFields.ItemFocused.Data)[Index];
    lvRanges.Items[Index].Caption := TMapRange(lvRanges.Items[Index].Data).AsString;
    lvRanges.Items[Index + 1].Data := TMapRow(lvFields.ItemFocused.Data)[Index + 1];
    lvRanges.Items[Index + 1].Caption := TMapRange(lvRanges.Items[Index + 1].Data).AsString;
    for i := 0 to lvRanges.Items.Count - 1 do begin
      lvRanges.Items[i].Focused := lvRanges.Items[i] = lvRanges.Items[Index + 1];
      lvRanges.Items[i].Selected := lvRanges.Items[i] = lvRanges.Items[Index + 1];
    end;
  finally
    lvRanges.Items.EndUpdate;
  end;
  TuneButtons;
end;

procedure TfmQImport3XLSEditor.tbtDelRangeClick(Sender: TObject);
begin
  XLSDeleteSelectedRanges;
  RepaintCurrentGrid;
end;

procedure TfmQImport3XLSEditor.lvRangesDblClick(Sender: TObject);
begin
  if tbtEditRange.Enabled then
    tbtEditRange.Click;
end;

procedure TfmQImport3XLSEditor.tbtClearAllRangesClick(Sender: TObject);
var
  i, k: integer;
begin
  for i := 0 to lvFields.Items.Count - 1 do
  begin

    for k := 0 to TMapRow(lvFields.Items[i].Data).Count - 1 do
      TMapRow(lvFields.Items[i].Data).Delete(k);

    TMapRow(lvFields.Items[i].Data).Clear;
  end;
  lvFieldsChange(lvFields, lvFields.ItemFocused, ctState);
  TuneButtons;
end;

procedure TfmQImport3XLSEditor.edSkipColsChange(Sender: TObject);
begin
  SkipCols := StrToIntDef(edSkipCols.Text, 0);
end;

function TfmQImport3XLSEditor.MarkFirstRow: Boolean;
begin
  Result := False;
end;

procedure TfmQImport3XLSEditor.SetSkipLines(const Value: Integer);
begin
  if SkipLines <> Value then
  begin
    inherited;
    RepaintCurrentGrid;
  end;
end;

end.
