unit cxPivotMultipleTotalFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxPivotSalesPersonFormUnit, cxCustomPivotGrid, cxDBPivotGrid,
  cxControls, cxGraphics, cxClasses, cxCustomData, cxStyles, cxLookAndFeels, cxLookAndFeelPainters, cxEdit,
  dxLayoutContainer, dxLayoutLookAndFeels, ActnList, dxLayoutControl, System.Actions, dxBarBuiltInMenu;

type
  TfrmMultipleTotals = class(TfrmSalesPerson)
  public
    class function GetID: Integer; override;
    function HasOptions: Boolean; override;
  end;

implementation

uses Math;

{$R *.dfm}

class function TfrmMultipleTotals.GetID: Integer;
begin
  Result := 4;
end;

function TfrmMultipleTotals.HasOptions: Boolean;
begin
  Result := False;
end;

initialization
  TfrmMultipleTotals.Register;

finalization

end.
