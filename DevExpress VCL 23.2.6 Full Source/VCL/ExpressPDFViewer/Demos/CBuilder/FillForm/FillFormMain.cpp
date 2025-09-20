//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "FillFormMain.h"
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
#pragma link "dxPDFForm"
#pragma link "dxPDFFormData"
#pragma link "dxPrintUtils"
#pragma link "cxCalendar"
#pragma link "cxDateUtils"
#pragma link "dxCore"
#pragma resource "*.dfm"
TfrmPDFFillForm *frmPDFFillForm;
//---------------------------------------------------------------------------
__fastcall TfrmPDFFillForm::TfrmPDFFillForm(TComponent* Owner)
	: TfmBaseForm(Owner)
{

}
//---------------------------------------------------------------------------
void __fastcall TfrmPDFFillForm::AfterConstruction()
{
  TfmBaseForm::AfterConstruction();
  LoadDocument("..\\..\\Data\\FormDemo.pdf");
  LoadNationalityItems();
  ResetForm();
}
//---------------------------------------------------------------------------
void TfrmPDFFillForm::LoadNationalityItems()
{
  TdxPDFComboBoxField* AComboBoxField;
  if (!FDocument->Form->TryGetComboBoxField("Nationality", AComboBoxField))
	return;
  cbNationality->Properties->BeginUpdate();
  for (int i = 0; i < AComboBoxField->ItemCount; i++)
	cbNationality->Properties->Items->Add(AComboBoxField->Items[i].Value);
	cbNationality->ItemIndex = AComboBoxField->ItemIndex;
  cbNationality->Properties->EndUpdate();
}
//---------------------------------------------------------------------------
void TfrmPDFFillForm::ResetForm()
{
  FDocument->Form->Reset();
  btnReset->Enabled = false;
}
//---------------------------------------------------------------------------
void TfrmPDFFillForm::LoadDocument(const UnicodeString AFileName)
{
  dxPDFViewer1->BeginUpdate();
  dxPDFViewer1->LoadFromFile(AFileName);
  dxPDFViewer1->OptionsZoom->ZoomMode = pzmPageWidth;
  dxPDFViewer1->EndUpdate();
  FDocument = dxPDFViewer1->Document;
  Caption = "Fill PDF Form - " + AFileName;
  Width = 1005;
};
//---------------------------------------------------------------------------
void TfrmPDFFillForm::SetTextValue(const UnicodeString AFieldName, const UnicodeString AValue)
{
  TdxPDFTextField* AField;
  if (FDocument->Form->TryGetTextField(AFieldName, AField))
	AField->Text = AValue;
}
//---------------------------------------------------------------------------
void __fastcall TfrmPDFFillForm::UpdateControls()
{

};
//---------------------------------------------------------------------------
void __fastcall TfrmPDFFillForm::btnResetClick(TObject *Sender)
{
  ResetForm();
}
//---------------------------------------------------------------------------
void __fastcall TfrmPDFFillForm::btnSubmitClick(TObject *Sender)
{
  TdxPDFForm* AForm = FDocument->Form;

  FDocument->BeginUpdate();
  try
  {
	SetTextValue("FirstName", teFirstName->Text);
	SetTextValue("LastName", teLastName->Text);
	SetTextValue("PassportNo", tePassportNo->Text);
	SetTextValue("Address", teAddress->Text);
	SetTextValue("VisaNo", teVisaNo->Text);
	SetTextValue("FlightNo", teFlightNo->Text);

	TDateTime ADate = deDateOfBirth->Date;
	SetTextValue("DD", IntToStr(DayOf(ADate)));
	SetTextValue("MM", IntToStr(MonthOf(ADate)));
	SetTextValue("YYYY", IntToStr(YearOf(ADate)));

	TdxPDFRadioGroupField* ARadioGroupField;
	if (AForm->TryGetRadioGroupField("Gender", ARadioGroupField))
	  ARadioGroupField->ItemIndex = IfThen(rbtFemale->Checked, 1);

	TdxPDFComboBoxField* AComboBoxField;
	if (AForm->TryGetComboBoxField("Nationality", AComboBoxField))
	  AComboBoxField->ItemIndex = cbNationality->ItemIndex;
  }
  __finally
  {
	FDocument->EndUpdate();
  }
  btnReset->Enabled = true;
}
//---------------------------------------------------------------------------

void __fastcall TfrmPDFFillForm::SaveAs1Click(TObject *Sender)
{
  if (SaveDialog->Execute(Handle))
	FDocument->SaveToFile(SaveDialog->FileName, True);
}
//---------------------------------------------------------------------------

