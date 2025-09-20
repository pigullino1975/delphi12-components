//---------------------------------------------------------------------------

#ifndef ListViewDemoMainH
#define ListViewDemoMainH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <Menus.hpp>
#include "BaseForm.h"
#include "cxCheckBox.hpp"
#include "cxCheckComboBox.hpp"
#include "cxContainer.hpp"
#include "cxControls.hpp"
#include "cxDropDownEdit.hpp"
#include "cxEdit.hpp"
#include "cxGraphics.hpp"
#include "cxGroupBox.hpp"
#include "cxLabel.hpp"
#include "cxLookAndFeelPainters.hpp"
#include "cxLookAndFeels.hpp"
#include "cxMaskEdit.hpp"
#include "cxSpinEdit.hpp"
#include "cxTextEdit.hpp"
#include "dxCheckGroupBox.hpp"
#include "dxLayoutControlAdapters.hpp"
#include "dxLayoutcxEditAdapters.hpp"
#include "dxLayoutContainer.hpp"
#include "dxLayoutControl.hpp"
#include "dxLayoutLookAndFeels.hpp"
#include "cxImageList.hpp"
#include "dxListView.hpp"
#include <ComCtrls.hpp>
#include "cxClasses.hpp"
#include <ImgList.hpp>

//---------------------------------------------------------------------------
class TfmListViewDemo : public TfmBaseForm
{
__published:	// IDE-managed Components
    TdxLayoutGroup *dxLayoutControl1Group_Root;
    TdxLayoutControl *dxLayoutControl1;
    TdxLayoutItem *dxLayoutItem1;
    TdxListViewControl *LV;
    TcxImageList *ilLargeCars;
    TdxListGroup *LVGroup1;
    TdxListGroup *LVGroup2;
    TdxListGroup *LVGroup3;
    TdxListGroup *LVGroup4;
    TdxListGroup *LVGroup5;
    TdxListGroup *LVGroup6;
    TdxListGroup *LVGroup7;
    TdxListGroup *LVGroup8;
    TdxListGroup *LVGroup9;
    TdxListGroup *LVGroup10;
    TdxListGroup *LVGroup11;
    TdxListGroup *LVGroup12;
    TdxListGroup *LVGroup13;
    TdxListGroup *LVGroup14;
    TdxListGroup *LVGroup15;
    TdxListGroup *LVGroup16;
    TdxListGroup *LVGroup17;
    TdxListGroup *LVGroup18;
    TdxListGroup *LVGroup19;
    TdxLayoutGroup *dxLayoutGroup1;
    TcxImageList *ilSmallCars;
    TdxLayoutCheckBoxItem *liMultiSelect;
    TdxLayoutGroup *lgViewStyles;
    TdxLayoutRadioButtonItem *liIcons;
    TdxLayoutRadioButtonItem *liList;
    TdxLayoutRadioButtonItem *liReport;
    TdxLayoutRadioButtonItem *liSmallIcon;
    TdxLayoutCheckBoxItem *liGroupView;
    TdxLayoutCheckBoxItem *liCheckboxes;
    TdxLayoutLookAndFeelList *dxLayoutLookAndFeelList1;
    TdxLayoutSkinLookAndFeel *dxLayoutSkinLookAndFeel1;
    TdxLayoutGroup *lgItemsArrangement;
    TdxLayoutRadioButtonItem *liHorizontal;
    TdxLayoutRadioButtonItem *liVertical;
    TdxLayoutCheckBoxItem *liExplorerStyle;
    TdxLayoutGroup *dxLayoutGroup2;
    TdxLayoutRadioButtonItem *liGDI;
    TdxLayoutRadioButtonItem *liGDIPlus;
    TdxLayoutRadioButtonItem *liDirectX;

    void __fastcall liCheckboxesClick(TObject *Sender);
    void __fastcall liGroupViewClick(TObject *Sender);
    void __fastcall liMultiSelectClick(TObject *Sender);
    void __fastcall liViewStyleClick(TObject *Sender);
    void __fastcall liArrangementClick(TObject *Sender);
    void __fastcall liExplorerStyleClick(TObject *Sender);
    void __fastcall LVInfoTip(TdxCustomListView *Sender, TdxListItem *AItem, UnicodeString &AInfoTip);
    void __fastcall OnRenderModeClick(TObject *Sender);
private:	// User declarations
public:		// User declarations
	__fastcall TfmListViewDemo(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TfmListViewDemo *fmListViewDemo;
//---------------------------------------------------------------------------
#endif
