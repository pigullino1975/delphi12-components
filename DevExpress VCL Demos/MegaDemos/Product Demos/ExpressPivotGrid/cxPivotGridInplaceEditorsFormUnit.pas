unit cxPivotGridInplaceEditorsFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxPivotSalesPersonFormUnit, cxClasses, cxGraphics, cxCustomData,
  cxStyles, cxEdit, dxSkinsCore, dxSkinsDefaultPainters, cxCustomPivotGrid,
  cxDBPivotGrid, cxControls, cxProgressBar, cxLookAndFeels, cxLookAndFeelPainters, dxLayoutContainer,
  dxLayoutLookAndFeels, ActnList, dxLayoutControl, dxBarBuiltInMenu, System.Actions;

type
  TfrmInplaceEditors = class(TfrmSalesPerson)
    pgfPercentsOfColumn: TcxDBPivotGridField;
  public
    class function GetID: Integer; override;
    function HasOptions: Boolean; override;
  end;

implementation

{$R *.dfm}

{ TfrmInplaceEditors }

class function TfrmInplaceEditors.GetID: Integer;
begin
  Result := 26;
end;

function TfrmInplaceEditors.HasOptions: Boolean;
begin
  Result := False;
end;

initialization
  TfrmInplaceEditors.Register;

finalization

end.
