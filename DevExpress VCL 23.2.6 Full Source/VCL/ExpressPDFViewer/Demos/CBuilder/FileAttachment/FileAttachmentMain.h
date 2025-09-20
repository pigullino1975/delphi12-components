//---------------------------------------------------------------------------

#ifndef FileAttachmentMainH
#define FileAttachmentMainH
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
//---------------------------------------------------------------------------
class TfrmPDFFileAttachment : public TfmBaseForm
{
__published:	// IDE-managed Components
	TdxPDFViewer *dxPDFViewer1;
	TdxLayoutItem *dxLayoutItem1;
	TdxLayoutGroup *dxLayoutGroup1;
	TdxLayoutItem *dxLayoutItem2;
	TcxButton *btnAttachFile;
	TdxLayoutItem *dxLayoutItem3;
	TcxListBox *lbAttachments;
	TcxButton *btnDetachSeleted;
	void __fastcall btnAttachFileClick(TObject *Sender);
	void __fastcall btnDetachSeletedClick(TObject *Sender);
	void __fastcall lbAttachmentsClick(TObject *Sender);
	void __fastcall FormShow(TObject *Sender);
private:	// User declarations
    void __fastcall UpdateControls();
public:		// User declarations
	__fastcall TfrmPDFFileAttachment(TComponent* Owner);
	void LoadDocument(const UnicodeString AFileName);
	void Attach(const UnicodeString AFileName);
	void Detach(const UnicodeString AFileName);
};
//---------------------------------------------------------------------------
extern PACKAGE TfrmPDFFileAttachment *frmPDFFileAttachment;
//---------------------------------------------------------------------------
#endif
