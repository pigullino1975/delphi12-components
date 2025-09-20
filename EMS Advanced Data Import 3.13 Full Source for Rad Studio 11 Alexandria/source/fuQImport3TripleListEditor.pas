unit fuQImport3TripleListEditor;

{$I QImport3VerCtrl.Inc}

interface

uses
  {$IFDEF VCL16}
    System.SysUtils,
    Winapi.Messages,
    System.Variants,
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
    Vcl.Graphics,
  {$ELSE}
    SysUtils,
    Messages,
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
    Graphics,
    {$IFDEF VCL6}
      Variants,
    {$ENDIF}
  {$ENDIF}
  QImport3Common,
  QImport3StrTypes,
  fuQImport3Editor;

type
  TfmQImport3TripleListEditor = class(TfmQImport3Editor)
    lvMap: TListView;
    lvSource: TListView;
    buClear: TSpeedButton;
    buRemove: TSpeedButton;
    buAutoFill: TSpeedButton;
    buAdd: TSpeedButton;
    pbClear: TPaintBox;
    pbRemove: TPaintBox;
    pbAutoFill: TPaintBox;
    pbAdd: TPaintBox;
    procedure buAddClick(Sender: TObject);
    procedure buAddMouseDown(Sender: TObject; Button: TMouseButton; Shift:
        TShiftState; X, Y: Integer);
    procedure buAddMouseUp(Sender: TObject; Button: TMouseButton; Shift:
        TShiftState; X, Y: Integer);
    procedure buAutoFillClick(Sender: TObject);
    procedure buRemoveClick(Sender: TObject);
    procedure pbAddPaint(Sender: TObject);
  protected
    procedure ApplyMapValue(Index: integer); override;
    procedure DoClear; override;
    procedure FieldsListCallback(var Item: TListItem; ImportType: TAllowedImport);
        override;
    procedure FillMap; override;
    procedure FillSourceList; virtual; abstract;
    function GetMapView: TListView; override;
    procedure InitObjs; override;
    procedure SetFileName(const Value: string); override;
    procedure TuneButtons; override;
  end;

implementation

{$R *.dfm}

procedure TfmQImport3TripleListEditor.ApplyMapValue(Index: integer);
var
  Item: TListItem;
begin
  Item := lvMap.Items[Index];
  Import.Map.Values[Item.Caption] := Item.SubItems[1];
end;

procedure TfmQImport3TripleListEditor.buAddClick(Sender: TObject);
begin
  with lvMap.Items.Add do begin
    Caption := lvFields.Selected.Caption;
    SubItems.Add('=');
    SubItems.Add(lvSource.Selected.Caption);
    ListView.Selected := lvMap.Items[Index];
    ImageIndex := 8;
  end;
  lvFields.Items.Delete(lvFields.Selected.Index);
  if lvFields.Items.Count > 0 then begin
    lvFields.Items[0].Focused := true;
    lvFields.Items[0].Selected := true;
  end;
  if lvMap.Items.Count > 0 then begin
    lvMap.Items[0].Focused := true;
    lvMap.Items[0].Selected := true;
  end;
  TuneButtons;
end;

procedure TfmQImport3TripleListEditor.buAddMouseDown(Sender: TObject; Button:
    TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  C: TControl;
begin
  if Sender = buAdd then
    C := pbAdd
  else if Sender = buAutoFill then
    C := pbAutoFill
  else if Sender = buRemove then
    C := pbRemove
  else if Sender = buClear then
    C := pbClear
  else
    Exit;
  C.Left := C.Left + 1;
  C.Top := C.Top + 1;
end;

procedure TfmQImport3TripleListEditor.buAddMouseUp(Sender: TObject; Button:
    TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  C: TControl;
begin
  if Sender = buAdd then
    C := pbAdd
  else if Sender = buAutoFill then
    C := pbAutoFill
  else if Sender = buRemove then
    C := pbRemove
  else if Sender = buClear then
    C := pbClear
  else
    Exit;
  C.Left := C.Left - 1;
  C.Top := C.Top - 1;
end;

procedure TfmQImport3TripleListEditor.buAutoFillClick(Sender: TObject);
var
  i, N: integer;
begin
  lvFields.Items.BeginUpdate;
  try
    lvSource.Items.BeginUpdate;
    try
      lvMap.Items.BeginUpdate;
      try
        lvMap.Items.Clear;
        FillFieldsList;
        N := lvSource.Items.Count;
        if N > lvFields.Items.Count
          then N := lvFields.Items.Count;
        for i := N - 1 downto 0 do begin
          with lvMap.Items.Insert(0) do begin
            Caption := lvFields.Items[i].Caption;
            SubItems.Add('=');
            SubItems.Add(lvSource.Items[i].Caption);
            ImageIndex := 8;
          end;
          lvFields.Items[i].Delete;
        end;
        if lvMap.Items.Count > 0 then begin
          lvMap.Items[0].Focused := true;
          lvMap.Items[0].Selected := true;
        end;
      finally
        lvMap.Items.EndUpdate;
      end;
    finally
      lvSource.Items.EndUpdate;
    end;
  finally
    lvFields.Items.EndUpdate;
  end;
  TuneButtons;
end;

procedure TfmQImport3TripleListEditor.buRemoveClick(Sender: TObject);
begin
  with lvFields.Items.Add do begin
    Caption := lvMap.Selected.Caption;
    ImageIndex := 8;
  end;
  lvMap.Items.Delete(lvMap.Selected.Index);
  if lvMap.Items.Count > 0 then begin
    lvMap.Items[0].Focused := true;
    lvMap.Items[0].Selected := true;
  end;
  if lvFields.Items.Count > 0 then begin
    lvFields.Items[0].Focused := true;
    lvFields.Items[0].Selected := true;
  end;
  TuneButtons;
end;

procedure TfmQImport3TripleListEditor.DoClear;
begin
  lvFields.Items.BeginUpdate;
  try
    lvMap.Items.BeginUpdate;
    try
      lvMap.Items.Clear;
      FillFieldsList;
    finally
      lvMap.Items.EndUpdate;
    end;
  finally
    lvFields.Items.EndUpdate;
  end;
  TuneButtons;
end;

{ TfmQImport3TripleListEditor }

procedure TfmQImport3TripleListEditor.FieldsListCallback(var Item: TListItem;
    ImportType: TAllowedImport);
begin
  if not Assigned(Item) then
    Exit;
  Item.ImageIndex := 8;
end;

procedure TfmQImport3TripleListEditor.FillMap;
var
  i, j: integer;
  b: boolean;
begin
  lvMap.Items.BeginUpdate;
  try
    lvFields.Items.BeginUpdate;
    try
      lvMap.Items.Clear;
      for i := 0 to Import.Map.Count - 1 do begin
        b := false;
        for j := 0 to lvSource.Items.Count - 1 do begin
          b := b or (AnsiCompareText(lvSource.Items[j].Caption,
             Import.Map.Values[Import.Map.Names[i]]) = 0);
          if b then Break;
        end;
        if not b then Continue;
        with lvMap.Items.Add do begin
          Caption := Import.Map.Names[i];
          SubItems.Add('=');
          SubItems.Add(Import.Map.Values[Import.Map.Names[i]]);
          ImageIndex := 8;
        end;
        for j := 0 to lvFields.Items.Count - 1 do
          if AnsiCompareText(lvFields.Items[j].Caption,
            Import.Map.Names[i]) = 0 then begin
            lvFields.Items[j].Delete;
            Break;
          end;
      end;
      if lvMap.Items.Count > 0 then begin
        lvMap.Items[0].Focused := true;
        lvMap.Items[0].Selected := true;
      end;
    finally
      lvFields.Items.EndUpdate;
    end;
  finally
    lvMap.Items.EndUpdate;
  end;
end;

function TfmQImport3TripleListEditor.GetMapView: TListView;
begin
  Result := lvMap;
end;

procedure TfmQImport3TripleListEditor.InitObjs;
begin
  laSkip_01.Parent := paFields;
  laSkip_02.Parent := paFields;
  edSkip.Parent := paFields;
  laSkip_01.Top := lvMap.Top;
  laSkip_02.Top := lvMap.Top;
  edSkip.Top := lvMap.Top;
  laSkip_01.Left := buAdd.Left;
  edSkip.Left := buAdd.Left + buAdd.Width + 2;
  laSkip_02.Left := edSkip.Left + edSkip.Width + 2;
  inherited;
end;

procedure TfmQImport3TripleListEditor.pbAddPaint(Sender: TObject);
var
  Bmp: TBitmap;
  i: integer;
begin
  if Sender = pbAdd then
    i := 0
  else if Sender = pbAutoFill then
    i := 1
  else if Sender = pbRemove then
    i := 2
  else if Sender = pbClear then
    i := 3
  else
    Exit;
  Bmp := TBitmap.Create;
  try
    Bmp.Transparent := true;
    if not TControl(Sender).Enabled
      then i := i + 4;
    ilWizard.GetBitmap(i, Bmp);
    TPaintBox(Sender).Canvas.Draw(0, 0, Bmp);
  finally
    Bmp.Free;
  end;
end;

procedure TfmQImport3TripleListEditor.SetFileName(const Value: string);
begin
  if FFileName <> Trim(Value) then
  begin
    if not FileExists(Value) then
      if Application.MessageBox(PChar('File ' + Value + ' doesn''t exist. Continue ?'),
        'Warning', MB_YESNO + MB_ICONWARNING + MB_DEFBUTTON2) = IDNO
        then begin
          edFileName.Text := FFileName;
          Abort;
        end;
    if lvMap.Items.Count > 0 then
      if Application.MessageBox('File name was changed. Want you clear map list ?',
        'Question', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON1) = IDYES
        then lvMap.Items.Clear;
    FFileName := Trim(Value);
    edFileName.Text := FFileName;
    FillSourceList;
    FillMap;
  end;
  TuneButtons;
end;

procedure TfmQImport3TripleListEditor.TuneButtons;
begin
  buAdd.Enabled := Assigned(lvFields.Selected) and Assigned(lvSource.Selected);
  buRemove.Enabled := Assigned(lvMap.Selected);
  buClear.Enabled := buRemove.Enabled;
  buAutoFill.Enabled := (lvSource.Items.Count > 0) and
    ((lvFields.Items.Count > 0) or (lvMap.Items.Count > 0));
end;

end.
