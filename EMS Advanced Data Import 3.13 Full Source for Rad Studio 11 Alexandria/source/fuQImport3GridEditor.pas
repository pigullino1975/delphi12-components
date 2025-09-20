unit fuQImport3GridEditor;

{$I QImport3VerCtrl.Inc}

interface

uses
  {$IFDEF VCL16}
    System.SysUtils,
    Winapi.Messages,
    System.Variants,
    Vcl.Graphics,
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
    Vcl.Grids,
  {$ELSE}
    SysUtils,
    Messages,
    Graphics,
    {$IFDEF VCL6}
      Variants,
    {$ENDIF}
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
    Grids,
  {$ENDIF}
  {$IFDEF QI_UNICODE}
    QImport3WideStringGrid,
  {$ENDIF}
  QImport3Common,
  QImport3StrTypes,
  fuQImport3Editor;

type
  TfmQImport3GridEditor = class(TfmQImport3Editor)
    paGrid: TPanel;
    tbtAutoFill: TToolButton;
    cbColumn: TComboBox;
    laColumn: TLabel;
    procedure cbColumnChange(Sender: TObject);
    procedure GridDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
        State: TGridDrawState);
    procedure GridMouseDown(Sender: TObject; Button: TMouseButton; Shift:
        TShiftState; X, Y: Integer);
    procedure tbtAutoFillClick(Sender: TObject);
  private
  protected
    FGrid: TqiStringGrid;
    procedure DoAutoFill; virtual;
    procedure DoFieldsChange(Item: TListItem; Change: TItemChange); override;
    procedure FieldsListCallback(var Item: TListItem; ImportType: TAllowedImport);
        override;
    procedure FillComboColumn;
    procedure FillGrid; virtual; abstract;
    procedure InitObjs; override;
    function MarkFirstRow: Boolean; virtual; abstract;
    procedure SetFileName(const Value: string); override;
    procedure TuneButtons; override;
  end;

implementation

{$R *.dfm}

procedure TfmQImport3GridEditor.cbColumnChange(Sender: TObject);
begin
  if not Assigned(lvFields.Selected) then
    Exit;
  lvFields.Selected.SubItems[0] := cbColumn.Text;
  FGrid.Repaint;
end;

procedure TfmQImport3GridEditor.DoAutoFill;
var
  i: Integer;
begin
  for i := 0 to lvFields.Items.Count - 1 do
    if (i <= FGrid.ColCount - 1) then
      lvFields.Items[i].SubItems[0] := IntToStr(i + 1)
    else
      lvFields.Items[i].SubItems[0] := EmptyStr;
  lvFieldsChange(lvFields, lvFields.Selected, ctState);
  TuneButtons;
end;

procedure TfmQImport3GridEditor.DoFieldsChange(Item: TListItem; Change:
    TItemChange);
begin
  if not Assigned(Item) then
    Exit;
  cbColumn.OnChange := nil;
  try
    if Item.SubItems.Count > 0 then
      cbColumn.ItemIndex := cbColumn.Items.IndexOf(Item.SubItems[0]);
    FGrid.Repaint;
    inherited;
  finally
    cbColumn.OnChange := cbColumnChange;
  end;
end;

procedure TfmQImport3GridEditor.FieldsListCallback(var Item: TListItem;
    ImportType: TAllowedImport);
begin
  if not Assigned(Item) then
    Exit;
  inherited;
  Item.SubItems.Add(EmptyStr);
end;

procedure TfmQImport3GridEditor.FillComboColumn;
var
  i: Integer;
begin
  cbColumn.Clear;
  cbColumn.Items.Add('');
  cbColumn.ItemIndex := 0;
  for i := 0 to FGrid.ColCount - 1 do
    cbColumn.Items.Add(IntToStr(Succ(i)));
end;

procedure TfmQImport3GridEditor.InitObjs;
begin
  FGrid := TqiStringGrid.Create(Self);
  FGrid.Parent := paGrid;
  FGrid.Align := alClient;
  FGrid.ColCount := 1;
  FGrid.DefaultRowHeight := 16;
  FGrid.FixedCols := 0;
  FGrid.RowCount := 1;
  FGrid.FixedRows := 0;
  FGrid.Font.Charset := DEFAULT_CHARSET;
  FGrid.Font.Color := clWindowText;
  FGrid.Font.Height := -11;
  FGrid.Font.Name := 'Courier New';
  FGrid.Font.Style := [];
  FGrid.ParentFont := False;
  FGrid.TabOrder := 4;
  FGrid.OnDrawCell := GridDrawCell;
  FGrid.OnMouseDown := GridMouseDown;
  inherited;
end;

procedure TfmQImport3GridEditor.GridDrawCell(Sender: TObject; ACol, ARow:
    Integer; Rect: TRect; State: TGridDrawState);
var
  X, Y: Integer;
begin
  X := Rect.Left + (Rect.Right - Rect.Left -
    FGrid.Canvas.TextWidth(FGrid.Cells[ACol, ARow])) div 2;
  Y := Rect.Top + (Rect.Bottom - Rect.Top -
    FGrid.Canvas.TextHeight(FGrid.Cells[ACol, ARow])) div 2;
  FGrid.DefaultDrawing := False;
  try
    if gdFixed in State then
    begin
      if MarkFirstRow then
        if (ACol = ColValue - 1) and (ARow = 0) then
          FGrid.Canvas.Font.Style := FGrid.Canvas.Font.Style + [fsBold]
        else
          FGrid.Canvas.Font.Style := FGrid.Canvas.Font.Style - [fsBold];
      FGrid.Canvas.FillRect(Rect);
      FGrid.Canvas.TextOut(X - 1, Y + 1, FGrid.Cells[ACol, ARow]);
    end
    else begin
      FGrid.Canvas.Brush.Color := clWindow;
      FGrid.Canvas.FillRect(Rect);
      FGrid.Canvas.Font.Color := clWindowText;
      FGrid.Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 2, FGrid.Cells[ACol, ARow]);

      if (ACol = ColValue - 1) and (not MarkFirstRow or (ARow > 0)) then
      begin
        FGrid.Canvas.Font.Color := clHighLightText;
        FGrid.Canvas.Brush.Color := clHighLight;
        Rect.Bottom := Rect.Bottom + 1;
        FGrid.Canvas.FillRect(Rect);
        FGrid.Canvas.TextOut(Rect.Left + 2, Y, FGrid.Cells[ACol, ARow]);
        Rect.Bottom := Rect.Bottom - 1;
      end;
    end;
    if gdFocused in State then
      DrawFocusRect(FGrid.Canvas.Handle, Rect);
  finally
    FGrid.DefaultDrawing := True;
  end;
end;

procedure TfmQImport3GridEditor.GridMouseDown(Sender: TObject; Button:
    TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  ACol, ARow: Integer;
begin
  FGrid.MouseToCell(X, Y, ACol, ARow);
  if not Assigned(lvFields.Selected) then
    Exit;
  if ColValue = ACol + 1 then
    lvFields.Selected.SubItems[0] := EmptyStr
  else if MarkFirstRow or (ACol > -1) then
    lvFields.Selected.SubItems[0] := IntToStr(ACol + 1);
  lvFieldsChange(lvFields, lvFields.Selected, ctState);
end;

procedure TfmQImport3GridEditor.SetFileName(const Value: string);
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

procedure TfmQImport3GridEditor.tbtAutoFillClick(Sender: TObject);
begin
  DoAutoFill;
end;

procedure TfmQImport3GridEditor.TuneButtons;
var
  Condition: boolean;
begin
  inherited;
  Condition := tbtClear.Enabled;
  tbtAutoFill.Enabled := Condition;
  FGrid.Enabled := Condition;
  laColumn.Enabled := Condition;
  cbColumn.Enabled := Condition;
end;

end.
