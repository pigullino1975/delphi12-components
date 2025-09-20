//---------------------------------------------------------------------------

#ifndef TreeViewDemoMainH
#define TreeViewDemoMainH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "BaseForm.h"
#include <Menus.hpp>
#include "cxButtons.hpp"
#include "cxClasses.hpp"
#include "cxContainer.hpp"
#include "cxControls.hpp"
#include "cxEdit.hpp"
#include "cxGraphics.hpp"
#include "cxLookAndFeelPainters.hpp"
#include "cxLookAndFeels.hpp"
#include "cxMaskEdit.hpp"
#include "cxMemo.hpp"
#include "cxSpinEdit.hpp"
#include "cxTextEdit.hpp"
#include "dxLayoutContainer.hpp"
#include "dxLayoutControl.hpp"
#include "dxLayoutControlAdapters.hpp"
#include "dxLayoutcxEditAdapters.hpp"
#include "dxLayoutLookAndFeels.hpp"
#include "dxTreeView.hpp"
#include <ComCtrls.hpp>
//---------------------------------------------------------------------------
typedef void __fastcall (__closure *TTreeViewProc)();
enum TdxTreeViewDemoAction {tdaAdd, tdaClear, tdaExpand, tdaCollapse};

class TfmTreeViewDemo : public TfmBaseForm
{
__published:	// IDE-managed Components
	TdxLayoutControl *lcMain;
	TdxTreeViewControl *dxNewTreeView;
	TcxSpinEdit *seFirstLevelNodeCount;
	TcxButton *btnTreeViewAdd;
	TcxButton *btnTreeViewClear;
	TcxMemo *mLog;
	TcxSpinEdit *seDepth;
	TcxButton *btnTreeViewFullExpand;
	TcxButton *btnTreeViewFullCollapse;
	TcxSpinEdit *seChildrenCount;
	TcxButton *btndxTreeViewClear;
	TcxButton *btndxTreeViewAdd;
	TcxButton *btndxTreeViewFullExpand;
	TcxButton *btndxTreeViewFullCollapse;
	TTreeView *TreeView;
	TdxLayoutGroup *lcMainGroup_Root;
	TdxLayoutItem *lidxNewTreeView;
	TdxLayoutItem *liseAddCount;
	TdxLayoutItem *liTreeViewAdd;
	TdxLayoutItem *liTreeViewClear;
	TdxLayoutGroup *lgTreeViews;
	TdxLayoutGroup *lgLog;
	TdxLayoutItem *limLog;
	TdxLayoutItem *dxLayoutItem1;
	TdxLayoutLabeledItem *liNodesCount;
	TdxLayoutGroup *lgdxTreeViewControl;
	TdxLayoutGroup *lgTreeView;
	TdxLayoutGroup *dxLayoutGroup3;
	TdxLayoutItem *liTreeViewExpand;
	TdxLayoutItem *liTreeViewCollapse;
	TdxLayoutItem *liChildrenCount;
	TdxLayoutGroup *dxLayoutGroup5;
	TdxLayoutGroup *dxLayoutGroup1;
	TdxLayoutAutoCreatedGroup *dxLayoutAutoCreatedGroup1;
	TdxLayoutItem *lidxTreeViewClear;
	TdxLayoutItem *lidxTreeViewAdd;
	TdxLayoutItem *lidxTreeViewExpand;
	TdxLayoutItem *lidxTreeViewCollapse;
	TdxLayoutItem *liTreeView;
	TdxLayoutLookAndFeelList *dxLayoutLookAndFeelList1;
	TdxLayoutSkinLookAndFeel *dxLayoutSkinLookAndFeel1;
	TdxLayoutLabeledItem *lidxTreeViewNodeCount;
	TdxLayoutLabeledItem *liTreeViewNodeCount;
	TdxLayoutAutoCreatedGroup *dxLayoutAutoCreatedGroup2;
	TdxLayoutAutoCreatedGroup *dxLayoutAutoCreatedGroup3;
	void __fastcall FormCreate(TObject *Sender);
	void __fastcall seDepthPropertiesChange(TObject *Sender);
	void __fastcall btndxTreeViewAddClick(TObject *Sender);
	void __fastcall btndxTreeViewClearClick(TObject *Sender);
	void __fastcall btndxTreeViewFullExpandClick(TObject *Sender);
	void __fastcall btndxTreeViewFullCollapseClick(TObject *Sender);
	void __fastcall btnTreeViewAddClick(TObject *Sender);
	void __fastcall btnTreeViewClearClick(TObject *Sender);
	void __fastcall btnTreeViewFullExpandClick(TObject *Sender);
	void __fastcall btnTreeViewFullCollapseClick(TObject *Sender);
	void __fastcall lgLogButton0Click(TObject *Sender);
private:
	__int64 FNodesCount;
	int FLevelCount;
	int FTopLevelNodesCount;
    Cardinal FTickCount;
	void __fastcall SettingsChanged();
	void __fastcall DoTreeViewOperation(TTreeViewProc AProc, TdxTreeViewDemoAction AAction);
	void __fastcall DodxTreeViewControlOperation(TTreeViewProc AProc, TdxTreeViewDemoAction AAction);

	void __fastcall AdddxTreeViewNodes();
	void __fastcall AdddxTreeViewChildren(TdxTreeViewNode* AParent);
	void __fastcall AddTreeViewNodes();
	void __fastcall AddTreeViewChildren(TTreeNode* AParent);
	void __fastcall ClearTreeViewNodes();
	void __fastcall CleardxTreeViewNodes();
	void __fastcall CollapseTreeViewNodes();
	void __fastcall CollapsedxTreeViewNodes();
	void __fastcall ExpandTreeViewNodes();
	void __fastcall ExpanddxTreeViewNodes();
	String __fastcall GetdxTreeViewNodeCountText(TdxTreeViewDemoAction AAction);
	String __fastcall GetTreeViewNodeCountText(TdxTreeViewDemoAction AAction);
	void __fastcall RefreshTreeViewActions();
	void __fastcall RefreshdxTreeViewActions();

	String __fastcall GetActionDescription(TdxTreeViewDemoAction AAction);
	String __fastcall GetStartActionDescription(TdxTreeViewDemoAction AAction);

	void __fastcall BeginTimeCalculation(const String AMsg);
	void __fastcall EndTimeCalculation(const String AMsg);
public:		// User declarations
	__fastcall TfmTreeViewDemo(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TfmTreeViewDemo *fmTreeViewDemo;
//---------------------------------------------------------------------------
#endif
