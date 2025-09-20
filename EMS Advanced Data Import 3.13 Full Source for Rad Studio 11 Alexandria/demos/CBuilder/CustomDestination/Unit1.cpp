//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "Unit1.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "QImport3"
#pragma link "QImport3XLS"
#pragma resource "*.dfm"
TForm1 *Form1;
String arCountry[5][18];
//---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
        : TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TForm1::FormCreate(TObject *Sender)
{
  int i = 0;
  String dbDir = ExtractFileDir(Application->ExeName);
  while (!(FileExists(dbDir + "\\data\\country.xls")) && (i < 4))
  {
    dbDir = ExtractFileDir(dbDir);
    i++;
  }
  QImportXLS1->FileName = dbDir + "\\data\\country.xls";
  StringGrid1->Cells[0][0] = "Name";
  StringGrid1->Cells[1][0] = "Capital";
  StringGrid1->Cells[2][0] = "Continent";
  StringGrid1->Cells[3][0] = "Area";
  StringGrid1->Cells[4][0] = "Population";

  StringGrid1->ColWidths[0] = 125;
  StringGrid1->ColWidths[1] = 70;
  StringGrid1->ColWidths[2] = 80;
}
//---------------------------------------------------------------------------
void __fastcall TForm1::QImportXLS1BeforeImport(TObject *Sender)
{
  for (int i = 0; i <= 4; i++)
    for (int j = 0; j <= 17; j++)
      arCountry[i][j] = EmptyStr;
  FCounter = 0;
}
//---------------------------------------------------------------------------
void __fastcall TForm1::QImportXLS1UserDefinedImport(TObject *Sender,
  TQImportRow *Row)
{
  for (int i = 0; i <= Row->Count - 1; i++)
    arCountry[i][FCounter] = Row->Items[i]->Value;
  FCounter++;
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Button1Click(TObject *Sender)
{
  QImportXLS1->Execute();
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Button2Click(TObject *Sender)
{
  for (int i = 0; i <= 4; i++)
    for (int j = 1; j <= 18; j++)
      StringGrid1->Cells[i][j] = EmptyStr;
}
//---------------------------------------------------------------------------
void __fastcall TForm1::QImportXLS1AfterImport(TObject *Sender)
{
  for (int i = 0; i <= 4; i++)
    for (int j = 0; j <= 17; j++)
      StringGrid1->Cells[i][j + 1] = arCountry[i][j];
}