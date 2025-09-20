//---------------------------------------------------------------------------

#ifndef DigitalSignatureMainH
#define DigitalSignatureMainH
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
//---------------------------------------------------------------------------
class TfrmPDFSignature : public TfmBaseForm
{
__published:	// IDE-managed Components
	TdxPDFViewer *dxPDFViewer1;
	TcxButton *btnLoadCertificate;
	TcxTextEdit *teSignatureReason;
	TcxTextEdit *teSignatureLocation;
	TcxTextEdit *teSignatureContactInfo;
	TcxImage *imSignatureImage;
	TcxButton *btnApply;
	TcxButton *btnViewCertificate;
	TcxLabel *lblCertificateSubject;
	TcxComboBox *cbSignatureImagePosition;
	TcxButton *btnSignAndSave;
	TdxLayoutItem *dxLayoutItem1;
	TdxLayoutGroup *dxLayoutGroup1;
	TdxLayoutItem *liLoadCertificate;
	TdxLayoutItem *liSignatureReason;
	TdxLayoutItem *liSignatureLocation;
	TdxLayoutItem *liSignatureContactInfo;
	TdxLayoutItem *liSignatureImage;
	TdxLayoutItem *dxLayoutItem2;
	TdxLayoutItem *dxLayoutItem3;
	TdxLayoutItem *liCertificateSubject;
	TdxLayoutGroup *dxLayoutGroup2;
	TdxLayoutGroup *dxLayoutGroup3;
	TdxLayoutGroup *dxLayoutGroup4;
	TdxLayoutItem *dxLayoutItem4;
	TdxLayoutGroup *dxLayoutGroup5;
	TdxLayoutItem *dxLayoutItem5;
	TdxLayoutAutoCreatedGroup *dxLayoutAutoCreatedGroup2;
	TdxLayoutAutoCreatedGroup *dxLayoutAutoCreatedGroup1;
	TdxOpenFileDialog *CertificateOpenDialog;
	void __fastcall btnLoadCertificateClick(TObject *Sender);
	void __fastcall teSignatureReasonPropertiesChange(TObject *Sender);
	void __fastcall FormDestroy(TObject *Sender);
	void __fastcall FormCreate(TObject *Sender);
	void __fastcall btnViewCertificateClick(TObject *Sender);
	void __fastcall btnApplyClick(TObject *Sender);
	void __fastcall btnSignAndSaveClick(TObject *Sender);
	void __fastcall teSignatureLocationPropertiesChange(TObject *Sender);
	void __fastcall teSignatureContactInfoPropertiesChange(TObject *Sender);
private:	// User declarations
    void __fastcall UpdateControls();
public:		// User declarations
	TdxX509Certificate* FCertificate;
	__fastcall TfrmPDFSignature(TComponent* Owner);

	TdxRectF GetImageBounds(TdxPDFDocument* ADocument, Integer APageIdex, const TSize ASize);
	void LoadDocument(const UnicodeString AFileName);
	void LoadCertificate(const UnicodeString ACertificateFileName, const UnicodeString APassword);
	void SaveDocumentToStream(TStream* AStream);
	void SignDocument(TdxPDFDocument* ADocument, TStream* AStream);
	void PrepareSingatureFieldInfo(TdxPDFDocument* ADocument, TdxPDFSignatureFieldInfo* AInfo);
	void ShowMessageBox(const UnicodeString ACaption, const UnicodeString AMessage);
};
//---------------------------------------------------------------------------
extern PACKAGE TfrmPDFSignature *frmPDFSignature;
//---------------------------------------------------------------------------
#endif
