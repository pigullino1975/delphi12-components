//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "ImpDlgF.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "QImport3Wizard"
#pragma resource "*.dfm"
TfmImpDlg *fmImpDlg;
//---------------------------------------------------------------------------
__fastcall TfmImpDlg::TfmImpDlg(TComponent* Owner)
        : TForm(Owner)
{
}
//---------------------------------------------------------------------------

String _DATA_DIR = "data";

void __fastcall TfmImpDlg::FormCreate(TObject *Sender)
{
  String dataDir = ExtractFileDir(Application->ExeName);
  int i = 0;
  while (!DirectoryExists(Format("%s\\%s", ARRAYOFCONST((dataDir, _DATA_DIR)))) && (i < 5))
  {
    dataDir = ExtractFileDir(dataDir);
    i++;
  }
  dataDir = Format("%s\\%s", ARRAYOFCONST((dataDir, _DATA_DIR)));

  Table1->LoadFromFile(Format("%s\\%s.xml", ARRAYOFCONST((dataDir, "country_empty"))));
}
//---------------------------------------------------------------------------
void __fastcall TfmImpDlg::FormDestroy(TObject *Sender)
{
  Table1->Active = False;
}
//---------------------------------------------------------------------------
void __fastcall TfmImpDlg::btImportClick(TObject *Sender)
{
  QImportWizard1->Execute();
}
//---------------------------------------------------------------------------
void __fastcall TfmImpDlg::QImportWizard1AfterImport(TObject *Sender)
{
  Table1->Close();
  Table1->Open();
}
//---------------------------------------------------------------------------
void __fastcall TfmImpDlg::QImportWizard1BeforePost(TObject *Sender,
  TQImportRow *Row, bool &Accept)
{
  if (chbUseBeforePost->Checked)
    for (int i = 0; i <= Row->Count - 1; i++)
      if (Row->Items[i]->Value == "Argentina")
      {
        Accept = false;
        return;
      }
}
//---------------------------------------------------------------------------
void __fastcall TfmImpDlg::Button1Click(TObject *Sender)
{
  if ((pcDestinations->ActivePage == tshDataSet) ||
      (pcDestinations->ActivePage == tshDBGrid))
  {
    Table1->DisableControls();
    try
    {
      Table1->First();
      while (!Table1->Eof)
      {
        Table1->Delete();
      }
    }
    __finally
    {
      Table1->EnableControls();
    }
  }
  else if (pcDestinations->ActivePage == tshListView)
  {
    ListView->Items->BeginUpdate();
    try
    {
      ListView->Items->Clear();
    }
    __finally
    {
      ListView->Items->EndUpdate();
    }
  }
  else if (pcDestinations->ActivePage == tshStringGrid)
  {
    for (int i = 1; i <= StringGrid->RowCount - 1; i++)
      for (int j = 0; j <= StringGrid->ColCount - 1; j++)
        StringGrid->Cells[j][i] = EmptyStr;
  }
}
//---------------------------------------------------------------------------
void __fastcall TfmImpDlg::pcDestinationsChange(TObject *Sender)
{
  if (pcDestinations->ActivePage == tshDataSet)
    QImportWizard1->ImportDestination = qidDataSet;
  else if (pcDestinations->ActivePage == tshDBGrid)
    QImportWizard1->ImportDestination = qidDBGrid;
  else if (pcDestinations->ActivePage == tshListView)
    QImportWizard1->ImportDestination = qidListView;
  else if (pcDestinations->ActivePage == tshStringGrid) 
    QImportWizard1->ImportDestination = qidStringGrid;
}

