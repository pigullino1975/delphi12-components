unit SummaryGroupDemoData;

interface

uses
  Forms,
  SysUtils, Classes, DB, cxStyles, ImgList, Controls, DemoUtils,
  dxmdaset, cxClasses;

type
  TSummaryGroupDemoDataDM = class(TDataModule)
    dsCars: TDataSource;
    dsOrders: TDataSource;
    dsCustomers: TDataSource;
    StyleRepository: TcxStyleRepository;
    stBlueLight: TcxStyle;
    stGreyLight: TcxStyle;
    stBlueSky: TcxStyle;
    PaymentTypeImages: TImageList;
    stClear: TcxStyle;
    stRed: TcxStyle;
    mdOrders: TdxMemData;
    mdCustomers: TdxMemData;
    mdOrdersID: TAutoIncField;
    mdOrdersCustomerID: TIntegerField;
    mdOrdersProductID: TIntegerField;
    mdOrdersPurchaseDate: TDateTimeField;
    mdOrdersTime: TDateTimeField;
    mdOrdersPaymentType: TStringField;
    mdOrdersPaymentAmount: TCurrencyField;
    mdOrdersDescription: TMemoField;
    mdOrdersQuantity: TIntegerField;
    mdCustomersID: TAutoIncField;
    mdCustomersFirstName: TStringField;
    mdCustomersLastName: TStringField;
    mdCustomersCompany: TStringField;
    mdCustomersPrefix: TStringField;
    mdCustomersTitle: TStringField;
    mdCustomersAddress: TStringField;
    mdCustomersCity: TStringField;
    mdCustomersState: TStringField;
    mdCustomersZipCode: TStringField;
    mdCustomersSource: TStringField;
    mdCustomersCustomer: TStringField;
    mdCustomersHomePhone: TStringField;
    mdCustomersFaxPhone: TStringField;
    mdCustomersSpouse: TStringField;
    mdCustomersOccupation: TStringField;
    mdCustomersDescription: TMemoField;
    mdCustomersEmail: TStringField;
    mdOrdersPurchaseMonth: TStringField;
    mdCars: TdxMemData;
    mdCarsID: TIntegerField;
    mdCarsTrademarkID: TIntegerField;
    mdCarsName: TWideStringField;
    mdCarsModification: TWideStringField;
    mdCarsCategoryID: TIntegerField;
    mdCarsPrice: TBCDField;
    mdCarsMPG_City: TIntegerField;
    mdCarsMPG_Highway: TIntegerField;
    mdCarsDoors: TIntegerField;
    mdCarsBodyStyleID: TIntegerField;
    mdCarsCilinders: TIntegerField;
    mdCarsHorsepower: TWideStringField;
    mdCarsTorque: TWideStringField;
    mdCarsTransmission_Speeds: TWideStringField;
    mdCarsTransmission_Type: TIntegerField;
    mdCarsDescription: TWideMemoField;
    mdCarsImage: TBlobField;
    mdCarsPhoto: TBlobField;
    mdCarsDelivery_Date: TDateTimeField;
    mdCarsInStock: TBooleanField;
    mdCarsCarName: TStringField;
    mdCarsTrademark: TStringField;
    mdTrademark: TdxMemData;
    mdTrademarkID: TIntegerField;
    mdTrademarkName: TWideStringField;
    mdTrademarkSite: TWideStringField;
    mdTrademarkLogo: TBlobField;
    mdTrademarkDescription: TWideMemoField;
    procedure mdCarsCalcFields(DataSet: TDataSet);
    procedure mdOrdersCalcFields(DataSet: TDataSet);
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SummaryGroupDemoDataDM: TSummaryGroupDemoDataDM;

implementation

{$R *.dfm}

uses
  dxCore;

procedure TSummaryGroupDemoDataDM.mdCarsCalcFields(DataSet: TDataSet);
begin
  SetStringFieldValue(mdCarsCarName, dxAnsiStringToString(mdCarsTrademark.Value + ' ' +  mdCarsName.Value));
end;

procedure TSummaryGroupDemoDataDM.mdOrdersCalcFields(DataSet: TDataSet);
var
  s: string;
begin
  DateTimeToString(s, 'mmmm', mdOrdersPurchaseDate.AsDateTime);
  SetStringFieldValue(mdOrdersPurchaseMonth, s);
end;

procedure TSummaryGroupDemoDataDM.DataModuleCreate(Sender: TObject);
begin
  mdCars.LoadFromBinaryFile('..\..\Data\CarsModel.dat');
  mdOrders.LoadFromBinaryFile('..\..\Data\Orders.dat');
  mdCustomers.LoadFromBinaryFile('..\..\Data\Customers.dat');
  mdTrademark.LoadFromBinaryFile('..\..\Data\CarsTrademark.dat');
  mdCars.Open;
  mdOrders.Open;
  mdCustomers.Open;
  mdTrademark.Open;
end;

end.
