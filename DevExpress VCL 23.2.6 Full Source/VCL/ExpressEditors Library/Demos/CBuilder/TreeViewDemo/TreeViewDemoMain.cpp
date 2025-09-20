//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "TreeViewDemoMain.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "BaseForm"
#pragma link "cxButtons"
#pragma link "cxClasses"
#pragma link "cxContainer"
#pragma link "cxControls"
#pragma link "cxEdit"
#pragma link "cxGraphics"
#pragma link "cxLookAndFeelPainters"
#pragma link "cxLookAndFeels"
#pragma link "cxMaskEdit"
#pragma link "cxMemo"
#pragma link "cxSpinEdit"
#pragma link "cxTextEdit"
#pragma link "dxLayoutContainer"
#pragma link "dxLayoutControl"
#pragma link "dxLayoutControlAdapters"
#pragma link "dxLayoutcxEditAdapters"
#pragma link "dxLayoutLookAndFeels"
#pragma link "dxTreeView"
#pragma resource "*.dfm"
TfmTreeViewDemo *fmTreeViewDemo;

const
  String SAdd = "Added %s nodes to";
  String SClear = "Removed %s nodes from";
  String SExpand = "Expanded %s nodes in";
  String SCollapse = "Collapsed %s nodes in";

  String SStartAdd = "add nodes to";
  String SStartClear = "remove all nodes from";
  String SStartExpand = "expand all nodes in";
  String SStartCollapse = "collapse all nodes in";

  String SNodesCountToAdd = "Nodes to Add: %s";
  String SNodesCount = "Node Count: %s";

//---------------------------------------------------------------------------
String __fastcall TfmTreeViewDemo::GetActionDescription(TdxTreeViewDemoAction AAction)
{
  switch (AAction){
	case tdaCollapse: return(SCollapse);
	case tdaClear: return(SClear);
	case tdaExpand: return(SExpand);
  default: // tdaAdd
    return(SAdd);
  };
}
//---------------------------------------------------------------------------
String __fastcall TfmTreeViewDemo::GetStartActionDescription(TdxTreeViewDemoAction AAction)
{
  switch (AAction){
	case tdaCollapse: return(SStartCollapse);
	case tdaClear: return(SStartClear);
	case tdaExpand: return(SStartExpand);
  default: // tdaAdd
	return(SStartAdd);
  };
}
//---------------------------------------------------------------------------
void __fastcall TfmTreeViewDemo::SettingsChanged()
{
  FNodesCount = 0;
  FLevelCount = seDepth->Value;
  FTopLevelNodesCount = seFirstLevelNodeCount->Value;
  for (int i = 0; i < FLevelCount; i++) {
	FNodesCount = FNodesCount + FTopLevelNodesCount * (__int64)(Power(seChildrenCount->Value, (float)i));};
  liNodesCount->CaptionOptions->Text = String::Format(SNodesCountToAdd, ARRAYOFCONST((FormatFloat("#,###", FNodesCount))));
}

//---------------------------------------------------------------------------
void __fastcall TfmTreeViewDemo::DoTreeViewOperation(TTreeViewProc AProc, TdxTreeViewDemoAction AAction)
{
  String AEndDescription = String::Format(GetActionDescription(AAction), ARRAYOFCONST((GetTreeViewNodeCountText(AAction))));
  BeginTimeCalculation(String::Format("%s TTreeView", ARRAYOFCONST((GetStartActionDescription(AAction)))));
  TreeView->Items->BeginUpdate();
  __try {
	  AProc();
  }
  __finally
  {
	TreeView->Items->EndUpdate();
	EndTimeCalculation(String::Format("%s TTreeView", ARRAYOFCONST((AEndDescription))));
	RefreshTreeViewActions();
  };
}
//---------------------------------------------------------------------------
void __fastcall TfmTreeViewDemo::DodxTreeViewControlOperation(TTreeViewProc AProc, TdxTreeViewDemoAction AAction)
{
  String AEndDescription = String::Format(GetActionDescription(AAction), ARRAYOFCONST((GetdxTreeViewNodeCountText(AAction))));
  BeginTimeCalculation(String::Format("%s TdxTreeViewControl", ARRAYOFCONST((GetStartActionDescription(AAction)))));
  dxNewTreeView->Items->BeginUpdate();
  __try {
	  AProc();
  }
  __finally
  {
	dxNewTreeView->Items->EndUpdate();
	dxNewTreeView->Update();
	EndTimeCalculation(String::Format("%s TdxTreeViewControl", ARRAYOFCONST((AEndDescription))));
	RefreshdxTreeViewActions();
  };
}
//---------------------------------------------------------------------------
void __fastcall TfmTreeViewDemo::AdddxTreeViewNodes()
{
  for (int i = 0; i < FTopLevelNodesCount; i++) {
	TdxTreeViewNode* ANode = dxNewTreeView->Items->Add(0, String::Format("%d", ARRAYOFCONST((i))));
	AdddxTreeViewChildren(ANode);};
}
//---------------------------------------------------------------------------
void __fastcall TfmTreeViewDemo::AdddxTreeViewChildren(TdxTreeViewNode* AParent)
{
  if (AParent->Level >= FLevelCount - 1) return;
  for (int i = 0; i < seChildrenCount->Value; i++) {
	TdxTreeViewNode* ANode = dxNewTreeView->Items->AddChild(AParent, String::Format("%s%d", ARRAYOFCONST((AParent->Caption, i))));
	AdddxTreeViewChildren(ANode);
  };
}
//---------------------------------------------------------------------------
void __fastcall TfmTreeViewDemo::AddTreeViewNodes(){
  for (int i = 0; i < FTopLevelNodesCount; i++) {
	TTreeNode* ANode = TreeView->Items->Add(0, String::Format("%d", ARRAYOFCONST((i))));
	AddTreeViewChildren(ANode);};
}
//---------------------------------------------------------------------------
void __fastcall TfmTreeViewDemo::AddTreeViewChildren(TTreeNode* AParent)
{
  if (AParent->Level >= FLevelCount - 1) return;
  for (int i = 0; i < seChildrenCount->Value; i++) {
	TTreeNode* ANode = TreeView->Items->AddChild(AParent, String::Format("%s%d", ARRAYOFCONST((AParent->Text, i))));
	AddTreeViewChildren(ANode);
  };
}
//---------------------------------------------------------------------------
void __fastcall TfmTreeViewDemo::ClearTreeViewNodes()
{
  TreeView->Items->Clear();
}
//---------------------------------------------------------------------------
void __fastcall TfmTreeViewDemo::CleardxTreeViewNodes()
{
  dxNewTreeView->Items->Clear();
}
//---------------------------------------------------------------------------
void __fastcall TfmTreeViewDemo::CollapseTreeViewNodes()
{
   TreeView->FullCollapse();
}
//---------------------------------------------------------------------------
void __fastcall TfmTreeViewDemo::CollapsedxTreeViewNodes()
{
  dxNewTreeView->FullCollapse();
}
//---------------------------------------------------------------------------
void __fastcall TfmTreeViewDemo::ExpandTreeViewNodes()
{
   TreeView->FullExpand();
}
//---------------------------------------------------------------------------
void __fastcall TfmTreeViewDemo::ExpanddxTreeViewNodes()
{
  dxNewTreeView->FullExpand();
}
//---------------------------------------------------------------------------
String __fastcall TfmTreeViewDemo::GetdxTreeViewNodeCountText(TdxTreeViewDemoAction AAction)
{
  return(FormatFloat("#,###0", IfThen(AAction == tdaAdd, FNodesCount, __int64(dxNewTreeView->AbsoluteCount))));
}
//---------------------------------------------------------------------------
String __fastcall TfmTreeViewDemo::GetTreeViewNodeCountText(TdxTreeViewDemoAction AAction)
{
  return(FormatFloat("#,###0", IfThen(AAction == tdaAdd, FNodesCount, __int64(TreeView->Items->Count))));
}
//---------------------------------------------------------------------------
void __fastcall TfmTreeViewDemo::RefreshTreeViewActions()
{
  liTreeViewClear->Enabled = TreeView->Items->GetFirstNode() != 0;
  liTreeViewExpand->Enabled = liTreeViewClear->Enabled;
  liTreeViewCollapse->Enabled = liTreeViewClear->Enabled;
  liTreeViewNodeCount->CaptionOptions->Text = String::Format(SNodesCount, ARRAYOFCONST((GetTreeViewNodeCountText(tdaClear))));
}
//---------------------------------------------------------------------------
void __fastcall TfmTreeViewDemo::RefreshdxTreeViewActions()
{
  lidxTreeViewClear->Enabled = dxNewTreeView->Root->First != 0;
  lidxTreeViewExpand->Enabled = lidxTreeViewClear->Enabled;
  lidxTreeViewCollapse->Enabled = lidxTreeViewClear->Enabled;
  lidxTreeViewNodeCount->CaptionOptions->Text = String::Format(SNodesCount, ARRAYOFCONST((GetdxTreeViewNodeCountText(tdaClear))));
}
//---------------------------------------------------------------------------
void __fastcall TfmTreeViewDemo::BeginTimeCalculation(const String AMsg)
{
  mLog->Lines->Add(String::Format("[%s] Starting to %s...", ARRAYOFCONST((TimeToStr(Now()), AMsg))));
  FTickCount = GetTickCount();
  ShowHourglassCursor();
}
//---------------------------------------------------------------------------
void __fastcall TfmTreeViewDemo::EndTimeCalculation(const String AMsg)
{
  mLog->Lines->Add(String::Format("[%s] %s. Time taken: %f seconds", ARRAYOFCONST((TimeToStr(Now()), AMsg, float(GetTickCount() - FTickCount) / 1000))));
  HideHourglassCursor();
}
//---------------------------------------------------------------------------
__fastcall TfmTreeViewDemo::TfmTreeViewDemo(TComponent* Owner)
	: TfmBaseForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TfmTreeViewDemo::FormCreate(TObject *Sender)
{
  SettingsChanged();
  RefreshTreeViewActions();
  RefreshdxTreeViewActions();
}
//---------------------------------------------------------------------------

void __fastcall TfmTreeViewDemo::seDepthPropertiesChange(TObject *Sender)
{
  SettingsChanged();
}
//---------------------------------------------------------------------------

void __fastcall TfmTreeViewDemo::btndxTreeViewAddClick(TObject *Sender)
{
  DodxTreeViewControlOperation(AdddxTreeViewNodes, tdaAdd);
}
//---------------------------------------------------------------------------

void __fastcall TfmTreeViewDemo::btndxTreeViewClearClick(TObject *Sender)
{
  DodxTreeViewControlOperation(CleardxTreeViewNodes, tdaClear);
}
//---------------------------------------------------------------------------

void __fastcall TfmTreeViewDemo::btndxTreeViewFullExpandClick(TObject *Sender)
{
  DodxTreeViewControlOperation(ExpanddxTreeViewNodes, tdaExpand);
}
//---------------------------------------------------------------------------

void __fastcall TfmTreeViewDemo::btndxTreeViewFullCollapseClick(TObject *Sender)
{
  DodxTreeViewControlOperation(CollapsedxTreeViewNodes, tdaCollapse);
}
//---------------------------------------------------------------------------

void __fastcall TfmTreeViewDemo::btnTreeViewAddClick(TObject *Sender)
{
  DoTreeViewOperation(AddTreeViewNodes, tdaAdd);
}
//---------------------------------------------------------------------------

void __fastcall TfmTreeViewDemo::btnTreeViewClearClick(TObject *Sender)
{
  DoTreeViewOperation(ClearTreeViewNodes, tdaClear);
}
//---------------------------------------------------------------------------

void __fastcall TfmTreeViewDemo::btnTreeViewFullExpandClick(TObject *Sender)
{
  DoTreeViewOperation(ExpandTreeViewNodes, tdaExpand);
}
//---------------------------------------------------------------------------

void __fastcall TfmTreeViewDemo::btnTreeViewFullCollapseClick(TObject *Sender)
{
  DoTreeViewOperation(CollapseTreeViewNodes, tdaCollapse);
}
//---------------------------------------------------------------------------

void __fastcall TfmTreeViewDemo::lgLogButton0Click(TObject *Sender)
{
  mLog->Lines->Clear();
}
//---------------------------------------------------------------------------

