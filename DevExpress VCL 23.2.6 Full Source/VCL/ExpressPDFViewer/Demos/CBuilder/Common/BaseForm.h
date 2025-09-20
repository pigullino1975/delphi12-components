//---------------------------------------------------------------------------

#ifndef BaseFormH
#define BaseFormH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "cxClasses.hpp"
#include "cxLookAndFeels.hpp"
#include "dxShellDialogs.hpp"
#include <ComCtrls.hpp>
#include <Dialogs.hpp>
#include <Menus.hpp>
#include "cxControls.hpp"
#include "cxGraphics.hpp"
#include "cxLookAndFeelPainters.hpp"
#include "dxLayoutContainer.hpp"
#include "dxLayoutControl.hpp"
#include "dxLayoutLookAndFeels.hpp"
//---------------------------------------------------------------------------
class TfmBaseForm : public TForm
{
__published:	// IDE-managed Components
	TMainMenu *mmMain;
	TMenuItem *miFile;
	TMenuItem *miExit;
	TMenuItem *miAbout;
	TLabel *lbDescription;
	TdxLayoutControl *lcMain;
	TdxLayoutLookAndFeelList *dxLayoutLookAndFeelList1;
	TcxLookAndFeelController *cxLookAndFeelController1;
	TdxSaveFileDialog *SaveDialog;
	TdxOpenFileDialog *OpenDialog;
	void __fastcall miExitClick(TObject *Sender);
	void __fastcall miAboutClick(TObject *Sender);
	void __fastcall FormCreate(TObject *Sender);
private:	// User declarations
	TcxLookAndFeelController *FLookAndFeelController;
public:		// User declarations
	__fastcall TfmBaseForm(TComponent* Owner);
	virtual void __fastcall AddLookAndFeelMenu();
	virtual TcxLookAndFeelKind __fastcall GetDefaultLookAndFeelKind();
	virtual bool __fastcall IsNativeDefaultStyle();
	virtual void __fastcall SetDefaultLookAndFeel();
};
//---------------------------------------------------------------------------
extern PACKAGE TfmBaseForm *fmBaseForm;
//---------------------------------------------------------------------------
#endif
