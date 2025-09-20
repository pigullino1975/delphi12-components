unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Qimport3, Qimport3XLS, Grids, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    StringGrid1: TStringGrid;
    QImportXLS1: TQimport3XLS;
    Button2: TButton;
    procedure QImportXLS1UserDefinedImport(Sender: TObject;
      Row: TQImportRow);
    procedure QImportXLS1BeforeImport(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure QImportXLS1AfterImport(Sender: TObject);
  private
    FCounter: integer;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

var
  arCountry: array[0..4, 0..17] of string;

procedure TForm1.FormCreate(Sender: TObject);
var
  i: Integer;
  dbDir: string;
begin
  i := 0;
  dbDir := ExtractFileDir(Application.ExeName);
  while (not FileExists(dbDir + '\data\country.xls')) and (i < 4) do
  begin
    dbDir := ExtractFileDir(dbDir);
    Inc(i);
  end;
  QImportXLS1.FileName := dbDir + '\data\country.xls';
  StringGrid1.Cells[0, 0] := 'Name';
  StringGrid1.Cells[1, 0] := 'Capital';
  StringGrid1.Cells[2, 0] := 'Continent';
  StringGrid1.Cells[3, 0] := 'Area';
  StringGrid1.Cells[4, 0] := 'Population';

  StringGrid1.ColWidths[0] := 125;
  StringGrid1.ColWidths[1] := 70;
  StringGrid1.ColWidths[2] := 80;
end;

procedure TForm1.QImportXLS1BeforeImport(Sender: TObject);
var
  i, j: integer;
begin
  for i := 0 to 4 do
    for j := 0 to 17 do
      arCountry[i, j] := EmptyStr;
  FCounter := 0;
end;

procedure TForm1.QImportXLS1UserDefinedImport(Sender: TObject;
  Row: TQImportRow);
var
  i: integer;
begin
  for i := 0 to Row.Count - 1 do
    arCountry[i, FCounter] := Row[i].Value;
  Inc(FCounter);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  QImportXLS1.Execute;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  i, j: integer;
begin
  for i := 0 to 4 do
    for j := 1 to 18 do
      StringGrid1.Cells[i, j] := EmptyStr;
end;

procedure TForm1.QImportXLS1AfterImport(Sender: TObject);
var
  i, j: integer;
begin
  for i := 0 to 4 do
    for j := 0 to 17 do 
      StringGrid1.Cells[i, j + 1] := arCountry[i, j];
end;

end.
