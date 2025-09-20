//---------------------------------------------------------------------------

#ifndef BaselinesDemoMainH
#define BaselinesDemoMainH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "DemoBasicMain.h"
#include "cxClasses.hpp"
#include "cxContainer.hpp"
#include "cxControls.hpp"
#include "cxDropDownEdit.hpp"
#include "cxEdit.hpp"
#include "cxGraphics.hpp"
#include "cxLookAndFeelPainters.hpp"
#include "cxLookAndFeels.hpp"
#include "cxMaskEdit.hpp"
#include "cxSpinEdit.hpp"
#include "cxTextEdit.hpp"
#include "cxButtons.hpp"
#include "cxGroupBox.hpp"
#include "dxCore.hpp"
#include "dxGanttControl.hpp"
#include "dxGanttControlAssignments.hpp"
#include "dxGanttControlCustomClasses.hpp"
#include "dxGanttControlCustomSheet.hpp"
#include "dxGanttControlResources.hpp"
#include "dxGanttControlTasks.hpp"
#include "dxGanttControlViewChart.hpp"
#include "dxGanttControlViewResourceSheet.hpp"
#include "dxGanttControlViewTimeline.hpp"
#include "dxLayoutContainer.hpp"
#include "dxLayoutControl.hpp"
#include "dxLayoutControlAdapters.hpp"
#include "dxLayoutcxEditAdapters.hpp"
#include "dxLayoutLookAndFeels.hpp"
#include <Dialogs.hpp>
#include <Menus.hpp>
#include <Dialogs.hpp>
#include <Menus.hpp>
#include "cxImageList.hpp"
#include "dxShellDialogs.hpp"
#include <ActnList.hpp>
#include <ImgList.hpp>
//---------------------------------------------------------------------------
class TBaselinesDemoMainForm : public TDemoBasicMainForm
{
__published:	// IDE-managed Components
	TdxLayoutGroup *dxLayoutGroup9;
    	TcxComboBox *cbBaseline;
    	TdxLayoutItem *dxLayoutItem8;
    	TdxLayoutItem *dxLayoutItem9;
    	TcxComboBox *cbSetBaseline;
    	TdxLayoutCheckBoxItem *lcbiSelectedTasks;
    	TcxButton *cxButton3;
    	TdxLayoutItem *dxLayoutItem10;
    	TcxButton *cxButton4;
    	TdxLayoutItem *dxLayoutItem11;
    	TdxLayoutAutoCreatedGroup *dxLayoutAutoCreatedGroup1;
	void __fastcall GanttControlDataModelLoaded(TObject *Sender);
	void __fastcall GanttControlBaselineChanged(TObject *Sender, TdxGanttControlDataModelBaseline *ABaseline);
	void __fastcall GanttControlViewChartBaselineNumberChanged(TObject *Sender);
	void __fastcall cbBaselinePropertiesEditValueChanged(TObject *Sender);
	void __fastcall cxButton3Click(TObject *Sender);
	void __fastcall cxButton4Click(TObject *Sender);

private:	// User declarations
	int FLockCount;
	UnicodeString __fastcall BaselineToText(TdxGanttControlDataModelBaseline *ABaseline);
	void __fastcall UpdateBaselineList();
public:		// User declarations
	__fastcall TBaselinesDemoMainForm(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TBaselinesDemoMainForm *BaselinesDemoMainForm;
//---------------------------------------------------------------------------
#endif
