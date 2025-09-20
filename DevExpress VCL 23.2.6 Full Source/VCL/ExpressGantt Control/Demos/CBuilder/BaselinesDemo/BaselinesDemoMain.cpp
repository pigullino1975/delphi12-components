//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "BaselinesDemoMain.h"
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
#pragma link "dxLayoutContainer"
#pragma link "dxLayoutControl"
#pragma link "dxLayoutControlAdapters"
#pragma link "dxLayoutcxEditAdapters"
#pragma link "dxLayoutLookAndFeels"
#pragma link "cxImageList"
#pragma link "dxShellDialogs"
#pragma resource "*.dfm"
TBaselinesDemoMainForm *BaselinesDemoMainForm;
//---------------------------------------------------------------------------
__fastcall TBaselinesDemoMainForm::TBaselinesDemoMainForm(TComponent* Owner)
	: TDemoBasicMainForm(Owner)
{
  GanttControl->DataModel->LoadFromFile("..\\..\\Data\\SoftDev-Baselines.xml");
}
//---------------------------------------------------------------------------
void __fastcall TBaselinesDemoMainForm::GanttControlDataModelLoaded(TObject *Sender)
{
  UpdateBaselineList();
  cbBaseline->ItemIndex = 0;
  cbSetBaseline->ItemIndex = 0;
}
//---------------------------------------------------------------------------

void __fastcall TBaselinesDemoMainForm::GanttControlBaselineChanged(TObject *Sender,
		  TdxGanttControlDataModelBaseline *ABaseline)
{
  UpdateBaselineList();
}
//---------------------------------------------------------------------------

void __fastcall TBaselinesDemoMainForm::UpdateBaselineList()
{
  FLockCount++;
  cbBaseline->ActiveProperties->BeginUpdate();
  cbSetBaseline->ActiveProperties->BeginUpdate();
  try {
  	TdxGanttControlDataModelBaseline *ABaseline;
	if (GanttControl->ViewChart->BaselineNumber < 0)
	  ABaseline = NULL;
	else
	  ABaseline = GanttControl->DataModel->Baselines->Find(GanttControl->ViewChart->BaselineNumber);
	int ASetBaselineIndex = cbSetBaseline->ItemIndex;
	cbBaseline->ActiveProperties->Items->Clear();
	cbSetBaseline->ActiveProperties->Items->Clear();
	cbSetBaseline->ActiveProperties->Items->Add("Baseline");
	for (int I = 1; I <= 10; I++)
	  cbSetBaseline->ActiveProperties->Items->Add("Baseline " + IntToStr(I));
	cbBaseline->ActiveProperties->Items->Add("None");
	for (int I = 0; I < GanttControl->DataModel->Baselines->Count; I++) {
	  UnicodeString AText = BaselineToText(GanttControl->DataModel->Baselines->Items[I]);
	  cbBaseline->ActiveProperties->Items->AddObject(AText, GanttControl->DataModel->Baselines->Items[I]);
	  if (GanttControl->DataModel->Baselines->Items[I]->Number <= 10) {
		cbSetBaseline->ActiveProperties->Items->Strings[GanttControl->DataModel->Baselines->Items[I]->Number] = AText;
		cbSetBaseline->ActiveProperties->Items->Objects[GanttControl->DataModel->Baselines->Items[I]->Number] = GanttControl->DataModel->Baselines->Items[I];
	  }
	}
	int I = cbBaseline->ActiveProperties->Items->IndexOfObject(ABaseline);
	cbBaseline->ItemIndex = Max(0, I);
	cbSetBaseline->ItemIndex = ASetBaselineIndex;
  } __finally {
	cbSetBaseline->ActiveProperties->EndUpdate();
	cbBaseline->ActiveProperties->EndUpdate();
	FLockCount--;
  }
}
//---------------------------------------------------------------------------

UnicodeString __fastcall TBaselinesDemoMainForm::BaselineToText(TdxGanttControlDataModelBaseline *ABaseline)
{
  if (ABaseline->Description != "")
	return ABaseline->Description;
  if (ABaseline->Number == 0)
	return "Baseline (Last saved on " + DateTimeToStr(ABaseline->Created) + ")";
  else
	return "Baseline "+ IntToStr(ABaseline->Number) + " (Last saved on " + DateTimeToStr(ABaseline->Created) + ")";
}
//---------------------------------------------------------------------------

void __fastcall TBaselinesDemoMainForm::GanttControlViewChartBaselineNumberChanged(TObject *Sender)

{
  if (GanttControl->ViewChart->BaselineNumber < 0)
	cbBaseline->ItemIndex = 0;
  else {
	for (int I = 1; I < cbBaseline->ActiveProperties->Items->Count; I++)
	  if (((TdxGanttControlDataModelBaseline*)(cbBaseline->ActiveProperties->Items->Objects[I]))->Number == GanttControl->ViewChart->BaselineNumber) {
		cbBaseline->ItemIndex = I;
		break;
	  }
  }
}
//---------------------------------------------------------------------------

void __fastcall TBaselinesDemoMainForm::cbBaselinePropertiesEditValueChanged(TObject *Sender)

{
  if (FLockCount > 0)
	return;
  if ((cbBaseline->ItemIndex == -1) || (cbBaseline->ActiveProperties->Items->Objects[cbBaseline->ItemIndex] == NULL))
	GanttControl->ViewChart->HideBaselines();
  else
	GanttControl->ViewChart->ShowBaselines(((TdxGanttControlDataModelBaseline*)(cbBaseline->ActiveProperties->Items->Objects[cbBaseline->ItemIndex]))->Number);
}
//---------------------------------------------------------------------------

void __fastcall TBaselinesDemoMainForm::cxButton3Click(TObject *Sender)
{
  GanttControl->ViewChart->SetBaselines(cbSetBaseline->ItemIndex, lcbiSelectedTasks->Checked);
}
//---------------------------------------------------------------------------

void __fastcall TBaselinesDemoMainForm::cxButton4Click(TObject *Sender)
{
  GanttControl->ViewChart->ClearBaselines(cbSetBaseline->ItemIndex, lcbiSelectedTasks->Checked);
}
//---------------------------------------------------------------------------

