unit ImpDlgFIBF;

interface

uses
  Forms, Db, fibdataset, pfibdataset, fibdatabase, pfibdatabase,
  Qimport3Wizard, Grids, DBGrids, StdCtrls, Classes, Controls, ExtCtrls,
  Qimport3, fibquery, pfibquery;

type
  TfmImpDlg = class(TForm)
    Qimport3Wizard1: TQimport3Wizard;
    Panel1: TPanel;
    btImport: TButton;
    DBGrid: TDBGrid;
    DataSource1: TDataSource;
    chbUseBeforePost: TCheckBox;
    Button1: TButton;
    pFIBDatabase1: TpFIBDatabase;
    pFIBTransaction1: TpFIBTransaction;
    pFIBDataSet1: TpFIBDataSet;
    pFIBQuery1: TpFIBQuery;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btImportClick(Sender: TObject);
    procedure Qimport3Wizard1AfterImport(Sender: TObject);
    procedure Qimport3Wizard1NeedCommit(Sender: TObject; DataSet: TDataSet);
    procedure Qimport3Wizard1BeforePost(Sender: TObject; Row: TQImportRow;
      var Accept: Boolean);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmImpDlg: TfmImpDlg;

implementation

uses SysUtils, Windows;

{$R *.DFM}

procedure TfmImpDlg.FormCreate(Sender: TObject);
begin
  pFIBDataBase1.DatabaseName := ExtractFilePath(Application.ExeName) + '..\..\data\country.gdb';
  pFIBDataBase1.Connected := true;
  pFIBTransaction1.Active := true;
  pFIBDataSet1.Active := true;
end;

procedure TfmImpDlg.FormDestroy(Sender: TObject);
begin
  pFIBDataSet1.Active := False;
  pFIBTransaction1.Active := false;
  pFIBDataBase1.Connected := false;
end;

procedure TfmImpDlg.btImportClick(Sender: TObject);
begin
  Qimport3Wizard1.Execute;
end;

procedure TfmImpDlg.Qimport3Wizard1AfterImport(Sender: TObject);
begin
  pFIBDataSet1.DisableControls;
  try
    pFIBDataSet1.CloseOpen(true);
  finally
    pFIBDataSet1.EnableControls;
  end;
end;

procedure TfmImpDlg.Qimport3Wizard1NeedCommit(Sender: TObject;
  DataSet: TDataSet);
begin
  pFIBTransaction1.CommitRetaining;
end;

procedure TfmImpDlg.Qimport3Wizard1BeforePost(Sender: TObject;
  Row: TQImportRow; var Accept: Boolean);
var
  i: integer;
begin
  if chbUseBeforePost.Checked then
    for i := 0 to Row.Count - 1 do
      if (Row[i].Name = 'NAME') and (Row[i].Value = 'Argentina') then begin
        Accept := false;
        Exit;
      end;
end;

procedure TfmImpDlg.Button1Click(Sender: TObject);
begin
  pFIBQuery1.ExecQuery;
  pFIBQuery1.Transaction.CommitRetaining;
  pFIBDataSet1.DisableControls;
  try
    pFIBDataSet1.CloseOpen(true);
  finally
    pFIBDataSet1.EnableControls;
  end;
end;

end.
