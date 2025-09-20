//---------------------------------------------------------------------------

#ifndef SummaryGroupDemoDataH
#define SummaryGroupDemoDataH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "cxClasses.hpp"
#include "cxGridTableView.hpp"
#include "cxStyles.hpp"
#include <DB.hpp>
#include <ImgList.hpp>
#include "dxmdaset.hpp"
//---------------------------------------------------------------------------
class TSummaryGroupDemoDataDM : public TDataModule
{
__published:	// IDE-managed Components
		TDataSource *dsCars;
		TDataSource *dsOrders;
		TDataSource *dsCustomers;
		TdxMemData *mdCars;
		TIntegerField *mdCarsID;
		TIntegerField *mdCarsTrademarkID;
		TStringField *mdCarsTrademark;
		TWideStringField *mdCarsName;
		TIntegerField *mdCarsMPG_City;
		TIntegerField *mdCarsMPG_Highway;
		TWideMemoField *mdCarsDescription;
		TBCDField *mdCarsPrice;
		TStringField *mdCarsCarName;
		TBlobField *mdCarsImage;
		TBlobField *mdCarsPhoto;
		TBooleanField *mdCarsInStock;
		TdxMemData *mdOrders;
        TAutoIncField *mdOrdersID;
        TIntegerField *mdOrdersCustomerID;
        TIntegerField *mdOrdersProductID;
        TDateTimeField *mdOrdersPurchaseDate;
        TDateTimeField *mdOrdersTime;
        TStringField *mdOrdersPaymentType;
        TMemoField *mdOrdersDescription;
        TIntegerField *mdOrdersQuantity;
        TCurrencyField *mdOrdersPaymentAmount;
        TStringField *mdOrdersPurchaseMonth;
        TdxMemData *mdCustomers;
		TAutoIncField *mdCustomersID;
		TStringField *mdCustomersFirstName;
		TStringField *mdCustomersLastName;
		TStringField *mdCustomersCompany;
		TdxMemData *mdTrademark;
        TcxStyleRepository *StyleRepository;
        TcxStyle *stBlueLight;
        TcxStyle *stGreyLight;
        TcxStyle *stBlueSky;
        TImageList *PaymentTypeImages;
        TcxStyle *stClear;
        TcxStyle *stRed;
        void __fastcall mdCarsCalcFields(TDataSet *DataSet);
        void __fastcall mdOrdersCalcFields(TDataSet *DataSet);
	void __fastcall DataModuleCreate(TObject *Sender);
private:	// User declarations
public:		// User declarations
  __fastcall TSummaryGroupDemoDataDM(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TSummaryGroupDemoDataDM *SummaryGroupDemoDataDM;
//---------------------------------------------------------------------------
#endif
