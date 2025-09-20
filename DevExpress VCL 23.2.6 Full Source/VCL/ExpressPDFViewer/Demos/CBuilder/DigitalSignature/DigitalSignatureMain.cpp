//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "DigitalSignatureMain.h"
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
#pragma resource "*.dfm"
TfrmPDFSignature *frmPDFSignature;
//---------------------------------------------------------------------------
__fastcall TfrmPDFSignature::TfrmPDFSignature(TComponent* Owner)
	: TfmBaseForm(Owner)
{
}
//---------------------------------------------------------------------------

void __fastcall TfrmPDFSignature::UpdateControls()
{
  btnApply->Enabled = (teSignatureReason->Text != "") && (teSignatureContactInfo->Text != "") &&
	(teSignatureLocation->Text != "") && (FCertificate != NULL);
  btnSignAndSave->Enabled = btnApply->Enabled;
  btnViewCertificate->Enabled = FCertificate != NULL;
  if (FCertificate != NULL) {
	lblCertificateSubject->Caption = FCertificate->Subject;
  }
  else
  {
	lblCertificateSubject->Caption = "Unassigned";
  }
};
//---------------------------------------------------------------------------
void __fastcall TfrmPDFSignature::btnLoadCertificateClick(TObject *Sender)
{
  UnicodeString APassword;
  if ((CertificateOpenDialog->Execute(Handle)) && (TdxX509CertificatePasswordDialogForm::Execute(NULL, NULL, APassword)))
  {
	LoadCertificate(CertificateOpenDialog->FileName, APassword);
	UpdateControls();
  };
}
//---------------------------------------------------------------------------
void TfrmPDFSignature::LoadDocument(const UnicodeString AFileName)
{
  dxPDFViewer1->LoadFromFile(AFileName);
  dxPDFViewer1->OptionsZoom->ZoomFactor = 60;
  Caption = "PDF Signature - " + AFileName;
};
//---------------------------------------------------------------------------
void TfrmPDFSignature::LoadCertificate(const UnicodeString ACertificateFileName, const UnicodeString APassword)
{
  if (FCertificate != NULL)
    FCertificate->Free();
  try
  {
	FCertificate = new TdxX509Certificate(ACertificateFileName, APassword);
	if (!dxX509IsUsableForDigitalSignature(FCertificate))
	{
	  ShowMessageBox("Invalid certificate", "The certificate cannot be used for the digital signature");
	  FCertificate->Free();
	};
  }
  catch (Exception &exception)
  {
	ShowMessageBox("Incorrect password", "The password for the certificate is incorrect.");
	FCertificate->Free();
  }
}
//---------------------------------------------------------------------------
void TfrmPDFSignature::ShowMessageBox(const UnicodeString ACaption, const UnicodeString AMessage)
{
  Application->MessageBox(AMessage.w_str(), ACaption.w_str(), MB_OK | MB_ICONERROR);
};
//---------------------------------------------------------------------------
void __fastcall TfrmPDFSignature::teSignatureReasonPropertiesChange(TObject *Sender)

{
  UpdateControls();
}
//---------------------------------------------------------------------------

void __fastcall TfrmPDFSignature::FormDestroy(TObject *Sender)
{
  if (FCertificate != NULL)
    FCertificate->Free();
}
//---------------------------------------------------------------------------

void __fastcall TfrmPDFSignature::FormCreate(TObject *Sender)
{
  lbDescription->Caption = "";

  CertificateOpenDialog->Filter = "Digital ID File (*.pfx)|*.PFX";
  cbSignatureImagePosition->ItemIndex = 5;

  LoadDocument("..\\..\\Data\\DigitalSignature.pdf");
  LoadCertificate("..\\..\\Data\\DigitalSignature.pfx", "dxdemo");

  UpdateControls();
}
//---------------------------------------------------------------------------
void __fastcall TfrmPDFSignature::btnViewCertificateClick(TObject *Sender)
{
  dxX509DisplayCertificate(FCertificate, 0);
}
//---------------------------------------------------------------------------
TdxRectF TfrmPDFSignature::GetImageBounds(TdxPDFDocument* ADocument, Integer APageIdex, const TSize ASize)
{
  TdxPointF APageSize = ADocument->PageInfo[APageIdex].Size;
  switch (cbSignatureImagePosition->ItemIndex) {
	case 1:  // Top Center
	  return dxRectF((APageSize.X - ASize.cx) / 2, 0, (APageSize.X + ASize.cx) / 2, ASize.cy);
	case 2:  // Top Left
	  return dxRectF(0, 0, ASize.cx, ASize.cy);
	case 3:  // Bottom Right
	  return dxRectF(APageSize.X - ASize.cx, APageSize.Y - ASize.cy, APageSize.X, APageSize.Y);
	case 4:  // Bottom Center
	  return dxRectF((APageSize.X - ASize.cx) / 2, APageSize.Y - ASize.cy, (APageSize.X + ASize.cx) / 2, APageSize.Y);
	case 5:  // Bottom Left
	  return dxRectF(0, APageSize.Y - ASize.cy, ASize.cx, APageSize.Y);
  default:
	return dxRectF(APageSize.X - ASize.cx, 0, APageSize.X, ASize.cy);
  }
}
//---------------------------------------------------------------------------
void TfrmPDFSignature::PrepareSingatureFieldInfo(TdxPDFDocument* ADocument, TdxPDFSignatureFieldInfo* AInfo)
{
	AInfo->Reason = teSignatureReason->Text;
	AInfo->Location = teSignatureLocation->Text;
	AInfo->ContactInfo = teSignatureContactInfo->Text;
	AInfo->Certificate = FCertificate;
	if (imSignatureImage->Picture != NULL)
	{
	  AInfo->Appearance->Image->Assign(imSignatureImage->Picture->Graphic);
	  AInfo->Appearance->RotationAngle = ra0;
	  AInfo->Appearance->FitMode = ifmProportionalStretch;
	  AInfo->Appearance->Bounds.PageIndex = 0;
	  AInfo->Appearance->Bounds.Rect = GetImageBounds(ADocument, AInfo->Appearance->Bounds.PageIndex, cxSize(300, 150));
	}
}
//---------------------------------------------------------------------------
void TfrmPDFSignature::SignDocument(TdxPDFDocument* ADocument, TStream* AStream)
{
  PrepareSingatureFieldInfo(ADocument, ADocument->SignatureOptions->Signature);
  ADocument->SignatureOptions->Enabled = True;
  ADocument->SaveToStream(AStream, True);
}
//---------------------------------------------------------------------------
void TfrmPDFSignature::SaveDocumentToStream(TStream* AStream)
{
  SignDocument(dxPDFViewer1->Document, AStream);
  AStream->Position = 0;
  dxPDFViewer1->LoadFromStream(AStream);
  AStream->Position = 0;
}
//---------------------------------------------------------------------------
void __fastcall TfrmPDFSignature::btnApplyClick(TObject *Sender)
{
  TMemoryStream* AStream = new TMemoryStream();
  try
  {
	SaveDocumentToStream(AStream);
  }
  __finally{
	delete AStream;
  }
}
//---------------------------------------------------------------------------

void __fastcall TfrmPDFSignature::btnSignAndSaveClick(TObject *Sender)
{
  if (SaveDialog->Execute(Handle))
  {
	TFileStream* AStream = new TFileStream(SaveDialog->FileName, fmCreate);
	try
	{
	  SaveDocumentToStream(AStream);
	}
	__finally
	{
	  delete AStream;
	}
  }
}
//---------------------------------------------------------------------------

void __fastcall TfrmPDFSignature::teSignatureLocationPropertiesChange(TObject *Sender)

{
  UpdateControls();
}
//---------------------------------------------------------------------------

void __fastcall TfrmPDFSignature::teSignatureContactInfoPropertiesChange(TObject *Sender)

{
  UpdateControls();
}
//---------------------------------------------------------------------------

