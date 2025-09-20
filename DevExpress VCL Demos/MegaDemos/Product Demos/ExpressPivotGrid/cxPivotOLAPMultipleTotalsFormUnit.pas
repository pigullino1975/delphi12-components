unit cxPivotOLAPMultipleTotalsFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxPivotOLAPBrowserFormUnit, cxClasses, cxGraphics, cxCustomData,
  cxStyles, cxEdit, Menus, cxLookAndFeelPainters, cxCustomPivotGrid,
  cxPivotGridOLAPDataSource, StdCtrls, cxButtons, ExtCtrls, cxControls,
  cxPivotGrid, cxLookAndFeels, cxContainer, cxGroupBox, cxRadioGroup, dxLayoutContainer, dxLayoutControlAdapters,
  dxLayoutcxEditAdapters, cxTextEdit, cxMaskEdit, cxDropDownEdit, dxLayoutLookAndFeels, ActnList, dxLayoutControl,
  System.Actions, dxBarBuiltInMenu;

const
  WM_EXPANDFIELD = WM_APP + 1;

type
  TfrmOLAPMultipleTotals = class(TfrmOLAPBrowser)
  private
    procedure WMEXPANDFIELD(var AMsg: TMessage); message WM_EXPANDFIELD;
  public
    procedure ActivateDataSet; override;
    class function GetID: Integer; override;
  end;

implementation

{$R *.dfm}

procedure TfrmOLAPMultipleTotals.ActivateDataSet;
var
  AField: TcxPivotGridField;
begin
  inherited ActivateDataSet;
  AField := PivotGrid.GetFieldByName('Category Name');
  if AField = nil then Exit;
  PivotGrid.BeginUpdate;
  try
    PivotGrid.OptionsView.FilterFields := False;
    AField.TotalsVisibility := tvCustom;
    AField.CustomTotals.Add(stMin);
    AField.CustomTotals.Add(stMax);
    AField.CustomTotals.Add(stSum);
    AField.CustomTotals.Add(stCount);
    AField.CustomTotals.Add(stAverage);
  finally
    PivotGrid.EndUpdate;
  end;
  PostMessage(Handle, WM_EXPANDFIELD, Integer(AField), 0);
end;

class function TfrmOLAPMultipleTotals.GetID: Integer;
begin
  Result := 33;
end;

procedure TfrmOLAPMultipleTotals.WMEXPANDFIELD(var AMsg: TMessage);
begin
  TcxPivotGridField(AMsg.WParam).ExpandAll;
end;

initialization
  TfrmOLAPMultipleTotals.Register;

end.
