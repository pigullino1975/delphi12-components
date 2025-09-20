//---------------------------------------------------------------------------

#ifndef PageMergingMainH
#define PageMergingMainH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
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
#include <ComCtrls.hpp>
#include "dxShellDialogs.hpp"
//---------------------------------------------------------------------------
class TfrmPDFPageMerging : public TfmBaseForm
{
__published:	// IDE-managed Components
	TdxPDFViewer *dxPDFViewer1;
	TcxButton *btnOpen;
	TcxButton *btnAppend;
	TcxButton *btnSave;
	TcxButton *btnNew;
	TdxLayoutItem *dxLayoutItem1;
	TdxLayoutItem *dxLayoutItem3;
	TdxLayoutItem *dxLayoutItem4;
	TdxLayoutItem *dxLayoutItem5;
	TdxLayoutGroup *dxLayoutGroup1;
	TdxLayoutItem *dxLayoutItem2;
	void __fastcall btnNewClick(TObject *Sender);
	void __fastcall btnOpenClick(TObject *Sender);
	void __fastcall btnSaveClick(TObject *Sender);
	void __fastcall btnAppendClick(TObject *Sender);
private:	// User declarations
	void __fastcall LoadDocument(const UnicodeString AFileName);
	void __fastcall UpdateControls();
public:		// User declarations
	__fastcall TfrmPDFPageMerging(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TfrmPDFPageMerging *frmPDFPageMerging;
//---------------------------------------------------------------------------
#endif
