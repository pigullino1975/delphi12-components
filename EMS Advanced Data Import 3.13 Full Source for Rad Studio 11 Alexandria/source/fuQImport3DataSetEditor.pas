unit fuQImport3DataSetEditor;

{$I QImport3VerCtrl.Inc}

interface

uses
  {$IFDEF VCL16}
    Vcl.Forms,
    Vcl.ExtCtrls,
    Vcl.StdCtrls,
    Vcl.ComCtrls,
    Vcl.Dialogs,
    Vcl.Controls,
    System.Classes,
    Data.Db,
    Vcl.ImgList,
    Vcl.Buttons,
    Vcl.ToolWin,
    System.SysUtils,
    Vcl.Graphics,
  {$ELSE}
    Forms,
    ExtCtrls,
    StdCtrls,
    ComCtrls,
    Dialogs,
    Controls,
    Classes,
    Db,
    ImgList,
    Buttons,
    ToolWin,
    SysUtils,
    Graphics,
  {$ENDIF}
  QImport3,
  QImport3DataSet,
  fuQImport3TripleListEditor;

type
  TfmQImport3DataSetEditor = class(TfmQImport3TripleListEditor)
  private
  protected
    procedure FillSourceList; override;
    procedure SetImport(const Value: TQImport3); override;
  public
  end;

function RunQImportDataSetEditor(AImport: TQImport3DataSet): boolean;

implementation

{$R *.DFM}

function RunQImportDataSetEditor(AImport: TQImport3DataSet): boolean;
begin
  with TfmQImport3DataSetEditor.Create(nil) do
  try
    Import := AImport;
    Result := ShowModal = mrOk;
    if Result then ApplyChanges;
  finally
    Free;
  end;
end;

{ TfmQImport3DataSetEditor }

procedure TfmQImport3DataSetEditor.FillSourceList;
var
  i: integer;
  WasActive: boolean;
  Field: TField;
  DS: TDataSet;
begin
  DS := TQImport3DataSet(Import).Source;
  lvSource.Items.BeginUpdate;
  WasActive := DS.Active;
  try
    if not WasActive and (DS.FieldCount = 0) then
    try
      DS.Open;
    except
      Exit;
    end;
    lvSource.Items.Clear;
    for i := 0 to DS.FieldCount - 1 do
    begin
      Field := DS.Fields[i];
      if not Import.SkipInvisibleColumns or Field.Visible then
        with lvSource.Items.Add do begin
          Caption := (Field.FieldName);
          ImageIndex := 8;
        end;
    end;
    if lvSource.Items.Count > 0 then begin
      lvSource.Items[0].Focused := true;
      lvSource.Items[0].Selected := true;
    end;
  finally
    if not WasActive and DS.Active then DS.Close;
    lvSource.Items.EndUpdate;
  end;
end;

procedure TfmQImport3DataSetEditor.SetImport(const Value: TQImport3);
begin
  if Import = Value then
    Exit;
  inherited;
  FillSourceList;
  FillMap;
  TuneButtons;
end;

end.
