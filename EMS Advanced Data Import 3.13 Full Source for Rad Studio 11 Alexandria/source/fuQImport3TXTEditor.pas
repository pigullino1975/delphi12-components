unit fuQImport3TXTEditor;

{$I QImport3VerCtrl.Inc}

interface

uses
  {$IFDEF VCL16}
    Vcl.Forms,
    Vcl.Dialogs,
    Vcl.StdCtrls,
    Vcl.Controls,
    Vcl.ExtCtrls,
    System.Classes,
    Data.Db,
    Vcl.ComCtrls,
    Winapi.Windows,
    Vcl.ToolWin,
    Vcl.ImgList,
    Vcl.Buttons,
    System.SysUtils,
    Vcl.Graphics,
  {$ELSE}
    Forms,
    Dialogs,
    StdCtrls,
    Controls,
    ExtCtrls,
    Classes,
    Db,
    ComCtrls,
    Windows,
    ToolWin,
    ImgList,
    Buttons,
    SysUtils,
    Graphics,
  {$ENDIF}
  QImport3,
  QImport3Common,
  QImport3TXTView,
  QImport3ASCII,
  fuQImport3Editor,
  QImport3StrIDs;

type
  TfmQImport3TXTEditor = class(TfmQImport3Editor)
    paView: TPanel;
  private
    FItemIndex: integer;
    FClearing: boolean;
    vwTXT: TQImport3TXTViewer;
    procedure LoadFile;
    procedure ViewerChangeSelection(Sender: TObject);
  protected
    procedure DoClear; override;
    procedure DoFieldsChange(Item: TListItem; Change: TItemChange); override;
    procedure FieldsListCallback(var Item: TListItem; ImportType: TAllowedImport); override;
    procedure ApplyMapValue(Index: integer); override;
    procedure InitObjs; override;
    procedure SetFileName(const Value: string); override;
    procedure SetImport(const Value: TQImport3); override;
    procedure TuneButtons; override;
    procedure FillMap; override;
  end;

function RunQImportTXTEditor(AImport: TQImport3ASCII): boolean;

implementation

{$R *.DFM}

function RunQImportTXTEditor(AImport: TQImport3ASCII): boolean;
begin
  with TfmQImport3TXTEditor.Create(nil) do
  try
    FileName := AImport.FileName;
    Import := AImport;
    SkipLines := AImport.SkipFirstRows;
    FItemIndex := -1;
    FClearing := false;
    Result := ShowModal = mrOk;
    if Result then ApplyChanges;
  finally
    Free;
  end;
end;

{ TfmQImport3TXTEditor }

procedure TfmQImport3TXTEditor.LoadFile;
begin
  if not FileExists(FileName) then Exit;
  vwTXT.LoadFromFile(FileName);
  FNeedLoadFile := false;
end;

procedure TfmQImport3TXTEditor.DoClear;
var
  i: Integer;
begin
  vwTXT.SetSelection(0, 0);
  vwTXT.DeleteArrows;
  vwTXT.Invalidate;
  for i := 0 to lvFields.Items.Count - 1 do
  begin
    lvFields.Items[i].SubItems[0] := EmptyStr;
    lvFields.Items[i].SubItems[1] := EmptyStr;
  end;
  inherited;
end;

procedure TfmQImport3TXTEditor.DoFieldsChange(Item: TListItem; Change: TItemChange);
var
  P, S: integer;
begin
  if not Assigned(Item) then Exit;
  if Item.SubItems.Count < 2 then Exit;
  P := StrToIntDef(Item.SubItems[0], -1);
  S := StrToIntDef(Item.SubItems[1], -1);
  if (P > -1) and (S > -1) then
    vwTXT.SetSelection(P, S);
  inherited;
end;

procedure TfmQImport3TXTEditor.FieldsListCallback(var Item: TListItem; ImportType: TAllowedImport);
var
  i, P, L: integer;
  SS: string;
begin
  if not Assigned(Item) then
    Exit;
  inherited;
  i := Import.Map.IndexOfName(Item.Caption);
  if i > -1 then
  begin
    SS := Import.Map.Values[Import.Map.Names[i]];

    P := StrToIntDef(Copy(SS, 1, Pos(';', SS) - 1), 0);
    L := StrToIntDef(Copy(SS, Pos(';', SS) + 1, Length(SS)), 0);

    if L > 0 then
    begin
      vwTXT.AddArrow(P);
      vwTXT.AddArrow(P + L);
    end;

    Item.SubItems.Add(IntToStr(P));
    Item.SubItems.Add(IntToStr(L));
  end
  else begin
    Item.SubItems.Add(EmptyStr);
    Item.SubItems.Add(EmptyStr);
  end;
end;

procedure TfmQImport3TXTEditor.FillMap;
var
  i, j: Integer;
  Name, Value: string;
  Item: TListItem;
begin
  for i := 0 to Import.Map.Count - 1 do
  begin
    Name := Import.Map.Names[i];
    for j := 0 to lvFields.Items.Count - 1 do
    begin
      Item := lvFields.Items[j];
      if AnsiCompareText(Item.Caption, Name) = 0 then
      begin
        Value := Import.Map.Values[Name];
        Item.SubItems[0] := Copy(Value, 1, Pos(';', Value) - 1);
        Item.SubItems[1] := Copy(Value, Pos(';', Value) + 1, Length(Value));
        Break;
      end;
    end;
  end;
  vwTXT.Invalidate;
end;

procedure TfmQImport3TXTEditor.ApplyMapValue(Index: integer);
var
  Item: TListItem;
begin
  Item := lvFields.Items[Index];
  if (Item.SubItems[0] <> EmptyStr) and (Item.SubItems[1] <> EmptyStr) then
    Import.Map.Values[Item.Caption] :=
      Format('%s;%s', [Item.SubItems[0], Item.SubItems[1]]);
end;

procedure TfmQImport3TXTEditor.InitObjs;
begin
  inherited;
  vwTXT := TQImport3TXTViewer.Create(Self);
  vwTXT.Parent := paView;
  vwTXT.Align := alClient;
  vwTXT.OnChangeSelection := ViewerChangeSelection;
end;

procedure TfmQImport3TXTEditor.ViewerChangeSelection(Sender: TObject);
var
  P, S: integer;
begin
  if not Assigned(lvFields.ItemFocused) then Exit;
  vwTXT.GetSelection(P, S);
  if (P > -1) and (S > -1) then
  begin
    lvFields.ItemFocused.SubItems[0] := IntToStr(P);
    lvFields.ItemFocused.SubItems[1] := IntToStr(S);
  end
  else begin
    lvFields.ItemFocused.SubItems[0] := EmptyStr;
    lvFields.ItemFocused.SubItems[1] := EmptyStr;
  end;
end;

procedure TfmQImport3TXTEditor.SetFileName(const Value: string);
begin
  if AnsiCompareText(FileName, Trim(Value)) <> 0 then
  begin
    inherited;
    FNeedLoadFile := True;
    LoadFile;
  end;
  TuneButtons;
end;

procedure TfmQImport3TXTEditor.SetImport(const Value: TQImport3);
begin
  if Import = Value then
    Exit;
  inherited;
  vwTXT.Import := Value as TQImport3ASCII;
end;

procedure TfmQImport3TXTEditor.TuneButtons;
var
  Condition: boolean;
begin
  Condition := (lvFields.Items.Count > 0) and FileExists(FileName);
  tbtClear.Enabled := Condition;
  laSkip_01.Enabled := Condition;
  edSkip.Enabled := Condition;
  laSkip_02.Enabled := Condition;
  if Assigned(vwTXT) then
    vwTXT.Enabled := Condition;
end;

end.
