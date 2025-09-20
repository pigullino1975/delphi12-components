//---------------------------------------------------------------------------
#ifndef FixedColumnsDemoMainH
#define FixedColumnsDemoMainH
//---------------------------------------------------------------------------
#include <BaseForm.h>
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Menus.hpp>
#include <ComCtrls.hpp>
#include <SysUtils.hpp>
#include <Forms.hpp>
#include <DB.hpp>
#include <DBClient.hpp>
#include <cxClasses.hpp>
#include <cxControls.hpp>
#include <cxGraphics.hpp>
#include <cxLookAndFeels.hpp>
#include <cxLookAndFeelPainters.hpp>
#include <cxStyles.hpp>
#include <cxCustomData.hpp>
#include <cxFilter.hpp>
#include <cxData.hpp>
#include <cxDataStorage.hpp>
#include <cxEdit.hpp>
#include <cxNavigator.hpp>
#include <dxDateRanges.hpp>
#include <dxScrollbarAnnotations.hpp>
#include <cxDBData.hpp>
#include <cxGridLevel.hpp>
#include <cxGridCustomView.hpp>
#include <cxGridCustomTableView.hpp>
#include <cxGridTableView.hpp>
#include <cxGridDBTableView.hpp>
#include <cxGrid.hpp>
#include <cxGridCardView.hpp>
#include <dxBar.hpp>
#include <cxGridPopupMenu.hpp>
#include <ExtCtrls.hpp>
#include <cxGroupBox.hpp>
#include <cxButtons.hpp>
#include <cxLabel.hpp>
#include <cxSpinEdit.hpp>
#include <cxImageComboBox.hpp>
#include <cxCheckBox.hpp>
#include <dxColorDialog.hpp>
#include <ActnList.hpp>
//---------------------------------------------------------------------------
class TfrmMain : public TfmBaseForm
{
__published:  // IDE-managed Components
	TcxGrid *Grid;
	TcxGridDBTableView *tvTableView;
	TcxGridLevel *lvlLevel;
	TDataSource *dsCustomers;
	TClientDataSet *cdsCustomers;
	TStringField *cdsCustomersCompanyName;
	TStringField *cdsCustomersContactName;
	TStringField *cdsCustomersContactTitle;
	TStringField *cdsCustomersAddress;
	TStringField *cdsCustomersCity;
	TStringField *cdsCustomersPostalCode;
	TStringField *cdsCustomersCountry;
	TStringField *cdsCustomersPhone;
	TStringField *cdsCustomersFax;
	TStringField *cdsCustomersRegion;
	TcxGridDBColumn *tvTableViewCompanyName;
	TcxGridDBColumn *tvTableViewContactName;
	TcxGridDBColumn *tvTableViewContactTitle;
	TcxGridDBColumn *tvTableViewAddress;
	TcxGridDBColumn *tvTableViewCity;
	TcxGridDBColumn *tvTableViewPostalCode;
	TcxGridDBColumn *tvTableViewCountry;
	TcxGridDBColumn *tvTableViewPhone;
	TcxGridDBColumn *tvTableViewFax;
	TcxGridDBColumn *tvTableViewRegion;
	TcxImageList *ilImages;
	TcxGridPopupMenu *gpmPopupMenu;	
	TPopupMenu *pmHeaderPopup;
	TMenuItem *pmiNotFixed;
	TMenuItem *pmiFixedLeft;
	TMenuItem *pmiFixedRight;
	TMenuItem *FixedLeftDynamic1;
	TActionList *acHeaderPopup;
	TAction *acNotFixed;
	TAction *acFixedLeft;
	TAction *acFixedRight;
	TAction *acFixedDynamic;	
	TcxGroupBox *gbOptions;
	TcxButton *btnResetFixedColumnHightlightColor;
	TPaintBox *pbFixedColumnOverlayColor;
	TcxSpinEdit *seFixedSeparatorWidth;
	TcxImageComboBox *cbFixStyle;
	TcxImageComboBox *cbColumn;
	TcxLabel *lblColumns;
	TcxLabel *lblFixStyle;
	TcxLabel *lblFixedSeparatorWidth;
	TcxCheckBox *cbHighlightFixedColumns;
	TcxLabel *lblFixedColumnHighlightColor;
	TdxColorDialog *cdFixedColumnOverlayColor;
	void __fastcall FormCreate(TObject *Sender);
	void __fastcall cbColumnPropertiesEditValueChanged(TObject *Sender);
	void __fastcall cbFixStylePropertiesEditValueChanged(TObject *Sender);
	void __fastcall seFixedSeparatorWidthPropertiesEditValueChanged(TObject *Sender);
	void __fastcall cbHighlightFixedColumnsPropertiesEditValueChanged(TObject *Sender);
	void __fastcall pbFixedColumnOverlayColorPaint(TObject *Sender);
	void __fastcall pbFixedColumnOverlayColorClick(TObject *Sender);
	void __fastcall btnResetFixedColumnHightlightColorClick(TObject *Sender);
	void __fastcall acFixedClick(TObject *Sender);
	void __fastcall gpmPopupMenuPopup(TComponent *ASenderMenu, TcxCustomGridHitTest *AHitTest, int X, int Y, bool &AllowPopup);
protected:
	TcxCustomGridColumn *FPopupColumn;

	void ChangeFixedKind(TcxCustomGridColumn *AColumn, TcxGridColumnFixedKind AKind);
	TcxCustomGridColumn* GetComboBoxColumn();
	void PopulateColumnComboBox();
	void PopulateSortedColumns(TStringList *AList);
public:   // User declarations
  __fastcall TfrmMain(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TfrmMain *frmMain;
//---------------------------------------------------------------------------
#endif
