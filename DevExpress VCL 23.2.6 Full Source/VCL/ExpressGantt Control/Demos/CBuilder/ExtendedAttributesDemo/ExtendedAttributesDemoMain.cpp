//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "ExtendedAttributesDemoMain.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "cxClasses"
#pragma link "cxContainer"
#pragma link "cxControls"
#pragma link "cxDropDownEdit"
#pragma link "cxEdit"
#pragma link "cxGraphics"
#pragma link "cxLookAndFeelPainters"
#pragma link "cxLookAndFeels"
#pragma link "cxMaskEdit"
#pragma link "cxSpinEdit"
#pragma link "cxTextEdit"
#pragma link "cxButtons"
#pragma link "cxGroupBox"
#pragma link "dxCore"
#pragma link "dxGanttControl"
#pragma link "dxGanttControlAssignments"
#pragma link "dxGanttControlCustomClasses"
#pragma link "dxGanttControlCustomSheet"
#pragma link "dxGanttControlResources"
#pragma link "dxGanttControlTasks"
#pragma link "dxGanttControlViewChart"
#pragma link "dxGanttControlViewResourceSheet"
#pragma link "dxGanttControlViewTimeline"
#pragma link "dxGanttControlExtendedAttributes"
#pragma link "dxLayoutContainer"
#pragma link "dxLayoutControl"
#pragma link "dxLayoutControlAdapters"
#pragma link "dxLayoutcxEditAdapters"
#pragma link "dxLayoutLookAndFeels"
#pragma link "dxGanttControlExtendedAttributes"
#pragma resource "*.dfm"
TExtendedAttributesDemoMainForm *ExtendedAttributesDemoMainForm;
//---------------------------------------------------------------------------
__fastcall TExtendedAttributesDemoMainForm::TExtendedAttributesDemoMainForm(TComponent* Owner)
	: TDemoBasicMainForm(Owner)
{
  GanttControl->DataModel->LoadFromFile("..\\..\\Data\\ExtendedAttributesDemo.xml");
}
//---------------------------------------------------------------------------
void __fastcall TExtendedAttributesDemoMainForm::GanttControlDataModelLoaded(TObject *Sender)
{
  CreateExtendedAttributeColumns(GanttControl->ViewChart->OptionsSheet);
  GanttControl->ViewChart->OptionsSheet->Columns->Items[0]->Visible = false;
  GanttControl->ViewChart->OptionsSheet->Columns->Items[1]->Visible = false;
  GanttControl->ViewChart->OptionsSheet->Columns->Items[3]->Visible = false;
  GanttControl->ViewChart->OptionsSheet->Columns->Items[7]->Visible = false;
  CreateExtendedAttributeColumns(GanttControl->ViewResourceSheet->OptionsSheet);
}
//---------------------------------------------------------------------------

void __fastcall TExtendedAttributesDemoMainForm::lcbAlwaysShowEditorClick(TObject *Sender)

{
	GanttControl->OptionsBehavior->AlwaysShowEditor = lcbAlwaysShowEditor->Checked;
}
//---------------------------------------------------------------------------
void __fastcall TExtendedAttributesDemoMainForm::CreateExtendedAttributeColumns(TdxGanttControlViewSheetOptions *AOptions)
{
    AOptions->Columns->Reset();
    AOptions->RetrieveMissingExtendedAttributeColumns();
    AOptions->AddExtendedAttributeColumns();

}
//---------------------------------------------------------------------------

