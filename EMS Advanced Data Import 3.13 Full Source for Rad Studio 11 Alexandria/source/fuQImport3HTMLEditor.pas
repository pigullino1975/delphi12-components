unit fuQImport3HTMLEditor;

{$I QImport3VerCtrl.Inc}

interface

{$IFDEF HTML}

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
    Vcl.ComCtrls,
    Vcl.StdCtrls,
    Vcl.ToolWin,
    Vcl.Grids,
    Vcl.ExtCtrls,
    Vcl.ImgList,
    Vcl.Buttons,
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
    ComCtrls,
    StdCtrls,
    ToolWin,
    Grids,
    ExtCtrls,
    ImgList,
    Buttons,
    Math,
  {$ENDIF}
  QImport3StrTypes,
  QImport3HTML,
  fuQImport3GridEditor,
  QImport3Common,
  fuQImport3Loading;

type
  TfmQImport3HTMLEditor = class(TfmQImport3GridEditor)
    laTable: TLabel;
    cbTable: TComboBox;
    procedure cbTableChange(Sender: TObject);
  private
    FHTML: THTMLFile;
  protected
    procedure ApplyChanges; override;
    procedure FillGrid; override;
    procedure InitObjs; override;
    function MarkFirstRow: Boolean; override;
    procedure TuneButtons; override;
  end;

function RunQImportHTMLEditor(AImport: TQImport3HTML): boolean;

{$ENDIF}

implementation

{$IFDEF HTML}

{$R *.dfm}

function RunQImportHTMLEditor(AImport: TQImport3HTML): boolean;
begin
  with TfmQImport3HTMLEditor.Create(nil) do
  try
    Import := AImport;
    FileName := AImport.FileName;
    SkipLines := AImport.SkipFirstRows;
    Result := ShowModal = mrOk;
    if Result then ApplyChanges;
  finally
    Free;
  end;
end;

{ TfmQImport3HTMLEditor }

procedure TfmQImport3HTMLEditor.cbTableChange(Sender: TObject);
begin
  FillGrid;
end;

procedure TfmQImport3HTMLEditor.FillGrid;
var
  F: TForm;
  Start, Finish: TDateTime;
  i, j:  Integer;
begin
  if not FileExists(FileName) then Exit;

  if FNeedLoadFile then  
  begin
    Start := Now;
    F := ShowLoading(Self, FileName);
    try
      Application.ProcessMessages;
      if Assigned(FHTML) then FHTML.Free;
      FHTML := THTMLFile.Create;
      FHTML.FileName := FileName;
      FHTML.Load(0);
      cbTable.Items.Clear;
      if FHTML.TableList.Count >= 0 then
      begin
        for i := 0 to FHTML.TableList.Count - 1 do
          cbTable.Items.Add(IntToStr(Succ(i)));
        cbTable.ItemIndex := 0;
      end;
      FNeedLoadFile := False;
    finally
      Finish := Now;
      while (Finish - Start) < EncodeTime(0, 0, 0, 500) do
        Finish := Now;
      if Assigned(F) then
        F.Free;
    end;
  end;

  if FHTML.TableList.Count >= 0 then
  begin
    FGrid.ColCount := 1;
    FGrid.RowCount := Min(FHTML.TableList[cbTable.ItemIndex].Rows.Count, 30);
    for i := 0 to FGrid.RowCount - 1 do
    begin
      if FGrid.ColCount < FHTML.TableList[cbTable.ItemIndex].Rows[i].Cells.Count then
        FGrid.ColCount := FHTML.TableList[cbTable.ItemIndex].Rows[i].Cells.Count;
      for j := 0 to FHTML.TableList[cbTable.ItemIndex].Rows[i].Cells.Count - 1 do
        FGrid.Cells[j, i] := FHTML.TableList[cbTable.ItemIndex].Rows[i].Cells[j].Text;
    end;
    FillComboColumn;
  end;
end;

procedure TfmQImport3HTMLEditor.TuneButtons;
var
  Condition: boolean;
begin
  inherited;
  Condition := (not FNeedLoadFile) and FileExists(FileName);
  laTable.Enabled := Condition;
  cbTable.Enabled := Condition;
end;

procedure TfmQImport3HTMLEditor.ApplyChanges;
begin
  inherited;
  TQImport3HTML(Import).TableNumber := StrToIntDef(cbTable.Text, 0);
end;

procedure TfmQImport3HTMLEditor.InitObjs;
begin
  inherited;
  FGrid.Options := [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine];
end;

function TfmQImport3HTMLEditor.MarkFirstRow: Boolean;
begin
  Result := False;
end;

{$ENDIF}

end.
