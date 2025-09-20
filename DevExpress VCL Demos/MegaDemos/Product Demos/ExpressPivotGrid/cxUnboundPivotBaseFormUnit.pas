unit cxUnboundPivotBaseFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxCustomPivotBaseFormUnit, cxClasses, cxGraphics, cxCustomData,
  cxStyles, cxEdit, cxControls, cxCustomPivotGrid, cxPivotGrid, cxLookAndFeels, cxLookAndFeelPainters,
  dxLayoutContainer, dxLayoutControl, dxLayoutLookAndFeels, ActnList, dxBarBuiltInMenu, System.Actions;

type
  TcxUnboundPivotGridDemoUnitForm = class(TcxCustomPivotGridDemoUnitForm)
    dxLayoutItem1: TdxLayoutItem;
    UnboundPivot: TcxPivotGrid;
  protected
    function GetPivotGrid: TcxCustomPivotGrid; override;
  public
    function HasOptions: Boolean; override;
  end;

var
  cxUnboundPivotGridDemoUnitForm: TcxUnboundPivotGridDemoUnitForm;

implementation

{$R *.dfm}

{ TcxUnboundPivotGridDemoUnitForm }

function TcxUnboundPivotGridDemoUnitForm.GetPivotGrid: TcxCustomPivotGrid;
begin
  Result := UnboundPivot;
end;

function TcxUnboundPivotGridDemoUnitForm.HasOptions: Boolean;
begin
  Result := True;
end;

end.
