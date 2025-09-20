unit ImpDlgIBXF;

interface

uses
  Forms, Db, Qimport3Wizard, Grids, DBGrids, StdCtrls, Classes,
  Controls, ExtCtrls, Qimport3, QImport3Common, ComCtrls, IBQuery, IBDatabase,
  IBCustomDataSet, IBTable;

type
  TfmImpDlgIBX = class(TForm)
    QImportWizard1: TQimport3Wizard;
    Panel1: TPanel;
    btImport: TButton;
    DataSource1: TDataSource;
    chbUseBeforePost: TCheckBox;
    Button1: TButton;
    pcDestinations: TPageControl;
    tshDataSet: TTabSheet;
    dgrDataSet: TDBGrid;
    tshDBGrid: TTabSheet;
    tshListView: TTabSheet;
    tshStringGrid: TTabSheet;
    DBGrid: TDBGrid;
    ListView: TListView;
    StringGrid: TStringGrid;
    IBTable1: TIBTable;
    IBDatabase1: TIBDatabase;
    IBTransaction1: TIBTransaction;
    IBQuery1: TIBQuery;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btImportClick(Sender: TObject);
    procedure QImportWizard1AfterImport(Sender: TObject);
    procedure QImportWizard1BeforePost(Sender: TObject; Row: TQImportRow;
      var Accept: Boolean);
    procedure Button1Click(Sender: TObject);
    procedure pcDestinationsChange(Sender: TObject);
    procedure QImportWizard1NeedCommit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmImpDlgIBX: TfmImpDlgIBX;

implementation

uses SysUtils, Windows;

{$R *.DFM}

procedure TfmImpDlgIBX.FormCreate(Sender: TObject);
var
  i: Integer;
  dbDir: string;
begin
  i := 0;
  dbDir := ExtractFileDir(Application.ExeName);
  while (not FileExists(dbDir + '\demo.gdb')) and (i < 3) do
  begin
    dbDir := ExtractFileDir(dbDir);
    Inc(i);
  end;
  IBDataBase1.DatabaseName := dbDir + '\demo.gdb';
  IBDataBase1.Connected := true;
  IBTransaction1.Active := true;
  IBTable1.TableName := 'country';
  IBTable1.Active := true;

  StringGrid.Cells[0, 0] := 'Name of Country';
  StringGrid.Cells[1, 0] := 'Capital of Country';
  StringGrid.Cells[2, 0] := 'Continent of Country';
  StringGrid.Cells[3, 0] := 'Area of Country';
  StringGrid.Cells[4, 0] := 'Population of Country';
end;

procedure TfmImpDlgIBX.FormDestroy(Sender: TObject);
begin
  IBTable1.Active := False;
  IBTransaction1.Active := false;
  IBDataBase1.Connected := false;
end;

procedure TfmImpDlgIBX.btImportClick(Sender: TObject);
begin
  QImportWizard1.Execute;  
end;

procedure TfmImpDlgIBX.QImportWizard1AfterImport(Sender: TObject);
begin
  IBTable1.Refresh;
end;

procedure TfmImpDlgIBX.QImportWizard1BeforePost(Sender: TObject;
  Row: TQImportRow; var Accept: Boolean);
var
  i: integer;
begin
  if chbUseBeforePost.Checked then
    for i := 0 to Row.Count - 1 do
      if AnsiCompareText(Row[i].Value, 'Argentina') = 0 then begin
        Accept := false;
        Exit;
      end;
end;

procedure TfmImpDlgIBX.Button1Click(Sender: TObject);
var
  i, j: integer;
begin
  if (pcDestinations.ActivePage = tshDataSet) or
     (pcDestinations.ActivePage = tshDBGrid) then begin
    IBQuery1.ExecSQL;
    IBQuery1.Transaction.Commit;
    IBTable1.Open;
  end
  else if pcDestinations.ActivePage = tshListView then begin
    ListView.Items.BeginUpdate;
    try
      ListView.Items.Clear;
    finally
      ListView.Items.EndUpdate;
    end;
  end
  else if pcDestinations.ActivePage = tshStringGrid then begin
    for i := 1 to StringGrid.RowCount - 1 do
      for j := 0 to StringGrid.ColCount - 1 do
        StringGrid.Cells[j, i] := EmptyStr;
  end;
end;

procedure TfmImpDlgIBX.pcDestinationsChange(Sender: TObject);
begin
  if pcDestinations.ActivePage = tshDataSet then
    QImportWizard1.ImportDestination := qidDataSet
  else if pcDestinations.ActivePage = tshDBGrid then
    QImportWizard1.ImportDestination := qidDBGrid
  else if pcDestinations.ActivePage = tshListView then
    QImportWizard1.ImportDestination := qidListView
  else if pcDestinations.ActivePage = tshStringGrid then
    QImportWizard1.ImportDestination := qidStringGrid;
end;

procedure TfmImpDlgIBX.QImportWizard1NeedCommit(Sender: TObject);
begin
  IBTransaction1.CommitRetaining;
end;

end.
