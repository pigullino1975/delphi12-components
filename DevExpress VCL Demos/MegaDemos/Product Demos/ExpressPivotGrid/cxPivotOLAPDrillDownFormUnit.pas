unit cxPivotOLAPDrillDownFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxPivotOLAPBrowserFormUnit, cxClasses, cxGraphics, cxCustomData,
  cxStyles, cxEdit, Menus, cxLookAndFeelPainters, cxCustomPivotGrid,
  cxPivotGridOLAPDataSource, StdCtrls, cxButtons, ExtCtrls, cxControls,
  cxPivotGrid, cxPivotDrillDownFormUnit, cxLookAndFeels, cxContainer, cxGroupBox, cxRadioGroup, dxLayoutContainer,
  dxLayoutControlAdapters, dxLayoutcxEditAdapters, cxTextEdit, cxMaskEdit, cxDropDownEdit, dxLayoutLookAndFeels,
  ActnList, dxLayoutControl, System.Actions, dxBarBuiltInMenu;

const
  WM_SHOWDRILLDOWN = WM_APP + 2;

type
  TfrmOLAPDrillDown = class(TfrmOLAPBrowser)
  private
    procedure WMShowDrillDown(var AMsg: TMessage); message WM_SHOWDRILLDOWN;
  public
    procedure ActivateDataSet; override;
    class function GetID: Integer; override;
  end;

implementation

uses cxCustomPivotBaseFormUnit;

{$R *.dfm}

{ TfrmOLAPDrillDown }

procedure TfrmOLAPDrillDown.ActivateDataSet;
begin
  inherited ActivateDataSet;
  PostMessage(Handle, WM_SHOWDRILLDOWN, 0, 0);
end;

class function TfrmOLAPDrillDown.GetID: Integer;
begin
  Result := 34;
end;

procedure TfrmOLAPDrillDown.WMShowDrillDown(var AMsg: TMessage);
var
  AViewData: TcxPivotGridViewData;
  ACell: TcxPivotGridCrossCellSummary;
  ACrossCell: TcxPivotGridCrossCell;
begin
  AViewData := PivotGrid.ViewData;
  if AViewData.ColumnCount * AViewData.RowCount > 0 then
  begin
    ACell := AViewData.Cells[0, 0];
    if ACell = nil then
      Exit;
    ACrossCell := ACell.Owner;
    if ACrossCell <> nil then
      cxShowDrillDownDataSource(ACrossCell);
  end;
end;

initialization
  TfrmOLAPDrillDown.Register;

end.
