unit uGridFiltering;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uGridSummaries, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxControls, cxGridCustomView, cxGrid,
  StdCtrls, ExtCtrls, uGridCustomSummaries, cxStyles, cxCustomData,
  cxGraphics, cxFilter, cxData, cxEdit, DB, cxDBData, cxClasses,
  cxDataStorage, cxSpinEdit, cxContainer, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxImageComboBox, cxLabel, cxCheckBox, cxLookAndFeels,
  cxLookAndFeelPainters, Menus, cxNavigator, dxLayoutControlAdapters, dxLayoutContainer, cxButtons, dxLayoutControl,
  dxLayoutcxEditAdapters, dxToggleSwitch, ActnList, dxDateRanges, dxScrollbarAnnotations, System.Actions,
  dxLayoutLookAndFeels, cxGroupBox, dxPanel, cxGeometry,
  dxFramedControl;

type
  TfrmFitleringGrid = class(TfrmCustomGridSummaries)
    dxLayoutItem1: TdxLayoutItem;
    cbFilterPanelLocation: TcxImageComboBox;
    dxLayoutGroup1: TdxLayoutGroup;
    lgCheckBoxes: TdxLayoutGroup;
    acDropDownColumnMRUList: TAction;
    acDropDownTableViewMRUList: TAction;
    cbDropDownColumnMRUList: TdxLayoutCheckBoxItem;
    cbDropDownTableViewMRUList: TdxLayoutCheckBoxItem;
    procedure cbFilterPanelLocationPropertiesChange(Sender: TObject);
    procedure acDropDownColumnMRUListExecute(Sender: TObject);
    procedure acDropDownTableViewMRUListExecute(Sender: TObject);
  private
    procedure AddFilterToMRUItems(AItemLink: TObject;
      AOperatorKind: TcxFilterOperatorKind; const AValue: Variant; const ADisplayValue: string);
    procedure AddComplexFilterToMRUItems;
  protected
    function GetDescription: string; override;
    function NeedSetup: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.dfm}

uses
  FrameIDs, dxFrames, uStrsConst, mainData;

constructor TfrmFitleringGrid.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  GridDBTableView.DataController.Filter.AddItem(nil, GridDBTableViewCOPIES, foGreater, 3, '3');
  GridDBTableView.DataController.Filter.Active := True;
  AddFilterToMRUItems(GridDBTableViewCOPIES, foGreater, 3, '3');
  AddFilterToMRUItems(GridDBTableViewCOPIES, foEqual, 3, '3');
  AddFilterToMRUItems(GridDBTableViewCOPIES, foNotEqual, 3, '3');
  AddFilterToMRUItems(GridDBTableViewCOPIES, foLess, 3, '3');
  AddComplexFilterToMRUItems;
end;

procedure TfrmFitleringGrid.AddFilterToMRUItems(AItemLink: TObject;
  AOperatorKind: TcxFilterOperatorKind; const AValue: Variant; const ADisplayValue: string);
var
  AFilter : TcxDataFilterCriteria;
begin
  AFilter := GridDBTableView.DataController.CreateFilter;
  try
    AFilter.AddItem(nil, AItemLink, AOperatorKind, AValue, ADisplayValue);
    GridDBTableView.Filtering.AddFilterToMRUItems(AFilter);
  finally
    AFilter.Free;
  end;
end;

procedure TfrmFitleringGrid.AddComplexFilterToMRUItems;
var
  AFilter : TcxDataFilterCriteria;
begin
  AFilter := GridDBTableView.DataController.CreateFilter;
  try
    AFilter.AddItem(nil, GridDBTableViewPAYMENTTYPE , foEqual, 2, dmMain.edrepDXPaymentTypeImageCombo.Properties.GetDisplayText(2));
    AFilter.AddItem(nil, GridDBTableViewPAYMENTAMOUNT, foGreater, 300, '300');
    GridDBTableView.Filtering.AddFilterToMRUItems(AFilter);
  finally
    AFilter.Free;
  end;
end;

function TfrmFitleringGrid.GetDescription: string;
begin
  Result := sdxFrameFilteringDescription;
end;

function TfrmFitleringGrid.NeedSetup: Boolean;
begin
  Result := True;
end;

procedure TfrmFitleringGrid.cbFilterPanelLocationPropertiesChange(
  Sender: TObject);
begin
  GridDBTableView.Filtering.Position := TcxGridFilterPosition(cbFilterPanelLocation.EditValue);
end;

procedure TfrmFitleringGrid.acDropDownColumnMRUListExecute(Sender: TObject);
begin
  GridDBTableView.Filtering.ColumnMRUItemsList := acDropDownColumnMRUList.Checked;
end;

procedure TfrmFitleringGrid.acDropDownTableViewMRUListExecute(Sender: TObject);
begin
  GridDBTableView.Filtering.MRUItemsList := acDropDownTableViewMRUList.Checked;
end;

initialization
  dxFrameManager.RegisterFrame(GridFilteringFrameID, TfrmFitleringGrid,
    GridDataFilteringFrameName, GridFilteringImageIndex, FilteringGroupIndex, -1, -1);


end.
