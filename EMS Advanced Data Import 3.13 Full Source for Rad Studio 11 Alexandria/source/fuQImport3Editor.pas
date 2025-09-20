unit fuQImport3Editor;

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
  {$ELSE}
    SysUtils,
    Messages,
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
  {$ENDIF}
  QImport3,
  QImport3Common;

type
  TfmQImport3Editor = class(TForm)
    paFileName: TPanel;
    bvlBrowse: TBevel;
    laFileName: TLabel;
    edFileName: TEdit;
    bBrowse: TSpeedButton;
    Bevel1: TBevel;
    odFileName: TOpenDialog;
    paButtons: TPanel;
    buOk: TButton;
    buCancel: TButton;
    Bevel2: TBevel;
    paFields: TPanel;
    lvFields: TListView;
    ToolBar: TToolBar;
    tbtClear: TToolButton;
    ilWizard: TImageList;
    laSkip_01: TLabel;
    edSkip: TEdit;
    laSkip_02: TLabel;
    procedure FormDestroy(Sender: TObject);
    procedure bBrowseClick(Sender: TObject);
    procedure edFileNameChange(Sender: TObject);
    procedure edSkipChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lvFieldsChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure lvFieldsEnter(Sender: TObject);
    procedure lvFieldsExit(Sender: TObject);
    procedure tbtClearClick(Sender: TObject);
  private
    { Private declarations }
    FImport: TQImport3;
    FSkipLines: Integer;
  protected
    FFileName: string;
    FNeedLoadFile: Boolean;
    procedure ApplyChanges; virtual;
    procedure ClearData; virtual;
    procedure ClearFieldList; virtual;
    procedure DoClear; virtual;
    procedure DoFieldsChange(Item: TListItem; Change: TItemChange); virtual;
    procedure DoFieldsListEnter; virtual;
    procedure DoFieldsListExit; virtual;
    procedure FieldsListCallback(var Item: TListItem; ImportType: TAllowedImport); virtual;
    procedure ApplyMapValue(Index: integer); virtual;
    function ColValue: integer; virtual;
    procedure FillFieldsList;
    procedure FillMap; virtual;
    function GetCondition: Boolean; virtual;
    function GetMapView: TListView; virtual;
    procedure InitObjs; virtual;
    procedure SetCaption; virtual;
    procedure SetFileName(const Value: string); virtual;
    procedure SetImport(const Value: TQImport3); virtual;
    procedure SetSkipLines(const Value: Integer); virtual;
    procedure TuneButtons; virtual;
  public
    { Public declarations }
    property Import: TQImport3 read FImport write SetImport;
    property FileName: string read FFileName write SetFileName;
    property SkipLines: Integer read FSkipLines write SetSkipLines;
  end;

implementation

{$R *.DFM}

{ TfmQImport3Editor }

procedure TfmQImport3Editor.ApplyChanges;
var
  i: integer;
begin
  Import.Map.BeginUpdate;
  try
    Import.Map.Clear;
    for i := 0 to GetMapView.Items.Count - 1 do
      ApplyMapValue(i);
  finally
    Import.Map.EndUpdate;
  end;
  Import.FileName := FileName;
  Import.SkipFirstRows := SkipLines;
end;

procedure TfmQImport3Editor.ApplyMapValue(Index: integer);
var
  Item: TListItem;
begin
  Item := lvFields.Items[Index];
  if Item.SubItems[0] <> EmptyStr then
    Import.Map.Values[Item.Caption] := Item.SubItems[0];
end;

procedure TfmQImport3Editor.FieldsListCallback(var Item: TListItem; ImportType:
    TAllowedImport);
begin
  if not Assigned(Item) then
    Exit;
  Item.ImageIndex := 0;
  Item.SubItems.Clear;
end;

procedure TfmQImport3Editor.FillFieldsList;
begin
  if not QImportDestinationAssigned(false, Import.ImportDestination,
      Import.DataSet, Import.DBGrid, Import.ListView, Import.StringGrid)
    then Exit;
  ClearFieldList;
  QImportFillDestinationFieldsList(lvFields, Import.ImportDestination,
  Import.DataSet,  Import.DBGrid, Import.ListView, Import.StringGrid,
  Import.GridCaptionRow, Import.SkipInvisibleColumns, aiCSV, FieldsListCallback);
end;

procedure TfmQImport3Editor.ClearFieldList;
begin
  lvFields.Items.Clear;
end;

procedure TfmQImport3Editor.TuneButtons;
var
  Condition: boolean;
begin
  Condition := GetCondition;
  tbtClear.Enabled := Condition;
  laSkip_01.Enabled := Condition;
  edSkip.Enabled := Condition;
  laSkip_02.Enabled := Condition;
end;

procedure TfmQImport3Editor.SetFileName(const Value: string);
begin
  if AnsiCompareText(FFileName, Trim(Value)) <> 0 then
  begin
    FFileName := Trim(Value);
    edFileName.Text := FFileName;
    SetCaption;
  end;
end;

procedure TfmQImport3Editor.edFileNameChange(Sender: TObject);
begin
  FileName := edFileName.Text;
end;

procedure TfmQImport3Editor.ClearData;
begin
  ClearFieldList;
end;

procedure TfmQImport3Editor.FormDestroy(Sender: TObject);
begin
  ClearData;
end;

procedure TfmQImport3Editor.bBrowseClick(Sender: TObject);
begin
  odFileName.FileName := FFileName;
  if odFileName.Execute then
  begin
    FileName := odFileName.FileName;
    DoClear;
  end;
end;

function TfmQImport3Editor.ColValue: integer;
begin
  Result := 0;
  if Assigned(lvFields.Selected) then
    Result := StrToIntDef(lvFields.Selected.SubItems[0], 0);
end;

procedure TfmQImport3Editor.DoClear;
var
  i: Integer;
begin
  for i := 0 to lvFields.Items.Count - 1 do
    lvFields.Items[i].SubItems[0] := EmptyStr;
  lvFieldsChange(lvFields, lvFields.Selected, ctState);
end;

procedure TfmQImport3Editor.DoFieldsChange(Item: TListItem; Change:
    TItemChange);
begin
  TuneButtons;
end;

procedure TfmQImport3Editor.DoFieldsListEnter;
begin

end;

procedure TfmQImport3Editor.DoFieldsListExit;
begin

end;

procedure TfmQImport3Editor.edSkipChange(Sender: TObject);
begin
  SkipLines := StrToIntDef(edSkip.Text, 0);
end;

procedure TfmQImport3Editor.FillMap;
var
  i, j: Integer;
  Nm: string;
  Item: TListItem;
begin
  for i := 0 to Import.Map.Count - 1 do
  begin
    Nm := Import.Map.Names[i];
    for j := 0 to lvFields.Items.Count - 1 do
    begin
      Item := lvFields.Items[j];
      if AnsiCompareText(Item.Caption, Nm) = 0 then
      begin
        if Item.SubItems.Count > 0 then
          Item.SubItems[0] := Import.Map.Values[Nm]
        else
          Item.SubItems.Add(Import.Map.Values[Nm]);
        Break;
      end;
    end;
  end;
end;

procedure TfmQImport3Editor.FormCreate(Sender: TObject);
begin
  InitObjs;
end;

procedure TfmQImport3Editor.FormShow(Sender: TObject);
begin
  SetCaption;
  if lvFields.Items.Count > 0 then
  begin
    lvFields.Items[0].Focused := True;
    lvFields.Items[0].Selected := True;
  end;
end;

function TfmQImport3Editor.GetCondition: Boolean;
begin
  Result := (lvFields.Items.Count > 0) and FileExists(FileName);
end;

function TfmQImport3Editor.GetMapView: TListView;
begin
  Result := lvFields;
end;

procedure TfmQImport3Editor.InitObjs;
begin
  FNeedLoadFile := True;
end;

procedure TfmQImport3Editor.lvFieldsChange(Sender: TObject;
  Item: TListItem; Change: TItemChange);
begin
  DoFieldsChange(Item, Change);
end;

procedure TfmQImport3Editor.lvFieldsEnter(Sender: TObject);
begin
  DoFieldsListEnter;
end;

procedure TfmQImport3Editor.lvFieldsExit(Sender: TObject);
begin
  DoFieldsListExit;
end;

procedure TfmQImport3Editor.SetCaption;
begin
  if Assigned(Import) then
    Caption := Import.Name + ' - Component Editor';
end;

procedure TfmQImport3Editor.SetImport(const Value: TQImport3);
begin
  if FImport = Value then
    Exit;
  FImport := Value;
  FillFieldsList;
end;

procedure TfmQImport3Editor.SetSkipLines(const Value: Integer);
begin
  if FSkipLines <> Value then
  begin
    FSkipLines := Value;
    edSkip.Text := IntToStr(FSkipLines);
  end;
  FillMap;
end;

procedure TfmQImport3Editor.tbtClearClick(Sender: TObject);
begin
  DoClear;
end;

end.
