unit fuQImport3DBFEditor;

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
    Vcl.ImgList,
    Vcl.Buttons,
    Vcl.ToolWin,
    System.SysUtils,
    Winapi.Windows,
    Vcl.Graphics,
    Data.DB,
  {$ELSE}
    Forms,
    ExtCtrls,
    StdCtrls,
    ComCtrls,
    Dialogs,
    Controls,
    Classes,
    ImgList,
    Buttons,
    ToolWin,
    SysUtils,
    Windows,
    Graphics,
    DB,
  {$ENDIF}
  QImport3DBF,
  fuQImport3TripleListEditor,
  QImport3DBFFile;

type
  TfmQImport3DBFEditor = class(TfmQImport3TripleListEditor)
  protected
    procedure FillSourceList; override;
  end;

function RunQImportDBFEditor(AImport: TQImport3DBF): boolean;

implementation

{$R *.DFM}

function RunQImportDBFEditor(AImport: TQImport3DBF): boolean;
begin
  with TfmQImport3DBFEditor.Create(nil) do
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

procedure TfmQImport3DBFEditor.FillSourceList;
var
  DBF: TDBFRead;
  i: integer;
begin
  lvSource.Items.BeginUpdate;
  try
    lvSource.Items.Clear;
    if not FileExists(FileName) then Exit;
    DBF := TDBFRead.Create(FileName);
    try
      for i := 0 to DBF.FieldCount - 1 do
      begin
        with lvSource.Items.Add do begin
          Caption := string(DBF.FieldName[i]);
          ImageIndex := 8;
        end;
      end;
      if lvSource.Items.Count > 0 then begin
        lvSource.Items[0].Focused := true;
        lvSource.Items[0].Selected := true;
      end;
    finally
      DBF.Free;
    end;
  finally
    lvSource.Items.EndUpdate;
  end;
end;

end.
