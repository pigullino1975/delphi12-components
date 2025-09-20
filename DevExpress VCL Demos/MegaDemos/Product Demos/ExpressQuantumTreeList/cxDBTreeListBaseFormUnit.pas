unit cxDBTreeListBaseFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxCustomTreeListBaseFormUnit, cxGraphics, cxCustomData, cxStyles,
  cxTL, cxTLdxBarBuiltInMenu, dxSkinsCore, 
  cxControls, cxInplaceContainer, cxTLData, cxDBTL, StdCtrls, ExtCtrls,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxGroupBox, cxLabel, cxLookAndFeels, dxLayoutContainer, cxClasses,
  dxLayoutControl, ActnList, dxLayoutLookAndFeels, dxScrollbarAnnotations, System.Actions,
  cxFilter;

type
  TcxDBTreeListDemoUnitForm = class(TcxCustomTreeListDemoUnitForm)
    dxLayoutItem1: TdxLayoutItem;
    tlDB: TcxDBTreeList;
  private
  protected
    function GetTreeList: TcxCustomTreeList; override;
    function GetDBTreeList: TcxDBTreeList;
  public
    procedure ActivateDataSet; override;
    property DBTreeList: TcxDBTreeList read GetDBTreeList;
  end;

implementation

{$R *.dfm}

{ TcxDBTreeListDemoUnitForm }

procedure TcxDBTreeListDemoUnitForm.ActivateDataSet;
begin
  DBTreeList.DataController.DataSet.Open;
end;

function TcxDBTreeListDemoUnitForm.GetTreeList: TcxCustomTreeList;
begin
  Result := tlDB;
end;

function TcxDBTreeListDemoUnitForm.GetDBTreeList: TcxDBTreeList;
begin
  Result := tlDB;
end;

end.
