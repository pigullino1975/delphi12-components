//---------------------------------------------------------------------------

#ifndef ExtendedAttributesDemoMainH
#define ExtendedAttributesDemoMainH
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
#include "dxGanttControlExtendedAttributes.hpp"
#include "dxLayoutContainer.hpp"
#include "dxLayoutControl.hpp"
#include "dxLayoutControlAdapters.hpp"
#include "dxLayoutcxEditAdapters.hpp"
#include "dxLayoutLookAndFeels.hpp"
#include "dxGanttControlExtendedAttributes.hpp"
#include <Dialogs.hpp>
#include <Menus.hpp>
#include <Dialogs.hpp>
#include <Menus.hpp>
//---------------------------------------------------------------------------
class TExtendedAttributesDemoMainForm : public TDemoBasicMainForm
{
__published:	// IDE-managed Components
	TdxLayoutCheckBoxItem *lcbAlwaysShowEditor;
	void __fastcall lcbAlwaysShowEditorClick(TObject *Sender);
	void __fastcall GanttControlDataModelLoaded(TObject *Sender);
private:	// User declarations
	void __fastcall CreateExtendedAttributeColumns(TdxGanttControlViewSheetOptions *AOptions);
public:		// User declarations
	__fastcall TExtendedAttributesDemoMainForm(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TExtendedAttributesDemoMainForm *ExtendedAttributesDemoMainForm;
//---------------------------------------------------------------------------
#endif
