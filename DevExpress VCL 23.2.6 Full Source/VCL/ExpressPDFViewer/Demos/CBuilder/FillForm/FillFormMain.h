//---------------------------------------------------------------------------

#ifndef FillFormMainH
#define FillFormMainH
#include "BaseForm.h"
#include "cxButtons.hpp"
#include "cxClasses.hpp"
#include "cxContainer.hpp"
#include "cxControls.hpp"
#include "cxDropDownEdit.hpp"
#include "cxEdit.hpp"
#include "cxGraphics.hpp"
#include "cxImage.hpp"
#include "cxLabel.hpp"
#include "cxLookAndFeelPainters.hpp"
#include "cxLookAndFeels.hpp"
#include "cxMaskEdit.hpp"
#include "cxTextEdit.hpp"
#include "dxCustomPreview.hpp"
#include "dxGDIPlusClasses.hpp"
#include "dxLayoutContainer.hpp"
#include "dxLayoutControl.hpp"
#include "dxLayoutControlAdapters.hpp"
#include "dxLayoutcxEditAdapters.hpp"
#include "dxLayoutLookAndFeels.hpp"
#include "dxPDFBase.hpp"
#include "dxPDFCore.hpp"
#include "dxPDFDocument.hpp"
#include "dxPDFDocumentViewer.hpp"
#include "dxPDFRecognizedObject.hpp"
#include "dxPDFText.hpp"
#include "dxPDFViewer.hpp"
#include "dxShellDialogs.hpp"
#include <Classes.hpp>
#include <Controls.hpp>
#include <Dialogs.hpp>
#include <Menus.hpp>
#include <StdCtrls.hpp>
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <IOUtils.hpp>
#include <Forms.hpp>
#include <Dialogs.hpp>
#include "BaseForm.h"
#include "cxClasses.hpp"
#include "cxLookAndFeels.hpp"
#include <Dialogs.hpp>
#include <Menus.hpp>
#include "cxButtons.hpp"
#include "cxControls.hpp"
#include "cxGraphics.hpp"
#include "cxLookAndFeelPainters.hpp"
#include "dxCustomPreview.hpp"
#include "dxLayoutContainer.hpp"
#include "dxLayoutControl.hpp"
#include "dxLayoutControlAdapters.hpp"
#include "dxLayoutLookAndFeels.hpp"
#include "dxPDFBase.hpp"
#include "dxPDFCore.hpp"
#include "dxPDFDocument.hpp"
#include "dxPDFDocumentViewer.hpp"
#include "dxPDFRecognizedObject.hpp"
#include "dxPDFText.hpp"
#include "dxPDFViewer.hpp"
#include "dxShellDialogs.hpp"
#include "dxX509Certificate.hpp"
#include "dxX509CertificatePasswordDialog.hpp"
#include <ComCtrls.hpp>
#include "cxContainer.hpp"
#include "cxDropDownEdit.hpp"
#include "cxEdit.hpp"
#include "cxImage.hpp"
#include "cxLabel.hpp"
#include "cxMaskEdit.hpp"
#include "cxTextEdit.hpp"
#include "dxGDIPlusClasses.hpp"
#include "dxLayoutcxEditAdapters.hpp"
#include "cxCustomListBox.hpp"
#include "cxListBox.hpp"
#include "dxPDFForm.hpp"
#include "dxPDFFormData.hpp"
#include "dxPrintUtils.hpp"
#include "cxCalendar.hpp"
#include "cxDateUtils.hpp"
#include "dxCore.hpp"
#include "dxBarBuiltInMenu.hpp"
//---------------------------------------------------------------------------
class TfrmPDFFillForm : public TfmBaseForm
{
__published:	// IDE-managed Components
	TdxPDFViewer *dxPDFViewer1;
	TdxLayoutItem *dxLayoutItem1;
	TdxLayoutGroup *dxLayoutGroup1;
	TdxLayoutItem *dxLayoutItem2;
	TcxTextEdit *teFirstName;
	TdxLayoutItem *dxLayoutItem3;
	TcxTextEdit *teLastName;
	TdxLayoutItem *dxLayoutItem4;
	TcxDateEdit *deDateOfBirth;
	TdxLayoutItem *dxLayoutItem5;
	TcxTextEdit *tePassportNo;
	TdxLayoutItem *dxLayoutItem6;
	TcxComboBox *cbNationality;
	TdxLayoutItem *dxLayoutItem7;
	TcxTextEdit *teAddress;
	TdxLayoutItem *dxLayoutItem8;
	TcxTextEdit *teVisaNo;
	TdxLayoutItem *dxLayoutItem9;
	TcxTextEdit *teFlightNo;
	TdxLayoutRadioButtonItem *rbtMale;
	TdxLayoutRadioButtonItem *rbtFemale;
	TdxLayoutItem *dxLayoutItem10;
	TcxButton *btnSubmit;
	TdxLayoutItem *dxLayoutItem11;
	TcxButton *btnReset;
	void __fastcall btnResetClick(TObject *Sender);
	void __fastcall btnSubmitClick(TObject *Sender);
	void __fastcall SaveAs1Click(TObject *Sender);
private:	// User declarations
    void __fastcall UpdateControls();
public:		// User declarations
	TdxPDFDocument* FDocument;
	__fastcall TfrmPDFFillForm(TComponent* Owner);
	void __fastcall AfterConstruction();
	void LoadDocument(const UnicodeString AFileName);
	void LoadNationalityItems();
	void SetTextValue(const UnicodeString AFieldName, const UnicodeString AValue);
	void ResetForm();
};
//---------------------------------------------------------------------------
extern PACKAGE TfrmPDFFillForm *frmPDFFillForm;
//---------------------------------------------------------------------------
#endif
