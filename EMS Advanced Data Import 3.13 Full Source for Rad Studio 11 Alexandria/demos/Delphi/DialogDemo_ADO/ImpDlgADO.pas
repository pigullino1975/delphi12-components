unit ImpDlgADO;

interface

uses
  Forms, Db, Qimport3Wizard, Grids, DBGrids, StdCtrls, Classes,
  Controls, ExtCtrls, Qimport3, Qimport3Common, ComCtrls, Graphics, ADODB;

type
  TImpDlgADO = class(TForm)
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
    Table1: TADOTable;
    cmd1: TADOCommand;
    cnn1: TADOConnection;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btImportClick(Sender: TObject);
    procedure QImportWizard1AfterImport(Sender: TObject);
    procedure QImportWizard1BeforePost(Sender: TObject; Row: TQImportRow;
      var Accept: Boolean);
    procedure Button1Click(Sender: TObject);
    procedure pcDestinationsChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fImpDlgADO: TImpDlgADO;

implementation

uses SysUtils, Windows;

{$R *.DFM}

procedure TImpDlgADO.FormCreate(Sender: TObject);
var
  i: Integer;
  dbDir: string;
begin
  cnn1.Connected := False;

  i := 0;
  dbDir := ExtractFileDir(Application.ExeName);
  while (not FileExists(dbDir + '\demo.mdb')) and (i < 3) do
  begin
    dbDir := ExtractFileDir(dbDir);
    Inc(i);
  end;
  cnn1.ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0;Password="";Data Source=' +
    dbDir + '\demo.mdb;Persist Security Info=True';

  cnn1.Connected := True;
  Table1.Active := True;

  StringGrid.Cells[0, 0] := 'Name of Country';
  StringGrid.Cells[1, 0] := 'Capital of Country';
  StringGrid.Cells[2, 0] := 'Continent of Country';
  StringGrid.Cells[3, 0] := 'Area of Country';
  StringGrid.Cells[4, 0] := 'Population of Country';
end;

procedure TImpDlgADO.FormDestroy(Sender: TObject);
begin
  Table1.Active := False;
  cnn1.Connected := False;
end;

procedure TImpDlgADO.btImportClick(Sender: TObject);
begin
  QImportWizard1.Execute;
end;

procedure TImpDlgADO.QImportWizard1AfterImport(Sender: TObject);
begin
  Table1.Close;
  cnn1.Connected := False;
  cnn1.Connected := True;
  Table1.Open;
end;

procedure TImpDlgADO.QImportWizard1BeforePost(Sender: TObject;
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

procedure TImpDlgADO.Button1Click(Sender: TObject);
var
  i, j: integer;
begin
  if (pcDestinations.ActivePage = tshDataSet) or
     (pcDestinations.ActivePage = tshDBGrid) then begin
   Table1.Close;
   try
     cmd1.CommandText := 'delete * from '+Table1.TableName;
     cmd1.Execute;
   finally
     Table1.Open;
   end;
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

procedure TImpDlgADO.pcDestinationsChange(Sender: TObject);
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

end.
