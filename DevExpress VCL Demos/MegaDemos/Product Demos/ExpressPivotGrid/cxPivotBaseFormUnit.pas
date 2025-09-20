unit cxPivotBaseFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxControls, cxCustomPivotGrid, cxDBPivotGrid, cxPivotDataModule,
  cxPivotDrillDownFormUnit, cxClasses, cxGraphics, cxCustomData, cxStyles,
  cxEdit, cxCustomPivotBaseFormUnit, cxLookAndFeels, cxLookAndFeelPainters, dxLayoutContainer, dxLayoutControl,
  dxLayoutLookAndFeels, ActnList, dxBarBuiltInMenu, System.Actions;

type
  TcxPivotGridDemoUnitForm = class(TcxCustomPivotGridDemoUnitForm)
    dxLayoutItem1: TdxLayoutItem;
    DBPivotGrid: TcxDBPivotGrid;
    procedure DBPivotGridDblClick(Sender: TObject);
  protected
    function GetPivotGrid: TcxCustomPivotGrid; override;
  public
    procedure ActivateDataSet; override;
  end;

implementation

{$R *.dfm}

uses
  Main, dxSplashUnit, DB;

procedure TcxPivotGridDemoUnitForm.ActivateDataSet;
var
  S: string;
  ADataSet: TDataSet;
begin
  inherited;
  ADataSet := DBPivotGrid.DataSource.DataSet;
  if ADataSet.Active then Exit;
  S := ADataSet.Name;
  Delete(S, 1, 2);
  if Pos('Reports', S) > 0 then
    Insert(' ', S, Pos('Reports', S));
  if Pos('Person', S) > 0 then
    Insert(' ', S, Pos('Person', S));
  dxSetSplashVisibility(Application.MainForm <> nil, S);
  try
    ADataSet.Active := True;
  finally
    dxSetSplashVisibility(False, S);
  end;
end;

function TcxPivotGridDemoUnitForm.GetPivotGrid: TcxCustomPivotGrid;
begin
  Result := DBPivotGrid;
end;

procedure TcxPivotGridDemoUnitForm.DBPivotGridDblClick(Sender: TObject);
var
  ACrossCell: TcxPivotGridCrossCell;
begin
  with PivotGrid.HitTest do
  begin
    if HitAtDataCell then
    begin
      ACrossCell := (HitObject as TcxPivotGridDataCellViewInfo).CrossCell;
      if ACrossCell <> nil then
        cxShowDrillDownDataSource(ACrossCell);
    end;
  end; 
end;

end.
