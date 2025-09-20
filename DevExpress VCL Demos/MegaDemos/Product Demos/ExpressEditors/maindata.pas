unit maindata;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, ImgList, cxDBEditRepository, cxEditRepositoryItems, cxEdit,
  DBClient, cxGraphics, cxClasses, dxmdaset, MidasLib, cxStyles, cxCustomData,
  cxFilter, cxData, cxDataStorage, cxNavigator, cxDBData, cxHyperLinkEdit,
  cxGridCustomTableView, cxGridTableView, cxGridBandedTableView,
  cxGridDBBandedTableView, cxControls, cxGridCustomView, cxGrid,
  cxDBExtLookupComboBox, cxImageList, cxExtEditRepositoryItems;

type
  TdmMain = class(TDataModule)
    dsDXCustomers: TDataSource;
    dsDXProducts: TDataSource;
    cdsDXCustomers: TClientDataSet;
    cdsDXProducts: TClientDataSet;
    cdsDXCustomersID: TAutoIncField;
    cdsDXCustomersFIRSTNAME: TWideStringField;
    cdsDXCustomersLASTNAME: TWideStringField;
    cdsDXCustomersCOMPANYNAME: TWideStringField;
    cdsDXCustomersPAYMENTTYPE: TIntegerField;
    cdsDXCustomersPRODUCTID: TIntegerField;
    cdsDXCustomersCUSTOMER: TBooleanField;
    cdsDXCustomersPURCHASEDATE: TDateTimeField;
    cdsDXCustomersPAYMENTAMOUNT: TBCDField;
    cdsDXCustomersCOPIES: TIntegerField;
    cdsDXProductsID: TAutoIncField;
    cdsDXProductsName: TWideStringField;
    ilMain: TcxImageList;
    cdsFoodsCategories: TClientDataSet;
    cdsFoodsCategoriesCategoryID: TAutoIncField;
    cdsFoodsCategoriesCategoryName: TWideStringField;
    cdsFoodsCategoriesDescription: TStringField;
    cdsFoodsCategoriesPicture: TBlobField;
    cdsFoodsCategoriesIcon_17: TBlobField;
    cdsFoodsCategoriesIcon_25: TBlobField;
    dsFoodsCategories: TDataSource;
    cdsEmployees: TClientDataSet;
    cdsEmployeesId: TIntegerField;
    cdsEmployeesDepartment: TIntegerField;
    cdsEmployeesTitle: TWideStringField;
    cdsEmployeesStatus: TIntegerField;
    cdsEmployeesHireDate: TDateTimeField;
    cdsEmployeesPersonalProfile: TWideStringField;
    cdsEmployeesFirstName: TWideStringField;
    cdsEmployeesLastName: TWideStringField;
    cdsEmployeesFullName: TWideStringField;
    cdsEmployeesPrefix: TIntegerField;
    cdsEmployeesHomePhone: TWideStringField;
    cdsEmployeesMobilePhone: TWideStringField;
    cdsEmployeesEmail: TWideStringField;
    cdsEmployeesSkype: TWideStringField;
    cdsEmployeesBirthDate: TDateTimeField;
    cdsEmployeesPictureId: TIntegerField;
    cdsEmployeesAddress_Line: TWideStringField;
    cdsEmployeesAddress_City: TWideStringField;
    cdsEmployeesAddress_State: TIntegerField;
    cdsEmployeesAddress_ZipCode: TWideStringField;
    cdsEmployeesAddress_Latitude: TFloatField;
    cdsEmployeesAddress_Longitude: TFloatField;
    cdsEmployeesProbationReason_Id: TIntegerField;
    cdsEmployeesPicture: TBlobField;
    cdsEmployeesDepartment_Name: TStringField;
    dsEmployees: TDataSource;
    cdsDepartmentSpr: TClientDataSet;
    dsDepartmentSpr: TDataSource;
    mdStatesSpr: TdxMemData;
    mdStatesSprID: TIntegerField;
    mdStatesSprShortName: TStringField;
    mdStatesSprLongName: TWideStringField;
    mdStatesSprFlag48px: TBlobField;
    mdStatesSprFlag24px: TBlobField;
    dsStatesSpr: TDataSource;
    mdEvaluation: TdxMemData;
    mdEvaluationNN: TAutoIncField;
    mdEvaluationCreatedOn: TDateField;
    mdEvaluationSubject: TStringField;
    mdEvaluationManager: TStringField;
    dsEvaluation: TDataSource;
    mdTasks: TdxMemData;
    mdTasksNN: TAutoIncField;
    mdTasksPRIORITY: TIntegerField;
    mdTasksDUEDATE: TDateField;
    mdTasksSUBJECT: TStringField;
    mdTasksCOMPLETION: TIntegerField;
    mdTasksDESCRIPTION: TStringField;
    dsTasks: TDataSource;
    procedure DataModuleCreate(Sender: TObject);
  private
    FDataPath: string;
    FImagesPath: string;
    procedure OpenDX;
  public
    procedure OpenContactDetailsDemoData;
    procedure OpenEmployeesDataset;
    procedure OpenInplaceGridEditorsDemoData;

    property DataPath: string read FDataPath;
    property ImagesPath: string read FImagesPath;
  end;

var
  dmMain: TdmMain;

implementation

{$R *.DFM}

uses
  SysConst, dxCore, dxDemoUtils;

procedure TdmMain.DataModuleCreate(Sender: TObject);
begin
  FDataPath := ExtractFilePath(Application.ExeName) + 'Data\';
  FImagesPath := FDataPath + 'Images\';
end;

procedure TdmMain.OpenContactDetailsDemoData;
begin
  OpenDX;
  mdStatesSpr.LoadFromBinaryFile(FDataPath + 'States.dat');
  mdEvaluation.LoadFromBinaryFile(FDataPath + 'Evaluation.dat');
  mdTasks.LoadFromBinaryFile(FDataPath + 'Tasks.dat');
  OpenEmployeesDataset;
  ActualizeDateTimesFields(cdsDXCustomers, ['PURCHASEDATE', 20]);
end;

procedure TdmMain.OpenDX;
begin
  if not cdsDXCustomers.Active then
    cdsDXCustomers.LoadFromFile(dmMain.DataPath + 'DXCustomers.cds');
  if not cdsDXProducts.Active then
    cdsDXProducts.LoadFromFile(FDataPath + 'DXProducts.cds');
end;

procedure TdmMain.OpenEmployeesDataset;
begin
  if not cdsDepartmentSpr.Active then
    cdsDepartmentSpr.LoadFromFile(FDataPath + 'Departments.cds');
  if not cdsEmployees.Active then
    cdsEmployees.LoadFromFile(FDataPath + 'Employees.cds');
end;

procedure TdmMain.OpenInplaceGridEditorsDemoData;
begin
  cdsFoodsCategories.LoadFromFile(FDataPath + 'FoodsCategories.cds');
  OpenDX;
end;

end.
