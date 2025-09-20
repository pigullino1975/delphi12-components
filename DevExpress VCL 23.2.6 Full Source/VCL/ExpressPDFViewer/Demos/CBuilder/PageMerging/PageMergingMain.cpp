//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "PageMergingMain.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "BaseForm"
#pragma link "cxClasses"
#pragma link "cxLookAndFeels"
#pragma link "cxButtons"
#pragma link "cxControls"
#pragma link "cxGraphics"
#pragma link "cxLookAndFeelPainters"
#pragma link "dxCustomPreview"
#pragma link "dxLayoutContainer"
#pragma link "dxLayoutControl"
#pragma link "dxLayoutControlAdapters"
#pragma link "dxLayoutLookAndFeels"
#pragma link "dxPDFBase"
#pragma link "dxPDFCore"
#pragma link "dxPDFDocument"
#pragma link "dxPDFDocumentViewer"
#pragma link "dxPDFRecognizedObject"
#pragma link "dxPDFText"
#pragma link "dxPDFViewer"
#pragma link "dxShellDialogs"
#pragma resource "*.dfm"
TfrmPDFPageMerging *frmPDFPageMerging;
//---------------------------------------------------------------------------
void __fastcall TfrmPDFPageMerging::LoadDocument(const UnicodeString AFileName)
{
  dxPDFViewer1->BeginUpdate();
  dxPDFViewer1->LoadFromFile(AFileName);
  dxPDFViewer1->OptionsZoom->ZoomFactor = 70;
  dxPDFViewer1->EndUpdate();
}
//---------------------------------------------------------------------------
__fastcall TfrmPDFPageMerging::TfrmPDFPageMerging(TComponent* Owner)
	: TfmBaseForm(Owner)
{
  LoadDocument("..\\..\\Data\\PageMerging.pdf");
}
//---------------------------------------------------------------------------

void __fastcall TfrmPDFPageMerging::UpdateControls()
{
  btnSave->Enabled = dxPDFViewer1->IsDocumentLoaded();
};

void __fastcall TfrmPDFPageMerging::btnNewClick(TObject *Sender)
{
  dxPDFViewer1->Document->Clear();
  UpdateControls();
}
//---------------------------------------------------------------------------

void __fastcall TfrmPDFPageMerging::btnOpenClick(TObject *Sender)
{
  if (OpenDialog->Execute())
	LoadDocument(OpenDialog->FileName);
  UpdateControls();
}
//---------------------------------------------------------------------------

void __fastcall TfrmPDFPageMerging::btnSaveClick(TObject *Sender)
{
  if (SaveDialog->Execute())
	dxPDFViewer1->Document->SaveToFile(SaveDialog->FileName, True);
  UpdateControls();
}
//---------------------------------------------------------------------------

void __fastcall TfrmPDFPageMerging::btnAppendClick(TObject *Sender)
{
  TdxPDFDocument *ADocument;

  if (OpenDialog->Execute())
  {
	Screen->Cursor = crHourGlass;
	ADocument =  new TdxPDFDocument();
	try
	{
	  ADocument->LoadFromFile(OpenDialog->FileName);
	  dxPDFViewer1->Document->Append(ADocument);
	}
	__finally
	{
	  ADocument->Free();
	  Screen->Cursor = crDefault;
	}
  }
  UpdateControls();
}
//---------------------------------------------------------------------------



