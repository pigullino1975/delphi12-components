unit ImpDlgF;

interface

uses
{$IF CompilerVersion >= 21}
  MidasLib,
{$IFEND}
  Forms, Db, Qimport3Wizard, Grids, DBGrids, StdCtrls, Classes,
  Controls, ExtCtrls, Qimport3, Qimport3Common, ComCtrls, Graphics, Windows, DBClient, SysUtils;

type
  TfmImpDlg = class(TForm)
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
    Table1: TClientDataSet;
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
  fmImpDlg: TfmImpDlg;

implementation

{$R *.DFM}

const
  _DATA_DIR = 'data';

procedure TfmImpDlg.FormCreate(Sender: TObject);
var
  dataDir: string;
  i: Integer;
begin
  dataDir := ExtractFileDir(Application.ExeName);
  i := 0;
  while not DirectoryExists(Format('%s\%s', [dataDir, _DATA_DIR])) and (i < 5) do
  begin
    dataDir := ExtractFileDir(dataDir);
    Inc(i);
  end;
  dataDir := Format('%s\%s', [dataDir, _DATA_DIR]);
  Table1.LoadFromFile(Format('%s\%s.xml', [dataDir, 'country_empty']));

  StringGrid.Cells[0, 0] := 'Name of Country';
  StringGrid.Cells[1, 0] := 'Capital of Country';
  StringGrid.Cells[2, 0] := 'Continent of Country';
  StringGrid.Cells[3, 0] := 'Area of Country';
  StringGrid.Cells[4, 0] := 'Population of Country';
end;

procedure TfmImpDlg.FormDestroy(Sender: TObject);
begin
  Table1.Active := False;
end;

procedure TfmImpDlg.btImportClick(Sender: TObject);
begin
  QImportWizard1.Execute;  
end;

procedure TfmImpDlg.QImportWizard1AfterImport(Sender: TObject);
begin
  Table1.Close;
  Table1.Open;
end;

procedure TfmImpDlg.QImportWizard1BeforePost(Sender: TObject;
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

procedure TfmImpDlg.Button1Click(Sender: TObject);
var
  i, j: integer;
begin
  if (pcDestinations.ActivePage = tshDataSet) or (pcDestinations.ActivePage = tshDBGrid) then
  begin
    Table1.DisableControls;
    try
      Table1.First;
      while not Table1.Eof do
        Table1.Delete;
    finally
      Table1.EnableControls;
    end;
  end
  else if pcDestinations.ActivePage = tshListView then
  begin
    ListView.Items.BeginUpdate;
    try
      ListView.Items.Clear;
    finally
      ListView.Items.EndUpdate;
    end;
  end
  else
    if pcDestinations.ActivePage = tshStringGrid then
    begin
      for i := 1 to StringGrid.RowCount - 1 do
        for j := 0 to StringGrid.ColCount - 1 do
          StringGrid.Cells[j, i] := EmptyStr;
      StringGrid.RowCount := 2;
    end;
end;

procedure TfmImpDlg.pcDestinationsChange(Sender: TObject);
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
