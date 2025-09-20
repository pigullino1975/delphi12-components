unit fuQImport3XMLDocEditor;

{$I QImport3VerCtrl.Inc}

interface

{$IFDEF XMLDOC}

uses
  {$IFDEF VCL16}
    System.Variants,
    Winapi.Windows,
    Winapi.Messages,
    System.SysUtils,
    System.Classes,
    Vcl.Graphics,
    Vcl.Controls,
    Vcl.Forms,
    Vcl.Dialogs,
    Vcl.ComCtrls,
    Vcl.ImgList,
    Vcl.StdCtrls,
    Vcl.ToolWin,
    Vcl.Grids,
    Vcl.Buttons,
    Vcl.ExtCtrls,
    Vcl.Menus,
  {$ELSE}
    {$IFDEF VCL6}
      Variants,
    {$ENDIF}
    Windows,
    Messages,
    SysUtils,
    Classes,
    Graphics,
    Controls,
    Forms,
    Dialogs,
    ComCtrls,
    ImgList,
    StdCtrls,
    ToolWin,
    Grids,
    Buttons,
    ExtCtrls,
    Menus,
  {$ENDIF}
  QImport3XMLDoc,
  QImport3StrTypes,
  fuQImport3GridEditor,
  QImport3Common,
  fuQImport3Loading;

type
  TLoadDataProc = procedure of object;

  TfmQImport3XMLDocEditor = class(TfmQImport3GridEditor)
    tvXMLDoc: TTreeView;
    laXPath: TLabel;
    edXPath: TEdit;
    bFillGrig: TSpeedButton;
    bBuildTree: TSpeedButton;
    bGetXPath: TSpeedButton;
    pmTreeView: TPopupMenu;
    miGetXPath: TMenuItem;
    laDataLocation: TLabel;
    cbDataLocation: TComboBox;
    procedure bFillGrigClick(Sender: TObject);
    procedure bBuildTreeClick(Sender: TObject);
    procedure bGetXPathClick(Sender: TObject);
  private
    FXMLFile: TXMLDocFile;
    FXPath: qiString;
    FDataLocation: TXMLDataLocation;

    procedure SetXPath(const Value: qiString);
    procedure SetDataLocation(const Value: TXMLDataLocation);

    procedure ClearGrid;
    function GetXPath: qiString;

    procedure LoadXmlFile;
    procedure ApplyXPath;
    procedure ShowXmlData;
    procedure BuildTree;
    procedure ShowLoadProcess(const ATitle: string; AProc: TLoadDataProc);
  protected
    procedure SetCaption; override;
    procedure ApplyChanges; override;
    procedure ClearData; override;
    procedure DoAutoFill; override;
    procedure FillGrid; override;
    procedure InitObjs; override;
    procedure TuneButtons; override;
    function MarkFirstRow: Boolean; override;
    procedure SetFileName(const Value: string); override;
  public
    property XPath: qiString read FXPath write SetXPath;
    property DataLocation: TXMLDataLocation read FDataLocation write SetDataLocation;
  end;

function RunQImportXMLDocEditor(AImport: TQImport3XMLDoc): Boolean;

{$ENDIF}

implementation

{$IFDEF XMLDOC}

{$R *.dfm}

function RunQImportXMLDocEditor(AImport: TQImport3XMLDoc): Boolean;
var
  Editor: TfmQImport3XMLDocEditor;
begin
  Editor := TfmQImport3XMLDocEditor.Create(nil);
  try
    Editor.Import := AImport;
    Editor.FileName := AImport.FileName;
    Editor.DataLocation := AImport.DataLocation;
    Editor.XPath := AImport.XPath;
    Editor.SkipLines := AImport.SkipFirstRows;

    Result := Editor.ShowModal = mrOk;
    if Result then
      Editor.ApplyChanges;
  finally
    Editor.Free;
  end;
end;

procedure TfmQImport3XMLDocEditor.bFillGrigClick(Sender: TObject);
begin
  if FNeedLoadFile then
    LoadXmlFile;
  DataLocation := TXMLDataLocation(cbDataLocation.ItemIndex);
  XPath := edXPath.Text;
  ShowLoadProcess(edXPath.Text, ApplyXPath);
end;

procedure TfmQImport3XMLDocEditor.SetXPath(const Value: qiString);
begin
  if Value <> FXPath then
  begin
    FXPath := Value;
    edXPath.Text := FXPath;
  end;
end;

procedure TfmQImport3XMLDocEditor.TuneButtons;
begin
  inherited TuneButtons;
  bBuildTree.Enabled := Length(edFileName.Text) > 0;
end;

procedure TfmQImport3XMLDocEditor.ApplyXPath;
begin
  FXMLFile.XPath := FXPath;
  FillGrid;
end;

procedure TfmQImport3XMLDocEditor.SetCaption;
begin
  inherited;
  if FileExists(FileName) then
    ShowLoadProcess(FileName, ShowXmlData);
  FillMap;
end;

procedure TfmQImport3XMLDocEditor.SetDataLocation(
  const Value: TXMLDataLocation);
begin
  if Value <> FDataLocation then
  begin
    FDataLocation := Value;
    cbDataLocation.ItemIndex := Integer(Value);
    FXMLFile.DataLocation := Value;
  end;
end;

procedure TfmQImport3XMLDocEditor.FillGrid;
begin
  ClearGrid;
  FillStringGrid(FGrid, FXMLFile);
  FillComboColumn;
end;

procedure TfmQImport3XMLDocEditor.ClearGrid;
var
  i: Integer;
begin
  for i := 0 to FGrid.ColCount - 1 do
    FGrid.Cols[i].Clear;
  FGrid.ColCount := 2;
  FGrid.FixedCols := 1;
  FGrid.RowCount := 2;
  FGrid.FixedRows := 1;
end;

procedure TfmQImport3XMLDocEditor.ApplyChanges;
begin
  inherited;
  TQImport3XMLDoc(Import).DataLocation := DataLocation;
  TQImport3XMLDoc(Import).XPath := XPath;
end;

procedure TfmQImport3XMLDocEditor.bBuildTreeClick(Sender: TObject);
begin
  if FNeedLoadFile then
    LoadXmlFile;
  ShowLoadProcess('Building...', BuildTree);
end;

function TfmQImport3XMLDocEditor.GetXPath: qiString;
var
  CurrentNode: TTreeNode;
begin
  Result := '/';                                                                                    
  if Assigned(tvXMLDoc.Selected) then
  begin
    CurrentNode := tvXMLDoc.Selected;
    if Assigned(CurrentNode) then
      if not Assigned(CurrentNode.Data) then
        Result := Concat('/', CurrentNode.Text)
      else
      if Integer(CurrentNode.Data) = 2 then
        Result := Concat('[', CurrentNode.Text, ']');

    while CurrentNode.Parent <> nil do
    begin
      CurrentNode := CurrentNode.Parent;
      Result := Concat('/', CurrentNode.Text, Result);
    end;
  end;  
end;

procedure TfmQImport3XMLDocEditor.bGetXPathClick(Sender: TObject);
begin
  edXPath.Text := GetXPath;
end;

procedure TfmQImport3XMLDocEditor.BuildTree;
begin
  XMLFile2TreeView(tvXMLDoc, FXMLFile);
end;

procedure TfmQImport3XMLDocEditor.ClearData;
begin
  inherited;
  FXMLFile.Destroy;
end;

procedure TfmQImport3XMLDocEditor.DoAutoFill;
var
  i: Integer;
begin
  for i := 0 to lvFields.Items.Count - 1 do
    if (i <= FGrid.ColCount - 2) then
      lvFields.Items[i].SubItems[0] := IntToStr(i + 2)
    else
      lvFields.Items[i].SubItems[0] := EmptyStr;
  lvFieldsChange(lvFields, lvFields.Selected, ctState);
  TuneButtons;
end;

procedure TfmQImport3XMLDocEditor.InitObjs;
begin
  inherited;
  FGrid.ColCount := 2;
  FGrid.DefaultColWidth := 82;
  FGrid.RowCount := 2;
  FGrid.Options := [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine];
  FXMLFile := TXMLDocFile.Create;
end;

procedure TfmQImport3XMLDocEditor.ShowLoadProcess(const ATitle: string; AProc: TLoadDataProc);
var
  F: TForm;
  Start, Finish: TDateTime;
begin
  Start := Now;
  F := ShowLoading(Self, ATitle);
  try
    Application.ProcessMessages;
    AProc;
  finally
    Finish := Now;
    while (Finish - Start) < EncodeTime(0, 0, 0, 500) do
      Finish := Now;
    F.Free;
  end;
end;

function TfmQImport3XMLDocEditor.MarkFirstRow: Boolean;
begin
  Result := True;
end;

procedure TfmQImport3XMLDocEditor.SetFileName(const Value: string);
begin
  if AnsiCompareText(FileName, Trim(Value)) <> 0 then
  begin
    FFileName := Trim(Value);
    edFileName.Text := FFileName;
    FXMLFile.FileName := FFileName;
    FNeedLoadFile := True;
  end;
  TuneButtons;
end;

procedure TfmQImport3XMLDocEditor.ShowXmlData;
begin
  LoadXmlFile;
  ApplyXPath;
end;

procedure TfmQImport3XMLDocEditor.LoadXmlFile;
begin
  FXMLFile.Load;
  ClearGrid;
  FNeedLoadFile := False;
end;

{$ENDIF}

end.
