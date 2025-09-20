//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "FileAttachmentMain.h"
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
#pragma link "dxX509Certificate"
#pragma link "dxX509CertificatePasswordDialog"
#pragma link "dxPDFViewer"
#pragma link "cxContainer"
#pragma link "cxDropDownEdit"
#pragma link "cxEdit"
#pragma link "cxImage"
#pragma link "cxLabel"
#pragma link "cxMaskEdit"
#pragma link "cxTextEdit"
#pragma link "dxGDIPlusClasses"
#pragma link "dxLayoutcxEditAdapters"
#pragma link "BaseForm"
#pragma link "cxButtons"
#pragma link "cxClasses"
#pragma link "cxContainer"
#pragma link "cxControls"
#pragma link "cxDropDownEdit"
#pragma link "cxEdit"
#pragma link "cxGraphics"
#pragma link "cxImage"
#pragma link "cxLabel"
#pragma link "cxLookAndFeelPainters"
#pragma link "cxLookAndFeels"
#pragma link "cxMaskEdit"
#pragma link "cxTextEdit"
#pragma link "dxCustomPreview"
#pragma link "dxGDIPlusClasses"
#pragma link "dxLayoutContainer"
#pragma link "dxLayoutControl"
#pragma link "dxLayoutControlAdapters"
#pragma link "dxLayoutcxEditAdapters"
#pragma link "dxLayoutLookAndFeels"
#pragma link "dxPDFBase"
#pragma link "dxPDFCore"
#pragma link "dxPDFDocument"
#pragma link "dxPDFDocumentViewer"
#pragma link "dxPDFRecognizedObject"
#pragma link "dxPDFText"
#pragma link "dxPDFViewer"
#pragma link "dxShellDialogs"
#pragma link "cxCustomListBox"
#pragma link "cxListBox"
#pragma resource "*.dfm"
TfrmPDFFileAttachment *frmPDFFileAttachment;
//---------------------------------------------------------------------------
__fastcall TfrmPDFFileAttachment::TfrmPDFFileAttachment(TComponent* Owner)
	: TfmBaseForm(Owner)
{
  LoadDocument("..\\..\\Data\\FileAttachment.pdf");
  Attach("..\\..\\Data\\DevExpress.png");
  OpenDialog->Filter = "";
  UpdateControls();
}
//---------------------------------------------------------------------------
void TfrmPDFFileAttachment::Attach(const UnicodeString AFileName)
{
  TdxPDFFileAttachment *AAttachment;
  dxPDFViewer1->Document->BeginUpdate();
  AAttachment = dxPDFViewer1->Document->FileAttachments->Add();
  AAttachment->LoadFromFile(AFileName);
  AAttachment->Description = "Description";
  dxPDFViewer1->Document->EndUpdate();
  lbAttachments->Items->Add(TPath::GetFileName(AFileName));
}
//---------------------------------------------------------------------------
void TfrmPDFFileAttachment::LoadDocument(const UnicodeString AFileName)
{
	dxPDFViewer1->BeginUpdate();
	dxPDFViewer1->LoadFromFile(AFileName);
	dxPDFViewer1->OptionsNavigationPane->Attachments->Visible = bTrue;
	dxPDFViewer1->OptionsNavigationPane->Bookmarks->Visible = bFalse;
	dxPDFViewer1->OptionsNavigationPane->Thumbnails->Visible = bFalse;
	dxPDFViewer1->OptionsNavigationPane->Visible = True;
	dxPDFViewer1->OptionsZoom->ZoomFactor = 55;
	dxPDFViewer1->EndUpdate();
    Caption = "PDF File Attachment - " + AFileName;
};
//---------------------------------------------------------------------------
void __fastcall TfrmPDFFileAttachment::UpdateControls()
{
  btnDetachSeleted->Enabled = lbAttachments->SelCount > 0;
};
//---------------------------------------------------------------------------
void __fastcall TfrmPDFFileAttachment::btnAttachFileClick(TObject *Sender)
{
  if (OpenDialog->Execute(NULL))
  {
	dxPDFViewer1->BeginUpdate();
	for (int I = 0; I < OpenDialog->Files->Count; I++)
	  Attach(OpenDialog->Files->Strings[I]);
	dxPDFViewer1->EndUpdate();
  }
}
//---------------------------------------------------------------------------
void TfrmPDFFileAttachment::Detach(const UnicodeString AFileName)
{
  TdxPDFFileAttachment *AAttachment;
  for (int I = 0; I < dxPDFViewer1->Document->FileAttachments->Count; I++) {
	if (SameText(dxPDFViewer1->Document->FileAttachments->Items[I]->FileName, AFileName))
	  dxPDFViewer1->Document->FileAttachments->Remove(dxPDFViewer1->Document->FileAttachments->Items[I]);
  }
}
//---------------------------------------------------------------------------
void __fastcall TfrmPDFFileAttachment::btnDetachSeletedClick(TObject *Sender)
{
  dxPDFViewer1->Document->BeginUpdate();
  try
  {
	for (int I = 0; I < lbAttachments->Items->Count; I++)
	  if (lbAttachments->Selected[I])
		Detach(lbAttachments->Items->Strings[I]);
	lbAttachments->DeleteSelected();
  }
  __finally
  {
	dxPDFViewer1->Document->EndUpdate();
  }
}
//---------------------------------------------------------------------------

void __fastcall TfrmPDFFileAttachment::lbAttachmentsClick(TObject *Sender)
{
  UpdateControls();
}
//---------------------------------------------------------------------------

void __fastcall TfrmPDFFileAttachment::FormShow(TObject *Sender)
{
  OpenDialog->Filter = "";
}
//---------------------------------------------------------------------------

