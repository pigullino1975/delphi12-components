unit fuQImport3PCEditor;

{$I QImport3VerCtrl.Inc}

interface

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
  QImport3Common,
  QImport3StrTypes,
  fuQImport3Editor;

type
  TfmQImport3PCEditor = class(TfmQImport3Editor)
    pcGrid: TPageControl;
    tbtAutoFill: TToolButton;
    procedure pcGridChange(Sender: TObject);
    procedure tbtAutoFillClick(Sender: TObject);
  private
    { Private declarations }
  protected
    FCurrentStringGrid: TqiStringGrid;
    procedure ClearAll; virtual;
    procedure DoAutoFill; virtual;
    function GetAutoFillValue(Index: integer): string; virtual;
    procedure DoFieldsChange(Item: TListItem; Change: TItemChange); override;
    procedure DoPCChange; virtual; abstract;
    procedure FieldsListCallback(var Item: TListItem; ImportType: TAllowedImport);
        override;
    procedure FillGrid; virtual; abstract;
    function GetMapValue(Index: integer): string; virtual;
    procedure GridDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
        State: TGridDrawState); virtual;
    procedure GridMouseDown(Sender: TObject; Button: TMouseButton; Shift:
        TShiftState; X, Y: Integer); virtual;
    function MarkFirstRow: Boolean; virtual; abstract;
    procedure RepaintCurrentGrid;
    procedure SetCurrentGrid;
    procedure SetFileName(const Value: string); override;
    procedure TuneButtons; override;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TfmQImport3PCEditor.ClearAll;
begin
  if Assigned(FCurrentStringGrid) then
    FCurrentStringGrid := nil;
  while pcGrid.PageCount > 0 do
    pcGrid.Pages[0].Free;
end;

procedure TfmQImport3PCEditor.DoAutoFill;
var
  i, j: Integer;
begin
  if Assigned(FCurrentStringGrid) then
  begin
    if not MarkFirstRow then
      j := 2
    else
      j := 1;
    for i := 0 to lvFields.Items.Count - 1 do
      if (i <= FCurrentStringGrid.ColCount - j) then
        lvFields.Items[i].SubItems[0] := GetAutoFillValue(i)
      else
        lvFields.Items[i].SubItems[0] := EmptyStr;
    lvFieldsChange(lvFields, lvFields.Selected, ctState);
  end;
  TuneButtons;
end;

function TfmQImport3PCEditor.GetAutoFillValue(Index: integer): string;
begin
  Result := IntToStr(Index + 1);
end;

procedure TfmQImport3PCEditor.DoFieldsChange(Item: TListItem; Change:
    TItemChange);
begin
  if not Assigned(Item) then Exit;
  RepaintCurrentGrid;
  inherited;
end;

procedure TfmQImport3PCEditor.FieldsListCallback(var Item: TListItem;
    ImportType: TAllowedImport);
begin
  if not Assigned(Item) then
    Exit;
  inherited;
  Item.SubItems.Add(EmptyStr);
end;

function TfmQImport3PCEditor.GetMapValue(Index: integer): string;
begin
  Result := GetAutoFillValue(Index);
end;

procedure TfmQImport3PCEditor.pcGridChange(Sender: TObject);
begin
  DoPCChange;
end;

procedure TfmQImport3PCEditor.SetFileName(const Value: string);
begin
  if AnsiCompareText(FileName, Trim(Value)) <> 0 then
  begin
    inherited;
    FillMap;
    FNeedLoadFile := True;
    FillGrid;
  end;
  TuneButtons;
end;

procedure TfmQImport3PCEditor.GridMouseDown(Sender: TObject; Button:
    TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  ACol, ARow: Integer;
  grid: TqiStringGrid;
begin
  if not ((Sender is TqiStringGrid) and Assigned(lvFields.Selected)) then
    Exit;
  grid := Sender as TqiStringGrid;
  grid.MouseToCell(X, Y, ACol, ARow);
  if (MarkFirstRow and (ColValue = ACol + 1)) or (ColValue = ACol) then
    lvFields.Selected.SubItems[0] := EmptyStr
  else
    if not MarkFirstRow or (ACol > -1) then
      lvFields.Selected.SubItems[0] := GetMapValue(ACol);
  lvFieldsChange(lvFields, lvFields.Selected, ctState);
end;

procedure TfmQImport3PCEditor.GridDrawCell(Sender: TObject; ACol, ARow:
    Integer; Rect: TRect; State: TGridDrawState);
var
  X, Y: integer;
  grid: TqiStringGrid;
begin
  if not (Sender is TqiStringGrid) then Exit;
  grid := Sender as TqiStringGrid;

  X := Rect.Left + (Rect.Right - Rect.Left -
   grid.Canvas.TextWidth(grid.Cells[ACol, ARow])) div 2;
  Y := Rect.Top + (Rect.Bottom - Rect.Top -
    grid.Canvas.TextHeight(grid.Cells[ACol, ARow])) div 2;
  grid.DefaultDrawing := False;
  try
    if gdFixed in State then
    begin
      if not MarkFirstRow then
        if (ACol = ColValue) and (ARow = 0) then
          grid.Canvas.Font.Style := grid.Canvas.Font.Style + [fsBold]
        else
          grid.Canvas.Font.Style := grid.Canvas.Font.Style - [fsBold];
      grid.Canvas.FillRect(Rect);
      grid.Canvas.TextOut(X - 1, Y + 1, grid.Cells[ACol, ARow]);
    end
    else begin
      grid.Canvas.Brush.Color := clWindow;
      grid.Canvas.FillRect(Rect);
      grid.Canvas.Font.Color := clWindowText;
      grid.Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 2,
        grid.Cells[ACol, ARow]);

      if (not MarkFirstRow and (ACol = ColValue) and (ARow > 0)) or
        (MarkFirstRow and (ACol = ColValue - 1)) then
      begin
        grid.Canvas.Font.Color := clHighLightText;
        grid.Canvas.Brush.Color := clHighLight;
        Rect.Bottom := Rect.Bottom + 1;
        grid.Canvas.FillRect(Rect);
        grid.Canvas.TextOut(Rect.Left + 2, Y, grid.Cells[ACol, ARow]);
        Rect.Bottom := Rect.Bottom - 1;
      end;
    end;
    if gdFocused in State then
      DrawFocusRect(grid.Canvas.Handle, Rect);
  finally
    grid.DefaultDrawing := true;
  end;
end;

procedure TfmQImport3PCEditor.RepaintCurrentGrid;
begin
  if Assigned(FCurrentStringGrid) then
    FCurrentStringGrid.Repaint;
end;

procedure TfmQImport3PCEditor.SetCurrentGrid;
begin
  if pcGrid.ActivePage.Components[0] is TqiStringGrid then
    FCurrentStringGrid := TqiStringGrid(pcGrid.ActivePage.Components[0]);
end;

procedure TfmQImport3PCEditor.tbtAutoFillClick(Sender: TObject);
begin
  DoAutoFill;
end;

procedure TfmQImport3PCEditor.TuneButtons;
var
  Condition: boolean;
begin
  inherited;
  Condition := tbtClear.Enabled;
  tbtAutoFill.Enabled := Condition;
  pcGrid.Enabled := Condition;
end;

end.
