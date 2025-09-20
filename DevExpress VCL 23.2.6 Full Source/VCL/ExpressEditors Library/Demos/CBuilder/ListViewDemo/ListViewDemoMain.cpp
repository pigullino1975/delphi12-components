//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "ListViewDemoMain.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "BaseForm"
#pragma link "cxCheckBox"
#pragma link "cxCheckComboBox"
#pragma link "cxContainer"
#pragma link "cxControls"
#pragma link "cxDropDownEdit"
#pragma link "cxEdit"
#pragma link "cxGraphics"
#pragma link "cxGroupBox"
#pragma link "cxLabel"
#pragma link "cxLookAndFeelPainters"
#pragma link "cxLookAndFeels"
#pragma link "cxMaskEdit"
#pragma link "cxSpinEdit"
#pragma link "cxTextEdit"
#pragma link "dxCheckGroupBox"
#pragma link "dxListView"
#pragma link "cxClasses"
#pragma resource "*.dfm"

TfmListViewDemo *fmListViewDemo;

//---------------------------------------------------------------------------
__fastcall TfmListViewDemo::TfmListViewDemo(TComponent* Owner)
	: TfmBaseForm(Owner)
{
}

void __fastcall TfmListViewDemo::liCheckboxesClick(TObject *Sender)
{
  LV->Checkboxes = liCheckboxes->Checked;
}

void __fastcall TfmListViewDemo::liGroupViewClick(TObject *Sender)
{
  LV->GroupView = liGroupView->Checked;
}

void __fastcall TfmListViewDemo::liMultiSelectClick(TObject *Sender)
{
  LV->MultiSelect = liMultiSelect->Checked;
}

void __fastcall TfmListViewDemo::liViewStyleClick(TObject *Sender)
{
  TdxLayoutRadioButtonItem *AItem =  (TdxLayoutRadioButtonItem*)Sender;
  if (AItem->Tag == 0) LV->ViewStyle = TdxListViewStyle::Icon;
  if (AItem->Tag == 1) LV->ViewStyle = TdxListViewStyle::SmallIcon;
  if (AItem->Tag == 2) LV->ViewStyle = TdxListViewStyle::List;
  if (AItem->Tag == 3) LV->ViewStyle = TdxListViewStyle::Report;
  lgItemsArrangement->Enabled = (AItem->Tag == 0)||(AItem->Tag == 1);
}

void __fastcall TfmListViewDemo::liArrangementClick(TObject *Sender)
{
  TdxLayoutRadioButtonItem *AItem =  (TdxLayoutRadioButtonItem*)Sender;
  if (AItem->Tag == 0) {
	LV->ViewStyleIcon->Arrangement = TdxListIconsArrangement::Horizontal;
	LV->ViewStyleSmallIcon->Arrangement = TdxListIconsArrangement::Horizontal;
  }
  else {
	LV->ViewStyleIcon->Arrangement = TdxListIconsArrangement::Vertical;
	LV->ViewStyleSmallIcon->Arrangement = TdxListIconsArrangement::Vertical;
  }
}

void __fastcall TfmListViewDemo::liExplorerStyleClick(TObject *Sender)
{
  LV->ExplorerStyle = liExplorerStyle->Checked;
}

void __fastcall TfmListViewDemo::LVInfoTip(TdxCustomListView *Sender, TdxListItem *AItem, UnicodeString &AInfoTip)
{
  AInfoTip = "Trademark: " + AItem->Caption + "\r\n" + "Model: " + AItem->SubItems->Strings[0];
}
//---------------------------------------------------------------------------

void __fastcall TfmListViewDemo::OnRenderModeClick(TObject *Sender)
{
  TdxLayoutRadioButtonItem *AItem =  (TdxLayoutRadioButtonItem*)Sender;
  if (AItem->Tag == 0) LV->LookAndFeel->RenderMode = rmGDI;
  if (AItem->Tag == 1) LV->LookAndFeel->RenderMode = rmGDIPlus;
  if (AItem->Tag == 2) LV->LookAndFeel->RenderMode = rmDirectX;
}
