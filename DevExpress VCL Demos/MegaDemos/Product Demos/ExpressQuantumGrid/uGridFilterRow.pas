unit uGridFilterRow;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dxGridFrame, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxContainer, cxEdit, cxLabel, cxGrid,
  ExtCtrls, maindata, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxNavigator, DB, cxDBData, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGridCustomView, cxClasses, cxGridLevel,
  cxDBLookupComboBox, cxCurrencyEdit, StdCtrls, cxCheckBox, dxToggleSwitch,
  cxGroupBox, dxGDIPlusClasses, cxImage, Menus, dxLayoutControlAdapters, dxLayoutContainer, cxButtons, dxLayoutControl,
  dxLayoutcxEditAdapters, dxCustomDemoFrameUnit, ActnList, dxDateRanges, dxScrollbarAnnotations, System.Actions,
  dxLayoutLookAndFeels, dxPanel, cxGeometry,
  dxFramedControl;

type
  TfrmGridFilterRow = class(TdxGridFrame)
    TableView: TcxGridDBTableView;
    TableViewTrademark: TcxGridDBColumn;
    TableViewName: TcxGridDBColumn;
    TableViewModification: TcxGridDBColumn;
    TableViewPrice: TcxGridDBColumn;
    TableViewDoors: TcxGridDBColumn;
    TableViewBodyStyle: TcxGridDBColumn;
    TableViewCilinders: TcxGridDBColumn;
    TableViewHorsepower: TcxGridDBColumn;
    lgSetupThroughCheckBoxes: TdxLayoutGroup;
    acShowFilterRow: TAction;
    acAllowOperatorCustomization: TAction;
    cbAllowOperatorCustomization: TdxLayoutCheckBoxItem;
    cbShowFilterRow: TdxLayoutCheckBoxItem;
    procedure acShowFilterRowExecute(Sender: TObject);
    procedure acAllowOperatorCustomizationExecute(Sender: TObject);
  protected
    function GetDescription: string; override;
    function NeedSetup: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmGridFilterRow: TfrmGridFilterRow;

implementation

{$R *.dfm}

uses
  dxCore, dxFrames, FrameIDs, uStrsConst, cxGridDemoUtils;

{ TfrmGridFilterRow }

constructor TfrmGridFilterRow.Create(AOwner: TComponent);
var
  AFilterRow: TcxGridFilterRow;
begin
  inherited Create(AOwner);
  AFilterRow := TableView.ViewData.FilterRow;
  AFilterRow.Values[TableViewTrademark.Index] := 1;
  TableViewTrademark.Options.FilterRowOperator := foNotEqual;
  AFilterRow.Values[TableViewDoors.Index] := 2;
  TableViewDoors.Options.FilterRowOperator := foGreater;
  AFilterRow.Values[TableViewCilinders.Index] := 4;
  AFilterRow.Values[TableViewPrice.Index] := 30000;
  TableViewPrice.Options.FilterRowOperator := foLess;
  TableViewName.Options.FilterRowOperator := foContains;
  TableViewModification.Options.FilterRowOperator := foContains;
  TableViewHorsepower.Options.FilterRowOperator := foContains;
end;

function TfrmGridFilterRow.GetDescription: string;
begin
  Result := sdxFrameFilterRowDescription;
end;

function TfrmGridFilterRow.NeedSetup: Boolean;
begin
  Result := True;
end;

procedure TfrmGridFilterRow.acAllowOperatorCustomizationExecute(Sender: TObject);
begin
  TableView.FilterRow.OperatorCustomization := acAllowOperatorCustomization.Checked;
end;

procedure TfrmGridFilterRow.acShowFilterRowExecute(Sender: TObject);
begin
  TableView.FilterRow.Visible := acShowFilterRow.Checked;
end;

initialization
  dxFrameManager.RegisterFrame(GridFilterRowFrameID, TfrmGridFilterRow,
    GridFilterRowFrameName, GridFindPanelImageIndex, -1, FilteringGroupIndex, -1);

end.
