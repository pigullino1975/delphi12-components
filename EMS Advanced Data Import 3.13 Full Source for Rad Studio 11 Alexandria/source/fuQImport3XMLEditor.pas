unit fuQImport3XMLEditor;

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
  QImport3XML,
  fuQImport3TripleListEditor;

type
  TfmQImport3XMLEditor = class(TfmQImport3TripleListEditor)
  private
  protected
    procedure FillSourceList; override;
  public
  end;

function RunQImportXMLEditor(AImport: TQImport3XML): boolean;

implementation

{$R *.DFM}

function RunQImportXMLEditor(AImport: TQImport3XML): boolean;
begin
  with TfmQImport3XMLEditor.Create(nil) do
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

procedure TfmQImport3XMLEditor.FillSourceList;
var
  XML: TXMLFile;
  i, j: integer;
  F: TXMLTag;
begin
  lvSource.Items.BeginUpdate;
  try
    lvSource.Items.Clear;
    if not FileExists(FileName) then Exit;
    XML := TXMLFile.Create;
    try
      XML.FileName := FileName;
      XML.Load(true);
      for i := 0 to XML.FieldCount - 1 do begin
        F := XML.Fields[i];
        j := F.Attributes.IndexOfName('attrname');
        if j  = -1 then j := F.Attributes.IndexOfName('FieldName');
        if j > -1 then
          with lvSource.Items.Add do begin
            Caption := F.Attributes.Values[F.Attributes.Names[j]];
            ImageIndex := 8;
          end;
      end;
      if lvSource.Items.Count > 0 then begin
        lvSource.Items[0].Focused := true;
        lvSource.Items[0].Selected := true;
      end;
    finally
      XML.Free;
    end;
  finally
    lvSource.Items.EndUpdate;
  end;
end;

end.
